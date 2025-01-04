local sensor = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
sensor.name = "pollution-detector"
sensor.icon = "__pollution-detector__/graphics/icons/pollution-detector.png"
sensor.icon_draw_specification = {
  scale = 0.5,
}
sensor.minable.result = "pollution-detector"
sensor.sprites = make_4way_animation_from_spritesheet(
  {
    layers =
    {
      {
        filename = "__pollution-detector__/graphics/entity/pollution-detector.png",
        width = 114,
        height = 102,
        scale = 0.5,
        frame_count = 1,
        shift = util.by_pixel(0, 5),
      },
      {
        filename = "__pollution-detector__/graphics/entity/pollution-detector-shadow.png",
        width = 98,
        height = 66,
        scale = 0.5,
        frame_count = 1,
        shift = util.by_pixel(8.5, 5.5),
        draw_as_shadow = true,
      },
    },
  })

sensor.item_slot_count = 10
    
    
data:extend({ sensor })
