1 pragma solidity ^0.5.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     return a / b;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23     c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract EXCH {
30     function distribute(uint256 _amount) public returns (uint256);
31     function appreciateTokenPrice(uint256 _amount) public;
32 }
33 
34 contract TOKEN {
35     function totalSupply() external view returns (uint256);
36     function balanceOf(address account) external view returns (uint256);
37     function transfer(address recipient, uint256 amount) external returns (bool);
38     function allowance(address owner, address spender) external view returns (uint256);
39     function approve(address spender, uint256 amount) external returns (bool);
40     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
41     function stakeStart(uint256 newStakedHearts, uint256 newStakedDays) external;
42     function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam) external;
43     function stakeCount(address stakerAddr) external view returns (uint256);
44     function stakeLists(address owner, uint256 stakeIndex) external view returns (uint40, uint72, uint72, uint16, uint16, uint16, bool);
45     function currentDay() external view returns (uint256);
46 }
47 
48 contract Ownable {
49   address public owner;
50 
51   constructor() public {
52     owner = address(0x86d9344094297cf5a6c77c07476F40C2F9903CD8);
53   }
54 
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 }
60 
61 contract HMX is Ownable {
62     using SafeMath for uint256;
63 
64     uint ACTIVATION_TIME = 1585440000;
65 
66     modifier isActivated {
67         require(now >= ACTIVATION_TIME);
68 
69         if (now <= (ACTIVATION_TIME + 2 minutes)) {
70             require(tx.gasprice <= 0.2 szabo);
71         }
72         _;
73     }
74 
75     modifier onlyTokenHolders {
76         require(myTokens(true) > 0);
77         _;
78     }
79 
80     modifier onlyDivis {
81         require(myDividends(true) > 0);
82         _;
83     }
84 
85     modifier isStakeActivated {
86         require(stakeActivated == true);
87         _;
88     }
89 
90     event onDistribute(
91         address indexed customerAddress,
92         uint256 tokens
93     );
94 
95     event onTokenAppreciation(
96         uint256 tokenPrice,
97         uint256 timestamp
98     );
99 
100     event Transfer(
101         address indexed from,
102         address indexed to,
103         uint256 tokens
104     );
105 
106     event onTokenPurchase(
107         address indexed customerAddress,
108         uint256 incomingHEX,
109         uint256 tokensMinted,
110         address indexed referredBy,
111         uint256 timestamp
112     );
113 
114     event onTokenSell(
115         address indexed customerAddress,
116         uint256 tokensBurned,
117         uint256 hexEarned,
118         uint256 timestamp
119     );
120 
121     event onRoll(
122         address indexed customerAddress,
123         uint256 hexRolled,
124         uint256 tokensMinted
125     );
126 
127     event onWithdraw(
128         address indexed customerAddress,
129         uint256 hexWithdrawn
130     );
131 
132     event onStakeStart(
133         address indexed customerAddress,
134         uint256 uniqueID,
135         uint256 currentTokens,
136         uint256 timestamp
137     );
138 
139     event onStakeEnd(
140         address indexed customerAddress,
141         uint256 uniqueID,
142         uint256 returnAmount,
143         uint256 difference,
144         uint256 timestamp
145     );
146 
147     string public name = "HEXMAX";
148     string public symbol = "HEX4";
149     uint8 constant public decimals = 8;
150     uint256 constant private priceMagnitude = 1e8;
151     uint256 constant private divMagnitude = 2 ** 64;
152 
153     uint8 constant private appreciateFee = 2;
154     uint8 constant private buyInFee = 6;
155     uint8 constant private sellOutFee = 6;
156     uint8 constant private transferFee = 1;
157     uint8 constant private devFee = 1;
158     uint8 constant private hexTewFee = 1;
159     uint8 constant private hexRiseFee = 1;
160 
161     mapping(address => uint256) private tokenBalanceLedger;
162     mapping(address => uint256) private referralBalance;
163     mapping(address => int256) private payoutsTo;
164     mapping(address => uint256) public lockedHexBalanceLedger;
165 
166     struct Stats {
167        uint256 deposits;
168        uint256 withdrawals;
169        uint256 staked;
170        uint256 activeStakes;
171     }
172 
173     mapping(address => Stats) public playerStats;
174 
175     uint256 public referralRequirement = 100000e8;
176     uint256 public totalStakeBalance = 0;
177     uint256 public totalPlayer = 0;
178     uint256 public totalDonation = 0;
179     uint256 public totalTewFundReceived = 0;
180     uint256 public totalTewFundCollected = 0;
181     uint256 public totalRiseFundReceived = 0;
182     uint256 public totalRiseFundCollected = 0;
183 
184     uint256 private tokenSupply = 0;
185     uint256 private profitPerShare = 0;
186     uint256 private contractValue = 0;
187     uint256 private tokenPrice = 100000000;
188 
189     EXCH hextew;
190     EXCH hexrise;
191 
192     TOKEN erc20;
193 
194     struct StakeStore {
195       uint40 stakeID;
196       uint256 hexAmount;
197       uint72 stakeShares;
198       uint16 lockedDay;
199       uint16 stakedDays;
200       uint16 unlockedDay;
201       bool started;
202       bool ended;
203     }
204 
205     bool stakeActivated = true;
206     bool feedActivated = true;
207     mapping(address => mapping(uint256 => StakeStore)) public stakeLists;
208 
209     constructor() public {
210         hextew = EXCH(address(0xD495cC8C7c29c7fA3E027a5759561Ab68C363609));
211         hexrise = EXCH(address(0x8D5CA96e9984662625e6cbF490Da40c9D7270865));
212         erc20 = TOKEN(address(0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39));
213     }
214 
215     function() payable external {
216         revert();
217     }
218 
219     function checkAndTransferHEX(uint256 _amount) private {
220         require(erc20.transferFrom(msg.sender, address(this), _amount) == true, "transfer must succeed");
221     }
222 
223     function distribute(uint256 _amount) isActivated public {
224         require(_amount > 0, "must be a positive value");
225         checkAndTransferHEX(_amount);
226         totalDonation += _amount;
227         profitPerShare = SafeMath.add(profitPerShare, (_amount * divMagnitude) / tokenSupply);
228         emit onDistribute(msg.sender, _amount);
229     }
230 
231     function appreciateTokenPrice(uint256 _amount) isActivated public {
232         require(_amount > 0, "must be a positive value");
233         checkAndTransferHEX(_amount);
234         totalDonation += _amount;
235         contractValue = contractValue.add(_amount);
236 
237         if (tokenSupply > priceMagnitude) {
238             tokenPrice = (contractValue.mul(priceMagnitude)) / tokenSupply;
239         }
240 
241         emit onTokenAppreciation(tokenPrice, now);
242     }
243 
244     function payFund(bytes32 exchange) public {
245         if (exchange == "hextew") {
246           uint256 _hexToPay = totalTewFundCollected.sub(totalTewFundReceived);
247           require(_hexToPay > 0);
248           totalTewFundReceived = totalTewFundReceived.add(_hexToPay);
249           erc20.approve(address(0xD495cC8C7c29c7fA3E027a5759561Ab68C363609), _hexToPay);
250           hextew.distribute(_hexToPay);
251         } else if (exchange == "hexrise") {
252           uint256 _hexToPay = totalRiseFundCollected.sub(totalRiseFundReceived);
253           require(_hexToPay > 0);
254           totalRiseFundReceived = totalRiseFundReceived.add(_hexToPay);
255           erc20.approve(address(0x8D5CA96e9984662625e6cbF490Da40c9D7270865), _hexToPay);
256           hexrise.appreciateTokenPrice(_hexToPay);
257         }
258     }
259 
260     function roll() onlyDivis public {
261         address _customerAddress = msg.sender;
262         uint256 _dividends = myDividends(false);
263         payoutsTo[_customerAddress] +=  (int256) (_dividends * divMagnitude);
264         _dividends += referralBalance[_customerAddress];
265         referralBalance[_customerAddress] = 0;
266         uint256 _tokens = purchaseTokens(address(0), _customerAddress, _dividends);
267         emit onRoll(_customerAddress, _dividends, _tokens);
268     }
269 
270     function exit() external {
271         address _customerAddress = msg.sender;
272         uint256 _lockedToken = (lockedHexBalanceLedger[_customerAddress].mul(priceMagnitude)) / tokenPrice;
273         uint256 _tokens = tokenBalanceLedger[_customerAddress].sub(_lockedToken);
274         if (_tokens > 0) sell(_tokens);
275         withdraw();
276     }
277 
278     function withdraw() onlyDivis public {
279         address _customerAddress = msg.sender;
280         uint256 _dividends = myDividends(false);
281         payoutsTo[_customerAddress] += (int256) (_dividends * divMagnitude);
282         _dividends += referralBalance[_customerAddress];
283         referralBalance[_customerAddress] = 0;
284         erc20.transfer(_customerAddress, _dividends);
285         playerStats[_customerAddress].withdrawals += _dividends;
286         emit onWithdraw(_customerAddress, _dividends);
287     }
288 
289     function buy(address _referredBy, uint256 _amount) public returns (uint256) {
290         checkAndTransferHEX(_amount);
291         return purchaseTokens(_referredBy, msg.sender, _amount);
292     }
293 
294     function buyFor(address _referredBy, address _customerAddress, uint256 _amount) public returns (uint256) {
295         checkAndTransferHEX(_amount);
296         return purchaseTokens(_referredBy, _customerAddress, _amount);
297     }
298 
299     function _purchaseTokens(address _customerAddress, uint256 _incomingHEX, uint256 _dividends) private returns(uint256) {
300         uint256 _amountOfTokens = (_incomingHEX.mul(priceMagnitude)) / tokenPrice;
301         uint256 _fee = _dividends * divMagnitude;
302 
303         require(_amountOfTokens > 0 && _amountOfTokens.add(tokenSupply) > tokenSupply);
304 
305         if (tokenSupply > 0) {
306             tokenSupply = tokenSupply.add(_amountOfTokens);
307             profitPerShare += (_dividends * divMagnitude / tokenSupply);
308             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * divMagnitude / tokenSupply)));
309         } else {
310             tokenSupply = _amountOfTokens;
311         }
312 
313         tokenBalanceLedger[_customerAddress] =  tokenBalanceLedger[_customerAddress].add(_amountOfTokens);
314 
315         int256 _updatedPayouts = (int256) (profitPerShare * _amountOfTokens - _fee);
316         payoutsTo[_customerAddress] += _updatedPayouts;
317 
318         emit Transfer(address(0), _customerAddress, _amountOfTokens);
319 
320         return _amountOfTokens;
321     }
322 
323     function purchaseTokens(address _referredBy, address _customerAddress, uint256 _incomingHEX) private isActivated returns (uint256) {
324         if (playerStats[_customerAddress].deposits == 0) {
325             totalPlayer++;
326         }
327 
328         playerStats[_customerAddress].deposits += _incomingHEX;
329 
330         require(_incomingHEX > 0);
331 
332         uint256 _appreciateFee = _incomingHEX.mul(appreciateFee).div(100);
333         uint256 _dividendFee = feedActivated == true ? _incomingHEX.mul(buyInFee).div(100) : _incomingHEX.mul(buyInFee+1).div(100);
334         uint256 _devFee = _incomingHEX.mul(devFee).div(100);
335         uint256 _hexTewFee = feedActivated == true ? _incomingHEX.mul(hexTewFee).div(100) : 0;
336         uint256 _taxedHEX = _incomingHEX.sub(_appreciateFee).sub(_dividendFee).sub(_devFee).sub(_hexTewFee);
337 
338         _purchaseTokens(owner, _devFee, 0);
339         uint256 _amountOfTokens = _purchaseTokens(_customerAddress, _taxedHEX, _dividendFee);
340 
341         if (_referredBy != address(0) && _referredBy != _customerAddress && tokenBalanceLedger[_referredBy] >= referralRequirement) {
342             referralBalance[_referredBy] = referralBalance[_referredBy].add(_hexTewFee);
343         } else {
344             totalTewFundCollected = totalTewFundCollected.add(_hexTewFee);
345         }
346 
347         contractValue = contractValue.add(_incomingHEX.sub(_hexTewFee).sub(_dividendFee));
348 
349         if (tokenSupply > priceMagnitude) {
350             tokenPrice = (contractValue.mul(priceMagnitude)) / tokenSupply;
351         }
352 
353         if (hexToSendFund("hextew") >= 10000e8) {
354             payFund("hextew");
355         }
356 
357         emit onTokenPurchase(_customerAddress, _incomingHEX, _amountOfTokens, _referredBy, now);
358         emit onTokenAppreciation(tokenPrice, now);
359 
360         return _amountOfTokens;
361     }
362 
363     function sell(uint256 _amountOfTokens) isActivated onlyTokenHolders public {
364         address _customerAddress = msg.sender;
365         uint256 _lockedToken = (lockedHexBalanceLedger[_customerAddress].mul(priceMagnitude)) / tokenPrice;
366 
367         require(_amountOfTokens > 0 && _amountOfTokens <= tokenBalanceLedger[_customerAddress].sub(_lockedToken));
368 
369         uint256 _hex = _amountOfTokens.mul(tokenPrice).div(priceMagnitude);
370         uint256 _appreciateFee = _hex.mul(appreciateFee).div(100);
371         uint256 _dividendFee = feedActivated == true ? _hex.mul(sellOutFee).div(100) : _hex.mul(sellOutFee+1).div(100);
372         uint256 _devFee = _hex.mul(devFee).div(100);
373         uint256 _hexRiseFee = feedActivated == true ? _hex.mul(hexRiseFee).div(100) : 0;
374 
375         _purchaseTokens(owner, _devFee, 0);
376         totalRiseFundCollected = totalRiseFundCollected.add(_hexRiseFee);
377 
378         _hex = _hex.sub(_appreciateFee).sub(_dividendFee).sub(_devFee).sub(_hexRiseFee);
379 
380         tokenSupply = tokenSupply.sub(_amountOfTokens);
381         tokenBalanceLedger[_customerAddress] = tokenBalanceLedger[_customerAddress].sub(_amountOfTokens);
382 
383         int256 _updatedPayouts = (int256) (profitPerShare * _amountOfTokens + (_hex * divMagnitude));
384         payoutsTo[_customerAddress] -= _updatedPayouts;
385 
386         if (tokenSupply > 0) {
387             profitPerShare = SafeMath.add(profitPerShare, (_dividendFee * divMagnitude) / tokenSupply);
388         }
389 
390         contractValue = contractValue.sub(_hex.add(_hexRiseFee).add(_dividendFee));
391 
392         if (tokenSupply > priceMagnitude) {
393             tokenPrice = (contractValue.mul(priceMagnitude)) / tokenSupply;
394         }
395 
396         if (hexToSendFund("hexrise") >= 10000e8) {
397             payFund("hexrise");
398         }
399 
400         emit Transfer(_customerAddress, address(0), _amountOfTokens);
401         emit onTokenSell(_customerAddress, _amountOfTokens, _hex, now);
402         emit onTokenAppreciation(tokenPrice, now);
403     }
404 
405     function transfer(address _toAddress, uint256 _amountOfTokens) isActivated onlyTokenHolders external returns (bool) {
406         address _customerAddress = msg.sender;
407         uint256 _lockedToken = (lockedHexBalanceLedger[_customerAddress].mul(priceMagnitude)) / tokenPrice;
408 
409         require(_amountOfTokens > 0 && _amountOfTokens <= tokenBalanceLedger[_customerAddress].sub(_lockedToken));
410 
411         if (myDividends(true) > 0) {
412             withdraw();
413         }
414 
415         uint256 _tokenFee = _amountOfTokens.mul(transferFee).div(100);
416         uint256 _taxedTokens = _amountOfTokens.sub(_tokenFee);
417 
418         tokenBalanceLedger[_customerAddress] = tokenBalanceLedger[_customerAddress].sub(_amountOfTokens);
419         tokenBalanceLedger[_toAddress] = tokenBalanceLedger[_toAddress].add(_taxedTokens);
420 
421         payoutsTo[_customerAddress] -= (int256) (profitPerShare * _amountOfTokens);
422         payoutsTo[_toAddress] += (int256) (profitPerShare * _taxedTokens);
423 
424         tokenSupply = tokenSupply.sub(_tokenFee);
425 
426         if (tokenSupply > priceMagnitude)
427         {
428             tokenPrice = (contractValue.mul(priceMagnitude)) / tokenSupply;
429         }
430 
431         emit Transfer(_customerAddress, address(0), _tokenFee);
432         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
433         emit onTokenAppreciation(tokenPrice, now);
434 
435         return true;
436     }
437 
438     function stakeStart(uint256 _amount, uint256 _days) public isStakeActivated {
439         require(_amount <= 4722366482869645213695);
440         require(hexBalanceOfNoFee(msg.sender, true) >= _amount);
441 
442         erc20.stakeStart(_amount, _days); // revert or succeed
443 
444         uint256 _stakeIndex;
445         uint40 _stakeID;
446         uint72 _stakeShares;
447         uint16 _lockedDay;
448         uint16 _stakedDays;
449 
450         _stakeIndex = erc20.stakeCount(address(this));
451         _stakeIndex = SafeMath.sub(_stakeIndex, 1);
452 
453         (_stakeID,,_stakeShares,_lockedDay,_stakedDays,,) = erc20.stakeLists(address(this), _stakeIndex);
454 
455         uint256 _uniqueID =  uint256(keccak256(abi.encodePacked(_stakeID, _stakeShares))); // unique enough
456         require(stakeLists[msg.sender][_uniqueID].started == false); // still check for collision
457         stakeLists[msg.sender][_uniqueID].started = true;
458 
459         stakeLists[msg.sender][_uniqueID] = StakeStore(_stakeID, _amount, _stakeShares, _lockedDay, _stakedDays, uint16(0), true, false);
460 
461         totalStakeBalance = SafeMath.add(totalStakeBalance, _amount);
462 
463         playerStats[msg.sender].activeStakes += 1;
464         playerStats[msg.sender].staked += _amount;
465 
466         lockedHexBalanceLedger[msg.sender] = SafeMath.add(lockedHexBalanceLedger[msg.sender], _amount);
467 
468         emit onStakeStart(msg.sender, _uniqueID, calculateTokensReceived(_amount, false), now);
469     }
470 
471     function _stakeEnd(uint256 _stakeIndex, uint40 _stakeIdParam, uint256 _uniqueID) public view returns (uint16){
472         uint40 _stakeID;
473         uint72 _stakedHearts;
474         uint72 _stakeShares;
475         uint16 _lockedDay;
476         uint16 _stakedDays;
477         uint16 _unlockedDay;
478 
479         (_stakeID,_stakedHearts,_stakeShares,_lockedDay,_stakedDays,_unlockedDay,) = erc20.stakeLists(address(this), _stakeIndex);
480         require(stakeLists[msg.sender][_uniqueID].started == true && stakeLists[msg.sender][_uniqueID].ended == false);
481         require(stakeLists[msg.sender][_uniqueID].stakeID == _stakeIdParam && _stakeIdParam == _stakeID);
482         require(stakeLists[msg.sender][_uniqueID].hexAmount == uint256(_stakedHearts));
483         require(stakeLists[msg.sender][_uniqueID].stakeShares == _stakeShares);
484         require(stakeLists[msg.sender][_uniqueID].lockedDay == _lockedDay);
485         require(stakeLists[msg.sender][_uniqueID].stakedDays == _stakedDays);
486 
487         return _unlockedDay;
488     }
489 
490     function stakeEnd(uint256 _stakeIndex, uint40 _stakeIdParam, uint256 _uniqueID) public {
491         uint16 _unlockedDay = _stakeEnd(_stakeIndex, _stakeIdParam, _uniqueID);
492 
493         if (_unlockedDay == 0){
494             stakeLists[msg.sender][_uniqueID].unlockedDay = uint16(erc20.currentDay()); // no penalty/penalty/reward
495         } else {
496             stakeLists[msg.sender][_uniqueID].unlockedDay = _unlockedDay;
497         }
498 
499         uint256 _balance = erc20.balanceOf(address(this));
500 
501         erc20.stakeEnd(_stakeIndex, _stakeIdParam); // revert or 0 or less or equal or more hex returned.
502         stakeLists[msg.sender][_uniqueID].ended = true;
503 
504         uint256 _amount = SafeMath.sub(erc20.balanceOf(address(this)), _balance);
505         uint256 _stakedAmount = stakeLists[msg.sender][_uniqueID].hexAmount;
506         uint256 _difference;
507 
508         if (_amount <= _stakedAmount) {
509             _difference = SafeMath.sub(_stakedAmount, _amount);
510             contractValue = contractValue.sub(_difference);
511             _difference = (_difference.mul(priceMagnitude)) / tokenPrice;
512             tokenSupply = SafeMath.sub(tokenSupply, _difference);
513             tokenBalanceLedger[msg.sender] = SafeMath.sub(tokenBalanceLedger[msg.sender], _difference);
514             int256 _updatedPayouts = (int256) (profitPerShare * _difference);
515             payoutsTo[msg.sender] -= _updatedPayouts;
516             emit Transfer(msg.sender, address(0), _difference);
517         } else if (_amount > _stakedAmount) {
518             _difference = SafeMath.sub(_amount, _stakedAmount);
519             _difference = purchaseTokens(address(0), msg.sender, _difference);
520         }
521 
522         totalStakeBalance = SafeMath.sub(totalStakeBalance, _stakedAmount);
523         playerStats[msg.sender].activeStakes -= 1;
524 
525         lockedHexBalanceLedger[msg.sender] = SafeMath.sub(lockedHexBalanceLedger[msg.sender], _stakedAmount);
526 
527         emit onStakeEnd(msg.sender, _uniqueID, _amount, _difference, now);
528     }
529 
530     function setName(string memory _name) onlyOwner public
531     {
532         name = _name;
533     }
534 
535     function setSymbol(string memory _symbol) onlyOwner public
536     {
537         symbol = _symbol;
538     }
539 
540     function setHexStaking(bool _stakeActivated) onlyOwner public
541     {
542         stakeActivated = _stakeActivated;
543     }
544 
545     function setFeeding(bool _feedActivated) onlyOwner public
546     {
547         feedActivated = _feedActivated;
548     }
549 
550     function totalHexBalance() public view returns (uint256) {
551         return erc20.balanceOf(address(this));
552     }
553 
554     function totalSupply() public view returns(uint256) {
555         return tokenSupply;
556     }
557 
558     function myTokens(bool _stakeable) public view returns (uint256) {
559         address _customerAddress = msg.sender;
560         return balanceOf(_customerAddress, _stakeable);
561     }
562 
563     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
564         address _customerAddress = msg.sender;
565         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance[_customerAddress] : dividendsOf(_customerAddress) ;
566     }
567 
568     function balanceOf(address _customerAddress, bool _stakeable) public view returns (uint256) {
569         if (_stakeable == false) {
570             return tokenBalanceLedger[_customerAddress];
571         }
572         else if (_stakeable == true) {
573             uint256 _lockedToken = (lockedHexBalanceLedger[_customerAddress].mul(priceMagnitude)) / tokenPrice;
574             return (tokenBalanceLedger[_customerAddress].sub(_lockedToken));
575         }
576     }
577 
578     function dividendsOf(address _customerAddress) public view returns (uint256) {
579         return (uint256) ((int256) (profitPerShare * tokenBalanceLedger[_customerAddress]) - payoutsTo[_customerAddress]) / divMagnitude;
580     }
581 
582     function sellPrice(bool _includeFees) public view returns (uint256) {
583         uint256 _appreciateFee = 0;
584         uint256 _dividendFee = 0;
585         uint256 _devFee = 0;
586         uint256 _hexRiseFee = 0;
587 
588         if (_includeFees) {
589             _appreciateFee = tokenPrice.mul(appreciateFee).div(100);
590             _dividendFee = feedActivated == true ? tokenPrice.mul(sellOutFee).div(100) : tokenPrice.mul(sellOutFee+1).div(100);
591             _devFee = tokenPrice.mul(devFee).div(100);
592             _hexRiseFee = feedActivated == true ? tokenPrice.mul(hexRiseFee).div(100) : 0;
593         }
594 
595         return (tokenPrice.sub(_appreciateFee).sub(_dividendFee).sub(_devFee).sub(_hexRiseFee));
596     }
597 
598     function buyPrice(bool _includeFees) public view returns(uint256) {
599         uint256 _appreciateFee = 0;
600         uint256 _dividendFee = 0;
601         uint256 _devFee = 0;
602         uint256 _hexTewFee = 0;
603 
604         if (_includeFees) {
605             _appreciateFee = tokenPrice.mul(appreciateFee).div(100);
606             _dividendFee = feedActivated == true ? tokenPrice.mul(buyInFee).div(100) : tokenPrice.mul(buyInFee+1).div(100);
607             _devFee = tokenPrice.mul(devFee).div(100);
608             _hexTewFee = feedActivated == true ? tokenPrice.mul(hexTewFee).div(100) : 0;
609         }
610 
611         return (tokenPrice.add(_appreciateFee).add(_dividendFee).add(_devFee).add(_hexTewFee));
612     }
613 
614     function calculateTokensReceived(uint256 _hexToSpend, bool _includeFees) public view returns (uint256) {
615         uint256 _appreciateFee = 0;
616         uint256 _dividendFee = 0;
617         uint256 _devFee = 0;
618         uint256 _hexTewFee = 0;
619 
620         if (_includeFees) {
621             _appreciateFee = _hexToSpend.mul(appreciateFee).div(100);
622             _dividendFee = feedActivated == true ? _hexToSpend.mul(buyInFee).div(100) : _hexToSpend.mul(buyInFee+1).div(100);
623             _devFee = _hexToSpend.mul(devFee).div(100);
624             _hexTewFee = feedActivated == true ? _hexToSpend.mul(hexTewFee).div(100) : 0;
625         }
626 
627         uint256 _taxedHEX = _hexToSpend.sub(_appreciateFee).sub(_dividendFee).sub(_devFee).sub(_hexTewFee);
628         uint256 _amountOfTokens = (_taxedHEX.mul(priceMagnitude)) / tokenPrice;
629 
630         return _amountOfTokens;
631     }
632 
633     function hexBalanceOf(address _customerAddress, bool _stakeable) public view returns(uint256) {
634         uint256 _price = sellPrice(true);
635         uint256 _balance = balanceOf(_customerAddress, _stakeable);
636         uint256 _value = (_balance.mul(_price)) / priceMagnitude;
637 
638         return _value;
639     }
640 
641     function hexBalanceOfNoFee(address _customerAddress, bool _stakeable) public view returns(uint256) {
642         uint256 _price = sellPrice(false);
643         uint256 _balance = balanceOf(_customerAddress, _stakeable);
644         uint256 _value = (_balance.mul(_price)) / priceMagnitude;
645 
646         return _value;
647     }
648 
649     function hexToSendFund(bytes32 exchange) public view returns(uint256) {
650         if (exchange == "hextew") {
651           return totalTewFundCollected.sub(totalTewFundReceived);
652         } else if (exchange == "hexrise") {
653           return totalRiseFundCollected.sub(totalRiseFundReceived);
654         }
655     }
656 }