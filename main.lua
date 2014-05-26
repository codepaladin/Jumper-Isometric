-- main.lua

-- Hide the iPhone status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the jumper library
local Grid = require ("jumper.jumper.grid")
local Pathfinder = require ("jumper.jumper.pathfinder")
local walkable = 0 -- used by Jumper to mark obstacles

local map = {}   -- table representing each grid position
local startX = 1 -- start x grid (cartesian) coordinate
local startY = 1 -- start y grid (cartesian) coordinate
local endX = 3   -- end x grid (cartesian) coordinate
local endY = 4   -- end y grid (cartesian) coordinate

local tileWidth = 128
local tileHeight = 64

local bg = display.newRect( display.screenOriginX,
                            display.screenOriginY, 
                            display.actualContentWidth, 
                            display.actualContentHeight)
 
bg.x = display.contentCenterX
bg.y = display.contentCenterY
bg:setFillColor( 000/255, 168/255, 254/255 )

-- display group that will hold grid
group = display.newGroup( )
group.x = display.contentCenterX -- center the grid on the screen

-- draw a tile map to the screen
-- populate the tile map
function drawGrid()
   for row = 0, 5 do
      local gridRow = {}
      
      for col = 0, 5 do
        -- draw a diamond shaped tile
        local vertices = { 0,-16, -64,16, 0,48, 64,16 }
        local tile = display.newPolygon(group, 0, 0, vertices )

        -- outline the tile and make it transparent
		    tile.strokeWidth = 1
		    tile:setStrokeColor( 0, 1, 1 )
        tile.alpha = .25

        -- set the tile's x and y coordinates
        local x = col * tileHeight
        local y = row * tileHeight

        tile.x = x - y
        -- the first part of this equation is to move the y coordinate down 32 pixels (tileHeight/2)
        tile.y = (tileHeight/2) + ((x + y)/2) 
        
        -- make a tile walkable
        gridRow[col] = 0
      end
      -- add gridRow table to the map table
      map[row] = gridRow
   end
end

-- get start position based off of startX and startY grid (cartesian) coordinates
function drawStart()
	local x = (display.contentWidth * 0.5 + ((startX - startY) * tileHeight)) 
	local y = (((startX + startY)/2) * tileHeight) - (tileHeight/2)
	local myText = display.newText( "A", x, y, native.systemFont, 34 )
end

-- get end position based off of endX and endY grid (cartesian) coordinates
function drawEnd()
  local x = (display.contentWidth * 0.5 + ((endX - endY) * tileHeight)) 
  local y = (((endX + endY)/2) * tileHeight) - (tileHeight/2)
  local myText = display.newText( "B", x, y, native.systemFont, 34 )
end

-- find the path from point A to point B
function getPath()
   -- create a Jumper Grid object by passing in our map table
   local grid = Grid(map)

   -- Creates a pathfinder object using Jump Point Search
   local pather = Pathfinder(grid, 'JPS', walkable)
   pather:setMode("ORTHOGONAL") 
   
   -- Calculates the path, and its length
   local path = pather:getPath(startX,startY, endX,endY)

   if path then
    for node, count in path:nodes() do
      print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
    end
 end
end


drawGrid()
drawStart()
drawEnd()
getPath()