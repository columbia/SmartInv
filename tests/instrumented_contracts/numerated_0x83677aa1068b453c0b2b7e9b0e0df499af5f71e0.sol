1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /* ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
11  ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
12 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#@@@#/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
13 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@@@@@@@&@&%%@@@@@@@@@@@(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
14 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@%%%%@@@%%%            @@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
15 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@@@@@@%%%%%%%%%@.               ,@@@@@@@/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
16 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#@@@@&@@%%%%%%*   @%             (@%%%%%%%%%&@@&,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
17 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@%%%#                                   #%%%@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
18 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@%%%%                                    %% %%%@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
19 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@@/,,,,,,@%@@%%*    @@@@@@@@,,          ...*#     ./%%%%%%@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
20 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@@@@%%%%%&@,##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@(%%%%%&%%@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
21 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@@,@@%%%@&%%@@@@@@@@@@@@@@@%%%%%%%%%%%%&@@@@@@@@@@@@@@@@@@%%@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
22 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@%%%%%%%%%%%% @@@@@@@%%%%%%%%%%%%%%%&@@@%@@@@@&%%@@@&%&@%@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
23 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@%@@@&@@%%%%%%%%(        &@%%@@@@@%@@@%#       #%*(#%%%%%%%%%@@@@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
24 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#@@@@@%%@@%%%%%%%*                                            %%%%%%%%@@@@&%@@@@##@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
25 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@@@@@@&%%%%%%%%.                                                 .%%%%%%..%%%@@@@@@&@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
26 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@%%@%%*%%                                                 (@         @@@@@%%%%&@@@,@@,,@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
27 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/@@@@@@%%%%%                                                      ,&@*@@,    *@@%&@&%%%&@@&@@,@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
28 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@&%%%%.                                               /&@@@*. %@@@@&@@     (@@&@&%&@@@@,@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
29 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@%%%%%%%                                          %   #@@&@#@@@@# ,@%@@@@@@*   (@@@@@&%@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
30 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@%%%%%%%%                   @@                     @#@@@@#####@@@@@%  @@@@@@@@@    (@(@@@%@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
31 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@%%%%%%%%                @@%@(                   .@@@@@########@@@@%% %@@&@@#@@@,    &@%%@@(@@&,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
32 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@%%%%%%%% * %  *((        @@@@            ,@(    @@@@&##########&@@@%%%%@*@@@@%@@@% .%(@@%%&@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
33 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#@&@@@@%%%%%%%@ %%*@&         @%@(       %    &@    (@@@#############@@@%%%%@@&@@@#@@@@@*%%@@@%@@@(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
34 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@&@@@@%%%%%%@@@%%@@%   *%*%* @@@%*    @@@   @@%@@ @@@@@#############@@@%%%%&@%@@@@@@@@@&%%@@@&%@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
35 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#@@%&@&@&%%%%%%@@%%@@%%% %%%%%@@@@@%*   .@&    @&@@% @@@@##############@@@%%%@@@%@@@@ @@(@@%@%@@@%&@@/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
36 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@%&@&@&%%%%%%@@%&@%%%%%%%%%%@@@@&%*  *&@&   (@&@@%@@@@@###############@@%%@@@@%@@@@ @@ @@@%%&@@@&@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
37 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@%&@@@&%%%%%&@@%@@%%%%&@%%%%@@@@&%*  #@@&   &@&@@%@@@@@###############&@%%@@@@&@@@%@@@*@@@@@&%@@&@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
38 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@%&@@@&%%%%%&@@%@@%%%%@@%%%%@@@@%%#  #@@@   @@%@@@@@@@@################@@@@@@%%@@ @@@  @@%@@%%%%@@#@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
39 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@&%%@@@&%%%, (@@%@@%%%%@@%%@@@@@@%%%%%%@@&% .@@&@@@%@@#@################@@@&@@%%@@@@@@  @@@@@%%%%@@,,@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
40 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@&%@@@@@%%*   @@@@@%%%%@@%@@@@@&@&%%%%%@@&%%%@@@@@@%@@#@&################@@@@@@&@%@&%@%%*@%@@%%%@@@@#@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
41 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@&@@%@@@@%%#  @@@@@%%%%&@%@&@&@&@@#%%##@@@%%%@@@@@@%@@#&%#################@@@@@@@&@%@@@%%@%&@@%@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
42 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@%@@@@%%%%  @@@@&%%%%@&@&@&@@%@@%%##&@@@%%&@@@@@%@@######################@@@@@@%%@@@%%@%&@@@@@@@,@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
43 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@%@@@@@%%%%%#@@@@%%%%@@@@@@@@@@@@@@@@@@@@@&@@%@@%%@@####@@@@@@@@@@@@@@@@@@@@@@@%%@@%%@@%&@@@@@@,#@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
44 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@&@@@%@@@@@%%@%%@@@@@%%%@@@@&##@@@@@%%%%@@@@&%@@&@@%&@####@@@&################@@@&%@&%&@%@@@@@@@,,#@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
45 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@%@@@@@@@@@@%@@&@@@@@%%&@@@@###@@@@&%%%&@@@@%&@&@@@%@&##########################@@@%%@@@@@@@@@&(,*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
46 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@,#@@@@@@@@@@@@@##@@&@@@%%@@&####@@@@@%%%@@@@@@@@@@@@@@#############@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
47 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@,,,,@&@@@@@@@#####@@#@@@%&@@%####&@@@@%%%@@@@@###@@@@@@######@@@@@@@,@@@@@@@@@@@@&&#%&@@%%@@@@#%%@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
48 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@,,,@@@&&@@@@&%####%#####@@@@&#####@@@@@@@%@@@@%##@@@#######@@@@@&@@@@@@@@@@@@@@&&@%@@&%%%@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
49 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@%&@@@@%%######@@@@@@@@@@@@@@@@@@#%@@@@@@@###@@@%#####&@@@###((////@@@@@#,,@@%%%%%%@@@@@@@%%@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
50 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@&#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@&##########%%###########         %@@@@@@@@%%%%%%%@@#@@@@%%@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
51 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@&%%@@@@@&@@@@@@@@@@@@@@@%#########%%%%%%##########@@@@@@@@@@@@%%%%%%%%%%%%%@@#@@@%#@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
52 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@&%%%@@@@%%%(####((((@@@@@&&#,/@@##########%@@&%@##########################%%%%%&@%@@#&@@##@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
53 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@%#%##%%%@@@%%%(       ,@@@@@@,,*%#########@&#####@##########################%%%%%%@@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
54 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#@%#@@@&@@@@@%%&@@@@%%%%@@@@@@@@@@@############################################%%%%%%@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
55 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@@@@@@@@@@@%%%%%%%%%%%%%%######################################@@############%%%%@@@  &@,@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
56 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@#####@@@%%%%%%%%%%%%####################################&@@&############%%%&@@@@% (@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
57 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/@###@@@@@%%%%%%%%%%%#############################%%@@@@###############%%%@@@@@@@@  %@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
58 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@@&%@@@@%%%%%%#############@@@@@############@@&#################%%%@@@@@@@@ @  %@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
59 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@&%%@@@@@%%%%#################################################%&@@@@@@@&@@ @@.@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
60 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@&%%@@%@@@@@&%%#############################################@@@@@@@@@@@@@@@@@ %%@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
61 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*@@%%%@@%%@,%@@@@%#######################################@@@@@@@@/,,,@#@@@@@@@%%@@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
62 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@%@@&@&%%@@@@,@@@@&#################################@@@@@@@*,,,,,,,,#@@@@@@@%@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
63 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@%%@@@@@@@,,,,,,,&@@@@@@@@@%##################%@@@@@@@@(,,,,,,,,,,,,,@&@@%&@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
64 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@%%%&@@@#,,,,,,,,,,,#@@@@@@@@@@@&&&&&&&&@@@@@@%@@@@@,,,,,,,,,,,,,,,@&@@&@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
65 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@&%@.@,,,,,,,,,,,,,,,,,,(@@@@@@@@@&&%%%%%%%%%%%@@,,,,,,,,,,,,,,,@@@@@%,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
66 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@,,,,,,,,,,,,,,,,,,(@%%%%%%%%%%%%%%%%%%%%@@#,,,,,,,,,,,,,,,#@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
67 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@ @,,,,,,,,,,,,,,,@@@@&%%%%%%##########%&@(  @&,,,,,,,,,,,,,,,(@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
68 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@@ @,,,,,,,,,,,,,,,@ @@  %@@  (@@@@@@@@@@  %@@@@@@@@@@@#,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
69 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#@@@@@@,,,,,,,,,,&@@@@@@@@&%%@@% ,@% @@   @@* *@@@@@@@@%.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
70 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@,,@#,@@@@@@@@@@@@@@@@@@ @@@@@&##@@@@@@@@@@@@@@@@@@  @  @@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
71 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,//@@@@@@@@@@@@@@@@@@@@@@%      *@@@@@######@@@@@@&         .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/,,,,,,,,,,,,,,,,,,,,,,,,,,,
72 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#&@@@@@@@@@@@@@@@@@@@@@@(((.                    *@@%#@@@@%            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,
73 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%                  @@@@              *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,
74 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@             (@@@@@            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,
75 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    .@@@&         .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%,,,,,,,,,,,,,,,,,,,,,,,,,,
76 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@((@@@@        (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,
77 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*   #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,
78 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@&@@@%@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,
79 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@%%%%%%@&@@&&@@@@@@@@@@@@@@@@@@@@%%%@@@&%%      @@@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,
80 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@%%&%%%@&@@@@@@@@@@@@@@@@@@@@@@@((((@@@@@@@@@@@@@@@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,
81 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%&&&&@&%%%%&@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&&@@@@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,
82 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&&@@@@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,
83 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&&@@@@@@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,
84 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,
85 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,
86 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,
87 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#,,,,,,,,,,,,,,,,,,,,,,,,,,
88 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&%%&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/,,,,,,,,,,,,,,,,,,,,,,,,,,
89 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&%%%&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,
90 */
91 
92 
93 /**
94  * @title Counters
95  * @author Matt Condon (@shrugs)
96  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
97  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
98  *
99  * Include with `using Counters for Counters.Counter;`
100  */
101 library Counters {
102     struct Counter {
103         // This variable should never be directly accessed by users of the library: interactions must be restricted to
104         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
105         // this feature: see https://github.com/ethereum/solidity/issues/4637
106         uint256 _value; // default: 0
107     }
108 
109     function current(Counter storage counter) internal view returns (uint256) {
110         return counter._value;
111     }
112 
113     function increment(Counter storage counter) internal {
114         unchecked {
115             counter._value += 1;
116         }
117     }
118 
119     function decrement(Counter storage counter) internal {
120         uint256 value = counter._value;
121         require(value > 0, "Counter: decrement overflow");
122         unchecked {
123             counter._value = value - 1;
124         }
125     }
126 
127     function reset(Counter storage counter) internal {
128         counter._value = 0;
129     }
130 }
131 
132 // File: @openzeppelin/contracts/utils/Strings.sol
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev String operations.
141  */
142 library Strings {
143     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
144 
145     /**
146      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
147      */
148     function toString(uint256 value) internal pure returns (string memory) {
149         // Inspired by OraclizeAPI's implementation - MIT licence
150         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
151 
152         if (value == 0) {
153             return "0";
154         }
155         uint256 temp = value;
156         uint256 digits;
157         while (temp != 0) {
158             digits++;
159             temp /= 10;
160         }
161         bytes memory buffer = new bytes(digits);
162         while (value != 0) {
163             digits -= 1;
164             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
165             value /= 10;
166         }
167         return string(buffer);
168     }
169 
170     /**
171      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
172      */
173     function toHexString(uint256 value) internal pure returns (string memory) {
174         if (value == 0) {
175             return "0x00";
176         }
177         uint256 temp = value;
178         uint256 length = 0;
179         while (temp != 0) {
180             length++;
181             temp >>= 8;
182         }
183         return toHexString(value, length);
184     }
185 
186     /**
187      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
188      */
189     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
190         bytes memory buffer = new bytes(2 * length + 2);
191         buffer[0] = "0";
192         buffer[1] = "x";
193         for (uint256 i = 2 * length + 1; i > 1; --i) {
194             buffer[i] = _HEX_SYMBOLS[value & 0xf];
195             value >>= 4;
196         }
197         require(value == 0, "Strings: hex length insufficient");
198         return string(buffer);
199     }
200 }
201 
202 // File: @openzeppelin/contracts/utils/Context.sol
203 
204 
205 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
206 
207 pragma solidity ^0.8.0;
208 
209 /**
210  * @dev Provides information about the current execution context, including the
211  * sender of the transaction and its data. While these are generally available
212  * via msg.sender and msg.data, they should not be accessed in such a direct
213  * manner, since when dealing with meta-transactions the account sending and
214  * paying for execution may not be the actual sender (as far as an application
215  * is concerned).
216  *
217  * This contract is only required for intermediate, library-like contracts.
218  */
219 abstract contract Context {
220     function _msgSender() internal view virtual returns (address) {
221         return msg.sender;
222     }
223 
224     function _msgData() internal view virtual returns (bytes calldata) {
225         return msg.data;
226     }
227 }
228 
229 // File: @openzeppelin/contracts/access/Ownable.sol
230 
231 
232 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 
237 /**
238  * @dev Contract module which provides a basic access control mechanism, where
239  * there is an account (an owner) that can be granted exclusive access to
240  * specific functions.
241  *
242  * By default, the owner account will be the one that deploys the contract. This
243  * can later be changed with {transferOwnership}.
244  *
245  * This module is used through inheritance. It will make available the modifier
246  * `onlyOwner`, which can be applied to your functions to restrict their use to
247  * the owner.
248  */
249 abstract contract Ownable is Context {
250     address private _owner;
251 
252     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
253 
254     /**
255      * @dev Initializes the contract setting the deployer as the initial owner.
256      */
257     constructor() {
258         _transferOwnership(_msgSender());
259     }
260 
261     /**
262      * @dev Returns the address of the current owner.
263      */
264     function owner() public view virtual returns (address) {
265         return _owner;
266     }
267 
268     /**
269      * @dev Throws if called by any account other than the owner.
270      */
271     modifier onlyOwner() {
272         require(owner() == _msgSender(), "Ownable: caller is not the owner");
273         _;
274     }
275 
276     /**
277      * @dev Leaves the contract without owner. It will not be possible to call
278      * `onlyOwner` functions anymore. Can only be called by the current owner.
279      *
280      * NOTE: Renouncing ownership will leave the contract without an owner,
281      * thereby removing any functionality that is only available to the owner.
282      */
283     function renounceOwnership() public virtual onlyOwner {
284         _transferOwnership(address(0));
285     }
286 
287     /**
288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
289      * Can only be called by the current owner.
290      */
291     function transferOwnership(address newOwner) public virtual onlyOwner {
292         require(newOwner != address(0), "Ownable: new owner is the zero address");
293         _transferOwnership(newOwner);
294     }
295 
296     /**
297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
298      * Internal function without access restriction.
299      */
300     function _transferOwnership(address newOwner) internal virtual {
301         address oldOwner = _owner;
302         _owner = newOwner;
303         emit OwnershipTransferred(oldOwner, newOwner);
304     }
305 }
306 
307 // File: @openzeppelin/contracts/utils/Address.sol
308 
309 
310 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
311 
312 pragma solidity ^0.8.1;
313 
314 /**
315  * @dev Collection of functions related to the address type
316  */
317 library Address {
318     /**
319      * @dev Returns true if `account` is a contract.
320      *
321      * [IMPORTANT]
322      * ====
323      * It is unsafe to assume that an address for which this function returns
324      * false is an externally-owned account (EOA) and not a contract.
325      *
326      * Among others, `isContract` will return false for the following
327      * types of addresses:
328      *
329      *  - an externally-owned account
330      *  - a contract in construction
331      *  - an address where a contract will be created
332      *  - an address where a contract lived, but was destroyed
333      * ====
334      *
335      * [IMPORTANT]
336      * ====
337      * You shouldn't rely on `isContract` to protect against flash loan attacks!
338      *
339      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
340      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
341      * constructor.
342      * ====
343      */
344     function isContract(address account) internal view returns (bool) {
345         // This method relies on extcodesize/address.code.length, which returns 0
346         // for contracts in construction, since the code is only stored at the end
347         // of the constructor execution.
348 
349         return account.code.length > 0;
350     }
351 
352     /**
353      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
354      * `recipient`, forwarding all available gas and reverting on errors.
355      *
356      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
357      * of certain opcodes, possibly making contracts go over the 2300 gas limit
358      * imposed by `transfer`, making them unable to receive funds via
359      * `transfer`. {sendValue} removes this limitation.
360      *
361      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
362      *
363      * IMPORTANT: because control is transferred to `recipient`, care must be
364      * taken to not create reentrancy vulnerabilities. Consider using
365      * {ReentrancyGuard} or the
366      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
367      */
368     function sendValue(address payable recipient, uint256 amount) internal {
369         require(address(this).balance >= amount, "Address: insufficient balance");
370 
371         (bool success, ) = recipient.call{value: amount}("");
372         require(success, "Address: unable to send value, recipient may have reverted");
373     }
374 
375     /**
376      * @dev Performs a Solidity function call using a low level `call`. A
377      * plain `call` is an unsafe replacement for a function call: use this
378      * function instead.
379      *
380      * If `target` reverts with a revert reason, it is bubbled up by this
381      * function (like regular Solidity function calls).
382      *
383      * Returns the raw returned data. To convert to the expected return value,
384      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
385      *
386      * Requirements:
387      *
388      * - `target` must be a contract.
389      * - calling `target` with `data` must not revert.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionCall(target, data, "Address: low-level call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
399      * `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, 0, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but also transferring `value` wei to `target`.
414      *
415      * Requirements:
416      *
417      * - the calling contract must have an ETH balance of at least `value`.
418      * - the called Solidity function must be `payable`.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(
423         address target,
424         bytes memory data,
425         uint256 value
426     ) internal returns (bytes memory) {
427         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
432      * with `errorMessage` as a fallback revert reason when `target` reverts.
433      *
434      * _Available since v3.1._
435      */
436     function functionCallWithValue(
437         address target,
438         bytes memory data,
439         uint256 value,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         require(address(this).balance >= value, "Address: insufficient balance for call");
443         require(isContract(target), "Address: call to non-contract");
444 
445         (bool success, bytes memory returndata) = target.call{value: value}(data);
446         return verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
456         return functionStaticCall(target, data, "Address: low-level static call failed");
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
461      * but performing a static call.
462      *
463      * _Available since v3.3._
464      */
465     function functionStaticCall(
466         address target,
467         bytes memory data,
468         string memory errorMessage
469     ) internal view returns (bytes memory) {
470         require(isContract(target), "Address: static call to non-contract");
471 
472         (bool success, bytes memory returndata) = target.staticcall(data);
473         return verifyCallResult(success, returndata, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but performing a delegate call.
479      *
480      * _Available since v3.4._
481      */
482     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
483         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
488      * but performing a delegate call.
489      *
490      * _Available since v3.4._
491      */
492     function functionDelegateCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         require(isContract(target), "Address: delegate call to non-contract");
498 
499         (bool success, bytes memory returndata) = target.delegatecall(data);
500         return verifyCallResult(success, returndata, errorMessage);
501     }
502 
503     /**
504      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
505      * revert reason using the provided one.
506      *
507      * _Available since v4.3._
508      */
509     function verifyCallResult(
510         bool success,
511         bytes memory returndata,
512         string memory errorMessage
513     ) internal pure returns (bytes memory) {
514         if (success) {
515             return returndata;
516         } else {
517             // Look for revert reason and bubble it up if present
518             if (returndata.length > 0) {
519                 // The easiest way to bubble the revert reason is using memory via assembly
520 
521                 assembly {
522                     let returndata_size := mload(returndata)
523                     revert(add(32, returndata), returndata_size)
524                 }
525             } else {
526                 revert(errorMessage);
527             }
528         }
529     }
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
533 
534 
535 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @title ERC721 token receiver interface
541  * @dev Interface for any contract that wants to support safeTransfers
542  * from ERC721 asset contracts.
543  */
544 interface IERC721Receiver {
545     /**
546      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
547      * by `operator` from `from`, this function is called.
548      *
549      * It must return its Solidity selector to confirm the token transfer.
550      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
551      *
552      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
553      */
554     function onERC721Received(
555         address operator,
556         address from,
557         uint256 tokenId,
558         bytes calldata data
559     ) external returns (bytes4);
560 }
561 
562 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @dev Interface of the ERC165 standard, as defined in the
571  * https://eips.ethereum.org/EIPS/eip-165[EIP].
572  *
573  * Implementers can declare support of contract interfaces, which can then be
574  * queried by others ({ERC165Checker}).
575  *
576  * For an implementation, see {ERC165}.
577  */
578 interface IERC165 {
579     /**
580      * @dev Returns true if this contract implements the interface defined by
581      * `interfaceId`. See the corresponding
582      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
583      * to learn more about how these ids are created.
584      *
585      * This function call must use less than 30 000 gas.
586      */
587     function supportsInterface(bytes4 interfaceId) external view returns (bool);
588 }
589 
590 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 
598 /**
599  * @dev Implementation of the {IERC165} interface.
600  *
601  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
602  * for the additional interface id that will be supported. For example:
603  *
604  * ```solidity
605  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
606  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
607  * }
608  * ```
609  *
610  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
611  */
612 abstract contract ERC165 is IERC165 {
613     /**
614      * @dev See {IERC165-supportsInterface}.
615      */
616     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
617         return interfaceId == type(IERC165).interfaceId;
618     }
619 }
620 
621 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
622 
623 
624 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 
629 /**
630  * @dev Required interface of an ERC721 compliant contract.
631  */
632 interface IERC721 is IERC165 {
633     /**
634      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
635      */
636     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
637 
638     /**
639      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
640      */
641     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
642 
643     /**
644      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
645      */
646     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
647 
648     /**
649      * @dev Returns the number of tokens in ``owner``'s account.
650      */
651     function balanceOf(address owner) external view returns (uint256 balance);
652 
653     /**
654      * @dev Returns the owner of the `tokenId` token.
655      *
656      * Requirements:
657      *
658      * - `tokenId` must exist.
659      */
660     function ownerOf(uint256 tokenId) external view returns (address owner);
661 
662     /**
663      * @dev Safely transfers `tokenId` token from `from` to `to`.
664      *
665      * Requirements:
666      *
667      * - `from` cannot be the zero address.
668      * - `to` cannot be the zero address.
669      * - `tokenId` token must exist and be owned by `from`.
670      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
671      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
672      *
673      * Emits a {Transfer} event.
674      */
675     function safeTransferFrom(
676         address from,
677         address to,
678         uint256 tokenId,
679         bytes calldata data
680     ) external;
681 
682     /**
683      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
684      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
685      *
686      * Requirements:
687      *
688      * - `from` cannot be the zero address.
689      * - `to` cannot be the zero address.
690      * - `tokenId` token must exist and be owned by `from`.
691      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
692      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
693      *
694      * Emits a {Transfer} event.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 tokenId
700     ) external;
701 
702     /**
703      * @dev Transfers `tokenId` token from `from` to `to`.
704      *
705      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
706      *
707      * Requirements:
708      *
709      * - `from` cannot be the zero address.
710      * - `to` cannot be the zero address.
711      * - `tokenId` token must be owned by `from`.
712      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
713      *
714      * Emits a {Transfer} event.
715      */
716     function transferFrom(
717         address from,
718         address to,
719         uint256 tokenId
720     ) external;
721 
722     /**
723      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
724      * The approval is cleared when the token is transferred.
725      *
726      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
727      *
728      * Requirements:
729      *
730      * - The caller must own the token or be an approved operator.
731      * - `tokenId` must exist.
732      *
733      * Emits an {Approval} event.
734      */
735     function approve(address to, uint256 tokenId) external;
736 
737     /**
738      * @dev Approve or remove `operator` as an operator for the caller.
739      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
740      *
741      * Requirements:
742      *
743      * - The `operator` cannot be the caller.
744      *
745      * Emits an {ApprovalForAll} event.
746      */
747     function setApprovalForAll(address operator, bool _approved) external;
748 
749     /**
750      * @dev Returns the account approved for `tokenId` token.
751      *
752      * Requirements:
753      *
754      * - `tokenId` must exist.
755      */
756     function getApproved(uint256 tokenId) external view returns (address operator);
757 
758     /**
759      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
760      *
761      * See {setApprovalForAll}
762      */
763     function isApprovedForAll(address owner, address operator) external view returns (bool);
764 }
765 
766 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
767 
768 
769 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 
774 /**
775  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
776  * @dev See https://eips.ethereum.org/EIPS/eip-721
777  */
778 interface IERC721Metadata is IERC721 {
779     /**
780      * @dev Returns the token collection name.
781      */
782     function name() external view returns (string memory);
783 
784     /**
785      * @dev Returns the token collection symbol.
786      */
787     function symbol() external view returns (string memory);
788 
789     /**
790      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
791      */
792     function tokenURI(uint256 tokenId) external view returns (string memory);
793 }
794 
795 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
796 
797 
798 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
799 
800 pragma solidity ^0.8.0;
801 
802 
803 
804 
805 
806 
807 
808 
809 /**
810  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
811  * the Metadata extension, but not including the Enumerable extension, which is available separately as
812  * {ERC721Enumerable}.
813  */
814 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
815     using Address for address;
816     using Strings for uint256;
817 
818     // Token name
819     string private _name;
820 
821     // Token symbol
822     string private _symbol;
823 
824     // Mapping from token ID to owner address
825     mapping(uint256 => address) private _owners;
826 
827     // Mapping owner address to token count
828     mapping(address => uint256) private _balances;
829 
830     // Mapping from token ID to approved address
831     mapping(uint256 => address) private _tokenApprovals;
832 
833     // Mapping from owner to operator approvals
834     mapping(address => mapping(address => bool)) private _operatorApprovals;
835 
836     /**
837      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
838      */
839     constructor(string memory name_, string memory symbol_) {
840         _name = name_;
841         _symbol = symbol_;
842     }
843 
844     /**
845      * @dev See {IERC165-supportsInterface}.
846      */
847     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
848         return
849             interfaceId == type(IERC721).interfaceId ||
850             interfaceId == type(IERC721Metadata).interfaceId ||
851             super.supportsInterface(interfaceId);
852     }
853 
854     /**
855      * @dev See {IERC721-balanceOf}.
856      */
857     function balanceOf(address owner) public view virtual override returns (uint256) {
858         require(owner != address(0), "ERC721: balance query for the zero address");
859         return _balances[owner];
860     }
861 
862     /**
863      * @dev See {IERC721-ownerOf}.
864      */
865     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
866         address owner = _owners[tokenId];
867         require(owner != address(0), "ERC721: owner query for nonexistent token");
868         return owner;
869     }
870 
871     /**
872      * @dev See {IERC721Metadata-name}.
873      */
874     function name() public view virtual override returns (string memory) {
875         return _name;
876     }
877 
878     /**
879      * @dev See {IERC721Metadata-symbol}.
880      */
881     function symbol() public view virtual override returns (string memory) {
882         return _symbol;
883     }
884 
885     /**
886      * @dev See {IERC721Metadata-tokenURI}.
887      */
888     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
889         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
890 
891         string memory baseURI = _baseURI();
892         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
893     }
894 
895     /**
896      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
897      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
898      * by default, can be overridden in child contracts.
899      */
900     function _baseURI() internal view virtual returns (string memory) {
901         return "";
902     }
903 
904     /**
905      * @dev See {IERC721-approve}.
906      */
907     function approve(address to, uint256 tokenId) public virtual override {
908         address owner = ERC721.ownerOf(tokenId);
909         require(to != owner, "ERC721: approval to current owner");
910 
911         require(
912             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
913             "ERC721: approve caller is not owner nor approved for all"
914         );
915 
916         _approve(to, tokenId);
917     }
918 
919     /**
920      * @dev See {IERC721-getApproved}.
921      */
922     function getApproved(uint256 tokenId) public view virtual override returns (address) {
923         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
924 
925         return _tokenApprovals[tokenId];
926     }
927 
928     /**
929      * @dev See {IERC721-setApprovalForAll}.
930      */
931     function setApprovalForAll(address operator, bool approved) public virtual override {
932         _setApprovalForAll(_msgSender(), operator, approved);
933     }
934 
935     /**
936      * @dev See {IERC721-isApprovedForAll}.
937      */
938     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
939         return _operatorApprovals[owner][operator];
940     }
941 
942     /**
943      * @dev See {IERC721-transferFrom}.
944      */
945     function transferFrom(
946         address from,
947         address to,
948         uint256 tokenId
949     ) public virtual override {
950         //solhint-disable-next-line max-line-length
951         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
952 
953         _transfer(from, to, tokenId);
954     }
955 
956     /**
957      * @dev See {IERC721-safeTransferFrom}.
958      */
959     function safeTransferFrom(
960         address from,
961         address to,
962         uint256 tokenId
963     ) public virtual override {
964         safeTransferFrom(from, to, tokenId, "");
965     }
966 
967     /**
968      * @dev See {IERC721-safeTransferFrom}.
969      */
970     function safeTransferFrom(
971         address from,
972         address to,
973         uint256 tokenId,
974         bytes memory _data
975     ) public virtual override {
976         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
977         _safeTransfer(from, to, tokenId, _data);
978     }
979 
980     /**
981      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
982      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
983      *
984      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
985      *
986      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
987      * implement alternative mechanisms to perform token transfer, such as signature-based.
988      *
989      * Requirements:
990      *
991      * - `from` cannot be the zero address.
992      * - `to` cannot be the zero address.
993      * - `tokenId` token must exist and be owned by `from`.
994      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _safeTransfer(
999         address from,
1000         address to,
1001         uint256 tokenId,
1002         bytes memory _data
1003     ) internal virtual {
1004         _transfer(from, to, tokenId);
1005         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1006     }
1007 
1008     /**
1009      * @dev Returns whether `tokenId` exists.
1010      *
1011      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1012      *
1013      * Tokens start existing when they are minted (`_mint`),
1014      * and stop existing when they are burned (`_burn`).
1015      */
1016     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1017         return _owners[tokenId] != address(0);
1018     }
1019 
1020     /**
1021      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1022      *
1023      * Requirements:
1024      *
1025      * - `tokenId` must exist.
1026      */
1027     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1028         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1029         address owner = ERC721.ownerOf(tokenId);
1030         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1031     }
1032 
1033     /**
1034      * @dev Safely mints `tokenId` and transfers it to `to`.
1035      *
1036      * Requirements:
1037      *
1038      * - `tokenId` must not exist.
1039      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function _safeMint(address to, uint256 tokenId) internal virtual {
1044         _safeMint(to, tokenId, "");
1045     }
1046 
1047     /**
1048      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1049      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1050      */
1051     function _safeMint(
1052         address to,
1053         uint256 tokenId,
1054         bytes memory _data
1055     ) internal virtual {
1056         _mint(to, tokenId);
1057         require(
1058             _checkOnERC721Received(address(0), to, tokenId, _data),
1059             "ERC721: transfer to non ERC721Receiver implementer"
1060         );
1061     }
1062 
1063     /**
1064      * @dev Mints `tokenId` and transfers it to `to`.
1065      *
1066      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1067      *
1068      * Requirements:
1069      *
1070      * - `tokenId` must not exist.
1071      * - `to` cannot be the zero address.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _mint(address to, uint256 tokenId) internal virtual {
1076         require(to != address(0), "ERC721: mint to the zero address");
1077         require(!_exists(tokenId), "ERC721: token already minted");
1078 
1079         _beforeTokenTransfer(address(0), to, tokenId);
1080 
1081         _balances[to] += 1;
1082         _owners[tokenId] = to;
1083 
1084         emit Transfer(address(0), to, tokenId);
1085 
1086         _afterTokenTransfer(address(0), to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Destroys `tokenId`.
1091      * The approval is cleared when the token is burned.
1092      *
1093      * Requirements:
1094      *
1095      * - `tokenId` must exist.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _burn(uint256 tokenId) internal virtual {
1100         address owner = ERC721.ownerOf(tokenId);
1101 
1102         _beforeTokenTransfer(owner, address(0), tokenId);
1103 
1104         // Clear approvals
1105         _approve(address(0), tokenId);
1106 
1107         _balances[owner] -= 1;
1108         delete _owners[tokenId];
1109 
1110         emit Transfer(owner, address(0), tokenId);
1111 
1112         _afterTokenTransfer(owner, address(0), tokenId);
1113     }
1114 
1115     /**
1116      * @dev Transfers `tokenId` from `from` to `to`.
1117      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1118      *
1119      * Requirements:
1120      *
1121      * - `to` cannot be the zero address.
1122      * - `tokenId` token must be owned by `from`.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _transfer(
1127         address from,
1128         address to,
1129         uint256 tokenId
1130     ) internal virtual {
1131         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1132         require(to != address(0), "ERC721: transfer to the zero address");
1133 
1134         _beforeTokenTransfer(from, to, tokenId);
1135 
1136         // Clear approvals from the previous owner
1137         _approve(address(0), tokenId);
1138 
1139         _balances[from] -= 1;
1140         _balances[to] += 1;
1141         _owners[tokenId] = to;
1142 
1143         emit Transfer(from, to, tokenId);
1144 
1145         _afterTokenTransfer(from, to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev Approve `to` to operate on `tokenId`
1150      *
1151      * Emits a {Approval} event.
1152      */
1153     function _approve(address to, uint256 tokenId) internal virtual {
1154         _tokenApprovals[tokenId] = to;
1155         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1156     }
1157 
1158     /**
1159      * @dev Approve `operator` to operate on all of `owner` tokens
1160      *
1161      * Emits a {ApprovalForAll} event.
1162      */
1163     function _setApprovalForAll(
1164         address owner,
1165         address operator,
1166         bool approved
1167     ) internal virtual {
1168         require(owner != operator, "ERC721: approve to caller");
1169         _operatorApprovals[owner][operator] = approved;
1170         emit ApprovalForAll(owner, operator, approved);
1171     }
1172 
1173     /**
1174      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1175      * The call is not executed if the target address is not a contract.
1176      *
1177      * @param from address representing the previous owner of the given token ID
1178      * @param to target address that will receive the tokens
1179      * @param tokenId uint256 ID of the token to be transferred
1180      * @param _data bytes optional data to send along with the call
1181      * @return bool whether the call correctly returned the expected magic value
1182      */
1183     function _checkOnERC721Received(
1184         address from,
1185         address to,
1186         uint256 tokenId,
1187         bytes memory _data
1188     ) private returns (bool) {
1189         if (to.isContract()) {
1190             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1191                 return retval == IERC721Receiver.onERC721Received.selector;
1192             } catch (bytes memory reason) {
1193                 if (reason.length == 0) {
1194                     revert("ERC721: transfer to non ERC721Receiver implementer");
1195                 } else {
1196                     assembly {
1197                         revert(add(32, reason), mload(reason))
1198                     }
1199                 }
1200             }
1201         } else {
1202             return true;
1203         }
1204     }
1205 
1206     /**
1207      * @dev Hook that is called before any token transfer. This includes minting
1208      * and burning.
1209      *
1210      * Calling conditions:
1211      *
1212      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1213      * transferred to `to`.
1214      * - When `from` is zero, `tokenId` will be minted for `to`.
1215      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1216      * - `from` and `to` are never both zero.
1217      *
1218      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1219      */
1220     function _beforeTokenTransfer(
1221         address from,
1222         address to,
1223         uint256 tokenId
1224     ) internal virtual {}
1225 
1226     /**
1227      * @dev Hook that is called after any transfer of tokens. This includes
1228      * minting and burning.
1229      *
1230      * Calling conditions:
1231      *
1232      * - when `from` and `to` are both non-zero.
1233      * - `from` and `to` are never both zero.
1234      *
1235      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1236      */
1237     function _afterTokenTransfer(
1238         address from,
1239         address to,
1240         uint256 tokenId
1241     ) internal virtual {}
1242 }
1243 
1244 // File: contracts/Mogas.sol
1245 
1246 
1247 
1248 
1249 pragma solidity >=0.7.0 <0.9.0;
1250 
1251 
1252 
1253 
1254 contract Mogas is ERC721, Ownable {
1255   using Strings for uint256;
1256   using Counters for Counters.Counter;
1257 
1258   Counters.Counter private supply;
1259 
1260   string public uriPrefix = "";
1261   string public uriSuffix = ".json";
1262   string public hiddenMetadataUri;
1263   
1264   uint256 public cost = 0 ether;
1265   uint256 public maxSupply = 3333;
1266   uint256 public maxMintAmountPerTx = 1;
1267 
1268   bool public paused = true;
1269   bool public revealed = false;
1270 
1271   constructor() ERC721("Mogas", "MGS") {
1272     setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1273   }
1274 
1275   modifier mintCompliance(uint256 _mintAmount) {
1276     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1277     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1278     _;
1279   }
1280 
1281   function totalSupply() public view returns (uint256) {
1282     return supply.current();
1283   }
1284 
1285   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1286     require(!paused, "The contract is paused!");
1287     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1288 
1289     _mintLoop(msg.sender, _mintAmount);
1290   }
1291   
1292   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1293     _mintLoop(_receiver, _mintAmount);
1294   }
1295 
1296   function walletOfOwner(address _owner)
1297     public
1298     view
1299     returns (uint256[] memory)
1300   {
1301     uint256 ownerTokenCount = balanceOf(_owner);
1302     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1303     uint256 currentTokenId = 1;
1304     uint256 ownedTokenIndex = 0;
1305 
1306     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1307       address currentTokenOwner = ownerOf(currentTokenId);
1308 
1309       if (currentTokenOwner == _owner) {
1310         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1311 
1312         ownedTokenIndex++;
1313       }
1314 
1315       currentTokenId++;
1316     }
1317 
1318     return ownedTokenIds;
1319   }
1320 
1321   function tokenURI(uint256 _tokenId)
1322     public
1323     view
1324     virtual
1325     override
1326     returns (string memory)
1327   {
1328     require(
1329       _exists(_tokenId),
1330       "ERC721Metadata: URI query for nonexistent token"
1331     );
1332 
1333     if (revealed == false) {
1334       return hiddenMetadataUri;
1335     }
1336 
1337     string memory currentBaseURI = _baseURI();
1338     return bytes(currentBaseURI).length > 0
1339         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1340         : "";
1341   }
1342 
1343   function setRevealed(bool _state) public onlyOwner {
1344     revealed = _state;
1345   }
1346 
1347   function setCost(uint256 _cost) public onlyOwner {
1348     cost = _cost;
1349   }
1350 
1351   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1352     maxMintAmountPerTx = _maxMintAmountPerTx;
1353   }
1354 
1355   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1356     hiddenMetadataUri = _hiddenMetadataUri;
1357   }
1358 
1359   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1360     uriPrefix = _uriPrefix;
1361   }
1362 
1363   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1364     uriSuffix = _uriSuffix;
1365   }
1366 
1367   function setPaused(bool _state) public onlyOwner {
1368     paused = _state;
1369   }
1370 
1371   function withdraw() public onlyOwner {
1372     // This will pay HashLips 5% of the initial sale.
1373     // You can remove this if you want, or keep it in to support HashLips and his channel.
1374     // =============================================================================
1375     (bool hs, ) = payable(0x6F2BcAEE254a2B46DeaD5B7347cc33acc3523d0A).call{value: address(this).balance * 5 / 100}("");
1376     require(hs);
1377     // =============================================================================
1378 
1379     // This will transfer the remaining contract balance to the owner.
1380     // Do not remove this otherwise you will not be able to withdraw the funds.
1381     // =============================================================================
1382     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1383     require(os);
1384     // =============================================================================
1385   }
1386 
1387   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1388     for (uint256 i = 0; i < _mintAmount; i++) {
1389       supply.increment();
1390       _safeMint(_receiver, supply.current());
1391     }
1392   }
1393 
1394   function _baseURI() internal view virtual override returns (string memory) {
1395     return uriPrefix;
1396   }
1397 }