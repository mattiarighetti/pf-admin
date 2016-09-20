# 

ad_page_contract {
    
    
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-09-20
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}

set award_id [pf::awards::id]
if {[db_0or1row query "select * from awards_edizioni where award_id = :award_id and demo is true"]} {
    db_dml query "update awards_edizioni set demo = false where award_id = :award_id"
} else {
    db_dml query "update awards_edizioni set demo = true where award_id = :award_id"
}
ad_returnredirect index
ad_script_abort
