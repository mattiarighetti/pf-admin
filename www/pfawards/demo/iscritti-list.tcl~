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
set context [list [list index "PFAwards"] $page_title]
set award_id [db_string query "select award_id from awards_edizioni where attivo is true limit 1"]
set actions "{Nuovo} {iscritti-new} {Crea un nuovo iscritto} {Esporta} {[export_vars -base iscritti-excel {award_id}]} {Esporta un file Excel con gli iscritti ai PFAwards selezionati}"
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
template::list::create \
    -name iscritti \
    -multirow iscritti \
    -actions $actions \
    -no_data "Nessun iscritto corrisponde ai criteri di ricerca impostati." \
    -row_pretty_plural "iscritti" \
    -elements {
	persona_id {
	    label "Codice persona"
	}
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
	    link_html {title "Elimina iscrizioni ai PFAwards"}
	    sub_class narrow
	}
    } \
    -filters {
	q {
	    hide_p 1
	    values {$q $q}
            where_clause {p.nome||p.cognome ILIKE '%$q%'}
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
	    orderby p.nome
	}
	cognome {
	    label "Cognome"
	    orderby p.cognome
	}
    }
db_multirow \
    -extend {
	view_url
	delete_url
    } iscritti query "SELECT p.persona_id, INITCAP(LOWER(p.nome)) AS nome, INITCAP(LOWER(p.cognome)) AS cognome, pa.email FROM crm_persone p, awards_esami e, parties pa WHERE pa.party_id = p.user_id AND e.award_id = :award_id AND e.persona_id = p.persona_id [template::list::filter_where_clauses -name iscritti -and] GROUP BY p.persona_id, p.nome, p.cognome, pa.email [template::list::orderby_clause -name iscritti -orderby] LIMIT $rows_per_page OFFSET $offset" {
	set view_url [export_vars -base "iscritti-gest" {persona_id}]
	set delete_url [export_vars -base "iscritti-canc" {persona_id}]
    }
