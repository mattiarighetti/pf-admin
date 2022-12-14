ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 12 November, 2014
} {
    persona_id:integer
}
set page_title "Password Reset"
set context [list [list / {Iscritti}] "$page_title"]
ad_form -name "password" \
    -export "persona_id" \
    -form {
	{password:text
            {label "Password"}
            {html {size 50}}
        }
        {email:boolean(checkbox)
            {label "Email memo"}
            {options {{"Sì" 1}}}
        }
    } -on_submit {
	set user_id [db_string query "select user_id from crm_persone where persona_id = :persona_id"]
	ad_change_password $user_id $password
	if {$email == 1} {
	    set body "Gentile utente,\n\nLa tua password per accedere ai portali di ProfessioneFinanza è stata cambiata con: "
	    append body $password "\n\n Lo staff."
	    acs_mail_lite::send -send_immediately -from_addr "webmaster@professionefinanza.com" -to_addr [db_string query "select email from parties where party_id = :user_id"] -subject "Cambio password - ProfessioneFinanza" -body $body -mime_type "text/plain"
	}
	ad_returnredirect [export_vars -base iscritti-gest {persona_id}] 
	ad_script_abort
    }
