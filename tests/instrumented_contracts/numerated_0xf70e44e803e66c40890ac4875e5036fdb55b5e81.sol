1 pragma solidity ^0.4.18;
2 
3 // zeppelin-solidity@1.8.0 from NPM
4 
5 contract DataCenterInterface {
6   function getResult(bytes32 gameId) view public returns (uint16, uint16, uint8);
7 }
8 
9 contract DataCenterAddrResolverInterface {
10   function getAddress() public returns (address _addr);
11 }
12 
13 contract DataCenterBridge {
14   uint8 constant networkID_auto = 0;
15   uint8 constant networkID_mainnet = 1;
16   uint8 constant networkID_testnet = 3;
17   string public networkName;
18 
19   address public mainnetAddr = 0x6690E2698Bfa407DB697E69a11eA56810454549b;
20   address public testnetAddr = 0x282b192518fc09568de0E66Df8e2533f88C16672;
21 
22   DataCenterAddrResolverInterface DAR;
23 
24   DataCenterInterface dataCenter;
25 
26   modifier dataCenterAPI() {
27     if((address(DAR) == 0) || (getCodeSize(address(DAR)) == 0))
28       setNetwork(networkID_auto);
29     if(address(dataCenter) != DAR.getAddress())
30       dataCenter = DataCenterInterface(DAR.getAddress());
31     _;
32   }
33 
34   /**
35    * @dev set network will indicate which net will be used
36    * @notice comment out `networkID` to avoid 'unused parameter' warning
37    */
38   function setNetwork(uint8 /*networkID*/) internal returns(bool){
39     return setNetwork();
40   }
41 
42   function setNetwork() internal returns(bool){
43     if (getCodeSize(mainnetAddr) > 0) {
44       DAR = DataCenterAddrResolverInterface(mainnetAddr);
45       setNetworkName("eth_mainnet");
46       return true;
47     }
48     if (getCodeSize(testnetAddr) > 0) {
49       DAR = DataCenterAddrResolverInterface(testnetAddr);
50       setNetworkName("eth_ropsten");
51       return true;
52     }
53     return false;
54   }
55 
56   function setNetworkName(string _networkName) internal {
57     networkName = _networkName;
58   }
59 
60   function getNetworkName() internal view returns (string) {
61     return networkName;
62   }
63 
64   function dataCenterGetResult(bytes32 _gameId) dataCenterAPI internal returns (uint16, uint16, uint8){
65     return dataCenter.getResult(_gameId);
66   }
67 
68   function getCodeSize(address _addr) view internal returns (uint _size) {
69     assembly {
70       _size := extcodesize(_addr)
71     }
72   }
73 }
74 
75 /**
76  * @title Ownable
77  * @dev The Ownable contract has an owner address, and provides basic authorization control
78  * functions, this simplifies the implementation of "user permissions".
79  */
80 contract Ownable {
81   address public owner;
82 
83 
84   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86 
87   /**
88    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
89    * account.
90    */
91   function Ownable() public {
92     owner = msg.sender;
93   }
94 
95   /**
96    * @dev Throws if called by any account other than the owner.
97    */
98   modifier onlyOwner() {
99     require(msg.sender == owner);
100     _;
101   }
102 
103   /**
104    * @dev Allows the current owner to transfer control of the contract to a newOwner.
105    * @param newOwner The address to transfer ownership to.
106    */
107   function transferOwnership(address newOwner) public onlyOwner {
108     require(newOwner != address(0));
109     OwnershipTransferred(owner, newOwner);
110     owner = newOwner;
111   }
112 
113 }
114 
115 /**
116  * @title SafeMath
117  * @dev Math operations with safety checks that throw on error
118  */
119 library SafeMath {
120 
121   /**
122   * @dev Multiplies two numbers, throws on overflow.
123   */
124   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125     if (a == 0) {
126       return 0;
127     }
128     uint256 c = a * b;
129     assert(c / a == b);
130     return c;
131   }
132 
133   /**
134   * @dev Integer division of two numbers, truncating the quotient.
135   */
136   function div(uint256 a, uint256 b) internal pure returns (uint256) {
137     // assert(b > 0); // Solidity automatically throws when dividing by 0
138     uint256 c = a / b;
139     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
140     return c;
141   }
142 
143   /**
144   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
145   */
146   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147     assert(b <= a);
148     return a - b;
149   }
150 
151   /**
152   * @dev Adds two numbers, throws on overflow.
153   */
154   function add(uint256 a, uint256 b) internal pure returns (uint256) {
155     uint256 c = a + b;
156     assert(c >= a);
157     return c;
158   }
159 }
160 
161 contract Bet is Ownable, DataCenterBridge {
162   using SafeMath for uint;
163 
164   event LogDistributeReward(address indexed addr, uint reward, uint index);
165   event LogGameResult(bytes32 indexed category, bytes32 indexed gameId, uint leftPts, uint rightPts);
166   event LogParticipant(address indexed addr, uint choice, uint betAmount);
167   event LogRefund(address indexed addr, uint betAmount);
168   event LogBetClosed(bool isRefund, uint timestamp);
169   event LogDealerWithdraw(address indexed addr, uint withdrawAmount);
170 
171   /** 
172    * @desc
173    * gameId: is a fixed string just like "0021701030"
174    *   the full gameId encode(include football, basketball, esports..) will publish on github
175    * leftOdds: need divide 100, if odds is 216 means 2.16
176    * middleOdds: need divide 100, if odds is 175 means 1.75
177    * rightOdds: need divide 100, if odds is 250 means 2.50
178    * spread: need sub 0.5, if spread is 1 means 0.5, 0 means no spread
179    * flag: indicate which team get spread, 1 means leftTeam, 3 means rightTeam
180    */
181   struct BetInfo {
182     bytes32 category;
183     bytes32 gameId;
184     uint8   spread;
185     uint8   flag;
186     uint16  leftOdds;
187     uint16  middleOdds;
188     uint16  rightOdds;
189     uint    minimumBet;
190     uint    startTime;
191     uint    deposit;
192     address dealer;
193   }
194 
195   struct Player {
196     uint betAmount;
197     uint choice;
198   }
199 
200   /**
201    * @desc
202    * winChoice: Indicate the winner choice of this betting
203    *   1 means leftTeam win, 3 means rightTeam win, 2 means draw(leftTeam is not always equivalent to the home team)
204    */
205   uint8 public winChoice;
206   uint8 public confirmations = 0;
207   uint8 public neededConfirmations = 1;
208   uint16 public leftPts;
209   uint16 public rightPts;
210   bool public isBetClosed = false;
211 
212   uint public totalBetAmount = 0;
213   uint public leftAmount;
214   uint public middleAmount;
215   uint public rightAmount;
216   uint public numberOfBet;
217 
218   address [] public players;
219   mapping(address => Player) public playerInfo;
220 
221   /**
222    * @dev Throws if called by any account other than the dealer
223    */
224   modifier onlyDealer() {
225     require(msg.sender == betInfo.dealer);
226     _;
227   }
228 
229   function() payable public {}
230 
231   BetInfo betInfo;
232 
233   function Bet(address _dealer, bytes32 _category, bytes32 _gameId, uint _minimumBet, 
234                   uint8 _spread, uint16 _leftOdds, uint16 _middleOdds, uint16 _rightOdds, uint8 _flag,
235                   uint _startTime, uint8 _neededConfirmations, address _owner) payable public {
236     require(_flag == 1 || _flag == 3);
237     require(_startTime > now);
238     require(msg.value >= 0.1 ether);
239     require(_neededConfirmations >= neededConfirmations);
240 
241     betInfo.dealer = _dealer;
242     betInfo.deposit = msg.value;
243     betInfo.flag = _flag;
244     betInfo.category = _category;
245     betInfo.gameId = _gameId;
246     betInfo.minimumBet = _minimumBet;
247     betInfo.spread = _spread;
248     betInfo.leftOdds = _leftOdds;
249     betInfo.middleOdds = _middleOdds;
250     betInfo.rightOdds = _rightOdds;
251     betInfo.startTime = _startTime;
252 
253     neededConfirmations = _neededConfirmations;
254     owner = _owner;
255   }
256 
257   /**
258    * @dev get basic information of this bet
259    */
260   function getBetInfo() public view returns (bytes32, bytes32, uint8, uint8, uint16, uint16, uint16, uint, uint, uint, address) {
261     return (betInfo.category, betInfo.gameId, betInfo.spread, betInfo.flag, betInfo.leftOdds, betInfo.middleOdds,
262             betInfo.rightOdds, betInfo.minimumBet, betInfo.startTime, betInfo.deposit, betInfo.dealer);
263   }
264 
265   /**
266    * @dev get basic information of this bet
267    *
268    *  uint public numberOfBet;
269    *  uint public totalBetAmount = 0;
270    *  uint public leftAmount;
271    *  uint public middleAmount;
272    *  uint public rightAmount;
273    *  uint public deposit;
274    */
275   function getBetMutableData() public view returns (uint, uint, uint, uint, uint, uint) {
276     return (numberOfBet, totalBetAmount, leftAmount, middleAmount, rightAmount, betInfo.deposit);
277   }
278 
279   /**
280    * @dev get bet result information
281    *
282    *  uint8 public winChoice;
283    *  uint8 public confirmations = 0;
284    *  uint8 public neededConfirmations = 1;
285    *  uint16 public leftPts;
286    *  uint16 public rightPts;
287    *  bool public isBetClosed = false;
288    */
289   function getBetResult() public view returns (uint8, uint8, uint8, uint16, uint16, bool) {
290     return (winChoice, confirmations, neededConfirmations, leftPts, rightPts, isBetClosed);
291   }
292 
293   /**
294    * @dev calculate the gas whichdistribute rewards will cost
295    * set default gasPrice is 5000000000
296    */
297   function getRefundTxFee() public view returns (uint) {
298     return numberOfBet.mul(5000000000 * 21000);
299   }
300 
301   /**
302    * @dev find a player has participanted or not
303    * @param player the address of the participant
304    */
305   function checkPlayerExists(address player) public view returns (bool) {
306     if (playerInfo[player].choice == 0) {
307       return false;
308     }
309     return true;
310   }
311 
312   /**
313    * @dev to check the dealer is solvent or not
314    * @param choice indicate which team user choose
315    * @param amount indicate how many ether user bet
316    */
317   function isSolvent(uint choice, uint amount) internal view returns (bool) {
318     uint needAmount;
319     if (choice == 1) {
320       needAmount = (leftAmount.add(amount)).mul(betInfo.leftOdds).div(100);
321     } else if (choice == 2) {
322       needAmount = (middleAmount.add(amount)).mul(betInfo.middleOdds).div(100);
323     } else {
324       needAmount = (rightAmount.add(amount)).mul(betInfo.rightOdds).div(100);
325     }
326 
327     if (needAmount.add(getRefundTxFee()) > totalBetAmount.add(amount).add(betInfo.deposit)) {
328       return false;
329     } else {
330       return true;
331     }
332   }
333 
334   /**
335    * @dev update this bet some state
336    * @param choice indicate which team user choose
337    * @param amount indicate how many ether user bet
338    */
339   function updateAmountOfEachChoice(uint choice, uint amount) internal {
340     if (choice == 1) {
341       leftAmount = leftAmount.add(amount);
342     } else if (choice == 2) {
343       middleAmount = middleAmount.add(amount);
344     } else {
345       rightAmount = rightAmount.add(amount);
346     }
347   }
348 
349   /**
350    * @dev place a bet with his/her choice
351    * @param choice indicate which team user choose
352    */
353   function placeBet(uint choice) public payable {
354     require(now < betInfo.startTime);
355     require(choice == 1 ||  choice == 2 || choice == 3);
356     require(msg.value >= betInfo.minimumBet);
357     require(!checkPlayerExists(msg.sender));
358 
359     if (!isSolvent(choice, msg.value)) {
360       revert();
361     }
362 
363     playerInfo[msg.sender].betAmount = msg.value;
364     playerInfo[msg.sender].choice = choice;
365 
366     totalBetAmount = totalBetAmount.add(msg.value);
367     numberOfBet = numberOfBet.add(1);
368     updateAmountOfEachChoice(choice, msg.value);
369     players.push(msg.sender);
370     LogParticipant(msg.sender, choice, msg.value);
371   }
372 
373   /**
374    * @dev in order to let more people participant, dealer can recharge
375    */
376   function rechargeDeposit() public payable {
377     require(msg.value >= betInfo.minimumBet);
378     betInfo.deposit = betInfo.deposit.add(msg.value);
379   }
380 
381   /**
382    * @dev given game result, _return win choice by specific spread
383    */
384   function getWinChoice(uint _leftPts, uint _rightPts) public view returns (uint8) {
385     uint8 _winChoice;
386     if (betInfo.spread == 0) {
387       if (_leftPts > _rightPts) {
388         _winChoice = 1;
389       } else if (_leftPts == _rightPts) {
390         _winChoice = 2;
391       } else {
392         _winChoice = 3;
393       }
394     } else {
395       if (betInfo.flag == 1) {
396         if (_leftPts + betInfo.spread > _rightPts) {
397           _winChoice = 1;
398         } else {
399           _winChoice = 3;
400         }
401       } else {
402         if (_rightPts + betInfo.spread > _leftPts) {
403           _winChoice = 3;
404         } else {
405           _winChoice = 1;
406         }
407       }
408     }
409     return _winChoice;
410   }
411 
412   /**
413    * @dev manualCloseBet could only be called by owner,
414    *      this method only be used for ropsten,
415    *      when ethereum-events-data deployed,
416    *      game result should not be upload by owner
417    */
418   function manualCloseBet(uint16 _leftPts, uint16 _rightPts) onlyOwner external {
419     require(!isBetClosed);
420     leftPts = _leftPts;
421     rightPts = _rightPts;
422 
423     LogGameResult(betInfo.category, betInfo.gameId, leftPts, rightPts);
424 
425     winChoice = getWinChoice(leftPts, rightPts);
426 
427     if (winChoice == 1) {
428       distributeReward(betInfo.leftOdds);
429     } else if (winChoice == 2) {
430       distributeReward(betInfo.middleOdds);
431     } else {
432       distributeReward(betInfo.rightOdds);
433     }
434 
435     isBetClosed = true;
436     LogBetClosed(false, now);
437     withdraw();
438   }
439 
440   /**
441    * @dev closeBet could be called by everyone, but owner/dealer should to this.
442    */
443   function closeBet() external {
444     require(!isBetClosed);
445     (leftPts, rightPts, confirmations) = dataCenterGetResult(betInfo.gameId);
446 
447     require(confirmations >= neededConfirmations);
448 
449     LogGameResult(betInfo.category, betInfo.gameId, leftPts, rightPts);
450 
451     winChoice = getWinChoice(leftPts, rightPts);
452 
453     if (winChoice == 1) {
454       distributeReward(betInfo.leftOdds);
455     } else if (winChoice == 2) {
456       distributeReward(betInfo.middleOdds);
457     } else {
458       distributeReward(betInfo.rightOdds);
459     }
460 
461     isBetClosed = true;
462     LogBetClosed(false, now);
463     withdraw();
464   }
465 
466   /**
467    * @dev get the players
468    */
469   function getPlayers() view public returns (address[]) {
470     return players;
471   }
472 
473   /**
474    * @dev get contract balance
475    */
476   function getBalance() view public returns (uint) {
477     return address(this).balance;
478   }
479 
480   /**
481    * @dev if there are some reasons lead game postpone or cancel
482    *      the bet will also cancel and refund every bet
483    */
484   function refund() onlyOwner public {
485     for (uint i = 0; i < players.length; i++) {
486       players[i].transfer(playerInfo[players[i]].betAmount);
487       LogRefund(players[i], playerInfo[players[i]].betAmount);
488     }
489 
490     isBetClosed = true;
491     LogBetClosed(true, now);
492     withdraw();
493   }
494 
495   /**
496    * @dev dealer can withdraw the remain ether after refund or closed
497    */
498   function withdraw() internal {
499     require(isBetClosed);
500     uint _balance = address(this).balance;
501     betInfo.dealer.transfer(_balance);
502     LogDealerWithdraw(betInfo.dealer, _balance);
503   }
504 
505   /**
506    * @dev distribute ether to every winner as they choosed odds
507    */
508   function distributeReward(uint winOdds) internal {
509     for (uint i = 0; i < players.length; i++) {
510       if (playerInfo[players[i]].choice == winChoice) {
511         players[i].transfer(winOdds.mul(playerInfo[players[i]].betAmount).div(100));
512         LogDistributeReward(players[i], winOdds.mul(playerInfo[players[i]].betAmount).div(100), i);
513       }
514     }
515   }
516 }
517 
518 contract BetCenter is Ownable {
519 
520   event LogCreateBet(uint indexed startTime, uint indexed spreadTag, bytes32 indexed category, uint deposit, address bet, bytes32 gameId);
521 
522   function() payable public {}
523 
524   function createBet(bytes32 category, bytes32 gameId, uint minimumBet, 
525                   uint8 spread, uint16 leftOdds, uint16 middleOdds, uint16 rightOdds, uint8 flag,
526                   uint startTime, uint8 confirmations) payable public {
527     Bet bet = (new Bet).value(msg.value)(msg.sender, category, gameId, minimumBet, 
528                   spread, leftOdds, middleOdds, rightOdds , flag, startTime, confirmations, owner);
529     if (spread == 0) {
530       LogCreateBet(startTime, 0, category, msg.value, bet, gameId);
531     } else {
532       LogCreateBet(startTime, 1, category, msg.value, bet, gameId);
533     }
534   }
535 }