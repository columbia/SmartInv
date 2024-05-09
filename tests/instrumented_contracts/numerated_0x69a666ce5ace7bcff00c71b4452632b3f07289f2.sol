1 // File: smartcontract/chefInOne.sol
2 
3 /*
4 
5 website: http://yfgyoza.money/
6 
7 forked from SUSHI and YUNO and Kimchi
8 
9 */
10 
11 pragma solidity ^0.6.6;
12 
13 abstract contract Context {
14     function _msgSender() internal virtual view returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal virtual view returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount)
43         external
44         returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender)
54         external
55         view
56         returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     function mint(address _to, uint256 _amount) external;
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(
104         address indexed owner,
105         address indexed spender,
106         uint256 value
107     );
108 }
109 
110 interface IMigratorChef {
111     function migrate(IERC20 token) external returns (IERC20);
112 }
113 
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         return sub(a, b, "SafeMath: subtraction overflow");
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(
157         uint256 a,
158         uint256 b,
159         string memory errorMessage
160     ) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
244         return mod(a, b, "SafeMath: modulo by zero");
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts with custom message when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(
260         uint256 a,
261         uint256 b,
262         string memory errorMessage
263     ) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies in extcodesize, which returns 0 for contracts in
289         // construction, since the code is only stored at the end of the
290         // constructor execution.
291 
292         uint256 size;
293         // solhint-disable-next-line no-inline-assembly
294         assembly {
295             size := extcodesize(account)
296         }
297         return size > 0;
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(
318             address(this).balance >= amount,
319             "Address: insufficient balance"
320         );
321 
322         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
323         (bool success, ) = recipient.call{value: amount}("");
324         require(
325             success,
326             "Address: unable to send value, recipient may have reverted"
327         );
328     }
329 
330     /**
331      * @dev Performs a Solidity function call using a low level `call`. A
332      * plain`call` is an unsafe replacement for a function call: use this
333      * function instead.
334      *
335      * If `target` reverts with a revert reason, it is bubbled up by this
336      * function (like regular Solidity function calls).
337      *
338      * Returns the raw returned data. To convert to the expected return value,
339      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
340      *
341      * Requirements:
342      *
343      * - `target` must be a contract.
344      * - calling `target` with `data` must not revert.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data)
349         internal
350         returns (bytes memory)
351     {
352         return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         return _functionCallWithValue(target, data, 0, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but also transferring `value` wei to `target`.
372      *
373      * Requirements:
374      *
375      * - the calling contract must have an ETH balance of at least `value`.
376      * - the called Solidity function must be `payable`.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(
381         address target,
382         bytes memory data,
383         uint256 value
384     ) internal returns (bytes memory) {
385         return
386             functionCallWithValue(
387                 target,
388                 data,
389                 value,
390                 "Address: low-level call with value failed"
391             );
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
396      * with `errorMessage` as a fallback revert reason when `target` reverts.
397      *
398      * _Available since v3.1._
399      */
400     function functionCallWithValue(
401         address target,
402         bytes memory data,
403         uint256 value,
404         string memory errorMessage
405     ) internal returns (bytes memory) {
406         require(
407             address(this).balance >= value,
408             "Address: insufficient balance for call"
409         );
410         return _functionCallWithValue(target, data, value, errorMessage);
411     }
412 
413     function _functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 weiValue,
417         string memory errorMessage
418     ) private returns (bytes memory) {
419         require(isContract(target), "Address: call to non-contract");
420 
421         // solhint-disable-next-line avoid-low-level-calls
422         (bool success, bytes memory returndata) = target.call{value: weiValue}(
423             data
424         );
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 // solhint-disable-next-line no-inline-assembly
433                 assembly {
434                     let returndata_size := mload(returndata)
435                     revert(add(32, returndata), returndata_size)
436                 }
437             } else {
438                 revert(errorMessage);
439             }
440         }
441     }
442 }
443 
444 library SafeERC20 {
445     using SafeMath for uint256;
446     using Address for address;
447 
448     function safeTransfer(
449         IERC20 token,
450         address to,
451         uint256 value
452     ) internal {
453         _callOptionalReturn(
454             token,
455             abi.encodeWithSelector(token.transfer.selector, to, value)
456         );
457     }
458 
459     function safeTransferFrom(
460         IERC20 token,
461         address from,
462         address to,
463         uint256 value
464     ) internal {
465         _callOptionalReturn(
466             token,
467             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
468         );
469     }
470 
471     /**
472      * @dev Deprecated. This function has issues similar to the ones found in
473      * {IERC20-approve}, and its usage is discouraged.
474      *
475      * Whenever possible, use {safeIncreaseAllowance} and
476      * {safeDecreaseAllowance} instead.
477      */
478     function safeApprove(
479         IERC20 token,
480         address spender,
481         uint256 value
482     ) internal {
483         // safeApprove should only be called when setting an initial allowance,
484         // or when resetting it to zero. To increase and decrease it, use
485         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
486         // solhint-disable-next-line max-line-length
487         require(
488             (value == 0) || (token.allowance(address(this), spender) == 0),
489             "SafeERC20: approve from non-zero to non-zero allowance"
490         );
491         _callOptionalReturn(
492             token,
493             abi.encodeWithSelector(token.approve.selector, spender, value)
494         );
495     }
496 
497     function safeIncreaseAllowance(
498         IERC20 token,
499         address spender,
500         uint256 value
501     ) internal {
502         uint256 newAllowance = token.allowance(address(this), spender).add(
503             value
504         );
505         _callOptionalReturn(
506             token,
507             abi.encodeWithSelector(
508                 token.approve.selector,
509                 spender,
510                 newAllowance
511             )
512         );
513     }
514 
515     function safeDecreaseAllowance(
516         IERC20 token,
517         address spender,
518         uint256 value
519     ) internal {
520         uint256 newAllowance = token.allowance(address(this), spender).sub(
521             value,
522             "SafeERC20: decreased allowance below zero"
523         );
524         _callOptionalReturn(
525             token,
526             abi.encodeWithSelector(
527                 token.approve.selector,
528                 spender,
529                 newAllowance
530             )
531         );
532     }
533 
534     /**
535      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
536      * on the return value: the return value is optional (but if data is returned, it must not be false).
537      * @param token The token targeted by the call.
538      * @param data The call data (encoded using abi.encode or one of its variants).
539      */
540     function _callOptionalReturn(IERC20 token, bytes memory data) private {
541         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
542         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
543         // the target address contains contract code and also asserts for success in the low-level call.
544 
545         bytes memory returndata = address(token).functionCall(
546             data,
547             "SafeERC20: low-level call failed"
548         );
549         if (returndata.length > 0) {
550             // Return data is optional
551             // solhint-disable-next-line max-line-length
552             require(
553                 abi.decode(returndata, (bool)),
554                 "SafeERC20: ERC20 operation did not succeed"
555             );
556         }
557     }
558 }
559 
560 contract Ownable is Context {
561     address private _owner;
562 
563     event OwnershipTransferred(
564         address indexed previousOwner,
565         address indexed newOwner
566     );
567 
568     /**
569      * @dev Initializes the contract setting the deployer as the initial owner.
570      */
571     constructor() internal {
572         address msgSender = _msgSender();
573         _owner = msgSender;
574         emit OwnershipTransferred(address(0), msgSender);
575     }
576 
577     /**
578      * @dev Returns the address of the current owner.
579      */
580     function owner() public view returns (address) {
581         return _owner;
582     }
583 
584     /**
585      * @dev Throws if called by any account other than the owner.
586      */
587     modifier onlyOwner() {
588         require(_owner == _msgSender(), "Ownable: caller is not the owner");
589         _;
590     }
591 
592     /**
593      * @dev Leaves the contract without owner. It will not be possible to call
594      * `onlyOwner` functions anymore. Can only be called by the current owner.
595      *
596      * NOTE: Renouncing ownership will leave the contract without an owner,
597      * thereby removing any functionality that is only available to the owner.
598      */
599     function renounceOwnership() public virtual onlyOwner {
600         emit OwnershipTransferred(_owner, address(0));
601         _owner = address(0);
602     }
603 
604     /**
605      * @dev Transfers ownership of the contract to a new account (`newOwner`).
606      * Can only be called by the current owner.
607      */
608     function transferOwnership(address newOwner) public virtual onlyOwner {
609         require(
610             newOwner != address(0),
611             "Ownable: new owner is the zero address"
612         );
613         emit OwnershipTransferred(_owner, newOwner);
614         _owner = newOwner;
615     }
616 }
617 
618 contract GYOZAChef is Ownable {
619     using SafeMath for uint256;
620     using SafeERC20 for IERC20;
621 
622     // Info of each user.
623     struct UserInfo {
624         uint256 amount; // How many LP tokens the user has provided.
625         uint256 rewardDebt; // Reward debt. See explanation below.
626         //
627         // We do some fancy math here. Basically, any point in time, the amount of GYOZAs
628         // entitled to a user but is pending to be distributed is:
629         //
630         //   pending reward = (user.amount * pool.accGYOZAPerShare) - user.rewardDebt
631     }
632 
633     // Info of each pool.
634     struct PoolInfo {
635         IERC20 lpToken; // Address of LP token contract.
636         uint256 allocPoint; // How many allocation points assigned to this pool. GYOZAs to distribute per block.
637         uint256 lastRewardBlock; // Last block number that GYOZAs distribution occurs.
638         uint256 accGYOZAPerShare; // Accumulated GYOZAs per share, times 1e12. See below.
639     }
640 
641     // The GYOZA TOKEN!
642     IERC20 public gyoza;
643     // Dev address.
644     address public devaddr;
645     // Community address.
646     address public communityaddr;
647     // Block number when bonus GYOZA period ends.
648     uint256 public bonusEndBlock;
649     // GYOZA tokens created per block.
650     uint256 public gyozaPerBlock;
651     // Bonus muliplier for early gyoza makers.
652     // no bonus
653     IMigratorChef public migrator;
654 
655     // Info of each pool.
656     PoolInfo[] public poolInfo;
657     mapping(address => bool) public lpTokenExistsInPool;
658     // Info of each user that stakes LP tokens.
659     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
660     // Total allocation poitns. Must be the sum of all allocation points in all pools.
661     uint256 public totalAllocPoint = 0;
662     // The block number when GYOZA mining starts.
663     uint256 public startBlock;
664 
665     uint256 public blockInADay = 5760; // Assume 15s per block
666     uint256 public blockInAMonth = 172800;
667     uint256 public halvePeriod = blockInAMonth;
668     uint256 public minimumGYOZAPerBlock = 125 ether; // Start at 1000, halve 3 times, 500 > 250 > 125.
669     uint256 public lastHalveBlock ;
670 
671     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
672     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
673     event EmergencyWithdraw(
674         address indexed user,
675         uint256 indexed pid,
676         uint256 amount
677     );
678     event Halve(uint256 newGYOZAPerBlock, uint256 nextHalveBlockNumber);
679 
680     constructor(
681         IERC20 _gyoza,
682         address _devaddr,
683         address _communityaddr
684     ) public {
685         gyoza = _gyoza;
686         devaddr = _devaddr;
687         communityaddr = _communityaddr;
688         gyozaPerBlock = 1000 ether;
689         
690         startBlock = 9999999999999999;
691         lastHalveBlock = 9999999999999999;
692     }
693     
694     function initializeStartBlock(uint256 _startBlock) public onlyOwner {
695         if(startBlock == 9999999999999999) {
696             startBlock = _startBlock;
697             lastHalveBlock = _startBlock;
698         }
699     }
700 
701     function doHalvingCheck(bool _withUpdate) public {
702         if (gyozaPerBlock <= minimumGYOZAPerBlock) {
703             return;
704         }
705         bool doHalve = block.number > lastHalveBlock + halvePeriod;
706         if (!doHalve) {
707             return;
708         }
709         uint256 newGYOZAPerBlock = gyozaPerBlock.div(2);
710         if (newGYOZAPerBlock >= minimumGYOZAPerBlock) {
711             gyozaPerBlock = newGYOZAPerBlock;
712             lastHalveBlock = block.number;
713             emit Halve(newGYOZAPerBlock, block.number + halvePeriod);
714 
715             if (_withUpdate) {
716                 massUpdatePools();
717             }
718         }
719     }
720 
721     function poolLength() external view returns (uint256) {
722         return poolInfo.length;
723     }
724 
725     // Add a new lp to the pool. Can only be called by the owner.
726     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
727     function add(
728         uint256 _allocPoint,
729         IERC20 _lpToken,
730         bool _withUpdate
731     ) public onlyOwner {
732         require(
733             !lpTokenExistsInPool[address(_lpToken)],
734             "GYOZAChef: LP Token Address already exists in pool"
735         );
736         if (_withUpdate) {
737             massUpdatePools();
738         }
739         uint256 lastRewardBlock = block.number > startBlock
740             ? block.number
741             : startBlock;
742         totalAllocPoint = totalAllocPoint.add(_allocPoint);
743         poolInfo.push(
744             PoolInfo({
745                 lpToken: _lpToken,
746                 allocPoint: _allocPoint,
747                 lastRewardBlock: lastRewardBlock,
748                 accGYOZAPerShare: 0
749             })
750         );
751         lpTokenExistsInPool[address(_lpToken)] = true;
752     }
753 
754     function updateLpTokenExists(address _lpTokenAddr, bool _isExists)
755         external
756         onlyOwner
757     {
758         lpTokenExistsInPool[_lpTokenAddr] = _isExists;
759     }
760 
761     // Update the given pool's GYOZA allocation point. Can only be called by the owner.
762     function set(
763         uint256 _pid,
764         uint256 _allocPoint,
765         bool _withUpdate
766     ) public onlyOwner {
767         if (_withUpdate) {
768             massUpdatePools();
769         }
770         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
771             _allocPoint
772         );
773         poolInfo[_pid].allocPoint = _allocPoint;
774     }
775 
776     function setMigrator(IMigratorChef _migrator) public onlyOwner {
777         migrator = _migrator;
778     }
779 
780     function migrate(uint256 _pid) public onlyOwner {
781         require(
782             address(migrator) != address(0),
783             "GYOZAChef: Address of migrator is null"
784         );
785         PoolInfo storage pool = poolInfo[_pid];
786         IERC20 lpToken = pool.lpToken;
787         uint256 bal = lpToken.balanceOf(address(this));
788         lpToken.safeApprove(address(migrator), bal);
789         IERC20 newLpToken = migrator.migrate(lpToken);
790         require(
791             !lpTokenExistsInPool[address(newLpToken)],
792             "GYOZAChef: New LP Token Address already exists in pool"
793         );
794         require(
795             bal == newLpToken.balanceOf(address(this)),
796             "GYOZAChef: New LP Token balance incorrect"
797         );
798         pool.lpToken = newLpToken;
799         lpTokenExistsInPool[address(newLpToken)] = true;
800     }
801 
802     // View function to see pending GYOZAs on frontend.
803     function pendingGYOZA(uint256 _pid, address _user)
804         external
805         view
806         returns (uint256)
807     {
808         PoolInfo storage pool = poolInfo[_pid];
809         UserInfo storage user = userInfo[_pid][_user];
810         uint256 accGYOZAPerShare = pool.accGYOZAPerShare;
811         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
812         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
813             uint256 blockPassed = block.number.sub(pool.lastRewardBlock);
814             uint256 gyozaReward = blockPassed
815                 .mul(gyozaPerBlock)
816                 .mul(pool.allocPoint)
817                 .div(totalAllocPoint);
818             accGYOZAPerShare = accGYOZAPerShare.add(
819                 gyozaReward.mul(1e12).div(lpSupply)
820             );
821         }
822         return
823             user.amount.mul(accGYOZAPerShare).div(1e12).sub(user.rewardDebt);
824     }
825 
826     // Update reward vairables for all pools. Be careful of gas spending!
827     function massUpdatePools() public {
828         uint256 length = poolInfo.length;
829         for (uint256 pid = 0; pid < length; ++pid) {
830             updatePool(pid);
831         }
832     }
833 
834     // Update reward variables of the given pool to be up-to-date.
835     function updatePool(uint256 _pid) public {
836         doHalvingCheck(false);
837         PoolInfo storage pool = poolInfo[_pid];
838         if (block.number <= pool.lastRewardBlock) {
839             return;
840         }
841         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
842         if (lpSupply == 0) {
843             pool.lastRewardBlock = block.number;
844             return;
845         }
846         uint256 blockPassed = block.number.sub(pool.lastRewardBlock);
847         uint256 gyozaReward = blockPassed
848             .mul(gyozaPerBlock)
849             .mul(pool.allocPoint)
850             .div(totalAllocPoint);
851         gyoza.mint(devaddr, gyozaReward.div(50)); // 2%
852         gyoza.mint(communityaddr, gyozaReward.div(50)); // 2%
853         gyoza.mint(address(this), gyozaReward);
854         pool.accGYOZAPerShare = pool.accGYOZAPerShare.add(
855             gyozaReward.mul(1e12).div(lpSupply)
856         );
857         pool.lastRewardBlock = block.number;
858     }
859 
860     // Deposit LP tokens to MasterChef for GYOZA allocation.
861     function deposit(uint256 _pid, uint256 _amount) public {
862         PoolInfo storage pool = poolInfo[_pid];
863         UserInfo storage user = userInfo[_pid][msg.sender];
864         updatePool(_pid);
865         if (user.amount > 0) {
866             uint256 pending = user
867                 .amount
868                 .mul(pool.accGYOZAPerShare)
869                 .div(1e12)
870                 .sub(user.rewardDebt);
871             safeGYOZATransfer(msg.sender, pending);
872         }
873         pool.lpToken.safeTransferFrom(
874             address(msg.sender),
875             address(this),
876             _amount
877         );
878         user.amount = user.amount.add(_amount);
879         user.rewardDebt = user.amount.mul(pool.accGYOZAPerShare).div(1e12);
880         emit Deposit(msg.sender, _pid, _amount);
881     }
882 
883     // Withdraw LP tokens from MasterChef.
884     function withdraw(uint256 _pid, uint256 _amount) public {
885         PoolInfo storage pool = poolInfo[_pid];
886         UserInfo storage user = userInfo[_pid][msg.sender];
887         require(
888             user.amount >= _amount,
889             "GYOZAChef: Insufficient Amount to withdraw"
890         );
891         updatePool(_pid);
892         uint256 pending = user.amount.mul(pool.accGYOZAPerShare).div(1e12).sub(
893             user.rewardDebt
894         );
895         safeGYOZATransfer(msg.sender, pending);
896         user.amount = user.amount.sub(_amount);
897         user.rewardDebt = user.amount.mul(pool.accGYOZAPerShare).div(1e12);
898         pool.lpToken.safeTransfer(address(msg.sender), _amount);
899         emit Withdraw(msg.sender, _pid, _amount);
900     }
901 
902     // Withdraw without caring about rewards. EMERGENCY ONLY.
903     function emergencyWithdraw(uint256 _pid) public {
904         PoolInfo storage pool = poolInfo[_pid];
905         UserInfo storage user = userInfo[_pid][msg.sender];
906         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
907         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
908         user.amount = 0;
909         user.rewardDebt = 0;
910     }
911 
912     // Safe gyoza transfer function, just in case if rounding error causes pool to not have enough GYOZAs.
913     function safeGYOZATransfer(address _to, uint256 _amount) internal {
914         uint256 gyozaBal = gyoza.balanceOf(address(this));
915         if (_amount > gyozaBal) {
916             gyoza.transfer(_to, gyozaBal);
917         } else {
918             gyoza.transfer(_to, _amount);
919         }
920     }
921 
922     // Update dev address by the previous dev.
923     function dev(address _devaddr) public {
924         require(
925             msg.sender == devaddr,
926             "GYOZAChef: Sender is not the developer"
927         );
928         devaddr = _devaddr;
929     }
930 }