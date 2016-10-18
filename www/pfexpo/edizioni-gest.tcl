ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 2015-11-16
    @cvs-id $Id$set oacs:msg
} {
    expo_id:integer,optional
}
set page_title "Edizione"
set context [list [list index "PFEXPO"] $page_title]
ad_form -name "edizione" \
    -mode edit \
    -form {
	expo_id:key
	{data:date,to_sql(linear_date_no_time),to_html(sql_date)
	    {format "DD MONTH YYYY"}
	    {label "Data"}
	}
	{luogo_id:integer(select)
	    {label "Luogo"}
	    {options {[db_list_of_lists query "select l.denominazione||' - '||c.denominazione, l.luogo_id from expo_luoghi l, comuni c where c.comune_id = l.comune_id"]}}
	    {after_html "<a target=\"_black\" href=\"luoghi-gest\">Nuovo</a>"}
	}
	{attivo:text,optional
	    {label "Attivo"}
	    {options {{"" t}}}
	}
	{google_maps:text(textarea)
	    {label "Google Maps"}
	    {html {cols "50" rows "4"}}
	}
    } -select_query {
	"select data, luogo_id, attivo, google_maps from expo_edizioni where expo_id = :expo_id"
    } -validate {
    } -new_data {
	set expo_id [db_string query "select coalesce(max(expo_id), 1) from expo_edizioni"]
	db_dml query "insert into expo_edizioni (expo_id, luogo_id, attivo, google_maps) values (:expo_id, :luogo_id, :attivo, :google_maps)"
    } -edit_data {
	db_dml query "update expo_edizioni set luogo_id = :luogo_id, attivo = :attivo, google_maps = :google_maps)"
    } -after_submit {
	    ad_returnredirect iscriviti?msg=ok
	    ad_script_abort
	}
