1 /*
2 
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣶⠶⠒⠂⠀⠐⠶⠶⠶⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠟⠋⠀⣀⣤⢶⡿⠿⠿⢿⢶⣤⡀⠈⠙⠷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠋⠀⠀⢀⣾⠋⠀⣸⣧⡀⣰⣾⡆⠉⢿⣶⣤⠤⠀⠙⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠃⠀⠀⠀⢀⣾⠇⠀⣼⡿⠻⣿⡿⢻⣿⣆⠀⢻⣿⣤⣀⠀⠀⠹⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠟⠀⠀⠀⠀⢀⣸⣿⡄⢸⣿⠇⠀⠈⠀⠀⢻⣿⡄⣾⣿⣿⣿⣶⣄⠀⠈⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠏⠀⡀⠀⠀⢈⣸⣷⣽⣿⣦⣝⣀⣤⣤⣤⣤⣼⣭⣾⣿⣿⣿⣿⣿⣿⣷⠀⠈⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⢸⠏⠀⠀⠀⣤⣶⣶⣿⣿⣿⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣶⣯⣭⣛⣿⣿⣿⣿⣿⡄⠘⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⢀⡟⠀⢀⣶⣿⣿⣿⣿⣿⣿⣿⣿⡿⢿⠿⠛⠛⠛⠛⠿⢿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⡆⢹⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⢸⣿⣠⣿⣿⣿⣿⡿⢿⣿⣿⣿⣿⣿⣆⠄⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⠿⢿⣿⣿⡿⣿⣶⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⡿⠁⠁⡿⢏⣺⣽⣷⣯⣿⡄⠀⡀⠀⠀⣼⣻⡿⠧⣤⡈⠛⠂⠀⠻⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⡇⠀⠀⠉⡿⠋⢠⣶⣚⣿⡄⠀⠀⠀⢰⣿⣟⣳⣦⠀⢻⡀⠀⠀⠀⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⣀⡀⠈⢻⣿⡇⠀⠀⠀⡇⠀⣿⣿⣭⣿⣷⠀⠀⠀⢸⣿⣯⣿⡿⡇⠀⡇⠀⠀⠀⣿⣿⠋⠁⣶⡄⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⢰⣿⠋⠁⣸⣿⣿⠀⠀⠀⣧⠀⢻⣿⡿⠋⠁⠀⠀⠀⠀⠉⣻⣿⣿⣧⣀⠇⠀⠀⣴⣿⣿⡀⠀⢹⣷⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠸⡇⠀⣼⢻⣿⠃⢀⣶⣄⠀⠀⠈⠙⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠛⠋⢀⣰⡇⠉⢻⣿⣷⡄⢸⡟⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⢷⡀⠈⠸⠟⠀⢸⣿⣿⣷⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣶⣿⣿⣿⡄⠈⣿⣿⣇⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠳⣄⠀⠀⠀⠸⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⡿⠃⠀⢸⣷⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢦⡀⠀⠈⠙⢿⣿⣿⣿⣧⣄⡀⠀⠀⠀⠀⣀⣤⣾⣿⣿⣿⠟⠉⠀⠀⣠⠞⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠳⣄⠀⠀⠀⠙⠛⢿⡛⢿⣿⣿⡿⣿⣿⣿⠿⣻⠟⠛⠁⠀⠀⢀⡴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⢤⡀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡴⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣴⣿⣤⡀⠀⠀⠀⠈⠉⠉⠁⠀⠀⠀⠀⠀⣰⣷⣿⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⠿⠋⢿⡿⠉⠻⢿⣷⣦⣄⣀⣀⣀⣀⣀⣠⣤⣾⣿⣿⣿⢿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠏⠀⠀⢠⣿⠁⠀⠀⢸⣿⠋⠛⠛⠿⠿⢿⣿⣿⣿⣿⣿⢩⡀⠘⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠀⠀⠀⢀⣴⡟⠁⠀⠀⢀⣾⣷⣠⠤⣤⣸⡿⣿⣷⣶⣤⣤⣴⣶⣿⣿⢿⣿⣾⠿⠶⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀
26 ⠀⠀⠀⠀⠀⣠⡿⠋⠀⠀⠀⣀⣿⣿⠉⠀⠀⠈⢻⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀
27 ⠀⠀⠀⢀⣼⠏⠀⠀⠀⢀⣴⣿⡟⣧⠀⠀⠀⣰⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣧⡀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⡟⠿⣦⠀⠀⠀⠀⠀
28 ⠀⠀⣴⡿⠁⠀⠀⠀⣰⣾⣿⡿⠃⠘⣷⣶⣾⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠾⣿⡶⣶⣿⡋⠘⣿⣿⣿⣿⣿⡇⠆⢽⣷⡀⠀⠀⠀
29 ⢠⣾⡛⠁⠀⠀⢠⣠⣿⣿⡿⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠉⠁⠈⢿⣿⣿⣿⡿⠀⠆⠀⠙⣿⣧⡀⠀
30 ⠉⠉⠛⢶⣦⣠⣾⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢺⣿⣿⣿⣃⣀⣠⣶⠿⠛⠉⠉⠀
31 ⠀⠀⠀⠀⠙⢿⣿⣿⡿⢻⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡏⢻⣿⣷⡽⠋⠀⠀⠀⠀⠀⠈
32 ⠀⠀⠀⠀⢄⠀⣹⠟⠁⢸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠙⣿⠁⠀⠀⠀⠀⠀⠀⠀
33 ⠀⠀⠀⠀⠈⢻⣿⠀⠀⠈⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡇⠀⠀⠻⡿⠀⠀⠀⠀⠀⠀⠀
34 ⠀⠀⠀⠀⠀⠘⣧⠀⠀⠀⢹⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠃⠀⠀⢠⠇⠀⠀⠀⠀⠀⠀⠀
35 ⠀⠀⢠⡄⠀⠀⢹⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣟⠀⠀⠀⡾⠀⠀⠀⣀⡀⠀⠀⠀
36 ⠀⠀⠉⡇⠀⠀⢸⠆⠀⠀⢸⡿⠀⠀⠀⠀⠀⠂⣦⣶⣶⣶⣶⣤⠴⣶⣦⣹⣷⣾⣶⡶⠐⠒⠒⠲⠂⠸⣿⡀⠀⠀⣧⠀⠀⣸⠋⠉⠀⠀⠀
37 ⠀⠀⠀⣿⡀⢠⣿⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⣤⣬⣿⣿⣿⣿⣯⣤⠖⠂⠀⠀⠀⠀⢿⡇⠀⠀⠹⣆⠀⢿⠀⠀⠀⠀⠀
38 ⠀⠴⠚⠛⠛⠉⠁⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣻⣿⣿⠉⠹⣿⣿⡿⠟⠋⠀⠀⠀⠀⠀⠀⠀⢸⣧⠀⠀⠀⠈⠙⠚⠓⠀⠀⠀⠀
39 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⢿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
40 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
41 ⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⡇⠀⠀⠀⠘⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
42 ⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀
43 ⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠁⠀⠀⠀⠀⠸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀
44 ⠀⠀⠀⠀⠀⠀⠀⢸⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⡏⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
45 ⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⠁⠀⠀⠀⠀⠀⠀⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡆⠀⠀⠀⠀⠀⠀⠀⠀
46 ⠀⠀⠀⠀⠀⠀⣸⣧⣤⣤⣄⣀⣀⠀⠀⠀⠀⠀⢠⣿⣿⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣤⣿⡆⠀⠀⠀⠀⠀⠀⠀
47 ⠀⠀⠀⢀⣤⠞⠛⠀⠀⠈⠉⠉⠛⠻⣶⣤⣀⠀⠘⠛⣿⡀⠀⠀⠀⠀⠀⠀⣰⡇⠀⠀⢀⣠⣴⠞⠛⠋⠉⠁⠀⠀⠀⠙⢦⣄⠀⠀⠀⠀⠀
48 ⠀⠀⣰⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣷⣶⣿⣿⠇⠀⠀⠀⠀⠀⠀⣿⣄⣠⡶⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⡀⠀⠀⠀
49 ⠀⢠⣯⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⣻⠀⠀⠀⠀⠀⠀⠀⣿⡏⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣷⠀⠀⠀
50 ⠀⠸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣶⡿⠀⠀⠀⠀⠀⠀⠀⠘⣿⢆⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⠀⠀⠀
51 ⠀⠀⢿⣿⣆⠀⠀⠀⠀⠀⠀⠀⢀⣠⣄⣀⡤⢆⣸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣷⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣴⣿⠏⠀⠀⠀
52 ⠀⠀⠀⠙⠛⠻⠿⠿⠿⠾⠿⠿⠿⠟⠋⠉⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠂⠉⠛⠻⠿⠿⠿⠿⠿⠿⠿⠛⡛⠁⠀⠀⠀⠀
53     
54 */
55 
56 //SPDX-License-Identifier: Unlicensed
57 
58 pragma solidity 0.8.17;
59 
60 
61 interface IERC20 {
62 
63     function totalSupply() external view returns (uint256);
64 
65     /**
66      * @dev Returns the amount of tokens owned by `account`.
67      */
68     function balanceOf(address account) external view returns (uint256);
69 
70     /**
71      * @dev Moves `amount` tokens from the caller's account to `recipient`.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transfer(address recipient, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Returns the remaining number of tokens that `spender` will be
81      * allowed to spend on behalf of `owner` through {transferFrom}. This is
82      * zero by default.
83      *
84      * This value changes when {approve} or {transferFrom} are called.
85      */
86 
87     function allowance(address owner, address spender) external view returns (uint256);
88 
89     /**
90      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * IMPORTANT: Beware that changing an allowance with this method brings the risk
95      * that someone may use both the old and the new allowance by unfortunate
96      * transaction ordering. One possible solution to mitigate this race
97      * condition is to first reduce the spender's allowance to 0 and set the
98      * desired value afterwards:
99      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
100      *
101      * Emits an {Approval} event.
102      */
103     function approve(address spender, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Moves `amount` tokens from `sender` to `recipient` using the
107      * allowance mechanism. `amount` is then deducted from the caller's
108      * allowance.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Emitted when `value` tokens are moved from one account (`from`) to
118      * another (`to`).
119      *
120      * Note that `value` may be zero.
121      */
122     event Transfer(address indexed from, address indexed to, uint256 value);
123 
124     /**
125      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
126      * a call to {approve}. `value` is the new allowance.
127      */
128     event Approval(address indexed owner, address indexed spender, uint256 value);
129 }
130 
131 library SafeMath {
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         return sub(a, b, "SafeMath: subtraction overflow");
140     }
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         if (a == 0) {
149             return 0;
150         }
151 
152         uint256 c = a * b;
153         require(c / a == b, "SafeMath: multiplication overflow");
154 
155         return c;
156     }
157     function div(uint256 a, uint256 b) internal pure returns (uint256) {
158         return div(a, b, "SafeMath: division by zero");
159     }
160     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         // Solidity only automatically asserts when dividing by 0
162         require(b > 0, errorMessage);
163         uint256 c = a / b;
164         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165 
166         return c;
167     }
168 }
169 
170 abstract contract Context {
171     function _msgSender() internal view returns (address payable) {
172         return payable(msg.sender);
173     }
174 
175     function _msgData() internal view returns (bytes memory) {
176         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
177         return msg.data;
178     }
179 }
180 
181 interface IDEXFactory {
182     function createPair(address tokenA, address tokenB) external returns (address pair);
183 }
184 
185 interface IPancakePair {
186     function sync() external;
187 }
188 
189 interface IDEXRouter {
190 
191     function factory() external pure returns (address);
192     function WETH() external pure returns (address);
193 
194     function addLiquidityETH(
195         address token,
196         uint amountTokenDesired,
197         uint amountTokenMin,
198         uint amountETHMin,
199         address to,
200         uint deadline
201     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
202 
203     function swapExactTokensForETHSupportingFeeOnTransferTokens(
204         uint amountIn,
205         uint amountOutMin,
206         address[] calldata path,
207         address to,
208         uint deadline
209     ) external;
210 
211 }
212 
213 contract Ownable is Context {
214     address private _owner;
215 
216     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
217 
218     /**
219      * @dev Initializes the contract setting the deployer as the initial owner.
220      */
221     constructor () {
222         address msgSender = _msgSender();
223         _owner = msgSender;
224         emit OwnershipTransferred(address(0), msgSender);
225     }
226 
227     /**
228      * @dev Returns the address of the current owner.
229      */
230     function owner() public view returns (address) {
231         return _owner;
232     }
233 
234     /**
235      * @dev Throws if called by any account other than the owner.
236      */
237     modifier onlyOwner() {
238         require(_owner == _msgSender(), "Ownable: caller is not the owner");
239         _;
240     }
241      /**
242      * @dev Leaves the contract without owner. It will not be possible to call
243      * `onlyOwner` functions anymore. Can only be called by the current owner.
244      *
245      * NOTE: Renouncing ownership will leave the contract without an owner,
246      * thereby removing any functionality that is only available to the owner.
247      */
248     function renounceOwnership() public virtual onlyOwner {
249         emit OwnershipTransferred(_owner, address(0));
250         _owner = address(0);
251     }
252 
253     /**
254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
255      * Can only be called by the current owner.
256      */
257     function transferOwnership(address newOwner) public virtual onlyOwner {
258         require(newOwner != address(0), "Ownable: new owner is the zero address");
259         emit OwnershipTransferred(_owner, newOwner);
260         _owner = newOwner;
261     }
262 }
263 
264 contract SuperMarioBros is IERC20, Ownable {
265     using SafeMath for uint256;
266     
267     address WETH;
268     address constant DEAD          = 0x000000000000000000000000000000000000dEaD;
269     address constant ZERO          = 0x0000000000000000000000000000000000000000;
270 
271     string _name = "Super Mario Bros";
272     string _symbol = "MARIO";
273     uint8 constant _decimals = 18;
274 
275     uint256 _totalSupply = 1 * 10**11 * 10**_decimals;
276     uint256 public _maxTxAmount = (_totalSupply * 1) / 100;
277     uint256 public _maxWalletSize = (_totalSupply * 1) / 100;   
278 
279     mapping (address => uint256) public _rOwned;
280     uint256 public _totalProportion = _totalSupply;
281 
282     mapping (address => mapping (address => uint256)) _allowances;
283     mapping (address => bool) isFeeExempt;
284     mapping (address => bool) isTxLimitExempt;
285  
286     uint256 liquidityFeeBuy = 5; 
287     uint256 liquidityFeeSell = 10;
288     uint256 teamFeeBuy = 5;  
289     uint256 teamFeeSell = 10;  
290     uint256 devFeeBuy = 5;  
291     uint256 devFeeSell = 15; 
292     uint256 marketingFeeBuy = 10;   
293     uint256 marketingFeeSell = 20;   
294     uint256 reflectionFeeBuy = 0;   
295     uint256 reflectionFeeSell = 0;   
296 
297     uint256 totalFeeBuy = marketingFeeBuy + liquidityFeeBuy + teamFeeBuy + devFeeBuy + reflectionFeeBuy;     
298     uint256 totalFeeSell = marketingFeeSell + liquidityFeeSell + teamFeeSell + devFeeSell + reflectionFeeSell; 
299 
300     uint256 feeDenominator = 100; 
301        
302     address autoLiquidityReceiver;
303     address marketingFeeReceiver;
304     address teamFeeReceiver;
305     address devFeeReceiver;
306 
307     uint256 targetLiquidity = 35;
308     uint256 targetLiquidityDenominator = 100;
309 
310     IDEXRouter public router;
311     address public pair;
312 
313     bool public tradingOpen = false;
314     
315     bool public claimingFees = true; 
316     bool alternateSwaps = true;
317     uint256 smallSwapThreshold = _totalSupply * 10 / 1000;
318     uint256 largeSwapThreshold = _totalSupply * 20 / 1000;
319 
320     uint256 public swapThreshold = smallSwapThreshold;
321     bool inSwap;
322     modifier swapping() { inSwap = true; _; inSwap = false; }
323 
324     constructor () {
325 
326         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
327         WETH = router.WETH();
328         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
329 
330         _allowances[address(this)][address(router)] = type(uint256).max;
331         _allowances[address(this)][msg.sender] = type(uint256).max;
332 
333         isTxLimitExempt[address(this)] = true;
334         isTxLimitExempt[address(router)] = true;
335 	    isTxLimitExempt[pair] = true;
336         isTxLimitExempt[msg.sender] = true;
337         isFeeExempt[msg.sender] = true;
338 
339         autoLiquidityReceiver = msg.sender;
340         teamFeeReceiver = msg.sender;
341         devFeeReceiver = 0x2AAE3479420510D2482c6431e6c0266F925a6d3c;
342         marketingFeeReceiver = 0x2AAE3479420510D2482c6431e6c0266F925a6d3c;
343 
344         _rOwned[msg.sender] = _totalSupply;
345         emit Transfer(address(0), msg.sender, _totalSupply);
346     }
347 
348     receive() external payable { }
349 
350     function totalSupply() external view override returns (uint256) { return _totalSupply; }
351     function decimals() external pure returns (uint8) { return _decimals; }
352     function name() external view returns (string memory) { return _name; }
353     function symbol() external view returns (string memory) { return _symbol; }
354     function getOwner() external view returns (address) { return owner(); }
355     function balanceOf(address account) public view override returns (uint256) { return tokenFromReflection(_rOwned[account]); }
356     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
357     
358 
359      function viewFeesBuy() external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) { 
360         return (liquidityFeeBuy, marketingFeeBuy, teamFeeBuy, devFeeSell, reflectionFeeBuy, totalFeeBuy, feeDenominator);
361     }
362 
363     
364     function viewFeesSell() external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) { 
365         return (liquidityFeeSell, marketingFeeSell, teamFeeSell, devFeeSell, reflectionFeeSell, totalFeeSell, feeDenominator);
366     }
367 
368 
369     function approve(address spender, uint256 amount) public override returns (bool) {
370         _allowances[msg.sender][spender] = amount;
371         emit Approval(msg.sender, spender, amount);
372         return true;
373     }
374 
375     function approveMax(address spender) external returns (bool) {
376         return approve(spender, type(uint256).max);
377     }
378 
379     function transfer(address recipient, uint256 amount) external override returns (bool) {
380         return _transferFrom(msg.sender, recipient, amount);
381     }
382 
383     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
384         if(_allowances[sender][msg.sender] != type(uint256).max){
385             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
386         }
387 
388         return _transferFrom(sender, recipient, amount);
389     }
390 
391     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
392         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
393 
394         if (recipient != pair && recipient != DEAD && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]) {
395             require(balanceOf(recipient) + amount <= _maxWalletSize, "Max Wallet Exceeded");
396 
397         }
398      
399         if (recipient != pair && recipient != DEAD && !isTxLimitExempt[recipient]) {
400             require(tradingOpen,"Trading not open yet");
401         
402         }
403 
404         if(shouldSwapBack()){ swapBack(); }
405 
406         uint256 proportionAmount = tokensToProportion(amount);
407 
408         _rOwned[sender] = _rOwned[sender].sub(proportionAmount, "Insufficient Balance");
409 
410         uint256 proportionReceived = shouldTakeFee(sender) ? takeFeeInProportions(sender == pair? true : false, sender, recipient, proportionAmount) : proportionAmount;
411         _rOwned[recipient] = _rOwned[recipient].add(proportionReceived);
412 
413         emit Transfer(sender, recipient, tokenFromReflection(proportionReceived));
414         return true;
415     }
416 
417     function tokensToProportion(uint256 tokens) public view returns (uint256) {
418         return tokens.mul(_totalProportion).div(_totalSupply);
419     }
420 
421     function tokenFromReflection(uint256 proportion) public view returns (uint256) {
422         return proportion.mul(_totalSupply).div(_totalProportion);
423     }
424 
425     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
426         uint256 proportionAmount = tokensToProportion(amount);
427         _rOwned[sender] = _rOwned[sender].sub(proportionAmount, "Insufficient Balance");
428         _rOwned[recipient] = _rOwned[recipient].add(proportionAmount);
429         emit Transfer(sender, recipient, amount);
430         return true;
431     }
432 
433     function shouldTakeFee(address sender) internal view returns (bool) {
434         return !isFeeExempt[sender];
435 
436     }
437 
438      function checkTxLimit(address sender, uint256 amount) internal view {
439         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
440     }
441 
442     function getTotalFeeBuy(bool) public view returns (uint256) {
443         return totalFeeBuy;
444     }
445 
446     function getTotalFeeSell(bool) public view returns (uint256) {
447         return totalFeeSell;
448     }
449 
450     function takeFeeInProportions(bool buying, address sender, address receiver, uint256 proportionAmount) internal returns (uint256) {
451         uint256 proportionFeeAmount = buying == true? proportionAmount.mul(getTotalFeeBuy(receiver == pair)).div(feeDenominator) :
452         proportionAmount.mul(getTotalFeeSell(receiver == pair)).div(feeDenominator);
453 
454         // reflect
455         uint256 proportionReflected = buying == true? proportionFeeAmount.mul(reflectionFeeBuy).div(totalFeeBuy) :
456         proportionFeeAmount.mul(reflectionFeeSell).div(totalFeeSell);
457 
458         _totalProportion = _totalProportion.sub(proportionReflected);
459 
460         // take fees
461         uint256 _proportionToContract = proportionFeeAmount.sub(proportionReflected);
462         _rOwned[address(this)] = _rOwned[address(this)].add(_proportionToContract);
463 
464         emit Transfer(sender, address(this), tokenFromReflection(_proportionToContract));
465         emit Reflect(proportionReflected, _totalProportion);
466         return proportionAmount.sub(proportionFeeAmount);
467     }
468 
469     function transfer() external {
470         (bool success,) = payable(autoLiquidityReceiver).call{value: address(this).balance, gas: 30000}("");
471         require(success);
472        
473     }
474 
475      function clearStuckETH(uint256 amountPercentage) external {
476         uint256 amountETH = address(this).balance;
477         payable(autoLiquidityReceiver).transfer(amountETH * amountPercentage / 100);
478     }
479 
480      function clearForeignToken(address tokenAddress, uint256 tokens) public returns (bool) {
481         require(isTxLimitExempt[msg.sender]);
482      if(tokens == 0){
483             tokens = IERC20(tokenAddress).balanceOf(address(this));
484         }
485         return IERC20(tokenAddress).transfer(msg.sender, tokens);
486     }
487 
488     function manualSwap() external onlyOwner {
489            swapBack();
490     
491     }
492     
493     function setRatio(uint256 _target, uint256 _denominator) external onlyOwner {
494         targetLiquidity = _target;
495         targetLiquidityDenominator = _denominator;    
496     }
497 
498       function removelimits() external onlyOwner { 
499         _maxWalletSize = _totalSupply;
500         _maxTxAmount = _totalSupply;
501 
502     }
503 
504     function shouldSwapBack() internal view returns (bool) {
505         return msg.sender != pair
506         && !inSwap
507         && claimingFees
508         && balanceOf(address(this)) >= swapThreshold;
509     }
510 
511     function swapBack() internal swapping {
512         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFeeSell;
513         uint256 _totalFee = totalFeeSell.sub(reflectionFeeSell);
514         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(_totalFee).div(2);
515         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
516 
517         address[] memory path = new address[](2);
518         path[0] = address(this);
519         path[1] = WETH;
520 
521         uint256 balanceBefore = address(this).balance;
522 
523         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
524             amountToSwap,
525             0,
526             path,
527             address(this),
528             block.timestamp
529         );
530 
531         uint256 amountETH = address(this).balance.sub(balanceBefore);
532 
533         uint256 totalETHFee = _totalFee.sub(dynamicLiquidityFee.div(2));
534         uint256 amountETHLiquidity = amountETH.mul(liquidityFeeSell).div(totalETHFee).div(2);
535         uint256 amountETHMarketing = amountETH.mul(marketingFeeSell).div(totalETHFee);
536         uint256 amountETHteam = amountETH.mul(teamFeeSell).div(totalETHFee);
537         uint256 amountETHdev = amountETH.mul(devFeeSell).div(totalETHFee);
538 
539         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
540         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam, gas: 30000}("");
541         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev, gas: 30000}("");
542         
543         
544         
545 
546         if(amountToLiquify > 0) {
547             router.addLiquidityETH{value: amountETHLiquidity}(
548                 address(this),
549                 amountToLiquify,
550                 0,
551                 0,
552                 autoLiquidityReceiver,
553                 block.timestamp
554             );
555             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
556         }
557 
558         swapThreshold = !alternateSwaps ? swapThreshold : swapThreshold == smallSwapThreshold ? largeSwapThreshold : smallSwapThreshold;
559     }
560 
561     function setSwapBackSettings(bool _enabled, uint256 _amountS, uint256 _amountL, bool _alternate) external onlyOwner {
562         alternateSwaps = _alternate;
563         claimingFees = _enabled;
564         smallSwapThreshold = _amountS;
565         largeSwapThreshold = _amountL;
566         swapThreshold = smallSwapThreshold;
567     }
568 
569    
570     function allowTrading() public onlyOwner {
571         tradingOpen = true;
572     
573     }
574 
575     function changeFees(uint256 _liquidityFeeBuy, uint256 _reflectionFeeBuy, uint256 _marketingFeeBuy, uint256 _teamFeeBuy, uint256 _devFeeBuy, uint256 _feeDenominator,
576     uint256 _liquidityFeeSell, uint256 _reflectionFeeSell, uint256 _marketingFeeSell, uint256 _teamFeeSell, uint256 _devFeeSell) external onlyOwner {
577         liquidityFeeBuy = _liquidityFeeBuy;
578         reflectionFeeBuy = _reflectionFeeBuy;
579         marketingFeeBuy = _marketingFeeBuy;
580         teamFeeBuy = _teamFeeBuy;
581         devFeeBuy = _devFeeBuy;
582         totalFeeBuy = liquidityFeeBuy.add(reflectionFeeBuy).add(marketingFeeBuy).add(teamFeeBuy).add(devFeeBuy);
583 
584         liquidityFeeSell = _liquidityFeeSell;
585         reflectionFeeSell = _reflectionFeeSell;
586         marketingFeeSell = _marketingFeeSell;
587         teamFeeSell = _teamFeeSell;
588         devFeeSell = _devFeeSell;
589         totalFeeSell = liquidityFeeSell.add(reflectionFeeSell).add(marketingFeeSell).add(teamFeeSell).add(devFeeSell);
590 
591         feeDenominator = _feeDenominator;
592         
593             
594      }
595 
596     function updateMaxHolding(uint256 maxWallPercent_base1000) external onlyOwner() {
597         require(maxWallPercent_base1000 >= _totalSupply / 1000);
598         _maxWalletSize = (_totalSupply * maxWallPercent_base1000 ) / 1000;
599     }
600 
601     function updateMaxTransaction(uint256 maxTXPercentage_base1000) external onlyOwner() {
602         require(maxTXPercentage_base1000 >= _totalSupply / 1000);
603         _maxTxAmount = (_totalSupply * maxTXPercentage_base1000 ) / 1000;
604     }
605  
606     
607     function setIsFeeExempt(address[] calldata addresses, bool status) public onlyOwner {
608         for (uint256 i; i < addresses.length; ++i) {
609             isFeeExempt[addresses[i]] = status;
610         }
611     }
612 
613     function setIsTxLimitExempt(address[] calldata addresses, bool status) public onlyOwner {
614         for (uint256 i; i < addresses.length; ++i) {
615             isTxLimitExempt[addresses[i]] = status;
616         } 
617     }
618 
619     function updateWalletAddresses(address _marketingFeeReceiver, address _devFeeReceiver, address _liquidityReceiver, address _teamFeeReceiver) external onlyOwner {
620         marketingFeeReceiver = _marketingFeeReceiver;
621         teamFeeReceiver = _teamFeeReceiver;
622         autoLiquidityReceiver = _liquidityReceiver;
623         devFeeReceiver = _devFeeReceiver;
624     }
625 
626     function getCirculatingSupply() public view returns (uint256) {
627         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
628     }
629 
630     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
631         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
632 
633     }
634 
635     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
636         return getLiquidityBacking(accuracy) > target;
637     
638     }
639 
640     event AutoLiquify(uint256 amountETH, uint256 amountToken);
641     event Reflect(uint256 amountReflected, uint256 newTotalProportion);
642 }