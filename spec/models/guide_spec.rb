require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Guide Model" do

  before do
    Guide.collection.remove
  end

  it 'not create a guide without title' do
    guide = Guide.create
    guide.errors.size.should > 0
    Guide.count.should == 0
  end

  it 'not create a post without body' do
    guide = Post.create(:title => 'foo')
    guide.errors.size.should > 0
    Guide.count.should == 0
  end

  it 'be draft as default' do
    guide = Guide.create(:title => 'Foo', :summary => 'Bar')
    guide.draft.should be_true
  end

  context 'permalink' do
    it 'create a permalink' do
      guide = Guide.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :body => 'foo')
      guide.permalink.should == "lorem-ipsum-dolor-sit-amet-consectetur-adipisicing-elit"
    end

    it 'not create a permalink if title is not unique' do
      Guide.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :body => 'foo')
      guide = Guide.create(:title => '[Lorem] ipsum dolor sit amet, consectetur adipisicing-elit', :body => 'foo')
      guide.errors.size.should > 0
    end
  end

  context 'textile' do
    it 'create correctly the textile formatted for body' do
      guide = Guide.create(:title => 'Foo Bar', :body => 'h1. Lorem ipsum dolor sit amet, consectetur adipisicing elit')
      guide.body_formatted.should == '<h1>Lorem ipsum dolor sit amet, consectetur adipisicing elit</h1>'
    end

    it 'create correctly internal links' do
      linked = Guide.create(:title => 'Linked Page', :body => 'Im the linked page')
      linker = Guide.create(:title => 'Linker', :body => 'I should link to [[Linked Page]]')
      linker.body_formatted.should == '<p>I should link to <a href="/guides/linked-page">Linked Page</a></p>'
    end

    it 'not parse pre without lang' do
      guide = Guide.create(:title => 'Foo Bar', :body => '<pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>')
      guide.body_formatted.should == '<pre>Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>'
    end

    it 'parse correctly pre with lang' do
      guide = Guide.create(:title => 'Foo Bar', :body => '<pre lang="ruby">Lorem ipsum dolor sit amet, consectetur adipisicing elit</pre>')
      guide.body_formatted.should == "<div class=\"CodeRay\">\n  <div class=\"code\"><pre><span class=\"co\">Lorem</span> ipsum dolor sit amet, consectetur adipisicing elit</pre></div>\n</div>\n"
      guide = Guide.create(:title => 'Foo Baz', :body => 'pre[ruby]. Lorem ipsum dolor sit amet, consectetur adipisicing elit')
      guide.body_formatted.should == "<div class=\"CodeRay\">\n  <div class=\"code\"><pre><span class=\"co\">Lorem</span> ipsum dolor sit amet, consectetur adipisicing elit</pre></div>\n</div>\n"
    end

    it 'parse correctly chapters' do
      guide = Guide.create(:title => 'Foo Bar', :body => 'h2. Lorem ipsum dolor sit amet, consectetur adipisicing elit')
      guide.body_formatted.should == "<a name=\"lorem-ipsum-dolor-sit-amet-consectetur-adipisicing-elit\">&nbsp</a>\n<h2>Lorem ipsum dolor sit amet, consectetur adipisicing elit</h2>"
    end
  end
end