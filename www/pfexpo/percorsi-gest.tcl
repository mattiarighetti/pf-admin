ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 29 May 2015
} {
    percorso_id:integer,optional
}
if {[ad_form_new_p -key percorso_id]} {
    set page_title "Nuovo percorso"
    set buttons [list [list "Aggiungi" new]]
} else {
    set page_title "Modifica percorso"
    set buttons [list [list "Modifica" edit]]
}
set context [list [list index "PFEXPO"] [list percorsi-list "Percorsi"] $page_title]
ad_form -name percorso \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	percorso_id:key
	{descrizione:text
	    {label "Descrizione"}
	    {html {size 70 maxlength 100}}
	}
	{hex_color:text
	    {label "Colore"}
	    {html {size 70 maxlength 7}}
	    {help_text "Da esprimere in esadecimale."}
	}
    } -select_query {
	"select descrizione, hex_color from expo_percorsi where percorso_id = :percorso_id"
    } -new_data {
	set percorso_id [db_string query "select coalesce(max(percorso_id)+1,1) FROM expo_percorsi"]	    
	db_dml query "insert into expo_percorsi (percorso_id, descrizione,hex_color) VALUES (:percorso_id, :descrizione, :hex_color)"    
    } -edit_data {
	db_dml query "update expo_percorsi set descrizione = :descrizione, hex_color = :hex_color where percorso_id = :percorso_id"
    } -after_submit {
	ad_returnredirect "percorsi-list"
	ad_script_abort
    }
