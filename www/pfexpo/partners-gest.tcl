ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    partner_id:integer,optional
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
}
pf::user_must_admin
if {[ad_form_new_p -key partner_id]} {
    set page_title "Nuovo partner"
    set buttons [list [list "Nuovo" new]]
} else {
    set page_title "Modifica partner"
    set buttons [list [list "Modifica" edit]]
}
set context [list [list index "PFEXPO"] [list partners-list "Partners"] $page_title]
set mime_types [parameter::get -parameter AcceptablePortraitMIMETypes -default ""]
set max_bytes [parameter::get -parameter MaxPortraitBytes -default ""]
ad_form -name partner \
    -edit_buttons $buttons \
    -has_edit 1 \
    -html {enctype "multipart/form-data"} \
    -form {
	partner_id:key
	{denominazione:text
	    {label "Denominazione"}
	    {html {size 70 maxlength 50}}
	}
	{descrizione:text(textarea),optional
	    {label "Descrizione"}
	    {html {cols 70 rows 10}}
	}
	{permalink:text
	    {label "Permalink"}
	    {html {size 70 maxlength 100}}
	}
	{categoria_id:integer(select)
	    {options {[db_list_of_lists query "select descrizione, categoria_id from expo_par_cat order by item_order"]}}
	    {label "Categoria"}
	    {after_html "<a href=\"partners-cat-gest\" target=\"_blank\">Aggiungi categoria</a>"}
	}
	{item_order:integer,optional
	    {label "Ordine"}
	}
	{visibile:text(checkbox),optional
	    {label "Visibile"}
	    {options {{"Sì" 1}}}
	}
	{upload_file:text(file),optional
	    {help_text "Dev'essere quadrato e scontornato. Se lasci vuoto apparirà l'icona no-user."}
	    {label "Logo"}
	}
    } -select_query {
	"select partner_id, denominazione, descrizione, item_order, categoria_id, permalink, visibile, immagine AS upload_file from expo_partners where partner_id = :partner_id"
    } -validate {
    } -new_data {
	if {$upload_file ne ""} {
	    db_transaction {
		set partner_id [db_string query "SELECT COALESCE(MAX(partner_id)+1,1) FROM expo_partners"]
		regsub -all {\\} $upload_file "<" upload_file
		if {[string match *.jpg $upload_file] || [string match *.JPG $upload_file] || [string match *.jpeg $upload_file] || [string match *.JPEG $upload_file]} {
		    set file_name [string map {- _} $permalink]
		    append filename ".jpg"		}
		if {[string match *.png $upload_file] || [string match *.PNG $upload_file]} {
		    set file_name [string map {- _} $permalink] 
		    append file_name ".png"
		}
		ns_rename $filepath /usr/share/openacs/packages/images/www/pfexpo/partners_portraits/$file_name
		db_dml query "INSERT INTO expo_partners (partner_id, denominazione, immagine, descrizione, item_order, categoria_id, permalink, visibile) VALUES (:partner_id, :denominazione, :file_name, :descrizione, :item_order, :categoria_id, :permalink, :visibile)"
	    }
	} else {
	    db_dml query "INSERT INTO expo_partners (partner_id, denominazione, immagine, descrizione, item_order, categoria_id, permalink, visibile) VALUES (:partner_id, :denominazione, :file_name, :descrizione, :item_order, :categoria_id, :permalink, :visibile)"
	}
    } -edit_data {
    	if {$upload_file eq ""} {
	    db_dml query "UPDATE expo_partners SET denominazione = :denominazione, descrizione = :descrizione, item_order = :item_order, categoria_id = :categoria_id, permalink = :permalink, visibile = :visibile WHERE partner_id = :partner_id"
	} else {
	    db_transaction {
		regsub -all {\\} $upload_file "<" upload_file
		if {[string match *.jpg $upload_file] || [string match *.JPG $upload_file] || [string match *.jpeg $upload_file] || [string match *.JPEG $upload_file]} {
		    set file_name [string map {- _} $permalink]
		    append filename ".jpg"		}
		if {[string match *.png $upload_file] || [string match *.PNG $upload_file]} {
		    set file_name [string map {- _} $permalink] 
		    append file_name ".png"
		}
		ns_rename $filepath /usr/share/openacs/packages/images/www/pfexpo/partners_portraits/$file_name
		db_dml query "UPDATE expo_partners SET denominazione = :denominazione, descrizione = :descrizione, item_order = :item_order, categoria_id = :categoria_id, permalink = :permalink, visibile = :visibile, immagine = :file_name WHERE partner_id = :partner_id"
	    }
	}
    } -on_submit {
	set filepath [ns_queryget upload_file.tmpfile]
    } -after_submit {
	ad_returnredirect "partners-list"
	ad_script_abort
    }
