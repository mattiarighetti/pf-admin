ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Saturday 1 November, 2014
} {
    {rows_per_page 100}
    {offset 0}
    {q ""}
    categoria_id:integer,optional
    orderby:optional
}
pf::user_must_admin
set award_id [pf::awards::id]
set page_title "Esami"
set context [list [list "index" PFAwards] $page_title]
set actions {"Aggiungi" esami-gest "Aggiunge una nuova sessione." "Stampa lista" esami-stamp "Stampa gli esami."}
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
template::list::create \
    -name esami \
    -multirow esami \
    -actions $actions \
    -elements {
	esame_id {
	    label "Esame"
	}	
	nominativo {
	    label "Nominativo"
	}
	categoria {
	    label "Categoria"
	}
	stato {
	    label "Stato"
	}
	start_time {
	    label "Inizio"
	}
	end_time {
	    label "Fine"
	}
	punti {
	    label "Punti"
	}
	promuovi {
	    link_url_col promuovi_url
	    display_template {Promuovi}
	    link_html {title "Promuovi alla seconda fase"}
	    sub_class narrow
	}
	reset {
	    link_url_col reset_url
	    display_template {<img src="http://images.professionefinanza.com/icons/reset_timer.png" width="20px" height="20px" border="0">}
	    link_html {title "Resetta tempo." onClick "return(confirm('Cliccando su OK aggiungerai 30 minuti in più.'));"}
	    sub_class narrow
	}
	view {
	    link_url_col view_url
            display_template {PDF}
            link_html {title "Scarica PDF." target "_blank"}
            sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/icona-delete.ico" width="20px" height="20px" border="0">}
	    link_html {title "Annulla esame." onClick "return(confirm('Vuoi davvero annullare l'esame?'));"}
	    sub_class narrow
	}
    } \
    -filters {
	q {
            hide_p 1
            values {$q $q}
            where_clause {pp.last_name||' '||e.esame_id::text||' '||p.persona_id::text||' '||p.user_id ILIKE '%$q%'}
        }
	rows_per_page {
	    label "Righe"
	    values {{Cinquanta 50} {Cento 100} {Duecentocinquanta 250}}
	    where_clause {1 = 1}
	    default_value 100
	}
	categoria_id {
	    label "Categoria"
	    values {[db_list_of_lists query "select titolo, categoria_id from awards_categorie order by categoria_id"]}
	    where_clause {e.categoria_id = :categoria_id}
	}
    } \
    -orderby {
	default_value esame_id
	esame_id {
	    label "Esame"
	    orderby e.esame_id
	}
	nominativo {
	    label "Nominativo"
	    orderby pp.last_name
	}
	punti {
	    label "Punti"
	    orderby e.punti
	}
    }
db_multirow \
    -extend {
	edit_url
	view_url
	reset_url
	delete_url 
    } esami query "SELECT '#'||e.esame_id AS esame_id, c.titolo as categoria, TO_CHAR(e.start_time, 'DD/MM/YYYY HH24:MI') AS start_time, TO_CHAR(e.end_time, 'DD/MM/YYYY HH24:MI') as end_time, e.punti, e.attivato, INITCAP(LOWER(e.stato)) AS stato, e.pdf_doc, UPPER(pp.last_name)||' '||INITCAP(LOWER(pp.first_names))||' (#'||p.user_id||')' AS nominativo FROM awards_esami e, crm_persone p, persons pp, awards_categorie c WHERE e.award_id = :award_id AND e.persona_id = p.persona_id AND p.user_id = pp.person_id AND c.categoria_id = e.categoria_id [template::list::filter_where_clauses -name esami -and] [template::list::orderby_clause -name esami -orderby] LIMIT $rows_per_page OFFSET $offset" {
	set edit_url [export_vars -base "esami-gest" {esame_id}]
	set view_url $pdf_doc
	set reset_url [export_vars -base "esami-reset" {esame_id}]
	set delete_url [export_vars -base "esami-canc" {esame_id}]
    }
