-- ;
-- ;  Written by ToothyJarl :: 4/11/2023
-- ;

LUI.addmenubutton("pc_controls", {
    index = 1,
    text = "Viewhands",
    description = Engine.Localize("Choose which viewhands are used in game."),
    callback = function()
        LUI.FlowManager.RequestAddMenu(nil, "viewhand")
    end
})