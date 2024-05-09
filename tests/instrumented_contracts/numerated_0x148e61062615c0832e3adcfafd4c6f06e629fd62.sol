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
125   }
126 
127   function addAuctionReward() public payable {
128     reward = reward + msg.value;
129   }
130 
131 
132   uint256 gameId; // gameId increase from 1
133   uint256 gameStartTime;  // game start time
134   uint256 gameLastAuctionTime;   // last auction time
135   uint256 gameLastAuctionMoney; 
136   uint256 gameSecondLeft; // how many seconds left to auction
137 
138 
139   ////////////////////////// money
140 
141   uint256 reward; // reward for winner
142   uint256 dividends;  // total dividends for players
143   uint256 nextReward; // reward for next round
144   uint256 dividendForDev;
145 
146 
147   ////////////////////////// api
148 
149   OracleBase oracleAPI;
150 
151   function setOracleAPIAddress(address _addr) public onlyOwner {
152     oracleAPI = OracleBase(_addr);
153   }
154 
155   uint rollCount = 100;
156 
157   function getRandom() internal returns (uint256) {
158     rollCount = rollCount + 1;
159     return oracleAPI.getRandomForContract(100, rollCount);
160   }
161 
162 
163 
164   ////////////////////////// game money
165 
166   function _inMoney(uint _m) internal {
167     dividends = dividends + _m * 7 / 100;
168     dividendForDev = dividendForDev + _m * 2 / 100;
169 
170     reward = reward + _m * 2 / 100;
171     nextReward = nextReward + _m * 4 / 100;
172   }
173 
174   function _startNewRound(address _addr) internal {
175     reward = nextReward * 80 / 100;
176     nextReward = nextReward * 20 / 100;
177     gameId = gameId + 1;
178     dividends = 0;
179 
180     gameStartTime = block.timestamp;
181     gameLastAuctionTime = block.timestamp;
182 
183 
184     uint256 price = _getMinAuctionStartPrice();
185     reward = reward.sub(price);
186 
187     PlayerAuction memory p;
188     gameAuction[gameId].push(p);
189     gameAuction[gameId][0].addr = _addr;
190     gameAuction[gameId][0].money = price;
191     gameAuction[gameId][0].bid = price;
192     gameAuction[gameId][0].refunded = false;
193     gameAuction[gameId][0].dividended = false;
194 
195     gameLastAuctionMoney = price;
196     gameSecondLeft = _getInitAuctionSeconds();
197 
198     emit GameAuction(gameId, _addr, price, price, gameSecondLeft, block.timestamp);
199   }
200 
201   function adminPayout() public onlyOwner {
202     owner.transfer(dividendForDev);
203     dividendForDev = 0;
204   }
205 
206   ////////////////////////// game struct
207 
208   struct GameData {
209     uint256 gameId;
210     uint256 reward;
211     uint256 dividends;
212   }
213 
214   struct PlayerAuction {
215     address addr;
216     uint256 money;
217     uint256 bid;
218     bool refunded;
219     bool dividended;
220   }
221 
222   mapping(uint256 => PlayerAuction[]) gameAuction;
223 
224   GameData[] gameData;
225 
226   ////////////////////////// game event
227 
228   event GameAuction(uint indexed gameId, address player, uint money, uint auctionValue, uint secondsLeft, uint datetime);
229   
230   event GameRewardClaim(uint indexed gameId, address indexed player, uint money);
231 
232   event GameRewardRefund(uint indexed gameId, address indexed player, uint money);
233 
234   event GameEnd(uint indexed gameId, address indexed winner, uint money, uint datetime);
235 
236   ////////////////////////// game play
237 
238   function getMinAuctionValue() public view returns (uint256) {
239     uint256 gap = _getGameAuctionGap();
240     uint256 auctionValue = gap + gameLastAuctionMoney;
241     return auctionValue;
242   }
243 
244   function auction() public payable {
245     bool ended = (block.timestamp > gameLastAuctionTime + gameSecondLeft) ? true: false;
246     if (ended) {
247       revert('this round end!!!');
248     }
249 
250     uint256 len = gameAuction[gameId].length;
251     if (len > 1) {
252       address bidder = gameAuction[gameId][len - 1].addr;
253       if (msg.sender == bidder)
254         revert("wrong action");
255     }
256 
257     uint256 gap = _getGameAuctionGap();
258     uint256 auctionValue = gap + gameLastAuctionMoney;
259     uint256 maxAuctionValue = 3 * gap + gameLastAuctionMoney;
260 
261     if (msg.value < auctionValue) {
262       revert("wrong eth value!");
263     }
264 
265     if (msg.value >= maxAuctionValue) {
266       auctionValue = maxAuctionValue;
267     } else {
268       auctionValue = msg.value;
269     }
270 
271     gameLastAuctionMoney = auctionValue;
272     _inMoney(auctionValue);
273     gameLastAuctionTime = block.timestamp;
274 
275     uint256 random = getRandom();
276     gameSecondLeft = random * (_getMaxAuctionSeconds() - _getMinAuctionSeconds()) / 100 + _getMinAuctionSeconds();
277 
278     PlayerAuction memory p;
279     gameAuction[gameId].push(p);
280     gameAuction[gameId][gameAuction[gameId].length - 1].addr = msg.sender;
281     gameAuction[gameId][gameAuction[gameId].length - 1].money = msg.value;
282     gameAuction[gameId][gameAuction[gameId].length - 1].bid = auctionValue;
283     gameAuction[gameId][gameAuction[gameId].length - 1].refunded = false;
284     gameAuction[gameId][gameAuction[gameId].length - 1].dividended = false;
285 
286     emit GameAuction(gameId, msg.sender, msg.value, auctionValue, gameSecondLeft, block.timestamp);
287   }
288 
289   function claimReward(uint256 _id) public {
290     _claimReward(msg.sender, _id);
291   }
292 
293   function _claimReward(address _addr, uint256 _id) internal {
294     if (_id == gameId) {
295       bool ended = (block.timestamp > gameLastAuctionTime + gameSecondLeft) ? true: false;
296       if (ended == false)
297         revert('game is still on, cannot claim reward');
298     }
299 
300     uint _reward = 0;
301     uint _dividends = 0;
302     uint _myMoney = 0;
303     uint _myDividends = 0;
304     uint _myRefund = 0;
305     uint _myReward = 0;
306     bool _claimed = false;
307     (_myMoney, _myDividends, _myRefund, _myReward, _claimed) = _getGameInfoPart1(_addr, _id);
308     (_reward, _dividends) = _getGameInfoPart2(_id);
309 
310     if (_claimed)
311       revert('already claimed!');
312 
313     for (uint k = 0; k < gameAuction[_id].length; k++) {
314       if (gameAuction[_id][k].addr == _addr) {
315         gameAuction[_id][k].dividended = true;
316       }
317     }
318 
319     _addr.transfer(_myDividends + _myRefund + _myReward); 
320     emit GameRewardClaim(_id, _addr, _myDividends + _myRefund + _myReward);
321   }
322 
323   // can only refund game still on
324   function refund() public {
325     uint256 len = gameAuction[gameId].length;
326     if (len > 1) {
327       if (msg.sender != gameAuction[gameId][len - 2].addr
328         && msg.sender != gameAuction[gameId][len - 1].addr) {
329 
330         uint256 money = 0;
331 
332         for (uint k = 0; k < gameAuction[gameId].length; k++) {
333           if (gameAuction[gameId][k].addr == msg.sender && gameAuction[gameId][k].refunded == false) {
334             money = money + gameAuction[gameId][k].bid * 85 / 100 + gameAuction[gameId][k].money;
335             gameAuction[gameId][k].refunded = true;
336           }
337         }
338 
339         msg.sender.transfer(money); 
340         emit GameRewardRefund(gameId, msg.sender, money);
341       } else {
342         revert('cannot refund because you are no.2 bidder');
343       }
344     }   
345   }
346 
347 
348   // anyone can end this round
349   function gameRoundEnd() public {
350     bool ended = (block.timestamp > gameLastAuctionTime + gameSecondLeft) ? true: false;
351     if (ended == false)
352       revert("game cannot end");
353 
354     uint256 len = gameAuction[gameId].length;
355     address winner = gameAuction[gameId][len - 1].addr;
356 
357     GameData memory d;
358     gameData.push(d);
359     gameData[gameData.length - 1].gameId = gameId;
360     gameData[gameData.length - 1].reward = reward;
361     gameData[gameData.length - 1].dividends = dividends;
362 
363     _startNewRound(msg.sender);
364 
365     _claimReward(msg.sender, gameId - 1);
366 
367     emit GameEnd(gameId - 1, winner, gameData[gameData.length - 1].reward, block.timestamp);
368   }
369 
370   function getCurrCanRefund() public view returns (bool) {
371 
372     if (gameAuction[gameId].length > 1) {
373       if (msg.sender == gameAuction[gameId][gameAuction[gameId].length - 2].addr) {
374         return false;
375       } else if (msg.sender == gameAuction[gameId][gameAuction[gameId].length - 1].addr) {
376         return false;
377       }
378       return true;
379     } else {
380       return false;
381     }
382   }
383 
384   function getCurrGameInfo() public view returns (uint256 _gameId, 
385                                                           uint256 _reward, 
386                                                           uint256 _dividends,
387                                                           uint256 _lastAuction, 
388                                                           uint256 _gap, 
389                                                           uint256 _lastAuctionTime,
390                                                           uint256 _secondsLeft, 
391                                                           uint256 _myMoney,
392                                                           uint256 _myDividends,
393                                                           uint256 _myRefund,
394                                                           bool _ended) {
395     _gameId = gameId;
396 
397     _reward = reward;
398     _dividends = dividends;
399     _lastAuction = gameLastAuctionMoney;
400     _gap = _getGameAuctionGap();
401     _lastAuctionTime = gameLastAuctionTime;
402     _secondsLeft = gameSecondLeft;
403     _ended = (block.timestamp > _lastAuctionTime + _secondsLeft) ? true: false;
404 
405     uint256 _moneyForCal = 0;
406 
407     if (gameAuction[gameId].length > 1) {
408 
409       uint256 totalMoney = 0;
410 
411       for (uint256 i = 0; i < gameAuction[gameId].length; i++) {
412         if (gameAuction[gameId][i].addr == msg.sender && gameAuction[gameId][i].dividended == true) {
413 
414         }
415 
416         if (gameAuction[gameId][i].addr == msg.sender && gameAuction[gameId][i].refunded == false) {
417 
418           if ((i == gameAuction[gameId].length - 2) || (i == gameAuction[gameId].length - 1)) {
419             _myRefund = _myRefund.add(gameAuction[gameId][i].money).sub(gameAuction[gameId][i].bid);
420           } else {
421             _myRefund = _myRefund.add(gameAuction[gameId][i].money).sub(gameAuction[gameId][i].bid.mul(15).div(100));
422           }
423 
424           _myMoney = _myMoney + gameAuction[gameId][i].money;
425 
426           _moneyForCal = _moneyForCal.add((gameAuction[gameId][i].money.div(10**15)).mul(gameAuction[gameId][i].money.div(10**15)).mul(gameAuction[gameId].length + 1 - i));
427         }
428 
429         if (gameAuction[gameId][i].refunded == false) {
430           totalMoney = totalMoney.add((gameAuction[gameId][i].money.div(10**15)).mul(gameAuction[gameId][i].money.div(10**15)).mul(gameAuction[gameId].length + 1 - i));
431         }
432       }
433 
434       if (totalMoney != 0)
435         _myDividends = _moneyForCal.mul(_dividends).div(totalMoney);
436     }
437   }
438 
439   function getGameDataByIndex(uint256 _index) public view returns (uint256 _id, uint256 _reward, uint256 _dividends) {
440     uint256 len = gameData.length;
441     if (len >= (_index + 1)) {
442       GameData memory d = gameData[_index];
443       _id = d.gameId;
444       _reward = d.reward;
445       _dividends = d.dividends;
446     }
447   }
448 
449   function getGameInfo(uint256 _id) public view returns (uint256 _reward, uint256 _dividends, uint256 _myMoney, uint256 _myDividends, uint256 _myRefund, uint256 _myReward, bool _claimed) {
450     (_reward, _dividends) = _getGameInfoPart2(_id);
451     (_myMoney, _myRefund, _myDividends, _myReward, _claimed) = _getGameInfoPart1(msg.sender, _id);
452   }
453 
454   function _getGameInfoPart1(address _addr, uint256 _id) internal view returns (uint256 _myMoney, uint256 _myRefund, uint256 _myDividends, uint256 _myReward, bool _claimed) {
455     uint256 totalMoney = 0;
456     uint k = 0;
457 
458     if (_id == gameId) {
459      
460     } else {
461 
462       for (uint256 i = 0; i < gameData.length; i++) {
463         GameData memory d = gameData[i];
464         if (d.gameId == _id) {
465 
466           if (gameAuction[d.gameId].length > 1) {
467 
468             // no.2 bidder can refund except for the last one
469             if (gameAuction[d.gameId][gameAuction[d.gameId].length - 1].addr == _addr) {
470               // if sender is winner
471               _myReward = d.reward;
472 
473               _myReward = _myReward + gameAuction[d.gameId][gameAuction[d.gameId].length - 2].bid;
474             }
475 
476             // add no.2 bidder's money to winner
477             // address loseBidder = gameAuction[d.gameId][gameAuction[d.gameId].length - 2].addr;
478 
479             totalMoney = 0;
480             uint256 _moneyForCal = 0;
481 
482             for (k = 0; k < gameAuction[d.gameId].length; k++) {
483 
484               if (gameAuction[d.gameId][k].addr == _addr && gameAuction[d.gameId][k].dividended == true) {
485                 _claimed = true;
486               }
487 
488               // k != (gameAuction[d.gameId].length - 2): for no.2 bidder, who cannot refund this bid
489               if (gameAuction[d.gameId][k].addr == _addr && gameAuction[d.gameId][k].refunded == false && k != (gameAuction[d.gameId].length - 2)) {
490                 _myRefund = _myRefund.add( gameAuction[d.gameId][k].money.sub( gameAuction[d.gameId][k].bid.mul(15).div(100) ) );
491                 _moneyForCal = _moneyForCal.add( (gameAuction[d.gameId][k].money.div(10**15)).mul( gameAuction[d.gameId][k].money.div(10**15) ).mul( gameAuction[d.gameId].length + 1 - k) );
492                 _myMoney = _myMoney.add(gameAuction[d.gameId][k].money);
493               }
494 
495               if (gameAuction[d.gameId][k].refunded == false && k != (gameAuction[d.gameId].length - 2)) {
496                 totalMoney = totalMoney.add( ( gameAuction[d.gameId][k].money.div(10**15) ).mul( gameAuction[d.gameId][k].money.div(10**15) ).mul( gameAuction[d.gameId].length + 1 - k) );
497               }
498             }
499 
500             if (totalMoney != 0)
501               _myDividends = d.dividends.mul(_moneyForCal).div(totalMoney);
502 
503           }
504   
505           break;
506         }
507       }
508     } 
509   }
510 
511   function _getGameInfoPart2(uint256 _id) internal view returns (uint256 _reward, uint256 _dividends) {
512     if (_id == gameId) {
513      
514     } else {
515       for (uint256 i = 0; i < gameData.length; i++) {
516         GameData memory d = gameData[i];
517         if (d.gameId == _id) {
518           _reward = d.reward;
519           _dividends = d.dividends;
520           break;
521         }
522       }
523     }
524   }
525 
526   ////////////////////////// game rule
527 
528   function _getGameStartAuctionMoney() internal pure returns (uint256) {
529     return 10**15;
530   }
531 
532   function _getGameAuctionGap() internal view returns (uint256) {
533     if (gameLastAuctionMoney < 10**18) {
534       return 10**15;
535     }
536 
537     uint256 n = 17;
538     for (n = 18; n < 200; n ++) {
539       if (gameLastAuctionMoney >= 10**n && gameLastAuctionMoney < 10**(n + 1)) {
540         break;
541       }
542     }
543 
544     return 10**(n-2);
545   }
546 
547   function _getMinAuctionSeconds() internal pure returns (uint256) {
548     return 15 * 60;
549     // return 1 * 60; //test
550   }
551 
552   function _getMaxAuctionSeconds() internal pure returns (uint256) {
553     return 30 * 60;
554     // return 3 * 60;  //test
555   }
556 
557   function _getInitAuctionSeconds() internal pure returns (uint256) {
558     return 3 * 24 * 60 * 60;
559   }
560 
561   // only invoke at the beginning of auction
562   function _getMinAuctionStartPrice() internal view returns (uint256) {
563     if (reward < 10**18) {
564       return 10**15;
565     }
566 
567     uint256 n = 17;
568     for (n = 18; n < 200; n ++) {
569       if (reward >= 10**n && reward < 10**(n + 1)) {
570         break;
571       }
572     }
573 
574     return 10**(n-2);
575   }
576 
577 }