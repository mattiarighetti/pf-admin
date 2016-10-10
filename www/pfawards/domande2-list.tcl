ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday, 9 December 2015
} {
    {rows_per_page 50}
    {offset 0}
    {q ""}
    {award_id [pf::awards::id]}
    orderby:optional
    categoria_id:optional
}
pf::user_must_admin
set page_title "Quesiti seconda fase"
set context [list [list index "PFAwards"]  $page_title]
set actions "{Nuova} {domande2-gest} {Crea una nuova domanda}"
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
            where_clause {d.testo ILIKE '%$q%'}
        }
	categoria_id {
	    label "Categoria"
	    values {[db_list_of_lists query "select titolo, categoria_id from awards_categorie"]}
	    where_clause {d.categoria_id = :categoria_id}
	}
	award_id {
	    label "Edizione"
	    values {[db_list_of_lists query "select anno, award_id from awards_edizioni order by anno"]}
	    where_clause {award_id = :award_id}
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
	    orderby d.categoria_id 
	}
    }
db_multirow \
    -extend {
	edit_url
	delete_url
    } domande query "SELECT substring(d.testo from 0 for 150)||'...' as domanda, d.domanda_id, c.titolo as categoria from awards_domande_2 d, awards_categorie c where c.categoria_id = d.categoria_id [template::list::filter_where_clauses -name domande -and] AND award_id = :award_id [template::list::orderby_clause -name domande -orderby] LIMIT $rows_per_page OFFSET $offset" {
	set edit_url [export_vars -base "domande2-gest" {domanda_id}]
	set delete_url [export_vars -base "domande2-canc" {domanda_id}]
    }
