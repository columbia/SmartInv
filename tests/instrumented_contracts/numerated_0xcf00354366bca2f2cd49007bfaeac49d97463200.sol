1 contract ConnectSix {
2 
3   uint8 constant public board_size = 19;
4 
5   Game[] public games;
6 
7   struct Game {
8       mapping(uint8 => mapping(uint8 => uint8)) board;
9       uint8[] move_history;
10       address[3] players;
11       // 0 means game did not start yet
12       uint8 turn;
13       // Either 1 or 2. 0 means not finished
14       uint8 winner;
15       // true if players agreed to a draw
16       uint time_per_move;
17       // if move is not made by this time, opponent can claim victory
18       uint deadline;
19       // amount player 1 put in
20       uint player_1_stake;
21       // amount player 2 must send to join
22       uint player_2_stake;
23   }
24 
25   event LogGameCreated(uint game_num);
26   event LogGameStarted(uint game_num);
27   event LogVictory(uint game_num, uint8 winner);
28   event LogMoveMade(uint game_num, uint8 x1, uint8 y1, uint8 x2, uint8 y2);
29 
30   function new_game(uint _time_per_move, uint opponent_stake) {
31     games.length++;
32     Game g = games[games.length - 1];
33     g.players[1] = msg.sender;
34     g.time_per_move = _time_per_move;
35     g.player_1_stake = msg.value;
36     g.player_2_stake = opponent_stake;
37     // make the first move in the center of the board
38     g.board[board_size / 2][board_size / 2] = 1;
39     LogGameCreated(games.length - 1);
40   }
41 
42   function join_game(uint game_num) {
43     Game g = games[game_num];
44     if (g.turn != 0 || g.player_2_stake != msg.value) {
45       throw;
46     }
47     g.players[2] = msg.sender;
48     // It's the second player's turn because the first player automatically makes a single move in the center
49     g.turn = 2;
50     g.deadline = now + g.time_per_move;
51     LogGameStarted(game_num);
52   }
53 
54   function player_1(uint game_num) constant returns (address) {
55     return games[game_num].players[1];
56   }
57   
58   function player_2(uint game_num) constant returns (address) {
59     return games[game_num].players[2];
60   }
61 
62   function board(uint game_num, uint8 x, uint8 y) constant returns (uint8) {
63     return games[game_num].board[x][y];
64   }
65 
66   function move_history(uint game_num) constant returns (uint8[]) {
67       return games[game_num].move_history;
68   }
69 
70   function single_move(uint game_num, uint8 x, uint8 y) internal {
71     if (x > board_size || y > board_size) {
72       throw;
73     }
74     Game g = games[game_num];
75     if (g.board[x][y] != 0) {
76       throw;
77     }
78     g.board[x][y] = g.turn;
79   }
80 
81   function make_move(uint game_num, uint8 x1, uint8 y1, uint8 x2, uint8 y2) {
82     Game g = games[game_num];
83     if (g.winner != 0 || msg.sender != g.players[g.turn]) {
84       throw;
85     }
86     single_move(game_num, x1, y1);
87     single_move(game_num, x2, y2);
88     g.turn = 3 - g.turn;
89     g.deadline = now + g.time_per_move;
90     g.move_history.length++;
91     g.move_history[g.move_history.length - 1] = x1;
92     g.move_history.length++;
93     g.move_history[g.move_history.length - 1] = y1;
94     g.move_history.length++;
95     g.move_history[g.move_history.length - 1] = x2;
96     g.move_history.length++;
97     g.move_history[g.move_history.length - 1] = y2;
98     LogMoveMade(game_num, x1, y1, x2, y2);
99   }
100 
101   function make_move_and_claim_victory(uint game_num, uint8 x1, uint8 y1, uint8 x2, uint8 y2, uint8 wx, uint8 wy, uint8 dir) {
102     make_move(game_num, x1, y1, x2, y2);
103     claim_victory(game_num, wx, wy, dir);
104   }
105   
106   function pay_winner(uint game_num) internal {
107     Game g = games[game_num];
108     uint amount = g.player_1_stake + g.player_2_stake;
109     if (amount > 0 && !g.players[g.winner].send(amount)) {
110       throw;
111     }
112   }
113 
114   function claim_time_victory(uint game_num) {
115     Game g = games[game_num];
116     if (g.winner != 0 || g.deadline == 0 || now <= g.deadline) {
117       throw;
118     }
119     g.winner = 3 - g.turn;
120     pay_winner(game_num);
121     LogVictory(game_num, g.winner);
122   }
123 
124   function claim_victory(uint game_num, uint8 x, uint8 y, uint8 dir) {
125     Game g = games[game_num];
126     if (x > board_size 
127         || y > board_size
128         || g.winner != 0
129         || g.board[x][y] == 0
130         || dir > 3) {
131       throw;
132     }
133     // We don't have to worry about overflow and underflows here because all the values outside the 
134     // 19 x 19 board are 0
135     if (dir == 3) {
136       // this is going diagonal (10:30pm)
137       for (uint8 j = 1; j < 6; j++) {
138         if (g.board[x - j*dx][y + j*dy] != g.board[x][y]) {
139           throw;
140         }
141       }
142     } else {
143       uint8 dx = 0;
144       uint8 dy = 0;
145       if (dir == 2) {
146         // diagonal - 1:30pm
147         dx = 1;
148         dy = 1;
149       } else if (dir == 1) {
150         // 12:00pm
151         dy = 1;
152       } else {
153         // 3 pm
154         dx = 1;
155       }
156       for (uint8 i = 1; i < 6; i++) {
157         if (g.board[x + i*dx][y + i*dy] != g.board[x][y]) {
158           throw;
159         }
160       }
161     }
162     g.winner = g.board[x][y];
163     pay_winner(game_num);
164     LogVictory(game_num, g.winner);
165   }
166 }