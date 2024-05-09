1 // File: smartcontract/chefInOne.sol
2 
3 /*
4 
5 website: noodle.finance
6 
7  ███▄    █  ▒█████   ▒█████  ▓█████▄  ██▓    ▓█████        █████▒██▓ ███▄    █  ▄▄▄       ███▄    █  ▄████▄  ▓█████ 
8  ██ ▀█   █ ▒██▒  ██▒▒██▒  ██▒▒██▀ ██▌▓██▒    ▓█   ▀      ▓██   ▒▓██▒ ██ ▀█   █ ▒████▄     ██ ▀█   █ ▒██▀ ▀█  ▓█   ▀ 
9 ▓██  ▀█ ██▒▒██░  ██▒▒██░  ██▒░██   █▌▒██░    ▒███        ▒████ ░▒██▒▓██  ▀█ ██▒▒██  ▀█▄  ▓██  ▀█ ██▒▒▓█    ▄ ▒███   
10 ▓██▒  ▐▌██▒▒██   ██░▒██   ██░░▓█▄   ▌▒██░    ▒▓█  ▄      ░▓█▒  ░░██░▓██▒  ▐▌██▒░██▄▄▄▄██ ▓██▒  ▐▌██▒▒▓▓▄ ▄██▒▒▓█  ▄ 
11 ▒██░   ▓██░░ ████▓▒░░ ████▓▒░░▒████▓ ░██████▒░▒████▒ ██▓ ░▒█░   ░██░▒██░   ▓██░ ▓█   ▓██▒▒██░   ▓██░▒ ▓███▀ ░░▒████▒
12 ░ ▒░   ▒ ▒ ░ ▒░▒░▒░ ░ ▒░▒░▒░  ▒▒▓  ▒ ░ ▒░▓  ░░░ ▒░ ░ ▒▓▒  ▒ ░   ░▓  ░ ▒░   ▒ ▒  ▒▒   ▓▒█░░ ▒░   ▒ ▒ ░ ░▒ ▒  ░░░ ▒░ ░
13 ░ ░░   ░ ▒░  ░ ▒ ▒░   ░ ▒ ▒░  ░ ▒  ▒ ░ ░ ▒  ░ ░ ░  ░ ░▒   ░      ▒ ░░ ░░   ░ ▒░  ▒   ▒▒ ░░ ░░   ░ ▒░  ░  ▒    ░ ░  ░
14    ░   ░ ░ ░ ░ ░ ▒  ░ ░ ░ ▒   ░ ░  ░   ░ ░      ░    ░    ░ ░    ▒ ░   ░   ░ ░   ░   ▒      ░   ░ ░ ░           ░   
15          ░     ░ ░      ░ ░     ░        ░  ░   ░  ░  ░          ░           ░       ░  ░         ░ ░ ░         ░  ░
16                               ░                       ░                                             ░               
17 forked from SUSHI and YUNO and Kimchi
18 
19 */
20 
21 pragma solidity ^0.6.6;
22 
23 abstract contract Context {
24     function _msgSender() internal virtual view returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal virtual view returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount)
53         external
54         returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender)
64         external
65         view
66         returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address sender,
95         address recipient,
96         uint256 amount
97     ) external returns (bool);
98 
99     function mint(address _to, uint256 _amount) external;
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(
114         address indexed owner,
115         address indexed spender,
116         uint256 value
117     );
118 }
119 
120 interface IMigratorChef {
121     function migrate(IERC20 token) external returns (IERC20);
122 }
123 
124 library SafeMath {
125     /**
126      * @dev Returns the addition of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `+` operator.
130      *
131      * Requirements:
132      *
133      * - Addition cannot overflow.
134      */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         return sub(a, b, "SafeMath: subtraction overflow");
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(
167         uint256 a,
168         uint256 b,
169         string memory errorMessage
170     ) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      *
185      * - Multiplication cannot overflow.
186      */
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
189         // benefit is lost if 'b' is also tested.
190         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
191         if (a == 0) {
192             return 0;
193         }
194 
195         uint256 c = a * b;
196         require(c / a == b, "SafeMath: multiplication overflow");
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return div(a, b, "SafeMath: division by zero");
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(
230         uint256 a,
231         uint256 b,
232         string memory errorMessage
233     ) internal pure returns (uint256) {
234         require(b > 0, errorMessage);
235         uint256 c = a / b;
236         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         return mod(a, b, "SafeMath: modulo by zero");
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * Reverts with custom message when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(
270         uint256 a,
271         uint256 b,
272         string memory errorMessage
273     ) internal pure returns (uint256) {
274         require(b != 0, errorMessage);
275         return a % b;
276     }
277 }
278 
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // This method relies in extcodesize, which returns 0 for contracts in
299         // construction, since the code is only stored at the end of the
300         // constructor execution.
301 
302         uint256 size;
303         // solhint-disable-next-line no-inline-assembly
304         assembly {
305             size := extcodesize(account)
306         }
307         return size > 0;
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(
328             address(this).balance >= amount,
329             "Address: insufficient balance"
330         );
331 
332         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
333         (bool success, ) = recipient.call{value: amount}("");
334         require(
335             success,
336             "Address: unable to send value, recipient may have reverted"
337         );
338     }
339 
340     /**
341      * @dev Performs a Solidity function call using a low level `call`. A
342      * plain`call` is an unsafe replacement for a function call: use this
343      * function instead.
344      *
345      * If `target` reverts with a revert reason, it is bubbled up by this
346      * function (like regular Solidity function calls).
347      *
348      * Returns the raw returned data. To convert to the expected return value,
349      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
350      *
351      * Requirements:
352      *
353      * - `target` must be a contract.
354      * - calling `target` with `data` must not revert.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data)
359         internal
360         returns (bytes memory)
361     {
362         return functionCall(target, data, "Address: low-level call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
367      * `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(
372         address target,
373         bytes memory data,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         return _functionCallWithValue(target, data, 0, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but also transferring `value` wei to `target`.
382      *
383      * Requirements:
384      *
385      * - the calling contract must have an ETH balance of at least `value`.
386      * - the called Solidity function must be `payable`.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(
391         address target,
392         bytes memory data,
393         uint256 value
394     ) internal returns (bytes memory) {
395         return
396             functionCallWithValue(
397                 target,
398                 data,
399                 value,
400                 "Address: low-level call with value failed"
401             );
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
406      * with `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(
417             address(this).balance >= value,
418             "Address: insufficient balance for call"
419         );
420         return _functionCallWithValue(target, data, value, errorMessage);
421     }
422 
423     function _functionCallWithValue(
424         address target,
425         bytes memory data,
426         uint256 weiValue,
427         string memory errorMessage
428     ) private returns (bytes memory) {
429         require(isContract(target), "Address: call to non-contract");
430 
431         // solhint-disable-next-line avoid-low-level-calls
432         (bool success, bytes memory returndata) = target.call{value: weiValue}(
433             data
434         );
435         if (success) {
436             return returndata;
437         } else {
438             // Look for revert reason and bubble it up if present
439             if (returndata.length > 0) {
440                 // The easiest way to bubble the revert reason is using memory via assembly
441 
442                 // solhint-disable-next-line no-inline-assembly
443                 assembly {
444                     let returndata_size := mload(returndata)
445                     revert(add(32, returndata), returndata_size)
446                 }
447             } else {
448                 revert(errorMessage);
449             }
450         }
451     }
452 }
453 
454 library SafeERC20 {
455     using SafeMath for uint256;
456     using Address for address;
457 
458     function safeTransfer(
459         IERC20 token,
460         address to,
461         uint256 value
462     ) internal {
463         _callOptionalReturn(
464             token,
465             abi.encodeWithSelector(token.transfer.selector, to, value)
466         );
467     }
468 
469     function safeTransferFrom(
470         IERC20 token,
471         address from,
472         address to,
473         uint256 value
474     ) internal {
475         _callOptionalReturn(
476             token,
477             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
478         );
479     }
480 
481     /**
482      * @dev Deprecated. This function has issues similar to the ones found in
483      * {IERC20-approve}, and its usage is discouraged.
484      *
485      * Whenever possible, use {safeIncreaseAllowance} and
486      * {safeDecreaseAllowance} instead.
487      */
488     function safeApprove(
489         IERC20 token,
490         address spender,
491         uint256 value
492     ) internal {
493         // safeApprove should only be called when setting an initial allowance,
494         // or when resetting it to zero. To increase and decrease it, use
495         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
496         // solhint-disable-next-line max-line-length
497         require(
498             (value == 0) || (token.allowance(address(this), spender) == 0),
499             "SafeERC20: approve from non-zero to non-zero allowance"
500         );
501         _callOptionalReturn(
502             token,
503             abi.encodeWithSelector(token.approve.selector, spender, value)
504         );
505     }
506 
507     function safeIncreaseAllowance(
508         IERC20 token,
509         address spender,
510         uint256 value
511     ) internal {
512         uint256 newAllowance = token.allowance(address(this), spender).add(
513             value
514         );
515         _callOptionalReturn(
516             token,
517             abi.encodeWithSelector(
518                 token.approve.selector,
519                 spender,
520                 newAllowance
521             )
522         );
523     }
524 
525     function safeDecreaseAllowance(
526         IERC20 token,
527         address spender,
528         uint256 value
529     ) internal {
530         uint256 newAllowance = token.allowance(address(this), spender).sub(
531             value,
532             "SafeERC20: decreased allowance below zero"
533         );
534         _callOptionalReturn(
535             token,
536             abi.encodeWithSelector(
537                 token.approve.selector,
538                 spender,
539                 newAllowance
540             )
541         );
542     }
543 
544     /**
545      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
546      * on the return value: the return value is optional (but if data is returned, it must not be false).
547      * @param token The token targeted by the call.
548      * @param data The call data (encoded using abi.encode or one of its variants).
549      */
550     function _callOptionalReturn(IERC20 token, bytes memory data) private {
551         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
552         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
553         // the target address contains contract code and also asserts for success in the low-level call.
554 
555         bytes memory returndata = address(token).functionCall(
556             data,
557             "SafeERC20: low-level call failed"
558         );
559         if (returndata.length > 0) {
560             // Return data is optional
561             // solhint-disable-next-line max-line-length
562             require(
563                 abi.decode(returndata, (bool)),
564                 "SafeERC20: ERC20 operation did not succeed"
565             );
566         }
567     }
568 }
569 
570 contract Ownable is Context {
571     address private _owner;
572 
573     event OwnershipTransferred(
574         address indexed previousOwner,
575         address indexed newOwner
576     );
577 
578     /**
579      * @dev Initializes the contract setting the deployer as the initial owner.
580      */
581     constructor() internal {
582         address msgSender = _msgSender();
583         _owner = msgSender;
584         emit OwnershipTransferred(address(0), msgSender);
585     }
586 
587     /**
588      * @dev Returns the address of the current owner.
589      */
590     function owner() public view returns (address) {
591         return _owner;
592     }
593 
594     /**
595      * @dev Throws if called by any account other than the owner.
596      */
597     modifier onlyOwner() {
598         require(_owner == _msgSender(), "Ownable: caller is not the owner");
599         _;
600     }
601 
602     /**
603      * @dev Leaves the contract without owner. It will not be possible to call
604      * `onlyOwner` functions anymore. Can only be called by the current owner.
605      *
606      * NOTE: Renouncing ownership will leave the contract without an owner,
607      * thereby removing any functionality that is only available to the owner.
608      */
609     function renounceOwnership() public virtual onlyOwner {
610         emit OwnershipTransferred(_owner, address(0));
611         _owner = address(0);
612     }
613 
614     /**
615      * @dev Transfers ownership of the contract to a new account (`newOwner`).
616      * Can only be called by the current owner.
617      */
618     function transferOwnership(address newOwner) public virtual onlyOwner {
619         require(
620             newOwner != address(0),
621             "Ownable: new owner is the zero address"
622         );
623         emit OwnershipTransferred(_owner, newOwner);
624         _owner = newOwner;
625     }
626 }
627 
628 contract NoodleChef is Ownable {
629     using SafeMath for uint256;
630     using SafeERC20 for IERC20;
631 
632     // Info of each user.
633     struct UserInfo {
634         uint256 amount; // How many LP tokens the user has provided.
635         uint256 rewardDebt; // Reward debt. See explanation below.
636         //
637         // We do some fancy math here. Basically, any point in time, the amount of NOODLEs
638         // entitled to a user but is pending to be distributed is:
639         //
640         //   pending reward = (user.amount * pool.accNoodlePerShare) - user.rewardDebt
641     }
642 
643     // Info of each pool.
644     struct PoolInfo {
645         IERC20 lpToken; // Address of LP token contract.
646         uint256 allocPoint; // How many allocation points assigned to this pool. NOODLEs to distribute per block.
647         uint256 lastRewardBlock; // Last block number that NOODLEs distribution occurs.
648         uint256 accNoodlePerShare; // Accumulated NOODLEs per share, times 1e12. See below.
649     }
650 
651     // The NOODLE TOKEN!
652     IERC20 public noodle;
653     // Dev address.
654     address public devaddr;
655     // Block number when bonus NOODLE period ends.
656     uint256 public bonusEndBlock;
657     // NOODLE tokens created per block.
658     uint256 public noodlePerBlock;
659     // Bonus muliplier for early noodle makers.
660     // no bonus
661     IMigratorChef public migrator;
662 
663     // Info of each pool.
664     PoolInfo[] public poolInfo;
665     mapping(address => bool) public lpTokenExistsInPool;
666     // Info of each user that stakes LP tokens.
667     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
668     // Total allocation poitns. Must be the sum of all allocation points in all pools.
669     uint256 public totalAllocPoint = 0;
670     // The block number when NOODLE mining starts.
671     uint256 public startBlock;
672 
673     uint256 public blockInADay = 5760; // Assume 15s per block
674     uint256 public blockInAMonth = 172800;
675     uint256 public halvePeriod = blockInAMonth;
676     uint256 public minimumNoodlePerBlock = 125 ether; // Start at 1000, halve 3 times, 500 > 250 > 125.
677     uint256 public lastHalveBlock;
678 
679     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
680     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
681     event EmergencyWithdraw(
682         address indexed user,
683         uint256 indexed pid,
684         uint256 amount
685     );
686     event Halve(uint256 newNoodlePerBlock, uint256 nextHalveBlockNumber);
687 
688     constructor(
689         IERC20 _noodle,
690         address _devaddr,
691         uint256 _startBlock
692     ) public {
693         noodle = _noodle;
694         devaddr = _devaddr;
695         noodlePerBlock = 1000 ether;
696         startBlock = _startBlock;
697         lastHalveBlock = _startBlock;
698     }
699 
700     function doHalvingCheck(bool _withUpdate) public {
701         if (noodlePerBlock <= minimumNoodlePerBlock) {
702             return;
703         }
704         bool doHalve = block.number > lastHalveBlock + halvePeriod;
705         if (!doHalve) {
706             return;
707         }
708         uint256 newNoodlePerBlock = noodlePerBlock.div(2);
709         if (newNoodlePerBlock >= minimumNoodlePerBlock) {
710             noodlePerBlock = newNoodlePerBlock;
711             lastHalveBlock = block.number;
712             emit Halve(newNoodlePerBlock, block.number + halvePeriod);
713 
714             if (_withUpdate) {
715                 massUpdatePools();
716             }
717         }
718     }
719 
720     function poolLength() external view returns (uint256) {
721         return poolInfo.length;
722     }
723 
724     // Add a new lp to the pool. Can only be called by the owner.
725     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
726     function add(
727         uint256 _allocPoint,
728         IERC20 _lpToken,
729         bool _withUpdate
730     ) public onlyOwner {
731         require(
732             !lpTokenExistsInPool[address(_lpToken)],
733             "NoodleChef: LP Token Address already exists in pool"
734         );
735         if (_withUpdate) {
736             massUpdatePools();
737         }
738         uint256 lastRewardBlock = block.number > startBlock
739             ? block.number
740             : startBlock;
741         totalAllocPoint = totalAllocPoint.add(_allocPoint);
742         poolInfo.push(
743             PoolInfo({
744                 lpToken: _lpToken,
745                 allocPoint: _allocPoint,
746                 lastRewardBlock: lastRewardBlock,
747                 accNoodlePerShare: 0
748             })
749         );
750         lpTokenExistsInPool[address(_lpToken)] = true;
751     }
752 
753     function updateLpTokenExists(address _lpTokenAddr, bool _isExists)
754         external
755         onlyOwner
756     {
757         lpTokenExistsInPool[_lpTokenAddr] = _isExists;
758     }
759 
760     // Update the given pool's NOODLE allocation point. Can only be called by the owner.
761     function set(
762         uint256 _pid,
763         uint256 _allocPoint,
764         bool _withUpdate
765     ) public onlyOwner {
766         if (_withUpdate) {
767             massUpdatePools();
768         }
769         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
770             _allocPoint
771         );
772         poolInfo[_pid].allocPoint = _allocPoint;
773     }
774 
775     function setMigrator(IMigratorChef _migrator) public onlyOwner {
776         migrator = _migrator;
777     }
778 
779     function migrate(uint256 _pid) public onlyOwner {
780         require(
781             address(migrator) != address(0),
782             "NoodleChef: Address of migrator is null"
783         );
784         PoolInfo storage pool = poolInfo[_pid];
785         IERC20 lpToken = pool.lpToken;
786         uint256 bal = lpToken.balanceOf(address(this));
787         lpToken.safeApprove(address(migrator), bal);
788         IERC20 newLpToken = migrator.migrate(lpToken);
789         require(
790             !lpTokenExistsInPool[address(newLpToken)],
791             "NoodleChef: New LP Token Address already exists in pool"
792         );
793         require(
794             bal == newLpToken.balanceOf(address(this)),
795             "NoodleChef: New LP Token balance incorrect"
796         );
797         pool.lpToken = newLpToken;
798         lpTokenExistsInPool[address(newLpToken)] = true;
799     }
800 
801     // View function to see pending NOODLEs on frontend.
802     function pendingNoodle(uint256 _pid, address _user)
803         external
804         view
805         returns (uint256)
806     {
807         PoolInfo storage pool = poolInfo[_pid];
808         UserInfo storage user = userInfo[_pid][_user];
809         uint256 accNoodlePerShare = pool.accNoodlePerShare;
810         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
811         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
812             uint256 blockPassed = block.number.sub(pool.lastRewardBlock);
813             uint256 noodleReward = blockPassed
814                 .mul(noodlePerBlock)
815                 .mul(pool.allocPoint)
816                 .div(totalAllocPoint);
817             accNoodlePerShare = accNoodlePerShare.add(
818                 noodleReward.mul(1e12).div(lpSupply)
819             );
820         }
821         return
822             user.amount.mul(accNoodlePerShare).div(1e12).sub(user.rewardDebt);
823     }
824 
825     // Update reward vairables for all pools. Be careful of gas spending!
826     function massUpdatePools() public {
827         uint256 length = poolInfo.length;
828         for (uint256 pid = 0; pid < length; ++pid) {
829             updatePool(pid);
830         }
831     }
832 
833     // Update reward variables of the given pool to be up-to-date.
834     function updatePool(uint256 _pid) public {
835         doHalvingCheck(false);
836         PoolInfo storage pool = poolInfo[_pid];
837         if (block.number <= pool.lastRewardBlock) {
838             return;
839         }
840         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
841         if (lpSupply == 0) {
842             pool.lastRewardBlock = block.number;
843             return;
844         }
845         uint256 blockPassed = block.number.sub(pool.lastRewardBlock);
846         uint256 noodleReward = blockPassed
847             .mul(noodlePerBlock)
848             .mul(pool.allocPoint)
849             .div(totalAllocPoint);
850         noodle.mint(devaddr, noodleReward.div(16)); // 6.25%
851         noodle.mint(address(this), noodleReward);
852         pool.accNoodlePerShare = pool.accNoodlePerShare.add(
853             noodleReward.mul(1e12).div(lpSupply)
854         );
855         pool.lastRewardBlock = block.number;
856     }
857 
858     // Deposit LP tokens to MasterChef for NOODLE allocation.
859     function deposit(uint256 _pid, uint256 _amount) public {
860         PoolInfo storage pool = poolInfo[_pid];
861         UserInfo storage user = userInfo[_pid][msg.sender];
862         updatePool(_pid);
863         if (user.amount > 0) {
864             uint256 pending = user
865                 .amount
866                 .mul(pool.accNoodlePerShare)
867                 .div(1e12)
868                 .sub(user.rewardDebt);
869             safeNoodleTransfer(msg.sender, pending);
870         }
871         pool.lpToken.safeTransferFrom(
872             address(msg.sender),
873             address(this),
874             _amount
875         );
876         user.amount = user.amount.add(_amount);
877         user.rewardDebt = user.amount.mul(pool.accNoodlePerShare).div(1e12);
878         emit Deposit(msg.sender, _pid, _amount);
879     }
880 
881     // Withdraw LP tokens from MasterChef.
882     function withdraw(uint256 _pid, uint256 _amount) public {
883         PoolInfo storage pool = poolInfo[_pid];
884         UserInfo storage user = userInfo[_pid][msg.sender];
885         require(
886             user.amount >= _amount,
887             "NoodleChef: Insufficient Amount to withdraw"
888         );
889         updatePool(_pid);
890         uint256 pending = user.amount.mul(pool.accNoodlePerShare).div(1e12).sub(
891             user.rewardDebt
892         );
893         safeNoodleTransfer(msg.sender, pending);
894         user.amount = user.amount.sub(_amount);
895         user.rewardDebt = user.amount.mul(pool.accNoodlePerShare).div(1e12);
896         pool.lpToken.safeTransfer(address(msg.sender), _amount);
897         emit Withdraw(msg.sender, _pid, _amount);
898     }
899 
900     // Withdraw without caring about rewards. EMERGENCY ONLY.
901     function emergencyWithdraw(uint256 _pid) public {
902         PoolInfo storage pool = poolInfo[_pid];
903         UserInfo storage user = userInfo[_pid][msg.sender];
904         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
905         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
906         user.amount = 0;
907         user.rewardDebt = 0;
908     }
909 
910     // Safe noodle transfer function, just in case if rounding error causes pool to not have enough NOODLEs.
911     function safeNoodleTransfer(address _to, uint256 _amount) internal {
912         uint256 noodleBal = noodle.balanceOf(address(this));
913         if (_amount > noodleBal) {
914             noodle.transfer(_to, noodleBal);
915         } else {
916             noodle.transfer(_to, _amount);
917         }
918     }
919 
920     // Update dev address by the previous dev.
921     function dev(address _devaddr) public {
922         require(
923             msg.sender == devaddr,
924             "NoodleChef: Sender is not the developer"
925         );
926         devaddr = _devaddr;
927     }
928 }