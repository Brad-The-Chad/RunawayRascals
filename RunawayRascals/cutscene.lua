cutscene=true 



function cutsceneUpdate()

end



function cutsceneDraw()
    local rectWidth, rectHeight = 250, 100 -- change the size of the rectangle here
    love.graphics.setColor(0, 0, 0) -- set the fill color to black
    love.graphics.rectangle("fill", 500, 500, rectWidth, rectHeight)
    love.graphics.setColor(1, 1, 1) -- set the outline color to white
    love.graphics.setLineWidth(5) -- set the line width to 5
    love.graphics.rectangle("line", 500, 500, rectWidth, rectHeight)
    love.graphics.setColor(1, 1, 1) -- set the text color to white
    love.graphics.setFont(love.graphics.newFont(24)) -- change the font size here
    love.graphics.printf("Find the scattered critters", 500, 550 - rectHeight / 2, rectWidth, "center")
    


end
    