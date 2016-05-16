ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 27 May 2015
} {
    expo_id:integer,optional 
    {cerca_expo_id 0}
}
set page_title "PFEXPO"
set context [list $page_title]
template::head::add_css -href ../dashboard.css
set admin_menu [pf::admin_menu "pfexpo"]
if {$cerca_expo_id == 0} {
    set cerca_expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
    set expo_id $cerca_expo_id
    ad_set_cookie expo_id $expo_id
}
set expo_id_options ""
db_foreach query "select e.expo_id, c.denominazione, to_char(e.data, 'YYYY') as anno from expo_edizioni e, comuni c, expo_luoghi l where c.comune_id = l.comune_id and l.luogo_id = e.luogo_id order by e.expo_id desc" {
    if {$cerca_expo_id == $expo_id} {
	append expo_id_options "<option value=${expo_id} selected=\"selected\">${denominazione} ${anno}</option>"
    } else {
	append expo_id_options "<option value=${expo_id}>${denominazione} ${anno}</option>"
    }
}
set attivo [db_0or1row query "select * from expo_edizioni where attivo is true limit 1"]
if {$attivo eq 1} {
    db_transaction {
	set giorni [db_string query "select data - current_date from expo_edizioni where expo_id = :expo_id"]
	set tot_iscr [db_string query "select count(distinct(email)) from expo_iscritti where expo_id = :expo_id"]
	set oggi_iscr [db_string query "select count(distinct(email)) from expo_iscritti where data = current_date and expo_id = :expo_id"]
    }
}
ad_return_template
