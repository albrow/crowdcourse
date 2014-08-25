PgSearch.multisearch_options = {
  :using => {
  	:dmetaphone => {},
    :trigram => {},
    :tsearch => {:prefix => true, :dictionary => "english", :any_word => true}
  },
  :ignoring => :accents
}