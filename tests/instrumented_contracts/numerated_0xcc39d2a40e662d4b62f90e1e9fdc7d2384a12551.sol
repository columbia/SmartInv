1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
3 pragma solidity ^0.8.7;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      *
26      * [IMPORTANT]
27      * ====
28      * You shouldn't rely on `isContract` to protect against flash loan attacks!
29      *
30      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
31      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
32      * constructor.
33      * ====
34      */
35     function isContract(address account) internal view returns (bool) {
36         // This method relies on extcodesize/address.code.length, which returns 0
37         // for contracts in construction, since the code is only stored at the end
38         // of the constructor execution.
39 
40         return account.code.length > 0;
41     }
42 
43     /**
44      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
45      * `recipient`, forwarding all available gas and reverting on errors.
46      *
47      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
48      * of certain opcodes, possibly making contracts go over the 2300 gas limit
49      * imposed by `transfer`, making them unable to receive funds via
50      * `transfer`. {sendValue} removes this limitation.
51      *
52      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
53      *
54      * IMPORTANT: because control is transferred to `recipient`, care must be
55      * taken to not create reentrancy vulnerabilities. Consider using
56      * {ReentrancyGuard} or the
57      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
58      */
59     function sendValue(address payable recipient, uint256 amount) internal {
60         require(
61             address(this).balance >= amount,
62             "Address: insufficient balance"
63         );
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(
67             success,
68             "Address: unable to send value, recipient may have reverted"
69         );
70     }
71 
72     /**
73      * @dev Performs a Solidity function call using a low level `call`. A
74      * plain `call` is an unsafe replacement for a function call: use this
75      * function instead.
76      *
77      * If `target` reverts with a revert reason, it is bubbled up by this
78      * function (like regular Solidity function calls).
79      *
80      * Returns the raw returned data. To convert to the expected return value,
81      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
82      *
83      * Requirements:
84      *
85      * - `target` must be a contract.
86      * - calling `target` with `data` must not revert.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data)
91         internal
92         returns (bytes memory)
93     {
94         return
95             functionCallWithValue(
96                 target,
97                 data,
98                 0,
99                 "Address: low-level call failed"
100             );
101     }
102 
103     /**
104      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
105      * `errorMessage` as a fallback revert reason when `target` reverts.
106      *
107      * _Available since v3.1._
108      */
109     function functionCall(
110         address target,
111         bytes memory data,
112         string memory errorMessage
113     ) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, 0, errorMessage);
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
119      * but also transferring `value` wei to `target`.
120      *
121      * Requirements:
122      *
123      * - the calling contract must have an ETH balance of at least `value`.
124      * - the called Solidity function must be `payable`.
125      *
126      * _Available since v3.1._
127      */
128     function functionCallWithValue(
129         address target,
130         bytes memory data,
131         uint256 value
132     ) internal returns (bytes memory) {
133         return
134             functionCallWithValue(
135                 target,
136                 data,
137                 value,
138                 "Address: low-level call with value failed"
139             );
140     }
141 
142     /**
143      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
144      * with `errorMessage` as a fallback revert reason when `target` reverts.
145      *
146      * _Available since v3.1._
147      */
148     function functionCallWithValue(
149         address target,
150         bytes memory data,
151         uint256 value,
152         string memory errorMessage
153     ) internal returns (bytes memory) {
154         require(
155             address(this).balance >= value,
156             "Address: insufficient balance for call"
157         );
158         (bool success, bytes memory returndata) = target.call{value: value}(
159             data
160         );
161         return
162             verifyCallResultFromTarget(
163                 target,
164                 success,
165                 returndata,
166                 errorMessage
167             );
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a static call.
173      *
174      * _Available since v3.3._
175      */
176     function functionStaticCall(address target, bytes memory data)
177         internal
178         view
179         returns (bytes memory)
180     {
181         return
182             functionStaticCall(
183                 target,
184                 data,
185                 "Address: low-level static call failed"
186             );
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
191      * but performing a static call.
192      *
193      * _Available since v3.3._
194      */
195     function functionStaticCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal view returns (bytes memory) {
200         (bool success, bytes memory returndata) = target.staticcall(data);
201         return
202             verifyCallResultFromTarget(
203                 target,
204                 success,
205                 returndata,
206                 errorMessage
207             );
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but performing a delegate call.
213      *
214      * _Available since v3.4._
215      */
216     function functionDelegateCall(address target, bytes memory data)
217         internal
218         returns (bytes memory)
219     {
220         return
221             functionDelegateCall(
222                 target,
223                 data,
224                 "Address: low-level delegate call failed"
225             );
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
230      * but performing a delegate call.
231      *
232      * _Available since v3.4._
233      */
234     function functionDelegateCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal returns (bytes memory) {
239         (bool success, bytes memory returndata) = target.delegatecall(data);
240         return
241             verifyCallResultFromTarget(
242                 target,
243                 success,
244                 returndata,
245                 errorMessage
246             );
247     }
248 
249     /**
250      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
251      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
252      *
253      * _Available since v4.8._
254      */
255     function verifyCallResultFromTarget(
256         address target,
257         bool success,
258         bytes memory returndata,
259         string memory errorMessage
260     ) internal view returns (bytes memory) {
261         if (success) {
262             if (returndata.length == 0) {
263                 // only check isContract if the call was successful and the return data is empty
264                 // otherwise we already know that it was a contract
265                 require(isContract(target), "Address: call to non-contract");
266             }
267             return returndata;
268         } else {
269             _revert(returndata, errorMessage);
270         }
271     }
272 
273     /**
274      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
275      * revert reason or using the provided one.
276      *
277      * _Available since v4.3._
278      */
279     function verifyCallResult(
280         bool success,
281         bytes memory returndata,
282         string memory errorMessage
283     ) internal pure returns (bytes memory) {
284         if (success) {
285             return returndata;
286         } else {
287             _revert(returndata, errorMessage);
288         }
289     }
290 
291     function _revert(bytes memory returndata, string memory errorMessage)
292         private
293         pure
294     {
295         // Look for revert reason and bubble it up if present
296         if (returndata.length > 0) {
297             // The easiest way to bubble the revert reason is using memory via assembly
298             /// @solidity memory-safe-assembly
299             assembly {
300                 let returndata_size := mload(returndata)
301                 revert(add(32, returndata), returndata_size)
302             }
303         } else {
304             revert(errorMessage);
305         }
306     }
307 }
308 
309 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @dev Provides information about the current execution context, including the
315  * sender of the transaction and its data. While these are generally available
316  * via msg.sender and msg.data, they should not be accessed in such a direct
317  * manner, since when dealing with meta-transactions the account sending and
318  * paying for execution may not be the actual sender (as far as an application
319  * is concerned).
320  *
321  * This contract is only required for intermediate, library-like contracts.
322  */
323 abstract contract Context {
324     function _msgSender() internal view virtual returns (address) {
325         return msg.sender;
326     }
327 
328     function _msgData() internal view virtual returns (bytes calldata) {
329         return msg.data;
330     }
331 }
332 
333 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
334 
335 /**
336  * @title Ownable
337  * @dev The Ownable contract has an owner address, and provides basic authorization control
338  * functions, this simplifies the implementation of "user permissions".
339  */
340 contract Ownable {
341     address private _owner;
342 
343     event OwnershipTransferred(
344         address indexed previousOwner,
345         address indexed newOwner
346     );
347 
348     /**
349      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
350      * account.
351      */
352     constructor() {
353         _owner = msg.sender;
354         emit OwnershipTransferred(address(0), _owner);
355     }
356 
357     /**
358      * @return the address of the owner.
359      */
360     function owner() public view returns (address) {
361         return _owner;
362     }
363 
364     /**
365      * @dev Throws if called by any account other than the owner.
366      */
367     modifier onlyOwner() {
368         require(isOwner());
369         _;
370     }
371 
372     /**
373      * @return true if `msg.sender` is the owner of the contract.
374      */
375     function isOwner() public view returns (bool) {
376         return msg.sender == _owner;
377     }
378 
379     /**
380      * @dev Allows the current owner to relinquish control of the contract.
381      * @notice Renouncing to ownership will leave the contract without an owner.
382      * It will not be possible to call the functions with the `onlyOwner`
383      * modifier anymore.
384      */
385     function renounceOwnership() public onlyOwner {
386         emit OwnershipTransferred(_owner, address(0));
387         _owner = address(0);
388     }
389 
390     /**
391      * @dev Allows the current owner to transfer control of the contract to a newOwner.
392      * @param newOwner The address to transfer ownership to.
393      */
394     function transferOwnership(address newOwner) public onlyOwner {
395         _transferOwnership(newOwner);
396     }
397 
398     /**
399      * @dev Transfers control of the contract to a newOwner.
400      * @param newOwner The address to transfer ownership to.
401      */
402     function _transferOwnership(address newOwner) internal {
403         require(newOwner != address(0));
404         emit OwnershipTransferred(_owner, newOwner);
405         _owner = newOwner;
406     }
407 }
408 
409 // File: @uniswap\lib\contracts\libraries\TransferHelper.sol
410 
411 pragma solidity >=0.6.0;
412 
413 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
414 library TransferHelper {
415     function safeApprove(
416         address token,
417         address to,
418         uint256 value
419     ) internal {
420         // bytes4(keccak256(bytes('approve(address,uint256)')));
421         (bool success, bytes memory data) = token.call(
422             abi.encodeWithSelector(0x095ea7b3, to, value)
423         );
424         require(
425             success && (data.length == 0 || abi.decode(data, (bool))),
426             "TransferHelper: APPROVE_FAILED"
427         );
428     }
429 
430     function safeTransfer(
431         address token,
432         address to,
433         uint256 value
434     ) internal {
435         // bytes4(keccak256(bytes('transfer(address,uint256)')));
436         (bool success, bytes memory data) = token.call(
437             abi.encodeWithSelector(0xa9059cbb, to, value)
438         );
439         require(
440             success && (data.length == 0 || abi.decode(data, (bool))),
441             "TransferHelper: TRANSFER_FAILED"
442         );
443     }
444 
445     function safeTransferFrom(
446         address token,
447         address from,
448         address to,
449         uint256 value
450     ) internal {
451         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
452         (bool success, bytes memory data) = token.call(
453             abi.encodeWithSelector(0x23b872dd, from, to, value)
454         );
455         require(
456             success && (data.length == 0 || abi.decode(data, (bool))),
457             "TransferHelper: TRANSFER_FROM_FAILED"
458         );
459     }
460 
461     function safeTransferETH(address to, uint256 value) internal {
462         (bool success, ) = to.call{value: value}(new bytes(0));
463         require(success, "TransferHelper: ETH_TRANSFER_FAILED");
464     }
465 }
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @dev Interface of the ERC20 standard as defined in the EIP.
471  */
472 interface IERC20 {
473     /**
474      * @dev Emitted when `value` tokens are moved from one account (`from`) to
475      * another (`to`).
476      *
477      * Note that `value` may be zero.
478      */
479     event Transfer(address indexed from, address indexed to, uint256 value);
480 
481     /**
482      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
483      * a call to {approve}. `value` is the new allowance.
484      */
485     event Approval(
486         address indexed owner,
487         address indexed spender,
488         uint256 value
489     );
490 
491     /**
492      * @dev Returns the amount of tokens in existence.
493      */
494     function totalSupply() external view returns (uint256);
495 
496     /**
497      * @dev Returns the amount of tokens owned by `account`.
498      */
499     function balanceOf(address account) external view returns (uint256);
500 
501     /**
502      * @dev Moves `amount` tokens from the caller's account to `to`.
503      *
504      * Returns a boolean value indicating whether the operation succeeded.
505      *
506      * Emits a {Transfer} event.
507      */
508     function transfer(address to, uint256 amount) external returns (bool);
509 
510     /**
511      * @dev Returns the remaining number of tokens that `spender` will be
512      * allowed to spend on behalf of `owner` through {transferFrom}. This is
513      * zero by default.
514      *
515      * This value changes when {approve} or {transferFrom} are called.
516      */
517     function allowance(address owner, address spender)
518         external
519         view
520         returns (uint256);
521 
522     /**
523      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
524      *
525      * Returns a boolean value indicating whether the operation succeeded.
526      *
527      * IMPORTANT: Beware that changing an allowance with this method brings the risk
528      * that someone may use both the old and the new allowance by unfortunate
529      * transaction ordering. One possible solution to mitigate this race
530      * condition is to first reduce the spender's allowance to 0 and set the
531      * desired value afterwards:
532      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
533      *
534      * Emits an {Approval} event.
535      */
536     function approve(address spender, uint256 amount) external returns (bool);
537 
538     /**
539      * @dev Moves `amount` tokens from `from` to `to` using the
540      * allowance mechanism. `amount` is then deducted from the caller's
541      * allowance.
542      *
543      * Returns a boolean value indicating whether the operation succeeded.
544      *
545      * Emits a {Transfer} event.
546      */
547     function transferFrom(
548         address from,
549         address to,
550         uint256 amount
551     ) external returns (bool);
552 }
553 
554 contract MStake is Ownable {
555     IERC20 public mCoin;
556     uint256 public maxIndex;
557     // time of detail
558     mapping(uint256 => TimeDetail) public timeOf;
559     // user stakes
560     mapping(address => StakeDetail[]) public userStakesOf;
561     // The total amount that the user has completed in each time
562     mapping(address => mapping(uint256 => uint256)) public userTimeFinishedOf;
563     // The total amount that the user staked in each time
564     mapping(address => mapping(uint256 => uint256)) public userTimeStakedOf;
565     uint256 constant TENTHOUSANDTH = 10000;
566     mapping(address => bool) public controllers;
567 
568     modifier onlyController() {
569         require(controllers[msg.sender]);
570         _;
571     }
572 
573     struct TimeDetail {
574         uint256 cycle;
575         uint256 min;
576         uint256 reward;
577         uint256 perCount;
578     }
579 
580     struct StakeDetail {
581         uint256 start;
582         uint256 end;
583         uint256 index;
584         uint256 amount;
585         uint256 autoIndex;
586         bool closed;
587     }
588 
589     // User stake event
590     event Stake(
591         address indexed addr,
592         uint256 indexed amount,
593         uint256 indexed index,
594         uint256 end
595     );
596 
597     // User withdrawal event
598     event Withdraw(
599         address indexed addr,
600         uint256 indexed amount,
601         uint256 indexed reward
602     );
603 
604     constructor(IERC20 _mCoin) {
605         mCoin = _mCoin;
606         controllers[msg.sender] = true;
607         timeOf[1] = TimeDetail(7776000, 1000 * 1e8, 2000, 0);
608         timeOf[2] = TimeDetail(7776000, 1000 * 1e8, 5000, 0);
609         timeOf[3] = TimeDetail(7776000, 1000 * 1e8, 5000, 0);
610         maxIndex = 3;
611     }
612 
613     function addController(address controller) external onlyOwner {
614         controllers[controller] = true;
615     }
616 
617     function removeController(address controller) external onlyOwner {
618         controllers[controller] = false;
619     }
620 
621     /**
622      *   pre the amount that can be pledged in each time
623      */
624     function preQuotaOfTimes(address _addr)
625         public
626         view
627         returns (uint256[] memory _result)
628     {
629         _result = new uint256[](maxIndex);
630         _result[0] = 0;
631         for (uint256 i = 2; i <= maxIndex; i++) {
632             _result[i - 1] =
633                 userTimeFinishedOf[_addr][i - 1] -
634                 userTimeStakedOf[_addr][i];
635         }
636     }
637 
638     function preTimes() public view returns (TimeDetail[] memory _result) {
639         _result = new TimeDetail[](maxIndex);
640         for (uint256 i = 1; i <= maxIndex; i++) {
641             _result[i - 1] = timeOf[i];
642         }
643     }
644 
645     function preTotal(address _addr)
646         public
647         view
648         returns (uint256[2] memory _result)
649     {
650         uint256 _stakingTotal;
651         uint256 _total;
652         for (uint256 i = 0; i < userStakesOf[_addr].length; i++) {
653             StakeDetail memory stakeDetail = userStakesOf[_addr][i];
654             if (stakeDetail.closed) continue;
655             _stakingTotal += stakeDetail.amount;
656         }
657         for (uint256 i = 0; i <= maxIndex; i++) {
658             _total += userTimeStakedOf[_addr][i];
659         }
660         _result[0] = _stakingTotal;
661         _result[1] = _total;
662     }
663 
664     function preTotalReward(address _addr, uint256 _index)
665         public
666         view
667         returns (uint256 _result)
668     {
669         for (uint256 i = 0; i < userStakesOf[_addr].length; i++) {
670             StakeDetail memory stakeDetail = userStakesOf[_addr][i];
671             if (stakeDetail.closed) continue;
672             if (_index == 0 && stakeDetail.index != 0) continue;
673 
674             if (stakeDetail.index == 0) {
675                 uint256 _cycle = 0;
676                 for (uint256 j = 1; j <= maxIndex; j++) {
677                     _cycle += timeOf[j].cycle;
678                     if (
679                         stakeDetail.start + _cycle < block.timestamp &&
680                         stakeDetail.autoIndex < j
681                     ) {
682                         _result +=
683                             (timeOf[j].reward * stakeDetail.amount) /
684                             TENTHOUSANDTH;
685                         if (j == maxIndex) _result += stakeDetail.amount;
686                     }
687                 }
688             } else if (stakeDetail.end < block.timestamp) {
689                 _result += stakeDetail.amount;
690                 _result +=
691                     (stakeDetail.amount * timeOf[stakeDetail.index].reward) /
692                     TENTHOUSANDTH;
693             }
694         }
695     }
696 
697     function userStakes(
698         address _addr,
699         uint256 _from,
700         uint256 _limit
701     ) public view returns (StakeDetail[] memory _result) {
702         if (_from == 0) _from = 1;
703         uint256 totalStakes = userStakesOf[_addr].length;
704         uint256 endIndex = _from - 1 + _limit;
705         if (totalStakes < endIndex) endIndex = totalStakes;
706         if (totalStakes == 0 || _from > endIndex) return new StakeDetail[](0);
707 
708         _result = new StakeDetail[](endIndex - _from + 1);
709 
710         for (uint256 i = _from - 1; i < endIndex; i++) {
711             _result[i + 1 - _from] = userStakesOf[_addr][totalStakes - i - 1];
712         }
713     }
714 
715     function setTime(uint256 _time, TimeDetail memory _detail)
716         public
717         onlyOwner
718     {
719         timeOf[_time] = _detail;
720     }
721 
722     function setToken(address _token)
723         public
724         onlyOwner
725     {
726         require(_token != address(0));
727         mCoin = IERC20(_token);
728     }
729 
730     function move(address _addr, uint256 _amount) public onlyController {
731         require(_addr != address(0) && _amount > 0);
732 
733         uint256 _cycle = 0;
734         for (uint256 i = 1; i <= maxIndex; i++) {
735             _cycle += timeOf[i].cycle;
736         }
737 
738         uint256 _end = block.timestamp + _cycle;
739         userStakesOf[_addr].push(
740             StakeDetail(block.timestamp, _end, 0, _amount, 0, false)
741         );
742 
743         userTimeStakedOf[_addr][0] += _amount;
744         emit Stake(_addr, _amount, 0, _end);
745     }
746 
747     function stake(uint256 _time, uint256 _amount) public {
748         TimeDetail memory timeDetail = timeOf[_time];
749         require(timeDetail.cycle > 0, "no current period.");
750         require(
751             _amount > 0 && _amount >= timeDetail.min,
752             "less than the minimum amount."
753         );
754         if (timeDetail.perCount > 0)
755             require(_amount % timeDetail.perCount == 0, "must be a multiple.");
756         if (_time > 1) {
757             require(
758                 userTimeFinishedOf[msg.sender][_time - 1] -
759                     userTimeStakedOf[msg.sender][_time] >=
760                     _amount,
761                 "greater than the principal of the previous period."
762             );
763         }
764 
765         TransferHelper.safeTransferFrom(
766             address(mCoin),
767             msg.sender,
768             address(this),
769             _amount
770         );
771 
772         uint256 _end = block.timestamp + timeDetail.cycle;
773         userStakesOf[msg.sender].push(
774             StakeDetail(block.timestamp, _end, _time, _amount, 0, false)
775         );
776         userTimeStakedOf[msg.sender][_time] += _amount;
777         emit Stake(msg.sender, _amount, _time, _end);
778     }
779 
780     // user withdraw
781     function userWithdraw(uint256 _index) public {
782         uint256 _totalAmount = 0;
783         uint256 _stake = 0;
784 
785         for (uint256 i = 0; i < userStakesOf[msg.sender].length; i++) {
786             StakeDetail memory stakeDetail = userStakesOf[msg.sender][i];
787             if (stakeDetail.closed) continue;
788             if (_index == 0 && stakeDetail.index != 0) continue;
789 
790             if (stakeDetail.index == 0) {
791                 uint256 cycle = 0;
792                 for (uint256 j = 1; j <= maxIndex; j++) {
793                     cycle += timeOf[j].cycle;
794                     if (
795                         stakeDetail.start + cycle < block.timestamp &&
796                         stakeDetail.autoIndex < j
797                     ) {
798                         _totalAmount +=
799                             (timeOf[j].reward * stakeDetail.amount) /
800                             TENTHOUSANDTH;
801                         if (j == maxIndex) {
802                             _totalAmount += stakeDetail.amount;
803                             _stake += stakeDetail.amount;
804                             userTimeFinishedOf[msg.sender][
805                                 stakeDetail.index
806                             ] += stakeDetail.amount;
807                             userStakesOf[msg.sender][i].closed = true;
808                         } else {
809                             userStakesOf[msg.sender][i].autoIndex = j;
810                         }
811                     }
812                 }
813             } else if (stakeDetail.end < block.timestamp) {
814                 _totalAmount += stakeDetail.amount;
815                 _stake += stakeDetail.amount;
816                 _totalAmount +=
817                     (stakeDetail.amount * timeOf[stakeDetail.index].reward) /
818                     TENTHOUSANDTH;
819                 userTimeFinishedOf[msg.sender][stakeDetail.index] += stakeDetail
820                     .amount;
821                 userStakesOf[msg.sender][i].closed = true;
822             }
823         }
824         require(_totalAmount > 0);
825         TransferHelper.safeTransfer(address(mCoin), msg.sender, _totalAmount);
826         emit Withdraw(msg.sender, _stake, _totalAmount - _stake);
827     }
828 
829     // withdraw
830     function withdraw(address _token, uint256 _amount) public onlyOwner {
831         if (_token == address(0)) {
832             payable(msg.sender).transfer(_amount);
833         } else {
834             uint256 balance = IERC20(_token).balanceOf(address(this));
835             require(balance >= _amount, "Insufficient contract assets!!!");
836             TransferHelper.safeTransfer(_token, msg.sender, _amount);
837         }
838     }
839 }