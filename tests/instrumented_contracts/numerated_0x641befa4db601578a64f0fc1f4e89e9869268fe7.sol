1 // SPDX-License-Identifier: AGPLv3
2 pragma solidity >=0.6.0 <0.8.0;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; 
21         return msg.data;
22     }
23 }
24 
25 pragma solidity >=0.6.0 <0.8.0;
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor () internal {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(_owner == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 pragma solidity >=0.6.0 <0.8.0;
92 
93 /**
94  * @dev Wrappers over Solidity's arithmetic operations with added overflow
95  * checks.
96  *
97  * Arithmetic operations in Solidity wrap on overflow. This can easily result
98  * in bugs, because programmers usually assume that an overflow raises an
99  * error, which is the standard behavior in high level programming languages.
100  * `SafeMath` restores this intuition by reverting the transaction when an
101  * operation overflows.
102  *
103  * Using this library instead of the unchecked operations eliminates an entire
104  * class of bugs, so it's recommended to use it always.
105  */
106 library SafeMath {
107     /**
108      * @dev Returns the addition of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `+` operator.
112      *
113      * Requirements:
114      *
115      * - Addition cannot overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return sub(a, b, "SafeMath: subtraction overflow");
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b <= a, errorMessage);
150         uint256 c = a - b;
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the multiplication of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `*` operator.
160      *
161      * Requirements:
162      *
163      * - Multiplication cannot overflow.
164      */
165     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166         
167         
168         
169         if (a == 0) {
170             return 0;
171         }
172 
173         uint256 c = a * b;
174         require(c / a == b, "SafeMath: multiplication overflow");
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts on
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
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         return div(a, b, "SafeMath: division by zero");
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
208         require(b > 0, errorMessage);
209         uint256 c = a / b;
210         
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
228         return mod(a, b, "SafeMath: modulo by zero");
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts with custom message when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b != 0, errorMessage);
245         return a % b;
246     }
247 }
248 
249 pragma solidity >=0.6.0 <0.8.0;
250 
251 /**
252  * @dev Interface of the ERC20 standard as defined in the EIP.
253  */
254 interface IERC20 {
255     /**
256      * @dev Returns the amount of tokens in existence.
257      */
258     function totalSupply() external view returns (uint256);
259 
260     /**
261      * @dev Returns the amount of tokens owned by `account`.
262      */
263     function balanceOf(address account) external view returns (uint256);
264 
265     /**
266      * @dev Moves `amount` tokens from the caller's account to `recipient`.
267      *
268      * Returns a boolean value indicating whether the operation succeeded.
269      *
270      * Emits a {Transfer} event.
271      */
272     function transfer(address recipient, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Returns the remaining number of tokens that `spender` will be
276      * allowed to spend on behalf of `owner` through {transferFrom}. This is
277      * zero by default.
278      *
279      * This value changes when {approve} or {transferFrom} are called.
280      */
281     function allowance(address owner, address spender) external view returns (uint256);
282 
283     /**
284      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * IMPORTANT: Beware that changing an allowance with this method brings the risk
289      * that someone may use both the old and the new allowance by unfortunate
290      * transaction ordering. One possible solution to mitigate this race
291      * condition is to first reduce the spender's allowance to 0 and set the
292      * desired value afterwards:
293      * https:
294      *
295      * Emits an {Approval} event.
296      */
297     function approve(address spender, uint256 amount) external returns (bool);
298 
299     /**
300      * @dev Moves `amount` tokens from `sender` to `recipient` using the
301      * allowance mechanism. `amount` is then deducted from the caller's
302      * allowance.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Emitted when `value` tokens are moved from one account (`from`) to
312      * another (`to`).
313      *
314      * Note that `value` may be zero.
315      */
316     event Transfer(address indexed from, address indexed to, uint256 value);
317 
318     /**
319      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
320      * a call to {approve}. `value` is the new allowance.
321      */
322     event Approval(address indexed owner, address indexed spender, uint256 value);
323 }
324 
325 pragma solidity >=0.6.2 <0.8.0;
326 
327 /**
328  * @dev Collection of functions related to the address type
329  */
330 library Address {
331     /**
332      * @dev Returns true if `account` is a contract.
333      *
334      * [IMPORTANT]
335      * ====
336      * It is unsafe to assume that an address for which this function returns
337      * false is an externally-owned account (EOA) and not a contract.
338      *
339      * Among others, `isContract` will return false for the following
340      * types of addresses:
341      *
342      *  - an externally-owned account
343      *  - a contract in construction
344      *  - an address where a contract will be created
345      *  - an address where a contract lived, but was destroyed
346      * ====
347      */
348     function isContract(address account) internal view returns (bool) {
349         
350         
351         
352 
353         uint256 size;
354         
355         assembly { size := extcodesize(account) }
356         return size > 0;
357     }
358 
359     /**
360      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
361      * `recipient`, forwarding all available gas and reverting on errors.
362      *
363      * https:
364      * of certain opcodes, possibly making contracts go over the 2300 gas limit
365      * imposed by `transfer`, making them unable to receive funds via
366      * `transfer`. {sendValue} removes this limitation.
367      *
368      * https:
369      *
370      * IMPORTANT: because control is transferred to `recipient`, care must be
371      * taken to not create reentrancy vulnerabilities. Consider using
372      * {ReentrancyGuard} or the
373      * https:
374      */
375     function sendValue(address payable recipient, uint256 amount) internal {
376         require(address(this).balance >= amount, "Address: insufficient balance");
377 
378         
379         (bool success, ) = recipient.call{ value: amount }("");
380         require(success, "Address: unable to send value, recipient may have reverted");
381     }
382 
383     /**
384      * @dev Performs a Solidity function call using a low level `call`. A
385      * plain`call` is an unsafe replacement for a function call: use this
386      * function instead.
387      *
388      * If `target` reverts with a revert reason, it is bubbled up by this
389      * function (like regular Solidity function calls).
390      *
391      * Returns the raw returned data. To convert to the expected return value,
392      * use https:
393      *
394      * Requirements:
395      *
396      * - `target` must be a contract.
397      * - calling `target` with `data` must not revert.
398      *
399      * _Available since v3.1._
400      */
401     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
402       return functionCall(target, data, "Address: low-level call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
407      * `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
412         return functionCallWithValue(target, data, 0, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but also transferring `value` wei to `target`.
418      *
419      * Requirements:
420      *
421      * - the calling contract must have an ETH balance of at least `value`.
422      * - the called Solidity function must be `payable`.
423      *
424      * _Available since v3.1._
425      */
426     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
427         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
432      * with `errorMessage` as a fallback revert reason when `target` reverts.
433      *
434      * _Available since v3.1._
435      */
436     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
437         require(address(this).balance >= value, "Address: insufficient balance for call");
438         require(isContract(target), "Address: call to non-contract");
439 
440         
441         (bool success, bytes memory returndata) = target.call{ value: value }(data);
442         return _verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
452         return functionStaticCall(target, data, "Address: low-level static call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
462         require(isContract(target), "Address: static call to non-contract");
463 
464         
465         (bool success, bytes memory returndata) = target.staticcall(data);
466         return _verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
470         if (success) {
471             return returndata;
472         } else {
473             
474             if (returndata.length > 0) {
475                 
476 
477                 
478                 assembly {
479                     let returndata_size := mload(returndata)
480                     revert(add(32, returndata), returndata_size)
481                 }
482             } else {
483                 revert(errorMessage);
484             }
485         }
486     }
487 }
488 
489 pragma solidity >=0.6.0 <0.8.0;
490 
491 /**
492  * @title SafeERC20
493  * @dev Wrappers around ERC20 operations that throw on failure (when the token
494  * contract returns false). Tokens that return no value (and instead revert or
495  * throw on failure) are also supported, non-reverting calls are assumed to be
496  * successful.
497  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
498  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
499  */
500 library SafeERC20 {
501     using SafeMath for uint256;
502     using Address for address;
503 
504     function safeTransfer(IERC20 token, address to, uint256 value) internal {
505         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
506     }
507 
508     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
509         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
510     }
511 
512     /**
513      * @dev Deprecated. This function has issues similar to the ones found in
514      * {IERC20-approve}, and its usage is discouraged.
515      *
516      * Whenever possible, use {safeIncreaseAllowance} and
517      * {safeDecreaseAllowance} instead.
518      */
519     function safeApprove(IERC20 token, address spender, uint256 value) internal {
520         
521         
522         
523         
524         require((value == 0) || (token.allowance(address(this), spender) == 0),
525             "SafeERC20: approve from non-zero to non-zero allowance"
526         );
527         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
528     }
529 
530     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
531         uint256 newAllowance = token.allowance(address(this), spender).add(value);
532         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
533     }
534 
535     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
536         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
537         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
538     }
539 
540     /**
541      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
542      * on the return value: the return value is optional (but if data is returned, it must not be false).
543      * @param token The token targeted by the call.
544      * @param data The call data (encoded using abi.encode or one of its variants).
545      */
546     function _callOptionalReturn(IERC20 token, bytes memory data) private {
547         
548         
549         
550 
551         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
552         if (returndata.length > 0) { 
553             
554             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
555         }
556     }
557 }
558 
559 pragma solidity >=0.6.0 <0.7.0;
560 
561 contract Constants {
562     uint8 public constant N_COINS = 3;
563     uint8 public constant DEFAULT_DECIMALS = 18; 
564     uint256 public constant DEFAULT_DECIMALS_FACTOR = uint256(10)**DEFAULT_DECIMALS;
565     uint8 public constant CHAINLINK_PRICE_DECIMALS = 8;
566     uint256 public constant CHAINLINK_PRICE_DECIMAL_FACTOR = uint256(10)**CHAINLINK_PRICE_DECIMALS;
567     uint8 public constant PERCENTAGE_DECIMALS = 4;
568     uint256 public constant PERCENTAGE_DECIMAL_FACTOR = uint256(10)**PERCENTAGE_DECIMALS;
569     uint256 public constant CURVE_RATIO_DECIMALS = 6;
570     uint256 public constant CURVE_RATIO_DECIMALS_FACTOR = uint256(10)**CURVE_RATIO_DECIMALS;
571 }
572 
573 pragma solidity >=0.6.0 <0.7.0;
574 
575 interface IToken {
576     function factor() external view returns (uint256);
577 
578     function factor(uint256 totalAssets) external view returns (uint256);
579 
580     function mint(
581         address account,
582         uint256 _factor,
583         uint256 amount
584     ) external;
585 
586     function burn(
587         address account,
588         uint256 _factor,
589         uint256 amount
590     ) external;
591 
592     function burnAll(address account) external;
593 
594     function totalAssets() external view returns (uint256);
595 
596     function getPricePerShare() external view returns (uint256);
597 
598     function getShareAssets(uint256 shares) external view returns (uint256);
599 
600     function getAssets(address account) external view returns (uint256);
601 }
602 
603 pragma solidity >=0.6.0 <0.7.0;
604 
605 interface IVault {
606     function withdraw(uint256 amount) external;
607 
608     function withdraw(uint256 amount, address recipient) external;
609 
610     function withdrawByStrategyOrder(
611         uint256 amount,
612         address recipient,
613         bool reversed
614     ) external;
615 
616     function withdrawByStrategyIndex(
617         uint256 amount,
618         address recipient,
619         uint256 strategyIndex
620     ) external;
621 
622     function deposit(uint256 amount) external;
623 
624     function updateStrategyRatio(uint256[] calldata strategyRetios) external;
625 
626     function totalAssets() external view returns (uint256);
627 
628     function getStrategiesLength() external view returns (uint256);
629 
630     function strategyHarvestTrigger(uint256 index, uint256 callCost) external view returns (bool);
631 
632     function strategyHarvest(uint256 index) external returns (bool);
633 
634     function getStrategyAssets(uint256 index) external view returns (uint256);
635 
636     function token() external view returns (address);
637 
638     function vault() external view returns (address);
639 
640     function investTrigger() external view returns (bool);
641 
642     function invest() external;
643 }
644 
645 pragma solidity >=0.6.0 <0.7.0;
646 
647 contract FixedStablecoins is Constants {
648     address public immutable DAI; 
649     address public immutable USDC; 
650     address public immutable USDT; 
651 
652     uint256 public immutable DAI_DECIMALS; 
653     uint256 public immutable USDC_DECIMALS; 
654     uint256 public immutable USDT_DECIMALS; 
655 
656     constructor(address[N_COINS] memory _tokens, uint256[N_COINS] memory _decimals) public {
657         DAI = _tokens[0];
658         USDC = _tokens[1];
659         USDT = _tokens[2];
660         DAI_DECIMALS = _decimals[0];
661         USDC_DECIMALS = _decimals[1];
662         USDT_DECIMALS = _decimals[2];
663     }
664 
665     function underlyingTokens() internal view returns (address[N_COINS] memory tokens) {
666         tokens[0] = DAI;
667         tokens[1] = USDC;
668         tokens[2] = USDT;
669     }
670 
671     function getToken(uint256 index) internal view returns (address) {
672         if (index == 0) {
673             return DAI;
674         } else if (index == 1) {
675             return USDC;
676         } else {
677             return USDT;
678         }
679     }
680 
681     function decimals() internal view returns (uint256[N_COINS] memory _decimals) {
682         _decimals[0] = DAI_DECIMALS;
683         _decimals[1] = USDC_DECIMALS;
684         _decimals[2] = USDT_DECIMALS;
685     }
686 
687     function getDecimal(uint256 index) internal view returns (uint256) {
688         if (index == 0) {
689             return DAI_DECIMALS;
690         } else if (index == 1) {
691             return USDC_DECIMALS;
692         } else {
693             return USDT_DECIMALS;
694         }
695     }
696 }
697 
698 contract FixedGTokens {
699     IToken public immutable pwrd;
700     IToken public immutable gvt;
701 
702     constructor(address _pwrd, address _gvt) public {
703         pwrd = IToken(_pwrd);
704         gvt = IToken(_gvt);
705     }
706 
707     function gTokens(bool _pwrd) internal view returns (IToken) {
708         if (_pwrd) {
709             return pwrd;
710         } else {
711             return gvt;
712         }
713     }
714 }
715 
716 contract FixedVaults is Constants {
717     address public immutable DAI_VAULT;
718     address public immutable USDC_VAULT;
719     address public immutable USDT_VAULT;
720 
721     constructor(address[N_COINS] memory _vaults) public {
722         DAI_VAULT = _vaults[0];
723         USDC_VAULT = _vaults[1];
724         USDT_VAULT = _vaults[2];
725     }
726 
727     function getVault(uint256 index) internal view returns (address) {
728         if (index == 0) {
729             return DAI_VAULT;
730         } else if (index == 1) {
731             return USDC_VAULT;
732         } else {
733             return USDT_VAULT;
734         }
735     }
736 
737     function vaults() internal view returns (address[N_COINS] memory _vaults) {
738         _vaults[0] = DAI_VAULT;
739         _vaults[1] = USDC_VAULT;
740         _vaults[2] = USDT_VAULT;
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
893 interface IEmergencyHandler {
894     function emergencyWithdrawal(
895         address user,
896         bool pwrd,
897         uint256 inAmount,
898         uint256 minAmounts
899     ) external;
900 
901     function emergencyWithdrawAll(
902         address user,
903         bool pwrd,
904         uint256 minAmounts
905     ) external;
906 }
907 
908 pragma solidity >=0.6.0 <0.7.0;
909 
910 interface IInsurance {
911     function calculateDepositDeltasOnAllVaults() external view returns (uint256[3] memory);
912 
913     function rebalanceTrigger() external view returns (bool sysNeedRebalance);
914 
915     function rebalance() external;
916 
917     function calcSkim() external view returns (uint256);
918 
919     function rebalanceForWithdraw(uint256 withdrawUsd, bool pwrd) external returns (bool);
920 
921     function getDelta(uint256 withdrawUsd) external view returns (uint256[3] memory delta);
922 
923     function getVaultDeltaForDeposit(uint256 amount) external view returns (uint256[3] memory, uint256);
924 
925     function sortVaultsByDelta(bool bigFirst) external view returns (uint256[3] memory vaultIndexes);
926 
927     function getStrategiesTargetRatio(uint256 utilRatio) external view returns (uint256[] memory);
928 
929     function setUnderlyingTokenPercents(uint256[3] calldata percents) external;
930 }
931 
932 pragma solidity >=0.6.0 <0.7.0;
933 
934 interface ILifeGuard {
935     function assets(uint256 i) external view returns (uint256);
936 
937     function totalAssets() external view returns (uint256);
938 
939     function getAssets() external view returns (uint256[3] memory);
940 
941     function totalAssetsUsd() external view returns (uint256);
942 
943     function availableUsd() external view returns (uint256 dollar);
944 
945     function availableLP() external view returns (uint256);
946 
947     function depositStable(bool rebalance) external returns (uint256);
948 
949     function investToCurveVault() external;
950 
951     function distributeCurveVault(uint256 amount, uint256[3] memory delta) external returns (uint256[3] memory);
952 
953     function deposit() external returns (uint256 usdAmount);
954 
955     function withdrawSingleByLiquidity(
956         uint256 i,
957         uint256 minAmount,
958         address recipient
959     ) external returns (uint256 usdAmount, uint256 amount);
960 
961     function withdrawSingleByExchange(
962         uint256 i,
963         uint256 minAmount,
964         address recipient
965     ) external returns (uint256 usdAmount, uint256 amount);
966 
967     function invest(uint256 whaleDepositAmount, uint256[3] calldata delta) external returns (uint256 dollarAmount);
968 
969     function getBuoy() external view returns (address);
970 
971     function investSingle(
972         uint256[3] calldata inAmounts,
973         uint256 i,
974         uint256 j
975     ) external returns (uint256 dollarAmount);
976 
977     function investToCurveVaultTrigger() external view returns (bool _invest);
978 }
979 
980 pragma solidity >=0.6.0 <0.7.0;
981 
982 interface IWithdrawHandler {
983     function withdrawByLPToken(
984         bool pwrd,
985         uint256 lpAmount,
986         uint256[3] calldata minAmounts
987     ) external;
988 
989     function withdrawByStablecoin(
990         bool pwrd,
991         uint256 index,
992         uint256 lpAmount,
993         uint256 minAmount
994     ) external;
995 
996     function withdrawAllSingle(
997         bool pwrd,
998         uint256 index,
999         uint256 minAmount
1000     ) external;
1001 
1002     function withdrawAllBalanced(bool pwrd, uint256[3] calldata minAmounts) external;
1003 }
1004 
1005 pragma solidity >=0.6.0 <0.7.0;
1006 
1007 contract WithdrawHandler is Controllable, FixedStablecoins, FixedVaults, IWithdrawHandler {
1008     using SafeERC20 for IERC20;
1009     using SafeMath for uint256;
1010     IController public ctrl;
1011     ILifeGuard public lg;
1012     IBuoy public buoy;
1013     IInsurance public insurance;
1014     IEmergencyHandler public emergencyHandler;
1015 
1016     event LogNewDependencies(
1017         address controller,
1018         address lifeguard,
1019         address buoy,
1020         address insurance,
1021         address emergencyHandler
1022     );
1023     event LogNewWithdrawal(
1024         address indexed user,
1025         address indexed referral,
1026         bool pwrd,
1027         bool balanced,
1028         bool all,
1029         uint256 deductUsd,
1030         uint256 returnUsd,
1031         uint256 lpAmount,
1032         uint256[N_COINS] tokenAmounts
1033     );
1034 
1035     
1036     struct WithdrawParameter {
1037         address account;
1038         bool pwrd;
1039         bool balanced;
1040         bool all;
1041         uint256 index;
1042         uint256[N_COINS] minAmounts;
1043         uint256 lpAmount;
1044     }
1045 
1046     constructor(
1047         address[N_COINS] memory _vaults,
1048         address[N_COINS] memory _tokens,
1049         uint256[N_COINS] memory _decimals
1050     ) public FixedStablecoins(_tokens, _decimals) FixedVaults(_vaults) {}
1051 
1052     function setDependencies() external onlyOwner {
1053         ctrl = _controller();
1054         lg = ILifeGuard(ctrl.lifeGuard());
1055         buoy = IBuoy(lg.getBuoy());
1056         insurance = IInsurance(ctrl.insurance());
1057         emergencyHandler = IEmergencyHandler(ctrl.emergencyHandler());
1058         emit LogNewDependencies(
1059             address(ctrl),
1060             address(lg),
1061             address(buoy),
1062             address(insurance),
1063             address(emergencyHandler)
1064         );
1065     }
1066 
1067     function withdrawByLPToken(
1068         bool pwrd,
1069         uint256 lpAmount,
1070         uint256[N_COINS] calldata minAmounts
1071     ) external override {
1072         require(!ctrl.emergencyState(), "withdrawByLPToken: emergencyState");
1073         require(lpAmount > 0, "!minAmount");
1074         WithdrawParameter memory parameters = WithdrawParameter(
1075             msg.sender,
1076             pwrd,
1077             true,
1078             false,
1079             N_COINS,
1080             minAmounts,
1081             lpAmount
1082         );
1083         _withdraw(parameters);
1084     }
1085 
1086     function withdrawByStablecoin(
1087         bool pwrd,
1088         uint256 index,
1089         uint256 lpAmount,
1090         uint256 minAmount
1091     ) external override {
1092         if (ctrl.emergencyState()) {
1093             emergencyHandler.emergencyWithdrawal(msg.sender, pwrd, lpAmount, minAmount);
1094         } else {
1095             require(index < N_COINS, "!withdrawByStablecoin: invalid index");
1096             require(lpAmount > 0, "!lpAmount");
1097             uint256[N_COINS] memory minAmounts;
1098             minAmounts[index] = minAmount;
1099             WithdrawParameter memory parameters = WithdrawParameter(
1100                 msg.sender,
1101                 pwrd,
1102                 false,
1103                 false,
1104                 index,
1105                 minAmounts,
1106                 lpAmount
1107             );
1108             _withdraw(parameters);
1109         }
1110     }
1111 
1112     function withdrawAllSingle(
1113         bool pwrd,
1114         uint256 index,
1115         uint256 minAmount
1116     ) external override {
1117         if (ctrl.emergencyState()) {
1118             emergencyHandler.emergencyWithdrawAll(msg.sender, pwrd, minAmount);
1119         } else {
1120             _withdrawAllSingleFromAccount(msg.sender, pwrd, index, minAmount);
1121         }
1122     }
1123 
1124     function withdrawAllBalanced(bool pwrd, uint256[N_COINS] calldata minAmounts) external override {
1125         require(!ctrl.emergencyState(), "withdrawByLPToken: emergencyState");
1126         WithdrawParameter memory parameters = WithdrawParameter(msg.sender, pwrd, true, true, N_COINS, minAmounts, 0);
1127         _withdraw(parameters);
1128     }
1129 
1130     function getVaultDeltas(uint256 amount) external view returns (uint256[N_COINS] memory tokenAmounts) {
1131         uint256[N_COINS] memory delta = insurance.getDelta(buoy.lpToUsd(amount));
1132         for (uint256 i; i < N_COINS; i++) {
1133             uint256 withdraw = amount.mul(delta[i]).div(PERCENTAGE_DECIMAL_FACTOR);
1134             if (withdraw > 0) tokenAmounts[i] = buoy.singleStableFromLp(withdraw, int128(i));
1135         }
1136     }
1137 
1138     function withdrawalFee(bool pwrd) public view returns (uint256) {
1139         return ctrl.withdrawalFee(pwrd);
1140     }
1141 
1142     function _withdrawAllSingleFromAccount(
1143         address account,
1144         bool pwrd,
1145         uint256 index,
1146         uint256 minAmount
1147     ) private {
1148         require(index < N_COINS, "!withdrawAllSingleFromAccount: invalid index");
1149         uint256[N_COINS] memory minAmounts;
1150         minAmounts[index] = minAmount;
1151         WithdrawParameter memory parameters = WithdrawParameter(account, pwrd, false, true, index, minAmounts, 0);
1152         _withdraw(parameters);
1153     }
1154 
1155     function _withdraw(WithdrawParameter memory parameters) private {
1156         IController _ctrl = ctrl;
1157         IBuoy _buoy = buoy;
1158         _ctrl.eoaOnly(msg.sender);
1159         require(_buoy.safetyCheck(), "!safetyCheck");
1160 
1161         uint256 deductUsd;
1162         uint256 returnUsd;
1163         uint256 lpAmountFee;
1164         uint256[N_COINS] memory tokenAmounts;
1165         
1166         uint256 virtualPrice = _buoy.getVirtualPrice();
1167         if (parameters.all) {
1168             deductUsd = _ctrl.getUserAssets(parameters.pwrd, parameters.account);
1169             returnUsd = deductUsd.sub(deductUsd.mul(withdrawalFee(parameters.pwrd)).div(PERCENTAGE_DECIMAL_FACTOR));
1170             lpAmountFee = returnUsd.mul(DEFAULT_DECIMALS_FACTOR).div(virtualPrice);
1171             
1172         } else {
1173             uint256 userAssets = _ctrl.getUserAssets(parameters.pwrd, parameters.account);
1174             uint256 lpAmount = parameters.lpAmount;
1175             uint256 fee = lpAmount.mul(withdrawalFee(parameters.pwrd)).div(PERCENTAGE_DECIMAL_FACTOR);
1176             lpAmountFee = lpAmount.sub(fee);
1177             returnUsd = lpAmountFee.mul(virtualPrice).div(DEFAULT_DECIMALS_FACTOR);
1178             deductUsd = lpAmount.mul(virtualPrice).div(DEFAULT_DECIMALS_FACTOR);
1179             require(deductUsd <= userAssets, "!withdraw: not enough balance");
1180         }
1181         uint256 hodlerBonus = deductUsd.sub(returnUsd);
1182 
1183         bool whale = _ctrl.isValidBigFish(parameters.pwrd, false, returnUsd);
1184 
1185         
1186         if (parameters.balanced) {
1187             (returnUsd, tokenAmounts) = _withdrawBalanced(
1188                 parameters.account,
1189                 parameters.pwrd,
1190                 lpAmountFee,
1191                 parameters.minAmounts,
1192                 returnUsd
1193             );
1194             
1195         } else {
1196             (returnUsd, tokenAmounts[parameters.index]) = _withdrawSingle(
1197                 parameters.account,
1198                 parameters.pwrd,
1199                 lpAmountFee,
1200                 parameters.minAmounts[parameters.index],
1201                 parameters.index,
1202                 returnUsd,
1203                 whale
1204             );
1205         }
1206 
1207         _ctrl.burnGToken(parameters.pwrd, parameters.all, parameters.account, deductUsd, hodlerBonus);
1208 
1209         emit LogNewWithdrawal(
1210             parameters.account,
1211             _ctrl.referrals(parameters.account),
1212             parameters.pwrd,
1213             parameters.balanced,
1214             parameters.all,
1215             deductUsd,
1216             returnUsd,
1217             lpAmountFee,
1218             tokenAmounts
1219         );
1220     }
1221 
1222     function _withdrawSingle(
1223         address account,
1224         bool pwrd,
1225         uint256 lpAmount,
1226         uint256 minAmount,
1227         uint256 index,
1228         uint256 withdrawUsd,
1229         bool whale
1230     ) private returns (uint256 dollarAmount, uint256 tokenAmount) {
1231         dollarAmount = withdrawUsd;
1232         
1233         if (whale) {
1234             (dollarAmount, tokenAmount) = _prepareForWithdrawalSingle(account, pwrd, index, minAmount, withdrawUsd);
1235         } else {
1236             
1237             IVault adapter = IVault(getVault(index));
1238             tokenAmount = buoy.singleStableFromLp(lpAmount, int128(index));
1239             adapter.withdrawByStrategyOrder(tokenAmount, account, pwrd);
1240         }
1241         require(tokenAmount >= minAmount, "!withdrawSingle: !minAmount");
1242     }
1243 
1244     function _withdrawBalanced(
1245         address account,
1246         bool pwrd,
1247         uint256 lpAmount,
1248         uint256[N_COINS] memory minAmounts,
1249         uint256 withdrawUsd
1250     ) private returns (uint256 dollarAmount, uint256[N_COINS] memory tokenAmounts) {
1251         IBuoy _buoy = buoy;
1252         uint256[N_COINS] memory delta = insurance.getDelta(withdrawUsd);
1253         address[N_COINS] memory _vaults = vaults();
1254         for (uint256 i; i < N_COINS; i++) {
1255             uint256 withdraw = lpAmount.mul(delta[i]).div(PERCENTAGE_DECIMAL_FACTOR);
1256             if (withdraw > 0) {
1257                 tokenAmounts[i] = buoy.singleStableFromLp(withdraw, int128(i));
1258                 require(tokenAmounts[i] >= minAmounts[i], "!withdrawBalanced: !minAmount");
1259                 IVault adapter = IVault(_vaults[i]);
1260                 require(tokenAmounts[i] <= adapter.totalAssets(), "_withdrawBalanced: !adapterBalance");
1261                 adapter.withdrawByStrategyOrder(tokenAmounts[i], account, pwrd);
1262             }
1263         }
1264         dollarAmount = buoy.stableToUsd(tokenAmounts, false);
1265     }
1266 
1267     function _prepareForWithdrawalSingle(
1268         address account,
1269         bool pwrd,
1270         uint256 index,
1271         uint256 minAmount,
1272         uint256 withdrawUsd
1273     ) private returns (uint256 dollarAmount, uint256 amount) {
1274         bool curve = insurance.rebalanceForWithdraw(withdrawUsd, pwrd);
1275         ILifeGuard _lg = lg;
1276         if (curve) {
1277             _lg.depositStable(false);
1278             (dollarAmount, amount) = _lg.withdrawSingleByLiquidity(index, minAmount, account);
1279         } else {
1280             (dollarAmount, amount) = _lg.withdrawSingleByExchange(index, minAmount, account);
1281         }
1282         require(minAmount <= amount, "!prepareForWithdrawalSingle: !minAmount");
1283     }
1284 }