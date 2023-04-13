// ;
// ;  Written by ToothyJarl :: 4/12/2023
// ;

initViewhands()
{
    checkViewhands();
    
    for (;;)
    {
        if (getdvar( "globalViewhandsUpdate" ) == "1")
        {
            setdvar( "globalViewhandsUpdate", "0" );
            checkViewhands();
            
        }

        level.player setviewmodel(getdvar( "globalViewhandsCurrent"));
        
        wait 0.05;
    }
}

checkViewhands()
{
    if (getdvar( "globalViewhandsMode" ) == "global")
    {
        IPrintLn("^2Global: " + getdvar( "globalViewhands_global" ));    
        setdvar("globalViewhandsCurrent", getdvar( "globalViewhands_global"));
    } 
    else if (getdvar( "globalViewhandsMode" ) == "individual")
    {
        if(getdvar( "globalViewhands_" +  getdvar("mapname")) != undefined)
        {
            IPrintLn("^2Individual: " + getdvar( "globalViewhands_" +  getdvar("mapname")));
            setdvar("globalViewhandsCurrent", getdvar( "globalViewhands_" +  getdvar("mapname")));

        }
        else
        {
            IPrintLn("^1No viewhand is set for this map. Please set it in the viewhands selector.");
        }
    }
}