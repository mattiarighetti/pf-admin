ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 29 May 2015
} {
    luogo_id:integer
    sala_id:integer,optional
}
if {[ad_form_new_p -key sala_id]} {
    set page_title "Nuova sala"
    set buttons [list [list "Aggiungi" new]]
} else {
    set page_title "Modifica sala"
    set buttons [list [list "Modifica" edit]]
}
set luogo [db_string query "select denominazione from expo_luoghi where luogo_id = :luogo_id"]
set context [list [list index "PFEXPO"] [list luoghi-list "Luoghi"] [list [export_vars -base "sale-list" {luogo_id}] "Sale - $luogo"] $page_title]
ad_form -name sala \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	sala_id:key
	{denominazione:text
	    {label "Denominazione"}
	    {html {size 70 maxlength 100}}
	}
	{capienza:text
	    {label "Capienza"}
	    {html {size 70 maxlength 3}}
	}
    } -select_query {
	"select sala_id, denominazione, capienza from expo_sale where sala_id = :sala_id"
    } -new_data {
	set sala_id [db_string query "select coalesce(max(sala_id)+1,1) FROM expo_sale"]	    
	db_dml query "insert into expo_sale (sala_id, denominazione, capienza, luogo_id) VALUES (:sala_id, :denominazione, :capienza, :luogo_id)"    
    } -edit_data {
	db_dml query "update expo_sale set denominazione = :denominazione, capienza = :capienza where sala_id = :sala_id"
    } -after_submit {
	ad_returnredirect [export_vars -base "sale-list" {luogo_id}]
	ad_script_abort
    }
