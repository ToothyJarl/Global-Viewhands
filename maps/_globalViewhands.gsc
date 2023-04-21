// ;
// ;  Written by ToothyJarl :: 4/12/2023
// ;

initViewhands()
{
    for (;;)
    {
        if (getdvar( "globalViewhandsMode" ) == "global")
        {
            level.player setviewmodel(getdvar( "globalViewhands_global"));
        } 
        else if (getdvar( "globalViewhandsMode" ) == "individual")
        {
            if(getdvar( "globalViewhands_" +  getdvar("mapname")) != undefined)
            {
                level.player setviewmodel(getdvar( "globalViewhands_" +  getdvar("mapname")));
            }
            else
            {
                IPrintLn("^1No viewhand is set for this map. Please set it in the viewhands selector.");
            }
        }

        wait 0.05;
    }
}

inGameCheck()
{
    IPrintLn("Success!");
}

checkViewhands()
{
    if (getdvar( "globalViewhandsMode" ) == "global")
    {
        IPrintLn("^2Global: " + getdvar( "globalViewhands_global" ));    
        level.player setviewmodel(getdvar( "globalViewhands_global"));
    } 
    else if (getdvar( "globalViewhandsMode" ) == "individual")
    {
        if(getdvar( "globalViewhands_" +  getdvar("mapname")) != undefined)
        {
            IPrintLn("^2Individual: " + getdvar( "globalViewhands_" +  getdvar("mapname")));
            level.player setviewmodel(getdvar( "globalViewhands_" +  getdvar("mapname")));
        }
        else
        {
            IPrintLn("^1No viewhand is set for this map. Please set it in the viewhands selector.");
        }
    }
}