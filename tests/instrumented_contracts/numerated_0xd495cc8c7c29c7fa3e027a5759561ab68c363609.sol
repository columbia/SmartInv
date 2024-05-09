1 pragma solidity ^0.4.26;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29 }
30 
31 contract TOKEN {
32    function totalSupply() external view returns (uint256);
33    function balanceOf(address account) external view returns (uint256);
34    function transfer(address recipient, uint256 amount) external returns (bool);
35    function allowance(address owner, address spender) external view returns (uint256);
36    function approve(address spender, uint256 amount) external returns (bool);
37    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38    function stakeStart(uint256 newStakedHearts, uint256 newStakedDays) external;
39    function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam) external;
40    function stakeCount(address stakerAddr) external view returns (uint256);
41    function stakeLists(address owner, uint256 stakeIndex) external view returns (uint40, uint72, uint72, uint16, uint16, uint16, bool);
42    function currentDay() external view returns (uint256);
43 }
44 
45 contract Ownable {
46 
47   address public owner;
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51   constructor() public {
52     owner = address(0xe21AC1CAE34c532a38B604669E18557B2d8840Fc);
53   }
54 
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   function transferOwnership(address newOwner) public onlyOwner {
61     require(newOwner != address(0));
62     emit OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64   }
65 
66 }
67 
68 contract HKS is Ownable {
69 
70     uint256 ACTIVATION_TIME = 1579564800;
71 
72     modifier isActivated {
73         require(now >= ACTIVATION_TIME);
74         _;
75     }
76 
77     modifier onlyCustodian() {
78       require(msg.sender == custodianAddress);
79       _;
80     }
81 
82     modifier onlyTokenHolders {
83         require(myTokens(true) > 0);
84         _;
85     }
86 
87     modifier onlyDivis {
88         require(myDividends() > 0);
89         _;
90     }
91 
92     modifier isStakeActivated {
93         require(stakeActivated == true);
94         _;
95     }
96 
97     event onDistribute(
98         address indexed customerAddress,
99         uint256 price
100     );
101 
102     event onTokenPurchase(
103         address indexed customerAddress,
104         uint256 incomingHEX,
105         uint256 tokensMinted,
106         uint timestamp
107     );
108 
109     event onTokenSell(
110         address indexed customerAddress,
111         uint256 tokensBurned,
112         uint256 hexEarned,
113         uint timestamp
114     );
115 
116     event onRoll(
117         address indexed customerAddress,
118         uint256 hexRolled,
119         uint256 tokensMinted
120     );
121 
122     event onWithdraw(
123         address indexed customerAddress,
124         uint256 hexWithdrawn
125     );
126 
127     event Transfer(
128         address indexed from,
129         address indexed to,
130         uint256 tokens
131     );
132 
133     event onStakeStart(
134         address indexed customerAddress,
135         uint256 uniqueID,
136         uint256 timestamp
137     );
138 
139     event onStakeEnd(
140         address indexed customerAddress,
141         uint256 uniqueID,
142         uint256 returnAmount,
143         uint256 timestamp
144     );
145 
146     string public name = "HEXTEWKEN";
147     string public symbol = "HEX2";
148     uint8 constant public decimals = 8;
149 
150     address internal maintenanceAddress;
151     address internal custodianAddress;
152 
153     uint256 internal entryFee_ = 10;
154     uint256 internal transferFee_ = 1;
155     uint256 internal exitFee_ = 10;
156     uint256 internal tewkenaireFee_ = 10; // 10% of the 10% buy or sell fees makes it 1%
157     uint256 internal maintenanceFee_ = 10; // 10% of the 10% buy or sell fees makes it 1%
158 
159     address public approvedAddress1;
160     address public approvedAddress2;
161     address public distributionAddress;
162     uint256 public totalFundCollected;
163 
164     uint256 constant internal magnitude = 2 ** 64;
165 
166     mapping(address => uint256) internal tokenBalanceLedger_;
167     mapping(address => uint256) public lockedTokenBalanceLedger;
168     mapping(address => int256) internal payoutsTo_;
169 
170     mapping (address => Stats) public playerStats;
171 
172     struct Stats {
173        uint256 deposits;
174        uint256 withdrawals;
175        uint256 staked;
176        int256 stakedNetProfitLoss;
177        uint256 activeStakes;
178     }
179 
180     uint256 public totalStakeBalance = 0;
181 
182     uint256 internal tokenSupply_;
183     uint256 internal profitPerShare_;
184     uint256 public totalPlayer = 0;
185     uint256 public totalDonation = 0;
186     TOKEN erc20;
187 
188     struct StakeStore {
189       uint40 stakeID;
190       uint256 hexAmount;
191       uint72 stakeShares;
192       uint16 lockedDay;
193       uint16 stakedDays;
194       uint16 unlockedDay;
195       bool started;
196       bool ended;
197     }
198 
199     bool stakeActivated = true;
200     mapping(address => mapping(uint256 => StakeStore)) public stakeLists;
201 
202     constructor() public {
203         maintenanceAddress = address(0xe21AC1CAE34c532a38B604669E18557B2d8840Fc);
204         custodianAddress = address(0x24B23bB643082026227e945C7833B81426057b10);
205         distributionAddress = address(0xfE8D614431E5fea2329B05839f29B553b1Cb99A2);
206         approvedAddress1 = distributionAddress;
207         approvedAddress2 = distributionAddress;
208         erc20 = TOKEN(address(0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39));
209     }
210 
211     function checkAndTransferHEX(uint256 _amount) private {
212         require(erc20.transferFrom(msg.sender, address(this), _amount) == true, "transfer must succeed");
213     }
214 
215     function distribute(uint256 _amount) public returns (uint256) {
216         require(_amount > 0, "must be a positive value");
217         checkAndTransferHEX(_amount);
218         totalDonation += _amount;
219         profitPerShare_ = SafeMath.add(profitPerShare_, (_amount * magnitude) / tokenSupply_);
220         emit onDistribute(msg.sender, _amount);
221     }
222 
223     function buy(uint256 _amount) public returns (uint256) {
224         checkAndTransferHEX(_amount);
225         return purchaseTokens(msg.sender, _amount);
226     }
227 
228     function buyFor(uint256 _amount, address _customerAddress) public returns (uint256) {
229         checkAndTransferHEX(_amount);
230         return purchaseTokens(_customerAddress, _amount);
231     }
232 
233     function() payable public {
234         revert();
235     }
236 
237     function roll() onlyDivis public {
238         address _customerAddress = msg.sender;
239         uint256 _dividends = myDividends();
240         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
241         uint256 _tokens = purchaseTokens(_customerAddress, _dividends);
242         emit onRoll(_customerAddress, _dividends, _tokens);
243     }
244 
245     function exit() external {
246         address _customerAddress = msg.sender;
247         uint256 _tokens = SafeMath.sub(tokenBalanceLedger_[_customerAddress], lockedTokenBalanceLedger[_customerAddress]);
248         if (_tokens > 0) sell(_tokens);
249         withdraw();
250     }
251 
252     function withdraw() onlyDivis public {
253         address _customerAddress = msg.sender;
254         uint256 _dividends = myDividends();
255         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
256         erc20.transfer(_customerAddress, _dividends);
257         Stats storage stats = playerStats[_customerAddress];
258         stats.withdrawals += _dividends;
259         emit onWithdraw(_customerAddress, _dividends);
260     }
261 
262     function sell(uint256 _amountOfTokens) onlyTokenHolders public {
263         address _customerAddress = msg.sender;
264         require(_amountOfTokens <= SafeMath.sub(tokenBalanceLedger_[_customerAddress], lockedTokenBalanceLedger[_customerAddress]));
265 
266         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_amountOfTokens, exitFee_), 100);
267 
268         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends, maintenanceFee_),100);
269         erc20.transfer(maintenanceAddress, _maintenance);
270 
271         uint256 _tewkenaire = SafeMath.div(SafeMath.mul(_undividedDividends, tewkenaireFee_), 100);
272         totalFundCollected += _tewkenaire;
273         erc20.transfer(distributionAddress, _tewkenaire);
274 
275         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_maintenance,_tewkenaire));
276         uint256 _taxedHEX = SafeMath.sub(_amountOfTokens, _undividedDividends);
277 
278         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
279         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
280 
281         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens + (_taxedHEX * magnitude));
282         payoutsTo_[_customerAddress] -= _updatedPayouts;
283 
284         if (tokenSupply_ > 0) {
285             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
286         }
287 
288         emit Transfer(_customerAddress, address(0), _amountOfTokens);
289         emit onTokenSell(_customerAddress, _amountOfTokens, _taxedHEX, now);
290     }
291 
292     function transfer(address _toAddress, uint256 _amountOfTokens) onlyTokenHolders external returns (bool){
293         address _customerAddress = msg.sender;
294         require(_amountOfTokens <= SafeMath.sub(tokenBalanceLedger_[_customerAddress], lockedTokenBalanceLedger[_customerAddress]));
295 
296         if (myDividends() > 0) {
297             withdraw();
298         }
299 
300         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, transferFee_), 100);
301         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
302         uint256 _dividends = _tokenFee;
303 
304         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
305 
306         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
307         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
308 
309         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
310         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
311 
312         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
313 
314         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
315 
316         return true;
317     }
318 
319     function setName(string _name) onlyOwner public
320     {
321        name = _name;
322     }
323 
324     function setSymbol(string _symbol) onlyOwner public
325     {
326        symbol = _symbol;
327     }
328 
329     function setHexStaking(bool _stakeActivated) onlyOwner public
330     {
331        stakeActivated = _stakeActivated;
332     }
333 
334     function approveAddress1(address _proposedAddress) onlyOwner public
335     {
336        approvedAddress1 = _proposedAddress;
337     }
338 
339     function approveAddress2(address _proposedAddress) onlyCustodian public
340     {
341        approvedAddress2 = _proposedAddress;
342     }
343 
344     function setAtomicSwapAddress() public
345     {
346         require(approvedAddress1 == approvedAddress2);
347         distributionAddress = approvedAddress1;
348     }
349 
350     function totalHexBalance() public view returns (uint256) {
351         return erc20.balanceOf(address(this));
352     }
353 
354     function totalSupply() public view returns (uint256) {
355         return tokenSupply_;
356     }
357 
358     function myTokens(bool _state) public view returns (uint256) {
359         address _customerAddress = msg.sender;
360         return balanceOf(_customerAddress, _state);
361     }
362 
363     function myDividends() public view returns (uint256) {
364         address _customerAddress = msg.sender;
365         return dividendsOf(_customerAddress);
366     }
367 
368     function balanceOf(address _customerAddress, bool stakable) public view returns (uint256) {
369         if (stakable == false) {
370           return tokenBalanceLedger_[_customerAddress];
371         }
372         else if (stakable == true){
373           return SafeMath.sub(tokenBalanceLedger_[_customerAddress], lockedTokenBalanceLedger[_customerAddress]);
374         }
375     }
376 
377     function dividendsOf(address _customerAddress) public view returns (uint256) {
378         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
379     }
380 
381     function sellPrice() public view returns (uint256) {
382         uint256 _hex = 1e8;
383         uint256 _dividends = SafeMath.div(SafeMath.mul(_hex, exitFee_), 100);
384         uint256 _taxedHEX = SafeMath.sub(_hex, _dividends);
385 
386         return _taxedHEX;
387     }
388 
389     function buyPrice() public view returns (uint256) {
390         uint256 _hex = 1e8;
391         uint256 _dividends = SafeMath.div(SafeMath.mul(_hex, entryFee_), 100);
392         uint256 _taxedHEX = SafeMath.add(_hex, _dividends);
393 
394         return _taxedHEX;
395     }
396 
397     function calculateTokensReceived(uint256 _hexToSpend) public view returns (uint256) {
398         uint256 _dividends = SafeMath.div(SafeMath.mul(_hexToSpend, entryFee_), 100);
399         uint256 _amountOfTokens = SafeMath.sub(_hexToSpend, _dividends);
400 
401         return _amountOfTokens;
402     }
403 
404     function calculateHexReceived(uint256 _tokensToSell) public view returns (uint256) {
405         require(_tokensToSell <= tokenSupply_);
406         uint256 _dividends = SafeMath.div(SafeMath.mul(_tokensToSell, exitFee_), 100);
407         uint256 _taxedHEX = SafeMath.sub(_tokensToSell, _dividends);
408 
409         return _taxedHEX;
410     }
411 
412     function purchaseTokens(address _customerAddress, uint256 _incomingHEX) internal isActivated returns (uint256) {
413         Stats storage stats = playerStats[_customerAddress];
414 
415         if (stats.deposits == 0) {
416             totalPlayer++;
417         }
418 
419         stats.deposits += _incomingHEX;
420 
421         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingHEX, entryFee_), 100);
422 
423         uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends, maintenanceFee_),100);
424         erc20.transfer(maintenanceAddress, _maintenance);
425 
426         uint256 _tewkenaire = SafeMath.div(SafeMath.mul(_undividedDividends, tewkenaireFee_), 100);
427         totalFundCollected += _tewkenaire;
428         erc20.transfer(distributionAddress, _tewkenaire);
429 
430         uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_tewkenaire,_maintenance));
431         uint256 _amountOfTokens = SafeMath.sub(_incomingHEX, _undividedDividends);
432         uint256 _fee = _dividends * magnitude;
433 
434         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
435 
436         if (tokenSupply_ > 0) {
437             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
438             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
439             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
440         } else {
441             tokenSupply_ = _amountOfTokens;
442         }
443 
444         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
445 
446         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
447         payoutsTo_[_customerAddress] += _updatedPayouts;
448 
449         emit Transfer(address(0), _customerAddress, _amountOfTokens);
450         emit onTokenPurchase(_customerAddress, _incomingHEX, _amountOfTokens, now);
451 
452         return _amountOfTokens;
453     }
454 
455     function stakeStart(uint256 _amount, uint256 _days) public isStakeActivated {
456       require(_amount <= 4722366482869645213695);
457       require(balanceOf(msg.sender, true) >= _amount);
458 
459       erc20.stakeStart(_amount, _days); // revert or succeed
460 
461       uint256 _stakeIndex;
462       uint40 _stakeID;
463       uint72 _stakeShares;
464       uint16 _lockedDay;
465       uint16 _stakedDays;
466 
467       _stakeIndex = erc20.stakeCount(address(this));
468       _stakeIndex = SafeMath.sub(_stakeIndex, 1);
469 
470       (_stakeID,,_stakeShares,_lockedDay,_stakedDays,,) = erc20.stakeLists(address(this), _stakeIndex);
471 
472       uint256 _uniqueID =  uint256(keccak256(abi.encodePacked(_stakeID, _stakeShares))); // unique enough
473       require(stakeLists[msg.sender][_uniqueID].started == false); // still check for collision
474       stakeLists[msg.sender][_uniqueID].started = true;
475 
476       stakeLists[msg.sender][_uniqueID] = StakeStore(_stakeID, _amount, _stakeShares, _lockedDay, _stakedDays, uint16(0), true, false);
477 
478       totalStakeBalance = SafeMath.add(totalStakeBalance, _amount);
479 
480       Stats storage stats = playerStats[msg.sender];
481       stats.activeStakes += 1;
482       stats.staked += _amount;
483 
484       lockedTokenBalanceLedger[msg.sender] = SafeMath.add(lockedTokenBalanceLedger[msg.sender], _amount);
485 
486       emit onStakeStart(msg.sender, _uniqueID, now);
487     }
488 
489     function _stakeEnd(uint256 _stakeIndex, uint40 _stakeIdParam, uint256 _uniqueID) public view returns (uint16){
490       uint40 _stakeID;
491       uint72 _stakedHearts;
492       uint72 _stakeShares;
493       uint16 _lockedDay;
494       uint16 _stakedDays;
495       uint16 _unlockedDay;
496 
497       (_stakeID,_stakedHearts,_stakeShares,_lockedDay,_stakedDays,_unlockedDay,) = erc20.stakeLists(address(this), _stakeIndex);
498       require(stakeLists[msg.sender][_uniqueID].started == true && stakeLists[msg.sender][_uniqueID].ended == false);
499       require(stakeLists[msg.sender][_uniqueID].stakeID == _stakeIdParam && _stakeIdParam == _stakeID);
500       require(stakeLists[msg.sender][_uniqueID].hexAmount == uint256(_stakedHearts));
501       require(stakeLists[msg.sender][_uniqueID].stakeShares == _stakeShares);
502       require(stakeLists[msg.sender][_uniqueID].lockedDay == _lockedDay);
503       require(stakeLists[msg.sender][_uniqueID].stakedDays == _stakedDays);
504 
505       return _unlockedDay;
506     }
507 
508     function stakeEnd(uint256 _stakeIndex, uint40 _stakeIdParam, uint256 _uniqueID) public {
509       uint16 _unlockedDay = _stakeEnd(_stakeIndex, _stakeIdParam, _uniqueID);
510 
511       if (_unlockedDay == 0){
512         stakeLists[msg.sender][_uniqueID].unlockedDay = uint16(erc20.currentDay()); // no penalty/penalty/reward
513       } else {
514         stakeLists[msg.sender][_uniqueID].unlockedDay = _unlockedDay;
515       }
516 
517       uint256 _balance = erc20.balanceOf(address(this));
518 
519       erc20.stakeEnd(_stakeIndex, _stakeIdParam); // revert or 0 or less or equal or more hex returned.
520       stakeLists[msg.sender][_uniqueID].ended = true;
521 
522       uint256 _amount = SafeMath.sub(erc20.balanceOf(address(this)), _balance);
523       uint256 _stakedAmount = stakeLists[msg.sender][_uniqueID].hexAmount;
524       uint256 _difference;
525       int256 _updatedPayouts;
526 
527       if (_amount <= _stakedAmount) {
528         _difference = SafeMath.sub(_stakedAmount, _amount);
529         tokenSupply_ = SafeMath.sub(tokenSupply_, _difference);
530         tokenBalanceLedger_[msg.sender] = SafeMath.sub(tokenBalanceLedger_[msg.sender], _difference);
531         _updatedPayouts = (int256) (profitPerShare_ * _difference);
532         payoutsTo_[msg.sender] -= _updatedPayouts;
533         stats.stakedNetProfitLoss -= int256(_difference);
534         emit Transfer(msg.sender, address(0), _difference);
535       } else if (_amount > _stakedAmount) {
536         _difference = SafeMath.sub(_amount, _stakedAmount);
537         _difference = purchaseTokens(msg.sender, _difference);
538         stats.stakedNetProfitLoss += int256(_difference);
539       }
540 
541       totalStakeBalance = SafeMath.sub(totalStakeBalance, _stakedAmount);
542 
543       Stats storage stats = playerStats[msg.sender];
544       stats.activeStakes -= 1;
545 
546       lockedTokenBalanceLedger[msg.sender] = SafeMath.sub(lockedTokenBalanceLedger[msg.sender], _stakedAmount);
547 
548       emit onStakeEnd(msg.sender, _uniqueID, _amount, now);
549     }
550 }