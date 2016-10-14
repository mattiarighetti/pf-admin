ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 November, 2014
} {
    bonus_id:integer
}
set esame_id [db_string query "select esame_id from awards_bonus where bonus_id = :bonus_id"]
db_dml query "delete from awards_bonus where bonus_id = :bonus_id"
ad_returnredirect [export_vars -base "esami-gest" {esame_id}]
ad_script_abort
