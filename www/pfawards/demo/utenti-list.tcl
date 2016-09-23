ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday, 9 December 2015
} {
    {rows_per_page 50}
    {offset 0}
    {q ""}
    orderby:optional
}
pf::user_must_admin
set page_title "Iscritti"
set context [list [list /pfawards "PFAwards"] [list index "Demo"] $page_title]
set actions ""
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
template::list::create \
    -name iscritti \
    -multirow iscritti \
    -actions $actions \
    -no_data "Nessun iscritto corrisponde ai criteri di ricerca impostati." \
    -row_pretty_plural "iscritti" \
    -elements {
	nome {
	    label "Nome"
	}
	cognome {
	    label "Cognome"
	}
	email {
	    label "Email"
	}
	view {
	    link_url_col view_url
	    display_template "<img src=\"http://images.professionefinanza.com/icons/view.gif\" height=\"12px\" border=\"0\">"
	    link_html {title "Apri scheda"}
	    sub_class narrow
	}
	delete {
	    link_url_col delete_url
	    display_template "<img src=\"http://images.professionefinanza.com/icons/delete.gif\" height=\"12px\" border=\"0\">"
	    link_html {title "Elimina utente demo"}
	    sub_class narrow
	}
    } \
    -filters {
	q {
	    hide_p 1
	    values {$q $q}
            where_clause {nome||cognome ILIKE '%$q%'}
        }
	rows_per_page {
	    label "Righe"
	    values {{Cinquanta 50} {Cento 100} {Duecentocinquanta 250}}
	    where_clause {1 = 1}
	    default_value 50
	}
    } -orderby {
	nome {
	    label "Nome"
	    orderby nome
	}
	cognome {
	    label "Cognome"
	    orderby cognome
	}
    }
db_multirow \
    -extend {
	view_url
	delete_url
    } iscritti query "SELECT utente_id, INITCAP(LOWER(nome)) AS nome, INITCAP(LOWER(cognome)) AS cognome, email FROM itfaw_utenti WHERE [template::list::filter_where_clauses -name iscritti] [template::list::orderby_clause -name iscritti -orderby] LIMIT $rows_per_page OFFSET $offset" {
	set view_url [export_vars -base "utenti-gest" {utente_id}]
	set delete_url [export_vars -base "utenti-canc" {utente_id}]
    }
