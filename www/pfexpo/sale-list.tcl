ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 29 May 2015
} {
    orderby:optional
    luogo_id:integer
}
set page_title "Sale - "
if {![info exists expo_id]} {
    if {[ad_get_cookie expo_id] != ""} {
        set expo_id [ad_get_cookie expo_id]
    } else {
        set expo_id [db_0or1row query "select * from expo_edizioni where attivo is true limit 1"]
    }
}
append page_title [db_string query "select l.denominazione from expo_luoghi l where :luogo_id = l.luogo_id"]
set context [list [list index "PFEXPO"] [list luoghi-list "Luoghi"] $page_title]
set actions "{Nuova sala} {sale-gest?luogo_id=$luogo_id} {Aggiunge una nuova sala}"
template::list::create \
    -name sale \
    -multirow sale \
    -actions $actions \
    -elements {	
	denominazione {
	    label "Denominazione"
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="http://images.professionefinanza.com/icons/edit.gif" height="12" border="0">}
	    link_html {title "Modifica sala."}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella sala." onClick "return(confirm('Sei davvero sicuro di voler cancellare la sala?'));"}
	    sub_class narrow
	}
}
db_multirow \
    -extend {
	edit_url
	delete_url
    } sale query "select s.sala_id, s.denominazione from expo_sale s where s.luogo_id = :luogo_id order by sala_id" {
	set edit_url [export_vars -base "sale-gest" {luogo_id sala_id}]
	set delete_url [export_vars -base "sale-canc" {luogo_id sala_id}]
    }
