ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    evento_id:naturalnum
}
pf::user_must_admin
set page_title "Speaker di "
append page_title [db_string query "select denominazione from expo_eventi where evento_id = :evento_id"]
set context [list [list index "PFEXPO"] [list eventi-list "Eventi"] $page_title]
set evento_html [db_string query "select denominazione from expo_eventi where evento_id = :evento_id"]
set actions [list "Aggiungi speaker" [export_vars -base "eventi-speakers-gest" {evento_id}] "Aggiunge un nuovo speaker."]
template::list::create \
    -name speaker \
    -multirow speaker \
    -actions $actions \
    -elements {
	speaker {
	    label "Speaker"
	}
	tipo {
	    label "Modalità di partecipazione"
	}
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" height="12" border="0">}
	    link_html {title "Cancella l'evento." onClick "return(confirm('Sei davvero sicuro di voler cancellare l'evento?'));"}
	    sub_class narrow
	}
    } 
db_multirow \
    -e\xtend {
	delete_url
    } speaker query "select s.speaker_id, s.nome||' '||s.cognome as speaker, t.descrizione as tipo from expo_speakers s, expo_speakers_tipo t, expo_eventi_speakers e where e.speaker_id = s.speaker_id and e.evento_id = :evento_id and e.tipo_id = t.tipo_id" {
	set delete_url [export_vars -base "eventi-speakers-canc" {evento_id speaker_id}]
    }
