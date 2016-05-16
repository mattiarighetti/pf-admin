ad_page_contract {
    Programma per l'aggiunta di un partner all'edizione dell'expo attiva.
    
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 7 November, 2014
}
set user_id [ad_conn user_id]
if {![info exist expo_id]} {
    set expo_id [ad_get_cookie expo_id]
}
set edizione [db_string query "select 'PFEXPO - '||c.denominazione||' '||to_char(e.data, 'YYYY') from expo_edizioni e, expo_luoghi l, comuni c where c.comune_id = l.comune_id and e.luogo_id = l.luogo_id and expo_id = :expo_id"]
ad_form -name partner \
    -mode edit \
    -has_edit 1 \
    -form {
	{edizione:text,optional
	    {label "Edizione"}
	    {mode display}
	    {value $edizione}
	}
	{partner_id:integer(select)
	    {label "Partner"}
	    {options {[db_list_of_lists query "select denominazione, partner_id from expo_partners order by denominazione"]}}
	    {after_html "<a href=\"partners-gest\">Aggiungi nuovo</a>"}
	}
    } -on_submit {
	db_dml query "insert into expo_edizioni_partners (expo_id, partner_id) values (:expo_id, :partner_id)"
    } -after_submit {
	ad_returnredirect "edizioni-partners-list"
	ad_script_abort
    }
