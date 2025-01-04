data:extend({
  {
    type = "technology",
    name = "pollution-detection",
    icon = "__pollution-detector__/graphics/technology/pollution-detection.png",
    icon_size = 256,
    prerequisites = {"plastics", "advanced-circuit"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "pollution-detector"
      }
    },
    unit =
    {
      count = 100,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1}
      },
      time = 30
    },
    order = "d-a-a"
  }
})
