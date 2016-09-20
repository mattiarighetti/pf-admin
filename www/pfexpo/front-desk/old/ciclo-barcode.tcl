ad_page_contract {
    Programma per l'inserimento di codici barcode senza checksum (perché il Dymo non la vuole)
}
db_foreach query "select iscritto_id from expo_iscritti" {
    set barcode [expr ($iscritto_id + 803000000000)]
    db_dml query "update expo_iscritti set barcode = :barcode where iscritto_id = :iscritto_id"
}
ad_returnredirect index
ad_script_abort
