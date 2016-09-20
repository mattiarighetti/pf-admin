ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    orderby:optional
}
pf::user_must_admin
if {[ad_get_cookie expo_id] ne ""} {
    set expo_id [ad_get_cookie expo_id]
} else {
    ad_return_complaint 1 "Nessuna edizione del PFEXPO selezionata per questa funzione. <a href=\"/pfexpo\">Torna indietro per selezionarne una.</a>"
}   
set page_title "Partners PFEXPO "
append page_title [db_string query "select to_char(data, 'YYYY') from expo_edizioni where expo_id = :expo_id"] " - " [db_string query "select c.denominazione from comuni c, expo_luoghi l, expo_edizioni e where e.expo_id = :expo_id and e.luogo_id = l.luogo_id and c.comune_id = l.comune_id"]
set context [list [list / "PFEXPO"] $page_title]
set actions "{Attiva partner} {[export_vars -base edizioni-partners-gest {expo_id}]} {Aggiunge un partner esistente al PFEXPO}"
template::list::create \
    -name partners \
    -multirow partners \
    -actions $actions \
    -elements {	
	denominazione {
	    label "Denominazione"
	}
	edit {
	    link_url_col edit_url
	    display_template {<img src="http://images.professionefinanza.com/icons/edit.gif" height="12" border="0">} 
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella partner." onClick "return(confirm('Sei davvero sicuro di voler cancellare il partner? Ci&ograve; non comporterà la cancellazione dell'account.'));"}
	    sub_class narrow
	}
    } 
db_multirow \
    -extend {
	edit_url
	delete_url
    } partners query "select p.partner_id, p.denominazione from expo_partners p, expo_edizioni_partners e where e.expo_id = :expo_id and p.partner_id = e.partner_id [template::list::filter_where_clauses -name partners -and] [template::list::orderby_clause -name partners -orderby]" {
	set edit_url [export_vars -base "partners-gest" {partner_id}]
	set delete_url [export_vars -base "edizioni-partners-canc" {partner_id expo_id}]
    }
