1 library ArrayLib {
2   // Inserts to keep array sorted (assumes input array is sorted)
3 	function insertInPlace(uint8[] storage self, uint8 n) {
4 		uint8 insertingIndex = 0;
5 
6 		while (self.length > 0 && insertingIndex < self.length && self[insertingIndex] < n) {
7 			insertingIndex += 1;
8 		}
9 
10 		self.length += 1;
11 		for (uint8 i = uint8(self.length) - 1; i > insertingIndex; i--) {
12 			self[i] = self[i - 1];
13 		}
14 
15 		self[insertingIndex] = n;
16 	}
17 }
18 
19 library DeckLib {
20 	using ArrayLib for uint8[];
21 
22 	enum Suit { Spades, Hearts, Clubs, Diamonds }
23 	uint8 constant cardsPerSuit = 13;
24 	uint8 constant suits = 4;
25 	uint8 constant totalCards = cardsPerSuit * suits;
26 
27 	struct Deck {
28 		uint8[] usedCards; // always has to be sorted
29 		address player;
30 		uint256 gameID;
31 	}
32 
33 	function init(Deck storage self, uint256 gameID)  {
34 		self.usedCards = new uint8[](0);
35 		self.player = msg.sender;
36 		self.gameID = gameID;
37 	}
38 
39 	function getCard(Deck storage self, uint256 blockNumber)  returns (uint8)  {
40 		uint cardIndex = self.usedCards.length;
41 		if (cardIndex >= totalCards) throw;
42 		uint8 r = uint8(getRandomNumber(blockNumber, self.player, self.gameID, cardIndex, totalCards - cardIndex));
43 
44 		for (uint8 i = 0; i < cardIndex; i++) {
45 			if (self.usedCards[i] <= r) r += 1;
46 		}
47 
48 		self.usedCards.insertInPlace(r);
49 
50 		return r;
51 	}
52 
53 	function cardDescription(uint8 self) constant returns (Suit, uint8) {
54 		return (Suit(self / cardsPerSuit), cardFacevalue(self));
55 	}
56 
57 	function cardEmojified(uint8 self) constant returns (uint8, string) {
58 		string memory emojiSuit;
59 
60 		var (suit, number) = cardDescription(self);
61 		if (suit == Suit.Clubs) emojiSuit = "♣️";
62 		else if (suit == Suit.Diamonds) emojiSuit = "♦️";
63 		else if (suit == Suit.Hearts) emojiSuit = "♥️";
64 		else if (suit == Suit.Spades) emojiSuit = "♠️";
65 
66 		return (number, emojiSuit);
67 	}
68 
69 	function cardFacevalue(uint8 self) constant returns (uint8) {
70 		return 1 + self % cardsPerSuit;
71 	}
72 
73 	function blackjackValue(uint8 self) constant returns (uint8) {
74 		uint8 cardValue = cardFacevalue(self);
75 		return cardValue < 10 ? cardValue : 10;
76 	}
77 
78 	function getRandomNumber(uint b, address player, uint256 gameID, uint n, uint m) constant returns (uint) {
79 		// Uses blockhash as randomness source.
80 		// Credits: https://github.com/Bunjin/Rouleth/blob/master/Provably_Fair_No_Cheating.md
81 		bytes32 blockHash = block.blockhash(b);
82 		if (blockHash == 0x0) throw;
83 		return uint(uint256(keccak256(blockHash, player, gameID, n)) % m);
84 
85 	}
86 }
87 
88 contract AbstractBlockjackLogs {
89   event GameEnded(uint256 gameID, address player, uint gameResult, uint256 payout, uint8 playerHand, uint8 houseHand);
90   event GameNeedsTick(uint256 gameID, address player, uint256 actionBlock);
91 
92   function recordLog(uint256 gameID, address player, uint gameResult, uint256 payout, uint8 playerHand, uint8 houseHand);
93   function tickRequiredLog(uint256 gameID, address player, uint256 actionBlock);
94 }
95 
96 library GameLib {
97   using DeckLib for *;
98 
99   uint8 constant houseLimit = 17;
100   uint8 constant target = 21;
101 
102   enum ComparaisonResult { First, Second, Tie }
103   enum GameState { InitialCards, Waiting, Hit, Stand, DoubleDown, Finished }
104   enum GameResult { Ongoing, House, Tie, Player, PlayerNatural }
105 
106   struct Game {
107     address player;
108     uint256 bet;
109     uint256 payout;
110     uint256 gameID;
111 
112     DeckLib.Deck deck;
113     uint8[] houseCards;
114     uint8[] playerCards;
115 
116     uint256 actionBlock; // Block on which commitment to perform an action happens.
117 
118     GameState state;
119     GameResult result;
120 
121     bool closed;
122   }
123 
124   function init(Game storage self, uint256 gameID) {
125     self.player = msg.sender;
126     self.bet = msg.value;
127     self.payout = 0;
128     self.houseCards = new uint8[](0);
129     self.playerCards = new uint8[](0);
130     self.actionBlock = block.number;
131     self.state = GameState.InitialCards;
132     self.result = GameResult.Ongoing;
133     self.closed = false;
134     self.gameID = gameID;
135 
136     self.deck.init(gameID);
137   }
138 
139   function tick(Game storage self) returns (bool) {
140     if (block.number <= self.actionBlock) return false; // Can't tick yet
141     if (self.actionBlock + 255 < block.number) {
142       endGame(self, GameResult.House);
143       return true;
144     }
145     if (!needsTick(self)) return true; // not needed, everything is fine
146 
147     if (self.state == GameState.InitialCards) dealInitialCards(self);
148     if (self.state == GameState.Hit) dealHitCard(self);
149     if (self.state == GameState.DoubleDown) {
150       if (!canDoubleDown(self)) throw;
151       self.bet += msg.value;
152       dealHitCard(self);
153       forceStand(self);
154     }
155 
156     if (self.state == GameState.Stand) {
157       dealHouseCards(self);
158       checkGameResult(self);
159     } else {
160       checkGameContinues(self);
161     }
162 
163     return true;
164   }
165 
166   function needsTick(Game storage self) constant returns (bool) {
167     if (self.state == GameState.Waiting) return false;
168     if (self.state == GameState.Finished) return false;
169 
170     return true;
171   }
172 
173   function checkGameResult(Game storage self)  {
174     uint8 houseHand = countHand(self.houseCards);
175 
176     if (houseHand == target && self.houseCards.length == 2) return endGame(self, GameResult.House); // House natural
177 
178     ComparaisonResult result = compareHands(houseHand, countHand(self.playerCards));
179     if (result == ComparaisonResult.First) return endGame(self, GameResult.House);
180     if (result == ComparaisonResult.Second) return endGame(self, GameResult.Player);
181 
182     endGame(self, GameResult.Tie);
183   }
184 
185   function checkGameContinues(Game storage self)  {
186     uint8 playerHand = countHand(self.playerCards);
187     if (playerHand == target && self.playerCards.length == 2) return endGame(self, GameResult.PlayerNatural); // player natural
188     if (playerHand > target) return endGame(self, GameResult.House); // Player busted
189     if (playerHand == target) {
190       // Player is forced to stand with 21
191       forceStand(self);
192       if (!tick(self)) throw; // Forces tick, commitment to play actually happened past block
193     }
194   }
195 
196   function forceStand(Game storage self) {
197     uint256 currentActionBlock = self.actionBlock;
198     playerDecision(self, GameState.Stand);
199     self.actionBlock = currentActionBlock;
200   }
201 
202   function canDoubleDown(Game storage self) returns (bool) {
203     if (self.playerCards.length > 2) return false;
204     uint8 totalPlayer = countHand(self.playerCards);
205     if (totalPlayer < 9 || totalPlayer > 11) return false;
206     if (msg.value != self.bet) return false;
207   }
208 
209   function playerDecision(Game storage self, GameState decision)  {
210     if (self.state != GameState.Waiting) throw;
211     if (decision != GameState.Hit && decision != GameState.Stand) throw;
212 
213     self.state = decision;
214     self.actionBlock = block.number;
215   }
216 
217   function dealInitialCards(Game storage self) private {
218     self.playerCards.push(self.deck.getCard(self.actionBlock));
219     self.houseCards.push(self.deck.getCard(self.actionBlock));
220     self.playerCards.push(self.deck.getCard(self.actionBlock));
221 
222     self.state = GameState.Waiting;
223   }
224 
225   function dealHitCard(Game storage self) private {
226     self.playerCards.push(self.deck.getCard(self.actionBlock));
227 
228     self.state = GameState.Waiting;
229   }
230 
231   function dealHouseCards(Game storage self) private {
232     self.houseCards.push(self.deck.getCard(self.actionBlock));
233 
234     if (countHand(self.houseCards) < houseLimit) dealHouseCards(self);
235   }
236 
237   function endGame(Game storage self, GameResult result) {
238     self.result = result;
239     self.state = GameState.Finished;
240     self.payout = payoutForResult(self.result, self.bet);
241 
242     closeGame(self);
243   }
244 
245   function closeGame(Game storage self) private {
246     if (self.closed) throw; // cannot re-close
247     if (self.state != GameState.Finished) throw; // not closable
248 
249     self.closed = true;
250 
251     if (self.payout > 0) {
252       if (!self.player.send(self.payout)) throw;
253     }
254   }
255 
256   function payoutForResult(GameResult result, uint256 bet) private returns (uint256) {
257     if (result == GameResult.PlayerNatural) return bet * 5 / 2; // bet + 1.5x bet
258     if (result == GameResult.Player) return bet * 2; // doubles bet
259     if (result == GameResult.Tie) return bet; // returns bet
260 
261     return 0;
262   }
263 
264   function countHand(uint8[] memory hand)  returns (uint8) {
265     uint8[] memory possibleSums = new uint8[](1);
266 
267     for (uint i = 0; i < hand.length; i++) {
268       uint8 value = hand[i].blackjackValue();
269       uint l = possibleSums.length;
270       for (uint j = 0; j < l; j++) {
271         possibleSums[j] += value;
272         if (value == 1) { // is Ace
273           possibleSums = appendArray(possibleSums, possibleSums[j] + 10); // Fork possible sum with 11 as ace value.
274         }
275       }
276     }
277 
278     return bestSum(possibleSums);
279   }
280 
281   function bestSum(uint8[] possibleSums)  returns (uint8 bestSum) {
282     bestSum = 50; // very bad hand
283     for (uint i = 0; i < possibleSums.length; i++) {
284       if (compareHands(bestSum, possibleSums[i]) == ComparaisonResult.Second) {
285         bestSum = possibleSums[i];
286       }
287     }
288     return;
289   }
290 
291   function appendArray(uint8[] memory array, uint8 n)  returns (uint8[] memory) {
292     uint8[] memory newArray = new uint8[](array.length + 1);
293     for (uint8 i = 0; i < array.length; i++) {
294       newArray[i] = array[i];
295     }
296     newArray[array.length] = n;
297     return newArray;
298   }
299 
300   function compareHands(uint8 a, uint8 b)  returns (ComparaisonResult) {
301     if (a <= target && b <= target) {
302       if (a > b) return ComparaisonResult.First;
303       if (a < b) return ComparaisonResult.Second;
304     }
305 
306     if (a > target && b > target) {
307       if (a < b) return ComparaisonResult.First;
308       if (a > b) return ComparaisonResult.Second;
309     }
310 
311     if (a > target) return ComparaisonResult.Second;
312     if (b > target) return ComparaisonResult.First;
313 
314     return ComparaisonResult.Tie;
315   }
316 }
317 
318 contract Blockjack {
319   AbstractBlockjackLogs blockjacklogs;
320 
321   using GameLib for GameLib.Game;
322 
323   GameLib.Game[] games;
324   mapping (address => uint256) public currentGame;
325 
326   bool contractCleared;
327   // Initial settings
328   uint256 public minBet = 50 finney;
329   uint256 public maxBet = 500 finney;
330   bool public allowsNewGames = false;
331   uint256 public maxBlockActions = 10;
332 
333   mapping (uint256 => uint256) blockActions;
334 
335   // Admin
336 
337   //kovan
338   //  address public DX =       0x0006426a1057cbc60762802FFb5FBdc55D008fAf;
339   //  address public DEV =      0x0031EDb4846BAb2EDEdd7f724E58C50762a45Cb2;
340 
341   //main
342   address public DX = 0x296Ae1d2D9A8701e113EcdF6cE986a4a7D0A6dC5;
343   address public DEV = 0xBC4343B11B7cfdd6dD635f61039b8a66aF6E73Bb;
344 
345 
346 
347   address public ADMIN_CONTRACT;
348 
349   uint256 public BANKROLL_LOCK_PERIOD = 30 days;
350 
351   uint256 public bankrollLockedUntil;
352   uint256 public profitsLockedUntil;
353   uint256 public initialBankroll;
354   uint256 public currentBankroll;
355 
356   mapping (address => bool) public isOwner;
357 
358   modifier onlyOwner {
359     if (!isOwner[msg.sender]) throw;
360     _;
361   }
362 
363   modifier only(address x) {
364     if (msg.sender != x) throw;
365     _;
366   }
367 
368   modifier onlyPlayer(uint256 gameID) {
369     if (msg.sender != games[gameID].player) throw;
370     _;
371   }
372 
373   modifier blockActionProtected {
374     blockActions[block.number] += 1;
375     if (blockActions[block.number] > maxBlockActions) throw;
376     _;
377   }
378 
379   function Blockjack(address _admin_contract, address _logs_contract) { // only(DEV) {
380     ADMIN_CONTRACT = _admin_contract;
381     blockjacklogs = AbstractBlockjackLogs(_logs_contract);
382     games.length += 1;
383     games[0].init(0); // Init game 0 so indices start on 1
384     games[0].player = this;
385     setupTrustedAccounts();
386   }
387 
388   function () payable {
389     startGame();
390   }
391 
392   function startGame() blockActionProtected payable {
393     if (!allowsNewGames) throw;
394     if (msg.value < minBet) throw;
395     if (msg.value > maxBet) throw;
396 
397     // check if player has game opened
398     uint256 currentGameId = currentGame[msg.sender];
399     if (games.length > currentGameId) {
400       GameLib.Game openedGame = games[currentGameId];
401       if (openedGame.player == msg.sender && !openedGame.closed) { // Check for index 0 mapping problems
402 	if (!openedGame.tick()) throw;
403 	if (!openedGame.closed) throw; // cannot start game with on-going game
404 	recordEndedGame(currentGameId);
405       }
406     }
407     uint256 newGameID = games.length;
408 
409     games.length += 1;
410     games[newGameID].init(newGameID);
411     currentGame[msg.sender] = newGameID;
412     tickRequiredLog(games[newGameID]);
413   }
414 
415   function hit(uint256 gameID) onlyPlayer(gameID) blockActionProtected {
416     GameLib.Game game = games[gameID];
417 
418     if (!game.tick()) throw;
419     game.playerDecision(GameLib.GameState.Hit);
420     tickRequiredLog(game);
421   }
422 
423   function doubleDown(uint256 gameID) onlyPlayer(gameID) blockActionProtected payable {
424     GameLib.Game game = games[gameID];
425 
426     if (!game.tick()) throw;
427     game.playerDecision(GameLib.GameState.DoubleDown);
428     tickRequiredLog(game);
429   }
430 
431   function stand(uint256 gameID) onlyPlayer(gameID) blockActionProtected {
432     GameLib.Game game = games[gameID];
433 
434     if (!game.tick()) throw;
435     game.playerDecision(GameLib.GameState.Stand);
436     tickRequiredLog(game);
437   }
438 
439   function gameTick(uint256 gameID) blockActionProtected {
440     GameLib.Game openedGame = games[gameID];
441     if (openedGame.closed) throw;
442     if (!openedGame.tick()) throw;
443     if (openedGame.closed) recordEndedGame(gameID);
444   }
445 
446   function recordEndedGame(uint gameID) private {
447     GameLib.Game openedGame = games[gameID];
448 
449     //vs potential overflow when croupier is not ticking frequently enough
450     if(currentBankroll + openedGame.bet > openedGame.payout){
451       currentBankroll = currentBankroll + openedGame.bet - openedGame.payout;
452     }
453 
454     blockjacklogs.recordLog(
455 			    openedGame.gameID,
456 			    openedGame.player,
457 			    uint(openedGame.result),
458 			    openedGame.payout,
459 			    GameLib.countHand(openedGame.playerCards),
460 			    GameLib.countHand(openedGame.houseCards)
461 			    );
462   }
463 
464   function tickRequiredLog(GameLib.Game storage game) private {
465     blockjacklogs.tickRequiredLog(game.gameID, game.player, game.actionBlock);
466   }
467 
468   // Constants
469 
470   function gameState(uint i) constant returns (uint8[], uint8[], uint8, uint8, uint256, uint256, uint8, uint8, bool, uint256) {
471     GameLib.Game game = games[i];
472 
473     return (
474 	    game.houseCards,
475 	    game.playerCards,
476 	    GameLib.countHand(game.houseCards),
477 	    GameLib.countHand(game.playerCards),
478 	    game.bet,
479 	    game.payout,
480 	    uint8(game.state),
481 	    uint8(game.result),
482 	    game.closed,
483 	    game.actionBlock
484 	    );
485   }
486 
487   // Admin
488   function setupTrustedAccounts()
489     internal
490   {
491     isOwner[DX] = true;
492     isOwner[DEV] = true;
493     isOwner[ADMIN_CONTRACT] = true;
494   }
495 
496   function changeDev(address newDev) only(DEV) {
497     isOwner[DEV] = false;
498     DEV = newDev;
499     isOwner[DEV] = true;
500   }
501 
502   function changeDX(address newDX) only(DX) {
503     isOwner[DX] = false;
504     DX = newDX;
505     isOwner[DX] = true;
506   }
507 
508   function changeAdminContract(address _new_admin_contract) only(ADMIN_CONTRACT) {
509     isOwner[ADMIN_CONTRACT] = false;
510     ADMIN_CONTRACT = _new_admin_contract;
511     isOwner[ADMIN_CONTRACT] = true;
512   }
513 
514   function setSettings(uint256 _min, uint256 _max, uint256 _maxBlockActions) only(ADMIN_CONTRACT) {
515     minBet = _min;
516     maxBet = _max;
517     maxBlockActions = _maxBlockActions;
518   }
519 
520   function registerOwner(address _new_watcher) only(ADMIN_CONTRACT) {
521     isOwner[_new_watcher] = true;
522   }
523 
524   function removeOwner(address _old_watcher) only(ADMIN_CONTRACT) {
525     isOwner[_old_watcher] = false;
526   }
527 
528   function stopBlockjack() onlyOwner {
529     allowsNewGames = false;
530   }
531 
532   function startBlockjack() only(ADMIN_CONTRACT) {
533     allowsNewGames = true;
534   }
535 
536   function addBankroll() only(DX) payable {
537     initialBankroll += msg.value;
538     currentBankroll += msg.value;
539   }
540 
541   function remainingBankroll() constant returns (uint256) {
542     return currentBankroll > initialBankroll ? initialBankroll : currentBankroll;
543   }
544 
545   function removeBankroll() only(DX) {
546     if (initialBankroll > currentBankroll - 5 ether && bankrollLockedUntil > now) throw;
547 
548     stopBlockjack();
549 
550     if (currentBankroll > initialBankroll) { // there are profits
551       if (!DEV.send(currentBankroll - initialBankroll)) throw;
552     }
553 
554     suicide(DX); // send rest to dx
555     contractCleared = true;
556   }
557 
558   function migrateBlockjack() only(ADMIN_CONTRACT) {
559     stopBlockjack();
560 
561     if (currentBankroll > initialBankroll) { // there are profits, share them
562       if (!ADMIN_CONTRACT.call.value(currentBankroll - initialBankroll)()) throw;
563     }
564     suicide(DX); // send rest to dx
565     //DX will have to refund the non finalized bets that may have been stopped
566   }
567 
568   function shareProfits() onlyOwner {
569     if (profitsLockedUntil > now) throw;
570     if (currentBankroll <= initialBankroll) throw; // there are no profits
571 
572     uint256 profit = currentBankroll - initialBankroll;
573     if (!ADMIN_CONTRACT.call.value(profit)()) throw;
574     currentBankroll -= profit;
575 
576     bankrollLockedUntil = now + BANKROLL_LOCK_PERIOD;
577     profitsLockedUntil = bankrollLockedUntil + BANKROLL_LOCK_PERIOD;
578   }
579 }