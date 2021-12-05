local surface = require("gamesense/surface")

local Esp = {}
Esp.__index = Esp


function Esp.new()
    local self = {}
    self.x, self.y = 10, 0
    self.w, self.h = 300, 0
    self.elements = {}

    return setmetatable(self, Esp)
end

function Esp:renderPreview()
    local menu_x, menu_y = ui.menu_position()
    local menu_w, menu_h = ui.menu_size()
    
    local x, y = menu_x + menu_w + self.x + 6, menu_y + self.y + 6
    local w, h = 300, menu_h * 0.6 - 12
    
    -- Window
    surface.draw_filled_rect(x - 6, y - 6, w + 12, h + 12, 12, 12, 12, 255)
    surface.draw_filled_rect(x - 5, y - 5, w + 10, h + 10, 60, 60, 60, 255)
    surface.draw_filled_rect(x - 4, y - 4, w + 8, h + 8, 40, 40, 40, 255)
    surface.draw_filled_rect(x - 1, y - 1, w + 2, h + 2, 60, 60, 60, 255)
    surface.draw_filled_rect(x, y, w, h, 23, 23, 23, 255)

    -- Esp Preview
    local box_x, box_y = x + w * 0.3, y + h * 0.1
    local box_w, box_h = w * 0.4, h * 0.6
    surface.draw_outlined_rect(box_x, box_y, box_w, box_h, 255, 255, 255, 255)

    -- Element Space
    
end

--[[    renderer_rectangle(s_x - 6, s_y - 6, s_w + 12, s_h + 12, 12, 12, 12, s_alpha)
    renderer_rectangle(s_x - 5, s_y - 5, s_w + 10, s_h + 10, 60, 60, 60, s_alpha)
    renderer_rectangle(s_x - 4, s_y - 4, s_w + 8, s_h + 8, 40, 40, 40, s_alpha)
    renderer_rectangle(s_x - 1, s_y - 1, s_w + 2, s_h + 2, 60, 60, 60, s_alpha)]]

local PlayerEsp = Esp.new()
client.set_event_callback("paint_ui", function()
    PlayerEsp:renderPreview()
end)