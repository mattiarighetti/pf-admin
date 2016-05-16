ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday, 9 December 2015
} {
    {rows_per_page 25}
    {offset 0}
    {q ""}
    orderby:optional
    expo_id:integer,optional
}
set page_title "Gestione PFEXPO - Iscritti"
set context [list $page_title]
#if {![info exists expo_id]} {
 #   set expo_id 3
#}
set actions ""
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
template::list::create \
    -name "iscritti" \
    -multirow "iscritti" \
    -actions $actions \
    -elements {
	iscritto_id {
	    label "ID"
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
	societa {
	    label "Società"
	}
	data {
	    label "Data iscrizione"
	}
	pagato {
	    label "Vip pass"
	}
	view {
	    link_url_col view_url
	    display_template "<img src=\"http://images.professionefinanza.com/icons/view.gif\" height=\"12px\" border=\"0\">"
	    link_html {title "Apri scheda"}
	    sub_class narrow
	}
    } \
    -filters {
	q {
            hide_p 1
            values {$q $q}
            where_clause {UPPER(i.nome||i.cognome||i.email||i.societa) LIKE UPPER('%$q%')}
        }
	expo_id {
	    label "Edizione"
	    type multivar
	    values {[db_list_of_lists query "select permalink, expo_id from expo_edizioni order by data desc"]}
	    where_clause {i.expo_id = :expo_id}
	    default_value {[db_string query "select expo_id from expo_edizioni order by data desc offset 1 limit 1"]}
	}
	rows_per_page {
	    label "Righe"
	    values {{Venticinque 25} {Cinquanta 50} {Cento 100}}
	    where_clause {1 = 1}
	    default_value 25
	}
    } -orderby {
	nome {
	    label "Nome"
	    orderby i.nome
	}
	cognome {
	    label "Cognome"
	    orderby i.cognome
	}
	data {
	    label "Data"
	    orderby i.data
	}
    }
db_multirow \
    -extend {
	view_url
    } iscritti query "SELECT i.iscritto_id, INITCAP(LOWER(i.nome)) AS nome, INITCAP(LOWER(i.cognome)) AS cognome, i.email, i.societa, case when i.pagato is true then 'Pagato' else 'No' end as pagato, i.data FROM expo_iscritti i, expo_presenze p WHERE i.iscritto_id = p.iscritto_id [template::list::filter_where_clauses -name iscritti -and] group by i.iscritto_id, i.nome, i.cognome, i.email, i.societa, i.pagato, i.data [template::list::orderby_clause -name iscritti -orderby] LIMIT $rows_per_page OFFSET $offset" {
	set return_url [ad_return_url -qualified urlencode]
	set view_url [export_vars -base "partecipati-eventi" {iscritto_id return_url}]
    }
set edizione [db_string query "select permalink from expo_edizioni where expo_id = :expo_id"]
