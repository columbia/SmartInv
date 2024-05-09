1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      *
13      * - Addition cannot overflow.
14      */
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21 
22     /**
23      * @dev Returns the subtraction of two unsigned integers, reverting on
24      * overflow (when the result is negative).
25      *
26      * Counterpart to Solidity's `-` operator.
27      *
28      * Requirements:
29      *
30      * - Subtraction cannot overflow.
31      */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `*` operator.
58      *
59      * Requirements:
60      *
61      * - Multiplication cannot overflow.
62      */
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the integer division of two unsigned integers. Reverts on
79      * division by zero. The result is rounded towards zero.
80      *
81      * Counterpart to Solidity's `/` operator. Note: this function uses a
82      * `revert` opcode (which leaves remaining gas untouched) while Solidity
83      * uses an invalid opcode to revert (consuming all remaining gas).
84      *
85      * Requirements:
86      *
87      * - The divisor cannot be zero.
88      */
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         return div(a, b, "SafeMath: division by zero");
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
106         require(b > 0, errorMessage);
107         uint256 c = a / b;
108         assert(a == b * c + a % b); // There is no case in which this doesn't hold
109 
110         return c;
111     }
112 }
113 
114 interface IERC20 {
115     function decimals() external view returns (uint8);
116   /**
117    * @dev Returns the amount of tokens in existence.
118    */
119   function totalSupply() external view returns (uint256);
120 
121   /**
122    * @dev Returns the amount of tokens owned by `account`.
123    */
124   function balanceOf(address account) external view returns (uint256);
125 
126   /**
127    * @dev Moves `amount` tokens from the caller's account to `recipient`.
128    *
129    * Returns a boolean value indicating whether the operation succeeded.
130    *
131    * Emits a {Transfer} event.
132    */
133   function transfer(address recipient, uint256 amount) external returns (bool);
134 
135   /**
136    * @dev Returns the remaining number of tokens that `spender` will be
137    * allowed to spend on behalf of `owner` through {transferFrom}. This is
138    * zero by default.
139    *
140    * This value changes when {approve} or {transferFrom} are called.
141    */
142   function allowance(address owner, address spender) external view returns (uint256);
143 
144   /**
145    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
146    *
147    * Returns a boolean value indicating whether the operation succeeded.
148    *
149    * IMPORTANT: Beware that changing an allowance with this method brings the risk
150    * that someone may use both the old and the new allowance by unfortunate
151    * transaction ordering. One possible solution to mitigate this race
152    * condition is to first reduce the spender's allowance to 0 and set the
153    * desired value afterwards:
154    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155    *
156    * Emits an {Approval} event.
157    */
158   function approve(address spender, uint256 amount) external returns (bool);
159 
160   /**
161    * @dev Moves `amount` tokens from `sender` to `recipient` using the
162    * allowance mechanism. `amount` is then deducted from the caller's
163    * allowance.
164    *
165    * Returns a boolean value indicating whether the operation succeeded.
166    *
167    * Emits a {Transfer} event.
168    */
169   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
170 
171   /**
172    * @dev Emitted when `value` tokens are moved from one account (`from`) to
173    * another (`to`).
174    *
175    * Note that `value` may be zero.
176    */
177   event Transfer(address indexed from, address indexed to, uint256 value);
178 
179   /**
180    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
181    * a call to {approve}. `value` is the new allowance.
182    */
183   event Approval(address indexed owner, address indexed spender, uint256 value);
184 }
185 
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * [IMPORTANT]
191      * ====
192      * It is unsafe to assume that an address for which this function returns
193      * false is an externally-owned account (EOA) and not a contract.
194      *
195      * Among others, `isContract` will return false for the following
196      * types of addresses:
197      *
198      *  - an externally-owned account
199      *  - a contract in construction
200      *  - an address where a contract will be created
201      *  - an address where a contract lived, but was destroyed
202      * ====
203      */
204     function isContract(address account) internal view returns (bool) {
205         // This method relies in extcodesize, which returns 0 for contracts in
206         // construction, since the code is only stored at the end of the
207         // constructor execution.
208 
209         uint256 size;
210         // solhint-disable-next-line no-inline-assembly
211         assembly { size := extcodesize(account) }
212         return size > 0;
213     }
214 
215     /**
216      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
217      * `recipient`, forwarding all available gas and reverting on errors.
218      *
219      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
220      * of certain opcodes, possibly making contracts go over the 2300 gas limit
221      * imposed by `transfer`, making them unable to receive funds via
222      * `transfer`. {sendValue} removes this limitation.
223      *
224      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
225      *
226      * IMPORTANT: because control is transferred to `recipient`, care must be
227      * taken to not create reentrancy vulnerabilities. Consider using
228      * {ReentrancyGuard} or the
229      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
230      */
231     function sendValue(address payable recipient, uint256 amount) internal {
232         require(address(this).balance >= amount, "Address: insufficient balance");
233 
234         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
235         (bool success, ) = recipient.call{ value: amount }("");
236         require(success, "Address: unable to send value, recipient may have reverted");
237     }
238 
239     /**
240      * @dev Performs a Solidity function call using a low level `call`. A
241      * plain`call` is an unsafe replacement for a function call: use this
242      * function instead.
243      *
244      * If `target` reverts with a revert reason, it is bubbled up by this
245      * function (like regular Solidity function calls).
246      *
247      * Returns the raw returned data. To convert to the expected return value,
248      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
249      *
250      * Requirements:
251      *
252      * - `target` must be a contract.
253      * - calling `target` with `data` must not revert.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
258       return functionCall(target, data, "Address: low-level call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
263      * `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
268         return _functionCallWithValue(target, data, 0, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but also transferring `value` wei to `target`.
274      *
275      * Requirements:
276      *
277      * - the calling contract must have an ETH balance of at least `value`.
278      * - the called Solidity function must be `payable`.
279      *
280      * _Available since v3.1._
281      */
282     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
288      * with `errorMessage` as a fallback revert reason when `target` reverts.
289      *
290      * _Available since v3.1._
291      */
292     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
293         require(address(this).balance >= value, "Address: insufficient balance for call");
294         require(isContract(target), "Address: call to non-contract");
295 
296         // solhint-disable-next-line avoid-low-level-calls
297         (bool success, bytes memory returndata) = target.call{ value: value }(data);
298         return _verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
302         require(isContract(target), "Address: call to non-contract");
303 
304         // solhint-disable-next-line avoid-low-level-calls
305         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
306         if (success) {
307             return returndata;
308         } else {
309             // Look for revert reason and bubble it up if present
310             if (returndata.length > 0) {
311                 // The easiest way to bubble the revert reason is using memory via assembly
312 
313                 // solhint-disable-next-line no-inline-assembly
314                 assembly {
315                     let returndata_size := mload(returndata)
316                     revert(add(32, returndata), returndata_size)
317                 }
318             } else {
319                 revert(errorMessage);
320             }
321         }
322     }
323 
324   /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
331         return functionStaticCall(target, data, "Address: low-level static call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
341         require(isContract(target), "Address: static call to non-contract");
342 
343         // solhint-disable-next-line avoid-low-level-calls
344         (bool success, bytes memory returndata) = target.staticcall(data);
345         return _verifyCallResult(success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but performing a delegate call.
351      *
352      * _Available since v3.3._
353      */
354     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
355         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
360      * but performing a delegate call.
361      *
362      * _Available since v3.3._
363      */
364     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
365         require(isContract(target), "Address: delegate call to non-contract");
366 
367         // solhint-disable-next-line avoid-low-level-calls
368         (bool success, bytes memory returndata) = target.delegatecall(data);
369         return _verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
373         if (success) {
374             return returndata;
375         } else {
376             // Look for revert reason and bubble it up if present
377             if (returndata.length > 0) {
378                 // The easiest way to bubble the revert reason is using memory via assembly
379 
380                 // solhint-disable-next-line no-inline-assembly
381                 assembly {
382                     let returndata_size := mload(returndata)
383                     revert(add(32, returndata), returndata_size)
384                 }
385             } else {
386                 revert(errorMessage);
387             }
388         }
389     }
390 
391     function addressToString(address _address) internal pure returns(string memory) {
392         bytes32 _bytes = bytes32(uint256(_address));
393         bytes memory HEX = "0123456789abcdef";
394         bytes memory _addr = new bytes(42);
395 
396         _addr[0] = '0';
397         _addr[1] = 'x';
398 
399         for(uint256 i = 0; i < 20; i++) {
400             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
401             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
402         }
403 
404         return string(_addr);
405 
406     }
407 }
408 
409 library SafeERC20 {
410     using SafeMath for uint256;
411     using Address for address;
412 
413     function safeTransfer(IERC20 token, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
415     }
416 
417     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
418         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
419     }
420 
421     /**
422      * @dev Deprecated. This function has issues similar to the ones found in
423      * {IERC20-approve}, and its usage is discouraged.
424      *
425      * Whenever possible, use {safeIncreaseAllowance} and
426      * {safeDecreaseAllowance} instead.
427      */
428     function safeApprove(IERC20 token, address spender, uint256 value) internal {
429         // safeApprove should only be called when setting an initial allowance,
430         // or when resetting it to zero. To increase and decrease it, use
431         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
432         // solhint-disable-next-line max-line-length
433         require((value == 0) || (token.allowance(address(this), spender) == 0),
434             "SafeERC20: approve from non-zero to non-zero allowance"
435         );
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
437     }
438 
439     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
440         uint256 newAllowance = token.allowance(address(this), spender).add(value);
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
445         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
446         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
447     }
448 
449     /**
450      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
451      * on the return value: the return value is optional (but if data is returned, it must not be false).
452      * @param token The token targeted by the call.
453      * @param data The call data (encoded using abi.encode or one of its variants).
454      */
455     function _callOptionalReturn(IERC20 token, bytes memory data) private {
456         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
457         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
458         // the target address contains contract code and also asserts for success in the low-level call.
459 
460         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
461         if (returndata.length > 0) { // Return data is optional
462             // solhint-disable-next-line max-line-length
463             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
464         }
465     }
466 }
467 
468 interface IOwnable {
469   function manager() external view returns (address);
470 
471   function renounceManagement() external;
472   
473   function pushManagement( address newOwner_ ) external;
474   
475   function pullManagement() external;
476 }
477 
478 contract Ownable is IOwnable {
479 
480     address internal _owner;
481     address internal _newOwner;
482 
483     event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
484     event OwnershipPulled(address indexed previousOwner, address indexed newOwner);
485 
486     constructor () {
487         _owner = msg.sender;
488         emit OwnershipPushed( address(0), _owner );
489     }
490 
491     function manager() public view override returns (address) {
492         return _owner;
493     }
494 
495     modifier onlyManager() {
496         require( _owner == msg.sender, "Ownable: caller is not the owner" );
497         _;
498     }
499 
500     function renounceManagement() public virtual override onlyManager() {
501         emit OwnershipPushed( _owner, address(0) );
502         _owner = address(0);
503     }
504 
505     function pushManagement( address newOwner_ ) public virtual override onlyManager() {
506         require( newOwner_ != address(0), "Ownable: new owner is the zero address");
507         emit OwnershipPushed( _owner, newOwner_ );
508         _newOwner = newOwner_;
509     }
510     
511     function pullManagement() public virtual override {
512         require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
513         emit OwnershipPulled( _owner, _newOwner );
514         _owner = _newOwner;
515     }
516 }
517 
518 interface IsOHM {
519     function rebase( uint256 ohmProfit_, uint epoch_) external returns (uint256);
520 
521     function circulatingSupply() external view returns (uint256);
522 
523     function balanceOf(address who) external view returns (uint256);
524 
525     function gonsForBalance( uint amount ) external view returns ( uint );
526 
527     function balanceForGons( uint gons ) external view returns ( uint );
528     
529     function index() external view returns ( uint );
530 }
531 
532 interface IWarmup {
533     function retrieve( address staker_, uint amount_ ) external;
534 }
535 
536 interface IDistributor {
537     function distribute() external returns ( bool );
538 }
539 
540 contract OlympusStaking is Ownable {
541 
542     using SafeMath for uint256;
543     using SafeERC20 for IERC20;
544 
545     address public immutable OHM;
546     address public immutable sOHM;
547 
548     struct Epoch {
549         uint length;
550         uint number;
551         uint endBlock;
552         uint distribute;
553     }
554     Epoch public epoch;
555 
556     address public distributor;
557     
558     address public locker;
559     uint public totalBonus;
560     
561     address public warmupContract;
562     uint public warmupPeriod;
563     
564     constructor ( 
565         address _OHM, 
566         address _sOHM, 
567         uint _epochLength,
568         uint _firstEpochNumber,
569         uint _firstEpochBlock
570     ) {
571         require( _OHM != address(0) );
572         OHM = _OHM;
573         require( _sOHM != address(0) );
574         sOHM = _sOHM;
575         
576         epoch = Epoch({
577             length: _epochLength,
578             number: _firstEpochNumber,
579             endBlock: _firstEpochBlock,
580             distribute: 0
581         });
582     }
583 
584     struct Claim {
585         uint deposit;
586         uint gons;
587         uint expiry;
588         bool lock; // prevents malicious delays
589     }
590     mapping( address => Claim ) public warmupInfo;
591 
592     /**
593         @notice stake OHM to enter warmup
594         @param _amount uint
595         @return bool
596      */
597     function stake( uint _amount, address _recipient ) external returns ( bool ) {
598         rebase();
599         
600         IERC20( OHM ).safeTransferFrom( msg.sender, address(this), _amount );
601 
602         Claim memory info = warmupInfo[ _recipient ];
603         require( !info.lock, "Deposits for account are locked" );
604 
605         warmupInfo[ _recipient ] = Claim ({
606             deposit: info.deposit.add( _amount ),
607             gons: info.gons.add( IsOHM( sOHM ).gonsForBalance( _amount ) ),
608             expiry: epoch.number.add( warmupPeriod ),
609             lock: false
610         });
611         
612         IERC20( sOHM ).safeTransfer( warmupContract, _amount );
613         return true;
614     }
615 
616     /**
617         @notice retrieve sOHM from warmup
618         @param _recipient address
619      */
620     function claim ( address _recipient ) public {
621         Claim memory info = warmupInfo[ _recipient ];
622         if ( epoch.number >= info.expiry && info.expiry != 0 ) {
623             delete warmupInfo[ _recipient ];
624             IWarmup( warmupContract ).retrieve( _recipient, IsOHM( sOHM ).balanceForGons( info.gons ) );
625         }
626     }
627 
628     /**
629         @notice forfeit sOHM in warmup and retrieve OHM
630      */
631     function forfeit() external {
632         Claim memory info = warmupInfo[ msg.sender ];
633         delete warmupInfo[ msg.sender ];
634 
635         IWarmup( warmupContract ).retrieve( address(this), IsOHM( sOHM ).balanceForGons( info.gons ) );
636         IERC20( OHM ).safeTransfer( msg.sender, info.deposit );
637     }
638 
639     /**
640         @notice prevent new deposits to address (protection from malicious activity)
641      */
642     function toggleDepositLock() external {
643         warmupInfo[ msg.sender ].lock = !warmupInfo[ msg.sender ].lock;
644     }
645 
646     /**
647         @notice redeem sOHM for OHM
648         @param _amount uint
649         @param _trigger bool
650      */
651     function unstake( uint _amount, bool _trigger ) external {
652         if ( _trigger ) {
653             rebase();
654         }
655         IERC20( sOHM ).safeTransferFrom( msg.sender, address(this), _amount );
656         IERC20( OHM ).safeTransfer( msg.sender, _amount );
657     }
658 
659     /**
660         @notice returns the sOHM index, which tracks rebase growth
661         @return uint
662      */
663     function index() public view returns ( uint ) {
664         return IsOHM( sOHM ).index();
665     }
666 
667     /**
668         @notice trigger rebase if epoch over
669      */
670     function rebase() public {
671         if( epoch.endBlock <= block.number ) {
672 
673             IsOHM( sOHM ).rebase( epoch.distribute, epoch.number );
674 
675             epoch.endBlock = epoch.endBlock.add( epoch.length );
676             epoch.number++;
677             
678             if ( distributor != address(0) ) {
679                 IDistributor( distributor ).distribute();
680             }
681 
682             uint balance = contractBalance();
683             uint staked = IsOHM( sOHM ).circulatingSupply();
684 
685             if( balance <= staked ) {
686                 epoch.distribute = 0;
687             } else {
688                 epoch.distribute = balance.sub( staked );
689             }
690         }
691     }
692 
693     /**
694         @notice returns contract OHM holdings, including bonuses provided
695         @return uint
696      */
697     function contractBalance() public view returns ( uint ) {
698         return IERC20( OHM ).balanceOf( address(this) ).add( totalBonus );
699     }
700 
701     /**
702         @notice provide bonus to locked staking contract
703         @param _amount uint
704      */
705     function giveLockBonus( uint _amount ) external {
706         require( msg.sender == locker );
707         totalBonus = totalBonus.add( _amount );
708         IERC20( sOHM ).safeTransfer( locker, _amount );
709     }
710 
711     /**
712         @notice reclaim bonus from locked staking contract
713         @param _amount uint
714      */
715     function returnLockBonus( uint _amount ) external {
716         require( msg.sender == locker );
717         totalBonus = totalBonus.sub( _amount );
718         IERC20( sOHM ).safeTransferFrom( locker, address(this), _amount );
719     }
720 
721     enum CONTRACTS { DISTRIBUTOR, WARMUP, LOCKER }
722 
723     /**
724         @notice sets the contract address for LP staking
725         @param _contract address
726      */
727     function setContract( CONTRACTS _contract, address _address ) external onlyManager() {
728         if( _contract == CONTRACTS.DISTRIBUTOR ) { // 0
729             distributor = _address;
730         } else if ( _contract == CONTRACTS.WARMUP ) { // 1
731             require( warmupContract == address( 0 ), "Warmup cannot be set more than once" );
732             warmupContract = _address;
733         } else if ( _contract == CONTRACTS.LOCKER ) { // 2
734             require( locker == address(0), "Locker cannot be set more than once" );
735             locker = _address;
736         }
737     }
738     
739     /**
740      * @notice set warmup period for new stakers
741      * @param _warmupPeriod uint
742      */
743     function setWarmup( uint _warmupPeriod ) external onlyManager() {
744         warmupPeriod = _warmupPeriod;
745     }
746 }