1 pragma solidity ^0.4.2;
2 
3 library Deck {
4 	// returns random number from 0 to 51
5 	// let's say 'value' % 4 means suit (0 - Hearts, 1 - Spades, 2 - Diamonds, 3 - Clubs)
6 	//			 'value' / 4 means: 0 - King, 1 - Ace, 2 - 10 - pip values, 11 - Jacket, 12 - Queen
7 
8 	function deal(address player, uint8 cardNumber) internal returns (uint8) {
9 		uint b = block.number;
10 		uint timestamp = block.timestamp;
11 		return uint8(uint256(keccak256(block.blockhash(b), player, cardNumber, timestamp)) % 52);
12 	}
13 
14 	function valueOf(uint8 card, bool isBigAce) internal constant returns (uint8) {
15 		uint8 value = card / 4;
16 		if (value == 0 || value == 11 || value == 12) { // Face cards
17 			return 10;
18 		}
19 		if (value == 1 && isBigAce) { // Ace is worth 11
20 			return 11;
21 		}
22 		return value;
23 	}
24 
25 	function isAce(uint8 card) internal constant returns (bool) {
26 		return card / 4 == 1;
27 	}
28 
29 	function isTen(uint8 card) internal constant returns (bool) {
30 		return card / 4 == 10;
31 	}
32 }
33 
34 
35 contract BlackJack {
36 	using Deck for *;
37 
38 	uint public minBet = 50 finney; // 0.05 eth
39 	uint public maxBet = 5 ether;
40 
41 	uint8 BLACKJACK = 21;
42 
43   enum GameState { Ongoing, Player, Tie, House }
44 
45 	struct Game {
46 		address player; // address игрока
47 		uint bet; // стывка
48 
49 		uint8[] houseCards; // карты диллера
50 		uint8[] playerCards; // карты игрока
51 
52 		GameState state; // состояние
53 		uint8 cardsDealt;
54 	}
55 
56 	mapping (address => Game) public games;
57 
58 	modifier gameIsGoingOn() {
59 		if (games[msg.sender].player == 0 || games[msg.sender].state != GameState.Ongoing) {
60 			throw; // game doesn't exist or already finished
61 		}
62 		_;
63 	}
64 
65 	event Deal(
66         bool isUser,
67         uint8 _card
68     );
69 
70     event GameStatus(
71     	uint8 houseScore,
72     	uint8 houseScoreBig,
73     	uint8 playerScore,
74     	uint8 playerScoreBig
75     );
76 
77     event Log(
78     	uint8 value
79     );
80 
81 	function BlackJack() {
82 
83 	}
84 
85 	function () payable {
86 		
87 	}
88 
89 	// starts a new game
90 	function deal() public payable {
91 		if (games[msg.sender].player != 0 && games[msg.sender].state == GameState.Ongoing) {
92 			throw; // game is already going on
93 		}
94 
95 		if (msg.value < minBet || msg.value > maxBet) {
96 			throw; // incorrect bet
97 		}
98 
99 		uint8[] memory houseCards = new uint8[](1);
100 		uint8[] memory playerCards = new uint8[](2);
101 
102 		// deal the cards
103 		playerCards[0] = Deck.deal(msg.sender, 0);
104 		Deal(true, playerCards[0]);
105 		houseCards[0] = Deck.deal(msg.sender, 1);
106 		Deal(false, houseCards[0]);
107 		playerCards[1] = Deck.deal(msg.sender, 2);
108 		Deal(true, playerCards[1]);
109 
110 		games[msg.sender] = Game({
111 			player: msg.sender,
112 			bet: msg.value,
113 			houseCards: houseCards,
114 			playerCards: playerCards,
115 			state: GameState.Ongoing,
116 			cardsDealt: 3,
117 		});
118 
119 		checkGameResult(games[msg.sender], false);
120 	}
121 
122 	// deals one more card to the player
123 	function hit() public gameIsGoingOn {
124 		uint8 nextCard = games[msg.sender].cardsDealt;
125 		games[msg.sender].playerCards.push(Deck.deal(msg.sender, nextCard));
126 		games[msg.sender].cardsDealt = nextCard + 1;
127 		Deal(true, games[msg.sender].playerCards[games[msg.sender].playerCards.length - 1]);
128 		checkGameResult(games[msg.sender], false);
129 	}
130 
131 	// finishes the game
132 	function stand() public gameIsGoingOn {
133 
134 		var (houseScore, houseScoreBig) = calculateScore(games[msg.sender].houseCards);
135 
136 		while (houseScoreBig < 17) {
137 			uint8 nextCard = games[msg.sender].cardsDealt;
138 			uint8 newCard = Deck.deal(msg.sender, nextCard);
139 			games[msg.sender].houseCards.push(newCard);
140 			games[msg.sender].cardsDealt = nextCard + 1;
141 			houseScoreBig += Deck.valueOf(newCard, true);
142 			Deal(false, newCard);
143 		}
144 
145 		checkGameResult(games[msg.sender], true);
146 	}
147 
148 	// @param finishGame - whether to finish the game or not (in case of Blackjack the game finishes anyway)
149 	function checkGameResult(Game game, bool finishGame) private {
150 		// calculate house score
151 		var (houseScore, houseScoreBig) = calculateScore(game.houseCards);
152 		// calculate player score
153 		var (playerScore, playerScoreBig) = calculateScore(game.playerCards);
154 
155 		GameStatus(houseScore, houseScoreBig, playerScore, playerScoreBig);
156 
157 		if (houseScoreBig == BLACKJACK || houseScore == BLACKJACK) {
158 			if (playerScore == BLACKJACK || playerScoreBig == BLACKJACK) {
159 				// TIE
160 				if (!msg.sender.send(game.bet)) throw; // return bet to the player
161 				games[msg.sender].state = GameState.Tie; // finish the game
162 				return;
163 			} else {
164 				// HOUSE WON
165 				games[msg.sender].state = GameState.House; // simply finish the game
166 				return;
167 			}
168 		} else {
169 			if (playerScore == BLACKJACK || playerScoreBig == BLACKJACK) {
170 				// PLAYER WON
171 				if (game.playerCards.length == 2 && (Deck.isTen(game.playerCards[0]) || Deck.isTen(game.playerCards[1]))) {
172 					// Natural blackjack => return x2.5
173 					if (!msg.sender.send((game.bet * 5) / 2)) throw; // send prize to the player
174 				} else {
175 					// Usual blackjack => return x2
176 					if (!msg.sender.send(game.bet * 2)) throw; // send prize to the player
177 				}
178 				games[msg.sender].state = GameState.Player; // finish the game
179 				return;
180 			} else {
181 
182 				if (playerScore > BLACKJACK) {
183 					// BUST, HOUSE WON
184 					Log(1);
185 					games[msg.sender].state = GameState.House; // finish the game
186 					return;
187 				}
188 
189 				if (!finishGame) {
190 					return; // continue the game
191 				}
192 				
193                 // недобор
194 				uint8 playerShortage = 0; 
195 				uint8 houseShortage = 0;
196 
197 				// player decided to finish the game
198 				if (playerScoreBig > BLACKJACK) {
199 					if (playerScore > BLACKJACK) {
200 						// HOUSE WON
201 						games[msg.sender].state = GameState.House; // simply finish the game
202 						return;
203 					} else {
204 						playerShortage = BLACKJACK - playerScore;
205 					}
206 				} else {
207 					playerShortage = BLACKJACK - playerScoreBig;
208 				}
209 
210 				if (houseScoreBig > BLACKJACK) {
211 					if (houseScore > BLACKJACK) {
212 						// PLAYER WON
213 						if (!msg.sender.send(game.bet * 2)) throw; // send prize to the player
214 						games[msg.sender].state = GameState.Player;
215 						return;
216 					} else {
217 						houseShortage = BLACKJACK - houseScore;
218 					}
219 				} else {
220 					houseShortage = BLACKJACK - houseScoreBig;
221 				}
222 				
223                 // ?????????????????????? почему игра заканчивается?
224 				if (houseShortage == playerShortage) {
225 					// TIE
226 					if (!msg.sender.send(game.bet)) throw; // return bet to the player
227 					games[msg.sender].state = GameState.Tie;
228 				} else if (houseShortage > playerShortage) {
229 					// PLAYER WON
230 					if (!msg.sender.send(game.bet * 2)) throw; // send prize to the player
231 					games[msg.sender].state = GameState.Player;
232 				} else {
233 					games[msg.sender].state = GameState.House;
234 				}
235 			}
236 		}
237 	}
238 
239 	function calculateScore(uint8[] cards) private constant returns (uint8, uint8) {
240 		uint8 score = 0;
241 		uint8 scoreBig = 0; // in case of Ace there could be 2 different scores
242 		bool bigAceUsed = false;
243 		for (uint i = 0; i < cards.length; ++i) {
244 			uint8 card = cards[i];
245 			if (Deck.isAce(card) && !bigAceUsed) { // doesn't make sense to use the second Ace as 11, because it leads to the losing
246 				scoreBig += Deck.valueOf(card, true);
247 				bigAceUsed = true;
248 			} else {
249 				scoreBig += Deck.valueOf(card, false);
250 			}
251 			score += Deck.valueOf(card, false);
252 		}
253 		return (score, scoreBig);
254 	}
255 
256 	function getPlayerCard(uint8 id) public gameIsGoingOn constant returns(uint8) {
257 		if (id < 0 || id > games[msg.sender].playerCards.length) {
258 			throw;
259 		}
260 		return games[msg.sender].playerCards[id];
261 	}
262 
263 	function getHouseCard(uint8 id) public gameIsGoingOn constant returns(uint8) {
264 		if (id < 0 || id > games[msg.sender].houseCards.length) {
265 			throw;
266 		}
267 		return games[msg.sender].houseCards[id];
268 	}
269 
270 	function getPlayerCardsNumber() public gameIsGoingOn constant returns(uint) {
271 		return games[msg.sender].playerCards.length;
272 	}
273 
274 	function getHouseCardsNumber() public gameIsGoingOn constant returns(uint) {
275 		return games[msg.sender].houseCards.length;
276 	}
277 
278 	function getGameState() public constant returns (uint8) {
279 		if (games[msg.sender].player == 0) {
280 			throw; // game doesn't exist
281 		}
282 
283 		Game game = games[msg.sender];
284 
285 		if (game.state == GameState.Player) {
286 			return 1;
287 		}
288 		if (game.state == GameState.House) {
289 			return 2;
290 		}
291 		if (game.state == GameState.Tie) {
292 			return 3;
293 		}
294 
295 		return 0; // the game is still going on
296 	}
297 
298 }