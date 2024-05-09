1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 /**
5 
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ⣀⣠⣤⣤⣤⣤⣤⣤⡀⠀⠀⠀⠀⠀ ⣀⣤⣤⣤⣤⣤⣶⣶⣶⣶⣦⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⢀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡦⣀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢏⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⢠⣿⣿⣿⣿⣿⡿⠿⠟⢛⡛⠻⠿⣿⣿⣿⢟⣵⣿⣿⣿⣵⣶⣶⣶⣶⣶⣶⣭⣝⡛⠿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⣼⣿⣿⣫⣥⣶⣾⣿⣿⣿⣿⣿⣿⡿⢋⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣿⣿⡿⠟⣛⣛⣛⡛⢿⣿⣿⣿⡟⣱⣿⣿⣿⣛⣩⣭⣭⣥⣤⣦⣬⣭⣭⣛⣛⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣬⡻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣟⣛⣛⣛⡛⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⢃⣿⣿⣿⡿⠿⠟⢛⣛⣛⣛⣛⡛⠛⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⡿⠟⣛⣛⣛⣉⣙⣛⠻⢿⣿⣿⣿⣿⣿⣿⣾⢟⣩⣴⣾⣿⣛⣭⣭⣭⣭⣭⣭⣍⣛⡛⠷⣶⣭⡛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⢟⣥⣾⡿⠿⠿⠿⠿⠿⣿⣿⣷⣌⣻⣿⣿⣿⢟⣵⣿⣿⣿⣿⠿⠿⠿⠟⠛⠿⠿⠿⢿⣿⣿⣿⣶⣍⠻⣷⣌⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡇⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣿⣿⣿⣿⣿⣿⠟⠉⠀⠀⠀⠀⠀⠀⠀  ⠀⠀⠀⠀ ⠙⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⣟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ⠀⠀  ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡇⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⡸⣷⣄⣀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣴⣿⣿⣿⢿⣿⣿⣷⣤⣄⣀⠀⠀⠀⠀  ⢀⣀⣀⣤⣴⣾⣿⣿⠿⣛⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⡈⢙⣛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣙⡛⠛⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠛⣛⣫⣭⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣶⣭⣿⣿⣿⣿⣿⣶⡤⢔⣊⣵⣿⣿⣿⣿⣿⡹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣹⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⢫⣾⣿⣿⣿⠏⠀⠙⢿⣿⣷⣝⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀
26 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠈⣿⣿⣿⣷⣬⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠛⢻⡌⢿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀
27 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣴⣤⣀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠛⠛⠁⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀
28 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠟⣛⡛⣩⣥⣦⠺⠿⠃⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀
29 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⣙⣛⠛⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⢛⣛⣩⣴⡆⣾⡿⠘⠛⠋⠈⠁⠀⠀⠀⣠⡀⠾⣣⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
30 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⠿⠿⠸⣿⣶⡆⣶⣬⣭⡍⣭⣭⡍⣭⣭⣭⡍⣥⣴⡖⢾⡿⠟⠘⠋⠁⠀⠀⠀⠀⠀⢀⣀⢠⣶⡜⠟⣩⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀
31 ⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠁⠉⠛⠁⠙⠛⠋⠁⠉⠁⠀⠀⠀⠀⠀⠀⠀⣀⣀⢠⣴⣦⠻⠿⢊⣩⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀
32  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⢀⣤⣄⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ⣀⣀⢀⣤⡄⣶⣶⡎⠿⠿⢃⣫⣥⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
33 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣦⣭⣛⡘⠿⠿⠲⠿⠶⠰⣶⠶⠰⠾⠷⠰⠿⠿⠸⠿⠛⣘⣛⣡⣭⣴⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
34 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
35 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
36 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
37 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
38 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠛⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
39 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
40 
41     ** Twitter
42        https://twitter.com/PepeYogaClubNFT
43 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
44 **/
45 
46 
47 // ERC721A Contracts v4.2.2
48 // Creator: Chiru Labs
49 
50 /**
51  * @dev Interface of ERC721A.
52  */
53 interface IERC721A {
54     /**
55      * The caller must own the token or be an approved operator.
56      */
57     error ApprovalCallerNotOwnerNorApproved();
58 
59     /**
60      * The token does not exist.
61      */
62     error ApprovalQueryForNonexistentToken();
63 
64     /**
65      * Cannot query the balance for the zero address.
66      */
67     error BalanceQueryForZeroAddress();
68 
69     /**
70      * Cannot mint to the zero address.
71      */
72     error MintToZeroAddress();
73 
74     /**
75      * The quantity of tokens minted must be more than zero.
76      */
77     error MintZeroQuantity();
78 
79     /**
80      * The token does not exist.
81      */
82     error OwnerQueryForNonexistentToken();
83 
84     /**
85      * The caller must own the token or be an approved operator.
86      */
87     error TransferCallerNotOwnerNorApproved();
88 
89     /**
90      * The token must be owned by `from`.
91      */
92     error TransferFromIncorrectOwner();
93 
94     /**
95      * Cannot safely transfer to a contract that does not implement the
96      * ERC721Receiver interface.
97      */
98     error TransferToNonERC721ReceiverImplementer();
99 
100     /**
101      * Cannot transfer to the zero address.
102      */
103     error TransferToZeroAddress();
104 
105     /**
106      * The token does not exist.
107      */
108     error URIQueryForNonexistentToken();
109 
110     /**
111      * The `quantity` minted with ERC2309 exceeds the safety limit.
112      */
113     error MintERC2309QuantityExceedsLimit();
114 
115     /**
116      * The `extraData` cannot be set on an unintialized ownership slot.
117      */
118     error OwnershipNotInitializedForExtraData();
119 
120     // =============================================================
121     //                            STRUCTS
122     // =============================================================
123 
124     struct TokenOwnership {
125         // The address of the owner.
126         address addr;
127         // Stores the start time of ownership with minimal overhead for tokenomics.
128         uint64 startTimestamp;
129         // Whether the token has been burned.
130         bool burned;
131         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
132         uint24 extraData;
133     }
134 
135     // =============================================================
136     //                         TOKEN COUNTERS
137     // =============================================================
138 
139     /**
140      * @dev Returns the total number of tokens in existence.
141      * Burned tokens will reduce the count.
142      * To get the total number of tokens minted, please see {_totalMinted}.
143      */
144     function totalSupply() external view returns (uint256);
145 
146     // =============================================================
147     //                            IERC165
148     // =============================================================
149 
150     /**
151      * @dev Returns true if this contract implements the interface defined by
152      * `interfaceId`. See the corresponding
153      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
154      * to learn more about how these ids are created.
155      *
156      * This function call must use less than 30000 gas.
157      */
158     function supportsInterface(bytes4 interfaceId) external view returns (bool);
159 
160     // =============================================================
161     //                            IERC721
162     // =============================================================
163 
164     /**
165      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
168 
169     /**
170      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
171      */
172     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
173 
174     /**
175      * @dev Emitted when `owner` enables or disables
176      * (`approved`) `operator` to manage all of its assets.
177      */
178     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
179 
180     /**
181      * @dev Returns the number of tokens in `owner`'s account.
182      */
183     function balanceOf(address owner) external view returns (uint256 balance);
184 
185     /**
186      * @dev Returns the owner of the `tokenId` token.
187      *
188      * Requirements:
189      *
190      * - `tokenId` must exist.
191      */
192     function ownerOf(uint256 tokenId) external view returns (address owner);
193 
194     /**
195      * @dev Safely transfers `tokenId` token from `from` to `to`,
196      * checking first that contract recipients are aware of the ERC721 protocol
197      * to prevent tokens from being forever locked.
198      *
199      * Requirements:
200      *
201      * - `from` cannot be the zero address.
202      * - `to` cannot be the zero address.
203      * - `tokenId` token must exist and be owned by `from`.
204      * - If the caller is not `from`, it must be have been allowed to move
205      * this token by either {approve} or {setApprovalForAll}.
206      * - If `to` refers to a smart contract, it must implement
207      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
208      *
209      * Emits a {Transfer} event.
210      */
211     function safeTransferFrom(
212         address from,
213         address to,
214         uint256 tokenId,
215         bytes calldata data
216     ) external;
217 
218     /**
219      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
220      */
221     function safeTransferFrom(
222         address from,
223         address to,
224         uint256 tokenId
225     ) external;
226 
227     /**
228      * @dev Transfers `tokenId` from `from` to `to`.
229      *
230      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
231      * whenever possible.
232      *
233      * Requirements:
234      *
235      * - `from` cannot be the zero address.
236      * - `to` cannot be the zero address.
237      * - `tokenId` token must be owned by `from`.
238      * - If the caller is not `from`, it must be approved to move this token
239      * by either {approve} or {setApprovalForAll}.
240      *
241      * Emits a {Transfer} event.
242      */
243     function transferFrom(
244         address from,
245         address to,
246         uint256 tokenId
247     ) external;
248 
249     /**
250      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
251      * The approval is cleared when the token is transferred.
252      *
253      * Only a single account can be approved at a time, so approving the
254      * zero address clears previous approvals.
255      *
256      * Requirements:
257      *
258      * - The caller must own the token or be an approved operator.
259      * - `tokenId` must exist.
260      *
261      * Emits an {Approval} event.
262      */
263     function approve(address to, uint256 tokenId) external;
264 
265     /**
266      * @dev Approve or remove `operator` as an operator for the caller.
267      * Operators can call {transferFrom} or {safeTransferFrom}
268      * for any token owned by the caller.
269      *
270      * Requirements:
271      *
272      * - The `operator` cannot be the caller.
273      *
274      * Emits an {ApprovalForAll} event.
275      */
276     function setApprovalForAll(address operator, bool _approved) external;
277 
278     /**
279      * @dev Returns the account approved for `tokenId` token.
280      *
281      * Requirements:
282      *
283      * - `tokenId` must exist.
284      */
285     function getApproved(uint256 tokenId) external view returns (address operator);
286 
287     /**
288      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
289      *
290      * See {setApprovalForAll}.
291      */
292     function isApprovedForAll(address owner, address operator) external view returns (bool);
293 
294     // =============================================================
295     //                        IERC721Metadata
296     // =============================================================
297 
298     /**
299      * @dev Returns the token collection name.
300      */
301     function name() external view returns (string memory);
302 
303     /**
304      * @dev Returns the token collection symbol.
305      */
306     function symbol() external view returns (string memory);
307 
308     /**
309      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
310      */
311     function tokenURI(uint256 tokenId) external view returns (string memory);
312 
313     // =============================================================
314     //                           IERC2309
315     // =============================================================
316 
317     /**
318      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
319      * (inclusive) is transferred from `from` to `to`, as defined in the
320      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
321      *
322      * See {_mintERC2309} for more details.
323      */
324     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
325 }
326 
327 
328 /**
329  * @dev Interface of ERC721 token receiver.
330  */
331 interface ERC721A__IERC721Receiver {
332     function onERC721Received(
333         address operator,
334         address from,
335         uint256 tokenId,
336         bytes calldata data
337     ) external returns (bytes4);
338 }
339 
340 /**
341  * @title ERC721A
342  *
343  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
344  * Non-Fungible Token Standard, including the Metadata extension.
345  * Optimized for lower gas during batch mints.
346  *
347  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
348  * starting from `_startTokenId()`.
349  *
350  * Assumptions:
351  *
352  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
353  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
354  */
355 contract ERC721A is IERC721A {
356     // Reference type for token approval.
357     struct TokenApprovalRef {
358         address value;
359     }
360 
361     // =============================================================
362     //                           CONSTANTS
363     // =============================================================
364 
365     // Mask of an entry in packed address data.
366     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
367 
368     // The bit position of `numberMinted` in packed address data.
369     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
370 
371     // The bit position of `numberBurned` in packed address data.
372     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
373 
374     // The bit position of `aux` in packed address data.
375     uint256 private constant _BITPOS_AUX = 192;
376 
377     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
378     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
379 
380     // The bit position of `startTimestamp` in packed ownership.
381     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
382 
383     // The bit mask of the `burned` bit in packed ownership.
384     uint256 private constant _BITMASK_BURNED = 1 << 224;
385 
386     // The bit position of the `nextInitialized` bit in packed ownership.
387     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
388 
389     // The bit mask of the `nextInitialized` bit in packed ownership.
390     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
391 
392     // The bit position of `extraData` in packed ownership.
393     uint256 private constant _BITPOS_EXTRA_DATA = 232;
394 
395     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
396     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
397 
398     // The mask of the lower 160 bits for addresses.
399     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
400 
401     // The maximum `quantity` that can be minted with {_mintERC2309}.
402     // This limit is to prevent overflows on the address data entries.
403     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
404     // is required to cause an overflow, which is unrealistic.
405     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
406 
407     // The `Transfer` event signature is given by:
408     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
409     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
410         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
411 
412     // =============================================================
413     //                            STORAGE
414     // =============================================================
415 
416     // The next token ID to be minted.
417     uint256 private _currentIndex;
418 
419     // The number of tokens burned.
420     uint256 private _burnCounter;
421 
422     // Token name
423     string private _name;
424 
425     // Token symbol
426     string private _symbol;
427 
428     // Mapping from token ID to ownership details
429     // An empty struct value does not necessarily mean the token is unowned.
430     // See {_packedOwnershipOf} implementation for details.
431     //
432     // Bits Layout:
433     // - [0..159]   `addr`
434     // - [160..223] `startTimestamp`
435     // - [224]      `burned`
436     // - [225]      `nextInitialized`
437     // - [232..255] `extraData`
438     mapping(uint256 => uint256) private _packedOwnerships;
439 
440     // Mapping owner address to address data.
441     //
442     // Bits Layout:
443     // - [0..63]    `balance`
444     // - [64..127]  `numberMinted`
445     // - [128..191] `numberBurned`
446     // - [192..255] `aux`
447     mapping(address => uint256) private _packedAddressData;
448 
449     // Mapping from token ID to approved address.
450     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
451 
452     // Mapping from owner to operator approvals
453     mapping(address => mapping(address => bool)) private _operatorApprovals;
454 
455     // =============================================================
456     //                          CONSTRUCTOR
457     // =============================================================
458 
459     constructor(string memory name_, string memory symbol_) {
460         _name = name_;
461         _symbol = symbol_;
462         _currentIndex = _startTokenId();
463     }
464 
465     // =============================================================
466     //                   TOKEN COUNTING OPERATIONS
467     // =============================================================
468 
469     /**
470      * @dev Returns the starting token ID.
471      * To change the starting token ID, please override this function.
472      */
473     function _startTokenId() internal view virtual returns (uint256) {
474         return 0;
475     }
476 
477     /**
478      * @dev Returns the next token ID to be minted.
479      */
480     function _nextTokenId() internal view virtual returns (uint256) {
481         return _currentIndex;
482     }
483 
484     /**
485      * @dev Returns the total number of tokens in existence.
486      * Burned tokens will reduce the count.
487      * To get the total number of tokens minted, please see {_totalMinted}.
488      */
489     function totalSupply() public view virtual override returns (uint256) {
490         // Counter underflow is impossible as _burnCounter cannot be incremented
491         // more than `_currentIndex - _startTokenId()` times.
492         unchecked {
493             return _currentIndex - _burnCounter - _startTokenId();
494         }
495     }
496 
497     /**
498      * @dev Returns the total amount of tokens minted in the contract.
499      */
500     function _totalMinted() internal view virtual returns (uint256) {
501         // Counter underflow is impossible as `_currentIndex` does not decrement,
502         // and it is initialized to `_startTokenId()`.
503         unchecked {
504             return _currentIndex - _startTokenId();
505         }
506     }
507 
508     /**
509      * @dev Returns the total number of tokens burned.
510      */
511     function _totalBurned() internal view virtual returns (uint256) {
512         return _burnCounter;
513     }
514 
515     // =============================================================
516     //                    ADDRESS DATA OPERATIONS
517     // =============================================================
518 
519     /**
520      * @dev Returns the number of tokens in `owner`'s account.
521      */
522     function balanceOf(address owner) public view virtual override returns (uint256) {
523         if (owner == address(0)) revert BalanceQueryForZeroAddress();
524         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
525     }
526 
527     /**
528      * Returns the number of tokens minted by `owner`.
529      */
530     function _numberMinted(address owner) internal view returns (uint256) {
531         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
532     }
533 
534     /**
535      * Returns the number of tokens burned by or on behalf of `owner`.
536      */
537     function _numberBurned(address owner) internal view returns (uint256) {
538         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
539     }
540 
541     /**
542      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
543      */
544     function _getAux(address owner) internal view returns (uint64) {
545         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
546     }
547 
548     /**
549      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
550      * If there are multiple variables, please pack them into a uint64.
551      */
552     function _setAux(address owner, uint64 aux) internal virtual {
553         uint256 packed = _packedAddressData[owner];
554         uint256 auxCasted;
555         // Cast `aux` with assembly to avoid redundant masking.
556         assembly {
557             auxCasted := aux
558         }
559         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
560         _packedAddressData[owner] = packed;
561     }
562 
563     // =============================================================
564     //                            IERC165
565     // =============================================================
566 
567     /**
568      * @dev Returns true if this contract implements the interface defined by
569      * `interfaceId`. See the corresponding
570      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
571      * to learn more about how these ids are created.
572      *
573      * This function call must use less than 30000 gas.
574      */
575     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
576         // The interface IDs are constants representing the first 4 bytes
577         // of the XOR of all function selectors in the interface.
578         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
579         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
580         return
581             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
582             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
583             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
584     }
585 
586     // =============================================================
587     //                        IERC721Metadata
588     // =============================================================
589 
590     /**
591      * @dev Returns the token collection name.
592      */
593     function name() public view virtual override returns (string memory) {
594         return _name;
595     }
596 
597     /**
598      * @dev Returns the token collection symbol.
599      */
600     function symbol() public view virtual override returns (string memory) {
601         return _symbol;
602     }
603 
604     /**
605      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
606      */
607     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
608         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
609 
610         string memory baseURI = _baseURI();
611         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
612     }
613 
614     /**
615      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
616      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
617      * by default, it can be overridden in child contracts.
618      */
619     function _baseURI() internal view virtual returns (string memory) {
620         return '';
621     }
622 
623     // =============================================================
624     //                     OWNERSHIPS OPERATIONS
625     // =============================================================
626 
627     /**
628      * @dev Returns the owner of the `tokenId` token.
629      *
630      * Requirements:
631      *
632      * - `tokenId` must exist.
633      */
634     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
635         return address(uint160(_packedOwnershipOf(tokenId)));
636     }
637 
638     /**
639      * @dev Gas spent here starts off proportional to the maximum mint batch size.
640      * It gradually moves to O(1) as tokens get transferred around over time.
641      */
642     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
643         return _unpackedOwnership(_packedOwnershipOf(tokenId));
644     }
645 
646     /**
647      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
648      */
649     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
650         return _unpackedOwnership(_packedOwnerships[index]);
651     }
652 
653     /**
654      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
655      */
656     function _initializeOwnershipAt(uint256 index) internal virtual {
657         if (_packedOwnerships[index] == 0) {
658             _packedOwnerships[index] = _packedOwnershipOf(index);
659         }
660     }
661 
662     /**
663      * Returns the packed ownership data of `tokenId`.
664      */
665     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
666         uint256 curr = tokenId;
667 
668         unchecked {
669             if (_startTokenId() <= curr)
670                 if (curr < _currentIndex) {
671                     uint256 packed = _packedOwnerships[curr];
672                     // If not burned.
673                     if (packed & _BITMASK_BURNED == 0) {
674                         // Invariant:
675                         // There will always be an initialized ownership slot
676                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
677                         // before an unintialized ownership slot
678                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
679                         // Hence, `curr` will not underflow.
680                         //
681                         // We can directly compare the packed value.
682                         // If the address is zero, packed will be zero.
683                         while (packed == 0) {
684                             packed = _packedOwnerships[--curr];
685                         }
686                         return packed;
687                     }
688                 }
689         }
690         revert OwnerQueryForNonexistentToken();
691     }
692 
693     /**
694      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
695      */
696     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
697         ownership.addr = address(uint160(packed));
698         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
699         ownership.burned = packed & _BITMASK_BURNED != 0;
700         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
701     }
702 
703     /**
704      * @dev Packs ownership data into a single uint256.
705      */
706     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
707         assembly {
708             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
709             owner := and(owner, _BITMASK_ADDRESS)
710             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
711             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
712         }
713     }
714 
715     /**
716      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
717      */
718     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
719         // For branchless setting of the `nextInitialized` flag.
720         assembly {
721             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
722             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
723         }
724     }
725 
726     // =============================================================
727     //                      APPROVAL OPERATIONS
728     // =============================================================
729 
730     /**
731      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
732      * The approval is cleared when the token is transferred.
733      *
734      * Only a single account can be approved at a time, so approving the
735      * zero address clears previous approvals.
736      *
737      * Requirements:
738      *
739      * - The caller must own the token or be an approved operator.
740      * - `tokenId` must exist.
741      *
742      * Emits an {Approval} event.
743      */
744     function approve(address to, uint256 tokenId) public virtual override {
745         address owner = ownerOf(tokenId);
746 
747         if (_msgSenderERC721A() != owner)
748             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
749                 revert ApprovalCallerNotOwnerNorApproved();
750             }
751 
752         _tokenApprovals[tokenId].value = to;
753         emit Approval(owner, to, tokenId);
754     }
755 
756     /**
757      * @dev Returns the account approved for `tokenId` token.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function getApproved(uint256 tokenId) public view virtual override returns (address) {
764         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
765 
766         return _tokenApprovals[tokenId].value;
767     }
768 
769     /**
770      * @dev Approve or remove `operator` as an operator for the caller.
771      * Operators can call {transferFrom} or {safeTransferFrom}
772      * for any token owned by the caller.
773      *
774      * Requirements:
775      *
776      * - The `operator` cannot be the caller.
777      *
778      * Emits an {ApprovalForAll} event.
779      */
780     function setApprovalForAll(address operator, bool approved) public virtual override {
781         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
782         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
783     }
784 
785     /**
786      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
787      *
788      * See {setApprovalForAll}.
789      */
790     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
791         return _operatorApprovals[owner][operator];
792     }
793 
794     /**
795      * @dev Returns whether `tokenId` exists.
796      *
797      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
798      *
799      * Tokens start existing when they are minted. See {_mint}.
800      */
801     function _exists(uint256 tokenId) internal view virtual returns (bool) {
802         return
803             _startTokenId() <= tokenId &&
804             tokenId < _currentIndex && // If within bounds,
805             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
806     }
807 
808     /**
809      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
810      */
811     function _isSenderApprovedOrOwner(
812         address approvedAddress,
813         address owner,
814         address msgSender
815     ) private pure returns (bool result) {
816         assembly {
817             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
818             owner := and(owner, _BITMASK_ADDRESS)
819             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
820             msgSender := and(msgSender, _BITMASK_ADDRESS)
821             // `msgSender == owner || msgSender == approvedAddress`.
822             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
823         }
824     }
825 
826     /**
827      * @dev Returns the storage slot and value for the approved address of `tokenId`.
828      */
829     function _getApprovedSlotAndAddress(uint256 tokenId)
830         private
831         view
832         returns (uint256 approvedAddressSlot, address approvedAddress)
833     {
834         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
835         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
836         assembly {
837             approvedAddressSlot := tokenApproval.slot
838             approvedAddress := sload(approvedAddressSlot)
839         }
840     }
841 
842     // =============================================================
843     //                      TRANSFER OPERATIONS
844     // =============================================================
845 
846     /**
847      * @dev Transfers `tokenId` from `from` to `to`.
848      *
849      * Requirements:
850      *
851      * - `from` cannot be the zero address.
852      * - `to` cannot be the zero address.
853      * - `tokenId` token must be owned by `from`.
854      * - If the caller is not `from`, it must be approved to move this token
855      * by either {approve} or {setApprovalForAll}.
856      *
857      * Emits a {Transfer} event.
858      */
859     function transferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) public virtual override {
864         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
865 
866         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
867 
868         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
869 
870         // The nested ifs save around 20+ gas over a compound boolean condition.
871         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
872             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
873 
874         if (to == address(0)) revert TransferToZeroAddress();
875 
876         _beforeTokenTransfers(from, to, tokenId, 1);
877 
878         // Clear approvals from the previous owner.
879         assembly {
880             if approvedAddress {
881                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
882                 sstore(approvedAddressSlot, 0)
883             }
884         }
885 
886         // Underflow of the sender's balance is impossible because we check for
887         // ownership above and the recipient's balance can't realistically overflow.
888         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
889         unchecked {
890             // We can directly increment and decrement the balances.
891             --_packedAddressData[from]; // Updates: `balance -= 1`.
892             ++_packedAddressData[to]; // Updates: `balance += 1`.
893 
894             // Updates:
895             // - `address` to the next owner.
896             // - `startTimestamp` to the timestamp of transfering.
897             // - `burned` to `false`.
898             // - `nextInitialized` to `true`.
899             _packedOwnerships[tokenId] = _packOwnershipData(
900                 to,
901                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
902             );
903 
904             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
905             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
906                 uint256 nextTokenId = tokenId + 1;
907                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
908                 if (_packedOwnerships[nextTokenId] == 0) {
909                     // If the next slot is within bounds.
910                     if (nextTokenId != _currentIndex) {
911                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
912                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
913                     }
914                 }
915             }
916         }
917 
918         emit Transfer(from, to, tokenId);
919         _afterTokenTransfers(from, to, tokenId, 1);
920     }
921 
922     /**
923      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId
929     ) public virtual override {
930         safeTransferFrom(from, to, tokenId, '');
931     }
932 
933     /**
934      * @dev Safely transfers `tokenId` token from `from` to `to`.
935      *
936      * Requirements:
937      *
938      * - `from` cannot be the zero address.
939      * - `to` cannot be the zero address.
940      * - `tokenId` token must exist and be owned by `from`.
941      * - If the caller is not `from`, it must be approved to move this token
942      * by either {approve} or {setApprovalForAll}.
943      * - If `to` refers to a smart contract, it must implement
944      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
945      *
946      * Emits a {Transfer} event.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) public virtual override {
954         transferFrom(from, to, tokenId);
955         if (to.code.length != 0)
956             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
957                 revert TransferToNonERC721ReceiverImplementer();
958             }
959     }
960 
961     /**
962      * @dev Hook that is called before a set of serially-ordered token IDs
963      * are about to be transferred. This includes minting.
964      * And also called before burning one token.
965      *
966      * `startTokenId` - the first token ID to be transferred.
967      * `quantity` - the amount to be transferred.
968      *
969      * Calling conditions:
970      *
971      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
972      * transferred to `to`.
973      * - When `from` is zero, `tokenId` will be minted for `to`.
974      * - When `to` is zero, `tokenId` will be burned by `from`.
975      * - `from` and `to` are never both zero.
976      */
977     function _beforeTokenTransfers(
978         address from,
979         address to,
980         uint256 startTokenId,
981         uint256 quantity
982     ) internal virtual {}
983 
984     /**
985      * @dev Hook that is called after a set of serially-ordered token IDs
986      * have been transferred. This includes minting.
987      * And also called after one token has been burned.
988      *
989      * `startTokenId` - the first token ID to be transferred.
990      * `quantity` - the amount to be transferred.
991      *
992      * Calling conditions:
993      *
994      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
995      * transferred to `to`.
996      * - When `from` is zero, `tokenId` has been minted for `to`.
997      * - When `to` is zero, `tokenId` has been burned by `from`.
998      * - `from` and `to` are never both zero.
999      */
1000     function _afterTokenTransfers(
1001         address from,
1002         address to,
1003         uint256 startTokenId,
1004         uint256 quantity
1005     ) internal virtual {}
1006 
1007     /**
1008      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1009      *
1010      * `from` - Previous owner of the given token ID.
1011      * `to` - Target address that will receive the token.
1012      * `tokenId` - Token ID to be transferred.
1013      * `_data` - Optional data to send along with the call.
1014      *
1015      * Returns whether the call correctly returned the expected magic value.
1016      */
1017     function _checkContractOnERC721Received(
1018         address from,
1019         address to,
1020         uint256 tokenId,
1021         bytes memory _data
1022     ) private returns (bool) {
1023         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1024             bytes4 retval
1025         ) {
1026             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1027         } catch (bytes memory reason) {
1028             if (reason.length == 0) {
1029                 revert TransferToNonERC721ReceiverImplementer();
1030             } else {
1031                 assembly {
1032                     revert(add(32, reason), mload(reason))
1033                 }
1034             }
1035         }
1036     }
1037 
1038     // =============================================================
1039     //                        MINT OPERATIONS
1040     // =============================================================
1041 
1042     /**
1043      * @dev Mints `quantity` tokens and transfers them to `to`.
1044      *
1045      * Requirements:
1046      *
1047      * - `to` cannot be the zero address.
1048      * - `quantity` must be greater than 0.
1049      *
1050      * Emits a {Transfer} event for each mint.
1051      */
1052     function _mint(address to, uint256 quantity) internal virtual {
1053         uint256 startTokenId = _currentIndex;
1054         if (quantity == 0) revert MintZeroQuantity();
1055 
1056         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1057 
1058         // Overflows are incredibly unrealistic.
1059         // `balance` and `numberMinted` have a maximum limit of 2**64.
1060         // `tokenId` has a maximum limit of 2**256.
1061         unchecked {
1062             // Updates:
1063             // - `balance += quantity`.
1064             // - `numberMinted += quantity`.
1065             //
1066             // We can directly add to the `balance` and `numberMinted`.
1067             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1068 
1069             // Updates:
1070             // - `address` to the owner.
1071             // - `startTimestamp` to the timestamp of minting.
1072             // - `burned` to `false`.
1073             // - `nextInitialized` to `quantity == 1`.
1074             _packedOwnerships[startTokenId] = _packOwnershipData(
1075                 to,
1076                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1077             );
1078 
1079             uint256 toMasked;
1080             uint256 end = startTokenId + quantity;
1081 
1082             // Use assembly to loop and emit the `Transfer` event for gas savings.
1083             // The duplicated `log4` removes an extra check and reduces stack juggling.
1084             // The assembly, together with the surrounding Solidity code, have been
1085             // delicately arranged to nudge the compiler into producing optimized opcodes.
1086             assembly {
1087                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1088                 toMasked := and(to, _BITMASK_ADDRESS)
1089                 // Emit the `Transfer` event.
1090                 log4(
1091                     0, // Start of data (0, since no data).
1092                     0, // End of data (0, since no data).
1093                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1094                     0, // `address(0)`.
1095                     toMasked, // `to`.
1096                     startTokenId // `tokenId`.
1097                 )
1098 
1099                 for {
1100                     let tokenId := add(startTokenId, 1)
1101                 } iszero(eq(tokenId, end)) {
1102                     tokenId := add(tokenId, 1)
1103                 } {
1104                     // Emit the `Transfer` event. Similar to above.
1105                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1106                 }
1107             }
1108             if (toMasked == 0) revert MintToZeroAddress();
1109 
1110             _currentIndex = end;
1111         }
1112         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1113     }
1114 
1115     /**
1116      * @dev Mints `quantity` tokens and transfers them to `to`.
1117      *
1118      * This function is intended for efficient minting only during contract creation.
1119      *
1120      * It emits only one {ConsecutiveTransfer} as defined in
1121      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1122      * instead of a sequence of {Transfer} event(s).
1123      *
1124      * Calling this function outside of contract creation WILL make your contract
1125      * non-compliant with the ERC721 standard.
1126      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1127      * {ConsecutiveTransfer} event is only permissible during contract creation.
1128      *
1129      * Requirements:
1130      *
1131      * - `to` cannot be the zero address.
1132      * - `quantity` must be greater than 0.
1133      *
1134      * Emits a {ConsecutiveTransfer} event.
1135      */
1136     function _mintERC2309(address to, uint256 quantity) internal virtual {
1137         uint256 startTokenId = _currentIndex;
1138         if (to == address(0)) revert MintToZeroAddress();
1139         if (quantity == 0) revert MintZeroQuantity();
1140         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1141 
1142         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1143 
1144         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1145         unchecked {
1146             // Updates:
1147             // - `balance += quantity`.
1148             // - `numberMinted += quantity`.
1149             //
1150             // We can directly add to the `balance` and `numberMinted`.
1151             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1152 
1153             // Updates:
1154             // - `address` to the owner.
1155             // - `startTimestamp` to the timestamp of minting.
1156             // - `burned` to `false`.
1157             // - `nextInitialized` to `quantity == 1`.
1158             _packedOwnerships[startTokenId] = _packOwnershipData(
1159                 to,
1160                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1161             );
1162 
1163             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1164 
1165             _currentIndex = startTokenId + quantity;
1166         }
1167         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1168     }
1169 
1170     /**
1171      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1172      *
1173      * Requirements:
1174      *
1175      * - If `to` refers to a smart contract, it must implement
1176      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1177      * - `quantity` must be greater than 0.
1178      *
1179      * See {_mint}.
1180      *
1181      * Emits a {Transfer} event for each mint.
1182      */
1183     function _safeMint(
1184         address to,
1185         uint256 quantity,
1186         bytes memory _data
1187     ) internal virtual {
1188         _mint(to, quantity);
1189 
1190         unchecked {
1191             if (to.code.length != 0) {
1192                 uint256 end = _currentIndex;
1193                 uint256 index = end - quantity;
1194                 do {
1195                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1196                         revert TransferToNonERC721ReceiverImplementer();
1197                     }
1198                 } while (index < end);
1199                 // Reentrancy protection.
1200                 if (_currentIndex != end) revert();
1201             }
1202         }
1203     }
1204 
1205     /**
1206      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1207      */
1208     function _safeMint(address to, uint256 quantity) internal virtual {
1209         _safeMint(to, quantity, '');
1210     }
1211 
1212     // =============================================================
1213     //                        BURN OPERATIONS
1214     // =============================================================
1215 
1216     /**
1217      * @dev Equivalent to `_burn(tokenId, false)`.
1218      */
1219     function _burn(uint256 tokenId) internal virtual {
1220         _burn(tokenId, false);
1221     }
1222 
1223     /**
1224      * @dev Destroys `tokenId`.
1225      * The approval is cleared when the token is burned.
1226      *
1227      * Requirements:
1228      *
1229      * - `tokenId` must exist.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1234         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1235 
1236         address from = address(uint160(prevOwnershipPacked));
1237 
1238         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1239 
1240         if (approvalCheck) {
1241             // The nested ifs save around 20+ gas over a compound boolean condition.
1242             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1243                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1244         }
1245 
1246         _beforeTokenTransfers(from, address(0), tokenId, 1);
1247 
1248         // Clear approvals from the previous owner.
1249         assembly {
1250             if approvedAddress {
1251                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1252                 sstore(approvedAddressSlot, 0)
1253             }
1254         }
1255 
1256         // Underflow of the sender's balance is impossible because we check for
1257         // ownership above and the recipient's balance can't realistically overflow.
1258         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1259         unchecked {
1260             // Updates:
1261             // - `balance -= 1`.
1262             // - `numberBurned += 1`.
1263             //
1264             // We can directly decrement the balance, and increment the number burned.
1265             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1266             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1267 
1268             // Updates:
1269             // - `address` to the last owner.
1270             // - `startTimestamp` to the timestamp of burning.
1271             // - `burned` to `true`.
1272             // - `nextInitialized` to `true`.
1273             _packedOwnerships[tokenId] = _packOwnershipData(
1274                 from,
1275                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1276             );
1277 
1278             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1279             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1280                 uint256 nextTokenId = tokenId + 1;
1281                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1282                 if (_packedOwnerships[nextTokenId] == 0) {
1283                     // If the next slot is within bounds.
1284                     if (nextTokenId != _currentIndex) {
1285                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1286                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1287                     }
1288                 }
1289             }
1290         }
1291 
1292         emit Transfer(from, address(0), tokenId);
1293         _afterTokenTransfers(from, address(0), tokenId, 1);
1294 
1295         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1296         unchecked {
1297             _burnCounter++;
1298         }
1299     }
1300 
1301     // =============================================================
1302     //                     EXTRA DATA OPERATIONS
1303     // =============================================================
1304 
1305     /**
1306      * @dev Directly sets the extra data for the ownership data `index`.
1307      */
1308     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1309         uint256 packed = _packedOwnerships[index];
1310         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1311         uint256 extraDataCasted;
1312         // Cast `extraData` with assembly to avoid redundant masking.
1313         assembly {
1314             extraDataCasted := extraData
1315         }
1316         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1317         _packedOwnerships[index] = packed;
1318     }
1319 
1320     /**
1321      * @dev Called during each token transfer to set the 24bit `extraData` field.
1322      * Intended to be overridden by the cosumer contract.
1323      *
1324      * `previousExtraData` - the value of `extraData` before transfer.
1325      *
1326      * Calling conditions:
1327      *
1328      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1329      * transferred to `to`.
1330      * - When `from` is zero, `tokenId` will be minted for `to`.
1331      * - When `to` is zero, `tokenId` will be burned by `from`.
1332      * - `from` and `to` are never both zero.
1333      */
1334     function _extraData(
1335         address from,
1336         address to,
1337         uint24 previousExtraData
1338     ) internal view virtual returns (uint24) {}
1339 
1340     /**
1341      * @dev Returns the next extra data for the packed ownership data.
1342      * The returned result is shifted into position.
1343      */
1344     function _nextExtraData(
1345         address from,
1346         address to,
1347         uint256 prevOwnershipPacked
1348     ) private view returns (uint256) {
1349         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1350         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1351     }
1352 
1353     // =============================================================
1354     //                       OTHER OPERATIONS
1355     // =============================================================
1356 
1357     /**
1358      * @dev Returns the message sender (defaults to `msg.sender`).
1359      *
1360      * If you are writing GSN compatible contracts, you need to override this function.
1361      */
1362     function _msgSenderERC721A() internal view virtual returns (address) {
1363         return msg.sender;
1364     }
1365 
1366     /**
1367      * @dev Converts a uint256 to its ASCII string decimal representation.
1368      */
1369     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1370         assembly {
1371             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1372             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
1373             // We will need 1 32-byte word to store the length,
1374             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1375             str := add(mload(0x40), 0x80)
1376             // Update the free memory pointer to allocate.
1377             mstore(0x40, str)
1378 
1379             // Cache the end of the memory to calculate the length later.
1380             let end := str
1381 
1382             // We write the string from rightmost digit to leftmost digit.
1383             // The following is essentially a do-while loop that also handles the zero case.
1384             // prettier-ignore
1385             for { let temp := value } 1 {} {
1386                 str := sub(str, 1)
1387                 // Write the character to the pointer.
1388                 // The ASCII index of the '0' character is 48.
1389                 mstore8(str, add(48, mod(temp, 10)))
1390                 // Keep dividing `temp` until zero.
1391                 temp := div(temp, 10)
1392                 // prettier-ignore
1393                 if iszero(temp) { break }
1394             }
1395 
1396             let length := sub(end, str)
1397             // Move the pointer 32 bytes leftwards to make room for the length.
1398             str := sub(str, 0x20)
1399             // Store the length.
1400             mstore(str, length)
1401         }
1402     }
1403 }
1404 
1405 
1406 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1407 
1408 
1409 
1410 /**
1411  * @dev String operations.
1412  */
1413 library Strings {
1414     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1415     uint8 private constant _ADDRESS_LENGTH = 20;
1416 
1417     /**
1418      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1419      */
1420     function toString(uint256 value) internal pure returns (string memory) {
1421         // Inspired by OraclizeAPI's implementation - MIT licence
1422         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1423 
1424         if (value == 0) {
1425             return "0";
1426         }
1427         uint256 temp = value;
1428         uint256 digits;
1429         while (temp != 0) {
1430             digits++;
1431             temp /= 10;
1432         }
1433         bytes memory buffer = new bytes(digits);
1434         while (value != 0) {
1435             digits -= 1;
1436             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1437             value /= 10;
1438         }
1439         return string(buffer);
1440     }
1441 
1442     /**
1443      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1444      */
1445     function toHexString(uint256 value) internal pure returns (string memory) {
1446         if (value == 0) {
1447             return "0x00";
1448         }
1449         uint256 temp = value;
1450         uint256 length = 0;
1451         while (temp != 0) {
1452             length++;
1453             temp >>= 8;
1454         }
1455         return toHexString(value, length);
1456     }
1457 
1458     /**
1459      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1460      */
1461     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1462         bytes memory buffer = new bytes(2 * length + 2);
1463         buffer[0] = "0";
1464         buffer[1] = "x";
1465         for (uint256 i = 2 * length + 1; i > 1; --i) {
1466             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1467             value >>= 4;
1468         }
1469         require(value == 0, "Strings: hex length insufficient");
1470         return string(buffer);
1471     }
1472 
1473     /**
1474      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1475      */
1476     function toHexString(address addr) internal pure returns (string memory) {
1477         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1478     }
1479 }
1480 
1481 
1482 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1483 
1484 
1485 
1486 
1487 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1488 
1489 
1490 
1491 /**
1492  * @dev Provides information about the current execution context, including the
1493  * sender of the transaction and its data. While these are generally available
1494  * via msg.sender and msg.data, they should not be accessed in such a direct
1495  * manner, since when dealing with meta-transactions the account sending and
1496  * paying for execution may not be the actual sender (as far as an application
1497  * is concerned).
1498  *
1499  * This contract is only required for intermediate, library-like contracts.
1500  */
1501 abstract contract Context {
1502     function _msgSender() internal view virtual returns (address) {
1503         return msg.sender;
1504     }
1505 
1506     function _msgData() internal view virtual returns (bytes calldata) {
1507         return msg.data;
1508     }
1509 }
1510 
1511 
1512 /**
1513  * @dev Contract module which provides a basic access control mechanism, where
1514  * there is an account (an owner) that can be granted exclusive access to
1515  * specific functions.
1516  *
1517  * By default, the owner account will be the one that deploys the contract. This
1518  * can later be changed with {transferOwnership}.
1519  *
1520  * This module is used through inheritance. It will make available the modifier
1521  * `onlyOwner`, which can be applied to your functions to restrict their use to
1522  * the owner.
1523  */
1524 abstract contract Ownable is Context {
1525     address private _owner;
1526 
1527     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1528 
1529     /**
1530      * @dev Initializes the contract setting the deployer as the initial owner.
1531      */
1532     constructor() {
1533         _transferOwnership(_msgSender());
1534     }
1535 
1536     /**
1537      * @dev Throws if called by any account other than the owner.
1538      */
1539     modifier onlyOwner() {
1540         _checkOwner();
1541         _;
1542     }
1543 
1544     /**
1545      * @dev Returns the address of the current owner.
1546      */
1547     function owner() public view virtual returns (address) {
1548         return _owner;
1549     }
1550 
1551     /**
1552      * @dev Throws if the sender is not the owner.
1553      */
1554     function _checkOwner() internal view virtual {
1555         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1556     }
1557 
1558     /**
1559      * @dev Leaves the contract without owner. It will not be possible to call
1560      * `onlyOwner` functions anymore. Can only be called by the current owner.
1561      *
1562      * NOTE: Renouncing ownership will leave the contract without an owner,
1563      * thereby removing any functionality that is only available to the owner.
1564      */
1565     function renounceOwnership() public virtual onlyOwner {
1566         _transferOwnership(address(0));
1567     }
1568 
1569     /**
1570      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1571      * Can only be called by the current owner.
1572      */
1573     function transferOwnership(address newOwner) public virtual onlyOwner {
1574         require(newOwner != address(0), "Ownable: new owner is the zero address");
1575         _transferOwnership(newOwner);
1576     }
1577 
1578     /**
1579      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1580      * Internal function without access restriction.
1581      */
1582     function _transferOwnership(address newOwner) internal virtual {
1583         address oldOwner = _owner;
1584         _owner = newOwner;
1585         emit OwnershipTransferred(oldOwner, newOwner);
1586     }
1587 }
1588 
1589 
1590 contract PepeYogaClub is ERC721A, Ownable {
1591 
1592     string public baseURI = "ipfs://QmTLWN9WPq5L9eS9EKcTn2rqUCzr9QK5sd8DYVkkL7yguL/";
1593     string public contractURI = "ipfs://QmUvB8sKL4XFTxbMkL9FykiqLgrXeBV1mUkdzWMWhachvD";
1594 
1595     uint256 public MAX_PER_WALLET = 11;
1596     uint256 public constant MAX_SUPPLY = 2069;
1597     uint256 public price = 0.0069 ether;
1598 
1599     bool public paused = true;
1600 
1601     constructor() ERC721A("PepeYogaClub", "PYC") {}
1602 
1603     function mint(uint256 _amount) external payable {
1604         address _caller = _msgSender();
1605         require(!paused, "Paused");
1606         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1607         require(_amount > 0, "No 0 mints");
1608         require(_numberMinted(_caller) + _amount <= MAX_PER_WALLET, "Exceeds max per wallet");
1609         require(tx.origin == _caller, "No contracts");
1610         uint256 cost = _amount * price;
1611         if(_numberMinted(_caller) == 0) cost -= price;
1612         require(msg.value >= cost, "Invalid funds provided");
1613 
1614         _safeMint(_caller, _amount);
1615     }
1616 
1617     function _startTokenId() internal override view virtual returns (uint256) {
1618         return 1;
1619     }
1620 
1621     function minted(address _owner) public view returns (uint256) {
1622         return _numberMinted(_owner);
1623     }
1624 
1625     function withdraw() external onlyOwner {
1626         uint256 balance = address(this).balance;
1627         (bool success, ) = _msgSender().call{value: balance}("");
1628         require(success, "Failed to send");
1629     }
1630 
1631     function teamMint(address[] memory _to, uint256[] memory _amount) external onlyOwner {
1632         require(_to.length == _amount.length, "Not same lenght");
1633         for (uint256 i; i < _to.length; i++) {
1634             _safeMint(_to[i], _amount[i]);
1635         }
1636     }
1637 
1638     function setMaxPerWallet(uint256 _max) external onlyOwner {
1639         MAX_PER_WALLET = _max;
1640     }
1641 
1642     function setPrice(uint256 _price) external onlyOwner {
1643         price = _price;
1644     }
1645 
1646     function toggleMint() external onlyOwner {
1647         paused = !paused;
1648     }
1649 
1650     function setBaseURI(string memory baseURI_) external onlyOwner {
1651         baseURI = baseURI_;
1652     }
1653 
1654     function setContractURI(string memory _contractURI) external onlyOwner {
1655         contractURI = _contractURI;
1656     }
1657 
1658     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1659         require(_exists(_tokenId), "Token does not exist.");
1660         return bytes(baseURI).length > 0 ? string(
1661             abi.encodePacked(
1662               baseURI,
1663               Strings.toString(_tokenId),
1664               ".json"
1665             )
1666         ) : "";
1667     }
1668 }