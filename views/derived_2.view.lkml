include: "/views/filters.view.lkml"
view: derived_2 {
  extends: [filters]
  derived_table: {
    sql: SELECT
          inventory_items.product_sku  AS inventory_items_product_sku,
          order_items.user_id  AS order_items_user_id,
          users.state  AS users_state,
          users.last_name  AS users_last_name,
          COUNT(DISTINCT inventory_items.id ) AS inventory_items_count,
          COUNT(DISTINCT users.id ) AS users_count
      FROM `venkata_bq.order_items`  AS order_items
      LEFT JOIN `venkata_bq.users`  AS users ON order_items.user_id = users.id
      LEFT JOIN `venkata_bq.inventory_items`  AS inventory_items ON order_items.inventory_item_id = inventory_items.id
      WHERE
      {% condition date_filter %} order_items.id {% endcondition %}
      GROUP BY
          1,
          2,
          3,
          4
      ORDER BY
          5 DESC
      LIMIT 500 ;;
  }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: inventory_items_product_sku {
    type: string
    sql: ${TABLE}.inventory_items_product_sku ;;
  }

  dimension: order_items_user_id {
    type: number
    sql: ${TABLE}.order_items_user_id ;;
  }

  dimension: users_state {
    type: string
    sql: ${TABLE}.users_state ;;
  }

  dimension: users_last_name {
    type: string
    sql: ${TABLE}.users_last_name ;;
  }

  dimension: inventory_items_count {
    type: number
    sql: ${TABLE}.inventory_items_count ;;
  }

  dimension: users_count {
    type: number
    sql: ${TABLE}.users_count ;;
  }

  set: detail {
    fields: [
      inventory_items_product_sku,
      order_items_user_id,
      users_state,
      users_last_name,
      inventory_items_count,
      users_count
    ]
  }
}
