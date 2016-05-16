ad_page_contract {
    Programma per la cancellazione di un partner dall'expo attivo (non la scheda dal db).
    
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Sunday 14 June 2015
    @cvs-id processing-delete.tcl
} {
    partner_id:integer
}
pf::user_must_admin
set user_id [ad_conn user_id]
if {![info exist expo_id]} {
    set expo_id [ad_get_cookie expo_id]
}
db_dml query "delete from expo_edizioni_partners where partner_id = :partner_id and expo_id = :expo_id"
ad_returnredirect [export_vars -base "edizioni-partners-list"]
ad_script_abort
