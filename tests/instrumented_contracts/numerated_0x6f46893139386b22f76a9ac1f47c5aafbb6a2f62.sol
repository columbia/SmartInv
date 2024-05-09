1 pragma solidity ^0.4.24;
2 
3 // File: contracts\utils\SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49   /**
50   * @dev gives square root of given x.
51   */
52   function sqrt(uint256 x)
53     internal
54     pure
55     returns (uint256 y)
56   {
57     uint256 z = ((add(x,1)) / 2);
58     y = x;
59     while (z < y)
60     {
61         y = z;
62         z = ((add((x / z),z)) / 2);
63     }
64   }
65 
66   /**
67   * @dev gives square. multiplies x by x
68   */
69   function sq(uint256 x)
70     internal
71     pure
72     returns (uint256)
73   {
74     return (mul(x,x));
75   }
76 
77   /**
78   * @dev x to the power of y
79   */
80   function pwr(uint256 x, uint256 y)
81     internal
82     pure
83     returns (uint256)
84   {
85     if (x==0)
86         return (0);
87     else if (y==0)
88         return (1);
89     else
90     {
91         uint256 z = x;
92         for (uint256 i=1; i < y; i++)
93             z = mul(z,x);
94         return (z);
95     }
96   }
97 }
98 
99 // File: contracts\CKingCal.sol
100 
101 library CKingCal {
102 
103   using SafeMath for *;
104   /**
105   * @dev calculates number of keys received given X eth
106   * @param _curEth current amount of eth in contract
107   * @param _newEth eth being spent
108   * @return amount of ticket purchased
109   */
110   function keysRec(uint256 _curEth, uint256 _newEth)
111     internal
112     pure
113     returns (uint256)
114   {
115     return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
116   }
117 
118   /**
119   * @dev calculates amount of eth received if you sold X keys
120   * @param _curKeys current amount of keys that exist
121   * @param _sellKeys amount of keys you wish to sell
122   * @return amount of eth received
123   */
124   function ethRec(uint256 _curKeys, uint256 _sellKeys)
125     internal
126     pure
127     returns (uint256)
128   {
129     return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
130   }
131 
132   /**
133   * @dev calculates how many keys would exist with given an amount of eth
134   * @param _eth total ether received.
135   * @return number of keys that would exist
136   */
137   function keys(uint256 _eth)
138     internal
139     pure
140     returns(uint256)
141   {
142       // sqrt((eth*1 eth* 312500000000000000000000000)+5624988281256103515625000000000000000000000000000000000000000000) - 74999921875000000000000000000000) / 15625000
143       return ((((((_eth).mul(1000000000000000000)).mul(31250000000000000000000000)).add(56249882812561035156250000000000000000000000000000000000000000)).sqrt()).sub(7499992187500000000000000000000)) / (15625000);
144   }  
145 
146   /**
147   * @dev calculates how much eth would be in contract given a number of keys
148   * @param _keys number of keys "in contract"
149   * @return eth that would exists
150   */
151   function eth(uint256 _keys)
152     internal
153     pure
154     returns(uint256)
155   {
156     // (149999843750000*keys*1 eth) + 78125000 * keys * keys) /2 /(sq(1 ether))
157     return ((7812500).mul(_keys.sq()).add(((14999984375000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
158   }
159 }
160 
161 // File: contracts\utils\Ownable.sol
162 
163 /**
164  * @title Ownable
165  * @dev The Ownable contract has an owner address, and provides basic authorization control
166  * functions, this simplifies the implementation of "user permissions".
167  */
168 contract Ownable {
169   address public owner;
170 
171 
172   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
173 
174 
175   /**
176    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
177    * account.
178    */
179   constructor() public {
180     owner = msg.sender;
181   }
182 
183   /**
184    * @dev Throws if called by any account other than the owner.
185    */
186   modifier onlyOwner() {
187     require(msg.sender == owner);
188     _;
189   }
190 
191   /**
192    * @dev Allows the current owner to transfer control of the contract to a newOwner.
193    * @param newOwner The address to transfer ownership to.
194    */
195   function transferOwnership(address newOwner) public onlyOwner {
196     require(newOwner != address(0));
197     emit OwnershipTransferred(owner, newOwner);
198     owner = newOwner;
199   }
200 
201 }
202 
203 // File: contracts\TowerCKing.sol
204 
205 contract CKing is Ownable {
206   using SafeMath for *;
207   using CKingCal for uint256;
208 
209 
210   string constant public name = "Cryptower";
211   string constant public symbol = "CT";
212 
213   // time constants;
214   uint256 constant private timeInit = 1 weeks; // 600; //1 week 
215   uint256 constant private timeInc = 30 seconds; //60 ///////
216   uint256 constant private timeMax = 30 minutes; // 300
217 
218   // profit distribution parameters
219   uint256 constant private fixRet = 46;
220   uint256 constant private extraRet = 10;
221   uint256 constant private affRet = 10;
222   uint256 constant private gamePrize = 12;
223   uint256 constant private groupPrize = 12;
224   uint256 constant private devTeam = 10;
225 
226   // player data
227   struct Player {
228     address addr; // player address
229     string name; // playerName
230     uint256 aff;  // affliliate vault
231     uint256 affId; // affiliate id, who referered u
232     uint256 hretKeys; // number of high return keys
233     uint256 mretKeys; // number of medium return keys
234     uint256 lretKeys; // number of low return keys
235     uint256 eth;      // total eth spend for the keys
236     uint256 ethWithdraw; // earning withdrawed by user
237   }
238 
239   mapping(uint256 => Player) public players; // player data
240   mapping(address => uint) public addrXpId; // player address => pId
241   uint public playerNum = 0;
242 
243   // game info
244   uint256 public totalEther;     // total key sale revenue
245   uint256 public totalKeys;      // total number of keys.
246   uint256 private constant minPay = 1000000000; // minimum pay to buy keys or deposit in game;
247   uint256 public totalCommPot;   // total ether going to be distributed
248   uint256 private keysForGame;    // keys belongs to the game for profit distribution
249   uint256 private gamePot;        // ether need to be distributed based on the side chain game
250   uint256 public teamWithdrawed; // eth withdrawed by dev team. 
251   uint256 public gameWithdrawed; // ether already been withdrawn from game pot 
252   uint256 public endTime;        // main game end time
253   address public CFO;
254   address public COO; 
255   address public fundCenter; 
256   address public playerBook; 
257 
258 
259 
260   uint private stageId = 1;   // stageId start 1
261   uint private constant groupPrizeStartAt = 2000000000000000000000000; // 1000000000000000000000;
262   uint private constant groupPrizeStageGap = 100000000000000000000000; // 100000000000000000000
263   mapping(uint => mapping(uint => uint)) public stageInfo; // stageId => pID => keys purchased in this stage
264 
265   // admin params
266   uint256 public startTime;  // admin set start
267   uint256 constant private coolDownTime = 2 days; // team is able to withdraw fund 2 days after game end.
268 
269   modifier isGameActive() {
270     uint _now = now;
271     require(_now > startTime && _now < endTime);
272     _;
273   }
274   
275   modifier onlyCOO() {
276     require(COO == msg.sender, "Only COO can operate.");
277     _; 
278   }
279 
280   // events
281   event BuyKey(uint indexed _pID, uint _affId, uint _keyType, uint _keyAmount);
282   event EarningWithdraw(uint indexed _pID, address _addr, uint _amount);
283 
284 
285   constructor(address _CFO, address _COO, address _fundCenter, address _playerBook) public {
286     CFO = _CFO;
287     COO = _COO; 
288     fundCenter = _fundCenter; 
289     playerBook = _playerBook; 
290   }
291     
292   function setCFO(address _CFO) onlyOwner public {
293     CFO = _CFO; 
294   }  
295   
296   function setCOO(address _COO) onlyOwner public {
297     COO = _COO; 
298   }  
299   
300   function setContractAddress(address _fundCenter, address _playerBook) onlyCOO public {
301     fundCenter = _fundCenter; 
302     playerBook = _playerBook; 
303   }
304 
305   function startGame(uint _startTime) onlyCOO public {
306     require(_startTime > now);
307     startTime = _startTime;
308     endTime = startTime.add(timeInit);
309   }
310   
311   function gameWithdraw(uint _amount) onlyCOO public {
312     // users may choose to withdraw eth from cryptower game, allow dev team to withdraw eth from this contract to fund center. 
313     uint _total = getTotalGamePot(); 
314     uint _remainingBalance = _total.sub(gameWithdrawed); 
315     
316     if(_amount > 0) {
317       require(_amount <= _remainingBalance);
318     } else{
319       _amount = _remainingBalance;
320     }
321     
322     fundCenter.transfer(_amount); 
323     gameWithdrawed = gameWithdrawed.add(_amount); 
324   }
325 
326 
327   function teamWithdraw(uint _amount) onlyCOO public {
328     uint256 _now = now;
329     if(_now > endTime.add(coolDownTime)) {
330       // dev team have rights to withdraw all remaining balance 2 days after game end. 
331       // if users does not claim their ETH within coolDown period, the team may withdraw their remaining balance. Users can go to crytower game to get their ETH back.
332       CFO.transfer(_amount);
333       teamWithdrawed = teamWithdrawed.add(_amount); 
334     } else {
335         uint _total = totalEther.mul(devTeam).div(100); 
336         uint _remainingBalance = _total.sub(teamWithdrawed); 
337         
338         if(_amount > 0) {
339             require(_amount <= _remainingBalance);
340         } else{
341             _amount = _remainingBalance;
342         }
343         CFO.transfer(_amount);
344         teamWithdrawed = teamWithdrawed.add(_amount); 
345     }
346   }
347   
348 
349   function updateTimer(uint256 _keys) private {
350     uint256 _now = now;
351     uint256 _newTime;
352 
353     if(endTime.sub(_now) < timeMax) {
354         _newTime = ((_keys) / (1000000000000000000)).mul(timeInc).add(endTime);
355         if(_newTime.sub(_now) > timeMax) {
356             _newTime = _now.add(timeMax);
357         }
358         endTime = _newTime;
359     }
360   }
361   
362   function receivePlayerInfo(address _addr, string _name) external {
363     require(msg.sender == playerBook, "must be from playerbook address"); 
364     uint _pID = addrXpId[_addr];
365     if(_pID == 0) { // player not exist yet. create one 
366         playerNum = playerNum + 1;
367         Player memory p; 
368         p.addr = _addr;
369         p.name = _name; 
370         players[playerNum] = p; 
371         _pID = playerNum; 
372         addrXpId[_addr] = _pID;
373     } else {
374         players[_pID].name = _name; 
375     }
376   }
377 
378   function buyByAddress(uint256 _affId, uint _keyType) payable isGameActive public {
379     uint _pID = addrXpId[msg.sender];
380     if(_pID == 0) { // player not exist yet. create one
381       playerNum = playerNum + 1;
382       Player memory p;
383       p.addr = msg.sender;
384       p.affId = _affId;
385       players[playerNum] = p;
386       _pID = playerNum;
387       addrXpId[msg.sender] = _pID;
388     }
389     buy(_pID, msg.value, _affId, _keyType);
390   }
391 
392   function buyFromVault(uint _amount, uint256 _affId, uint _keyType) public isGameActive  {
393     uint _pID = addrXpId[msg.sender];
394     uint _earning = getPlayerEarning(_pID);
395     uint _newEthWithdraw = _amount.add(players[_pID].ethWithdraw);
396     require(_newEthWithdraw < _earning); // withdraw amount cannot bigger than earning
397     players[_pID].ethWithdraw = _newEthWithdraw; // update player withdraw
398     buy(_pID, _amount, _affId, _keyType);
399   }
400 
401   function getKeyPrice(uint _keyAmount) public view returns(uint256) {
402     if(now > startTime) {
403       return totalKeys.add(_keyAmount).ethRec(_keyAmount);
404     } else { // copy fomo init price
405       return (7500000000000);
406     }
407   }
408 
409   function buy(uint256 _pID, uint256 _eth, uint256 _affId, uint _keyType) private {
410 
411     if (_eth > minPay) { // bigger than minimum pay
412       players[_pID].eth = _eth.add(players[_pID].eth);
413       uint _keys = totalEther.keysRec(_eth);
414       //bought at least 1 whole key
415       if(_keys >= 1000000000000000000) {
416         updateTimer(_keys);
417       }
418 
419       //update total ether and total keys
420       totalEther = totalEther.add(_eth);
421       totalKeys = totalKeys.add(_keys);
422       // update game portion
423       uint256 _game = _eth.mul(gamePrize).div(100);
424       gamePot = _game.add(gamePot);
425 
426 
427       // update player keys and keysForGame
428       if(_keyType == 1) { // high return key
429         players[_pID].hretKeys  = _keys.add(players[_pID].hretKeys);
430       } else if (_keyType == 2) {
431         players[_pID].mretKeys = _keys.add(players[_pID].mretKeys);
432         keysForGame = keysForGame.add(_keys.mul(extraRet).div(fixRet+extraRet));
433       } else if (_keyType == 3) {
434         players[_pID].lretKeys = _keys.add(players[_pID].lretKeys);
435         keysForGame = keysForGame.add(_keys);
436       } else { // keytype unknown.
437         revert();
438       }
439       //update affliliate gain
440       if(_affId != 0 && _affId != _pID && _affId <= playerNum) { // udate players
441           uint256 _aff = _eth.mul(affRet).div(100);
442           players[_affId].aff = _aff.add(players[_affId].aff);
443           totalCommPot = (_eth.mul(fixRet+extraRet).div(100)).add(totalCommPot);
444       } else { // addId == 0 or _affId is self, put the fund into earnings per key
445           totalCommPot = (_eth.mul(fixRet+extraRet+affRet).div(100)).add(totalCommPot);
446       }
447       // update stage info
448       if(totalKeys > groupPrizeStartAt) {
449         updateStageInfo(_pID, _keys);
450       }
451       emit BuyKey(_pID, _affId, _keyType, _keys);
452     } else { // if contribute less than the minimum conntribution return to player aff vault
453       players[_pID].aff = _eth.add(players[_pID].aff);
454     }
455   }
456 
457   function updateStageInfo(uint _pID, uint _keyAmount) private {
458     uint _stageL = groupPrizeStartAt.add(groupPrizeStageGap.mul(stageId - 1));
459     uint _stageH = groupPrizeStartAt.add(groupPrizeStageGap.mul(stageId));
460     if(totalKeys > _stageH) { // game has been pushed to next stage
461       stageId = (totalKeys.sub(groupPrizeStartAt)).div(groupPrizeStageGap) + 1;
462       _keyAmount = (totalKeys.sub(groupPrizeStartAt)) % groupPrizeStageGap;
463       stageInfo[stageId][_pID] = stageInfo[stageId][_pID].add(_keyAmount);
464     } else {
465       if(_keyAmount < totalKeys.sub(_stageL)) {
466         stageInfo[stageId][_pID] = stageInfo[stageId][_pID].add(_keyAmount);
467       } else {
468         _keyAmount = totalKeys.sub(_stageL);
469         stageInfo[stageId][_pID] = stageInfo[stageId][_pID].add(_keyAmount);
470       }
471     }
472   }
473 
474   function withdrawEarning(uint256 _amount) public {
475     address _addr = msg.sender;
476     uint256 _pID = addrXpId[_addr];
477     require(_pID != 0);  // player must exist
478 
479     uint _earning = getPlayerEarning(_pID);
480     uint _remainingBalance = _earning.sub(players[_pID].ethWithdraw);
481     if(_amount > 0) {
482       require(_amount <= _remainingBalance);
483     }else{
484       _amount = _remainingBalance;
485     }
486 
487 
488     _addr.transfer(_amount);  // transfer remaining balance to
489     players[_pID].ethWithdraw = players[_pID].ethWithdraw.add(_amount);
490   }
491 
492   function getPlayerEarning(uint256 _pID) view public returns (uint256) {
493     Player memory p = players[_pID];
494     uint _gain = totalCommPot.mul(p.hretKeys.add(p.mretKeys.mul(fixRet).div(fixRet+extraRet))).div(totalKeys);
495     uint _total = _gain.add(p.aff);
496     _total = getWinnerPrize(_pID).add(_total);
497     return _total;
498   }
499 
500   function getPlayerWithdrawEarning(uint _pid) public view returns(uint){
501     uint _earning = getPlayerEarning(_pid);
502     return _earning.sub(players[_pid].ethWithdraw);
503   }
504 
505   function getWinnerPrize(uint256 _pID) view public returns (uint256) {
506     uint _keys;
507     uint _pKeys;
508     if(now < endTime) {
509       return 0;
510     } else if(totalKeys > groupPrizeStartAt) { // keys in the winner stage share the group prize
511       _keys = totalKeys.sub(groupPrizeStartAt.add(groupPrizeStageGap.mul(stageId - 1)));
512       _pKeys = stageInfo[stageId][_pID];
513       return totalEther.mul(groupPrize).div(100).mul(_pKeys).div(_keys);
514     } else { // totalkeys does not meet the minimum group prize criteria, all keys share the group prize
515       Player memory p = players[_pID];
516       _pKeys = p.hretKeys.add(p.mretKeys).add(p.lretKeys);
517       return totalEther.mul(groupPrize).div(100).mul(_pKeys).div(totalKeys);
518     }
519   }
520 
521   function getWinningStageInfo() view public returns (uint256 _stageId, uint256 _keys, uint256 _amount) {
522     _amount = totalEther.mul(groupPrize).div(100);
523     if(totalKeys < groupPrizeStartAt) { // group prize is not activate yet
524       return (0, totalKeys, _amount);
525     } else {
526       _stageId = stageId;
527       _keys = totalKeys.sub(groupPrizeStartAt.add(groupPrizeStageGap.mul(stageId - 1)));
528       return (_stageId, _keys, _amount);
529     }
530   }
531 
532   function getPlayerStageKeys() view public returns (uint256 _stageId, uint _keys, uint _pKeys) {
533     uint _pID = addrXpId[msg.sender];
534     if(totalKeys < groupPrizeStartAt) {
535       Player memory p = players[_pID];
536       _pKeys = p.hretKeys.add(p.mretKeys).add(p.lretKeys);
537       return (0, totalKeys, _pKeys);
538     } else {
539       _stageId = stageId;
540       _keys = totalKeys.sub(groupPrizeStartAt.add(groupPrizeStageGap.mul(stageId - 1)));
541       _pKeys = stageInfo[_stageId][_pID];
542       return (_stageId, _keys, _pKeys);
543     }
544 
545   }
546 
547   function getTotalGamePot() view public returns (uint256) {
548     uint _gain = totalCommPot.mul(keysForGame).div(totalKeys);
549     uint _total = _gain.add(gamePot);
550     return _total;
551   }
552   
553 }