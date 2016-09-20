ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 November, 2014
} {
    persona_id:integer
}
set page_title "Dettaglio"
set context [list [list index "PFAwards"] [list iscritti-list "Iscritti"] $page_title]
set user_id [db_string query "select user_id from crm_persone where persona_id = :persona_id"]
ad_form -name iscritto \
    -mode display \
    -export "return_url" \
    -has_edit 0 \
    -has_submit 0 \
    -cancel_url [export_vars -base "iscritto-canc" {persona_id}] \
    -cancel_label "Cancella tutte le iscrizioni" \
    -show_required_p 0 \
    -form {
        persona_id:key
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
    } -select_query {
	"SELECT INITCAP(LOWER(p.nome)) AS nome, INITCAP(LOWER(p.cognome)) AS cognome, LOWER(pa.email) AS email, INITCAP(LOWER(p.societa_man)) AS societa FROM crm_persone p, parties pa WHERE p.persona_id = :persona_id AND p.user_id = pa.party_id"
    } -edit_data {
	db_dml query "UPDATE crm_persone SET nome = INITCAP(LOWER(:nome)), cognome = INITCAP(LOWER(:cognome)), email = LOWER(:email), societa = INITCAP(LOWER(:societa)) WHERE persona_id = :persona_id"
    }
template::list::create \
    -name iscrizioni \
    -multirow iscrizioni \
    -actions "{Aggiungi esame} {[export_vars -base iscritti-esami-gest {persona_id}]} {Aggiungi esami all'utente}" \
    -key esame_id \
    -caption "Esami a cui è iscritto" \
    -elements {
	anno {
	    label "PFAwards"
	}
	esame_id {
	    label "ID Esame"
	}
	denominazione {
	    label "Categoria"
	}
	data_iscr {
	    label "Data iscrizione"
	}
	decorrenza {
	    label "Decorrenza"
	}
	scadenza {
	    label "Scadenza"
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
	delete_url
    } iscrizioni query "SELECT e.award_id, ed.anno, e.esame_id, c.titolo as denominazione, e.start_time, e.end_time, e.punti, to_char(e.scadenza, 'DD/MM/YYYY') AS scadenza, e.decorrenza, e.data_iscr FROM awards_esami e, awards_edizioni ed, awards_categorie c WHERE e.persona_id = :persona_id AND e.categoria_id = c.categoria_id AND e.award_id = ed.award_id ORDER BY e.award_id desc, e.categoria_id desc" {
	set delete_url [export_vars -base "iscritti-esami-canc" {esame_id persona_id}]
    }
