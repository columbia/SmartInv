1 /**
2 
3 Tg - https://t.me/RockyTheHamster
4 Web - https://www.rockythehamster.com
5 Twitter - https://twitter.com/RockyERC
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Interface of the ERC20 standard as defined in the EIP.
121  */
122 interface IERC20 {
123     /**
124      * @dev Emitted when `value` tokens are moved from one account (`from`) to
125      * another (`to`).
126      *
127      * Note that `value` may be zero.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 value);
130 
131     /**
132      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
133      * a call to {approve}. `value` is the new allowance.
134      */
135     event Approval(address indexed owner, address indexed spender, uint256 value);
136 
137     /**
138      * @dev Returns the amount of tokens in existence.
139      */
140     function totalSupply() external view returns (uint256);
141 
142     /**
143      * @dev Returns the amount of tokens owned by `account`.
144      */
145     function balanceOf(address account) external view returns (uint256);
146 
147     /**
148      * @dev Moves `amount` tokens from the caller's account to `to`.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transfer(address to, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Returns the remaining number of tokens that `spender` will be
158      * allowed to spend on behalf of `owner` through {transferFrom}. This is
159      * zero by default.
160      *
161      * This value changes when {approve} or {transferFrom} are called.
162      */
163     function allowance(address owner, address spender) external view returns (uint256);
164 
165     /**
166      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * IMPORTANT: Beware that changing an allowance with this method brings the risk
171      * that someone may use both the old and the new allowance by unfortunate
172      * transaction ordering. One possible solution to mitigate this race
173      * condition is to first reduce the spender's allowance to 0 and set the
174      * desired value afterwards:
175      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176      *
177      * Emits an {Approval} event.
178      */
179     function approve(address spender, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Moves `amount` tokens from `from` to `to` using the
183      * allowance mechanism. `amount` is then deducted from the caller's
184      * allowance.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address from,
192         address to,
193         uint256 amount
194     ) external returns (bool);
195 }
196 
197 pragma solidity ^0.8.19;
198 
199 interface IUniswapV2Router02 {
200     function factory() external pure returns (address);
201 
202     function WETH() external pure returns (address);
203 
204     function swapExactTokensForETHSupportingFeeOnTransferTokens(
205         uint256 amountIn,
206         uint256 amountOutMin,
207         address[] calldata path,
208         address to,
209         uint256 deadline
210     ) external;
211 }
212 
213 interface IUniswapV2Factory {
214     function createPair(address tokenA, address tokenB) external returns (address UNISWAP_V2_PAIR);
215 }
216 
217 contract ROCKY is IERC20, Ownable {
218 
219     event Reflect(uint256 amountReflected, uint256 newTotalProportion);
220     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
221 
222     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
223     address constant ZERO = 0x0000000000000000000000000000000000000000;
224 
225     uint256 constant MAX_FEE = 10;
226 
227     IUniswapV2Router02 public constant UNISWAP_V2_ROUTER =
228         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
229     address public immutable UNISWAP_V2_PAIR;
230     mapping(address => bool) public automatedMarketMakerPairs;
231 
232     struct Fee {
233         uint8 reflection;
234         uint8 marketing;
235         uint8 lp;
236         uint8 buyback;
237         uint8 burn;
238         uint128 total;
239     }
240 
241     string _name = "Rocky";
242     string _symbol = "ROCKY";
243 
244     uint256 _totalSupply = 69_420_000_000 ether;
245     uint256 public _maxTxAmount = _totalSupply * 15 / 1000;
246     uint256 public _maxWalletAmount = _totalSupply * 15 / 1000;
247 
248     /* rOwned = ratio of tokens owned relative to circulating supply (NOT total supply, since circulating <= total) */
249     mapping(address => uint256) public _rOwned;
250     uint256 public _totalProportion = _totalSupply;
251 
252     mapping(address => mapping(address => uint256)) _allowances;
253 
254     bool public tradingActive = false;
255     bool public transferDelayEnabled = false;
256     bool public limitsEnabled = true;
257     mapping(address => bool) isFeeExempt;
258     mapping(address => bool) isLimitExempt;
259 
260     Fee public buyFee = Fee({reflection: 0, marketing: 25, lp: 0, buyback: 0, burn: 0, total: 25});
261     Fee public sellFee = Fee({reflection: 0, marketing: 25, lp: 0, buyback: 0, burn: 0, total: 25});
262 
263     address private marketingFeeReceiver;
264     address private lpFeeReceiver;
265     address private buybackFeeReceiver;
266 
267     bool public claimingFees = false;
268     uint256 public swapThreshold = (_totalSupply * 3) / 1000;
269     bool inSwap;
270     mapping(address => bool) public blacklists;
271     mapping(address => uint256) private _holderLastTransferTimestamp;
272 
273     modifier swapping() {
274         inSwap = true;
275         _;
276         inSwap = false;
277     }
278 
279     constructor() {
280         // create uniswap pair
281         address _uniswapPair =
282             IUniswapV2Factory(UNISWAP_V2_ROUTER.factory()).createPair(address(this), UNISWAP_V2_ROUTER.WETH());
283         UNISWAP_V2_PAIR = _uniswapPair;
284         _setAutomatedMarketMakerPair(address(_uniswapPair), true);
285 
286         _allowances[address(this)][address(UNISWAP_V2_ROUTER)] = type(uint256).max;
287         _allowances[address(this)][owner()] = type(uint256).max;
288 
289         isLimitExempt[address(this)] = true;
290         isLimitExempt[DEAD] = true;
291         isLimitExempt[owner()] = true;
292         isLimitExempt[UNISWAP_V2_PAIR] = true;
293         
294         isFeeExempt[address(this)] = true;
295         isFeeExempt[DEAD] = true;
296         isFeeExempt[owner()] = true;
297 
298         marketingFeeReceiver = 0xC58a37c78Da211F0318AB6aCd5cBbac6f9e6a531;
299         lpFeeReceiver = 0xC58a37c78Da211F0318AB6aCd5cBbac6f9e6a531;
300         buybackFeeReceiver = 0xC58a37c78Da211F0318AB6aCd5cBbac6f9e6a531;
301 
302         _rOwned[tx.origin] = _totalSupply;
303         emit Transfer(address(0), tx.origin, _totalSupply);
304     }
305 
306     receive() external payable {}
307 
308     function approve(address spender, uint256 amount) public override returns (bool) {
309         _allowances[msg.sender][spender] = amount;
310         emit Approval(msg.sender, spender, amount);
311         return true;
312     }
313 
314     function approveMax(address spender) external returns (bool) {
315         return approve(spender, type(uint256).max);
316     }
317 
318     function transfer(address recipient, uint256 amount) external override returns (bool) {
319         return _transferFrom(msg.sender, recipient, amount);
320     }
321 
322     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
323         if (_allowances[sender][msg.sender] != type(uint256).max) {
324             require(_allowances[sender][msg.sender] >= amount, "ERC20: insufficient allowance");
325             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
326         }
327 
328         return _transferFrom(sender, recipient, amount);
329     }
330 
331     function totalSupply() external view override returns (uint256) {
332         return _totalSupply;
333     }
334 
335     function decimals() external pure returns (uint8) {
336         return 18;
337     }
338 
339     function name() external view returns (string memory) {
340         return _name;
341     }
342 
343     function symbol() external view returns (string memory) {
344         return _symbol;
345     }
346 
347     function balanceOf(address account) public view override returns (uint256) {
348         return tokenFromReflection(_rOwned[account]);
349     }
350 
351     function allowance(address holder, address spender) external view override returns (uint256) {
352         return _allowances[holder][spender];
353     }
354 
355     function tokensToProportion(uint256 tokens) public view returns (uint256) {
356         return tokens * _totalProportion / _totalSupply;
357     }
358 
359     function tokenFromReflection(uint256 proportion) public view returns (uint256) {
360         return proportion * _totalSupply / _totalProportion;
361     }
362 
363     function getCirculatingSupply() public view returns (uint256) {
364         return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);
365     }
366 
367     function enableTrading() external onlyOwner {
368         tradingActive = true;
369         claimingFees = true;
370     }
371 
372     function setAutomatedMarketMakerPair(address pair, bool value)
373         public
374         onlyOwner
375     {
376         require(
377             pair != UNISWAP_V2_PAIR,
378             "The pair cannot be removed from automatedMarketMakerPairs"
379         );
380 
381         _setAutomatedMarketMakerPair(pair, value);
382     }
383 
384     function _setAutomatedMarketMakerPair(address pair, bool value) private {
385         automatedMarketMakerPairs[pair] = value;
386 
387         emit SetAutomatedMarketMakerPair(pair, value);
388     }
389 
390     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
391         require(
392             newNum >= ((_totalSupply * 1) / 1000) / 1e18,
393             "Cannot set maxTransactionAmount lower than 0.1%"
394         );
395         _maxTxAmount = newNum * (10**18);
396     }
397 
398     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
399         require(
400             newNum >= ((_totalSupply * 5) / 1000) / 1e18,
401             "Cannot set maxWallet lower than 0.5%"
402         );
403         _maxWalletAmount = newNum * (10**18);
404     }
405 
406     function clearStuckBalance() external onlyOwner {
407         (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
408         require(success);
409     }
410 
411     function clearStuckToken() external onlyOwner {
412         _transferFrom(address(this), msg.sender, balanceOf(address(this)));
413     }
414 
415     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
416         claimingFees = _enabled;
417         swapThreshold = _amount;
418     }
419 
420     function changeFees(
421         uint8 reflectionFeeBuy,
422         uint8 marketingFeeBuy,
423         uint8 lpFeeBuy,
424         uint8 buybackFeeBuy,
425         uint8 burnFeeBuy,
426         uint8 reflectionFeeSell,
427         uint8 marketingFeeSell,
428         uint8 lpFeeSell,
429         uint8 buybackFeeSell,
430         uint8 burnFeeSell
431     ) external onlyOwner {
432         uint128 __totalBuyFee = reflectionFeeBuy + marketingFeeBuy + lpFeeBuy + buybackFeeBuy + burnFeeBuy;
433         uint128 __totalSellFee = reflectionFeeSell + marketingFeeSell + lpFeeSell + buybackFeeSell + burnFeeSell;
434 
435         buyFee = Fee({
436             reflection: reflectionFeeBuy,
437             marketing: marketingFeeBuy,
438             lp: lpFeeBuy,
439             buyback: buybackFeeBuy,
440             burn: burnFeeBuy,
441             total: __totalBuyFee
442         });
443 
444         sellFee = Fee({
445             reflection: reflectionFeeSell,
446             marketing: marketingFeeSell,
447             lp: lpFeeSell,
448             buyback: buybackFeeSell,
449             burn: burnFeeSell,
450             total: __totalSellFee
451         });
452     }
453 
454     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
455         isFeeExempt[holder] = exempt;
456     }
457 
458     function setisLimitExempt(address holder, bool exempt) external onlyOwner {
459         isLimitExempt[holder] = exempt;
460     }
461 
462     function setFeeReceivers(address m_, address lp_, address b_) external onlyOwner {
463         marketingFeeReceiver = m_;
464         lpFeeReceiver = lp_;
465         buybackFeeReceiver = b_;
466     }
467 
468     function setLimitsEnabled(bool e_) external onlyOwner {
469         limitsEnabled = e_;
470     }
471 
472     // Set Transfer delay
473     function disableTransferDelay(bool e_) external onlyOwner returns (bool) {
474         transferDelayEnabled = e_;
475         return true;
476     }
477 
478     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
479         blacklists[_address] = _isBlacklisting;
480     }
481 
482     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
483         require(!blacklists[recipient] && !blacklists[sender], "Blacklisted");
484 
485         if (inSwap) {
486             return _basicTransfer(sender, recipient, amount);
487         }
488 
489         if (limitsEnabled) {
490             if (!tradingActive) 
491             {
492                 require(
493                     isFeeExempt[sender] || isFeeExempt[recipient],
494                     "Trading is not active."
495                 );
496             }
497 
498             //when buy
499             if (automatedMarketMakerPairs[sender] && !isLimitExempt[recipient]) 
500             {
501                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
502                 require(amount + balanceOf(recipient) <= _maxWalletAmount, "Max wallet exceeded");
503             }
504             //when sell
505             else if (automatedMarketMakerPairs[recipient] && !isLimitExempt[sender])
506             {
507                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
508             }
509             else if (!isLimitExempt[recipient]) 
510             {
511                 require(amount + balanceOf(recipient) <= _maxWalletAmount, "Max wallet exceeded");
512             }
513             
514             // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
515             if (transferDelayEnabled) {
516                 if (
517                     recipient != owner() &&
518                     recipient != address(UNISWAP_V2_ROUTER) &&
519                     recipient != UNISWAP_V2_PAIR
520                 ) {
521                     require(
522                         _holderLastTransferTimestamp[tx.origin] + 1 <
523                             block.number,
524                         "_transfer:: Transfer Delay enabled.  Only one purchase per two blocks allowed."
525                     );
526                     _holderLastTransferTimestamp[tx.origin] = block.number;
527                 }
528             }
529         }
530 
531         if (_shouldSwapBack()) {
532             _swapBack();
533         }
534 
535         uint256 proportionAmount = tokensToProportion(amount);
536         require(_rOwned[sender] >= proportionAmount, "Insufficient Balance");
537         _rOwned[sender] = _rOwned[sender] - proportionAmount;
538 
539         uint256 proportionReceived = _shouldTakeFee(sender, recipient)
540             ? _takeFeeInProportions(sender == UNISWAP_V2_PAIR ? true : false, sender, proportionAmount)
541             : proportionAmount;
542         _rOwned[recipient] = _rOwned[recipient] + proportionReceived;
543 
544         emit Transfer(sender, recipient, tokenFromReflection(proportionReceived));
545         return true;
546     }
547 
548     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
549         uint256 proportionAmount = tokensToProportion(amount);
550         require(_rOwned[sender] >= proportionAmount, "Insufficient Balance");
551         _rOwned[sender] = _rOwned[sender] - proportionAmount;
552         _rOwned[recipient] = _rOwned[recipient] + proportionAmount;
553         emit Transfer(sender, recipient, amount);
554         return true;
555     }
556 
557     function _takeFeeInProportions(bool buying, address sender, uint256 proportionAmount) internal returns (uint256) {
558         Fee memory __buyFee = buyFee;
559         Fee memory __sellFee = sellFee;
560 
561         uint256 proportionFeeAmount =
562             buying == true ? proportionAmount * __buyFee.total / 100 : proportionAmount * __sellFee.total / 100;
563 
564         // reflect
565         uint256 proportionReflected = buying == true
566             ? proportionFeeAmount * __buyFee.reflection / __buyFee.total
567             : proportionFeeAmount * __sellFee.reflection / __sellFee.total;
568 
569         _totalProportion = _totalProportion - proportionReflected;
570 
571         // take fees
572         uint256 _proportionToContract = proportionFeeAmount - proportionReflected;
573         if (_proportionToContract > 0) {
574             _rOwned[address(this)] = _rOwned[address(this)] + _proportionToContract;
575 
576             emit Transfer(sender, address(this), tokenFromReflection(_proportionToContract));
577         }
578         emit Reflect(proportionReflected, _totalProportion);
579         return proportionAmount - proportionFeeAmount;
580     }
581 
582     function _shouldSwapBack() internal view returns (bool) {
583         return msg.sender != UNISWAP_V2_PAIR && !inSwap && claimingFees && balanceOf(address(this)) >= swapThreshold;
584     }
585 
586     function _swapBack() internal swapping {
587         Fee memory __sellFee = sellFee;
588 
589         uint256 __swapThreshold = swapThreshold;
590         uint256 amountToBurn = __swapThreshold * __sellFee.burn / __sellFee.total;
591         uint256 amountToSwap = __swapThreshold - amountToBurn;
592         approve(address(UNISWAP_V2_ROUTER), amountToSwap);
593 
594         if(amountToBurn > 0)
595         {
596             // burn
597             _transferFrom(address(this), DEAD, amountToBurn);
598         }
599 
600         // swap
601         address[] memory path = new address[](2);
602         path[0] = address(this);
603         path[1] = UNISWAP_V2_ROUTER.WETH();
604 
605         UNISWAP_V2_ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(
606             amountToSwap, 0, path, address(this), block.timestamp
607         );
608 
609         uint256 amountETH = address(this).balance;
610 
611         uint256 totalSwapFee = __sellFee.total - __sellFee.reflection - __sellFee.burn;
612         uint256 amountETHMarketing = amountETH * __sellFee.marketing / totalSwapFee;
613         uint256 amountETHLP = amountETH * __sellFee.lp / totalSwapFee;
614         uint256 amountETHBuyback = amountETH * __sellFee.buyback / totalSwapFee;
615 
616         // send
617         (bool tmpSuccess,) = payable(lpFeeReceiver).call{value: amountETHLP}("");
618         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHBuyback}("");
619         (tmpSuccess,) = address(marketingFeeReceiver).call{value: address(this).balance}("");
620     }
621 
622     function _shouldTakeFee(address sender, address recipient) internal view returns (bool) {
623         return !isFeeExempt[sender] && !isFeeExempt[recipient];
624     }
625 }