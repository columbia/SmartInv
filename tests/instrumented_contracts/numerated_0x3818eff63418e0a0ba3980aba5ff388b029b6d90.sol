1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 library SafeMath {
5   /**
6    * @dev Returns the addition of two unsigned integers, reverting on
7    * overflow.
8    *
9    * Counterpart to Solidity's `+` operator.
10    *
11    * Requirements:
12    *
13    * - Addition cannot overflow.
14    */
15   function add(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a + b;
17     require(c >= a, "SafeMath: addition overflow");
18 
19     return c;
20   }
21 
22   /**
23    * @dev Returns the subtraction of two unsigned integers, reverting on
24    * overflow (when the result is negative).
25    *
26    * Counterpart to Solidity's `-` operator.
27    *
28    * Requirements:
29    *
30    * - Subtraction cannot overflow.
31    */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     return sub(a, b, "SafeMath: subtraction overflow");
34   }
35 
36   /**
37    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
38    * overflow (when the result is negative).
39    *
40    * Counterpart to Solidity's `-` operator.
41    *
42    * Requirements:
43    *
44    * - Subtraction cannot overflow.
45    */
46   function sub(
47     uint256 a,
48     uint256 b,
49     string memory errorMessage
50   ) internal pure returns (uint256) {
51     require(b <= a, errorMessage);
52     uint256 c = a - b;
53 
54     return c;
55   }
56 
57   /**
58    * @dev Returns the multiplication of two unsigned integers, reverting on
59    * overflow.
60    *
61    * Counterpart to Solidity's `*` operator.
62    *
63    * Requirements:
64    *
65    * - Multiplication cannot overflow.
66    */
67   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
69     // benefit is lost if 'b' is also tested.
70     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
71     if (a == 0) {
72       return 0;
73     }
74 
75     uint256 c = a * b;
76     require(c / a == b, "SafeMath: multiplication overflow");
77 
78     return c;
79   }
80 
81   /**
82    * @dev Returns the integer division of two unsigned integers. Reverts on
83    * division by zero. The result is rounded towards zero.
84    *
85    * Counterpart to Solidity's `/` operator. Note: this function uses a
86    * `revert` opcode (which leaves remaining gas untouched) while Solidity
87    * uses an invalid opcode to revert (consuming all remaining gas).
88    *
89    * Requirements:
90    *
91    * - The divisor cannot be zero.
92    */
93   function div(uint256 a, uint256 b) internal pure returns (uint256) {
94     return div(a, b, "SafeMath: division by zero");
95   }
96 
97   /**
98    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
99    * division by zero. The result is rounded towards zero.
100    *
101    * Counterpart to Solidity's `/` operator. Note: this function uses a
102    * `revert` opcode (which leaves remaining gas untouched) while Solidity
103    * uses an invalid opcode to revert (consuming all remaining gas).
104    *
105    * Requirements:
106    *
107    * - The divisor cannot be zero.
108    */
109   function div(
110     uint256 a,
111     uint256 b,
112     string memory errorMessage
113   ) internal pure returns (uint256) {
114     require(b > 0, errorMessage);
115     uint256 c = a / b;
116     assert(a == b * c + (a % b)); // There is no case in which this doesn't hold
117 
118     return c;
119   }
120 }
121 
122 interface IERC20 {
123   function decimals() external view returns (uint8);
124 
125   /**
126    * @dev Returns the amount of tokens in existence.
127    */
128   function totalSupply() external view returns (uint256);
129 
130   /**
131    * @dev Returns the amount of tokens owned by `account`.
132    */
133   function balanceOf(address account) external view returns (uint256);
134 
135   /**
136    * @dev Moves `amount` tokens from the caller's account to `recipient`.
137    *
138    * Returns a boolean value indicating whether the operation succeeded.
139    *
140    * Emits a {Transfer} event.
141    */
142   function transfer(address recipient, uint256 amount) external returns (bool);
143 
144   /**
145    * @dev Returns the remaining number of tokens that `spender` will be
146    * allowed to spend on behalf of `owner` through {transferFrom}. This is
147    * zero by default.
148    *
149    * This value changes when {approve} or {transferFrom} are called.
150    */
151   function allowance(address owner, address spender)
152     external
153     view
154     returns (uint256);
155 
156   /**
157    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
158    *
159    * Returns a boolean value indicating whether the operation succeeded.
160    *
161    * IMPORTANT: Beware that changing an allowance with this method brings the risk
162    * that someone may use both the old and the new allowance by unfortunate
163    * transaction ordering. One possible solution to mitigate this race
164    * condition is to first reduce the spender's allowance to 0 and set the
165    * desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    *
168    * Emits an {Approval} event.
169    */
170   function approve(address spender, uint256 amount) external returns (bool);
171 
172   /**
173    * @dev Moves `amount` tokens from `sender` to `recipient` using the
174    * allowance mechanism. `amount` is then deducted from the caller's
175    * allowance.
176    *
177    * Returns a boolean value indicating whether the operation succeeded.
178    *
179    * Emits a {Transfer} event.
180    */
181   function transferFrom(
182     address sender,
183     address recipient,
184     uint256 amount
185   ) external returns (bool);
186 
187   /**
188    * @dev Emitted when `value` tokens are moved from one account (`from`) to
189    * another (`to`).
190    *
191    * Note that `value` may be zero.
192    */
193   event Transfer(address indexed from, address indexed to, uint256 value);
194 
195   /**
196    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
197    * a call to {approve}. `value` is the new allowance.
198    */
199   event Approval(address indexed owner, address indexed spender, uint256 value);
200 }
201 
202 library Address {
203   /**
204    * @dev Returns true if `account` is a contract.
205    *
206    * [IMPORTANT]
207    * ====
208    * It is unsafe to assume that an address for which this function returns
209    * false is an externally-owned account (EOA) and not a contract.
210    *
211    * Among others, `isContract` will return false for the following
212    * types of addresses:
213    *
214    *  - an externally-owned account
215    *  - a contract in construction
216    *  - an address where a contract will be created
217    *  - an address where a contract lived, but was destroyed
218    * ====
219    */
220   function isContract(address account) internal view returns (bool) {
221     // This method relies in extcodesize, which returns 0 for contracts in
222     // construction, since the code is only stored at the end of the
223     // constructor execution.
224 
225     uint256 size;
226     // solhint-disable-next-line no-inline-assembly
227     assembly {
228       size := extcodesize(account)
229     }
230     return size > 0;
231   }
232 
233   /**
234    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
235    * `recipient`, forwarding all available gas and reverting on errors.
236    *
237    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
238    * of certain opcodes, possibly making contracts go over the 2300 gas limit
239    * imposed by `transfer`, making them unable to receive funds via
240    * `transfer`. {sendValue} removes this limitation.
241    *
242    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
243    *
244    * IMPORTANT: because control is transferred to `recipient`, care must be
245    * taken to not create reentrancy vulnerabilities. Consider using
246    * {ReentrancyGuard} or the
247    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
248    */
249   function sendValue(address payable recipient, uint256 amount) internal {
250     require(address(this).balance >= amount, "Address: insufficient balance");
251 
252     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
253     (bool success, ) = recipient.call{value: amount}("");
254     require(
255       success,
256       "Address: unable to send value, recipient may have reverted"
257     );
258   }
259 
260   /**
261    * @dev Performs a Solidity function call using a low level `call`. A
262    * plain`call` is an unsafe replacement for a function call: use this
263    * function instead.
264    *
265    * If `target` reverts with a revert reason, it is bubbled up by this
266    * function (like regular Solidity function calls).
267    *
268    * Returns the raw returned data. To convert to the expected return value,
269    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
270    *
271    * Requirements:
272    *
273    * - `target` must be a contract.
274    * - calling `target` with `data` must not revert.
275    *
276    * _Available since v3.1._
277    */
278   function functionCall(address target, bytes memory data)
279     internal
280     returns (bytes memory)
281   {
282     return functionCall(target, data, "Address: low-level call failed");
283   }
284 
285   /**
286    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
287    * `errorMessage` as a fallback revert reason when `target` reverts.
288    *
289    * _Available since v3.1._
290    */
291   function functionCall(
292     address target,
293     bytes memory data,
294     string memory errorMessage
295   ) internal returns (bytes memory) {
296     return _functionCallWithValue(target, data, 0, errorMessage);
297   }
298 
299   /**
300    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
301    * but also transferring `value` wei to `target`.
302    *
303    * Requirements:
304    *
305    * - the calling contract must have an ETH balance of at least `value`.
306    * - the called Solidity function must be `payable`.
307    *
308    * _Available since v3.1._
309    */
310   function functionCallWithValue(
311     address target,
312     bytes memory data,
313     uint256 value
314   ) internal returns (bytes memory) {
315     return
316       functionCallWithValue(
317         target,
318         data,
319         value,
320         "Address: low-level call with value failed"
321       );
322   }
323 
324   /**
325    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
326    * with `errorMessage` as a fallback revert reason when `target` reverts.
327    *
328    * _Available since v3.1._
329    */
330   function functionCallWithValue(
331     address target,
332     bytes memory data,
333     uint256 value,
334     string memory errorMessage
335   ) internal returns (bytes memory) {
336     require(
337       address(this).balance >= value,
338       "Address: insufficient balance for call"
339     );
340     require(isContract(target), "Address: call to non-contract");
341 
342     // solhint-disable-next-line avoid-low-level-calls
343     (bool success, bytes memory returndata) = target.call{value: value}(data);
344     return _verifyCallResult(success, returndata, errorMessage);
345   }
346 
347   function _functionCallWithValue(
348     address target,
349     bytes memory data,
350     uint256 weiValue,
351     string memory errorMessage
352   ) private returns (bytes memory) {
353     require(isContract(target), "Address: call to non-contract");
354 
355     // solhint-disable-next-line avoid-low-level-calls
356     (bool success, bytes memory returndata) = target.call{value: weiValue}(
357       data
358     );
359     if (success) {
360       return returndata;
361     } else {
362       // Look for revert reason and bubble it up if present
363       if (returndata.length > 0) {
364         // The easiest way to bubble the revert reason is using memory via assembly
365 
366         // solhint-disable-next-line no-inline-assembly
367         assembly {
368           let returndata_size := mload(returndata)
369           revert(add(32, returndata), returndata_size)
370         }
371       } else {
372         revert(errorMessage);
373       }
374     }
375   }
376 
377   /**
378    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379    * but performing a static call.
380    *
381    * _Available since v3.3._
382    */
383   function functionStaticCall(address target, bytes memory data)
384     internal
385     view
386     returns (bytes memory)
387   {
388     return
389       functionStaticCall(target, data, "Address: low-level static call failed");
390   }
391 
392   /**
393    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394    * but performing a static call.
395    *
396    * _Available since v3.3._
397    */
398   function functionStaticCall(
399     address target,
400     bytes memory data,
401     string memory errorMessage
402   ) internal view returns (bytes memory) {
403     require(isContract(target), "Address: static call to non-contract");
404 
405     // solhint-disable-next-line avoid-low-level-calls
406     (bool success, bytes memory returndata) = target.staticcall(data);
407     return _verifyCallResult(success, returndata, errorMessage);
408   }
409 
410   /**
411    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412    * but performing a delegate call.
413    *
414    * _Available since v3.3._
415    */
416   function functionDelegateCall(address target, bytes memory data)
417     internal
418     returns (bytes memory)
419   {
420     return
421       functionDelegateCall(
422         target,
423         data,
424         "Address: low-level delegate call failed"
425       );
426   }
427 
428   /**
429    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
430    * but performing a delegate call.
431    *
432    * _Available since v3.3._
433    */
434   function functionDelegateCall(
435     address target,
436     bytes memory data,
437     string memory errorMessage
438   ) internal returns (bytes memory) {
439     require(isContract(target), "Address: delegate call to non-contract");
440 
441     // solhint-disable-next-line avoid-low-level-calls
442     (bool success, bytes memory returndata) = target.delegatecall(data);
443     return _verifyCallResult(success, returndata, errorMessage);
444   }
445 
446   function _verifyCallResult(
447     bool success,
448     bytes memory returndata,
449     string memory errorMessage
450   ) private pure returns (bytes memory) {
451     if (success) {
452       return returndata;
453     } else {
454       // Look for revert reason and bubble it up if present
455       if (returndata.length > 0) {
456         // The easiest way to bubble the revert reason is using memory via assembly
457 
458         // solhint-disable-next-line no-inline-assembly
459         assembly {
460           let returndata_size := mload(returndata)
461           revert(add(32, returndata), returndata_size)
462         }
463       } else {
464         revert(errorMessage);
465       }
466     }
467   }
468 
469   function addressToString(address _address)
470     internal
471     pure
472     returns (string memory)
473   {
474     bytes32 _bytes = bytes32(uint256(_address));
475     bytes memory HEX = "0123456789abcdef";
476     bytes memory _addr = new bytes(42);
477 
478     _addr[0] = "0";
479     _addr[1] = "x";
480 
481     for (uint256 i = 0; i < 20; i++) {
482       _addr[2 + i * 2] = HEX[uint8(_bytes[i + 12] >> 4)];
483       _addr[3 + i * 2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
484     }
485 
486     return string(_addr);
487   }
488 }
489 
490 library SafeERC20 {
491   using SafeMath for uint256;
492   using Address for address;
493 
494   function safeTransfer(
495     IERC20 token,
496     address to,
497     uint256 value
498   ) internal {
499     _callOptionalReturn(
500       token,
501       abi.encodeWithSelector(token.transfer.selector, to, value)
502     );
503   }
504 
505   function safeTransferFrom(
506     IERC20 token,
507     address from,
508     address to,
509     uint256 value
510   ) internal {
511     _callOptionalReturn(
512       token,
513       abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
514     );
515   }
516 
517   /**
518    * @dev Deprecated. This function has issues similar to the ones found in
519    * {IERC20-approve}, and its usage is discouraged.
520    *
521    * Whenever possible, use {safeIncreaseAllowance} and
522    * {safeDecreaseAllowance} instead.
523    */
524   function safeApprove(
525     IERC20 token,
526     address spender,
527     uint256 value
528   ) internal {
529     // safeApprove should only be called when setting an initial allowance,
530     // or when resetting it to zero. To increase and decrease it, use
531     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
532     // solhint-disable-next-line max-line-length
533     require(
534       (value == 0) || (token.allowance(address(this), spender) == 0),
535       "SafeERC20: approve from non-zero to non-zero allowance"
536     );
537     _callOptionalReturn(
538       token,
539       abi.encodeWithSelector(token.approve.selector, spender, value)
540     );
541   }
542 
543   function safeIncreaseAllowance(
544     IERC20 token,
545     address spender,
546     uint256 value
547   ) internal {
548     uint256 newAllowance = token.allowance(address(this), spender).add(value);
549     _callOptionalReturn(
550       token,
551       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
552     );
553   }
554 
555   function safeDecreaseAllowance(
556     IERC20 token,
557     address spender,
558     uint256 value
559   ) internal {
560     uint256 newAllowance = token.allowance(address(this), spender).sub(
561       value,
562       "SafeERC20: decreased allowance below zero"
563     );
564     _callOptionalReturn(
565       token,
566       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
567     );
568   }
569 
570   /**
571    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
572    * on the return value: the return value is optional (but if data is returned, it must not be false).
573    * @param token The token targeted by the call.
574    * @param data The call data (encoded using abi.encode or one of its variants).
575    */
576   function _callOptionalReturn(IERC20 token, bytes memory data) private {
577     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
578     // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
579     // the target address contains contract code and also asserts for success in the low-level call.
580 
581     bytes memory returndata = address(token).functionCall(
582       data,
583       "SafeERC20: low-level call failed"
584     );
585     if (returndata.length > 0) {
586       // Return data is optional
587       // solhint-disable-next-line max-line-length
588       require(
589         abi.decode(returndata, (bool)),
590         "SafeERC20: ERC20 operation did not succeed"
591       );
592     }
593   }
594 }
595 
596 interface IOwnable {
597   function manager() external view returns (address);
598 
599   function renounceManagement() external;
600 
601   function pushManagement(address newOwner_) external;
602 
603   function pullManagement() external;
604 }
605 
606 contract Ownable is IOwnable {
607   address internal _owner;
608   address internal _newOwner;
609 
610   event OwnershipPushed(
611     address indexed previousOwner,
612     address indexed newOwner
613   );
614   event OwnershipPulled(
615     address indexed previousOwner,
616     address indexed newOwner
617   );
618 
619   constructor() {
620     _owner = msg.sender;
621     emit OwnershipPushed(address(0), _owner);
622   }
623 
624   function manager() public view override returns (address) {
625     return _owner;
626   }
627 
628   modifier onlyManager() {
629     require(_owner == msg.sender, "Ownable: caller is not the owner");
630     _;
631   }
632 
633   function renounceManagement() public virtual override onlyManager {
634     emit OwnershipPushed(_owner, address(0));
635     _owner = address(0);
636   }
637 
638   function pushManagement(address newOwner_)
639     public
640     virtual
641     override
642     onlyManager
643   {
644     require(newOwner_ != address(0), "Ownable: new owner is the zero address");
645     emit OwnershipPushed(_owner, newOwner_);
646     _newOwner = newOwner_;
647   }
648 
649   function pullManagement() public virtual override {
650     require(msg.sender == _newOwner, "Ownable: must be new owner to pull");
651     emit OwnershipPulled(_owner, _newOwner);
652     _owner = _newOwner;
653   }
654 }
655 
656 interface IsLOBI {
657   function rebase(uint256 lobiProfit_, uint256 epoch_)
658     external
659     returns (uint256);
660 
661   function circulatingSupply() external view returns (uint256);
662 
663   function balanceOf(address who) external view returns (uint256);
664 
665   function gonsForBalance(uint256 amount) external view returns (uint256);
666 
667   function balanceForGons(uint256 gons) external view returns (uint256);
668 
669   function index() external view returns (uint256);
670 }
671 
672 interface IWarmup {
673   function retrieve(address staker_, uint256 amount_) external;
674 }
675 
676 interface IDistributor {
677   function distribute() external returns (bool);
678 }
679 
680 contract LobisStaking is Ownable {
681   using SafeMath for uint256;
682   using SafeERC20 for IERC20;
683 
684   address public immutable LOBI;
685   address public immutable sLOBI;
686 
687   struct Epoch {
688     uint256 length;
689     uint256 number;
690     uint256 endBlock;
691     uint256 distribute;
692   }
693   Epoch public epoch;
694 
695   address public distributor;
696 
697   address public locker;
698   uint256 public totalBonus;
699 
700   address public warmupContract;
701   uint256 public warmupPeriod;
702 
703   constructor(
704     address _LOBI,
705     address _sLOBI,
706     uint256 _epochLength,
707     uint256 _firstEpochNumber,
708     uint256 _firstEpochBlock
709   ) {
710     require(_LOBI != address(0));
711     LOBI = _LOBI;
712     require(_sLOBI != address(0));
713     sLOBI = _sLOBI;
714 
715     epoch = Epoch({
716       length: _epochLength,
717       number: _firstEpochNumber,
718       endBlock: _firstEpochBlock,
719       distribute: 0
720     });
721   }
722 
723   struct Claim {
724     uint256 deposit;
725     uint256 gons;
726     uint256 expiry;
727     bool lock; // prevents malicious delays
728   }
729   mapping(address => Claim) public warmupInfo;
730 
731   /**
732         @notice stake LOBI to enter warmup
733         @param _amount uint
734         @return bool
735      */
736   function stake(uint256 _amount, address _recipient) external returns (bool) {
737     rebase();
738 
739     IERC20(LOBI).safeTransferFrom(msg.sender, address(this), _amount);
740 
741     Claim memory info = warmupInfo[_recipient];
742     require(!info.lock, "Deposits for account are locked");
743 
744     warmupInfo[_recipient] = Claim({
745       deposit: info.deposit.add(_amount),
746       gons: info.gons.add(IsLOBI(sLOBI).gonsForBalance(_amount)),
747       expiry: epoch.number.add(warmupPeriod),
748       lock: false
749     });
750 
751     IERC20(sLOBI).safeTransfer(warmupContract, _amount);
752     return true;
753   }
754 
755   /**
756         @notice retrieve sLOBI from warmup
757         @param _recipient address
758      */
759   function claim(address _recipient) public {
760     Claim memory info = warmupInfo[_recipient];
761     if (epoch.number >= info.expiry && info.expiry != 0) {
762       delete warmupInfo[_recipient];
763       IWarmup(warmupContract).retrieve(
764         _recipient,
765         IsLOBI(sLOBI).balanceForGons(info.gons)
766       );
767     }
768   }
769 
770   /**
771         @notice forfeit sLOBI in warmup and retrieve LOBI
772      */
773   function forfeit() external {
774     Claim memory info = warmupInfo[msg.sender];
775     delete warmupInfo[msg.sender];
776 
777     IWarmup(warmupContract).retrieve(
778       address(this),
779       IsLOBI(sLOBI).balanceForGons(info.gons)
780     );
781     IERC20(LOBI).safeTransfer(msg.sender, info.deposit);
782   }
783 
784   /**
785         @notice prevent new deposits to address (protection from malicious activity)
786      */
787   function toggleDepositLock() external {
788     warmupInfo[msg.sender].lock = !warmupInfo[msg.sender].lock;
789   }
790 
791   /**
792         @notice redeem sLOBI for LOBI
793         @param _amount uint
794         @param _trigger bool
795      */
796   function unstake(uint256 _amount, bool _trigger) external {
797     if (_trigger) {
798       rebase();
799     }
800     IERC20(sLOBI).safeTransferFrom(msg.sender, address(this), _amount);
801     IERC20(LOBI).safeTransfer(msg.sender, _amount);
802   }
803 
804   /**
805         @notice returns the sLOBI index, which tracks rebase growth
806         @return uint
807      */
808   function index() public view returns (uint256) {
809     return IsLOBI(sLOBI).index();
810   }
811 
812   /**
813         @notice trigger rebase if epoch over
814      */
815   function rebase() public {
816     if (epoch.endBlock <= block.number) {
817       IsLOBI(sLOBI).rebase(epoch.distribute, epoch.number);
818 
819       epoch.endBlock = epoch.endBlock.add(epoch.length);
820       epoch.number++;
821 
822       if (distributor != address(0)) {
823         IDistributor(distributor).distribute();
824       }
825 
826       uint256 balance = contractBalance();
827       uint256 staked = IsLOBI(sLOBI).circulatingSupply();
828 
829       if (balance <= staked) {
830         epoch.distribute = 0;
831       } else {
832         epoch.distribute = balance.sub(staked);
833       }
834     }
835   }
836 
837   /**
838         @notice returns contract LOBI holdings, including bonuses provided
839         @return uint
840      */
841   function contractBalance() public view returns (uint256) {
842     return IERC20(LOBI).balanceOf(address(this)).add(totalBonus);
843   }
844 
845   /**
846         @notice provide bonus to locked staking contract
847         @param _amount uint
848      */
849   function giveLockBonus(uint256 _amount) external {
850     require(msg.sender == locker);
851     totalBonus = totalBonus.add(_amount);
852     IERC20(sLOBI).safeTransfer(locker, _amount);
853   }
854 
855   /**
856         @notice reclaim bonus from locked staking contract
857         @param _amount uint
858      */
859   function returnLockBonus(uint256 _amount) external {
860     require(msg.sender == locker);
861     totalBonus = totalBonus.sub(_amount);
862     IERC20(sLOBI).safeTransferFrom(locker, address(this), _amount);
863   }
864 
865   enum CONTRACTS {
866     DISTRIBUTOR,
867     WARMUP,
868     LOCKER
869   }
870 
871   /**
872         @notice sets the contract address for LP staking
873         @param _contract address
874      */
875   function setContract(CONTRACTS _contract, address _address)
876     external
877     onlyManager
878   {
879     if (_contract == CONTRACTS.DISTRIBUTOR) {
880       // 0
881       distributor = _address;
882     } else if (_contract == CONTRACTS.WARMUP) {
883       // 1
884       require(
885         warmupContract == address(0),
886         "Warmup cannot be set more than once"
887       );
888       warmupContract = _address;
889     } else if (_contract == CONTRACTS.LOCKER) {
890       // 2
891       require(locker == address(0), "Locker cannot be set more than once");
892       locker = _address;
893     }
894   }
895 
896   /**
897    * @notice set warmup period for new stakers
898    * @param _warmupPeriod uint
899    */
900   function setWarmup(uint256 _warmupPeriod) external onlyManager {
901     warmupPeriod = _warmupPeriod;
902   }
903 }