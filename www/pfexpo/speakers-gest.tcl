ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    speaker_id:integer,optional
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
}
if {[ad_form_new_p -key speaker_id]} {
    set page_title "Nuovo speaker"
    set buttons [list [list "Aggiungi" new]]
    set portrait_html ""
} else {
    set page_title "Modifica speaker"
    set buttons [list [list "Modifica" edit]]
    set portrait_html [db_string query "select immagine from expo_speakers where speaker_id = :speaker_id"]
}
set context [list [list /pfexpo "PFEXPO"] [list speakers-list "Speakers"] $page_title]
ad_form -name relatore \
    -edit_buttons $buttons \
    -method post \
    -has_edit 1 \
    -html {enctype "multipart/form-data"} \
    -form {
	speaker_id:key
	{nome:text
	    {label "Nome"}
	    {html {size 70 maxlength 100}}
	}
	{cognome:text
	    {label "Cognome"}
	    {html {size 70 maxlength 100}}
	}
	{short_cv:text(textarea),optional
	    {html {cols 70 rows 10 wrap soft}}
	    {label "Short CV"}
	    
	}
	{partner_id:integer(select),optional
	    {label "Partner"}
	    {options {"" [db_list_of_lists query "select denominazione, partner_id from expo_partners order by denominazione"]}}
	}
	{upload_file:text(file),optional
	    {help_text "Dev'essere quadrata e scontornata. Se lasci vuoto apparirà l'icona no-user."}
	    {label "Immagine"}
	}
    } -select_query {
	"SELECT speaker_id, short_cv, 'http://images.professionefinanza.com/pfexpo/speakers_portraits/'||immagine AS upload_file, nome, cognome, partner_id FROM expo_speakers WHERE speaker_id = :speaker_id"
    } -new_data {
	if {$upload_file ne ""} {
	    db_transaction {
		set speaker_id [db_string query "SELECT COALESCE(MAX(speaker_id)+1,1) FROM expo_speakers"]	    
		regsub -all {\\} $upload_file "<" upload_file
		if {[string match *.jpg $upload_file] || [string match *.JPG $upload_file] || [string match *.jpeg $upload_file] || [string match *.JPEG $upload_file]} {
		    set file_name $cognome
		    append filename "_" $nome ".jpg"		}
		if {[string match *.png $upload_file] || [string match *.PNG $upload_file]} {
		    set file_name $cognome
		    append file_name "_" $nome ".png"
		}
		ns_rename $filepath /usr/share/openacs/packages/images/www/pfexpo/speakers_portraits/$file_name
		db_dml query "INSERT INTO expo_speakers (speaker_id, nome, cognome, short_cv, immagine, partner_id) VALUES (:speaker_id, :nome, :cognome, :short_cv, :file_name, :partner_id)"
	    }
	} else {
	    db_dml query "INSERT INTO expo_speakers (speaker_id, nome, cognome, short_cv, partner_id, immagine) VALUES (:speaker_id, :nome, :cognome, :short_cv, :partner_id, 'no-user.jpg')"
	}
    } -edit_data {
    	if {$upload_file eq ""} {
	    db_dml query "UPDATE expo_speakers SET short_cv = :short_cv, nome = :nome, cognome = :cognome, partner_id = :partner_id WHERE speaker_id = :speaker_id"
	} else {
	    db_transaction {
		regsub -all {\\} $upload_file "<" upload_file
		if {[string match *.jpg $upload_file] || [string match *.JPG $upload_file] || [string match *.jpeg $upload_file] || [string match *.JPEG $upload_file]} {
		    set file_name $cognome
		    append file_name "_" $nome ".jpg"
		}
		if {[string match *.png $upload_file] || [string match *.PNG $upload_file]} {
		    set file_name $cognome
		    append file_name "_" $nome ".png"
		}
		ns_rename $filepath /usr/share/openacs/packages/images/www/pfexpo/speakers_portraits/$file_name
		db_dml query "UPDATE expo_speakers SET short_cv = :short_cv, nome = :nome, cognome = :cognome, partner_id = :partner_id, immagine = :file_name WHERE speaker_id = :speaker_id"
	    }
	}
    } -on_submit {
	set filepath [ns_queryget upload_file.tmpfile]
    } -after_submit {
	ad_returnredirect "speakers-list"
	ad_script_abort
    }
