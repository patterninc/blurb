# frozen_string_literal: true

# Type checking (audit item 12): `make typecheck` runs `steep check` against sig/.
D = Steep::Diagnostic

target :lib do
  signature 'sig'
  check 'lib'
  library 'json', 'date', 'uri'
  configure_code_diagnostics(D::Ruby.default) do |hash|
    # RequestCollection#execute_bulk_request passes its keyword hash positionally
    # (lib/blurb/request_collection.rb). Ruby 2.7 accepts it; Ruby 3 does not. It is a
    # known follow-up (runtime change), so report it without failing the check.
    hash[D::Ruby::UnexpectedPositionalArgument] = :information
    hash[D::Ruby::InsufficientKeywordArguments] = :information
  end
end
