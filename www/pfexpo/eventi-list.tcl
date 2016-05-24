ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    expo_id:integer,optional
    orderby:optional
}
pf::user_must_admin
template::head::add_css -href ../dashboard.css
set admin_menu [pf::admin_menu "pfexpo"]
set page_title "Eventi"
set context [list [list /pfexpo "PFEXPO"] $page_title]
if {![info exist expo_id]} {
    set expo_id [ad_get_cookie expo_id]
} else {
    set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
}
set actions [list "Nuovo evento" eventi-gest "Aggiunge un nuovo evento."]
template::list::create \
    -name eventi \
    -multirow eventi \
    -actions $actions \
    -elements {	
	denominazione {
	    label "Denominazione"
	    link_url_col edit_url
	}
	docenti {
	    label "Docenti"
	    display_template {<img src="http://images.professionefinanza.com/icons/view.gif" height="12" border="0">}
	    link_url_col docenti_url
	    sub_class narrow
	}
	speaker {
	    label "Speaker"
	    display_template {<img src="http://images.professionefinanza.com/icons/view.gif" height="12" border="0">}
	    link_url_col speaker_url
	    sub_class narrow
	}
	iscritti {
	    label "Iscritti"
	    link_url_col subscribed_url
	}
	slides {
	    label "Slides"
	    link_url_col slides_url
	    display_template {<img src="http://images.professionefinanza.com/icons/tipo_ico.jpeg" height="20" width="20" border="0">}
            link_html {title "Carica le slides dell'evento."}
            sub_class narrow
	}
	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella l'evento." onClick "return(confirm('Sei davvero sicuro di voler cancellare l'evento?'));"}
	    sub_class narrow
	}
    } \
    -orderby {
	default_value evento_id
	evento_id {
	    label "ID"
	    orderby evento_id
	}
    }
db_multirow \
    -extend {
	edit_url
	docenti_url
	speaker_url
	subscribed_url
	slides_url
	delete_url
    } eventi query "select e.evento_id, e.denominazione, count(i.iscritto_id) as iscritti from expo_eventi e left outer join expo_iscrizioni i on e.evento_id = i.evento_id where expo_id = :expo_id [template::list::filter_where_clauses -name eventi -and] group by e.evento_id, e.denominazione [template::list::orderby_clause -name eventi -orderby]" {
	set edit_url [export_vars -base "eventi-gest" {evento_id}]
	set docenti_url [export_vars -base "eventi-docenti-list" {evento_id}]
	set speaker_url [export_vars -base "eventi-speakers-list" {evento_id}]
	set subscribed_url [export_vars -base "iscritti-list" {evento_id}]
	set slides_url [export_vars -base "eventi-slides" {evento_id}]
	set delete_url [export_vars -base "eventi-canc" {evento_id}]
    }
