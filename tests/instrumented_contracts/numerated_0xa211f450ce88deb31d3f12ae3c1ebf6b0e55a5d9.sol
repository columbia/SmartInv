1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
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
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
160 
161 
162 /**
163  * @dev Collection of functions related to the address type
164  */
165 library Address {
166     /**
167      * @dev Returns true if `account` is a contract.
168      *
169      * [IMPORTANT]
170      * ====
171      * It is unsafe to assume that an address for which this function returns
172      * false is an externally-owned account (EOA) and not a contract.
173      *
174      * Among others, `isContract` will return false for the following
175      * types of addresses:
176      *
177      *  - an externally-owned account
178      *  - a contract in construction
179      *  - an address where a contract will be created
180      *  - an address where a contract lived, but was destroyed
181      * ====
182      */
183     function isContract(address account) internal view returns (bool) {
184         // This method relies in extcodesize, which returns 0 for contracts in
185         // construction, since the code is only stored at the end of the
186         // constructor execution.
187 
188         uint256 size;
189         // solhint-disable-next-line no-inline-assembly
190         assembly { size := extcodesize(account) }
191         return size > 0;
192     }
193 
194     /**
195      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
196      * `recipient`, forwarding all available gas and reverting on errors.
197      *
198      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
199      * of certain opcodes, possibly making contracts go over the 2300 gas limit
200      * imposed by `transfer`, making them unable to receive funds via
201      * `transfer`. {sendValue} removes this limitation.
202      *
203      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
204      *
205      * IMPORTANT: because control is transferred to `recipient`, care must be
206      * taken to not create reentrancy vulnerabilities. Consider using
207      * {ReentrancyGuard} or the
208      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
209      */
210     function sendValue(address payable recipient, uint256 amount) internal {
211         require(address(this).balance >= amount, "Address: insufficient balance");
212 
213         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
214         (bool success, ) = recipient.call{ value: amount }("");
215         require(success, "Address: unable to send value, recipient may have reverted");
216     }
217 
218     /**
219      * @dev Performs a Solidity function call using a low level `call`. A
220      * plain`call` is an unsafe replacement for a function call: use this
221      * function instead.
222      *
223      * If `target` reverts with a revert reason, it is bubbled up by this
224      * function (like regular Solidity function calls).
225      *
226      * Returns the raw returned data. To convert to the expected return value,
227      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
228      *
229      * Requirements:
230      *
231      * - `target` must be a contract.
232      * - calling `target` with `data` must not revert.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
237       return functionCall(target, data, "Address: low-level call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
242      * `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
247         return _functionCallWithValue(target, data, 0, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but also transferring `value` wei to `target`.
253      *
254      * Requirements:
255      *
256      * - the calling contract must have an ETH balance of at least `value`.
257      * - the called Solidity function must be `payable`.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
262         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
267      * with `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
272         require(address(this).balance >= value, "Address: insufficient balance for call");
273         return _functionCallWithValue(target, data, value, errorMessage);
274     }
275 
276     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
277         require(isContract(target), "Address: call to non-contract");
278 
279         // solhint-disable-next-line avoid-low-level-calls
280         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
281         if (success) {
282             return returndata;
283         } else {
284             // Look for revert reason and bubble it up if present
285             if (returndata.length > 0) {
286                 // The easiest way to bubble the revert reason is using memory via assembly
287 
288                 // solhint-disable-next-line no-inline-assembly
289                 assembly {
290                     let returndata_size := mload(returndata)
291                     revert(add(32, returndata), returndata_size)
292                 }
293             } else {
294                 revert(errorMessage);
295             }
296         }
297     }
298 }
299 
300 /**
301  * @title SafeERC20
302  * @dev Wrappers around ERC20 operations that throw on failure (when the token
303  * contract returns false). Tokens that return no value (and instead revert or
304  * throw on failure) are also supported, non-reverting calls are assumed to be
305  * successful.
306  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
307  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
308  */
309 library SafeERC20 {
310     using SafeMath for uint256;
311     using Address for address;
312 
313     function safeTransfer(IERC20 token, address to, uint256 value) internal {
314         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
315     }
316 
317     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
318         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
319     }
320 
321     /**
322      * @dev Deprecated. This function has issues similar to the ones found in
323      * {IERC20-approve}, and its usage is discouraged.
324      *
325      * Whenever possible, use {safeIncreaseAllowance} and
326      * {safeDecreaseAllowance} instead.
327      */
328     function safeApprove(IERC20 token, address spender, uint256 value) internal {
329         // safeApprove should only be called when setting an initial allowance,
330         // or when resetting it to zero. To increase and decrease it, use
331         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
332         // solhint-disable-next-line max-line-length
333         require((value == 0) || (token.allowance(address(this), spender) == 0),
334             "SafeERC20: approve from non-zero to non-zero allowance"
335         );
336         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
337     }
338 
339     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
340         uint256 newAllowance = token.allowance(address(this), spender).add(value);
341         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
342     }
343 
344     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
345         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
346         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
347     }
348 
349     /**
350      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
351      * on the return value: the return value is optional (but if data is returned, it must not be false).
352      * @param token The token targeted by the call.
353      * @param data The call data (encoded using abi.encode or one of its variants).
354      */
355     function _callOptionalReturn(IERC20 token, bytes memory data) private {
356         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
357         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
358         // the target address contains contract code and also asserts for success in the low-level call.
359 
360         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
361         if (returndata.length > 0) { // Return data is optional
362             // solhint-disable-next-line max-line-length
363             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
364         }
365     }
366 }
367 
368 
369 /**
370  * @dev Interface of the ERC20 standard as defined in the EIP.
371  */
372 interface IERC20 {
373     /**
374      * @dev Returns the amount of tokens in existence.
375      */
376     function totalSupply() external view returns (uint256);
377 
378     /**
379      * @dev Returns the amount of tokens owned by `account`.
380      */
381     function balanceOf(address account) external view returns (uint256);
382 
383     /**
384      * @dev Moves `amount` tokens from the caller's account to `recipient`.
385      *
386      * Returns a boolean value indicating whether the operation succeeded.
387      *
388      * Emits a {Transfer} event.
389      */
390     function transfer(address recipient, uint256 amount) external returns (bool);
391 
392     /**
393      * @dev Returns the remaining number of tokens that `spender` will be
394      * allowed to spend on behalf of `owner` through {transferFrom}. This is
395      * zero by default.
396      *
397      * This value changes when {approve} or {transferFrom} are called.
398      */
399     function allowance(address owner, address spender) external view returns (uint256);
400 
401     /**
402      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
403      *
404      * Returns a boolean value indicating whether the operation succeeded.
405      *
406      * IMPORTANT: Beware that changing an allowance with this method brings the risk
407      * that someone may use both the old and the new allowance by unfortunate
408      * transaction ordering. One possible solution to mitigate this race
409      * condition is to first reduce the spender's allowance to 0 and set the
410      * desired value afterwards:
411      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
412      *
413      * Emits an {Approval} event.
414      */
415     function approve(address spender, uint256 amount) external returns (bool);
416 
417     /**
418      * @dev Moves `amount` tokens from `sender` to `recipient` using the
419      * allowance mechanism. `amount` is then deducted from the caller's
420      * allowance.
421      *
422      * Returns a boolean value indicating whether the operation succeeded.
423      *
424      * Emits a {Transfer} event.
425      */
426     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
427 
428     /**
429      * @dev Emitted when `value` tokens are moved from one account (`from`) to
430      * another (`to`).
431      *
432      * Note that `value` may be zero.
433      */
434     event Transfer(address indexed from, address indexed to, uint256 value);
435 
436     /**
437      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
438      * a call to {approve}. `value` is the new allowance.
439      */
440     event Approval(address indexed owner, address indexed spender, uint256 value);
441 }
442 
443 
444 contract ParsiqBoost is IERC20 {
445     using SafeMath for uint256;
446     using SafeERC20 for IERC20;
447 
448     uint256 constant private MAX_UINT256 = ~uint256(0);
449     string constant public name = "Parsiq Boost";
450     string constant public symbol = "PRQBOOST";
451     uint8 constant public decimals = 18;
452 
453     mapping (address => uint256) private _balances;
454     mapping (address => mapping (address => uint256)) private _allowances;
455     uint256 private _totalSupply;
456 
457     bytes32 public DOMAIN_SEPARATOR;
458     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
459     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
460     mapping(address => uint256) public nonces;
461     
462     mapping(address => uint256) public reviewPeriods;
463     mapping(address => uint256) public decisionPeriods;
464     uint256 public reviewPeriod = 86400; // 1 day
465     uint256 public decisionPeriod = 86400; // 1 day after review period
466     address public governanceBoard;
467     address public pendingGovernanceBoard;
468     bool public paused = true;
469 
470     event Paused();
471     event Unpaused();
472     event Reviewing(address indexed account, uint256 reviewUntil, uint256 decideUntil);
473     event Resolved(address indexed account);
474     event ReviewPeriodChanged(uint256 reviewPeriod);
475     event DecisionPeriodChanged(uint256 decisionPeriod);
476     event GovernanceBoardChanged(address indexed from, address indexed to);
477     event GovernedTransfer(address indexed from, address indexed to, uint256 amount);
478 
479     modifier whenNotPaused() {
480         require(!paused || msg.sender == governanceBoard, "Pausable: paused");
481         _;
482     }
483 
484     modifier onlyGovernanceBoard() {
485         require(msg.sender == governanceBoard, "Sender is not governance board");
486         _;
487     }
488 
489     modifier onlyPendingGovernanceBoard() {
490         require(msg.sender == pendingGovernanceBoard, "Sender is not the pending governance board");
491         _;
492     }
493 
494     modifier onlyResolved(address account) {
495         require(decisionPeriods[account] < block.timestamp, "Account is being reviewed");
496         _;
497     }
498 
499     constructor () public {
500         _setGovernanceBoard(msg.sender);
501         _totalSupply = 100000000e18; // 100 000 000 tokens
502 
503         _balances[msg.sender] = _totalSupply;
504         emit Transfer(address(0), msg.sender, _totalSupply);
505 
506         uint256 chainId;
507         assembly {
508             chainId := chainid()
509         }
510 
511         DOMAIN_SEPARATOR = keccak256(
512             abi.encode(
513                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
514                 keccak256(bytes(name)),
515                 keccak256(bytes('1')),
516                 chainId,
517                 address(this)
518             )
519         );
520     }
521 
522     function pause() public onlyGovernanceBoard {
523         require(!paused, "Pausable: paused");
524         paused = true;
525         emit Paused();
526     }
527 
528     function unpause() public onlyGovernanceBoard {
529         require(paused, "Pausable: unpaused");
530         paused = false;
531         emit Unpaused();
532     }
533 
534     function review(address account) public onlyGovernanceBoard {
535         _review(account);
536     }
537 
538     function resolve(address account) public onlyGovernanceBoard {
539         _resolve(account);
540     }
541 
542     function electGovernanceBoard(address newGovernanceBoard) public onlyGovernanceBoard {
543         pendingGovernanceBoard = newGovernanceBoard;
544     }
545 
546     function takeGovernance() public onlyPendingGovernanceBoard {
547         _setGovernanceBoard(pendingGovernanceBoard);
548         pendingGovernanceBoard = address(0);
549     }
550 
551     function _setGovernanceBoard(address newGovernanceBoard) internal {
552         emit GovernanceBoardChanged(governanceBoard, newGovernanceBoard);
553         governanceBoard = newGovernanceBoard;
554     }
555 
556     /**
557      * @dev See {IERC20-totalSupply}.
558      */
559     function totalSupply() public view override returns (uint256) {
560         return _totalSupply;
561     }
562 
563     /**
564      * @dev See {IERC20-balanceOf}.
565      */
566     function balanceOf(address account) public view override returns (uint256) {
567         return _balances[account];
568     }
569 
570     /**
571      * @dev See {IERC20-transfer}.
572      *
573      * Requirements:
574      *
575      * - `recipient` cannot be the zero address.
576      * - the caller must have a balance of at least `amount`.
577      */
578     function transfer(address recipient, uint256 amount) public override 
579         onlyResolved(msg.sender)
580         onlyResolved(recipient)
581         whenNotPaused
582         returns (bool) {
583         _transfer(msg.sender, recipient, amount);
584         return true;
585     }
586 
587     /**
588      * @dev See {IERC20-allowance}.
589      */
590     function allowance(address owner, address spender) public view override returns (uint256) {
591         return _allowances[owner][spender];
592     }
593 
594     /**
595      * @dev See {IERC20-approve}.
596      *
597      * Requirements:
598      *
599      * - `spender` cannot be the zero address.
600      */
601     function approve(address spender, uint256 amount) public override
602         onlyResolved(msg.sender)
603         onlyResolved(spender)
604         whenNotPaused
605         returns (bool) {
606         _approve(msg.sender, spender, amount);
607         return true;
608     }
609 
610     /**
611      * @dev See {IERC20-transferFrom}.
612      *
613      * Emits an {Approval} event indicating the updated allowance. This is not
614      * required by the EIP. See the note at the beginning of {ERC20};
615      *
616      * Requirements:
617      * - `sender` and `recipient` cannot be the zero address.
618      * - `sender` must have a balance of at least `amount`.
619      * - the caller must have allowance for ``sender``'s tokens of at least
620      * `amount`.
621      */
622     function transferFrom(address sender, address recipient, uint256 amount) public override
623         onlyResolved(msg.sender)
624         onlyResolved(sender)
625         onlyResolved(recipient)
626         whenNotPaused
627         returns (bool) {
628         _transfer(sender, recipient, amount);
629         if (_allowances[sender][msg.sender] < MAX_UINT256) { // treat MAX_UINT256 approve as infinite approval
630             _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
631         }
632         return true;
633     }
634 
635     /**
636      * @dev Allows governance board to transfer funds.
637      *
638      * This allows to transfer tokens after review period have elapsed, 
639      * but before decision period is expired. So, basically governanceBoard have a time-window
640      * to move tokens from reviewed account. 
641      * After decision period have been expired remaining tokens are unlocked.
642      */
643     function governedTransfer(address from, address to, uint256 value) public onlyGovernanceBoard         
644         returns (bool) {
645         require(block.timestamp >  reviewPeriods[from], "Review period is not elapsed");
646         require(block.timestamp <= decisionPeriods[from], "Decision period expired");
647 
648         _transfer(from, to, value);
649         emit GovernedTransfer(from, to, value);
650         return true;
651     }
652 
653     /**
654      * @dev Atomically increases the allowance granted to `spender` by the caller.
655      *
656      * This is an alternative to {approve} that can be used as a mitigation for
657      * problems described in {IERC20-approve}.
658      *
659      * Emits an {Approval} event indicating the updated allowance.
660      *
661      * Requirements:
662      *
663      * - `spender` cannot be the zero address.
664      */
665     function increaseAllowance(address spender, uint256 addedValue) public 
666         onlyResolved(msg.sender)
667         onlyResolved(spender)
668         whenNotPaused
669         returns (bool) {
670         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
671         return true;
672     }
673 
674     /**
675      * @dev Atomically decreases the allowance granted to `spender` by the caller.
676      *
677      * This is an alternative to {approve} that can be used as a mitigation for
678      * problems described in {IERC20-approve}.
679      *
680      * Emits an {Approval} event indicating the updated allowance.
681      *
682      * Requirements:
683      *
684      * - `spender` cannot be the zero address.
685      * - `spender` must have allowance for the caller of at least
686      * `subtractedValue`.
687      */
688     function decreaseAllowance(address spender, uint256 subtractedValue) public 
689         onlyResolved(msg.sender)
690         onlyResolved(spender)
691         whenNotPaused
692         returns (bool) {
693         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
694         return true;
695     }
696 
697     /**
698      * @dev Moves tokens `amount` from `sender` to `recipient`.
699      *
700      * This is internal function is equivalent to {transfer}, and can be used to
701      * e.g. implement automatic token fees, slashing mechanisms, etc.
702      *
703      * Emits a {Transfer} event.
704      *
705      * Requirements:
706      *
707      * - `sender` cannot be the zero address.
708      * - `recipient` cannot be the zero address.
709      * - `sender` must have a balance of at least `amount`.
710      */
711     function _transfer(address sender, address recipient, uint256 amount) internal {
712         require(sender != address(0), "ERC20: transfer from the zero address");
713         require(recipient != address(0), "ERC20: transfer to the zero address");
714 
715         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
716         _balances[recipient] = _balances[recipient].add(amount);
717         emit Transfer(sender, recipient, amount);
718     }
719 
720     /**
721      * @dev Destroys `amount` tokens from `account`, reducing the
722      * total supply.
723      *
724      * Emits a {Transfer} event with `to` set to the zero address.
725      *
726      * Requirements
727      *
728      * - `account` cannot be the zero address.
729      * - `account` must have at least `amount` tokens.
730      */
731     function _burn(address account, uint256 amount) internal {
732         require(account != address(0), "ERC20: burn from the zero address");
733 
734         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
735         _totalSupply = _totalSupply.sub(amount);
736         emit Transfer(account, address(0), amount);
737     }
738 
739     /**
740      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
741      *
742      * This internal function is equivalent to `approve`, and can be used to
743      * e.g. set automatic allowances for certain subsystems, etc.
744      *
745      * Emits an {Approval} event.
746      *
747      * Requirements:
748      *
749      * - `owner` cannot be the zero address.
750      * - `spender` cannot be the zero address.
751      */
752     function _approve(address owner, address spender, uint256 amount) internal {
753         require(owner != address(0), "ERC20: approve from the zero address");
754         require(spender != address(0), "ERC20: approve to the zero address");
755 
756         _allowances[owner][spender] = amount;
757         emit Approval(owner, spender, amount);
758     }
759 
760     /**
761      * @dev Destroys `amount` tokens from the caller.
762      *
763      * See {ERC20-_burn}.
764      */
765     function burn(uint256 amount) public 
766         onlyResolved(msg.sender)
767         whenNotPaused
768     {
769         _burn(msg.sender, amount);
770     }
771 
772     function transferMany(address[] calldata recipients, uint256[] calldata amounts)
773         onlyResolved(msg.sender)
774         whenNotPaused
775         external {
776         require(recipients.length == amounts.length, "ParsiqToken: Wrong array length");
777 
778         uint256 total = 0;
779         for (uint256 i = 0; i < amounts.length; i++) {
780             total = total.add(amounts[i]);
781         }
782 
783         _balances[msg.sender] = _balances[msg.sender].sub(total, "ERC20: transfer amount exceeds balance");
784 
785         for (uint256 i = 0; i < recipients.length; i++) {
786             address recipient = recipients[i];
787             uint256 amount = amounts[i];
788             require(recipient != address(0), "ERC20: transfer to the zero address");
789             require(decisionPeriods[recipient] < block.timestamp, "Account is being reviewed");
790 
791             _balances[recipient] = _balances[recipient].add(amount);
792             emit Transfer(msg.sender, recipient, amount);
793         }
794     }
795 
796     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
797         // Need to unwrap modifiers to eliminate Stack too deep error
798         require(decisionPeriods[owner] < block.timestamp, "Account is being reviewed");
799         require(decisionPeriods[spender] < block.timestamp, "Account is being reviewed");
800         require(!paused || msg.sender == governanceBoard, "Pausable: paused");
801         require(deadline >= block.timestamp, 'ParsiqToken: EXPIRED');    
802         bytes32 digest = keccak256(
803             abi.encodePacked(
804                 '\x19\x01',
805                 DOMAIN_SEPARATOR,
806                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
807             )
808         );
809 
810         address recoveredAddress = ecrecover(digest, v, r, s);
811 
812         require(recoveredAddress != address(0) && recoveredAddress == owner, 'ParsiqToken: INVALID_SIGNATURE');
813         _approve(owner, spender, value);
814     }
815 
816     function setReviewPeriod(uint256 _reviewPeriod) public onlyGovernanceBoard {
817         reviewPeriod = _reviewPeriod;
818         emit ReviewPeriodChanged(reviewPeriod);
819     }
820 
821     function setDecisionPeriod(uint256 _decisionPeriod) public onlyGovernanceBoard {
822         decisionPeriod = _decisionPeriod;
823         emit DecisionPeriodChanged(decisionPeriod);
824     }
825 
826     function recoverTokens(IERC20 token, address to, uint256 amount) public onlyGovernanceBoard {
827         uint256 balance = token.balanceOf(address(this));
828         require(balance >= amount, "ERC20: Insufficient balance");
829         token.safeTransfer(to, amount);
830     }
831 
832     function _review(address account) internal {
833         uint256 reviewUntil = block.timestamp.add(reviewPeriod);
834         uint256 decideUntil = block.timestamp.add(reviewPeriod.add(decisionPeriod));
835         reviewPeriods[account] = reviewUntil;
836         decisionPeriods[account] = decideUntil;
837         emit Reviewing(account, reviewUntil, decideUntil);
838     }
839 
840     function _resolve(address account) internal {
841         reviewPeriods[account] = 0;
842         decisionPeriods[account] = 0;
843         emit Resolved(account);
844     }
845 }