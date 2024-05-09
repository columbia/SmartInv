1 pragma solidity ^0.4.26;
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
31 }
32 
33 contract TOKEN {
34     function totalSupply() external view returns (uint256);
35     function balanceOf(address account) external view returns (uint256);
36     function transfer(address recipient, uint256 amount) external returns (bool);
37     function allowance(address owner, address spender) external view returns (uint256);
38     function approve(address spender, uint256 amount) external returns (bool);
39     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
40     function stakeStart(uint256 newStakedHearts, uint256 newStakedDays) external;
41     function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam) external;
42     function stakeCount(address stakerAddr) external view returns (uint256);
43     function stakeLists(address owner, uint256 stakeIndex) external view returns (uint40, uint72, uint72, uint16, uint16, uint16, bool);
44     function currentDay() external view returns (uint256);
45 }
46 
47 contract Ownable {
48   address public owner;
49 
50   constructor() public {
51     owner = address(0xAeFeB36820bd832038E8e4F73eDbD5f48D3b4E50);
52   }
53 
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 }
59 
60 contract HRS is Ownable {
61     using SafeMath for uint256;
62 
63     uint ACTIVATION_TIME = 1582416000;
64 
65     modifier isActivated {
66         require(now >= ACTIVATION_TIME);
67 
68         if (now <= (ACTIVATION_TIME + 2 minutes)) {
69             require(tx.gasprice <= 0.1 szabo);
70         }
71         _;
72     }
73 
74     modifier onlyTokenHolders() {
75         require(myTokens(true) > 0);
76         _;
77     }
78 
79     modifier isStakeActivated {
80         require(stakeActivated == true);
81         _;
82     }
83 
84     event onDistribute(
85         address indexed customerAddress,
86         uint256 tokens
87     );
88 
89     event Transfer(
90         address indexed from,
91         address indexed to,
92         uint256 tokens
93     );
94 
95     event onTokenPurchase(
96         address indexed customerAddress,
97         uint256 incomingHEX,
98         uint256 tokensMinted,
99         uint256 timestamp
100     );
101 
102     event onTokenSell(
103         address indexed customerAddress,
104         uint256 tokensBurned,
105         uint256 hexEarned,
106         uint256 timestamp
107     );
108 
109     event onTokenAppreciation(
110         uint256 tokenPrice,
111         uint256 timestamp
112     );
113 
114     event onStakeStart(
115         address indexed customerAddress,
116         uint256 uniqueID,
117         uint256 currentTokens,
118         uint256 timestamp
119     );
120 
121     event onStakeEnd(
122         address indexed customerAddress,
123         uint256 uniqueID,
124         uint256 returnAmount,
125         uint256 difference,
126         uint256 timestamp
127     );
128 
129     string public name = "HEXRISE";
130     string public symbol = "HEX3";
131     uint8 constant public decimals = 8;
132     uint256 constant internal magnitude = 1e8;
133 
134     uint8 constant internal transferFee = 1;
135     uint8 constant internal buyInFee = 4;
136     uint8 constant internal sellOutFee = 4;
137     uint8 constant internal devFee = 1;
138     uint8 constant internal hexTewFee = 1;
139 
140     mapping(address => uint256) private tokenBalanceLedger;
141     mapping(address => uint256) public lockedHexBalanceLedger;
142 
143     struct Stats {
144        uint256 deposits;
145        uint256 withdrawals;
146        uint256 staked;
147        uint256 activeStakes;
148     }
149 
150     mapping(address => Stats) public playerStats;
151 
152     uint256 public totalStakeBalance = 0;
153     uint256 public totalPlayer = 0;
154     uint256 public totalDonation = 0;
155     uint256 public totalFundReceived = 0;
156     uint256 public totalFundCollected = 0; 
157 
158     uint256 private tokenSupply = 0;
159     uint256 private contractValue = 0;
160     uint256 private tokenPrice = 100000000;
161 
162     EXCH exchange;
163     TOKEN erc20;
164 
165     struct StakeStore {
166       uint40 stakeID;
167       uint256 hexAmount;
168       uint72 stakeShares;
169       uint16 lockedDay;
170       uint16 stakedDays;
171       uint16 unlockedDay;
172       bool started;
173       bool ended;
174     }
175 
176     bool stakeActivated = true;
177     mapping(address => mapping(uint256 => StakeStore)) public stakeLists;
178 
179     constructor() public {
180         exchange = EXCH(address(0xD495cC8C7c29c7fA3E027a5759561Ab68C363609));
181         erc20 = TOKEN(address(0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39));
182     }
183 
184     function() payable public {
185         revert();
186     }
187 
188     function checkAndTransferHEX(uint256 _amount) private {
189         require(erc20.transferFrom(msg.sender, address(this), _amount) == true, "transfer must succeed");
190     }
191 
192     function appreciateTokenPrice(uint256 _amount) isActivated public {
193         require(_amount > 0, "must be a positive value");
194         checkAndTransferHEX(_amount);
195         contractValue = contractValue.add(_amount);
196         totalDonation += _amount;
197 
198         if (tokenSupply > magnitude) {
199             tokenPrice = (contractValue.mul(magnitude)) / tokenSupply;
200         }
201 
202         emit onDistribute(msg.sender, _amount);
203         emit onTokenAppreciation(tokenPrice, now);
204     }
205 
206     function payFund() public {
207         uint256 _hexToPay = totalFundCollected.sub(totalFundReceived);
208         require(_hexToPay > 0);
209         totalFundReceived = totalFundReceived.add(_hexToPay);
210         erc20.approve(exchange, _hexToPay);
211         exchange.distribute(_hexToPay);
212     }
213 
214     function buy(uint256 _amount) public returns (uint256) {
215         checkAndTransferHEX(_amount);
216         return purchaseTokens(msg.sender, _amount);
217     }
218 
219     function buyFor(uint256 _amount, address _customerAddress) public returns (uint256) {
220         checkAndTransferHEX(_amount);
221         return purchaseTokens(_customerAddress, _amount);
222     }
223 
224     function _purchaseTokens(address _customerAddress, uint256 _incomingHEX) private returns(uint256) {
225         uint256 _amountOfTokens = (_incomingHEX.mul(magnitude)) / tokenPrice;
226 
227         require(_amountOfTokens > 0 && _amountOfTokens.add(tokenSupply) > tokenSupply);
228 
229         tokenBalanceLedger[_customerAddress] =  tokenBalanceLedger[_customerAddress].add(_amountOfTokens);
230         tokenSupply = tokenSupply.add(_amountOfTokens);
231 
232         emit Transfer(address(0), _customerAddress, _amountOfTokens);
233 
234         return _amountOfTokens;
235     }
236 
237     function purchaseTokens(address _customerAddress, uint256 _incomingHEX) private isActivated returns (uint256) {
238         if (playerStats[_customerAddress].deposits == 0) {
239             totalPlayer++;
240         }
241 
242         playerStats[_customerAddress].deposits += _incomingHEX;
243 
244         require(_incomingHEX > 0);
245 
246         uint256 _devFee = _incomingHEX.mul(devFee).div(100);
247         uint256 _hexTewFee = _incomingHEX.mul(hexTewFee).div(100);
248         uint256 _fee = _incomingHEX.mul(buyInFee).div(100);
249 
250         _purchaseTokens(owner, _devFee);
251         totalFundCollected = totalFundCollected.add(_hexTewFee);
252 
253         uint256 _amountOfTokens = _purchaseTokens(_customerAddress, _incomingHEX.sub(_fee).sub(_devFee).sub(_hexTewFee));
254             
255         contractValue = contractValue.add(_incomingHEX.sub(_hexTewFee));
256 
257         if (hexToSendFund() >= 10000e8) {
258             payFund();
259         }
260 
261         if (tokenSupply > magnitude) {
262             tokenPrice = (contractValue.mul(magnitude)) / tokenSupply;
263         }
264 
265         emit onTokenPurchase(_customerAddress, _incomingHEX, _amountOfTokens, now);
266         emit onTokenAppreciation(tokenPrice, now);
267 
268         return _amountOfTokens;
269     }
270 
271     function sell(uint256 _amountOfTokens) isActivated onlyTokenHolders public {
272         address _customerAddress = msg.sender;
273         uint256 _lockedToken = (lockedHexBalanceLedger[_customerAddress].mul(magnitude)) / tokenPrice;
274 
275         require(_amountOfTokens > 0 && _amountOfTokens <= tokenBalanceLedger[_customerAddress].sub(_lockedToken));
276 
277         uint256 _hex = _amountOfTokens.mul(tokenPrice).div(magnitude);
278         uint256 _fee = _hex.mul(sellOutFee).div(100);
279 
280         tokenSupply = tokenSupply.sub(_amountOfTokens);
281         tokenBalanceLedger[_customerAddress] = tokenBalanceLedger[_customerAddress].sub(_amountOfTokens);
282 
283         _hex = _hex.sub(_fee);
284 
285         contractValue = contractValue.sub(_hex);
286 
287         if (tokenSupply > magnitude) {
288             tokenPrice = (contractValue.mul(magnitude)) / tokenSupply;
289         }
290 
291         erc20.transfer(_customerAddress, _hex);
292         playerStats[_customerAddress].withdrawals += _hex;
293 
294         emit Transfer(_customerAddress, address(0), _amountOfTokens);
295         emit onTokenSell(_customerAddress, _amountOfTokens, _hex, now);
296         emit onTokenAppreciation(tokenPrice, now);
297     }
298 
299     function transfer(address _toAddress, uint256 _amountOfTokens) isActivated onlyTokenHolders external returns (bool) {
300         address _customerAddress = msg.sender;
301         uint256 _lockedToken = (lockedHexBalanceLedger[_customerAddress].mul(magnitude)) / tokenPrice;
302 
303         require(_amountOfTokens > 0 && _amountOfTokens <= tokenBalanceLedger[_customerAddress].sub(_lockedToken));
304 
305         uint256 _tokenFee = _amountOfTokens.mul(transferFee).div(100);
306         uint256 _taxedTokens = _amountOfTokens.sub(_tokenFee);
307 
308         tokenBalanceLedger[_customerAddress] = tokenBalanceLedger[_customerAddress].sub(_amountOfTokens);
309         tokenBalanceLedger[_toAddress] = tokenBalanceLedger[_toAddress].add(_taxedTokens);
310 
311         tokenSupply = tokenSupply.sub(_tokenFee);
312 
313         if (tokenSupply>magnitude)
314         {
315             tokenPrice = (contractValue.mul(magnitude)) / tokenSupply;
316         }
317 
318         emit Transfer(_customerAddress, address(0), _tokenFee);
319         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
320         emit onTokenAppreciation(tokenPrice, now);
321 
322         return true;
323     }
324 
325     function stakeStart(uint256 _amount, uint256 _days) public isStakeActivated {
326         require(_amount <= 4722366482869645213695);
327         require(hexBalanceOfNoFee(msg.sender, true) >= _amount);
328 
329         erc20.stakeStart(_amount, _days); // revert or succeed
330 
331         uint256 _stakeIndex;
332         uint40 _stakeID;
333         uint72 _stakeShares;
334         uint16 _lockedDay;
335         uint16 _stakedDays;
336 
337         _stakeIndex = erc20.stakeCount(address(this));
338         _stakeIndex = SafeMath.sub(_stakeIndex, 1);
339 
340         (_stakeID,,_stakeShares,_lockedDay,_stakedDays,,) = erc20.stakeLists(address(this), _stakeIndex);
341 
342         uint256 _uniqueID =  uint256(keccak256(abi.encodePacked(_stakeID, _stakeShares))); // unique enough
343         require(stakeLists[msg.sender][_uniqueID].started == false); // still check for collision
344         stakeLists[msg.sender][_uniqueID].started = true;
345 
346         stakeLists[msg.sender][_uniqueID] = StakeStore(_stakeID, _amount, _stakeShares, _lockedDay, _stakedDays, uint16(0), true, false);
347 
348         totalStakeBalance = SafeMath.add(totalStakeBalance, _amount);
349 
350         playerStats[msg.sender].activeStakes += 1;
351         playerStats[msg.sender].staked += _amount;
352 
353         lockedHexBalanceLedger[msg.sender] = SafeMath.add(lockedHexBalanceLedger[msg.sender], _amount);
354 
355         emit onStakeStart(msg.sender, _uniqueID, calculateTokensReceived(_amount, false), now);
356     }
357 
358     function _stakeEnd(uint256 _stakeIndex, uint40 _stakeIdParam, uint256 _uniqueID) public view returns (uint16){
359         uint40 _stakeID;
360         uint72 _stakedHearts;
361         uint72 _stakeShares;
362         uint16 _lockedDay;
363         uint16 _stakedDays;
364         uint16 _unlockedDay;
365 
366         (_stakeID,_stakedHearts,_stakeShares,_lockedDay,_stakedDays,_unlockedDay,) = erc20.stakeLists(address(this), _stakeIndex);
367         require(stakeLists[msg.sender][_uniqueID].started == true && stakeLists[msg.sender][_uniqueID].ended == false);
368         require(stakeLists[msg.sender][_uniqueID].stakeID == _stakeIdParam && _stakeIdParam == _stakeID);
369         require(stakeLists[msg.sender][_uniqueID].hexAmount == uint256(_stakedHearts));
370         require(stakeLists[msg.sender][_uniqueID].stakeShares == _stakeShares);
371         require(stakeLists[msg.sender][_uniqueID].lockedDay == _lockedDay);
372         require(stakeLists[msg.sender][_uniqueID].stakedDays == _stakedDays);
373 
374         return _unlockedDay;
375     }
376 
377     function stakeEnd(uint256 _stakeIndex, uint40 _stakeIdParam, uint256 _uniqueID) public {
378         uint16 _unlockedDay = _stakeEnd(_stakeIndex, _stakeIdParam, _uniqueID);
379 
380         if (_unlockedDay == 0){
381             stakeLists[msg.sender][_uniqueID].unlockedDay = uint16(erc20.currentDay()); // no penalty/penalty/reward
382         } else {
383             stakeLists[msg.sender][_uniqueID].unlockedDay = _unlockedDay;
384         }
385 
386         uint256 _balance = erc20.balanceOf(address(this));
387 
388         erc20.stakeEnd(_stakeIndex, _stakeIdParam); // revert or 0 or less or equal or more hex returned.
389         stakeLists[msg.sender][_uniqueID].ended = true;
390 
391         uint256 _amount = SafeMath.sub(erc20.balanceOf(address(this)), _balance);
392         uint256 _stakedAmount = stakeLists[msg.sender][_uniqueID].hexAmount;
393         uint256 _difference;
394 
395         if (_amount <= _stakedAmount) {
396             _difference = SafeMath.sub(_stakedAmount, _amount);
397             contractValue = contractValue.sub(_difference);
398             _difference = (_difference.mul(magnitude)) / tokenPrice;
399             tokenSupply = SafeMath.sub(tokenSupply, _difference);
400             tokenBalanceLedger[msg.sender] = SafeMath.sub(tokenBalanceLedger[msg.sender], _difference);
401             emit Transfer(msg.sender, address(0), _difference);
402         } else if (_amount > _stakedAmount) {
403             _difference = SafeMath.sub(_amount, _stakedAmount);
404             _difference = purchaseTokens(msg.sender, _difference);
405         }
406 
407         totalStakeBalance = SafeMath.sub(totalStakeBalance, _stakedAmount);
408         playerStats[msg.sender].activeStakes -= 1;
409 
410         lockedHexBalanceLedger[msg.sender] = SafeMath.sub(lockedHexBalanceLedger[msg.sender], _stakedAmount);
411 
412         emit onStakeEnd(msg.sender, _uniqueID, _amount, _difference, now);
413     }
414 
415     function setName(string _name) onlyOwner public
416     {
417         name = _name;
418     }
419 
420     function setSymbol(string _symbol) onlyOwner public
421     {
422         symbol = _symbol;
423     }
424 
425     function setHexStaking(bool _stakeActivated) onlyOwner public
426     {
427         stakeActivated = _stakeActivated;
428     }
429 
430     function totalHexBalance() public view returns (uint256) {
431         return erc20.balanceOf(address(this));
432     }
433 
434     function totalSupply() public view returns(uint256) {
435         return tokenSupply;
436     }
437 
438     function myTokens(bool _stakeable) public view returns (uint256) {
439         address _customerAddress = msg.sender;
440         return balanceOf(_customerAddress, _stakeable);
441     }
442 
443     function balanceOf(address _customerAddress, bool _stakeable) public view returns (uint256) {
444         if (_stakeable == false) {
445             return tokenBalanceLedger[_customerAddress];
446         }
447         else if (_stakeable == true) {
448             uint256 _lockedToken = (lockedHexBalanceLedger[_customerAddress].mul(magnitude)) / tokenPrice;
449             return (tokenBalanceLedger[_customerAddress].sub(_lockedToken));
450         }
451     }
452 
453     function sellPrice(bool _includeFees) public view returns (uint256) {
454         uint256 _fee = 0;
455 
456         if (_includeFees) {
457             _fee = tokenPrice.mul(sellOutFee).div(100);
458         }
459 
460         return (tokenPrice.sub(_fee));
461     }
462 
463     function buyPrice(bool _includeFees) public view returns(uint256) {
464         uint256 _fee = 0;
465         uint256 _devFee = 0;
466         uint256 _hexTewFee = 0;
467 
468         if (_includeFees) {
469             _fee = tokenPrice.mul(buyInFee).div(100);
470             _devFee = tokenPrice.mul(devFee).div(100);
471             _hexTewFee = tokenPrice.mul(hexTewFee).div(100);            
472         }
473 
474         return (tokenPrice.add(_fee).add(_devFee).add(_hexTewFee));
475     }
476 
477     function calculateTokensReceived(uint256 _hexToSpend, bool _includeFees) public view returns (uint256) {
478         uint256 _fee = 0;
479         uint256 _devFee = 0;
480         uint256 _hexTewFee = 0;
481 
482         if (_includeFees) {
483             _fee = _hexToSpend.mul(buyInFee).div(100);
484             _devFee = _hexToSpend.mul(devFee).div(100);
485             _hexTewFee = _hexToSpend.mul(hexTewFee).div(100);     
486         }
487 
488         uint256 _taxedHEX = _hexToSpend.sub(_fee).sub(_devFee).sub(_hexTewFee);
489         uint256 _amountOfTokens = (_taxedHEX.mul(magnitude)) / tokenPrice;
490 
491         return _amountOfTokens;
492     }
493 
494     function hexBalanceOf(address _customerAddress, bool _stakeable) public view returns(uint256) {
495         uint256 _price = sellPrice(true);
496         uint256 _balance = balanceOf(_customerAddress, _stakeable);
497         uint256 _value = (_balance.mul(_price)) / magnitude;
498 
499         return _value;
500     }
501 
502     function hexBalanceOfNoFee(address _customerAddress, bool _stakeable) public view returns(uint256) {
503         uint256 _price = sellPrice(false);
504         uint256 _balance = balanceOf(_customerAddress, _stakeable);
505         uint256 _value = (_balance.mul(_price)) / magnitude;
506 
507         return _value;
508     }
509 
510     function hexToSendFund() public view returns(uint256) {
511         return totalFundCollected.sub(totalFundReceived);
512     }
513 }