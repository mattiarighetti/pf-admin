ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 29 May 2015
} {
    expo_id:integer
    sala_id:integer,optional
}
if {[ad_form_new_p -key docente_id]} {
    set page_title "Nuova sala"
    set buttons [list [list "Aggiungi" new]]
} else {
    set page_title "Modifica sala"
    set buttons [list [list "Modifica" edit]]
}
set context ""
ad_form -name sala \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	sala_id:key
	{denominazione:text
	    {label "Denominazione"}
	    {html {size 70 maxlength 100}}
	}
    } -select_query {
	"select sala_id, denominazione from expo_sale where sala_id = :sala_id"
    } -new_data {
	db_transaction {
	    set sala_id [db_string query "select coalesce(max(sala_id)+1,1) FROM expo_sale"]	    
	    set luogo_id [db_string query "select l.luogo_id from expo_luoghi l, expo_edizioni e where l.luogo_id = e.luogo_id and e.expo_id = :expo_id"]
	    db_dml query "insert into expo_sale (sala_id, denominazione, luogo_id) VALUES (:sala_id, :denominazione, :luogo_id)"    
	}
    } -edit_data {
	    db_dml query "update expo_sale set sala_id = :sala_id, denominazione = :denominazione where professionista_id = :professionista_id"
    } -after_submit {
	ad_returnredirect "index?module=pfexpo&expo_id=:expo_id&template=modules%2Fpfexpo%2Fsale-list"
	ad_script_abort
    }
