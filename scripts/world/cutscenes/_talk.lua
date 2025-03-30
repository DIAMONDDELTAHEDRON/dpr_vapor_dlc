return {
    ---@param cutscene WorldCutscene
    main = function(cutscene, map, partyleader)
        if Game:isDessMode() then
            cutscene:showNametag("Dess")
            if map == "intro/start" then
                cutscene:text("* (But your voice echoed aimlessly.)")
            elseif map == "intro/pillars_1" then
                cutscene:text("* (But your voice echoed aimlessly.)")
            else
                cutscene:text("* allan please add dialogue", "neutral", "dess")
            end
            cutscene:hideNametag()
        else
            if map == "intro/start" then
                cutscene:text("* (But your voice echoed aimlessly.)")
            elseif map == "intro/pillars_1" then
                cutscene:text("* (But your voice echoed aimlessly.)")
            else
                cutscene:text("* (But your voice echoed aimlessly.)")
            end
        end
    end,
}