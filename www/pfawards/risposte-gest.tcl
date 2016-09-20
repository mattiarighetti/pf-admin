ad_page_contract {
    @author Mattia Righetti (mattia.righetti@mail.polimi.it)
    @creation-date Monday 3 November, 2014
} {
    domanda_id:integer
    risposta_id:integer,optional
}
pf::user_must_admin
if {[ad_form_new_p -key risposta_id]} {
    set page_title "Nuova risposta"
    set buttons [list [list "Salva" new]]
} else {
    set page_title "Modifica risposta #" 
    append page_title "$risposta_id"
    set buttons [list [list "Aggiorna" edit]]
}
set context [list [list index "PFAwards"] [list domande-list "Domande"] [list [export_vars -base "risposte-list" {domanda_id}] "Risposte quesito #$domanda_id"] $page_title]
ad_form -name risposta \
    -edit_buttons $buttons \
    -export {domanda_id} \
    -has_edit 1 \
    -form {
	risposta_id:key
	{corpo:text(textarea),nospell
	    {label "Risposta"}
	    {html {rows 6 cols 50 wrap soft}}
	}
	{punti:text
	    {label "Punti"}
	}	     
    } -select_query {
	"SELECT testo, punti FROM awards_risposte WHERE risposta_id = :risposta_id"
    } -new_data {
	set risposta_id [db_string query "SELECT COALESCE (MAX(risposta_id) + 1, 1) FROM awards_risposte"]
	db_dml query "INSERT INTO awards_risposte (risposta_id, testo, domanda_id, punti) VALUES (:risposta_id, :corpo, :domanda_id, :punti)"
    } -edit_data {
	db_dml query "UPDATE awards_risposte SET testo = :corpo, punti = :punti WHERE risposta_id = :risposta_id"
    } -after_submit {
	ad_returnredirect [export_vars -base "risposte-list" {domanda_id}]
	ad_script_abort
    }
