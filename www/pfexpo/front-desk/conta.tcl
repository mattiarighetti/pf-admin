# 

ad_page_contract {
    
    
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-01-26
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}

db_dml query "update expo_edizioni set conta = conta +1 where expo_id = 3"
ad_return_exception_page 200 ok ok
