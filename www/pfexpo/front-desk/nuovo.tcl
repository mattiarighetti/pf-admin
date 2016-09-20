ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 21 April 2015
} {
    iscritto_id:integer,optional
}
if {[ad_form_new_p -key iscritto_id]} {
    set page_title "Nuovo"
    set buttons [list [list "Iscrivi" new]]
} else {
    set page_title "Modifica"
    set buttons [list [list "Modifica categoria" edit]]
}
ad_form -name iscrizione \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	iscritto_id:key
	{nome:text
	    {label "Nome"}
	    {html {size 70 maxlength 50}}
	}
	{cognome:text
            {label "Cognome"}
            {html {size 70 maxlength 50}}
        }
	{email:text
            {label "Email"}
            {html {size 70 maxlength 50}}
        }
	{societa:text,optional
            {label "Societa"}
            {html {size 70 maxlength 50}}
        }
	{telefono:text,optional
            {label "Telefono"}
            {html {size 70 maxlength 50}}
        }
	{provincia:text
            {label "Provincia"}
            {html {size 70 maxlength 50}}
        }
	{voucher:boolean(checkbox),optional
	    {label "Area VIP"}
	    {options {{"" "t"}}}
	}
    } -new_data {
      	set iscritto_id [db_string query "SELECT COALESCE(MAX(iscritto_id)+1,1) FROM expo_iscritti"]
	set barcode "803000"
	if {[string length $iscritto_id] == 4} {
	    append barcode 00
	}
	if {[string length $iscritto_id] == 5} {
	    append barcode 0
	}
	append barcode $iscritto_id
	db_dml query "INSERT INTO expo_iscritti (iscritto_id, nome, cognome, email, societa, telefono, provincia, data, barcode, pagato, expo_id) VALUES (:iscritto_id, :nome, :cognome, :email, :societa, :telefono, :provincia, current_date, :barcode, :voucher, 5)"
    } -after_submit {
	set return_url "index?q=[string tolower $cognome]"
	ad_returnredirect -message "Iscrizione correttamente effettuata (ID: $iscritto_id)." $return_url
	ad_script_abort
    }
