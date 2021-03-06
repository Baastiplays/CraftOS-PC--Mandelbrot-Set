local PixelSize = 1 --KEEP AT 1

local function lightLevelToCol(D)
    return D*255
end

local function drawFromArray1D(x, y, T, Grid)
    local P = {}
    local Pit = 0
    P.currLightLevel = nil
    ---@diagnostic disable-next-line: undefined-field
    for i=1,table.getn(T) do
        if lightLevelToCol(T[i].lightLevel) == P.currLightLevel then
           if P[Pit][2] == nil then
               P[Pit][2] = 1
           end
           P[Pit][2] = P[Pit][2] + 1

        else
            Pit = Pit + 1 
            P.currLightLevel = lightLevelToCol(T[i].lightLevel)
            P[Pit] = {}
            P[Pit][1] = i
            P[Pit][2] = 1
            P[Pit].col = P.currLightLevel
        end
    end
    P.currLightLevel = nil
    --local file = fs.open("home/debug/DFA.txt","w")
    --file.write(textutils.serialise({T=T,P=P}))
    --file.close()
    
---@diagnostic disable-next-line: undefined-field
    for i=1,table.getn(P) do 
        term.drawPixels(
            (x+P[i][1])*PixelSize,
            y*PixelSize,
            P[i].col,
            PixelSize*(P[i][2]),
            PixelSize
        )
    end
    return P
end

local function drawFromArray2D(x, y, Grid) 
    local oT = {} 
    ---@diagnostic disable-next-line: undefined-field
    for y1=1,table.getn(Grid.grid) do
        oT[y1] = drawFromArray1D(x-1,y+y1-1,Grid.grid[y1], Grid)
    end
    --debugLog(oT,"DFA2D")
end

local function setPalette()
    local function fr(x)
        return (-0.140959*(0.984601^(x-127.5)))+1.01949
    end
    local function fg(x)
        return (-0.41188*(0.991979^(x-127.198)))+1.14716
    end
    local function fb(x)
        return 3/4*x/255+1/4
    end
    for i=0,255 do
        term.setPaletteColor(i, colors.packRGB(fr(i),fg(i),fb(i)))
    end
end

local function resetPalette()
    for i=0,15 do
        local r, g, b = term.nativePaletteColor(2^i)
        term.setPaletteColor(2^i, colors.packRGB(r,g,b))
    end
end

return {
    lightLevelToCol = lightLevelToCol,
    PixelSize = PixelSize,
    drawFromArray1D = drawFromArray1D,
    drawFromArray2D = drawFromArray2D,
    resetPalette = resetPalette,
    setPalette = setPalette
}