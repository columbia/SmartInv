1 pragma solidity ^0.6.12;
2 
3 
4 
5 
6 
7 library Address {
8     /**
9      * @dev Returns true if `account` is a contract.
10      *
11      * [IMPORTANT]
12      * ====
13      * It is unsafe to assume that an address for which this function returns
14      * false is an externally-owned account (EOA) and not a contract.
15      *
16      * Among others, `isContract` will return false for the following
17      * types of addresses:
18      *
19      *  - an externally-owned account
20      *  - a contract in construction
21      *  - an address where a contract will be created
22      *  - an address where a contract lived, but was destroyed
23      * ====
24      */
25     function isContract(address account) internal view returns (bool) {
26         // This method relies on extcodesize, which returns 0 for contracts in
27         // construction, since the code is only stored at the end of the
28         // constructor execution.
29 
30         uint256 size;
31         // solhint-disable-next-line no-inline-assembly
32         assembly { size := extcodesize(account) }
33         return size > 0;
34     }
35 
36     /**
37      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
38      * `recipient`, forwarding all available gas and reverting on errors.
39      *
40      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
41      * of certain opcodes, possibly making contracts go over the 2300 gas limit
42      * imposed by `transfer`, making them unable to receive funds via
43      * `transfer`. {sendValue} removes this limitation.
44      *
45      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
46      *
47      * IMPORTANT: because control is transferred to `recipient`, care must be
48      * taken to not create reentrancy vulnerabilities. Consider using
49      * {ReentrancyGuard} or the
50      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
51      */
52     function sendValue(address payable recipient, uint256 amount) internal {
53         require(address(this).balance >= amount, "Address: insufficient balance");
54 
55         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
56         (bool success, ) = recipient.call{ value: amount }("");
57         require(success, "Address: unable to send value, recipient may have reverted");
58     }
59 
60     /**
61      * @dev Performs a Solidity function call using a low level `call`. A
62      * plain`call` is an unsafe replacement for a function call: use this
63      * function instead.
64      *
65      * If `target` reverts with a revert reason, it is bubbled up by this
66      * function (like regular Solidity function calls).
67      *
68      * Returns the raw returned data. To convert to the expected return value,
69      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
70      *
71      * Requirements:
72      *
73      * - `target` must be a contract.
74      * - calling `target` with `data` must not revert.
75      *
76      * _Available since v3.1._
77      */
78     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
79       return functionCall(target, data, "Address: low-level call failed");
80     }
81 
82     /**
83      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
84      * `errorMessage` as a fallback revert reason when `target` reverts.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
89         return functionCallWithValue(target, data, 0, errorMessage);
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
94      * but also transferring `value` wei to `target`.
95      *
96      * Requirements:
97      *
98      * - the calling contract must have an ETH balance of at least `value`.
99      * - the called Solidity function must be `payable`.
100      *
101      * _Available since v3.1._
102      */
103     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
109      * with `errorMessage` as a fallback revert reason when `target` reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
114         require(address(this).balance >= value, "Address: insufficient balance for call");
115         require(isContract(target), "Address: call to non-contract");
116 
117         // solhint-disable-next-line avoid-low-level-calls
118         (bool success, bytes memory returndata) = target.call{ value: value }(data);
119         return _verifyCallResult(success, returndata, errorMessage);
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
124      * but performing a static call.
125      *
126      * _Available since v3.3._
127      */
128     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
129         return functionStaticCall(target, data, "Address: low-level static call failed");
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
134      * but performing a static call.
135      *
136      * _Available since v3.3._
137      */
138     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
139         require(isContract(target), "Address: static call to non-contract");
140 
141         // solhint-disable-next-line avoid-low-level-calls
142         (bool success, bytes memory returndata) = target.staticcall(data);
143         return _verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
148      * but performing a delegate call.
149      *
150      * _Available since v3.3._
151      */
152     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
158      * but performing a delegate call.
159      *
160      * _Available since v3.3._
161      */
162     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
163         require(isContract(target), "Address: delegate call to non-contract");
164 
165         // solhint-disable-next-line avoid-low-level-calls
166         (bool success, bytes memory returndata) = target.delegatecall(data);
167         return _verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
171         if (success) {
172             return returndata;
173         } else {
174             // Look for revert reason and bubble it up if present
175             if (returndata.length > 0) {
176                 // The easiest way to bubble the revert reason is using memory via assembly
177 
178                 // solhint-disable-next-line no-inline-assembly
179                 assembly {
180                     let returndata_size := mload(returndata)
181                     revert(add(32, returndata), returndata_size)
182                 }
183             } else {
184                 revert(errorMessage);
185             }
186         }
187     }
188 }
189 
190 library SafeMath {
191     /**
192      * @dev Returns the addition of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `+` operator.
196      *
197      * Requirements:
198      *
199      * - Addition cannot overflow.
200      */
201     function add(uint256 a, uint256 b) internal pure returns (uint256) {
202         uint256 c = a + b;
203         require(c >= a, "SafeMath: addition overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the subtraction of two unsigned integers, reverting on
210      * overflow (when the result is negative).
211      *
212      * Counterpart to Solidity's `-` operator.
213      *
214      * Requirements:
215      *
216      * - Subtraction cannot overflow.
217      */
218     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
219         return sub(a, b, "SafeMath: subtraction overflow");
220     }
221 
222     /**
223      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
224      * overflow (when the result is negative).
225      *
226      * Counterpart to Solidity's `-` operator.
227      *
228      * Requirements:
229      *
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b <= a, errorMessage);
234         uint256 c = a - b;
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the multiplication of two unsigned integers, reverting on
241      * overflow.
242      *
243      * Counterpart to Solidity's `*` operator.
244      *
245      * Requirements:
246      *
247      * - Multiplication cannot overflow.
248      */
249     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
250         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
251         // benefit is lost if 'b' is also tested.
252         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
253         if (a == 0) {
254             return 0;
255         }
256 
257         uint256 c = a * b;
258         require(c / a == b, "SafeMath: multiplication overflow");
259 
260         return c;
261     }
262 
263     /**
264      * @dev Returns the integer division of two unsigned integers. Reverts on
265      * division by zero. The result is rounded towards zero.
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function div(uint256 a, uint256 b) internal pure returns (uint256) {
276         return div(a, b, "SafeMath: division by zero");
277     }
278 
279     /**
280      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
281      * division by zero. The result is rounded towards zero.
282      *
283      * Counterpart to Solidity's `/` operator. Note: this function uses a
284      * `revert` opcode (which leaves remaining gas untouched) while Solidity
285      * uses an invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         require(b > 0, errorMessage);
293         uint256 c = a / b;
294         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
295 
296         return c;
297     }
298 
299     /**
300      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
301      * Reverts when dividing by zero.
302      *
303      * Counterpart to Solidity's `%` operator. This function uses a `revert`
304      * opcode (which leaves remaining gas untouched) while Solidity uses an
305      * invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      *
309      * - The divisor cannot be zero.
310      */
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         return mod(a, b, "SafeMath: modulo by zero");
313     }
314 
315     /**
316      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
317      * Reverts with custom message when dividing by zero.
318      *
319      * Counterpart to Solidity's `%` operator. This function uses a `revert`
320      * opcode (which leaves remaining gas untouched) while Solidity uses an
321      * invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b != 0, errorMessage);
329         return a % b;
330     }
331 }
332 
333 abstract contract Context {
334     function _msgSender() internal view virtual returns (address payable) {
335         return msg.sender;
336     }
337 
338     function _msgData() internal view virtual returns (bytes memory) {
339         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
340         return msg.data;
341     }
342 }
343 
344 abstract contract Ownable is Context {
345     address private _owner;
346 
347     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
348 
349     /**
350      * @dev Initializes the contract setting the deployer as the initial owner.
351      */
352     constructor () internal {
353         address msgSender = _msgSender();
354         _owner = msgSender;
355         emit OwnershipTransferred(address(0), msgSender);
356     }
357 
358     /**
359      * @dev Returns the address of the current owner.
360      */
361     function owner() public view returns (address) {
362         return _owner;
363     }
364 
365     /**
366      * @dev Throws if called by any account other than the owner.
367      */
368     modifier onlyOwner() {
369         require(_owner == _msgSender(), "Ownable: caller is not the owner");
370         _;
371     }
372 
373     /**
374      * @dev Leaves the contract without owner. It will not be possible to call
375      * `onlyOwner` functions anymore. Can only be called by the current owner.
376      *
377      * NOTE: Renouncing ownership will leave the contract without an owner,
378      * thereby removing any functionality that is only available to the owner.
379      */
380     function renounceOwnership() public virtual onlyOwner {
381         emit OwnershipTransferred(_owner, address(0));
382         _owner = address(0);
383     }
384 
385     /**
386      * @dev Transfers ownership of the contract to a new account (`newOwner`).
387      * Can only be called by the current owner.
388      */
389     function transferOwnership(address newOwner) public virtual onlyOwner {
390         require(newOwner != address(0), "Ownable: new owner is the zero address");
391         emit OwnershipTransferred(_owner, newOwner);
392         _owner = newOwner;
393     }
394 }
395 
396 contract Operator is Context, Ownable {
397     address private _operator;
398 
399     event OperatorTransferred(
400         address indexed previousOperator,
401         address indexed newOperator
402     );
403 
404     constructor() internal {
405         _operator = _msgSender();
406         emit OperatorTransferred(address(0), _operator);
407     }
408 
409     function operator() public view returns (address) {
410         return _operator;
411     }
412 
413     modifier onlyOperator() {
414         require(
415             _operator == msg.sender,
416             'operator: caller is not the operator'
417         );
418         _;
419     }
420 
421     function isOperator() public view returns (bool) {
422         return _msgSender() == _operator;
423     }
424 
425     function transferOperator(address newOperator_) public onlyOwner {
426         _transferOperator(newOperator_);
427     }
428 
429     function _transferOperator(address newOperator_) internal {
430         require(
431             newOperator_ != address(0),
432             'operator: zero address given for new operator'
433         );
434         emit OperatorTransferred(address(0), newOperator_);
435         _operator = newOperator_;
436     }
437 }
438 
439 interface IERC20 {
440     /**
441      * @dev Returns the amount of tokens in existence.
442      */
443     function totalSupply() external view returns (uint256);
444 
445     /**
446      * @dev Returns the amount of tokens owned by `account`.
447      */
448     function balanceOf(address account) external view returns (uint256);
449 
450     /**
451      * @dev Moves `amount` tokens from the caller's account to `recipient`.
452      *
453      * Returns a boolean value indicating whether the operation succeeded.
454      *
455      * Emits a {Transfer} event.
456      */
457     function transfer(address recipient, uint256 amount) external returns (bool);
458 
459     /**
460      * @dev Returns the remaining number of tokens that `spender` will be
461      * allowed to spend on behalf of `owner` through {transferFrom}. This is
462      * zero by default.
463      *
464      * This value changes when {approve} or {transferFrom} are called.
465      */
466     function allowance(address owner, address spender) external view returns (uint256);
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
470      *
471      * Returns a boolean value indicating whether the operation succeeded.
472      *
473      * IMPORTANT: Beware that changing an allowance with this method brings the risk
474      * that someone may use both the old and the new allowance by unfortunate
475      * transaction ordering. One possible solution to mitigate this race
476      * condition is to first reduce the spender's allowance to 0 and set the
477      * desired value afterwards:
478      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
479      *
480      * Emits an {Approval} event.
481      */
482     function approve(address spender, uint256 amount) external returns (bool);
483 
484     /**
485      * @dev Moves `amount` tokens from `sender` to `recipient` using the
486      * allowance mechanism. `amount` is then deducted from the caller's
487      * allowance.
488      *
489      * Returns a boolean value indicating whether the operation succeeded.
490      *
491      * Emits a {Transfer} event.
492      */
493     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
494 
495     /**
496      * @dev Emitted when `value` tokens are moved from one account (`from`) to
497      * another (`to`).
498      *
499      * Note that `value` may be zero.
500      */
501     event Transfer(address indexed from, address indexed to, uint256 value);
502 
503     /**
504      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
505      * a call to {approve}. `value` is the new allowance.
506      */
507     event Approval(address indexed owner, address indexed spender, uint256 value);
508 }
509 
510 library Safe112 {
511     function add(uint112 a, uint112 b) internal pure returns (uint256) {
512         uint256 c = a + b;
513         require(c >= a, 'Safe112: addition overflow');
514 
515         return c;
516     }
517 
518     function sub(uint112 a, uint112 b) internal pure returns (uint256) {
519         return sub(a, b, 'Safe112: subtraction overflow');
520     }
521 
522     function sub(
523         uint112 a,
524         uint112 b,
525         string memory errorMessage
526     ) internal pure returns (uint112) {
527         require(b <= a, errorMessage);
528         uint112 c = a - b;
529 
530         return c;
531     }
532 
533     function mul(uint112 a, uint112 b) internal pure returns (uint256) {
534         if (a == 0) {
535             return 0;
536         }
537 
538         uint256 c = a * b;
539         require(c / a == b, 'Safe112: multiplication overflow');
540 
541         return c;
542     }
543 
544     function div(uint112 a, uint112 b) internal pure returns (uint256) {
545         return div(a, b, 'Safe112: division by zero');
546     }
547 
548     function div(
549         uint112 a,
550         uint112 b,
551         string memory errorMessage
552     ) internal pure returns (uint112) {
553         // Solidity only automatically asserts when dividing by 0
554         require(b > 0, errorMessage);
555         uint112 c = a / b;
556 
557         return c;
558     }
559 
560     function mod(uint112 a, uint112 b) internal pure returns (uint256) {
561         return mod(a, b, 'Safe112: modulo by zero');
562     }
563 
564     function mod(
565         uint112 a,
566         uint112 b,
567         string memory errorMessage
568     ) internal pure returns (uint112) {
569         require(b != 0, errorMessage);
570         return a % b;
571     }
572 }
573 
574 library SafeERC20 {
575     using SafeMath for uint256;
576     using Address for address;
577 
578     function safeTransfer(IERC20 token, address to, uint256 value) internal {
579         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
580     }
581 
582     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
583         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
584     }
585 
586     /**
587      * @dev Deprecated. This function has issues similar to the ones found in
588      * {IERC20-approve}, and its usage is discouraged.
589      *
590      * Whenever possible, use {safeIncreaseAllowance} and
591      * {safeDecreaseAllowance} instead.
592      */
593     function safeApprove(IERC20 token, address spender, uint256 value) internal {
594         // safeApprove should only be called when setting an initial allowance,
595         // or when resetting it to zero. To increase and decrease it, use
596         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
597         // solhint-disable-next-line max-line-length
598         require((value == 0) || (token.allowance(address(this), spender) == 0),
599             "SafeERC20: approve from non-zero to non-zero allowance"
600         );
601         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
602     }
603 
604     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
605         uint256 newAllowance = token.allowance(address(this), spender).add(value);
606         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
607     }
608 
609     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
610         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
611         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
612     }
613 
614     /**
615      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
616      * on the return value: the return value is optional (but if data is returned, it must not be false).
617      * @param token The token targeted by the call.
618      * @param data The call data (encoded using abi.encode or one of its variants).
619      */
620     function _callOptionalReturn(IERC20 token, bytes memory data) private {
621         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
622         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
623         // the target address contains contract code and also asserts for success in the low-level call.
624 
625         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
626         if (returndata.length > 0) { // Return data is optional
627             // solhint-disable-next-line max-line-length
628             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
629         }
630     }
631 }
632 
633 contract ContractGuard {
634     mapping(uint256 => mapping(address => bool)) private _status;
635 
636     function checkSameOriginReentranted() internal view returns (bool) {
637         return _status[block.number][tx.origin];
638     }
639 
640     function checkSameSenderReentranted() internal view returns (bool) {
641         return _status[block.number][msg.sender];
642     }
643 
644     modifier onlyOneBlock() {
645         require(
646             !checkSameOriginReentranted(),
647             'ContractGuard: one block, one function'
648         );
649         require(
650             !checkSameSenderReentranted(),
651             'ContractGuard: one block, one function'
652         );
653 
654         _;
655 
656         _status[block.number][tx.origin] = true;
657         _status[block.number][msg.sender] = true;
658     }
659 }
660 
661 contract ShareWrapper {
662     using SafeMath for uint256;
663     using SafeERC20 for IERC20;
664 
665     IERC20 public share;
666 
667     uint256 private _totalSupply;
668     mapping(address => uint256) private _balances;
669 
670     function totalSupply() public view returns (uint256) {
671         return _totalSupply;
672     }
673 
674     function balanceOf(address account) public view returns (uint256) {
675         return _balances[account];
676     }
677 
678     function stake(uint256 amount) public virtual {
679         _totalSupply = _totalSupply.add(amount);
680         _balances[msg.sender] = _balances[msg.sender].add(amount);
681         share.safeTransferFrom(msg.sender, address(this), amount);
682     }
683 
684     function withdraw(uint256 amount) public virtual {
685         uint256 directorShare = _balances[msg.sender];
686         require(
687             directorShare >= amount,
688             'Boardroom: withdraw request greater than staked amount'
689         );
690         _totalSupply = _totalSupply.sub(amount);
691         _balances[msg.sender] = directorShare.sub(amount);
692         share.safeTransfer(msg.sender, amount);
693     }
694 }
695 
696 
697 contract Boardroom is ShareWrapper, ContractGuard, Operator {
698     using SafeERC20 for IERC20;
699     using Address for address;
700     using SafeMath for uint256;
701     using Safe112 for uint112;
702 
703     /* ========== DATA STRUCTURES ========== */
704 
705     struct Boardseat {
706         uint256 lastSnapshotIndex;
707         uint256 rewardEarned;
708     }
709 
710     struct BoardSnapshot {
711         uint256 time;
712         uint256 rewardReceived;
713         uint256 rewardPerShare;
714     }
715 
716     /* ========== STATE VARIABLES ========== */
717 
718     IERC20 private cash;
719 
720     mapping(address => Boardseat) private directors;
721     BoardSnapshot[] private boardHistory;
722 
723     /* ========== CONSTRUCTOR ========== */
724 
725     constructor(IERC20 _cash, IERC20 _share) public {
726         cash = _cash;
727         share = _share;
728 
729         BoardSnapshot memory genesisSnapshot = BoardSnapshot({
730             time: block.number,
731             rewardReceived: 0,
732             rewardPerShare: 0
733         });
734         boardHistory.push(genesisSnapshot);
735     }
736 
737     /* ========== Modifiers =============== */
738     modifier directorExists {
739         require(
740             balanceOf(msg.sender) > 0,
741             'Boardroom: The director does not exist'
742         );
743         _;
744     }
745 
746     modifier updateReward(address director) {
747         if (director != address(0)) {
748             Boardseat memory seat = directors[director];
749             seat.rewardEarned = earned(director);
750             seat.lastSnapshotIndex = latestSnapshotIndex();
751             directors[director] = seat;
752         }
753         _;
754     }
755 
756     /* ========== VIEW FUNCTIONS ========== */
757 
758     // =========== Snapshot getters
759 
760     function latestSnapshotIndex() public view returns (uint256) {
761         return boardHistory.length.sub(1);
762     }
763 
764     function getLatestSnapshot() internal view returns (BoardSnapshot memory) {
765         return boardHistory[latestSnapshotIndex()];
766     }
767 
768     function getLastSnapshotIndexOf(address director)
769         public
770         view
771         returns (uint256)
772     {
773         return directors[director].lastSnapshotIndex;
774     }
775 
776     function getLastSnapshotOf(address director)
777         internal
778         view
779         returns (BoardSnapshot memory)
780     {
781         return boardHistory[getLastSnapshotIndexOf(director)];
782     }
783 
784     // =========== Director getters
785 
786     function rewardPerShare() public view returns (uint256) {
787         return getLatestSnapshot().rewardPerShare;
788     }
789 
790     function earned(address director) public view returns (uint256) {
791         uint256 latestRPS = getLatestSnapshot().rewardPerShare;
792         uint256 storedRPS = getLastSnapshotOf(director).rewardPerShare;
793 
794         return
795             balanceOf(director).mul(latestRPS.sub(storedRPS)).div(1e18).add(
796                 directors[director].rewardEarned
797             );
798     }
799 
800     /* ========== MUTATIVE FUNCTIONS ========== */
801 
802     function stake(uint256 amount)
803         public
804         override
805         onlyOneBlock
806         updateReward(msg.sender)
807     {
808         require(amount > 0, 'Boardroom: Cannot stake 0');
809         super.stake(amount);
810         emit Staked(msg.sender, amount);
811     }
812 
813     function withdraw(uint256 amount)
814         public
815         override
816         onlyOneBlock
817         directorExists
818         updateReward(msg.sender)
819     {
820         require(amount > 0, 'Boardroom: Cannot withdraw 0');
821         super.withdraw(amount);
822         emit Withdrawn(msg.sender, amount);
823     }
824 
825     function exit() external {
826         withdraw(balanceOf(msg.sender));
827         claimReward();
828     }
829 
830     function claimReward() public updateReward(msg.sender) {
831         uint256 reward = directors[msg.sender].rewardEarned;
832         if (reward > 0) {
833             directors[msg.sender].rewardEarned = 0;
834             cash.safeTransfer(msg.sender, reward);
835             emit RewardPaid(msg.sender, reward);
836         }
837     }
838 
839     function allocateSeigniorage(uint256 amount)
840         external
841         onlyOneBlock
842         onlyOperator
843     {
844         require(amount > 0, 'Boardroom: Cannot allocate 0');
845         require(
846             totalSupply() > 0,
847             'Boardroom: Cannot allocate when totalSupply is 0'
848         );
849 
850         // Create & add new snapshot
851         uint256 prevRPS = getLatestSnapshot().rewardPerShare;
852         uint256 nextRPS = prevRPS.add(amount.mul(1e18).div(totalSupply()));
853 
854         BoardSnapshot memory newSnapshot = BoardSnapshot({
855             time: block.number,
856             rewardReceived: amount,
857             rewardPerShare: nextRPS
858         });
859         boardHistory.push(newSnapshot);
860 
861         cash.safeTransferFrom(msg.sender, address(this), amount);
862         emit RewardAdded(msg.sender, amount);
863     }
864 
865     /* ========== EVENTS ========== */
866 
867     event Staked(address indexed user, uint256 amount);
868     event Withdrawn(address indexed user, uint256 amount);
869     event RewardPaid(address indexed user, uint256 reward);
870     event RewardAdded(address indexed user, uint256 reward);
871 }