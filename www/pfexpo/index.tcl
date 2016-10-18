ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Wednesday 27 May 2015
} {
    expo_id:integer,optional
}
pf::user_must_admin
set page_title "PFEXPO"
set context [list $page_title]
if {![info exists expo_id]} {
    if {[ad_get_cookie expo_id] != ""} {
	set expo_id [ad_get_cookie expo_id]
    } else {
	if {[db_0or1row query "select * from expo_edizioni where attivo is true limit 1"]} {
	    set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true limit 1"]
	} else {
	    set expo_id [db_string query "select expo_id from expo_edizioni order by data desc limit 1"]
	}
	ad_set_cookie expo_id $expo_id
    }
}
ad_form -name edizione \
    -mode edit \
    -html {class "form-inline"} \
    -form {
	{expo_id:integer(select)
	    {options {[db_list_of_lists query "select c.denominazione||' '||to_char(e.data, 'YYYY'), e.expo_id from expo_edizioni e, comuni c, expo_luoghi l where c.comune_id = l.comune_id and l.luogo_id = e.luogo_id order by e.expo_id desc"]}}
	    {html {class "form-control" onChange "this.form.submit()"}}
	    {value $expo_id}
	}
    } -on_submit {
	ad_set_cookie expo_id $expo_id
    }
set giorni [db_string query "select data - current_date from expo_edizioni where expo_id = :expo_id"]
set tot_iscr [db_string query "select count(distinct(email)) from expo_iscritti where expo_id = :expo_id"]
set oggi_iscr [db_string query "select count(distinct(email)) from expo_iscritti where data = current_date and expo_id = :expo_id"]

#CREAZIONE TABELLA ORARIA
set orari [db_list query "select * from (select start_time as orari from expo_eventi where expo_id = :expo_id union select end_time as orari from expo_eventi where expo_id = :expo_id) t order by orari"]
set events_table "<table border=\"1\" cellspacing=\"10px\" cellpadding=\"10px\"><tbody><tr><td><img class=\"center-block\" height=\"auto\" width=\"120px\" src=\"http://images.professionefinanza.com/logos/pfexpo.png\"></td>"
#Estrazione sale
db_foreach query "select s.denominazione from expo_sale s, expo_luoghi l, expo_edizioni e where e.expo_id = :expo_id and e.luogo_id = l.luogo_id and s.luogo_id = l.luogo_id order by s.sala_id" {
    append events_table "<td> Sala " $denominazione "<br></td>"
}
append events_table "</tr>"
foreach orario $orari {
    set num_orari [llength $orari]
    if {[lsearch $orari $orario] ne [expr $num_orari - 1]} {
	set orario_next [lsearch $orari $orario]
	incr orario_next
	set orario_next [lindex $orari $orario_next]
	append events_table "<tr>\n<td>" [db_string query "select to_char('$orario'::timestamp, 'HH24:MI')||' - '||to_char('$orario_next'::timestamp, 'HH24:MI')"] "</td>\n"
	db_foreach query "select e.evento_id, e.denominazione, e.percorso_id, e.soldout,case when e.prezzo > 0::money then 'p' else 'g' end as prezzo, c.hex_color, e.permalink, e.start_time, e.end_time from expo_eventi e, expo_percorsi c where e.start_time = :orario and c.percorso_id = e.percorso_id order by sala_id" {
	    set rowspan [expr [lsearch $orari $end_time] - [lsearch $orari $start_time]]
	    append events_table "<td rowspan=\"" $rowspan "\" bgcolor=\"" $hex_color "\"><a href=\"/programma/" $permalink "\">"
	    if {$prezzo eq "p"} {
		append events_table "<img height=\"100px\" width=\"auto\" src=\"http://images.professionefinanza.com/pfexpo/icons/moneta_bianca.png\" align=\"right\">"
	    }
	    append events_table "<font color=\"#ffffff\"><big><b>" $denominazione "</b></bog></font><br><img height=\"\" width=\"auto\" src=\"" "\" align=\"right\"><br>"
	    if {[db_0or1row query "select * from expo_percorsi where percorso_id = :percorso_id and icon_white is not null"]} {
		set icon_white [db_string query "select icon_white from expo_percorsi where percorso_id = :percorso_id"]
		append events_table "<img align=\"right\" width=\"50px\" src=\"http://images.professionefinanza.com/categorie/white/$icon_white\" />"
	    }
	    append events_table "</a></td>\n"
	}
	append events_table "</tr>\n"
    }
}
append events_table "</tbody></table>"

ad_return_template
