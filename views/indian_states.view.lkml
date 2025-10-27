view: indian_states {
  sql_table_name: `venkata_bq.indian_states` ;;

  dimension: state_id {
    type: number
    sql: ${TABLE}.state_id ;;
  }
  dimension: state_name {
    type: string
    sql: ${TABLE}.state_name ;;
  }
  measure: count {
    type: count
    drill_fields: [state_name]
  }
}
