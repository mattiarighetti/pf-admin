ad_page_contract {
    @author Mattia Righetti (mattia.righetti@mail.polimi.it)
    @creation-date Tuesday 28 October, 2014
} {
    {rows_per_page 30}
    {offset 0}
    {q ""}
    {utente_id 0}
    orderby:optional
}
pf::user_must_admin
set page_title "Utenti"
set context [list [list /pfawards "PFAwards"] [list index "Demo"] $page_title]
set actions ""
source [ah::package_root -package_key ah-util]/paging-buttons.tcl
template::list::create \
    -name utenti \
    -multirow utenti \
    -key utente_id \
    -actions $actions \
    -elements {
	numero {
	    label "Numero"
	}
	utente {
	    label "Nome e Cognome"
	}
	email {
	    label "Email"
	}
        edit {
            link_url_col edit_url
            display_template {<img src="http://images.professionefinanza.com/icons/edit.gif" width="20px" height="20px" border="0">}
            link_html {title "Modifica scheda utente." width="20px"}
            sub_class narrow
        }
   	delete {
	    link_url_col delete_url 
	    display_template {<img src="http://images.professionefinanza.com/icons/delete.gif" width="20px" height="20px" border="0">}
	    link_html {title "Cancella scheda utente." onClick "return(confirm('Vuoi davvero cancellare la scheda?'));" width="20px"}
	    sub_class narrow
	}
    } \
    -filters {
	q {
	    hide_p 1
	    values {$q $q}
	    where_clause {UPPER (u.utente_id||p.nome||p.cognome) LIKE UPPER ('%$q%')}
	}
	rows_per_page {
	    label "Righe"
	    values {{Quindici 15} {Trenta 30} {Cinquanta 50}}
	    where_clause {1 = 1}
	    default_value 50
	}
    } \
    -orderby {
	default_value numero
	numero {
	    label "Numero"
	    orderby u.utente_id
	}
    }
db_multirow \
    -extend {
	edit_url
	delete_url 
    } utenti query "SELECT '#'||u.utente_id AS numero, p.nome||' '||p.cognome AS utente, pa.email
                      FROM itfaw_utenti u, crm_persone p, parties pa
                     WHERE u.persona_id = p.persona_id AND pa.party_id = p.user_id [template::list::filter_where_clauses -name utenti -and]
                           [template::list::orderby_clause -name utenti -orderby]
                     LIMIT $rows_per_page
                    OFFSET $offset" {
			set edit_url [export_vars -base "utenti-gest" {iscritto_id}]
			set delete_url [export_vars -base "utenti-canc" {iscritto_id}]
		    }
