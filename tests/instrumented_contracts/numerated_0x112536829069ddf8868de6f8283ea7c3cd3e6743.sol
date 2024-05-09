1 pragma solidity ^0.5.13;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5       if (a == 0) {
6         return 0;
7       }
8       c = a * b;
9       assert(c / a == b);
10       return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14       return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18       assert(b <= a);
19       return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23       c = a + b;
24       assert(c >= a);
25       return c;
26     }
27 }
28 
29 contract DIST {
30     function accounting() public;
31 }
32 
33 contract EXCH {
34     function appreciateTokenPrice(uint256 _amount) public;
35 }
36 
37 contract TOKEN {
38     function totalSupply() external view returns (uint256);
39     function balanceOf(address account) external view returns (uint256);
40     function transfer(address recipient, uint256 amount) external returns (bool);
41     function allowance(address owner, address spender) external view returns (uint256);
42     function approve(address spender, uint256 amount) external returns (bool);
43     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
44     function stakeStart(uint256 newStakedHearts, uint256 newStakedDays) external;
45     function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam) external;
46     function stakeCount(address stakerAddr) external view returns (uint256);
47     function stakeLists(address owner, uint256 stakeIndex) external view returns (uint40, uint72, uint72, uint16, uint16, uint16, bool);
48     function currentDay() external view returns (uint256);
49 }
50 
51 contract Ownable {
52     address public owner;
53 
54     constructor() public {
55       owner = address(0x583A013373A9e91fB64CBFFA999668bEdfdcf87C);
56     }
57 
58     modifier onlyOwner() {
59       require(msg.sender == owner);
60       _;
61     }
62 }
63 
64 contract HTI is Ownable {
65     using SafeMath for uint256;
66 
67     uint256 ACTIVATION_TIME = 1590274800;
68 
69     modifier isActivated {
70         require(now >= ACTIVATION_TIME);
71 
72         if (now <= (ACTIVATION_TIME + 2 minutes)) {
73             require(tx.gasprice <= 0.2 szabo);
74         }
75         _;
76     }
77 
78     modifier onlyCustodian() {
79         require(msg.sender == custodianAddress);
80         _;
81     }
82 
83     modifier hasDripped {
84         if (dividendPool > 0) {
85           uint256 secondsPassed = SafeMath.sub(now, lastDripTime);
86           uint256 dividends = secondsPassed.mul(dividendPool).div(dailyRate);
87 
88           if (dividends > dividendPool) {
89             dividends = dividendPool;
90           }
91 
92           profitPerShare = SafeMath.add(profitPerShare, (dividends * divMagnitude) / tokenSupply);
93           dividendPool = dividendPool.sub(dividends);
94           lastDripTime = now;
95         }
96 
97         if (hexToSendFund("hexmax") >= 10000e8) {
98             payFund("hexmax");
99         }
100 
101         if (hexToSendFund("stableth") >= 10000e8) {
102             payFund("stableth");
103         }
104         _;
105     }
106 
107     modifier onlyTokenHolders {
108         require(myTokens(true) > 0);
109         _;
110     }
111 
112     modifier onlyDivis {
113         require(myDividends(true) > 0);
114         _;
115     }
116 
117     modifier isStakeActivated {
118         require(stakeActivated == true);
119         _;
120     }
121 
122     event onDonation(
123         address indexed customerAddress,
124         uint256 tokens
125     );
126 
127     event Transfer(
128         address indexed from,
129         address indexed to,
130         uint256 tokens
131     );
132 
133     event onTokenPurchase(
134         address indexed customerAddress,
135         uint256 incomingHEX,
136         uint256 tokensMinted,
137         address indexed referredBy,
138         uint256 timestamp
139     );
140 
141     event onTokenSell(
142         address indexed customerAddress,
143         uint256 tokensBurned,
144         uint256 hexEarned,
145         uint256 timestamp
146     );
147 
148     event onRoll(
149         address indexed customerAddress,
150         uint256 hexRolled,
151         uint256 tokensMinted
152     );
153 
154     event onWithdraw(
155         address indexed customerAddress,
156         uint256 hexWithdrawn
157     );
158 
159     event onStakeStart(
160         address indexed customerAddress,
161         uint256 uniqueID,
162         uint256 timestamp
163     );
164 
165     event onStakeEnd(
166         address indexed customerAddress,
167         uint256 uniqueID,
168         uint256 returnAmount,
169         uint256 timestamp
170     );
171 
172     string public name = "Infinihex";
173     string public symbol = "HEX5";
174     uint8 constant public decimals = 8;
175     uint256 constant private divMagnitude = 2 ** 64;
176 
177     uint8 public percentage1 = 2;
178     uint8 public percentage2 = 2;
179     uint32 public dailyRate = 4320000;
180     uint8 constant private buyInFee = 40;
181     uint8 constant private rewardFee = 5;
182     uint8 constant private referralFee = 1;
183     uint8 constant private devFee = 1;
184     uint8 constant private hexMaxFee = 1;
185     uint8 constant private stableETHFee = 2;
186     uint8 constant private sellOutFee = 9;
187     uint8 constant private transferFee = 1;
188 
189     mapping(address => uint256) private tokenBalanceLedger;
190     mapping(address => uint256) public lockedTokenBalanceLedger;
191     mapping(address => uint256) private referralBalance;
192     mapping(address => int256) private payoutsTo;
193 
194     struct Stats {
195        uint256 deposits;
196        uint256 withdrawals;
197        uint256 staked;
198        uint256 activeStakes;
199     }
200 
201     mapping(address => Stats) public playerStats;
202 
203     uint256 public dividendPool = 0;
204     uint256 public lastDripTime = ACTIVATION_TIME;
205     uint256 public referralRequirement = 1000e8;
206     uint256 public totalStakeBalance = 0;
207     uint256 public totalPlayer = 0;
208     uint256 public totalDonation = 0;
209     uint256 public totalStableFundReceived = 0;
210     uint256 public totalStableFundCollected = 0;
211     uint256 public totalMaxFundReceived = 0;
212     uint256 public totalMaxFundCollected = 0;
213 
214     uint256 private tokenSupply = 0;
215     uint256 private profitPerShare = 0;
216 
217     address public uniswapAddress;
218     address public approvedAddress1;
219     address public approvedAddress2;
220     address public distributionAddress;
221     address public custodianAddress;
222 
223     EXCH hexmax;
224     DIST stablethdist;
225 
226     TOKEN erc20;
227 
228     struct StakeStore {
229       uint40 stakeID;
230       uint256 hexAmount;
231       uint72 stakeShares;
232       uint16 lockedDay;
233       uint16 stakedDays;
234       uint16 unlockedDay;
235       bool started;
236       bool ended;
237     }
238 
239     bool stakeActivated = true;
240     bool feedActivated = true;
241     mapping(address => mapping(uint256 => StakeStore)) public stakeLists;
242 
243     constructor() public {
244         custodianAddress = address(0x24B23bB643082026227e945C7833B81426057b10);
245         hexmax = EXCH(address(0xd52dca990CFC3760e0Cb0A60D96BE0da43fEbf19));
246         uniswapAddress = address(0x05cDe89cCfa0adA8C88D5A23caaa79Ef129E7883);
247         distributionAddress = address(0x699C01b92f2b036A1879416fC1977f60153A1729);
248         stablethdist = DIST(distributionAddress);
249         erc20 = TOKEN(address(0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39));
250     }
251 
252     function() payable external {
253         revert();
254     }
255 
256     function checkAndTransferHEX(uint256 _amount) private {
257         require(erc20.transferFrom(msg.sender, address(this), _amount) == true, "transfer must succeed");
258     }
259 
260     function distribute(uint256 _amount) isActivated public {
261         require(_amount > 0, "must be a positive value");
262         checkAndTransferHEX(_amount);
263         totalDonation += _amount;
264         profitPerShare = SafeMath.add(profitPerShare, (_amount * divMagnitude) / tokenSupply);
265         emit onDonation(msg.sender, _amount);
266     }
267 
268     function distributePool(uint256 _amount) public {
269         require(_amount > 0 && tokenSupply > 0, "must be a positive value and have supply");
270         checkAndTransferHEX(_amount);
271         totalDonation += _amount;
272         dividendPool = dividendPool.add(_amount);
273         emit onDonation(msg.sender, _amount);
274     }
275 
276     function payFund(bytes32 exchange) public {
277         if (exchange == "hexmax") {
278           uint256 _hexToPay = totalMaxFundCollected.sub(totalMaxFundReceived);
279           require(_hexToPay > 0);
280           totalMaxFundReceived = totalMaxFundReceived.add(_hexToPay);
281           erc20.approve(address(0xd52dca990CFC3760e0Cb0A60D96BE0da43fEbf19), _hexToPay);
282           hexmax.appreciateTokenPrice(_hexToPay);
283         } else if (exchange == "stableth") {
284           uint256 _hexToPay = totalStableFundCollected.sub(totalStableFundReceived);
285           require(_hexToPay > 0);
286           totalStableFundReceived = totalStableFundReceived.add(_hexToPay);
287 
288           if (feedActivated && uniswapAddress.balance >= 500e18) {
289             erc20.transfer(distributionAddress, _hexToPay);
290             uint256 _balance = erc20.balanceOf(distributionAddress);
291 
292             if (_balance >= 10000e8) {
293               stablethdist.accounting();
294             }
295           } else {
296             profitPerShare = SafeMath.add(profitPerShare, (_hexToPay * divMagnitude) / tokenSupply);
297           }
298         }
299     }
300 
301     function roll() hasDripped onlyDivis public {
302         address _customerAddress = msg.sender;
303         uint256 _dividends = myDividends(false);
304         payoutsTo[_customerAddress] +=  (int256) (_dividends * divMagnitude);
305         _dividends += referralBalance[_customerAddress];
306         referralBalance[_customerAddress] = 0;
307         uint256 _tokens = purchaseTokens(address(0), _customerAddress, _dividends);
308         emit onRoll(_customerAddress, _dividends, _tokens);
309     }
310 
311     function withdraw() hasDripped onlyDivis public {
312         address _customerAddress = msg.sender;
313         uint256 _dividends = myDividends(false);
314         payoutsTo[_customerAddress] += (int256) (_dividends * divMagnitude);
315         _dividends += referralBalance[_customerAddress];
316         referralBalance[_customerAddress] = 0;
317         erc20.transfer(_customerAddress, _dividends);
318         playerStats[_customerAddress].withdrawals += _dividends;
319         emit onWithdraw(_customerAddress, _dividends);
320     }
321 
322     function buy(address _referredBy, uint256 _amount) hasDripped public returns (uint256) {
323         checkAndTransferHEX(_amount);
324         return purchaseTokens(_referredBy, msg.sender, _amount);
325     }
326 
327     function buyFor(address _referredBy, address _customerAddress, uint256 _amount) hasDripped public returns (uint256) {
328         checkAndTransferHEX(_amount);
329         return purchaseTokens(_referredBy, _customerAddress, _amount);
330     }
331 
332     function _purchaseTokens(address _customerAddress, uint256 _incomingHEX, uint256 _rewards) private returns(uint256) {
333         uint256 _amountOfTokens = _incomingHEX;
334         uint256 _fee = _rewards * divMagnitude;
335 
336         require(_amountOfTokens > 0 && _amountOfTokens.add(tokenSupply) > tokenSupply);
337 
338         if (tokenSupply > 0) {
339             tokenSupply = tokenSupply.add(_amountOfTokens);
340             profitPerShare += (_rewards * divMagnitude / tokenSupply);
341             _fee = _fee - (_fee - (_amountOfTokens * (_rewards * divMagnitude / tokenSupply)));
342         } else {
343             tokenSupply = _amountOfTokens;
344         }
345 
346         tokenBalanceLedger[_customerAddress] =  tokenBalanceLedger[_customerAddress].add(_amountOfTokens);
347 
348         int256 _updatedPayouts = (int256) (profitPerShare * _amountOfTokens - _fee);
349         payoutsTo[_customerAddress] += _updatedPayouts;
350 
351         emit Transfer(address(0), _customerAddress, _amountOfTokens);
352 
353         return _amountOfTokens;
354     }
355 
356     function purchaseTokens(address _referredBy, address _customerAddress, uint256 _incomingHEX) isActivated private returns (uint256) {
357         if (playerStats[_customerAddress].deposits == 0) {
358             totalPlayer++;
359         }
360 
361         playerStats[_customerAddress].deposits += _incomingHEX;
362 
363         require(_incomingHEX > 0);
364 
365         uint256 _dividendFee = _incomingHEX.mul(buyInFee).div(100);
366         uint256 _rewardFee = _incomingHEX.mul(rewardFee).div(100);
367         uint256 _referralBonus = _incomingHEX.mul(referralFee).div(100);
368         uint256 _devFee = _incomingHEX.mul(devFee).div(100);
369         uint256 _hexMaxFee = _incomingHEX.mul(hexMaxFee).div(100);
370         uint256 _stableETHFee = _incomingHEX.mul(stableETHFee).div(100);
371 
372         uint256 _entryFee = _incomingHEX.mul(50).div(100);
373         uint256 _taxedHEX = _incomingHEX.sub(_entryFee);
374 
375         _purchaseTokens(owner, _devFee, 0);
376 
377         if (_referredBy != address(0) && _referredBy != _customerAddress && tokenBalanceLedger[_referredBy] >= referralRequirement) {
378             referralBalance[_referredBy] = referralBalance[_referredBy].add(_referralBonus);
379         } else {
380             _rewardFee = _rewardFee.add(_referralBonus);
381         }
382 
383         uint256 _amountOfTokens = _purchaseTokens(_customerAddress, _taxedHEX, _rewardFee);
384 
385         dividendPool = dividendPool.add(_dividendFee);
386         totalMaxFundCollected = totalMaxFundCollected.add(_hexMaxFee);
387         totalStableFundCollected = totalStableFundCollected.add(_stableETHFee);
388 
389         emit onTokenPurchase(_customerAddress, _incomingHEX, _amountOfTokens, _referredBy, now);
390 
391         return _amountOfTokens;
392     }
393 
394     function sell(uint256 _amountOfTokens) isActivated hasDripped onlyTokenHolders public {
395         address _customerAddress = msg.sender;
396         require(_amountOfTokens > 0 && _amountOfTokens <= tokenBalanceLedger[_customerAddress].sub(lockedTokenBalanceLedger[_customerAddress]));
397 
398         uint256 _dividendFee = _amountOfTokens.mul(sellOutFee).div(100);
399         uint256 _devFee = _amountOfTokens.mul(devFee).div(100);
400         uint256 _taxedHEX = _amountOfTokens.sub(_dividendFee).sub(_devFee);
401 
402         _purchaseTokens(owner, _devFee, 0);
403 
404         tokenSupply = tokenSupply.sub(_amountOfTokens);
405         tokenBalanceLedger[_customerAddress] = tokenBalanceLedger[_customerAddress].sub(_amountOfTokens);
406 
407         int256 _updatedPayouts = (int256) (profitPerShare * _amountOfTokens + (_taxedHEX * divMagnitude));
408         payoutsTo[_customerAddress] -= _updatedPayouts;
409 
410         dividendPool = dividendPool.add(_dividendFee);
411 
412         emit Transfer(_customerAddress, address(0), _amountOfTokens);
413         emit onTokenSell(_customerAddress, _amountOfTokens, _taxedHEX, now);
414     }
415 
416     function transfer(address _toAddress, uint256 _amountOfTokens) isActivated hasDripped onlyTokenHolders external returns (bool) {
417         address _customerAddress = msg.sender;
418         require(_amountOfTokens > 0 && _amountOfTokens <= tokenBalanceLedger[_customerAddress].sub(lockedTokenBalanceLedger[_customerAddress]));
419 
420         if (myDividends(true) > 0) {
421             withdraw();
422         }
423 
424         uint256 _tokenFee = _amountOfTokens.mul(transferFee).div(100);
425         uint256 _taxedTokens = _amountOfTokens.sub(_tokenFee);
426 
427         tokenBalanceLedger[_customerAddress] = tokenBalanceLedger[_customerAddress].sub(_amountOfTokens);
428         tokenBalanceLedger[_toAddress] = tokenBalanceLedger[_toAddress].add(_taxedTokens);
429         tokenBalanceLedger[owner] = tokenBalanceLedger[owner].add(_tokenFee);
430 
431         payoutsTo[_customerAddress] -= (int256) (profitPerShare * _amountOfTokens);
432         payoutsTo[_toAddress] += (int256) (profitPerShare * _taxedTokens);
433         payoutsTo[owner] += (int256) (profitPerShare * _tokenFee);
434 
435         emit Transfer(_customerAddress, owner, _tokenFee);
436         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
437 
438         return true;
439     }
440 
441     function stakeStart(uint256 _amount, uint256 _days) public isStakeActivated {
442         require(_amount <= 4722366482869645213695);
443         require(balanceOf(msg.sender, true) >= _amount);
444 
445         erc20.stakeStart(_amount, _days); // revert or succeed
446 
447         uint256 _stakeIndex;
448         uint40 _stakeID;
449         uint72 _stakeShares;
450         uint16 _lockedDay;
451         uint16 _stakedDays;
452 
453         _stakeIndex = erc20.stakeCount(address(this));
454         _stakeIndex = SafeMath.sub(_stakeIndex, 1);
455 
456         (_stakeID,,_stakeShares,_lockedDay,_stakedDays,,) = erc20.stakeLists(address(this), _stakeIndex);
457 
458         uint256 _uniqueID =  uint256(keccak256(abi.encodePacked(_stakeID, _stakeShares))); // unique enough
459         require(stakeLists[msg.sender][_uniqueID].started == false); // still check for collision
460         stakeLists[msg.sender][_uniqueID].started = true;
461 
462         stakeLists[msg.sender][_uniqueID] = StakeStore(_stakeID, _amount, _stakeShares, _lockedDay, _stakedDays, uint16(0), true, false);
463 
464         totalStakeBalance = SafeMath.add(totalStakeBalance, _amount);
465 
466         playerStats[msg.sender].activeStakes += 1;
467         playerStats[msg.sender].staked += _amount;
468 
469         lockedTokenBalanceLedger[msg.sender] = SafeMath.add(lockedTokenBalanceLedger[msg.sender], _amount);
470 
471         emit onStakeStart(msg.sender, _uniqueID, now);
472     }
473 
474     function _stakeEnd(uint256 _stakeIndex, uint40 _stakeIdParam, uint256 _uniqueID) private view returns (uint16){
475         uint40 _stakeID;
476         uint72 _stakedHearts;
477         uint72 _stakeShares;
478         uint16 _lockedDay;
479         uint16 _stakedDays;
480         uint16 _unlockedDay;
481 
482         (_stakeID,_stakedHearts,_stakeShares,_lockedDay,_stakedDays,_unlockedDay,) = erc20.stakeLists(address(this), _stakeIndex);
483         require(stakeLists[msg.sender][_uniqueID].started == true && stakeLists[msg.sender][_uniqueID].ended == false);
484         require(stakeLists[msg.sender][_uniqueID].stakeID == _stakeIdParam && _stakeIdParam == _stakeID);
485         require(stakeLists[msg.sender][_uniqueID].hexAmount == uint256(_stakedHearts));
486         require(stakeLists[msg.sender][_uniqueID].stakeShares == _stakeShares);
487         require(stakeLists[msg.sender][_uniqueID].lockedDay == _lockedDay);
488         require(stakeLists[msg.sender][_uniqueID].stakedDays == _stakedDays);
489 
490         return _unlockedDay;
491     }
492 
493     function stakeEnd(uint256 _stakeIndex, uint40 _stakeIdParam, uint256 _uniqueID) hasDripped public {
494         uint16 _unlockedDay = _stakeEnd(_stakeIndex, _stakeIdParam, _uniqueID);
495 
496         if (_unlockedDay == 0){
497           stakeLists[msg.sender][_uniqueID].unlockedDay = uint16(erc20.currentDay()); // no penalty/penalty/reward
498         } else {
499           stakeLists[msg.sender][_uniqueID].unlockedDay = _unlockedDay;
500         }
501 
502         uint256 _balance = erc20.balanceOf(address(this));
503 
504         erc20.stakeEnd(_stakeIndex, _stakeIdParam); // revert or 0 or less or equal or more hex returned.
505         stakeLists[msg.sender][_uniqueID].ended = true;
506 
507         uint256 _amount = SafeMath.sub(erc20.balanceOf(address(this)), _balance);
508         uint256 _stakedAmount = stakeLists[msg.sender][_uniqueID].hexAmount;
509         uint256 _difference;
510 
511         if (_amount <= _stakedAmount) {
512           _difference = SafeMath.sub(_stakedAmount, _amount);
513           tokenSupply = SafeMath.sub(tokenSupply, _difference);
514           tokenBalanceLedger[msg.sender] = SafeMath.sub(tokenBalanceLedger[msg.sender], _difference);
515           int256 _updatedPayouts = (int256) (profitPerShare * _difference);
516           payoutsTo[msg.sender] -= _updatedPayouts;
517           emit Transfer(msg.sender, address(0), _difference);
518         } else if (_amount > _stakedAmount) {
519           _difference = SafeMath.sub(_amount, _stakedAmount);
520           _difference = purchaseTokens(address(0), msg.sender, _difference);
521         }
522 
523         totalStakeBalance = SafeMath.sub(totalStakeBalance, _stakedAmount);
524         playerStats[msg.sender].activeStakes -= 1;
525 
526         lockedTokenBalanceLedger[msg.sender] = SafeMath.sub(lockedTokenBalanceLedger[msg.sender], _stakedAmount);
527 
528         emit onStakeEnd(msg.sender, _uniqueID, _amount, now);
529     }
530 
531     function setName(string memory _name) onlyOwner public
532     {
533         name = _name;
534     }
535 
536     function setSymbol(string memory _symbol) onlyOwner public
537     {
538         symbol = _symbol;
539     }
540 
541     function setHexStaking(bool _stakeActivated) onlyOwner public
542     {
543         stakeActivated = _stakeActivated;
544     }
545 
546     function setFeeding(bool _feedActivated) onlyOwner public
547     {
548         feedActivated = _feedActivated;
549     }
550 
551     function setUniswapAddress(address _proposedAddress) onlyOwner public
552     {
553        uniswapAddress = _proposedAddress;
554     }
555 
556     function approveAddress1(address _proposedAddress) onlyOwner public
557     {
558        approvedAddress1 = _proposedAddress;
559     }
560 
561     function approveAddress2(address _proposedAddress) onlyCustodian public
562     {
563        approvedAddress2 = _proposedAddress;
564     }
565 
566     function setDistributionAddress() public
567     {
568         require(approvedAddress1 != address(0) && approvedAddress1 == approvedAddress2);
569         distributionAddress = approvedAddress1;
570         stablethdist = DIST(approvedAddress1);
571     }
572 
573     function approveDrip1(uint8 _percentage) onlyOwner public
574     {
575         require(_percentage > 1 && _percentage < 6);
576         percentage1 = _percentage;
577     }
578 
579     function approveDrip2(uint8 _percentage) onlyCustodian public
580     {
581         require(_percentage > 1 && _percentage < 6);
582         percentage2 = _percentage;
583     }
584 
585     function setDripPercentage() public
586     {
587         require(percentage1 == percentage2);
588         dailyRate = 86400 / percentage1 * 100;
589     }
590 
591     function totalHexBalance() public view returns (uint256) {
592         return erc20.balanceOf(address(this));
593     }
594 
595     function totalSupply() public view returns(uint256) {
596         return tokenSupply;
597     }
598 
599     function myTokens(bool _stakeable) public view returns (uint256) {
600         address _customerAddress = msg.sender;
601         return balanceOf(_customerAddress, _stakeable);
602     }
603 
604     function myEstimateDividends(bool _includeReferralBonus, bool _dayEstimate) public view returns (uint256) {
605         address _customerAddress = msg.sender;
606         return _includeReferralBonus ? estimateDividendsOf(_customerAddress, _dayEstimate) + referralBalance[_customerAddress] : estimateDividendsOf(_customerAddress, _dayEstimate) ;
607     }
608 
609     function estimateDividendsOf(address _customerAddress, bool _dayEstimate) public view returns (uint256) {
610         uint256 _profitPerShare = profitPerShare;
611 
612         if (dividendPool > 0) {
613           uint256 secondsPassed = 0;
614 
615           if (_dayEstimate == true){
616             secondsPassed = 86400;
617           } else {
618             secondsPassed = SafeMath.sub(now, lastDripTime);
619           }
620 
621           uint256 dividends = secondsPassed.mul(dividendPool).div(dailyRate);
622 
623           if (dividends > dividendPool) {
624             dividends = dividendPool;
625           }
626 
627           _profitPerShare = SafeMath.add(_profitPerShare, (dividends * divMagnitude) / tokenSupply);
628         }
629 
630         return (uint256) ((int256) (_profitPerShare * tokenBalanceLedger[_customerAddress]) - payoutsTo[_customerAddress]) / divMagnitude;
631     }
632 
633     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
634         address _customerAddress = msg.sender;
635         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance[_customerAddress] : dividendsOf(_customerAddress) ;
636     }
637 
638     function dividendsOf(address _customerAddress) public view returns (uint256) {
639         return (uint256) ((int256) (profitPerShare * tokenBalanceLedger[_customerAddress]) - payoutsTo[_customerAddress]) / divMagnitude;
640     }
641 
642     function balanceOf(address _customerAddress, bool _stakeable) public view returns (uint256) {
643         if (_stakeable == false) {
644             return tokenBalanceLedger[_customerAddress];
645         }
646         else if (_stakeable == true) {
647             return (tokenBalanceLedger[_customerAddress].sub(lockedTokenBalanceLedger[_customerAddress]));
648         }
649     }
650 
651     function sellPrice() public view returns (uint256) {
652         uint256 _hex = 1e8;
653         uint256 _dividendFee = _hex.mul(sellOutFee).div(100);
654         uint256 _devFee = _hex.mul(devFee).div(100);
655 
656         return (_hex.sub(_dividendFee).sub(_devFee));
657     }
658 
659     function buyPrice() public view returns(uint256) {
660         uint256 _hex = 1e8;
661         uint256 _entryFee = _hex.mul(50).div(100);
662         return (_hex.add(_entryFee));
663     }
664 
665     function calculateTokensReceived(uint256 _tronToSpend) public view returns (uint256) {
666         uint256 _entryFee = _tronToSpend.mul(50).div(100);
667         uint256 _amountOfTokens = _tronToSpend.sub(_entryFee);
668 
669         return _amountOfTokens;
670     }
671 
672     function calculateHexReceived(uint256 _tokensToSell) public view returns (uint256) {
673         require(_tokensToSell <= tokenSupply);
674         uint256 _exitFee = _tokensToSell.mul(10).div(100);
675         uint256 _taxedHEX = _tokensToSell.sub(_exitFee);
676 
677         return _taxedHEX;
678     }
679 
680     function hexToSendFund(bytes32 exchange) public view returns(uint256) {
681         if (exchange == "hexmax") {
682           return totalMaxFundCollected.sub(totalMaxFundReceived);
683         } else if (exchange == "stableth") {
684           return totalStableFundCollected.sub(totalStableFundReceived);
685         }
686     }
687 }