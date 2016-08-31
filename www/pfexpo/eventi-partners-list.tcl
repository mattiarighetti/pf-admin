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
set actions [list "Aggiungi partner" eventi-partners-gest?evento_id=$evento_id "Aggiunge un nuovo partner."]
template::list::create \
    -name speaker \
    -multirow speaker \
    -actions $actions \
    -elements {
	speaker {
	    label "Partner"
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella il partner dall'evento." onClick "return(confirm('Sei davvero sicuro di voler cancellare lassociaizone?'));"}
	    sub_class narrow
	}
    } 
db_multirow \
    -extend {
	delete_url
    } speaker query "select s.partner_id, s.denominazione as speaker from expo_partners s, expo_eve_par e where e.partner_id = s.partner_id and e.evento_id = :evento_id" {
	set delete_url [export_vars -base "eventi-partners-canc" {evento_id partner_id}]
    }
