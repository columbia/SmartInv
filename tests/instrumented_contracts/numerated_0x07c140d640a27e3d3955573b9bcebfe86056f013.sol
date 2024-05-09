1 //EVERMARS
2 //
3 //https://evermars.io/
4 //https://t.me/EVERMARS_PORTAL
5 //https://twitter.com/EverMarsERC20
6 
7 
8 // SPDX-License-Identifier: UNLICENSED
9 pragma solidity ^0.8.19;
10 
11 
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Emitted when `value` tokens are moved from one account (`from`) to
39      * another (`to`).
40      *
41      * Note that `value` may be zero.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     /**
46      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
47      * a call to {approve}. `value` is the new allowance.
48      */
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 
51     /**
52      * @dev Returns the amount of tokens in existence.
53      */
54     function totalSupply() external view returns (uint256);
55 
56     /**
57      * @dev Returns the amount of tokens owned by `account`.
58      */
59     function balanceOf(address account) external view returns (uint256);
60 
61     /**
62      * @dev Moves `amount` tokens from the caller's account to `to`.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transfer(address to, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Returns the remaining number of tokens that `spender` will be
72      * allowed to spend on behalf of `owner` through {transferFrom}. This is
73      * zero by default.
74      *
75      * This value changes when {approve} or {transferFrom} are called.
76      */
77     function allowance(address owner, address spender) external view returns (uint256);
78 
79     /**
80      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * IMPORTANT: Beware that changing an allowance with this method brings the risk
85      * that someone may use both the old and the new allowance by unfortunate
86      * transaction ordering. One possible solution to mitigate this race
87      * condition is to first reduce the spender's allowance to 0 and set the
88      * desired value afterwards:
89      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
90      *
91      * Emits an {Approval} event.
92      */
93     function approve(address spender, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Moves `amount` tokens from `from` to `to` using the
97      * allowance mechanism. `amount` is then deducted from the caller's
98      * allowance.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 amount
108     ) external returns (bool);
109 }
110 
111 /**
112  * @dev Contract module which provides a basic access control mechanism, where
113  * there is an account (an owner) that can be granted exclusive access to
114  * specific functions.
115  *
116  * By default, the owner account will be the one that deploys the contract. This
117  * can later be changed with {transferOwnership}.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 abstract contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor() {
132         _transferOwnership(_msgSender());
133     }
134 
135     /**
136      * @dev Throws if called by any account other than the owner.
137      */
138     modifier onlyOwner() {
139         _checkOwner();
140         _;
141     }
142 
143     /**
144      * @dev Returns the address of the current owner.
145      */
146     function owner() public view virtual returns (address) {
147         return _owner;
148     }
149 
150     /**
151      * @dev Throws if the sender is not the owner.
152      */
153     function _checkOwner() internal view virtual {
154         require(owner() == _msgSender(), "Ownable: caller is not the owner");
155     }
156 
157     /**
158      * @dev Leaves the contract without owner. It will not be possible to call
159      * `onlyOwner` functions anymore. Can only be called by the current owner.
160      *
161      * NOTE: Renouncing ownership will leave the contract without an owner,
162      * thereby removing any functionality that is only available to the owner.
163      */
164     function renounceOwnership() public virtual onlyOwner {
165         _transferOwnership(address(0));
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Can only be called by the current owner.
171      */
172     function transferOwnership(address newOwner) public virtual onlyOwner {
173         require(newOwner != address(0), "Ownable: new owner is the zero address");
174         _transferOwnership(newOwner);
175     }
176 
177     /**
178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
179      * Internal function without access restriction.
180      */
181     function _transferOwnership(address newOwner) internal virtual {
182         address oldOwner = _owner;
183         _owner = newOwner;
184         emit OwnershipTransferred(oldOwner, newOwner);
185     }
186 }
187 
188 interface IUniswapV2Router02 {
189     function factory() external pure returns (address);
190 
191     function WETH() external pure returns (address);
192 
193     function swapExactTokensForETHSupportingFeeOnTransferTokens(
194         uint256 amountIn,
195         uint256 amountOutMin,
196         address[] calldata path,
197         address to,
198         uint256 deadline
199     ) external;
200 }
201 
202 interface IUniswapV2Factory {
203     function createPair(address tokenA, address tokenB) external returns (address UNISWAP_V2_PAIR);
204 }
205 
206 contract Evermars is IERC20, Ownable {
207     /* -------------------------------------------------------------------------- */
208     /*                                   events                                   */
209     /* -------------------------------------------------------------------------- */
210     event Reflect(uint256 amountReflected, uint256 newTotalProportion);
211 
212     /* -------------------------------------------------------------------------- */
213     /*                                  constants                                 */
214     /* -------------------------------------------------------------------------- */
215     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
216     address constant ZERO = 0x0000000000000000000000000000000000000000;
217 
218     uint256 constant MAX_FEE = 20;
219 
220     /* -------------------------------------------------------------------------- */
221     /*                                   states                                   */
222     /* -------------------------------------------------------------------------- */
223     IUniswapV2Router02 public constant UNISWAP_V2_ROUTER =
224         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
225     address public immutable UNISWAP_V2_PAIR;
226 
227     struct Fee {
228         uint8 reflection;
229         uint8 marketing;
230         uint8 lp;
231         uint8 buyback;
232         uint8 burn;
233         uint128 total;
234     }
235 
236     string _name = "Evermars";
237     string _symbol = "EVERMARS";
238 
239     uint256 _totalSupply = 1_000_000_000_000 ether;
240     uint256 public _maxTxAmount = _totalSupply * 2 / 100;
241 
242     /* rOwned = ratio of tokens owned relative to circulating supply (NOT total supply, since circulating <= total) */
243     mapping(address => uint256) public _rOwned;
244     uint256 public _totalProportion = _totalSupply;
245 
246     mapping(address => mapping(address => uint256)) _allowances;
247 
248     bool public limitsEnabled = true;
249     mapping(address => bool) isFeeExempt;
250     mapping(address => bool) isTxLimitExempt;
251 
252     Fee public buyFee = Fee({reflection: 3, marketing: 2, lp: 0, buyback: 0, burn: 0, total: 5});
253     Fee public sellFee = Fee({reflection: 3, marketing: 2, lp: 0, buyback: 0, burn: 0, total: 5});
254 
255     address private marketingFeeReceiver;
256     address private lpFeeReceiver;
257     address private buybackFeeReceiver;
258 
259     bool public claimingFees = true;
260     uint256 public swapThreshold = (_totalSupply * 2) / 1000;
261     bool inSwap;
262     mapping(address => bool) public blacklists;
263 
264     /* -------------------------------------------------------------------------- */
265     /*                                  modifiers                                 */
266     /* -------------------------------------------------------------------------- */
267     modifier swapping() {
268         inSwap = true;
269         _;
270         inSwap = false;
271     }
272 
273     /* -------------------------------------------------------------------------- */
274     /*                                 constructor                                */
275     /* -------------------------------------------------------------------------- */
276     constructor() {
277         // create uniswap pair
278         address _uniswapPair =
279             IUniswapV2Factory(UNISWAP_V2_ROUTER.factory()).createPair(address(this), UNISWAP_V2_ROUTER.WETH());
280         UNISWAP_V2_PAIR = _uniswapPair;
281 
282         _allowances[address(this)][address(UNISWAP_V2_ROUTER)] = type(uint256).max;
283         _allowances[address(this)][tx.origin] = type(uint256).max;
284 
285         isTxLimitExempt[address(this)] = true;
286         isTxLimitExempt[address(UNISWAP_V2_ROUTER)] = true;
287         isTxLimitExempt[_uniswapPair] = true;
288         isTxLimitExempt[tx.origin] = true;
289         isFeeExempt[tx.origin] = true;
290 
291         marketingFeeReceiver = 0xDd7e5E6Ea82863456f1D3510BF45d10E445Bff2e;
292         lpFeeReceiver = 0xDd7e5E6Ea82863456f1D3510BF45d10E445Bff2e;
293         buybackFeeReceiver = 0xDd7e5E6Ea82863456f1D3510BF45d10E445Bff2e;
294 
295         _rOwned[tx.origin] = _totalSupply;
296         emit Transfer(address(0), tx.origin, _totalSupply);
297     }
298 
299     receive() external payable {}
300 
301     /* -------------------------------------------------------------------------- */
302     /*                                    ERC20                                   */
303     /* -------------------------------------------------------------------------- */
304     function approve(address spender, uint256 amount) public override returns (bool) {
305         _allowances[msg.sender][spender] = amount;
306         emit Approval(msg.sender, spender, amount);
307         return true;
308     }
309 
310     function approveMax(address spender) external returns (bool) {
311         return approve(spender, type(uint256).max);
312     }
313 
314     function transfer(address recipient, uint256 amount) external override returns (bool) {
315         return _transferFrom(msg.sender, recipient, amount);
316     }
317 
318     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
319         if (_allowances[sender][msg.sender] != type(uint256).max) {
320             require(_allowances[sender][msg.sender] >= amount, "ERC20: insufficient allowance");
321             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
322         }
323 
324         return _transferFrom(sender, recipient, amount);
325     }
326 
327     /* -------------------------------------------------------------------------- */
328     /*                                    views                                   */
329     /* -------------------------------------------------------------------------- */
330     function totalSupply() external view override returns (uint256) {
331         return _totalSupply;
332     }
333 
334     function decimals() external pure returns (uint8) {
335         return 18;
336     }
337 
338     function name() external view returns (string memory) {
339         return _name;
340     }
341 
342     function symbol() external view returns (string memory) {
343         return _symbol;
344     }
345 
346     function balanceOf(address account) public view override returns (uint256) {
347         return tokenFromReflection(_rOwned[account]);
348     }
349 
350     function allowance(address holder, address spender) external view override returns (uint256) {
351         return _allowances[holder][spender];
352     }
353 
354     function tokensToProportion(uint256 tokens) public view returns (uint256) {
355         return tokens * _totalProportion / _totalSupply;
356     }
357 
358     function tokenFromReflection(uint256 proportion) public view returns (uint256) {
359         return proportion * _totalSupply / _totalProportion;
360     }
361 
362     function getCirculatingSupply() public view returns (uint256) {
363         return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);
364     }
365 
366     /* -------------------------------------------------------------------------- */
367     /*                                   owners                                   */
368     /* -------------------------------------------------------------------------- */
369     function clearStuckBalance() external onlyOwner {
370         (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
371         require(success);
372     }
373 
374     function clearStuckToken() external onlyOwner {
375         _transferFrom(address(this), msg.sender, balanceOf(address(this)));
376     }
377 
378     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
379         claimingFees = _enabled;
380         swapThreshold = _amount;
381     }
382 
383     function changeFees(
384         uint8 reflectionFeeBuy,
385         uint8 marketingFeeBuy,
386         uint8 lpFeeBuy,
387         uint8 buybackFeeBuy,
388         uint8 burnFeeBuy,
389         uint8 reflectionFeeSell,
390         uint8 marketingFeeSell,
391         uint8 lpFeeSell,
392         uint8 buybackFeeSell,
393         uint8 burnFeeSell
394     ) external onlyOwner {
395         uint128 __totalBuyFee = reflectionFeeBuy + marketingFeeBuy + lpFeeBuy + buybackFeeBuy + burnFeeBuy;
396         uint128 __totalSellFee = reflectionFeeSell + marketingFeeSell + lpFeeSell + buybackFeeSell + burnFeeSell;
397 
398         require(__totalBuyFee <= MAX_FEE, "Buy fees too high");
399         require(__totalSellFee <= MAX_FEE, "Sell fees too high");
400 
401         buyFee = Fee({
402             reflection: reflectionFeeBuy,
403             marketing: reflectionFeeBuy,
404             lp: reflectionFeeBuy,
405             buyback: reflectionFeeBuy,
406             burn: burnFeeBuy,
407             total: __totalBuyFee
408         });
409 
410         sellFee = Fee({
411             reflection: reflectionFeeSell,
412             marketing: reflectionFeeSell,
413             lp: reflectionFeeSell,
414             buyback: reflectionFeeSell,
415             burn: burnFeeSell,
416             total: __totalSellFee
417         });
418     }
419 
420     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
421         isFeeExempt[holder] = exempt;
422     }
423 
424     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
425         isTxLimitExempt[holder] = exempt;
426     }
427 
428     function setFeeReceivers(address m_, address lp_, address b_) external onlyOwner {
429         marketingFeeReceiver = m_;
430         lpFeeReceiver = lp_;
431         buybackFeeReceiver = b_;
432     }
433 
434     function setMaxTxBasisPoint(uint256 p_) external onlyOwner {
435         _maxTxAmount = _totalSupply * p_ / 10000;
436     }
437 
438     function setLimitsEnabled(bool e_) external onlyOwner {
439         limitsEnabled = e_;
440     }
441 
442     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
443         blacklists[_address] = _isBlacklisting;
444     }
445 
446     /* -------------------------------------------------------------------------- */
447     /*                                   private                                  */
448     /* -------------------------------------------------------------------------- */
449     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
450         require(!blacklists[recipient] && !blacklists[sender], "Blacklisted");
451 
452         if (inSwap) {
453             return _basicTransfer(sender, recipient, amount);
454         }
455 
456         if (limitsEnabled && !isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
457             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
458         }
459 
460         if (_shouldSwapBack()) {
461             _swapBack();
462         }
463 
464         uint256 proportionAmount = tokensToProportion(amount);
465         require(_rOwned[sender] >= proportionAmount, "Insufficient Balance");
466         _rOwned[sender] = _rOwned[sender] - proportionAmount;
467 
468         uint256 proportionReceived = _shouldTakeFee(sender, recipient)
469             ? _takeFeeInProportions(sender == UNISWAP_V2_PAIR ? true : false, sender, proportionAmount)
470             : proportionAmount;
471         _rOwned[recipient] = _rOwned[recipient] + proportionReceived;
472 
473         emit Transfer(sender, recipient, tokenFromReflection(proportionReceived));
474         return true;
475     }
476 
477     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
478         uint256 proportionAmount = tokensToProportion(amount);
479         require(_rOwned[sender] >= proportionAmount, "Insufficient Balance");
480         _rOwned[sender] = _rOwned[sender] - proportionAmount;
481         _rOwned[recipient] = _rOwned[recipient] + proportionAmount;
482         emit Transfer(sender, recipient, amount);
483         return true;
484     }
485 
486     function _takeFeeInProportions(bool buying, address sender, uint256 proportionAmount) internal returns (uint256) {
487         Fee memory __buyFee = buyFee;
488         Fee memory __sellFee = sellFee;
489 
490         uint256 proportionFeeAmount =
491             buying == true ? proportionAmount * __buyFee.total / 100 : proportionAmount * __sellFee.total / 100;
492 
493         // reflect
494         uint256 proportionReflected = buying == true
495             ? proportionFeeAmount * __buyFee.reflection / __buyFee.total
496             : proportionFeeAmount * __sellFee.reflection / __sellFee.total;
497 
498         _totalProportion = _totalProportion - proportionReflected;
499 
500         // take fees
501         uint256 _proportionToContract = proportionFeeAmount - proportionReflected;
502         if (_proportionToContract > 0) {
503             _rOwned[address(this)] = _rOwned[address(this)] + _proportionToContract;
504 
505             emit Transfer(sender, address(this), tokenFromReflection(_proportionToContract));
506         }
507         emit Reflect(proportionReflected, _totalProportion);
508         return proportionAmount - proportionFeeAmount;
509     }
510 
511     function _shouldSwapBack() internal view returns (bool) {
512         return msg.sender != UNISWAP_V2_PAIR && !inSwap && claimingFees && balanceOf(address(this)) >= swapThreshold;
513     }
514 
515     function _swapBack() internal swapping {
516         Fee memory __sellFee = sellFee;
517 
518         uint256 __swapThreshold = swapThreshold;
519         uint256 amountToBurn = __swapThreshold * __sellFee.burn / __sellFee.total;
520         uint256 amountToSwap = __swapThreshold - amountToBurn;
521         approve(address(UNISWAP_V2_ROUTER), amountToSwap);
522 
523         // burn
524         _transferFrom(address(this), DEAD, amountToBurn);
525 
526         // swap
527         address[] memory path = new address[](2);
528         path[0] = address(this);
529         path[1] = UNISWAP_V2_ROUTER.WETH();
530 
531         UNISWAP_V2_ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(
532             amountToSwap, 0, path, address(this), block.timestamp
533         );
534 
535         uint256 amountETH = address(this).balance;
536 
537         uint256 totalSwapFee = __sellFee.total - __sellFee.reflection - __sellFee.burn;
538         uint256 amountETHMarketing = amountETH * __sellFee.marketing / totalSwapFee;
539         uint256 amountETHLP = amountETH * __sellFee.lp / totalSwapFee;
540         uint256 amountETHBuyback = amountETH * __sellFee.buyback / totalSwapFee;
541 
542         // send
543         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
544         (tmpSuccess,) = payable(lpFeeReceiver).call{value: amountETHLP}("");
545         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHBuyback}("");
546 
547     }
548 
549     function _shouldTakeFee(address sender, address recipient) internal view returns (bool) {
550         return !isFeeExempt[sender] && !isFeeExempt[recipient];
551     }
552 }