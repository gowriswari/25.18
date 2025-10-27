# If necessary, uncomment the line below to include explore_source.
# include: "gowri_project1.model.lkml"
include: "/views/filters.view.lkml"
view: derived_1 {
  extends: [filters]
  derived_table: {
    sql: SELECT
          inventory_items.product_sku  AS inventory_items_product_sku,
          order_items.user_id  AS order_items_user_id,
          COUNT(DISTINCT inventory_items.id ) AS inventory_items_count
      FROM `venkata_bq.order_items`  AS order_items
      LEFT JOIN `venkata_bq.inventory_items`  AS inventory_items ON order_items.inventory_item_id = inventory_items.id
      WHERE {% condition date_filter %} order_items.id {% endcondition %}
      GROUP BY
          1,
          2
      ORDER BY
          3 DESC
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

  dimension: inventory_items_count {
    type: number
    sql: ${TABLE}.inventory_items_count ;;
  }

  set: detail {
    fields: [
      inventory_items_product_sku,
      order_items_user_id,
      inventory_items_count
    ]
  }
}
