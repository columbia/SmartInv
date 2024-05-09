1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract OwnableExtended {
7   address public owner;
8   address public admin;
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function OwnableExtended() {
16     owner = msg.sender;
17     admin = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner or admin.
31    */
32   modifier onlyAdmin() {
33     require(msg.sender == owner || msg.sender == admin);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) onlyOwner {
42     if (newOwner != address(0)) {
43       owner = newOwner;
44     }
45   }
46 
47   /**
48   * @dev Allows the current owner to change admin of the contract
49   * @param newAdmin The new admin address
50   */
51   function changeAdmin(address newAdmin) onlyOwner {
52     if (newAdmin != address(0)) {
53       admin = newAdmin;
54     }
55   }
56 }
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  */
62 library SafeMath {
63   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
64     uint256 c = a * b;
65     assert(a == 0 || c / a == b);
66     return c;
67   }
68 
69   function div(uint256 a, uint256 b) internal constant returns (uint256) {
70     // assert(b > 0); // Solidity automatically throws when dividing by 0
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73     return c;
74   }
75 
76   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   function add(uint256 a, uint256 b) internal constant returns (uint256) {
82     uint256 c = a + b;
83     assert(c >= a);
84     return c;
85   }
86 }
87 
88 contract iChampion {
89     uint256 public currentGameBlockNumber;
90 
91     function buyTicket(address) returns (uint256, uint256) {}
92     function startGame() returns (bool) {}
93     function finishCurrentGame() returns (address) {}
94     function setGamePrize(uint256, uint256) {}
95 }
96 
97 contract Ottolotto is OwnableExtended {
98     using SafeMath for uint256;
99     using SafeMath for uint8;
100     
101     event StartedGame(uint256 indexed _game, uint256 _nextGame);
102     event GameProgress(uint256 indexed _game, uint256 _processed, uint256 _toProcess);
103     event Ticket(uint256 indexed _game, address indexed _address, bytes3 bet);
104     event Win(address indexed _address, uint256 indexed _game, uint256 _matches, uint256 _amount, uint256 _time);
105     event Jackpot(address indexed _address, uint256 indexed _game, uint256 _amount, uint256 _time);
106     event RaisedByPartner(address indexed _partner, uint256 _game, uint256 _amount, uint256 _time);
107     event ChampionGameStarted(uint256 indexed _game, uint256 _time);
108     event ChampionGameFinished(uint256 indexed _game, address indexed _winner, uint256 _amount, uint256 _time);
109 
110     struct Winner {
111         address player;
112         bytes3  bet;
113         uint8   matches;
114     }
115     
116     struct Bet {
117         address player;
118         bytes3  bet;
119     }
120 
121     struct TicketBet {
122         bytes3  bet;
123         bool    isPayed;
124     }
125 
126     iChampion public champion;
127 
128     mapping(address => mapping(uint256 => TicketBet[])) tickets;
129     mapping(uint256 => Bet[]) gameBets;
130     mapping(uint256 => Winner[]) winners;
131     mapping(uint256 => uint256) weiRaised;
132     mapping(uint256 => uint256) gameStartBlock;
133     mapping(uint256 => uint32[7]) gameStats;
134     mapping(uint256 => bool) gameCalculated;
135     mapping(uint256 => uint256) gameCalculationProgress;
136     mapping(uint8 => uint8) percents;
137     mapping(address => address) partner;
138     mapping(address => address[]) partners;
139 
140     uint256 public jackpot;
141     
142     uint256 public gameNext;
143     uint256 public gamePlayed;  
144     uint8   public gameDuration = 6;
145 
146     bool public gamePlayedStatus = false;
147     
148     uint64  public ticketPrice = 0.001 ether;
149     
150     function Ottolotto() {}
151     
152     function init(address _champion) onlyOwner {
153         require(gameNext == 0);
154         gameNext = block.number;
155         
156         percents[1] = 5;
157         percents[2] = 8;
158         percents[3] = 12;
159         percents[4] = 15;
160         percents[5] = 25;
161         percents[6] = 35;
162 
163         champion = iChampion(_champion);
164     }
165 
166     function getGamePrize(uint256 _game)
167             constant returns (uint256) {
168         return weiRaised[_game];            
169     }
170     
171     function getGameStartBlock(uint256 _game) 
172             constant returns (uint256) {
173         return gameStartBlock[_game];
174     }
175     
176     function getGameCalculationProgress(uint256 _game) 
177             constant returns (uint256) {
178         return gameCalculationProgress[_game];
179     }
180 
181     function getPlayersCount(uint256 _game)
182             constant returns (uint256) {
183         return gameBets[_game].length;
184     }
185 
186     function getGameCalculatedStats(uint256 _game)
187             constant returns (uint32[7]) {
188         return gameStats[_game];
189     }
190 
191     function getPartner(address _player) constant returns (address) {
192         return partner[_player];
193     }
194 
195     function getPartners(address _player) 
196             constant returns (address[]) {
197         return partners[_player];
198     }
199 
200     function getBet(address _player, uint256 _game) 
201         constant returns (bytes3[]) {
202         bytes3[] memory bets = new bytes3[](tickets[_player][_game].length);
203         for (uint32 i = 0; i < tickets[_player][_game].length; i++) {
204             bets[i] = tickets[_player][_game][i].bet;
205         }        
206         return bets;
207     }
208 
209     function getWinners(uint256 _game) 
210             constant returns (address[]) {
211         address[] memory _winners = new address[](winners[_game].length);
212         for (uint32 i = 0; i < winners[_game].length; i++) {
213             _winners[i] = winners[_game][i].player;
214         }
215         return _winners;
216     }
217 
218     function betsArePayed(address _player, uint256 _game) constant returns (bool) {
219         uint256 startBlock = getGameStartBlock(_game);
220         for (uint16 i = 0; i < tickets[_player][_game].length; i++) {
221             if (tickets[_player][_game][i].isPayed == false) {
222                 uint8 matches = getMatches(startBlock, tickets[_player][_game][i].bet);
223                 if (matches > 0) {
224                     return false;
225                 }
226             }
227         }
228         return true;
229     }
230 
231     function getGameBlocks(uint256 _game) 
232             constant returns(bytes32[]) {
233         uint256 startBlock = getGameStartBlock(_game);
234         bytes32[] memory blocks = new bytes32[](6);
235         uint8 num = 0;
236         for (startBlock; startBlock + num <= startBlock + gameDuration - 1; num++) {
237             blocks[num] = block.blockhash(startBlock + num);
238         }
239         
240         return blocks;
241     }
242     
243     function toBytes(uint8 n1, uint8 n2, uint8 n3, uint8 n4, uint8 n5, uint8 n6) 
244             internal constant returns (bytes3) {
245         return bytes3(16**5*n1+16**4*n2+16**3*n3+16**2*n4+16**1*n5+n6);
246     }
247     
248     function modifyBet(bytes32 _bet, uint256 _step) 
249             internal constant returns (bytes32) {
250         return _bet >> (232 + (_step * 4 - 4)) << 252 >> 252;
251     }
252 
253     function modifyBlock(uint256 _blockNumber) 
254             internal constant returns (bytes32) {
255         return block.blockhash(_blockNumber) << 252 >> 252;
256     }
257     
258     function equalNumber(bytes32 _bet, uint256 _game, uint256 _endBlock) 
259             internal constant returns (bool) {
260         uint256 step = _endBlock - _game;
261         if (modifyBlock(_game) ^ modifyBet(_bet, step) == 0) {
262             return true;
263         }
264         
265         return false;
266     }
267     
268     function makeBet(uint8 n1, uint8 n2, uint8 n3, uint8 n4, uint8 n5, uint8 n6, address _partner) 
269             payable returns (bool) {
270         require(msg.value == ticketPrice);
271                 
272         bytes3 uBet = toBytes(n1, n2, n3, n4, n5, n6);
273         Bet memory pBet = Bet({player: msg.sender, bet: uBet});
274         TicketBet memory tBet = TicketBet({bet: uBet, isPayed: false});
275 
276         tickets[msg.sender][gameNext].push(tBet);
277         gameBets[gameNext].push(pBet);
278         
279         weiRaised[gameNext] += ticketPrice;
280         
281         Ticket(gameNext, msg.sender, uBet);
282 
283         champion.buyTicket(msg.sender);
284 
285         if (_partner != 0x0 && partner[msg.sender] == 0x0) {
286             addPartner(_partner, msg.sender);
287         }
288 
289         return true;
290     }
291 
292     function startGame() onlyAdmin returns (bool) {
293         gamePlayed = gameNext;
294         gameNext = block.number;
295         gamePlayedStatus = true;
296 
297         gameStartBlock[gamePlayed] = gameNext + gameDuration;
298 
299 
300         jackpot += weiRaised[gamePlayed].mul(percents[6]).div(100);
301         StartedGame(gamePlayed, gameNext);
302 
303         return true;
304     }
305 
306     function getMatches(uint256 _game, bytes3 _bet) 
307             constant returns (uint8) {
308         bytes32 bet = bytes32(_bet);
309         uint256 endBlock = _game + gameDuration;
310         uint8 matches = 0;
311         for (; endBlock > _game; _game++) {
312             if (equalNumber(bet, _game, endBlock)) {
313                 matches++;
314                 continue;
315             }
316             break;
317         }
318         
319         return matches;
320     }
321         
322     function getAllMatches(uint256 _game) 
323             constant returns (uint256[]) {
324         uint256 startBlock = getGameStartBlock(_game);
325         uint256[] memory matches = new uint256[](7);
326         for (uint32 i = 0; i < gameBets[_game].length; i++) {
327             Bet memory bet = gameBets[_game][i];
328             uint8 matched = getMatches(startBlock, bet.bet);
329             if (matched == 0) {
330                 continue;
331             }
332             (matched == 1) ? matches[1] += 1 : 
333             (matched == 2) ? matches[2] += 1 : 
334             (matched == 3) ? matches[3] += 1 : 
335             (matched == 4) ? matches[4] += 1 :
336             (matched == 5) ? matches[5] += 1 :
337             (matched == 6) ? matches[6] += 1 : matches[6] += 0;
338         }
339         
340         return matches;
341     }
342 
343     function gameIsOver(uint256 _game) 
344             constant returns (bool) {
345         if (gameStartBlock[_game] == 0) {
346             return false;
347         }
348 
349         return (gameStartBlock[_game] + gameDuration - 1) < block.number;   
350     }
351 
352     function gameIsCalculated(uint256 _game)
353             constant returns (bool) {
354         return gameCalculated[_game];
355     }
356 
357     function updateGameToCalculated(uint256 _game) internal {
358         gameCalculated[_game] = true;
359         gamePlayedStatus = false;
360     }
361 
362     function processGame(uint256 _game, uint256 calculationStep) returns (bool) {
363         require(gamePlayedStatus == true);
364         require(gameIsOver(_game));
365 
366         if (gameIsCalculated(_game)) {
367             return true;
368         }
369 
370 
371         if (gameCalculationProgress[_game] == gameBets[_game].length) {
372             updateGameToCalculated(_game);
373             return true;
374         } 
375 
376         uint256 steps = calculationStep;
377         if (gameCalculationProgress[_game] + steps > gameBets[_game].length) {
378             steps -= gameCalculationProgress[_game] + steps - gameBets[_game].length;
379         }
380     
381         uint32[] memory matches = new uint32[](7);
382         uint256 to = gameCalculationProgress[_game] + steps;
383         uint256 startBlock = getGameStartBlock(_game);
384         for (; gameCalculationProgress[_game] < to; gameCalculationProgress[_game]++) {
385             Bet memory bet = gameBets[_game][gameCalculationProgress[_game]];
386             uint8 matched = getMatches(startBlock, bet.bet);
387             if (matched == 0) {
388                 continue;
389             }
390             (matched == 1) ? matches[1] += 1 : 
391             (matched == 2) ? matches[2] += 1 : 
392             (matched == 3) ? matches[3] += 1 : 
393             (matched == 4) ? matches[4] += 1 :
394             (matched == 5) ? matches[5] += 1 :
395             (matched == 6) ? matches[6] += 1 : gameStats[_game][6];
396         }
397 
398         for (uint8 i = 1; i <= 6; i++) {
399             gameStats[_game][i] += matches[i];
400         }
401 
402         GameProgress(_game, gameCalculationProgress[_game], gameBets[_game].length);
403         if (gameCalculationProgress[_game] == gameBets[_game].length) {
404             updateGameToCalculated(_game);
405             distributeRaisedWeiToJackpot(_game);
406             return true;
407         }
408 
409         return false;
410     }
411 
412     function distributeRaisedWeiToJackpot(uint256 _game) internal {
413         for (uint8 i = 1; i <= 5; i ++) {
414             if (gameStats[_game][i] == 0) {
415                 jackpot += weiRaised[_game].mul(percents[i]).div(100);
416             }
417         }
418     }
419 
420     function distributeFunds(uint256 weiWin, uint256 _game, uint8 matched, address _player) 
421             internal {
422         uint256 toOwner = weiWin.div(5);
423         uint256 toPartner = 0;
424 
425         if (partner[_player] != 0x0) {
426             toPartner = toOwner.mul(5).div(100);
427             partner[_player].transfer(toPartner);
428             RaisedByPartner(_player, _game, toPartner, now);
429         }
430 
431         _player.transfer(weiWin - toOwner);
432         owner.transfer(toOwner - toPartner);
433 
434         Win(_player, _game, matched, weiWin, now);
435         if (matched == 6) {
436             Jackpot(_player, _game, weiWin, now);
437         }
438     }
439 
440     function getPrize(address _player, uint256 _game, bytes3 _bet, uint16 _index) 
441             returns (bool) {
442         TicketBet memory ticket = tickets[_player][_game][_index];
443 
444         if (ticket.isPayed || ticket.bet != _bet) {
445             return false;
446         }
447         
448         uint256 startBlock = getGameStartBlock(_game);
449         uint8 matched = getMatches(startBlock, ticket.bet);
450         if (matched == 0) {
451             return false;
452         }
453 
454         uint256 weiWin = 0;
455         if (matched != 6) {
456             uint256 weiByMatch = weiRaised[gamePlayed].mul(percents[matched]).div(100);
457             weiWin = weiByMatch.div(gameStats[_game][matched]);
458         } else {
459             weiWin = jackpot.div(gameStats[_game][matched]);
460             jackpot -= weiWin;
461         }
462         
463         distributeFunds(weiWin, _game, matched, _player);
464 
465         ticket.isPayed = true;
466         tickets[_player][_game][_index] = ticket;
467 
468         winners[gamePlayed].push(Winner({
469             player: _player,
470             bet: ticket.bet,
471             matches: matched
472         }));
473 
474         return true;
475     }
476 
477     function addPartner(address _partner, address _player) 
478             internal returns (bool) {
479         if (partner[_player] != 0x0) {
480             return false;
481         }
482 
483         partner[_player] = _partner;
484         partners[_partner].push(_player);
485 
486         return true;
487     }
488 
489     // champion
490     function startChampionGame() onlyAdmin {
491         champion.startGame();
492 
493         uint256 currentGame = champion.currentGameBlockNumber();
494         ChampionGameStarted(currentGame, now);
495     }
496 
497     function finishChampionGame() onlyAdmin {
498         uint256 currentGame = champion.currentGameBlockNumber();
499         
500         address winner = champion.finishCurrentGame();
501         require(winner != 0x0);
502 
503         champion.setGamePrize(currentGame, jackpot);
504 
505         winner.transfer(jackpot - jackpot.div(5));
506         owner.transfer(jackpot.div(5));
507 
508         ChampionGameFinished(currentGame, winner, jackpot, now);
509 
510         jackpot = 0;
511     }
512 }