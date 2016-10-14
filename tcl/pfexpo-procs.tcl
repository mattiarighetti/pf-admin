ad_library {}

namespace eval pf::expo {}

ad_proc -public pf::expo::voucher_check {
    voucher_code
} {
    #Controlla se esiste e ne imposta l'ID                                                                                                                                                   
    if {![db_0or1row query "select * from expo_voucher where lower(codice) = lower(:voucher_code)"]} {
        return 0
    } else {
        set voucher_id [db_string query "select voucher_id from expo_voucher where lower(codice) = lower(:voucher_code)"]
    }
    #Controlla se è ancora disponibile                                                                                                                                                         
    if {[db_string query "select count(distinct(iscritto_id)) from expo_iscrizioni where voucher_id = :voucher_id"] >= [db_string query "select times from expo_voucher where voucher_id = :voucher_id"]} {
        return 0
    }
    #Controlla se è scaduto                                                                                                                                                                    
    if {[db_string query "select expiry_date from expo_voucher where voucher_id = :voucher_id"] ne "" } {
        if {[db_string query "select current_date"] > [db_string query "select expiry_date from expo_voucher where voucher_id = :voucher_id"]} {
            return 0
        }
    }
    return 1
}

ad_proc -public pf::expo::id {
} {
    if {[ad_get_cookie expo_id] != ""} {
	return [ad_get_cookie expo_id]
    } else {
	if {[db_0or1row query "select * from expo_edizioni where attivo is true limit 1"]} {
	    return [db_string query "select expo_id from expo_edizioni where attivo is true"]
	} else {
	    ad_return_complaint 1 "Nessuna edizione PFEXPO selezionata. <a href=\"index\">Ritorna al menu per selezionarla</a>."
	}
    }
}

ad_proc -public pf::expo::edition_id {
    {expo_id ""}
} {
    if {$expo_id eq ""} {
	
    } else {
	ad_set_cookie 
    }
    return 1
}

namespace eval pf::awards {}

ad_proc -public pf::awards::id {
} {
    if {[ad_get_cookie award_id] != ""} {
	return [ad_get_cookie award_id]
    } else {
	set award_id [db_string query "select award_id from awards_edizioni order by attivo, award_id desc limit 1"]
	ad_set_cookie award_id $award_id
	return $award_id
    }
}
