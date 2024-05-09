1 /* SPDX-License-Identifier: Unlicensed
2 
3 .                                                                                                                                                                                                       
4 .                                                                                 .......''',,,,,,,;;,,,,,,,,'''.......                                                                                 
5 .                                                                        ....'',;;::::::::::::::::::::::::::::::::::::;;,,'....                                                                         
6 .                                                                  ...',;::::::::::::::::::::::::::::::::::::::::::::::::::::::;,''..                                                                   
7 .                                                             ..',;::::::::::::::::ccccccccccccccccccccccccccccccccc:::::::::::::::::;,'...                                                             
8 .                                                        ...,;:::::::::::::ccccccccccccccccccccccccccccccccccccccccccccccccccc::::::::::::;,'..                                                         
9 .                                                    ..',;::::::::::::cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc:::::::::::;'..                                                     
10 .                                                 ..,;:::::::::cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc::::::::::,'.                                                  
11 .                                              .',::::::::::cccccccccccccccccccclcccllllllllllllllllllllllllllllllllllccccccccccccccccccccccc:::::::::;,..                                              
12 .                                           .';:::::::::ccccccccccccccccccclllllllllllllllllllllllllllllllllllllllllllllllllllccccccccccccccccccc::::::::;,..                                           
13 .                                        .';::::::::cccccccccccccccccccclllllllllllllllllllllllllllllllllllllllllllllllllllllllllccccccccccccccccccc::::::::;,.                                         
14 .                                     ..,::::::::cccccccc::;,,''.......''',;:clllllllolllllllllllllllllllllllllloololllllllc:;,,'''....''',,;::cccccccc::::::::;'.                                      
15 .                                   .';::::::::cccccc:;,'.....',,,;;;;;;,,,''.'';::;;,,,''''''''''''''''''''''',,,;;::c:;,'''',,;;;;;;;,,''....'';:cccccc:::::::::,.                                    
16 .                                 .,::::::::cccccc:;'....,;:cllooooooddolc;,'.....'''',,,;;;;::::::::::::;;;;;,,,,''.......,;:loddooooooollc:;,'...',;ccccccc:::::::;..                                 
17 .                               .,::::::::ccccc:;'...';:clooddddxkOkdl:,'..',;;::clloooooooddddddddddddddooooooooollcc::;;,''.',:ldkOOkxxdddooolc;,....,:cccccccc:::::;'.                               
18 .                             .,:::::::cccccc:,...',:loodddxkO00kdc;''';::clloooodddddddddxxddddddddddddddxxdddddddddoooolllcc:;,'.,:okKKKOkxdddoolc;'...,:cccccc::c::::;'.                             
19 .                           .,:::::::cccccc:,...':loodddxk0KKOo;'.,;:cllooodddddddddddddddddddddddddddddddddddddddddddddddddoolllcc;,'.,cxKNX0Oxddddolc,...':ccccccc::::::;'.                           
20 .                         .,::::::cccccccc;...':loddddxOKNKd;..,:clllooddddxxddddddddddddddddddxddxdddddxdddddddddddddddddddddddooolll:;'.,ckXWX0kxddddoc;...,:cccccc:::::::;.                          
21 .                       .':::::::ccccccc:'..':oddddxk0NNOl'.,:clllodddddddddddddddddddddddddddddddxkkxdddddddddddddddddddddddddxddddoolllc;'.;dKWNKOxddddoc,...;ccccccc:::::::,.                        
22 .                      .;:::::ccccccccc,...:odddddk0NNOc..;cllloodddddddddddddddddxddddddddddddxdxKNNKkdddddddddddxddddddddddddddddddddoollc:'.,oKWWXOxdxdddc'..':cccccccc::::::'.                      
23 .                    .,::::::cccccccc:'..,ldddddx0NWKl'.;cllloddddddddddddddddddddxdddddddddddxddONMMW0xddddddddddddddddddddddddddddddddddolll:,.,dXMWKkxddddo;...;ccccccccc:::::;.                     
24 .                   .;:::::ccccccccc;...;oxdddxOXWNx,.,:llloddddddddddddddxddxxdddxxddddddddddxdxKWMMMKxddddddddddddddddxdddddddddddddddddddolll:'.;kNWN0xdddddc'..,ccccccccc::::::,.                   
25 .                 .'::::::ccccccccc;...cdxxxdxKWMXl..;lllloddddddddddddddddddddolloddxdddddddxxdkXMMMMXkddddddddddddllloddddddddddddddddxdddddollc;..oXMWXOxddddl,..':cccccccc::::::;.                  
26 .                .;::::::ccccccccc,..'lddddxOXWW0:.':llloddddddddddddddddddddddc'..'cddddddddxxdONMMMMWOddddddxdxdc'..'cddddxddxddddddddddddddddoll:'.:0WMN0xdxddo;..':ccccccccc:::::;.                 
27 .               .;:::::cccccccccc,..,lddxdx0NMW0;.,cllldddxdddddddddddddddddoooc,:;..:ddddxdddxOXMMMMMMNOxdxdddddc..;:;loloddddxddddddddddddddddddllc,.,OWMWKkddddd:...:cccccccccc:::::,.               
28 .              '::::::cccccccccc,..'lxdddx0WMMK:.,clloddxddddddddddddddddddd:'...,'..:dxddddxOKNMMMMMMMMNKOxdddxd:..',...'cdddxddddddddddddddddddddolc,.,OWMWXkdddxd:..':ccccccccc::::::,.              
29 .             '::::::cccccccccl;..'lxdddkKWMMXc.'clloddddddddddddddddddxddddo:'.....:oxxkO0KNNX0OkkkkkO0NWWNK0Okxo;......:dxdddddddddddddddddddddxxdolc,.,OWMMNOxddxo;..,clccccccccc:::::;.             
30 .            ':::::cccccccccllc,..:ddddkXWMMNo..:llodddddddxddddddddddddddddddolloxO0KXNWWMMNK0O0KKKKK0O0KNMMMWNNXKkdolloddddxxdddddddddddddddddddxddolc,.:KMMMNOxdddl'..:llccccccccc:::::;.            
31 .           ':::::ccccccccclllc'..cxddkXWMMMO'.;llodxdddddddddddddddddddddxxO0KXNWMMMMMMMMMMWWMMMMMMMMMMMWWMMMMMMMMMMWWNXK0kxdxdddddddddddddddddddddddol:'.lNMMWN0xdxo,..;llllcccccccc:::::;.           
32 .          '::::::cccccccclllll,..,clxKNNXKO:.'clodddddddddddddddddddddddxOXWMMMMMMMMMMMMMMMMXxddddddddddONMMMMMMMMMMMMMMMMWXOxddddddddddddddddddddddxdol;..o0KXNXkol;..'clllllcccccccc:::::;.          
33 .         ':::::cccccccccllllllc;....';;,'....;llddddxxdddddddddddddddddkKWMMMMMMMMMMMMMMMMMMk...........:KMMMMMMMMMMMMMMMMMMW0xddddddddddddddddddddddddoc'...',,;,....,clllllllcccccccc:::::,.         
34 .        .;::::cccccccccllllllllll:;;;;;;;:'.'cloddddddddddddddddddddddkKWMMMMMMMMMMMMMMMMMMMXc.........'xWMMMMMMMMMMMMMMMMMMMWKxdddddddddddddddddddxdddol;..,:;;;,;;:clollllllllcccccccc:::::,         
35 .       .;::::::ccccccclllllllloooooooddddl'.,loddddxdddddddddddddddddxKWMMMMMMMMMMMMMMMMMMMMMXd;.....':OWMMMMMMMMMMMMMMMMMMMMMW0xdddddddddddddddddddddddoc'.,odddoooooooollllllllcccccccc:::::'        
36 .      .,:::::ccccccccllllllllooooooooddddc..;loddddxddddddddddddddxdd0NMMMMMMMMMMMMMMMMMMMMMMMMN0o:lxKWMMMMMMMMMMMMMMMMMMMMMMMMNOdddddddddddddddddddddddol,.'lddddoooooooollllllllccccccc:::::;.       
37 .      ':::::cccccccclllllllllooooooooddddc..:ldxdddddddddddddddxddddkXWMMMMMMMMMMMMMMMMMMMMMMMMMMkoxKMMMMMMMMMMMMMMMMMMMMMMMMMMMKxdxddddddddddddddddddddol;..cdddddooooooolllllllllccccccc:::::,.      
38 .     .;:::::ccccccclllllllloooooooodddddd:..:odxddddddddxddddddxxddx0WMMMMMMMMMMMMMMMMMMMMMMMMMMNl,;xWMMMMMMMMMMMMMMMMMMMMMMMMMMNOddddxxdddddddddddddddddo:..:ddddddoooooooolllllllcccccccc:::::'      
39 .     ,:::::cccccccclllllllooooooooddddddd:..:odxddddddddxxxdddddxxdkXMMN0kOKXWWMMMMMMMMMWWWWWWNKl'..'dXWWWWWWWMMMMMMMMMWWXKOOKWMWKxdxxxxdddddddddddddddxdo:..:dddddddooooooollllllllcccccccc::::;.     
40 .    .::::::cccccccllllllllooooooooddddddd:..:oddddddddddxxddddxddxxONMWN0d:,,:loxk0KXXNNNNXX0ko,......;dOKXXNNNXXKKOkdoc:,';d0XNWNOdxxdddddddddddddddddxdoc..:dddddddoooooooolllllllcccccccc:::::,     
41 .    ,:::::ccccccclllllllloooooooodddddddxc..:oddddddddddddxxdddolc:col:;,'.........',;::cc:;,............,;:cc::;,'..........',;:c:;::clodddxddddddddddddo:..:dddddddddoooooollllllllcccccccc::::;.    
42 .   .;::::cccccccclllllllloooooooddddddddxl'.;odxddddddxxdoc:;,'................................''''''''..............''..................',;cloddddddddxdo:..cxddddddddooooooolllllllccccccccc::::'    
43 .   ':::::cccccccclllllllooooooodddddddddxo'.,ldxdddddoc;'.............'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''...........',:ldddddxdl;..lxddddddddooooooollllllllcccccccc::::;.   
44 .  .;:::::ccccccclllllllloooooooddddddddxxd,.'ldddddc,........''''''...'''''''''''''''''''''''''''''''''''..'''''''..'''''''''''''''''''''''.......';lddddl,.'oxddddddddoooooooolllllllcccccccc:::::.   
45 .  .:::::cccccccclllllllooooooooddddddddxxd;.'cddxo,.....''''''''''....''''.''''''''''''''''''''''''''..''....'''''....''''''''''''''''''''''''''.....:dddl,.,dxxxdddddddoooooooolllllllcccccccc::::,   
46 .  ':::::cccccccclllllllooooooodddddddxxxxxc..:ddd;....'''''''''''......''...'''''''''''''''''''''''''..........'''......''''''''''''''''''''''''''....cdoc'.;dxxxdddddddoooooooolllllllcccccccc::::;.  
47 . .,:::::cccccccclllllllooooooddddddddxxxxxl..:oxl'...'''''''''''..,;...''...'''''''''''''''''''''''''..:l;'..........;'...'''''''''''''''''''''''''...;dd:..:xxxxxddddddoooooooollllllllccccccc:::::.  
48 . .;:::::cccccccllllllloooooooddddddddxxxxxo'.;odc...'''''''''''...ll'...'....'''''''''''''...''''''''..;k0xc,....,,..,lc'...'''''''''''''''''''''''...'oo:..cxxxxxdddddddoooooooolllllllccccccc:::::.  
49 . .;::::ccccccccllllllloooooooddddddddxxxxxo,.,od:...''''''''''...:Ol;c'.'.....''''''''''''.....''''''...cO00kl,..'cl;.'odc'....''''''''''''''''''''...'lo;..oxxxxxdddddddooooooollllllllccccccc:::::'  
50 . .:::::cccccccclllllllooooooodddddddxxxxxxd;.'ld;...''''''''''..'x0o;dl........''''''''''.......''...'...o0000Oo,..oOxc,:dxc'....''''''''''''''''''....co,.'oxxxxxdddddddooooooollllllllcccccccc::::,  
51 . .:::::cccccccclllllllooooooodddddddxxxxxxx:.'co;...'''''''''...l0Kx:dO:........'''''''''........''......'d00000kl''o00koclxxl,....'''''''''''''''''...cl,.,dxxxxxddddddddooooooolllllllcccccccc::::,  
52 . .::::ccccccccccllllloooooooodddddddxxxxxxxc..co;...'''''''''..,k00Oll0k;........'''''''''.........'......'oO00000x:,x0000kddxkd:......'''''''''''''...cl'.;xxxxxxddddddddooooooollllllllccccccc::::,  
53 . .::::ccccccccclllllllooooooodddddddxxxxxxxl..:o;...''''''''...l0000kok0x,.........'''''''.....;c'..........ck00000OllO0OOOOOkxkOxl,......''''''''''...:c..:xxxxxxdddddddoooooooollllllllccccccc::::,  
54 . .:::::cccccccclllllllooooooodddddddxxxxxxko'.;o;...'''''''...;k0000Oxdkko'...;'....''''''.....;kd'....;:....,oO0Okxo:;;,,,,;;:cldkkxc,......'''''''...c:..lxxxxxxdddddddoooooooolllllllcccccccc::::,  
55 . .;::::ccccccccllllllloooooooddddddddxxxxxkd'.;l;...'''''''...lkdlc;,''.''....,l,....'''''......dKxc,..;kkc,...;lxkOd,...........'cdxkOdc,...''''''....c:..oxxxxxxddddddddooooooolllllllccccccc:::::'  
56 . .;:::::cccccccllllllloooooooddddddddxxxxxxd,.,l;...'''''''..'oo'..............,o:.....''''.....:0X0x,..dXX0xl;..:xXx'............dXOk0XXOo,.''''''....:;.'okxxxxxdddddddoooooooollllllcccccccc:::::'  
57 . .;:::::cccccccllllllllooooooddddddddxxxxxxx:.'c:...''''''...oNx'...............cOx,......'......oXNXx,.cKNNNXK0kdodl'..,,'......'dWXOKNXKk;.''..''...':,.,dxxxxxddddddddoooooooollllllcccccccc:::::.  
58 .  ,:::::ccccccccllllllloooooooddddddddxxxxxxc..c:....'''''..'OWx'..,,'......'od'.c00o,...........'dKXXx,,ONNNNNNWMMWKo'.........'lXMWOkXXXk,.'...''...':'.;xxxxxxdddddddoooooooolllllllcccccccc::::;.  
59 .  .:::::ccccccccllllllloooooooddddddddxxxxxxl..:c....'''''..:KMXl...........lXWO:.:0X0o;..........':xXXd;xNNNNXXNMMMMNOl,.....,ckNMMWxoXNXx'.'...''...,:..:xxxxxxdddddddoooooooolllllllcccccccc::::,.  
60 .  .;:::::cccccccllllllllooooooodddddddxxxxxxl..;c'...'''''..lNMMNkc,.....,ckNMMMXl.;kXXKxc,.........'dXKddXNNNN00WMMMMMWXOkkkOKNMMMWOcdXNXd......''...,:..cxxxxxxdddddddooooooollllllllccccccc:::::'   
61 .   ,:::::ccccccccllllllloooooooddddddddxxxxxo'.;c'.....'''..lNMMMMNKOxxxOKNMMMMW0loocxKNXX0xc;........oK0OXNNNNXOx0NMMMMMMMMMMMMWXOl;l0NNKl......''...,;..lxxxxxdddddddoooooooolllllllcccccccc::::;.   
62 .   .:::::cccccccclllllllooooooooddddddddxxxxd,.,c,.....'.'..lxkKWMMMMMMMMMMMWX0d:dKNKO0NNNNXXKkdc;'....cOXXNNNNNXOddddxxkkOOkxxdl::lxKNNN0:......''...;;.'oxxxxddddddddooooooolllllllccccccccc::::,    
63 .   .,::::ccccccccllllllllloooooooddddddddxxxd;.'c,..........o0xooddxxkkxxdolc::lkXNNNNNNNNNNNNNNXX0Okdocd0NNNNNNNNNKOxdoolllooodxOKXNNNNNO,.';...'....;,.,dxxxddddddddoooooooolllllllccccccccc::::.    
64 .    ':::::cccccccclllllllloooooooddddddddxxxx:..c;..........oXNXKOxdoolllloodk0XNNNNNNNNNNNNNNNNNNNNNNNNXXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXd..:c...'....;'.;dxxxdddddddoooooooollllllllcccccccc::::,.    
65 .    .;:::::cccccccllllllllooooooooddddddddxxxc..::..........oXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNKc.;xc...'...';..:dxxddddddddooooooollllllllcccccccc:::::.     
66 .     .::::::ccccccclllllllloooooooodddddddddxl..;:..........cKNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNKkxxxk0XNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNO;:Ok,.......';..cxdddddddddoooooooollllllllcccccccc::::,      
67 .     .,:::::ccccccccllllllllooooooooddddddddxo'.;c'.........,ONNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNK00KK0KXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN0OKKd........,;..lxddddddddoooooooollllllllcccccccc::::;.      
68 .      .;:::::cccccccclllllllloooooooodddddddxo,.,c,.......;c,oXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXO:........;;.'oxdddddddoooooooollllllllcccccccc:::::'       
69 .       .:::::ccccccccclllllllloooooooodddddddd;.'c;..''...'dxoOXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXKx'........;,.,odddddddoooooooollllllllccccccccc::::,.       
70 .        ':::::cccccccclllllllllooooooooddddddd:..::..,:....,xKKXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNX0c.........:'.;dddddddoooooooollllllllccccccccc::::;.        
71 .        .,:::::cccccccclllllllllooooooooodddddc..::..'l;....'dKNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNX0o'........':..:ddddddoooooooollllllllccccccccc::::;.         
72 .         .,:::::ccccccccllllllllloooooooooddddc..;c'..lo,.....:kXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNKd;......,,..,:..cddddooooooooollllllllccccccccc:::::.          
73 .          .;:::::cccccccccllllllllloooooooodddl'.,c,..:xo,......:d0XNNNNNNNNNNNNNNNNNNNNNNNNNXXXXKKKKXXXNNNNNNNNNNNNNNNNNNNNNNNNNNNNX0d;.......;o;..;;..cdddooooooooollllllllccccccccc:::::.           
74 .           .;:::::ccccccccclllllllllooooooooodo,.,c;..;dxo,..,c:'.'cx0XNNNNNNNNNNNNNNNNNNNNNK0OkxxxxxkkOOOO00KXNNNNNNNNNNNNNNNNNNX0d:'.,;'....:do,..:;.'ldooooooooolllllllllccccccccc:::::'            
75 .            .;::::ccccccccccllllllllloooooooodo;.'c:..,oxxo;..;ddl:,.,cx0XNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXXXKKKXNNNNNNNNNNNNNNNX0dc'.,:ldc...'ldxl'.':,.,looooooooolllllllllcccccccccc:::;.             
76 .             .,:::::ccccccccclllllllllooooooooo;..cc'.'lxdddc'.:dxxxoc,'':dOXNNNXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNKko:'',codxxo'..:odddc..,:'.,oooooooollllllllllcccccccc:::::;.              
77 .              .,:::::cccccccccclllllllllooooooo:..:c,..:ddddxo:':dxxxxxdl;,';cxOKNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXOdc;,,:ldxxxxxd;.;lddddd;..;:..;oooooollllllllllccccccccc:::::;.               
78 .                ';::::cccccccccccllllllllloooooc..;l;..;oddddddo:ldxxxxxxxxol:,;:cdk0XNNNNNNNNNNNNNNNNNNNNNNNNNNNNX0kdl:;;:ldxxxxxxxxdl:lddddddo,..::..:ooooolllllllllcccccccccc:::::,.                
79 .                 .;:::::cccccccccccllllllllllooc'.,l:..,oddddddddddxxxxxxxxxxxxdoc:::cloxk0KXNNNNNNNNNNNNNXXK0kxolc:::codxxxxxxxxxxddddddddddddl'..::..cooollllllllllcccccccccc:::::'                  
80 .                  .,::::::ccccccccccllllllllllol'.,lc..'cddddddddddddxxxxxxxxxxxxxxxddlccclloddxxkkOOkkxxddollcclldxxxxxxxxxxxxxdddddddddddddddc..'c;.'collllllllllcccccccccc:::::;.                   
81 .                    ';:::::cccccccccclllllllllll,.'cl,..:ododddddddddddddddxxxxxxxxxxxxxxxxxxxddddddxxdddxxxxxxxxxxxxxxxxxxxxddddddddddddddoooo;..,c,.'clllllllllcccccccccc::::::,.                    
82 .                     .,:::::ccccccccccllllllllll;..cl;..;ooooodddddddddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdddddddddddddddddooooool,..;c'.,lllllllllcccccccccc:::::;.                      
83 .                       .;::::::cccccccccccllllll;..:o:..,loooooooodddddddddddddddddddddxxxxxxxxxxxxxxxxxxxxxxxdddddddddddddddddddddddoooooooooc'..:c..;llllllccccccccccc::::::'.                       
84 .                        .';:::::ccccccccccccclll:..;lc'..cooooooooooooddddddddddddddddddddddddddddddddddddddddddddddddddddddddddoooooooooooooo:..'c:..;llllccccccccccc::::::,.                         
85 .                          .':::::::cccccccccccll:..,ll,..:oooooooooooooooooodddddddddddddddddddddddddddddddddddddddddddddddooooooooooooooooool;..,l;..:lccccccccccccc:::::;.                           
86 .                            .,:::::::cccccccccclc'.,lo;..,llllooooooooooooooooooodddddddddddddddddddddddddddddddddddddoooooooooooooooooollllll,..;l,..:lcccccccccc::::::;.                             
87 .                              .,:::::::cccccccccc'.'coc..'cllllllooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooolllllllllc'..cl,.':ccccccccc::::::;.                               
88 .                                .';::::::cccccccc,.':c,...:lllllllllllooooooooooooooooooooooooooooooooooooooooooooooooooooooooollllllllllllll;...:c'.'cccccccc::::::,.                                 
89 .                                  .';::::::cccccc;......',:lllllllllllllllllooooooooooooooooooooooooooooooooooooooooooooooolllllllllllllllllc;....'..,ccccc::::::;,.                                   
90 .                                     .,:::::::c:c;..',;:cccccllllllllllllllllllllllloooooooooooooooooooooooooooooolllllllllllllllllllllllclcccc:;,'..,cc:::::::;'.                                     
91 .                                       .';::::::::;:ccccccccccccccllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllccccccccccccccc:;:::::::;,.                                        
92 .                                          .';:::::::cccccccccccccccccccllllllllllllllllllllllllllllllllllllllllllllllllllllllllllccccccccccccccc:cc:::::::,..                                          
93 .                                             .';:::::::::ccccccccccccccccccccclllllllllllllllllllllllllllllllllllllllllllccccccccccccccccccccc::::::::;,..                                             
94 .                                                .',;:::::::::cccccccccccccccccccccccccllllllllllllllllllllllllllllcccccccccccccccccccccccc:::::::::;'..                                                
95 .                                                   ..';:::::::::ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc::::::::::;,..                                                    
96 .                                                       ..';::::::::::::cccccccccccccccccccccccccccccccccccccccccccccccccccccccc::c:::::::::;,'..                                                       
97 .                                                           ..',;::::::::::::::cccccccccccccccccccccccccccccccccccccccccc::::::::::::::;,'..                                                            
98 .                                                                ...',;:::::::::::::::::::::ccccccccccccccccccc::::::::::::::::::;;,'...                                                                
99 .                                                                      ...',,;::::::::::::::::::::::::::::::::::::::::::::;;,'....                                                                      
100 .                                                                             .....'',,,;;;::::::::::::::::::;;;;,,''.....                                                                              
101 .                                                                                          ..................                                                                                           
102 .                                                                                                                                                                                                       
103 
104 */
105 
106 
107 
108 pragma solidity ^0.8.4;
109 
110 abstract contract Context {
111     function _msgSender() internal view virtual returns (address) {
112         return msg.sender;
113     }
114 }
115 
116 interface IERC20 {
117     function totalSupply() external view returns (uint256);
118     function balanceOf(address account) external view returns (uint256);
119     function transfer(address recipient, uint256 amount) external returns (bool);
120     function allowance(address owner, address spender) external view returns (uint256);
121     function approve(address spender, uint256 amount) external returns (bool);
122     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
123     event Transfer(address indexed from, address indexed to, uint256 value);
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 library SafeMath {
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131         return c;
132     }
133 
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return sub(a, b, "SafeMath: subtraction overflow");
136     }
137 
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141         return c;
142     }
143 
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         if (a == 0) {
146             return 0;
147         }
148         uint256 c = a * b;
149         require(c / a == b, "SafeMath: multiplication overflow");
150         return c;
151     }
152 
153     function div(uint256 a, uint256 b) internal pure returns (uint256) {
154         return div(a, b, "SafeMath: division by zero");
155     }
156 
157     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b > 0, errorMessage);
159         uint256 c = a / b;
160         return c;
161     }
162 
163 }
164 
165 contract Ownable is Context {
166     address private _owner;
167     address private _previousOwner;
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     constructor () {
171         address msgSender = _msgSender();
172         _owner = msgSender;
173         emit OwnershipTransferred(address(0), msgSender);
174     }
175 
176     function owner() public view returns (address) {
177         return _owner;
178     }
179 
180     modifier onlyOwner() {
181         require(_owner == _msgSender(), "Ownable: caller is not the owner");
182         _;
183     }
184 
185     function renounceOwnership() public virtual onlyOwner {
186         emit OwnershipTransferred(_owner, address(0));
187         _owner = address(0);
188     }
189 
190 }  
191 
192 interface IUniswapV2Factory {
193     function createPair(address tokenA, address tokenB) external returns (address pair);
194 }
195 
196 interface IUniswapV2Router02 {
197     function swapExactTokensForETHSupportingFeeOnTransferTokens(
198         uint amountIn,
199         uint amountOutMin,
200         address[] calldata path,
201         address to,
202         uint deadline
203     ) external;
204     function factory() external pure returns (address);
205     function WETH() external pure returns (address);
206     function addLiquidityETH(
207         address token,
208         uint amountTokenDesired,
209         uint amountTokenMin,
210         uint amountETHMin,
211         address to,
212         uint deadline
213     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
214 }
215 
216 contract LInu is Context, IERC20, Ownable {
217     using SafeMath for uint256;
218     mapping (address => uint256) private _rOwned;
219     mapping (address => uint256) private _tOwned;
220     mapping (address => mapping (address => uint256)) private _allowances;
221     mapping (address => bool) private _isExcludedFromFee;
222     mapping (address => bool) private bots;
223     mapping (address => uint) private cooldown;
224     uint256 private constant MAX = ~uint256(0);
225     uint256 private constant _tTotal = 1e12 * 10**9;
226     uint256 private _rTotal = (MAX - (MAX % _tTotal));
227     uint256 private _tFeeTotal;
228     
229     uint256 private _feeAddr1;
230     uint256 private _feeAddr2;
231     address payable private _feeAddrWallet1;
232     address payable private _feeAddrWallet2;
233     
234     string private constant _name = "L Inu";
235     string private constant _symbol = "L";
236     uint8 private constant _decimals = 9;
237     
238     IUniswapV2Router02 private uniswapV2Router;
239     address private uniswapV2Pair;
240     bool private tradingOpen;
241     bool private inSwap = false;
242     bool private swapEnabled = false;
243     bool private cooldownEnabled = false;
244     uint256 private _maxTxAmount = _tTotal;
245     event MaxTxAmountUpdated(uint _maxTxAmount);
246     modifier lockTheSwap {
247         inSwap = true;
248         _;
249         inSwap = false;
250     }
251     constructor () {
252         _feeAddrWallet1 = payable(0xB7bC74793768A2C7aa6c4872B9C5F3497B5F0652);
253         _feeAddrWallet2 = payable(0xB7bC74793768A2C7aa6c4872B9C5F3497B5F0652);
254         _rOwned[_msgSender()] = _rTotal;
255         _isExcludedFromFee[owner()] = true;
256         _isExcludedFromFee[address(this)] = true;
257         _isExcludedFromFee[_feeAddrWallet1] = true;
258         _isExcludedFromFee[_feeAddrWallet2] = true;
259         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
260     }
261 
262     function name() public pure returns (string memory) {
263         return _name;
264     }
265 
266     function symbol() public pure returns (string memory) {
267         return _symbol;
268     }
269 
270     function decimals() public pure returns (uint8) {
271         return _decimals;
272     }
273 
274     function totalSupply() public pure override returns (uint256) {
275         return _tTotal;
276     }
277 
278     function balanceOf(address account) public view override returns (uint256) {
279         return tokenFromReflection(_rOwned[account]);
280     }
281 
282     function transfer(address recipient, uint256 amount) public override returns (bool) {
283         _transfer(_msgSender(), recipient, amount);
284         return true;
285     }
286 
287     function allowance(address owner, address spender) public view override returns (uint256) {
288         return _allowances[owner][spender];
289     }
290 
291     function approve(address spender, uint256 amount) public override returns (bool) {
292         _approve(_msgSender(), spender, amount);
293         return true;
294     }
295 
296     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
297         _transfer(sender, recipient, amount);
298         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
299         return true;
300     }
301 
302     function setCooldownEnabled(bool onoff) external onlyOwner() {
303         cooldownEnabled = onoff;
304     }
305 
306     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
307         require(rAmount <= _rTotal, "Amount must be less than total reflections");
308         uint256 currentRate =  _getRate();
309         return rAmount.div(currentRate);
310     }
311 
312     function _approve(address owner, address spender, uint256 amount) private {
313         require(owner != address(0), "ERC20: approve from the zero address");
314         require(spender != address(0), "ERC20: approve to the zero address");
315         _allowances[owner][spender] = amount;
316         emit Approval(owner, spender, amount);
317     }
318 
319     function _transfer(address from, address to, uint256 amount) private {
320         require(from != address(0), "ERC20: transfer from the zero address");
321         require(to != address(0), "ERC20: transfer to the zero address");
322         require(amount > 0, "Transfer amount must be greater than zero");
323         _feeAddr1 = 2;
324         _feeAddr2 = 8;
325 
326        
327         if (from != owner() && to != owner()) {
328             require(!bots[from] && !bots[to]);
329             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
330                 // Cooldown
331                 require(amount <= _maxTxAmount);
332                 require(cooldown[to] < block.timestamp);
333                 cooldown[to] = block.timestamp + (30 seconds);
334             }
335             
336             
337             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
338                 _feeAddr1 = 2;
339                 _feeAddr2 = 10;
340             }
341             uint256 contractTokenBalance = balanceOf(address(this));
342             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
343                 swapTokensForEth(contractTokenBalance);
344                 uint256 contractETHBalance = address(this).balance;
345                 if(contractETHBalance > 0) {
346                     sendETHToFee(address(this).balance);
347                 }
348             }
349         }
350 
351         _tokenTransfer(from,to,amount);
352     }
353 
354     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
355         address[] memory path = new address[](2);
356         path[0] = address(this);
357         path[1] = uniswapV2Router.WETH();
358         _approve(address(this), address(uniswapV2Router), tokenAmount);
359         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
360             tokenAmount,
361             0,
362             path,
363             address(this),
364             block.timestamp
365         );
366     }
367         
368     function sendETHToFee(uint256 amount) private {
369         _feeAddrWallet1.transfer(amount.div(2));
370         _feeAddrWallet2.transfer(amount.div(2));
371     }
372     
373     function oopenTrading() external onlyOwner() {
374         require(!tradingOpen,"trading is already open");
375         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
376         uniswapV2Router = _uniswapV2Router;
377         _approve(address(this), address(uniswapV2Router), _tTotal);
378         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
379         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
380         swapEnabled = true;
381         cooldownEnabled = true;
382         _maxTxAmount = 5e9 * 10**9;
383         tradingOpen = true;
384         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
385     }
386     
387     function setBots(address[] memory bots_) public onlyOwner {
388         for (uint i = 0; i < bots_.length; i++) {
389             bots[bots_[i]] = true;
390         }
391     }
392     
393     function removeStrictTxLimit() public onlyOwner {
394         _maxTxAmount = 1e12 * 10**9;
395     }
396     
397     function delBot(address notbot) public onlyOwner {
398         bots[notbot] = false;
399     }
400         
401     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
402         _transferStandard(sender, recipient, amount);
403     }
404 
405     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
406         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
407         _rOwned[sender] = _rOwned[sender].sub(rAmount);
408         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
409         _takeTeam(tTeam);
410         _reflectFee(rFee, tFee);
411         emit Transfer(sender, recipient, tTransferAmount);
412     }
413 
414     function _takeTeam(uint256 tTeam) private {
415         uint256 currentRate =  _getRate();
416         uint256 rTeam = tTeam.mul(currentRate);
417         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
418     }
419 
420     function _reflectFee(uint256 rFee, uint256 tFee) private {
421         _rTotal = _rTotal.sub(rFee);
422         _tFeeTotal = _tFeeTotal.add(tFee);
423     }
424 
425     receive() external payable {}
426     
427     function manualswap() external {
428         require(_msgSender() == _feeAddrWallet1);
429         uint256 contractBalance = balanceOf(address(this));
430         swapTokensForEth(contractBalance);
431     }
432     
433     function manualsend() external {
434         require(_msgSender() == _feeAddrWallet1);
435         uint256 contractETHBalance = address(this).balance;
436         sendETHToFee(contractETHBalance);
437     }
438     
439 
440     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
441         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
442         uint256 currentRate =  _getRate();
443         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
444         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
445     }
446 
447     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
448         uint256 tFee = tAmount.mul(taxFee).div(100);
449         uint256 tTeam = tAmount.mul(TeamFee).div(100);
450         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
451         return (tTransferAmount, tFee, tTeam);
452     }
453 
454     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
455         uint256 rAmount = tAmount.mul(currentRate);
456         uint256 rFee = tFee.mul(currentRate);
457         uint256 rTeam = tTeam.mul(currentRate);
458         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
459         return (rAmount, rTransferAmount, rFee);
460     }
461 
462 	function _getRate() private view returns(uint256) {
463         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
464         return rSupply.div(tSupply);
465     }
466 
467     function _getCurrentSupply() private view returns(uint256, uint256) {
468         uint256 rSupply = _rTotal;
469         uint256 tSupply = _tTotal;      
470         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
471         return (rSupply, tSupply);
472     }
473 }