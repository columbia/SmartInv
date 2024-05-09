1 pragma solidity ^0.4.8;
2 
3 library ArrayLib {
4   // Inserts to keep array sorted (assumes input array is sorted)
5 	function insertInPlace(uint8[] storage self, uint8 n) {
6 		uint8 insertingIndex = 0;
7 
8 		while (self.length > 0 && insertingIndex < self.length && self[insertingIndex] < n) {
9 			insertingIndex += 1;
10 		}
11 
12 		self.length += 1;
13 		for (uint8 i = uint8(self.length) - 1; i > insertingIndex; i--) {
14 			self[i] = self[i - 1];
15 		}
16 
17 		self[insertingIndex] = n;
18 	}
19 }
20 
21 library DeckLib {
22 	using ArrayLib for uint8[];
23 
24 	enum Suit { Spades, Hearts, Clubs, Diamonds }
25 	uint8 constant cardsPerSuit = 13;
26 	uint8 constant suits = 4;
27 	uint8 constant totalCards = cardsPerSuit * suits;
28 
29 	struct Deck {
30 		uint8[] usedCards; // always has to be sorted
31 		address player;
32 		uint256 gameID;
33 	}
34 
35 	function init(Deck storage self, uint256 gameID)  {
36 		self.usedCards = new uint8[](0);
37 		self.player = msg.sender;
38 		self.gameID = gameID;
39 	}
40 
41 	function getCard(Deck storage self, uint256 blockNumber)  returns (uint8)  {
42 		uint cardIndex = self.usedCards.length;
43 		if (cardIndex >= totalCards) throw;
44 		uint8 r = uint8(getRandomNumber(blockNumber, self.player, self.gameID, cardIndex, totalCards - cardIndex));
45 
46 		for (uint8 i = 0; i < cardIndex; i++) {
47 			if (self.usedCards[i] <= r) r += 1;
48 		}
49 
50 		self.usedCards.insertInPlace(r);
51 
52 		return r;
53 	}
54 
55 	function cardDescription(uint8 self) constant returns (Suit, uint8) {
56 		return (Suit(self / cardsPerSuit), cardFacevalue(self));
57 	}
58 
59 	function cardEmojified(uint8 self) constant returns (uint8, string) {
60 		string memory emojiSuit;
61 
62 		var (suit, number) = cardDescription(self);
63 		if (suit == Suit.Clubs) emojiSuit = "♣️";
64 		else if (suit == Suit.Diamonds) emojiSuit = "♦️";
65 		else if (suit == Suit.Hearts) emojiSuit = "♥️";
66 		else if (suit == Suit.Spades) emojiSuit = "♠️";
67 
68 		return (number, emojiSuit);
69 	}
70 
71 	function cardFacevalue(uint8 self) constant returns (uint8) {
72 		return 1 + self % cardsPerSuit;
73 	}
74 
75 	function blackjackValue(uint8 self) constant returns (uint8) {
76 		uint8 cardValue = cardFacevalue(self);
77 		return cardValue < 10 ? cardValue : 10;
78 	}
79 
80 	function getRandomNumber(uint b, address player, uint256 gameID, uint n, uint m) constant returns (uint) {
81 		// Uses blockhash as randomness source.
82 		// Credits: https://github.com/Bunjin/Rouleth/blob/master/Provably_Fair_No_Cheating.md
83 		bytes32 blockHash = block.blockhash(b);
84 		if (blockHash == 0x0) throw;
85 		return uint(uint256(keccak256(blockHash, player, gameID, n)) % m);
86 
87 	}
88 }
89 
90 
91 
92 library GameLib {
93   using DeckLib for *;
94 
95   uint8 constant houseLimit = 17;
96   uint8 constant target = 21;
97 
98   enum ComparaisonResult { First, Second, Tie }
99   enum GameState { InitialCards, Waiting, Hit, Stand, DoubleDown, Finished }
100   enum GameResult { Ongoing, House, Tie, Player, PlayerNatural }
101 
102   struct Game {
103     address player;
104     uint256 bet;
105     uint256 payout;
106     uint256 gameID;
107 
108     DeckLib.Deck deck;
109     uint8[] houseCards;
110     uint8[] playerCards;
111 
112     uint256 actionBlock; // Block on which commitment to perform an action happens.
113 
114     GameState state;
115     GameResult result;
116 
117     bool closed;
118   }
119 
120   function init(Game storage self, uint256 gameID) {
121     self.player = msg.sender;
122     self.bet = msg.value;
123     self.payout = 0;
124     self.houseCards = new uint8[](0);
125     self.playerCards = new uint8[](0);
126     self.actionBlock = block.number;
127     self.state = GameState.InitialCards;
128     self.result = GameResult.Ongoing;
129     self.closed = false;
130     self.gameID = gameID;
131 
132     self.deck.init(gameID);
133   }
134 
135   function tick(Game storage self) returns (bool) {
136     if (block.number <= self.actionBlock) return false; // Can't tick yet
137     if (self.actionBlock + 255 < block.number) {
138       endGame(self, GameResult.House);
139       return true;
140     }
141     if (!needsTick(self)) return true; // not needed, everything is fine
142     if (self.state == GameState.InitialCards) dealInitialCards(self);
143     if (self.state == GameState.Hit) dealHitCard(self);
144     if (self.state == GameState.DoubleDown) {
145       dealHitCard(self);
146       forceStand(self);
147     }
148 
149     if (self.state == GameState.Stand) {
150       dealHouseCards(self);
151       checkGameResult(self);
152     } else {
153       checkGameContinues(self);
154     }
155 
156     return true;
157   }
158 
159   function needsTick(Game storage self) constant returns (bool) {
160     if (self.state == GameState.Waiting) return false;
161     if (self.state == GameState.Finished) return false;
162 
163     return true;
164   }
165 
166   function checkGameResult(Game storage self)  {
167     uint8 houseHand = countHand(self.houseCards);
168 
169     if (houseHand == target && self.houseCards.length == 2) return endGame(self, GameResult.House); // House natural
170 
171     ComparaisonResult result = compareHands(houseHand, countHand(self.playerCards));
172     if (result == ComparaisonResult.First) return endGame(self, GameResult.House);
173     if (result == ComparaisonResult.Second) return endGame(self, GameResult.Player);
174 
175     endGame(self, GameResult.Tie);
176   }
177 
178   function checkGameContinues(Game storage self)  {
179     uint8 playerHand = countHand(self.playerCards);
180     if (playerHand == target && self.playerCards.length == 2) return endGame(self, GameResult.PlayerNatural); // player natural
181     if (playerHand > target) return endGame(self, GameResult.House); // Player busted
182     if (playerHand == target && self.state == GameState.Waiting) {
183       // Player is forced to stand with 21 (but should not  already standing, ie in double down)
184       forceStand(self);
185     }
186   }
187 
188   function forceStand(Game storage self) {
189     uint256 currentActionBlock = self.actionBlock;
190     playerDecision(self, GameState.Stand);
191     self.actionBlock = currentActionBlock;
192     if (!tick(self)) throw; // Forces tick, commitment to play actually happened past block
193   }
194 
195   function canDoubleDown(Game storage self) returns (bool) {
196     if (self.playerCards.length > 2) return false;
197     uint8 totalPlayer = countHand(self.playerCards);
198     if (totalPlayer < 9 || totalPlayer > 11) return false;
199     if (msg.value != self.bet) return false;
200     return true;
201   }
202 
203   function playerDecision(Game storage self, GameState decision)  {
204     if (self.state != GameState.Waiting) throw;
205     if (decision != GameState.Hit && decision != GameState.Stand && decision != GameState.DoubleDown) throw;
206 
207     if (decision == GameState.DoubleDown){
208       if (!canDoubleDown(self)) throw;
209       self.bet += msg.value;
210     }
211 
212     self.state = decision;
213     self.actionBlock = block.number;
214   }
215 
216   function dealInitialCards(Game storage self) private {
217     self.playerCards.push(self.deck.getCard(self.actionBlock));
218     self.houseCards.push(self.deck.getCard(self.actionBlock));
219     self.playerCards.push(self.deck.getCard(self.actionBlock));
220     self.state = GameState.Waiting;
221   }
222 
223   function dealHitCard(Game storage self) private {
224     self.playerCards.push(self.deck.getCard(self.actionBlock));
225     self.state = GameState.Waiting;
226   }
227 
228   function dealHouseCards(Game storage self) private {
229     self.houseCards.push(self.deck.getCard(self.actionBlock));
230     if (countHand(self.houseCards) < houseLimit) dealHouseCards(self);
231   }
232 
233   function endGame(Game storage self, GameResult result) {
234     self.result = result;
235     self.state = GameState.Finished;
236     self.payout = payoutForResult(self.result, self.bet);
237 
238     closeGame(self);
239   }
240 
241   function closeGame(Game storage self) private {
242     if (self.closed) throw; // cannot re-close
243     if (self.state != GameState.Finished) throw; // not closable
244 
245     self.closed = true;
246 
247     if (self.payout > 0) {
248       if (!self.player.send(self.payout)) throw;
249     }
250   }
251 
252   function payoutForResult(GameResult result, uint256 bet) private returns (uint256) {
253     if (result == GameResult.PlayerNatural) return bet * 5 / 2; // bet + 1.5x bet
254     if (result == GameResult.Player) return bet * 2; // doubles bet
255     if (result == GameResult.Tie) return bet; // returns bet
256 
257     return 0;
258   }
259 
260   function countHand(uint8[] memory hand)  returns (uint8) {
261     uint8[] memory possibleSums = new uint8[](1);
262 
263     for (uint i = 0; i < hand.length; i++) {
264       uint8 value = hand[i].blackjackValue();
265       uint l = possibleSums.length;
266       for (uint j = 0; j < l; j++) {
267         possibleSums[j] += value;
268         if (value == 1) { // is Ace
269           possibleSums = appendArray(possibleSums, possibleSums[j] + 10); // Fork possible sum with 11 as ace value.
270         }
271       }
272     }
273 
274     return bestSum(possibleSums);
275   }
276 
277   function bestSum(uint8[] possibleSums)  returns (uint8 bestSum) {
278     bestSum = 50; // very bad hand
279     for (uint i = 0; i < possibleSums.length; i++) {
280       if (compareHands(bestSum, possibleSums[i]) == ComparaisonResult.Second) {
281         bestSum = possibleSums[i];
282       }
283     }
284     return;
285   }
286 
287   function appendArray(uint8[] memory array, uint8 n)  returns (uint8[] memory) {
288     uint8[] memory newArray = new uint8[](array.length + 1);
289     for (uint8 i = 0; i < array.length; i++) {
290       newArray[i] = array[i];
291     }
292     newArray[array.length] = n;
293     return newArray;
294   }
295 
296   function compareHands(uint8 a, uint8 b)  returns (ComparaisonResult) {
297     if (a <= target && b <= target) {
298       if (a > b) return ComparaisonResult.First;
299       if (a < b) return ComparaisonResult.Second;
300     }
301 
302     if (a > target && b > target) {
303       if (a < b) return ComparaisonResult.First;
304       if (a > b) return ComparaisonResult.Second;
305     }
306 
307     if (a > target) return ComparaisonResult.Second;
308     if (b > target) return ComparaisonResult.First;
309 
310     return ComparaisonResult.Tie;
311   }
312 }
313 
314 contract Blockjack {
315   
316   event GameEnded(uint256 gameID, address player, uint gameResult, uint256 wager, uint256 payout, uint8 playerHand, uint8 houseHand);
317   event GameNeedsTick(uint256 gameID, address player, uint256 actionBlock);
318 
319   using GameLib for GameLib.Game;
320 
321   GameLib.Game[] games;
322   mapping (address => uint256) public currentGame;
323 
324   // Initial settings
325   uint256 public minBet = 10 finney;
326   uint256 public maxBet = 500 finney;
327   bool public allowsNewGames = true;
328   uint256 public maxBlockActions = 10;
329 
330   mapping (uint256 => uint256) blockActions;
331 
332   //main
333   address public DX;
334   address public DEV;
335 
336   uint256 public initialBankroll;
337   uint256 public currentBankroll;
338 
339   mapping (address => bool) public isOwner;
340 
341   modifier onlyOwner {
342     if (!isOwner[msg.sender]) throw;
343     _;
344   }
345 
346   modifier only(address x) {
347     if (msg.sender != x) throw;
348     _;
349   }
350 
351   modifier onlyPlayer(uint256 gameID) {
352     if (msg.sender != games[gameID].player) throw;
353     _;
354   }
355 
356   modifier blockActionProtected {
357     blockActions[block.number] += 1;
358     if (blockActions[block.number] > maxBlockActions) throw;
359     _;
360   }
361 
362   function Blockjack(address _DX, address _DEV) {
363     DX = _DX;
364     DEV = _DEV;
365     games.length += 1;
366     games[0].init(0); // Init game 0 so indices start on 1
367     games[0].player = this;
368     isOwner[DX] = true;
369     isOwner[DEV] = true;
370   }
371 
372   function () payable {
373     startGame();
374   }
375 
376   function startGame() blockActionProtected payable {
377     if (!allowsNewGames) throw;
378     if (msg.value < minBet) throw;
379     if (msg.value > maxBet) throw;
380 
381     // check if player has game opened
382     uint256 currentGameId = currentGame[msg.sender];
383     if (games.length > currentGameId) {
384       GameLib.Game openedGame = games[currentGameId];
385       if (openedGame.player == msg.sender && !openedGame.closed) { // Check for index 0 mapping problems
386 	if (!openedGame.tick()) throw;
387 	if (!openedGame.closed) throw; // cannot start game with on-going game
388 	recordEndedGame(currentGameId);
389       }
390     }
391     uint256 newGameID = games.length;
392 
393     games.length += 1;
394     games[newGameID].init(newGameID);
395     currentGame[msg.sender] = newGameID;
396     tickRequiredLog(games[newGameID]);
397   }
398 
399   function hit(uint256 gameID) onlyPlayer(gameID) blockActionProtected {
400     GameLib.Game game = games[gameID];
401     if (!game.tick()) throw;
402     game.playerDecision(GameLib.GameState.Hit);
403     tickRequiredLog(game);
404   }
405 
406   function doubleDown(uint256 gameID) onlyPlayer(gameID) blockActionProtected payable {
407     GameLib.Game game = games[gameID];
408     if (!game.tick()) throw;
409     game.playerDecision(GameLib.GameState.DoubleDown);
410     tickRequiredLog(game);
411   }
412 
413   function stand(uint256 gameID) onlyPlayer(gameID) blockActionProtected {
414     GameLib.Game game = games[gameID];
415     if (!game.tick()) throw;
416     game.playerDecision(GameLib.GameState.Stand);
417     tickRequiredLog(game);
418   }
419 
420   function gameTick(uint256 gameID) blockActionProtected {
421     GameLib.Game openedGame = games[gameID];
422     if (openedGame.closed) throw;
423     if (!openedGame.tick()) throw;
424     if (openedGame.closed) recordEndedGame(gameID);
425   }
426 
427   function recordEndedGame(uint gameID) private {
428     GameLib.Game openedGame = games[gameID];
429 
430     //vs potential overflow when croupier is not ticking frequently enough
431     if(currentBankroll + openedGame.bet > openedGame.payout){
432       currentBankroll = currentBankroll + openedGame.bet - openedGame.payout;
433     }
434 
435     GameEnded(
436 	      openedGame.gameID,
437 	      openedGame.player,
438 	      uint(openedGame.result),
439 	      openedGame.bet,
440 	      openedGame.payout,
441 	      GameLib.countHand(openedGame.playerCards),
442 	      GameLib.countHand(openedGame.houseCards)
443 	      );
444   }
445 
446   function tickRequiredLog(GameLib.Game storage game) private {
447     GameNeedsTick(game.gameID, game.player, game.actionBlock);
448   }
449 
450   // Constants
451 
452   function gameState(uint i) constant returns (uint8[], uint8[], uint8, uint8, uint256, uint256, uint8, uint8, bool, uint256) {
453     GameLib.Game game = games[i];
454 
455     return (
456 	    game.houseCards,
457 	    game.playerCards,
458 	    GameLib.countHand(game.houseCards),
459 	    GameLib.countHand(game.playerCards),
460 	    game.bet,
461 	    game.payout,
462 	    uint8(game.state),
463 	    uint8(game.result),
464 	    game.closed,
465 	    game.actionBlock
466 	    );
467   }
468 
469 
470   function changeDev(address newDev) only(DEV) {
471     isOwner[DEV] = false;
472     DEV = newDev;
473     isOwner[DEV] = true;
474   }
475 
476   function changeDX(address newDX) only(DX) {
477     isOwner[DX] = false;
478     DX = newDX;
479     isOwner[DX] = true;
480   }
481 
482   function setSettings(uint256 _min, uint256 _max, uint256 _maxBlockActions) only(DX) {
483     minBet = _min;
484     maxBet = _max;
485     maxBlockActions = _maxBlockActions;
486   }
487 
488   function registerOwner(address _new_watcher) only(DX) {
489     isOwner[_new_watcher] = true;
490   }
491 
492   function removeOwner(address _old_watcher) only(DX) {
493     isOwner[_old_watcher] = false;
494   }
495 
496   function stopBlockjack() onlyOwner {
497     allowsNewGames = false;
498   }
499 
500   function startBlockjack() only(DX) {
501     allowsNewGames = true;
502   }
503 
504   function addBankroll() only(DX) payable {
505     initialBankroll += msg.value;
506     currentBankroll += msg.value;
507   }
508 
509   function migrateBlockjack() only(DX) {
510     stopBlockjack();
511     shareProfits();
512     suicide(DX);
513   }
514 
515   uint256 DX_PROFITS = 90;
516   uint256 DEV_PROFITS = 10;
517   uint256 PROFITS_BASE = 100;
518   
519   function shareProfits() onlyOwner{
520     if (currentBankroll <= initialBankroll) return; // there are no profits
521     uint256 profit = currentBankroll - initialBankroll;
522     uint256 notSent;
523     if (!DX.send(profit * DX_PROFITS / PROFITS_BASE)) {
524       notSent = profit * DX_PROFITS / PROFITS_BASE;
525     }
526     if (!DEV.send(profit * DEV_PROFITS / PROFITS_BASE)){
527       notSent = profit * DEV_PROFITS / PROFITS_BASE;
528     }
529     currentBankroll -= profit - notSent;
530   }
531 
532 
533   
534 }