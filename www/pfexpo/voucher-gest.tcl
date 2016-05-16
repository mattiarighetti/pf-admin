ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    expo_id:integer,optional
    voucher_id:integer,optional
}
pf::user_must_admin
template::head::add_css -href ../dashboard.css
template::head::add_css -href http://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.min.css
template::head::add_javascript -src http://code.jquery.com/jquery-1.9.1.min.js
template::head::add_css -href "http://images.professionefinanza.com/js/summernote/summernote.css" 
template::head::add_javascript -src "http://images.professionefinanza.com/js/summernote/summernote.js"
set admin_menu [pf::admin_menu "pfexpo"]
set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
if {[ad_form_new_p -key voucher_id]} {
    set page_title "Nuovo"
    set context [list [list /pfexpo/ "PFEXPO"] [list voucher-list "Voucher"] $page_title]
    set buttons [list [list "Crea voucher" new]]
} else {
    set page_title "Modifica"
    set context [list [list /pfexpo/ "PFEXPO"] [list voucher-list "Voucher"] $page_title]
    set buttons [list [list "Modifica voucher" edit]]
}
ad_form -name voucher \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	voucher_id:key
	{evento_id:integer(select),optional
	    {label "Evento"}
	    {options {"Tutti" [db_list_of_lists query "select denominazione, evento_id from expo_eventi where expo_id = :expo_id order by denominazione"]}}
	    {help_text "Su che eventi avrà effetto il voucher?"}
	}
	{codice:text
	    {label "Codice"}
	    {html {size 70 maxlength 15}}
		{help_text "Codice voucher da inviare (e.g.:PF15GRATIS). Massimo 15 caratteri."}
	}
	{times:integer
	    {label "Utilizzi"}
	    {help_text "Quante volte è utilizzabile?"}
	}
	{discount:text
	    {label "Sconto"}
	    {after_html "%"}
	    {value "100"}
	    {help_text "Usare il punto come separatore decimale."}
	}
	{expiry_date:date(date),to_sql(linear_date_no_time),optional
	    {label "Scadenza"}
	    {help_text "Scadenza del voucher. Lasciare vuoto per che sia valido per sempre."}
	}
    }  -select_query {
	"select voucher_id, evento_id, times, discount, codice, creation_date, expiry_date from expo_voucher where voucher_id = :voucher_id"
    } -on_submit {
	
    } -new_data {
      	set voucher_id [db_string query "SELECT COALESCE(MAX(voucher_id)+1,1) FROM expo_voucher"]
	db_dml query "INSERT INTO expo_voucher(voucher_id, evento_id, codice, times, discount, creation_date, expiry_date) VALUES (:voucher_id, :evento_id, :codice, :times, :discount, current_timestamp, :expiry_date)"
    } -edit_data {
	db_dml query "UPDATE expo_voucher SET evento_id = :evento_id, times = :times, discount = :discount, codice = :codice, expiry_date = :expiry_date WHERE voucher_id = :voucher_id"
    } -after_submit {
	ad_returnredirect "voucher-list"
	ad_script_abort
    }


