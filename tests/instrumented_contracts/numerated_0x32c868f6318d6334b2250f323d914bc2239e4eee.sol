1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal virtual view returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal virtual view returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // File: contracts/INerdBaseToken.sol
27 
28 pragma solidity 0.6.12;
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface INerdBaseToken {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount)
52         external
53         returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender)
63         external
64         view
65         returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(
111         address indexed owner,
112         address indexed spender,
113         uint256 value
114     );
115 
116     event Log(string log);
117 }
118 
119 interface INerdBaseTokenLGE is INerdBaseToken {
120     function getAllocatedLP(address _user) external view returns (uint256);
121 
122     function getLpReleaseStart() external view returns (uint256);
123 
124     function getTokenUniswapPair() external view returns (address);
125 
126     function getTotalLPTokensMinted() external view returns (uint256);
127 
128     function getReleasableLPTokensMinted() external view returns (uint256);
129 
130     function isLPGenerationCompleted() external view returns (bool);
131 
132     function tokenUniswapPair() external view returns (address);
133 
134     function getUniswapRouterV2() external view returns (address);
135 
136     function getUniswapFactory() external view returns (address);
137 
138     function devFundAddress() external view returns (address);
139 
140     function transferCheckerAddress() external view returns (address);
141 
142     function feeDistributor() external view returns (address);
143 }
144 
145 // File: @openzeppelin/contracts/math/SafeMath.sol
146 
147 pragma solidity ^0.6.0;
148 
149 /**
150  * @dev Wrappers over Solidity's arithmetic operations with added overflow
151  * checks.
152  *
153  * Arithmetic operations in Solidity wrap on overflow. This can easily result
154  * in bugs, because programmers usually assume that an overflow raises an
155  * error, which is the standard behavior in high level programming languages.
156  * `SafeMath` restores this intuition by reverting the transaction when an
157  * operation overflows.
158  *
159  * Using this library instead of the unchecked operations eliminates an entire
160  * class of bugs, so it's recommended to use it always.
161  */
162 library SafeMath {
163     /**
164      * @dev Returns the addition of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `+` operator.
168      *
169      * Requirements:
170      *
171      * - Addition cannot overflow.
172      */
173     function add(uint256 a, uint256 b) internal pure returns (uint256) {
174         uint256 c = a + b;
175         require(c >= a, "SafeMath: addition overflow");
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the subtraction of two unsigned integers, reverting on
182      * overflow (when the result is negative).
183      *
184      * Counterpart to Solidity's `-` operator.
185      *
186      * Requirements:
187      *
188      * - Subtraction cannot overflow.
189      */
190     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191         return sub(a, b, "SafeMath: subtraction overflow");
192     }
193 
194     /**
195      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
196      * overflow (when the result is negative).
197      *
198      * Counterpart to Solidity's `-` operator.
199      *
200      * Requirements:
201      *
202      * - Subtraction cannot overflow.
203      */
204     function sub(
205         uint256 a,
206         uint256 b,
207         string memory errorMessage
208     ) internal pure returns (uint256) {
209         require(b <= a, errorMessage);
210         uint256 c = a - b;
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `*` operator.
220      *
221      * Requirements:
222      *
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
227         // benefit is lost if 'b' is also tested.
228         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
229         if (a == 0) {
230             return 0;
231         }
232 
233         uint256 c = a * b;
234         require(c / a == b, "SafeMath: multiplication overflow");
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the integer division of two unsigned integers. Reverts on
241      * division by zero. The result is rounded towards zero.
242      *
243      * Counterpart to Solidity's `/` operator. Note: this function uses a
244      * `revert` opcode (which leaves remaining gas untouched) while Solidity
245      * uses an invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function div(uint256 a, uint256 b) internal pure returns (uint256) {
252         return div(a, b, "SafeMath: division by zero");
253     }
254 
255     /**
256      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
257      * division by zero. The result is rounded towards zero.
258      *
259      * Counterpart to Solidity's `/` operator. Note: this function uses a
260      * `revert` opcode (which leaves remaining gas untouched) while Solidity
261      * uses an invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function div(
268         uint256 a,
269         uint256 b,
270         string memory errorMessage
271     ) internal pure returns (uint256) {
272         require(b > 0, errorMessage);
273         uint256 c = a / b;
274         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
275 
276         return c;
277     }
278 
279     /**
280      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
281      * Reverts when dividing by zero.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
292         return mod(a, b, "SafeMath: modulo by zero");
293     }
294 
295     /**
296      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
297      * Reverts with custom message when dividing by zero.
298      *
299      * Counterpart to Solidity's `%` operator. This function uses a `revert`
300      * opcode (which leaves remaining gas untouched) while Solidity uses an
301      * invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      *
305      * - The divisor cannot be zero.
306      */
307     function mod(
308         uint256 a,
309         uint256 b,
310         string memory errorMessage
311     ) internal pure returns (uint256) {
312         require(b != 0, errorMessage);
313         return a % b;
314     }
315 }
316 
317 // File: @openzeppelin/contracts/utils/Address.sol
318 
319 pragma solidity ^0.6.2;
320 
321 /**
322  * @dev Collection of functions related to the address type
323  */
324 library Address {
325     /**
326      * @dev Returns true if `account` is a contract.
327      *
328      * [IMPORTANT]
329      * ====
330      * It is unsafe to assume that an address for which this function returns
331      * false is an externally-owned account (EOA) and not a contract.
332      *
333      * Among others, `isContract` will return false for the following
334      * types of addresses:
335      *
336      *  - an externally-owned account
337      *  - a contract in construction
338      *  - an address where a contract will be created
339      *  - an address where a contract lived, but was destroyed
340      * ====
341      */
342     function isContract(address account) internal view returns (bool) {
343         // This method relies in extcodesize, which returns 0 for contracts in
344         // construction, since the code is only stored at the end of the
345         // constructor execution.
346 
347         uint256 size;
348         // solhint-disable-next-line no-inline-assembly
349         assembly {
350             size := extcodesize(account)
351         }
352         return size > 0;
353     }
354 
355     /**
356      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
357      * `recipient`, forwarding all available gas and reverting on errors.
358      *
359      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
360      * of certain opcodes, possibly making contracts go over the 2300 gas limit
361      * imposed by `transfer`, making them unable to receive funds via
362      * `transfer`. {sendValue} removes this limitation.
363      *
364      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
365      *
366      * IMPORTANT: because control is transferred to `recipient`, care must be
367      * taken to not create reentrancy vulnerabilities. Consider using
368      * {ReentrancyGuard} or the
369      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
370      */
371     function sendValue(address payable recipient, uint256 amount) internal {
372         require(
373             address(this).balance >= amount,
374             "Address: insufficient balance"
375         );
376 
377         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
378         (bool success, ) = recipient.call{value: amount}("");
379         require(
380             success,
381             "Address: unable to send value, recipient may have reverted"
382         );
383     }
384 
385     /**
386      * @dev Performs a Solidity function call using a low level `call`. A
387      * plain`call` is an unsafe replacement for a function call: use this
388      * function instead.
389      *
390      * If `target` reverts with a revert reason, it is bubbled up by this
391      * function (like regular Solidity function calls).
392      *
393      * Returns the raw returned data. To convert to the expected return value,
394      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
395      *
396      * Requirements:
397      *
398      * - `target` must be a contract.
399      * - calling `target` with `data` must not revert.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(address target, bytes memory data)
404         internal
405         returns (bytes memory)
406     {
407         return functionCall(target, data, "Address: low-level call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
412      * `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         return _functionCallWithValue(target, data, 0, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but also transferring `value` wei to `target`.
427      *
428      * Requirements:
429      *
430      * - the calling contract must have an ETH balance of at least `value`.
431      * - the called Solidity function must be `payable`.
432      *
433      * _Available since v3.1._
434      */
435     function functionCallWithValue(
436         address target,
437         bytes memory data,
438         uint256 value
439     ) internal returns (bytes memory) {
440         return
441             functionCallWithValue(
442                 target,
443                 data,
444                 value,
445                 "Address: low-level call with value failed"
446             );
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
451      * with `errorMessage` as a fallback revert reason when `target` reverts.
452      *
453      * _Available since v3.1._
454      */
455     function functionCallWithValue(
456         address target,
457         bytes memory data,
458         uint256 value,
459         string memory errorMessage
460     ) internal returns (bytes memory) {
461         require(
462             address(this).balance >= value,
463             "Address: insufficient balance for call"
464         );
465         return _functionCallWithValue(target, data, value, errorMessage);
466     }
467 
468     function _functionCallWithValue(
469         address target,
470         bytes memory data,
471         uint256 weiValue,
472         string memory errorMessage
473     ) private returns (bytes memory) {
474         require(isContract(target), "Address: call to non-contract");
475 
476         // solhint-disable-next-line avoid-low-level-calls
477         (bool success, bytes memory returndata) = target.call{value: weiValue}(
478             data
479         );
480         if (success) {
481             return returndata;
482         } else {
483             // Look for revert reason and bubble it up if present
484             if (returndata.length > 0) {
485                 // The easiest way to bubble the revert reason is using memory via assembly
486 
487                 // solhint-disable-next-line no-inline-assembly
488                 assembly {
489                     let returndata_size := mload(returndata)
490                     revert(add(32, returndata), returndata_size)
491                 }
492             } else {
493                 revert(errorMessage);
494             }
495         }
496     }
497 }
498 
499 // File: contracts/IFeeApprover.sol
500 
501 pragma solidity 0.6.12;
502 
503 interface IFeeApprover {
504     function check(
505         address sender,
506         address recipient,
507         uint256 amount
508     ) external returns (bool);
509 
510     function setFeeMultiplier(uint256 _feeMultiplier) external;
511 
512     function feePercentX100() external view returns (uint256);
513 
514     function setTokenUniswapPair(address _tokenUniswapPair) external;
515 
516     function setNerdTokenAddress(address _nerdTokenAddress) external;
517 
518     function updateTxState() external;
519 
520     function calculateAmountsAfterFee(
521         address sender,
522         address recipient,
523         uint256 amount
524     )
525         external
526         returns (uint256 transferToAmount, uint256 transferToFeeBearerAmount);
527 
528     function setPaused() external;
529 }
530 
531 // File: contracts/INerdVault.sol
532 
533 pragma solidity 0.6.12;
534 
535 interface INerdVault {
536     function updatePendingRewards() external;
537 
538     function depositFor(
539         address _depositFor,
540         uint256 _pid,
541         uint256 _amount
542     ) external;
543 
544     function poolInfo(uint256 _pid)
545         external
546         view
547         returns (
548             address,
549             uint256,
550             uint256,
551             uint256,
552             bool,
553             uint256,
554             uint256,
555             uint256,
556             uint256
557         );
558 }
559 
560 // File: @nomiclabs/buidler/console.sol
561 
562 pragma solidity >=0.4.22 <0.8.0;
563 
564 library console {
565     address constant CONSOLE_ADDRESS = address(
566         0x000000000000000000636F6e736F6c652e6c6f67
567     );
568 
569     function _sendLogPayload(bytes memory payload) private view {
570         uint256 payloadLength = payload.length;
571         address consoleAddress = CONSOLE_ADDRESS;
572         assembly {
573             let payloadStart := add(payload, 32)
574             let r := staticcall(
575                 gas(),
576                 consoleAddress,
577                 payloadStart,
578                 payloadLength,
579                 0,
580                 0
581             )
582         }
583     }
584 
585     function log() internal view {
586         _sendLogPayload(abi.encodeWithSignature("log()"));
587     }
588 
589     function logInt(int256 p0) internal view {
590         _sendLogPayload(abi.encodeWithSignature("log(int)", p0));
591     }
592 
593     function logUint(uint256 p0) internal view {
594         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
595     }
596 
597     function logString(string memory p0) internal view {
598         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
599     }
600 
601     function logBool(bool p0) internal view {
602         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
603     }
604 
605     function logAddress(address p0) internal view {
606         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
607     }
608 
609     function logBytes(bytes memory p0) internal view {
610         _sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
611     }
612 
613     function logByte(bytes1 p0) internal view {
614         _sendLogPayload(abi.encodeWithSignature("log(byte)", p0));
615     }
616 
617     function logBytes1(bytes1 p0) internal view {
618         _sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
619     }
620 
621     function logBytes2(bytes2 p0) internal view {
622         _sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
623     }
624 
625     function logBytes3(bytes3 p0) internal view {
626         _sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
627     }
628 
629     function logBytes4(bytes4 p0) internal view {
630         _sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
631     }
632 
633     function logBytes5(bytes5 p0) internal view {
634         _sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
635     }
636 
637     function logBytes6(bytes6 p0) internal view {
638         _sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
639     }
640 
641     function logBytes7(bytes7 p0) internal view {
642         _sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
643     }
644 
645     function logBytes8(bytes8 p0) internal view {
646         _sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
647     }
648 
649     function logBytes9(bytes9 p0) internal view {
650         _sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
651     }
652 
653     function logBytes10(bytes10 p0) internal view {
654         _sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
655     }
656 
657     function logBytes11(bytes11 p0) internal view {
658         _sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
659     }
660 
661     function logBytes12(bytes12 p0) internal view {
662         _sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
663     }
664 
665     function logBytes13(bytes13 p0) internal view {
666         _sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
667     }
668 
669     function logBytes14(bytes14 p0) internal view {
670         _sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
671     }
672 
673     function logBytes15(bytes15 p0) internal view {
674         _sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
675     }
676 
677     function logBytes16(bytes16 p0) internal view {
678         _sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
679     }
680 
681     function logBytes17(bytes17 p0) internal view {
682         _sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
683     }
684 
685     function logBytes18(bytes18 p0) internal view {
686         _sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
687     }
688 
689     function logBytes19(bytes19 p0) internal view {
690         _sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
691     }
692 
693     function logBytes20(bytes20 p0) internal view {
694         _sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
695     }
696 
697     function logBytes21(bytes21 p0) internal view {
698         _sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
699     }
700 
701     function logBytes22(bytes22 p0) internal view {
702         _sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
703     }
704 
705     function logBytes23(bytes23 p0) internal view {
706         _sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
707     }
708 
709     function logBytes24(bytes24 p0) internal view {
710         _sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
711     }
712 
713     function logBytes25(bytes25 p0) internal view {
714         _sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
715     }
716 
717     function logBytes26(bytes26 p0) internal view {
718         _sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
719     }
720 
721     function logBytes27(bytes27 p0) internal view {
722         _sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
723     }
724 
725     function logBytes28(bytes28 p0) internal view {
726         _sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
727     }
728 
729     function logBytes29(bytes29 p0) internal view {
730         _sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
731     }
732 
733     function logBytes30(bytes30 p0) internal view {
734         _sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
735     }
736 
737     function logBytes31(bytes31 p0) internal view {
738         _sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
739     }
740 
741     function logBytes32(bytes32 p0) internal view {
742         _sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
743     }
744 
745     function log(uint256 p0) internal view {
746         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
747     }
748 
749     function log(string memory p0) internal view {
750         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
751     }
752 
753     function log(bool p0) internal view {
754         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
755     }
756 
757     function log(address p0) internal view {
758         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
759     }
760 
761     function log(uint256 p0, uint256 p1) internal view {
762         _sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
763     }
764 
765     function log(uint256 p0, string memory p1) internal view {
766         _sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
767     }
768 
769     function log(uint256 p0, bool p1) internal view {
770         _sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
771     }
772 
773     function log(uint256 p0, address p1) internal view {
774         _sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
775     }
776 
777     function log(string memory p0, uint256 p1) internal view {
778         _sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
779     }
780 
781     function log(string memory p0, string memory p1) internal view {
782         _sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
783     }
784 
785     function log(string memory p0, bool p1) internal view {
786         _sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
787     }
788 
789     function log(string memory p0, address p1) internal view {
790         _sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
791     }
792 
793     function log(bool p0, uint256 p1) internal view {
794         _sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
795     }
796 
797     function log(bool p0, string memory p1) internal view {
798         _sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
799     }
800 
801     function log(bool p0, bool p1) internal view {
802         _sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
803     }
804 
805     function log(bool p0, address p1) internal view {
806         _sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
807     }
808 
809     function log(address p0, uint256 p1) internal view {
810         _sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
811     }
812 
813     function log(address p0, string memory p1) internal view {
814         _sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
815     }
816 
817     function log(address p0, bool p1) internal view {
818         _sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
819     }
820 
821     function log(address p0, address p1) internal view {
822         _sendLogPayload(
823             abi.encodeWithSignature("log(address,address)", p0, p1)
824         );
825     }
826 
827     function log(
828         uint256 p0,
829         uint256 p1,
830         uint256 p2
831     ) internal view {
832         _sendLogPayload(
833             abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2)
834         );
835     }
836 
837     function log(
838         uint256 p0,
839         uint256 p1,
840         string memory p2
841     ) internal view {
842         _sendLogPayload(
843             abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2)
844         );
845     }
846 
847     function log(
848         uint256 p0,
849         uint256 p1,
850         bool p2
851     ) internal view {
852         _sendLogPayload(
853             abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2)
854         );
855     }
856 
857     function log(
858         uint256 p0,
859         uint256 p1,
860         address p2
861     ) internal view {
862         _sendLogPayload(
863             abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2)
864         );
865     }
866 
867     function log(
868         uint256 p0,
869         string memory p1,
870         uint256 p2
871     ) internal view {
872         _sendLogPayload(
873             abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2)
874         );
875     }
876 
877     function log(
878         uint256 p0,
879         string memory p1,
880         string memory p2
881     ) internal view {
882         _sendLogPayload(
883             abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2)
884         );
885     }
886 
887     function log(
888         uint256 p0,
889         string memory p1,
890         bool p2
891     ) internal view {
892         _sendLogPayload(
893             abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2)
894         );
895     }
896 
897     function log(
898         uint256 p0,
899         string memory p1,
900         address p2
901     ) internal view {
902         _sendLogPayload(
903             abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2)
904         );
905     }
906 
907     function log(
908         uint256 p0,
909         bool p1,
910         uint256 p2
911     ) internal view {
912         _sendLogPayload(
913             abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2)
914         );
915     }
916 
917     function log(
918         uint256 p0,
919         bool p1,
920         string memory p2
921     ) internal view {
922         _sendLogPayload(
923             abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2)
924         );
925     }
926 
927     function log(
928         uint256 p0,
929         bool p1,
930         bool p2
931     ) internal view {
932         _sendLogPayload(
933             abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2)
934         );
935     }
936 
937     function log(
938         uint256 p0,
939         bool p1,
940         address p2
941     ) internal view {
942         _sendLogPayload(
943             abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2)
944         );
945     }
946 
947     function log(
948         uint256 p0,
949         address p1,
950         uint256 p2
951     ) internal view {
952         _sendLogPayload(
953             abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2)
954         );
955     }
956 
957     function log(
958         uint256 p0,
959         address p1,
960         string memory p2
961     ) internal view {
962         _sendLogPayload(
963             abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2)
964         );
965     }
966 
967     function log(
968         uint256 p0,
969         address p1,
970         bool p2
971     ) internal view {
972         _sendLogPayload(
973             abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2)
974         );
975     }
976 
977     function log(
978         uint256 p0,
979         address p1,
980         address p2
981     ) internal view {
982         _sendLogPayload(
983             abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2)
984         );
985     }
986 
987     function log(
988         string memory p0,
989         uint256 p1,
990         uint256 p2
991     ) internal view {
992         _sendLogPayload(
993             abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2)
994         );
995     }
996 
997     function log(
998         string memory p0,
999         uint256 p1,
1000         string memory p2
1001     ) internal view {
1002         _sendLogPayload(
1003             abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2)
1004         );
1005     }
1006 
1007     function log(
1008         string memory p0,
1009         uint256 p1,
1010         bool p2
1011     ) internal view {
1012         _sendLogPayload(
1013             abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2)
1014         );
1015     }
1016 
1017     function log(
1018         string memory p0,
1019         uint256 p1,
1020         address p2
1021     ) internal view {
1022         _sendLogPayload(
1023             abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2)
1024         );
1025     }
1026 
1027     function log(
1028         string memory p0,
1029         string memory p1,
1030         uint256 p2
1031     ) internal view {
1032         _sendLogPayload(
1033             abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2)
1034         );
1035     }
1036 
1037     function log(
1038         string memory p0,
1039         string memory p1,
1040         string memory p2
1041     ) internal view {
1042         _sendLogPayload(
1043             abi.encodeWithSignature("log(string,string,string)", p0, p1, p2)
1044         );
1045     }
1046 
1047     function log(
1048         string memory p0,
1049         string memory p1,
1050         bool p2
1051     ) internal view {
1052         _sendLogPayload(
1053             abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2)
1054         );
1055     }
1056 
1057     function log(
1058         string memory p0,
1059         string memory p1,
1060         address p2
1061     ) internal view {
1062         _sendLogPayload(
1063             abi.encodeWithSignature("log(string,string,address)", p0, p1, p2)
1064         );
1065     }
1066 
1067     function log(
1068         string memory p0,
1069         bool p1,
1070         uint256 p2
1071     ) internal view {
1072         _sendLogPayload(
1073             abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2)
1074         );
1075     }
1076 
1077     function log(
1078         string memory p0,
1079         bool p1,
1080         string memory p2
1081     ) internal view {
1082         _sendLogPayload(
1083             abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2)
1084         );
1085     }
1086 
1087     function log(
1088         string memory p0,
1089         bool p1,
1090         bool p2
1091     ) internal view {
1092         _sendLogPayload(
1093             abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2)
1094         );
1095     }
1096 
1097     function log(
1098         string memory p0,
1099         bool p1,
1100         address p2
1101     ) internal view {
1102         _sendLogPayload(
1103             abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2)
1104         );
1105     }
1106 
1107     function log(
1108         string memory p0,
1109         address p1,
1110         uint256 p2
1111     ) internal view {
1112         _sendLogPayload(
1113             abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2)
1114         );
1115     }
1116 
1117     function log(
1118         string memory p0,
1119         address p1,
1120         string memory p2
1121     ) internal view {
1122         _sendLogPayload(
1123             abi.encodeWithSignature("log(string,address,string)", p0, p1, p2)
1124         );
1125     }
1126 
1127     function log(
1128         string memory p0,
1129         address p1,
1130         bool p2
1131     ) internal view {
1132         _sendLogPayload(
1133             abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2)
1134         );
1135     }
1136 
1137     function log(
1138         string memory p0,
1139         address p1,
1140         address p2
1141     ) internal view {
1142         _sendLogPayload(
1143             abi.encodeWithSignature("log(string,address,address)", p0, p1, p2)
1144         );
1145     }
1146 
1147     function log(
1148         bool p0,
1149         uint256 p1,
1150         uint256 p2
1151     ) internal view {
1152         _sendLogPayload(
1153             abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2)
1154         );
1155     }
1156 
1157     function log(
1158         bool p0,
1159         uint256 p1,
1160         string memory p2
1161     ) internal view {
1162         _sendLogPayload(
1163             abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2)
1164         );
1165     }
1166 
1167     function log(
1168         bool p0,
1169         uint256 p1,
1170         bool p2
1171     ) internal view {
1172         _sendLogPayload(
1173             abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2)
1174         );
1175     }
1176 
1177     function log(
1178         bool p0,
1179         uint256 p1,
1180         address p2
1181     ) internal view {
1182         _sendLogPayload(
1183             abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2)
1184         );
1185     }
1186 
1187     function log(
1188         bool p0,
1189         string memory p1,
1190         uint256 p2
1191     ) internal view {
1192         _sendLogPayload(
1193             abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2)
1194         );
1195     }
1196 
1197     function log(
1198         bool p0,
1199         string memory p1,
1200         string memory p2
1201     ) internal view {
1202         _sendLogPayload(
1203             abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2)
1204         );
1205     }
1206 
1207     function log(
1208         bool p0,
1209         string memory p1,
1210         bool p2
1211     ) internal view {
1212         _sendLogPayload(
1213             abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2)
1214         );
1215     }
1216 
1217     function log(
1218         bool p0,
1219         string memory p1,
1220         address p2
1221     ) internal view {
1222         _sendLogPayload(
1223             abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2)
1224         );
1225     }
1226 
1227     function log(
1228         bool p0,
1229         bool p1,
1230         uint256 p2
1231     ) internal view {
1232         _sendLogPayload(
1233             abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2)
1234         );
1235     }
1236 
1237     function log(
1238         bool p0,
1239         bool p1,
1240         string memory p2
1241     ) internal view {
1242         _sendLogPayload(
1243             abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2)
1244         );
1245     }
1246 
1247     function log(
1248         bool p0,
1249         bool p1,
1250         bool p2
1251     ) internal view {
1252         _sendLogPayload(
1253             abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2)
1254         );
1255     }
1256 
1257     function log(
1258         bool p0,
1259         bool p1,
1260         address p2
1261     ) internal view {
1262         _sendLogPayload(
1263             abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2)
1264         );
1265     }
1266 
1267     function log(
1268         bool p0,
1269         address p1,
1270         uint256 p2
1271     ) internal view {
1272         _sendLogPayload(
1273             abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2)
1274         );
1275     }
1276 
1277     function log(
1278         bool p0,
1279         address p1,
1280         string memory p2
1281     ) internal view {
1282         _sendLogPayload(
1283             abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2)
1284         );
1285     }
1286 
1287     function log(
1288         bool p0,
1289         address p1,
1290         bool p2
1291     ) internal view {
1292         _sendLogPayload(
1293             abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2)
1294         );
1295     }
1296 
1297     function log(
1298         bool p0,
1299         address p1,
1300         address p2
1301     ) internal view {
1302         _sendLogPayload(
1303             abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2)
1304         );
1305     }
1306 
1307     function log(
1308         address p0,
1309         uint256 p1,
1310         uint256 p2
1311     ) internal view {
1312         _sendLogPayload(
1313             abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2)
1314         );
1315     }
1316 
1317     function log(
1318         address p0,
1319         uint256 p1,
1320         string memory p2
1321     ) internal view {
1322         _sendLogPayload(
1323             abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2)
1324         );
1325     }
1326 
1327     function log(
1328         address p0,
1329         uint256 p1,
1330         bool p2
1331     ) internal view {
1332         _sendLogPayload(
1333             abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2)
1334         );
1335     }
1336 
1337     function log(
1338         address p0,
1339         uint256 p1,
1340         address p2
1341     ) internal view {
1342         _sendLogPayload(
1343             abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2)
1344         );
1345     }
1346 
1347     function log(
1348         address p0,
1349         string memory p1,
1350         uint256 p2
1351     ) internal view {
1352         _sendLogPayload(
1353             abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2)
1354         );
1355     }
1356 
1357     function log(
1358         address p0,
1359         string memory p1,
1360         string memory p2
1361     ) internal view {
1362         _sendLogPayload(
1363             abi.encodeWithSignature("log(address,string,string)", p0, p1, p2)
1364         );
1365     }
1366 
1367     function log(
1368         address p0,
1369         string memory p1,
1370         bool p2
1371     ) internal view {
1372         _sendLogPayload(
1373             abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2)
1374         );
1375     }
1376 
1377     function log(
1378         address p0,
1379         string memory p1,
1380         address p2
1381     ) internal view {
1382         _sendLogPayload(
1383             abi.encodeWithSignature("log(address,string,address)", p0, p1, p2)
1384         );
1385     }
1386 
1387     function log(
1388         address p0,
1389         bool p1,
1390         uint256 p2
1391     ) internal view {
1392         _sendLogPayload(
1393             abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2)
1394         );
1395     }
1396 
1397     function log(
1398         address p0,
1399         bool p1,
1400         string memory p2
1401     ) internal view {
1402         _sendLogPayload(
1403             abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2)
1404         );
1405     }
1406 
1407     function log(
1408         address p0,
1409         bool p1,
1410         bool p2
1411     ) internal view {
1412         _sendLogPayload(
1413             abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2)
1414         );
1415     }
1416 
1417     function log(
1418         address p0,
1419         bool p1,
1420         address p2
1421     ) internal view {
1422         _sendLogPayload(
1423             abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2)
1424         );
1425     }
1426 
1427     function log(
1428         address p0,
1429         address p1,
1430         uint256 p2
1431     ) internal view {
1432         _sendLogPayload(
1433             abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2)
1434         );
1435     }
1436 
1437     function log(
1438         address p0,
1439         address p1,
1440         string memory p2
1441     ) internal view {
1442         _sendLogPayload(
1443             abi.encodeWithSignature("log(address,address,string)", p0, p1, p2)
1444         );
1445     }
1446 
1447     function log(
1448         address p0,
1449         address p1,
1450         bool p2
1451     ) internal view {
1452         _sendLogPayload(
1453             abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2)
1454         );
1455     }
1456 
1457     function log(
1458         address p0,
1459         address p1,
1460         address p2
1461     ) internal view {
1462         _sendLogPayload(
1463             abi.encodeWithSignature("log(address,address,address)", p0, p1, p2)
1464         );
1465     }
1466 
1467     function log(
1468         uint256 p0,
1469         uint256 p1,
1470         uint256 p2,
1471         uint256 p3
1472     ) internal view {
1473         _sendLogPayload(
1474             abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3)
1475         );
1476     }
1477 
1478     function log(
1479         uint256 p0,
1480         uint256 p1,
1481         uint256 p2,
1482         string memory p3
1483     ) internal view {
1484         _sendLogPayload(
1485             abi.encodeWithSignature(
1486                 "log(uint,uint,uint,string)",
1487                 p0,
1488                 p1,
1489                 p2,
1490                 p3
1491             )
1492         );
1493     }
1494 
1495     function log(
1496         uint256 p0,
1497         uint256 p1,
1498         uint256 p2,
1499         bool p3
1500     ) internal view {
1501         _sendLogPayload(
1502             abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3)
1503         );
1504     }
1505 
1506     function log(
1507         uint256 p0,
1508         uint256 p1,
1509         uint256 p2,
1510         address p3
1511     ) internal view {
1512         _sendLogPayload(
1513             abi.encodeWithSignature(
1514                 "log(uint,uint,uint,address)",
1515                 p0,
1516                 p1,
1517                 p2,
1518                 p3
1519             )
1520         );
1521     }
1522 
1523     function log(
1524         uint256 p0,
1525         uint256 p1,
1526         string memory p2,
1527         uint256 p3
1528     ) internal view {
1529         _sendLogPayload(
1530             abi.encodeWithSignature(
1531                 "log(uint,uint,string,uint)",
1532                 p0,
1533                 p1,
1534                 p2,
1535                 p3
1536             )
1537         );
1538     }
1539 
1540     function log(
1541         uint256 p0,
1542         uint256 p1,
1543         string memory p2,
1544         string memory p3
1545     ) internal view {
1546         _sendLogPayload(
1547             abi.encodeWithSignature(
1548                 "log(uint,uint,string,string)",
1549                 p0,
1550                 p1,
1551                 p2,
1552                 p3
1553             )
1554         );
1555     }
1556 
1557     function log(
1558         uint256 p0,
1559         uint256 p1,
1560         string memory p2,
1561         bool p3
1562     ) internal view {
1563         _sendLogPayload(
1564             abi.encodeWithSignature(
1565                 "log(uint,uint,string,bool)",
1566                 p0,
1567                 p1,
1568                 p2,
1569                 p3
1570             )
1571         );
1572     }
1573 
1574     function log(
1575         uint256 p0,
1576         uint256 p1,
1577         string memory p2,
1578         address p3
1579     ) internal view {
1580         _sendLogPayload(
1581             abi.encodeWithSignature(
1582                 "log(uint,uint,string,address)",
1583                 p0,
1584                 p1,
1585                 p2,
1586                 p3
1587             )
1588         );
1589     }
1590 
1591     function log(
1592         uint256 p0,
1593         uint256 p1,
1594         bool p2,
1595         uint256 p3
1596     ) internal view {
1597         _sendLogPayload(
1598             abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3)
1599         );
1600     }
1601 
1602     function log(
1603         uint256 p0,
1604         uint256 p1,
1605         bool p2,
1606         string memory p3
1607     ) internal view {
1608         _sendLogPayload(
1609             abi.encodeWithSignature(
1610                 "log(uint,uint,bool,string)",
1611                 p0,
1612                 p1,
1613                 p2,
1614                 p3
1615             )
1616         );
1617     }
1618 
1619     function log(
1620         uint256 p0,
1621         uint256 p1,
1622         bool p2,
1623         bool p3
1624     ) internal view {
1625         _sendLogPayload(
1626             abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3)
1627         );
1628     }
1629 
1630     function log(
1631         uint256 p0,
1632         uint256 p1,
1633         bool p2,
1634         address p3
1635     ) internal view {
1636         _sendLogPayload(
1637             abi.encodeWithSignature(
1638                 "log(uint,uint,bool,address)",
1639                 p0,
1640                 p1,
1641                 p2,
1642                 p3
1643             )
1644         );
1645     }
1646 
1647     function log(
1648         uint256 p0,
1649         uint256 p1,
1650         address p2,
1651         uint256 p3
1652     ) internal view {
1653         _sendLogPayload(
1654             abi.encodeWithSignature(
1655                 "log(uint,uint,address,uint)",
1656                 p0,
1657                 p1,
1658                 p2,
1659                 p3
1660             )
1661         );
1662     }
1663 
1664     function log(
1665         uint256 p0,
1666         uint256 p1,
1667         address p2,
1668         string memory p3
1669     ) internal view {
1670         _sendLogPayload(
1671             abi.encodeWithSignature(
1672                 "log(uint,uint,address,string)",
1673                 p0,
1674                 p1,
1675                 p2,
1676                 p3
1677             )
1678         );
1679     }
1680 
1681     function log(
1682         uint256 p0,
1683         uint256 p1,
1684         address p2,
1685         bool p3
1686     ) internal view {
1687         _sendLogPayload(
1688             abi.encodeWithSignature(
1689                 "log(uint,uint,address,bool)",
1690                 p0,
1691                 p1,
1692                 p2,
1693                 p3
1694             )
1695         );
1696     }
1697 
1698     function log(
1699         uint256 p0,
1700         uint256 p1,
1701         address p2,
1702         address p3
1703     ) internal view {
1704         _sendLogPayload(
1705             abi.encodeWithSignature(
1706                 "log(uint,uint,address,address)",
1707                 p0,
1708                 p1,
1709                 p2,
1710                 p3
1711             )
1712         );
1713     }
1714 
1715     function log(
1716         uint256 p0,
1717         string memory p1,
1718         uint256 p2,
1719         uint256 p3
1720     ) internal view {
1721         _sendLogPayload(
1722             abi.encodeWithSignature(
1723                 "log(uint,string,uint,uint)",
1724                 p0,
1725                 p1,
1726                 p2,
1727                 p3
1728             )
1729         );
1730     }
1731 
1732     function log(
1733         uint256 p0,
1734         string memory p1,
1735         uint256 p2,
1736         string memory p3
1737     ) internal view {
1738         _sendLogPayload(
1739             abi.encodeWithSignature(
1740                 "log(uint,string,uint,string)",
1741                 p0,
1742                 p1,
1743                 p2,
1744                 p3
1745             )
1746         );
1747     }
1748 
1749     function log(
1750         uint256 p0,
1751         string memory p1,
1752         uint256 p2,
1753         bool p3
1754     ) internal view {
1755         _sendLogPayload(
1756             abi.encodeWithSignature(
1757                 "log(uint,string,uint,bool)",
1758                 p0,
1759                 p1,
1760                 p2,
1761                 p3
1762             )
1763         );
1764     }
1765 
1766     function log(
1767         uint256 p0,
1768         string memory p1,
1769         uint256 p2,
1770         address p3
1771     ) internal view {
1772         _sendLogPayload(
1773             abi.encodeWithSignature(
1774                 "log(uint,string,uint,address)",
1775                 p0,
1776                 p1,
1777                 p2,
1778                 p3
1779             )
1780         );
1781     }
1782 
1783     function log(
1784         uint256 p0,
1785         string memory p1,
1786         string memory p2,
1787         uint256 p3
1788     ) internal view {
1789         _sendLogPayload(
1790             abi.encodeWithSignature(
1791                 "log(uint,string,string,uint)",
1792                 p0,
1793                 p1,
1794                 p2,
1795                 p3
1796             )
1797         );
1798     }
1799 
1800     function log(
1801         uint256 p0,
1802         string memory p1,
1803         string memory p2,
1804         string memory p3
1805     ) internal view {
1806         _sendLogPayload(
1807             abi.encodeWithSignature(
1808                 "log(uint,string,string,string)",
1809                 p0,
1810                 p1,
1811                 p2,
1812                 p3
1813             )
1814         );
1815     }
1816 
1817     function log(
1818         uint256 p0,
1819         string memory p1,
1820         string memory p2,
1821         bool p3
1822     ) internal view {
1823         _sendLogPayload(
1824             abi.encodeWithSignature(
1825                 "log(uint,string,string,bool)",
1826                 p0,
1827                 p1,
1828                 p2,
1829                 p3
1830             )
1831         );
1832     }
1833 
1834     function log(
1835         uint256 p0,
1836         string memory p1,
1837         string memory p2,
1838         address p3
1839     ) internal view {
1840         _sendLogPayload(
1841             abi.encodeWithSignature(
1842                 "log(uint,string,string,address)",
1843                 p0,
1844                 p1,
1845                 p2,
1846                 p3
1847             )
1848         );
1849     }
1850 
1851     function log(
1852         uint256 p0,
1853         string memory p1,
1854         bool p2,
1855         uint256 p3
1856     ) internal view {
1857         _sendLogPayload(
1858             abi.encodeWithSignature(
1859                 "log(uint,string,bool,uint)",
1860                 p0,
1861                 p1,
1862                 p2,
1863                 p3
1864             )
1865         );
1866     }
1867 
1868     function log(
1869         uint256 p0,
1870         string memory p1,
1871         bool p2,
1872         string memory p3
1873     ) internal view {
1874         _sendLogPayload(
1875             abi.encodeWithSignature(
1876                 "log(uint,string,bool,string)",
1877                 p0,
1878                 p1,
1879                 p2,
1880                 p3
1881             )
1882         );
1883     }
1884 
1885     function log(
1886         uint256 p0,
1887         string memory p1,
1888         bool p2,
1889         bool p3
1890     ) internal view {
1891         _sendLogPayload(
1892             abi.encodeWithSignature(
1893                 "log(uint,string,bool,bool)",
1894                 p0,
1895                 p1,
1896                 p2,
1897                 p3
1898             )
1899         );
1900     }
1901 
1902     function log(
1903         uint256 p0,
1904         string memory p1,
1905         bool p2,
1906         address p3
1907     ) internal view {
1908         _sendLogPayload(
1909             abi.encodeWithSignature(
1910                 "log(uint,string,bool,address)",
1911                 p0,
1912                 p1,
1913                 p2,
1914                 p3
1915             )
1916         );
1917     }
1918 
1919     function log(
1920         uint256 p0,
1921         string memory p1,
1922         address p2,
1923         uint256 p3
1924     ) internal view {
1925         _sendLogPayload(
1926             abi.encodeWithSignature(
1927                 "log(uint,string,address,uint)",
1928                 p0,
1929                 p1,
1930                 p2,
1931                 p3
1932             )
1933         );
1934     }
1935 
1936     function log(
1937         uint256 p0,
1938         string memory p1,
1939         address p2,
1940         string memory p3
1941     ) internal view {
1942         _sendLogPayload(
1943             abi.encodeWithSignature(
1944                 "log(uint,string,address,string)",
1945                 p0,
1946                 p1,
1947                 p2,
1948                 p3
1949             )
1950         );
1951     }
1952 
1953     function log(
1954         uint256 p0,
1955         string memory p1,
1956         address p2,
1957         bool p3
1958     ) internal view {
1959         _sendLogPayload(
1960             abi.encodeWithSignature(
1961                 "log(uint,string,address,bool)",
1962                 p0,
1963                 p1,
1964                 p2,
1965                 p3
1966             )
1967         );
1968     }
1969 
1970     function log(
1971         uint256 p0,
1972         string memory p1,
1973         address p2,
1974         address p3
1975     ) internal view {
1976         _sendLogPayload(
1977             abi.encodeWithSignature(
1978                 "log(uint,string,address,address)",
1979                 p0,
1980                 p1,
1981                 p2,
1982                 p3
1983             )
1984         );
1985     }
1986 
1987     function log(
1988         uint256 p0,
1989         bool p1,
1990         uint256 p2,
1991         uint256 p3
1992     ) internal view {
1993         _sendLogPayload(
1994             abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3)
1995         );
1996     }
1997 
1998     function log(
1999         uint256 p0,
2000         bool p1,
2001         uint256 p2,
2002         string memory p3
2003     ) internal view {
2004         _sendLogPayload(
2005             abi.encodeWithSignature(
2006                 "log(uint,bool,uint,string)",
2007                 p0,
2008                 p1,
2009                 p2,
2010                 p3
2011             )
2012         );
2013     }
2014 
2015     function log(
2016         uint256 p0,
2017         bool p1,
2018         uint256 p2,
2019         bool p3
2020     ) internal view {
2021         _sendLogPayload(
2022             abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3)
2023         );
2024     }
2025 
2026     function log(
2027         uint256 p0,
2028         bool p1,
2029         uint256 p2,
2030         address p3
2031     ) internal view {
2032         _sendLogPayload(
2033             abi.encodeWithSignature(
2034                 "log(uint,bool,uint,address)",
2035                 p0,
2036                 p1,
2037                 p2,
2038                 p3
2039             )
2040         );
2041     }
2042 
2043     function log(
2044         uint256 p0,
2045         bool p1,
2046         string memory p2,
2047         uint256 p3
2048     ) internal view {
2049         _sendLogPayload(
2050             abi.encodeWithSignature(
2051                 "log(uint,bool,string,uint)",
2052                 p0,
2053                 p1,
2054                 p2,
2055                 p3
2056             )
2057         );
2058     }
2059 
2060     function log(
2061         uint256 p0,
2062         bool p1,
2063         string memory p2,
2064         string memory p3
2065     ) internal view {
2066         _sendLogPayload(
2067             abi.encodeWithSignature(
2068                 "log(uint,bool,string,string)",
2069                 p0,
2070                 p1,
2071                 p2,
2072                 p3
2073             )
2074         );
2075     }
2076 
2077     function log(
2078         uint256 p0,
2079         bool p1,
2080         string memory p2,
2081         bool p3
2082     ) internal view {
2083         _sendLogPayload(
2084             abi.encodeWithSignature(
2085                 "log(uint,bool,string,bool)",
2086                 p0,
2087                 p1,
2088                 p2,
2089                 p3
2090             )
2091         );
2092     }
2093 
2094     function log(
2095         uint256 p0,
2096         bool p1,
2097         string memory p2,
2098         address p3
2099     ) internal view {
2100         _sendLogPayload(
2101             abi.encodeWithSignature(
2102                 "log(uint,bool,string,address)",
2103                 p0,
2104                 p1,
2105                 p2,
2106                 p3
2107             )
2108         );
2109     }
2110 
2111     function log(
2112         uint256 p0,
2113         bool p1,
2114         bool p2,
2115         uint256 p3
2116     ) internal view {
2117         _sendLogPayload(
2118             abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3)
2119         );
2120     }
2121 
2122     function log(
2123         uint256 p0,
2124         bool p1,
2125         bool p2,
2126         string memory p3
2127     ) internal view {
2128         _sendLogPayload(
2129             abi.encodeWithSignature(
2130                 "log(uint,bool,bool,string)",
2131                 p0,
2132                 p1,
2133                 p2,
2134                 p3
2135             )
2136         );
2137     }
2138 
2139     function log(
2140         uint256 p0,
2141         bool p1,
2142         bool p2,
2143         bool p3
2144     ) internal view {
2145         _sendLogPayload(
2146             abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3)
2147         );
2148     }
2149 
2150     function log(
2151         uint256 p0,
2152         bool p1,
2153         bool p2,
2154         address p3
2155     ) internal view {
2156         _sendLogPayload(
2157             abi.encodeWithSignature(
2158                 "log(uint,bool,bool,address)",
2159                 p0,
2160                 p1,
2161                 p2,
2162                 p3
2163             )
2164         );
2165     }
2166 
2167     function log(
2168         uint256 p0,
2169         bool p1,
2170         address p2,
2171         uint256 p3
2172     ) internal view {
2173         _sendLogPayload(
2174             abi.encodeWithSignature(
2175                 "log(uint,bool,address,uint)",
2176                 p0,
2177                 p1,
2178                 p2,
2179                 p3
2180             )
2181         );
2182     }
2183 
2184     function log(
2185         uint256 p0,
2186         bool p1,
2187         address p2,
2188         string memory p3
2189     ) internal view {
2190         _sendLogPayload(
2191             abi.encodeWithSignature(
2192                 "log(uint,bool,address,string)",
2193                 p0,
2194                 p1,
2195                 p2,
2196                 p3
2197             )
2198         );
2199     }
2200 
2201     function log(
2202         uint256 p0,
2203         bool p1,
2204         address p2,
2205         bool p3
2206     ) internal view {
2207         _sendLogPayload(
2208             abi.encodeWithSignature(
2209                 "log(uint,bool,address,bool)",
2210                 p0,
2211                 p1,
2212                 p2,
2213                 p3
2214             )
2215         );
2216     }
2217 
2218     function log(
2219         uint256 p0,
2220         bool p1,
2221         address p2,
2222         address p3
2223     ) internal view {
2224         _sendLogPayload(
2225             abi.encodeWithSignature(
2226                 "log(uint,bool,address,address)",
2227                 p0,
2228                 p1,
2229                 p2,
2230                 p3
2231             )
2232         );
2233     }
2234 
2235     function log(
2236         uint256 p0,
2237         address p1,
2238         uint256 p2,
2239         uint256 p3
2240     ) internal view {
2241         _sendLogPayload(
2242             abi.encodeWithSignature(
2243                 "log(uint,address,uint,uint)",
2244                 p0,
2245                 p1,
2246                 p2,
2247                 p3
2248             )
2249         );
2250     }
2251 
2252     function log(
2253         uint256 p0,
2254         address p1,
2255         uint256 p2,
2256         string memory p3
2257     ) internal view {
2258         _sendLogPayload(
2259             abi.encodeWithSignature(
2260                 "log(uint,address,uint,string)",
2261                 p0,
2262                 p1,
2263                 p2,
2264                 p3
2265             )
2266         );
2267     }
2268 
2269     function log(
2270         uint256 p0,
2271         address p1,
2272         uint256 p2,
2273         bool p3
2274     ) internal view {
2275         _sendLogPayload(
2276             abi.encodeWithSignature(
2277                 "log(uint,address,uint,bool)",
2278                 p0,
2279                 p1,
2280                 p2,
2281                 p3
2282             )
2283         );
2284     }
2285 
2286     function log(
2287         uint256 p0,
2288         address p1,
2289         uint256 p2,
2290         address p3
2291     ) internal view {
2292         _sendLogPayload(
2293             abi.encodeWithSignature(
2294                 "log(uint,address,uint,address)",
2295                 p0,
2296                 p1,
2297                 p2,
2298                 p3
2299             )
2300         );
2301     }
2302 
2303     function log(
2304         uint256 p0,
2305         address p1,
2306         string memory p2,
2307         uint256 p3
2308     ) internal view {
2309         _sendLogPayload(
2310             abi.encodeWithSignature(
2311                 "log(uint,address,string,uint)",
2312                 p0,
2313                 p1,
2314                 p2,
2315                 p3
2316             )
2317         );
2318     }
2319 
2320     function log(
2321         uint256 p0,
2322         address p1,
2323         string memory p2,
2324         string memory p3
2325     ) internal view {
2326         _sendLogPayload(
2327             abi.encodeWithSignature(
2328                 "log(uint,address,string,string)",
2329                 p0,
2330                 p1,
2331                 p2,
2332                 p3
2333             )
2334         );
2335     }
2336 
2337     function log(
2338         uint256 p0,
2339         address p1,
2340         string memory p2,
2341         bool p3
2342     ) internal view {
2343         _sendLogPayload(
2344             abi.encodeWithSignature(
2345                 "log(uint,address,string,bool)",
2346                 p0,
2347                 p1,
2348                 p2,
2349                 p3
2350             )
2351         );
2352     }
2353 
2354     function log(
2355         uint256 p0,
2356         address p1,
2357         string memory p2,
2358         address p3
2359     ) internal view {
2360         _sendLogPayload(
2361             abi.encodeWithSignature(
2362                 "log(uint,address,string,address)",
2363                 p0,
2364                 p1,
2365                 p2,
2366                 p3
2367             )
2368         );
2369     }
2370 
2371     function log(
2372         uint256 p0,
2373         address p1,
2374         bool p2,
2375         uint256 p3
2376     ) internal view {
2377         _sendLogPayload(
2378             abi.encodeWithSignature(
2379                 "log(uint,address,bool,uint)",
2380                 p0,
2381                 p1,
2382                 p2,
2383                 p3
2384             )
2385         );
2386     }
2387 
2388     function log(
2389         uint256 p0,
2390         address p1,
2391         bool p2,
2392         string memory p3
2393     ) internal view {
2394         _sendLogPayload(
2395             abi.encodeWithSignature(
2396                 "log(uint,address,bool,string)",
2397                 p0,
2398                 p1,
2399                 p2,
2400                 p3
2401             )
2402         );
2403     }
2404 
2405     function log(
2406         uint256 p0,
2407         address p1,
2408         bool p2,
2409         bool p3
2410     ) internal view {
2411         _sendLogPayload(
2412             abi.encodeWithSignature(
2413                 "log(uint,address,bool,bool)",
2414                 p0,
2415                 p1,
2416                 p2,
2417                 p3
2418             )
2419         );
2420     }
2421 
2422     function log(
2423         uint256 p0,
2424         address p1,
2425         bool p2,
2426         address p3
2427     ) internal view {
2428         _sendLogPayload(
2429             abi.encodeWithSignature(
2430                 "log(uint,address,bool,address)",
2431                 p0,
2432                 p1,
2433                 p2,
2434                 p3
2435             )
2436         );
2437     }
2438 
2439     function log(
2440         uint256 p0,
2441         address p1,
2442         address p2,
2443         uint256 p3
2444     ) internal view {
2445         _sendLogPayload(
2446             abi.encodeWithSignature(
2447                 "log(uint,address,address,uint)",
2448                 p0,
2449                 p1,
2450                 p2,
2451                 p3
2452             )
2453         );
2454     }
2455 
2456     function log(
2457         uint256 p0,
2458         address p1,
2459         address p2,
2460         string memory p3
2461     ) internal view {
2462         _sendLogPayload(
2463             abi.encodeWithSignature(
2464                 "log(uint,address,address,string)",
2465                 p0,
2466                 p1,
2467                 p2,
2468                 p3
2469             )
2470         );
2471     }
2472 
2473     function log(
2474         uint256 p0,
2475         address p1,
2476         address p2,
2477         bool p3
2478     ) internal view {
2479         _sendLogPayload(
2480             abi.encodeWithSignature(
2481                 "log(uint,address,address,bool)",
2482                 p0,
2483                 p1,
2484                 p2,
2485                 p3
2486             )
2487         );
2488     }
2489 
2490     function log(
2491         uint256 p0,
2492         address p1,
2493         address p2,
2494         address p3
2495     ) internal view {
2496         _sendLogPayload(
2497             abi.encodeWithSignature(
2498                 "log(uint,address,address,address)",
2499                 p0,
2500                 p1,
2501                 p2,
2502                 p3
2503             )
2504         );
2505     }
2506 
2507     function log(
2508         string memory p0,
2509         uint256 p1,
2510         uint256 p2,
2511         uint256 p3
2512     ) internal view {
2513         _sendLogPayload(
2514             abi.encodeWithSignature(
2515                 "log(string,uint,uint,uint)",
2516                 p0,
2517                 p1,
2518                 p2,
2519                 p3
2520             )
2521         );
2522     }
2523 
2524     function log(
2525         string memory p0,
2526         uint256 p1,
2527         uint256 p2,
2528         string memory p3
2529     ) internal view {
2530         _sendLogPayload(
2531             abi.encodeWithSignature(
2532                 "log(string,uint,uint,string)",
2533                 p0,
2534                 p1,
2535                 p2,
2536                 p3
2537             )
2538         );
2539     }
2540 
2541     function log(
2542         string memory p0,
2543         uint256 p1,
2544         uint256 p2,
2545         bool p3
2546     ) internal view {
2547         _sendLogPayload(
2548             abi.encodeWithSignature(
2549                 "log(string,uint,uint,bool)",
2550                 p0,
2551                 p1,
2552                 p2,
2553                 p3
2554             )
2555         );
2556     }
2557 
2558     function log(
2559         string memory p0,
2560         uint256 p1,
2561         uint256 p2,
2562         address p3
2563     ) internal view {
2564         _sendLogPayload(
2565             abi.encodeWithSignature(
2566                 "log(string,uint,uint,address)",
2567                 p0,
2568                 p1,
2569                 p2,
2570                 p3
2571             )
2572         );
2573     }
2574 
2575     function log(
2576         string memory p0,
2577         uint256 p1,
2578         string memory p2,
2579         uint256 p3
2580     ) internal view {
2581         _sendLogPayload(
2582             abi.encodeWithSignature(
2583                 "log(string,uint,string,uint)",
2584                 p0,
2585                 p1,
2586                 p2,
2587                 p3
2588             )
2589         );
2590     }
2591 
2592     function log(
2593         string memory p0,
2594         uint256 p1,
2595         string memory p2,
2596         string memory p3
2597     ) internal view {
2598         _sendLogPayload(
2599             abi.encodeWithSignature(
2600                 "log(string,uint,string,string)",
2601                 p0,
2602                 p1,
2603                 p2,
2604                 p3
2605             )
2606         );
2607     }
2608 
2609     function log(
2610         string memory p0,
2611         uint256 p1,
2612         string memory p2,
2613         bool p3
2614     ) internal view {
2615         _sendLogPayload(
2616             abi.encodeWithSignature(
2617                 "log(string,uint,string,bool)",
2618                 p0,
2619                 p1,
2620                 p2,
2621                 p3
2622             )
2623         );
2624     }
2625 
2626     function log(
2627         string memory p0,
2628         uint256 p1,
2629         string memory p2,
2630         address p3
2631     ) internal view {
2632         _sendLogPayload(
2633             abi.encodeWithSignature(
2634                 "log(string,uint,string,address)",
2635                 p0,
2636                 p1,
2637                 p2,
2638                 p3
2639             )
2640         );
2641     }
2642 
2643     function log(
2644         string memory p0,
2645         uint256 p1,
2646         bool p2,
2647         uint256 p3
2648     ) internal view {
2649         _sendLogPayload(
2650             abi.encodeWithSignature(
2651                 "log(string,uint,bool,uint)",
2652                 p0,
2653                 p1,
2654                 p2,
2655                 p3
2656             )
2657         );
2658     }
2659 
2660     function log(
2661         string memory p0,
2662         uint256 p1,
2663         bool p2,
2664         string memory p3
2665     ) internal view {
2666         _sendLogPayload(
2667             abi.encodeWithSignature(
2668                 "log(string,uint,bool,string)",
2669                 p0,
2670                 p1,
2671                 p2,
2672                 p3
2673             )
2674         );
2675     }
2676 
2677     function log(
2678         string memory p0,
2679         uint256 p1,
2680         bool p2,
2681         bool p3
2682     ) internal view {
2683         _sendLogPayload(
2684             abi.encodeWithSignature(
2685                 "log(string,uint,bool,bool)",
2686                 p0,
2687                 p1,
2688                 p2,
2689                 p3
2690             )
2691         );
2692     }
2693 
2694     function log(
2695         string memory p0,
2696         uint256 p1,
2697         bool p2,
2698         address p3
2699     ) internal view {
2700         _sendLogPayload(
2701             abi.encodeWithSignature(
2702                 "log(string,uint,bool,address)",
2703                 p0,
2704                 p1,
2705                 p2,
2706                 p3
2707             )
2708         );
2709     }
2710 
2711     function log(
2712         string memory p0,
2713         uint256 p1,
2714         address p2,
2715         uint256 p3
2716     ) internal view {
2717         _sendLogPayload(
2718             abi.encodeWithSignature(
2719                 "log(string,uint,address,uint)",
2720                 p0,
2721                 p1,
2722                 p2,
2723                 p3
2724             )
2725         );
2726     }
2727 
2728     function log(
2729         string memory p0,
2730         uint256 p1,
2731         address p2,
2732         string memory p3
2733     ) internal view {
2734         _sendLogPayload(
2735             abi.encodeWithSignature(
2736                 "log(string,uint,address,string)",
2737                 p0,
2738                 p1,
2739                 p2,
2740                 p3
2741             )
2742         );
2743     }
2744 
2745     function log(
2746         string memory p0,
2747         uint256 p1,
2748         address p2,
2749         bool p3
2750     ) internal view {
2751         _sendLogPayload(
2752             abi.encodeWithSignature(
2753                 "log(string,uint,address,bool)",
2754                 p0,
2755                 p1,
2756                 p2,
2757                 p3
2758             )
2759         );
2760     }
2761 
2762     function log(
2763         string memory p0,
2764         uint256 p1,
2765         address p2,
2766         address p3
2767     ) internal view {
2768         _sendLogPayload(
2769             abi.encodeWithSignature(
2770                 "log(string,uint,address,address)",
2771                 p0,
2772                 p1,
2773                 p2,
2774                 p3
2775             )
2776         );
2777     }
2778 
2779     function log(
2780         string memory p0,
2781         string memory p1,
2782         uint256 p2,
2783         uint256 p3
2784     ) internal view {
2785         _sendLogPayload(
2786             abi.encodeWithSignature(
2787                 "log(string,string,uint,uint)",
2788                 p0,
2789                 p1,
2790                 p2,
2791                 p3
2792             )
2793         );
2794     }
2795 
2796     function log(
2797         string memory p0,
2798         string memory p1,
2799         uint256 p2,
2800         string memory p3
2801     ) internal view {
2802         _sendLogPayload(
2803             abi.encodeWithSignature(
2804                 "log(string,string,uint,string)",
2805                 p0,
2806                 p1,
2807                 p2,
2808                 p3
2809             )
2810         );
2811     }
2812 
2813     function log(
2814         string memory p0,
2815         string memory p1,
2816         uint256 p2,
2817         bool p3
2818     ) internal view {
2819         _sendLogPayload(
2820             abi.encodeWithSignature(
2821                 "log(string,string,uint,bool)",
2822                 p0,
2823                 p1,
2824                 p2,
2825                 p3
2826             )
2827         );
2828     }
2829 
2830     function log(
2831         string memory p0,
2832         string memory p1,
2833         uint256 p2,
2834         address p3
2835     ) internal view {
2836         _sendLogPayload(
2837             abi.encodeWithSignature(
2838                 "log(string,string,uint,address)",
2839                 p0,
2840                 p1,
2841                 p2,
2842                 p3
2843             )
2844         );
2845     }
2846 
2847     function log(
2848         string memory p0,
2849         string memory p1,
2850         string memory p2,
2851         uint256 p3
2852     ) internal view {
2853         _sendLogPayload(
2854             abi.encodeWithSignature(
2855                 "log(string,string,string,uint)",
2856                 p0,
2857                 p1,
2858                 p2,
2859                 p3
2860             )
2861         );
2862     }
2863 
2864     function log(
2865         string memory p0,
2866         string memory p1,
2867         string memory p2,
2868         string memory p3
2869     ) internal view {
2870         _sendLogPayload(
2871             abi.encodeWithSignature(
2872                 "log(string,string,string,string)",
2873                 p0,
2874                 p1,
2875                 p2,
2876                 p3
2877             )
2878         );
2879     }
2880 
2881     function log(
2882         string memory p0,
2883         string memory p1,
2884         string memory p2,
2885         bool p3
2886     ) internal view {
2887         _sendLogPayload(
2888             abi.encodeWithSignature(
2889                 "log(string,string,string,bool)",
2890                 p0,
2891                 p1,
2892                 p2,
2893                 p3
2894             )
2895         );
2896     }
2897 
2898     function log(
2899         string memory p0,
2900         string memory p1,
2901         string memory p2,
2902         address p3
2903     ) internal view {
2904         _sendLogPayload(
2905             abi.encodeWithSignature(
2906                 "log(string,string,string,address)",
2907                 p0,
2908                 p1,
2909                 p2,
2910                 p3
2911             )
2912         );
2913     }
2914 
2915     function log(
2916         string memory p0,
2917         string memory p1,
2918         bool p2,
2919         uint256 p3
2920     ) internal view {
2921         _sendLogPayload(
2922             abi.encodeWithSignature(
2923                 "log(string,string,bool,uint)",
2924                 p0,
2925                 p1,
2926                 p2,
2927                 p3
2928             )
2929         );
2930     }
2931 
2932     function log(
2933         string memory p0,
2934         string memory p1,
2935         bool p2,
2936         string memory p3
2937     ) internal view {
2938         _sendLogPayload(
2939             abi.encodeWithSignature(
2940                 "log(string,string,bool,string)",
2941                 p0,
2942                 p1,
2943                 p2,
2944                 p3
2945             )
2946         );
2947     }
2948 
2949     function log(
2950         string memory p0,
2951         string memory p1,
2952         bool p2,
2953         bool p3
2954     ) internal view {
2955         _sendLogPayload(
2956             abi.encodeWithSignature(
2957                 "log(string,string,bool,bool)",
2958                 p0,
2959                 p1,
2960                 p2,
2961                 p3
2962             )
2963         );
2964     }
2965 
2966     function log(
2967         string memory p0,
2968         string memory p1,
2969         bool p2,
2970         address p3
2971     ) internal view {
2972         _sendLogPayload(
2973             abi.encodeWithSignature(
2974                 "log(string,string,bool,address)",
2975                 p0,
2976                 p1,
2977                 p2,
2978                 p3
2979             )
2980         );
2981     }
2982 
2983     function log(
2984         string memory p0,
2985         string memory p1,
2986         address p2,
2987         uint256 p3
2988     ) internal view {
2989         _sendLogPayload(
2990             abi.encodeWithSignature(
2991                 "log(string,string,address,uint)",
2992                 p0,
2993                 p1,
2994                 p2,
2995                 p3
2996             )
2997         );
2998     }
2999 
3000     function log(
3001         string memory p0,
3002         string memory p1,
3003         address p2,
3004         string memory p3
3005     ) internal view {
3006         _sendLogPayload(
3007             abi.encodeWithSignature(
3008                 "log(string,string,address,string)",
3009                 p0,
3010                 p1,
3011                 p2,
3012                 p3
3013             )
3014         );
3015     }
3016 
3017     function log(
3018         string memory p0,
3019         string memory p1,
3020         address p2,
3021         bool p3
3022     ) internal view {
3023         _sendLogPayload(
3024             abi.encodeWithSignature(
3025                 "log(string,string,address,bool)",
3026                 p0,
3027                 p1,
3028                 p2,
3029                 p3
3030             )
3031         );
3032     }
3033 
3034     function log(
3035         string memory p0,
3036         string memory p1,
3037         address p2,
3038         address p3
3039     ) internal view {
3040         _sendLogPayload(
3041             abi.encodeWithSignature(
3042                 "log(string,string,address,address)",
3043                 p0,
3044                 p1,
3045                 p2,
3046                 p3
3047             )
3048         );
3049     }
3050 
3051     function log(
3052         string memory p0,
3053         bool p1,
3054         uint256 p2,
3055         uint256 p3
3056     ) internal view {
3057         _sendLogPayload(
3058             abi.encodeWithSignature(
3059                 "log(string,bool,uint,uint)",
3060                 p0,
3061                 p1,
3062                 p2,
3063                 p3
3064             )
3065         );
3066     }
3067 
3068     function log(
3069         string memory p0,
3070         bool p1,
3071         uint256 p2,
3072         string memory p3
3073     ) internal view {
3074         _sendLogPayload(
3075             abi.encodeWithSignature(
3076                 "log(string,bool,uint,string)",
3077                 p0,
3078                 p1,
3079                 p2,
3080                 p3
3081             )
3082         );
3083     }
3084 
3085     function log(
3086         string memory p0,
3087         bool p1,
3088         uint256 p2,
3089         bool p3
3090     ) internal view {
3091         _sendLogPayload(
3092             abi.encodeWithSignature(
3093                 "log(string,bool,uint,bool)",
3094                 p0,
3095                 p1,
3096                 p2,
3097                 p3
3098             )
3099         );
3100     }
3101 
3102     function log(
3103         string memory p0,
3104         bool p1,
3105         uint256 p2,
3106         address p3
3107     ) internal view {
3108         _sendLogPayload(
3109             abi.encodeWithSignature(
3110                 "log(string,bool,uint,address)",
3111                 p0,
3112                 p1,
3113                 p2,
3114                 p3
3115             )
3116         );
3117     }
3118 
3119     function log(
3120         string memory p0,
3121         bool p1,
3122         string memory p2,
3123         uint256 p3
3124     ) internal view {
3125         _sendLogPayload(
3126             abi.encodeWithSignature(
3127                 "log(string,bool,string,uint)",
3128                 p0,
3129                 p1,
3130                 p2,
3131                 p3
3132             )
3133         );
3134     }
3135 
3136     function log(
3137         string memory p0,
3138         bool p1,
3139         string memory p2,
3140         string memory p3
3141     ) internal view {
3142         _sendLogPayload(
3143             abi.encodeWithSignature(
3144                 "log(string,bool,string,string)",
3145                 p0,
3146                 p1,
3147                 p2,
3148                 p3
3149             )
3150         );
3151     }
3152 
3153     function log(
3154         string memory p0,
3155         bool p1,
3156         string memory p2,
3157         bool p3
3158     ) internal view {
3159         _sendLogPayload(
3160             abi.encodeWithSignature(
3161                 "log(string,bool,string,bool)",
3162                 p0,
3163                 p1,
3164                 p2,
3165                 p3
3166             )
3167         );
3168     }
3169 
3170     function log(
3171         string memory p0,
3172         bool p1,
3173         string memory p2,
3174         address p3
3175     ) internal view {
3176         _sendLogPayload(
3177             abi.encodeWithSignature(
3178                 "log(string,bool,string,address)",
3179                 p0,
3180                 p1,
3181                 p2,
3182                 p3
3183             )
3184         );
3185     }
3186 
3187     function log(
3188         string memory p0,
3189         bool p1,
3190         bool p2,
3191         uint256 p3
3192     ) internal view {
3193         _sendLogPayload(
3194             abi.encodeWithSignature(
3195                 "log(string,bool,bool,uint)",
3196                 p0,
3197                 p1,
3198                 p2,
3199                 p3
3200             )
3201         );
3202     }
3203 
3204     function log(
3205         string memory p0,
3206         bool p1,
3207         bool p2,
3208         string memory p3
3209     ) internal view {
3210         _sendLogPayload(
3211             abi.encodeWithSignature(
3212                 "log(string,bool,bool,string)",
3213                 p0,
3214                 p1,
3215                 p2,
3216                 p3
3217             )
3218         );
3219     }
3220 
3221     function log(
3222         string memory p0,
3223         bool p1,
3224         bool p2,
3225         bool p3
3226     ) internal view {
3227         _sendLogPayload(
3228             abi.encodeWithSignature(
3229                 "log(string,bool,bool,bool)",
3230                 p0,
3231                 p1,
3232                 p2,
3233                 p3
3234             )
3235         );
3236     }
3237 
3238     function log(
3239         string memory p0,
3240         bool p1,
3241         bool p2,
3242         address p3
3243     ) internal view {
3244         _sendLogPayload(
3245             abi.encodeWithSignature(
3246                 "log(string,bool,bool,address)",
3247                 p0,
3248                 p1,
3249                 p2,
3250                 p3
3251             )
3252         );
3253     }
3254 
3255     function log(
3256         string memory p0,
3257         bool p1,
3258         address p2,
3259         uint256 p3
3260     ) internal view {
3261         _sendLogPayload(
3262             abi.encodeWithSignature(
3263                 "log(string,bool,address,uint)",
3264                 p0,
3265                 p1,
3266                 p2,
3267                 p3
3268             )
3269         );
3270     }
3271 
3272     function log(
3273         string memory p0,
3274         bool p1,
3275         address p2,
3276         string memory p3
3277     ) internal view {
3278         _sendLogPayload(
3279             abi.encodeWithSignature(
3280                 "log(string,bool,address,string)",
3281                 p0,
3282                 p1,
3283                 p2,
3284                 p3
3285             )
3286         );
3287     }
3288 
3289     function log(
3290         string memory p0,
3291         bool p1,
3292         address p2,
3293         bool p3
3294     ) internal view {
3295         _sendLogPayload(
3296             abi.encodeWithSignature(
3297                 "log(string,bool,address,bool)",
3298                 p0,
3299                 p1,
3300                 p2,
3301                 p3
3302             )
3303         );
3304     }
3305 
3306     function log(
3307         string memory p0,
3308         bool p1,
3309         address p2,
3310         address p3
3311     ) internal view {
3312         _sendLogPayload(
3313             abi.encodeWithSignature(
3314                 "log(string,bool,address,address)",
3315                 p0,
3316                 p1,
3317                 p2,
3318                 p3
3319             )
3320         );
3321     }
3322 
3323     function log(
3324         string memory p0,
3325         address p1,
3326         uint256 p2,
3327         uint256 p3
3328     ) internal view {
3329         _sendLogPayload(
3330             abi.encodeWithSignature(
3331                 "log(string,address,uint,uint)",
3332                 p0,
3333                 p1,
3334                 p2,
3335                 p3
3336             )
3337         );
3338     }
3339 
3340     function log(
3341         string memory p0,
3342         address p1,
3343         uint256 p2,
3344         string memory p3
3345     ) internal view {
3346         _sendLogPayload(
3347             abi.encodeWithSignature(
3348                 "log(string,address,uint,string)",
3349                 p0,
3350                 p1,
3351                 p2,
3352                 p3
3353             )
3354         );
3355     }
3356 
3357     function log(
3358         string memory p0,
3359         address p1,
3360         uint256 p2,
3361         bool p3
3362     ) internal view {
3363         _sendLogPayload(
3364             abi.encodeWithSignature(
3365                 "log(string,address,uint,bool)",
3366                 p0,
3367                 p1,
3368                 p2,
3369                 p3
3370             )
3371         );
3372     }
3373 
3374     function log(
3375         string memory p0,
3376         address p1,
3377         uint256 p2,
3378         address p3
3379     ) internal view {
3380         _sendLogPayload(
3381             abi.encodeWithSignature(
3382                 "log(string,address,uint,address)",
3383                 p0,
3384                 p1,
3385                 p2,
3386                 p3
3387             )
3388         );
3389     }
3390 
3391     function log(
3392         string memory p0,
3393         address p1,
3394         string memory p2,
3395         uint256 p3
3396     ) internal view {
3397         _sendLogPayload(
3398             abi.encodeWithSignature(
3399                 "log(string,address,string,uint)",
3400                 p0,
3401                 p1,
3402                 p2,
3403                 p3
3404             )
3405         );
3406     }
3407 
3408     function log(
3409         string memory p0,
3410         address p1,
3411         string memory p2,
3412         string memory p3
3413     ) internal view {
3414         _sendLogPayload(
3415             abi.encodeWithSignature(
3416                 "log(string,address,string,string)",
3417                 p0,
3418                 p1,
3419                 p2,
3420                 p3
3421             )
3422         );
3423     }
3424 
3425     function log(
3426         string memory p0,
3427         address p1,
3428         string memory p2,
3429         bool p3
3430     ) internal view {
3431         _sendLogPayload(
3432             abi.encodeWithSignature(
3433                 "log(string,address,string,bool)",
3434                 p0,
3435                 p1,
3436                 p2,
3437                 p3
3438             )
3439         );
3440     }
3441 
3442     function log(
3443         string memory p0,
3444         address p1,
3445         string memory p2,
3446         address p3
3447     ) internal view {
3448         _sendLogPayload(
3449             abi.encodeWithSignature(
3450                 "log(string,address,string,address)",
3451                 p0,
3452                 p1,
3453                 p2,
3454                 p3
3455             )
3456         );
3457     }
3458 
3459     function log(
3460         string memory p0,
3461         address p1,
3462         bool p2,
3463         uint256 p3
3464     ) internal view {
3465         _sendLogPayload(
3466             abi.encodeWithSignature(
3467                 "log(string,address,bool,uint)",
3468                 p0,
3469                 p1,
3470                 p2,
3471                 p3
3472             )
3473         );
3474     }
3475 
3476     function log(
3477         string memory p0,
3478         address p1,
3479         bool p2,
3480         string memory p3
3481     ) internal view {
3482         _sendLogPayload(
3483             abi.encodeWithSignature(
3484                 "log(string,address,bool,string)",
3485                 p0,
3486                 p1,
3487                 p2,
3488                 p3
3489             )
3490         );
3491     }
3492 
3493     function log(
3494         string memory p0,
3495         address p1,
3496         bool p2,
3497         bool p3
3498     ) internal view {
3499         _sendLogPayload(
3500             abi.encodeWithSignature(
3501                 "log(string,address,bool,bool)",
3502                 p0,
3503                 p1,
3504                 p2,
3505                 p3
3506             )
3507         );
3508     }
3509 
3510     function log(
3511         string memory p0,
3512         address p1,
3513         bool p2,
3514         address p3
3515     ) internal view {
3516         _sendLogPayload(
3517             abi.encodeWithSignature(
3518                 "log(string,address,bool,address)",
3519                 p0,
3520                 p1,
3521                 p2,
3522                 p3
3523             )
3524         );
3525     }
3526 
3527     function log(
3528         string memory p0,
3529         address p1,
3530         address p2,
3531         uint256 p3
3532     ) internal view {
3533         _sendLogPayload(
3534             abi.encodeWithSignature(
3535                 "log(string,address,address,uint)",
3536                 p0,
3537                 p1,
3538                 p2,
3539                 p3
3540             )
3541         );
3542     }
3543 
3544     function log(
3545         string memory p0,
3546         address p1,
3547         address p2,
3548         string memory p3
3549     ) internal view {
3550         _sendLogPayload(
3551             abi.encodeWithSignature(
3552                 "log(string,address,address,string)",
3553                 p0,
3554                 p1,
3555                 p2,
3556                 p3
3557             )
3558         );
3559     }
3560 
3561     function log(
3562         string memory p0,
3563         address p1,
3564         address p2,
3565         bool p3
3566     ) internal view {
3567         _sendLogPayload(
3568             abi.encodeWithSignature(
3569                 "log(string,address,address,bool)",
3570                 p0,
3571                 p1,
3572                 p2,
3573                 p3
3574             )
3575         );
3576     }
3577 
3578     function log(
3579         string memory p0,
3580         address p1,
3581         address p2,
3582         address p3
3583     ) internal view {
3584         _sendLogPayload(
3585             abi.encodeWithSignature(
3586                 "log(string,address,address,address)",
3587                 p0,
3588                 p1,
3589                 p2,
3590                 p3
3591             )
3592         );
3593     }
3594 
3595     function log(
3596         bool p0,
3597         uint256 p1,
3598         uint256 p2,
3599         uint256 p3
3600     ) internal view {
3601         _sendLogPayload(
3602             abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3)
3603         );
3604     }
3605 
3606     function log(
3607         bool p0,
3608         uint256 p1,
3609         uint256 p2,
3610         string memory p3
3611     ) internal view {
3612         _sendLogPayload(
3613             abi.encodeWithSignature(
3614                 "log(bool,uint,uint,string)",
3615                 p0,
3616                 p1,
3617                 p2,
3618                 p3
3619             )
3620         );
3621     }
3622 
3623     function log(
3624         bool p0,
3625         uint256 p1,
3626         uint256 p2,
3627         bool p3
3628     ) internal view {
3629         _sendLogPayload(
3630             abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3)
3631         );
3632     }
3633 
3634     function log(
3635         bool p0,
3636         uint256 p1,
3637         uint256 p2,
3638         address p3
3639     ) internal view {
3640         _sendLogPayload(
3641             abi.encodeWithSignature(
3642                 "log(bool,uint,uint,address)",
3643                 p0,
3644                 p1,
3645                 p2,
3646                 p3
3647             )
3648         );
3649     }
3650 
3651     function log(
3652         bool p0,
3653         uint256 p1,
3654         string memory p2,
3655         uint256 p3
3656     ) internal view {
3657         _sendLogPayload(
3658             abi.encodeWithSignature(
3659                 "log(bool,uint,string,uint)",
3660                 p0,
3661                 p1,
3662                 p2,
3663                 p3
3664             )
3665         );
3666     }
3667 
3668     function log(
3669         bool p0,
3670         uint256 p1,
3671         string memory p2,
3672         string memory p3
3673     ) internal view {
3674         _sendLogPayload(
3675             abi.encodeWithSignature(
3676                 "log(bool,uint,string,string)",
3677                 p0,
3678                 p1,
3679                 p2,
3680                 p3
3681             )
3682         );
3683     }
3684 
3685     function log(
3686         bool p0,
3687         uint256 p1,
3688         string memory p2,
3689         bool p3
3690     ) internal view {
3691         _sendLogPayload(
3692             abi.encodeWithSignature(
3693                 "log(bool,uint,string,bool)",
3694                 p0,
3695                 p1,
3696                 p2,
3697                 p3
3698             )
3699         );
3700     }
3701 
3702     function log(
3703         bool p0,
3704         uint256 p1,
3705         string memory p2,
3706         address p3
3707     ) internal view {
3708         _sendLogPayload(
3709             abi.encodeWithSignature(
3710                 "log(bool,uint,string,address)",
3711                 p0,
3712                 p1,
3713                 p2,
3714                 p3
3715             )
3716         );
3717     }
3718 
3719     function log(
3720         bool p0,
3721         uint256 p1,
3722         bool p2,
3723         uint256 p3
3724     ) internal view {
3725         _sendLogPayload(
3726             abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3)
3727         );
3728     }
3729 
3730     function log(
3731         bool p0,
3732         uint256 p1,
3733         bool p2,
3734         string memory p3
3735     ) internal view {
3736         _sendLogPayload(
3737             abi.encodeWithSignature(
3738                 "log(bool,uint,bool,string)",
3739                 p0,
3740                 p1,
3741                 p2,
3742                 p3
3743             )
3744         );
3745     }
3746 
3747     function log(
3748         bool p0,
3749         uint256 p1,
3750         bool p2,
3751         bool p3
3752     ) internal view {
3753         _sendLogPayload(
3754             abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3)
3755         );
3756     }
3757 
3758     function log(
3759         bool p0,
3760         uint256 p1,
3761         bool p2,
3762         address p3
3763     ) internal view {
3764         _sendLogPayload(
3765             abi.encodeWithSignature(
3766                 "log(bool,uint,bool,address)",
3767                 p0,
3768                 p1,
3769                 p2,
3770                 p3
3771             )
3772         );
3773     }
3774 
3775     function log(
3776         bool p0,
3777         uint256 p1,
3778         address p2,
3779         uint256 p3
3780     ) internal view {
3781         _sendLogPayload(
3782             abi.encodeWithSignature(
3783                 "log(bool,uint,address,uint)",
3784                 p0,
3785                 p1,
3786                 p2,
3787                 p3
3788             )
3789         );
3790     }
3791 
3792     function log(
3793         bool p0,
3794         uint256 p1,
3795         address p2,
3796         string memory p3
3797     ) internal view {
3798         _sendLogPayload(
3799             abi.encodeWithSignature(
3800                 "log(bool,uint,address,string)",
3801                 p0,
3802                 p1,
3803                 p2,
3804                 p3
3805             )
3806         );
3807     }
3808 
3809     function log(
3810         bool p0,
3811         uint256 p1,
3812         address p2,
3813         bool p3
3814     ) internal view {
3815         _sendLogPayload(
3816             abi.encodeWithSignature(
3817                 "log(bool,uint,address,bool)",
3818                 p0,
3819                 p1,
3820                 p2,
3821                 p3
3822             )
3823         );
3824     }
3825 
3826     function log(
3827         bool p0,
3828         uint256 p1,
3829         address p2,
3830         address p3
3831     ) internal view {
3832         _sendLogPayload(
3833             abi.encodeWithSignature(
3834                 "log(bool,uint,address,address)",
3835                 p0,
3836                 p1,
3837                 p2,
3838                 p3
3839             )
3840         );
3841     }
3842 
3843     function log(
3844         bool p0,
3845         string memory p1,
3846         uint256 p2,
3847         uint256 p3
3848     ) internal view {
3849         _sendLogPayload(
3850             abi.encodeWithSignature(
3851                 "log(bool,string,uint,uint)",
3852                 p0,
3853                 p1,
3854                 p2,
3855                 p3
3856             )
3857         );
3858     }
3859 
3860     function log(
3861         bool p0,
3862         string memory p1,
3863         uint256 p2,
3864         string memory p3
3865     ) internal view {
3866         _sendLogPayload(
3867             abi.encodeWithSignature(
3868                 "log(bool,string,uint,string)",
3869                 p0,
3870                 p1,
3871                 p2,
3872                 p3
3873             )
3874         );
3875     }
3876 
3877     function log(
3878         bool p0,
3879         string memory p1,
3880         uint256 p2,
3881         bool p3
3882     ) internal view {
3883         _sendLogPayload(
3884             abi.encodeWithSignature(
3885                 "log(bool,string,uint,bool)",
3886                 p0,
3887                 p1,
3888                 p2,
3889                 p3
3890             )
3891         );
3892     }
3893 
3894     function log(
3895         bool p0,
3896         string memory p1,
3897         uint256 p2,
3898         address p3
3899     ) internal view {
3900         _sendLogPayload(
3901             abi.encodeWithSignature(
3902                 "log(bool,string,uint,address)",
3903                 p0,
3904                 p1,
3905                 p2,
3906                 p3
3907             )
3908         );
3909     }
3910 
3911     function log(
3912         bool p0,
3913         string memory p1,
3914         string memory p2,
3915         uint256 p3
3916     ) internal view {
3917         _sendLogPayload(
3918             abi.encodeWithSignature(
3919                 "log(bool,string,string,uint)",
3920                 p0,
3921                 p1,
3922                 p2,
3923                 p3
3924             )
3925         );
3926     }
3927 
3928     function log(
3929         bool p0,
3930         string memory p1,
3931         string memory p2,
3932         string memory p3
3933     ) internal view {
3934         _sendLogPayload(
3935             abi.encodeWithSignature(
3936                 "log(bool,string,string,string)",
3937                 p0,
3938                 p1,
3939                 p2,
3940                 p3
3941             )
3942         );
3943     }
3944 
3945     function log(
3946         bool p0,
3947         string memory p1,
3948         string memory p2,
3949         bool p3
3950     ) internal view {
3951         _sendLogPayload(
3952             abi.encodeWithSignature(
3953                 "log(bool,string,string,bool)",
3954                 p0,
3955                 p1,
3956                 p2,
3957                 p3
3958             )
3959         );
3960     }
3961 
3962     function log(
3963         bool p0,
3964         string memory p1,
3965         string memory p2,
3966         address p3
3967     ) internal view {
3968         _sendLogPayload(
3969             abi.encodeWithSignature(
3970                 "log(bool,string,string,address)",
3971                 p0,
3972                 p1,
3973                 p2,
3974                 p3
3975             )
3976         );
3977     }
3978 
3979     function log(
3980         bool p0,
3981         string memory p1,
3982         bool p2,
3983         uint256 p3
3984     ) internal view {
3985         _sendLogPayload(
3986             abi.encodeWithSignature(
3987                 "log(bool,string,bool,uint)",
3988                 p0,
3989                 p1,
3990                 p2,
3991                 p3
3992             )
3993         );
3994     }
3995 
3996     function log(
3997         bool p0,
3998         string memory p1,
3999         bool p2,
4000         string memory p3
4001     ) internal view {
4002         _sendLogPayload(
4003             abi.encodeWithSignature(
4004                 "log(bool,string,bool,string)",
4005                 p0,
4006                 p1,
4007                 p2,
4008                 p3
4009             )
4010         );
4011     }
4012 
4013     function log(
4014         bool p0,
4015         string memory p1,
4016         bool p2,
4017         bool p3
4018     ) internal view {
4019         _sendLogPayload(
4020             abi.encodeWithSignature(
4021                 "log(bool,string,bool,bool)",
4022                 p0,
4023                 p1,
4024                 p2,
4025                 p3
4026             )
4027         );
4028     }
4029 
4030     function log(
4031         bool p0,
4032         string memory p1,
4033         bool p2,
4034         address p3
4035     ) internal view {
4036         _sendLogPayload(
4037             abi.encodeWithSignature(
4038                 "log(bool,string,bool,address)",
4039                 p0,
4040                 p1,
4041                 p2,
4042                 p3
4043             )
4044         );
4045     }
4046 
4047     function log(
4048         bool p0,
4049         string memory p1,
4050         address p2,
4051         uint256 p3
4052     ) internal view {
4053         _sendLogPayload(
4054             abi.encodeWithSignature(
4055                 "log(bool,string,address,uint)",
4056                 p0,
4057                 p1,
4058                 p2,
4059                 p3
4060             )
4061         );
4062     }
4063 
4064     function log(
4065         bool p0,
4066         string memory p1,
4067         address p2,
4068         string memory p3
4069     ) internal view {
4070         _sendLogPayload(
4071             abi.encodeWithSignature(
4072                 "log(bool,string,address,string)",
4073                 p0,
4074                 p1,
4075                 p2,
4076                 p3
4077             )
4078         );
4079     }
4080 
4081     function log(
4082         bool p0,
4083         string memory p1,
4084         address p2,
4085         bool p3
4086     ) internal view {
4087         _sendLogPayload(
4088             abi.encodeWithSignature(
4089                 "log(bool,string,address,bool)",
4090                 p0,
4091                 p1,
4092                 p2,
4093                 p3
4094             )
4095         );
4096     }
4097 
4098     function log(
4099         bool p0,
4100         string memory p1,
4101         address p2,
4102         address p3
4103     ) internal view {
4104         _sendLogPayload(
4105             abi.encodeWithSignature(
4106                 "log(bool,string,address,address)",
4107                 p0,
4108                 p1,
4109                 p2,
4110                 p3
4111             )
4112         );
4113     }
4114 
4115     function log(
4116         bool p0,
4117         bool p1,
4118         uint256 p2,
4119         uint256 p3
4120     ) internal view {
4121         _sendLogPayload(
4122             abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3)
4123         );
4124     }
4125 
4126     function log(
4127         bool p0,
4128         bool p1,
4129         uint256 p2,
4130         string memory p3
4131     ) internal view {
4132         _sendLogPayload(
4133             abi.encodeWithSignature(
4134                 "log(bool,bool,uint,string)",
4135                 p0,
4136                 p1,
4137                 p2,
4138                 p3
4139             )
4140         );
4141     }
4142 
4143     function log(
4144         bool p0,
4145         bool p1,
4146         uint256 p2,
4147         bool p3
4148     ) internal view {
4149         _sendLogPayload(
4150             abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3)
4151         );
4152     }
4153 
4154     function log(
4155         bool p0,
4156         bool p1,
4157         uint256 p2,
4158         address p3
4159     ) internal view {
4160         _sendLogPayload(
4161             abi.encodeWithSignature(
4162                 "log(bool,bool,uint,address)",
4163                 p0,
4164                 p1,
4165                 p2,
4166                 p3
4167             )
4168         );
4169     }
4170 
4171     function log(
4172         bool p0,
4173         bool p1,
4174         string memory p2,
4175         uint256 p3
4176     ) internal view {
4177         _sendLogPayload(
4178             abi.encodeWithSignature(
4179                 "log(bool,bool,string,uint)",
4180                 p0,
4181                 p1,
4182                 p2,
4183                 p3
4184             )
4185         );
4186     }
4187 
4188     function log(
4189         bool p0,
4190         bool p1,
4191         string memory p2,
4192         string memory p3
4193     ) internal view {
4194         _sendLogPayload(
4195             abi.encodeWithSignature(
4196                 "log(bool,bool,string,string)",
4197                 p0,
4198                 p1,
4199                 p2,
4200                 p3
4201             )
4202         );
4203     }
4204 
4205     function log(
4206         bool p0,
4207         bool p1,
4208         string memory p2,
4209         bool p3
4210     ) internal view {
4211         _sendLogPayload(
4212             abi.encodeWithSignature(
4213                 "log(bool,bool,string,bool)",
4214                 p0,
4215                 p1,
4216                 p2,
4217                 p3
4218             )
4219         );
4220     }
4221 
4222     function log(
4223         bool p0,
4224         bool p1,
4225         string memory p2,
4226         address p3
4227     ) internal view {
4228         _sendLogPayload(
4229             abi.encodeWithSignature(
4230                 "log(bool,bool,string,address)",
4231                 p0,
4232                 p1,
4233                 p2,
4234                 p3
4235             )
4236         );
4237     }
4238 
4239     function log(
4240         bool p0,
4241         bool p1,
4242         bool p2,
4243         uint256 p3
4244     ) internal view {
4245         _sendLogPayload(
4246             abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3)
4247         );
4248     }
4249 
4250     function log(
4251         bool p0,
4252         bool p1,
4253         bool p2,
4254         string memory p3
4255     ) internal view {
4256         _sendLogPayload(
4257             abi.encodeWithSignature(
4258                 "log(bool,bool,bool,string)",
4259                 p0,
4260                 p1,
4261                 p2,
4262                 p3
4263             )
4264         );
4265     }
4266 
4267     function log(
4268         bool p0,
4269         bool p1,
4270         bool p2,
4271         bool p3
4272     ) internal view {
4273         _sendLogPayload(
4274             abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3)
4275         );
4276     }
4277 
4278     function log(
4279         bool p0,
4280         bool p1,
4281         bool p2,
4282         address p3
4283     ) internal view {
4284         _sendLogPayload(
4285             abi.encodeWithSignature(
4286                 "log(bool,bool,bool,address)",
4287                 p0,
4288                 p1,
4289                 p2,
4290                 p3
4291             )
4292         );
4293     }
4294 
4295     function log(
4296         bool p0,
4297         bool p1,
4298         address p2,
4299         uint256 p3
4300     ) internal view {
4301         _sendLogPayload(
4302             abi.encodeWithSignature(
4303                 "log(bool,bool,address,uint)",
4304                 p0,
4305                 p1,
4306                 p2,
4307                 p3
4308             )
4309         );
4310     }
4311 
4312     function log(
4313         bool p0,
4314         bool p1,
4315         address p2,
4316         string memory p3
4317     ) internal view {
4318         _sendLogPayload(
4319             abi.encodeWithSignature(
4320                 "log(bool,bool,address,string)",
4321                 p0,
4322                 p1,
4323                 p2,
4324                 p3
4325             )
4326         );
4327     }
4328 
4329     function log(
4330         bool p0,
4331         bool p1,
4332         address p2,
4333         bool p3
4334     ) internal view {
4335         _sendLogPayload(
4336             abi.encodeWithSignature(
4337                 "log(bool,bool,address,bool)",
4338                 p0,
4339                 p1,
4340                 p2,
4341                 p3
4342             )
4343         );
4344     }
4345 
4346     function log(
4347         bool p0,
4348         bool p1,
4349         address p2,
4350         address p3
4351     ) internal view {
4352         _sendLogPayload(
4353             abi.encodeWithSignature(
4354                 "log(bool,bool,address,address)",
4355                 p0,
4356                 p1,
4357                 p2,
4358                 p3
4359             )
4360         );
4361     }
4362 
4363     function log(
4364         bool p0,
4365         address p1,
4366         uint256 p2,
4367         uint256 p3
4368     ) internal view {
4369         _sendLogPayload(
4370             abi.encodeWithSignature(
4371                 "log(bool,address,uint,uint)",
4372                 p0,
4373                 p1,
4374                 p2,
4375                 p3
4376             )
4377         );
4378     }
4379 
4380     function log(
4381         bool p0,
4382         address p1,
4383         uint256 p2,
4384         string memory p3
4385     ) internal view {
4386         _sendLogPayload(
4387             abi.encodeWithSignature(
4388                 "log(bool,address,uint,string)",
4389                 p0,
4390                 p1,
4391                 p2,
4392                 p3
4393             )
4394         );
4395     }
4396 
4397     function log(
4398         bool p0,
4399         address p1,
4400         uint256 p2,
4401         bool p3
4402     ) internal view {
4403         _sendLogPayload(
4404             abi.encodeWithSignature(
4405                 "log(bool,address,uint,bool)",
4406                 p0,
4407                 p1,
4408                 p2,
4409                 p3
4410             )
4411         );
4412     }
4413 
4414     function log(
4415         bool p0,
4416         address p1,
4417         uint256 p2,
4418         address p3
4419     ) internal view {
4420         _sendLogPayload(
4421             abi.encodeWithSignature(
4422                 "log(bool,address,uint,address)",
4423                 p0,
4424                 p1,
4425                 p2,
4426                 p3
4427             )
4428         );
4429     }
4430 
4431     function log(
4432         bool p0,
4433         address p1,
4434         string memory p2,
4435         uint256 p3
4436     ) internal view {
4437         _sendLogPayload(
4438             abi.encodeWithSignature(
4439                 "log(bool,address,string,uint)",
4440                 p0,
4441                 p1,
4442                 p2,
4443                 p3
4444             )
4445         );
4446     }
4447 
4448     function log(
4449         bool p0,
4450         address p1,
4451         string memory p2,
4452         string memory p3
4453     ) internal view {
4454         _sendLogPayload(
4455             abi.encodeWithSignature(
4456                 "log(bool,address,string,string)",
4457                 p0,
4458                 p1,
4459                 p2,
4460                 p3
4461             )
4462         );
4463     }
4464 
4465     function log(
4466         bool p0,
4467         address p1,
4468         string memory p2,
4469         bool p3
4470     ) internal view {
4471         _sendLogPayload(
4472             abi.encodeWithSignature(
4473                 "log(bool,address,string,bool)",
4474                 p0,
4475                 p1,
4476                 p2,
4477                 p3
4478             )
4479         );
4480     }
4481 
4482     function log(
4483         bool p0,
4484         address p1,
4485         string memory p2,
4486         address p3
4487     ) internal view {
4488         _sendLogPayload(
4489             abi.encodeWithSignature(
4490                 "log(bool,address,string,address)",
4491                 p0,
4492                 p1,
4493                 p2,
4494                 p3
4495             )
4496         );
4497     }
4498 
4499     function log(
4500         bool p0,
4501         address p1,
4502         bool p2,
4503         uint256 p3
4504     ) internal view {
4505         _sendLogPayload(
4506             abi.encodeWithSignature(
4507                 "log(bool,address,bool,uint)",
4508                 p0,
4509                 p1,
4510                 p2,
4511                 p3
4512             )
4513         );
4514     }
4515 
4516     function log(
4517         bool p0,
4518         address p1,
4519         bool p2,
4520         string memory p3
4521     ) internal view {
4522         _sendLogPayload(
4523             abi.encodeWithSignature(
4524                 "log(bool,address,bool,string)",
4525                 p0,
4526                 p1,
4527                 p2,
4528                 p3
4529             )
4530         );
4531     }
4532 
4533     function log(
4534         bool p0,
4535         address p1,
4536         bool p2,
4537         bool p3
4538     ) internal view {
4539         _sendLogPayload(
4540             abi.encodeWithSignature(
4541                 "log(bool,address,bool,bool)",
4542                 p0,
4543                 p1,
4544                 p2,
4545                 p3
4546             )
4547         );
4548     }
4549 
4550     function log(
4551         bool p0,
4552         address p1,
4553         bool p2,
4554         address p3
4555     ) internal view {
4556         _sendLogPayload(
4557             abi.encodeWithSignature(
4558                 "log(bool,address,bool,address)",
4559                 p0,
4560                 p1,
4561                 p2,
4562                 p3
4563             )
4564         );
4565     }
4566 
4567     function log(
4568         bool p0,
4569         address p1,
4570         address p2,
4571         uint256 p3
4572     ) internal view {
4573         _sendLogPayload(
4574             abi.encodeWithSignature(
4575                 "log(bool,address,address,uint)",
4576                 p0,
4577                 p1,
4578                 p2,
4579                 p3
4580             )
4581         );
4582     }
4583 
4584     function log(
4585         bool p0,
4586         address p1,
4587         address p2,
4588         string memory p3
4589     ) internal view {
4590         _sendLogPayload(
4591             abi.encodeWithSignature(
4592                 "log(bool,address,address,string)",
4593                 p0,
4594                 p1,
4595                 p2,
4596                 p3
4597             )
4598         );
4599     }
4600 
4601     function log(
4602         bool p0,
4603         address p1,
4604         address p2,
4605         bool p3
4606     ) internal view {
4607         _sendLogPayload(
4608             abi.encodeWithSignature(
4609                 "log(bool,address,address,bool)",
4610                 p0,
4611                 p1,
4612                 p2,
4613                 p3
4614             )
4615         );
4616     }
4617 
4618     function log(
4619         bool p0,
4620         address p1,
4621         address p2,
4622         address p3
4623     ) internal view {
4624         _sendLogPayload(
4625             abi.encodeWithSignature(
4626                 "log(bool,address,address,address)",
4627                 p0,
4628                 p1,
4629                 p2,
4630                 p3
4631             )
4632         );
4633     }
4634 
4635     function log(
4636         address p0,
4637         uint256 p1,
4638         uint256 p2,
4639         uint256 p3
4640     ) internal view {
4641         _sendLogPayload(
4642             abi.encodeWithSignature(
4643                 "log(address,uint,uint,uint)",
4644                 p0,
4645                 p1,
4646                 p2,
4647                 p3
4648             )
4649         );
4650     }
4651 
4652     function log(
4653         address p0,
4654         uint256 p1,
4655         uint256 p2,
4656         string memory p3
4657     ) internal view {
4658         _sendLogPayload(
4659             abi.encodeWithSignature(
4660                 "log(address,uint,uint,string)",
4661                 p0,
4662                 p1,
4663                 p2,
4664                 p3
4665             )
4666         );
4667     }
4668 
4669     function log(
4670         address p0,
4671         uint256 p1,
4672         uint256 p2,
4673         bool p3
4674     ) internal view {
4675         _sendLogPayload(
4676             abi.encodeWithSignature(
4677                 "log(address,uint,uint,bool)",
4678                 p0,
4679                 p1,
4680                 p2,
4681                 p3
4682             )
4683         );
4684     }
4685 
4686     function log(
4687         address p0,
4688         uint256 p1,
4689         uint256 p2,
4690         address p3
4691     ) internal view {
4692         _sendLogPayload(
4693             abi.encodeWithSignature(
4694                 "log(address,uint,uint,address)",
4695                 p0,
4696                 p1,
4697                 p2,
4698                 p3
4699             )
4700         );
4701     }
4702 
4703     function log(
4704         address p0,
4705         uint256 p1,
4706         string memory p2,
4707         uint256 p3
4708     ) internal view {
4709         _sendLogPayload(
4710             abi.encodeWithSignature(
4711                 "log(address,uint,string,uint)",
4712                 p0,
4713                 p1,
4714                 p2,
4715                 p3
4716             )
4717         );
4718     }
4719 
4720     function log(
4721         address p0,
4722         uint256 p1,
4723         string memory p2,
4724         string memory p3
4725     ) internal view {
4726         _sendLogPayload(
4727             abi.encodeWithSignature(
4728                 "log(address,uint,string,string)",
4729                 p0,
4730                 p1,
4731                 p2,
4732                 p3
4733             )
4734         );
4735     }
4736 
4737     function log(
4738         address p0,
4739         uint256 p1,
4740         string memory p2,
4741         bool p3
4742     ) internal view {
4743         _sendLogPayload(
4744             abi.encodeWithSignature(
4745                 "log(address,uint,string,bool)",
4746                 p0,
4747                 p1,
4748                 p2,
4749                 p3
4750             )
4751         );
4752     }
4753 
4754     function log(
4755         address p0,
4756         uint256 p1,
4757         string memory p2,
4758         address p3
4759     ) internal view {
4760         _sendLogPayload(
4761             abi.encodeWithSignature(
4762                 "log(address,uint,string,address)",
4763                 p0,
4764                 p1,
4765                 p2,
4766                 p3
4767             )
4768         );
4769     }
4770 
4771     function log(
4772         address p0,
4773         uint256 p1,
4774         bool p2,
4775         uint256 p3
4776     ) internal view {
4777         _sendLogPayload(
4778             abi.encodeWithSignature(
4779                 "log(address,uint,bool,uint)",
4780                 p0,
4781                 p1,
4782                 p2,
4783                 p3
4784             )
4785         );
4786     }
4787 
4788     function log(
4789         address p0,
4790         uint256 p1,
4791         bool p2,
4792         string memory p3
4793     ) internal view {
4794         _sendLogPayload(
4795             abi.encodeWithSignature(
4796                 "log(address,uint,bool,string)",
4797                 p0,
4798                 p1,
4799                 p2,
4800                 p3
4801             )
4802         );
4803     }
4804 
4805     function log(
4806         address p0,
4807         uint256 p1,
4808         bool p2,
4809         bool p3
4810     ) internal view {
4811         _sendLogPayload(
4812             abi.encodeWithSignature(
4813                 "log(address,uint,bool,bool)",
4814                 p0,
4815                 p1,
4816                 p2,
4817                 p3
4818             )
4819         );
4820     }
4821 
4822     function log(
4823         address p0,
4824         uint256 p1,
4825         bool p2,
4826         address p3
4827     ) internal view {
4828         _sendLogPayload(
4829             abi.encodeWithSignature(
4830                 "log(address,uint,bool,address)",
4831                 p0,
4832                 p1,
4833                 p2,
4834                 p3
4835             )
4836         );
4837     }
4838 
4839     function log(
4840         address p0,
4841         uint256 p1,
4842         address p2,
4843         uint256 p3
4844     ) internal view {
4845         _sendLogPayload(
4846             abi.encodeWithSignature(
4847                 "log(address,uint,address,uint)",
4848                 p0,
4849                 p1,
4850                 p2,
4851                 p3
4852             )
4853         );
4854     }
4855 
4856     function log(
4857         address p0,
4858         uint256 p1,
4859         address p2,
4860         string memory p3
4861     ) internal view {
4862         _sendLogPayload(
4863             abi.encodeWithSignature(
4864                 "log(address,uint,address,string)",
4865                 p0,
4866                 p1,
4867                 p2,
4868                 p3
4869             )
4870         );
4871     }
4872 
4873     function log(
4874         address p0,
4875         uint256 p1,
4876         address p2,
4877         bool p3
4878     ) internal view {
4879         _sendLogPayload(
4880             abi.encodeWithSignature(
4881                 "log(address,uint,address,bool)",
4882                 p0,
4883                 p1,
4884                 p2,
4885                 p3
4886             )
4887         );
4888     }
4889 
4890     function log(
4891         address p0,
4892         uint256 p1,
4893         address p2,
4894         address p3
4895     ) internal view {
4896         _sendLogPayload(
4897             abi.encodeWithSignature(
4898                 "log(address,uint,address,address)",
4899                 p0,
4900                 p1,
4901                 p2,
4902                 p3
4903             )
4904         );
4905     }
4906 
4907     function log(
4908         address p0,
4909         string memory p1,
4910         uint256 p2,
4911         uint256 p3
4912     ) internal view {
4913         _sendLogPayload(
4914             abi.encodeWithSignature(
4915                 "log(address,string,uint,uint)",
4916                 p0,
4917                 p1,
4918                 p2,
4919                 p3
4920             )
4921         );
4922     }
4923 
4924     function log(
4925         address p0,
4926         string memory p1,
4927         uint256 p2,
4928         string memory p3
4929     ) internal view {
4930         _sendLogPayload(
4931             abi.encodeWithSignature(
4932                 "log(address,string,uint,string)",
4933                 p0,
4934                 p1,
4935                 p2,
4936                 p3
4937             )
4938         );
4939     }
4940 
4941     function log(
4942         address p0,
4943         string memory p1,
4944         uint256 p2,
4945         bool p3
4946     ) internal view {
4947         _sendLogPayload(
4948             abi.encodeWithSignature(
4949                 "log(address,string,uint,bool)",
4950                 p0,
4951                 p1,
4952                 p2,
4953                 p3
4954             )
4955         );
4956     }
4957 
4958     function log(
4959         address p0,
4960         string memory p1,
4961         uint256 p2,
4962         address p3
4963     ) internal view {
4964         _sendLogPayload(
4965             abi.encodeWithSignature(
4966                 "log(address,string,uint,address)",
4967                 p0,
4968                 p1,
4969                 p2,
4970                 p3
4971             )
4972         );
4973     }
4974 
4975     function log(
4976         address p0,
4977         string memory p1,
4978         string memory p2,
4979         uint256 p3
4980     ) internal view {
4981         _sendLogPayload(
4982             abi.encodeWithSignature(
4983                 "log(address,string,string,uint)",
4984                 p0,
4985                 p1,
4986                 p2,
4987                 p3
4988             )
4989         );
4990     }
4991 
4992     function log(
4993         address p0,
4994         string memory p1,
4995         string memory p2,
4996         string memory p3
4997     ) internal view {
4998         _sendLogPayload(
4999             abi.encodeWithSignature(
5000                 "log(address,string,string,string)",
5001                 p0,
5002                 p1,
5003                 p2,
5004                 p3
5005             )
5006         );
5007     }
5008 
5009     function log(
5010         address p0,
5011         string memory p1,
5012         string memory p2,
5013         bool p3
5014     ) internal view {
5015         _sendLogPayload(
5016             abi.encodeWithSignature(
5017                 "log(address,string,string,bool)",
5018                 p0,
5019                 p1,
5020                 p2,
5021                 p3
5022             )
5023         );
5024     }
5025 
5026     function log(
5027         address p0,
5028         string memory p1,
5029         string memory p2,
5030         address p3
5031     ) internal view {
5032         _sendLogPayload(
5033             abi.encodeWithSignature(
5034                 "log(address,string,string,address)",
5035                 p0,
5036                 p1,
5037                 p2,
5038                 p3
5039             )
5040         );
5041     }
5042 
5043     function log(
5044         address p0,
5045         string memory p1,
5046         bool p2,
5047         uint256 p3
5048     ) internal view {
5049         _sendLogPayload(
5050             abi.encodeWithSignature(
5051                 "log(address,string,bool,uint)",
5052                 p0,
5053                 p1,
5054                 p2,
5055                 p3
5056             )
5057         );
5058     }
5059 
5060     function log(
5061         address p0,
5062         string memory p1,
5063         bool p2,
5064         string memory p3
5065     ) internal view {
5066         _sendLogPayload(
5067             abi.encodeWithSignature(
5068                 "log(address,string,bool,string)",
5069                 p0,
5070                 p1,
5071                 p2,
5072                 p3
5073             )
5074         );
5075     }
5076 
5077     function log(
5078         address p0,
5079         string memory p1,
5080         bool p2,
5081         bool p3
5082     ) internal view {
5083         _sendLogPayload(
5084             abi.encodeWithSignature(
5085                 "log(address,string,bool,bool)",
5086                 p0,
5087                 p1,
5088                 p2,
5089                 p3
5090             )
5091         );
5092     }
5093 
5094     function log(
5095         address p0,
5096         string memory p1,
5097         bool p2,
5098         address p3
5099     ) internal view {
5100         _sendLogPayload(
5101             abi.encodeWithSignature(
5102                 "log(address,string,bool,address)",
5103                 p0,
5104                 p1,
5105                 p2,
5106                 p3
5107             )
5108         );
5109     }
5110 
5111     function log(
5112         address p0,
5113         string memory p1,
5114         address p2,
5115         uint256 p3
5116     ) internal view {
5117         _sendLogPayload(
5118             abi.encodeWithSignature(
5119                 "log(address,string,address,uint)",
5120                 p0,
5121                 p1,
5122                 p2,
5123                 p3
5124             )
5125         );
5126     }
5127 
5128     function log(
5129         address p0,
5130         string memory p1,
5131         address p2,
5132         string memory p3
5133     ) internal view {
5134         _sendLogPayload(
5135             abi.encodeWithSignature(
5136                 "log(address,string,address,string)",
5137                 p0,
5138                 p1,
5139                 p2,
5140                 p3
5141             )
5142         );
5143     }
5144 
5145     function log(
5146         address p0,
5147         string memory p1,
5148         address p2,
5149         bool p3
5150     ) internal view {
5151         _sendLogPayload(
5152             abi.encodeWithSignature(
5153                 "log(address,string,address,bool)",
5154                 p0,
5155                 p1,
5156                 p2,
5157                 p3
5158             )
5159         );
5160     }
5161 
5162     function log(
5163         address p0,
5164         string memory p1,
5165         address p2,
5166         address p3
5167     ) internal view {
5168         _sendLogPayload(
5169             abi.encodeWithSignature(
5170                 "log(address,string,address,address)",
5171                 p0,
5172                 p1,
5173                 p2,
5174                 p3
5175             )
5176         );
5177     }
5178 
5179     function log(
5180         address p0,
5181         bool p1,
5182         uint256 p2,
5183         uint256 p3
5184     ) internal view {
5185         _sendLogPayload(
5186             abi.encodeWithSignature(
5187                 "log(address,bool,uint,uint)",
5188                 p0,
5189                 p1,
5190                 p2,
5191                 p3
5192             )
5193         );
5194     }
5195 
5196     function log(
5197         address p0,
5198         bool p1,
5199         uint256 p2,
5200         string memory p3
5201     ) internal view {
5202         _sendLogPayload(
5203             abi.encodeWithSignature(
5204                 "log(address,bool,uint,string)",
5205                 p0,
5206                 p1,
5207                 p2,
5208                 p3
5209             )
5210         );
5211     }
5212 
5213     function log(
5214         address p0,
5215         bool p1,
5216         uint256 p2,
5217         bool p3
5218     ) internal view {
5219         _sendLogPayload(
5220             abi.encodeWithSignature(
5221                 "log(address,bool,uint,bool)",
5222                 p0,
5223                 p1,
5224                 p2,
5225                 p3
5226             )
5227         );
5228     }
5229 
5230     function log(
5231         address p0,
5232         bool p1,
5233         uint256 p2,
5234         address p3
5235     ) internal view {
5236         _sendLogPayload(
5237             abi.encodeWithSignature(
5238                 "log(address,bool,uint,address)",
5239                 p0,
5240                 p1,
5241                 p2,
5242                 p3
5243             )
5244         );
5245     }
5246 
5247     function log(
5248         address p0,
5249         bool p1,
5250         string memory p2,
5251         uint256 p3
5252     ) internal view {
5253         _sendLogPayload(
5254             abi.encodeWithSignature(
5255                 "log(address,bool,string,uint)",
5256                 p0,
5257                 p1,
5258                 p2,
5259                 p3
5260             )
5261         );
5262     }
5263 
5264     function log(
5265         address p0,
5266         bool p1,
5267         string memory p2,
5268         string memory p3
5269     ) internal view {
5270         _sendLogPayload(
5271             abi.encodeWithSignature(
5272                 "log(address,bool,string,string)",
5273                 p0,
5274                 p1,
5275                 p2,
5276                 p3
5277             )
5278         );
5279     }
5280 
5281     function log(
5282         address p0,
5283         bool p1,
5284         string memory p2,
5285         bool p3
5286     ) internal view {
5287         _sendLogPayload(
5288             abi.encodeWithSignature(
5289                 "log(address,bool,string,bool)",
5290                 p0,
5291                 p1,
5292                 p2,
5293                 p3
5294             )
5295         );
5296     }
5297 
5298     function log(
5299         address p0,
5300         bool p1,
5301         string memory p2,
5302         address p3
5303     ) internal view {
5304         _sendLogPayload(
5305             abi.encodeWithSignature(
5306                 "log(address,bool,string,address)",
5307                 p0,
5308                 p1,
5309                 p2,
5310                 p3
5311             )
5312         );
5313     }
5314 
5315     function log(
5316         address p0,
5317         bool p1,
5318         bool p2,
5319         uint256 p3
5320     ) internal view {
5321         _sendLogPayload(
5322             abi.encodeWithSignature(
5323                 "log(address,bool,bool,uint)",
5324                 p0,
5325                 p1,
5326                 p2,
5327                 p3
5328             )
5329         );
5330     }
5331 
5332     function log(
5333         address p0,
5334         bool p1,
5335         bool p2,
5336         string memory p3
5337     ) internal view {
5338         _sendLogPayload(
5339             abi.encodeWithSignature(
5340                 "log(address,bool,bool,string)",
5341                 p0,
5342                 p1,
5343                 p2,
5344                 p3
5345             )
5346         );
5347     }
5348 
5349     function log(
5350         address p0,
5351         bool p1,
5352         bool p2,
5353         bool p3
5354     ) internal view {
5355         _sendLogPayload(
5356             abi.encodeWithSignature(
5357                 "log(address,bool,bool,bool)",
5358                 p0,
5359                 p1,
5360                 p2,
5361                 p3
5362             )
5363         );
5364     }
5365 
5366     function log(
5367         address p0,
5368         bool p1,
5369         bool p2,
5370         address p3
5371     ) internal view {
5372         _sendLogPayload(
5373             abi.encodeWithSignature(
5374                 "log(address,bool,bool,address)",
5375                 p0,
5376                 p1,
5377                 p2,
5378                 p3
5379             )
5380         );
5381     }
5382 
5383     function log(
5384         address p0,
5385         bool p1,
5386         address p2,
5387         uint256 p3
5388     ) internal view {
5389         _sendLogPayload(
5390             abi.encodeWithSignature(
5391                 "log(address,bool,address,uint)",
5392                 p0,
5393                 p1,
5394                 p2,
5395                 p3
5396             )
5397         );
5398     }
5399 
5400     function log(
5401         address p0,
5402         bool p1,
5403         address p2,
5404         string memory p3
5405     ) internal view {
5406         _sendLogPayload(
5407             abi.encodeWithSignature(
5408                 "log(address,bool,address,string)",
5409                 p0,
5410                 p1,
5411                 p2,
5412                 p3
5413             )
5414         );
5415     }
5416 
5417     function log(
5418         address p0,
5419         bool p1,
5420         address p2,
5421         bool p3
5422     ) internal view {
5423         _sendLogPayload(
5424             abi.encodeWithSignature(
5425                 "log(address,bool,address,bool)",
5426                 p0,
5427                 p1,
5428                 p2,
5429                 p3
5430             )
5431         );
5432     }
5433 
5434     function log(
5435         address p0,
5436         bool p1,
5437         address p2,
5438         address p3
5439     ) internal view {
5440         _sendLogPayload(
5441             abi.encodeWithSignature(
5442                 "log(address,bool,address,address)",
5443                 p0,
5444                 p1,
5445                 p2,
5446                 p3
5447             )
5448         );
5449     }
5450 
5451     function log(
5452         address p0,
5453         address p1,
5454         uint256 p2,
5455         uint256 p3
5456     ) internal view {
5457         _sendLogPayload(
5458             abi.encodeWithSignature(
5459                 "log(address,address,uint,uint)",
5460                 p0,
5461                 p1,
5462                 p2,
5463                 p3
5464             )
5465         );
5466     }
5467 
5468     function log(
5469         address p0,
5470         address p1,
5471         uint256 p2,
5472         string memory p3
5473     ) internal view {
5474         _sendLogPayload(
5475             abi.encodeWithSignature(
5476                 "log(address,address,uint,string)",
5477                 p0,
5478                 p1,
5479                 p2,
5480                 p3
5481             )
5482         );
5483     }
5484 
5485     function log(
5486         address p0,
5487         address p1,
5488         uint256 p2,
5489         bool p3
5490     ) internal view {
5491         _sendLogPayload(
5492             abi.encodeWithSignature(
5493                 "log(address,address,uint,bool)",
5494                 p0,
5495                 p1,
5496                 p2,
5497                 p3
5498             )
5499         );
5500     }
5501 
5502     function log(
5503         address p0,
5504         address p1,
5505         uint256 p2,
5506         address p3
5507     ) internal view {
5508         _sendLogPayload(
5509             abi.encodeWithSignature(
5510                 "log(address,address,uint,address)",
5511                 p0,
5512                 p1,
5513                 p2,
5514                 p3
5515             )
5516         );
5517     }
5518 
5519     function log(
5520         address p0,
5521         address p1,
5522         string memory p2,
5523         uint256 p3
5524     ) internal view {
5525         _sendLogPayload(
5526             abi.encodeWithSignature(
5527                 "log(address,address,string,uint)",
5528                 p0,
5529                 p1,
5530                 p2,
5531                 p3
5532             )
5533         );
5534     }
5535 
5536     function log(
5537         address p0,
5538         address p1,
5539         string memory p2,
5540         string memory p3
5541     ) internal view {
5542         _sendLogPayload(
5543             abi.encodeWithSignature(
5544                 "log(address,address,string,string)",
5545                 p0,
5546                 p1,
5547                 p2,
5548                 p3
5549             )
5550         );
5551     }
5552 
5553     function log(
5554         address p0,
5555         address p1,
5556         string memory p2,
5557         bool p3
5558     ) internal view {
5559         _sendLogPayload(
5560             abi.encodeWithSignature(
5561                 "log(address,address,string,bool)",
5562                 p0,
5563                 p1,
5564                 p2,
5565                 p3
5566             )
5567         );
5568     }
5569 
5570     function log(
5571         address p0,
5572         address p1,
5573         string memory p2,
5574         address p3
5575     ) internal view {
5576         _sendLogPayload(
5577             abi.encodeWithSignature(
5578                 "log(address,address,string,address)",
5579                 p0,
5580                 p1,
5581                 p2,
5582                 p3
5583             )
5584         );
5585     }
5586 
5587     function log(
5588         address p0,
5589         address p1,
5590         bool p2,
5591         uint256 p3
5592     ) internal view {
5593         _sendLogPayload(
5594             abi.encodeWithSignature(
5595                 "log(address,address,bool,uint)",
5596                 p0,
5597                 p1,
5598                 p2,
5599                 p3
5600             )
5601         );
5602     }
5603 
5604     function log(
5605         address p0,
5606         address p1,
5607         bool p2,
5608         string memory p3
5609     ) internal view {
5610         _sendLogPayload(
5611             abi.encodeWithSignature(
5612                 "log(address,address,bool,string)",
5613                 p0,
5614                 p1,
5615                 p2,
5616                 p3
5617             )
5618         );
5619     }
5620 
5621     function log(
5622         address p0,
5623         address p1,
5624         bool p2,
5625         bool p3
5626     ) internal view {
5627         _sendLogPayload(
5628             abi.encodeWithSignature(
5629                 "log(address,address,bool,bool)",
5630                 p0,
5631                 p1,
5632                 p2,
5633                 p3
5634             )
5635         );
5636     }
5637 
5638     function log(
5639         address p0,
5640         address p1,
5641         bool p2,
5642         address p3
5643     ) internal view {
5644         _sendLogPayload(
5645             abi.encodeWithSignature(
5646                 "log(address,address,bool,address)",
5647                 p0,
5648                 p1,
5649                 p2,
5650                 p3
5651             )
5652         );
5653     }
5654 
5655     function log(
5656         address p0,
5657         address p1,
5658         address p2,
5659         uint256 p3
5660     ) internal view {
5661         _sendLogPayload(
5662             abi.encodeWithSignature(
5663                 "log(address,address,address,uint)",
5664                 p0,
5665                 p1,
5666                 p2,
5667                 p3
5668             )
5669         );
5670     }
5671 
5672     function log(
5673         address p0,
5674         address p1,
5675         address p2,
5676         string memory p3
5677     ) internal view {
5678         _sendLogPayload(
5679             abi.encodeWithSignature(
5680                 "log(address,address,address,string)",
5681                 p0,
5682                 p1,
5683                 p2,
5684                 p3
5685             )
5686         );
5687     }
5688 
5689     function log(
5690         address p0,
5691         address p1,
5692         address p2,
5693         bool p3
5694     ) internal view {
5695         _sendLogPayload(
5696             abi.encodeWithSignature(
5697                 "log(address,address,address,bool)",
5698                 p0,
5699                 p1,
5700                 p2,
5701                 p3
5702             )
5703         );
5704     }
5705 
5706     function log(
5707         address p0,
5708         address p1,
5709         address p2,
5710         address p3
5711     ) internal view {
5712         _sendLogPayload(
5713             abi.encodeWithSignature(
5714                 "log(address,address,address,address)",
5715                 p0,
5716                 p1,
5717                 p2,
5718                 p3
5719             )
5720         );
5721     }
5722 }
5723 
5724 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
5725 
5726 pragma solidity ^0.6.0;
5727 
5728 /**
5729  * @dev Interface of the ERC20 standard as defined in the EIP.
5730  */
5731 interface IERC20 {
5732     /**
5733      * @dev Returns the amount of tokens in existence.
5734      */
5735     function totalSupply() external view returns (uint256);
5736 
5737     /**
5738      * @dev Returns the amount of tokens owned by `account`.
5739      */
5740     function balanceOf(address account) external view returns (uint256);
5741 
5742     /**
5743      * @dev Moves `amount` tokens from the caller's account to `recipient`.
5744      *
5745      * Returns a boolean value indicating whether the operation succeeded.
5746      *
5747      * Emits a {Transfer} event.
5748      */
5749     function transfer(address recipient, uint256 amount)
5750         external
5751         returns (bool);
5752 
5753     /**
5754      * @dev Returns the remaining number of tokens that `spender` will be
5755      * allowed to spend on behalf of `owner` through {transferFrom}. This is
5756      * zero by default.
5757      *
5758      * This value changes when {approve} or {transferFrom} are called.
5759      */
5760     function allowance(address owner, address spender)
5761         external
5762         view
5763         returns (uint256);
5764 
5765     /**
5766      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
5767      *
5768      * Returns a boolean value indicating whether the operation succeeded.
5769      *
5770      * IMPORTANT: Beware that changing an allowance with this method brings the risk
5771      * that someone may use both the old and the new allowance by unfortunate
5772      * transaction ordering. One possible solution to mitigate this race
5773      * condition is to first reduce the spender's allowance to 0 and set the
5774      * desired value afterwards:
5775      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
5776      *
5777      * Emits an {Approval} event.
5778      */
5779     function approve(address spender, uint256 amount) external returns (bool);
5780 
5781     /**
5782      * @dev Moves `amount` tokens from `sender` to `recipient` using the
5783      * allowance mechanism. `amount` is then deducted from the caller's
5784      * allowance.
5785      *
5786      * Returns a boolean value indicating whether the operation succeeded.
5787      *
5788      * Emits a {Transfer} event.
5789      */
5790     function transferFrom(
5791         address sender,
5792         address recipient,
5793         uint256 amount
5794     ) external returns (bool);
5795 
5796     /**
5797      * @dev Emitted when `value` tokens are moved from one account (`from`) to
5798      * another (`to`).
5799      *
5800      * Note that `value` may be zero.
5801      */
5802     event Transfer(address indexed from, address indexed to, uint256 value);
5803 
5804     /**
5805      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
5806      * a call to {approve}. `value` is the new allowance.
5807      */
5808     event Approval(
5809         address indexed owner,
5810         address indexed spender,
5811         uint256 value
5812     );
5813 }
5814 
5815 // File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
5816 
5817 pragma solidity 0.6.12;
5818 
5819 interface IUniswapV2Factory {
5820     event PairCreated(
5821         address indexed token0,
5822         address indexed token1,
5823         address pair,
5824         uint256
5825     );
5826 
5827     function feeTo() external view returns (address);
5828 
5829     function feeToSetter() external view returns (address);
5830 
5831     function migrator() external view returns (address);
5832 
5833     function getPair(address tokenA, address tokenB)
5834         external
5835         view
5836         returns (address pair);
5837 
5838     function allPairs(uint256) external view returns (address pair);
5839 
5840     function allPairsLength() external view returns (uint256);
5841 
5842     function createPair(address tokenA, address tokenB)
5843         external
5844         returns (address pair);
5845 
5846     function setFeeTo(address) external;
5847 
5848     function setFeeToSetter(address) external;
5849 
5850     function setMigrator(address) external;
5851 }
5852 
5853 // File: contracts/uniswapv2/interfaces/IUniswapV2Router01.sol
5854 
5855 pragma solidity 0.6.12;
5856 
5857 interface IUniswapV2Router01 {
5858     function factory() external pure returns (address);
5859 
5860     function WETH() external pure returns (address);
5861 
5862     function addLiquidity(
5863         address tokenA,
5864         address tokenB,
5865         uint256 amountADesired,
5866         uint256 amountBDesired,
5867         uint256 amountAMin,
5868         uint256 amountBMin,
5869         address to,
5870         uint256 deadline
5871     )
5872         external
5873         returns (
5874             uint256 amountA,
5875             uint256 amountB,
5876             uint256 liquidity
5877         );
5878 
5879     function addLiquidityETH(
5880         address token,
5881         uint256 amountTokenDesired,
5882         uint256 amountTokenMin,
5883         uint256 amountETHMin,
5884         address to,
5885         uint256 deadline
5886     )
5887         external
5888         payable
5889         returns (
5890             uint256 amountToken,
5891             uint256 amountETH,
5892             uint256 liquidity
5893         );
5894 
5895     function removeLiquidity(
5896         address tokenA,
5897         address tokenB,
5898         uint256 liquidity,
5899         uint256 amountAMin,
5900         uint256 amountBMin,
5901         address to,
5902         uint256 deadline
5903     ) external returns (uint256 amountA, uint256 amountB);
5904 
5905     function removeLiquidityETH(
5906         address token,
5907         uint256 liquidity,
5908         uint256 amountTokenMin,
5909         uint256 amountETHMin,
5910         address to,
5911         uint256 deadline
5912     ) external returns (uint256 amountToken, uint256 amountETH);
5913 
5914     function removeLiquidityWithPermit(
5915         address tokenA,
5916         address tokenB,
5917         uint256 liquidity,
5918         uint256 amountAMin,
5919         uint256 amountBMin,
5920         address to,
5921         uint256 deadline,
5922         bool approveMax,
5923         uint8 v,
5924         bytes32 r,
5925         bytes32 s
5926     ) external returns (uint256 amountA, uint256 amountB);
5927 
5928     function removeLiquidityETHWithPermit(
5929         address token,
5930         uint256 liquidity,
5931         uint256 amountTokenMin,
5932         uint256 amountETHMin,
5933         address to,
5934         uint256 deadline,
5935         bool approveMax,
5936         uint8 v,
5937         bytes32 r,
5938         bytes32 s
5939     ) external returns (uint256 amountToken, uint256 amountETH);
5940 
5941     function swapExactTokensForTokens(
5942         uint256 amountIn,
5943         uint256 amountOutMin,
5944         address[] calldata path,
5945         address to,
5946         uint256 deadline
5947     ) external returns (uint256[] memory amounts);
5948 
5949     function swapTokensForExactTokens(
5950         uint256 amountOut,
5951         uint256 amountInMax,
5952         address[] calldata path,
5953         address to,
5954         uint256 deadline
5955     ) external returns (uint256[] memory amounts);
5956 
5957     function swapExactETHForTokens(
5958         uint256 amountOutMin,
5959         address[] calldata path,
5960         address to,
5961         uint256 deadline
5962     ) external payable returns (uint256[] memory amounts);
5963 
5964     function swapTokensForExactETH(
5965         uint256 amountOut,
5966         uint256 amountInMax,
5967         address[] calldata path,
5968         address to,
5969         uint256 deadline
5970     ) external returns (uint256[] memory amounts);
5971 
5972     function swapExactTokensForETH(
5973         uint256 amountIn,
5974         uint256 amountOutMin,
5975         address[] calldata path,
5976         address to,
5977         uint256 deadline
5978     ) external returns (uint256[] memory amounts);
5979 
5980     function swapETHForExactTokens(
5981         uint256 amountOut,
5982         address[] calldata path,
5983         address to,
5984         uint256 deadline
5985     ) external payable returns (uint256[] memory amounts);
5986 
5987     function quote(
5988         uint256 amountA,
5989         uint256 reserveA,
5990         uint256 reserveB
5991     ) external pure returns (uint256 amountB);
5992 
5993     function getAmountOut(
5994         uint256 amountIn,
5995         uint256 reserveIn,
5996         uint256 reserveOut
5997     ) external pure returns (uint256 amountOut);
5998 
5999     function getAmountIn(
6000         uint256 amountOut,
6001         uint256 reserveIn,
6002         uint256 reserveOut
6003     ) external pure returns (uint256 amountIn);
6004 
6005     function getAmountsOut(uint256 amountIn, address[] calldata path)
6006         external
6007         view
6008         returns (uint256[] memory amounts);
6009 
6010     function getAmountsIn(uint256 amountOut, address[] calldata path)
6011         external
6012         view
6013         returns (uint256[] memory amounts);
6014 }
6015 
6016 // File: contracts/uniswapv2/interfaces/IUniswapV2Router02.sol
6017 
6018 pragma solidity 0.6.12;
6019 
6020 interface IUniswapV2Router02 is IUniswapV2Router01 {
6021     function removeLiquidityETHSupportingFeeOnTransferTokens(
6022         address token,
6023         uint256 liquidity,
6024         uint256 amountTokenMin,
6025         uint256 amountETHMin,
6026         address to,
6027         uint256 deadline
6028     ) external returns (uint256 amountETH);
6029 
6030     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
6031         address token,
6032         uint256 liquidity,
6033         uint256 amountTokenMin,
6034         uint256 amountETHMin,
6035         address to,
6036         uint256 deadline,
6037         bool approveMax,
6038         uint8 v,
6039         bytes32 r,
6040         bytes32 s
6041     ) external returns (uint256 amountETH);
6042 
6043     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
6044         uint256 amountIn,
6045         uint256 amountOutMin,
6046         address[] calldata path,
6047         address to,
6048         uint256 deadline
6049     ) external;
6050 
6051     function swapExactETHForTokensSupportingFeeOnTransferTokens(
6052         uint256 amountOutMin,
6053         address[] calldata path,
6054         address to,
6055         uint256 deadline
6056     ) external payable;
6057 
6058     function swapExactTokensForETHSupportingFeeOnTransferTokens(
6059         uint256 amountIn,
6060         uint256 amountOutMin,
6061         address[] calldata path,
6062         address to,
6063         uint256 deadline
6064     ) external;
6065 }
6066 
6067 // File: contracts/uniswapv2/interfaces/IUniswapV2Pair.sol
6068 
6069 pragma solidity 0.6.12;
6070 
6071 interface IUniswapV2Pair {
6072     event Approval(
6073         address indexed owner,
6074         address indexed spender,
6075         uint256 value
6076     );
6077     event Transfer(address indexed from, address indexed to, uint256 value);
6078 
6079     function name() external pure returns (string memory);
6080 
6081     function symbol() external pure returns (string memory);
6082 
6083     function decimals() external pure returns (uint8);
6084 
6085     function totalSupply() external view returns (uint256);
6086 
6087     function balanceOf(address owner) external view returns (uint256);
6088 
6089     function allowance(address owner, address spender)
6090         external
6091         view
6092         returns (uint256);
6093 
6094     function approve(address spender, uint256 value) external returns (bool);
6095 
6096     function transfer(address to, uint256 value) external returns (bool);
6097 
6098     function transferFrom(
6099         address from,
6100         address to,
6101         uint256 value
6102     ) external returns (bool);
6103 
6104     function DOMAIN_SEPARATOR() external view returns (bytes32);
6105 
6106     function PERMIT_TYPEHASH() external pure returns (bytes32);
6107 
6108     function nonces(address owner) external view returns (uint256);
6109 
6110     function permit(
6111         address owner,
6112         address spender,
6113         uint256 value,
6114         uint256 deadline,
6115         uint8 v,
6116         bytes32 r,
6117         bytes32 s
6118     ) external;
6119 
6120     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
6121     event Burn(
6122         address indexed sender,
6123         uint256 amount0,
6124         uint256 amount1,
6125         address indexed to
6126     );
6127     event Swap(
6128         address indexed sender,
6129         uint256 amount0In,
6130         uint256 amount1In,
6131         uint256 amount0Out,
6132         uint256 amount1Out,
6133         address indexed to
6134     );
6135     event Sync(uint112 reserve0, uint112 reserve1);
6136 
6137     function MINIMUM_LIQUIDITY() external pure returns (uint256);
6138 
6139     function factory() external view returns (address);
6140 
6141     function token0() external view returns (address);
6142 
6143     function token1() external view returns (address);
6144 
6145     function getReserves()
6146         external
6147         view
6148         returns (
6149             uint112 reserve0,
6150             uint112 reserve1,
6151             uint32 blockTimestampLast
6152         );
6153 
6154     function price0CumulativeLast() external view returns (uint256);
6155 
6156     function price1CumulativeLast() external view returns (uint256);
6157 
6158     function kLast() external view returns (uint256);
6159 
6160     function mint(address to) external returns (uint256 liquidity);
6161 
6162     function burn(address to)
6163         external
6164         returns (uint256 amount0, uint256 amount1);
6165 
6166     function swap(
6167         uint256 amount0Out,
6168         uint256 amount1Out,
6169         address to,
6170         bytes calldata data
6171     ) external;
6172 
6173     function skim(address to) external;
6174 
6175     function sync() external;
6176 
6177     function initialize(address, address) external;
6178 }
6179 
6180 // File: contracts/uniswapv2/interfaces/IWETH.sol
6181 
6182 pragma solidity 0.6.12;
6183 
6184 interface IWETH {
6185     function deposit() external payable;
6186 
6187     function transfer(address to, uint256 value) external returns (bool);
6188 
6189     function withdraw(uint256) external;
6190 
6191     function approve(address guy, uint256 wad) external returns (bool);
6192 
6193     function balanceOf(address addr) external view returns (uint256);
6194 }
6195 
6196 // File: @openzeppelin/contracts/access/Ownable.sol
6197 
6198 pragma solidity ^0.6.0;
6199 
6200 /**
6201  * @dev Contract module which provides a basic access control mechanism, where
6202  * there is an account (an owner) that can be granted exclusive access to
6203  * specific functions.
6204  *
6205  * By default, the owner account will be the one that deploys the contract. This
6206  * can later be changed with {transferOwnership}.
6207  *
6208  * This module is used through inheritance. It will make available the modifier
6209  * `onlyOwner`, which can be applied to your functions to restrict their use to
6210  * the owner.
6211  */
6212 contract Ownable is Context {
6213     address private _owner;
6214 
6215     event OwnershipTransferred(
6216         address indexed previousOwner,
6217         address indexed newOwner
6218     );
6219 
6220     /**
6221      * @dev Initializes the contract setting the deployer as the initial owner.
6222      */
6223     constructor() internal {
6224         address msgSender = _msgSender();
6225         _owner = msgSender;
6226         emit OwnershipTransferred(address(0), msgSender);
6227     }
6228 
6229     /**
6230      * @dev Returns the address of the current owner.
6231      */
6232     function owner() public view returns (address) {
6233         return _owner;
6234     }
6235 
6236     /**
6237      * @dev Throws if called by any account other than the owner.
6238      */
6239     modifier onlyOwner() {
6240         require(_owner == _msgSender(), "Ownable: caller is not the owner");
6241         _;
6242     }
6243 
6244     /**
6245      * @dev Leaves the contract without owner. It will not be possible to call
6246      * `onlyOwner` functions anymore. Can only be called by the current owner.
6247      *
6248      * NOTE: Renouncing ownership will leave the contract without an owner,
6249      * thereby removing any functionality that is only available to the owner.
6250      */
6251     function renounceOwnership() public virtual onlyOwner {
6252         emit OwnershipTransferred(_owner, address(0));
6253         _owner = address(0);
6254     }
6255 
6256     /**
6257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
6258      * Can only be called by the current owner.
6259      */
6260     function transferOwnership(address newOwner) public virtual onlyOwner {
6261         require(
6262             newOwner != address(0),
6263             "Ownable: new owner is the zero address"
6264         );
6265         emit OwnershipTransferred(_owner, newOwner);
6266         _owner = newOwner;
6267     }
6268 }
6269 
6270 // File: contracts/NerdBaseToken.sol
6271 
6272 pragma solidity 0.6.12;
6273 
6274 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
6275 
6276 contract NerdBaseToken is Context, INerdBaseTokenLGE, Ownable {
6277     using SafeMath for uint256;
6278     using Address for address;
6279 
6280     uint256 public constant DEV_FUND_LOCKED_MONTHS = 6;
6281     uint256 public constant ONE_MONTH = 30 days;
6282     uint256 public constant HARD_CAP_LIQUIDITY_EVENT = 800 ether;
6283     uint256 public constant DEV_FUND_RESERVE_PERCENT = 9; //9%
6284 
6285     uint256 public constant LP_LOCK_FOREVER_PERCENT = 40; //40%
6286 
6287     uint256 public constant LP_INITIAL_LOCKED_PERIOD = 28 days;
6288     uint256 public LGE_DURATION = 7 days;
6289 
6290     address public override tokenUniswapPair;
6291 
6292     uint256 public totalLPTokensMinted;
6293     uint256 public totalETHContributed;
6294     uint256 public LPperETHUnit;
6295     mapping(address => uint256) public ethContributed;
6296 
6297     mapping(address => uint256) private _balances;
6298 
6299     mapping(address => mapping(address => uint256)) private _allowances;
6300 
6301     event LiquidityAddition(address indexed dst, uint256 value);
6302     event LPTokenClaimed(address dst, uint256 value);
6303 
6304     uint256 private _totalSupply;
6305 
6306     string private _name;
6307     string private _symbol;
6308     uint8 private _decimals;
6309     uint256 public constant initialSupply = 21000e18;
6310     uint256 public contractStartTimestamp;
6311 
6312     uint256 public tokenActiveStartTimestamp;
6313 
6314     address public override devFundAddress;
6315     address public tentativeDevAddress;
6316     uint256 public devFundTotal;
6317     uint256 public releasedDevFund;
6318 
6319     uint256 public lpReleaseStart;
6320 
6321     address public lgeApprover;
6322 
6323     mapping(address => bool) public alreadyPlayGameUsers;
6324 
6325     function name() public view returns (string memory) {
6326         return _name;
6327     }
6328 
6329     function initialSetup(
6330         address router,
6331         address factory,
6332         address _devFund,
6333         uint256 _lgePeriod,
6334         address _lgeApprover
6335     ) internal {
6336         _name = "N3RD.FINANCE";
6337         _symbol = "N3RDz";
6338         _decimals = 18;
6339         LGE_DURATION = (_lgePeriod > 0) ? _lgePeriod : LGE_DURATION;
6340         uint256 initialMint = initialSupply.div(100).mul(
6341             100 - DEV_FUND_RESERVE_PERCENT
6342         );
6343         _mint(address(this), initialMint);
6344         contractStartTimestamp = block.timestamp;
6345         uniswapRouterV2 = IUniswapV2Router02(
6346             router != address(0)
6347                 ? router
6348                 : 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
6349         );
6350         uniswapFactory = IUniswapV2Factory(
6351             factory != address(0)
6352                 ? factory
6353                 : 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
6354         );
6355         createUniswapPairMainnet();
6356         releasedDevFund = 0;
6357         devFundAddress = _devFund;
6358         devFundTotal = initialSupply.sub(initialMint);
6359 
6360         lpReleaseStart = block.timestamp.add(LGE_DURATION).add(
6361             LP_INITIAL_LOCKED_PERIOD
6362         ); //7 days for LGE + 28 days locked
6363         lgeApprover = _lgeApprover;
6364     }
6365 
6366     function isApprovedBySignature(
6367         address _joiner,
6368         bytes32 r,
6369         bytes32 s,
6370         uint8 v
6371     ) public view returns (bool) {
6372         //compute keccak hash of address
6373         bytes32 h = keccak256(abi.encodePacked(_joiner));
6374         bytes32 messageHash = keccak256(
6375             abi.encodePacked("\x19Ethereum Signed Message:\n32", h)
6376         );
6377         return ecrecover(messageHash, v, r, s) == lgeApprover;
6378     }
6379 
6380     function isJoinedLGE(address _joiner) public view returns (bool) {
6381         return ethContributed[_joiner] > 0 || alreadyPlayGameUsers[_joiner];
6382     }
6383 
6384     function registerLGE(
6385         bytes32 r,
6386         bytes32 s,
6387         uint8 v
6388     ) public {
6389         require(isApprovedBySignature(msg.sender, r, s, v), "!signature");
6390         alreadyPlayGameUsers[msg.sender] = true;
6391     }
6392 
6393     function getAllocatedLP(address _user)
6394         public
6395         override
6396         view
6397         returns (uint256)
6398     {
6399         return
6400             ethContributed[_user]
6401                 .mul(LPperETHUnit)
6402                 .mul(uint256(100).sub(LP_LOCK_FOREVER_PERCENT))
6403                 .div(100)
6404                 .div(1e18);
6405     }
6406 
6407     function getLpReleaseStart() public override view returns (uint256) {
6408         return lpReleaseStart;
6409     }
6410 
6411     function getTokenUniswapPair() public override view returns (address) {
6412         return tokenUniswapPair;
6413     }
6414 
6415     function getTotalLPTokensMinted() public override view returns (uint256) {
6416         return totalLPTokensMinted;
6417     }
6418 
6419     function getReleasableLPTokensMinted()
6420         public
6421         override
6422         view
6423         returns (uint256)
6424     {
6425         return
6426             totalETHContributed
6427                 .mul(LPperETHUnit)
6428                 .mul(uint256(100).sub(LP_LOCK_FOREVER_PERCENT))
6429                 .div(100)
6430                 .div(1e18);
6431     }
6432 
6433     function pendingReleasableDevFund() public view returns (uint256) {
6434         if (tokenActiveStartTimestamp == 0 || !LPGenerationCompleted) return 0;
6435         uint256 monthsTilNow = (block.timestamp.sub(tokenActiveStartTimestamp))
6436             .div(ONE_MONTH);
6437         monthsTilNow = monthsTilNow.add(1);
6438         uint256 totalReleasableTilNow = monthsTilNow.mul(devFundTotal).div(
6439             DEV_FUND_LOCKED_MONTHS
6440         );
6441         if (totalReleasableTilNow > devFundTotal) {
6442             totalReleasableTilNow = devFundTotal;
6443         }
6444         if (totalReleasableTilNow > releasedDevFund) {
6445             return totalReleasableTilNow.sub(releasedDevFund);
6446         }
6447         return 0;
6448     }
6449 
6450     function unlockDevFund() public {
6451         uint256 tobeReleasedAmount = pendingReleasableDevFund();
6452         if (tobeReleasedAmount > 0) {
6453             releasedDevFund = releasedDevFund.add(tobeReleasedAmount);
6454             _mint(devFundAddress, tobeReleasedAmount);
6455         }
6456     }
6457 
6458     function symbol() public view returns (string memory) {
6459         return _symbol;
6460     }
6461 
6462     function decimals() public view returns (uint8) {
6463         return _decimals;
6464     }
6465 
6466     function totalSupply() public override view returns (uint256) {
6467         return _totalSupply;
6468     }
6469 
6470     function balanceOf(address _owner) public override view returns (uint256) {
6471         return _balances[_owner];
6472     }
6473 
6474     IUniswapV2Router02 public uniswapRouterV2;
6475     IUniswapV2Factory public uniswapFactory;
6476 
6477     function getUniswapRouterV2() public override view returns (address) {
6478         return address(uniswapRouterV2);
6479     }
6480 
6481     function getUniswapFactory() public override view returns (address) {
6482         return address(uniswapFactory);
6483     }
6484 
6485     function createUniswapPairMainnet() public returns (address) {
6486         require(tokenUniswapPair == address(0), "Token: pool already created");
6487         tokenUniswapPair = uniswapFactory.createPair(
6488             address(uniswapRouterV2.WETH()),
6489             address(this)
6490         );
6491         return tokenUniswapPair;
6492     }
6493 
6494     string
6495         public liquidityGenerationParticipationAgreement = "I'm not a resident of the United States \n I understand that this contract is provided with no warranty of any kind. \n I agree to not hold the contract creators, NERD team members or anyone associated with this event liable for any damage monetary and otherwise I might onccur. \n I understand that any smart contract interaction carries an inherent risk.";
6496 
6497     function getSecondsLeftInLiquidityGenerationEvent()
6498         public
6499         view
6500         returns (uint256)
6501     {
6502         if (!liquidityGenerationOngoing()) return 0;
6503         console.log(
6504             "LGE_DURATION since start is",
6505             contractStartTimestamp.add(LGE_DURATION),
6506             "Time now is",
6507             block.timestamp
6508         );
6509         return contractStartTimestamp.add(LGE_DURATION).sub(block.timestamp);
6510     }
6511 
6512     function liquidityGenerationOngoing() public view returns (bool) {
6513         console.log(
6514             "LGE_DURATION since start is",
6515             contractStartTimestamp.add(LGE_DURATION),
6516             "Time now is",
6517             block.timestamp
6518         );
6519         console.log(
6520             "liquidity generation ongoing",
6521             contractStartTimestamp.add(LGE_DURATION) < block.timestamp
6522         );
6523         return contractStartTimestamp.add(LGE_DURATION) > block.timestamp;
6524     }
6525 
6526     function emergencyDrain24hAfterLiquidityGenerationEventIsDone()
6527         public
6528         onlyOwner
6529     {
6530         require(
6531             contractStartTimestamp.add(8 days) < block.timestamp,
6532             "Liquidity generation grace period still ongoing"
6533         );
6534         (bool success, ) = msg.sender.call{value: address(this).balance}("");
6535         require(success, "Transfer failed.");
6536         _balances[msg.sender] = _balances[address(this)];
6537         _balances[address(this)] = 0;
6538     }
6539 
6540     bool public LPGenerationCompleted;
6541 
6542     function isLPGenerationCompleted() public override view returns (bool) {
6543         return LPGenerationCompleted;
6544     }
6545 
6546     function addLiquidityToUniswapNERDxWETHPair() public {
6547         require(
6548             liquidityGenerationOngoing() == false,
6549             "Liquidity generation onging"
6550         );
6551         require(
6552             LPGenerationCompleted == false,
6553             "Liquidity generation already finished"
6554         );
6555         totalETHContributed = address(this).balance;
6556         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
6557         console.log("Balance of this", totalETHContributed / 1e18);
6558         address WETH = uniswapRouterV2.WETH();
6559         IWETH(WETH).deposit{value: totalETHContributed}();
6560         require(address(this).balance == 0, "Transfer Failed");
6561         IWETH(WETH).transfer(address(pair), totalETHContributed);
6562         _balances[address(pair)] = _balances[address(this)];
6563         _balances[address(this)] = 0;
6564         pair.mint(address(this));
6565         totalLPTokensMinted = pair.balanceOf(address(this));
6566         console.log("Total tokens minted", totalLPTokensMinted);
6567         require(totalLPTokensMinted != 0, "LP creation failed");
6568         LPperETHUnit = totalLPTokensMinted.mul(1e18).div(totalETHContributed);
6569         console.log("Total per LP token", LPperETHUnit);
6570         require(LPperETHUnit != 0, "LP creation failed");
6571         LPGenerationCompleted = true;
6572         tokenActiveStartTimestamp = block.timestamp;
6573 
6574         //approve WETH for uniswapRouterV2
6575         IWETH(WETH).approve(address(uniswapRouterV2), uint256(-1));
6576     }
6577 
6578     modifier checkPreconditionsLGE(
6579         bool agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement
6580     ) {
6581         require(
6582             liquidityGenerationOngoing(),
6583             "Liquidity Generation Event over"
6584         );
6585         require(
6586             agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement,
6587             "No agreement provided"
6588         );
6589         require(
6590             totalETHContributed < HARD_CAP_LIQUIDITY_EVENT,
6591             "Liquidity generation even hard cap already reached!"
6592         );
6593         _;
6594     }
6595 
6596     function addLiquidity(
6597         bool agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement,
6598         bytes32 r,
6599         bytes32 s,
6600         uint8 v
6601     )
6602         public
6603         payable
6604         checkPreconditionsLGE(
6605             agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement
6606         )
6607     {
6608         require(
6609             isJoinedLGE(msg.sender) ||
6610                 (isApprovedBySignature(msg.sender, r, s, v)),
6611             "You havent played the game"
6612         );
6613         addLiquidityInternal();
6614     }
6615 
6616     function setDevFundReciever(address _devaddr) public {
6617         require(devFundAddress == msg.sender, "only dev can change");
6618         tentativeDevAddress = _devaddr;
6619     }
6620 
6621     function confirmDevAddress() public {
6622         require(tentativeDevAddress == msg.sender, "not tentativeDevAddress!");
6623         devFundAddress = tentativeDevAddress;
6624         tentativeDevAddress = address(0);
6625     }
6626 
6627     function getHardCap() public view returns (uint256) {
6628         return HARD_CAP_LIQUIDITY_EVENT;
6629     }
6630 
6631     function addLiquidityWithoutSignature(
6632         bool agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement
6633     )
6634         public
6635         payable
6636         checkPreconditionsLGE(
6637             agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement
6638         )
6639     {
6640         require(isJoinedLGE(msg.sender), "You havent played the game");
6641         addLiquidityInternal();
6642     }
6643 
6644     function addLiquidityInternal() private {
6645         totalETHContributed = totalETHContributed.add(msg.value);
6646         uint256 refund = 0;
6647         if (totalETHContributed > HARD_CAP_LIQUIDITY_EVENT) {
6648             refund = totalETHContributed.sub(HARD_CAP_LIQUIDITY_EVENT);
6649             totalETHContributed = HARD_CAP_LIQUIDITY_EVENT;
6650         }
6651         ethContributed[msg.sender] = ethContributed[msg.sender].add(
6652             msg.value.sub(refund)
6653         );
6654         if (refund > 0) {
6655             msg.sender.transfer(refund);
6656         }
6657         emit LiquidityAddition(msg.sender, msg.value);
6658     }
6659 
6660     function transfer(address recipient, uint256 amount)
6661         public
6662         virtual
6663         override
6664         returns (bool)
6665     {
6666         _transfer(_msgSender(), recipient, amount);
6667         return true;
6668     }
6669 
6670     function allowance(address owner, address spender)
6671         public
6672         virtual
6673         override
6674         view
6675         returns (uint256)
6676     {
6677         return _allowances[owner][spender];
6678     }
6679 
6680     function approve(address spender, uint256 amount)
6681         public
6682         virtual
6683         override
6684         returns (bool)
6685     {
6686         _approve(_msgSender(), spender, amount);
6687         return true;
6688     }
6689 
6690     function transferFrom(
6691         address sender,
6692         address recipient,
6693         uint256 amount
6694     ) public virtual override returns (bool) {
6695         _transfer(sender, recipient, amount);
6696         _approve(
6697             sender,
6698             _msgSender(),
6699             _allowances[sender][_msgSender()].sub(
6700                 amount,
6701                 "ERC20: transfer amount exceeds allowance"
6702             )
6703         );
6704         return true;
6705     }
6706 
6707     function increaseAllowance(address spender, uint256 addedValue)
6708         public
6709         virtual
6710         returns (bool)
6711     {
6712         _approve(
6713             _msgSender(),
6714             spender,
6715             _allowances[_msgSender()][spender].add(addedValue)
6716         );
6717         return true;
6718     }
6719 
6720     function decreaseAllowance(address spender, uint256 subtractedValue)
6721         public
6722         virtual
6723         returns (bool)
6724     {
6725         _approve(
6726             _msgSender(),
6727             spender,
6728             _allowances[_msgSender()][spender].sub(
6729                 subtractedValue,
6730                 "ERC20: decreased allowance below zero"
6731             )
6732         );
6733         return true;
6734     }
6735 
6736     function setShouldTransferChecker(address _transferCheckerAddress)
6737         public
6738         onlyOwner
6739     {
6740         transferCheckerAddress = _transferCheckerAddress;
6741     }
6742 
6743     address public override transferCheckerAddress;
6744 
6745     function setFeeDistributor(address _feeDistributor) public onlyOwner {
6746         feeDistributor = _feeDistributor;
6747         _approve(
6748             address(this),
6749             _feeDistributor,
6750             0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
6751         );
6752         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
6753         pair.approve(
6754             _feeDistributor,
6755             0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
6756         );
6757     }
6758 
6759     address public override feeDistributor;
6760 
6761     function _transfer(
6762         address sender,
6763         address recipient,
6764         uint256 amount
6765     ) internal virtual {
6766         require(sender != address(0), "ERC20: transfer from the zero address");
6767         require(recipient != address(0), "ERC20: transfer to the zero address");
6768 
6769         _beforeTokenTransfer(sender, recipient, amount);
6770 
6771         _balances[sender] = _balances[sender].sub(
6772             amount,
6773             "ERC20: transfer amount exceeds balance"
6774         );
6775 
6776         (
6777             uint256 transferToAmount,
6778             uint256 transferToFeeDistributorAmount
6779         ) = IFeeApprover(transferCheckerAddress).calculateAmountsAfterFee(
6780             sender,
6781             recipient,
6782             amount
6783         );
6784         console.log("Sender is :", sender, "Recipent is :", recipient);
6785         console.log("amount is ", amount);
6786 
6787         require(
6788             transferToAmount.add(transferToFeeDistributorAmount) == amount,
6789             "Math broke, does gravity still work?"
6790         );
6791 
6792         _balances[recipient] = _balances[recipient].add(transferToAmount);
6793         emit Transfer(sender, recipient, transferToAmount);
6794 
6795         //transferToFeeDistributorAmount is total rewards fees received for genesis pool (this contract) and farming pool
6796         if (
6797             transferToFeeDistributorAmount > 0 && feeDistributor != address(0)
6798         ) {
6799             _balances[feeDistributor] = _balances[feeDistributor].add(
6800                 transferToFeeDistributorAmount
6801             );
6802             emit Transfer(
6803                 sender,
6804                 feeDistributor,
6805                 transferToFeeDistributorAmount
6806             );
6807             INerdVault(feeDistributor).updatePendingRewards();
6808         }
6809     }
6810 
6811     function _mint(address account, uint256 amount) internal virtual {
6812         require(account != address(0), "ERC20: mint to the zero address");
6813 
6814         _beforeTokenTransfer(address(0), account, amount);
6815 
6816         _totalSupply = _totalSupply.add(amount);
6817         _balances[account] = _balances[account].add(amount);
6818         emit Transfer(address(0), account, amount);
6819     }
6820 
6821     function _burn(address account, uint256 amount) internal virtual {
6822         require(account != address(0), "ERC20: burn from the zero address");
6823 
6824         _beforeTokenTransfer(account, address(0), amount);
6825 
6826         _balances[account] = _balances[account].sub(
6827             amount,
6828             "ERC20: burn amount exceeds balance"
6829         );
6830         _totalSupply = _totalSupply.sub(amount);
6831         emit Transfer(account, address(0), amount);
6832     }
6833 
6834     function _approve(
6835         address owner,
6836         address spender,
6837         uint256 amount
6838     ) internal virtual {
6839         require(owner != address(0), "ERC20: approve from the zero address");
6840         require(spender != address(0), "ERC20: approve to the zero address");
6841 
6842         _allowances[owner][spender] = amount;
6843         emit Approval(owner, spender, amount);
6844     }
6845 
6846     function _setupDecimals(uint8 decimals_) internal {
6847         _decimals = decimals_;
6848     }
6849 
6850     function _beforeTokenTransfer(
6851         address from,
6852         address to,
6853         uint256 amount
6854     ) internal virtual {}
6855 }
6856 
6857 // File: contracts/Nerd.sol
6858 
6859 pragma solidity 0.6.12;
6860 
6861 // NerdToken with Governance.
6862 contract Nerd is NerdBaseToken {
6863     /**
6864      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
6865      * a default value of 18.
6866      *
6867      * To select a different value for {decimals}, use {_setupDecimals}.
6868      *
6869      * All three of these values are immutable: they can only be set once during
6870      * construction.
6871      */
6872     constructor(
6873         address router,
6874         address factory,
6875         address _devFund,
6876         uint256 _lgePeriod,
6877         address _lgeApprover
6878     ) public {
6879         initialSetup(router, factory, _devFund, _lgePeriod, _lgeApprover);
6880         // _name = name;
6881         // _symbol = symbol;
6882         // _decimals = 18;
6883         // _totalSupply = initialSupply;
6884         // _balances[address(this)] = initialSupply;
6885         // contractStartTimestamp = block.timestamp;
6886         // // UNISWAP
6887         // IUniswapV2Router02(router != address(0) ? router : 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f); // For testing
6888         // IUniswapV2Factory(factory != address(0) ? factory : 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f); // For testing
6889     }
6890 
6891     // Copied and modified from YAM code:
6892     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
6893     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
6894     // Which is copied and modified from COMPOUND:
6895     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
6896 
6897     /// @notice A record of each accounts delegate
6898     mapping(address => address) internal _delegates;
6899 
6900     /// @notice A checkpoint for marking number of votes from a given block
6901     struct Checkpoint {
6902         uint32 fromBlock;
6903         uint256 votes;
6904     }
6905 
6906     /// @notice A record of votes checkpoints for each account, by index
6907     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
6908 
6909     /// @notice The number of checkpoints for each account
6910     mapping(address => uint32) public numCheckpoints;
6911 
6912     /// @notice The EIP-712 typehash for the contract's domain
6913     bytes32 public constant DOMAIN_TYPEHASH = keccak256(
6914         "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
6915     );
6916 
6917     /// @notice The EIP-712 typehash for the delegation struct used by the contract
6918     bytes32 public constant DELEGATION_TYPEHASH = keccak256(
6919         "Delegation(address delegatee,uint256 nonce,uint256 expiry)"
6920     );
6921 
6922     /// @notice A record of states for signing / validating signatures
6923     mapping(address => uint256) public nonces;
6924 
6925     /// @notice An event thats emitted when an account changes its delegate
6926     event DelegateChanged(
6927         address indexed delegator,
6928         address indexed fromDelegate,
6929         address indexed toDelegate
6930     );
6931 
6932     /// @notice An event thats emitted when a delegate account's vote balance changes
6933     event DelegateVotesChanged(
6934         address indexed delegate,
6935         uint256 previousBalance,
6936         uint256 newBalance
6937     );
6938 
6939     /**
6940      * @notice Delegate votes from `msg.sender` to `delegatee`
6941      * @param delegator The address to get delegatee for
6942      */
6943     function delegates(address delegator) external view returns (address) {
6944         return _delegates[delegator];
6945     }
6946 
6947     /**
6948      * @notice Delegate votes from `msg.sender` to `delegatee`
6949      * @param delegatee The address to delegate votes to
6950      */
6951     function delegate(address delegatee) external {
6952         return _delegate(msg.sender, delegatee);
6953     }
6954 
6955     /**
6956      * @notice Delegates votes from signatory to `delegatee`
6957      * @param delegatee The address to delegate votes to
6958      * @param nonce The contract state required to match the signature
6959      * @param expiry The time at which to expire the signature
6960      * @param v The recovery byte of the signature
6961      * @param r Half of the ECDSA signature pair
6962      * @param s Half of the ECDSA signature pair
6963      */
6964     function delegateBySig(
6965         address delegatee,
6966         uint256 nonce,
6967         uint256 expiry,
6968         uint8 v,
6969         bytes32 r,
6970         bytes32 s
6971     ) external {
6972         bytes32 domainSeparator = keccak256(
6973             abi.encode(
6974                 DOMAIN_TYPEHASH,
6975                 keccak256(bytes(name())),
6976                 getChainId(),
6977                 address(this)
6978             )
6979         );
6980 
6981         bytes32 structHash = keccak256(
6982             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
6983         );
6984 
6985         bytes32 digest = keccak256(
6986             abi.encodePacked("\x19\x01", domainSeparator, structHash)
6987         );
6988 
6989         address signatory = ecrecover(digest, v, r, s);
6990         require(
6991             signatory != address(0),
6992             "NERD::delegateBySig: invalid signature"
6993         );
6994         require(
6995             nonce == nonces[signatory]++,
6996             "NERD::delegateBySig: invalid nonce"
6997         );
6998         require(now <= expiry, "NERD::delegateBySig: signature expired");
6999         return _delegate(signatory, delegatee);
7000     }
7001 
7002     /**
7003      * @notice Gets the current votes balance for `account`
7004      * @param account The address to get votes balance
7005      * @return The number of current votes for `account`
7006      */
7007     function getCurrentVotes(address account) external view returns (uint256) {
7008         uint32 nCheckpoints = numCheckpoints[account];
7009         return
7010             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
7011     }
7012 
7013     /**
7014      * @notice Determine the prior number of votes for an account as of a block number
7015      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
7016      * @param account The address of the account to check
7017      * @param blockNumber The block number to get the vote balance at
7018      * @return The number of votes the account had as of the given block
7019      */
7020     function getPriorVotes(address account, uint256 blockNumber)
7021         external
7022         view
7023         returns (uint256)
7024     {
7025         require(
7026             blockNumber < block.number,
7027             "NERD::getPriorVotes: not yet determined"
7028         );
7029 
7030         uint32 nCheckpoints = numCheckpoints[account];
7031         if (nCheckpoints == 0) {
7032             return 0;
7033         }
7034 
7035         // First check most recent balance
7036         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
7037             return checkpoints[account][nCheckpoints - 1].votes;
7038         }
7039 
7040         // Next check implicit zero balance
7041         if (checkpoints[account][0].fromBlock > blockNumber) {
7042             return 0;
7043         }
7044 
7045         uint32 lower = 0;
7046         uint32 upper = nCheckpoints - 1;
7047         while (upper > lower) {
7048             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
7049             Checkpoint memory cp = checkpoints[account][center];
7050             if (cp.fromBlock == blockNumber) {
7051                 return cp.votes;
7052             } else if (cp.fromBlock < blockNumber) {
7053                 lower = center;
7054             } else {
7055                 upper = center - 1;
7056             }
7057         }
7058         return checkpoints[account][lower].votes;
7059     }
7060 
7061     function _delegate(address delegator, address delegatee) internal {
7062         address currentDelegate = _delegates[delegator];
7063         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying NERD tokens (not scaled);
7064         _delegates[delegator] = delegatee;
7065 
7066         emit DelegateChanged(delegator, currentDelegate, delegatee);
7067 
7068         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
7069     }
7070 
7071     function _moveDelegates(
7072         address srcRep,
7073         address dstRep,
7074         uint256 amount
7075     ) internal {
7076         if (srcRep != dstRep && amount > 0) {
7077             if (srcRep != address(0)) {
7078                 // decrease old representative
7079                 uint32 srcRepNum = numCheckpoints[srcRep];
7080                 uint256 srcRepOld = srcRepNum > 0
7081                     ? checkpoints[srcRep][srcRepNum - 1].votes
7082                     : 0;
7083                 uint256 srcRepNew = srcRepOld.sub(amount);
7084                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
7085             }
7086 
7087             if (dstRep != address(0)) {
7088                 // increase new representative
7089                 uint32 dstRepNum = numCheckpoints[dstRep];
7090                 uint256 dstRepOld = dstRepNum > 0
7091                     ? checkpoints[dstRep][dstRepNum - 1].votes
7092                     : 0;
7093                 uint256 dstRepNew = dstRepOld.add(amount);
7094                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
7095             }
7096         }
7097     }
7098 
7099     function _writeCheckpoint(
7100         address delegatee,
7101         uint32 nCheckpoints,
7102         uint256 oldVotes,
7103         uint256 newVotes
7104     ) internal {
7105         uint32 blockNumber = safe32(
7106             block.number,
7107             "NERD::_writeCheckpoint: block number exceeds 32 bits"
7108         );
7109 
7110         if (
7111             nCheckpoints > 0 &&
7112             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
7113         ) {
7114             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
7115         } else {
7116             checkpoints[delegatee][nCheckpoints] = Checkpoint(
7117                 blockNumber,
7118                 newVotes
7119             );
7120             numCheckpoints[delegatee] = nCheckpoints + 1;
7121         }
7122 
7123         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
7124     }
7125 
7126     function safe32(uint256 n, string memory errorMessage)
7127         internal
7128         pure
7129         returns (uint32)
7130     {
7131         require(n < 2**32, errorMessage);
7132         return uint32(n);
7133     }
7134 
7135     function getChainId() internal pure returns (uint256) {
7136         uint256 chainId;
7137         assembly {
7138             chainId := chainid()
7139         }
7140         return chainId;
7141     }
7142 }