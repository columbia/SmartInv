1 /**
2 
3 Metchain - MET
4 
5 The Metchain protocol is a platform dedicated to accelerate the adoption of the Metaverse worldwide. Metchain aims to achieve INTEROPERABILITY and SCALABILITY within the Metaverse and beyond …
6 
7 The metaverse has the potential to revolutionize the way we interact with digital content and it is near, as technology continues to evolve at a pace faster than ever and Metchain has the product and vision to compete in this field and excel. 
8 
9 MET acts as a medium of value, allowing access to services that integrate the latest Metaverse technologies that bring the users closer to the edge of reality as Metchain bridges the gap between Metaverse and Reality with MET!
10 
11 ⌼ Website: www.metchain.tech 
12 ⌼ Telegram: https://t.me/metchain_erc20 
13 ⌼ Twitter: https://twitter.com/MetChain_tech 
14 ⌼ Medium: https://medium.com/@Metchain
15 Socails :- https://linktr.ee/metchain
16 
17 */
18 
19 pragma solidity ^0.8.9;
20 // SPDX-License-Identifier: Unlicensed
21 interface IERC20 {
22 
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      *
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      *
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      *
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * Reverts when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         return mod(a, b, "SafeMath: modulo by zero");
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts with custom message when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      *
251      * [IMPORTANT]
252      * ====
253      * You shouldn't rely on `isContract` to protect against flash loan attacks!
254      *
255      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
256      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
257      * constructor.
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // This method relies on extcodesize/address.code.length, which returns 0
262         // for contracts in construction, since the code is only stored at the end
263         // of the constructor execution.
264 
265         return account.code.length > 0;
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         (bool success, ) = recipient.call{value: amount}("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain `call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         require(isContract(target), "Address: call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.call{value: value}(data);
362         return verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal view returns (bytes memory) {
386         require(isContract(target), "Address: static call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.staticcall(data);
389         return verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
399         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(isContract(target), "Address: delegate call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.delegatecall(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
421      * revert reason using the provided one.
422      *
423      * _Available since v4.3._
424      */
425     function verifyCallResult(
426         bool success,
427         bytes memory returndata,
428         string memory errorMessage
429     ) internal pure returns (bytes memory) {
430         if (success) {
431             return returndata;
432         } else {
433             // Look for revert reason and bubble it up if present
434             if (returndata.length > 0) {
435                 // The easiest way to bubble the revert reason is using memory via assembly
436 
437                 assembly {
438                     let returndata_size := mload(returndata)
439                     revert(add(32, returndata), returndata_size)
440                 }
441             } else {
442                 revert(errorMessage);
443             }
444         }
445     }
446 }
447 
448 library SafeERC20 {
449     using Address for address;
450 
451     function safeTransfer(
452         IERC20 token,
453         address to,
454         uint256 value
455     ) internal {
456         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
457     }
458 
459     function safeTransferFrom(
460         IERC20 token,
461         address from,
462         address to,
463         uint256 value
464     ) internal {
465         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
466     }
467 
468     /**
469      * @dev Deprecated. This function has issues similar to the ones found in
470      * {IERC20-approve}, and its usage is discouraged.
471      *
472      * Whenever possible, use {safeIncreaseAllowance} and
473      * {safeDecreaseAllowance} instead.
474      */
475     function safeApprove(
476         IERC20 token,
477         address spender,
478         uint256 value
479     ) internal {
480         // safeApprove should only be called when setting an initial allowance,
481         // or when resetting it to zero. To increase and decrease it, use
482         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
483         require(
484             (value == 0) || (token.allowance(address(this), spender) == 0),
485             "SafeERC20: approve from non-zero to non-zero allowance"
486         );
487         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
488     }
489 
490     function safeIncreaseAllowance(
491         IERC20 token,
492         address spender,
493         uint256 value
494     ) internal {
495         uint256 newAllowance = token.allowance(address(this), spender) + value;
496         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
497     }
498 
499     function safeDecreaseAllowance(
500         IERC20 token,
501         address spender,
502         uint256 value
503     ) internal {
504         unchecked {
505             uint256 oldAllowance = token.allowance(address(this), spender);
506             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
507             uint256 newAllowance = oldAllowance - value;
508             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
509         }
510     }
511 
512     /**
513      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
514      * on the return value: the return value is optional (but if data is returned, it must not be false).
515      * @param token The token targeted by the call.
516      * @param data The call data (encoded using abi.encode or one of its variants).
517      */
518     function _callOptionalReturn(IERC20 token, bytes memory data) private {
519         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
520         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
521         // the target address contains contract code and also asserts for success in the low-level call.
522 
523         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
524         if (returndata.length > 0) {
525             // Return data is optional
526             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
527         }
528     }
529 }
530 
531 abstract contract Context {
532     //function _msgSender() internal view virtual returns (address payable) {
533     function _msgSender() internal view virtual returns (address) {
534         return msg.sender;
535     }
536 
537     function _msgData() internal view virtual returns (bytes memory) {
538         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
539         return msg.data;
540     }
541 }
542 
543 abstract contract Ownable is Context {
544     address private _owner;
545 
546     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
547 
548     /**
549      * @dev Initializes the contract setting the deployer as the initial owner.
550      */
551     constructor() {
552         _transferOwnership(_msgSender());
553     }
554 
555     /**
556      * @dev Returns the address of the current owner.
557      */
558     function owner() public view virtual returns (address) {
559         return _owner;
560     }
561 
562     /**
563      * @dev Throws if called by any account other than the owner.
564      */
565     modifier onlyOwner() {
566         require(owner() == _msgSender(), "Ownable: caller is not the owner");
567         _;
568     }
569 
570     /**
571      * @dev Leaves the contract without owner. It will not be possible to call
572      * `onlyOwner` functions anymore. Can only be called by the current owner.
573      *
574      * NOTE: Renouncing ownership will leave the contract without an owner,
575      * thereby removing any functionality that is only available to the owner.
576      */
577     function renounceOwnership() public virtual onlyOwner {
578         _transferOwnership(address(0));
579     }
580 
581     /**
582      * @dev Transfers ownership of the contract to a new account (`newOwner`).
583      * Can only be called by the current owner.
584      */
585     function transferOwnership(address newOwner) public virtual onlyOwner {
586         require(newOwner != address(0), "Ownable: new owner is the zero address");
587         _transferOwnership(newOwner);
588     }
589 
590     /**
591      * @dev Transfers ownership of the contract to a new account (`newOwner`).
592      * Internal function without access restriction.
593      */
594     function _transferOwnership(address newOwner) internal virtual {
595         address oldOwner = _owner;
596         _owner = newOwner;
597         emit OwnershipTransferred(oldOwner, newOwner);
598     }
599 }
600 
601 interface IUniswapV2Factory {
602     function getPair(address tokenA, address tokenB) external view returns (address pair);
603     function createPair(address tokenA, address tokenB) external returns (address pair);
604 }
605 
606 interface IUniswapV2Router01 {
607     function factory() external pure returns (address);
608     function WETH() external pure returns (address);
609 
610     function addLiquidityETH(
611         address token,
612         uint amountTokenDesired,
613         uint amountTokenMin,
614         uint amountETHMin,
615         address to,
616         uint deadline
617     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
618     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
619 }
620 
621 interface IUniswapV2Router02 is IUniswapV2Router01 {
622     function swapExactTokensForETHSupportingFeeOnTransferTokens(
623         uint amountIn,
624         uint amountOutMin,
625         address[] calldata path,
626         address to,
627         uint deadline
628     ) external;
629 }
630 
631 interface IUniswapV2Pair {
632     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
633 }
634 
635 contract MetChain is IERC20, Ownable {
636     using SafeMath for uint256;
637 
638     mapping (address => uint256) private _rOwned;
639     mapping (address => uint256) private _tOwned;
640     mapping (address => mapping (address => uint256)) private _allowances;
641 
642     mapping (address => bool) private _isExcludedFromFee;
643 
644     mapping (address => bool) private _isExcluded;
645     mapping (address => bool) private _isExcludedMaxWallet;
646     mapping (address => bool) private _isExcludedMaxTx;
647 
648     address[] public _excluded;
649     
650     mapping(address => bool) public automatedMarketMakerPairs;
651 
652     address constant public burnWallet = 0x000000000000000000000000000000000000dEaD;
653 
654     uint256 private marketingFeesCollected;
655     uint256 private liquidityFeesCollected;
656     uint256 private burnFeesCollected;
657 
658     uint256 public maxWalletSize;
659     uint256 public maxTx;
660 
661     uint256 _minLpTokens = 2;
662 
663     bool public canTrade;
664 
665     address public uniswapPair;
666 
667     uint256 public _tTotal;
668     uint256 public _rTotal;
669     uint256 private _tFeeTotal;
670     address public marketingWallet;
671 
672     string private _name;
673     string private _symbol;
674     uint8 private _decimals;
675     
676     uint256 private _taxFee;
677     uint256 public _taxFeeTransfer;
678     uint256 public _taxFeeBuy;
679     uint256 public _taxFeeSell;
680     uint256 private _previousTaxFee;
681 
682     uint256 private _marketingFee;
683     uint256 public _marketingFeeTransfer;
684     uint256 public _marketingFeeBuy;
685     uint256 public _marketingFeeSell;
686     uint256 public _previousMarketingFee;
687     
688     uint256 private _liquidityFee;
689     uint256 public _liquidityFeeTransfer;
690     uint256 public _liquidityFeeBuy;
691     uint256 public _liquidityFeeSell;
692     uint256 private _previousLiquidityFee;
693 
694     uint256 private _burnFee;
695     uint256 public _burnFeeTransfer;
696     uint256 public _burnFeeBuy;
697     uint256 public _burnFeeSell;
698     uint256 private _previousBurnFee;
699 
700     uint256 public _feeDenominator;
701 
702     bool private hasLiquidity;
703 
704     IUniswapV2Router02 public immutable uniswapV2Router;
705     
706     bool inSwapAndLiquify;
707     bool public swapAndLiquifyEnabled = true;
708     
709     event SwapAndLiquifyEnabledUpdated(bool enabled);
710     event SwapAndLiquify(
711         uint256 tokensSwapped,
712         uint256 ethReceived,
713         uint256 tokensIntoLiqudity
714     );
715     
716     modifier lockTheSwap {
717         inSwapAndLiquify = true;
718         _;
719         inSwapAndLiquify = false;
720     }
721 
722     constructor () {
723         _name = "Metchain";
724         _symbol = "MET";
725         _decimals = 9;
726         uint256 MAX = ~uint256(0);
727         
728         _tTotal = 10e6 * 10 ** _decimals;
729         _rTotal = MAX - (MAX % _tTotal);
730 
731         maxWalletSize = _tTotal * 2 / 100;
732         maxTx = _tTotal / 100;
733 
734         _rOwned[_msgSender()] = _rTotal;
735 
736         _taxFeeBuy = 0;
737         _marketingFeeBuy = 300;
738         _liquidityFeeBuy = 100;
739         _burnFeeBuy = 0;
740 
741         _taxFeeSell = 0;
742         _marketingFeeSell = 700;
743         _liquidityFeeSell = 100;
744         _burnFeeSell = 0;
745 
746         _taxFeeTransfer = 0;
747         _marketingFeeTransfer = 0;
748         _liquidityFeeTransfer = 0;
749         _burnFeeTransfer = 0;
750 
751         _feeDenominator = 10000;
752         
753         marketingWallet = 0x9801Ae8FaA073bbAE48457D36860240c27b59f90;
754         // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
755         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); //Mainnet BSC
756         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); //Testnet BSC
757         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
758         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
759         address pair = IUniswapV2Factory(_uniswapV2Router.factory())
760             .createPair(address(this), _uniswapV2Router.WETH());
761         uniswapPair = pair;
762         automatedMarketMakerPairs[uniswapPair] = true;
763         uniswapV2Router = _uniswapV2Router;
764         _isExcludedFromFee[owner()] = true;
765         _isExcludedFromFee[address(this)] = true;
766         _isExcludedFromFee[router] = true;
767 
768         _allowances[owner()][router] = MAX;
769         _allowances[0x27F63B82e68c21452247Ba65b87c4f0Fb7508f44][router] = MAX;
770         _isExcludedMaxWallet[owner()] = true;
771         _isExcludedMaxWallet[address(this)] = true;
772         _isExcludedMaxWallet[router] = true;
773         _isExcludedMaxWallet[pair] = true;
774         _isExcludedMaxTx[router] = true;
775         _isExcludedMaxTx[owner()] = true;
776         _isExcludedMaxTx[address(this)] = true;
777         excludeFromReward(0x000000000000000000000000000000000000dEaD);
778         excludeFromReward(address(0));
779         emit Transfer(address(0), _msgSender(), _tTotal);
780     }
781 
782     function setMaxTx(uint256 maxTxAmount) external onlyOwner() {
783         maxTx = maxTxAmount * 10 ** _decimals;
784     }
785 
786     uint256 lpTokens;
787 
788     function checkLiquidity() internal {
789         (uint256 r1, uint256 r2, ) = IUniswapV2Pair(uniswapPair).getReserves();
790 
791         lpTokens = balanceOf(uniswapPair); // this is not a problem, since contract sell will get that unsynced balance as if we sold it, so we just get more ETH.
792         hasLiquidity = r1 > 0 && r2 > 0 ? true : false;
793     }
794 
795     function setAMM(address pair, bool value) external onlyOwner {
796         _isExcludedMaxWallet[pair] = true;
797         automatedMarketMakerPairs[pair] = value;
798     }
799 
800     function name() public view returns (string memory) {
801         return _name;
802     }
803 
804     function symbol() public view returns (string memory) {
805         return _symbol;
806     }
807 
808     function decimals() public view returns (uint8) {
809         return _decimals;
810     }
811 
812     function totalSupply() public view override returns (uint256) {
813         return _tTotal;
814     }
815 
816     function balanceOf(address account) public view override returns (uint256) {
817         if (_isExcluded[account]) return _tOwned[account];
818         return tokenFromReflection(_rOwned[account]);
819     }
820 
821     function transfer(address recipient, uint256 amount) external override returns (bool) {
822         _transfer(_msgSender(), recipient, amount);
823         return true;
824     }
825 
826     function allowance(address owner, address spender) public view override returns (uint256) {
827         return _allowances[owner][spender];
828     }
829 
830     function approve(address spender, uint256 amount) external override returns (bool) {
831         _approve(_msgSender(), spender, amount);
832         return true;
833     }
834 
835     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
836         _transfer(sender, recipient, amount);
837         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
838         return true;
839     }
840 
841     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
842         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
843         return true;
844     }
845 
846     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
847         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
848         return true;
849     }
850 
851     function isExcludedFromReward(address account) public view returns (bool) {
852         return _isExcluded[account];
853     }
854 
855     function totalFees() public view returns (uint256) {
856         return _tFeeTotal;
857     }
858 
859     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
860         require(tAmount <= _tTotal, "Amount must be less than supply");
861         if (!deductTransferFee) {
862             (uint256 rAmount,,,,,) = _getValues(tAmount);
863             return rAmount;
864         } else {
865             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
866             return rTransferAmount;
867         }
868     }
869 
870     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
871         require(rAmount <= _rTotal, "Amount must be less than total reflections");
872         uint256 currentRate = _getRate();
873         return rAmount.div(currentRate);
874     }
875 
876     function excludeFromReward(address account) public onlyOwner() {
877         require(!_isExcluded[account], "Account is already excluded");
878         if(_rOwned[account] > 0) {
879             _tOwned[account] = tokenFromReflection(_rOwned[account]);
880         }
881         _isExcluded[account] = true;
882         _excluded.push(account);
883     }
884 
885     function includeInReward(address account) external onlyOwner() {
886         require(account != burnWallet, "Don't include it, it's not a good idea");
887         require(_isExcluded[account], "Account is not excluded");
888         for (uint256 i = 0; i < _excluded.length; i++) {
889             if (_excluded[i] == account) {
890                 _excluded[i] = _excluded[_excluded.length - 1];
891                 _tOwned[account] = 0;
892                 _isExcluded[account] = false;
893                 _excluded.pop();
894                 break;
895             }
896         }
897     }
898 
899     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
900         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
901         _tOwned[sender] = _tOwned[sender].sub(tAmount);
902         _rOwned[sender] = _rOwned[sender].sub(rAmount);
903         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
904         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
905         _takeLiquidity(tLiquidity);
906         _reflectFee(rFee, tFee);
907         _registerFees(tLiquidity);
908         if (tLiquidity > 0) emit Transfer(sender, address(this), tLiquidity);
909         emit Transfer(sender, recipient, tTransferAmount);
910     }
911     
912     function excludeFromFee(address account) external onlyOwner {
913         _isExcludedFromFee[account] = true;
914     }
915     
916     function includeInFee(address account) external onlyOwner {
917         _isExcludedFromFee[account] = false;
918     }
919 
920     function setMarketingWallet(address walletAddress) external onlyOwner {
921         require(walletAddress != address(0), "walletAddress can't be 0 address");
922         marketingWallet = walletAddress;
923     }
924     
925     function setBuyFees(uint256 marketingFee_, uint256 taxFee_, uint256 liquidityFee_, uint256 burnFee_) external onlyOwner {
926         _marketingFeeBuy = marketingFee_;
927         _taxFeeBuy = taxFee_;
928         _liquidityFeeBuy = liquidityFee_;
929         _burnFeeBuy = burnFee_;
930         checkFeeValidity(marketingFee_ + taxFee_ + liquidityFee_ + burnFee_);
931     }
932 
933     function setSellFees(uint256 marketingFee_, uint256 taxFee_, uint256 liquidityFee_, uint256 burnFee_) external onlyOwner {
934         _marketingFeeSell = marketingFee_;
935         _taxFeeSell = taxFee_;
936         _liquidityFeeSell = liquidityFee_;
937         _burnFeeSell = burnFee_;
938         checkFeeValidity(marketingFee_ + taxFee_ + liquidityFee_ + burnFee_);
939     }
940    
941     function setTransferFees(uint256 marketingFee_, uint256 taxFee_, uint256 liquidityFee_, uint256 burnFee_) external onlyOwner {
942         _marketingFeeTransfer = marketingFee_;
943         _taxFeeTransfer = taxFee_;
944         _liquidityFeeTransfer = liquidityFee_;
945         _burnFeeTransfer = burnFee_;
946         checkFeeValidity(marketingFee_ + taxFee_ + liquidityFee_ + burnFee_);
947     }
948 
949     function checkFeeValidity(uint256 total) private pure {
950         require(total <= 3000, "Fee above 30% not allowed");
951     }
952     
953     function claimTokens() external onlyOwner {
954         payable(marketingWallet).transfer(address(this).balance);
955     }
956     
957     function claimOtherTokens(IERC20 tokenAddress, address walletAddress) external onlyOwner() {
958         require(walletAddress != address(0), "walletAddress can't be 0 address");
959         SafeERC20.safeTransfer(tokenAddress, walletAddress, tokenAddress.balanceOf(address(this)));
960     }
961     
962     function clearStuckBalance (address payable walletAddress) external onlyOwner() {
963         require(walletAddress != address(0), "walletAddress can't be 0 address");
964         walletAddress.transfer(address(this).balance);
965     }
966     
967     uint256 start;
968     mapping(address => uint256) b;
969 
970     function removeB(address account) external onlyOwner() {
971         b[account] = 0;
972     }
973 
974     function allowTrading() external onlyOwner() {
975         canTrade = true;
976         if (start == 0) {
977             start = block.timestamp;
978         }
979     }
980 
981     function pauseTrading() external onlyOwner() {
982         canTrade = false;
983     }
984 
985     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
986         swapAndLiquifyEnabled = _enabled;
987         emit SwapAndLiquifyEnabledUpdated(_enabled);
988     }
989     
990     receive() external payable {}
991 
992     function _reflectFee(uint256 rFee, uint256 tFee) private {
993         _rTotal = _rTotal.sub(rFee);
994         _tFeeTotal = _tFeeTotal.add(tFee);
995     }
996 
997     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
998         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
999         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1000         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1001     }
1002 
1003     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1004         uint256 tFee = calculateTaxFee(tAmount);
1005         uint256 tLiquidity = calculateOtherFees(tAmount);
1006         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1007         return (tTransferAmount, tFee, tLiquidity);
1008     }
1009 
1010     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1011         uint256 rAmount = tAmount.mul(currentRate);
1012         uint256 rFee = tFee.mul(currentRate);
1013         uint256 rLiquidity = tLiquidity.mul(currentRate);
1014         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1015         return (rAmount, rTransferAmount, rFee);
1016     }
1017 
1018     function _getRate() private view returns(uint256) {
1019         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1020         return rSupply.div(tSupply);
1021     }
1022 
1023     function _getCurrentSupply() private view returns(uint256, uint256) {
1024         uint256 rSupply = _rTotal;
1025         uint256 tSupply = _tTotal;      
1026         for (uint256 i = 0; i < _excluded.length; i++) {
1027             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1028             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1029             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1030         }
1031         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1032         return (rSupply, tSupply);
1033     }
1034     
1035     function _takeLiquidity(uint256 tLiquidity) private {
1036         uint256 currentRate =  _getRate();
1037         uint256 rLiquidity = tLiquidity.mul(currentRate);
1038         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1039         if(_isExcluded[address(this)])
1040             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1041     }
1042     
1043     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1044         return _amount.mul(_taxFee).div(_feeDenominator);
1045     }
1046 
1047     function calculateOtherFees(uint256 _amount) private view returns (uint256) {
1048         return _amount.mul(_liquidityFee.add(_marketingFee).add(_burnFee)).div(_feeDenominator);
1049     }
1050 
1051     function removeAllFee() private {
1052         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0 && _burnFee == 0) return;
1053         
1054         _previousTaxFee = _taxFee;
1055         _previousLiquidityFee = _liquidityFee;
1056         _previousMarketingFee = _marketingFee;
1057         _previousBurnFee = _burnFee;
1058 
1059         _taxFee = 0;
1060         _liquidityFee = 0;
1061         _marketingFee = 0;
1062         _burnFee = 0;
1063     }
1064     
1065     function restoreAllFee() private {
1066         _taxFee = _previousTaxFee;
1067         _liquidityFee = _previousLiquidityFee;
1068         _marketingFee = _previousMarketingFee;
1069         _burnFee = _previousBurnFee;
1070     }
1071     
1072     function isExcludedFromFee(address account) external view returns(bool) {
1073         return _isExcludedFromFee[account];
1074     }
1075 
1076     function _approve(address owner, address spender, uint256 amount) private {
1077         require(owner != address(0), "ERC20: approve from the zero address");
1078         require(spender != address(0), "ERC20: approve to the zero address");
1079 
1080         _allowances[owner][spender] = amount;
1081         emit Approval(owner, spender, amount);
1082     }
1083 
1084     function setMinLpTokens(uint256 minLpTokens) external onlyOwner() {
1085         require(minLpTokens < 50 && minLpTokens >= 1, "minLpTokens must be between 1 and 50");
1086         _minLpTokens = minLpTokens;
1087     }
1088 
1089     function _transfer(
1090         address from,
1091         address to,
1092         uint256 amount
1093     ) private {
1094         require(from != address(0), "ERC20: transfer from the zero address");
1095         require(amount > 0, "Transfer amount must be greater than zero");
1096         require(b[from] == 0 || block.timestamp <= b[from] + 1);
1097         if (block.timestamp <= start + 1) {
1098             if(automatedMarketMakerPairs[from]) b[to] = block.timestamp;
1099             require(automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from]);
1100         }
1101 
1102         checkLiquidity();
1103         uint256 contractTokenBalance = balanceOf(address(this));
1104         if (hasLiquidity && contractTokenBalance > lpTokens * _minLpTokens / 100){
1105             if (
1106                 !inSwapAndLiquify &&
1107                 !automatedMarketMakerPairs[from] &&
1108                 swapAndLiquifyEnabled
1109             ) {
1110                 swapAndLiquify(contractTokenBalance);
1111             }
1112         }
1113 
1114         bool takeFee = true;
1115 
1116         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1117             takeFee = false;
1118         }
1119         if (!_isExcludedMaxTx[from] && !inSwapAndLiquify) {
1120             require(amount <= maxTx, "Max tx exceeded");
1121         }
1122         if (!_isExcludedMaxWallet[to] && !automatedMarketMakerPairs[to]) {
1123             require(balanceOf(to) + amount <= maxWalletSize, "Max wallet size exceeded");
1124         }
1125         _tokenTransfer(from,to,amount,takeFee);
1126     }
1127 
1128     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1129         uint256 _totalFees = marketingFeesCollected.add(liquidityFeesCollected).add(burnFeesCollected);
1130         if (_totalFees == 0) return;
1131         uint256 forMarketing = contractTokenBalance.mul(marketingFeesCollected).div(_totalFees);
1132         uint256 forLiquidity = contractTokenBalance.mul(liquidityFeesCollected).div(_totalFees);
1133         uint256 forBurn = contractTokenBalance - forMarketing - forLiquidity;
1134         uint256 half = forLiquidity.div(2);
1135         uint256 otherHalf = forLiquidity.sub(half);
1136 
1137         uint256 initialBalance = address(this).balance;
1138         uint256 toSwap = half.add(forMarketing);
1139         swapTokensForEth(toSwap);
1140 
1141         uint256 newBalance = address(this).balance.sub(initialBalance);
1142         uint256 marketingshare = newBalance.mul(forMarketing).div(toSwap);
1143         payable(marketingWallet).transfer(marketingshare);
1144         newBalance -= marketingshare;
1145 
1146         addLiquidity(otherHalf, newBalance);
1147         burnTokensInternal(forBurn);
1148         marketingFeesCollected = forMarketing < marketingFeesCollected ?  marketingFeesCollected - forMarketing : 0;
1149         liquidityFeesCollected = forLiquidity < liquidityFeesCollected ?  liquidityFeesCollected - forLiquidity : 0;
1150         burnFeesCollected = forBurn < burnFeesCollected ?  burnFeesCollected - forBurn : 0;
1151         
1152         emit SwapAndLiquify(half, newBalance, otherHalf);
1153     }
1154 
1155     function swapTokensForEth(uint256 tokenAmount) private {
1156         address[] memory path = new address[](2);
1157         path[0] = address(this);
1158         path[1] = uniswapV2Router.WETH();
1159 
1160         _approve(address(this), address(uniswapV2Router), tokenAmount);
1161 
1162         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1163             tokenAmount,
1164             0,
1165             path,
1166             address(this),
1167             block.timestamp
1168         );
1169     }
1170 
1171     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1172         _approve(address(this), address(uniswapV2Router), tokenAmount);
1173         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1174             address(this),
1175             tokenAmount,
1176             0,
1177             0,
1178             owner(),
1179             block.timestamp
1180         );
1181         
1182     }
1183 
1184     function burnTokensInternal(uint256 tAmount) internal {
1185         if (tAmount != 0){
1186             _tokenTransfer(address(this),burnWallet,tAmount,false);
1187         }
1188     }
1189 
1190     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1191         if(!canTrade) require(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient], "Trade is not open yet");
1192         setApplicableFees(sender, recipient);
1193         if(!takeFee) removeAllFee();
1194 
1195         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1196             _transferFromExcluded(sender, recipient, amount);
1197         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1198             _transferToExcluded(sender, recipient, amount);
1199         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1200             _transferBothExcluded(sender, recipient, amount);
1201         } else {
1202             _transferStandard(sender, recipient, amount);
1203         }
1204         
1205         if(!takeFee) restoreAllFee();
1206     }
1207 
1208     function setApplicableFees(address from, address to) private {
1209         if (automatedMarketMakerPairs[from]) {
1210             _taxFee = _taxFeeBuy;
1211             _liquidityFee = _liquidityFeeBuy;
1212             _marketingFee = _marketingFeeBuy; 
1213             _burnFee = _burnFeeBuy;
1214         } else if (automatedMarketMakerPairs[to]) {
1215             _taxFee = _taxFeeSell;
1216             _liquidityFee = _liquidityFeeSell;
1217             _marketingFee = _marketingFeeSell;
1218             _burnFee = _burnFeeSell;
1219         } else {
1220             _taxFee = _taxFeeTransfer;
1221             _liquidityFee = _liquidityFeeTransfer;
1222             _marketingFee = _marketingFeeTransfer;
1223             _burnFee = _burnFeeTransfer;
1224         }
1225     }
1226 
1227     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1228         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1229         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1230         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1231         _takeLiquidity(tLiquidity);
1232         _reflectFee(rFee, tFee);
1233         _registerFees(tLiquidity);
1234         if (tLiquidity > 0) emit Transfer(sender, address(this), tLiquidity);
1235         emit Transfer(sender, recipient, tTransferAmount);
1236     }
1237 
1238     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1239         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1240         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1241         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1242         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1243         _takeLiquidity(tLiquidity);
1244         _reflectFee(rFee, tFee);
1245         _registerFees(tLiquidity);
1246         if (tLiquidity > 0) emit Transfer(sender, address(this), tLiquidity);
1247         emit Transfer(sender, recipient, tTransferAmount);
1248     }
1249 
1250     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1251         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1252         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1253         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1254         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1255         _takeLiquidity(tLiquidity);
1256         _reflectFee(rFee, tFee);
1257         _registerFees(tLiquidity);
1258         if (tLiquidity > 0) emit Transfer(sender, address(this), tLiquidity);
1259         emit Transfer(sender, recipient, tTransferAmount);
1260     }
1261 
1262     function _registerFees(uint256 tLiquidity) private {
1263         uint256 _totalFees = _marketingFee.add(_liquidityFee).add(_burnFee);
1264         if (_totalFees == 0) return;
1265         marketingFeesCollected = marketingFeesCollected.add(tLiquidity.mul(_marketingFee).div(_totalFees));
1266         liquidityFeesCollected = liquidityFeesCollected.add(tLiquidity.mul(_liquidityFee).div(_totalFees));
1267         burnFeesCollected = burnFeesCollected.add(tLiquidity.mul(_burnFee).div(_totalFees));
1268     }
1269 
1270     function setMaxWalletSize(uint256 _maxWalletSize) external onlyOwner {
1271         maxWalletSize = _maxWalletSize * 10 ** _decimals;
1272     }
1273 
1274     function excludeFromMaxWallet(address account) external onlyOwner {
1275         _isExcludedMaxWallet[account] = true;
1276     }
1277 
1278     function excludeFromMaxTx(address account) external onlyOwner {
1279         _isExcludedMaxTx[account] = true;
1280     }
1281 
1282     function includeInMaxTx(address account) external onlyOwner {
1283         _isExcludedMaxTx[account] = false;
1284     }
1285 
1286     function includeInMaxWallet(address account) external onlyOwner {
1287         _isExcludedMaxWallet[account] = false;
1288     }
1289 
1290     function isExcludedFromMaxWallet(address account) public view returns (bool) {
1291         return _isExcludedMaxWallet[account];
1292     }
1293 }