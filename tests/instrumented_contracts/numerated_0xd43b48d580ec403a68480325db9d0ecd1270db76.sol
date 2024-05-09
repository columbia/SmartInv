1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5                                                                                                                                                   
6                                                                                                                     ░░░░░░░░░░                    
7                                                                                                               ░░░░░░░░░░░░░░░░░░                  
8                                                                                                           ░░░░░░░░░░░░░░░░▒▒░░░░░░                
9                                                                                                       ░░░░░░░░░░░░░░░░▒▒▒▒▒▒░░░░░░                
10                                                                                                 ░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒░░░░░░              
11                                                                                             ░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░        
12                                                                                         ░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░    
13                                                                                     ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒░░░░░░░░░░  
14                                                                                   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░░░▒▒░░░░░░░░
15                                                                 ░░░░▒▒▒▒▒▒░░▒▒▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒░░░░
16                                                           ▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▒▒▒░░░░  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒░░░░░░░░
17                                                         ▒▒▓▓▓▓▒▒▒▒▓▓██▓▓██████▓▓▓▓▒▒  ░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░
18                                                 ░░░░░░░░▒▒▓▓▒▒████████░░████████▓▓▓▓▓▓▒▒  ░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░
19                                           ░░░░░░░░░░░░▒▒▒▒▒▒██▒▒▓▓▓▓██▓▓████▓▓▓▓▓▓▓▓▓▓▓▓▒▒  ░░▒▒▒▒░░▒▒▒▒░░░░░░░░▒▒░░▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░
20                                       ░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒████▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▒▒░░▒▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒
21                                 ░░░░░░░░░░░░░░▒▒▒▒▒▒░░░░▓▓██▓▓██▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▓▓░░  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒
22                           ░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒    ▓▓████▓▓▓▓▓▓▓▓▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓▒▒  ░░▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒
23                       ░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒    ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░  ▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒
24                 ░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ░░▓▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒  ░░▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
25           ░░░░░░░░░░░░░░░░░░▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ░░▓▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒  ░░▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
26 ░░░░░░░░░░░░░░▒▒░░░░░░░░▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒  ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
27 ░░░░░░░░░░░░░░░░▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓    ▓▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒  ▒▒▓▓▓▓▓▓▓▓▓▓▒▒    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
28 ░░░░░░░░░░░░▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▒▒▓▓▓▓▒▒  ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
29 ░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓░░  ░░██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒  ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
30 ░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓  ▒▒██▓▓░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
31 ░░▒▒▒▒▒▒░░▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒▓▓░░▒▒▓▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▒▒▓▓▒▒    ▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
32 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░▓▓▓▓    ▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
33 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓░░▓▓▓▓  ▓▓▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▓▒▒    ░░▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
34 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░▓▓▓▓▓▓▓▓░░▓▓▓▓▓▓░░    ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
35 ░░▒▒▒▒▒▒▒▒░░░░▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓████▒▒▒▒▓▓▓▓░░▒▒▒▒▓▓██░░░░  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
36 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░▓▓▓▓▒▒▓▓▓▓▓▓▓▓██████░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
37 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓██▒▒▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
38 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▒▒▒▒████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
39 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓██████████▓▓▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
40 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▒░░  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
41 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▒▒▓▓▒▒░░░░░░░░░░▒▒██░░  ▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
42 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓██░░░░▓▓▓▓▓▓▒▒▒▒░░░░▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
43 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓░░░░░░░░░░░░░░▒▒░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒
44 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒░░░░░░▒▒▒▒▓▓▒▒░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓
45 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒▓▓▓▓▓▓▓▓▒▒▒▒▓▓▒▒▓▓▓▓▓▓▓▓░░░░▒▒▓▓▓▓▒▒░░░░░░▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓
46 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓░░░░░░░░  ░░░░▒▒    ▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓
47 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒░░  ░░░░░░░░▓▓░░░░          ░░▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
48 ▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░                                  ▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
49 ▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▒▒▒▒▒▒▒▒░░░░                                          ░░▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
50 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒░░                                                      ░░▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
51 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒                                                                  ░░▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▓▓▓
52 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒                                                                            ░░▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
53 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒                                                                                        ░░  ░░                    
54 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒░░                                                                                                                      
55 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒                                                                                                                          
56 ▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒                                                                                                                              
57 ▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒░░                                                                                                                                
58 ▓▓▓▓▓▓▓▓▒▒▒▒░░                                                                                                                                    
59 ▓▓▒▒▒▒▒▒▒▒                                                                                                                                        
60 ▒▒▒▒▒▒░░                                                                                                                                          
61 
62 
63 Decadence, Craftsmanship, and Luxury.
64 
65 The one and only : 
66 GucciRolexLamborghini1000000Inu | $MONERO
67 
68 Website : https://www.guccirolexlambo.com/
69 Telegram : https://t.me/guccirolexlambo
70 Twitter : https://twitter.com/guccirolexlambo
71 
72 Created with love, by @FDASHO on telegram.
73 
74 */
75 
76 
77 pragma solidity 0.8.20;
78 
79 abstract contract Context {
80     function _msgSender() internal view virtual returns (address) {
81         return msg.sender;
82     }
83 }
84 
85 interface IERC20 {
86     function totalSupply() external view returns (uint256);
87     function balanceOf(address account) external view returns (uint256);
88     function transfer(address recipient, uint256 amount) external returns (bool);
89     function allowance(address owner, address spender) external view returns (uint256);
90     function approve(address spender, uint256 amount) external returns (bool);
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92     event Transfer(address indexed from, address indexed to, uint256 value);
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 library SafeMath {
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         uint256 c = a + b;
99         require(c >= a, "SafeMath: addition overflow");
100         return c;
101     }
102 
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         return sub(a, b, "SafeMath: subtraction overflow");
105     }
106 
107     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
108         require(b <= a, errorMessage);
109         uint256 c = a - b;
110         return c;
111     }
112 
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         if (a == 0) {
115             return 0;
116         }
117         uint256 c = a * b;
118         require(c / a == b, "SafeMath: multiplication overflow");
119         return c;
120     }
121 
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         return div(a, b, "SafeMath: division by zero");
124     }
125 
126     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         require(b > 0, errorMessage);
128         uint256 c = a / b;
129         return c;
130     }
131 
132 }
133 
134 contract Ownable is Context {
135     address private _owner;
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     constructor () {
139         address msgSender = _msgSender();
140         _owner = msgSender;
141         emit OwnershipTransferred(address(0), msgSender);
142     }
143 
144     function owner() public view returns (address) {
145         return _owner;
146     }
147 
148     modifier onlyOwner() {
149         require(_owner == _msgSender(), "Ownable: caller is not the owner");
150         _;
151     }
152 
153     function renounceOwnership() public virtual onlyOwner {
154         emit OwnershipTransferred(_owner, address(0));
155         _owner = address(0);
156     }
157 
158 }
159 
160 interface IUniswapV2Factory {
161     function createPair(address tokenA, address tokenB) external returns (address pair);
162 }
163 
164 interface IUniswapV2Router02 {
165     function swapExactTokensForETHSupportingFeeOnTransferTokens(
166         uint amountIn,
167         uint amountOutMin,
168         address[] calldata path,
169         address to,
170         uint deadline
171     ) external;
172     function factory() external pure returns (address);
173     function WETH() external pure returns (address);
174     function addLiquidityETH(
175         address token,
176         uint amountTokenDesired,
177         uint amountTokenMin,
178         uint amountETHMin,
179         address to,
180         uint deadline
181     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
182 }
183 
184 contract GucciRolexLamborghini1000000Inu is Context, IERC20, Ownable {
185     using SafeMath for uint256;
186     mapping (address => uint256) private _balances;
187     mapping (address => mapping (address => uint256)) private _allowances;
188     mapping (address => bool) private _isExcludedFromFee;
189     address payable private _taxWallet; // Marketing Wallet
190     address payable private _teamWallet; // Team Wallet
191     uint256 private _taxWalletPercentage = 75; // 75%
192     uint256 private _teamWalletPercentage = 25; // 25%
193 
194     uint256 firstBlock;
195 
196     uint256 private _initialBuyTax=20;
197     uint256 private _initialSellTax=20;
198     uint256 private _finalBuyTax=2;
199     uint256 private _finalSellTax=2;
200     uint256 private _reduceBuyTaxAt=25;
201     uint256 private _reduceSellTaxAt=25;
202     uint256 private _preventSwapBefore=25;
203     uint256 private _buyCount=0;
204 
205     uint8 private constant _decimals = 9;
206     uint256 private constant _tTotal = 1000000 * 10**_decimals;
207     string private constant _name = unicode"GucciRolexLamborghini1000000Inu";
208     string private constant _symbol = unicode"MONERO";
209     uint256 public _maxTxAmount =   10000 * 10**_decimals;
210     uint256 public _maxWalletSize = 10000 * 10**_decimals;
211     uint256 public _taxSwapThreshold= 10000 * 10**_decimals;
212     uint256 public _maxTaxSwap= 10000 * 10**_decimals;
213 
214     IUniswapV2Router02 private uniswapV2Router;
215     address private uniswapV2Pair;
216     bool private tradingOpen;
217     bool private inSwap = false;
218     bool private swapEnabled = false;
219 
220     event MaxTxAmountUpdated(uint _maxTxAmount);
221     event ClearStuck(uint256 amount);
222     event ClearToken(address TokenAddressCleared, uint256 Amount);
223     modifier lockTheSwap {
224         inSwap = true;
225         _;
226         inSwap = false;
227     }
228 
229     constructor () {
230 
231         _taxWallet = payable(_msgSender());
232         _teamWallet = payable(0x5b8FCc8a06687CB03e2B1F9A0A50B466a8307b91);
233         _balances[_msgSender()] = _tTotal;
234         _isExcludedFromFee[owner()] = true;
235         _isExcludedFromFee[address(this)] = true;
236         _isExcludedFromFee[_taxWallet] = true;
237         
238         emit Transfer(address(0), _msgSender(), _tTotal);
239     }
240 
241     function name() public pure returns (string memory) {
242         return _name;
243     }
244 
245     function symbol() public pure returns (string memory) {
246         return _symbol;
247     }
248 
249     function decimals() public pure returns (uint8) {
250         return _decimals;
251     }
252 
253     function totalSupply() public pure override returns (uint256) {
254         return _tTotal;
255     }
256 
257     function balanceOf(address account) public view override returns (uint256) {
258         return _balances[account];
259     }
260 
261     function transfer(address recipient, uint256 amount) public override returns (bool) {
262         _transfer(_msgSender(), recipient, amount);
263         return true;
264     }
265 
266     function allowance(address owner, address spender) public view override returns (uint256) {
267         return _allowances[owner][spender];
268     }
269 
270     function approve(address spender, uint256 amount) public override returns (bool) {
271         _approve(_msgSender(), spender, amount);
272         return true;
273     }
274 
275     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
276         _transfer(sender, recipient, amount);
277         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
278         return true;
279     }
280 
281     function _approve(address owner, address spender, uint256 amount) private {
282         require(owner != address(0), "ERC20: approve from the zero address");
283         require(spender != address(0), "ERC20: approve to the zero address");
284         _allowances[owner][spender] = amount;
285         emit Approval(owner, spender, amount);
286     }
287 
288     function _transfer(address from, address to, uint256 amount) private {
289         require(from != address(0), "ERC20: transfer from the zero address");
290         require(to != address(0), "ERC20: transfer to the zero address");
291         require(amount > 0, "Transfer amount must be greater than zero");
292         uint256 taxAmount=0;
293         if (from != owner() && to != owner()) {
294             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
295 
296             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
297                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
298                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
299 
300                 if (firstBlock + 3  > block.number) {
301                     require(!isContract(to));
302                 }
303                 _buyCount++;
304             }
305 
306             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
307                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
308             }
309 
310             if(to == uniswapV2Pair && from!= address(this) ){
311                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
312             }
313 
314             uint256 contractTokenBalance = balanceOf(address(this));
315             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
316                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
317                 uint256 contractETHBalance = address(this).balance;
318                 if(contractETHBalance > 0) {
319                     sendETHToFee(address(this).balance);
320                 }
321             }
322         }
323 
324         if(taxAmount>0){
325           _balances[address(this)]=_balances[address(this)].add(taxAmount);
326           emit Transfer(from, address(this),taxAmount);
327         }
328         _balances[from]=_balances[from].sub(amount);
329         _balances[to]=_balances[to].add(amount.sub(taxAmount));
330         emit Transfer(from, to, amount.sub(taxAmount));
331     }
332 
333 
334     function min(uint256 a, uint256 b) private pure returns (uint256){
335       return (a>b)?b:a;
336     }
337 
338     function isContract(address account) private view returns (bool) {
339         uint256 size;
340         assembly {
341             size := extcodesize(account)
342         }
343         return size > 0;
344     }
345 
346     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
347         address[] memory path = new address[](2);
348         path[0] = address(this);
349         path[1] = uniswapV2Router.WETH();
350         _approve(address(this), address(uniswapV2Router), tokenAmount);
351         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
352             tokenAmount,
353             0,
354             path,
355             address(this),
356             block.timestamp
357         );
358     }
359 
360     function removeLimits() external onlyOwner{
361         _maxTxAmount = _tTotal;
362         _maxWalletSize=_tTotal;
363         emit MaxTxAmountUpdated(_tTotal);
364     }
365 
366     function sendETHToFee(uint256 amount) private {
367         uint256 taxWalletShare = amount * _taxWalletPercentage / 100;
368         uint256 teamWalletShare = amount * _teamWalletPercentage / 100;
369 
370         _taxWallet.transfer(taxWalletShare);
371         _teamWallet.transfer(teamWalletShare);
372     }
373 
374     function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
375         if(tokens == 0){
376             tokens = IERC20(tokenAddress).balanceOf(address(this));
377         }
378         emit ClearToken(tokenAddress, tokens);
379         return IERC20(tokenAddress).transfer(_taxWallet, tokens);
380     }
381 
382     function manualSend() external {
383         require(address(this).balance > 0, "Contract balance must be greater than zero");
384         uint256 balance = address(this).balance; // Check
385         payable(_taxWallet).transfer(balance); // Effects + Interaction
386     }
387  
388     function manualSwap() external{
389         uint256 tokenBalance=balanceOf(address(this));
390         if(tokenBalance>0){
391           swapTokensForEth(tokenBalance);
392         }
393         uint256 ethBalance=address(this).balance;
394         if(ethBalance>0){
395           sendETHToFee(ethBalance);
396         }
397     }
398 
399     function openTrading() external onlyOwner() {
400         require(!tradingOpen,"trading is already open");
401         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
402         _approve(address(this), address(uniswapV2Router), _tTotal);
403         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
404         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
405         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
406         swapEnabled = true;
407         tradingOpen = true;
408         firstBlock = block.number;
409     }
410 
411     receive() external payable {}
412 }