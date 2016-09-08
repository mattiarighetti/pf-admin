ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 29 May 2015
} {
    orderby:optional
}
set page_title "Luoghi"
set context [list [list index "PFEXPO"] $page_title]
if {![info exists expo_id]} {
    if {[ad_get_cookie expo_id] != ""} {
        set expo_id [ad_get_cookie expo_id]
    } else {
        set expo_id [db_0or1row query "select * from expo_edizioni where attivo is true limit 1"]
    }
}
set actions "{Nuovo} {luoghi-gest} {Aggiunge un nuovo luogo}"
template::list::create \
    -name luoghi \
    -multirow luoghi \
    -actions $actions \
    -elements {	
	denominazione {
	    label "Denominazione"
	}
	sale {
	    label "Sale"
	    link_url_col sale_url
	    display_template {<img src="http://images.professionefinanza.com/icons/view.gif" height="12" border="0">}
	    link_html {title "Vai al dettaglio sale"}
	    sub_class narrow
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="http://images.professionefinanza.com/icons/edit.gif" height="12" border="0">}
	    link_html {title "Modifica luogo"}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella luogo" onClick "return(confirm('Sei davvero sicuro di voler cancellare questo luogo?'));"}
	    sub_class narrow
	}
}
db_multirow \
    -extend {
	sale_url
	edit_url
	delete_url
    } luoghi query "select luogo_id, denominazione from expo_luoghi" {
	set sale_url [export_vars -base "sale-list" {luogo_id}]
	set edit_url [export_vars -base "luoghi-gest" {luogo_id}]
	set delete_url [export_vars -base "luoghi-canc" {luogo_id}]
    }
