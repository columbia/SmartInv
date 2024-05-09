1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-12
3  */
4 
5 // SPDX-License-Identifier: AGPL-3.0-or-later
6 pragma solidity 0.7.5;
7 
8 library SafeMath {
9     /**
10      * @dev Returns the addition of two unsigned integers, reverting on
11      * overflow.
12      *
13      * Counterpart to Solidity's `+` operator.
14      *
15      * Requirements:
16      *
17      * - Addition cannot overflow.
18      */
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22 
23         return c;
24     }
25 
26     /**
27      * @dev Returns the subtraction of two unsigned integers, reverting on
28      * overflow (when the result is negative).
29      *
30      * Counterpart to Solidity's `-` operator.
31      *
32      * Requirements:
33      *
34      * - Subtraction cannot overflow.
35      */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     /**
41      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      *
48      * - Subtraction cannot overflow.
49      */
50     function sub(
51         uint256 a,
52         uint256 b,
53         string memory errorMessage
54     ) internal pure returns (uint256) {
55         require(b <= a, errorMessage);
56         uint256 c = a - b;
57 
58         return c;
59     }
60 
61     /**
62      * @dev Returns the multiplication of two unsigned integers, reverting on
63      * overflow.
64      *
65      * Counterpart to Solidity's `*` operator.
66      *
67      * Requirements:
68      *
69      * - Multiplication cannot overflow.
70      */
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73         // benefit is lost if 'b' is also tested.
74         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75         if (a == 0) {
76             return 0;
77         }
78 
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the integer division of two unsigned integers. Reverts on
87      * division by zero. The result is rounded towards zero.
88      *
89      * Counterpart to Solidity's `/` operator. Note: this function uses a
90      * `revert` opcode (which leaves remaining gas untouched) while Solidity
91      * uses an invalid opcode to revert (consuming all remaining gas).
92      *
93      * Requirements:
94      *
95      * - The divisor cannot be zero.
96      */
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         return div(a, b, "SafeMath: division by zero");
99     }
100 
101     /**
102      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
103      * division by zero. The result is rounded towards zero.
104      *
105      * Counterpart to Solidity's `/` operator. Note: this function uses a
106      * `revert` opcode (which leaves remaining gas untouched) while Solidity
107      * uses an invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      *
111      * - The divisor cannot be zero.
112      */
113     function div(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         assert(a == b * c + (a % b)); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 }
125 
126 interface IERC20 {
127     function decimals() external view returns (uint8);
128 
129     /**
130      * @dev Returns the amount of tokens in existence.
131      */
132     function totalSupply() external view returns (uint256);
133 
134     /**
135      * @dev Returns the amount of tokens owned by `account`.
136      */
137     function balanceOf(address account) external view returns (uint256);
138 
139     /**
140      * @dev Moves `amount` tokens from the caller's account to `recipient`.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transfer(address recipient, uint256 amount)
147         external
148         returns (bool);
149 
150     /**
151      * @dev Returns the remaining number of tokens that `spender` will be
152      * allowed to spend on behalf of `owner` through {transferFrom}. This is
153      * zero by default.
154      *
155      * This value changes when {approve} or {transferFrom} are called.
156      */
157     function allowance(address owner, address spender)
158         external
159         view
160         returns (uint256);
161 
162     /**
163      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * IMPORTANT: Beware that changing an allowance with this method brings the risk
168      * that someone may use both the old and the new allowance by unfortunate
169      * transaction ordering. One possible solution to mitigate this race
170      * condition is to first reduce the spender's allowance to 0 and set the
171      * desired value afterwards:
172      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173      *
174      * Emits an {Approval} event.
175      */
176     function approve(address spender, uint256 amount) external returns (bool);
177 
178     /**
179      * @dev Moves `amount` tokens from `sender` to `recipient` using the
180      * allowance mechanism. `amount` is then deducted from the caller's
181      * allowance.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transferFrom(
188         address sender,
189         address recipient,
190         uint256 amount
191     ) external returns (bool);
192 
193     /**
194      * @dev Emitted when `value` tokens are moved from one account (`from`) to
195      * another (`to`).
196      *
197      * Note that `value` may be zero.
198      */
199     event Transfer(address indexed from, address indexed to, uint256 value);
200 
201     /**
202      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
203      * a call to {approve}. `value` is the new allowance.
204      */
205     event Approval(
206         address indexed owner,
207         address indexed spender,
208         uint256 value
209     );
210 }
211 
212 library Address {
213     /**
214      * @dev Returns true if `account` is a contract.
215      *
216      * [IMPORTANT]
217      * ====
218      * It is unsafe to assume that an address for which this function returns
219      * false is an externally-owned account (EOA) and not a contract.
220      *
221      * Among others, `isContract` will return false for the following
222      * types of addresses:
223      *
224      *  - an externally-owned account
225      *  - a contract in construction
226      *  - an address where a contract will be created
227      *  - an address where a contract lived, but was destroyed
228      * ====
229      */
230     function isContract(address account) internal view returns (bool) {
231         // This method relies in extcodesize, which returns 0 for contracts in
232         // construction, since the code is only stored at the end of the
233         // constructor execution.
234 
235         uint256 size;
236         // solhint-disable-next-line no-inline-assembly
237         assembly {
238             size := extcodesize(account)
239         }
240         return size > 0;
241     }
242 
243     /**
244      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
245      * `recipient`, forwarding all available gas and reverting on errors.
246      *
247      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
248      * of certain opcodes, possibly making contracts go over the 2300 gas limit
249      * imposed by `transfer`, making them unable to receive funds via
250      * `transfer`. {sendValue} removes this limitation.
251      *
252      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
253      *
254      * IMPORTANT: because control is transferred to `recipient`, care must be
255      * taken to not create reentrancy vulnerabilities. Consider using
256      * {ReentrancyGuard} or the
257      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
258      */
259     function sendValue(address payable recipient, uint256 amount) internal {
260         require(
261             address(this).balance >= amount,
262             "Address: insufficient balance"
263         );
264 
265         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
266         (bool success, ) = recipient.call{value: amount}("");
267         require(
268             success,
269             "Address: unable to send value, recipient may have reverted"
270         );
271     }
272 
273     /**
274      * @dev Performs a Solidity function call using a low level `call`. A
275      * plain`call` is an unsafe replacement for a function call: use this
276      * function instead.
277      *
278      * If `target` reverts with a revert reason, it is bubbled up by this
279      * function (like regular Solidity function calls).
280      *
281      * Returns the raw returned data. To convert to the expected return value,
282      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
283      *
284      * Requirements:
285      *
286      * - `target` must be a contract.
287      * - calling `target` with `data` must not revert.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(address target, bytes memory data)
292         internal
293         returns (bytes memory)
294     {
295         return functionCall(target, data, "Address: low-level call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
300      * `errorMessage` as a fallback revert reason when `target` reverts.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         return _functionCallWithValue(target, data, 0, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but also transferring `value` wei to `target`.
315      *
316      * Requirements:
317      *
318      * - the calling contract must have an ETH balance of at least `value`.
319      * - the called Solidity function must be `payable`.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(
324         address target,
325         bytes memory data,
326         uint256 value
327     ) internal returns (bytes memory) {
328         return
329             functionCallWithValue(
330                 target,
331                 data,
332                 value,
333                 "Address: low-level call with value failed"
334             );
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
339      * with `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(
344         address target,
345         bytes memory data,
346         uint256 value,
347         string memory errorMessage
348     ) internal returns (bytes memory) {
349         require(
350             address(this).balance >= value,
351             "Address: insufficient balance for call"
352         );
353         require(isContract(target), "Address: call to non-contract");
354 
355         // solhint-disable-next-line avoid-low-level-calls
356         (bool success, bytes memory returndata) = target.call{value: value}(
357             data
358         );
359         return _verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     function _functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 weiValue,
366         string memory errorMessage
367     ) private returns (bytes memory) {
368         require(isContract(target), "Address: call to non-contract");
369 
370         // solhint-disable-next-line avoid-low-level-calls
371         (bool success, bytes memory returndata) = target.call{value: weiValue}(
372             data
373         );
374         if (success) {
375             return returndata;
376         } else {
377             // Look for revert reason and bubble it up if present
378             if (returndata.length > 0) {
379                 // The easiest way to bubble the revert reason is using memory via assembly
380 
381                 // solhint-disable-next-line no-inline-assembly
382                 assembly {
383                     let returndata_size := mload(returndata)
384                     revert(add(32, returndata), returndata_size)
385                 }
386             } else {
387                 revert(errorMessage);
388             }
389         }
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(address target, bytes memory data)
399         internal
400         view
401         returns (bytes memory)
402     {
403         return
404             functionStaticCall(
405                 target,
406                 data,
407                 "Address: low-level static call failed"
408             );
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal view returns (bytes memory) {
422         require(isContract(target), "Address: static call to non-contract");
423 
424         // solhint-disable-next-line avoid-low-level-calls
425         (bool success, bytes memory returndata) = target.staticcall(data);
426         return _verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a delegate call.
432      *
433      * _Available since v3.3._
434      */
435     function functionDelegateCall(address target, bytes memory data)
436         internal
437         returns (bytes memory)
438     {
439         return
440             functionDelegateCall(
441                 target,
442                 data,
443                 "Address: low-level delegate call failed"
444             );
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.3._
452      */
453     function functionDelegateCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         require(isContract(target), "Address: delegate call to non-contract");
459 
460         // solhint-disable-next-line avoid-low-level-calls
461         (bool success, bytes memory returndata) = target.delegatecall(data);
462         return _verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     function _verifyCallResult(
466         bool success,
467         bytes memory returndata,
468         string memory errorMessage
469     ) private pure returns (bytes memory) {
470         if (success) {
471             return returndata;
472         } else {
473             // Look for revert reason and bubble it up if present
474             if (returndata.length > 0) {
475                 // The easiest way to bubble the revert reason is using memory via assembly
476 
477                 // solhint-disable-next-line no-inline-assembly
478                 assembly {
479                     let returndata_size := mload(returndata)
480                     revert(add(32, returndata), returndata_size)
481                 }
482             } else {
483                 revert(errorMessage);
484             }
485         }
486     }
487 
488     function addressToString(address _address)
489         internal
490         pure
491         returns (string memory)
492     {
493         bytes32 _bytes = bytes32(uint256(_address));
494         bytes memory HEX = "0123456789abcdef";
495         bytes memory _addr = new bytes(42);
496 
497         _addr[0] = "0";
498         _addr[1] = "x";
499 
500         for (uint256 i = 0; i < 20; i++) {
501             _addr[2 + i * 2] = HEX[uint8(_bytes[i + 12] >> 4)];
502             _addr[3 + i * 2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
503         }
504 
505         return string(_addr);
506     }
507 }
508 
509 library SafeERC20 {
510     using SafeMath for uint256;
511     using Address for address;
512 
513     function safeTransfer(
514         IERC20 token,
515         address to,
516         uint256 value
517     ) internal {
518         _callOptionalReturn(
519             token,
520             abi.encodeWithSelector(token.transfer.selector, to, value)
521         );
522     }
523 
524     function safeTransferFrom(
525         IERC20 token,
526         address from,
527         address to,
528         uint256 value
529     ) internal {
530         _callOptionalReturn(
531             token,
532             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
533         );
534     }
535 
536     /**
537      * @dev Deprecated. This function has issues similar to the ones found in
538      * {IERC20-approve}, and its usage is discouraged.
539      *
540      * Whenever possible, use {safeIncreaseAllowance} and
541      * {safeDecreaseAllowance} instead.
542      */
543     function safeApprove(
544         IERC20 token,
545         address spender,
546         uint256 value
547     ) internal {
548         // safeApprove should only be called when setting an initial allowance,
549         // or when resetting it to zero. To increase and decrease it, use
550         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
551         // solhint-disable-next-line max-line-length
552         require(
553             (value == 0) || (token.allowance(address(this), spender) == 0),
554             "SafeERC20: approve from non-zero to non-zero allowance"
555         );
556         _callOptionalReturn(
557             token,
558             abi.encodeWithSelector(token.approve.selector, spender, value)
559         );
560     }
561 
562     function safeIncreaseAllowance(
563         IERC20 token,
564         address spender,
565         uint256 value
566     ) internal {
567         uint256 newAllowance = token.allowance(address(this), spender).add(
568             value
569         );
570         _callOptionalReturn(
571             token,
572             abi.encodeWithSelector(
573                 token.approve.selector,
574                 spender,
575                 newAllowance
576             )
577         );
578     }
579 
580     function safeDecreaseAllowance(
581         IERC20 token,
582         address spender,
583         uint256 value
584     ) internal {
585         uint256 newAllowance = token.allowance(address(this), spender).sub(
586             value,
587             "SafeERC20: decreased allowance below zero"
588         );
589         _callOptionalReturn(
590             token,
591             abi.encodeWithSelector(
592                 token.approve.selector,
593                 spender,
594                 newAllowance
595             )
596         );
597     }
598 
599     /**
600      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
601      * on the return value: the return value is optional (but if data is returned, it must not be false).
602      * @param token The token targeted by the call.
603      * @param data The call data (encoded using abi.encode or one of its variants).
604      */
605     function _callOptionalReturn(IERC20 token, bytes memory data) private {
606         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
607         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
608         // the target address contains contract code and also asserts for success in the low-level call.
609 
610         bytes memory returndata = address(token).functionCall(
611             data,
612             "SafeERC20: low-level call failed"
613         );
614         if (returndata.length > 0) {
615             // Return data is optional
616             // solhint-disable-next-line max-line-length
617             require(
618                 abi.decode(returndata, (bool)),
619                 "SafeERC20: ERC20 operation did not succeed"
620             );
621         }
622     }
623 }
624 
625 interface IOwnable {
626     function manager() external view returns (address);
627 
628     function renounceManagement() external;
629 
630     function pushManagement(address newOwner_) external;
631 
632     function pullManagement() external;
633 }
634 
635 contract Ownable is IOwnable {
636     address internal _owner;
637     address internal _newOwner;
638 
639     event OwnershipPushed(
640         address indexed previousOwner,
641         address indexed newOwner
642     );
643     event OwnershipPulled(
644         address indexed previousOwner,
645         address indexed newOwner
646     );
647 
648     constructor() {
649         _owner = msg.sender;
650         emit OwnershipPushed(address(0), _owner);
651     }
652 
653     function manager() public view override returns (address) {
654         return _owner;
655     }
656 
657     modifier onlyManager() {
658         require(_owner == msg.sender, "Ownable: caller is not the owner");
659         _;
660     }
661 
662     function renounceManagement() public virtual override onlyManager {
663         emit OwnershipPushed(_owner, address(0));
664         _owner = address(0);
665     }
666 
667     function pushManagement(address newOwner_)
668         public
669         virtual
670         override
671         onlyManager
672     {
673         require(
674             newOwner_ != address(0),
675             "Ownable: new owner is the zero address"
676         );
677         emit OwnershipPushed(_owner, newOwner_);
678         _newOwner = newOwner_;
679     }
680 
681     function pullManagement() public virtual override {
682         require(msg.sender == _newOwner, "Ownable: must be new owner to pull");
683         emit OwnershipPulled(_owner, _newOwner);
684         _owner = _newOwner;
685     }
686 }
687 
688 interface IsASG {
689     function rebase(uint256 asgProfit_, uint256 epoch_)
690         external
691         returns (uint256);
692 
693     function circulatingSupply() external view returns (uint256);
694 
695     function balanceOf(address who) external view returns (uint256);
696 
697     function gonsForBalance(uint256 amount) external view returns (uint256);
698 
699     function balanceForGons(uint256 gons) external view returns (uint256);
700 
701     function index() external view returns (uint256);
702 }
703 
704 interface IWarmup {
705     function retrieve(address staker_, uint256 amount_) external;
706 }
707 
708 interface IDistributor {
709     function distribute() external returns (bool);
710 }
711 
712 contract AsgardStaking is Ownable {
713     using SafeMath for uint256;
714     using SafeERC20 for IERC20;
715 
716     address public immutable ASG;
717     address public immutable sASG;
718 
719     struct Epoch {
720         uint256 length;
721         uint256 number;
722         uint256 endBlock;
723         uint256 distribute;
724     }
725     Epoch public epoch;
726 
727     address public distributor;
728 
729     address public locker;
730     uint256 public totalBonus;
731 
732     address public warmupContract;
733     uint256 public warmupPeriod;
734 
735     constructor(
736         address _ASG,
737         address _sASG,
738         uint256 _epochLength,
739         uint256 _firstEpochNumber,
740         uint256 _firstEpochBlock
741     ) {
742         require(_ASG != address(0));
743         ASG = _ASG;
744         require(_sASG != address(0));
745         sASG = _sASG;
746 
747         epoch = Epoch({
748             length: _epochLength,
749             number: _firstEpochNumber,
750             endBlock: _firstEpochBlock,
751             distribute: 0
752         });
753     }
754 
755     struct Claim {
756         uint256 deposit;
757         uint256 gons;
758         uint256 expiry;
759         bool lock; // prevents malicious delays
760     }
761     mapping(address => Claim) public warmupInfo;
762 
763     /**
764         @notice stake ASG to enter warmup
765         @param _amount uint
766         @return bool
767      */
768     function stake(uint256 _amount, address _recipient)
769         external
770         returns (bool)
771     {
772         rebase();
773 
774         IERC20(ASG).safeTransferFrom(msg.sender, address(this), _amount);
775 
776         Claim memory info = warmupInfo[_recipient];
777         require(!info.lock, "Deposits for account are locked");
778 
779         warmupInfo[_recipient] = Claim({
780             deposit: info.deposit.add(_amount),
781             gons: info.gons.add(IsASG(sASG).gonsForBalance(_amount)),
782             expiry: epoch.number.add(warmupPeriod),
783             lock: false
784         });
785 
786         IERC20(sASG).safeTransfer(warmupContract, _amount);
787         return true;
788     }
789 
790     /**
791         @notice retrieve sASG from warmup
792         @param _recipient address
793      */
794     function claim(address _recipient) public {
795         Claim memory info = warmupInfo[_recipient];
796         if (epoch.number >= info.expiry && info.expiry != 0) {
797             delete warmupInfo[_recipient];
798             IWarmup(warmupContract).retrieve(
799                 _recipient,
800                 IsASG(sASG).balanceForGons(info.gons)
801             );
802         }
803     }
804 
805     /**
806         @notice forfeit sASG in warmup and retrieve ASG
807      */
808     function forfeit() external {
809         Claim memory info = warmupInfo[msg.sender];
810         delete warmupInfo[msg.sender];
811 
812         IWarmup(warmupContract).retrieve(
813             address(this),
814             IsASG(sASG).balanceForGons(info.gons)
815         );
816         IERC20(ASG).safeTransfer(msg.sender, info.deposit);
817     }
818 
819     /**
820         @notice prevent new deposits to address (protection from malicious activity)
821      */
822     function toggleDepositLock() external {
823         warmupInfo[msg.sender].lock = !warmupInfo[msg.sender].lock;
824     }
825 
826     /**
827         @notice redeem sASG for ASG
828         @param _amount uint
829         @param _trigger bool
830      */
831     function unstake(uint256 _amount, bool _trigger) external {
832         if (_trigger) {
833             rebase();
834         }
835         IERC20(sASG).safeTransferFrom(msg.sender, address(this), _amount);
836         IERC20(ASG).safeTransfer(msg.sender, _amount);
837     }
838 
839     /**
840         @notice returns the sASG index, which tracks rebase growth
841         @return uint
842      */
843     function index() public view returns (uint256) {
844         return IsASG(sASG).index();
845     }
846 
847     /**
848         @notice trigger rebase if epoch over
849      */
850     function rebase() public {
851         if (epoch.endBlock <= block.number) {
852             IsASG(sASG).rebase(epoch.distribute, epoch.number);
853 
854             epoch.endBlock = epoch.endBlock.add(epoch.length);
855             epoch.number++;
856 
857             if (distributor != address(0)) {
858                 IDistributor(distributor).distribute();
859             }
860 
861             uint256 balance = contractBalance();
862             uint256 staked = IsASG(sASG).circulatingSupply();
863 
864             if (balance <= staked) {
865                 epoch.distribute = 0;
866             } else {
867                 epoch.distribute = balance.sub(staked);
868             }
869         }
870     }
871 
872     /**
873         @notice returns contract ASG holdings, including bonuses provided
874         @return uint
875      */
876     function contractBalance() public view returns (uint256) {
877         return IERC20(ASG).balanceOf(address(this)).add(totalBonus);
878     }
879 
880     /**
881         @notice provide bonus to locked staking contract
882         @param _amount uint
883      */
884     function giveLockBonus(uint256 _amount) external {
885         require(msg.sender == locker);
886         totalBonus = totalBonus.add(_amount);
887         IERC20(sASG).safeTransfer(locker, _amount);
888     }
889 
890     /**
891         @notice reclaim bonus from locked staking contract
892         @param _amount uint
893      */
894     function returnLockBonus(uint256 _amount) external {
895         require(msg.sender == locker);
896         totalBonus = totalBonus.sub(_amount);
897         IERC20(sASG).safeTransferFrom(locker, address(this), _amount);
898     }
899 
900     // enum CONTRACTS {
901     //     DISTRIBUTOR,
902     //     WARMUP,
903     //     LOCKER
904     // }
905 
906     enum CONTRACTS { DISTRIBUTOR, WARMUP, LOCKER }
907 
908     /**
909         @notice sets the contract address for LP staking
910         @param _contract address
911      */
912     function setContract( CONTRACTS _contract, address _address ) external onlyManager() {
913         if( _contract == CONTRACTS.DISTRIBUTOR ) { // 0
914             distributor = _address;
915         } else if ( _contract == CONTRACTS.WARMUP ) { // 1
916             require( warmupContract == address( 0 ), "Warmup cannot be set more than once" );
917             warmupContract = _address;
918         } else if ( _contract == CONTRACTS.LOCKER ) { // 2
919             require( locker == address(0), "Locker cannot be set more than once" );
920             locker = _address;
921         }
922     }
923 
924     /**
925      * @notice set warmup period for new stakers
926      * @param _warmupPeriod uint
927      */
928     function setWarmup(uint256 _warmupPeriod) external onlyManager {
929         warmupPeriod = _warmupPeriod;
930     }
931 }