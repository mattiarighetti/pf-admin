ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 29 May 2015
} {
    orderby:optional
}
set page_title "Percorsi"
set context [list [list index "PFEXPO"] $page_title]
set actions "{Nuova percorso} {percorsi-gest} {Aggiunge una nuovo percorso}"
template::list::create \
    -name percorsi \
    -multirow percorsi \
    -actions $actions \
    -elements {	
	denominazione {
	    label "Denominazione"
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="http://images.professionefinanza.com/icons/edit.gif" height="12" border="0">}
	    link_html {title "Modifica percorso."}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella percorso." onClick "return(confirm('Sei davvero sicuro di voler cancellare il percorso?'));"}
	    sub_class narrow
	}
    }
db_multirow \
    -extend {
	edit_url
	delete_url
    } percorsi query "select percorso_id, descrizione as denominazione from expo_percorsi order by percorso_id" {
	set edit_url [export_vars -base "percorsi-gest" {percorso_id}]
	set delete_url [export_vars -base "percorsi-canc" {percorso_id}]
    }
