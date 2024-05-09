1 // SPDX-License-Identifier: MIT
2 // DNA Token contract
3 
4 pragma solidity 0.7.6;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/contracts/math/SafeMath.sol
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, with an overflow flag.
98      *
99      * _Available since v3.4._
100      */
101     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
102         uint256 c = a + b;
103         if (c < a) return (false, 0);
104         return (true, c);
105     }
106 
107     /**
108      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
109      *
110      * _Available since v3.4._
111      */
112     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
113         if (b > a) return (false, 0);
114         return (true, a - b);
115     }
116 
117     /**
118      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
119      *
120      * _Available since v3.4._
121      */
122     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
124         // benefit is lost if 'b' is also tested.
125         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
126         if (a == 0) return (true, 0);
127         uint256 c = a * b;
128         if (c / a != b) return (false, 0);
129         return (true, c);
130     }
131 
132     /**
133      * @dev Returns the division of two unsigned integers, with a division by zero flag.
134      *
135      * _Available since v3.4._
136      */
137     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         if (b == 0) return (false, 0);
139         return (true, a / b);
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
144      *
145      * _Available since v3.4._
146      */
147     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         if (b == 0) return (false, 0);
149         return (true, a % b);
150     }
151 
152     /**
153      * @dev Returns the addition of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `+` operator.
157      *
158      * Requirements:
159      *
160      * - Addition cannot overflow.
161      */
162     function add(uint256 a, uint256 b) internal pure returns (uint256) {
163         uint256 c = a + b;
164         require(c >= a, "SafeMath: addition overflow");
165         return c;
166     }
167 
168     /**
169      * @dev Returns the subtraction of two unsigned integers, reverting on
170      * overflow (when the result is negative).
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b <= a, "SafeMath: subtraction overflow");
180         return a - b;
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `*` operator.
188      *
189      * Requirements:
190      *
191      * - Multiplication cannot overflow.
192      */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         if (a == 0) return 0;
195         uint256 c = a * b;
196         require(c / a == b, "SafeMath: multiplication overflow");
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers, reverting on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         require(b > 0, "SafeMath: division by zero");
214         return a / b;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * reverting when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         require(b > 0, "SafeMath: modulo by zero");
231         return a % b;
232     }
233 
234     /**
235      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
236      * overflow (when the result is negative).
237      *
238      * CAUTION: This function is deprecated because it requires allocating memory for the error
239      * message unnecessarily. For custom revert reasons use {trySub}.
240      *
241      * Counterpart to Solidity's `-` operator.
242      *
243      * Requirements:
244      *
245      * - Subtraction cannot overflow.
246      */
247     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b <= a, errorMessage);
249         return a - b;
250     }
251 
252     /**
253      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
254      * division by zero. The result is rounded towards zero.
255      *
256      * CAUTION: This function is deprecated because it requires allocating memory for the error
257      * message unnecessarily. For custom revert reasons use {tryDiv}.
258      *
259      * Counterpart to Solidity's `/` operator. Note: this function uses a
260      * `revert` opcode (which leaves remaining gas untouched) while Solidity
261      * uses an invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b > 0, errorMessage);
269         return a / b;
270     }
271 
272     /**
273      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
274      * reverting with custom message when dividing by zero.
275      *
276      * CAUTION: This function is deprecated because it requires allocating memory for the error
277      * message unnecessarily. For custom revert reasons use {tryMod}.
278      *
279      * Counterpart to Solidity's `%` operator. This function uses a `revert`
280      * opcode (which leaves remaining gas untouched) while Solidity uses an
281      * invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
288         require(b > 0, errorMessage);
289         return a % b;
290     }
291 }
292 
293 // File: @openzeppelin/contracts/utils/Address.sol
294 
295 /**
296  * @dev Collection of functions related to the address type
297  */
298 library Address {
299     /**
300      * @dev Returns true if `account` is a contract.
301      *
302      * [IMPORTANT]
303      * ====
304      * It is unsafe to assume that an address for which this function returns
305      * false is an externally-owned account (EOA) and not a contract.
306      *
307      * Among others, `isContract` will return false for the following
308      * types of addresses:
309      *
310      *  - an externally-owned account
311      *  - a contract in construction
312      *  - an address where a contract will be created
313      *  - an address where a contract lived, but was destroyed
314      * ====
315      */
316     function isContract(address account) internal view returns (bool) {
317         // This method relies on extcodesize, which returns 0 for contracts in
318         // construction, since the code is only stored at the end of the
319         // constructor execution.
320 
321         uint256 size;
322         // solhint-disable-next-line no-inline-assembly
323         assembly { size := extcodesize(account) }
324         return size > 0;
325     }
326 
327     /**
328      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
329      * `recipient`, forwarding all available gas and reverting on errors.
330      *
331      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
332      * of certain opcodes, possibly making contracts go over the 2300 gas limit
333      * imposed by `transfer`, making them unable to receive funds via
334      * `transfer`. {sendValue} removes this limitation.
335      *
336      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
337      *
338      * IMPORTANT: because control is transferred to `recipient`, care must be
339      * taken to not create reentrancy vulnerabilities. Consider using
340      * {ReentrancyGuard} or the
341      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
342      */
343     function sendValue(address payable recipient, uint256 amount) internal {
344         require(address(this).balance >= amount, "Address: insufficient balance");
345 
346         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
347         (bool success, ) = recipient.call{ value: amount }("");
348         require(success, "Address: unable to send value, recipient may have reverted");
349     }
350 
351     /**
352      * @dev Performs a Solidity function call using a low level `call`. A
353      * plain`call` is an unsafe replacement for a function call: use this
354      * function instead.
355      *
356      * If `target` reverts with a revert reason, it is bubbled up by this
357      * function (like regular Solidity function calls).
358      *
359      * Returns the raw returned data. To convert to the expected return value,
360      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
361      *
362      * Requirements:
363      *
364      * - `target` must be a contract.
365      * - calling `target` with `data` must not revert.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
370       return functionCall(target, data, "Address: low-level call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
375      * `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, 0, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but also transferring `value` wei to `target`.
386      *
387      * Requirements:
388      *
389      * - the calling contract must have an ETH balance of at least `value`.
390      * - the called Solidity function must be `payable`.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
395         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
400      * with `errorMessage` as a fallback revert reason when `target` reverts.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
405         require(address(this).balance >= value, "Address: insufficient balance for call");
406         require(isContract(target), "Address: call to non-contract");
407 
408         // solhint-disable-next-line avoid-low-level-calls
409         (bool success, bytes memory returndata) = target.call{ value: value }(data);
410         return _verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
415      * but performing a static call.
416      *
417      * _Available since v3.3._
418      */
419     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
420         return functionStaticCall(target, data, "Address: low-level static call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
430         require(isContract(target), "Address: static call to non-contract");
431 
432         // solhint-disable-next-line avoid-low-level-calls
433         (bool success, bytes memory returndata) = target.staticcall(data);
434         return _verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
444         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
454         require(isContract(target), "Address: delegate call to non-contract");
455 
456         // solhint-disable-next-line avoid-low-level-calls
457         (bool success, bytes memory returndata) = target.delegatecall(data);
458         return _verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468 
469                 // solhint-disable-next-line no-inline-assembly
470                 assembly {
471                     let returndata_size := mload(returndata)
472                     revert(add(32, returndata), returndata_size)
473                 }
474             } else {
475                 revert(errorMessage);
476             }
477         }
478     }
479 }
480 
481 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
482 
483 /**
484  * @title SafeERC20
485  * @dev Wrappers around ERC20 operations that throw on failure (when the token
486  * contract returns false). Tokens that return no value (and instead revert or
487  * throw on failure) are also supported, non-reverting calls are assumed to be
488  * successful.
489  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
490  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
491  */
492 library SafeERC20 {
493     using SafeMath for uint256;
494     using Address for address;
495 
496     function safeTransfer(IERC20 token, address to, uint256 value) internal {
497         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
498     }
499 
500     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
501         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
502     }
503 
504     /**
505      * @dev Deprecated. This function has issues similar to the ones found in
506      * {IERC20-approve}, and its usage is discouraged.
507      *
508      * Whenever possible, use {safeIncreaseAllowance} and
509      * {safeDecreaseAllowance} instead.
510      */
511     function safeApprove(IERC20 token, address spender, uint256 value) internal {
512         // safeApprove should only be called when setting an initial allowance,
513         // or when resetting it to zero. To increase and decrease it, use
514         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
515         // solhint-disable-next-line max-line-length
516         require((value == 0) || (token.allowance(address(this), spender) == 0),
517             "SafeERC20: approve from non-zero to non-zero allowance"
518         );
519         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
520     }
521 
522     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
523         uint256 newAllowance = token.allowance(address(this), spender).add(value);
524         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
525     }
526 
527     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
528         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
529         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
530     }
531 
532     /**
533      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
534      * on the return value: the return value is optional (but if data is returned, it must not be false).
535      * @param token The token targeted by the call.
536      * @param data The call data (encoded using abi.encode or one of its variants).
537      */
538     function _callOptionalReturn(IERC20 token, bytes memory data) private {
539         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
540         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
541         // the target address contains contract code and also asserts for success in the low-level call.
542 
543         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
544         if (returndata.length > 0) { // Return data is optional
545             // solhint-disable-next-line max-line-length
546             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
547         }
548     }
549 }
550 
551 // File: contracts/DNAToken.sol
552 
553 contract DNAToken is IERC20 {
554     using SafeMath for uint256;
555     using SafeERC20 for IERC20;
556 
557     uint256 constant private MAX_UINT256 = ~uint256(0);
558     string constant public name = "DNA";
559     string constant public symbol = "DNA";
560     uint8 constant public decimals = 18;
561 
562     mapping (address => uint256) private _balances;
563     mapping (address => mapping (address => uint256)) private _allowances;
564     uint256 private _totalSupply;
565 
566     bytes32 public DOMAIN_SEPARATOR;
567     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
568     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
569     mapping(address => uint256) public nonces;
570     
571     mapping(address => uint256) public reviewPeriods;
572     mapping(address => uint256) public decisionPeriods;
573     uint256 public reviewPeriod = 604800; // 7 days
574     uint256 public decisionPeriod = 7776000; // 90 days after review period
575     address public governanceBoard;
576     address public pendingGovernanceBoard;
577     bool public paused = true;
578 
579     event Paused();
580     event Unpaused();
581     event Reviewing(address indexed account, uint256 reviewUntil, uint256 decideUntil);
582     event Resolved(address indexed account);
583     event ReviewPeriodChanged(uint256 reviewPeriod);
584     event DecisionPeriodChanged(uint256 decisionPeriod);
585     event GovernanceBoardChanged(address indexed from, address indexed to);
586     event GovernedTransfer(address indexed from, address indexed to, uint256 amount);
587 
588     modifier whenNotPaused() {
589         require(!paused || msg.sender == governanceBoard, "Pausable: paused");
590         _;
591     }
592 
593     modifier onlyGovernanceBoard() {
594         require(msg.sender == governanceBoard, "Sender is not governance board");
595         _;
596     }
597 
598     modifier onlyPendingGovernanceBoard() {
599         require(msg.sender == pendingGovernanceBoard, "Sender is not the pending governance board");
600         _;
601     }
602 
603     modifier onlyResolved(address account) {
604         require(decisionPeriods[account] < block.timestamp, "Account is being reviewed");
605         _;
606     }
607 
608     constructor () public {
609         _setGovernanceBoard(msg.sender);
610         _totalSupply = 70938084472831915599080990;
611 
612         _balances[msg.sender] = _totalSupply;
613         emit Transfer(address(0), msg.sender, _totalSupply);
614 
615         uint256 chainId;
616         assembly {
617             chainId := chainid()
618         }
619 
620         DOMAIN_SEPARATOR = keccak256(
621             abi.encode(
622                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
623                 keccak256(bytes(name)),
624                 keccak256(bytes('1')),
625                 chainId,
626                 address(this)
627             )
628         );
629     }
630 
631     function pause() public onlyGovernanceBoard {
632         require(!paused, "Pausable: paused");
633         paused = true;
634         emit Paused();
635     }
636 
637     function unpause() public onlyGovernanceBoard {
638         require(paused, "Pausable: unpaused");
639         paused = false;
640         emit Unpaused();
641     }
642 
643     function review(address account) public onlyGovernanceBoard {
644         _review(account);
645     }
646 
647     function resolve(address account) public onlyGovernanceBoard {
648         _resolve(account);
649     }
650 
651     function electGovernanceBoard(address newGovernanceBoard) public onlyGovernanceBoard {
652         pendingGovernanceBoard = newGovernanceBoard;
653     }
654 
655     function takeGovernance() public onlyPendingGovernanceBoard {
656         _setGovernanceBoard(pendingGovernanceBoard);
657         pendingGovernanceBoard = address(0);
658     }
659 
660     function _setGovernanceBoard(address newGovernanceBoard) internal {
661         emit GovernanceBoardChanged(governanceBoard, newGovernanceBoard);
662         governanceBoard = newGovernanceBoard;
663     }
664 
665     /**
666      * @dev See {IERC20-totalSupply}.
667      */
668     function totalSupply() public view override returns (uint256) {
669         return _totalSupply;
670     }
671 
672     /**
673      * @dev See {IERC20-balanceOf}.
674      */
675     function balanceOf(address account) public view override returns (uint256) {
676         return _balances[account];
677     }
678 
679     /**
680      * @dev See {IERC20-transfer}.
681      *
682      * Requirements:
683      *
684      * - `recipient` cannot be the zero address.
685      * - the caller must have a balance of at least `amount`.
686      */
687     function transfer(address recipient, uint256 amount) public override 
688         onlyResolved(msg.sender)
689         onlyResolved(recipient)
690         whenNotPaused
691         returns (bool) {
692         _transfer(msg.sender, recipient, amount);
693         return true;
694     }
695 
696     /**
697      * @dev See {IERC20-allowance}.
698      */
699     function allowance(address owner, address spender) public view override returns (uint256) {
700         return _allowances[owner][spender];
701     }
702 
703     /**
704      * @dev See {IERC20-approve}.
705      *
706      * Requirements:
707      *
708      * - `spender` cannot be the zero address.
709      */
710     function approve(address spender, uint256 amount) public override
711         onlyResolved(msg.sender)
712         onlyResolved(spender)
713         whenNotPaused
714         returns (bool) {
715         _approve(msg.sender, spender, amount);
716         return true;
717     }
718 
719     /**
720      * @dev See {IERC20-transferFrom}.
721      *
722      * Emits an {Approval} event indicating the updated allowance. This is not
723      * required by the EIP. See the note at the beginning of {ERC20};
724      *
725      * Requirements:
726      * - `sender` and `recipient` cannot be the zero address.
727      * - `sender` must have a balance of at least `amount`.
728      * - the caller must have allowance for ``sender``'s tokens of at least
729      * `amount`.
730      */
731     function transferFrom(address sender, address recipient, uint256 amount) public override
732         onlyResolved(msg.sender)
733         onlyResolved(sender)
734         onlyResolved(recipient)
735         whenNotPaused
736         returns (bool) {
737         _transfer(sender, recipient, amount);
738         if (_allowances[sender][msg.sender] < MAX_UINT256) { // treat MAX_UINT256 approve as infinite approval
739             _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
740         }
741         return true;
742     }
743 
744     /**
745      * @dev Allows governance board to transfer funds.
746      *
747      * This allows to transfer tokens after review period have elapsed, 
748      * but before decision period is expired. So, basically governanceBoard have a time-window
749      * to move tokens from reviewed account. 
750      * After decision period have been expired remaining tokens are unlocked.
751      */
752     function governedTransfer(address from, address to, uint256 value) public onlyGovernanceBoard         
753         returns (bool) {
754         require(block.timestamp >  reviewPeriods[from], "Review period is not elapsed");
755         require(block.timestamp <= decisionPeriods[from], "Decision period expired");
756 
757         _transfer(from, to, value);
758         emit GovernedTransfer(from, to, value);
759         return true;
760     }
761 
762     /**
763      * @dev Atomically increases the allowance granted to `spender` by the caller.
764      *
765      * This is an alternative to {approve} that can be used as a mitigation for
766      * problems described in {IERC20-approve}.
767      *
768      * Emits an {Approval} event indicating the updated allowance.
769      *
770      * Requirements:
771      *
772      * - `spender` cannot be the zero address.
773      */
774     function increaseAllowance(address spender, uint256 addedValue) public 
775         onlyResolved(msg.sender)
776         onlyResolved(spender)
777         whenNotPaused
778         returns (bool) {
779         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
780         return true;
781     }
782 
783     /**
784      * @dev Atomically decreases the allowance granted to `spender` by the caller.
785      *
786      * This is an alternative to {approve} that can be used as a mitigation for
787      * problems described in {IERC20-approve}.
788      *
789      * Emits an {Approval} event indicating the updated allowance.
790      *
791      * Requirements:
792      *
793      * - `spender` cannot be the zero address.
794      * - `spender` must have allowance for the caller of at least
795      * `subtractedValue`.
796      */
797     function decreaseAllowance(address spender, uint256 subtractedValue) public 
798         onlyResolved(msg.sender)
799         onlyResolved(spender)
800         whenNotPaused
801         returns (bool) {
802         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
803         return true;
804     }
805 
806     /**
807      * @dev Moves tokens `amount` from `sender` to `recipient`.
808      *
809      * This is internal function is equivalent to {transfer}, and can be used to
810      * e.g. implement automatic token fees, slashing mechanisms, etc.
811      *
812      * Emits a {Transfer} event.
813      *
814      * Requirements:
815      *
816      * - `sender` cannot be the zero address.
817      * - `recipient` cannot be the zero address.
818      * - `sender` must have a balance of at least `amount`.
819      */
820     function _transfer(address sender, address recipient, uint256 amount) internal {
821         require(sender != address(0), "ERC20: transfer from the zero address");
822         require(recipient != address(0), "ERC20: transfer to the zero address");
823 
824         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
825         _balances[recipient] = _balances[recipient].add(amount);
826         emit Transfer(sender, recipient, amount);
827     }
828 
829     /**
830      * @dev Destroys `amount` tokens from `account`, reducing the
831      * total supply.
832      *
833      * Emits a {Transfer} event with `to` set to the zero address.
834      *
835      * Requirements
836      *
837      * - `account` cannot be the zero address.
838      * - `account` must have at least `amount` tokens.
839      */
840     function _burn(address account, uint256 amount) internal {
841         require(account != address(0), "ERC20: burn from the zero address");
842 
843         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
844         _totalSupply = _totalSupply.sub(amount);
845         emit Transfer(account, address(0), amount);
846     }
847 
848     /**
849      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
850      *
851      * This internal function is equivalent to `approve`, and can be used to
852      * e.g. set automatic allowances for certain subsystems, etc.
853      *
854      * Emits an {Approval} event.
855      *
856      * Requirements:
857      *
858      * - `owner` cannot be the zero address.
859      * - `spender` cannot be the zero address.
860      */
861     function _approve(address owner, address spender, uint256 amount) internal {
862         require(owner != address(0), "ERC20: approve from the zero address");
863         require(spender != address(0), "ERC20: approve to the zero address");
864 
865         _allowances[owner][spender] = amount;
866         emit Approval(owner, spender, amount);
867     }
868 
869     /**
870      * @dev Destroys `amount` tokens from the caller.
871      *
872      * See {ERC20-_burn}.
873      */
874     function burn(uint256 amount) public 
875         onlyResolved(msg.sender)
876         whenNotPaused
877     {
878         _burn(msg.sender, amount);
879     }
880 
881     function transferMany(address[] calldata recipients, uint256[] calldata amounts)
882         onlyResolved(msg.sender)
883         whenNotPaused
884         external {
885         require(recipients.length == amounts.length, "DNAToken: Wrong array length");
886 
887         uint256 total = 0;
888         for (uint256 i = 0; i < amounts.length; i++) {
889             total = total.add(amounts[i]);
890         }
891 
892         _balances[msg.sender] = _balances[msg.sender].sub(total, "ERC20: transfer amount exceeds balance");
893 
894         for (uint256 i = 0; i < recipients.length; i++) {
895             address recipient = recipients[i];
896             uint256 amount = amounts[i];
897             require(recipient != address(0), "ERC20: transfer to the zero address");
898             require(decisionPeriods[recipient] < block.timestamp, "Account is being reviewed");
899 
900             _balances[recipient] = _balances[recipient].add(amount);
901             emit Transfer(msg.sender, recipient, amount);
902         }
903     }
904 
905     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
906         // Need to unwrap modifiers to eliminate Stack too deep error
907         require(decisionPeriods[owner] < block.timestamp, "Account is being reviewed");
908         require(decisionPeriods[spender] < block.timestamp, "Account is being reviewed");
909         require(!paused || msg.sender == governanceBoard, "Pausable: paused");
910         require(deadline >= block.timestamp, 'DNAToken: EXPIRED');    
911         bytes32 digest = keccak256(
912             abi.encodePacked(
913                 '\x19\x01',
914                 DOMAIN_SEPARATOR,
915                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
916             )
917         );
918 
919         address recoveredAddress = ecrecover(digest, v, r, s);
920 
921         require(recoveredAddress != address(0) && recoveredAddress == owner, 'DNAToken: INVALID_SIGNATURE');
922         _approve(owner, spender, value);
923     }
924 
925     function setReviewPeriod(uint256 _reviewPeriod) public onlyGovernanceBoard {
926         reviewPeriod = _reviewPeriod;
927         emit ReviewPeriodChanged(reviewPeriod);
928     }
929 
930     function setDecisionPeriod(uint256 _decisionPeriod) public onlyGovernanceBoard {
931         decisionPeriod = _decisionPeriod;
932         emit DecisionPeriodChanged(decisionPeriod);
933     }
934 
935     function recoverTokens(IERC20 token, address to, uint256 amount) public onlyGovernanceBoard {
936         uint256 balance = token.balanceOf(address(this));
937         require(balance >= amount, "ERC20: Insufficient balance");
938         token.safeTransfer(to, amount);
939     }
940 
941     function _review(address account) internal {
942         uint256 reviewUntil = block.timestamp.add(reviewPeriod);
943         uint256 decideUntil = block.timestamp.add(reviewPeriod.add(decisionPeriod));
944         reviewPeriods[account] = reviewUntil;
945         decisionPeriods[account] = decideUntil;
946         emit Reviewing(account, reviewUntil, decideUntil);
947     }
948 
949     function _resolve(address account) internal {
950         reviewPeriods[account] = 0;
951         decisionPeriods[account] = 0;
952         emit Resolved(account);
953     }
954 }