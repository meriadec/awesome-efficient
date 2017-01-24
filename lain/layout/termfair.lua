
--[[
                                                  
     Licensed under GNU General Public License v2 
      * (c) 2014,      projektile                 
      * (c) 2013,      Luke Bonham                
      * (c) 2010,      Nicolas Estibals           
      * (c) 2010-2012, Peter Hofmann              
                                                  
--]]

local tag      = require("awful.tag")
local math     = { ceil  = math.ceil,
                   floor = math.floor,
                   max   = math.max }
local tonumber = tonumber

local termfair  = { name = "termfair" }
termfair.center = { name = "centerfair" }

local function do_fair(p, orientation)
    -- Screen.
    local wa  = p.workarea
    local cls = p.clients

    if #cls <= 0 then return end

    -- Useless gaps.
    local useless_gap = p.useless_gap or 0

    if orientation == "west" then
        -- Layout with fixed number of vertical columns (read from nmaster).
        -- New windows align from left to right. When a row is full, a now
        -- one above it is created. Like this:

        --        (1)                (2)                (3)
        --   +---+---+---+      +---+---+---+      +---+---+---+
        --   |   |   |   |      |   |   |   |      |   |   |   |
        --   | 1 |   |   |  ->  | 2 | 1 |   |  ->  | 3 | 2 | 1 |  ->
        --   |   |   |   |      |   |   |   |      |   |   |   |
        --   +---+---+---+      +---+---+---+      +---+---+---+

        --        (4)                (5)                (6)
        --   +---+---+---+      +---+---+---+      +---+---+---+
        --   | 4 |   |   |      | 5 | 4 |   |      | 6 | 5 | 4 |
        --   +---+---+---+  ->  +---+---+---+  ->  +---+---+---+
        --   | 3 | 2 | 1 |      | 3 | 2 | 1 |      | 3 | 2 | 1 |
        --   +---+---+---+      +---+---+---+      +---+---+---+

        if #cls <= 0 then return end

        -- How many vertical columns? Read from nmaster on the tag.
        local num_x = tonumber(termfair.nmaster) or tag.master_count
        local ncol  = tonumber(termfair.ncol) or tag.column_count
        local width = math.floor((wa.width - (num_x + 1)*useless_gap) / num_x)

        if num_x <= 2 then num_x = 2 end
        if ncol  <= 1 then ncol  = 1 end

        local num_y     = math.max(math.ceil(#cls / num_x), ncol)
        local height    = math.floor((wa.height - (num_y + 1)*useless_gap) / num_y)
        local cur_num_x = num_x
        local at_x      = 0
        local at_y      = 0

        local remaining_clients = #cls

        -- We start the first row. Left-align by limiting the number of
        -- available slots.
        if remaining_clients < num_x then
            cur_num_x = remaining_clients
        end

        -- Iterate in reversed order.
        for i = #cls,1,-1 do
            -- Get x and y position.
            local c = cls[i]
            local this_x = cur_num_x - at_x - 1
            local this_y = num_y - at_y - 1

            -- Calculate geometry.
            local g = {}
            if this_x == (num_x - 1) then
                g.width = wa.width - (num_x - 1)*width - (num_x + 1)*useless_gap - 2*c.border_width
            else
                g.width = width - 2*c.border_width
            end

            if this_y == (num_y - 1) then
                g.height = wa.height - (num_y - 1)*height - (num_y + 1)*useless_gap - 2*c.border_width
            else
                g.height = height - 2*c.border_width
            end

            g.x = wa.x + this_x*width
            g.y = wa.y + this_y*height

            if useless_gap > 0 then
                -- All clients tile evenly.
                g.x = g.x + (this_x + 1)*useless_gap
                g.y = g.y + (this_y + 1)*useless_gap
            end

            if g.width < 1 then g.width = 1 end
            if g.height < 1 then g.height = 1 end

            c:geometry(g)

            remaining_clients = remaining_clients - 1

            -- Next grid position.
            at_x = at_x + 1
            if at_x == num_x then
                -- Row full, create a new one above it.
                at_x = 0
                at_y = at_y + 1

                -- We start a new row. Left-align.
                if remaining_clients < num_x then
                    cur_num_x = remaining_clients
                end
            end
        end
    elseif orientation == "center" then
        -- Layout with fixed number of vertical columns (read from nmaster).
        -- Cols are centerded until there is nmaster columns, then windows
        -- are stacked in the slave columns, with at most ncol clients per
        -- column if possible.

        -- with nmaster=3 and ncol=1 you'll have
        --        (1)                (2)                (3)
        --   +---+---+---+      +-+---+---+-+      +---+---+---+
        --   |   |   |   |      | |   |   | |      |   |   |   |
        --   |   | 1 |   |  ->  | | 1 | 2 | | ->   | 1 | 2 | 3 |  ->
        --   |   |   |   |      | |   |   | |      |   |   |   |
        --   +---+---+---+      +-+---+---+-+      +---+---+---+

        --        (4)                (5)
        --   +---+---+---+      +---+---+---+
        --   |   |   | 3 |      |   | 2 | 4 |
        --   + 1 + 2 +---+  ->  + 1 +---+---+
        --   |   |   | 4 |      |   | 3 | 5 |
        --   +---+---+---+      +---+---+---+

        -- How many vertical columns? Read from nmaster on the tag.
        local num_x = tonumber(termfair.center.nmaster) or tag.master_count
        local ncol  = tonumber(termfair.center.ncol) or tag.column_count
        local width = math.floor((wa.width - (num_x + 1)*useless_gap) / num_x)

        if num_x <= 2 then num_x = 2 end
        if ncol  <= 1 then ncol  = 1 end

        if #cls < num_x then
            -- Less clients than the number of columns, let's center it!
            local offset_x = wa.x + (wa.width - #cls*width - (#cls - 1)*useless_gap) / 2
            local g = {}
            g.y = wa.y + useless_gap
            for i = 1, #cls do
                local c = cls[i]
                g.width = width - 2*c.border_width
                g.height = wa.height - 2*useless_gap - 2*c.border_width
                if g.width < 1 then g.width = 1 end
                if g.height < 1 then g.height = 1 end
                g.x = offset_x + (i - 1) * (width + useless_gap)
                c:geometry(g)
            end
        else
            -- More clients than the number of columns, let's arrange it!
            -- Master client deserves a special treatement
            local c = cls[1]
            local g = {}
            g.width = wa.width - (num_x - 1)*width - (num_x + 1)*useless_gap - 2*c.border_width
            g.height = wa.height - 2*useless_gap - 2*c.border_width
            if g.width < 1 then g.width = 1 end
            if g.height < 1 then g.height = 1 end
            g.x = wa.x + useless_gap
            g.y = wa.y + useless_gap

            c:geometry(g)

            -- Treat the other clients

            -- Compute distribution of clients among columns
            local num_y ={}
            do
                local remaining_clients = #cls-1
                local ncol_min = math.ceil(remaining_clients/(num_x-1))
                if ncol >= ncol_min then
                    for i = (num_x-1), 1, -1 do
                        if (remaining_clients-i+1) < ncol then
                            num_y[i] = remaining_clients-i + 1
                        else
                            num_y[i] = ncol
                        end
                        remaining_clients = remaining_clients - num_y[i]
                    end
                else
                    local rem = remaining_clients % (num_x-1)
                    if rem == 0 then
                        for i = 1, num_x-1 do
                            num_y[i] = ncol_min
                        end
                    else
                        for i = 1, num_x-1 do
                            num_y[i] = ncol_min - 1
                        end
                        for i = 0, rem-1 do
                            num_y[num_x-1-i] = num_y[num_x-1-i] + 1
                        end
                    end
                end
            end

            -- Compute geometry of the other clients
            local nclient = 2 -- we start with the 2nd client
            g.x = g.x + g.width + useless_gap + 2*c.border_width

            for i = 1, (num_x-1) do
                local height = math.floor((wa.height - (num_y[i] + 1)*useless_gap) / num_y[i])
                g.y = wa.y + useless_gap
                for j = 0, (num_y[i]-2) do
                    local c = cls[nclient]
                    g.height = height - 2*c.border_width
                    g.width = width - 2*c.border_width
                    if g.width < 1 then g.width = 1 end
                    if g.height < 1 then g.height = 1 end
                    c:geometry(g)
                    nclient = nclient + 1
                    g.y = g.y + height + useless_gap
                end
                local c = cls[nclient]
                g.height = wa.height - (num_y[i] + 1)*useless_gap - (num_y[i] - 1)*height - 2*c.border_width
                g.width = width - 2*c.border_width
                if g.width < 1 then g.width = 1 end
                if g.height < 1 then g.height = 1 end
                c:geometry(g)
                nclient = nclient + 1
                g.x = g.x + width + useless_gap
            end
        end
    end
end

function termfair.center.arrange(p)
    return do_fair(p, "center")
end

function termfair.arrange(p)
    return do_fair(p, "west")
end

return termfair
