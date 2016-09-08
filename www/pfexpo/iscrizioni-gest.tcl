ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    iscritto_id:integer
}
pf::user_must_admin
set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true limit 1"]
set page_title "Aggiunta corso"
set admin_menu [pf::admin_menu "pfexpo"]
set context [list [list /pfexpo/ "PFEXPO"] [list iscritti-list "Iscritti"] [list [export_vars -base "iscritti-gest" {iscritto_id}] "Dettaglio"] $page_title]
ad_form -name evento \
    -export {iscritto_id} \
    -form {
	{evento_id:integer(select)
	    {label "Corso"}
	    {options {[db_list_of_lists query "select e.denominazione, e.evento_id from expo_eventi e where e.expo_id = :expo_id order by e.start_time, e.sala_id"]}}
	}
    } -validate {
    } -on_submit {
	set iscrizione_id [db_string query "select coalesce(max(iscrizione_id)+1, 1) from expo_iscrizioni"]
	db_dml query "INSERT INTO expo_iscrizioni (iscrizione_id, evento_id, confermato, iscritto_id, data) VALUES (:iscrizione_id, :evento_id, true, :iscritto_id, current_date)"
    } -after_submit {
	ad_returnredirect [export_vars -base "iscritti-gest" {iscritto_id}]
	ad_script_abort
    }


