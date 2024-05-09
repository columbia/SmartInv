1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.16;
4 
5 /******************************************/
6 /*           IERC20 starts here           */
7 /******************************************/
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Emitted when `value` tokens are moved from one account (`from`) to
15      * another (`to`).
16      *
17      * Note that `value` may be zero.
18      */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /**
22      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
23      * a call to {approve}. `value` is the new allowance.
24      */
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `to`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address to, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `from` to `to` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(address from, address to, uint256 amount) external returns (bool);
81 }
82 
83 /******************************************/
84 /*           Context starts here          */
85 /******************************************/
86 
87 /**
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         return msg.data;
104     }
105 }
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * The initial owner is set to the address provided by the deployer. This can
113  * later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     /**
123      * @dev The caller account is not authorized to perform an operation.
124      */
125     error OwnableUnauthorizedAccount(address account);
126 
127     /**
128      * @dev The owner is not a valid owner account. (eg. `address(0)`)
129      */
130     error OwnableInvalidOwner(address owner);
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134     /**
135      * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
136      */
137     constructor(address initialOwner) {
138         _transferOwnership(initialOwner);
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         _checkOwner();
146         _;
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view virtual returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if the sender is not the owner.
158      */
159     function _checkOwner() internal view virtual {
160         if (owner() != _msgSender()) {
161             revert OwnableUnauthorizedAccount(_msgSender());
162         }
163     }
164 
165     /**
166      * @dev Leaves the contract without owner. It will not be possible to call
167      * `onlyOwner` functions. Can only be called by the current owner.
168      *
169      * NOTE: Renouncing ownership will leave the contract without an owner,
170      * thereby disabling any functionality that is only available to the owner.
171      */
172     function renounceOwnership() public virtual onlyOwner {
173         _transferOwnership(address(0));
174     }
175 
176     /**
177      * @dev Transfers ownership of the contract to a new account (`newOwner`).
178      * Can only be called by the current owner.
179      */
180     function transferOwnership(address newOwner) public virtual onlyOwner {
181         if (newOwner == address(0)) {
182             revert OwnableInvalidOwner(address(0));
183         }
184         _transferOwnership(newOwner);
185     }
186 
187     /**
188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
189      * Internal function without access restriction.
190      */
191     function _transferOwnership(address newOwner) internal virtual {
192         address oldOwner = _owner;
193         _owner = newOwner;
194         emit OwnershipTransferred(oldOwner, newOwner);
195     }
196 }
197 
198 /******************************************/
199 /*     IUniswapV2Router02 starts here     */
200 /******************************************/
201 
202 interface IUniswapV2Router02 {
203     function factory() external pure returns (address);
204 
205     function WETH() external pure returns (address);
206 
207     function swapExactTokensForETHSupportingFeeOnTransferTokens(
208         uint256 amountIn,
209         uint256 amountOutMin,
210         address[] calldata path,
211         address to,
212         uint256 deadline
213     ) external;
214 }
215 
216 /******************************************/
217 /*      IUniswapV2Factory starts here     */
218 /******************************************/
219 
220 interface IUniswapV2Factory {
221     function createPair(address tokenA, address tokenB) external returns (address UNISWAP_V2_PAIR);
222 }
223 
224 /******************************************/
225 /*          FullMoon starts here          */
226 /******************************************/
227 
228 contract FullMoon is IERC20, Ownable {
229     
230     // EVENTS
231     event Reflect(uint256 amountReflected, uint256 newTotalProportion);
232 
233     // CONSTANTS
234     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
235     address constant ZERO = 0x0000000000000000000000000000000000000000;
236 
237     uint256 constant MAX_FEE = 10;
238 
239     // STATES
240     IUniswapV2Router02 public constant UNISWAP_V2_ROUTER =
241         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
242     address public immutable UNISWAP_V2_PAIR;
243 
244     struct Fee {
245         uint8 reflection;
246         uint8 marketing;
247         uint8 lp;
248         uint8 buyback;
249         uint8 burn;
250         uint128 total;
251     }
252 
253     string _name = "FullMoon";
254     string _symbol = "FULLMOON";
255 
256     uint256 _totalSupply = 1_000_000_000 ether;
257     uint256 public _maxTxAmount = _totalSupply * 2 / 100;
258 
259     /* rOwned = ratio of tokens owned relative to circulating supply (NOT total supply, since circulating <= total) */
260     mapping(address => uint256) public _rOwned;
261     uint256 public _totalProportion = _totalSupply;
262 
263     mapping(address => mapping(address => uint256)) _allowances;
264 
265     bool public limitsEnabled = true;
266     mapping(address => bool) isFeeExempt;
267     mapping(address => bool) isTxLimitExempt;
268 
269     Fee public buyFee = Fee({reflection: 1, marketing: 1, lp: 1, buyback: 1, burn: 1, total: 5});
270     Fee public sellFee = Fee({reflection: 1, marketing: 1, lp: 1, buyback: 1, burn: 1, total: 5});
271 
272     address private marketingFeeReceiver;
273     address private lpFeeReceiver;
274     address private buybackFeeReceiver;
275 
276     bool public claimingFees = true;
277     uint256 public swapThreshold = (_totalSupply * 2) / 1000;
278     bool inSwap;
279     mapping(address => bool) public blacklists;
280 
281     // MODIFIERS
282     modifier swapping() {
283         inSwap = true;
284         _;
285         inSwap = false;
286     }
287 
288     // CONSTRUCTOR
289     constructor() Ownable(msg.sender) {
290         // create uniswap pair
291         address _uniswapPair =
292             IUniswapV2Factory(UNISWAP_V2_ROUTER.factory()).createPair(address(this), UNISWAP_V2_ROUTER.WETH());
293         UNISWAP_V2_PAIR = _uniswapPair;
294 
295         _allowances[address(this)][address(UNISWAP_V2_ROUTER)] = type(uint256).max;
296         _allowances[address(this)][tx.origin] = type(uint256).max;
297 
298         isTxLimitExempt[address(this)] = true;
299         isTxLimitExempt[address(UNISWAP_V2_ROUTER)] = true;
300         isTxLimitExempt[_uniswapPair] = true;
301         isTxLimitExempt[tx.origin] = true;
302         isFeeExempt[tx.origin] = true;
303 
304         marketingFeeReceiver = 0xc9840c5B817b42a2295A78211DC296D5d88D4F05;
305         lpFeeReceiver = 0xcBA568D9c69c4b50D9D12B5c4a9Abb66091af803;
306         buybackFeeReceiver = 0xaeCe8CBfdeBd00b49975F96B665264860C7B03E3;
307 
308         _rOwned[tx.origin] = _totalSupply;
309         emit Transfer(address(0), tx.origin, _totalSupply);
310     }
311 
312     receive() external payable {}
313 
314 /******************************************/
315 /*           ERC20 starts here            */
316 /******************************************/
317 
318     function approve(address spender, uint256 amount) public override returns (bool) {
319         _allowances[msg.sender][spender] = amount;
320         emit Approval(msg.sender, spender, amount);
321         return true;
322     }
323 
324     function approveMax(address spender) external returns (bool) {
325         return approve(spender, type(uint256).max);
326     }
327 
328     function transfer(address recipient, uint256 amount) external override returns (bool) {
329         return _transferFrom(msg.sender, recipient, amount);
330     }
331 
332     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
333         if (_allowances[sender][msg.sender] != type(uint256).max) {
334             require(_allowances[sender][msg.sender] >= amount, "ERC20: insufficient allowance");
335             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
336         }
337 
338         return _transferFrom(sender, recipient, amount);
339     }
340 
341 /******************************************/
342 /*            VIEW starts here            */
343 /******************************************/
344 
345     function totalSupply() external view override returns (uint256) {
346         return _totalSupply;
347     }
348 
349     function decimals() external pure returns (uint8) {
350         return 18;
351     }
352 
353     function name() external view returns (string memory) {
354         return _name;
355     }
356 
357     function symbol() external view returns (string memory) {
358         return _symbol;
359     }
360 
361     function balanceOf(address account) public view override returns (uint256) {
362         return tokenFromReflection(_rOwned[account]);
363     }
364 
365     function allowance(address holder, address spender) external view override returns (uint256) {
366         return _allowances[holder][spender];
367     }
368 
369     function tokensToProportion(uint256 tokens) public view returns (uint256) {
370         return tokens * _totalProportion / _totalSupply;
371     }
372 
373     function tokenFromReflection(uint256 proportion) public view returns (uint256) {
374         return proportion * _totalSupply / _totalProportion;
375     }
376 
377     function getCirculatingSupply() public view returns (uint256) {
378         return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);
379     }
380 
381 /******************************************/
382 /*           OWNER starts here            */
383 /******************************************/
384 
385     function clearStuckBalance() external onlyOwner {
386         (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
387         require(success);
388     }
389 
390     function clearStuckToken() external onlyOwner {
391         _transferFrom(address(this), msg.sender, balanceOf(address(this)));
392     }
393 
394     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
395         claimingFees = _enabled;
396         swapThreshold = _amount;
397     }
398 
399     function changeFees(
400         uint8 reflectionFeeBuy,
401         uint8 marketingFeeBuy,
402         uint8 lpFeeBuy,
403         uint8 buybackFeeBuy,
404         uint8 burnFeeBuy,
405         uint8 reflectionFeeSell,
406         uint8 marketingFeeSell,
407         uint8 lpFeeSell,
408         uint8 buybackFeeSell,
409         uint8 burnFeeSell
410     ) external onlyOwner {
411         uint128 __totalBuyFee = reflectionFeeBuy + marketingFeeBuy + lpFeeBuy + buybackFeeBuy + burnFeeBuy;
412         uint128 __totalSellFee = reflectionFeeSell + marketingFeeSell + lpFeeSell + buybackFeeSell + burnFeeSell;
413 
414         require(__totalBuyFee <= MAX_FEE, "Buy fees too high");
415         require(__totalSellFee <= MAX_FEE, "Sell fees too high");
416 
417         buyFee = Fee({
418             reflection: reflectionFeeBuy,
419             marketing: reflectionFeeBuy,
420             lp: reflectionFeeBuy,
421             buyback: reflectionFeeBuy,
422             burn: burnFeeBuy,
423             total: __totalBuyFee
424         });
425 
426         sellFee = Fee({
427             reflection: reflectionFeeSell,
428             marketing: reflectionFeeSell,
429             lp: reflectionFeeSell,
430             buyback: reflectionFeeSell,
431             burn: burnFeeSell,
432             total: __totalSellFee
433         });
434     }
435 
436     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
437         isFeeExempt[holder] = exempt;
438     }
439 
440     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
441         isTxLimitExempt[holder] = exempt;
442     }
443 
444     function setFeeReceivers(address m_, address lp_, address b_) external onlyOwner {
445         marketingFeeReceiver = m_;
446         lpFeeReceiver = lp_;
447         buybackFeeReceiver = b_;
448     }
449 
450     function setMaxTxBasisPoint(uint256 p_) external onlyOwner {
451         _maxTxAmount = _totalSupply * p_ / 10000;
452     }
453 
454     function setLimitsEnabled(bool e_) external onlyOwner {
455         limitsEnabled = e_;
456     }
457 
458     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
459         blacklists[_address] = _isBlacklisting;
460     }
461 
462 /******************************************/
463 /*           PRIVATE starts here          */
464 /******************************************/
465 
466     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
467         require(!blacklists[recipient] && !blacklists[sender], "Blacklisted");
468 
469         if (inSwap) {
470             return _basicTransfer(sender, recipient, amount);
471         }
472 
473         if (limitsEnabled && !isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
474             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
475         }
476 
477         if (_shouldSwapBack()) {
478             _swapBack();
479         }
480 
481         uint256 proportionAmount = tokensToProportion(amount);
482         require(_rOwned[sender] >= proportionAmount, "Insufficient Balance");
483         _rOwned[sender] = _rOwned[sender] - proportionAmount;
484 
485         uint256 proportionReceived = _shouldTakeFee(sender, recipient)
486             ? _takeFeeInProportions(sender == UNISWAP_V2_PAIR ? true : false, sender, proportionAmount)
487             : proportionAmount;
488         _rOwned[recipient] = _rOwned[recipient] + proportionReceived;
489 
490         emit Transfer(sender, recipient, tokenFromReflection(proportionReceived));
491         return true;
492     }
493 
494     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
495         uint256 proportionAmount = tokensToProportion(amount);
496         require(_rOwned[sender] >= proportionAmount, "Insufficient Balance");
497         _rOwned[sender] = _rOwned[sender] - proportionAmount;
498         _rOwned[recipient] = _rOwned[recipient] + proportionAmount;
499         emit Transfer(sender, recipient, amount);
500         return true;
501     }
502 
503     function _takeFeeInProportions(bool buying, address sender, uint256 proportionAmount) internal returns (uint256) {
504         Fee memory __buyFee = buyFee;
505         Fee memory __sellFee = sellFee;
506 
507         uint256 proportionFeeAmount =
508             buying == true ? proportionAmount * __buyFee.total / 100 : proportionAmount * __sellFee.total / 100;
509 
510         // reflect
511         uint256 proportionReflected = buying == true
512             ? proportionFeeAmount * __buyFee.reflection / __buyFee.total
513             : proportionFeeAmount * __sellFee.reflection / __sellFee.total;
514 
515         _totalProportion = _totalProportion - proportionReflected;
516 
517         // take fees
518         uint256 _proportionToContract = proportionFeeAmount - proportionReflected;
519         if (_proportionToContract > 0) {
520             _rOwned[address(this)] = _rOwned[address(this)] + _proportionToContract;
521 
522             emit Transfer(sender, address(this), tokenFromReflection(_proportionToContract));
523         }
524         emit Reflect(proportionReflected, _totalProportion);
525         return proportionAmount - proportionFeeAmount;
526     }
527 
528     function _shouldSwapBack() internal view returns (bool) {
529         return msg.sender != UNISWAP_V2_PAIR && !inSwap && claimingFees && balanceOf(address(this)) >= swapThreshold;
530     }
531 
532     function _swapBack() internal swapping {
533         Fee memory __sellFee = sellFee;
534 
535         uint256 __swapThreshold = swapThreshold;
536         uint256 amountToBurn = __swapThreshold * __sellFee.burn / __sellFee.total;
537         uint256 amountToSwap = __swapThreshold - amountToBurn;
538         approve(address(UNISWAP_V2_ROUTER), amountToSwap);
539 
540         // burn
541         _transferFrom(address(this), DEAD, amountToBurn);
542 
543         // swap
544         address[] memory path = new address[](2);
545         path[0] = address(this);
546         path[1] = UNISWAP_V2_ROUTER.WETH();
547 
548         UNISWAP_V2_ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(
549             amountToSwap, 0, path, address(this), block.timestamp
550         );
551 
552         uint256 amountETH = address(this).balance;
553 
554         uint256 totalSwapFee = __sellFee.total - __sellFee.reflection - __sellFee.burn;
555         uint256 amountETHMarketing = amountETH * __sellFee.marketing / totalSwapFee;
556         uint256 amountETHLP = amountETH * __sellFee.lp / totalSwapFee;
557         uint256 amountETHBuyback = amountETH * __sellFee.buyback / totalSwapFee;
558 
559         // send
560         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
561         (tmpSuccess,) = payable(lpFeeReceiver).call{value: amountETHLP}("");
562         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHBuyback}("");
563     }
564 
565     function _shouldTakeFee(address sender, address recipient) internal view returns (bool) {
566         return !isFeeExempt[sender] && !isFeeExempt[recipient];
567     }
568 }