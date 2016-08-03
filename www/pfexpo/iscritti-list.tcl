ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday, 9 December 2015
} {
    {rows_per_page 25}
    {offset 0}
    {q ""}
    orderby:optional
    evento_id:integer,optional
}
pf::user_must_admin
set page_title "Gestione PFEXPO - Iscritti"
set context [list $page_title]
set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
set actions "{Nuovo} {iscritti-gest} {Crea un nuovo iscritto} {Esporta} {[export_vars -base iscritti-excel {expo_id}]} {Esporta un file Excel con gli iscritti al PFEXPO selezionato}"
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
template::list::create \
    -name "iscritti" \
    -multirow "iscritti" \
    -key iscritto_id \
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
	societa {
	    label "Società"
	}
	data {
	    label "Data iscrizione"
	}
	eventi {
	    label "Eventi"
	}
	pagato {
	    label "Vip pass"
	    link_url_col vip_url
	}
	view {
	    link_url_col view_url
	    display_template "<img src=\"http://images.professionefinanza.com/icons/view.gif\" height=\"12px\" border=\"0\">"
	    link_html {title "Apri scheda"}
	    sub_class narrow
	}
	delete {
	    link_url_col delete_url
	    display_template "<img src=\"http://images.professionefinanza.com/icons/delete.gif\" height=\"12px\" border=\"0\""
            link_html {title "Cancellazione rapida" onClick "return(confirm('Attenzione: azione non reversibile.\nSei sicuro di voler cancellare questo profilo?"}
            sub_class narrow
	}
    } \
    -filters {
	q {
            hide_p 1
            values {$q $q}
            where_clause {UPPER(p.nome||p.cognome||p.email||p.societa) LIKE UPPER('%$q%')}
        }
	rows_per_page {
	    label "Righe"
	    values {{Venticinque 25} {Cinquanta 50} {Cento 100}}
	    where_clause {1 = 1}
	    default_value 25
	}
	evento_id {
	    label "Eventi"
	    values {[db_list_of_lists query "select denominazione from expo_eventi where expo_id = :expo_id order by denominazione"]}
	    where_clause {i.evento_id = :evento_id}
	    
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
	data {
	    label "Data"
	    orderby p.data
	}
    }
db_multirow \
    -extend {
	vip_url
	view_url
	delete_url
    } iscritti query "SELECT p.iscritto_id, INITCAP(LOWER(p.nome)) AS nome, INITCAP(LOWER(p.cognome)) AS cognome, p.email, p.societa, COUNT(i.evento_id) as eventi, case when p.pagato is true then 'Pagato' else 'No' end as pagato, p.data FROM expo_iscritti p LEFT OUTER JOIN expo_iscrizioni i ON p.iscritto_id = i.iscritto_id WHERE p.expo_id = :expo_id [template::list::filter_where_clauses -name iscritti -and] group by p.iscritto_id, p.nome, p.cognome, p.email, p.societa, p.pagato, p.data [template::list::orderby_clause -name iscritti -orderby] LIMIT $rows_per_page OFFSET $offset" {
	set return_url [ad_return_url -qualified urlencode]
	set vip_url [export_vars -base "iscritti-vip" {iscritto_id return_url}]
	set view_url [export_vars -base "iscritti-gest" {iscritto_id}]
	set delete_url [export_vars -base "iscritti-canc" {iscritto_id}]
    }
