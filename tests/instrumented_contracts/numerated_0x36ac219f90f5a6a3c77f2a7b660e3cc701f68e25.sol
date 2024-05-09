1 pragma solidity 0.6.12;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 /**
78  * @dev Wrappers over Solidity's arithmetic operations with added overflow
79  * checks.
80  *
81  * Arithmetic operations in Solidity wrap on overflow. This can easily result
82  * in bugs, because programmers usually assume that an overflow raises an
83  * error, which is the standard behavior in high level programming languages.
84  * `SafeMath` restores this intuition by reverting the transaction when an
85  * operation overflows.
86  *
87  * Using this library instead of the unchecked operations eliminates an entire
88  * class of bugs, so it's recommended to use it always.
89  */
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
233 /**
234  * @dev Collection of functions related to the address type
235  */
236 library Address {
237     /**
238      * @dev Returns true if `account` is a contract.
239      *
240      * [IMPORTANT]
241      * ====
242      * It is unsafe to assume that an address for which this function returns
243      * false is an externally-owned account (EOA) and not a contract.
244      *
245      * Among others, `isContract` will return false for the following
246      * types of addresses:
247      *
248      *  - an externally-owned account
249      *  - a contract in construction
250      *  - an address where a contract will be created
251      *  - an address where a contract lived, but was destroyed
252      * ====
253      */
254     function isContract(address account) internal view returns (bool) {
255         // This method relies in extcodesize, which returns 0 for contracts in
256         // construction, since the code is only stored at the end of the
257         // constructor execution.
258 
259         uint256 size;
260         // solhint-disable-next-line no-inline-assembly
261         assembly { size := extcodesize(account) }
262         return size > 0;
263     }
264 
265     /**
266      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267      * `recipient`, forwarding all available gas and reverting on errors.
268      *
269      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270      * of certain opcodes, possibly making contracts go over the 2300 gas limit
271      * imposed by `transfer`, making them unable to receive funds via
272      * `transfer`. {sendValue} removes this limitation.
273      *
274      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275      *
276      * IMPORTANT: because control is transferred to `recipient`, care must be
277      * taken to not create reentrancy vulnerabilities. Consider using
278      * {ReentrancyGuard} or the
279      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280      */
281     function sendValue(address payable recipient, uint256 amount) internal {
282         require(address(this).balance >= amount, "Address: insufficient balance");
283 
284         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
285         (bool success, ) = recipient.call{ value: amount }("");
286         require(success, "Address: unable to send value, recipient may have reverted");
287     }
288 
289     /**
290      * @dev Performs a Solidity function call using a low level `call`. A
291      * plain`call` is an unsafe replacement for a function call: use this
292      * function instead.
293      *
294      * If `target` reverts with a revert reason, it is bubbled up by this
295      * function (like regular Solidity function calls).
296      *
297      * Returns the raw returned data. To convert to the expected return value,
298      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299      *
300      * Requirements:
301      *
302      * - `target` must be a contract.
303      * - calling `target` with `data` must not revert.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308       return functionCall(target, data, "Address: low-level call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313      * `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
318         return _functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
338      * with `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
343         require(address(this).balance >= value, "Address: insufficient balance for call");
344         return _functionCallWithValue(target, data, value, errorMessage);
345     }
346 
347     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
348         require(isContract(target), "Address: call to non-contract");
349 
350         // solhint-disable-next-line avoid-low-level-calls
351         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
352         if (success) {
353             return returndata;
354         } else {
355             // Look for revert reason and bubble it up if present
356             if (returndata.length > 0) {
357                 // The easiest way to bubble the revert reason is using memory via assembly
358 
359                 // solhint-disable-next-line no-inline-assembly
360                 assembly {
361                     let returndata_size := mload(returndata)
362                     revert(add(32, returndata), returndata_size)
363                 }
364             } else {
365                 revert(errorMessage);
366             }
367         }
368     }
369 }
370 
371 /**
372  * @title SafeERC20
373  * @dev Wrappers around ERC20 operations that throw on failure (when the token
374  * contract returns false). Tokens that return no value (and instead revert or
375  * throw on failure) are also supported, non-reverting calls are assumed to be
376  * successful.
377  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
378  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
379  */
380 library SafeERC20 {
381     using SafeMath for uint256;
382     using Address for address;
383 
384     function safeTransfer(IERC20 token, address to, uint256 value) internal {
385         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
386     }
387 
388     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
389         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
390     }
391 
392     /**
393      * @dev Deprecated. This function has issues similar to the ones found in
394      * {IERC20-approve}, and its usage is discouraged.
395      *
396      * Whenever possible, use {safeIncreaseAllowance} and
397      * {safeDecreaseAllowance} instead.
398      */
399     function safeApprove(IERC20 token, address spender, uint256 value) internal {
400         // safeApprove should only be called when setting an initial allowance,
401         // or when resetting it to zero. To increase and decrease it, use
402         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
403         // solhint-disable-next-line max-line-length
404         require((value == 0) || (token.allowance(address(this), spender) == 0),
405             "SafeERC20: approve from non-zero to non-zero allowance"
406         );
407         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
408     }
409 
410     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
411         uint256 newAllowance = token.allowance(address(this), spender).add(value);
412         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
413     }
414 
415     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
416         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
417         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
418     }
419 
420     /**
421      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
422      * on the return value: the return value is optional (but if data is returned, it must not be false).
423      * @param token The token targeted by the call.
424      * @param data The call data (encoded using abi.encode or one of its variants).
425      */
426     function _callOptionalReturn(IERC20 token, bytes memory data) private {
427         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
428         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
429         // the target address contains contract code and also asserts for success in the low-level call.
430 
431         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
432         if (returndata.length > 0) { // Return data is optional
433             // solhint-disable-next-line max-line-length
434             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
435         }
436     }
437 }
438 
439 contract CoinMetroToken is IERC20 {
440     using SafeMath for uint256;
441     using SafeERC20 for IERC20;
442 
443     uint256 constant private MAX_UINT256 = ~uint256(0);
444     string constant public name = "CoinMetro Token";
445     string constant public symbol = "XCM";
446     uint8 constant public decimals = 18;
447 
448     mapping (address => uint256) private _balances;
449     mapping (address => mapping (address => uint256)) private _allowances;
450     uint256 private _totalSupply;
451 
452     bytes32 public DOMAIN_SEPARATOR;
453     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
454     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
455     mapping(address => uint256) public nonces;
456     
457     mapping(address => uint256) public reviewPeriods;
458     mapping(address => uint256) public decisionPeriods;
459     uint256 public reviewPeriod = 604800; // 7 days
460     uint256 public decisionPeriod = 7776000; // 90 days after review period
461     address public governanceBoard;
462     address public pendingGovernanceBoard;
463     bool public paused = true;
464 
465     event Paused();
466     event Unpaused();
467     event Reviewing(address indexed account, uint256 reviewUntil, uint256 decideUntil);
468     event Resolved(address indexed account);
469     event ReviewPeriodChanged(uint256 reviewPeriod);
470     event DecisionPeriodChanged(uint256 decisionPeriod);
471     event GovernanceBoardChanged(address indexed from, address indexed to);
472     event GovernedTransfer(address indexed from, address indexed to, uint256 amount);
473 
474     modifier whenNotPaused() {
475         require(!paused || msg.sender == governanceBoard, "Pausable: paused");
476         _;
477     }
478 
479     modifier onlyGovernanceBoard() {
480         require(msg.sender == governanceBoard, "Sender is not governance board");
481         _;
482     }
483 
484     modifier onlyPendingGovernanceBoard() {
485         require(msg.sender == pendingGovernanceBoard, "Sender is not the pending governance board");
486         _;
487     }
488 
489     modifier onlyResolved(address account) {
490         require(decisionPeriods[account] < block.timestamp, "Account is being reviewed");
491         _;
492     }
493 
494     constructor () public {
495         _setGovernanceBoard(msg.sender);
496         _totalSupply = 330000000e18; // 330 000 000 tokens
497 
498         _balances[msg.sender] = _totalSupply;
499         emit Transfer(address(0), msg.sender, _totalSupply);
500 
501         uint256 chainId;
502         assembly {
503             chainId := chainid()
504         }
505 
506         DOMAIN_SEPARATOR = keccak256(
507             abi.encode(
508                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
509                 keccak256(bytes(name)),
510                 keccak256(bytes('1')),
511                 chainId,
512                 address(this)
513             )
514         );
515     }
516 
517     function pause() public onlyGovernanceBoard {
518         require(!paused, "Pausable: paused");
519         paused = true;
520         emit Paused();
521     }
522 
523     function unpause() public onlyGovernanceBoard {
524         require(paused, "Pausable: unpaused");
525         paused = false;
526         emit Unpaused();
527     }
528 
529     function review(address account) public onlyGovernanceBoard {
530         _review(account);
531     }
532 
533     function resolve(address account) public onlyGovernanceBoard {
534         _resolve(account);
535     }
536 
537     function electGovernanceBoard(address newGovernanceBoard) public onlyGovernanceBoard {
538         pendingGovernanceBoard = newGovernanceBoard;
539     }
540 
541     function takeGovernance() public onlyPendingGovernanceBoard {
542         _setGovernanceBoard(pendingGovernanceBoard);
543         pendingGovernanceBoard = address(0);
544     }
545 
546     function _setGovernanceBoard(address newGovernanceBoard) internal {
547         emit GovernanceBoardChanged(governanceBoard, newGovernanceBoard);
548         governanceBoard = newGovernanceBoard;
549     }
550 
551     /**
552      * @dev See {IERC20-totalSupply}.
553      */
554     function totalSupply() public view override returns (uint256) {
555         return _totalSupply;
556     }
557 
558     /**
559      * @dev See {IERC20-balanceOf}.
560      */
561     function balanceOf(address account) public view override returns (uint256) {
562         return _balances[account];
563     }
564 
565     /**
566      * @dev See {IERC20-transfer}.
567      *
568      * Requirements:
569      *
570      * - `recipient` cannot be the zero address.
571      * - the caller must have a balance of at least `amount`.
572      */
573     function transfer(address recipient, uint256 amount) public override 
574         onlyResolved(msg.sender)
575         onlyResolved(recipient)
576         whenNotPaused
577         returns (bool) {
578         _transfer(msg.sender, recipient, amount);
579         return true;
580     }
581 
582     /**
583      * @dev See {IERC20-allowance}.
584      */
585     function allowance(address owner, address spender) public view override returns (uint256) {
586         return _allowances[owner][spender];
587     }
588 
589     /**
590      * @dev See {IERC20-approve}.
591      *
592      * Requirements:
593      *
594      * - `spender` cannot be the zero address.
595      */
596     function approve(address spender, uint256 amount) public override
597         onlyResolved(msg.sender)
598         onlyResolved(spender)
599         whenNotPaused
600         returns (bool) {
601         _approve(msg.sender, spender, amount);
602         return true;
603     }
604 
605     /**
606      * @dev See {IERC20-transferFrom}.
607      *
608      * Emits an {Approval} event indicating the updated allowance. This is not
609      * required by the EIP. See the note at the beginning of {ERC20};
610      *
611      * Requirements:
612      * - `sender` and `recipient` cannot be the zero address.
613      * - `sender` must have a balance of at least `amount`.
614      * - the caller must have allowance for ``sender``'s tokens of at least
615      * `amount`.
616      */
617     function transferFrom(address sender, address recipient, uint256 amount) public override
618         onlyResolved(msg.sender)
619         onlyResolved(sender)
620         onlyResolved(recipient)
621         whenNotPaused
622         returns (bool) {
623         _transfer(sender, recipient, amount);
624         if (_allowances[sender][msg.sender] < MAX_UINT256) { // treat MAX_UINT256 approve as infinite approval
625             _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
626         }
627         return true;
628     }
629 
630     /**
631      * @dev Allows governance board to transfer funds.
632      *
633      * This allows to transfer tokens after review period have elapsed, 
634      * but before decision period is expired. So, basically governanceBoard have a time-window
635      * to move tokens from reviewed account. 
636      * After decision period have been expired remaining tokens are unlocked.
637      */
638     function governedTransfer(address from, address to, uint256 value) public onlyGovernanceBoard         
639         returns (bool) {
640         require(block.timestamp >  reviewPeriods[from], "Review period is not elapsed");
641         require(block.timestamp <= decisionPeriods[from], "Decision period expired");
642 
643         _transfer(from, to, value);
644         emit GovernedTransfer(from, to, value);
645         return true;
646     }
647 
648     /**
649      * @dev Atomically increases the allowance granted to `spender` by the caller.
650      *
651      * This is an alternative to {approve} that can be used as a mitigation for
652      * problems described in {IERC20-approve}.
653      *
654      * Emits an {Approval} event indicating the updated allowance.
655      *
656      * Requirements:
657      *
658      * - `spender` cannot be the zero address.
659      */
660     function increaseAllowance(address spender, uint256 addedValue) public 
661         onlyResolved(msg.sender)
662         onlyResolved(spender)
663         whenNotPaused
664         returns (bool) {
665         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
666         return true;
667     }
668 
669     /**
670      * @dev Atomically decreases the allowance granted to `spender` by the caller.
671      *
672      * This is an alternative to {approve} that can be used as a mitigation for
673      * problems described in {IERC20-approve}.
674      *
675      * Emits an {Approval} event indicating the updated allowance.
676      *
677      * Requirements:
678      *
679      * - `spender` cannot be the zero address.
680      * - `spender` must have allowance for the caller of at least
681      * `subtractedValue`.
682      */
683     function decreaseAllowance(address spender, uint256 subtractedValue) public 
684         onlyResolved(msg.sender)
685         onlyResolved(spender)
686         whenNotPaused
687         returns (bool) {
688         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
689         return true;
690     }
691 
692     /**
693      * @dev Moves tokens `amount` from `sender` to `recipient`.
694      *
695      * This is internal function is equivalent to {transfer}, and can be used to
696      * e.g. implement automatic token fees, slashing mechanisms, etc.
697      *
698      * Emits a {Transfer} event.
699      *
700      * Requirements:
701      *
702      * - `sender` cannot be the zero address.
703      * - `recipient` cannot be the zero address.
704      * - `sender` must have a balance of at least `amount`.
705      */
706     function _transfer(address sender, address recipient, uint256 amount) internal {
707         require(sender != address(0), "ERC20: transfer from the zero address");
708         require(recipient != address(0), "ERC20: transfer to the zero address");
709 
710         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
711         _balances[recipient] = _balances[recipient].add(amount);
712         emit Transfer(sender, recipient, amount);
713     }
714 
715     /**
716      * @dev Destroys `amount` tokens from `account`, reducing the
717      * total supply.
718      *
719      * Emits a {Transfer} event with `to` set to the zero address.
720      *
721      * Requirements
722      *
723      * - `account` cannot be the zero address.
724      * - `account` must have at least `amount` tokens.
725      */
726     function _burn(address account, uint256 amount) internal {
727         require(account != address(0), "ERC20: burn from the zero address");
728 
729         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
730         _totalSupply = _totalSupply.sub(amount);
731         emit Transfer(account, address(0), amount);
732     }
733 
734     /**
735      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
736      *
737      * This internal function is equivalent to `approve`, and can be used to
738      * e.g. set automatic allowances for certain subsystems, etc.
739      *
740      * Emits an {Approval} event.
741      *
742      * Requirements:
743      *
744      * - `owner` cannot be the zero address.
745      * - `spender` cannot be the zero address.
746      */
747     function _approve(address owner, address spender, uint256 amount) internal {
748         require(owner != address(0), "ERC20: approve from the zero address");
749         require(spender != address(0), "ERC20: approve to the zero address");
750 
751         _allowances[owner][spender] = amount;
752         emit Approval(owner, spender, amount);
753     }
754 
755     /**
756      * @dev Destroys `amount` tokens from the caller.
757      *
758      * See {ERC20-_burn}.
759      */
760     function burn(uint256 amount) public 
761         onlyResolved(msg.sender)
762         whenNotPaused
763     {
764         _burn(msg.sender, amount);
765     }
766 
767     function transferMany(address[] calldata recipients, uint256[] calldata amounts)
768         onlyResolved(msg.sender)
769         whenNotPaused
770         external {
771         require(recipients.length == amounts.length, "CoinMetroToken: Wrong array length");
772 
773         uint256 total = 0;
774         for (uint256 i = 0; i < amounts.length; i++) {
775             total = total.add(amounts[i]);
776         }
777 
778         _balances[msg.sender] = _balances[msg.sender].sub(total, "ERC20: transfer amount exceeds balance");
779 
780         for (uint256 i = 0; i < recipients.length; i++) {
781             address recipient = recipients[i];
782             uint256 amount = amounts[i];
783             require(recipient != address(0), "ERC20: transfer to the zero address");
784             require(decisionPeriods[recipient] < block.timestamp, "Account is being reviewed");
785 
786             _balances[recipient] = _balances[recipient].add(amount);
787             emit Transfer(msg.sender, recipient, amount);
788         }
789     }
790 
791     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
792         // Need to unwrap modifiers to eliminate Stack too deep error
793         require(decisionPeriods[owner] < block.timestamp, "Account is being reviewed");
794         require(decisionPeriods[spender] < block.timestamp, "Account is being reviewed");
795         require(!paused || msg.sender == governanceBoard, "Pausable: paused");
796         require(deadline >= block.timestamp, 'CoinMetroToken: EXPIRED');    
797         bytes32 digest = keccak256(
798             abi.encodePacked(
799                 '\x19\x01',
800                 DOMAIN_SEPARATOR,
801                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
802             )
803         );
804 
805         address recoveredAddress = ecrecover(digest, v, r, s);
806 
807         require(recoveredAddress != address(0) && recoveredAddress == owner, 'CoinMetroToken: INVALID_SIGNATURE');
808         _approve(owner, spender, value);
809     }
810 
811     function setReviewPeriod(uint256 _reviewPeriod) public onlyGovernanceBoard {
812         reviewPeriod = _reviewPeriod;
813         emit ReviewPeriodChanged(reviewPeriod);
814     }
815 
816     function setDecisionPeriod(uint256 _decisionPeriod) public onlyGovernanceBoard {
817         decisionPeriod = _decisionPeriod;
818         emit DecisionPeriodChanged(decisionPeriod);
819     }
820 
821     function recoverTokens(IERC20 token, address to, uint256 amount) public onlyGovernanceBoard {
822         uint256 balance = token.balanceOf(address(this));
823         require(balance >= amount, "ERC20: Insufficient balance");
824         token.safeTransfer(to, amount);
825     }
826 
827     function _review(address account) internal {
828         uint256 reviewUntil = block.timestamp.add(reviewPeriod);
829         uint256 decideUntil = block.timestamp.add(reviewPeriod.add(decisionPeriod));
830         reviewPeriods[account] = reviewUntil;
831         decisionPeriods[account] = decideUntil;
832         emit Reviewing(account, reviewUntil, decideUntil);
833     }
834 
835     function _resolve(address account) internal {
836         reviewPeriods[account] = 0;
837         decisionPeriods[account] = 0;
838         emit Resolved(account);
839     }
840 }