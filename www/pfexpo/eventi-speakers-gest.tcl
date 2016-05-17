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
set page_title "Inserimento speaker evento"
set admin_menu [pf::admin_menu "pfexpo"]
set context [list [list /pfexpo/ "PFEXPO"] [list eventi-list "Eventi"] $page_title]
set buttons [list [list "Aggiungi" new]]
ad_form -name evento \
    -edit_buttons $buttons \
    -has_edit 1 \
    -export {evento_id} \
    -form {
	{speaker_id:integer(select)
	    {label "Speaker"}
	    {options {[db_list_of_lists query "select cognome||' '||nome, speaker_id from expo_speakers order by cognome"]}}
	}
	{tipo_id:integer(select)
	    {label "Modalità di partecipazione"}
	    {options {[db_list_of_lists query "select descrizione, tipo_id from expo_speakers_tipo order by item_order"]}}
	}
    } -validate {
	{speaker_id
	    {![db_0or1row query "select * from expo_eventi_speakers where evento_id = :evento_id and speaker_id = :speaker_id"]}
	    "Speaker già collegato all'evento!"
	}
    } -on_submit {
	db_dml query "INSERT INTO expo_eventi_speakers (evento_id, speaker_id, tipo_id) VALUES (:evento_id, :speaker_id, :tipo_id)"
    } -after_submit {
	ad_returnredirect "eventi-speakers-list?evento_id=$evento_id"
	ad_script_abort
    }


