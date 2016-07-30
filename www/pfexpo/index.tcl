ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 27 May 2015
} {
    expo_id:integer,optional
}
set page_title "PFEXPO"
set context [list $page_title]
if {![info exists expo_id]} {
    if {[ad_get_cookie expo_id] != ""} {
	set expo_id [ad_get_cookie expo_id]
    } else {
	set expo_id [db_0or1row query "select * from expo_edizioni where attivo is true limit 1"]
    }
}
template::head::add_css -href "http://pfexpo.professionefinanza.com/timetable.css"
template::head::add_css -href ../dashboard.css
set admin_menu [pf::admin_menu "pfexpo"]
ad_form -name edizione \
    -mode edit \
    -html {class "form-inline"} \
    -form {
	{expo_id:integer(select)
	    {options {[db_list_of_lists query "select c.denominazione||' '||to_char(e.data, 'YYYY'), e.expo_id from expo_edizioni e, comuni c, expo_luoghi l where c.comune_id = l.comune_id and l.luogo_id = e.luogo_id order by e.expo_id desc"]}}
	    {html {class "form-control" onchange "this.form.submit()"}}
	    {value $expo_id}
	}
    } -on_submit {
	ad_set_cookie expo_id $expo_id
    }
db_transaction {
    set giorni [db_string query "select data - current_date from expo_edizioni where expo_id = :expo_id"]
    set tot_iscr [db_string query "select count(distinct(email)) from expo_iscritti where expo_id = :expo_id"]
    set oggi_iscr [db_string query "select count(distinct(email)) from expo_iscritti where data = current_date and expo_id = :expo_id"]
}

#Estrae tabella eventi

set orari [db_list query "select * from (select start_time as orari from expo_eventi where expo_id = :expo_id union select end_time as orari from expo_eventi where expo_id = :expo_id) t order by orari"]
set events_table "<table cellspacing=\"5\" cellpadding=\"5\" class=\"tbl\"><tbody><tr class=\"blue\"><td><img class=\"center-block\" height=\"auto\" width=\"120px\" src=\"@logo_url;noquote@\"></td>"
#Estrazione sale
db_foreach query "select s.denominazione from expo_sale s, expo_luoghi l, expo_edizioni e where e.expo_id = :expo_id and e.luogo_id = l.luogo_id and s.luogo_id = l.luogo_id order by s.sala_id" {
    append events_table "<td>" $denominazione "<br></td>"
}
append events_table "</tr>"
foreach orario $orari {
    append events_table "<tr>\n<td class=\"blue\">" $orario "</td>\n"
    db_foreach query "select e.evento_id, e.denominazione,  c.hex_color, e.permalink, e.start_time, e.end_time from expo_eventi e, expo_percorsi c where e.start_time = :orario and c.percorso_id = e.percorso_id order by sala_id" {
	set rowspan [expr [lsearch $orari $end_time] - [lsearch $orari $start_time]]
	ns_log notice "CIAO " $orari "end" $end_time "..." [lsearch $orari $end_time] " ..." [lsearch $orari $start_time]
	if {$rowspan == 1} {
	    set rowspan 1
	} else {
	#    incr rowspan
	}
	append events_table "<td rowspan=\"" $rowspan "\" bgcolor=\"" $hex_color "\"><a href=\"" $permalink "\">" $denominazione ($evento_id) "<br></a></td>\n"
    }
    append events_table "</tr>\n"
    }
append events_table "</tbody></table>"

ad_return_template
