ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 23 December 2014
} {
    evento_id:integer,optional
}
pf::user_must_admin
template::head::add_css -href ../dashboard.css
template::head::add_css -href http://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.min.css
template::head::add_javascript -src http://code.jquery.com/jquery-1.9.1.min.js
template::head::add_css -href "http://images.professionefinanza.com/js/summernote/summernote.css" 
template::head::add_javascript -src "http://images.professionefinanza.com/js/summernote/summernote.js"
set admin_menu [pf::admin_menu "pfexpo"]
set expo_id [pf::expo::id]
if {[ad_form_new_p -key evento_id]} {
    set page_title "Nuovo"
    set context [list [list /pfexpo/ "PFEXPO"] [list eventi-list "Eventi"] $page_title]
    set buttons [list [list "Crea evento" new]]
} else {
    set page_title "Modifica"
    set context [list [list /pfexpo/ "PFEXPO"] [list eventi-list "Eventi"] $page_title]
    set buttons [list [list "Modifica evento" edit]]
}
set giorno [db_string query "select to_char(data, 'YYYY MM DD') from expo_edizioni where expo_id = :expo_id"]
ad_form -name evento \
    -edit_buttons $buttons \
    -has_edit 1 \
    -form {
	evento_id:key
	{denominazione:text
	    {label "Denominazione"}
	    {html {size 70 maxlength 200}}
	}
	{descrizione:text(textarea),optional
	    {label "Descrizione"}
	    {html {cols 70 rows 10}}
	}
	{sala_id:integer(select)
	    {label "Sala"}
	    {options {[db_list_of_lists query "select s.denominazione, s.sala_id from expo_sale s, expo_edizioni e where s.luogo_id = e.luogo_id and e.expo_id = :expo_id"]}}
	}
	{permalink:text
	    {label "Permalink"}
	}
	{short_title:text
	    {label "Titolo corto"}
	}
	{start_time:date,to_sql(sql_date),to_html(sql_date)
	    {format "DD MONTH YYYY HH24 MI SS"}
	    {label "Dalle"}
	    {help_text "Formato: hh24:mm."}
	    {value $giorno}
	}
	{end_time:date,to_sql(sql_date),to_html(sql_date)
	    {format "DD MONTH YYYY HH24 MI SS"}
	    {label "Alle"}
	    {help_text "Formato: hh24:mm."}
	    {value $giorno}
	}
	{percorso_id:integer(select)
	    {label "Percorso"}
	    {options {[db_list_of_lists query "select '<font color='||p.hex_color||'>'||p.descrizione||'</font>' as descrizione, p.percorso_id from expo_percorsi p"]}}
	}
	{prezzo:text,optional
	    {html {size 70 maxlength 5}}
	    {label "Prezzo"}
	    {help_text "Se è gratuito, mettere 0. Usare il punto come separatore decimale."}
	}	
	{soldout:text(checkbox),optional
	    {label "Sold Out"}
	    {options {{"" t}}}
	}
    }  -select_query {
	"SELECT evento_id, denominazione, short_title, descrizione, permalink, sala_id, start_time, end_time, prezzo::decimal, percorso_id, soldout FROM expo_eventi WHERE evento_id = :evento_id"
    } -new_data {
      	set evento_id [db_string query "SELECT COALESCE(MAX(evento_id)+1,1) FROM expo_eventi"]
	if {[db_0or1row query "select * from expo_eventi where permalink ilike :permalink limit 1"]} {
	    append permalink "_2"
	}
	db_dml query "INSERT INTO expo_eventi (evento_id, denominazione, short_title, permalink, descrizione, sala_id, start_time, end_time, prezzo, expo_id, percorso_id, soldout) VALUES (:evento_id, :denominazione, :short_title, :permalink, :descrizione, :sala_id, $start_time, $end_time, :prezzo::money, :expo_id, :percorso_id, :soldout)"
    } -edit_data {
	db_dml query "UPDATE expo_eventi SET denominazione = :denominazione, short_title = :short_title, descrizione = :descrizione, sala_id = :sala_id, start_time = $start_time, end_time = $end_time, prezzo = :prezzo::money, permalink = :permalink, soldout = :soldout WHERE evento_id = :evento_id"
    } -after_submit {
	ad_returnredirect "eventi-list"
	ad_script_abort
    }


