return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 28,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 7,
  nextobjectid = 23,
  backgroundcolor = { 14, 0, 29 },
  properties = {
    ["music"] = "resonance_muffled",
    ["use_footstep_sounds"] = true
  },
  tilesets = {
    {
      name = "vapor",
      firstgid = 1,
      filename = "../../tilesets/vapor.tsx",
      exportfilename = "../../tilesets/vapor.lua"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 28,
      id = 1,
      name = "Tile Layer 1",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        51, 51, 51, 52, 0, 0, 0, 0, 0, 0, 0, 0, 56, 57, 57, 57,
        61, 61, 61, 62, 63, 0, 0, 0, 0, 0, 0, 65, 66, 67, 67, 67,
        71, 71, 71, 72, 73, 63, 0, 0, 0, 0, 65, 75, 76, 77, 77, 77,
        81, 81, 81, 82, 83, 73, 74, 74, 74, 74, 75, 85, 86, 87, 87, 87,
        91, 91, 91, 92, 93, 83, 2, 2, 2, 2, 85, 95, 96, 97, 97, 97,
        101, 101, 101, 102, 103, 93, 94, 94, 94, 94, 95, 105, 106, 107, 107, 107,
        35, 35, 35, 35, 102, 103, 22, 12, 12, 22, 105, 35, 35, 35, 35, 35,
        35, 35, 35, 35, 35, 102, 17, 12, 12, 18, 106, 35, 35, 35, 35, 35,
        45, 45, 45, 45, 45, 45, 37, 12, 12, 38, 45, 45, 45, 45, 45, 45,
        0, 0, 0, 0, 0, 0, 14, 12, 12, 16, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 14, 12, 12, 16, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 14, 12, 12, 8, 5, 5, 6, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 14, 12, 12, 2, 2, 2, 16, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 14, 12, 12, 22, 22, 22, 16, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 14, 12, 12, 18, 25, 25, 26, 0, 0, 0,
        0, 0, 0, 4, 5, 5, 7, 12, 12, 38, 45, 45, 46, 0, 0, 0,
        0, 0, 0, 14, 2, 2, 2, 12, 12, 16, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 14, 22, 22, 22, 12, 12, 16, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 24, 25, 25, 17, 12, 12, 16, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 44, 45, 45, 37, 12, 12, 16, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 14, 12, 12, 16, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 14, 12, 12, 16, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 14, 12, 12, 16, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 14, 12, 12, 16, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 14, 12, 12, 16, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "collision",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 840,
          width = 120,
          height = 280,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 680,
          width = 120,
          height = 440,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 400,
          width = 120,
          height = 200,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 600,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 760,
          width = 40,
          height = 80,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 400,
          width = 120,
          height = 360,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 280,
          width = 120,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 280,
          width = 120,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 120,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 120,
          width = 120,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 240,
          width = 160,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "polygon",
          x = 240,
          y = 400,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -120, y = -120 },
            { x = -120, y = 0 }
          },
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "polygon",
          x = 400,
          y = 400,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 120, y = -120 },
            { x = 120, y = 0 }
          },
          properties = {}
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "polygon",
          x = 240,
          y = 280,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -120, y = -120 },
            { x = 0, y = -120 }
          },
          properties = {}
        },
        {
          id = 19,
          name = "",
          type = "",
          shape = "polygon",
          x = 400,
          y = 280,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 120, y = -120 },
            { x = 0, y = -120 }
          },
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "objects",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 14,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = -40,
          y = 160,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "intro/item_1",
            ["marker"] = "right"
          }
        },
        {
          id = 15,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 640,
          y = 160,
          width = 40,
          height = 120,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "intro/slides_1",
            ["marker"] = "left"
          }
        },
        {
          id = 16,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 1120,
          width = 80,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "intro/pillars_1",
            ["marker"] = "up"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "markers",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 17,
          name = "down",
          type = "",
          shape = "point",
          x = 320,
          y = 1080,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "left",
          type = "",
          shape = "point",
          x = 40,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "right",
          type = "",
          shape = "point",
          x = 600,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
      name = "controllers",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 22,
          name = "worldshader",
          type = "",
          shape = "point",
          x = 10,
          y = 20,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["shader"] = "ntsc"
          }
        }
      }
    }
  }
}
