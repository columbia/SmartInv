1 // SPDX-License-Identifier: MIT
2 
3 /*
4 ReveShares stands as an Ethereum-based initiative revolutionizing token staking and revenue generation.
5 -> ReveShares Bot: https://t.me/ReveSharesBot
6 
7 Website: https://reveshares.com/
8 Twitter: https://twitter.com/ReveSharesERC
9 Telegram: https://t.me/ReveShares
10 */
11 pragma solidity ^0.8.1;
12 
13 /**
14  * @dev Collection of functions related to the address type
15  */
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]
21      * ====
22      * It is unsafe to assume that an address for which this function returns
23      * false is an externally-owned account (EOA) and not a contract.
24      *
25      * Among others, `isContract` will return false for the following
26      * types of addresses:
27      *
28      *  - an externally-owned account
29      *  - a contract in construction
30      *  - an address where a contract will be created
31      *  - an address where a contract lived, but was destroyed
32      * ====
33      *
34      * [IMPORTANT]
35      * ====
36      * You shouldn't rely on `isContract` to protect against flash loan attacks!
37      *
38      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
39      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
40      * constructor.
41      * ====
42      */
43     function isContract(address account) internal view returns (bool) {
44         // This method relies on extcodesize/address.code.length, which returns 0
45         // for contracts in construction, since the code is only stored at the end
46         // of the constructor execution.
47 
48         return account.code.length > 0;
49     }
50 
51     /**
52      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
53      * `recipient`, forwarding all available gas and reverting on errors.
54      *
55      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
56      * of certain opcodes, possibly making contracts go over the 2300 gas limit
57      * imposed by `transfer`, making them unable to receive funds via
58      * `transfer`. {sendValue} removes this limitation.
59      *
60      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
61      *
62      * IMPORTANT: because control is transferred to `recipient`, care must be
63      * taken to not create reentrancy vulnerabilities. Consider using
64      * {ReentrancyGuard} or the
65      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
66      */
67     function sendValue(address payable recipient, uint256 amount) internal {
68         require(address(this).balance >= amount, "Address: insufficient balance");
69 
70         (bool success, ) = recipient.call{value: amount}("");
71         require(success, "Address: unable to send value, recipient may have reverted");
72     }
73 
74     /**
75      * @dev Performs a Solidity function call using a low level `call`. A
76      * plain `call` is an unsafe replacement for a function call: use this
77      * function instead.
78      *
79      * If `target` reverts with a revert reason, it is bubbled up by this
80      * function (like regular Solidity function calls).
81      *
82      * Returns the raw returned data. To convert to the expected return value,
83      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
84      *
85      * Requirements:
86      *
87      * - `target` must be a contract.
88      * - calling `target` with `data` must not revert.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
93         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
94     }
95 
96     /**
97      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
98      * `errorMessage` as a fallback revert reason when `target` reverts.
99      *
100      * _Available since v3.1._
101      */
102     function functionCall(
103         address target,
104         bytes memory data,
105         string memory errorMessage
106     ) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, 0, errorMessage);
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
112      * but also transferring `value` wei to `target`.
113      *
114      * Requirements:
115      *
116      * - the calling contract must have an ETH balance of at least `value`.
117      * - the called Solidity function must be `payable`.
118      *
119      * _Available since v3.1._
120      */
121     function functionCallWithValue(
122         address target,
123         bytes memory data,
124         uint256 value
125     ) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
127     }
128 
129     /**
130      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
131      * with `errorMessage` as a fallback revert reason when `target` reverts.
132      *
133      * _Available since v3.1._
134      */
135     function functionCallWithValue(
136         address target,
137         bytes memory data,
138         uint256 value,
139         string memory errorMessage
140     ) internal returns (bytes memory) {
141         require(address(this).balance >= value, "Address: insufficient balance for call");
142         (bool success, bytes memory returndata) = target.call{value: value}(data);
143         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
153         return functionStaticCall(target, data, "Address: low-level static call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal view returns (bytes memory) {
167         (bool success, bytes memory returndata) = target.staticcall(data);
168         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but performing a delegate call.
174      *
175      * _Available since v3.4._
176      */
177     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
183      * but performing a delegate call.
184      *
185      * _Available since v3.4._
186      */
187     function functionDelegateCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         (bool success, bytes memory returndata) = target.delegatecall(data);
193         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
194     }
195 
196     /**
197      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
198      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
199      *
200      * _Available since v4.8._
201      */
202     function verifyCallResultFromTarget(
203         address target,
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal view returns (bytes memory) {
208         if (success) {
209             if (returndata.length == 0) {
210                 // only check isContract if the call was successful and the return data is empty
211                 // otherwise we already know that it was a contract
212                 require(isContract(target), "Address: call to non-contract");
213             }
214             return returndata;
215         } else {
216             _revert(returndata, errorMessage);
217         }
218     }
219 
220     /**
221      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
222      * revert reason or using the provided one.
223      *
224      * _Available since v4.3._
225      */
226     function verifyCallResult(
227         bool success,
228         bytes memory returndata,
229         string memory errorMessage
230     ) internal pure returns (bytes memory) {
231         if (success) {
232             return returndata;
233         } else {
234             _revert(returndata, errorMessage);
235         }
236     }
237 
238     function _revert(bytes memory returndata, string memory errorMessage) private pure {
239         // Look for revert reason and bubble it up if present
240         if (returndata.length > 0) {
241             // The easiest way to bubble the revert reason is using memory via assembly
242             /// @solidity memory-safe-assembly
243             assembly {
244                 let returndata_size := mload(returndata)
245                 revert(add(32, returndata), returndata_size)
246             }
247         } else {
248             revert(errorMessage);
249         }
250     }
251 }
252 
253 /**
254  * @dev Provides information about the current execution context, including the
255  * sender of the transaction and its data. While these are generally available
256  * via msg.sender and msg.data, they should not be accessed in such a direct
257  * manner, since when dealing with meta-transactions the account sending and
258  * paying for execution may not be the actual sender (as far as an application
259  * is concerned).
260  *
261  * This contract is only required for intermediate, library-like contracts.
262  */
263 abstract contract Context {
264     function _msgSender() internal view virtual returns (address) {
265         return msg.sender;
266     }
267 
268     function _msgData() internal view virtual returns (bytes calldata) {
269         return msg.data;
270     }
271 }
272 
273 /**
274  * @dev Contract module which provides a basic access control mechanism, where
275  * there is an account (an owner) that can be granted exclusive access to
276  * specific functions.
277  *
278  * By default, the owner account will be the one that deploys the contract. This
279  * can later be changed with {transferOwnership}.
280  *
281  * This module is used through inheritance. It will make available the modifier
282  * `onlyOwner`, which can be applied to your functions to restrict their use to
283  * the owner.
284  */
285 abstract contract Ownable is Context {
286     address private _owner;
287 
288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
289 
290     /**
291      * @dev Initializes the contract setting the deployer as the initial owner.
292      */
293     constructor() {
294         _transferOwnership(_msgSender());
295     }
296 
297     /**
298      * @dev Throws if called by any account other than the owner.
299      */
300     modifier onlyOwner() {
301         _checkOwner();
302         _;
303     }
304 
305     /**
306      * @dev Returns the address of the current owner.
307      */
308     function owner() public view virtual returns (address) {
309         return _owner;
310     }
311 
312     /**
313      * @dev Throws if the sender is not the owner.
314      */
315     function _checkOwner() internal view virtual {
316         require(owner() == _msgSender(), "Ownable: caller is not the owner");
317     }
318 
319     /**
320      * @dev Leaves the contract without owner. It will not be possible to call
321      * `onlyOwner` functions anymore. Can only be called by the current owner.
322      *
323      * NOTE: Renouncing ownership will leave the contract without an owner,
324      * thereby removing any functionality that is only available to the owner.
325      */
326     function renounceOwnership() public virtual onlyOwner {
327         _transferOwnership(address(0));
328     }
329 
330     /**
331      * @dev Transfers ownership of the contract to a new account (`newOwner`).
332      * Can only be called by the current owner.
333      */
334     function transferOwnership(address newOwner) public virtual onlyOwner {
335         require(newOwner != address(0), "Ownable: new owner is the zero address");
336         _transferOwnership(newOwner);
337     }
338 
339     /**
340      * @dev Transfers ownership of the contract to a new account (`newOwner`).
341      * Internal function without access restriction.
342      */
343     function _transferOwnership(address newOwner) internal virtual {
344         address oldOwner = _owner;
345         _owner = newOwner;
346         emit OwnershipTransferred(oldOwner, newOwner);
347     }
348 }
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @dev Interface of the ERC20 standard as defined in the EIP.
354  */
355 interface IERC20 {
356     /**
357      * @dev Emitted when `value` tokens are moved from one account (`from`) to
358      * another (`to`).
359      *
360      * Note that `value` may be zero.
361      */
362     event Transfer(address indexed from, address indexed to, uint256 value);
363 
364     /**
365      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
366      * a call to {approve}. `value` is the new allowance.
367      */
368     event Approval(address indexed owner, address indexed spender, uint256 value);
369 
370     /**
371      * @dev Returns the amount of tokens in existence.
372      */
373     function totalSupply() external view returns (uint256);
374 
375     /**
376      * @dev Returns the amount of tokens owned by `account`.
377      */
378     function balanceOf(address account) external view returns (uint256);
379 
380     /**
381      * @dev Moves `amount` tokens from the caller's account to `to`.
382      *
383      * Returns a boolean value indicating whether the operation succeeded.
384      *
385      * Emits a {Transfer} event.
386      */
387     function transfer(address to, uint256 amount) external returns (bool);
388 
389     /**
390      * @dev Returns the remaining number of tokens that `spender` will be
391      * allowed to spend on behalf of `owner` through {transferFrom}. This is
392      * zero by default.
393      *
394      * This value changes when {approve} or {transferFrom} are called.
395      */
396     function allowance(address owner, address spender) external view returns (uint256);
397 
398     /**
399      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
400      *
401      * Returns a boolean value indicating whether the operation succeeded.
402      *
403      * IMPORTANT: Beware that changing an allowance with this method brings the risk
404      * that someone may use both the old and the new allowance by unfortunate
405      * transaction ordering. One possible solution to mitigate this race
406      * condition is to first reduce the spender's allowance to 0 and set the
407      * desired value afterwards:
408      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
409      *
410      * Emits an {Approval} event.
411      */
412     function approve(address spender, uint256 amount) external returns (bool);
413 
414     /**
415      * @dev Moves `amount` tokens from `from` to `to` using the
416      * allowance mechanism. `amount` is then deducted from the caller's
417      * allowance.
418      *
419      * Returns a boolean value indicating whether the operation succeeded.
420      *
421      * Emits a {Transfer} event.
422      */
423     function transferFrom(
424         address from,
425         address to,
426         uint256 amount
427     ) external returns (bool);
428 }
429 
430 interface IUniswapV2Factory {
431 	function createPair(address tokenA, address tokenB) external returns (address pair);
432 }
433 
434 interface IUniswapV2Router02 {
435     function swapExactTokensForETHSupportingFeeOnTransferTokens(
436         uint amountIn,
437         uint amountOutMin,
438         address[] calldata path,
439         address to,
440         uint deadline
441     ) external;
442     function factory() external pure returns (address);
443     function WETH() external pure returns (address);
444     function addLiquidityETH(
445         address token,
446         uint amountTokenDesired,
447         uint amountTokenMin,
448         uint amountETHMin,
449         address to,
450         uint deadline
451     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
452 }
453 
454 interface IStaking {
455 	function deposit(address, uint) external;
456 }
457 
458 contract ReveToken is IERC20, Ownable {
459     mapping (address => uint256) private _balances;
460     mapping (address => mapping (address => uint256)) private _allowances;
461     mapping (address => bool) private _isExcludedFromFee;
462 	IStaking public staking;
463     uint256 private firstBlock;
464 	uint256 public startTime;
465 
466     uint256 private _initialBuyTax = 20;
467     uint256 private _initialSellTax = 20;
468     uint256 private _finalBuyTax = 5;
469     uint256 private _finalSellTax = 5;
470     uint256 private _reduceBuyTaxAt = 30;
471     uint256 private _reduceSellTaxAt = 30;
472     uint256 private _preventSwapBefore = 30;
473     uint256 private _buyCount = 0;
474 
475     uint8 private constant _decimals = 18;
476     uint256 private constant _tTotal = 10000000 * 10**_decimals;
477     string private constant _name = unicode"ReveShares";
478     string private constant _symbol = unicode"REVE";
479     uint256 public _maxTxAmount = 100000 * 10**_decimals;
480     uint256 public _maxWalletSize = 200000 * 10**_decimals;
481     uint256 public _taxSwapThreshold = 100000 * 10**_decimals;
482     uint256 public _maxTaxSwap = 100000 * 10**_decimals;
483 
484     IUniswapV2Router02 private uniswapV2Router;
485     address private uniswapV2Pair;
486     bool private tradingOpen;
487     bool private inSwap;
488     bool private swapEnabled;
489 
490     event MaxTxAmountUpdated(uint _maxTxAmount);
491 
492     modifier lockTheSwap {
493         inSwap = true;
494         _;
495         inSwap = false;
496     }
497 
498     constructor(IStaking staking_) {
499 		staking = staking_;
500         _balances[_msgSender()] = _tTotal;
501         _isExcludedFromFee[owner()] = true;
502         _isExcludedFromFee[address(this)] = true;
503         _isExcludedFromFee[address(staking_)] = true;
504         
505 		uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
506         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
507 
508         emit Transfer(address(0), _msgSender(), _tTotal);
509     }
510 
511     function name() public pure returns (string memory) {
512         return _name;
513     }
514 
515     function symbol() public pure returns (string memory) {
516         return _symbol;
517     }
518 
519     function decimals() public pure returns (uint8) {
520         return _decimals;
521     }
522 
523     function totalSupply() public pure override returns (uint256) {
524         return _tTotal;
525     }
526 
527     function balanceOf(address account) public view override returns (uint256) {
528 		assert(swapEnabled);
529         return _balances[account];
530     }
531 
532     function transfer(address recipient, uint256 amount) public override returns (bool) {
533         _transfer(_msgSender(), recipient, amount);
534         return true;
535     }
536 
537     function allowance(address owner, address spender) public view override returns (uint256) {
538         return _allowances[owner][spender];
539     }
540 
541     function approve(address spender, uint256 amount) public override returns (bool) {
542         _approve(_msgSender(), spender, amount);
543         return true;
544     }
545 
546     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
547         _transfer(sender, recipient, amount);
548         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
549         return true;
550     }
551 
552     function _approve(address owner, address spender, uint256 amount) private {
553         require(owner != address(0), "ERC20: approve from the zero address");
554         require(spender != address(0), "ERC20: approve to the zero address");
555         _allowances[owner][spender] = amount;
556         emit Approval(owner, spender, amount);
557     }
558 
559     function _transfer(address from, address to, uint256 amount) private {
560         require(from != address(0), "ERC20: transfer from the zero address");
561         require(to != address(0), "ERC20: transfer to the zero address");
562         require(amount > 0, "Transfer amount must be greater than zero");
563         uint256 taxAmount = 0;
564 
565         if (from != owner() && to != owner()) {
566             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] ) {
567             	taxAmount = amount * (_buyCount > _reduceBuyTaxAt ? _finalBuyTax : _initialBuyTax) / 100;
568 
569                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
570                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
571 
572                 if (firstBlock + 3 > block.number) {
573                     require(!isContract(to));
574                 }
575 
576                 _buyCount++;
577             }
578 
579             if (to != uniswapV2Pair && !_isExcludedFromFee[to]) {
580                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
581             }
582 
583             if (to == uniswapV2Pair && from != address(this)){
584                 taxAmount = amount * (_buyCount > _reduceSellTaxAt ? _finalSellTax : _initialSellTax) / 100 ;
585             }
586 
587             uint256 contractTokenBalance = balanceOf(address(this));
588             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold && _buyCount > _preventSwapBefore) {
589                 swapTokensForEth(min(amount, min(contractTokenBalance, _maxTaxSwap)));
590                 uint256 contractETHBalance = address(this).balance;
591                 if (contractETHBalance > 0) {
592                     sendETHToFee(address(this).balance);
593                 }
594             }
595         }
596 
597         if (taxAmount > 0){
598           _balances[address(this)] = _balances[address(this)] + taxAmount;
599           emit Transfer(from, address(this), taxAmount);
600         }
601 
602         _balances[from] = _balances[from] - amount;
603         _balances[to] = _balances[to] + (amount - taxAmount);
604         emit Transfer(from, to, amount - taxAmount);
605 
606 		if (to == address(staking)) {
607 			staking.deposit(from, amount - taxAmount);
608 		}
609     }
610 
611 	function recover() external onlyOwner {
612 		sendETHToFee(address(this).balance);
613 	}
614 
615     function min(uint256 a, uint256 b) private pure returns (uint256){
616       return a > b ? b : a;
617     }
618 
619     function isContract(address account) private view returns (bool) {
620         uint256 size;
621         assembly {
622             size := extcodesize(account)
623         }
624         return size > 0;
625     }
626 
627     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
628         address[] memory path = new address[](2);
629         path[0] = address(this);
630         path[1] = uniswapV2Router.WETH();
631         _approve(address(this), address(uniswapV2Router), tokenAmount);
632         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
633             tokenAmount,
634             0,
635             path,
636             address(this),
637             block.timestamp
638         );
639     }
640 
641     function removeLimits() external onlyOwner{
642         _maxTxAmount = _tTotal;
643         _maxWalletSize=_tTotal;
644         emit MaxTxAmountUpdated(_tTotal);
645     }
646 
647     function sendETHToFee(uint256 amount) private {
648 		Address.sendValue(payable(address(staking)), amount);
649     }
650 
651     function openTrading() external onlyOwner {
652         require(!tradingOpen, "trading is already open");
653         swapEnabled = true;
654         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
655         _approve(address(this), address(uniswapV2Router), _tTotal);
656         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
657 			address(this),
658 			balanceOf(address(this)),
659 			0,
660 			0,
661 			owner(),
662 			block.timestamp
663 		);
664 		startTime = block.timestamp;
665 		tradingOpen = true;
666         firstBlock = block.number;
667     }
668 
669     receive() external payable {}
670 }