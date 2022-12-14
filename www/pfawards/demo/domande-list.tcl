ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday, 9 December 2015
} {
    {rows_per_page 50}
    {offset 0}
    {q ""}
    orderby:optional
    categoria_id:optional
}
pf::user_must_admin
set page_title "Domande"
set context [list [list ../index "PFAwards"] [list index "Demo"] $page_title]
set actions "{Nuova} {domande-gest} {Crea una nuova domanda}"
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
template::list::create \
    -name domande \
    -multirow domande \
    -actions $actions \
    -no_data "Nessun quesito trovato." \
    -row_pretty_plural "domande" \
    -elements {
	domanda_id {
	    label "Codice quesito"
	}
	categoria {
	    label "Categoria"
	}
	domanda {
	    label "Domanda"
	}
	edit {
	    link_url_col edit_url
	    display_template "<img src=\"http://images.professionefinanza.com/icons/edit.gif\" height=\"12px\" border=\"0\">"
	    link_html {title "Apri dettaglio"}
	    sub_class narrow
	}
	risposte {
	    link_url_col risposte_url
	    display_template "Risposte"
	    link_html {title "Vedi le risposte"}
	    sub_class narrow
	}
	delete {
	    link_url_col delete_url
	    display_template "<img src=\"http://images.professionefinanza.com/icons/delete.gif\" height=\"12px\" border=\"0\">"
	    link_html {title "Elimina"}
	    sub_class narrow
	}
    } \
    -filters {
	q {
	    hide_p 1
	    values {$q $q}
            where_clause {d.corpo ILIKE '%$q%'}
        }
	categoria_id {
	    label "Categoria"
	    values {[db_list_of_lists query "select descrizione, categoria_id from categoriaevento"]}
	    where_clause {d.categoria_id = :categoria_id}
	}
	rows_per_page {
	    label "Righe"
	    values {{Cinquanta 50} {Cento 100} {Duecentocinquanta 250}}
	    where_clause {1 = 1}
	    default_value 50
	}
    } -orderby {
	categoria {
	    label "Categoria"
	    orderby c.categoria_id 
	}
    }
db_multirow \
    -extend {
	edit_url
	risposte_url
	delete_url
    } domande query "SELECT d.corpo as domanda, d.domanda_id, c.descrizione as categoria from itfaw_domande d, categoriaevento c where c.categoria_id = d.categoria_id [template::list::filter_where_clauses -name domande -and] [template::list::orderby_clause -name domande -orderby] LIMIT $rows_per_page OFFSET $offset" {
	set edit_url [export_vars -base "domande-gest" {domanda_id}]
	set risposte_url [export_vars -base "risposte-list" {domanda_id}]
	set delete_url [export_vars -base "domande-canc" {domanda_id}]
    }
