1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity >=0.6.12; // =>0.8.7 
3 
4 library SafeMath {
5     /**
6      * @dev Multiplies two numbers, throws on overflow.
7      */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18      * @dev Integer division of two numbers, truncating the quotient.
19      */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29      */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36      * @dev Adds two numbers, throws on overflow.
37      */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 abstract contract Context {
46     function _msgSender() internal view virtual returns (address) {
47         return msg.sender;
48     }
49 
50     function _msgData() internal view virtual returns (bytes calldata) {
51         return msg.data;
52     }
53 }
54 
55 abstract contract ReentrancyGuard {
56     // Booleans are more expensive than uint256 or any type that takes up a full
57     // word because each write operation emits an extra SLOAD to first read the
58     // slot's contents, replace the bits taken up by the boolean, and then write
59     // back. This is the compiler's defense against contract upgrades and
60     // pointer aliasing, and it cannot be disabled.
61 
62     // The values being non-zero value makes deployment a bit more expensive,
63     // but in exchange the refund on every call to nonReentrant will be lower in
64     // amount. Since refunds are capped to a percentage of the total
65     // transaction's gas, it is best to keep them low in cases like this one, to
66     // increase the likelihood of the full refund coming into effect.
67     uint256 private constant _NOT_ENTERED = 1;
68     uint256 private constant _ENTERED = 2;
69 
70     uint256 private _status;
71 
72     constructor() {
73         _status = _NOT_ENTERED;
74     }
75 
76     /**
77      * @dev Prevents a contract from calling itself, directly or indirectly.
78      * Calling a `nonReentrant` function from another `nonReentrant`
79      * function is not supported. It is possible to prevent this from happening
80      * by making the `nonReentrant` function external, and make it call a
81      * `private` function that does the actual work.
82      */
83     modifier nonReentrant() {
84         // On the first call to nonReentrant, _notEntered will be true
85         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
86 
87         // Any calls to nonReentrant after this point will fail
88         _status = _ENTERED;
89 
90         _;
91 
92         // By storing the original value once again, a refund is triggered (see
93         // https://eips.ethereum.org/EIPS/eip-2200)
94         _status = _NOT_ENTERED;
95     }
96 }
97 
98 abstract contract Ownable is Context {
99     address private _owner;
100     address private _previousOwner;
101     uint256 private _lockTime;
102 
103     event OwnershipTransferred(
104         address indexed previousOwner,
105         address indexed newOwner
106     );
107 
108     /**
109      * @dev Initializes the contract setting the deployer as the initial owner.
110      */
111     constructor() {
112         address msgSender = _msgSender();
113         _owner = msgSender;
114         emit OwnershipTransferred(address(0), msgSender);
115     }
116 
117     /**
118      * @dev Returns the address of the current owner.
119      */
120     function owner() public view returns (address) {
121         return _owner;
122     }
123 
124     /**
125      * @dev Throws if called by any account other than the owner.
126      */
127     modifier onlyOwner() {
128         require(_owner == _msgSender(), "Ownable: caller is not the owner");
129         _;
130     }
131 
132     /**
133      * @dev Leaves the contract without owner. It will not be possible to call
134      * `onlyOwner` functions anymore. Can only be called by the current owner.
135      *
136      * NOTE: Renouncing ownership will leave the contract without an owner,
137      * thereby removing any functionality that is only available to the owner.
138      */
139     function renounceOwnership() public virtual onlyOwner {
140         emit OwnershipTransferred(_owner, address(0));
141         _owner = address(0);
142     }
143 
144     /**
145      * @dev Transfers ownership of the contract to a new account (`newOwner`).
146      * Can only be called by the current owner.
147      */
148     function transferOwnership(address newOwner) public virtual onlyOwner {
149         require(
150             newOwner != address(0),
151             "Ownable: new owner is the zero address"
152         );
153         emit OwnershipTransferred(_owner, newOwner);
154         _owner = newOwner;
155     }
156 
157     function getUnlockTime() public view returns (uint256) {
158         return _lockTime;
159     }
160 }
161 
162 interface IERC20 {
163     /**
164      * @dev Returns the amount of tokens in existence.
165      */
166     function totalSupply() external view returns (uint256);
167 
168     /**
169      * @dev Returns the token decimals.
170      */
171     function decimals() external view returns (uint8);
172 
173     /**
174      * @dev Returns the token symbol.
175      */
176     function symbol() external view returns (string memory);
177 
178     /**
179      * @dev Returns the token name.
180      */
181     function name() external view returns (string memory);
182 
183     /**
184      * @dev Returns the bep token owner.
185      */
186     function getOwner() external view returns (address);
187 
188     /**
189      * @dev Returns the amount of tokens owned by `account`.
190      */
191     function balanceOf(address account) external view returns (uint256);
192 
193     /**
194      * @dev Moves `amount` tokens from the caller's account to `recipient`.
195      *
196      * Returns a boolean value indicating whether the operation succeeded.
197      *
198      * Emits a {Transfer} event.
199      */
200     function transfer(address recipient, uint256 amount)
201         external
202         returns (bool);
203 
204     /**
205      * @dev Returns the remaining number of tokens that `spender` will be
206      * allowed to spend on behalf of `owner` through {transferFrom}. This is
207      * zero by default.
208      *
209      * This value changes when {approve} or {transferFrom} are called.
210      */
211     function allowance(address _owner, address spender)
212         external
213         view
214         returns (uint256);
215 
216     /**
217      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * IMPORTANT: Beware that changing an allowance with this method brings the risk
222      * that someone may use both the old and the new allowance by unfortunate
223      * transaction ordering. One possible solution to mitigate this race
224      * condition is to first reduce the spender's allowance to 0 and set the
225      * desired value afterwards:
226      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227      *
228      * Emits an {Approval} event.
229      */
230     function approve(address spender, uint256 amount) external returns (bool);
231 
232     /**
233      * @dev Moves `amount` tokens from `sender` to `recipient` using the
234      * allowance mechanism. `amount` is then deducted from the caller's
235      * allowance.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transferFrom(
242         address sender,
243         address recipient,
244         uint256 amount
245     ) external returns (bool);
246 
247     /**
248      * @dev Emitted when `value` tokens are moved from one account (`from`) to
249      * another (`to`).
250      *
251      * Note that `value` may be zero.
252      */
253     event Transfer(address indexed from, address indexed to, uint256 value);
254 
255     /**
256      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
257      * a call to {approve}. `value` is the new allowance.
258      */
259     event Approval(
260         address indexed owner,
261         address indexed spender,
262         uint256 value
263     );
264 }
265 
266 library Address {
267     /**
268      * @dev Returns true if `account` is a contract.
269      *
270      * [IMPORTANT]
271      * ====
272      * It is unsafe to assume that an address for which this function returns
273      * false is an externally-owned account (EOA) and not a contract.
274      *
275      * Among others, `isContract` will return false for the following
276      * types of addresses:
277      *
278      *  - an externally-owned account
279      *  - a contract in construction
280      *  - an address where a contract will be created
281      *  - an address where a contract lived, but was destroyed
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // This method relies on extcodesize, which returns 0 for contracts in
286         // construction, since the code is only stored at the end of the
287         // constructor execution.
288         uint256 size;
289         // solhint-disable-next-line no-inline-assembly
290         assembly {
291             size := extcodesize(account)
292         }
293         return size > 0;
294     }
295 
296     /**
297      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298      * `recipient`, forwarding all available gas and reverting on errors.
299      *
300      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301      * of certain opcodes, possibly making contracts go over the 2300 gas limit
302      * imposed by `transfer`, making them unable to receive funds via
303      * `transfer`. {sendValue} removes this limitation.
304      *
305      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306      *
307      * IMPORTANT: because control is transferred to `recipient`, care must be
308      * taken to not create reentrancy vulnerabilities. Consider using
309      * {ReentrancyGuard} or the
310      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311      */
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(
314             address(this).balance >= amount,
315             "Address: insufficient balance"
316         );
317         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
318         (bool success, ) = recipient.call{value: amount}("");
319         require(
320             success,
321             "Address: unable to send value, recipient may have reverted"
322         );
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain`call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data)
344         internal
345         returns (bytes memory)
346     {
347         return functionCall(target, data, "Address: low-level call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
352      * `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, 0, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but also transferring `value` wei to `target`.
367      *
368      * Requirements:
369      *
370      * - the calling contract must have an ETH balance of at least `value`.
371      * - the called Solidity function must be `payable`.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value
379     ) internal returns (bytes memory) {
380         return
381             functionCallWithValue(
382                 target,
383                 data,
384                 value,
385                 "Address: low-level call with value failed"
386             );
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
391      * with `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(
396         address target,
397         bytes memory data,
398         uint256 value,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         require(
402             address(this).balance >= value,
403             "Address: insufficient balance for call"
404         );
405         require(isContract(target), "Address: call to non-contract");
406         // solhint-disable-next-line avoid-low-level-calls
407         (bool success, bytes memory returndata) = target.call{value: value}(
408             data
409         );
410         return _verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
415      * but performing a static call.
416      *
417      * _Available since v3.3._
418      */
419     function functionStaticCall(address target, bytes memory data)
420         internal
421         view
422         returns (bytes memory)
423     {
424         return
425             functionStaticCall(
426                 target,
427                 data,
428                 "Address: low-level static call failed"
429             );
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
434      * but performing a static call.
435      *
436      * _Available since v3.3._
437      */
438     function functionStaticCall(
439         address target,
440         bytes memory data,
441         string memory errorMessage
442     ) internal view returns (bytes memory) {
443         require(isContract(target), "Address: static call to non-contract");
444         // solhint-disable-next-line avoid-low-level-calls
445         (bool success, bytes memory returndata) = target.staticcall(data);
446         return _verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
451      * but performing a delegate call.
452      *
453      * _Available since v3.4._
454      */
455     function functionDelegateCall(address target, bytes memory data)
456         internal
457         returns (bytes memory)
458     {
459         return
460             functionDelegateCall(
461                 target,
462                 data,
463                 "Address: low-level delegate call failed"
464             );
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.4._
472      */
473     function functionDelegateCall(
474         address target,
475         bytes memory data,
476         string memory errorMessage
477     ) internal returns (bytes memory) {
478         require(isContract(target), "Address: delegate call to non-contract");
479         // solhint-disable-next-line avoid-low-level-calls
480         (bool success, bytes memory returndata) = target.delegatecall(data);
481         return _verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     function _verifyCallResult(
485         bool success,
486         bytes memory returndata,
487         string memory errorMessage
488     ) private pure returns (bytes memory) {
489         if (success) {
490             return returndata;
491         } else {
492             // Look for revert reason and bubble it up if present
493             if (returndata.length > 0) {
494                 // The easiest way to bubble the revert reason is using memory via assembly
495                 // solhint-disable-next-line no-inline-assembly
496                 assembly {
497                     let returndata_size := mload(returndata)
498                     revert(add(32, returndata), returndata_size)
499                 }
500             } else {
501                 revert(errorMessage);
502             }
503         }
504     }
505 }
506 
507 library SafeERC20 {
508     using Address for address;
509 
510     function safeTransfer(
511         IERC20 token,
512         address to,
513         uint256 value
514     ) internal {
515         _callOptionalReturn(
516             token,
517             abi.encodeWithSelector(token.transfer.selector, to, value)
518         );
519     }
520 
521     function safeTransferFrom(
522         IERC20 token,
523         address from,
524         address to,
525         uint256 value
526     ) internal {
527         _callOptionalReturn(
528             token,
529             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
530         );
531     }
532 
533     /**
534      * @dev Deprecated. This function has issues similar to the ones found in
535      * {IERC20-approve}, and its usage is discouraged.
536      *
537      * Whenever possible, use {safeIncreaseAllowance} and
538      * {safeDecreaseAllowance} instead.
539      */
540     function safeApprove(
541         IERC20 token,
542         address spender,
543         uint256 value
544     ) internal {
545         // safeApprove should only be called when setting an initial allowance,
546         // or when resetting it to zero. To increase and decrease it, use
547         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
548         require(
549             (value == 0) || (token.allowance(address(this), spender) == 0),
550             "SafeERC20: approve from non-zero to non-zero allowance"
551         );
552         _callOptionalReturn(
553             token,
554             abi.encodeWithSelector(token.approve.selector, spender, value)
555         );
556     }
557 
558     function safeIncreaseAllowance(
559         IERC20 token,
560         address spender,
561         uint256 value
562     ) internal {
563         uint256 newAllowance = token.allowance(address(this), spender) + value;
564         _callOptionalReturn(
565             token,
566             abi.encodeWithSelector(
567                 token.approve.selector,
568                 spender,
569                 newAllowance
570             )
571         );
572     }
573 
574     function safeDecreaseAllowance(
575         IERC20 token,
576         address spender,
577         uint256 value
578     ) internal {
579         unchecked {
580             uint256 oldAllowance = token.allowance(address(this), spender);
581             require(
582                 oldAllowance >= value,
583                 "SafeERC20: decreased allowance below zero"
584             );
585             uint256 newAllowance = oldAllowance - value;
586             _callOptionalReturn(
587                 token,
588                 abi.encodeWithSelector(
589                     token.approve.selector,
590                     spender,
591                     newAllowance
592                 )
593             );
594         }
595     }
596 
597     /**
598      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
599      * on the return value: the return value is optional (but if data is returned, it must not be false).
600      * @param token The token targeted by the call.
601      * @param data The call data (encoded using abi.encode or one of its variants).
602      */
603     function _callOptionalReturn(IERC20 token, bytes memory data) private {
604         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
605         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
606         // the target address contains contract code and also asserts for success in the low-level call.
607 
608         bytes memory returndata = address(token).functionCall(
609             data,
610             "SafeERC20: low-level call failed"
611         );
612         if (returndata.length > 0) {
613             // Return data is optional
614             require(
615                 abi.decode(returndata, (bool)),
616                 "SafeERC20: ERC20 operation did not succeed"
617             );
618         }
619     }
620 }
621 
622 contract MasterChedda is Ownable, ReentrancyGuard {
623     using SafeMath for uint256;
624     using SafeERC20 for IERC20;
625 
626     // Info of each user.
627     struct UserInfo {
628         address playerAddy;
629         uint256 amount; // How many LP tokens the user has provided.
630         uint256 rewardDebt; // Reward debt. See explanation below.
631     }
632 
633     struct PoolInfo {
634         uint256 lastRewardBlock; // Last block number that Cheddas distribution occurs.
635         uint256 accCheddaPerShare; // Accumulated Cheddas per share, times 1e12. See below.
636     }
637 
638     // The Chedda TOKEN!
639     IERC20 public Chedda;
640     
641     // Chedda tokens created per block.
642     uint256 public CheddaPerBlock;
643 
644     // Info of each pool.
645     PoolInfo[] public poolInfo;
646     // Info of each user that stakes LP tokens.
647     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
648     uint256 public startBlock;
649 
650     UserInfo[] public UsersInfo;
651 
652     address public dev1;
653     address public dev2;
654     address public dev3;
655 
656     // Deposit fee in basis points
657     uint256 public depositFeeBP = 300; //3%
658 
659     // Withdraw fee in basis points
660     uint256 public withdrawFeeBP = 300; //3%
661 
662     // Claim fee in basis points
663     uint256 public HarvestfeeBP = 1000; //10%
664 
665     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
666     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
667     event EmergencyWithdraw(
668         address indexed user,
669         uint256 indexed pid,
670         uint256 amount
671     );
672     event SetDevs(address dev1, address dev2, address dev3);
673     event SetDepositFee(uint256 depositFeeBP);
674     event SetHarvestfee(uint256 HarvestfeeBP);
675     event NewCheddaPerBlock(uint256 rewardPerBlock);
676     event SetWithdrawFee(uint256 withdrawFeeBP);
677 
678     constructor(
679         IERC20 _Chedda,
680         uint256 _CheddaPerBlock,
681         uint256 _startBlock
682     ) {
683         Chedda = _Chedda;
684         CheddaPerBlock = _CheddaPerBlock;
685         startBlock = _startBlock;
686 
687         poolInfo.push(
688             PoolInfo({lastRewardBlock: startBlock, accCheddaPerShare: 0})
689         );
690     }
691 
692     // Return reward multiplier over the given _from to _to block.
693     function getMultiplier(uint256 _from, uint256 _to)
694         public
695         pure
696         returns (uint256)
697     {
698         return _to.sub(_from);
699     }
700 
701     // View function to see pending Cheddas on frontend.
702     function pendingCheddas() public view returns (uint256) {
703         uint256 pendingCheddasTotal;
704         for (uint256 i = 0; i < UsersInfo.length; i++) {
705             pendingCheddasTotal += pendingChedda(UsersInfo[i].playerAddy);
706         }
707         return pendingCheddasTotal;
708     }
709 
710     // totalDeposits is the total Cheddah deposited by users
711     function totalDeposits() public view returns (uint256) {
712         uint256 pendingCheddasTotal;
713         for (uint256 i = 0; i < UsersInfo.length; i++) {
714             UserInfo storage user = userInfo[0][UsersInfo[i].playerAddy];
715             pendingCheddasTotal += user.amount;
716         }
717         return pendingCheddasTotal;
718     }
719 
720     // effectiveRewards is the total Cheddah rewards remaining in contract
721     function effectiveRewards() public view returns (uint256) {
722         uint256 effectiveReward=0;
723         if (Chedda.balanceOf(address(this)) > pendingCheddas() + totalDeposits() )
724         {
725         effectiveReward = Chedda
726             .balanceOf(address(this))
727             .sub(pendingCheddas())
728             .sub(totalDeposits());
729         }
730         return effectiveReward;
731     }
732 
733     function pendingChedda(address _user) public view returns (uint256) {
734         PoolInfo storage pool = poolInfo[0];
735         UserInfo storage user = userInfo[0][_user];
736         uint256 accCheddaPerShare = pool.accCheddaPerShare;
737         uint256 lpSupply = totalDeposits();
738         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
739             uint256 multiplier = getMultiplier(
740                 pool.lastRewardBlock,
741                 block.number
742             );
743             uint256 CheddaReward = multiplier.mul(CheddaPerBlock);
744             accCheddaPerShare = accCheddaPerShare.add(
745                 CheddaReward.mul(1e12).div(lpSupply)
746             );
747         }
748         return
749             user.amount.mul(accCheddaPerShare).div(1e12).sub(user.rewardDebt);
750     }
751 
752     function updateCheddaPerBlock(uint256 _CheddaPerBlock) external onlyOwner {
753         CheddaPerBlock = _CheddaPerBlock;
754         emit NewCheddaPerBlock(_CheddaPerBlock);
755     }
756 
757     // Update reward variables of the given pool to be up-to-date.
758     function updatePool() public {
759         PoolInfo storage pool = poolInfo[0];
760         if (block.number <= pool.lastRewardBlock) {
761             return;
762         }
763         uint256 lpSupply = totalDeposits();
764         if (lpSupply == 0) {
765             pool.lastRewardBlock = block.number;
766             return;
767         }
768         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
769         uint256 CheddaReward = multiplier.mul(CheddaPerBlock);
770         pool.accCheddaPerShare = pool.accCheddaPerShare.add(
771             CheddaReward.mul(1e12).div(lpSupply)
772         );
773         pool.lastRewardBlock = block.number;
774     }
775 
776     // Stake Chedda tokens
777     function enterStaking(uint256 _amount) public nonReentrant {
778         PoolInfo storage pool = poolInfo[0];
779         UserInfo storage user = userInfo[0][msg.sender];
780 
781         if (user.playerAddy != msg.sender) {
782             user.playerAddy = msg.sender;
783             UsersInfo.push(user);
784         }
785 
786         updatePool();
787         if (user.amount > 0) {
788             uint256 pending = user
789                 .amount
790                 .mul(pool.accCheddaPerShare)
791                 .div(1e12)
792                 .sub(user.rewardDebt);
793             if (pending > 0) {
794                 uint256 Harvestfee = (pending * HarvestfeeBP) / 10000;
795                 Chedda.transfer(address(msg.sender), pending);
796                 Chedda.transfer(dev3, Harvestfee);
797             }
798         }
799 
800         if (_amount > 0) {
801             uint256 depositFee = (_amount * depositFeeBP) / 10000;
802             uint256 depositAmount = _amount.sub(depositFee);
803             user.amount = user.amount.add(depositAmount);
804             Chedda.safeTransferFrom(
805                 address(msg.sender),
806                 address(this),
807                 depositAmount
808             );
809             Chedda.safeTransferFrom(address(msg.sender), dev2, depositFee);
810         }
811         user.rewardDebt = user.amount.mul(pool.accCheddaPerShare).div(1e12);
812         emit Deposit(msg.sender, 0, _amount);
813     }
814 
815     function leaveStaking(uint256 _amount) public nonReentrant {
816         PoolInfo storage pool = poolInfo[0];
817         UserInfo storage user = userInfo[0][msg.sender];
818         require(user.amount >= _amount, "withdraw: not good");
819         updatePool();
820         uint256 pending = user.amount.mul(pool.accCheddaPerShare).div(1e12).sub(
821             user.rewardDebt
822         );
823 
824         if (_amount > 0) {
825             user.amount = user.amount.sub(_amount);
826             uint256 WithdrawFee = (_amount * withdrawFeeBP) / 10000;
827             Chedda.safeTransfer(address(msg.sender), _amount.sub(WithdrawFee));
828             Chedda.safeTransfer(dev1, WithdrawFee);
829         }
830 
831         if (pending > 0) {
832             uint256 HarvestBP = (pending * HarvestfeeBP) / 10000;
833             Chedda.transfer(address(msg.sender), pending);
834             Chedda.transfer(dev3, HarvestBP);
835         }
836         user.rewardDebt = user.amount.mul(pool.accCheddaPerShare).div(1e12);
837         emit Withdraw(msg.sender, 0, _amount);
838     }
839 
840     // Withdraw without caring about rewards. EMERGENCY ONLY.
841     function emergencyWithdraw() public nonReentrant {
842         UserInfo storage user = userInfo[0][msg.sender];
843         uint256 WithdrawFee = (user.amount * withdrawFeeBP) / 10000;
844         Chedda.safeTransfer(address(msg.sender), user.amount.sub(WithdrawFee));
845         Chedda.safeTransfer(dev1, WithdrawFee);
846         emit EmergencyWithdraw(msg.sender, 0, user.amount);
847         user.amount = 0;
848         user.rewardDebt = 0;
849     }
850 
851     function getPoolInfo()
852         public
853         view
854         returns (uint256 lastRewardBlock, uint256 accCheddaPerShare)
855     {
856         return (poolInfo[0].lastRewardBlock, poolInfo[0].accCheddaPerShare);
857     }
858 
859     function ChangedevAddress(address _dev1, address _dev2, address _dev3) external onlyOwner {
860         require(_dev1 != address(0), "!nonzero");
861         require(_dev2 != address(0), "!nonzero");
862         require(_dev3 != address(0), "!nonzero");
863         dev1 = _dev1;
864         dev2 = _dev2;
865         dev3 = _dev3;
866         emit SetDevs(_dev1, _dev2, _dev3);
867     }
868 
869     function ChangedepositFeeBP(uint256 _depositFeeBP) external onlyOwner {
870         depositFeeBP = _depositFeeBP;
871         emit SetDepositFee(_depositFeeBP);
872     }
873 
874     function ChangewithdrawFeeBP(uint256 _withdrawFeeBP) external onlyOwner {
875         withdrawFeeBP = _withdrawFeeBP;
876         emit SetWithdrawFee(_withdrawFeeBP);
877     }
878 
879     function ChangeHarvestfeeBP(uint256 _HarvestfeeBP) external onlyOwner {
880         require(_HarvestfeeBP < 2000, "max 20%"); // to Prevent any sort of Honypot
881         HarvestfeeBP = _HarvestfeeBP;
882         emit SetHarvestfee(_HarvestfeeBP);
883     }
884 }