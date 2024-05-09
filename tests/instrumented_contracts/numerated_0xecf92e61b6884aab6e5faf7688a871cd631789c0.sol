1 /**
2  *Submitted for verification at Etherscan.io on 2023-06-25
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         _checkOwner();
63         _;
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if the sender is not the owner.
75      */
76     function _checkOwner() internal view virtual {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public virtual onlyOwner {
88         _transferOwnership(address(0));
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Internal function without access restriction.
103      */
104     function _transferOwnership(address newOwner) internal virtual {
105         address oldOwner = _owner;
106         _owner = newOwner;
107         emit OwnershipTransferred(oldOwner, newOwner);
108     }
109 }
110 
111 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP.
117  */
118 interface IERC20 {
119     /**
120      * @dev Emitted when `value` tokens are moved from one account (`from`) to
121      * another (`to`).
122      *
123      * Note that `value` may be zero.
124      */
125     event Transfer(address indexed from, address indexed to, uint256 value);
126 
127     /**
128      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
129      * a call to {approve}. `value` is the new allowance.
130      */
131     event Approval(address indexed owner, address indexed spender, uint256 value);
132 
133     /**
134      * @dev Returns the amount of tokens in existence.
135      */
136     function totalSupply() external view returns (uint256);
137 
138     /**
139      * @dev Returns the amount of tokens owned by `account`.
140      */
141     function balanceOf(address account) external view returns (uint256);
142 
143     /**
144      * @dev Moves `amount` tokens from the caller's account to `to`.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a {Transfer} event.
149      */
150     function transfer(address to, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Returns the remaining number of tokens that `spender` will be
154      * allowed to spend on behalf of `owner` through {transferFrom}. This is
155      * zero by default.
156      *
157      * This value changes when {approve} or {transferFrom} are called.
158      */
159     function allowance(address owner, address spender) external view returns (uint256);
160 
161     /**
162      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * IMPORTANT: Beware that changing an allowance with this method brings the risk
167      * that someone may use both the old and the new allowance by unfortunate
168      * transaction ordering. One possible solution to mitigate this race
169      * condition is to first reduce the spender's allowance to 0 and set the
170      * desired value afterwards:
171      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172      *
173      * Emits an {Approval} event.
174      */
175     function approve(address spender, uint256 amount) external returns (bool);
176 
177     /**
178      * @dev Moves `amount` tokens from `from` to `to` using the
179      * allowance mechanism. `amount` is then deducted from the caller's
180      * allowance.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transferFrom(
187         address from,
188         address to,
189         uint256 amount
190     ) external returns (bool);
191 }
192 
193 pragma solidity ^0.8.19;
194 
195 // https://twitter.com/STDERC
196 // http://t.me/STDERC
197 
198 interface IUniswapV2Router02 {
199     function factory() external pure returns (address);
200 
201     function WETH() external pure returns (address);
202 
203     function swapExactTokensForETHSupportingFeeOnTransferTokens(
204         uint256 amountIn,
205         uint256 amountOutMin,
206         address[] calldata path,
207         address to,
208         uint256 deadline
209     ) external;
210 }
211 
212 interface IUniswapV2Factory {
213     function createPair(address tokenA, address tokenB) external returns (address UNISWAP_V2_PAIR);
214 }
215 
216 contract STD is IERC20, Ownable {
217     /* -------------------------------------------------------------------------- */
218     /*                                   events                                   */
219     /* -------------------------------------------------------------------------- */
220     event Reflect(uint256 amountReflected, uint256 newTotalProportion);
221     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
222 
223     /* -------------------------------------------------------------------------- */
224     /*                                  constants                                 */
225     /* -------------------------------------------------------------------------- */
226     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
227     address constant ZERO = 0x0000000000000000000000000000000000000000;
228 
229     uint256 constant MAX_FEE = 10;
230 
231     /* -------------------------------------------------------------------------- */
232     /*                                   states                                   */
233     /* -------------------------------------------------------------------------- */
234     IUniswapV2Router02 public constant UNISWAP_V2_ROUTER =
235         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
236     address public immutable UNISWAP_V2_PAIR;
237     mapping(address => bool) public automatedMarketMakerPairs;
238 
239     struct Fee {
240         uint8 reflection;
241         uint8 marketing;
242         uint8 lp;
243         uint8 buyback;
244         uint8 burn;
245         uint128 total;
246     }
247 
248     string _name = "STD";
249     string _symbol = "STD";
250 
251     uint256 _totalSupply = 100_000_000 ether;
252     uint256 public _maxTxAmount = _totalSupply * 1 / 100;
253     uint256 public _maxWalletAmount = _totalSupply * 2 / 100;
254 
255     /* rOwned = ratio of tokens owned relative to circulating supply (NOT total supply, since circulating <= total) */
256     mapping(address => uint256) public _rOwned;
257     uint256 public _totalProportion = _totalSupply;
258 
259     mapping(address => mapping(address => uint256)) _allowances;
260 
261     bool public tradingActive = false;
262     bool public transferDelayEnabled = true;
263     bool public limitsEnabled = true;
264     mapping(address => bool) isFeeExempt;
265     mapping(address => bool) isLimitExempt;
266 
267     Fee public buyFee = Fee({reflection: 1, marketing: 1, lp: 1, buyback: 0, burn: 0, total: 3});
268     Fee public sellFee = Fee({reflection: 1, marketing: 1, lp: 1, buyback: 0, burn: 0, total: 3});
269 
270     address private marketingFeeReceiver;
271     address private lpFeeReceiver;
272     address private buybackFeeReceiver;
273 
274     bool public claimingFees = false;
275     uint256 public swapThreshold = (_totalSupply * 2) / 1000;
276     bool inSwap;
277     mapping(address => bool) public blacklists;
278     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
279 
280     /* -------------------------------------------------------------------------- */
281     /*                                  modifiers                                 */
282     /* -------------------------------------------------------------------------- */
283     modifier swapping() {
284         inSwap = true;
285         _;
286         inSwap = false;
287     }
288 
289     /* -------------------------------------------------------------------------- */
290     /*                                 constructor                                */
291     /* -------------------------------------------------------------------------- */
292     constructor() {
293         // create uniswap pair
294         address _uniswapPair =
295             IUniswapV2Factory(UNISWAP_V2_ROUTER.factory()).createPair(address(this), UNISWAP_V2_ROUTER.WETH());
296         UNISWAP_V2_PAIR = _uniswapPair;
297         _setAutomatedMarketMakerPair(address(_uniswapPair), true);
298 
299         _allowances[address(this)][address(UNISWAP_V2_ROUTER)] = type(uint256).max;
300         _allowances[address(this)][owner()] = type(uint256).max;
301 
302         isLimitExempt[address(this)] = true;
303         isLimitExempt[DEAD] = true;
304         isLimitExempt[owner()] = true;
305         isLimitExempt[UNISWAP_V2_PAIR] = true;
306         
307         isFeeExempt[address(this)] = true;
308         isFeeExempt[DEAD] = true;
309         isFeeExempt[owner()] = true;
310 
311         marketingFeeReceiver = 0xD348F2c3c89ac9C3DD3422eD9C33906d4573691d;
312         lpFeeReceiver = 0xf5088AE1e7699220b7bdc19f05d34125AaC37524;
313         buybackFeeReceiver = 0x2256f5d11a591eBae0EC6F0886FDd5791B0685F0;
314 
315         _rOwned[tx.origin] = _totalSupply;
316         emit Transfer(address(0), tx.origin, _totalSupply);
317     }
318 
319     receive() external payable {}
320 
321     /* -------------------------------------------------------------------------- */
322     /*                                    ERC20                                   */
323     /* -------------------------------------------------------------------------- */
324     function approve(address spender, uint256 amount) public override returns (bool) {
325         _allowances[msg.sender][spender] = amount;
326         emit Approval(msg.sender, spender, amount);
327         return true;
328     }
329 
330     function approveMax(address spender) external returns (bool) {
331         return approve(spender, type(uint256).max);
332     }
333 
334     function transfer(address recipient, uint256 amount) external override returns (bool) {
335         return _transferFrom(msg.sender, recipient, amount);
336     }
337 
338     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
339         if (_allowances[sender][msg.sender] != type(uint256).max) {
340             require(_allowances[sender][msg.sender] >= amount, "ERC20: insufficient allowance");
341             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
342         }
343 
344         return _transferFrom(sender, recipient, amount);
345     }
346 
347     /* -------------------------------------------------------------------------- */
348     /*                                    views                                   */
349     /* -------------------------------------------------------------------------- */
350     function totalSupply() external view override returns (uint256) {
351         return _totalSupply;
352     }
353 
354     function decimals() external pure returns (uint8) {
355         return 18;
356     }
357 
358     function name() external view returns (string memory) {
359         return _name;
360     }
361 
362     function symbol() external view returns (string memory) {
363         return _symbol;
364     }
365 
366     function balanceOf(address account) public view override returns (uint256) {
367         return tokenFromReflection(_rOwned[account]);
368     }
369 
370     function allowance(address holder, address spender) external view override returns (uint256) {
371         return _allowances[holder][spender];
372     }
373 
374     function tokensToProportion(uint256 tokens) public view returns (uint256) {
375         return tokens * _totalProportion / _totalSupply;
376     }
377 
378     function tokenFromReflection(uint256 proportion) public view returns (uint256) {
379         return proportion * _totalSupply / _totalProportion;
380     }
381 
382     function getCirculatingSupply() public view returns (uint256) {
383         return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);
384     }
385 
386     /* -------------------------------------------------------------------------- */
387     /*                                   owners                                   */
388     /* -------------------------------------------------------------------------- */
389 
390     // once enabled, can never be turned off
391     function enableTrading() external onlyOwner {
392         tradingActive = true;
393         claimingFees = true;
394     }
395 
396     function setAutomatedMarketMakerPair(address pair, bool value)
397         public
398         onlyOwner
399     {
400         require(
401             pair != UNISWAP_V2_PAIR,
402             "The pair cannot be removed from automatedMarketMakerPairs"
403         );
404 
405         _setAutomatedMarketMakerPair(pair, value);
406     }
407 
408     function _setAutomatedMarketMakerPair(address pair, bool value) private {
409         automatedMarketMakerPairs[pair] = value;
410 
411         emit SetAutomatedMarketMakerPair(pair, value);
412     }
413 
414     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
415         require(
416             newNum >= ((_totalSupply * 1) / 1000) / 1e18,
417             "Cannot set maxTransactionAmount lower than 0.1%"
418         );
419         _maxTxAmount = newNum * (10**18);
420     }
421 
422     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
423         require(
424             newNum >= ((_totalSupply * 5) / 1000) / 1e18,
425             "Cannot set maxWallet lower than 0.5%"
426         );
427         _maxWalletAmount = newNum * (10**18);
428     }
429 
430     function clearStuckBalance() external onlyOwner {
431         (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
432         require(success);
433     }
434 
435     function clearStuckToken() external onlyOwner {
436         _transferFrom(address(this), msg.sender, balanceOf(address(this)));
437     }
438 
439     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
440         claimingFees = _enabled;
441         swapThreshold = _amount;
442     }
443 
444     function changeFees(
445         uint8 reflectionFeeBuy,
446         uint8 marketingFeeBuy,
447         uint8 lpFeeBuy,
448         uint8 buybackFeeBuy,
449         uint8 burnFeeBuy,
450         uint8 reflectionFeeSell,
451         uint8 marketingFeeSell,
452         uint8 lpFeeSell,
453         uint8 buybackFeeSell,
454         uint8 burnFeeSell
455     ) external onlyOwner {
456         uint128 __totalBuyFee = reflectionFeeBuy + marketingFeeBuy + lpFeeBuy + buybackFeeBuy + burnFeeBuy;
457         uint128 __totalSellFee = reflectionFeeSell + marketingFeeSell + lpFeeSell + buybackFeeSell + burnFeeSell;
458 
459         buyFee = Fee({
460             reflection: reflectionFeeBuy,
461             marketing: marketingFeeBuy,
462             lp: lpFeeBuy,
463             buyback: buybackFeeBuy,
464             burn: burnFeeBuy,
465             total: __totalBuyFee
466         });
467 
468         sellFee = Fee({
469             reflection: reflectionFeeSell,
470             marketing: marketingFeeSell,
471             lp: lpFeeSell,
472             buyback: buybackFeeSell,
473             burn: burnFeeSell,
474             total: __totalSellFee
475         });
476     }
477 
478     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
479         isFeeExempt[holder] = exempt;
480     }
481 
482     function setisLimitExempt(address holder, bool exempt) external onlyOwner {
483         isLimitExempt[holder] = exempt;
484     }
485 
486     function setFeeReceivers(address m_, address lp_, address b_) external onlyOwner {
487         marketingFeeReceiver = m_;
488         lpFeeReceiver = lp_;
489         buybackFeeReceiver = b_;
490     }
491 
492     function setLimitsEnabled(bool e_) external onlyOwner {
493         limitsEnabled = e_;
494     }
495 
496     // Set Transfer delay
497     function disableTransferDelay(bool e_) external onlyOwner returns (bool) {
498         transferDelayEnabled = e_;
499         return true;
500     }
501 
502     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
503         blacklists[_address] = _isBlacklisting;
504     }
505 
506     /* -------------------------------------------------------------------------- */
507     /*                                   private                                  */
508     /* -------------------------------------------------------------------------- */
509     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
510         require(!blacklists[recipient] && !blacklists[sender], "Blacklisted");
511 
512         if (inSwap) {
513             return _basicTransfer(sender, recipient, amount);
514         }
515 
516         if (limitsEnabled) {
517             if (!tradingActive) 
518             {
519                 require(
520                     isFeeExempt[sender] || isFeeExempt[recipient],
521                     "Trading is not active."
522                 );
523             }
524 
525             //when buy
526             if (automatedMarketMakerPairs[sender] && !isLimitExempt[recipient]) 
527             {
528                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
529                 require(amount + balanceOf(recipient) <= _maxWalletAmount, "Max wallet exceeded");
530             }
531             //when sell
532             else if (automatedMarketMakerPairs[recipient] && !isLimitExempt[sender])
533             {
534                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
535             }
536             else if (!isLimitExempt[recipient]) 
537             {
538                 require(amount + balanceOf(recipient) <= _maxWalletAmount, "Max wallet exceeded");
539             }
540             
541             // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
542             if (transferDelayEnabled) {
543                 if (
544                     recipient != owner() &&
545                     recipient != address(UNISWAP_V2_ROUTER) &&
546                     recipient != UNISWAP_V2_PAIR
547                 ) {
548                     require(
549                         _holderLastTransferTimestamp[tx.origin] + 1 <
550                             block.number,
551                         "_transfer:: Transfer Delay enabled.  Only one purchase per two blocks allowed."
552                     );
553                     _holderLastTransferTimestamp[tx.origin] = block.number;
554                 }
555             }
556         }
557 
558         if (_shouldSwapBack()) {
559             _swapBack();
560         }
561 
562         uint256 proportionAmount = tokensToProportion(amount);
563         require(_rOwned[sender] >= proportionAmount, "Insufficient Balance");
564         _rOwned[sender] = _rOwned[sender] - proportionAmount;
565 
566         uint256 proportionReceived = _shouldTakeFee(sender, recipient)
567             ? _takeFeeInProportions(sender == UNISWAP_V2_PAIR ? true : false, sender, proportionAmount)
568             : proportionAmount;
569         _rOwned[recipient] = _rOwned[recipient] + proportionReceived;
570 
571         emit Transfer(sender, recipient, tokenFromReflection(proportionReceived));
572         return true;
573     }
574 
575     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
576         uint256 proportionAmount = tokensToProportion(amount);
577         require(_rOwned[sender] >= proportionAmount, "Insufficient Balance");
578         _rOwned[sender] = _rOwned[sender] - proportionAmount;
579         _rOwned[recipient] = _rOwned[recipient] + proportionAmount;
580         emit Transfer(sender, recipient, amount);
581         return true;
582     }
583 
584     function _takeFeeInProportions(bool buying, address sender, uint256 proportionAmount) internal returns (uint256) {
585         Fee memory __buyFee = buyFee;
586         Fee memory __sellFee = sellFee;
587 
588         uint256 proportionFeeAmount =
589             buying == true ? proportionAmount * __buyFee.total / 100 : proportionAmount * __sellFee.total / 100;
590 
591         // reflect
592         uint256 proportionReflected = buying == true
593             ? proportionFeeAmount * __buyFee.reflection / __buyFee.total
594             : proportionFeeAmount * __sellFee.reflection / __sellFee.total;
595 
596         _totalProportion = _totalProportion - proportionReflected;
597 
598         // take fees
599         uint256 _proportionToContract = proportionFeeAmount - proportionReflected;
600         if (_proportionToContract > 0) {
601             _rOwned[address(this)] = _rOwned[address(this)] + _proportionToContract;
602 
603             emit Transfer(sender, address(this), tokenFromReflection(_proportionToContract));
604         }
605         emit Reflect(proportionReflected, _totalProportion);
606         return proportionAmount - proportionFeeAmount;
607     }
608 
609     function _shouldSwapBack() internal view returns (bool) {
610         return msg.sender != UNISWAP_V2_PAIR && !inSwap && claimingFees && balanceOf(address(this)) >= swapThreshold;
611     }
612 
613     function _swapBack() internal swapping {
614         Fee memory __sellFee = sellFee;
615 
616         uint256 __swapThreshold = swapThreshold;
617         uint256 amountToBurn = __swapThreshold * __sellFee.burn / __sellFee.total;
618         uint256 amountToSwap = __swapThreshold - amountToBurn;
619         approve(address(UNISWAP_V2_ROUTER), amountToSwap);
620 
621         if(amountToBurn > 0)
622         {
623             // burn
624             _transferFrom(address(this), DEAD, amountToBurn);
625         }
626 
627         // swap
628         address[] memory path = new address[](2);
629         path[0] = address(this);
630         path[1] = UNISWAP_V2_ROUTER.WETH();
631 
632         UNISWAP_V2_ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(
633             amountToSwap, 0, path, address(this), block.timestamp
634         );
635 
636         uint256 amountETH = address(this).balance;
637 
638         uint256 totalSwapFee = __sellFee.total - __sellFee.reflection - __sellFee.burn;
639         uint256 amountETHMarketing = amountETH * __sellFee.marketing / totalSwapFee;
640         uint256 amountETHLP = amountETH * __sellFee.lp / totalSwapFee;
641         uint256 amountETHBuyback = amountETH * __sellFee.buyback / totalSwapFee;
642 
643         // send
644         (bool tmpSuccess,) = payable(lpFeeReceiver).call{value: amountETHLP}("");
645         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHBuyback}("");
646         (tmpSuccess,) = address(marketingFeeReceiver).call{value: address(this).balance}("");
647     }
648 
649     function _shouldTakeFee(address sender, address recipient) internal view returns (bool) {
650         return !isFeeExempt[sender] && !isFeeExempt[recipient];
651     }
652 }