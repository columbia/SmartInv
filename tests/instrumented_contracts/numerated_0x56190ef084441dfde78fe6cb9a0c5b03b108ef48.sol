1 pragma solidity ^0.4.17;
2 
3 contract OracleBase {
4 
5   function getRandomUint(uint max) public returns (uint);
6 
7   function getRandomForContract(uint max, uint index) public view returns (uint);
8 
9   function getEtherDiceProfit(uint rate) public view returns (uint);
10 
11   function getRandomUint256(uint txId) public returns (uint256);
12 
13   function getRandomForContractClanwar(uint max, uint index) public view returns (uint);
14 }
15 
16 /**
17  * @title Ownable
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract ContractOwner {
22   address public owner;
23 
24 
25   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   constructor() public {
33     owner = msg.sender;
34   }
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address newOwner) public onlyOwner {
49     require(newOwner != address(0));
50     emit OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53 
54 }
55 
56 /**
57  * @title SafeMath
58  * @dev Math operations with safety checks that throw on error
59  */
60 library SafeMath {
61 
62   /**
63   * @dev Multiplies two numbers, throws on overflow.
64   */
65   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
66     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
67     // benefit is lost if 'b' is also tested.
68     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
69     if (a == 0) {
70       return 0;
71     }
72 
73     c = a * b;
74     assert(c / a == b);
75     return c;
76   }
77 
78   /**
79   * @dev Integer division of two numbers, truncating the quotient.
80   */
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     // uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return a / b;
86   }
87 
88   /**
89   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90   */
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     assert(b <= a);
93     return a - b;
94   }
95 
96   /**
97   * @dev Adds two numbers, throws on overflow.
98   */
99   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
100     c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 
107 contract Etherauction is ContractOwner {
108 
109   using SafeMath for uint256;
110 
111   constructor() public payable {
112     owner = msg.sender;
113 
114     gameId = 1;
115     gameStartTime = block.timestamp;
116     gameLastAuctionMoney = 10**15;
117 
118     gameLastAuctionTime = block.timestamp;
119     gameSecondLeft = _getInitAuctionSeconds();
120   }
121 
122   function adminAddMoney() public payable {
123     reward = reward + msg.value * 80 / 100;
124     nextReward = nextReward + msg.value * 20 / 100;
125 
126     Contributor memory c;
127     contributors[gameId].push(c);
128     contributors[gameId][contributors[gameId].length - 1].addr = owner;
129     contributors[gameId][contributors[gameId].length - 1].money = msg.value * 80 / 100;
130   }
131 
132   function addAuctionReward() public payable {
133     uint256 minBid = getMinAuctionValue();
134     if (msg.value < minBid)
135       revert('value error');
136 
137     uint value = msg.value - minBid;
138 
139     reward = reward + value * 98 / 100;
140     nextReward = nextReward + value * 2 / 100;
141 
142     Contributor memory c;
143     contributors[gameId].push(c);
144     contributors[gameId][contributors[gameId].length - 1].addr = msg.sender;
145     contributors[gameId][contributors[gameId].length - 1].money = msg.value - minBid;
146 
147     if (!_isUserInGame(msg.sender)) {
148       _auction(minBid, address(0x00));
149     }
150     
151   }
152 
153 
154   uint256 gameId; // gameId increase from 1
155   uint256 gameStartTime;  // game start time
156   uint256 gameLastAuctionTime;   // last auction time
157   uint256 gameLastAuctionMoney; 
158   uint256 gameSecondLeft; // how many seconds left to auction
159 
160 
161   ////////////////////////// money
162 
163   uint256 reward; // reward for winner
164   uint256 dividends;  // total dividends for players
165   uint256 nextReward; // reward for next round
166   uint256 dividendForDev;
167   uint256 dividendForContributor;
168 
169 
170   ////////////////////////// api
171 
172   // OracleBase oracleAPI;
173 
174   // function setOracleAPIAddress(address _addr) public onlyOwner {
175   //   oracleAPI = OracleBase(_addr);
176   // }
177 
178   // uint rollCount = 100;
179 
180   // function getRandom() internal returns (uint256) {
181   //   rollCount = rollCount + 1;
182   //   return oracleAPI.getRandomForContract(100, rollCount);
183   // }
184 
185 
186 
187   ////////////////////////// game money
188 
189   // 17%
190   function _inMoney(uint _m, address invitorAddr) internal {
191     if (invitorAddr != 0x00 && _isUserInGame(invitorAddr)) {
192 
193       shareds[gameId][invitorAddr].addr = invitorAddr;
194       shareds[gameId][invitorAddr].money = shareds[gameId][invitorAddr].money + _m * 1 / 100;
195 
196       dividends = dividends + _m * 6 / 100;
197       dividendForDev = dividendForDev + _m * 1 / 100;
198       dividendForContributor = dividendForContributor + _m * 3 / 100;
199 
200       reward = reward + _m * 2 / 100;
201       nextReward = nextReward + _m * 4 / 100;
202 
203       // emit GameInvited(gameId, invitorAddr, _m);
204     } else {
205 
206       dividends = dividends + _m * 7 / 100;
207       dividendForDev = dividendForDev + _m * 1 / 100;
208       dividendForContributor = dividendForContributor + _m * 3 / 100;
209 
210       reward = reward + _m * 2 / 100;
211       nextReward = nextReward + _m * 4 / 100;
212 
213     }
214   }
215 
216   function _startNewRound(address _addr) internal {
217     reward = nextReward * 80 / 100;
218     nextReward = nextReward * 20 / 100;
219     gameId = gameId + 1;
220     dividends = 0;
221 
222     gameStartTime = block.timestamp;
223     gameLastAuctionTime = block.timestamp;
224 
225     // have to make sure enough reward, or may get exception
226     uint256 price = _getMinAuctionStartPrice();
227     reward = reward.sub(price);
228 
229     PlayerAuction memory p;
230     gameAuction[gameId].push(p);
231     gameAuction[gameId][0].addr = _addr;
232     gameAuction[gameId][0].money = price;
233     gameAuction[gameId][0].bid = price;
234     gameAuction[gameId][0].refunded = false;
235     gameAuction[gameId][0].dividended = false;
236 
237     gameLastAuctionMoney = price;
238     gameSecondLeft = _getInitAuctionSeconds();
239 
240     Contributor memory c;
241     contributors[gameId].push(c);
242     contributors[gameId][0].addr = owner;
243     contributors[gameId][0].money = reward;
244 
245     emit GameAuction(gameId, _addr, price, price, gameSecondLeft, block.timestamp);
246   }
247 
248   function adminPayout() public onlyOwner {
249     owner.transfer(dividendForDev);
250     dividendForDev = 0;
251   }
252 
253   ////////////////////////// game struct
254 
255   struct GameData {
256     uint256 gameId;
257     uint256 reward;
258     uint256 dividends;
259     uint256 dividendForContributor;
260   }
261 
262   GameData[] gameData;
263 
264   struct PlayerAuction {
265     address addr;
266     uint256 money;
267     uint256 bid;
268     bool refunded;
269     bool dividended;
270   }
271 
272   mapping(uint256 => PlayerAuction[]) gameAuction;
273 
274   struct Contributor {
275     address addr;
276     uint256 money;
277   }
278 
279   mapping(uint256 => Contributor[]) contributors;
280 
281   struct Shared {
282     address addr;
283     uint256 money;
284   }
285 
286   mapping(uint256 => mapping(address => Shared)) shareds;
287 
288   ////////////////////////// game event
289 
290   event GameAuction(uint indexed gameId, address player, uint money, uint auctionValue, uint secondsLeft, uint datetime);
291   
292   event GameRewardClaim(uint indexed gameId, address indexed player, uint money);
293 
294   event GameRewardRefund(uint indexed gameId, address indexed player, uint money);
295 
296   event GameEnd(uint indexed gameId, address indexed winner, uint money, uint datetime);
297 
298   event GameInvited(uint indexed gameId, address player, uint money);
299 
300 
301   ////////////////////////// invite 
302 
303   // key is msgSender, value is invitor address
304   mapping(address => address) public inviteMap;
305 
306   function registerInvitor(address msgSender, address invitor) internal {
307     if (invitor == 0x0 || msgSender == 0x0) {
308       return;
309     }
310 
311     inviteMap[msgSender] = invitor;
312   }
313 
314   function getInvitor(address msgSender) internal view returns (address){
315     return inviteMap[msgSender];
316   }
317 
318 
319   ////////////////////////// game play
320 
321   function getMinAuctionValue() public view returns (uint256) {
322     uint256 gap = _getGameAuctionGap();
323     uint256 auctionValue = gap + gameLastAuctionMoney;
324     return auctionValue;
325   }
326 
327   function auction(address invitorAddr) public payable {
328     _auction(msg.value, invitorAddr);
329   }
330 
331   function _auction(uint256 value, address invitorAddr) internal {
332     bool ended = (block.timestamp > gameLastAuctionTime + gameSecondLeft) ? true: false;
333     if (ended) {
334       revert('this round end!!!');
335     }
336 
337     uint256 len = gameAuction[gameId].length;
338     if (len > 1) {
339       address bidder = gameAuction[gameId][len - 1].addr;
340       if (msg.sender == bidder)
341         revert("wrong action");
342     }
343 
344     uint256 gap = _getGameAuctionGap();
345     uint256 auctionValue = gap + gameLastAuctionMoney;
346     uint256 maxAuctionValue = 3 * gap + gameLastAuctionMoney;
347 
348     if (value < auctionValue) {
349       revert("wrong eth value!");
350     }
351 
352 
353     if (invitorAddr != 0x00) {
354       registerInvitor(msg.sender, invitorAddr);
355     } else
356       invitorAddr = getInvitor(msg.sender);
357 
358 
359     if (value >= maxAuctionValue) {
360       auctionValue = maxAuctionValue;
361     } else {
362       auctionValue = value;
363     }
364 
365     gameLastAuctionMoney = auctionValue;
366     _inMoney(auctionValue, invitorAddr);
367     gameLastAuctionTime = block.timestamp;
368 
369     // uint256 random = getRandom();
370     // gameSecondLeft = random * (_getMaxAuctionSeconds() - _getMinAuctionSeconds()) / 100 + _getMinAuctionSeconds();
371     gameSecondLeft = _getMaxAuctionSeconds();
372 
373     PlayerAuction memory p;
374     gameAuction[gameId].push(p);
375     gameAuction[gameId][gameAuction[gameId].length - 1].addr = msg.sender;
376     gameAuction[gameId][gameAuction[gameId].length - 1].money = value;
377     gameAuction[gameId][gameAuction[gameId].length - 1].bid = auctionValue;
378     gameAuction[gameId][gameAuction[gameId].length - 1].refunded = false;
379     gameAuction[gameId][gameAuction[gameId].length - 1].dividended = false;
380 
381     emit GameAuction(gameId, msg.sender, value, auctionValue, gameSecondLeft, block.timestamp);
382   }
383 
384   function claimReward(uint256 _id) public {
385     _claimReward(msg.sender, _id);
386   }
387 
388   function _claimReward(address _addr, uint256 _id) internal {
389     if (_id == gameId) {
390       bool ended = (block.timestamp > gameLastAuctionTime + gameSecondLeft) ? true: false;
391       if (ended == false)
392         revert('game is still on, cannot claim reward');
393     }
394 
395     uint _reward = 0;
396     uint _dividends = 0;
397     uint _myMoney = 0;
398     uint _myDividends = 0;
399     uint _myRefund = 0;
400     uint _myReward = 0;
401     bool _claimed = false;
402     (_myMoney, _myDividends, _myRefund, _myReward, _claimed) = _getGameInfoPart1(_addr, _id);
403     (_reward, _dividends) = _getGameInfoPart2(_id);
404 
405     uint256 contributeValue = 0;
406     uint256 sharedValue = 0;
407     (contributeValue, sharedValue) = _getGameInfoPart3(_addr, _id);
408 
409     if (_claimed)
410       revert('already claimed!');
411 
412     for (uint k = 0; k < gameAuction[_id].length; k++) {
413       if (gameAuction[_id][k].addr == _addr) {
414         gameAuction[_id][k].dividended = true;
415       }
416     }
417 
418     _addr.transfer(_myDividends + _myRefund + _myReward + contributeValue + sharedValue); 
419     emit GameRewardClaim(_id, _addr, _myDividends + _myRefund + _myReward);
420   }
421 
422   // can only refund game still on
423   function refund() public {
424     uint256 len = gameAuction[gameId].length;
425     if (len > 1) {
426       if (msg.sender != gameAuction[gameId][len - 2].addr
427         && msg.sender != gameAuction[gameId][len - 1].addr) {
428 
429         uint256 money = 0;
430         uint k = 0;
431         for (k = 0; k < gameAuction[gameId].length; k++) {
432           if (gameAuction[gameId][k].addr == msg.sender && gameAuction[gameId][k].refunded == false) {
433             money = money + gameAuction[gameId][k].bid * 83 / 100 + gameAuction[gameId][k].money;
434             gameAuction[gameId][k].refunded = true;
435           }
436         }
437 
438         // if user have contribute 
439         k = 0;
440         for (k = 0; k < contributors[gameId].length; k++) {
441           if (contributors[gameId][k].addr == msg.sender) {
442             contributors[gameId][k].money = 0;  // he cannot get any dividend from his contributor
443           }
444         }
445 
446         // if user have invited 
447         if (shareds[gameId][msg.sender].money > 0) {
448           dividends = dividends + shareds[gameId][msg.sender].money;
449           delete shareds[gameId][msg.sender];
450         }
451 
452         msg.sender.transfer(money); 
453         emit GameRewardRefund(gameId, msg.sender, money);
454       } else {
455         revert('cannot refund because you are no.2 bidder');
456       }
457     }   
458   }
459 
460 
461   // anyone can end this round
462   function gameRoundEnd() public {
463     bool ended = (block.timestamp > gameLastAuctionTime + gameSecondLeft) ? true: false;
464     if (ended == false)
465       revert("game cannot end");
466 
467     uint256 len = gameAuction[gameId].length;
468     address winner = gameAuction[gameId][len - 1].addr;
469 
470     GameData memory d;
471     gameData.push(d);
472     gameData[gameData.length - 1].gameId = gameId;
473     gameData[gameData.length - 1].reward = reward;
474     gameData[gameData.length - 1].dividends = dividends;
475     gameData[gameData.length - 1].dividendForContributor = dividendForContributor;
476 
477     _startNewRound(msg.sender);
478 
479     _claimReward(msg.sender, gameId - 1);
480 
481     emit GameEnd(gameId - 1, winner, gameData[gameData.length - 1].reward, block.timestamp);
482   }
483 
484   function getCurrCanRefund() public view returns (bool) {
485 
486     if (gameAuction[gameId].length > 1) {
487       if (msg.sender == gameAuction[gameId][gameAuction[gameId].length - 2].addr) {
488         return false;
489       } else if (msg.sender == gameAuction[gameId][gameAuction[gameId].length - 1].addr) {
490         return false;
491       }
492       return true;
493     } else {
494       return false;
495     }
496   }
497 
498 
499   function getCurrGameInfoPart2() public view returns (uint256 _myContributeMoney, uint256 _mySharedMoney) {
500     (_myContributeMoney, _mySharedMoney) = _getGameInfoPart3(msg.sender, gameId);
501   }
502 
503   function getCurrGameInfoPart1() public view returns (uint256 _gameId, 
504                                                           uint256 _reward, 
505                                                           uint256 _dividends,
506                                                           uint256 _lastAuction, 
507                                                           uint256 _gap, 
508                                                           uint256 _lastAuctionTime,
509                                                           uint256 _secondsLeft, 
510                                                           uint256 _myMoney,
511                                                           uint256 _myDividends,
512                                                           uint256 _myRefund,
513                                                           bool _ended) {
514     _gameId = gameId;
515 
516     _reward = reward;
517     _dividends = dividends;
518     _lastAuction = gameLastAuctionMoney;
519     _gap = _getGameAuctionGap();
520     _lastAuctionTime = gameLastAuctionTime;
521     _secondsLeft = gameSecondLeft;
522     _ended = (block.timestamp > _lastAuctionTime + _secondsLeft) ? true: false;
523 
524     uint256 _moneyForCal = 0;
525 
526     if (gameAuction[gameId].length > 1) {
527 
528       uint256 totalMoney = 0;
529 
530       for (uint256 i = 0; i < gameAuction[gameId].length; i++) {
531         if (gameAuction[gameId][i].addr == msg.sender && gameAuction[gameId][i].dividended == true) {
532 
533         }
534 
535         if (gameAuction[gameId][i].addr == msg.sender && gameAuction[gameId][i].refunded == false) {
536 
537           if ((i == gameAuction[gameId].length - 2) || (i == gameAuction[gameId].length - 1)) {
538             _myRefund = _myRefund.add(gameAuction[gameId][i].money).sub(gameAuction[gameId][i].bid);
539           } else {
540             _myRefund = _myRefund.add(gameAuction[gameId][i].money).sub(gameAuction[gameId][i].bid.mul(17).div(100));
541           }
542 
543           _myMoney = _myMoney + gameAuction[gameId][i].money;
544 
545           _moneyForCal = _moneyForCal.add((gameAuction[gameId][i].money.div(10**15)).mul(gameAuction[gameId][i].money.div(10**15)).mul(gameAuction[gameId].length + 1 - i));
546         }
547 
548         if (gameAuction[gameId][i].refunded == false) {
549           totalMoney = totalMoney.add((gameAuction[gameId][i].money.div(10**15)).mul(gameAuction[gameId][i].money.div(10**15)).mul(gameAuction[gameId].length + 1 - i));
550         }
551       }
552 
553       if (totalMoney != 0)
554         _myDividends = _moneyForCal.mul(_dividends).div(totalMoney);
555     }
556   }
557 
558   function getGameDataByIndex(uint256 _index) public view returns (uint256 _id, uint256 _reward, uint256 _dividends) {
559     uint256 len = gameData.length;
560     if (len >= (_index + 1)) {
561       GameData memory d = gameData[_index];
562       _id = d.gameId;
563       _reward = d.reward;
564       _dividends = d.dividends;
565     }
566   }
567 
568   function getGameInfo(uint256 _id) public view returns (uint256 _reward, uint256 _dividends, uint256 _myMoney, uint256 _myDividends, uint256 _myRefund, uint256 _myReward, uint256 _myInvestIncome, uint256 _myShared, bool _claimed) {
569     (_reward, _dividends) = _getGameInfoPart2(_id);
570     (_myMoney, _myRefund, _myDividends, _myReward, _claimed) = _getGameInfoPart1(msg.sender, _id);
571     (_myInvestIncome, _myShared) = _getGameInfoPart3(msg.sender, _id);
572   }
573 
574   function _getGameInfoPart1(address _addr, uint256 _id) internal view returns (uint256 _myMoney, uint256 _myRefund, uint256 _myDividends, uint256 _myReward, bool _claimed) {
575     uint256 totalMoney = 0;
576     uint k = 0;
577 
578     if (_id == gameId) {
579      
580     } else {
581 
582       for (uint256 i = 0; i < gameData.length; i++) {
583         GameData memory d = gameData[i];
584         if (d.gameId == _id) {
585 
586           if (gameAuction[d.gameId].length > 1) {
587 
588             // no.2 bidder can refund except for the last one
589             if (gameAuction[d.gameId][gameAuction[d.gameId].length - 1].addr == _addr) {
590               // if sender is winner
591               _myReward = d.reward;
592 
593               _myReward = _myReward + gameAuction[d.gameId][gameAuction[d.gameId].length - 2].bid;
594             }
595 
596             // add no.2 bidder's money to winner
597             // address loseBidder = gameAuction[d.gameId][gameAuction[d.gameId].length - 2].addr;
598 
599             totalMoney = 0;
600             uint256 _moneyForCal = 0;
601 
602             for (k = 0; k < gameAuction[d.gameId].length; k++) {
603 
604               if (gameAuction[d.gameId][k].addr == _addr && gameAuction[d.gameId][k].dividended == true) {
605                 _claimed = true;
606               }
607 
608               // k != (gameAuction[d.gameId].length - 2): for no.2 bidder, who cannot refund this bid
609               if (gameAuction[d.gameId][k].addr == _addr && gameAuction[d.gameId][k].refunded == false && k != (gameAuction[d.gameId].length - 2)) {
610                 _myRefund = _myRefund.add( gameAuction[d.gameId][k].money.sub( gameAuction[d.gameId][k].bid.mul(17).div(100) ) );
611                 _moneyForCal = _moneyForCal.add( (gameAuction[d.gameId][k].money.div(10**15)).mul( gameAuction[d.gameId][k].money.div(10**15) ).mul( gameAuction[d.gameId].length + 1 - k) );
612                 _myMoney = _myMoney.add(gameAuction[d.gameId][k].money);
613               }
614 
615               if (gameAuction[d.gameId][k].refunded == false && k != (gameAuction[d.gameId].length - 2)) {
616                 totalMoney = totalMoney.add( ( gameAuction[d.gameId][k].money.div(10**15) ).mul( gameAuction[d.gameId][k].money.div(10**15) ).mul( gameAuction[d.gameId].length + 1 - k) );
617               }
618             }
619 
620             if (totalMoney != 0)
621               _myDividends = d.dividends.mul(_moneyForCal).div(totalMoney);
622 
623           }
624   
625           break;
626         }
627       }
628     } 
629   }
630 
631   function _getGameInfoPart2(uint256 _id) internal view returns (uint256 _reward, uint256 _dividends) {
632     if (_id == gameId) {
633      
634     } else {
635       for (uint256 i = 0; i < gameData.length; i++) {
636         GameData memory d = gameData[i];
637         if (d.gameId == _id) {
638           _reward = d.reward;
639           _dividends = d.dividends;
640           break;
641         }
642       }
643     }
644   }
645 
646   function _getGameInfoPart3(address addr, uint256 _id) public view returns (uint256 _contributeReward, uint256 _shareReward) {
647     uint256 contributeDividend = 0;
648     uint256 total = 0;
649     uint256 money = 0;
650 
651     uint256 i = 0;
652 
653     if (_id == gameId) {
654       contributeDividend = dividendForContributor;
655     } else {
656       for (i = 0; i < gameData.length; i++) {
657         GameData memory d = gameData[i];
658         if (d.gameId == _id) {
659           contributeDividend = d.dividendForContributor;
660           break;
661         }
662       }
663     }
664 
665     for (i = 0; i < contributors[_id].length; i++) {
666       total = total + contributors[_id][i].money;
667       if (contributors[_id][i].addr == addr) {
668         money = money + contributors[_id][i].money;
669       }
670     }
671 
672     if (total > 0)
673       _contributeReward = contributeDividend.mul(money).div(total);
674 
675     // for invited money 
676     _shareReward = shareds[_id][addr].money;
677 
678   }
679 
680   function getCurrTotalInvest() public view returns (uint256 invest) {
681     for (uint i = 0; i < contributors[gameId].length; i++) {
682       if (contributors[gameId][i].addr == msg.sender) {
683         invest = invest + contributors[gameId][i].money;
684       }
685     }
686   }
687 
688   function _isUserInGame(address addr) internal view returns (bool) {
689     uint256 k = 0;
690     for (k = 0; k < gameAuction[gameId].length; k++) {
691       if (gameAuction[gameId][k].addr == addr && gameAuction[gameId][k].refunded == false) {
692         return true;
693       }
694     }
695     return false;
696   }
697 
698   ////////////////////////// game rule
699 
700   function _getGameStartAuctionMoney() internal pure returns (uint256) {
701     return 10**15;
702   }
703 
704   function _getGameAuctionGap() internal view returns (uint256) {
705     if (gameLastAuctionMoney < 10**18) {
706       return 10**15;
707     }
708 
709     uint256 n = 17;
710     for (n = 18; n < 200; n ++) {
711       if (gameLastAuctionMoney >= 10**n && gameLastAuctionMoney < 10**(n + 1)) {
712         break;
713       }
714     }
715 
716     return 10**(n-2);
717   }
718 
719   function _getMinAuctionSeconds() internal pure returns (uint256) {
720     return 30 * 60;
721     // return 1 * 60; //test
722   }
723 
724   function _getMaxAuctionSeconds() internal pure returns (uint256) {
725     return 24 * 60 * 60;
726     // return 5 * 60;  //test
727   }
728 
729   function _getInitAuctionSeconds() internal pure returns (uint256) {
730     return 3 * 24 * 60 * 60;
731   }
732 
733   // only invoke at the beginning of auction
734   function _getMinAuctionStartPrice() internal view returns (uint256) {
735     if (reward < 10**18) {
736       return 10**15;
737     }
738 
739     uint256 n = 17;
740     for (n = 18; n < 200; n ++) {
741       if (reward >= 10**n && reward < 10**(n + 1)) {
742         break;
743       }
744     }
745 
746     return 10**(n-2);
747   }
748 
749 }