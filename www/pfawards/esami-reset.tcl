ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 November, 2014
} {
    esame_id:integer
    return_url
}
db_dml query "update awards_esami set start_time = null, end_time = null, punti = null, stato = null, pdf_doc = null where esame_id = :esame_id"
db_dml query "delete from awards_rispusr where esame_id = :esame_id"
ad_returnredirect $return_url
ad_script_abort
