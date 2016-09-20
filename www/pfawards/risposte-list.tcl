ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday, 9 December 2015
} {
    domanda_id
}
pf::user_must_admin
set page_title "Risposte quesito #"
append page_title $domanda_id
set context [list [list index "PFAwards"] [list domande-list "Domande"] $page_title]
set actions "{Nuova} {[export_vars -base risposte-gest {domanda_id}]} {Aggiungi risposte}"
template::list::create \
    -name risposte \
    -multirow risposte \
    -actions $actions \
    -elements {
	risposta_id {
	    label "ID risposta"
	}
	testo {
	    label "Testo"
	}
	punti {
	    label "Punti"
	}
	edit {
	    link_url_col edit_url
	    display_template "<img src=\"http://images.professionefinanza.com/icons/edit.gif\" height=\"12px\" border=\"0\">"
	    link_html {title "Apri dettaglio"}
	    sub_class narrow
	}
	delete {
	    link_url_col delete_url
	    display_template "<img src=\"http://images.professionefinanza.com/icons/delete.gif\" height=\"12px\" border=\"0\">"
	    link_html {title "Elimina"}
	    sub_class narrow
	}
    } 
db_multirow \
    -extend {
	edit_url
	delete_url
    } risposte query "SELECT testo, risposta_id, punti from awards_risposte where domanda_id = :domanda_id" {
	set edit_url [export_vars -base "risposte-gest" {risposta_id domanda_id}]
	set delete_url [export_vars -base "risposte-canc" {risposta_id}]
    }
