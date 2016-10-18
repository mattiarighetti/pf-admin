ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    docente_id:integer,optional
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
}
pf::user_must_admin
if {[ad_form_new_p -key docente_id]} {
    set page_title "Nuovo docente"
    set img_html ""
    set buttons [list [list "Nuovo" new]]
} else {
    set page_title "Modifica docente"
    set buttons [list [list "Modifica" edit]]
    if {[db_0or1row query "select immagine from docenti where docente_id = :docente_id and immagine is not null"]} {
	set img_html "<img width=\"250px\" height=\"auto\" src=\"http://images.professionefinanza.com/docenti/"
	append img_html [db_string query "select immagine from docenti where docente_id = :docente_id"] "\" />"
    } else {
	set img_html ""
    }
}
set context [list [list docenti-list "Docenti"] $page_title]
set mime_types [parameter::get -parameter AcceptablePortraitMIMETypes -default ""]
set max_bytes [parameter::get -parameter MaxPortraitBytes -default ""]
ad_form -name docente \
    -edit_buttons $buttons \
    -has_edit 1 \
    -html {enctype "multipart/form-data"} \
    -form {
	docente_id:key
	{nome:text
	    {label "Nome"}
	    {html {size 70 maxlength 50}}
	}
	{cognome:text
	    {label "Cognome"}
	    {html {size 70 maxlength 50}}
	}
	{short_cv:text(textarea),optional
	    {label "Short CV"}
	    {html {cols 70 rows 10}}
	}
	{comitato_awards:text(radio),optional
	    {label "Comitato PFAwards"}
	    {options {{"Sì" 1} {"No" 0}}}
	}
	{patrimonia_forum:text(radio),optional
	    {label "Comitato PatrimoniaForum"}
	    {options {{"Sì" 1} {"No" 0}}}
	}
	{upload_file:text(file),optional
	    {help_text "Dev'essere quadrata e scontornata. Se lasci vuoto apparirà l'icona no-user."}
	    {label "Immagine"}
	}
    } -select_query {
	"select nome, cognome, short_cv, immagine, case when comitato_awards is true then 1 else 0 end as comitato_awards, case when patrimonia_forum is true then 1 else 0 end as patrimonia_forum from docenti where docente_id = :docente_id"
    } -validate {
    } -new_data {
	set docente_id [db_string query "select coalesce(max(docente_id) + trunc(random()*99), trunc(random()*99)) from docenti"]
	if {$upload_file ne ""} {
	    db_transaction {
		set docente_id [db_string query "SELECT COALESCE(MAX(docente_id)+1,1) FROM docenti"]
		regsub -all {\\} $upload_file "<" upload_file
		if {[string match *.jpg $upload_file] || [string match *.JPG $upload_file] || [string match *.jpeg $upload_file] || [string match *.JPEG $upload_file]} {
		    set file_name [string map {- _} $cognome]
		    append file_name [string map {- _} $nome]
		    append file_name ".jpg"		}
		if {[string match *.png $upload_file] || [string match *.PNG $upload_file]} {
		    set file_name [string map {- _} $cognome]
		    append file_name [string map {- _} $nome]
		    append file_name ".png"
		}
		ns_rename $filepath /usr/share/openacs/packages/images/www/docenti/$file_name
		db_dml query "INSERT INTO docenti (docente_id, nome, cognome, short_cv, immagine, comitato_awards, patrimonia_forum) VALUES (:docente_id, :nome, :cognome, :short_cv, :filename, :comitato_awards, :patrimonia_forum)"
	    }
	} else {
	    	db_dml query "INSERT INTO docenti (docente_id, nome, cognome, short_cv, comitato_awards, patrimonia_forum) VALUES (:docente_id, :nome, :cognome, :short_cv, :comitato_awards, :patrimonia_forum)"
	}
    } -edit_data {
    	if {$upload_file eq ""} {
	    db_dml query "UPDATE docenti SET nome = :nome, cognome = :cognome, short_cv = :short_cv, comitato_awards = :comitato_awards, patrimonia_forum = :patrimonia_forum WHERE docente_id = :docente_id"
	} else {
	    db_transaction {
		regsub -all {\\} $upload_file "<" upload_file
		if {[string match *.jpg $upload_file] || [string match *.JPG $upload_file] || [string match *.jpeg $upload_file] || [string match *.JPEG $upload_file]} {
		    set file_name [string map {- _} $cognome]
		    append file_name [string map {- _} $nome]
		    append file_name ".jpg"		}
		if {[string match *.png $upload_file] || [string match *.PNG $upload_file]} {
		    set file_name [string map {- _} $cognome]
		    append file_name [string map {- _} $nome]
		    append file_name ".png"
		}
		ns_rename $filepath /usr/share/openacs/packages/images/www/docenti/$file_name
		db_dml query "UPDATE docenti SET nome = :nome, cognome = :cognome, short_cv = :short_cv, comitato_awards = :comitato_awards, patrimonia_forum = :patrimonia_forum, immagine = :file_name WHERE docente_id = :docente_id"
	    }
	}
    } -on_submit {
	set filepath [ns_queryget upload_file.tmpfile]
    } -after_submit {
	ad_returnredirect "docenti-list"
	ad_script_abort
    }
