ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    evento_id:integer
}
pf::user_must_admin
template::head::add_css -href ../dashboard.css
template::head::add_css -href http://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.min.css
template::head::add_javascript -src http://code.jquery.com/jquery-1.9.1.min.js
template::head::add_css -href "http://images.professionefinanza.com/js/summernote/summernote.css" 
template::head::add_javascript -src "http://images.professionefinanza.com/js/summernote/summernote.js"
set page_title "Inserimento docente evento"
set admin_menu [pf::admin_menu "pfexpo"]
set context [list [list /pfexpo/ "PFEXPO"] [list eventi-list "Eventi"] $page_title]
set buttons [list [list "Aggiungi" new]]
ad_form -name evento \
    -edit_buttons $buttons \
    -has_edit 1 \
    -export {evento_id} \
    -form {
	{docente_id:integer(select)
	    {label "Docente"}
	    {options {[db_list_of_lists query "select cognome||' '||nome, docente_id from docenti order by cognome"]}}
	}
    } -validate {
	{docente_id
	    {![db_0or1row query "select * from expo_eve_doc where evento_id = :evento_id and docente_id = :docente_id"]}
	    "Docente già collegato all'evento!"
	}
    } -on_submit {
	db_dml query "INSERT INTO expo_eve_doc (evento_id, docente_id) VALUES (:evento_id, :docente_id)"
    } -after_submit {
	ad_returnredirect "eventi-docenti-list?evento_id=$evento_id"
	ad_script_abort
    }


