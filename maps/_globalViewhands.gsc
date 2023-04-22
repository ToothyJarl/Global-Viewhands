// ;
// ;  Written by ToothyJarl :: 4/12/2023
// ;

initViewhands()
{
    precacheViewhands();
    
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

precacheViewhands()
{
    precachemodel("globalViewhands_h1_usmc_marine");
    precachemodel("globalViewhands_h1_sas_woodland");
    precachemodel("globalViewhands_h1_sas_ct_mp_camo");
    precachemodel("globalViewhands_h1_sas_ct_mp_wet_camo");
    precachemodel("globalViewhands_h1_marine_sniper");
    precachemodel("globalViewhands_h1_op_force_ult");
    precachemodel("globalViewhands_h1_spetsnaz_urban_mp_wet_camo");
    precachemodel("globalViewhands_h1_arab_desert_mp_camo");
    precachemodel("globalViewhands_h1_arab_desert_mp_fullsleeves_camo");
}