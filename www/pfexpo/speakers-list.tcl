ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    orderby:optional
}
pf::user_must_admin
set page_title "Speakers"
set context [list [list /pfexpo "PFEXPO"] $page_title]
template::head::add_css -href ../dashboard.css
set admin_menu [pf::admin_menu "pfexpo"]
set actions "{Nuovo speaker} {spakers-gest} {Aggiunge un nuovo speaker}"
template::list::create \
    -name relatori \
    -multirow relatori \
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
	    link_html {title "Modifica relatore."}
	    sub_class narrow
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella relatore." onClick "return(confirm('Sei davvero sicuro di voler cancellare il relatore?'));"}
	    sub_class narrow
	}
    } \
    -orderby {
	default_value cognome
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
    } relatori query "SELECT speaker_id, nome, cognome from expo_speakers [template::list::filter_where_clauses -name relatori] [template::list::orderby_clause -name relatori -orderby]" {
	set edit_url [export_vars -base "speakers-gest" {speaker_id}]
	set delete_url [export_vars -base "speakers-canc" {speaker_id}]
    }
