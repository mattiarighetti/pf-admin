ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 November, 2014
} {
    iscritto_id:integer
    {return_url ""}
}
set page_title "Dettaglio"
set context [list [list index "PFEXPO"] [list iscritti-list "Iscritti"] "$page_title"]
set form_name "iscritto"
ad_form -name $form_name \
    -mode display \
    -export "return_url" \
    -has_edit 0 \
    -has_submit 0 \
    -cancel_url [export_vars -base "iscritto-canc" {iscritto_id return_url}] \
    -cancel_label "Cancella iscritto" \
    -show_required_p 0 \
    -form {
        iscritto_id:key
        {nome:text
            {label "Nome"}
            {html {size 50}}
        }
        {cognome:text
            {label "Cognome"}
            {html {size 50}}
        }
	{email:text
	    {label "Email"}
	    {html {size 50}}
	}
	{societa:text,optional
	    {label "Società"}
	    {html {size 50}}
	}
	{data:date(date)
	    {label "Data iscrizione"}
	}
    } -select_query {
	"SELECT INITCAP(LOWER(nome)) AS nome, INITCAP(LOWER(cognome)) AS cognome, LOWER(email) AS email, INITCAP(LOWER(societa)) AS societa, data FROM expo_iscritti WHERE iscritto_id = :iscritto_id"
    } -edit_data {
	db_dml query "UPDATE expo_iscritti SET nome = INITCAP(LOWER(:nome)), cognome = INITCAP(LOWER(:cognome)), email = LOWER(:email), societa = INITCAP(LOWER(:societa)) WHERE iscritto_id = :iscritto_id"
    }
set list_name "iscrizioni"
template::list::create \
    -name $list_name \
    -multirow $list_name \
    -actions [list "Aggiungi evento" [export_vars -base iscrizioni-gest {iscritto_id}] "Aggiungi evento all'iscritto"] \
    -key iscrizione_id \
    -caption "Situazione iscritto" \
    -elements {
	iscrizione_id {
	    label "ID"
	}
	denominazione {
	    label "Evento"
	}
	pagato {
            link_html {title "Clicca per cambiare stato pagamento."}
            link_url_col paid_url
            sub_class narrow
        }
	delete {
	    link_html {title "Cancella iscrizione"}
	    link_url_col delete_url
	    sub_class narrow
	    display_template "<img src=\"http://images.professionefinanza.com/icons/delete.gif\" height=\"12px\" border=\"0\""
	}
    }
db_multirow \
    -extend {
	paid_url
	delete_url
    } $list_name query "SELECT i.iscrizione_id, e.denominazione, CASE WHEN i.pagato = true THEN 'Pagato' WHEN i.pagato = false THEN 'Non pagato' WHEN i.pagato IS NULL THEN '' END AS pagato FROM expo_eventi e, expo_iscrizioni i WHERE i.iscritto_id = :iscritto_id AND e.evento_id = i.evento_id " {
	set return_url [ad_return_url]
	set delete_url [export_vars -base "iscrizioni-canc" {iscrizione_id return_url}] 
    }
