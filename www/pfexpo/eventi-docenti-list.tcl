ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    evento_id:naturalnum
}
pf::user_must_admin
template::head::add_css -href ../dashboard.css
set admin_menu [pf::admin_menu "pfexpo"]
set page_title "Eventi"
set context [list [list /pfexpo "PFEXPO"] $page_title]
set evento_html [db_string query "select denominazione from expo_eventi where evento_id = :evento_id"]
set actions [list "Aggiungi docenter" eventi-docenti-gest?evento_id=$evento_id "Aggiunge un nuovo docente all'evento."]
template::list::create \
    -name docenti \
    -multirow docenti \
    -actions $actions \
    -elements {
	docente {
	    label "Docente"
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella il docente." onClick "return(confirm('Sei davvero sicuro di voler cancellare il docente dall&quot;evento?'));"}
	    sub_class narrow
	}
    } 
db_multirow \
    -extend {
	delete_url
    } docenti query "select d.docente_id, d.nome||' '||d.cognome as docente from docenti d, expo_eve_doc e where e.evento_id = :evento_id and d.docente_id = e.docente_id order by d.cognome asc" {
	set delete_url [export_vars -base "eventi-docenti-canc" {evento_id docente_id}]
    }
