class PadrinoWeb < Padrino::Application
  register Padrino::Helpers
  register ExceptionNotifier
  set :exceptions_subject, "PadrinoWeb"
  set :exceptions_from,    "Padrino WebSite <exceptions@padrinorb.com>"
  set :exceptions_to,      Account.all.map(&:email)
  set :exceptions_page,    "base/errors"
end # PadrinoWeb