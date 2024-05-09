1 pragma solidity >=0.5.6 <0.6.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      *
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      *
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      *
56      * - Subtraction cannot overflow.
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      *
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      *
99      * - The divisor cannot be zero.
100      */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104 
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      *
115      * - The divisor cannot be zero.
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 contract DigiExchange {
160     using SafeMath for *;
161 
162     struct Roadmap {
163         uint256 supply;
164         uint256 startPrice;
165         uint256 incPrice;
166     }
167 
168     string constant public _name = "Digi Exchange";
169     string constant public _symbol = "DIGIX";
170     uint8 constant public _decimals = 0;
171     uint256 public _totalSupply = 1600000;
172     uint256 public _rewardsSupply = 240000;
173     uint256 public circulatingSupply = 514538;
174 
175     mapping(address => bool) private administrators;
176 
177     address commissionHolder;
178     address stakeHolder;
179     uint256 commissionFunds = 0;
180     uint256 public commissionPercent = 400;
181     uint256 public sellCommission = 600;
182     uint256 public tokenCommissionPercent = 250;
183     uint256 public buyPrice;
184     uint256 public sellPrice;
185     uint8 public currentRoadmap = 3;
186     uint8 public sellRoadmap = 3;
187     uint8 constant public LAST_ROADMAP = 18;
188     uint256 public currentRoadmapUsedSupply = 14538;
189     uint256 public sellRoadmapUsedSupply = 14538;
190     uint256 public totalStakeTokens = 0;
191     uint256 public totalLockInTokens = 0;
192     uint256 public locakablePercent = 750;
193     bool buyLimit = true;
194     uint256 buyLimitToken = 2100;
195     uint256 minBuyToken = 10;
196 
197     address dev; //Backend Operation
198     address dev1; //  Operations
199     address dev2; // Research Funds
200     address dev3; //Marketing
201     address dev4; // Development
202     address dev5; //Compliance
203 
204     uint256 dev1Com;
205     uint256 dev2Com;
206     uint256 dev3Com;
207     uint256 dev4Com;
208     uint256 dev5Com;
209 
210 
211     mapping(address => uint256) commissionOf;
212     mapping(address => uint256) userIncomes;
213     mapping(address => uint256) private _balances;
214     mapping(address => uint256) public stakeBalanceOf;
215     mapping(uint8 => Roadmap) public priceRoadmap;
216     mapping(address => uint256) public _lockInBalances;
217 
218     event Transfer(address indexed from, address indexed to, uint256 value);
219     event Stake(address indexed staker, uint256 value, uint256 totalInStake);
220     event UnStake(address indexed staker, uint256 value, uint256 totalInStake);
221     event CommissionWithdraw(address indexed user, uint256 amount);
222     event WithdrawTokenCommission(address indexed user, uint256 amount, uint256 nonce);
223     event WithdrawStakingCommission(address indexed user, uint256 amount, uint256 nonce);
224     event Price(uint256 buyPrice, uint256 sellPrice, uint256 circulatingSupply);
225     event StakeUser(address indexed user, uint256 value, uint256 totalInStake, uint256 nonce);
226     event LockIn(address indexed from, address indexed to, uint256 value);
227     event TransactionFees(address to, uint256 totalValue);
228 
229     constructor(address _commissionHolder, address _stakeHolder) public {
230         administrators[msg.sender] = true;
231         administrators[_commissionHolder] = true;
232         dev = msg.sender;
233         commissionHolder = _commissionHolder;
234         stakeHolder = _stakeHolder;
235         createRoadmap();
236         buyPrice = 867693750000000;
237         sellPrice = 867688750000000;
238     }
239 
240     function() external payable {
241         revert();
242     }
243 
244     modifier onlyAdministrators{
245         require(administrators[msg.sender], "Only administrators can execute this function");
246         _;
247     }
248 
249     function upgradeContract(address[] memory users) public onlyAdministrators {
250         for (uint i = 0; i < users.length; i++) {
251             _balances[users[i]] += 500;
252             _lockInBalances[users[i]] += 1500;
253             _balances[commissionHolder] += 666;
254             emit Transfer(address(this), users[i], _balances[users[i]]);
255             emit LockIn(users[i], address(this), _lockInBalances[users[i]]);
256         }
257     }
258 
259     function upgradeDetails(uint256 _bp, uint256 _sp, uint256 _circSup, uint8 _currentRp, uint8 _sellRp, uint256 _crs, uint256 _srs, uint256 _commFunds) public onlyAdministrators {
260         buyPrice = _bp;
261         sellPrice = _sp;
262         circulatingSupply = _circSup;
263         currentRoadmap = _currentRp;
264         sellRoadmap = _sellRp;
265         currentRoadmapUsedSupply = _crs;
266         sellRoadmapUsedSupply = _srs;
267         commissionFunds = _commFunds;
268     }
269 
270     function stake(address _user, uint256 _tokens, uint256 nonce) public onlyAdministrators {
271         require(_tokens <= _balances[_user], "User dont have enough tokens to stake");
272         _balances[_user] -= _tokens;
273         stakeBalanceOf[_user] += _tokens;
274         totalStakeTokens += _tokens;
275         emit StakeUser(_user, _tokens, totalStakeTokens, nonce);
276     }
277 
278     function stakeExt(address _user, uint256 _tokens) private {
279         require(_tokens <= _balances[_user], "You dont have enough tokens to stake");
280         _balances[_user] -= _tokens;
281         stakeBalanceOf[_user] += _tokens;
282         totalStakeTokens += _tokens;
283         emit Stake(_user, _tokens, totalStakeTokens);
284     }
285 
286     function unStake(address _user, uint256 _tokens) public onlyAdministrators {
287         require(_tokens <= stakeBalanceOf[_user], "User doesnt have amount of token in stake");
288         stakeBalanceOf[_user] -= _tokens;
289         totalStakeTokens -= _tokens;
290         _balances[_user] += _tokens;
291         emit UnStake(_user, _tokens, totalStakeTokens);
292     }
293 
294     function lockInExt(address _user, uint256 _tokens) private {
295         _lockInBalances[_user] += _tokens;
296         totalLockInTokens += _tokens;
297     }
298 
299     function releaseLockIn(address _user, uint256 _tokens) public onlyAdministrators {
300         require(_tokens <= _lockInBalances[_user], "User dont have enough balance in Tokens");
301         _lockInBalances[_user] = _lockInBalances[_user] - _tokens;
302         _balances[_user] = _balances[_user] + _tokens;
303 
304         totalLockInTokens = totalLockInTokens - _tokens;
305         emit LockIn(address(this), _user, _tokens);
306     }
307 
308     function addLiquidity() external payable returns (bool){
309         return true;
310     }
311 
312     function purchase(uint256 tokens) external payable {
313         purchaseExt(msg.sender, tokens, msg.value);
314     }
315 
316     function sell(uint256 _tokens) public {
317         require(_tokens > 0, "Tokens can not be zero");
318         require(_tokens <= _balances[msg.sender], "You dont have enough amount of token");
319         sellExt(msg.sender, _tokens);
320 
321     }
322 
323     function sellExt(address _user, uint256 _tokens) private {
324         uint256 saleAmount = updateSale(_tokens);
325         _balances[_user] -= _tokens;
326         uint256 _commission = saleAmount.mul(sellCommission).div(10000);
327         uint256 _balanceAfterCommission = saleAmount.sub(_commission);
328         uint256 txnFees = _commission * 200 / 1000;
329         commissionOf[dev] += txnFees;
330         uint256 userInc = _commission * 50 / 10000;
331         userIncomes[commissionHolder] += userInc;
332         commissionFunds += (_commission - txnFees) - userInc;
333 
334         emit Transfer(_user, address(this), _tokens);
335         emit Price(buyPrice, sellPrice, circulatingSupply);
336         emit TransactionFees(address(this), _commission);
337         sendBalanceAmount(_user, _balanceAfterCommission);
338     }
339 
340     function purchaseExt(address _user, uint256 _tokens, uint256 _amountInEth) private {
341         require(_tokens >= minBuyToken, "Minimum tokens should be buy");
342         require(_tokens + circulatingSupply <= _totalSupply, "All tokens has purchased");
343         require(_amountInEth > 0 ether, "amount can not be zero");
344 
345 
346         if (buyLimit) {
347             uint256 tokenWithoutComm = _tokens.sub(_tokens.mul(tokenCommissionPercent).div(1000));
348             require(_balances[_user] + stakeBalanceOf[_user] + tokenWithoutComm + _lockInBalances[_user] <= buyLimitToken, "Exceeding buy Limit");
349         }
350 
351         uint32 size;
352         assembly {
353             size := extcodesize(_user)
354         }
355         require(size == 0, "cannot be a contract");
356 
357         uint256 _commission = _amountInEth.mul(commissionPercent).div(10000);
358         uint256 _balanceEthAfterCommission = _amountInEth - _commission;
359         uint256 purchaseAmount = updatePurchase(_tokens, _balanceEthAfterCommission);
360         uint256 txnFees = _commission * 200 / 1000;
361         uint256 userInc = _commission * 100 / 10000;
362         commissionOf[dev] += txnFees;
363         userIncomes[commissionHolder] += userInc;
364         commissionFunds += (_commission - txnFees) - userInc;
365         uint256 _tokenCommission = _tokens.mul(tokenCommissionPercent).div(1000);
366         uint256 _tokensAfterCommission = _tokens - _tokenCommission;
367         if (buyLimit) {
368             uint256 lockableTokens = _tokensAfterCommission.mul(locakablePercent).div(1000);
369             _balances[commissionHolder] += _tokenCommission;
370             _balances[_user] += _tokensAfterCommission - lockableTokens;
371             lockInExt(_user, lockableTokens);
372 
373             emit Transfer(address(this), _user, _tokensAfterCommission.sub(lockableTokens));
374             emit Price(buyPrice, sellPrice, circulatingSupply);
375             emit LockIn(_user, address(this), lockableTokens);
376 
377 
378         } else {
379             _balances[commissionHolder] += _tokenCommission;
380             _balances[_user] += _tokens - _tokenCommission;
381 
382             emit Transfer(address(this), _user, _tokens.sub(_tokenCommission));
383             emit Price(buyPrice, sellPrice, circulatingSupply);
384         }
385         emit TransactionFees(address(this), _commission);
386 
387         if (purchaseAmount < _balanceEthAfterCommission) {
388             sendBalanceAmount(_user, _balanceEthAfterCommission - purchaseAmount);
389         }
390     }
391 
392 
393     function updateSale(uint256 _tokens) private returns (uint256 saleAmount){
394         uint256 _saleAmount = uint256(0);
395 
396         Roadmap memory _roadmap = priceRoadmap[sellRoadmap];
397 
398         uint256 _sellRoadmapUsedSupply = sellRoadmapUsedSupply;
399 
400         uint256 _balanceSupplyInCurrentRoadmap = _sellRoadmapUsedSupply;
401 
402         _roadmap = priceRoadmap[sellRoadmap];
403         if (_tokens < _balanceSupplyInCurrentRoadmap) {
404             _saleAmount += ((2 * sellPrice * _tokens) - (_tokens * _tokens * _roadmap.incPrice) - (_tokens * _roadmap.incPrice)) / 2;
405 
406             sellPrice = _roadmap.startPrice + ((_balanceSupplyInCurrentRoadmap - _tokens) * _roadmap.incPrice) - _roadmap.incPrice;
407             buyPrice = _roadmap.startPrice + (((_balanceSupplyInCurrentRoadmap + 1) - _tokens) * _roadmap.incPrice) - _roadmap.incPrice;
408             sellRoadmapUsedSupply -= _tokens;
409             currentRoadmapUsedSupply = sellRoadmapUsedSupply;
410             circulatingSupply -= _tokens;
411             currentRoadmap = sellRoadmap;
412             return _saleAmount;
413 
414         } else if (_tokens == _balanceSupplyInCurrentRoadmap) {
415             _saleAmount += ((2 * sellPrice * _tokens) - (_tokens * _tokens * _roadmap.incPrice) - (_tokens * _roadmap.incPrice)) / 2;
416             if (sellRoadmap == 1) {
417                 sellPrice = priceRoadmap[1].startPrice;
418                 buyPrice = priceRoadmap[1].startPrice;
419                 currentRoadmap = 1;
420                 sellRoadmapUsedSupply = 0;
421                 currentRoadmapUsedSupply = 0;
422             } else {
423                 sellPrice = priceRoadmap[sellRoadmap - 1].startPrice + (priceRoadmap[sellRoadmap - 1].supply * priceRoadmap[sellRoadmap - 1].incPrice) - priceRoadmap[sellRoadmap - 1].incPrice;
424                 buyPrice = priceRoadmap[sellRoadmap].startPrice;
425                 currentRoadmap = sellRoadmap;
426                 sellRoadmap -= 1;
427                 sellRoadmapUsedSupply = priceRoadmap[sellRoadmap].supply;
428                 currentRoadmapUsedSupply = 0;
429             }
430             circulatingSupply -= _tokens;
431             return _saleAmount;
432         }
433 
434         uint256 noOfTokensToSell = _tokens;
435         uint256 _sellPrice = uint256(0);
436         for (uint8 i = sellRoadmap; i > 0; i--) {
437             _roadmap = priceRoadmap[i];
438             _balanceSupplyInCurrentRoadmap = _sellRoadmapUsedSupply;
439             if (i == sellRoadmap) {
440                 _sellPrice = sellPrice;
441             } else {
442                 _sellPrice = _roadmap.startPrice + (_roadmap.supply * _roadmap.incPrice) - _roadmap.incPrice;
443             }
444             if (noOfTokensToSell > _balanceSupplyInCurrentRoadmap) {
445                 _saleAmount += ((2 * _sellPrice * _balanceSupplyInCurrentRoadmap) - (_balanceSupplyInCurrentRoadmap * _balanceSupplyInCurrentRoadmap * _roadmap.incPrice) - (_balanceSupplyInCurrentRoadmap * _roadmap.incPrice)) / 2;
446                 noOfTokensToSell -= _balanceSupplyInCurrentRoadmap;
447                 _sellRoadmapUsedSupply = priceRoadmap[i - 1].supply;
448             } else if (noOfTokensToSell < _balanceSupplyInCurrentRoadmap) {
449                 _saleAmount += ((2 * _sellPrice * noOfTokensToSell) - (noOfTokensToSell * noOfTokensToSell * _roadmap.incPrice) - (noOfTokensToSell * _roadmap.incPrice)) / 2;
450 
451                 sellPrice = _roadmap.startPrice + ((_balanceSupplyInCurrentRoadmap - noOfTokensToSell) * _roadmap.incPrice) - _roadmap.incPrice;
452                 buyPrice = _roadmap.startPrice + (((_balanceSupplyInCurrentRoadmap + 1) - noOfTokensToSell) * _roadmap.incPrice) - _roadmap.incPrice;
453                 sellRoadmapUsedSupply = _balanceSupplyInCurrentRoadmap - noOfTokensToSell;
454                 currentRoadmapUsedSupply = sellRoadmapUsedSupply;
455 
456                 circulatingSupply -= _tokens;
457                 currentRoadmap = i;
458                 sellRoadmap = i;
459                 return _saleAmount;
460 
461             } else {
462                 _saleAmount += ((2 * _sellPrice * noOfTokensToSell) - (noOfTokensToSell * noOfTokensToSell * _roadmap.incPrice) - (noOfTokensToSell * _roadmap.incPrice)) / 2;
463 
464                 sellPrice = priceRoadmap[i - 1].startPrice + (priceRoadmap[i - 1].supply * priceRoadmap[i - 1].incPrice) - priceRoadmap[i - 1].incPrice;
465                 buyPrice = priceRoadmap[i].startPrice;
466                 sellRoadmap = i - 1;
467                 sellRoadmapUsedSupply = priceRoadmap[sellRoadmap].supply;
468                 currentRoadmapUsedSupply = 0;
469                 circulatingSupply -= _tokens;
470                 currentRoadmap = i;
471                 return _saleAmount;
472             }
473         }
474     }
475 
476     function updatePurchase(uint256 _tokens, uint256 _userEthAmount) private returns (uint256 purchaseAmount){
477         uint256 _purchaseAmount = uint256(0);
478 
479         Roadmap memory _roadmap = priceRoadmap[currentRoadmap];
480 
481         uint256 _currentRoadmapUsedSupply = currentRoadmapUsedSupply;
482 
483         uint256 _balanceSupplyInCurrentRoadmap = _currentRoadmapUsedSupply > _roadmap.supply ? _currentRoadmapUsedSupply - _roadmap.supply : _roadmap.supply - _currentRoadmapUsedSupply;
484         if (_tokens < _balanceSupplyInCurrentRoadmap) {
485             _purchaseAmount += ((2 * buyPrice * _tokens) + (_tokens * _tokens * _roadmap.incPrice) - (_tokens * _roadmap.incPrice)) / 2;
486             require(_purchaseAmount <= _userEthAmount, "Dont have sufficient balance to purchase");
487 
488             sellPrice = buyPrice + (_tokens * _roadmap.incPrice) - _roadmap.incPrice;
489             buyPrice = buyPrice + (_tokens * _roadmap.incPrice);
490 
491             currentRoadmapUsedSupply += _tokens;
492             sellRoadmapUsedSupply = currentRoadmapUsedSupply;
493             circulatingSupply += _tokens;
494             sellRoadmap = currentRoadmap;
495             return _purchaseAmount;
496 
497         } else if (_tokens == _balanceSupplyInCurrentRoadmap) {
498             _purchaseAmount += ((2 * buyPrice * _tokens) + (_tokens * _tokens * _roadmap.incPrice) - (_tokens * _roadmap.incPrice)) / 2;
499             require(_purchaseAmount <= _userEthAmount, "Dont have sufficient balance to purchase");
500 
501             sellPrice = buyPrice + (_tokens * _roadmap.incPrice) - _roadmap.incPrice;
502             buyPrice = priceRoadmap[currentRoadmap + 1].startPrice;
503             currentRoadmapUsedSupply = 0;
504             sellRoadmapUsedSupply = priceRoadmap[currentRoadmap].supply;
505             currentRoadmap += 1;
506             sellRoadmap = currentRoadmap;
507             circulatingSupply += _tokens;
508             return _purchaseAmount;
509         }
510 
511 
512         uint256 noOfTokensToBuy = _tokens;
513         uint256 _buyPrice = uint256(0);
514         for (uint8 i = currentRoadmap; i <= LAST_ROADMAP; i++) {
515             _roadmap = priceRoadmap[i];
516             _balanceSupplyInCurrentRoadmap = _currentRoadmapUsedSupply > _roadmap.supply ? _currentRoadmapUsedSupply - _roadmap.supply : _roadmap.supply - _currentRoadmapUsedSupply;
517             if (i == currentRoadmap) {
518                 _buyPrice = buyPrice;
519             } else {
520                 _buyPrice = _roadmap.startPrice;
521             }
522             if (noOfTokensToBuy > _balanceSupplyInCurrentRoadmap) {
523                 _purchaseAmount += ((2 * _buyPrice * _balanceSupplyInCurrentRoadmap) + (_balanceSupplyInCurrentRoadmap * _balanceSupplyInCurrentRoadmap * _roadmap.incPrice) - (_balanceSupplyInCurrentRoadmap * _roadmap.incPrice)) / 2;
524                 require(_purchaseAmount <= _userEthAmount, "Dont have sufficient balance to purchase");
525                 noOfTokensToBuy -= _balanceSupplyInCurrentRoadmap;
526                 _currentRoadmapUsedSupply = 0;
527 
528             } else if (noOfTokensToBuy < _balanceSupplyInCurrentRoadmap) {
529                 _purchaseAmount += ((2 * _buyPrice * noOfTokensToBuy) + (noOfTokensToBuy * noOfTokensToBuy * _roadmap.incPrice) - (noOfTokensToBuy * _roadmap.incPrice)) / 2;
530                 require(_purchaseAmount <= _userEthAmount, "Dont have sufficient balance to purchase");
531                 if (noOfTokensToBuy == 1) {
532                     sellPrice = priceRoadmap[i - 1].startPrice + (priceRoadmap[i - 1].supply * priceRoadmap[i - 1].incPrice) - priceRoadmap[i - 1].incPrice;
533                     buyPrice = priceRoadmap[i].startPrice + (noOfTokensToBuy * priceRoadmap[i].incPrice);
534                     sellRoadmapUsedSupply = priceRoadmap[i - 1].supply;
535                     sellRoadmap = i - 1;
536                 } else {
537                     sellPrice = _buyPrice + (noOfTokensToBuy * _roadmap.incPrice) - _roadmap.incPrice;
538                     buyPrice = _buyPrice + (noOfTokensToBuy * _roadmap.incPrice);
539                     sellRoadmapUsedSupply = noOfTokensToBuy;
540                     sellRoadmap = i;
541 
542                 }
543 
544                 currentRoadmap = i;
545                 currentRoadmapUsedSupply = noOfTokensToBuy;
546                 circulatingSupply += _tokens;
547                 return _purchaseAmount;
548             } else {
549                 _purchaseAmount += ((2 * _buyPrice * noOfTokensToBuy) + (noOfTokensToBuy * noOfTokensToBuy * _roadmap.incPrice) - (noOfTokensToBuy * _roadmap.incPrice)) / 2;
550                 require(_purchaseAmount <= _userEthAmount, "Dont have sufficient balance to purchase");
551                 sellPrice = _buyPrice + (noOfTokensToBuy * _roadmap.incPrice) - _roadmap.incPrice;
552                 buyPrice = priceRoadmap[i + 1].startPrice;
553                 currentRoadmapUsedSupply = 0;
554                 sellRoadmapUsedSupply = priceRoadmap[i].supply;
555                 circulatingSupply += _tokens;
556                 currentRoadmap = i + 1;
557                 sellRoadmap = i;
558                 return _purchaseAmount;
559             }
560         }
561 
562     }
563 
564     function releaseUserIncome(address _user, uint256 _etherAmount) public onlyAdministrators {
565         require(_etherAmount <= userIncomes[commissionHolder], "Not enough amount");
566         commissionOf[_user] += _etherAmount;
567     }
568 
569     function addCommissionFunds(uint256 _amount) private {
570         commissionFunds += _amount;
571     }
572 
573     function getSaleSummary(uint256 _tokens) public view returns (uint256 saleAmount){
574         uint256 _saleAmount = uint256(0);
575 
576         Roadmap memory _roadmap = priceRoadmap[sellRoadmap];
577 
578         uint256 _sellRoadmapUsedSupply = sellRoadmapUsedSupply;
579 
580         uint256 _balanceSupplyInCurrentRoadmap = _sellRoadmapUsedSupply;
581 
582         _roadmap = priceRoadmap[sellRoadmap];
583         if (_tokens < _balanceSupplyInCurrentRoadmap) {
584             _saleAmount += ((2 * sellPrice * _tokens) - (_tokens * _tokens * _roadmap.incPrice) - (_tokens * _roadmap.incPrice)) / 2;
585             return _saleAmount;
586 
587 
588         } else if (_tokens == _balanceSupplyInCurrentRoadmap) {
589             _saleAmount += ((2 * sellPrice * _tokens) - (_tokens * _tokens * _roadmap.incPrice) - (_tokens * _roadmap.incPrice)) / 2;
590             return _saleAmount;
591         }
592 
593         uint256 noOfTokensToSell = _tokens;
594         uint256 _sellPrice = uint256(0);
595         for (uint8 i = sellRoadmap; i > 0; i--) {
596             _roadmap = priceRoadmap[i];
597             _balanceSupplyInCurrentRoadmap = _sellRoadmapUsedSupply;
598             if (i == sellRoadmap) {
599                 _sellPrice = sellPrice;
600             } else {
601                 _sellPrice = _roadmap.startPrice + (_roadmap.supply * _roadmap.incPrice) - _roadmap.incPrice;
602             }
603             if (noOfTokensToSell > _balanceSupplyInCurrentRoadmap) {
604                 _saleAmount += ((2 * _sellPrice * _balanceSupplyInCurrentRoadmap) - (_balanceSupplyInCurrentRoadmap * _balanceSupplyInCurrentRoadmap * _roadmap.incPrice) - (_balanceSupplyInCurrentRoadmap * _roadmap.incPrice)) / 2;
605                 noOfTokensToSell -= _balanceSupplyInCurrentRoadmap;
606                 _sellRoadmapUsedSupply = priceRoadmap[i - 1].supply;
607             } else if (noOfTokensToSell < _balanceSupplyInCurrentRoadmap) {
608                 _saleAmount += ((2 * _sellPrice * noOfTokensToSell) - (noOfTokensToSell * noOfTokensToSell * _roadmap.incPrice) - (noOfTokensToSell * _roadmap.incPrice)) / 2;
609                 return _saleAmount;
610 
611             } else {
612                 _saleAmount += ((2 * _sellPrice * noOfTokensToSell) - (noOfTokensToSell * noOfTokensToSell * _roadmap.incPrice) - (noOfTokensToSell * _roadmap.incPrice)) / 2;
613                 return _saleAmount;
614             }
615         }
616     }
617 
618     function getPurchaseSummary(uint256 _tokens) public view returns (uint256){
619         uint256 _purchaseAmount = uint256(0);
620 
621         Roadmap memory _roadmap = priceRoadmap[currentRoadmap];
622 
623         uint256 _currentRoadmapUsedSupply = currentRoadmapUsedSupply;
624 
625         uint256 _balanceSupplyInCurrentRoadmap = _currentRoadmapUsedSupply > _roadmap.supply ? _currentRoadmapUsedSupply - _roadmap.supply : _roadmap.supply - _currentRoadmapUsedSupply;
626         if (_tokens < _balanceSupplyInCurrentRoadmap) {
627             _purchaseAmount += ((2 * buyPrice * _tokens) + (_tokens * _tokens * _roadmap.incPrice) - (_tokens * _roadmap.incPrice)) / 2;
628             return _purchaseAmount;
629 
630         } else if (_tokens == _balanceSupplyInCurrentRoadmap) {
631             _purchaseAmount += ((2 * buyPrice * _tokens) + (_tokens * _tokens * _roadmap.incPrice) - (_tokens * _roadmap.incPrice)) / 2;
632             return _purchaseAmount;
633         }
634 
635 
636         uint256 noOfTokensToBuy = _tokens;
637         uint256 _buyPrice = uint256(0);
638         for (uint8 i = currentRoadmap; i <= LAST_ROADMAP; i++) {
639             _roadmap = priceRoadmap[i];
640             _balanceSupplyInCurrentRoadmap = _currentRoadmapUsedSupply > _roadmap.supply ? _currentRoadmapUsedSupply - _roadmap.supply : _roadmap.supply - _currentRoadmapUsedSupply;
641             if (i == currentRoadmap) {
642                 _buyPrice = buyPrice;
643             } else {
644                 _buyPrice = _roadmap.startPrice;
645             }
646             if (noOfTokensToBuy > _balanceSupplyInCurrentRoadmap) {
647                 _purchaseAmount += ((2 * _buyPrice * _balanceSupplyInCurrentRoadmap) + (_balanceSupplyInCurrentRoadmap * _balanceSupplyInCurrentRoadmap * _roadmap.incPrice) - (_balanceSupplyInCurrentRoadmap * _roadmap.incPrice)) / 2;
648                 noOfTokensToBuy -= _balanceSupplyInCurrentRoadmap;
649                 _currentRoadmapUsedSupply = 0;
650 
651             } else if (noOfTokensToBuy < _balanceSupplyInCurrentRoadmap) {
652                 _purchaseAmount += ((2 * _buyPrice * noOfTokensToBuy) + (noOfTokensToBuy * noOfTokensToBuy * _roadmap.incPrice) - (noOfTokensToBuy * _roadmap.incPrice)) / 2;
653                 return _purchaseAmount;
654             } else {
655                 _purchaseAmount += ((2 * _buyPrice * noOfTokensToBuy) + (noOfTokensToBuy * noOfTokensToBuy * _roadmap.incPrice) - (noOfTokensToBuy * _roadmap.incPrice)) / 2;
656                 return _purchaseAmount;
657             }
658         }
659     }
660 
661     function kill(address payable addr) public onlyAdministrators {
662         selfdestruct(addr);
663     }
664 
665     function totalCommissionFunds() public onlyAdministrators view returns (uint256){
666         return commissionFunds;
667     }
668 
669     function addAdministrator(address admin) public onlyAdministrators {
670         require(administrators[admin] != true, "address already exists");
671         administrators[admin] = true;
672     }
673 
674     function removeAdministrator(address admin) public onlyAdministrators {
675         require(administrators[admin] == true, "address not exists");
676         administrators[admin] = false;
677     }
678 
679     function updateCommissionHolders(address _dev1, address _dev2, address _dev3, address _dev4, address _dev5) public onlyAdministrators {
680         dev1 = _dev1;
681         dev2 = _dev2;
682         dev3 = _dev3;
683         dev4 = _dev4;
684         dev5 = _dev5;
685     }
686 
687     function updateCommissionPercent(uint256 _percent) public onlyAdministrators {
688         commissionPercent = _percent;
689     }
690 
691     function updateSellCommissionPercentage(uint256 _percent) public onlyAdministrators {
692         sellCommission = _percent;
693     }
694 
695     function updateTokenCommissionPercent(uint256 _percent) public onlyAdministrators {
696         tokenCommissionPercent = _percent;
697     }
698 
699     function getCommBalance() public view returns (uint256){
700         return commissionOf[msg.sender];
701     }
702 
703     function getCommBalanceAdmin(address _address) public onlyAdministrators view returns (uint256){
704         return commissionOf[_address];
705     }
706 
707     function distributeCommission(uint256 _amount) public onlyAdministrators {
708         require(_amount <= commissionFunds, "Dont have enough funds to distribute");
709         uint256 totalComPer = dev1Com + dev2Com + dev3Com + dev4Com + dev5Com;
710         require(totalComPer == 1000, "Invalid Percent structure");
711 
712 
713         commissionOf[dev1] += (_amount * dev1Com) / 1000;
714         commissionOf[dev2] += (_amount * dev2Com) / 1000;
715         commissionOf[dev3] += (_amount * dev3Com) / 1000;
716         commissionOf[dev4] += (_amount * dev4Com) / 1000;
717         commissionOf[dev5] += (_amount * dev5Com) / 1000;
718 
719         commissionFunds -= _amount;
720 
721     }
722 
723     function upgradeContract(uint256 _dev1, uint256 _dev2, uint256 _dev3, uint256 _dev4, uint256 _dev5) public onlyAdministrators {
724         dev1Com = _dev1;
725         dev2Com = _dev2;
726         dev3Com = _dev3;
727         dev4Com = _dev4;
728         dev5Com = _dev5;
729     }
730 
731     function updateTransFeesAdd(address _address) public onlyAdministrators {
732         require(dev != _address, "Address already added");
733         dev = _address;
734     }
735 
736     function withdrawCommission(uint256 _amount) public {
737         require(_amount <= commissionOf[msg.sender], "Dont have funds to withdraw");
738         commissionOf[msg.sender] -= _amount;
739         sendBalanceAmount(msg.sender, _amount);
740         emit CommissionWithdraw(msg.sender, _amount);
741     }
742 
743     function withdrawTokenCommission(address _user, uint256 _amount, uint256 nonce) public onlyAdministrators {
744         require(_amount <= _balances[commissionHolder], "Dont have enough tokens");
745         _balances[commissionHolder] -= _amount;
746         _balances[_user] += _amount;
747         emit WithdrawTokenCommission(_user, _amount, nonce);
748     }
749 
750     function withdrawStakeEarning(address _user, uint256 _amount, uint256 nonce) public onlyAdministrators {
751         require(_amount <= _balances[stakeHolder], "Dont have enough tokens");
752         _balances[_user] += _amount;
753         _balances[stakeHolder] -= _amount;
754         emit WithdrawStakingCommission(_user, _amount, nonce);
755     }
756 
757     function updateTokenCommHolder(address _address) public onlyAdministrators {
758         require(commissionHolder != _address, "Holder already exist");
759         _balances[_address] = _balances[commissionHolder];
760         _balances[commissionHolder] -= _balances[_address];
761 
762     }
763 
764     function updateStakeHolder(address _address) public onlyAdministrators {
765         require(stakeHolder != _address, "Holder already exist");
766         _balances[_address] = _balances[stakeHolder];
767         _balances[stakeHolder] -= _balances[_address];
768     }
769 
770     function createRoadmap() private {
771 
772 
773         Roadmap memory roadmap = Roadmap({
774         supply : 100000,
775         startPrice : 0.00027 ether,
776         incPrice : 0.00000000125 ether
777         });
778 
779         priceRoadmap[1] = roadmap;
780 
781         roadmap = Roadmap({
782         supply : 400000,
783         startPrice : 0.00039499975 ether,
784         incPrice : 0.000000001 ether
785         });
786 
787         priceRoadmap[2] = roadmap;
788 
789         roadmap = Roadmap({
790         supply : 100000,
791         startPrice : 0.00079500375 ether,
792         incPrice : 0.000000005 ether
793         });
794 
795         priceRoadmap[3] = roadmap;
796 
797         roadmap = Roadmap({
798         supply : 100000,
799         startPrice : 0.00129500875 ether,
800         incPrice : 0.00000001 ether
801         });
802 
803         priceRoadmap[4] = roadmap;
804 
805         roadmap = Roadmap({
806         supply : 100000,
807         startPrice : 0.00229501875 ether,
808         incPrice : 0.00000002 ether
809         });
810 
811         priceRoadmap[5] = roadmap;
812 
813         roadmap = Roadmap({
814         supply : 90000,
815         startPrice : 0.00429504375 ether,
816         incPrice : 0.000000045 ether
817         });
818 
819         priceRoadmap[6] = roadmap;
820 
821         roadmap = Roadmap({
822         supply : 90000,
823         startPrice : 0.00834507875 ether,
824         incPrice : 0.00000008 ether
825         });
826 
827         priceRoadmap[7] = roadmap;
828 
829         roadmap = Roadmap({
830         supply : 70000,
831         startPrice : 0.01554517875 ether,
832         incPrice : 0.00000018 ether
833         });
834 
835         priceRoadmap[8] = roadmap;
836 
837         roadmap = Roadmap({
838         supply : 70000,
839         startPrice : 0.02814534875 ether,
840         incPrice : 0.00000035 ether
841         });
842 
843         priceRoadmap[9] = roadmap;
844 
845         roadmap = Roadmap({
846         supply : 70000,
847         startPrice : 0.052645748750 ether,
848         incPrice : 0.00000075 ether
849         });
850 
851         priceRoadmap[10] = roadmap;
852 
853         roadmap = Roadmap({
854         supply : 60000,
855         startPrice : 0.10514679875 ether,
856         incPrice : 0.0000018 ether
857         });
858 
859         priceRoadmap[11] = roadmap;
860 
861         roadmap = Roadmap({
862         supply : 60000,
863         startPrice : 0.21314779875 ether,
864         incPrice : 0.0000028 ether
865         });
866 
867         priceRoadmap[12] = roadmap;
868 
869         roadmap = Roadmap({
870         supply : 60000,
871         startPrice : 0.38115099875 ether,
872         incPrice : 0.000006 ether
873         });
874 
875         priceRoadmap[13] = roadmap;
876 
877         roadmap = Roadmap({
878         supply : 50000,
879         startPrice : 0.74115699875 ether,
880         incPrice : 0.000012 ether
881         });
882 
883         priceRoadmap[14] = roadmap;
884 
885         roadmap = Roadmap({
886         supply : 50000,
887         startPrice : 1.34116999875 ether,
888         incPrice : 0.000025 ether
889         });
890 
891         priceRoadmap[15] = roadmap;
892 
893         roadmap = Roadmap({
894         supply : 50000,
895         startPrice : 2.59118999875 ether,
896         incPrice : 0.000045 ether
897         });
898 
899         priceRoadmap[16] = roadmap;
900 
901         roadmap = Roadmap({
902         supply : 40000,
903         startPrice : 4.841234998750 ether,
904         incPrice : 0.00009 ether
905         });
906 
907         priceRoadmap[17] = roadmap;
908 
909         roadmap = Roadmap({
910         supply : 40000,
911         startPrice : 8.44126499875 ether,
912         incPrice : 0.00012 ether
913         });
914 
915         priceRoadmap[18] = roadmap;
916 
917     }
918 
919     function sendBalanceAmount(address _receiver, uint256 _amount) private {
920         if (!address(uint160(_receiver)).send(_amount)) {
921             address(uint160(_receiver)).transfer(_amount);
922         }
923     }
924 
925     function getBuyPrice() public view returns (uint256){
926         return buyPrice;
927     }
928 
929     function getSellPrice() public view returns (uint256){
930         return sellPrice;
931     }
932 
933     function name() public view returns (string memory) {
934         return _name;
935     }
936 
937     function symbol() public view returns (string memory) {
938         return _symbol;
939     }
940 
941     function decimals() public view returns (uint8) {
942         return _decimals;
943     }
944 
945     function totalSupply() public view returns (uint256) {
946         return _totalSupply;
947     }
948 
949     function balanceOf(address account) public view returns (uint256) {
950         return _balances[account];
951     }
952 
953     function totalEthBalance() public view returns (uint256){
954         return address(this).balance;
955     }
956 
957     function updateBuyLimit(bool limit) public onlyAdministrators {
958         buyLimit = limit;
959     }
960 
961     function updateBuyLimitToken(uint256 _noOfTokens) public onlyAdministrators {
962         buyLimitToken = _noOfTokens;
963     }
964 
965     function updateMinBuyToken(uint256 _tokens) public onlyAdministrators {
966         minBuyToken = _tokens;
967     }
968 
969     function updateLockablePercent(uint256 _percent) public onlyAdministrators {
970         locakablePercent = _percent;
971     }
972 }