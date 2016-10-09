ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 3 October 2016
} 
pf::user_must_admin
set page_title "Aggiungi"
if {[ad_form_new_p -key iscritto_id]} {
    set buttons [list [list "Salva" new]]
} else {
    set buttons [list [list "Aggiorna" edit]]
}
ad_form -name iscritto \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	{nome:text
	    {label "Nome"}
	}
	{cognome:text
            {label "Cognome"}
	}
	{email:text
	    {label "Email"}
	}
	{password:text
	    {label "Password"}
	}
	{conferma_pwd:text
	    {label "Conferma password"}
	}
	{societa:text
	    {label "Societa"}
	}
	{provincia:text
	    {label "Provincia"}
	}
    } -select_query { "SELECT nome,
                              cognome
	                 FROM pf_iscritti
 	                WHERE iscritto_id = :iscritto_id"
    } -new_data {
	set iscritto_id [db_string query "SELECT COALESCE (MAX(iscritto_id) + 1, 1) FROM pf_iscritti"]
	db_dml query "INSERT INTO pf_iscritti (iscritto_id, nome, cognome) VALUES (:iscritto_id, :nome, :cognome)"
    } -edit_data {
	db_dml query "UPDATE pf_iscritti SET nome = :nome, cognome = :cognome WHERE iscritto_id = :iscritto_id"
    } -on_submit {
	set ctr_errori 0
	if {$ctr_errori > 0} {
	    break
	}
    } -after_submit {
	ad_returnredirect "utenti-list"
	ad_script_abort
    }
