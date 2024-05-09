1 //EVERMARS
2 //V2
3 //
4 //https://evermars.io/
5 //https://t.me/EVERMARS_PORTAL
6 //https://twitter.com/EverMarsERC20
7 
8 
9 // SPDX-License-Identifier: UNLICENSED
10 pragma solidity ^0.8.19;
11 
12 
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
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Emitted when `value` tokens are moved from one account (`from`) to
40      * another (`to`).
41      *
42      * Note that `value` may be zero.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 
46     /**
47      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
48      * a call to {approve}. `value` is the new allowance.
49      */
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 
52     /**
53      * @dev Returns the amount of tokens in existence.
54      */
55     function totalSupply() external view returns (uint256);
56 
57     /**
58      * @dev Returns the amount of tokens owned by `account`.
59      */
60     function balanceOf(address account) external view returns (uint256);
61 
62     /**
63      * @dev Moves `amount` tokens from the caller's account to `to`.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transfer(address to, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Returns the remaining number of tokens that `spender` will be
73      * allowed to spend on behalf of `owner` through {transferFrom}. This is
74      * zero by default.
75      *
76      * This value changes when {approve} or {transferFrom} are called.
77      */
78     function allowance(address owner, address spender) external view returns (uint256);
79 
80     /**
81      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * IMPORTANT: Beware that changing an allowance with this method brings the risk
86      * that someone may use both the old and the new allowance by unfortunate
87      * transaction ordering. One possible solution to mitigate this race
88      * condition is to first reduce the spender's allowance to 0 and set the
89      * desired value afterwards:
90      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
91      *
92      * Emits an {Approval} event.
93      */
94     function approve(address spender, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Moves `amount` tokens from `from` to `to` using the
98      * allowance mechanism. `amount` is then deducted from the caller's
99      * allowance.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 amount
109     ) external returns (bool);
110 }
111 
112 /**
113  * @dev Contract module which provides a basic access control mechanism, where
114  * there is an account (an owner) that can be granted exclusive access to
115  * specific functions.
116  *
117  * By default, the owner account will be the one that deploys the contract. This
118  * can later be changed with {transferOwnership}.
119  *
120  * This module is used through inheritance. It will make available the modifier
121  * `onlyOwner`, which can be applied to your functions to restrict their use to
122  * the owner.
123  */
124 abstract contract Ownable is Context {
125     address private _owner;
126 
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129     /**
130      * @dev Initializes the contract setting the deployer as the initial owner.
131      */
132     constructor() {
133         _transferOwnership(_msgSender());
134     }
135 
136     /**
137      * @dev Throws if called by any account other than the owner.
138      */
139     modifier onlyOwner() {
140         _checkOwner();
141         _;
142     }
143 
144     /**
145      * @dev Returns the address of the current owner.
146      */
147     function owner() public view virtual returns (address) {
148         return _owner;
149     }
150 
151     /**
152      * @dev Throws if the sender is not the owner.
153      */
154     function _checkOwner() internal view virtual {
155         require(owner() == _msgSender(), "Ownable: caller is not the owner");
156     }
157 
158     /**
159      * @dev Leaves the contract without owner. It will not be possible to call
160      * `onlyOwner` functions anymore. Can only be called by the current owner.
161      *
162      * NOTE: Renouncing ownership will leave the contract without an owner,
163      * thereby removing any functionality that is only available to the owner.
164      */
165     function renounceOwnership() public virtual onlyOwner {
166         _transferOwnership(address(0));
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Can only be called by the current owner.
172      */
173     function transferOwnership(address newOwner) public virtual onlyOwner {
174         require(newOwner != address(0), "Ownable: new owner is the zero address");
175         _transferOwnership(newOwner);
176     }
177 
178     /**
179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
180      * Internal function without access restriction.
181      */
182     function _transferOwnership(address newOwner) internal virtual {
183         address oldOwner = _owner;
184         _owner = newOwner;
185         emit OwnershipTransferred(oldOwner, newOwner);
186     }
187 }
188 
189 interface IUniswapV2Router02 {
190     function factory() external pure returns (address);
191 
192     function WETH() external pure returns (address);
193 
194     function swapExactTokensForETHSupportingFeeOnTransferTokens(
195         uint256 amountIn,
196         uint256 amountOutMin,
197         address[] calldata path,
198         address to,
199         uint256 deadline
200     ) external;
201 }
202 
203 interface IUniswapV2Factory {
204     function createPair(address tokenA, address tokenB) external returns (address UNISWAP_V2_PAIR);
205 }
206 
207 contract Evermars is IERC20, Ownable {
208     /* -------------------------------------------------------------------------- */
209     /*                                   events                                   */
210     /* -------------------------------------------------------------------------- */
211     event Reflect(uint256 amountReflected, uint256 newTotalProportion);
212 
213     /* -------------------------------------------------------------------------- */
214     /*                                  constants                                 */
215     /* -------------------------------------------------------------------------- */
216     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
217     address constant ZERO = 0x0000000000000000000000000000000000000000;
218 
219     uint256 constant MAX_FEE = 25;
220 
221     /* -------------------------------------------------------------------------- */
222     /*                                   states                                   */
223     /* -------------------------------------------------------------------------- */
224     IUniswapV2Router02 public constant UNISWAP_V2_ROUTER =
225         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
226     address public immutable UNISWAP_V2_PAIR;
227 
228     struct Fee {
229         uint8 reflection;
230         uint8 marketing;
231         uint8 lp;
232         uint8 buyback;
233         uint8 burn;
234         uint128 total;
235     }
236 
237     string _name = "Evermars";
238     string _symbol = "EVERMARS";
239 
240     uint256 _totalSupply = 1_000_000_000_000 ether;
241     uint256 public _maxTxAmount = _totalSupply * 2 / 100;
242 
243     /* rOwned = ratio of tokens owned relative to circulating supply (NOT total supply, since circulating <= total) */
244     mapping(address => uint256) public _rOwned;
245     uint256 public _totalProportion = _totalSupply;
246 
247     mapping(address => mapping(address => uint256)) _allowances;
248 
249     bool public limitsEnabled = true;
250     mapping(address => bool) isFeeExempt;
251     mapping(address => bool) isTxLimitExempt;
252 
253     Fee public buyFee = Fee({reflection: 3, marketing: 2, lp: 0, buyback: 0, burn: 0, total: 5});
254     Fee public sellFee = Fee({reflection: 3, marketing: 2, lp: 0, buyback: 0, burn: 0, total: 5});
255 
256     address private marketingFeeReceiver;
257     address private lpFeeReceiver;
258     address private buybackFeeReceiver;
259 
260     bool public claimingFees = true;
261     uint256 public swapThreshold = (_totalSupply * 2) / 1000;
262     bool inSwap;
263     mapping(address => bool) public blacklists;
264 
265     /* -------------------------------------------------------------------------- */
266     /*                                  modifiers                                 */
267     /* -------------------------------------------------------------------------- */
268     modifier swapping() {
269         inSwap = true;
270         _;
271         inSwap = false;
272     }
273 
274     /* -------------------------------------------------------------------------- */
275     /*                                 constructor                                */
276     /* -------------------------------------------------------------------------- */
277     constructor() {
278         // create uniswap pair
279         address _uniswapPair =
280             IUniswapV2Factory(UNISWAP_V2_ROUTER.factory()).createPair(address(this), UNISWAP_V2_ROUTER.WETH());
281         UNISWAP_V2_PAIR = _uniswapPair;
282 
283         _allowances[address(this)][address(UNISWAP_V2_ROUTER)] = type(uint256).max;
284         _allowances[address(this)][tx.origin] = type(uint256).max;
285 
286         isTxLimitExempt[address(this)] = true;
287         isTxLimitExempt[address(UNISWAP_V2_ROUTER)] = true;
288         isTxLimitExempt[_uniswapPair] = true;
289         isTxLimitExempt[tx.origin] = true;
290         isFeeExempt[tx.origin] = true;
291 
292         marketingFeeReceiver = 0xDd7e5E6Ea82863456f1D3510BF45d10E445Bff2e;
293         lpFeeReceiver = 0xDd7e5E6Ea82863456f1D3510BF45d10E445Bff2e;
294         buybackFeeReceiver = 0xDd7e5E6Ea82863456f1D3510BF45d10E445Bff2e;
295 
296         _rOwned[tx.origin] = _totalSupply;
297         emit Transfer(address(0), tx.origin, _totalSupply);
298     }
299 
300     receive() external payable {}
301 
302     /* -------------------------------------------------------------------------- */
303     /*                                    ERC20                                   */
304     /* -------------------------------------------------------------------------- */
305     function approve(address spender, uint256 amount) public override returns (bool) {
306         _allowances[msg.sender][spender] = amount;
307         emit Approval(msg.sender, spender, amount);
308         return true;
309     }
310 
311     function approveMax(address spender) external returns (bool) {
312         return approve(spender, type(uint256).max);
313     }
314 
315     function transfer(address recipient, uint256 amount) external override returns (bool) {
316         return _transferFrom(msg.sender, recipient, amount);
317     }
318 
319     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
320         if (_allowances[sender][msg.sender] != type(uint256).max) {
321             require(_allowances[sender][msg.sender] >= amount, "ERC20: insufficient allowance");
322             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
323         }
324 
325         return _transferFrom(sender, recipient, amount);
326     }
327 
328     /* -------------------------------------------------------------------------- */
329     /*                                    views                                   */
330     /* -------------------------------------------------------------------------- */
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
367     /* -------------------------------------------------------------------------- */
368     /*                                   owners                                   */
369     /* -------------------------------------------------------------------------- */
370     function clearStuckBalance() external onlyOwner {
371         (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
372         require(success);
373     }
374 
375     function clearStuckToken() external onlyOwner {
376         _transferFrom(address(this), msg.sender, balanceOf(address(this)));
377     }
378 
379     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
380         claimingFees = _enabled;
381         swapThreshold = _amount;
382     }
383 
384     function changeFees(
385         uint8 reflectionFeeBuy,
386         uint8 marketingFeeBuy,
387         uint8 lpFeeBuy,
388         uint8 buybackFeeBuy,
389         uint8 burnFeeBuy,
390         uint8 reflectionFeeSell,
391         uint8 marketingFeeSell,
392         uint8 lpFeeSell,
393         uint8 buybackFeeSell,
394         uint8 burnFeeSell
395     ) external onlyOwner {
396         uint128 __totalBuyFee = reflectionFeeBuy + marketingFeeBuy + lpFeeBuy + buybackFeeBuy + burnFeeBuy;
397         uint128 __totalSellFee = reflectionFeeSell + marketingFeeSell + lpFeeSell + buybackFeeSell + burnFeeSell;
398 
399         require(__totalBuyFee <= MAX_FEE, "Buy fees too high");
400         require(__totalSellFee <= MAX_FEE, "Sell fees too high");
401 
402         buyFee = Fee({
403             reflection: reflectionFeeBuy,
404             marketing: reflectionFeeBuy,
405             lp: reflectionFeeBuy,
406             buyback: reflectionFeeBuy,
407             burn: burnFeeBuy,
408             total: __totalBuyFee
409         });
410 
411         sellFee = Fee({
412             reflection: reflectionFeeSell,
413             marketing: reflectionFeeSell,
414             lp: reflectionFeeSell,
415             buyback: reflectionFeeSell,
416             burn: burnFeeSell,
417             total: __totalSellFee
418         });
419     }
420 
421     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
422         isFeeExempt[holder] = exempt;
423     }
424 
425     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
426         isTxLimitExempt[holder] = exempt;
427     }
428 
429     function setFeeReceivers(address m_, address lp_, address b_) external onlyOwner {
430         marketingFeeReceiver = m_;
431         lpFeeReceiver = lp_;
432         buybackFeeReceiver = b_;
433     }
434 
435     function setMaxTxBasisPoint(uint256 p_) external onlyOwner {
436         _maxTxAmount = _totalSupply * p_ / 10000;
437     }
438 
439     function setLimitsEnabled(bool e_) external onlyOwner {
440         limitsEnabled = e_;
441     }
442 
443     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
444         blacklists[_address] = _isBlacklisting;
445     }
446 
447     /* -------------------------------------------------------------------------- */
448     /*                                   private                                  */
449     /* -------------------------------------------------------------------------- */
450     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
451         require(!blacklists[recipient] && !blacklists[sender], "Blacklisted");
452 
453         if (inSwap) {
454             return _basicTransfer(sender, recipient, amount);
455         }
456 
457         if (limitsEnabled && !isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
458             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
459         }
460 
461         if (_shouldSwapBack()) {
462             _swapBack();
463         }
464 
465         uint256 proportionAmount = tokensToProportion(amount);
466         require(_rOwned[sender] >= proportionAmount, "Insufficient Balance");
467         _rOwned[sender] = _rOwned[sender] - proportionAmount;
468 
469         uint256 proportionReceived = _shouldTakeFee(sender, recipient)
470             ? _takeFeeInProportions(sender == UNISWAP_V2_PAIR ? true : false, sender, proportionAmount)
471             : proportionAmount;
472         _rOwned[recipient] = _rOwned[recipient] + proportionReceived;
473 
474         emit Transfer(sender, recipient, tokenFromReflection(proportionReceived));
475         return true;
476     }
477 
478     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
479         uint256 proportionAmount = tokensToProportion(amount);
480         require(_rOwned[sender] >= proportionAmount, "Insufficient Balance");
481         _rOwned[sender] = _rOwned[sender] - proportionAmount;
482         _rOwned[recipient] = _rOwned[recipient] + proportionAmount;
483         emit Transfer(sender, recipient, amount);
484         return true;
485     }
486 
487     function _takeFeeInProportions(bool buying, address sender, uint256 proportionAmount) internal returns (uint256) {
488         Fee memory __buyFee = buyFee;
489         Fee memory __sellFee = sellFee;
490 
491         uint256 proportionFeeAmount =
492             buying == true ? proportionAmount * __buyFee.total / 100 : proportionAmount * __sellFee.total / 100;
493 
494         // reflect
495         uint256 proportionReflected = buying == true
496             ? proportionFeeAmount * __buyFee.reflection / __buyFee.total
497             : proportionFeeAmount * __sellFee.reflection / __sellFee.total;
498 
499         _totalProportion = _totalProportion - proportionReflected;
500 
501         // take fees
502         uint256 _proportionToContract = proportionFeeAmount - proportionReflected;
503         if (_proportionToContract > 0) {
504             _rOwned[address(this)] = _rOwned[address(this)] + _proportionToContract;
505 
506             emit Transfer(sender, address(this), tokenFromReflection(_proportionToContract));
507         }
508         emit Reflect(proportionReflected, _totalProportion);
509         return proportionAmount - proportionFeeAmount;
510     }
511 
512     function _shouldSwapBack() internal view returns (bool) {
513         return msg.sender != UNISWAP_V2_PAIR && !inSwap && claimingFees && balanceOf(address(this)) >= swapThreshold;
514     }
515 
516     function _swapBack() internal swapping {
517         Fee memory __sellFee = sellFee;
518 
519         uint256 __swapThreshold = swapThreshold;
520         uint256 amountToBurn = __swapThreshold * __sellFee.burn / __sellFee.total;
521         uint256 amountToSwap = __swapThreshold - amountToBurn;
522         approve(address(UNISWAP_V2_ROUTER), amountToSwap);
523 
524         // burn
525         _transferFrom(address(this), DEAD, amountToBurn);
526 
527         // swap
528         address[] memory path = new address[](2);
529         path[0] = address(this);
530         path[1] = UNISWAP_V2_ROUTER.WETH();
531 
532         UNISWAP_V2_ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(
533             amountToSwap, 0, path, address(this), block.timestamp
534         );
535 
536         uint256 amountETH = address(this).balance;
537 
538         uint256 totalSwapFee = __sellFee.total - __sellFee.reflection - __sellFee.burn;
539         uint256 amountETHMarketing = amountETH * __sellFee.marketing / totalSwapFee;
540         uint256 amountETHLP = amountETH * __sellFee.lp / totalSwapFee;
541         uint256 amountETHBuyback = amountETH * __sellFee.buyback / totalSwapFee;
542 
543         // send
544         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
545         (tmpSuccess,) = payable(lpFeeReceiver).call{value: amountETHLP}("");
546         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHBuyback}("");
547 
548     }
549 
550     function _shouldTakeFee(address sender, address recipient) internal view returns (bool) {
551         return !isFeeExempt[sender] && !isFeeExempt[recipient];
552     }
553 }