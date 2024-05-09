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
19 
20 library DeckLib {
21 	using ArrayLib for uint8[];
22 
23 	enum Suit { Spades, Hearts, Clubs, Diamonds }
24 	uint8 constant cardsPerSuit = 13;
25 	uint8 constant suits = 4;
26 	uint8 constant totalCards = cardsPerSuit * suits;
27 
28 	struct Deck {
29 		uint8[] usedCards; // always has to be sorted
30 		address player;
31 		uint256 gameID;
32 	}
33 
34 	function init(Deck storage self, uint256 gameID)  {
35 		self.usedCards = new uint8[](0);
36 		self.player = msg.sender;
37 		self.gameID = gameID;
38 	}
39 
40 	function getCard(Deck storage self, uint256 blockNumber)  returns (uint8)  {
41 		uint cardIndex = self.usedCards.length;
42 		if (cardIndex >= totalCards) throw;
43 		uint8 r = uint8(getRandomNumber(blockNumber, self.player, self.gameID, cardIndex, totalCards - cardIndex));
44 
45 		for (uint8 i = 0; i < cardIndex; i++) {
46 			if (self.usedCards[i] <= r) r += 1;
47 		}
48 
49 		self.usedCards.insertInPlace(r);
50 
51 		return r;
52 	}
53 
54 	function cardDescription(uint8 self) constant returns (Suit, uint8) {
55 		return (Suit(self / cardsPerSuit), cardFacevalue(self));
56 	}
57 
58 	function cardEmojified(uint8 self) constant returns (uint8, string) {
59 		string memory emojiSuit;
60 
61 		var (suit, number) = cardDescription(self);
62 		if (suit == Suit.Clubs) emojiSuit = "♣️";
63 		else if (suit == Suit.Diamonds) emojiSuit = "♦️";
64 		else if (suit == Suit.Hearts) emojiSuit = "♥️";
65 		else if (suit == Suit.Spades) emojiSuit = "♠️";
66 
67 		return (number, emojiSuit);
68 	}
69 
70 	function cardFacevalue(uint8 self) constant returns (uint8) {
71 		return 1 + self % cardsPerSuit;
72 	}
73 
74 	function blackjackValue(uint8 self) constant returns (uint8) {
75 		uint8 cardValue = cardFacevalue(self);
76 		return cardValue < 10 ? cardValue : 10;
77 	}
78 
79 	function getRandomNumber(uint b, address player, uint256 gameID, uint n, uint m) constant returns (uint) {
80 		// Uses blockhash as randomness source.
81 		// Credits: https://github.com/Bunjin/Rouleth/blob/master/Provably_Fair_No_Cheating.md
82 		bytes32 blockHash = block.blockhash(b);
83 		if (blockHash == 0x0) throw;
84 		return uint(uint256(keccak256(blockHash, player, gameID, n)) % m);
85 
86 	}
87 }
88 
89 library GameLib {
90   using DeckLib for *;
91 
92   uint8 constant houseLimit = 17;
93   uint8 constant target = 21;
94 
95   enum ComparaisonResult { First, Second, Tie }
96   enum GameState { InitialCards, Waiting, Hit, Stand, Finished }
97   enum GameResult { Ongoing, House, Tie, Player, PlayerNatural }
98 
99   struct Game {
100     address player;
101     uint256 bet;
102     uint256 payout;
103     uint256 gameID;
104 
105     DeckLib.Deck deck;
106     uint8[] houseCards;
107     uint8[] playerCards;
108 
109     uint256 actionBlock; // Block on which commitment to perform an action happens.
110 
111     GameState state;
112     GameResult result;
113 
114     bool closed;
115   }
116 
117   function init(Game storage self, uint256 gameID) {
118     self.player = msg.sender;
119     self.bet = msg.value;
120     self.payout = 0;
121     self.houseCards = new uint8[](0);
122     self.playerCards = new uint8[](0);
123     self.actionBlock = block.number;
124     self.state = GameState.InitialCards;
125     self.result = GameResult.Ongoing;
126     self.closed = false;
127     self.gameID = gameID;
128 
129     self.deck.init(gameID);
130   }
131 
132   function tick(Game storage self)  returns (bool) {
133     if (block.number <= self.actionBlock) return false; // Can't tick yet
134     if (self.actionBlock + 255 < block.number) {
135       endGame(self, GameResult.House);
136       return true;
137     }
138     if (!needsTick(self)) return true; // not needed, everything is fine
139 
140     if (self.state == GameState.InitialCards) dealInitialCards(self);
141     if (self.state == GameState.Hit) dealHitCard(self);
142 
143     if (self.state == GameState.Stand) {
144       dealHouseCards(self);
145       checkGameResult(self);
146     } else {
147       checkGameContinues(self);
148     }
149 
150     return true;
151   }
152 
153   function needsTick(Game storage self) constant returns (bool) {
154     if (self.state == GameState.Waiting) return false;
155     if (self.state == GameState.Finished) return false;
156 
157     return true;
158   }
159 
160   function checkGameResult(Game storage self)  {
161     uint8 houseHand = countHand(self.houseCards);
162 
163     if (houseHand == target && self.houseCards.length == 2) return endGame(self, GameResult.House); // House natural
164 
165     ComparaisonResult result = compareHands(houseHand, countHand(self.playerCards));
166     if (result == ComparaisonResult.First) return endGame(self, GameResult.House);
167     if (result == ComparaisonResult.Second) return endGame(self, GameResult.Player);
168 
169     endGame(self, GameResult.Tie);
170   }
171 
172   function checkGameContinues(Game storage self)  {
173     uint8 playerHand = countHand(self.playerCards);
174     if (playerHand == target && self.playerCards.length == 2) return endGame(self, GameResult.PlayerNatural); // player natural
175     if (playerHand > target) return endGame(self, GameResult.House); // Player busted
176     if (playerHand == target) {
177       // Player is forced to stand with 21
178       uint256 currentActionBlock = self.actionBlock;
179       playerDecision(self, GameState.Stand);
180       self.actionBlock = currentActionBlock;
181       if (!tick(self)) throw; // Forces tick, commitment to play actually happened past block
182     }
183   }
184 
185   function playerDecision(Game storage self, GameState decision)  {
186     if (self.state != GameState.Waiting) throw;
187     if (decision != GameState.Hit && decision != GameState.Stand) throw;
188 
189     self.state = decision;
190     self.actionBlock = block.number;
191   }
192 
193   function dealInitialCards(Game storage self) private {
194     self.playerCards.push(self.deck.getCard(self.actionBlock));
195     self.houseCards.push(self.deck.getCard(self.actionBlock));
196     self.playerCards.push(self.deck.getCard(self.actionBlock));
197 
198     self.state = GameState.Waiting;
199   }
200 
201   function dealHitCard(Game storage self) private {
202     self.playerCards.push(self.deck.getCard(self.actionBlock));
203 
204     self.state = GameState.Waiting;
205   }
206 
207   function dealHouseCards(Game storage self) private {
208     self.houseCards.push(self.deck.getCard(self.actionBlock));
209 
210     if (countHand(self.houseCards) < houseLimit) dealHouseCards(self);
211   }
212 
213   function endGame(Game storage self, GameResult result) {
214     self.result = result;
215     self.state = GameState.Finished;
216     self.payout = payoutForResult(self.result, self.bet);
217 
218     closeGame(self);
219   }
220 
221   function closeGame(Game storage self) private {
222     if (self.closed) throw; // cannot re-close
223     if (self.state != GameState.Finished) throw; // not closable
224 
225     self.closed = true;
226 
227     if (self.payout > 0) {
228       if (!self.player.send(self.payout)) throw;
229     }
230   }
231 
232   function payoutForResult(GameResult result, uint256 bet) private returns (uint256) {
233     if (result == GameResult.PlayerNatural) return bet * 5 / 2; // bet + 1.5x bet
234     if (result == GameResult.Player) return bet * 2; // doubles bet
235     if (result == GameResult.Tie) return bet; // returns bet
236 
237     return 0;
238   }
239 
240   function countHand(uint8[] memory hand)  returns (uint8) {
241     uint8[] memory possibleSums = new uint8[](1);
242 
243     for (uint i = 0; i < hand.length; i++) {
244       uint8 value = hand[i].blackjackValue();
245       uint l = possibleSums.length;
246       for (uint j = 0; j < l; j++) {
247         possibleSums[j] += value;
248         if (value == 1) { // is Ace
249           possibleSums = appendArray(possibleSums, possibleSums[j] + 10); // Fork possible sum with 11 as ace value.
250         }
251       }
252     }
253 
254     return bestSum(possibleSums);
255   }
256 
257   function bestSum(uint8[] possibleSums)  returns (uint8 bestSum) {
258     bestSum = 50; // very bad hand
259     for (uint i = 0; i < possibleSums.length; i++) {
260       if (compareHands(bestSum, possibleSums[i]) == ComparaisonResult.Second) {
261         bestSum = possibleSums[i];
262       }
263     }
264     return;
265   }
266 
267   function appendArray(uint8[] memory array, uint8 n)  returns (uint8[] memory) {
268     uint8[] memory newArray = new uint8[](array.length + 1);
269     for (uint8 i = 0; i < array.length; i++) {
270       newArray[i] = array[i];
271     }
272     newArray[array.length] = n;
273     return newArray;
274   }
275 
276   function compareHands(uint8 a, uint8 b)  returns (ComparaisonResult) {
277     if (a <= target && b <= target) {
278       if (a > b) return ComparaisonResult.First;
279       if (a < b) return ComparaisonResult.Second;
280     }
281 
282     if (a > target && b > target) {
283       if (a < b) return ComparaisonResult.First;
284       if (a > b) return ComparaisonResult.Second;
285     }
286 
287     if (a > target) return ComparaisonResult.Second;
288     if (b > target) return ComparaisonResult.First;
289 
290     return ComparaisonResult.Tie;
291   }
292 }
293 
294 contract AbstractBlockjackLogs {
295   event GameEnded(uint256 gameID, address player, uint gameResult, uint256 payout, uint8 playerHand, uint8 houseHand);
296   event GameNeedsTick(uint256 gameID, address player, uint256 actionBlock);
297 
298   function recordLog(uint256 gameID, address player, uint gameResult, uint256 payout, uint8 playerHand, uint8 houseHand);
299   function tickRequiredLog(uint256 gameID, address player, uint256 actionBlock);
300 }
301 
302 contract Blockjack {
303   AbstractBlockjackLogs blockjacklogs;
304 
305   using GameLib for GameLib.Game;
306 
307   GameLib.Game[] games;
308   mapping (address => uint256) public currentGame;
309 
310   bool contractCleared;
311   // Initial settings
312   uint256 public minBet = 50 finney;
313   uint256 public maxBet = 500 finney;
314   bool public allowsNewGames = false;
315   uint256 public maxBlockActions = 10;
316 
317   mapping (uint256 => uint256) blockActions;
318 
319   // Admin
320   address public DX =       0x296Ae1d2D9A8701e113EcdF6cE986a4a7D0A6dC5;
321   address public DEV =      0xBC4343B11B7cfdd6dD635f61039b8a66aF6E73Bb;
322   address public ADMIN_CONTRACT;
323 
324   uint256 public BANKROLL_LOCK_PERIOD = 30 days;
325 
326   uint256 public bankrollLockedUntil;
327   uint256 public profitsLockedUntil;
328   uint256 public initialBankroll;
329   uint256 public currentBankroll;
330 
331   mapping (address => bool) public isOwner;
332 
333   modifier onlyOwner {
334     if (!isOwner[msg.sender]) throw;
335     _;
336   }
337 
338   modifier only(address x) {
339     if (msg.sender != x) throw;
340     _;
341   }
342 
343   modifier onlyPlayer(uint256 gameID) {
344     if (msg.sender != games[gameID].player) throw;
345     _;
346   }
347 
348   modifier blockActionProtected {
349     blockActions[block.number] += 1;
350     if (blockActions[block.number] > maxBlockActions) throw;
351     _;
352   }
353 
354   function Blockjack(address _admin_contract, address _logs_contract) { // only(DEV) {
355     ADMIN_CONTRACT = _admin_contract;
356     blockjacklogs = AbstractBlockjackLogs(_logs_contract);
357     games.length += 1;
358     games[0].init(0); // Init game 0 so indices start on 1
359     games[0].player = this;
360     setupTrustedAccounts();
361   }
362 
363   function () payable {
364     startGame();
365   }
366 
367   function startGame() blockActionProtected payable {
368     if (!allowsNewGames) throw;
369     if (msg.value < minBet) throw;
370     if (msg.value > maxBet) throw;
371 
372     // check if player has game opened
373     uint256 currentGameId = currentGame[msg.sender];
374     if (games.length > currentGameId) {
375       GameLib.Game openedGame = games[currentGameId];
376       if (openedGame.player == msg.sender && !openedGame.closed) { // Check for index 0 mapping problems
377 	if (!openedGame.tick()) throw;
378 	if (!openedGame.closed) throw; // cannot start game with on-going game
379 	recordEndedGame(currentGameId);
380       }
381     }
382     uint256 newGameID = games.length;
383 
384     games.length += 1;
385     games[newGameID].init(newGameID);
386     currentGame[msg.sender] = newGameID;
387     tickRequiredLog(games[newGameID]);
388   }
389 
390   function hit(uint256 gameID) onlyPlayer(gameID) blockActionProtected {
391     GameLib.Game game = games[gameID];
392 
393     if (!game.tick()) throw;
394     game.playerDecision(GameLib.GameState.Hit);
395     tickRequiredLog(game);
396   }
397 
398   function doubleDown(uint256 gameID) onlyPlayer(gameID) blockActionProtected payable {
399     GameLib.Game game = games[gameID];
400 
401     if (msg.value != game.bet) throw;
402     if (!game.tick()) throw;
403 
404     uint8 totalPlayer = GameLib.countHand(game.playerCards);
405     if (totalPlayer < 9 || totalPlayer > 11) throw;
406     if (game.bet > maxBet) throw;
407 
408     game.bet += msg.value;
409     game.playerDecision(GameLib.GameState.Hit);
410     tickRequiredLog(game);
411   }
412 
413   function stand(uint256 gameID) onlyPlayer(gameID) blockActionProtected {
414     GameLib.Game game = games[gameID];
415 
416     if (!game.tick()) throw;
417     game.playerDecision(GameLib.GameState.Stand);
418     tickRequiredLog(game);
419   }
420 
421   function gameTick(uint256 gameID) blockActionProtected {
422     GameLib.Game openedGame = games[gameID];
423     if (openedGame.closed) throw;
424     if (!openedGame.tick()) throw;
425     if (openedGame.closed) recordEndedGame(gameID);
426   }
427 
428   function recordEndedGame(uint gameID) private {
429     GameLib.Game openedGame = games[gameID];
430     currentBankroll = currentBankroll + openedGame.bet - openedGame.payout;
431 
432     blockjacklogs.recordLog(
433 			    openedGame.gameID,
434 			    openedGame.player,
435 			    uint(openedGame.result),
436 			    openedGame.payout,
437 			    GameLib.countHand(openedGame.playerCards),
438 			    GameLib.countHand(openedGame.houseCards)
439 			    );
440   }
441 
442   function tickRequiredLog(GameLib.Game storage game) private {
443     blockjacklogs.tickRequiredLog(game.gameID, game.player, game.actionBlock);
444   }
445 
446   // Constants
447 
448   function gameState(uint i) constant returns (uint8[], uint8[], uint8, uint8, uint256, uint256, uint8, uint8, bool, uint256) {
449     GameLib.Game game = games[i];
450 
451     return (
452 	    game.houseCards,
453 	    game.playerCards,
454 	    GameLib.countHand(game.houseCards),
455 	    GameLib.countHand(game.playerCards),
456 	    game.bet,
457 	    game.payout,
458 	    uint8(game.state),
459 	    uint8(game.result),
460 	    game.closed,
461 	    game.actionBlock
462 	    );
463   }
464 
465   // Admin
466   function setupTrustedAccounts()
467     internal
468   {
469     isOwner[DX] = true;
470     isOwner[DEV] = true;
471     isOwner[ADMIN_CONTRACT] = true;
472   }
473 
474   function changeDev(address newDev) only(DEV) {
475     isOwner[DEV] = false;
476     DEV = newDev;
477     isOwner[DEV] = true;
478   }
479 
480   function changeDX(address newDX) only(DX) {
481     isOwner[DX] = false;
482     DX = newDX;
483     isOwner[DX] = true;
484   }
485 
486   function changeAdminContract(address _new_admin_contract) only(ADMIN_CONTRACT) {
487     isOwner[ADMIN_CONTRACT] = false;
488     ADMIN_CONTRACT = _new_admin_contract;
489     isOwner[ADMIN_CONTRACT] = true;
490   }
491 
492   function setSettings(uint256 _min, uint256 _max, uint256 _maxBlockActions) only(ADMIN_CONTRACT) {
493     minBet = _min;
494     maxBet = _max;
495     maxBlockActions = _maxBlockActions;
496   }
497 
498   function registerOwner(address _new_watcher) only(ADMIN_CONTRACT) {
499     isOwner[_new_watcher] = true;
500   }
501 
502   function removeOwner(address _old_watcher) only(ADMIN_CONTRACT) {
503     isOwner[_old_watcher] = false;
504   }
505 
506   function stopBlockjack() onlyOwner {
507     allowsNewGames = false;
508   }
509 
510   function startBlockjack() only(ADMIN_CONTRACT) {
511     allowsNewGames = true;
512   }
513 
514   function addBankroll() only(DX) payable {
515     initialBankroll += msg.value;
516     currentBankroll += msg.value;
517   }
518 
519   function remainingBankroll() constant returns (uint256) {
520     return currentBankroll > initialBankroll ? initialBankroll : currentBankroll;
521   }
522 
523   function removeBankroll() only(DX) {
524     if (initialBankroll > currentBankroll - 5 ether && bankrollLockedUntil > now) throw;
525 
526     stopBlockjack();
527 
528     if (currentBankroll > initialBankroll) { // there are profits
529       if (!DEV.send(currentBankroll - initialBankroll)) throw;
530     }
531 
532     suicide(DX); // send rest to dx
533     contractCleared = true;
534   }
535 
536   function migrateBlockjack() only(ADMIN_CONTRACT) {
537     stopBlockjack();
538 
539     if (currentBankroll > initialBankroll) { // there are profits, share them
540       if (!ADMIN_CONTRACT.call.value(currentBankroll - initialBankroll)()) throw;
541     }
542     suicide(DX); // send rest to dx
543     //DX will have to refund the non finalized bets that may have been stopped
544   }
545 
546   function shareProfits() onlyOwner {
547     if (profitsLockedUntil > now) throw;
548     if (currentBankroll <= initialBankroll) throw; // there are no profits
549 
550     uint256 profit = currentBankroll - initialBankroll;
551     if (!ADMIN_CONTRACT.call.value(profit)()) throw;
552     currentBankroll -= profit;
553 
554     bankrollLockedUntil = now + BANKROLL_LOCK_PERIOD;
555     profitsLockedUntil = bankrollLockedUntil + BANKROLL_LOCK_PERIOD;
556   }
557 }