1 /* 
2 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⣴⣶⡤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣯⣁⣀⢀⣟⠀⠄⠉⢑⢢⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⠀⠀⠀⣸⠋⠛⠳⢶⣤⣏⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡸⠁⠀⠀⢠⡟⠏⠀⠀⠀⠀⡟⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡗⠀⠐⠂⣾⡀⠈⡂⢀⡀⣸⣹⡏⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⣸⡇⠉⠋⢱⣿⣿⣿⣿⣿⣾⣏⣿⣏⡷⢶⣄⣀⣠⡴⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⠀⠀⠀⡿⠋⠀⠀⠸⢿⣿⣿⡿⣿⣿⢩⣭⣼⣳⣿⡾⣿⡟⠁⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣆⠶⣤⣸⢇⠈⠀⠀⠀⠀⢰⠃⠉⠙⣏⢬⠻⠿⢿⣿⣸⢸⠀⠀⢀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢶⣄⣹⠍⠻⠙⣶⡾⢃⡏⠀⠀⠀⠈⡷⣶⣤⣾⠛⢿⣼⡀⢀⣾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠳⠶⠿⠾⠋⠀⠀⠀⠀⢰⣷⣿⣿⣿⡆⠀⠛⠷⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡟⢿⣿⣽⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀---------THROG---------⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠃⠀⠀⣸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀-----THE-FROG-OF-THUNDER-----⠀ ⠀⠀⠀⠀⠀⢠⡿⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⢘⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣇⠀⠀⠀⣼⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡇⢻⢿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡟⠀⠀⢠⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣷⡸⣸⣿⣀⣀⡀⠀⠀⠀⣠⣄⣀⣿⠀⠀⢀⡽⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣿⣧⢿⢻⣍⡉⢿⣦⣀⣸⢱⣶⣾⡇⢀⠀⠘⣏⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⢛⣭⣴⣿⠏⢺⠀⠙⢿⣿⡏⠙⣻⣿⣿⣿⠁⠈⡇⠀⠉⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣟⡳⢶⣤⣀⣾⣵⡫⠞⢉⡞⠘⠂⠓⠦⢤⣞⣡⣴⢇⣿⣿⣿⡄⠀⣧⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⢿⣷⣦⣽⣿⣏⠀⠀⡟⢀⣀⣤⣴⣾⣏⠳⣶⣿⠸⣿⣿⡿⡇⠀⢹⠀⢰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⢧⠹⣄⠇⠀⢹⣶⣿⣿⣿⣿⠟⠛⢛⡳⣍⣿⣇⣿⡞⣷⡀⠀⢸⡀⣾⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣼⡇⡿⠀⣰⣿⢿⣿⠿⢿⡏⠀⠀⢻⡙⢹⣿⣿⣿⣿⣿⣷⣄⠀⢧⣹⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠷⣽⠇⣰⣿⣿⢸⠃⠀⢿⠀⡤⢦⠀⣷⣿⣟⣿⡿⡿⣿⣿⣿⣷⣤⣉⣀⡿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
26 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣾⣻⠚⡳⢝⣻⣌⠳⣀⠀⠸⡽⢋⡾⢿⡿⣻⢏⣇⡏⠀⠙⣿⣿⣿⣋⣭⡏⠹⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
27 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡈⠙⢳⣦⣍⣛⢦⣬⣳⣶⢒⣿⠕⣫⣾⣿⠈⠀⠀⠀⠀⢸⣿⣿⣿⣿⣧⡀⢹⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
28 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡿⠱⣷⣌⠙⢿⣿⣿⣶⣯⣿⣿⡶⠟⣛⣩⣽⣧⡀⠀⢀⣠⣿⣿⣿⣿⣿⣿⣿⡆⢿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
29 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢷⣦⣈⠻⢷⣦⡉⠻⡏⠠⠤⠏⢿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣛⡿⣿⣿⣿⣿⣿⠁⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
30 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣦⣍⡻⣶⣽⡄⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⡁⠁⠀⠀⠘⣿⣿⡿⠇⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
31 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⣿⣿⡿⣿⣿⣿⠛⠿⣿⣶⣤⣤⣿⠿⣿⣿⣿⣯⣼⣷⡀⠀⢀⣼⣿⣿⣿⣿⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
32 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣾⡇⣿⣿⡆⢻⣿⣿⠖⠀⠀⢈⣿⣿⣏⠛⠋⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣬⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
33 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡾⠋⢸⠃⢸⣿⣧⣸⡿⠣⠀⠀⢀⣾⣿⣿⢿⣦⣀⣸⣿⣿⡿⠟⠛⢯⣷⢶⣲⠞⣉⢿⠉⠉⠛⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
34 ⠀⠀⣀⣴⢾⣷⢋⣩⣽⠛⢀⣴⣿⠀⣾⡿⠋⠁⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⡟⣵⡏⠀⠀⢀⣼⢈⣳⣭⣷⣴⣯⣠⣤⣀⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
35 ⣰⠊⣩⡶⣋⣴⣿⠻⠧⣴⣿⣿⣧⣾⡿⣿⠿⣯⣿⣶⣦⡀⡿⠙⠛⠿⢿⣿⣿⣽⣆⣹⣶⣾⣿⣿⣿⣿⣿⣿⣶⠛⣛⣩⡟⠛⠷⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
36 ⢰⡿⣫⣾⣿⠟⢻⣄⣀⣠⣍⣀⣠⠉⠁⡻⣜⠈⢈⣿⣿⣿⠇⠀⠀⠀⠀⠀⠉⠛⠻⣿⣿⣿⣿⡟⠛⠉⠈⠉⢸⣿⣿⡟⠀⠀⠀⠀⠉⠳⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
37 ⢸⣞⣿⠟⠁⣰⣿⣿⠏⠀⣰⡏⣿⢦⢰⡇⡌⠉⣉⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣦⣀⣀⣠⣾⣿⡿⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
38 ⢸⠟⠁⢀⣼⢿⡿⠁⠀⢠⣿⣰⠏⣾⢧⡇⠉⠒⣹⣿⡿⠋⠀⠀⠀⠀⢀⣀⣀⣀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
39 ⠘⠀⠀⣼⣇⣿⠣⠀⢠⣿⣿⠏⣰⣿⠘⣧⣃⣠⣿⣿⣝⣿⣷⠶⠖⣛⡯⠽⠃⠉⠙⠛⠒⠶⠦⢤⣤⣬⣿⣿⣿⡟⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣤⠀⠀⠀⠀⠀⠀⠀⠀
40 ⠀⣷⣶⣻⣿⢧⣶⣶⠾⠟⠁⣰⣟⣼⣧⢸⡿⠿⢛⣫⣽⡶⠾⠛⢉⣁⣤⠤⠀⠀⠀⣀⣀⡤⠴⠞⠓⠒⠈⠉⠉⠛⠛⠿⠷⠶⢶⣤⣤⣀⣀⡀⠀⠀⠀⠀⠘⢷⣄⠀⠀⠀⠀⠀⠀
41 ⠀⣿⣿⣿⣿⣾⣼⣿⣦⣴⣾⠿⠛⣉⣩⡇⢷⡾⣛⣉⣥⡤⢶⡿⠟⠋⠀⠀⠀⣀⣈⣁⣀⣀⣀⣀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠻⠶⢶⣤⣄⣀⠹⣦⣤⣀⣀⠀⠀
42 ⠀⡟⣻⣿⣿⣿⡿⠿⠿⣍⣀⣴⣿⣷⢾⣧⣾⡿⣿⣿⣿⣾⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣬⣉⡙⠻⢷⣴⣝⠙⢦
43 ⢸⠷⠛⣉⣭⠥⢤⣴⡶⠾⣟⡛⠛⠛⣛⡯⠟⠛⠛⢛⡻⢛⡿⠋⠛⠏⠋⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠉⠈⠉⠉⠉⠉⠉⠁⠂⠈⠋⠛⠀⣼
44 ⠠⠄⠪⠥⠤⠜⠉⠤⠤⠤⠀⠥⠴⠏⠥⠤⠤⠤⠈⠵⠞⠁⠤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠤⠤⠤⠤⠤⠄⠀⠀⠀⠀⣸
45 
46 */
47 // SPDX-License-Identifier: MIT
48 
49 pragma solidity 0.8.20;
50 
51 interface ERC20 {
52     function totalSupply() external view returns (uint256);
53     function decimals() external view returns (uint8);
54     function symbol() external view returns (string memory);
55     function name() external view returns (string memory);
56     function getOwner() external view returns (address);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address _owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 abstract contract Context {
67     
68     function _msgSender() internal view virtual returns (address payable) {
69         return payable(msg.sender);
70     }
71 
72     function _msgData() internal view virtual returns (bytes memory) {
73         this;
74         return msg.data;
75     }
76 }
77 
78 contract Ownable is Context {
79     address public _owner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     constructor () {
84         address msgSender = _msgSender();
85         _owner = msgSender;
86         authorizations[_owner] = true;
87         emit OwnershipTransferred(address(0), msgSender);
88     }
89     mapping (address => bool) internal authorizations;
90 
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     modifier onlyOwner() {
96         require(_owner == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     function renounceOwnership() public virtual onlyOwner {
101         emit OwnershipTransferred(_owner, address(0));
102         _owner = address(0);
103     }
104 
105     function transferOwnership(address newOwner) public virtual onlyOwner {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         emit OwnershipTransferred(_owner, newOwner);
108         _owner = newOwner;
109     }
110 }
111 
112 interface IDEXFactory {
113     function createPair(address tokenA, address tokenB) external returns (address pair);
114 }
115 
116 interface IDEXRouter {
117     function factory() external pure returns (address);
118     function WETH() external pure returns (address);
119 
120     function addLiquidity(
121         address tokenA,
122         address tokenB,
123         uint amountADesired,
124         uint amountBDesired,
125         uint amountAMin,
126         uint amountBMin,
127         address to,
128         uint deadline
129     ) external returns (uint amountA, uint amountB, uint liquidity);
130 
131     function addLiquidityETH(
132         address token,
133         uint amountTokenDesired,
134         uint amountTokenMin,
135         uint amountETHMin,
136         address to,
137         uint deadline
138     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
139 
140     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
141         uint amountIn,
142         uint amountOutMin,
143         address[] calldata path,
144         address to,
145         uint deadline
146     ) external;
147 
148     function swapExactETHForTokensSupportingFeeOnTransferTokens(
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline
153     ) external payable;
154 
155     function swapExactTokensForETHSupportingFeeOnTransferTokens(
156         uint amountIn,
157         uint amountOutMin,
158         address[] calldata path,
159         address to,
160         uint deadline
161     ) external;
162 }
163 
164 interface InterfaceLP {
165     function sync() external;
166 }
167 
168 
169 library SafeMath {
170     function add(uint256 a, uint256 b) internal pure returns (uint256) {
171         uint256 c = a + b;
172         require(c >= a, "SafeMath: addition overflow");
173 
174         return c;
175     }
176     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177         return sub(a, b, "SafeMath: subtraction overflow");
178     }
179     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
180         require(b <= a, errorMessage);
181         uint256 c = a - b;
182 
183         return c;
184     }
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195     function div(uint256 a, uint256 b) internal pure returns (uint256) {
196         return div(a, b, "SafeMath: division by zero");
197     }
198     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         return c;
202     }
203 }
204 
205 contract THROG is Ownable, ERC20 {
206     using SafeMath for uint256;
207 
208     address WETH;
209     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
210     address constant ZERO = 0x0000000000000000000000000000000000000000;
211     
212 
213     string constant _name = "Throg";
214     string constant _symbol = "THROG";
215     uint8 constant _decimals = 18; 
216 
217 
218     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
219     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
220     event user_exemptfromfees(address Wallet, bool Exempt);
221     event user_TxExempt(address Wallet, bool Exempt);
222     event ClearStuck(uint256 amount);
223     event ClearToken(address TokenAddressCleared, uint256 Amount);
224     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
225     event set_MaxWallet(uint256 maxWallet);
226     event set_MaxTX(uint256 maxTX);
227     event set_SwapBack(uint256 Amount, bool Enabled);
228   
229     uint256 _totalSupply =  420690000000 * 10**_decimals; 
230 
231     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
232     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
233 
234     mapping (address => uint256) _balances;
235     mapping (address => mapping (address => uint256)) _allowances;  
236     mapping (address => bool) isexemptfromfees;
237     mapping (address => bool) isexemptfrommaxTX;
238 
239     uint256 private liquidityFee    = 1;
240     uint256 private marketingFee    = 4;
241     uint256 private devFee          = 0;
242     uint256 private buybackFee      = 0; 
243     uint256 private burnFee         = 0;
244     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
245     uint256 private feeDenominator  = 100;
246 
247     uint256 sellpercent = 100;
248     uint256 buypercent = 100;
249     uint256 transferpercent = 100; 
250 
251     address private autoLiquidityReceiver;
252     address private marketingFeeReceiver;
253     address private devFeeReceiver;
254     address private buybackFeeReceiver;
255     address private burnFeeReceiver;
256 
257     uint256 setRatio = 30;
258     uint256 setRatioDenominator = 100;
259     
260 
261     IDEXRouter public router;
262     InterfaceLP private pairContract;
263     address public pair;
264     
265     bool public TradingOpen = false; 
266 
267    
268     bool public swapEnabled = true;
269     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
270     bool inSwap;
271     modifier swapping() { inSwap = true; _; inSwap = false; }
272     
273     constructor () {
274         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
275         WETH = router.WETH();
276         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
277         pairContract = InterfaceLP(pair);
278        
279         
280         _allowances[address(this)][address(router)] = type(uint256).max;
281 
282         isexemptfromfees[msg.sender] = true;            
283         isexemptfrommaxTX[msg.sender] = true;
284         isexemptfrommaxTX[pair] = true;
285         isexemptfrommaxTX[marketingFeeReceiver] = true;
286         isexemptfrommaxTX[address(this)] = true;
287         
288         autoLiquidityReceiver = msg.sender;
289         marketingFeeReceiver = 0xBEbe00A2655698B9eE7A859d1BC33B4b77d7719f;
290         devFeeReceiver = msg.sender;
291         buybackFeeReceiver = msg.sender;
292         burnFeeReceiver = DEAD; 
293 
294         _balances[msg.sender] = _totalSupply;
295         emit Transfer(address(0), msg.sender, _totalSupply);
296 
297     }
298 
299     receive() external payable { }
300 
301     function totalSupply() external view override returns (uint256) { return _totalSupply; }
302     function decimals() external pure override returns (uint8) { return _decimals; }
303     function symbol() external pure override returns (string memory) { return _symbol; }
304     function name() external pure override returns (string memory) { return _name; }
305     function getOwner() external view override returns (address) {return owner();}
306     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
307     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
308 
309     function approve(address spender, uint256 amount) public override returns (bool) {
310         _allowances[msg.sender][spender] = amount;
311         emit Approval(msg.sender, spender, amount);
312         return true;
313     }
314 
315     function approveMax(address spender) external returns (bool) {
316         return approve(spender, type(uint256).max);
317     }
318 
319     function transfer(address recipient, uint256 amount) external override returns (bool) {
320         return _transferFrom(msg.sender, recipient, amount);
321     }
322 
323     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
324         if(_allowances[sender][msg.sender] != type(uint256).max){
325             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
326         }
327 
328         return _transferFrom(sender, recipient, amount);
329     }
330 
331         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
332          require(maxWallPercent >= 1); 
333         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
334         emit set_MaxWallet(_maxWalletToken);
335                 
336     }
337 
338       function removeLimits () external onlyOwner {
339             _maxTxAmount = _totalSupply;
340             _maxWalletToken = _totalSupply;
341     }
342 
343       
344     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
345         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
346 
347         if(!authorizations[sender] && !authorizations[recipient]){
348             require(TradingOpen,"Trading not open yet");
349         
350           }
351         
352                
353         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
354             uint256 heldTokens = balanceOf(recipient);
355             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
356 
357         checkTxLimit(sender, amount);  
358 
359         if(shouldSwapBack()){ swapBack(); }
360         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
361 
362         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
363         _balances[recipient] = _balances[recipient].add(amountReceived);
364 
365         emit Transfer(sender, recipient, amountReceived);
366         return true;
367     }
368  
369     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
370         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
371         _balances[recipient] = _balances[recipient].add(amount);
372         emit Transfer(sender, recipient, amount);
373         return true;
374     }
375 
376     function checkTxLimit(address sender, uint256 amount) internal view {
377         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
378     }
379 
380     function shouldTakeFee(address sender) internal view returns (bool) {
381         return !isexemptfromfees[sender];
382     }
383 
384     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
385         
386         uint256 percent = transferpercent;
387         if(recipient == pair) {
388             percent = sellpercent;
389         } else if(sender == pair) {
390             percent = buypercent;
391         }
392 
393         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
394         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
395         uint256 contractTokens = feeAmount.sub(burnTokens);
396         _balances[address(this)] = _balances[address(this)].add(contractTokens);
397         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
398         emit Transfer(sender, address(this), contractTokens);
399         
400         
401         if(burnTokens > 0){
402             _totalSupply = _totalSupply.sub(burnTokens);
403             emit Transfer(sender, ZERO, burnTokens);  
404         
405         }
406 
407         return amount.sub(feeAmount);
408     }
409 
410     function shouldSwapBack() internal view returns (bool) {
411         return msg.sender != pair
412         && !inSwap
413         && swapEnabled
414         && _balances[address(this)] >= swapThreshold;
415     }
416 
417   
418      function manualSend() external { 
419              payable(autoLiquidityReceiver).transfer(address(this).balance);
420             
421     }
422 
423    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
424              if(tokens == 0){
425             tokens = ERC20(tokenAddress).balanceOf(address(this));
426         }
427         emit ClearToken(tokenAddress, tokens);
428         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
429     }
430 
431     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
432         sellpercent = _percentonsell;
433         buypercent = _percentonbuy;
434         transferpercent = _wallettransfer;    
435           
436     }
437        
438     function startTrading() public onlyOwner {
439         TradingOpen = true;
440         buypercent = 1600;
441         sellpercent = 1400;
442         transferpercent = 1000;
443                               
444     }
445 
446       function reduceFee() public onlyOwner {
447        
448         buypercent = 400;
449         sellpercent = 1000;
450         transferpercent = 200;
451                               
452     }
453 
454              
455     function swapBack() internal swapping {
456         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
457         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
458         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
459 
460         address[] memory path = new address[](2);
461         path[0] = address(this);
462         path[1] = WETH;
463 
464         uint256 balanceBefore = address(this).balance;
465 
466         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
467             amountToSwap,
468             0,
469             path,
470             address(this),
471             block.timestamp
472         );
473 
474         uint256 amountETH = address(this).balance.sub(balanceBefore);
475 
476         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
477         
478         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
479         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
480         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
481         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
482 
483         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
484         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
485         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
486         
487         tmpSuccess = false;
488 
489         if(amountToLiquify > 0){
490             router.addLiquidityETH{value: amountETHLiquidity}(
491                 address(this),
492                 amountToLiquify,
493                 0,
494                 0,
495                 autoLiquidityReceiver,
496                 block.timestamp
497             );
498             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
499         }
500     }
501     
502   
503     function set_fees() internal {
504       
505         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
506             uint8(totalFee.mul(sellpercent).div(100)),
507             uint8(totalFee.mul(transferpercent).div(100))
508             );
509     }
510     
511     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
512         liquidityFee = _liquidityFee;
513         buybackFee = _buybackFee;
514         marketingFee = _marketingFee;
515         devFee = _devFee;
516         burnFee = _burnFee;
517         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
518         feeDenominator = _feeDenominator;
519         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
520         set_fees();
521     }
522 
523    
524     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
525         autoLiquidityReceiver = _autoLiquidityReceiver;
526         marketingFeeReceiver = _marketingFeeReceiver;
527         devFeeReceiver = _devFeeReceiver;
528         burnFeeReceiver = _burnFeeReceiver;
529         buybackFeeReceiver = _buybackFeeReceiver;
530 
531         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
532     }
533 
534     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
535         swapEnabled = _enabled;
536         swapThreshold = _amount;
537         emit set_SwapBack(swapThreshold, swapEnabled);
538     }
539 
540     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
541         return showBacking(accuracy) > ratio;
542     }
543 
544     function showBacking(uint256 accuracy) public view returns (uint256) {
545         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
546     }
547     
548     function showSupply() public view returns (uint256) {
549         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
550     }
551 
552 
553 }