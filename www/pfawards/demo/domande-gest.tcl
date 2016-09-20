ad_page_contract {
    @author Mattia Righetti (mattia.righetti@mail.polimi.it)
    @creation-date Monday 3 November, 2014
} {
    domanda_id:integer,optional
}
pf::user_must_admin
if {[ad_form_new_p -key domanda_id]} {
    set page_title "Nuova domanda"
    set buttons [list [list "Salva" new]]
} else {
    set page_title "Modifica quesito #" 
    append page_title "$domanda_id"
    set buttons [list [list "Aggiorna" edit]]
}
set context [list [list ../index "PFAwards"] [list index "Demo"] [list domande-list "Domande"] $page_title]
ad_form -name domanda \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	domanda_id:key
	{categoria_id:integer(select)
	    {label "Categoria"}
	    {options {[db_list_of_lists query "select descrizione, categoria_id from categoriaevento"]}}
	}
	{corpo:text(textarea),nospell
	    {label "Corpo"}
	    {html {rows 6 cols 50 wrap soft}}
	}
    } -select_query {
	"SELECT d.corpo, d.categoria_id FROM itfaw_domande d WHERE d.domanda_id = :domanda_id"
    } -new_data {
	set domanda_id [db_string query "SELECT COALESCE (MAX(domanda_id) + 1, 1) FROM itfaw_domande"]
	db_dml query "INSERT INTO itfaw_domande (domanda_id, corpo, categoria_id) VALUES (:domanda_id, :corpo, :categoria_id)"
	set return_url [export_vars -base "risposte-list" {domanda_id}]
    } -edit_data {
	db_dml query "UPDATE itfaw_domande SET corpo = :corpo, categoria_id = :categoria_id WHERE domanda_id = :domanda_id"
	set return_url "domande-list"
    } -after_submit {
	ad_returnredirect $return_url
	ad_script_abort
    }
