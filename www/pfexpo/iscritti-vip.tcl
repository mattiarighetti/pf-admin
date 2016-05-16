# 

ad_page_contract {
    
    
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-01-26
    @cvs-id $Id$
} {
    iscritto_id:integer
    return_url
} -properties {
} -validate {
} -errors {
}

if {[db_0or1row query "select * from expo_iscritti where iscritto_id = :iscritto_id and pagato is true"]} {
    db_dml query "update expo_iscritti set pagato = false where iscritto_id = :iscritto_id"
} else {
    db_dml query "update expo_iscritti set pagato = true where iscritto_id = :iscritto_id"
}


ad_returnredirect -allow_complete_url $return_url
ad_script_abort
