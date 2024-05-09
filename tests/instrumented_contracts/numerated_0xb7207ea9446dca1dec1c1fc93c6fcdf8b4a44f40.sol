1 // SPDX-License-Identifier: AGPLv3
2 pragma solidity >=0.6.0 <0.8.0;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         
78         
79         
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 pragma solidity >=0.6.0 <0.8.0;
161 
162 /**
163  * @dev Interface of the ERC20 standard as defined in the EIP.
164  */
165 interface IERC20 {
166     /**
167      * @dev Returns the amount of tokens in existence.
168      */
169     function totalSupply() external view returns (uint256);
170 
171     /**
172      * @dev Returns the amount of tokens owned by `account`.
173      */
174     function balanceOf(address account) external view returns (uint256);
175 
176     /**
177      * @dev Moves `amount` tokens from the caller's account to `recipient`.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transfer(address recipient, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Returns the remaining number of tokens that `spender` will be
187      * allowed to spend on behalf of `owner` through {transferFrom}. This is
188      * zero by default.
189      *
190      * This value changes when {approve} or {transferFrom} are called.
191      */
192     function allowance(address owner, address spender) external view returns (uint256);
193 
194     /**
195      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * IMPORTANT: Beware that changing an allowance with this method brings the risk
200      * that someone may use both the old and the new allowance by unfortunate
201      * transaction ordering. One possible solution to mitigate this race
202      * condition is to first reduce the spender's allowance to 0 and set the
203      * desired value afterwards:
204      * https:
205      *
206      * Emits an {Approval} event.
207      */
208     function approve(address spender, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Moves `amount` tokens from `sender` to `recipient` using the
212      * allowance mechanism. `amount` is then deducted from the caller's
213      * allowance.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
220 
221     /**
222      * @dev Emitted when `value` tokens are moved from one account (`from`) to
223      * another (`to`).
224      *
225      * Note that `value` may be zero.
226      */
227     event Transfer(address indexed from, address indexed to, uint256 value);
228 
229     /**
230      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
231      * a call to {approve}. `value` is the new allowance.
232      */
233     event Approval(address indexed owner, address indexed spender, uint256 value);
234 }
235 
236 pragma solidity >=0.6.2 <0.8.0;
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         
261         
262         
263 
264         uint256 size;
265         
266         assembly { size := extcodesize(account) }
267         return size > 0;
268     }
269 
270     /**
271      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
272      * `recipient`, forwarding all available gas and reverting on errors.
273      *
274      * https:
275      * of certain opcodes, possibly making contracts go over the 2300 gas limit
276      * imposed by `transfer`, making them unable to receive funds via
277      * `transfer`. {sendValue} removes this limitation.
278      *
279      * https:
280      *
281      * IMPORTANT: because control is transferred to `recipient`, care must be
282      * taken to not create reentrancy vulnerabilities. Consider using
283      * {ReentrancyGuard} or the
284      * https:
285      */
286     function sendValue(address payable recipient, uint256 amount) internal {
287         require(address(this).balance >= amount, "Address: insufficient balance");
288 
289         
290         (bool success, ) = recipient.call{ value: amount }("");
291         require(success, "Address: unable to send value, recipient may have reverted");
292     }
293 
294     /**
295      * @dev Performs a Solidity function call using a low level `call`. A
296      * plain`call` is an unsafe replacement for a function call: use this
297      * function instead.
298      *
299      * If `target` reverts with a revert reason, it is bubbled up by this
300      * function (like regular Solidity function calls).
301      *
302      * Returns the raw returned data. To convert to the expected return value,
303      * use https:
304      *
305      * Requirements:
306      *
307      * - `target` must be a contract.
308      * - calling `target` with `data` must not revert.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
313       return functionCall(target, data, "Address: low-level call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
318      * `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, 0, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but also transferring `value` wei to `target`.
329      *
330      * Requirements:
331      *
332      * - the calling contract must have an ETH balance of at least `value`.
333      * - the called Solidity function must be `payable`.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
348         require(address(this).balance >= value, "Address: insufficient balance for call");
349         require(isContract(target), "Address: call to non-contract");
350 
351         
352         (bool success, bytes memory returndata) = target.call{ value: value }(data);
353         return _verifyCallResult(success, returndata, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but performing a static call.
359      *
360      * _Available since v3.3._
361      */
362     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
363         return functionStaticCall(target, data, "Address: low-level static call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
368      * but performing a static call.
369      *
370      * _Available since v3.3._
371      */
372     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
373         require(isContract(target), "Address: static call to non-contract");
374 
375         
376         (bool success, bytes memory returndata) = target.staticcall(data);
377         return _verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
381         if (success) {
382             return returndata;
383         } else {
384             
385             if (returndata.length > 0) {
386                 
387 
388                 
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 pragma solidity >=0.6.0 <0.8.0;
401 
402 /**
403  * @title SafeERC20
404  * @dev Wrappers around ERC20 operations that throw on failure (when the token
405  * contract returns false). Tokens that return no value (and instead revert or
406  * throw on failure) are also supported, non-reverting calls are assumed to be
407  * successful.
408  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
409  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
410  */
411 library SafeERC20 {
412     using SafeMath for uint256;
413     using Address for address;
414 
415     function safeTransfer(IERC20 token, address to, uint256 value) internal {
416         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
417     }
418 
419     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
420         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
421     }
422 
423     /**
424      * @dev Deprecated. This function has issues similar to the ones found in
425      * {IERC20-approve}, and its usage is discouraged.
426      *
427      * Whenever possible, use {safeIncreaseAllowance} and
428      * {safeDecreaseAllowance} instead.
429      */
430     function safeApprove(IERC20 token, address spender, uint256 value) internal {
431         
432         
433         
434         
435         require((value == 0) || (token.allowance(address(this), spender) == 0),
436             "SafeERC20: approve from non-zero to non-zero allowance"
437         );
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
439     }
440 
441     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
442         uint256 newAllowance = token.allowance(address(this), spender).add(value);
443         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
444     }
445 
446     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
447         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
448         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
449     }
450 
451     /**
452      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
453      * on the return value: the return value is optional (but if data is returned, it must not be false).
454      * @param token The token targeted by the call.
455      * @param data The call data (encoded using abi.encode or one of its variants).
456      */
457     function _callOptionalReturn(IERC20 token, bytes memory data) private {
458         
459         
460         
461 
462         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
463         if (returndata.length > 0) { 
464             
465             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
466         }
467     }
468 }
469 
470 pragma solidity >=0.6.0 <0.7.0;
471 
472 contract Constants {
473     uint8 public constant N_COINS = 3;
474     uint8 public constant DEFAULT_DECIMALS = 18; 
475     uint256 public constant DEFAULT_DECIMALS_FACTOR = uint256(10)**DEFAULT_DECIMALS;
476     uint8 public constant CHAINLINK_PRICE_DECIMALS = 8;
477     uint256 public constant CHAINLINK_PRICE_DECIMAL_FACTOR = uint256(10)**CHAINLINK_PRICE_DECIMALS;
478     uint8 public constant PERCENTAGE_DECIMALS = 4;
479     uint256 public constant PERCENTAGE_DECIMAL_FACTOR = uint256(10)**PERCENTAGE_DECIMALS;
480     uint256 public constant CURVE_RATIO_DECIMALS = 6;
481     uint256 public constant CURVE_RATIO_DECIMALS_FACTOR = uint256(10)**CURVE_RATIO_DECIMALS;
482 }
483 
484 pragma solidity >=0.6.0 <0.7.0;
485 
486 interface IToken {
487     function factor() external view returns (uint256);
488 
489     function factor(uint256 totalAssets) external view returns (uint256);
490 
491     function mint(
492         address account,
493         uint256 _factor,
494         uint256 amount
495     ) external;
496 
497     function burn(
498         address account,
499         uint256 _factor,
500         uint256 amount
501     ) external;
502 
503     function burnAll(address account) external;
504 
505     function totalAssets() external view returns (uint256);
506 
507     function getPricePerShare() external view returns (uint256);
508 
509     function getShareAssets(uint256 shares) external view returns (uint256);
510 
511     function getAssets(address account) external view returns (uint256);
512 }
513 
514 pragma solidity >=0.6.0 <0.7.0;
515 
516 interface IVault {
517     function withdraw(uint256 amount) external;
518 
519     function withdraw(uint256 amount, address recipient) external;
520 
521     function withdrawByStrategyOrder(
522         uint256 amount,
523         address recipient,
524         bool reversed
525     ) external;
526 
527     function withdrawByStrategyIndex(
528         uint256 amount,
529         address recipient,
530         uint256 strategyIndex
531     ) external;
532 
533     function deposit(uint256 amount) external;
534 
535     function updateStrategyRatio(uint256[] calldata strategyRetios) external;
536 
537     function totalAssets() external view returns (uint256);
538 
539     function getStrategiesLength() external view returns (uint256);
540 
541     function strategyHarvestTrigger(uint256 index, uint256 callCost) external view returns (bool);
542 
543     function strategyHarvest(uint256 index) external returns (bool);
544 
545     function getStrategyAssets(uint256 index) external view returns (uint256);
546 
547     function token() external view returns (address);
548 
549     function vault() external view returns (address);
550 
551     function investTrigger() external view returns (bool);
552 
553     function invest() external;
554 }
555 
556 pragma solidity >=0.6.0 <0.7.0;
557 
558 contract FixedStablecoins is Constants {
559     address public immutable DAI; 
560     address public immutable USDC; 
561     address public immutable USDT; 
562 
563     uint256 public immutable DAI_DECIMALS; 
564     uint256 public immutable USDC_DECIMALS; 
565     uint256 public immutable USDT_DECIMALS; 
566 
567     constructor(address[N_COINS] memory _tokens, uint256[N_COINS] memory _decimals) public {
568         DAI = _tokens[0];
569         USDC = _tokens[1];
570         USDT = _tokens[2];
571         DAI_DECIMALS = _decimals[0];
572         USDC_DECIMALS = _decimals[1];
573         USDT_DECIMALS = _decimals[2];
574     }
575 
576     function underlyingTokens() internal view returns (address[N_COINS] memory tokens) {
577         tokens[0] = DAI;
578         tokens[1] = USDC;
579         tokens[2] = USDT;
580     }
581 
582     function getToken(uint256 index) internal view returns (address) {
583         if (index == 0) {
584             return DAI;
585         } else if (index == 1) {
586             return USDC;
587         } else {
588             return USDT;
589         }
590     }
591 
592     function decimals() internal view returns (uint256[N_COINS] memory _decimals) {
593         _decimals[0] = DAI_DECIMALS;
594         _decimals[1] = USDC_DECIMALS;
595         _decimals[2] = USDT_DECIMALS;
596     }
597 
598     function getDecimal(uint256 index) internal view returns (uint256) {
599         if (index == 0) {
600             return DAI_DECIMALS;
601         } else if (index == 1) {
602             return USDC_DECIMALS;
603         } else {
604             return USDT_DECIMALS;
605         }
606     }
607 }
608 
609 contract FixedGTokens {
610     IToken public immutable pwrd;
611     IToken public immutable gvt;
612 
613     constructor(address _pwrd, address _gvt) public {
614         pwrd = IToken(_pwrd);
615         gvt = IToken(_gvt);
616     }
617 
618     function gTokens(bool _pwrd) internal view returns (IToken) {
619         if (_pwrd) {
620             return pwrd;
621         } else {
622             return gvt;
623         }
624     }
625 }
626 
627 contract FixedVaults is Constants {
628     address public immutable DAI_VAULT;
629     address public immutable USDC_VAULT;
630     address public immutable USDT_VAULT;
631 
632     constructor(address[N_COINS] memory _vaults) public {
633         DAI_VAULT = _vaults[0];
634         USDC_VAULT = _vaults[1];
635         USDT_VAULT = _vaults[2];
636     }
637 
638     function getVault(uint256 index) internal view returns (address) {
639         if (index == 0) {
640             return DAI_VAULT;
641         } else if (index == 1) {
642             return USDC_VAULT;
643         } else {
644             return USDT_VAULT;
645         }
646     }
647 
648     function vaults() internal view returns (address[N_COINS] memory _vaults) {
649         _vaults[0] = DAI_VAULT;
650         _vaults[1] = USDC_VAULT;
651         _vaults[2] = USDT_VAULT;
652     }
653 }
654 
655 pragma solidity >=0.6.0 <0.8.0;
656 
657 /*
658  * @dev Provides information about the current execution context, including the
659  * sender of the transaction and its data. While these are generally available
660  * via msg.sender and msg.data, they should not be accessed in such a direct
661  * manner, since when dealing with GSN meta-transactions the account sending and
662  * paying for execution may not be the actual sender (as far as an application
663  * is concerned).
664  *
665  * This contract is only required for intermediate, library-like contracts.
666  */
667 abstract contract Context {
668     function _msgSender() internal view virtual returns (address payable) {
669         return msg.sender;
670     }
671 
672     function _msgData() internal view virtual returns (bytes memory) {
673         this; 
674         return msg.data;
675     }
676 }
677 
678 pragma solidity >=0.6.0 <0.8.0;
679 
680 /**
681  * @dev Contract module which provides a basic access control mechanism, where
682  * there is an account (an owner) that can be granted exclusive access to
683  * specific functions.
684  *
685  * By default, the owner account will be the one that deploys the contract. This
686  * can later be changed with {transferOwnership}.
687  *
688  * This module is used through inheritance. It will make available the modifier
689  * `onlyOwner`, which can be applied to your functions to restrict their use to
690  * the owner.
691  */
692 abstract contract Ownable is Context {
693     address private _owner;
694 
695     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
696 
697     /**
698      * @dev Initializes the contract setting the deployer as the initial owner.
699      */
700     constructor () internal {
701         address msgSender = _msgSender();
702         _owner = msgSender;
703         emit OwnershipTransferred(address(0), msgSender);
704     }
705 
706     /**
707      * @dev Returns the address of the current owner.
708      */
709     function owner() public view returns (address) {
710         return _owner;
711     }
712 
713     /**
714      * @dev Throws if called by any account other than the owner.
715      */
716     modifier onlyOwner() {
717         require(_owner == _msgSender(), "Ownable: caller is not the owner");
718         _;
719     }
720 
721     /**
722      * @dev Leaves the contract without owner. It will not be possible to call
723      * `onlyOwner` functions anymore. Can only be called by the current owner.
724      *
725      * NOTE: Renouncing ownership will leave the contract without an owner,
726      * thereby removing any functionality that is only available to the owner.
727      */
728     function renounceOwnership() public virtual onlyOwner {
729         emit OwnershipTransferred(_owner, address(0));
730         _owner = address(0);
731     }
732 
733     /**
734      * @dev Transfers ownership of the contract to a new account (`newOwner`).
735      * Can only be called by the current owner.
736      */
737     function transferOwnership(address newOwner) public virtual onlyOwner {
738         require(newOwner != address(0), "Ownable: new owner is the zero address");
739         emit OwnershipTransferred(_owner, newOwner);
740         _owner = newOwner;
741     }
742 }
743 
744 pragma solidity >=0.6.0 <0.7.0;
745 
746 interface IController {
747     function stablecoins() external view returns (address[3] memory);
748 
749     function vaults() external view returns (address[3] memory);
750 
751     function underlyingVaults(uint256 i) external view returns (address vault);
752 
753     function curveVault() external view returns (address);
754 
755     function pnl() external view returns (address);
756 
757     function insurance() external view returns (address);
758 
759     function lifeGuard() external view returns (address);
760 
761     function buoy() external view returns (address);
762 
763     function reward() external view returns (address);
764 
765     function isValidBigFish(
766         bool pwrd,
767         bool deposit,
768         uint256 amount
769     ) external view returns (bool);
770 
771     function withdrawHandler() external view returns (address);
772 
773     function emergencyHandler() external view returns (address);
774 
775     function depositHandler() external view returns (address);
776 
777     function totalAssets() external view returns (uint256);
778 
779     function gTokenTotalAssets() external view returns (uint256);
780 
781     function eoaOnly(address sender) external;
782 
783     function getSkimPercent() external view returns (uint256);
784 
785     function gToken(bool _pwrd) external view returns (address);
786 
787     function emergencyState() external view returns (bool);
788 
789     function deadCoin() external view returns (uint256);
790 
791     function distributeStrategyGainLoss(uint256 gain, uint256 loss) external;
792 
793     function burnGToken(
794         bool pwrd,
795         bool all,
796         address account,
797         uint256 amount,
798         uint256 bonus
799     ) external;
800 
801     function mintGToken(
802         bool pwrd,
803         address account,
804         uint256 amount
805     ) external;
806 
807     function getUserAssets(bool pwrd, address account) external view returns (uint256 deductUsd);
808 
809     function referrals(address account) external view returns (address);
810 
811     function addReferral(address account, address referral) external;
812 
813     function getStrategiesTargetRatio() external view returns (uint256[] memory);
814 
815     function withdrawalFee(bool pwrd) external view returns (uint256);
816 
817     function validGTokenDecrease(uint256 amount) external view returns (bool);
818 }
819 
820 pragma solidity >=0.6.0 <0.7.0;
821 
822 interface IPausable {
823     function paused() external view returns (bool);
824 }
825 
826 pragma solidity >=0.6.0 <0.7.0;
827 
828 contract Controllable is Ownable {
829     address public controller;
830 
831     event ChangeController(address indexed oldController, address indexed newController);
832 
833     modifier whenNotPaused() {
834         require(!_pausable().paused(), "Pausable: paused");
835         _;
836     }
837 
838     modifier whenPaused() {
839         require(_pausable().paused(), "Pausable: not paused");
840         _;
841     }
842 
843     function ctrlPaused() public view returns (bool) {
844         return _pausable().paused();
845     }
846 
847     function setController(address newController) external onlyOwner {
848         require(newController != address(0), "setController: !0x");
849         address oldController = controller;
850         controller = newController;
851         emit ChangeController(oldController, newController);
852     }
853 
854     function _controller() internal view returns (IController) {
855         require(controller != address(0), "Controller not set");
856         return IController(controller);
857     }
858 
859     function _pausable() internal view returns (IPausable) {
860         require(controller != address(0), "Controller not set");
861         return IPausable(controller);
862     }
863 }
864 
865 pragma solidity >=0.6.0 <0.7.0;
866 
867 interface IBuoy {
868     function safetyCheck() external view returns (bool);
869 
870     function updateRatios() external returns (bool);
871 
872     function updateRatiosWithTolerance(uint256 tolerance) external returns (bool);
873 
874     function lpToUsd(uint256 inAmount) external view returns (uint256);
875 
876     function usdToLp(uint256 inAmount) external view returns (uint256);
877 
878     function stableToUsd(uint256[3] calldata inAmount, bool deposit) external view returns (uint256);
879 
880     function stableToLp(uint256[3] calldata inAmount, bool deposit) external view returns (uint256);
881 
882     function singleStableFromLp(uint256 inAmount, int128 i) external view returns (uint256);
883 
884     function getVirtualPrice() external view returns (uint256);
885 
886     function singleStableFromUsd(uint256 inAmount, int128 i) external view returns (uint256);
887 
888     function singleStableToUsd(uint256 inAmount, uint256 i) external view returns (uint256);
889 }
890 
891 pragma solidity >=0.6.0 <0.7.0;
892 
893 interface IDepositHandler {
894     function depositGvt(
895         uint256[3] calldata inAmounts,
896         uint256 minAmount,
897         address _referral
898     ) external;
899 
900     function depositPwrd(
901         uint256[3] calldata inAmounts,
902         uint256 minAmount,
903         address _referral
904     ) external;
905 }
906 
907 pragma solidity >=0.6.0 <0.7.0;
908 
909 interface IERC20Detailed {
910     function name() external view returns (string memory);
911 
912     function symbol() external view returns (string memory);
913 
914     function decimals() external view returns (uint8);
915 }
916 
917 pragma solidity >=0.6.0 <0.7.0;
918 
919 interface IInsurance {
920     function calculateDepositDeltasOnAllVaults() external view returns (uint256[3] memory);
921 
922     function rebalanceTrigger() external view returns (bool sysNeedRebalance);
923 
924     function rebalance() external;
925 
926     function calcSkim() external view returns (uint256);
927 
928     function rebalanceForWithdraw(uint256 withdrawUsd, bool pwrd) external returns (bool);
929 
930     function getDelta(uint256 withdrawUsd) external view returns (uint256[3] memory delta);
931 
932     function getVaultDeltaForDeposit(uint256 amount) external view returns (uint256[3] memory, uint256);
933 
934     function sortVaultsByDelta(bool bigFirst) external view returns (uint256[3] memory vaultIndexes);
935 
936     function getStrategiesTargetRatio(uint256 utilRatio) external view returns (uint256[] memory);
937 
938     function setUnderlyingTokenPercents(uint256[3] calldata percents) external;
939 }
940 
941 pragma solidity >=0.6.0 <0.7.0;
942 
943 interface ILifeGuard {
944     function assets(uint256 i) external view returns (uint256);
945 
946     function totalAssets() external view returns (uint256);
947 
948     function getAssets() external view returns (uint256[3] memory);
949 
950     function totalAssetsUsd() external view returns (uint256);
951 
952     function availableUsd() external view returns (uint256 dollar);
953 
954     function availableLP() external view returns (uint256);
955 
956     function depositStable(bool rebalance) external returns (uint256);
957 
958     function investToCurveVault() external;
959 
960     function distributeCurveVault(uint256 amount, uint256[3] memory delta) external returns (uint256[3] memory);
961 
962     function deposit() external returns (uint256 usdAmount);
963 
964     function withdrawSingleByLiquidity(
965         uint256 i,
966         uint256 minAmount,
967         address recipient
968     ) external returns (uint256 usdAmount, uint256 amount);
969 
970     function withdrawSingleByExchange(
971         uint256 i,
972         uint256 minAmount,
973         address recipient
974     ) external returns (uint256 usdAmount, uint256 amount);
975 
976     function invest(uint256 whaleDepositAmount, uint256[3] calldata delta) external returns (uint256 dollarAmount);
977 
978     function getBuoy() external view returns (address);
979 
980     function investSingle(
981         uint256[3] calldata inAmounts,
982         uint256 i,
983         uint256 j
984     ) external returns (uint256 dollarAmount);
985 
986     function investToCurveVaultTrigger() external view returns (bool _invest);
987 }
988 
989 pragma solidity >=0.6.0 <0.7.0;
990 
991 contract DepositHandler is Controllable, FixedStablecoins, FixedVaults, IDepositHandler {
992 
993     using SafeERC20 for IERC20;
994     using SafeMath for uint256;
995 
996     IController public ctrl;
997     ILifeGuard public lg;
998     IBuoy public buoy;
999     IInsurance public insurance;
1000     uint256 constant USDT_INDEX = 2;
1001 
1002     event LogNewDependencies(address controller, address lifeguard, address buoy, address insurance);
1003     event LogNewDeposit(
1004         address indexed user,
1005         address indexed referral,
1006         bool pwrd,
1007         uint256 usdAmount,
1008         uint256[N_COINS] tokens
1009     );
1010 
1011     constructor(
1012         address[N_COINS] memory _vaults,
1013         address[N_COINS] memory _tokens,
1014         uint256[N_COINS] memory _decimals
1015     ) public FixedStablecoins(_tokens, _decimals) FixedVaults(_vaults) {
1016     }
1017 
1018     function setDependencies() external onlyOwner {
1019         ctrl = _controller();
1020         lg = ILifeGuard(ctrl.lifeGuard());
1021         buoy = IBuoy(lg.getBuoy());
1022         insurance = IInsurance(ctrl.insurance());
1023         emit LogNewDependencies(address(ctrl), address(lg), address(buoy), address(insurance));
1024     }
1025 
1026     function depositPwrd(
1027         uint256[N_COINS] memory inAmounts,
1028         uint256 minAmount,
1029         address _referral
1030     ) external override whenNotPaused {
1031         depositGToken(inAmounts, minAmount, _referral, true);
1032     }
1033 
1034     function depositGvt(
1035         uint256[N_COINS] memory inAmounts,
1036         uint256 minAmount,
1037         address _referral
1038     ) external override whenNotPaused {
1039         depositGToken(inAmounts, minAmount, _referral, false);
1040     }
1041 
1042     function depositGToken(
1043         uint256[N_COINS] memory inAmounts,
1044         uint256 minAmount,
1045         address _referral,
1046         bool pwrd
1047     ) private {
1048         IController _ctrl = ctrl;
1049         _ctrl.eoaOnly(msg.sender);
1050         require(minAmount > 0, "minAmount is 0");
1051         require(buoy.safetyCheck(), "!safetyCheck");
1052         _ctrl.addReferral(msg.sender, _referral);
1053 
1054         uint256 roughUsd = roughUsd(inAmounts);
1055         uint256 dollarAmount = _deposit(pwrd, roughUsd, minAmount, inAmounts);
1056         _ctrl.mintGToken(pwrd, msg.sender, dollarAmount);
1057         
1058         emit LogNewDeposit(msg.sender, _ctrl.referrals(msg.sender), pwrd, dollarAmount, inAmounts);
1059     }
1060 
1061     function _deposit(
1062         bool pwrd,
1063         uint256 roughUsd,
1064         uint256 minAmount,
1065         uint256[N_COINS] memory inAmounts
1066     ) private returns (uint256 dollarAmount) {
1067         
1068         IBuoy _buoy = buoy;
1069         if (ctrl.isValidBigFish(pwrd, true, roughUsd)) {
1070             address _lg = address(lg);
1071             for (uint256 i = 0; i < N_COINS; i++) {
1072                 
1073                 if (inAmounts[i] > 0) {
1074                     IERC20 token = IERC20(getToken(i));
1075                     if (i == USDT_INDEX) {
1076                         
1077                         uint256 current = token.balanceOf(_lg);
1078                         token.safeTransferFrom(msg.sender, _lg, inAmounts[i]);
1079                         inAmounts[i] = token.balanceOf(_lg).sub(current);
1080                     } else {
1081                         token.safeTransferFrom(msg.sender, _lg, inAmounts[i]);
1082                     }
1083                 }
1084             }
1085             dollarAmount = _invest(inAmounts, roughUsd);
1086         } else {
1087             
1088             for (uint256 i = 0; i < N_COINS; i++) {
1089                 if (inAmounts[i] > 0) {
1090                     
1091                     IERC20 token = IERC20(getToken(i));
1092                     address _vault = getVault(i);
1093                     if (i == USDT_INDEX) {
1094                         
1095                         uint256 current = token.balanceOf(_vault);
1096                         token.safeTransferFrom(msg.sender, _vault, inAmounts[i]);
1097                         inAmounts[i] = token.balanceOf(_vault).sub(current);
1098                     } else {
1099                         token.safeTransferFrom(msg.sender, _vault, inAmounts[i]);
1100                     }
1101                 }
1102             }
1103             
1104             dollarAmount = _buoy.stableToUsd(inAmounts, true);
1105         }
1106         require(dollarAmount >= _buoy.lpToUsd(minAmount), "!minAmount");
1107     }
1108 
1109     function _invest(uint256[N_COINS] memory _inAmounts, uint256 roughUsd) internal returns (uint256 dollarAmount) {
1110         
1111         
1112         
1113         IInsurance _insurance = insurance;
1114         ILifeGuard _lg = lg;
1115         (uint256[N_COINS] memory vaultIndexes, uint256 _vaults) = _insurance.getVaultDeltaForDeposit(roughUsd);
1116         if (_vaults < N_COINS) {
1117             dollarAmount = _lg.investSingle(_inAmounts, vaultIndexes[0], vaultIndexes[1]);
1118         } else {
1119             uint256 outAmount = _lg.deposit();
1120             uint256[N_COINS] memory delta = _insurance.calculateDepositDeltasOnAllVaults();
1121             dollarAmount = _lg.invest(outAmount, delta);
1122         }
1123     }
1124 
1125     function roughUsd(uint256[N_COINS] memory inAmounts) private view returns (uint256 usdAmount) {
1126         for (uint256 i; i < N_COINS; i++) {
1127             if (inAmounts[i] > 0) {
1128                 usdAmount = usdAmount.add(inAmounts[i].mul(10**18).div(getDecimal(i)));
1129             }
1130         }
1131     }
1132 }