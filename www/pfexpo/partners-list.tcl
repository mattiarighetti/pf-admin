ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    orderby:optional
}
pf::user_must_admin
set page_title "Partners"
set context [list [list index "PFEXPO"] $page_title]
set actions "{Nuovo partner} {partners-gest} {Aggiunge un nuovo partner al DB.} {Attiva partner} {edizioni-partners} {Aggiunge un partner esistente al PFEXPO}"
template::list::create \
    -name partners \
    -multirow partners \
    -actions $actions \
    -elements {	
	denominazione {
	    label "Denominazione"
	}
	user_id {
	    label "ID utente"
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
	    link_html {title "Cancella partner." onClick "return(confirm('Sei davvero sicuro di voler cancellare il partner? Ci&ograve; non comporter√† la cancellazione dell'account.'));"}
	    sub_class narrow
	}
    } 
db_multirow \
    -extend {
	edit_url
	delete_url
    } partners query "select partner_id, denominazione, user_id from expo_partners [template::list::filter_where_clauses -name partners] [template::list::orderby_clause -name partners -orderby]" {
	set edit_url [export_vars -base "partners-gest" {partner_id}]
	set delete_url [export_vars -base "partners-canc" {partner_id}]
    }
