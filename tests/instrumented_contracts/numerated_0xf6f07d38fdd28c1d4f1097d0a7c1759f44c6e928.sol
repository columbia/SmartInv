1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 contract IERC721 {
5   function balanceOf(address owner) public view returns (uint256 balance);
6   function ownerOf(uint256 tokenId) public view returns (address owner);
7 
8   function approve(address to, uint256 tokenId) public;
9   function getApproved(uint256 tokenId) public view returns (address operator);
10 
11   function setApprovalForAll(address operator, bool _approved) public;
12   function isApprovedForAll(address owner, address operator) public view returns (bool);
13 
14   function transferFrom(address from, address to, uint256 tokenId) public;
15   function safeTransferFrom(address from, address to, uint256 tokenId) public;
16 
17   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
18 }
19 
20 contract Wizards {
21 
22   IERC721 internal constant wizards = IERC721(0x2F4Bdafb22bd92AA7b7552d270376dE8eDccbc1E);
23   uint8 internal constant ELEMENT_FIRE = 1;
24   uint8 internal constant ELEMENT_WIND = 2;
25   uint8 internal constant ELEMENT_WATER = 3;
26   uint256 internal constant MAX_WAIT = 86400; // 1 day timeout
27 
28   uint256 public ids;
29 
30   struct Game {
31     uint256 id;
32     // player 1
33     address player1;
34     uint256 player1TokenId;
35     bytes32 player1SpellHash;
36     uint8 player1Spell;
37     // player 2
38     address player2;
39     uint256 player2TokenId;
40     uint8 player2Spell;
41     uint256 timer;
42     // result
43     address winner;
44   }
45 
46   mapping (uint256 => Game) public games;
47   
48   event GameUpdate(uint256 indexed gameId);
49 
50   function start(uint256 tokenId, bytes32 spellHash) external {
51     // TODO: transfer wizard to this contract
52     // wizards.transferFrom(msg.sender, address(this), tokenId);
53     
54     // increment game ids
55     ids++;
56 
57     // add game details
58     games[ids].id = ids;
59     games[ids].player1 = msg.sender;
60     games[ids].player1TokenId = tokenId;
61     games[ids].player1SpellHash = spellHash;
62     
63     emit GameUpdate(ids);
64   }
65 
66   function join(uint256 gameId, uint256 tokenId, uint8 player2Spell) external {
67     Game storage game = games[gameId];
68 
69     // player 1 must exist
70     require(game.player1 != address(0));
71 
72     // player 2 must not exist
73     require(game.player2 == address(0));
74     
75     // player1 cannot be player2
76     require(game.player1 != game.player2);
77     
78     // spell must be valid
79     require(player2Spell > 0 && player2Spell < 4);
80     
81     // TODO: player 2 wizard power can only be equal to or greater than player 1 wizard
82    
83     // TODO: transfer wizard to this contract
84     // wizards.transferFrom(msg.sender, address(this), tokenId);
85 
86     // update game details
87     game.player2 = msg.sender;
88     game.player2TokenId = tokenId;
89     game.player2Spell = player2Spell;
90     game.timer = now;
91     
92     emit GameUpdate(gameId);
93   }
94 
95   function revealSpell(uint256 gameId, uint256 salt, uint8 player1Spell) external {
96     Game storage game = games[gameId];
97 
98     // player 2 must exist
99     require(game.player2 != address(0));
100     
101     // game must not have ended
102     require(game.winner == address(0));
103     
104     // spell must be valid
105     require(player1Spell > 0 && player1Spell < 4);
106     
107     bytes32 revealHash = keccak256(abi.encodePacked(address(this), salt, player1Spell));
108 
109     // revealed hash must match committed hash
110     require(revealHash == game.player1SpellHash);
111     
112     // set player 1 spell
113     game.player1Spell = player1Spell;
114     
115     uint8 player2Spell = game.player2Spell;
116     
117     emit GameUpdate(gameId);
118 
119     if (player1Spell == player2Spell) {
120       // draw
121       game.winner = address(this);
122       // TODO: return wizards to rightful owners
123       // wizards.transferFrom(address(this), game.player1, game.player1TokenId);
124       // wizards.transferFrom(address(this), game.player2, game.player2TokenId);
125       return;
126     }
127 
128     // Fire is effective against wind and weak to water
129     if (player1Spell == ELEMENT_FIRE) {
130       if (player2Spell == ELEMENT_WIND) {
131         // player 1 wins
132         _winner(gameId, game.player1);
133       } else {
134         // player 2 wins
135         _winner(gameId, game.player2);
136       }
137     }
138 
139     // Water is effective against fire and weak to wind
140     if (player1Spell == ELEMENT_WATER) {
141       if (player2Spell == ELEMENT_FIRE) {
142         // player 1 wins
143         _winner(gameId, game.player1);
144       } else {
145         // player 2 wins
146         _winner(gameId, game.player2);
147       }
148     }
149 
150     // Wind is effective against water and weak to fire
151     if (player1Spell == ELEMENT_WIND) {
152       if (player2Spell == ELEMENT_WATER) {
153         // player 1 wins
154         _winner(gameId, game.player1);
155       } else {
156         // player 2 wins
157         _winner(gameId, game.player2);
158       }
159     }
160   }
161 
162   function timeout(uint256 gameId) public {
163     Game storage game = games[gameId];
164     
165     // game must not have ended
166     require(game.winner == address(0));
167     
168     // game timer must have started
169     require(game.timer != 0);
170 
171     // game must have timed out
172     require(now - game.timer >= MAX_WAIT);
173 
174     // if player 1 did not reveal their spell
175     // player2 wins automatically
176     _winner(gameId, game.player2);
177     
178     emit GameUpdate(gameId);
179   }
180 
181   function _winner(uint256 gameId, address winner) internal {
182     Game storage game = games[gameId];
183     game.winner = winner;
184     // wizards.transferFrom(address(this), winner, game.player2TokenId);
185     // wizards.transferFrom(address(this), winner, game.player1TokenId);
186   }
187   
188   function getGames(uint256 from, uint256 limit, bool descending) public view returns (Game [] memory) {
189     Game [] memory gameArr = new Game[](limit);
190     if (descending) {
191       for (uint256 i = 0; i < limit; i++) {
192         gameArr[i] = games[from - i];
193       }
194     } else {
195       for (uint256 i = 0; i < limit; i++) {
196         gameArr[i] = games[from + i];
197       }
198     }
199     return gameArr;
200   }
201 }