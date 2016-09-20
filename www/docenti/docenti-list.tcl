ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    {rows_per_page 25}
    {offset 0}
    {q ""}
    orderby:optional
}
pf::user_must_admin
set page_title "Docenti"
set context [list [list index "Docenti"] $page_title]
set actions "{Nuovo docente} {docenti-gest} {Aggiunge un nuovo docente.}"
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
template::list::create \
    -name docenti \
    -multirow docenti \
    -actions $actions \
    -elements {
	nome {
	    label "Nome"
	}
	cognome {
	    label "Cognome"
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="http://images.professionefinanza.com/icons/edit.gif" height="12" border="0">}
	    link_html {title "Modifica partner."}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella partner." onClick "return(confirm('Sei davvero sicuro di voler cancellare il partner? Ci&ograve; non comporterà la cancellazione dell'account.'));"}
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
	    values {{Venticinque 25} {Cinquanta 50} {Cento 100}}
	    where_clause {1 = 1}
	    default_value 25
	}
    } \
    -orderby {
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
	edit_url
	delete_url
    } docenti query "select docente_id, nome, cognome from docenti where [template::list::filter_where_clauses -name docenti] [template::list::orderby_clause -name docenti -orderby] limit $rows_per_page offset $offset" {
	set edit_url [export_vars -base "docenti-gest" {docente_id}]
	set delete_url [export_vars -base "docenti-canc" {docente_id}]
    }
