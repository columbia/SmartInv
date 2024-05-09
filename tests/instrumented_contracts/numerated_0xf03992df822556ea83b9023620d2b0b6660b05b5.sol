1 /**
2 
3 Welcome to the inception of $DOGJAK, Wojaks Dog, an innovative and exciting digital asset inspired by the famous $WOJAK meme.
4 
5 TG - http://t.me/DogjakWojaksDog
6 
7 TWITTER - https://twitter.com/DogjakERC
8 
9 WEB - https://www.dogjak.com/
10 
11 */
12 
13 // SPDX-License-Identifier: MIT
14 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         _checkOwner();
71         _;
72     }
73 
74     /**
75      * @dev Returns the address of the current owner.
76      */
77     function owner() public view virtual returns (address) {
78         return _owner;
79     }
80 
81     /**
82      * @dev Throws if the sender is not the owner.
83      */
84     function _checkOwner() internal view virtual {
85         require(owner() == _msgSender(), "Ownable: caller is not the owner");
86     }
87 
88     /**
89      * @dev Leaves the contract without owner. It will not be possible to call
90      * `onlyOwner` functions anymore. Can only be called by the current owner.
91      *
92      * NOTE: Renouncing ownership will leave the contract without an owner,
93      * thereby removing any functionality that is only available to the owner.
94      */
95     function renounceOwnership() public virtual onlyOwner {
96         _transferOwnership(address(0));
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Can only be called by the current owner.
102      */
103     function transferOwnership(address newOwner) public virtual onlyOwner {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         _transferOwnership(newOwner);
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Internal function without access restriction.
111      */
112     function _transferOwnership(address newOwner) internal virtual {
113         address oldOwner = _owner;
114         _owner = newOwner;
115         emit OwnershipTransferred(oldOwner, newOwner);
116     }
117 }
118 
119 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Interface of the ERC20 standard as defined in the EIP.
125  */
126 interface IERC20 {
127     /**
128      * @dev Emitted when `value` tokens are moved from one account (`from`) to
129      * another (`to`).
130      *
131      * Note that `value` may be zero.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 
135     /**
136      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
137      * a call to {approve}. `value` is the new allowance.
138      */
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140 
141     /**
142      * @dev Returns the amount of tokens in existence.
143      */
144     function totalSupply() external view returns (uint256);
145 
146     /**
147      * @dev Returns the amount of tokens owned by `account`.
148      */
149     function balanceOf(address account) external view returns (uint256);
150 
151     /**
152      * @dev Moves `amount` tokens from the caller's account to `to`.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transfer(address to, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Returns the remaining number of tokens that `spender` will be
162      * allowed to spend on behalf of `owner` through {transferFrom}. This is
163      * zero by default.
164      *
165      * This value changes when {approve} or {transferFrom} are called.
166      */
167     function allowance(address owner, address spender) external view returns (uint256);
168 
169     /**
170      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * IMPORTANT: Beware that changing an allowance with this method brings the risk
175      * that someone may use both the old and the new allowance by unfortunate
176      * transaction ordering. One possible solution to mitigate this race
177      * condition is to first reduce the spender's allowance to 0 and set the
178      * desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      *
181      * Emits an {Approval} event.
182      */
183     function approve(address spender, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Moves `amount` tokens from `from` to `to` using the
187      * allowance mechanism. `amount` is then deducted from the caller's
188      * allowance.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(
195         address from,
196         address to,
197         uint256 amount
198     ) external returns (bool);
199 }
200 
201 pragma solidity ^0.8.19;
202 
203 interface IUniswapV2Router02 {
204     function factory() external pure returns (address);
205 
206     function WETH() external pure returns (address);
207 
208     function swapExactTokensForETHSupportingFeeOnTransferTokens(
209         uint256 amountIn,
210         uint256 amountOutMin,
211         address[] calldata path,
212         address to,
213         uint256 deadline
214     ) external;
215 }
216 
217 interface IUniswapV2Factory {
218     function createPair(address tokenA, address tokenB) external returns (address UNISWAP_V2_PAIR);
219 }
220 
221 contract DOGJAK is IERC20, Ownable {
222 
223     event Reflect(uint256 amountReflected, uint256 newTotalProportion);
224     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
225 
226     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
227     address constant ZERO = 0x0000000000000000000000000000000000000000;
228 
229     uint256 constant MAX_FEE = 10;
230 
231     IUniswapV2Router02 public constant UNISWAP_V2_ROUTER =
232         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
233     address public immutable UNISWAP_V2_PAIR;
234     mapping(address => bool) public automatedMarketMakerPairs;
235 
236     struct Fee {
237         uint8 reflection;
238         uint8 marketing;
239         uint8 lp;
240         uint8 buyback;
241         uint8 burn;
242         uint128 total;
243     }
244 
245     string _name = "Dogjak";
246     string _symbol = "DOGJAK";
247 
248     uint256 _totalSupply = 69_420_000_000 ether;
249     uint256 public _maxTxAmount = _totalSupply * 15 / 1000;
250     uint256 public _maxWalletAmount = _totalSupply * 15 / 1000;
251 
252     /* rOwned = ratio of tokens owned relative to circulating supply (NOT total supply, since circulating <= total) */
253     mapping(address => uint256) public _rOwned;
254     uint256 public _totalProportion = _totalSupply;
255 
256     mapping(address => mapping(address => uint256)) _allowances;
257 
258     bool public tradingActive = false;
259     bool public transferDelayEnabled = false;
260     bool public limitsEnabled = true;
261     mapping(address => bool) isFeeExempt;
262     mapping(address => bool) isLimitExempt;
263 
264     Fee public buyFee = Fee({reflection: 0, marketing: 25, lp: 0, buyback: 0, burn: 0, total: 25});
265     Fee public sellFee = Fee({reflection: 0, marketing: 25, lp: 0, buyback: 0, burn: 0, total: 25});
266 
267     address private marketingFeeReceiver;
268     address private lpFeeReceiver;
269     address private buybackFeeReceiver;
270 
271     bool public claimingFees = false;
272     uint256 public swapThreshold = (_totalSupply * 3) / 1000;
273     bool inSwap;
274     mapping(address => bool) public blacklists;
275     mapping(address => uint256) private _holderLastTransferTimestamp;
276 
277     modifier swapping() {
278         inSwap = true;
279         _;
280         inSwap = false;
281     }
282 
283     constructor() {
284         // create uniswap pair
285         address _uniswapPair =
286             IUniswapV2Factory(UNISWAP_V2_ROUTER.factory()).createPair(address(this), UNISWAP_V2_ROUTER.WETH());
287         UNISWAP_V2_PAIR = _uniswapPair;
288         _setAutomatedMarketMakerPair(address(_uniswapPair), true);
289 
290         _allowances[address(this)][address(UNISWAP_V2_ROUTER)] = type(uint256).max;
291         _allowances[address(this)][owner()] = type(uint256).max;
292 
293         isLimitExempt[address(this)] = true;
294         isLimitExempt[DEAD] = true;
295         isLimitExempt[owner()] = true;
296         isLimitExempt[UNISWAP_V2_PAIR] = true;
297         
298         isFeeExempt[address(this)] = true;
299         isFeeExempt[DEAD] = true;
300         isFeeExempt[owner()] = true;
301 
302         marketingFeeReceiver = 0xf31ac46405aCa6c37389A5671BE56a34B8392298;
303         lpFeeReceiver = 0x638bf5987452F14959f1DD2B76375ADd3BA0c603;
304         buybackFeeReceiver = 0xf31ac46405aCa6c37389A5671BE56a34B8392298;
305 
306         _rOwned[tx.origin] = _totalSupply;
307         emit Transfer(address(0), tx.origin, _totalSupply);
308     }
309 
310     receive() external payable {}
311 
312     function approve(address spender, uint256 amount) public override returns (bool) {
313         _allowances[msg.sender][spender] = amount;
314         emit Approval(msg.sender, spender, amount);
315         return true;
316     }
317 
318     function approveMax(address spender) external returns (bool) {
319         return approve(spender, type(uint256).max);
320     }
321 
322     function transfer(address recipient, uint256 amount) external override returns (bool) {
323         return _transferFrom(msg.sender, recipient, amount);
324     }
325 
326     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
327         if (_allowances[sender][msg.sender] != type(uint256).max) {
328             require(_allowances[sender][msg.sender] >= amount, "ERC20: insufficient allowance");
329             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
330         }
331 
332         return _transferFrom(sender, recipient, amount);
333     }
334 
335     function totalSupply() external view override returns (uint256) {
336         return _totalSupply;
337     }
338 
339     function decimals() external pure returns (uint8) {
340         return 18;
341     }
342 
343     function name() external view returns (string memory) {
344         return _name;
345     }
346 
347     function symbol() external view returns (string memory) {
348         return _symbol;
349     }
350 
351     function balanceOf(address account) public view override returns (uint256) {
352         return tokenFromReflection(_rOwned[account]);
353     }
354 
355     function allowance(address holder, address spender) external view override returns (uint256) {
356         return _allowances[holder][spender];
357     }
358 
359     function tokensToProportion(uint256 tokens) public view returns (uint256) {
360         return tokens * _totalProportion / _totalSupply;
361     }
362 
363     function tokenFromReflection(uint256 proportion) public view returns (uint256) {
364         return proportion * _totalSupply / _totalProportion;
365     }
366 
367     function getCirculatingSupply() public view returns (uint256) {
368         return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);
369     }
370 
371     function enableTrading() external onlyOwner {
372         tradingActive = true;
373         claimingFees = true;
374     }
375 
376     function setAutomatedMarketMakerPair(address pair, bool value)
377         public
378         onlyOwner
379     {
380         require(
381             pair != UNISWAP_V2_PAIR,
382             "The pair cannot be removed from automatedMarketMakerPairs"
383         );
384 
385         _setAutomatedMarketMakerPair(pair, value);
386     }
387 
388     function _setAutomatedMarketMakerPair(address pair, bool value) private {
389         automatedMarketMakerPairs[pair] = value;
390 
391         emit SetAutomatedMarketMakerPair(pair, value);
392     }
393 
394     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
395         require(
396             newNum >= ((_totalSupply * 1) / 1000) / 1e18,
397             "Cannot set maxTransactionAmount lower than 0.1%"
398         );
399         _maxTxAmount = newNum * (10**18);
400     }
401 
402     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
403         require(
404             newNum >= ((_totalSupply * 5) / 1000) / 1e18,
405             "Cannot set maxWallet lower than 0.5%"
406         );
407         _maxWalletAmount = newNum * (10**18);
408     }
409 
410     function clearStuckBalance() external onlyOwner {
411         (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
412         require(success);
413     }
414 
415     function clearStuckToken() external onlyOwner {
416         _transferFrom(address(this), msg.sender, balanceOf(address(this)));
417     }
418 
419     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
420         claimingFees = _enabled;
421         swapThreshold = _amount;
422     }
423 
424     function changeFees(
425         uint8 reflectionFeeBuy,
426         uint8 marketingFeeBuy,
427         uint8 lpFeeBuy,
428         uint8 buybackFeeBuy,
429         uint8 burnFeeBuy,
430         uint8 reflectionFeeSell,
431         uint8 marketingFeeSell,
432         uint8 lpFeeSell,
433         uint8 buybackFeeSell,
434         uint8 burnFeeSell
435     ) external onlyOwner {
436         uint128 __totalBuyFee = reflectionFeeBuy + marketingFeeBuy + lpFeeBuy + buybackFeeBuy + burnFeeBuy;
437         uint128 __totalSellFee = reflectionFeeSell + marketingFeeSell + lpFeeSell + buybackFeeSell + burnFeeSell;
438 
439         buyFee = Fee({
440             reflection: reflectionFeeBuy,
441             marketing: marketingFeeBuy,
442             lp: lpFeeBuy,
443             buyback: buybackFeeBuy,
444             burn: burnFeeBuy,
445             total: __totalBuyFee
446         });
447 
448         sellFee = Fee({
449             reflection: reflectionFeeSell,
450             marketing: marketingFeeSell,
451             lp: lpFeeSell,
452             buyback: buybackFeeSell,
453             burn: burnFeeSell,
454             total: __totalSellFee
455         });
456     }
457 
458     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
459         isFeeExempt[holder] = exempt;
460     }
461 
462     function setisLimitExempt(address holder, bool exempt) external onlyOwner {
463         isLimitExempt[holder] = exempt;
464     }
465 
466     function setFeeReceivers(address m_, address lp_, address b_) external onlyOwner {
467         marketingFeeReceiver = m_;
468         lpFeeReceiver = lp_;
469         buybackFeeReceiver = b_;
470     }
471 
472     function setLimitsEnabled(bool e_) external onlyOwner {
473         limitsEnabled = e_;
474     }
475 
476     // Set Transfer delay
477     function disableTransferDelay(bool e_) external onlyOwner returns (bool) {
478         transferDelayEnabled = e_;
479         return true;
480     }
481 
482     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
483         blacklists[_address] = _isBlacklisting;
484     }
485 
486     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
487         require(!blacklists[recipient] && !blacklists[sender], "Blacklisted");
488 
489         if (inSwap) {
490             return _basicTransfer(sender, recipient, amount);
491         }
492 
493         if (limitsEnabled) {
494             if (!tradingActive) 
495             {
496                 require(
497                     isFeeExempt[sender] || isFeeExempt[recipient],
498                     "Trading is not active."
499                 );
500             }
501 
502             //when buy
503             if (automatedMarketMakerPairs[sender] && !isLimitExempt[recipient]) 
504             {
505                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
506                 require(amount + balanceOf(recipient) <= _maxWalletAmount, "Max wallet exceeded");
507             }
508             //when sell
509             else if (automatedMarketMakerPairs[recipient] && !isLimitExempt[sender])
510             {
511                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
512             }
513             else if (!isLimitExempt[recipient]) 
514             {
515                 require(amount + balanceOf(recipient) <= _maxWalletAmount, "Max wallet exceeded");
516             }
517             
518             // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
519             if (transferDelayEnabled) {
520                 if (
521                     recipient != owner() &&
522                     recipient != address(UNISWAP_V2_ROUTER) &&
523                     recipient != UNISWAP_V2_PAIR
524                 ) {
525                     require(
526                         _holderLastTransferTimestamp[tx.origin] + 1 <
527                             block.number,
528                         "_transfer:: Transfer Delay enabled.  Only one purchase per two blocks allowed."
529                     );
530                     _holderLastTransferTimestamp[tx.origin] = block.number;
531                 }
532             }
533         }
534 
535         if (_shouldSwapBack()) {
536             _swapBack();
537         }
538 
539         uint256 proportionAmount = tokensToProportion(amount);
540         require(_rOwned[sender] >= proportionAmount, "Insufficient Balance");
541         _rOwned[sender] = _rOwned[sender] - proportionAmount;
542 
543         uint256 proportionReceived = _shouldTakeFee(sender, recipient)
544             ? _takeFeeInProportions(sender == UNISWAP_V2_PAIR ? true : false, sender, proportionAmount)
545             : proportionAmount;
546         _rOwned[recipient] = _rOwned[recipient] + proportionReceived;
547 
548         emit Transfer(sender, recipient, tokenFromReflection(proportionReceived));
549         return true;
550     }
551 
552     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
553         uint256 proportionAmount = tokensToProportion(amount);
554         require(_rOwned[sender] >= proportionAmount, "Insufficient Balance");
555         _rOwned[sender] = _rOwned[sender] - proportionAmount;
556         _rOwned[recipient] = _rOwned[recipient] + proportionAmount;
557         emit Transfer(sender, recipient, amount);
558         return true;
559     }
560 
561     function _takeFeeInProportions(bool buying, address sender, uint256 proportionAmount) internal returns (uint256) {
562         Fee memory __buyFee = buyFee;
563         Fee memory __sellFee = sellFee;
564 
565         uint256 proportionFeeAmount =
566             buying == true ? proportionAmount * __buyFee.total / 100 : proportionAmount * __sellFee.total / 100;
567 
568         // reflect
569         uint256 proportionReflected = buying == true
570             ? proportionFeeAmount * __buyFee.reflection / __buyFee.total
571             : proportionFeeAmount * __sellFee.reflection / __sellFee.total;
572 
573         _totalProportion = _totalProportion - proportionReflected;
574 
575         // take fees
576         uint256 _proportionToContract = proportionFeeAmount - proportionReflected;
577         if (_proportionToContract > 0) {
578             _rOwned[address(this)] = _rOwned[address(this)] + _proportionToContract;
579 
580             emit Transfer(sender, address(this), tokenFromReflection(_proportionToContract));
581         }
582         emit Reflect(proportionReflected, _totalProportion);
583         return proportionAmount - proportionFeeAmount;
584     }
585 
586     function _shouldSwapBack() internal view returns (bool) {
587         return msg.sender != UNISWAP_V2_PAIR && !inSwap && claimingFees && balanceOf(address(this)) >= swapThreshold;
588     }
589 
590     function _swapBack() internal swapping {
591         Fee memory __sellFee = sellFee;
592 
593         uint256 __swapThreshold = swapThreshold;
594         uint256 amountToBurn = __swapThreshold * __sellFee.burn / __sellFee.total;
595         uint256 amountToSwap = __swapThreshold - amountToBurn;
596         approve(address(UNISWAP_V2_ROUTER), amountToSwap);
597 
598         if(amountToBurn > 0)
599         {
600             // burn
601             _transferFrom(address(this), DEAD, amountToBurn);
602         }
603 
604         // swap
605         address[] memory path = new address[](2);
606         path[0] = address(this);
607         path[1] = UNISWAP_V2_ROUTER.WETH();
608 
609         UNISWAP_V2_ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(
610             amountToSwap, 0, path, address(this), block.timestamp
611         );
612 
613         uint256 amountETH = address(this).balance;
614 
615         uint256 totalSwapFee = __sellFee.total - __sellFee.reflection - __sellFee.burn;
616         uint256 amountETHMarketing = amountETH * __sellFee.marketing / totalSwapFee;
617         uint256 amountETHLP = amountETH * __sellFee.lp / totalSwapFee;
618         uint256 amountETHBuyback = amountETH * __sellFee.buyback / totalSwapFee;
619 
620         // send
621         (bool tmpSuccess,) = payable(lpFeeReceiver).call{value: amountETHLP}("");
622         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHBuyback}("");
623         (tmpSuccess,) = address(marketingFeeReceiver).call{value: address(this).balance}("");
624     }
625 
626     function _shouldTakeFee(address sender, address recipient) internal view returns (bool) {
627         return !isFeeExempt[sender] && !isFeeExempt[recipient];
628     }
629 }