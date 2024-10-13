---@diagnostic disable
return function(mode)
    local entities = {{Name="Echo Projectile",Anm2="projectiles/echo_projectile.anm2",CollisionMass=8,CollisionRadius=10,ShadowSize=15,NumGridCollisionPoints=60,Type=9,Variant=104,},
    {Name="Lantern Projectile",Anm2="projectiles/lantern_projectile.anm2",CollisionMass=8,CollisionRadius=5,ShadowSize=10,NumGridCollisionPoints=60,Type=9,Variant=106,},
    {Name="Staple Projectile",Anm2="staple_projectile.anm2",HP=10,CollisionMass=8,CollisionRadius=10,ShadowSize=15,NumGridCollisionPoints=8,Type=9,Variant=108,},
    {Name="Dumpling",Anm2="800.000_dumpling.anm2",HP=7,StageHP=2,Champion=true,CollisionDamage=1,CollisionMass=3,CollisionRadius=13,Friction="0.95",ShadowSize=12,NumGridCollisionPoints=12,Type=800,Variant=0,GridCollision="walls",HasFloorAlts="true",Portrait=0,Reroll="true",},
    {Name="Skinling",Anm2="800.001_skinling.anm2",HP=8,StageHP=2,Champion=true,CollisionDamage=1,CollisionMass=3,CollisionRadius=13,Friction="0.95",ShadowSize=12,NumGridCollisionPoints=12,Type=800,Variant=1,GridCollision="walls",HasFloorAlts="true",Portrait=1,Reroll="true",},
    {Name="Scab",Anm2="800.002_scab.anm2",HP=10,StageHP=2,Champion=true,CollisionDamage=1,CollisionMass=3,CollisionRadius=13,Friction="0.95",ShadowSize=12,NumGridCollisionPoints=12,Type=800,Variant=2,GridCollision="walls",HasFloorAlts="true",Portrait=2,Reroll="true",},
    {Name="Scorchling",Anm2="800.003_scorchling.anm2",HP=7,StageHP=2,Champion=true,CollisionDamage=1,CollisionMass=3,CollisionRadius=13,Friction="0.95",ShadowSize=12,NumGridCollisionPoints=12,Type=800,Variant=3,GridCollision="walls",HasFloorAlts="true",Portrait=3,Reroll="true",},
    {Name="Mortling",Anm2="800.004_mortling.anm2",HP=36,CollisionDamage=1,CollisionMass=3,CollisionRadius=16,Friction="0.95",ShadowSize=16,NumGridCollisionPoints=14,Type=800,Variant=4,GridCollision="walls",HasFloorAlts="true",ShieldStrength=5,Portrait=4,Reroll="true",},
    {Name="Tainted Dumpling",Anm2="800.005_tainted_dumpling.anm2",HP=70,CollisionDamage=1,CollisionMass=3,CollisionRadius=18,Friction="0.98",ShadowSize=18,NumGridCollisionPoints=14,Type=800,Variant=5,GridCollision="walls",HasFloorAlts="true",ShieldStrength=5,Portrait=5,Reroll="true",},
    {Name="Gilded Dumpling",Anm2="800.006_gilded_dumpling.anm2",HP=60,StageHP=2,CollisionDamage=1,CollisionMass=3,CollisionRadius=16,Friction="0.95",ShadowSize=16,NumGridCollisionPoints=14,Type=800,Variant=6,GridCollision="walls",Portrait=6,Reroll="true",},
    {Name="​Fracture",Anm2="801.000_fracture.anm2",HP=15,Champion=true,CollisionDamage=1,CollisionMass=10,CollisionRadius=13,ShadowSize=28,NumGridCollisionPoints=0,Type=29,Variant=1,Subtype=801,Tags="spider",HasFloorAlts="true",Portrait=7,},
    {Name="Stillborn",Anm2="802.000_stillborn.anm2",HP=10,CollisionDamage=1,CollisionMass=30,CollisionRadius=13,ShadowSize=14,NumGridCollisionPoints=12,Type=200,Variant=2409,GridCollision="walls",ShutDoors="false",Portrait=8,},
    {Name="Echo Bat",Anm2="828.000_echo bat.anm2",HP=20,Champion=true,CollisionDamage=1,CollisionMass=14,CollisionRadius=13,ShadowSize=18,NumGridCollisionPoints=12,Type=200,Variant=2407,Subtype=0,GridCollision="walls",Portrait=9,Reroll="true",},
    {Name="Necromancer",Anm2="831.000_necromancer.anm2",HP=25,Champion=true,CollisionDamage=1,CollisionMass=10,CollisionRadius=13,ShadowSize=14,NumGridCollisionPoints=12,Type=200,Variant=2410,Tags="homing_soul",HasFloorAlts="true",Portrait=10,},
    {Name="Swapper",Anm2="835.000_swapper.anm2",HP=25,Champion=true,CollisionMass=10,CollisionRadius=13,ShadowSize=16,NumGridCollisionPoints=8,Type=38,Variant=835,GridCollision="walls",Portrait=11,Reroll="true",},
    {Name="Swapper (Gehenna)",Anm2="835.000_swapper_gehenna.anm2",HP=25,Champion=true,CollisionMass=10,CollisionRadius=13,ShadowSize=16,NumGridCollisionPoints=8,Type=38,Variant=835,Subtype=1,GridCollision="walls",Portrait=12,Reroll="true",},
    {Name="Barfy",Anm2="850.000_barfy.anm2",HP=70,Champion=true,CollisionDamage=1,CollisionMass=10,CollisionRadius=13,ShadowSize=16,NumGridCollisionPoints=12,Type=208,Variant=850,Portrait=12,Reroll="true",},
    {Name="Coil",Anm2="864.000_coil.anm2",HP=20,CollisionDamage=1,CollisionMass=100,CollisionRadius=10,Friction=0,ShadowSize=13,NumGridCollisionPoints=12,Type=200,Variant=2406,Tags="noreroll",GridCollision="none",ShutDoors="false",Portrait=13,},
    {Name="Screamer",Anm2="867.000_screamer.anm2",HP=100,CollisionDamage=2,CollisionMass=950,CollisionRadius=13,ShadowSize=18,NumGridCollisionPoints=12,Type=200,Variant=2408,Portrait=14,},
    {Name="Cell",Anm2="cell.anm2",HP=16,CollisionDamage=1,CollisionMass=16,CollisionRadius=13,ShadowSize=12,NumGridCollisionPoints=12,Type=200,Variant=2500,GridCollision="walls",Portrait=15,},
    {Name="Fused Cells",Anm2="fused_cells.anm2",HP=32,CollisionDamage=1,CollisionMass=16,CollisionRadius=16,ShadowSize=20,NumGridCollisionPoints=12,Type=200,Variant=2501,GridCollision="walls",Portrait=16,},
    {Name="Tissue",Anm2="tissue.anm2",HP=64,CollisionDamage=1,CollisionMass=16,CollisionRadius=19,ShadowSize=24,NumGridCollisionPoints=12,Type=200,Variant=2502,GridCollision="walls",Portrait=17,},
    {Name="Grave Robber",Anm2="837.000_graverobber.anm2",HP=15,StageHP=1,CollisionMass=5,CollisionRadius=13,ShadowSize=15,NumGridCollisionPoints=12,Type=200,Variant=2503,Portrait=18,},
    {Name="Splashy Long Legs",Anm2="splashy_long_legs.anm2",HP=16,StageHP=4,CollisionDamage=1,CollisionMass=20,CollisionRadius=20,ShadowSize=44,NumGridCollisionPoints=12,Type=200,Variant=2504,Tags="spider",Portrait=19,Reroll="true",},
    {Name="Sticky Long Legs",Anm2="sticky_long_legs.anm2",HP=20,StageHP=5,CollisionDamage=1,CollisionMass=20,CollisionRadius=20,ShadowSize=44,NumGridCollisionPoints=12,Type=200,Variant=2504,Subtype=1,Tags="spider",Portrait=20,Reroll="true",},
    {Name="Red TNT",Anm2="grid/grid_redtnt.anm2",HP=4,CollisionMass=20,CollisionRadius=20,NumGridCollisionPoints=12,Type=292,Variant=3400,Tags="noreroll",ShutDoors="false",Portrait=22,},
    {Name="Screamer Ring",Anm2="1000.164_screamer ring.anm2",Type=1000,Variant=164,Subtype=867,},
    {Name="Nightwatch Spotlight",Anm2="nightwatch_spotlight.anm2",NumGridCollisionPoints=0,Type=1000,Variant=842,},
    {Name="Screamer Aura",Anm2="screamer_aura.anm2",NumGridCollisionPoints=0,Type=1000,Variant=867,},
    {Name="Fire Grimace",Anm2="Fire_Grimace.anm2",HP=10,CollisionMass=100,CollisionRadius=13,ShadowSize=22,NumGridCollisionPoints=0,Type=203,Variant=2500,Tags="noreroll",HasFloorAlts="true",ShutDoors="false",Portrait=22,},
    {Name="Bloodworm",Anm2="bloodworm.anm2",HP=100,CollisionDamage=1,CollisionMass=100,CollisionRadius=15,NumGridCollisionPoints=12,Type=244,Variant=2500,HasFloorAlts="true",Portrait=23,Reroll="false",},
    {Name="Vessel (RM)",Anm2="pale_vessel.anm2",HP=70,Champion=true,CollisionDamage=1,CollisionMass=10,CollisionRadius=13,ShadowSize=16,NumGridCollisionPoints=12,Type=858,Variant=1,Portrait=24,Reroll="true",},
    {Name="​Canary",Anm2="843.000_canary.anm2",HP=16,StageHP=2,Champion=true,CollisionDamage=1,CollisionMass=10,CollisionRadius=13,ShadowSize=14,NumGridCollisionPoints=12,Type=843,Variant=200,Portrait=27,},
    {Name="​​Foreigner",Anm2="843.001_foreigner.anm2",HP=18,StageHP=2,Champion=true,CollisionDamage=1,CollisionMass=10,CollisionRadius=13,ShadowSize=14,NumGridCollisionPoints=12,Type=843,Variant=201,Portrait=28,},
    {Name="​​​Exorcist",Anm2="832.000_exorcist.anm2",HP=25,Champion=true,CollisionDamage=1,CollisionMass=10,CollisionRadius=13,ShadowSize=14,NumGridCollisionPoints=12,Type=832,Variant=200,Tags="homing_soul",Portrait=29,},
    {Name="​​​​Corpse Eater",Anm2="239.100_corpse eater.anm2",HP=48,StageHP="2.5",CollisionDamage=1,CollisionMass=14,CollisionRadius=13,ShadowSize=21,NumGridCollisionPoints=12,Type=239,Variant=200,Portrait=30,},
    {Name="​Carrion Rider",Anm2="239.101_carrion rider.anm2",HP=48,StageHP="2.5",CollisionDamage=1,CollisionMass=14,CollisionRadius=13,ShadowSize=21,NumGridCollisionPoints=12,Type=239,Variant=201,Portrait=31,},
    {Name="​​Blind Bat",Anm2="803.000_blindbat.anm2",HP=10,CollisionDamage=1,CollisionMass=14,CollisionRadius=13,ShadowSize=18,NumGridCollisionPoints=32,Type=803,Variant=200,GridCollision="walls",Portrait=32,},
    {Name="​​​Split Rage Creep",Anm2="241.001_split rage creep.anm2",HP=16,Champion=true,CollisionDamage=1,CollisionMass=14,CollisionRadius=13,NumGridCollisionPoints=12,Type=241,Variant=200,Tags="spider brimstone_soul",Portrait=33,},
    {Name="​Rag Creep",Anm2="240.002_rag creep.anm2",HP=17,StageHP=4,CollisionDamage=1,CollisionMass=14,CollisionRadius=13,NumGridCollisionPoints=12,Type=240,Variant=200,Tags="spider homing_soul",Portrait=34,},
    {Name="​​Nightwatch",Anm2="842.000_nightwatch.anm2",HP=25,StageHP=5,CollisionDamage=1,CollisionMass=100,CollisionRadius=13,ShadowSize=20,NumGridCollisionPoints=12,Type=842,Variant=200,Tags="ghost",GridCollision="floor",ShutDoors="false",Portrait=35,},
    {Name="​Vessel (Antibirth)",Anm2="858.000_vessel.anm2",HP=60,Champion=true,CollisionDamage=1,CollisionMass=10,CollisionRadius=13,ShadowSize=15,NumGridCollisionPoints=12,Type=858,Variant=200,Portrait=36,},
    {Name="​Strifer",Anm2="839.000_strifer.anm2",HP=25,Champion=true,CollisionDamage=1,CollisionMass=5,CollisionRadius=13,ShadowSize=15,NumGridCollisionPoints=12,Type=839,Variant=200,Portrait=37,},
    {Name="Chubby Bunny",Anm2="chubby_bunny.anm2",HP=20,Champion=true,CollisionDamage=1,CollisionMass=14,CollisionRadius=13,ShadowSize=18,NumGridCollisionPoints=12,Type=200,Variant=2407,Subtype=1,GridCollision="walls",Portrait=38,Reroll="true",},
    {Name="Sporeling",Anm2="800.007_sporeling.anm2",HP=7,StageHP=2,Champion=true,CollisionDamage=1,CollisionMass=3,CollisionRadius=13,Friction="0.95",ShadowSize=12,NumGridCollisionPoints=12,Type=800,Variant=7,GridCollision="walls",HasFloorAlts="false",Portrait=39,Reroll="true",},
    {Name="Beard Bat",Anm2="beard_bat.anm2",HP=10,CollisionDamage=1,CollisionMass=14,CollisionRadius=13,ShadowSize=18,NumGridCollisionPoints=32,Type=803,Variant=2,GridCollision="walls",Portrait=32,},
    }

    if not mode or mode == 1 then
        return entities
    elseif mode == 2 then
        return {["Echo Projectile"]=entities[1],["Lantern Projectile"]=entities[2],["Staple Projectile"]=entities[3],["Dumpling"]=entities[4],["Skinling"]=entities[5],["Scab"]=entities[6],["Scorchling"]=entities[7],["Mortling"]=entities[8],["Tainted Dumpling"]=entities[9],
        ["Gilded Dumpling"]=entities[10],["​Fracture"]=entities[11],["Stillborn"]=entities[12],["Echo Bat"]=entities[13],["Necromancer"]=entities[14],["Swapper"]=entities[15],["Swapper (Gehenna)"]=entities[16],["Barfy"]=entities[17],["Screamer"]=entities[19],
        ["Cell"]=entities[20],["Fused Cells"]=entities[21],["Tissue"]=entities[22],["Grave Robber"]=entities[23],["Splashy Long Legs"]=entities[24],["Sticky Long Legs"]=entities[25],["Red TNT"]=entities[26],["Screamer Ring"]=entities[27],["Nightwatch Spotlight"]=entities[28],["Screamer Aura"]=entities[29],["Fire Grimace"]=entities[30],
        ["Bloodworm"]=entities[31],["Vessel (RM)"]=entities[32],["​​​​Corpse Eater"]=entities[36],["​Carrion Rider"]=entities[37],["​​Blind Bat"]=entities[38],["​​​Split Rage Creep"]=entities[39],["​Rag Creep"]=entities[40],
        ["​​Nightwatch"]=entities[41],["​Vessel (Antibirth)"]=entities[42],["​Strifer"]=entities[43],["Chubby Bunny"]=entities[44],["Sporeling"]=entities[45],["Beard Bat"]=entities[46]}
    elseif mode == 3 then
        return {[9]={[104]={[0]=entities[1],},[106]={[0]=entities[2],},[108]={[0]=entities[3],},},[800]={[0]={[0]=entities[4],},[1]={[0]=entities[5],},[2]={[0]=entities[6],},[3]={[0]=entities[7],},[4]={[0]=entities[8],},[5]={[0]=entities[9],},[6]={[0]=entities[10],},[7]={[0]=entities[45]},},
        [29]={[1]={[801]=entities[11],},},[200]={[2409]={[0]=entities[12],},[2407]={[0]=entities[13],[1]=entities[44]},[2410]={[0]=entities[14],},[2406]={[0]=entities[18],},[2408]={[0]=entities[19],},[2500]={[0]=entities[20],},[2501]={[0]=entities[21],},[2502]={[0]=entities[22],},[2503]={[0]=entities[23],},
        [2504]={[0]=entities[24],[1]=entities[25],},},[38]={[835]={[0]=entities[15],[1]=entities[16],},},[208]={[850]={[0]=entities[17],},},[292]={[3400]={[0]=entities[26],},},[1000]={[164]={[867]=entities[27],},[842]={[0]=entities[28],},[867]={[0]=entities[29],},},[203]={[2500]={[0]=entities[30],},},
        [244]={[2500]={[0]=entities[31],},},[858]={[1]={[0]=entities[32],},[200]={[0]=entities[42],},},[843]={[200]={[0]=entities[33],},[201]={[0]=entities[34],},},[832]={[200]={[0]=entities[35],},},[239]={[200]={[0]=entities[36],},[201]={[0]=entities[37],},},[803]={[200]={[0]=entities[38],},[2]={[0]=entities[46],},
        [241]={[200]={[0]=entities[39],},},[240]={[200]={[0]=entities[40],},},[842]={[200]={[0]=entities[41],},},[839]={[200]={[0]=entities[43],},},}
    end    
end