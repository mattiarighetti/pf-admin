ad_page_contract {
    @author Mattia Righetti (mattia.righetti@mail.polimi.it)
    @creation-date Monday 3 November, 2014
} {
    domanda_id:integer,optional
}
pf::user_must_admin
set award_id [pf::awards::id]
if {[ad_form_new_p -key domanda_id]} {
    set page_title "Nuovo quesito per PFAwards "
    append page_title [db_string query "select anno from awards_edizioni where award_id = :award_id"]
    set buttons [list [list "Salva" new]]
} else {
    set page_title "Modifica quesito #" 
    append page_title "$domanda_id"
    set buttons [list [list "Aggiorna" edit]]
}
set context [list [list index "PFAwards"] [list domande-list "Quesiti seconda fase"] $page_title]
ad_form -name domanda \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	domanda_id:key
	{categoria_id:integer(select)
	    {label "Categoria"}
	    {options {[db_list_of_lists query "select titolo, categoria_id from awards_categorie"]}}
	}
	{testo:text(textarea),nospell
	    {label "Domanda"}
	    {html {rows 6 cols 50 wrap soft}}
	}
    } -select_query {
	"SELECT testo, categoria_id FROM awards_domande WHERE domanda_id = :domanda_id"
    } -new_data {
	set domanda_id [db_string query "SELECT COALESCE (MAX(domanda_id) + 1, 1) FROM awards_domande"]
	db_dml query "INSERT INTO awards_domande (domanda_id, testo, categoria_id, award_id) VALUES (:domanda_id, :testo, :categoria_id, :award_id)"
	set return_url [export_vars -base "risposte-list" {domanda_id}]
    } -edit_data {
	db_dml query "UPDATE awards_domande SET testo = :testo, categoria_id = :categoria_id WHERE domanda_id = :domanda_id"
	set return_url "domande-list"
    } -after_submit {
	ad_returnredirect $return_url
	ad_script_abort
    }
