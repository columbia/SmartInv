1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity >=0.6.0 <0.8.0;
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
26 // File: contracts/IPISBaseToken.sol
27 
28 pragma solidity 0.6.12;
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IPISBaseToken {
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
119 interface IPISBaseTokenEx is IPISBaseToken {
120     function devFundAddress() external view returns (address);
121 
122     function transferCheckerAddress() external view returns (address);
123 
124     function feeDistributor() external view returns (address);
125 }
126 
127 // File: @openzeppelin/contracts/math/SafeMath.sol
128 
129 pragma solidity >=0.6.0 <0.8.0;
130 
131 /**
132  * @dev Wrappers over Solidity's arithmetic operations with added overflow
133  * checks.
134  *
135  * Arithmetic operations in Solidity wrap on overflow. This can easily result
136  * in bugs, because programmers usually assume that an overflow raises an
137  * error, which is the standard behavior in high level programming languages.
138  * `SafeMath` restores this intuition by reverting the transaction when an
139  * operation overflows.
140  *
141  * Using this library instead of the unchecked operations eliminates an entire
142  * class of bugs, so it's recommended to use it always.
143  */
144 library SafeMath {
145     /**
146      * @dev Returns the addition of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `+` operator.
150      *
151      * Requirements:
152      *
153      * - Addition cannot overflow.
154      */
155     function add(uint256 a, uint256 b) internal pure returns (uint256) {
156         uint256 c = a + b;
157         require(c >= a, "SafeMath: addition overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         return sub(a, b, "SafeMath: subtraction overflow");
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
178      * overflow (when the result is negative).
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      *
184      * - Subtraction cannot overflow.
185      */
186     function sub(
187         uint256 a,
188         uint256 b,
189         string memory errorMessage
190     ) internal pure returns (uint256) {
191         require(b <= a, errorMessage);
192         uint256 c = a - b;
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the multiplication of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `*` operator.
202      *
203      * Requirements:
204      *
205      * - Multiplication cannot overflow.
206      */
207     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
208         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
209         // benefit is lost if 'b' is also tested.
210         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
211         if (a == 0) {
212             return 0;
213         }
214 
215         uint256 c = a * b;
216         require(c / a == b, "SafeMath: multiplication overflow");
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers. Reverts on
223      * division by zero. The result is rounded towards zero.
224      *
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b) internal pure returns (uint256) {
234         return div(a, b, "SafeMath: division by zero");
235     }
236 
237     /**
238      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
239      * division by zero. The result is rounded towards zero.
240      *
241      * Counterpart to Solidity's `/` operator. Note: this function uses a
242      * `revert` opcode (which leaves remaining gas untouched) while Solidity
243      * uses an invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function div(
250         uint256 a,
251         uint256 b,
252         string memory errorMessage
253     ) internal pure returns (uint256) {
254         require(b > 0, errorMessage);
255         uint256 c = a / b;
256         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
257 
258         return c;
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * Reverts when dividing by zero.
264      *
265      * Counterpart to Solidity's `%` operator. This function uses a `revert`
266      * opcode (which leaves remaining gas untouched) while Solidity uses an
267      * invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
274         return mod(a, b, "SafeMath: modulo by zero");
275     }
276 
277     /**
278      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
279      * Reverts with custom message when dividing by zero.
280      *
281      * Counterpart to Solidity's `%` operator. This function uses a `revert`
282      * opcode (which leaves remaining gas untouched) while Solidity uses an
283      * invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function mod(
290         uint256 a,
291         uint256 b,
292         string memory errorMessage
293     ) internal pure returns (uint256) {
294         require(b != 0, errorMessage);
295         return a % b;
296     }
297 }
298 
299 // File: @openzeppelin/contracts/utils/Address.sol
300 
301 pragma solidity >=0.6.2 <0.8.0;
302 
303 /**
304  * @dev Collection of functions related to the address type
305  */
306 library Address {
307     /**
308      * @dev Returns true if `account` is a contract.
309      *
310      * [IMPORTANT]
311      * ====
312      * It is unsafe to assume that an address for which this function returns
313      * false is an externally-owned account (EOA) and not a contract.
314      *
315      * Among others, `isContract` will return false for the following
316      * types of addresses:
317      *
318      *  - an externally-owned account
319      *  - a contract in construction
320      *  - an address where a contract will be created
321      *  - an address where a contract lived, but was destroyed
322      * ====
323      */
324     function isContract(address account) internal view returns (bool) {
325         // This method relies on extcodesize, which returns 0 for contracts in
326         // construction, since the code is only stored at the end of the
327         // constructor execution.
328 
329         uint256 size;
330         // solhint-disable-next-line no-inline-assembly
331         assembly {
332             size := extcodesize(account)
333         }
334         return size > 0;
335     }
336 
337     /**
338      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
339      * `recipient`, forwarding all available gas and reverting on errors.
340      *
341      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
342      * of certain opcodes, possibly making contracts go over the 2300 gas limit
343      * imposed by `transfer`, making them unable to receive funds via
344      * `transfer`. {sendValue} removes this limitation.
345      *
346      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
347      *
348      * IMPORTANT: because control is transferred to `recipient`, care must be
349      * taken to not create reentrancy vulnerabilities. Consider using
350      * {ReentrancyGuard} or the
351      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
352      */
353     function sendValue(address payable recipient, uint256 amount) internal {
354         require(
355             address(this).balance >= amount,
356             "Address: insufficient balance"
357         );
358 
359         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
360         (bool success, ) = recipient.call{value: amount}("");
361         require(
362             success,
363             "Address: unable to send value, recipient may have reverted"
364         );
365     }
366 
367     /**
368      * @dev Performs a Solidity function call using a low level `call`. A
369      * plain`call` is an unsafe replacement for a function call: use this
370      * function instead.
371      *
372      * If `target` reverts with a revert reason, it is bubbled up by this
373      * function (like regular Solidity function calls).
374      *
375      * Returns the raw returned data. To convert to the expected return value,
376      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
377      *
378      * Requirements:
379      *
380      * - `target` must be a contract.
381      * - calling `target` with `data` must not revert.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(address target, bytes memory data)
386         internal
387         returns (bytes memory)
388     {
389         return functionCall(target, data, "Address: low-level call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
394      * `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, 0, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but also transferring `value` wei to `target`.
409      *
410      * Requirements:
411      *
412      * - the calling contract must have an ETH balance of at least `value`.
413      * - the called Solidity function must be `payable`.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value
421     ) internal returns (bytes memory) {
422         return
423             functionCallWithValue(
424                 target,
425                 data,
426                 value,
427                 "Address: low-level call with value failed"
428             );
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
433      * with `errorMessage` as a fallback revert reason when `target` reverts.
434      *
435      * _Available since v3.1._
436      */
437     function functionCallWithValue(
438         address target,
439         bytes memory data,
440         uint256 value,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         require(
444             address(this).balance >= value,
445             "Address: insufficient balance for call"
446         );
447         require(isContract(target), "Address: call to non-contract");
448 
449         // solhint-disable-next-line avoid-low-level-calls
450         (bool success, bytes memory returndata) = target.call{value: value}(
451             data
452         );
453         return _verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(address target, bytes memory data)
463         internal
464         view
465         returns (bytes memory)
466     {
467         return
468             functionStaticCall(
469                 target,
470                 data,
471                 "Address: low-level static call failed"
472             );
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal view returns (bytes memory) {
486         require(isContract(target), "Address: static call to non-contract");
487 
488         // solhint-disable-next-line avoid-low-level-calls
489         (bool success, bytes memory returndata) = target.staticcall(data);
490         return _verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     function _verifyCallResult(
494         bool success,
495         bytes memory returndata,
496         string memory errorMessage
497     ) private pure returns (bytes memory) {
498         if (success) {
499             return returndata;
500         } else {
501             // Look for revert reason and bubble it up if present
502             if (returndata.length > 0) {
503                 // The easiest way to bubble the revert reason is using memory via assembly
504 
505                 // solhint-disable-next-line no-inline-assembly
506                 assembly {
507                     let returndata_size := mload(returndata)
508                     revert(add(32, returndata), returndata_size)
509                 }
510             } else {
511                 revert(errorMessage);
512             }
513         }
514     }
515 }
516 
517 // File: contracts/IFeeCalculator.sol
518 
519 pragma solidity 0.6.12;
520 
521 interface IFeeCalculator {
522     function check(
523         address sender,
524         address recipient,
525         uint256 amount
526     ) external returns (bool);
527 
528     function setFeeMultiplier(uint256 _feeMultiplier) external;
529 
530     function feePercentX100() external view returns (uint256);
531 
532     function setTokenUniswapPair(address _tokenUniswapPair) external;
533 
534     function setPISTokenAddress(address _pisTokenAddress) external;
535 
536     function updateTxState() external;
537 
538     function calculateAmountsAfterFee(
539         address sender,
540         address recipient,
541         uint256 amount
542     )
543         external
544         returns (uint256 transferToAmount, uint256 transferToFeeBearerAmount);
545 
546     function setPaused() external;
547 }
548 
549 // File: contracts/IPISVault.sol
550 
551 pragma solidity 0.6.12;
552 
553 interface IPISVault {
554     function updatePendingRewards() external;
555 
556     function depositFor(
557         address _depositFor,
558         uint256 _pid,
559         uint256 _amount
560     ) external;
561 
562     function poolInfo(uint256 _pid)
563         external
564         view
565         returns (
566             address,
567             uint256,
568             uint256,
569             uint256,
570             bool,
571             uint256,
572             uint256,
573             uint256,
574             uint256
575         );
576 }
577 
578 // File: @nomiclabs/buidler/console.sol
579 
580 pragma solidity >=0.4.22 <0.8.0;
581 
582 library console {
583     address constant CONSOLE_ADDRESS = address(
584         0x000000000000000000636F6e736F6c652e6c6f67
585     );
586 
587     function _sendLogPayload(bytes memory payload) private view {
588         uint256 payloadLength = payload.length;
589         address consoleAddress = CONSOLE_ADDRESS;
590         assembly {
591             let payloadStart := add(payload, 32)
592             let r := staticcall(
593                 gas(),
594                 consoleAddress,
595                 payloadStart,
596                 payloadLength,
597                 0,
598                 0
599             )
600         }
601     }
602 
603     function log() internal view {
604         _sendLogPayload(abi.encodeWithSignature("log()"));
605     }
606 
607     function logInt(int256 p0) internal view {
608         _sendLogPayload(abi.encodeWithSignature("log(int)", p0));
609     }
610 
611     function logUint(uint256 p0) internal view {
612         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
613     }
614 
615     function logString(string memory p0) internal view {
616         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
617     }
618 
619     function logBool(bool p0) internal view {
620         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
621     }
622 
623     function logAddress(address p0) internal view {
624         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
625     }
626 
627     function logBytes(bytes memory p0) internal view {
628         _sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
629     }
630 
631     function logByte(bytes1 p0) internal view {
632         _sendLogPayload(abi.encodeWithSignature("log(byte)", p0));
633     }
634 
635     function logBytes1(bytes1 p0) internal view {
636         _sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
637     }
638 
639     function logBytes2(bytes2 p0) internal view {
640         _sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
641     }
642 
643     function logBytes3(bytes3 p0) internal view {
644         _sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
645     }
646 
647     function logBytes4(bytes4 p0) internal view {
648         _sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
649     }
650 
651     function logBytes5(bytes5 p0) internal view {
652         _sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
653     }
654 
655     function logBytes6(bytes6 p0) internal view {
656         _sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
657     }
658 
659     function logBytes7(bytes7 p0) internal view {
660         _sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
661     }
662 
663     function logBytes8(bytes8 p0) internal view {
664         _sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
665     }
666 
667     function logBytes9(bytes9 p0) internal view {
668         _sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
669     }
670 
671     function logBytes10(bytes10 p0) internal view {
672         _sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
673     }
674 
675     function logBytes11(bytes11 p0) internal view {
676         _sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
677     }
678 
679     function logBytes12(bytes12 p0) internal view {
680         _sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
681     }
682 
683     function logBytes13(bytes13 p0) internal view {
684         _sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
685     }
686 
687     function logBytes14(bytes14 p0) internal view {
688         _sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
689     }
690 
691     function logBytes15(bytes15 p0) internal view {
692         _sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
693     }
694 
695     function logBytes16(bytes16 p0) internal view {
696         _sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
697     }
698 
699     function logBytes17(bytes17 p0) internal view {
700         _sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
701     }
702 
703     function logBytes18(bytes18 p0) internal view {
704         _sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
705     }
706 
707     function logBytes19(bytes19 p0) internal view {
708         _sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
709     }
710 
711     function logBytes20(bytes20 p0) internal view {
712         _sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
713     }
714 
715     function logBytes21(bytes21 p0) internal view {
716         _sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
717     }
718 
719     function logBytes22(bytes22 p0) internal view {
720         _sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
721     }
722 
723     function logBytes23(bytes23 p0) internal view {
724         _sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
725     }
726 
727     function logBytes24(bytes24 p0) internal view {
728         _sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
729     }
730 
731     function logBytes25(bytes25 p0) internal view {
732         _sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
733     }
734 
735     function logBytes26(bytes26 p0) internal view {
736         _sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
737     }
738 
739     function logBytes27(bytes27 p0) internal view {
740         _sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
741     }
742 
743     function logBytes28(bytes28 p0) internal view {
744         _sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
745     }
746 
747     function logBytes29(bytes29 p0) internal view {
748         _sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
749     }
750 
751     function logBytes30(bytes30 p0) internal view {
752         _sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
753     }
754 
755     function logBytes31(bytes31 p0) internal view {
756         _sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
757     }
758 
759     function logBytes32(bytes32 p0) internal view {
760         _sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
761     }
762 
763     function log(uint256 p0) internal view {
764         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
765     }
766 
767     function log(string memory p0) internal view {
768         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
769     }
770 
771     function log(bool p0) internal view {
772         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
773     }
774 
775     function log(address p0) internal view {
776         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
777     }
778 
779     function log(uint256 p0, uint256 p1) internal view {
780         _sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
781     }
782 
783     function log(uint256 p0, string memory p1) internal view {
784         _sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
785     }
786 
787     function log(uint256 p0, bool p1) internal view {
788         _sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
789     }
790 
791     function log(uint256 p0, address p1) internal view {
792         _sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
793     }
794 
795     function log(string memory p0, uint256 p1) internal view {
796         _sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
797     }
798 
799     function log(string memory p0, string memory p1) internal view {
800         _sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
801     }
802 
803     function log(string memory p0, bool p1) internal view {
804         _sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
805     }
806 
807     function log(string memory p0, address p1) internal view {
808         _sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
809     }
810 
811     function log(bool p0, uint256 p1) internal view {
812         _sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
813     }
814 
815     function log(bool p0, string memory p1) internal view {
816         _sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
817     }
818 
819     function log(bool p0, bool p1) internal view {
820         _sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
821     }
822 
823     function log(bool p0, address p1) internal view {
824         _sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
825     }
826 
827     function log(address p0, uint256 p1) internal view {
828         _sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
829     }
830 
831     function log(address p0, string memory p1) internal view {
832         _sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
833     }
834 
835     function log(address p0, bool p1) internal view {
836         _sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
837     }
838 
839     function log(address p0, address p1) internal view {
840         _sendLogPayload(
841             abi.encodeWithSignature("log(address,address)", p0, p1)
842         );
843     }
844 
845     function log(
846         uint256 p0,
847         uint256 p1,
848         uint256 p2
849     ) internal view {
850         _sendLogPayload(
851             abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2)
852         );
853     }
854 
855     function log(
856         uint256 p0,
857         uint256 p1,
858         string memory p2
859     ) internal view {
860         _sendLogPayload(
861             abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2)
862         );
863     }
864 
865     function log(
866         uint256 p0,
867         uint256 p1,
868         bool p2
869     ) internal view {
870         _sendLogPayload(
871             abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2)
872         );
873     }
874 
875     function log(
876         uint256 p0,
877         uint256 p1,
878         address p2
879     ) internal view {
880         _sendLogPayload(
881             abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2)
882         );
883     }
884 
885     function log(
886         uint256 p0,
887         string memory p1,
888         uint256 p2
889     ) internal view {
890         _sendLogPayload(
891             abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2)
892         );
893     }
894 
895     function log(
896         uint256 p0,
897         string memory p1,
898         string memory p2
899     ) internal view {
900         _sendLogPayload(
901             abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2)
902         );
903     }
904 
905     function log(
906         uint256 p0,
907         string memory p1,
908         bool p2
909     ) internal view {
910         _sendLogPayload(
911             abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2)
912         );
913     }
914 
915     function log(
916         uint256 p0,
917         string memory p1,
918         address p2
919     ) internal view {
920         _sendLogPayload(
921             abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2)
922         );
923     }
924 
925     function log(
926         uint256 p0,
927         bool p1,
928         uint256 p2
929     ) internal view {
930         _sendLogPayload(
931             abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2)
932         );
933     }
934 
935     function log(
936         uint256 p0,
937         bool p1,
938         string memory p2
939     ) internal view {
940         _sendLogPayload(
941             abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2)
942         );
943     }
944 
945     function log(
946         uint256 p0,
947         bool p1,
948         bool p2
949     ) internal view {
950         _sendLogPayload(
951             abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2)
952         );
953     }
954 
955     function log(
956         uint256 p0,
957         bool p1,
958         address p2
959     ) internal view {
960         _sendLogPayload(
961             abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2)
962         );
963     }
964 
965     function log(
966         uint256 p0,
967         address p1,
968         uint256 p2
969     ) internal view {
970         _sendLogPayload(
971             abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2)
972         );
973     }
974 
975     function log(
976         uint256 p0,
977         address p1,
978         string memory p2
979     ) internal view {
980         _sendLogPayload(
981             abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2)
982         );
983     }
984 
985     function log(
986         uint256 p0,
987         address p1,
988         bool p2
989     ) internal view {
990         _sendLogPayload(
991             abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2)
992         );
993     }
994 
995     function log(
996         uint256 p0,
997         address p1,
998         address p2
999     ) internal view {
1000         _sendLogPayload(
1001             abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2)
1002         );
1003     }
1004 
1005     function log(
1006         string memory p0,
1007         uint256 p1,
1008         uint256 p2
1009     ) internal view {
1010         _sendLogPayload(
1011             abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2)
1012         );
1013     }
1014 
1015     function log(
1016         string memory p0,
1017         uint256 p1,
1018         string memory p2
1019     ) internal view {
1020         _sendLogPayload(
1021             abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2)
1022         );
1023     }
1024 
1025     function log(
1026         string memory p0,
1027         uint256 p1,
1028         bool p2
1029     ) internal view {
1030         _sendLogPayload(
1031             abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2)
1032         );
1033     }
1034 
1035     function log(
1036         string memory p0,
1037         uint256 p1,
1038         address p2
1039     ) internal view {
1040         _sendLogPayload(
1041             abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2)
1042         );
1043     }
1044 
1045     function log(
1046         string memory p0,
1047         string memory p1,
1048         uint256 p2
1049     ) internal view {
1050         _sendLogPayload(
1051             abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2)
1052         );
1053     }
1054 
1055     function log(
1056         string memory p0,
1057         string memory p1,
1058         string memory p2
1059     ) internal view {
1060         _sendLogPayload(
1061             abi.encodeWithSignature("log(string,string,string)", p0, p1, p2)
1062         );
1063     }
1064 
1065     function log(
1066         string memory p0,
1067         string memory p1,
1068         bool p2
1069     ) internal view {
1070         _sendLogPayload(
1071             abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2)
1072         );
1073     }
1074 
1075     function log(
1076         string memory p0,
1077         string memory p1,
1078         address p2
1079     ) internal view {
1080         _sendLogPayload(
1081             abi.encodeWithSignature("log(string,string,address)", p0, p1, p2)
1082         );
1083     }
1084 
1085     function log(
1086         string memory p0,
1087         bool p1,
1088         uint256 p2
1089     ) internal view {
1090         _sendLogPayload(
1091             abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2)
1092         );
1093     }
1094 
1095     function log(
1096         string memory p0,
1097         bool p1,
1098         string memory p2
1099     ) internal view {
1100         _sendLogPayload(
1101             abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2)
1102         );
1103     }
1104 
1105     function log(
1106         string memory p0,
1107         bool p1,
1108         bool p2
1109     ) internal view {
1110         _sendLogPayload(
1111             abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2)
1112         );
1113     }
1114 
1115     function log(
1116         string memory p0,
1117         bool p1,
1118         address p2
1119     ) internal view {
1120         _sendLogPayload(
1121             abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2)
1122         );
1123     }
1124 
1125     function log(
1126         string memory p0,
1127         address p1,
1128         uint256 p2
1129     ) internal view {
1130         _sendLogPayload(
1131             abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2)
1132         );
1133     }
1134 
1135     function log(
1136         string memory p0,
1137         address p1,
1138         string memory p2
1139     ) internal view {
1140         _sendLogPayload(
1141             abi.encodeWithSignature("log(string,address,string)", p0, p1, p2)
1142         );
1143     }
1144 
1145     function log(
1146         string memory p0,
1147         address p1,
1148         bool p2
1149     ) internal view {
1150         _sendLogPayload(
1151             abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2)
1152         );
1153     }
1154 
1155     function log(
1156         string memory p0,
1157         address p1,
1158         address p2
1159     ) internal view {
1160         _sendLogPayload(
1161             abi.encodeWithSignature("log(string,address,address)", p0, p1, p2)
1162         );
1163     }
1164 
1165     function log(
1166         bool p0,
1167         uint256 p1,
1168         uint256 p2
1169     ) internal view {
1170         _sendLogPayload(
1171             abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2)
1172         );
1173     }
1174 
1175     function log(
1176         bool p0,
1177         uint256 p1,
1178         string memory p2
1179     ) internal view {
1180         _sendLogPayload(
1181             abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2)
1182         );
1183     }
1184 
1185     function log(
1186         bool p0,
1187         uint256 p1,
1188         bool p2
1189     ) internal view {
1190         _sendLogPayload(
1191             abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2)
1192         );
1193     }
1194 
1195     function log(
1196         bool p0,
1197         uint256 p1,
1198         address p2
1199     ) internal view {
1200         _sendLogPayload(
1201             abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2)
1202         );
1203     }
1204 
1205     function log(
1206         bool p0,
1207         string memory p1,
1208         uint256 p2
1209     ) internal view {
1210         _sendLogPayload(
1211             abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2)
1212         );
1213     }
1214 
1215     function log(
1216         bool p0,
1217         string memory p1,
1218         string memory p2
1219     ) internal view {
1220         _sendLogPayload(
1221             abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2)
1222         );
1223     }
1224 
1225     function log(
1226         bool p0,
1227         string memory p1,
1228         bool p2
1229     ) internal view {
1230         _sendLogPayload(
1231             abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2)
1232         );
1233     }
1234 
1235     function log(
1236         bool p0,
1237         string memory p1,
1238         address p2
1239     ) internal view {
1240         _sendLogPayload(
1241             abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2)
1242         );
1243     }
1244 
1245     function log(
1246         bool p0,
1247         bool p1,
1248         uint256 p2
1249     ) internal view {
1250         _sendLogPayload(
1251             abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2)
1252         );
1253     }
1254 
1255     function log(
1256         bool p0,
1257         bool p1,
1258         string memory p2
1259     ) internal view {
1260         _sendLogPayload(
1261             abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2)
1262         );
1263     }
1264 
1265     function log(
1266         bool p0,
1267         bool p1,
1268         bool p2
1269     ) internal view {
1270         _sendLogPayload(
1271             abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2)
1272         );
1273     }
1274 
1275     function log(
1276         bool p0,
1277         bool p1,
1278         address p2
1279     ) internal view {
1280         _sendLogPayload(
1281             abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2)
1282         );
1283     }
1284 
1285     function log(
1286         bool p0,
1287         address p1,
1288         uint256 p2
1289     ) internal view {
1290         _sendLogPayload(
1291             abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2)
1292         );
1293     }
1294 
1295     function log(
1296         bool p0,
1297         address p1,
1298         string memory p2
1299     ) internal view {
1300         _sendLogPayload(
1301             abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2)
1302         );
1303     }
1304 
1305     function log(
1306         bool p0,
1307         address p1,
1308         bool p2
1309     ) internal view {
1310         _sendLogPayload(
1311             abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2)
1312         );
1313     }
1314 
1315     function log(
1316         bool p0,
1317         address p1,
1318         address p2
1319     ) internal view {
1320         _sendLogPayload(
1321             abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2)
1322         );
1323     }
1324 
1325     function log(
1326         address p0,
1327         uint256 p1,
1328         uint256 p2
1329     ) internal view {
1330         _sendLogPayload(
1331             abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2)
1332         );
1333     }
1334 
1335     function log(
1336         address p0,
1337         uint256 p1,
1338         string memory p2
1339     ) internal view {
1340         _sendLogPayload(
1341             abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2)
1342         );
1343     }
1344 
1345     function log(
1346         address p0,
1347         uint256 p1,
1348         bool p2
1349     ) internal view {
1350         _sendLogPayload(
1351             abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2)
1352         );
1353     }
1354 
1355     function log(
1356         address p0,
1357         uint256 p1,
1358         address p2
1359     ) internal view {
1360         _sendLogPayload(
1361             abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2)
1362         );
1363     }
1364 
1365     function log(
1366         address p0,
1367         string memory p1,
1368         uint256 p2
1369     ) internal view {
1370         _sendLogPayload(
1371             abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2)
1372         );
1373     }
1374 
1375     function log(
1376         address p0,
1377         string memory p1,
1378         string memory p2
1379     ) internal view {
1380         _sendLogPayload(
1381             abi.encodeWithSignature("log(address,string,string)", p0, p1, p2)
1382         );
1383     }
1384 
1385     function log(
1386         address p0,
1387         string memory p1,
1388         bool p2
1389     ) internal view {
1390         _sendLogPayload(
1391             abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2)
1392         );
1393     }
1394 
1395     function log(
1396         address p0,
1397         string memory p1,
1398         address p2
1399     ) internal view {
1400         _sendLogPayload(
1401             abi.encodeWithSignature("log(address,string,address)", p0, p1, p2)
1402         );
1403     }
1404 
1405     function log(
1406         address p0,
1407         bool p1,
1408         uint256 p2
1409     ) internal view {
1410         _sendLogPayload(
1411             abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2)
1412         );
1413     }
1414 
1415     function log(
1416         address p0,
1417         bool p1,
1418         string memory p2
1419     ) internal view {
1420         _sendLogPayload(
1421             abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2)
1422         );
1423     }
1424 
1425     function log(
1426         address p0,
1427         bool p1,
1428         bool p2
1429     ) internal view {
1430         _sendLogPayload(
1431             abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2)
1432         );
1433     }
1434 
1435     function log(
1436         address p0,
1437         bool p1,
1438         address p2
1439     ) internal view {
1440         _sendLogPayload(
1441             abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2)
1442         );
1443     }
1444 
1445     function log(
1446         address p0,
1447         address p1,
1448         uint256 p2
1449     ) internal view {
1450         _sendLogPayload(
1451             abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2)
1452         );
1453     }
1454 
1455     function log(
1456         address p0,
1457         address p1,
1458         string memory p2
1459     ) internal view {
1460         _sendLogPayload(
1461             abi.encodeWithSignature("log(address,address,string)", p0, p1, p2)
1462         );
1463     }
1464 
1465     function log(
1466         address p0,
1467         address p1,
1468         bool p2
1469     ) internal view {
1470         _sendLogPayload(
1471             abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2)
1472         );
1473     }
1474 
1475     function log(
1476         address p0,
1477         address p1,
1478         address p2
1479     ) internal view {
1480         _sendLogPayload(
1481             abi.encodeWithSignature("log(address,address,address)", p0, p1, p2)
1482         );
1483     }
1484 
1485     function log(
1486         uint256 p0,
1487         uint256 p1,
1488         uint256 p2,
1489         uint256 p3
1490     ) internal view {
1491         _sendLogPayload(
1492             abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3)
1493         );
1494     }
1495 
1496     function log(
1497         uint256 p0,
1498         uint256 p1,
1499         uint256 p2,
1500         string memory p3
1501     ) internal view {
1502         _sendLogPayload(
1503             abi.encodeWithSignature(
1504                 "log(uint,uint,uint,string)",
1505                 p0,
1506                 p1,
1507                 p2,
1508                 p3
1509             )
1510         );
1511     }
1512 
1513     function log(
1514         uint256 p0,
1515         uint256 p1,
1516         uint256 p2,
1517         bool p3
1518     ) internal view {
1519         _sendLogPayload(
1520             abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3)
1521         );
1522     }
1523 
1524     function log(
1525         uint256 p0,
1526         uint256 p1,
1527         uint256 p2,
1528         address p3
1529     ) internal view {
1530         _sendLogPayload(
1531             abi.encodeWithSignature(
1532                 "log(uint,uint,uint,address)",
1533                 p0,
1534                 p1,
1535                 p2,
1536                 p3
1537             )
1538         );
1539     }
1540 
1541     function log(
1542         uint256 p0,
1543         uint256 p1,
1544         string memory p2,
1545         uint256 p3
1546     ) internal view {
1547         _sendLogPayload(
1548             abi.encodeWithSignature(
1549                 "log(uint,uint,string,uint)",
1550                 p0,
1551                 p1,
1552                 p2,
1553                 p3
1554             )
1555         );
1556     }
1557 
1558     function log(
1559         uint256 p0,
1560         uint256 p1,
1561         string memory p2,
1562         string memory p3
1563     ) internal view {
1564         _sendLogPayload(
1565             abi.encodeWithSignature(
1566                 "log(uint,uint,string,string)",
1567                 p0,
1568                 p1,
1569                 p2,
1570                 p3
1571             )
1572         );
1573     }
1574 
1575     function log(
1576         uint256 p0,
1577         uint256 p1,
1578         string memory p2,
1579         bool p3
1580     ) internal view {
1581         _sendLogPayload(
1582             abi.encodeWithSignature(
1583                 "log(uint,uint,string,bool)",
1584                 p0,
1585                 p1,
1586                 p2,
1587                 p3
1588             )
1589         );
1590     }
1591 
1592     function log(
1593         uint256 p0,
1594         uint256 p1,
1595         string memory p2,
1596         address p3
1597     ) internal view {
1598         _sendLogPayload(
1599             abi.encodeWithSignature(
1600                 "log(uint,uint,string,address)",
1601                 p0,
1602                 p1,
1603                 p2,
1604                 p3
1605             )
1606         );
1607     }
1608 
1609     function log(
1610         uint256 p0,
1611         uint256 p1,
1612         bool p2,
1613         uint256 p3
1614     ) internal view {
1615         _sendLogPayload(
1616             abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3)
1617         );
1618     }
1619 
1620     function log(
1621         uint256 p0,
1622         uint256 p1,
1623         bool p2,
1624         string memory p3
1625     ) internal view {
1626         _sendLogPayload(
1627             abi.encodeWithSignature(
1628                 "log(uint,uint,bool,string)",
1629                 p0,
1630                 p1,
1631                 p2,
1632                 p3
1633             )
1634         );
1635     }
1636 
1637     function log(
1638         uint256 p0,
1639         uint256 p1,
1640         bool p2,
1641         bool p3
1642     ) internal view {
1643         _sendLogPayload(
1644             abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3)
1645         );
1646     }
1647 
1648     function log(
1649         uint256 p0,
1650         uint256 p1,
1651         bool p2,
1652         address p3
1653     ) internal view {
1654         _sendLogPayload(
1655             abi.encodeWithSignature(
1656                 "log(uint,uint,bool,address)",
1657                 p0,
1658                 p1,
1659                 p2,
1660                 p3
1661             )
1662         );
1663     }
1664 
1665     function log(
1666         uint256 p0,
1667         uint256 p1,
1668         address p2,
1669         uint256 p3
1670     ) internal view {
1671         _sendLogPayload(
1672             abi.encodeWithSignature(
1673                 "log(uint,uint,address,uint)",
1674                 p0,
1675                 p1,
1676                 p2,
1677                 p3
1678             )
1679         );
1680     }
1681 
1682     function log(
1683         uint256 p0,
1684         uint256 p1,
1685         address p2,
1686         string memory p3
1687     ) internal view {
1688         _sendLogPayload(
1689             abi.encodeWithSignature(
1690                 "log(uint,uint,address,string)",
1691                 p0,
1692                 p1,
1693                 p2,
1694                 p3
1695             )
1696         );
1697     }
1698 
1699     function log(
1700         uint256 p0,
1701         uint256 p1,
1702         address p2,
1703         bool p3
1704     ) internal view {
1705         _sendLogPayload(
1706             abi.encodeWithSignature(
1707                 "log(uint,uint,address,bool)",
1708                 p0,
1709                 p1,
1710                 p2,
1711                 p3
1712             )
1713         );
1714     }
1715 
1716     function log(
1717         uint256 p0,
1718         uint256 p1,
1719         address p2,
1720         address p3
1721     ) internal view {
1722         _sendLogPayload(
1723             abi.encodeWithSignature(
1724                 "log(uint,uint,address,address)",
1725                 p0,
1726                 p1,
1727                 p2,
1728                 p3
1729             )
1730         );
1731     }
1732 
1733     function log(
1734         uint256 p0,
1735         string memory p1,
1736         uint256 p2,
1737         uint256 p3
1738     ) internal view {
1739         _sendLogPayload(
1740             abi.encodeWithSignature(
1741                 "log(uint,string,uint,uint)",
1742                 p0,
1743                 p1,
1744                 p2,
1745                 p3
1746             )
1747         );
1748     }
1749 
1750     function log(
1751         uint256 p0,
1752         string memory p1,
1753         uint256 p2,
1754         string memory p3
1755     ) internal view {
1756         _sendLogPayload(
1757             abi.encodeWithSignature(
1758                 "log(uint,string,uint,string)",
1759                 p0,
1760                 p1,
1761                 p2,
1762                 p3
1763             )
1764         );
1765     }
1766 
1767     function log(
1768         uint256 p0,
1769         string memory p1,
1770         uint256 p2,
1771         bool p3
1772     ) internal view {
1773         _sendLogPayload(
1774             abi.encodeWithSignature(
1775                 "log(uint,string,uint,bool)",
1776                 p0,
1777                 p1,
1778                 p2,
1779                 p3
1780             )
1781         );
1782     }
1783 
1784     function log(
1785         uint256 p0,
1786         string memory p1,
1787         uint256 p2,
1788         address p3
1789     ) internal view {
1790         _sendLogPayload(
1791             abi.encodeWithSignature(
1792                 "log(uint,string,uint,address)",
1793                 p0,
1794                 p1,
1795                 p2,
1796                 p3
1797             )
1798         );
1799     }
1800 
1801     function log(
1802         uint256 p0,
1803         string memory p1,
1804         string memory p2,
1805         uint256 p3
1806     ) internal view {
1807         _sendLogPayload(
1808             abi.encodeWithSignature(
1809                 "log(uint,string,string,uint)",
1810                 p0,
1811                 p1,
1812                 p2,
1813                 p3
1814             )
1815         );
1816     }
1817 
1818     function log(
1819         uint256 p0,
1820         string memory p1,
1821         string memory p2,
1822         string memory p3
1823     ) internal view {
1824         _sendLogPayload(
1825             abi.encodeWithSignature(
1826                 "log(uint,string,string,string)",
1827                 p0,
1828                 p1,
1829                 p2,
1830                 p3
1831             )
1832         );
1833     }
1834 
1835     function log(
1836         uint256 p0,
1837         string memory p1,
1838         string memory p2,
1839         bool p3
1840     ) internal view {
1841         _sendLogPayload(
1842             abi.encodeWithSignature(
1843                 "log(uint,string,string,bool)",
1844                 p0,
1845                 p1,
1846                 p2,
1847                 p3
1848             )
1849         );
1850     }
1851 
1852     function log(
1853         uint256 p0,
1854         string memory p1,
1855         string memory p2,
1856         address p3
1857     ) internal view {
1858         _sendLogPayload(
1859             abi.encodeWithSignature(
1860                 "log(uint,string,string,address)",
1861                 p0,
1862                 p1,
1863                 p2,
1864                 p3
1865             )
1866         );
1867     }
1868 
1869     function log(
1870         uint256 p0,
1871         string memory p1,
1872         bool p2,
1873         uint256 p3
1874     ) internal view {
1875         _sendLogPayload(
1876             abi.encodeWithSignature(
1877                 "log(uint,string,bool,uint)",
1878                 p0,
1879                 p1,
1880                 p2,
1881                 p3
1882             )
1883         );
1884     }
1885 
1886     function log(
1887         uint256 p0,
1888         string memory p1,
1889         bool p2,
1890         string memory p3
1891     ) internal view {
1892         _sendLogPayload(
1893             abi.encodeWithSignature(
1894                 "log(uint,string,bool,string)",
1895                 p0,
1896                 p1,
1897                 p2,
1898                 p3
1899             )
1900         );
1901     }
1902 
1903     function log(
1904         uint256 p0,
1905         string memory p1,
1906         bool p2,
1907         bool p3
1908     ) internal view {
1909         _sendLogPayload(
1910             abi.encodeWithSignature(
1911                 "log(uint,string,bool,bool)",
1912                 p0,
1913                 p1,
1914                 p2,
1915                 p3
1916             )
1917         );
1918     }
1919 
1920     function log(
1921         uint256 p0,
1922         string memory p1,
1923         bool p2,
1924         address p3
1925     ) internal view {
1926         _sendLogPayload(
1927             abi.encodeWithSignature(
1928                 "log(uint,string,bool,address)",
1929                 p0,
1930                 p1,
1931                 p2,
1932                 p3
1933             )
1934         );
1935     }
1936 
1937     function log(
1938         uint256 p0,
1939         string memory p1,
1940         address p2,
1941         uint256 p3
1942     ) internal view {
1943         _sendLogPayload(
1944             abi.encodeWithSignature(
1945                 "log(uint,string,address,uint)",
1946                 p0,
1947                 p1,
1948                 p2,
1949                 p3
1950             )
1951         );
1952     }
1953 
1954     function log(
1955         uint256 p0,
1956         string memory p1,
1957         address p2,
1958         string memory p3
1959     ) internal view {
1960         _sendLogPayload(
1961             abi.encodeWithSignature(
1962                 "log(uint,string,address,string)",
1963                 p0,
1964                 p1,
1965                 p2,
1966                 p3
1967             )
1968         );
1969     }
1970 
1971     function log(
1972         uint256 p0,
1973         string memory p1,
1974         address p2,
1975         bool p3
1976     ) internal view {
1977         _sendLogPayload(
1978             abi.encodeWithSignature(
1979                 "log(uint,string,address,bool)",
1980                 p0,
1981                 p1,
1982                 p2,
1983                 p3
1984             )
1985         );
1986     }
1987 
1988     function log(
1989         uint256 p0,
1990         string memory p1,
1991         address p2,
1992         address p3
1993     ) internal view {
1994         _sendLogPayload(
1995             abi.encodeWithSignature(
1996                 "log(uint,string,address,address)",
1997                 p0,
1998                 p1,
1999                 p2,
2000                 p3
2001             )
2002         );
2003     }
2004 
2005     function log(
2006         uint256 p0,
2007         bool p1,
2008         uint256 p2,
2009         uint256 p3
2010     ) internal view {
2011         _sendLogPayload(
2012             abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3)
2013         );
2014     }
2015 
2016     function log(
2017         uint256 p0,
2018         bool p1,
2019         uint256 p2,
2020         string memory p3
2021     ) internal view {
2022         _sendLogPayload(
2023             abi.encodeWithSignature(
2024                 "log(uint,bool,uint,string)",
2025                 p0,
2026                 p1,
2027                 p2,
2028                 p3
2029             )
2030         );
2031     }
2032 
2033     function log(
2034         uint256 p0,
2035         bool p1,
2036         uint256 p2,
2037         bool p3
2038     ) internal view {
2039         _sendLogPayload(
2040             abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3)
2041         );
2042     }
2043 
2044     function log(
2045         uint256 p0,
2046         bool p1,
2047         uint256 p2,
2048         address p3
2049     ) internal view {
2050         _sendLogPayload(
2051             abi.encodeWithSignature(
2052                 "log(uint,bool,uint,address)",
2053                 p0,
2054                 p1,
2055                 p2,
2056                 p3
2057             )
2058         );
2059     }
2060 
2061     function log(
2062         uint256 p0,
2063         bool p1,
2064         string memory p2,
2065         uint256 p3
2066     ) internal view {
2067         _sendLogPayload(
2068             abi.encodeWithSignature(
2069                 "log(uint,bool,string,uint)",
2070                 p0,
2071                 p1,
2072                 p2,
2073                 p3
2074             )
2075         );
2076     }
2077 
2078     function log(
2079         uint256 p0,
2080         bool p1,
2081         string memory p2,
2082         string memory p3
2083     ) internal view {
2084         _sendLogPayload(
2085             abi.encodeWithSignature(
2086                 "log(uint,bool,string,string)",
2087                 p0,
2088                 p1,
2089                 p2,
2090                 p3
2091             )
2092         );
2093     }
2094 
2095     function log(
2096         uint256 p0,
2097         bool p1,
2098         string memory p2,
2099         bool p3
2100     ) internal view {
2101         _sendLogPayload(
2102             abi.encodeWithSignature(
2103                 "log(uint,bool,string,bool)",
2104                 p0,
2105                 p1,
2106                 p2,
2107                 p3
2108             )
2109         );
2110     }
2111 
2112     function log(
2113         uint256 p0,
2114         bool p1,
2115         string memory p2,
2116         address p3
2117     ) internal view {
2118         _sendLogPayload(
2119             abi.encodeWithSignature(
2120                 "log(uint,bool,string,address)",
2121                 p0,
2122                 p1,
2123                 p2,
2124                 p3
2125             )
2126         );
2127     }
2128 
2129     function log(
2130         uint256 p0,
2131         bool p1,
2132         bool p2,
2133         uint256 p3
2134     ) internal view {
2135         _sendLogPayload(
2136             abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3)
2137         );
2138     }
2139 
2140     function log(
2141         uint256 p0,
2142         bool p1,
2143         bool p2,
2144         string memory p3
2145     ) internal view {
2146         _sendLogPayload(
2147             abi.encodeWithSignature(
2148                 "log(uint,bool,bool,string)",
2149                 p0,
2150                 p1,
2151                 p2,
2152                 p3
2153             )
2154         );
2155     }
2156 
2157     function log(
2158         uint256 p0,
2159         bool p1,
2160         bool p2,
2161         bool p3
2162     ) internal view {
2163         _sendLogPayload(
2164             abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3)
2165         );
2166     }
2167 
2168     function log(
2169         uint256 p0,
2170         bool p1,
2171         bool p2,
2172         address p3
2173     ) internal view {
2174         _sendLogPayload(
2175             abi.encodeWithSignature(
2176                 "log(uint,bool,bool,address)",
2177                 p0,
2178                 p1,
2179                 p2,
2180                 p3
2181             )
2182         );
2183     }
2184 
2185     function log(
2186         uint256 p0,
2187         bool p1,
2188         address p2,
2189         uint256 p3
2190     ) internal view {
2191         _sendLogPayload(
2192             abi.encodeWithSignature(
2193                 "log(uint,bool,address,uint)",
2194                 p0,
2195                 p1,
2196                 p2,
2197                 p3
2198             )
2199         );
2200     }
2201 
2202     function log(
2203         uint256 p0,
2204         bool p1,
2205         address p2,
2206         string memory p3
2207     ) internal view {
2208         _sendLogPayload(
2209             abi.encodeWithSignature(
2210                 "log(uint,bool,address,string)",
2211                 p0,
2212                 p1,
2213                 p2,
2214                 p3
2215             )
2216         );
2217     }
2218 
2219     function log(
2220         uint256 p0,
2221         bool p1,
2222         address p2,
2223         bool p3
2224     ) internal view {
2225         _sendLogPayload(
2226             abi.encodeWithSignature(
2227                 "log(uint,bool,address,bool)",
2228                 p0,
2229                 p1,
2230                 p2,
2231                 p3
2232             )
2233         );
2234     }
2235 
2236     function log(
2237         uint256 p0,
2238         bool p1,
2239         address p2,
2240         address p3
2241     ) internal view {
2242         _sendLogPayload(
2243             abi.encodeWithSignature(
2244                 "log(uint,bool,address,address)",
2245                 p0,
2246                 p1,
2247                 p2,
2248                 p3
2249             )
2250         );
2251     }
2252 
2253     function log(
2254         uint256 p0,
2255         address p1,
2256         uint256 p2,
2257         uint256 p3
2258     ) internal view {
2259         _sendLogPayload(
2260             abi.encodeWithSignature(
2261                 "log(uint,address,uint,uint)",
2262                 p0,
2263                 p1,
2264                 p2,
2265                 p3
2266             )
2267         );
2268     }
2269 
2270     function log(
2271         uint256 p0,
2272         address p1,
2273         uint256 p2,
2274         string memory p3
2275     ) internal view {
2276         _sendLogPayload(
2277             abi.encodeWithSignature(
2278                 "log(uint,address,uint,string)",
2279                 p0,
2280                 p1,
2281                 p2,
2282                 p3
2283             )
2284         );
2285     }
2286 
2287     function log(
2288         uint256 p0,
2289         address p1,
2290         uint256 p2,
2291         bool p3
2292     ) internal view {
2293         _sendLogPayload(
2294             abi.encodeWithSignature(
2295                 "log(uint,address,uint,bool)",
2296                 p0,
2297                 p1,
2298                 p2,
2299                 p3
2300             )
2301         );
2302     }
2303 
2304     function log(
2305         uint256 p0,
2306         address p1,
2307         uint256 p2,
2308         address p3
2309     ) internal view {
2310         _sendLogPayload(
2311             abi.encodeWithSignature(
2312                 "log(uint,address,uint,address)",
2313                 p0,
2314                 p1,
2315                 p2,
2316                 p3
2317             )
2318         );
2319     }
2320 
2321     function log(
2322         uint256 p0,
2323         address p1,
2324         string memory p2,
2325         uint256 p3
2326     ) internal view {
2327         _sendLogPayload(
2328             abi.encodeWithSignature(
2329                 "log(uint,address,string,uint)",
2330                 p0,
2331                 p1,
2332                 p2,
2333                 p3
2334             )
2335         );
2336     }
2337 
2338     function log(
2339         uint256 p0,
2340         address p1,
2341         string memory p2,
2342         string memory p3
2343     ) internal view {
2344         _sendLogPayload(
2345             abi.encodeWithSignature(
2346                 "log(uint,address,string,string)",
2347                 p0,
2348                 p1,
2349                 p2,
2350                 p3
2351             )
2352         );
2353     }
2354 
2355     function log(
2356         uint256 p0,
2357         address p1,
2358         string memory p2,
2359         bool p3
2360     ) internal view {
2361         _sendLogPayload(
2362             abi.encodeWithSignature(
2363                 "log(uint,address,string,bool)",
2364                 p0,
2365                 p1,
2366                 p2,
2367                 p3
2368             )
2369         );
2370     }
2371 
2372     function log(
2373         uint256 p0,
2374         address p1,
2375         string memory p2,
2376         address p3
2377     ) internal view {
2378         _sendLogPayload(
2379             abi.encodeWithSignature(
2380                 "log(uint,address,string,address)",
2381                 p0,
2382                 p1,
2383                 p2,
2384                 p3
2385             )
2386         );
2387     }
2388 
2389     function log(
2390         uint256 p0,
2391         address p1,
2392         bool p2,
2393         uint256 p3
2394     ) internal view {
2395         _sendLogPayload(
2396             abi.encodeWithSignature(
2397                 "log(uint,address,bool,uint)",
2398                 p0,
2399                 p1,
2400                 p2,
2401                 p3
2402             )
2403         );
2404     }
2405 
2406     function log(
2407         uint256 p0,
2408         address p1,
2409         bool p2,
2410         string memory p3
2411     ) internal view {
2412         _sendLogPayload(
2413             abi.encodeWithSignature(
2414                 "log(uint,address,bool,string)",
2415                 p0,
2416                 p1,
2417                 p2,
2418                 p3
2419             )
2420         );
2421     }
2422 
2423     function log(
2424         uint256 p0,
2425         address p1,
2426         bool p2,
2427         bool p3
2428     ) internal view {
2429         _sendLogPayload(
2430             abi.encodeWithSignature(
2431                 "log(uint,address,bool,bool)",
2432                 p0,
2433                 p1,
2434                 p2,
2435                 p3
2436             )
2437         );
2438     }
2439 
2440     function log(
2441         uint256 p0,
2442         address p1,
2443         bool p2,
2444         address p3
2445     ) internal view {
2446         _sendLogPayload(
2447             abi.encodeWithSignature(
2448                 "log(uint,address,bool,address)",
2449                 p0,
2450                 p1,
2451                 p2,
2452                 p3
2453             )
2454         );
2455     }
2456 
2457     function log(
2458         uint256 p0,
2459         address p1,
2460         address p2,
2461         uint256 p3
2462     ) internal view {
2463         _sendLogPayload(
2464             abi.encodeWithSignature(
2465                 "log(uint,address,address,uint)",
2466                 p0,
2467                 p1,
2468                 p2,
2469                 p3
2470             )
2471         );
2472     }
2473 
2474     function log(
2475         uint256 p0,
2476         address p1,
2477         address p2,
2478         string memory p3
2479     ) internal view {
2480         _sendLogPayload(
2481             abi.encodeWithSignature(
2482                 "log(uint,address,address,string)",
2483                 p0,
2484                 p1,
2485                 p2,
2486                 p3
2487             )
2488         );
2489     }
2490 
2491     function log(
2492         uint256 p0,
2493         address p1,
2494         address p2,
2495         bool p3
2496     ) internal view {
2497         _sendLogPayload(
2498             abi.encodeWithSignature(
2499                 "log(uint,address,address,bool)",
2500                 p0,
2501                 p1,
2502                 p2,
2503                 p3
2504             )
2505         );
2506     }
2507 
2508     function log(
2509         uint256 p0,
2510         address p1,
2511         address p2,
2512         address p3
2513     ) internal view {
2514         _sendLogPayload(
2515             abi.encodeWithSignature(
2516                 "log(uint,address,address,address)",
2517                 p0,
2518                 p1,
2519                 p2,
2520                 p3
2521             )
2522         );
2523     }
2524 
2525     function log(
2526         string memory p0,
2527         uint256 p1,
2528         uint256 p2,
2529         uint256 p3
2530     ) internal view {
2531         _sendLogPayload(
2532             abi.encodeWithSignature(
2533                 "log(string,uint,uint,uint)",
2534                 p0,
2535                 p1,
2536                 p2,
2537                 p3
2538             )
2539         );
2540     }
2541 
2542     function log(
2543         string memory p0,
2544         uint256 p1,
2545         uint256 p2,
2546         string memory p3
2547     ) internal view {
2548         _sendLogPayload(
2549             abi.encodeWithSignature(
2550                 "log(string,uint,uint,string)",
2551                 p0,
2552                 p1,
2553                 p2,
2554                 p3
2555             )
2556         );
2557     }
2558 
2559     function log(
2560         string memory p0,
2561         uint256 p1,
2562         uint256 p2,
2563         bool p3
2564     ) internal view {
2565         _sendLogPayload(
2566             abi.encodeWithSignature(
2567                 "log(string,uint,uint,bool)",
2568                 p0,
2569                 p1,
2570                 p2,
2571                 p3
2572             )
2573         );
2574     }
2575 
2576     function log(
2577         string memory p0,
2578         uint256 p1,
2579         uint256 p2,
2580         address p3
2581     ) internal view {
2582         _sendLogPayload(
2583             abi.encodeWithSignature(
2584                 "log(string,uint,uint,address)",
2585                 p0,
2586                 p1,
2587                 p2,
2588                 p3
2589             )
2590         );
2591     }
2592 
2593     function log(
2594         string memory p0,
2595         uint256 p1,
2596         string memory p2,
2597         uint256 p3
2598     ) internal view {
2599         _sendLogPayload(
2600             abi.encodeWithSignature(
2601                 "log(string,uint,string,uint)",
2602                 p0,
2603                 p1,
2604                 p2,
2605                 p3
2606             )
2607         );
2608     }
2609 
2610     function log(
2611         string memory p0,
2612         uint256 p1,
2613         string memory p2,
2614         string memory p3
2615     ) internal view {
2616         _sendLogPayload(
2617             abi.encodeWithSignature(
2618                 "log(string,uint,string,string)",
2619                 p0,
2620                 p1,
2621                 p2,
2622                 p3
2623             )
2624         );
2625     }
2626 
2627     function log(
2628         string memory p0,
2629         uint256 p1,
2630         string memory p2,
2631         bool p3
2632     ) internal view {
2633         _sendLogPayload(
2634             abi.encodeWithSignature(
2635                 "log(string,uint,string,bool)",
2636                 p0,
2637                 p1,
2638                 p2,
2639                 p3
2640             )
2641         );
2642     }
2643 
2644     function log(
2645         string memory p0,
2646         uint256 p1,
2647         string memory p2,
2648         address p3
2649     ) internal view {
2650         _sendLogPayload(
2651             abi.encodeWithSignature(
2652                 "log(string,uint,string,address)",
2653                 p0,
2654                 p1,
2655                 p2,
2656                 p3
2657             )
2658         );
2659     }
2660 
2661     function log(
2662         string memory p0,
2663         uint256 p1,
2664         bool p2,
2665         uint256 p3
2666     ) internal view {
2667         _sendLogPayload(
2668             abi.encodeWithSignature(
2669                 "log(string,uint,bool,uint)",
2670                 p0,
2671                 p1,
2672                 p2,
2673                 p3
2674             )
2675         );
2676     }
2677 
2678     function log(
2679         string memory p0,
2680         uint256 p1,
2681         bool p2,
2682         string memory p3
2683     ) internal view {
2684         _sendLogPayload(
2685             abi.encodeWithSignature(
2686                 "log(string,uint,bool,string)",
2687                 p0,
2688                 p1,
2689                 p2,
2690                 p3
2691             )
2692         );
2693     }
2694 
2695     function log(
2696         string memory p0,
2697         uint256 p1,
2698         bool p2,
2699         bool p3
2700     ) internal view {
2701         _sendLogPayload(
2702             abi.encodeWithSignature(
2703                 "log(string,uint,bool,bool)",
2704                 p0,
2705                 p1,
2706                 p2,
2707                 p3
2708             )
2709         );
2710     }
2711 
2712     function log(
2713         string memory p0,
2714         uint256 p1,
2715         bool p2,
2716         address p3
2717     ) internal view {
2718         _sendLogPayload(
2719             abi.encodeWithSignature(
2720                 "log(string,uint,bool,address)",
2721                 p0,
2722                 p1,
2723                 p2,
2724                 p3
2725             )
2726         );
2727     }
2728 
2729     function log(
2730         string memory p0,
2731         uint256 p1,
2732         address p2,
2733         uint256 p3
2734     ) internal view {
2735         _sendLogPayload(
2736             abi.encodeWithSignature(
2737                 "log(string,uint,address,uint)",
2738                 p0,
2739                 p1,
2740                 p2,
2741                 p3
2742             )
2743         );
2744     }
2745 
2746     function log(
2747         string memory p0,
2748         uint256 p1,
2749         address p2,
2750         string memory p3
2751     ) internal view {
2752         _sendLogPayload(
2753             abi.encodeWithSignature(
2754                 "log(string,uint,address,string)",
2755                 p0,
2756                 p1,
2757                 p2,
2758                 p3
2759             )
2760         );
2761     }
2762 
2763     function log(
2764         string memory p0,
2765         uint256 p1,
2766         address p2,
2767         bool p3
2768     ) internal view {
2769         _sendLogPayload(
2770             abi.encodeWithSignature(
2771                 "log(string,uint,address,bool)",
2772                 p0,
2773                 p1,
2774                 p2,
2775                 p3
2776             )
2777         );
2778     }
2779 
2780     function log(
2781         string memory p0,
2782         uint256 p1,
2783         address p2,
2784         address p3
2785     ) internal view {
2786         _sendLogPayload(
2787             abi.encodeWithSignature(
2788                 "log(string,uint,address,address)",
2789                 p0,
2790                 p1,
2791                 p2,
2792                 p3
2793             )
2794         );
2795     }
2796 
2797     function log(
2798         string memory p0,
2799         string memory p1,
2800         uint256 p2,
2801         uint256 p3
2802     ) internal view {
2803         _sendLogPayload(
2804             abi.encodeWithSignature(
2805                 "log(string,string,uint,uint)",
2806                 p0,
2807                 p1,
2808                 p2,
2809                 p3
2810             )
2811         );
2812     }
2813 
2814     function log(
2815         string memory p0,
2816         string memory p1,
2817         uint256 p2,
2818         string memory p3
2819     ) internal view {
2820         _sendLogPayload(
2821             abi.encodeWithSignature(
2822                 "log(string,string,uint,string)",
2823                 p0,
2824                 p1,
2825                 p2,
2826                 p3
2827             )
2828         );
2829     }
2830 
2831     function log(
2832         string memory p0,
2833         string memory p1,
2834         uint256 p2,
2835         bool p3
2836     ) internal view {
2837         _sendLogPayload(
2838             abi.encodeWithSignature(
2839                 "log(string,string,uint,bool)",
2840                 p0,
2841                 p1,
2842                 p2,
2843                 p3
2844             )
2845         );
2846     }
2847 
2848     function log(
2849         string memory p0,
2850         string memory p1,
2851         uint256 p2,
2852         address p3
2853     ) internal view {
2854         _sendLogPayload(
2855             abi.encodeWithSignature(
2856                 "log(string,string,uint,address)",
2857                 p0,
2858                 p1,
2859                 p2,
2860                 p3
2861             )
2862         );
2863     }
2864 
2865     function log(
2866         string memory p0,
2867         string memory p1,
2868         string memory p2,
2869         uint256 p3
2870     ) internal view {
2871         _sendLogPayload(
2872             abi.encodeWithSignature(
2873                 "log(string,string,string,uint)",
2874                 p0,
2875                 p1,
2876                 p2,
2877                 p3
2878             )
2879         );
2880     }
2881 
2882     function log(
2883         string memory p0,
2884         string memory p1,
2885         string memory p2,
2886         string memory p3
2887     ) internal view {
2888         _sendLogPayload(
2889             abi.encodeWithSignature(
2890                 "log(string,string,string,string)",
2891                 p0,
2892                 p1,
2893                 p2,
2894                 p3
2895             )
2896         );
2897     }
2898 
2899     function log(
2900         string memory p0,
2901         string memory p1,
2902         string memory p2,
2903         bool p3
2904     ) internal view {
2905         _sendLogPayload(
2906             abi.encodeWithSignature(
2907                 "log(string,string,string,bool)",
2908                 p0,
2909                 p1,
2910                 p2,
2911                 p3
2912             )
2913         );
2914     }
2915 
2916     function log(
2917         string memory p0,
2918         string memory p1,
2919         string memory p2,
2920         address p3
2921     ) internal view {
2922         _sendLogPayload(
2923             abi.encodeWithSignature(
2924                 "log(string,string,string,address)",
2925                 p0,
2926                 p1,
2927                 p2,
2928                 p3
2929             )
2930         );
2931     }
2932 
2933     function log(
2934         string memory p0,
2935         string memory p1,
2936         bool p2,
2937         uint256 p3
2938     ) internal view {
2939         _sendLogPayload(
2940             abi.encodeWithSignature(
2941                 "log(string,string,bool,uint)",
2942                 p0,
2943                 p1,
2944                 p2,
2945                 p3
2946             )
2947         );
2948     }
2949 
2950     function log(
2951         string memory p0,
2952         string memory p1,
2953         bool p2,
2954         string memory p3
2955     ) internal view {
2956         _sendLogPayload(
2957             abi.encodeWithSignature(
2958                 "log(string,string,bool,string)",
2959                 p0,
2960                 p1,
2961                 p2,
2962                 p3
2963             )
2964         );
2965     }
2966 
2967     function log(
2968         string memory p0,
2969         string memory p1,
2970         bool p2,
2971         bool p3
2972     ) internal view {
2973         _sendLogPayload(
2974             abi.encodeWithSignature(
2975                 "log(string,string,bool,bool)",
2976                 p0,
2977                 p1,
2978                 p2,
2979                 p3
2980             )
2981         );
2982     }
2983 
2984     function log(
2985         string memory p0,
2986         string memory p1,
2987         bool p2,
2988         address p3
2989     ) internal view {
2990         _sendLogPayload(
2991             abi.encodeWithSignature(
2992                 "log(string,string,bool,address)",
2993                 p0,
2994                 p1,
2995                 p2,
2996                 p3
2997             )
2998         );
2999     }
3000 
3001     function log(
3002         string memory p0,
3003         string memory p1,
3004         address p2,
3005         uint256 p3
3006     ) internal view {
3007         _sendLogPayload(
3008             abi.encodeWithSignature(
3009                 "log(string,string,address,uint)",
3010                 p0,
3011                 p1,
3012                 p2,
3013                 p3
3014             )
3015         );
3016     }
3017 
3018     function log(
3019         string memory p0,
3020         string memory p1,
3021         address p2,
3022         string memory p3
3023     ) internal view {
3024         _sendLogPayload(
3025             abi.encodeWithSignature(
3026                 "log(string,string,address,string)",
3027                 p0,
3028                 p1,
3029                 p2,
3030                 p3
3031             )
3032         );
3033     }
3034 
3035     function log(
3036         string memory p0,
3037         string memory p1,
3038         address p2,
3039         bool p3
3040     ) internal view {
3041         _sendLogPayload(
3042             abi.encodeWithSignature(
3043                 "log(string,string,address,bool)",
3044                 p0,
3045                 p1,
3046                 p2,
3047                 p3
3048             )
3049         );
3050     }
3051 
3052     function log(
3053         string memory p0,
3054         string memory p1,
3055         address p2,
3056         address p3
3057     ) internal view {
3058         _sendLogPayload(
3059             abi.encodeWithSignature(
3060                 "log(string,string,address,address)",
3061                 p0,
3062                 p1,
3063                 p2,
3064                 p3
3065             )
3066         );
3067     }
3068 
3069     function log(
3070         string memory p0,
3071         bool p1,
3072         uint256 p2,
3073         uint256 p3
3074     ) internal view {
3075         _sendLogPayload(
3076             abi.encodeWithSignature(
3077                 "log(string,bool,uint,uint)",
3078                 p0,
3079                 p1,
3080                 p2,
3081                 p3
3082             )
3083         );
3084     }
3085 
3086     function log(
3087         string memory p0,
3088         bool p1,
3089         uint256 p2,
3090         string memory p3
3091     ) internal view {
3092         _sendLogPayload(
3093             abi.encodeWithSignature(
3094                 "log(string,bool,uint,string)",
3095                 p0,
3096                 p1,
3097                 p2,
3098                 p3
3099             )
3100         );
3101     }
3102 
3103     function log(
3104         string memory p0,
3105         bool p1,
3106         uint256 p2,
3107         bool p3
3108     ) internal view {
3109         _sendLogPayload(
3110             abi.encodeWithSignature(
3111                 "log(string,bool,uint,bool)",
3112                 p0,
3113                 p1,
3114                 p2,
3115                 p3
3116             )
3117         );
3118     }
3119 
3120     function log(
3121         string memory p0,
3122         bool p1,
3123         uint256 p2,
3124         address p3
3125     ) internal view {
3126         _sendLogPayload(
3127             abi.encodeWithSignature(
3128                 "log(string,bool,uint,address)",
3129                 p0,
3130                 p1,
3131                 p2,
3132                 p3
3133             )
3134         );
3135     }
3136 
3137     function log(
3138         string memory p0,
3139         bool p1,
3140         string memory p2,
3141         uint256 p3
3142     ) internal view {
3143         _sendLogPayload(
3144             abi.encodeWithSignature(
3145                 "log(string,bool,string,uint)",
3146                 p0,
3147                 p1,
3148                 p2,
3149                 p3
3150             )
3151         );
3152     }
3153 
3154     function log(
3155         string memory p0,
3156         bool p1,
3157         string memory p2,
3158         string memory p3
3159     ) internal view {
3160         _sendLogPayload(
3161             abi.encodeWithSignature(
3162                 "log(string,bool,string,string)",
3163                 p0,
3164                 p1,
3165                 p2,
3166                 p3
3167             )
3168         );
3169     }
3170 
3171     function log(
3172         string memory p0,
3173         bool p1,
3174         string memory p2,
3175         bool p3
3176     ) internal view {
3177         _sendLogPayload(
3178             abi.encodeWithSignature(
3179                 "log(string,bool,string,bool)",
3180                 p0,
3181                 p1,
3182                 p2,
3183                 p3
3184             )
3185         );
3186     }
3187 
3188     function log(
3189         string memory p0,
3190         bool p1,
3191         string memory p2,
3192         address p3
3193     ) internal view {
3194         _sendLogPayload(
3195             abi.encodeWithSignature(
3196                 "log(string,bool,string,address)",
3197                 p0,
3198                 p1,
3199                 p2,
3200                 p3
3201             )
3202         );
3203     }
3204 
3205     function log(
3206         string memory p0,
3207         bool p1,
3208         bool p2,
3209         uint256 p3
3210     ) internal view {
3211         _sendLogPayload(
3212             abi.encodeWithSignature(
3213                 "log(string,bool,bool,uint)",
3214                 p0,
3215                 p1,
3216                 p2,
3217                 p3
3218             )
3219         );
3220     }
3221 
3222     function log(
3223         string memory p0,
3224         bool p1,
3225         bool p2,
3226         string memory p3
3227     ) internal view {
3228         _sendLogPayload(
3229             abi.encodeWithSignature(
3230                 "log(string,bool,bool,string)",
3231                 p0,
3232                 p1,
3233                 p2,
3234                 p3
3235             )
3236         );
3237     }
3238 
3239     function log(
3240         string memory p0,
3241         bool p1,
3242         bool p2,
3243         bool p3
3244     ) internal view {
3245         _sendLogPayload(
3246             abi.encodeWithSignature(
3247                 "log(string,bool,bool,bool)",
3248                 p0,
3249                 p1,
3250                 p2,
3251                 p3
3252             )
3253         );
3254     }
3255 
3256     function log(
3257         string memory p0,
3258         bool p1,
3259         bool p2,
3260         address p3
3261     ) internal view {
3262         _sendLogPayload(
3263             abi.encodeWithSignature(
3264                 "log(string,bool,bool,address)",
3265                 p0,
3266                 p1,
3267                 p2,
3268                 p3
3269             )
3270         );
3271     }
3272 
3273     function log(
3274         string memory p0,
3275         bool p1,
3276         address p2,
3277         uint256 p3
3278     ) internal view {
3279         _sendLogPayload(
3280             abi.encodeWithSignature(
3281                 "log(string,bool,address,uint)",
3282                 p0,
3283                 p1,
3284                 p2,
3285                 p3
3286             )
3287         );
3288     }
3289 
3290     function log(
3291         string memory p0,
3292         bool p1,
3293         address p2,
3294         string memory p3
3295     ) internal view {
3296         _sendLogPayload(
3297             abi.encodeWithSignature(
3298                 "log(string,bool,address,string)",
3299                 p0,
3300                 p1,
3301                 p2,
3302                 p3
3303             )
3304         );
3305     }
3306 
3307     function log(
3308         string memory p0,
3309         bool p1,
3310         address p2,
3311         bool p3
3312     ) internal view {
3313         _sendLogPayload(
3314             abi.encodeWithSignature(
3315                 "log(string,bool,address,bool)",
3316                 p0,
3317                 p1,
3318                 p2,
3319                 p3
3320             )
3321         );
3322     }
3323 
3324     function log(
3325         string memory p0,
3326         bool p1,
3327         address p2,
3328         address p3
3329     ) internal view {
3330         _sendLogPayload(
3331             abi.encodeWithSignature(
3332                 "log(string,bool,address,address)",
3333                 p0,
3334                 p1,
3335                 p2,
3336                 p3
3337             )
3338         );
3339     }
3340 
3341     function log(
3342         string memory p0,
3343         address p1,
3344         uint256 p2,
3345         uint256 p3
3346     ) internal view {
3347         _sendLogPayload(
3348             abi.encodeWithSignature(
3349                 "log(string,address,uint,uint)",
3350                 p0,
3351                 p1,
3352                 p2,
3353                 p3
3354             )
3355         );
3356     }
3357 
3358     function log(
3359         string memory p0,
3360         address p1,
3361         uint256 p2,
3362         string memory p3
3363     ) internal view {
3364         _sendLogPayload(
3365             abi.encodeWithSignature(
3366                 "log(string,address,uint,string)",
3367                 p0,
3368                 p1,
3369                 p2,
3370                 p3
3371             )
3372         );
3373     }
3374 
3375     function log(
3376         string memory p0,
3377         address p1,
3378         uint256 p2,
3379         bool p3
3380     ) internal view {
3381         _sendLogPayload(
3382             abi.encodeWithSignature(
3383                 "log(string,address,uint,bool)",
3384                 p0,
3385                 p1,
3386                 p2,
3387                 p3
3388             )
3389         );
3390     }
3391 
3392     function log(
3393         string memory p0,
3394         address p1,
3395         uint256 p2,
3396         address p3
3397     ) internal view {
3398         _sendLogPayload(
3399             abi.encodeWithSignature(
3400                 "log(string,address,uint,address)",
3401                 p0,
3402                 p1,
3403                 p2,
3404                 p3
3405             )
3406         );
3407     }
3408 
3409     function log(
3410         string memory p0,
3411         address p1,
3412         string memory p2,
3413         uint256 p3
3414     ) internal view {
3415         _sendLogPayload(
3416             abi.encodeWithSignature(
3417                 "log(string,address,string,uint)",
3418                 p0,
3419                 p1,
3420                 p2,
3421                 p3
3422             )
3423         );
3424     }
3425 
3426     function log(
3427         string memory p0,
3428         address p1,
3429         string memory p2,
3430         string memory p3
3431     ) internal view {
3432         _sendLogPayload(
3433             abi.encodeWithSignature(
3434                 "log(string,address,string,string)",
3435                 p0,
3436                 p1,
3437                 p2,
3438                 p3
3439             )
3440         );
3441     }
3442 
3443     function log(
3444         string memory p0,
3445         address p1,
3446         string memory p2,
3447         bool p3
3448     ) internal view {
3449         _sendLogPayload(
3450             abi.encodeWithSignature(
3451                 "log(string,address,string,bool)",
3452                 p0,
3453                 p1,
3454                 p2,
3455                 p3
3456             )
3457         );
3458     }
3459 
3460     function log(
3461         string memory p0,
3462         address p1,
3463         string memory p2,
3464         address p3
3465     ) internal view {
3466         _sendLogPayload(
3467             abi.encodeWithSignature(
3468                 "log(string,address,string,address)",
3469                 p0,
3470                 p1,
3471                 p2,
3472                 p3
3473             )
3474         );
3475     }
3476 
3477     function log(
3478         string memory p0,
3479         address p1,
3480         bool p2,
3481         uint256 p3
3482     ) internal view {
3483         _sendLogPayload(
3484             abi.encodeWithSignature(
3485                 "log(string,address,bool,uint)",
3486                 p0,
3487                 p1,
3488                 p2,
3489                 p3
3490             )
3491         );
3492     }
3493 
3494     function log(
3495         string memory p0,
3496         address p1,
3497         bool p2,
3498         string memory p3
3499     ) internal view {
3500         _sendLogPayload(
3501             abi.encodeWithSignature(
3502                 "log(string,address,bool,string)",
3503                 p0,
3504                 p1,
3505                 p2,
3506                 p3
3507             )
3508         );
3509     }
3510 
3511     function log(
3512         string memory p0,
3513         address p1,
3514         bool p2,
3515         bool p3
3516     ) internal view {
3517         _sendLogPayload(
3518             abi.encodeWithSignature(
3519                 "log(string,address,bool,bool)",
3520                 p0,
3521                 p1,
3522                 p2,
3523                 p3
3524             )
3525         );
3526     }
3527 
3528     function log(
3529         string memory p0,
3530         address p1,
3531         bool p2,
3532         address p3
3533     ) internal view {
3534         _sendLogPayload(
3535             abi.encodeWithSignature(
3536                 "log(string,address,bool,address)",
3537                 p0,
3538                 p1,
3539                 p2,
3540                 p3
3541             )
3542         );
3543     }
3544 
3545     function log(
3546         string memory p0,
3547         address p1,
3548         address p2,
3549         uint256 p3
3550     ) internal view {
3551         _sendLogPayload(
3552             abi.encodeWithSignature(
3553                 "log(string,address,address,uint)",
3554                 p0,
3555                 p1,
3556                 p2,
3557                 p3
3558             )
3559         );
3560     }
3561 
3562     function log(
3563         string memory p0,
3564         address p1,
3565         address p2,
3566         string memory p3
3567     ) internal view {
3568         _sendLogPayload(
3569             abi.encodeWithSignature(
3570                 "log(string,address,address,string)",
3571                 p0,
3572                 p1,
3573                 p2,
3574                 p3
3575             )
3576         );
3577     }
3578 
3579     function log(
3580         string memory p0,
3581         address p1,
3582         address p2,
3583         bool p3
3584     ) internal view {
3585         _sendLogPayload(
3586             abi.encodeWithSignature(
3587                 "log(string,address,address,bool)",
3588                 p0,
3589                 p1,
3590                 p2,
3591                 p3
3592             )
3593         );
3594     }
3595 
3596     function log(
3597         string memory p0,
3598         address p1,
3599         address p2,
3600         address p3
3601     ) internal view {
3602         _sendLogPayload(
3603             abi.encodeWithSignature(
3604                 "log(string,address,address,address)",
3605                 p0,
3606                 p1,
3607                 p2,
3608                 p3
3609             )
3610         );
3611     }
3612 
3613     function log(
3614         bool p0,
3615         uint256 p1,
3616         uint256 p2,
3617         uint256 p3
3618     ) internal view {
3619         _sendLogPayload(
3620             abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3)
3621         );
3622     }
3623 
3624     function log(
3625         bool p0,
3626         uint256 p1,
3627         uint256 p2,
3628         string memory p3
3629     ) internal view {
3630         _sendLogPayload(
3631             abi.encodeWithSignature(
3632                 "log(bool,uint,uint,string)",
3633                 p0,
3634                 p1,
3635                 p2,
3636                 p3
3637             )
3638         );
3639     }
3640 
3641     function log(
3642         bool p0,
3643         uint256 p1,
3644         uint256 p2,
3645         bool p3
3646     ) internal view {
3647         _sendLogPayload(
3648             abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3)
3649         );
3650     }
3651 
3652     function log(
3653         bool p0,
3654         uint256 p1,
3655         uint256 p2,
3656         address p3
3657     ) internal view {
3658         _sendLogPayload(
3659             abi.encodeWithSignature(
3660                 "log(bool,uint,uint,address)",
3661                 p0,
3662                 p1,
3663                 p2,
3664                 p3
3665             )
3666         );
3667     }
3668 
3669     function log(
3670         bool p0,
3671         uint256 p1,
3672         string memory p2,
3673         uint256 p3
3674     ) internal view {
3675         _sendLogPayload(
3676             abi.encodeWithSignature(
3677                 "log(bool,uint,string,uint)",
3678                 p0,
3679                 p1,
3680                 p2,
3681                 p3
3682             )
3683         );
3684     }
3685 
3686     function log(
3687         bool p0,
3688         uint256 p1,
3689         string memory p2,
3690         string memory p3
3691     ) internal view {
3692         _sendLogPayload(
3693             abi.encodeWithSignature(
3694                 "log(bool,uint,string,string)",
3695                 p0,
3696                 p1,
3697                 p2,
3698                 p3
3699             )
3700         );
3701     }
3702 
3703     function log(
3704         bool p0,
3705         uint256 p1,
3706         string memory p2,
3707         bool p3
3708     ) internal view {
3709         _sendLogPayload(
3710             abi.encodeWithSignature(
3711                 "log(bool,uint,string,bool)",
3712                 p0,
3713                 p1,
3714                 p2,
3715                 p3
3716             )
3717         );
3718     }
3719 
3720     function log(
3721         bool p0,
3722         uint256 p1,
3723         string memory p2,
3724         address p3
3725     ) internal view {
3726         _sendLogPayload(
3727             abi.encodeWithSignature(
3728                 "log(bool,uint,string,address)",
3729                 p0,
3730                 p1,
3731                 p2,
3732                 p3
3733             )
3734         );
3735     }
3736 
3737     function log(
3738         bool p0,
3739         uint256 p1,
3740         bool p2,
3741         uint256 p3
3742     ) internal view {
3743         _sendLogPayload(
3744             abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3)
3745         );
3746     }
3747 
3748     function log(
3749         bool p0,
3750         uint256 p1,
3751         bool p2,
3752         string memory p3
3753     ) internal view {
3754         _sendLogPayload(
3755             abi.encodeWithSignature(
3756                 "log(bool,uint,bool,string)",
3757                 p0,
3758                 p1,
3759                 p2,
3760                 p3
3761             )
3762         );
3763     }
3764 
3765     function log(
3766         bool p0,
3767         uint256 p1,
3768         bool p2,
3769         bool p3
3770     ) internal view {
3771         _sendLogPayload(
3772             abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3)
3773         );
3774     }
3775 
3776     function log(
3777         bool p0,
3778         uint256 p1,
3779         bool p2,
3780         address p3
3781     ) internal view {
3782         _sendLogPayload(
3783             abi.encodeWithSignature(
3784                 "log(bool,uint,bool,address)",
3785                 p0,
3786                 p1,
3787                 p2,
3788                 p3
3789             )
3790         );
3791     }
3792 
3793     function log(
3794         bool p0,
3795         uint256 p1,
3796         address p2,
3797         uint256 p3
3798     ) internal view {
3799         _sendLogPayload(
3800             abi.encodeWithSignature(
3801                 "log(bool,uint,address,uint)",
3802                 p0,
3803                 p1,
3804                 p2,
3805                 p3
3806             )
3807         );
3808     }
3809 
3810     function log(
3811         bool p0,
3812         uint256 p1,
3813         address p2,
3814         string memory p3
3815     ) internal view {
3816         _sendLogPayload(
3817             abi.encodeWithSignature(
3818                 "log(bool,uint,address,string)",
3819                 p0,
3820                 p1,
3821                 p2,
3822                 p3
3823             )
3824         );
3825     }
3826 
3827     function log(
3828         bool p0,
3829         uint256 p1,
3830         address p2,
3831         bool p3
3832     ) internal view {
3833         _sendLogPayload(
3834             abi.encodeWithSignature(
3835                 "log(bool,uint,address,bool)",
3836                 p0,
3837                 p1,
3838                 p2,
3839                 p3
3840             )
3841         );
3842     }
3843 
3844     function log(
3845         bool p0,
3846         uint256 p1,
3847         address p2,
3848         address p3
3849     ) internal view {
3850         _sendLogPayload(
3851             abi.encodeWithSignature(
3852                 "log(bool,uint,address,address)",
3853                 p0,
3854                 p1,
3855                 p2,
3856                 p3
3857             )
3858         );
3859     }
3860 
3861     function log(
3862         bool p0,
3863         string memory p1,
3864         uint256 p2,
3865         uint256 p3
3866     ) internal view {
3867         _sendLogPayload(
3868             abi.encodeWithSignature(
3869                 "log(bool,string,uint,uint)",
3870                 p0,
3871                 p1,
3872                 p2,
3873                 p3
3874             )
3875         );
3876     }
3877 
3878     function log(
3879         bool p0,
3880         string memory p1,
3881         uint256 p2,
3882         string memory p3
3883     ) internal view {
3884         _sendLogPayload(
3885             abi.encodeWithSignature(
3886                 "log(bool,string,uint,string)",
3887                 p0,
3888                 p1,
3889                 p2,
3890                 p3
3891             )
3892         );
3893     }
3894 
3895     function log(
3896         bool p0,
3897         string memory p1,
3898         uint256 p2,
3899         bool p3
3900     ) internal view {
3901         _sendLogPayload(
3902             abi.encodeWithSignature(
3903                 "log(bool,string,uint,bool)",
3904                 p0,
3905                 p1,
3906                 p2,
3907                 p3
3908             )
3909         );
3910     }
3911 
3912     function log(
3913         bool p0,
3914         string memory p1,
3915         uint256 p2,
3916         address p3
3917     ) internal view {
3918         _sendLogPayload(
3919             abi.encodeWithSignature(
3920                 "log(bool,string,uint,address)",
3921                 p0,
3922                 p1,
3923                 p2,
3924                 p3
3925             )
3926         );
3927     }
3928 
3929     function log(
3930         bool p0,
3931         string memory p1,
3932         string memory p2,
3933         uint256 p3
3934     ) internal view {
3935         _sendLogPayload(
3936             abi.encodeWithSignature(
3937                 "log(bool,string,string,uint)",
3938                 p0,
3939                 p1,
3940                 p2,
3941                 p3
3942             )
3943         );
3944     }
3945 
3946     function log(
3947         bool p0,
3948         string memory p1,
3949         string memory p2,
3950         string memory p3
3951     ) internal view {
3952         _sendLogPayload(
3953             abi.encodeWithSignature(
3954                 "log(bool,string,string,string)",
3955                 p0,
3956                 p1,
3957                 p2,
3958                 p3
3959             )
3960         );
3961     }
3962 
3963     function log(
3964         bool p0,
3965         string memory p1,
3966         string memory p2,
3967         bool p3
3968     ) internal view {
3969         _sendLogPayload(
3970             abi.encodeWithSignature(
3971                 "log(bool,string,string,bool)",
3972                 p0,
3973                 p1,
3974                 p2,
3975                 p3
3976             )
3977         );
3978     }
3979 
3980     function log(
3981         bool p0,
3982         string memory p1,
3983         string memory p2,
3984         address p3
3985     ) internal view {
3986         _sendLogPayload(
3987             abi.encodeWithSignature(
3988                 "log(bool,string,string,address)",
3989                 p0,
3990                 p1,
3991                 p2,
3992                 p3
3993             )
3994         );
3995     }
3996 
3997     function log(
3998         bool p0,
3999         string memory p1,
4000         bool p2,
4001         uint256 p3
4002     ) internal view {
4003         _sendLogPayload(
4004             abi.encodeWithSignature(
4005                 "log(bool,string,bool,uint)",
4006                 p0,
4007                 p1,
4008                 p2,
4009                 p3
4010             )
4011         );
4012     }
4013 
4014     function log(
4015         bool p0,
4016         string memory p1,
4017         bool p2,
4018         string memory p3
4019     ) internal view {
4020         _sendLogPayload(
4021             abi.encodeWithSignature(
4022                 "log(bool,string,bool,string)",
4023                 p0,
4024                 p1,
4025                 p2,
4026                 p3
4027             )
4028         );
4029     }
4030 
4031     function log(
4032         bool p0,
4033         string memory p1,
4034         bool p2,
4035         bool p3
4036     ) internal view {
4037         _sendLogPayload(
4038             abi.encodeWithSignature(
4039                 "log(bool,string,bool,bool)",
4040                 p0,
4041                 p1,
4042                 p2,
4043                 p3
4044             )
4045         );
4046     }
4047 
4048     function log(
4049         bool p0,
4050         string memory p1,
4051         bool p2,
4052         address p3
4053     ) internal view {
4054         _sendLogPayload(
4055             abi.encodeWithSignature(
4056                 "log(bool,string,bool,address)",
4057                 p0,
4058                 p1,
4059                 p2,
4060                 p3
4061             )
4062         );
4063     }
4064 
4065     function log(
4066         bool p0,
4067         string memory p1,
4068         address p2,
4069         uint256 p3
4070     ) internal view {
4071         _sendLogPayload(
4072             abi.encodeWithSignature(
4073                 "log(bool,string,address,uint)",
4074                 p0,
4075                 p1,
4076                 p2,
4077                 p3
4078             )
4079         );
4080     }
4081 
4082     function log(
4083         bool p0,
4084         string memory p1,
4085         address p2,
4086         string memory p3
4087     ) internal view {
4088         _sendLogPayload(
4089             abi.encodeWithSignature(
4090                 "log(bool,string,address,string)",
4091                 p0,
4092                 p1,
4093                 p2,
4094                 p3
4095             )
4096         );
4097     }
4098 
4099     function log(
4100         bool p0,
4101         string memory p1,
4102         address p2,
4103         bool p3
4104     ) internal view {
4105         _sendLogPayload(
4106             abi.encodeWithSignature(
4107                 "log(bool,string,address,bool)",
4108                 p0,
4109                 p1,
4110                 p2,
4111                 p3
4112             )
4113         );
4114     }
4115 
4116     function log(
4117         bool p0,
4118         string memory p1,
4119         address p2,
4120         address p3
4121     ) internal view {
4122         _sendLogPayload(
4123             abi.encodeWithSignature(
4124                 "log(bool,string,address,address)",
4125                 p0,
4126                 p1,
4127                 p2,
4128                 p3
4129             )
4130         );
4131     }
4132 
4133     function log(
4134         bool p0,
4135         bool p1,
4136         uint256 p2,
4137         uint256 p3
4138     ) internal view {
4139         _sendLogPayload(
4140             abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3)
4141         );
4142     }
4143 
4144     function log(
4145         bool p0,
4146         bool p1,
4147         uint256 p2,
4148         string memory p3
4149     ) internal view {
4150         _sendLogPayload(
4151             abi.encodeWithSignature(
4152                 "log(bool,bool,uint,string)",
4153                 p0,
4154                 p1,
4155                 p2,
4156                 p3
4157             )
4158         );
4159     }
4160 
4161     function log(
4162         bool p0,
4163         bool p1,
4164         uint256 p2,
4165         bool p3
4166     ) internal view {
4167         _sendLogPayload(
4168             abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3)
4169         );
4170     }
4171 
4172     function log(
4173         bool p0,
4174         bool p1,
4175         uint256 p2,
4176         address p3
4177     ) internal view {
4178         _sendLogPayload(
4179             abi.encodeWithSignature(
4180                 "log(bool,bool,uint,address)",
4181                 p0,
4182                 p1,
4183                 p2,
4184                 p3
4185             )
4186         );
4187     }
4188 
4189     function log(
4190         bool p0,
4191         bool p1,
4192         string memory p2,
4193         uint256 p3
4194     ) internal view {
4195         _sendLogPayload(
4196             abi.encodeWithSignature(
4197                 "log(bool,bool,string,uint)",
4198                 p0,
4199                 p1,
4200                 p2,
4201                 p3
4202             )
4203         );
4204     }
4205 
4206     function log(
4207         bool p0,
4208         bool p1,
4209         string memory p2,
4210         string memory p3
4211     ) internal view {
4212         _sendLogPayload(
4213             abi.encodeWithSignature(
4214                 "log(bool,bool,string,string)",
4215                 p0,
4216                 p1,
4217                 p2,
4218                 p3
4219             )
4220         );
4221     }
4222 
4223     function log(
4224         bool p0,
4225         bool p1,
4226         string memory p2,
4227         bool p3
4228     ) internal view {
4229         _sendLogPayload(
4230             abi.encodeWithSignature(
4231                 "log(bool,bool,string,bool)",
4232                 p0,
4233                 p1,
4234                 p2,
4235                 p3
4236             )
4237         );
4238     }
4239 
4240     function log(
4241         bool p0,
4242         bool p1,
4243         string memory p2,
4244         address p3
4245     ) internal view {
4246         _sendLogPayload(
4247             abi.encodeWithSignature(
4248                 "log(bool,bool,string,address)",
4249                 p0,
4250                 p1,
4251                 p2,
4252                 p3
4253             )
4254         );
4255     }
4256 
4257     function log(
4258         bool p0,
4259         bool p1,
4260         bool p2,
4261         uint256 p3
4262     ) internal view {
4263         _sendLogPayload(
4264             abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3)
4265         );
4266     }
4267 
4268     function log(
4269         bool p0,
4270         bool p1,
4271         bool p2,
4272         string memory p3
4273     ) internal view {
4274         _sendLogPayload(
4275             abi.encodeWithSignature(
4276                 "log(bool,bool,bool,string)",
4277                 p0,
4278                 p1,
4279                 p2,
4280                 p3
4281             )
4282         );
4283     }
4284 
4285     function log(
4286         bool p0,
4287         bool p1,
4288         bool p2,
4289         bool p3
4290     ) internal view {
4291         _sendLogPayload(
4292             abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3)
4293         );
4294     }
4295 
4296     function log(
4297         bool p0,
4298         bool p1,
4299         bool p2,
4300         address p3
4301     ) internal view {
4302         _sendLogPayload(
4303             abi.encodeWithSignature(
4304                 "log(bool,bool,bool,address)",
4305                 p0,
4306                 p1,
4307                 p2,
4308                 p3
4309             )
4310         );
4311     }
4312 
4313     function log(
4314         bool p0,
4315         bool p1,
4316         address p2,
4317         uint256 p3
4318     ) internal view {
4319         _sendLogPayload(
4320             abi.encodeWithSignature(
4321                 "log(bool,bool,address,uint)",
4322                 p0,
4323                 p1,
4324                 p2,
4325                 p3
4326             )
4327         );
4328     }
4329 
4330     function log(
4331         bool p0,
4332         bool p1,
4333         address p2,
4334         string memory p3
4335     ) internal view {
4336         _sendLogPayload(
4337             abi.encodeWithSignature(
4338                 "log(bool,bool,address,string)",
4339                 p0,
4340                 p1,
4341                 p2,
4342                 p3
4343             )
4344         );
4345     }
4346 
4347     function log(
4348         bool p0,
4349         bool p1,
4350         address p2,
4351         bool p3
4352     ) internal view {
4353         _sendLogPayload(
4354             abi.encodeWithSignature(
4355                 "log(bool,bool,address,bool)",
4356                 p0,
4357                 p1,
4358                 p2,
4359                 p3
4360             )
4361         );
4362     }
4363 
4364     function log(
4365         bool p0,
4366         bool p1,
4367         address p2,
4368         address p3
4369     ) internal view {
4370         _sendLogPayload(
4371             abi.encodeWithSignature(
4372                 "log(bool,bool,address,address)",
4373                 p0,
4374                 p1,
4375                 p2,
4376                 p3
4377             )
4378         );
4379     }
4380 
4381     function log(
4382         bool p0,
4383         address p1,
4384         uint256 p2,
4385         uint256 p3
4386     ) internal view {
4387         _sendLogPayload(
4388             abi.encodeWithSignature(
4389                 "log(bool,address,uint,uint)",
4390                 p0,
4391                 p1,
4392                 p2,
4393                 p3
4394             )
4395         );
4396     }
4397 
4398     function log(
4399         bool p0,
4400         address p1,
4401         uint256 p2,
4402         string memory p3
4403     ) internal view {
4404         _sendLogPayload(
4405             abi.encodeWithSignature(
4406                 "log(bool,address,uint,string)",
4407                 p0,
4408                 p1,
4409                 p2,
4410                 p3
4411             )
4412         );
4413     }
4414 
4415     function log(
4416         bool p0,
4417         address p1,
4418         uint256 p2,
4419         bool p3
4420     ) internal view {
4421         _sendLogPayload(
4422             abi.encodeWithSignature(
4423                 "log(bool,address,uint,bool)",
4424                 p0,
4425                 p1,
4426                 p2,
4427                 p3
4428             )
4429         );
4430     }
4431 
4432     function log(
4433         bool p0,
4434         address p1,
4435         uint256 p2,
4436         address p3
4437     ) internal view {
4438         _sendLogPayload(
4439             abi.encodeWithSignature(
4440                 "log(bool,address,uint,address)",
4441                 p0,
4442                 p1,
4443                 p2,
4444                 p3
4445             )
4446         );
4447     }
4448 
4449     function log(
4450         bool p0,
4451         address p1,
4452         string memory p2,
4453         uint256 p3
4454     ) internal view {
4455         _sendLogPayload(
4456             abi.encodeWithSignature(
4457                 "log(bool,address,string,uint)",
4458                 p0,
4459                 p1,
4460                 p2,
4461                 p3
4462             )
4463         );
4464     }
4465 
4466     function log(
4467         bool p0,
4468         address p1,
4469         string memory p2,
4470         string memory p3
4471     ) internal view {
4472         _sendLogPayload(
4473             abi.encodeWithSignature(
4474                 "log(bool,address,string,string)",
4475                 p0,
4476                 p1,
4477                 p2,
4478                 p3
4479             )
4480         );
4481     }
4482 
4483     function log(
4484         bool p0,
4485         address p1,
4486         string memory p2,
4487         bool p3
4488     ) internal view {
4489         _sendLogPayload(
4490             abi.encodeWithSignature(
4491                 "log(bool,address,string,bool)",
4492                 p0,
4493                 p1,
4494                 p2,
4495                 p3
4496             )
4497         );
4498     }
4499 
4500     function log(
4501         bool p0,
4502         address p1,
4503         string memory p2,
4504         address p3
4505     ) internal view {
4506         _sendLogPayload(
4507             abi.encodeWithSignature(
4508                 "log(bool,address,string,address)",
4509                 p0,
4510                 p1,
4511                 p2,
4512                 p3
4513             )
4514         );
4515     }
4516 
4517     function log(
4518         bool p0,
4519         address p1,
4520         bool p2,
4521         uint256 p3
4522     ) internal view {
4523         _sendLogPayload(
4524             abi.encodeWithSignature(
4525                 "log(bool,address,bool,uint)",
4526                 p0,
4527                 p1,
4528                 p2,
4529                 p3
4530             )
4531         );
4532     }
4533 
4534     function log(
4535         bool p0,
4536         address p1,
4537         bool p2,
4538         string memory p3
4539     ) internal view {
4540         _sendLogPayload(
4541             abi.encodeWithSignature(
4542                 "log(bool,address,bool,string)",
4543                 p0,
4544                 p1,
4545                 p2,
4546                 p3
4547             )
4548         );
4549     }
4550 
4551     function log(
4552         bool p0,
4553         address p1,
4554         bool p2,
4555         bool p3
4556     ) internal view {
4557         _sendLogPayload(
4558             abi.encodeWithSignature(
4559                 "log(bool,address,bool,bool)",
4560                 p0,
4561                 p1,
4562                 p2,
4563                 p3
4564             )
4565         );
4566     }
4567 
4568     function log(
4569         bool p0,
4570         address p1,
4571         bool p2,
4572         address p3
4573     ) internal view {
4574         _sendLogPayload(
4575             abi.encodeWithSignature(
4576                 "log(bool,address,bool,address)",
4577                 p0,
4578                 p1,
4579                 p2,
4580                 p3
4581             )
4582         );
4583     }
4584 
4585     function log(
4586         bool p0,
4587         address p1,
4588         address p2,
4589         uint256 p3
4590     ) internal view {
4591         _sendLogPayload(
4592             abi.encodeWithSignature(
4593                 "log(bool,address,address,uint)",
4594                 p0,
4595                 p1,
4596                 p2,
4597                 p3
4598             )
4599         );
4600     }
4601 
4602     function log(
4603         bool p0,
4604         address p1,
4605         address p2,
4606         string memory p3
4607     ) internal view {
4608         _sendLogPayload(
4609             abi.encodeWithSignature(
4610                 "log(bool,address,address,string)",
4611                 p0,
4612                 p1,
4613                 p2,
4614                 p3
4615             )
4616         );
4617     }
4618 
4619     function log(
4620         bool p0,
4621         address p1,
4622         address p2,
4623         bool p3
4624     ) internal view {
4625         _sendLogPayload(
4626             abi.encodeWithSignature(
4627                 "log(bool,address,address,bool)",
4628                 p0,
4629                 p1,
4630                 p2,
4631                 p3
4632             )
4633         );
4634     }
4635 
4636     function log(
4637         bool p0,
4638         address p1,
4639         address p2,
4640         address p3
4641     ) internal view {
4642         _sendLogPayload(
4643             abi.encodeWithSignature(
4644                 "log(bool,address,address,address)",
4645                 p0,
4646                 p1,
4647                 p2,
4648                 p3
4649             )
4650         );
4651     }
4652 
4653     function log(
4654         address p0,
4655         uint256 p1,
4656         uint256 p2,
4657         uint256 p3
4658     ) internal view {
4659         _sendLogPayload(
4660             abi.encodeWithSignature(
4661                 "log(address,uint,uint,uint)",
4662                 p0,
4663                 p1,
4664                 p2,
4665                 p3
4666             )
4667         );
4668     }
4669 
4670     function log(
4671         address p0,
4672         uint256 p1,
4673         uint256 p2,
4674         string memory p3
4675     ) internal view {
4676         _sendLogPayload(
4677             abi.encodeWithSignature(
4678                 "log(address,uint,uint,string)",
4679                 p0,
4680                 p1,
4681                 p2,
4682                 p3
4683             )
4684         );
4685     }
4686 
4687     function log(
4688         address p0,
4689         uint256 p1,
4690         uint256 p2,
4691         bool p3
4692     ) internal view {
4693         _sendLogPayload(
4694             abi.encodeWithSignature(
4695                 "log(address,uint,uint,bool)",
4696                 p0,
4697                 p1,
4698                 p2,
4699                 p3
4700             )
4701         );
4702     }
4703 
4704     function log(
4705         address p0,
4706         uint256 p1,
4707         uint256 p2,
4708         address p3
4709     ) internal view {
4710         _sendLogPayload(
4711             abi.encodeWithSignature(
4712                 "log(address,uint,uint,address)",
4713                 p0,
4714                 p1,
4715                 p2,
4716                 p3
4717             )
4718         );
4719     }
4720 
4721     function log(
4722         address p0,
4723         uint256 p1,
4724         string memory p2,
4725         uint256 p3
4726     ) internal view {
4727         _sendLogPayload(
4728             abi.encodeWithSignature(
4729                 "log(address,uint,string,uint)",
4730                 p0,
4731                 p1,
4732                 p2,
4733                 p3
4734             )
4735         );
4736     }
4737 
4738     function log(
4739         address p0,
4740         uint256 p1,
4741         string memory p2,
4742         string memory p3
4743     ) internal view {
4744         _sendLogPayload(
4745             abi.encodeWithSignature(
4746                 "log(address,uint,string,string)",
4747                 p0,
4748                 p1,
4749                 p2,
4750                 p3
4751             )
4752         );
4753     }
4754 
4755     function log(
4756         address p0,
4757         uint256 p1,
4758         string memory p2,
4759         bool p3
4760     ) internal view {
4761         _sendLogPayload(
4762             abi.encodeWithSignature(
4763                 "log(address,uint,string,bool)",
4764                 p0,
4765                 p1,
4766                 p2,
4767                 p3
4768             )
4769         );
4770     }
4771 
4772     function log(
4773         address p0,
4774         uint256 p1,
4775         string memory p2,
4776         address p3
4777     ) internal view {
4778         _sendLogPayload(
4779             abi.encodeWithSignature(
4780                 "log(address,uint,string,address)",
4781                 p0,
4782                 p1,
4783                 p2,
4784                 p3
4785             )
4786         );
4787     }
4788 
4789     function log(
4790         address p0,
4791         uint256 p1,
4792         bool p2,
4793         uint256 p3
4794     ) internal view {
4795         _sendLogPayload(
4796             abi.encodeWithSignature(
4797                 "log(address,uint,bool,uint)",
4798                 p0,
4799                 p1,
4800                 p2,
4801                 p3
4802             )
4803         );
4804     }
4805 
4806     function log(
4807         address p0,
4808         uint256 p1,
4809         bool p2,
4810         string memory p3
4811     ) internal view {
4812         _sendLogPayload(
4813             abi.encodeWithSignature(
4814                 "log(address,uint,bool,string)",
4815                 p0,
4816                 p1,
4817                 p2,
4818                 p3
4819             )
4820         );
4821     }
4822 
4823     function log(
4824         address p0,
4825         uint256 p1,
4826         bool p2,
4827         bool p3
4828     ) internal view {
4829         _sendLogPayload(
4830             abi.encodeWithSignature(
4831                 "log(address,uint,bool,bool)",
4832                 p0,
4833                 p1,
4834                 p2,
4835                 p3
4836             )
4837         );
4838     }
4839 
4840     function log(
4841         address p0,
4842         uint256 p1,
4843         bool p2,
4844         address p3
4845     ) internal view {
4846         _sendLogPayload(
4847             abi.encodeWithSignature(
4848                 "log(address,uint,bool,address)",
4849                 p0,
4850                 p1,
4851                 p2,
4852                 p3
4853             )
4854         );
4855     }
4856 
4857     function log(
4858         address p0,
4859         uint256 p1,
4860         address p2,
4861         uint256 p3
4862     ) internal view {
4863         _sendLogPayload(
4864             abi.encodeWithSignature(
4865                 "log(address,uint,address,uint)",
4866                 p0,
4867                 p1,
4868                 p2,
4869                 p3
4870             )
4871         );
4872     }
4873 
4874     function log(
4875         address p0,
4876         uint256 p1,
4877         address p2,
4878         string memory p3
4879     ) internal view {
4880         _sendLogPayload(
4881             abi.encodeWithSignature(
4882                 "log(address,uint,address,string)",
4883                 p0,
4884                 p1,
4885                 p2,
4886                 p3
4887             )
4888         );
4889     }
4890 
4891     function log(
4892         address p0,
4893         uint256 p1,
4894         address p2,
4895         bool p3
4896     ) internal view {
4897         _sendLogPayload(
4898             abi.encodeWithSignature(
4899                 "log(address,uint,address,bool)",
4900                 p0,
4901                 p1,
4902                 p2,
4903                 p3
4904             )
4905         );
4906     }
4907 
4908     function log(
4909         address p0,
4910         uint256 p1,
4911         address p2,
4912         address p3
4913     ) internal view {
4914         _sendLogPayload(
4915             abi.encodeWithSignature(
4916                 "log(address,uint,address,address)",
4917                 p0,
4918                 p1,
4919                 p2,
4920                 p3
4921             )
4922         );
4923     }
4924 
4925     function log(
4926         address p0,
4927         string memory p1,
4928         uint256 p2,
4929         uint256 p3
4930     ) internal view {
4931         _sendLogPayload(
4932             abi.encodeWithSignature(
4933                 "log(address,string,uint,uint)",
4934                 p0,
4935                 p1,
4936                 p2,
4937                 p3
4938             )
4939         );
4940     }
4941 
4942     function log(
4943         address p0,
4944         string memory p1,
4945         uint256 p2,
4946         string memory p3
4947     ) internal view {
4948         _sendLogPayload(
4949             abi.encodeWithSignature(
4950                 "log(address,string,uint,string)",
4951                 p0,
4952                 p1,
4953                 p2,
4954                 p3
4955             )
4956         );
4957     }
4958 
4959     function log(
4960         address p0,
4961         string memory p1,
4962         uint256 p2,
4963         bool p3
4964     ) internal view {
4965         _sendLogPayload(
4966             abi.encodeWithSignature(
4967                 "log(address,string,uint,bool)",
4968                 p0,
4969                 p1,
4970                 p2,
4971                 p3
4972             )
4973         );
4974     }
4975 
4976     function log(
4977         address p0,
4978         string memory p1,
4979         uint256 p2,
4980         address p3
4981     ) internal view {
4982         _sendLogPayload(
4983             abi.encodeWithSignature(
4984                 "log(address,string,uint,address)",
4985                 p0,
4986                 p1,
4987                 p2,
4988                 p3
4989             )
4990         );
4991     }
4992 
4993     function log(
4994         address p0,
4995         string memory p1,
4996         string memory p2,
4997         uint256 p3
4998     ) internal view {
4999         _sendLogPayload(
5000             abi.encodeWithSignature(
5001                 "log(address,string,string,uint)",
5002                 p0,
5003                 p1,
5004                 p2,
5005                 p3
5006             )
5007         );
5008     }
5009 
5010     function log(
5011         address p0,
5012         string memory p1,
5013         string memory p2,
5014         string memory p3
5015     ) internal view {
5016         _sendLogPayload(
5017             abi.encodeWithSignature(
5018                 "log(address,string,string,string)",
5019                 p0,
5020                 p1,
5021                 p2,
5022                 p3
5023             )
5024         );
5025     }
5026 
5027     function log(
5028         address p0,
5029         string memory p1,
5030         string memory p2,
5031         bool p3
5032     ) internal view {
5033         _sendLogPayload(
5034             abi.encodeWithSignature(
5035                 "log(address,string,string,bool)",
5036                 p0,
5037                 p1,
5038                 p2,
5039                 p3
5040             )
5041         );
5042     }
5043 
5044     function log(
5045         address p0,
5046         string memory p1,
5047         string memory p2,
5048         address p3
5049     ) internal view {
5050         _sendLogPayload(
5051             abi.encodeWithSignature(
5052                 "log(address,string,string,address)",
5053                 p0,
5054                 p1,
5055                 p2,
5056                 p3
5057             )
5058         );
5059     }
5060 
5061     function log(
5062         address p0,
5063         string memory p1,
5064         bool p2,
5065         uint256 p3
5066     ) internal view {
5067         _sendLogPayload(
5068             abi.encodeWithSignature(
5069                 "log(address,string,bool,uint)",
5070                 p0,
5071                 p1,
5072                 p2,
5073                 p3
5074             )
5075         );
5076     }
5077 
5078     function log(
5079         address p0,
5080         string memory p1,
5081         bool p2,
5082         string memory p3
5083     ) internal view {
5084         _sendLogPayload(
5085             abi.encodeWithSignature(
5086                 "log(address,string,bool,string)",
5087                 p0,
5088                 p1,
5089                 p2,
5090                 p3
5091             )
5092         );
5093     }
5094 
5095     function log(
5096         address p0,
5097         string memory p1,
5098         bool p2,
5099         bool p3
5100     ) internal view {
5101         _sendLogPayload(
5102             abi.encodeWithSignature(
5103                 "log(address,string,bool,bool)",
5104                 p0,
5105                 p1,
5106                 p2,
5107                 p3
5108             )
5109         );
5110     }
5111 
5112     function log(
5113         address p0,
5114         string memory p1,
5115         bool p2,
5116         address p3
5117     ) internal view {
5118         _sendLogPayload(
5119             abi.encodeWithSignature(
5120                 "log(address,string,bool,address)",
5121                 p0,
5122                 p1,
5123                 p2,
5124                 p3
5125             )
5126         );
5127     }
5128 
5129     function log(
5130         address p0,
5131         string memory p1,
5132         address p2,
5133         uint256 p3
5134     ) internal view {
5135         _sendLogPayload(
5136             abi.encodeWithSignature(
5137                 "log(address,string,address,uint)",
5138                 p0,
5139                 p1,
5140                 p2,
5141                 p3
5142             )
5143         );
5144     }
5145 
5146     function log(
5147         address p0,
5148         string memory p1,
5149         address p2,
5150         string memory p3
5151     ) internal view {
5152         _sendLogPayload(
5153             abi.encodeWithSignature(
5154                 "log(address,string,address,string)",
5155                 p0,
5156                 p1,
5157                 p2,
5158                 p3
5159             )
5160         );
5161     }
5162 
5163     function log(
5164         address p0,
5165         string memory p1,
5166         address p2,
5167         bool p3
5168     ) internal view {
5169         _sendLogPayload(
5170             abi.encodeWithSignature(
5171                 "log(address,string,address,bool)",
5172                 p0,
5173                 p1,
5174                 p2,
5175                 p3
5176             )
5177         );
5178     }
5179 
5180     function log(
5181         address p0,
5182         string memory p1,
5183         address p2,
5184         address p3
5185     ) internal view {
5186         _sendLogPayload(
5187             abi.encodeWithSignature(
5188                 "log(address,string,address,address)",
5189                 p0,
5190                 p1,
5191                 p2,
5192                 p3
5193             )
5194         );
5195     }
5196 
5197     function log(
5198         address p0,
5199         bool p1,
5200         uint256 p2,
5201         uint256 p3
5202     ) internal view {
5203         _sendLogPayload(
5204             abi.encodeWithSignature(
5205                 "log(address,bool,uint,uint)",
5206                 p0,
5207                 p1,
5208                 p2,
5209                 p3
5210             )
5211         );
5212     }
5213 
5214     function log(
5215         address p0,
5216         bool p1,
5217         uint256 p2,
5218         string memory p3
5219     ) internal view {
5220         _sendLogPayload(
5221             abi.encodeWithSignature(
5222                 "log(address,bool,uint,string)",
5223                 p0,
5224                 p1,
5225                 p2,
5226                 p3
5227             )
5228         );
5229     }
5230 
5231     function log(
5232         address p0,
5233         bool p1,
5234         uint256 p2,
5235         bool p3
5236     ) internal view {
5237         _sendLogPayload(
5238             abi.encodeWithSignature(
5239                 "log(address,bool,uint,bool)",
5240                 p0,
5241                 p1,
5242                 p2,
5243                 p3
5244             )
5245         );
5246     }
5247 
5248     function log(
5249         address p0,
5250         bool p1,
5251         uint256 p2,
5252         address p3
5253     ) internal view {
5254         _sendLogPayload(
5255             abi.encodeWithSignature(
5256                 "log(address,bool,uint,address)",
5257                 p0,
5258                 p1,
5259                 p2,
5260                 p3
5261             )
5262         );
5263     }
5264 
5265     function log(
5266         address p0,
5267         bool p1,
5268         string memory p2,
5269         uint256 p3
5270     ) internal view {
5271         _sendLogPayload(
5272             abi.encodeWithSignature(
5273                 "log(address,bool,string,uint)",
5274                 p0,
5275                 p1,
5276                 p2,
5277                 p3
5278             )
5279         );
5280     }
5281 
5282     function log(
5283         address p0,
5284         bool p1,
5285         string memory p2,
5286         string memory p3
5287     ) internal view {
5288         _sendLogPayload(
5289             abi.encodeWithSignature(
5290                 "log(address,bool,string,string)",
5291                 p0,
5292                 p1,
5293                 p2,
5294                 p3
5295             )
5296         );
5297     }
5298 
5299     function log(
5300         address p0,
5301         bool p1,
5302         string memory p2,
5303         bool p3
5304     ) internal view {
5305         _sendLogPayload(
5306             abi.encodeWithSignature(
5307                 "log(address,bool,string,bool)",
5308                 p0,
5309                 p1,
5310                 p2,
5311                 p3
5312             )
5313         );
5314     }
5315 
5316     function log(
5317         address p0,
5318         bool p1,
5319         string memory p2,
5320         address p3
5321     ) internal view {
5322         _sendLogPayload(
5323             abi.encodeWithSignature(
5324                 "log(address,bool,string,address)",
5325                 p0,
5326                 p1,
5327                 p2,
5328                 p3
5329             )
5330         );
5331     }
5332 
5333     function log(
5334         address p0,
5335         bool p1,
5336         bool p2,
5337         uint256 p3
5338     ) internal view {
5339         _sendLogPayload(
5340             abi.encodeWithSignature(
5341                 "log(address,bool,bool,uint)",
5342                 p0,
5343                 p1,
5344                 p2,
5345                 p3
5346             )
5347         );
5348     }
5349 
5350     function log(
5351         address p0,
5352         bool p1,
5353         bool p2,
5354         string memory p3
5355     ) internal view {
5356         _sendLogPayload(
5357             abi.encodeWithSignature(
5358                 "log(address,bool,bool,string)",
5359                 p0,
5360                 p1,
5361                 p2,
5362                 p3
5363             )
5364         );
5365     }
5366 
5367     function log(
5368         address p0,
5369         bool p1,
5370         bool p2,
5371         bool p3
5372     ) internal view {
5373         _sendLogPayload(
5374             abi.encodeWithSignature(
5375                 "log(address,bool,bool,bool)",
5376                 p0,
5377                 p1,
5378                 p2,
5379                 p3
5380             )
5381         );
5382     }
5383 
5384     function log(
5385         address p0,
5386         bool p1,
5387         bool p2,
5388         address p3
5389     ) internal view {
5390         _sendLogPayload(
5391             abi.encodeWithSignature(
5392                 "log(address,bool,bool,address)",
5393                 p0,
5394                 p1,
5395                 p2,
5396                 p3
5397             )
5398         );
5399     }
5400 
5401     function log(
5402         address p0,
5403         bool p1,
5404         address p2,
5405         uint256 p3
5406     ) internal view {
5407         _sendLogPayload(
5408             abi.encodeWithSignature(
5409                 "log(address,bool,address,uint)",
5410                 p0,
5411                 p1,
5412                 p2,
5413                 p3
5414             )
5415         );
5416     }
5417 
5418     function log(
5419         address p0,
5420         bool p1,
5421         address p2,
5422         string memory p3
5423     ) internal view {
5424         _sendLogPayload(
5425             abi.encodeWithSignature(
5426                 "log(address,bool,address,string)",
5427                 p0,
5428                 p1,
5429                 p2,
5430                 p3
5431             )
5432         );
5433     }
5434 
5435     function log(
5436         address p0,
5437         bool p1,
5438         address p2,
5439         bool p3
5440     ) internal view {
5441         _sendLogPayload(
5442             abi.encodeWithSignature(
5443                 "log(address,bool,address,bool)",
5444                 p0,
5445                 p1,
5446                 p2,
5447                 p3
5448             )
5449         );
5450     }
5451 
5452     function log(
5453         address p0,
5454         bool p1,
5455         address p2,
5456         address p3
5457     ) internal view {
5458         _sendLogPayload(
5459             abi.encodeWithSignature(
5460                 "log(address,bool,address,address)",
5461                 p0,
5462                 p1,
5463                 p2,
5464                 p3
5465             )
5466         );
5467     }
5468 
5469     function log(
5470         address p0,
5471         address p1,
5472         uint256 p2,
5473         uint256 p3
5474     ) internal view {
5475         _sendLogPayload(
5476             abi.encodeWithSignature(
5477                 "log(address,address,uint,uint)",
5478                 p0,
5479                 p1,
5480                 p2,
5481                 p3
5482             )
5483         );
5484     }
5485 
5486     function log(
5487         address p0,
5488         address p1,
5489         uint256 p2,
5490         string memory p3
5491     ) internal view {
5492         _sendLogPayload(
5493             abi.encodeWithSignature(
5494                 "log(address,address,uint,string)",
5495                 p0,
5496                 p1,
5497                 p2,
5498                 p3
5499             )
5500         );
5501     }
5502 
5503     function log(
5504         address p0,
5505         address p1,
5506         uint256 p2,
5507         bool p3
5508     ) internal view {
5509         _sendLogPayload(
5510             abi.encodeWithSignature(
5511                 "log(address,address,uint,bool)",
5512                 p0,
5513                 p1,
5514                 p2,
5515                 p3
5516             )
5517         );
5518     }
5519 
5520     function log(
5521         address p0,
5522         address p1,
5523         uint256 p2,
5524         address p3
5525     ) internal view {
5526         _sendLogPayload(
5527             abi.encodeWithSignature(
5528                 "log(address,address,uint,address)",
5529                 p0,
5530                 p1,
5531                 p2,
5532                 p3
5533             )
5534         );
5535     }
5536 
5537     function log(
5538         address p0,
5539         address p1,
5540         string memory p2,
5541         uint256 p3
5542     ) internal view {
5543         _sendLogPayload(
5544             abi.encodeWithSignature(
5545                 "log(address,address,string,uint)",
5546                 p0,
5547                 p1,
5548                 p2,
5549                 p3
5550             )
5551         );
5552     }
5553 
5554     function log(
5555         address p0,
5556         address p1,
5557         string memory p2,
5558         string memory p3
5559     ) internal view {
5560         _sendLogPayload(
5561             abi.encodeWithSignature(
5562                 "log(address,address,string,string)",
5563                 p0,
5564                 p1,
5565                 p2,
5566                 p3
5567             )
5568         );
5569     }
5570 
5571     function log(
5572         address p0,
5573         address p1,
5574         string memory p2,
5575         bool p3
5576     ) internal view {
5577         _sendLogPayload(
5578             abi.encodeWithSignature(
5579                 "log(address,address,string,bool)",
5580                 p0,
5581                 p1,
5582                 p2,
5583                 p3
5584             )
5585         );
5586     }
5587 
5588     function log(
5589         address p0,
5590         address p1,
5591         string memory p2,
5592         address p3
5593     ) internal view {
5594         _sendLogPayload(
5595             abi.encodeWithSignature(
5596                 "log(address,address,string,address)",
5597                 p0,
5598                 p1,
5599                 p2,
5600                 p3
5601             )
5602         );
5603     }
5604 
5605     function log(
5606         address p0,
5607         address p1,
5608         bool p2,
5609         uint256 p3
5610     ) internal view {
5611         _sendLogPayload(
5612             abi.encodeWithSignature(
5613                 "log(address,address,bool,uint)",
5614                 p0,
5615                 p1,
5616                 p2,
5617                 p3
5618             )
5619         );
5620     }
5621 
5622     function log(
5623         address p0,
5624         address p1,
5625         bool p2,
5626         string memory p3
5627     ) internal view {
5628         _sendLogPayload(
5629             abi.encodeWithSignature(
5630                 "log(address,address,bool,string)",
5631                 p0,
5632                 p1,
5633                 p2,
5634                 p3
5635             )
5636         );
5637     }
5638 
5639     function log(
5640         address p0,
5641         address p1,
5642         bool p2,
5643         bool p3
5644     ) internal view {
5645         _sendLogPayload(
5646             abi.encodeWithSignature(
5647                 "log(address,address,bool,bool)",
5648                 p0,
5649                 p1,
5650                 p2,
5651                 p3
5652             )
5653         );
5654     }
5655 
5656     function log(
5657         address p0,
5658         address p1,
5659         bool p2,
5660         address p3
5661     ) internal view {
5662         _sendLogPayload(
5663             abi.encodeWithSignature(
5664                 "log(address,address,bool,address)",
5665                 p0,
5666                 p1,
5667                 p2,
5668                 p3
5669             )
5670         );
5671     }
5672 
5673     function log(
5674         address p0,
5675         address p1,
5676         address p2,
5677         uint256 p3
5678     ) internal view {
5679         _sendLogPayload(
5680             abi.encodeWithSignature(
5681                 "log(address,address,address,uint)",
5682                 p0,
5683                 p1,
5684                 p2,
5685                 p3
5686             )
5687         );
5688     }
5689 
5690     function log(
5691         address p0,
5692         address p1,
5693         address p2,
5694         string memory p3
5695     ) internal view {
5696         _sendLogPayload(
5697             abi.encodeWithSignature(
5698                 "log(address,address,address,string)",
5699                 p0,
5700                 p1,
5701                 p2,
5702                 p3
5703             )
5704         );
5705     }
5706 
5707     function log(
5708         address p0,
5709         address p1,
5710         address p2,
5711         bool p3
5712     ) internal view {
5713         _sendLogPayload(
5714             abi.encodeWithSignature(
5715                 "log(address,address,address,bool)",
5716                 p0,
5717                 p1,
5718                 p2,
5719                 p3
5720             )
5721         );
5722     }
5723 
5724     function log(
5725         address p0,
5726         address p1,
5727         address p2,
5728         address p3
5729     ) internal view {
5730         _sendLogPayload(
5731             abi.encodeWithSignature(
5732                 "log(address,address,address,address)",
5733                 p0,
5734                 p1,
5735                 p2,
5736                 p3
5737             )
5738         );
5739     }
5740 }
5741 
5742 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
5743 
5744 pragma solidity >=0.6.0 <0.8.0;
5745 
5746 /**
5747  * @dev Interface of the ERC20 standard as defined in the EIP.
5748  */
5749 interface IERC20 {
5750     /**
5751      * @dev Returns the amount of tokens in existence.
5752      */
5753     function totalSupply() external view returns (uint256);
5754 
5755     /**
5756      * @dev Returns the amount of tokens owned by `account`.
5757      */
5758     function balanceOf(address account) external view returns (uint256);
5759 
5760     /**
5761      * @dev Moves `amount` tokens from the caller's account to `recipient`.
5762      *
5763      * Returns a boolean value indicating whether the operation succeeded.
5764      *
5765      * Emits a {Transfer} event.
5766      */
5767     function transfer(address recipient, uint256 amount)
5768         external
5769         returns (bool);
5770 
5771     /**
5772      * @dev Returns the remaining number of tokens that `spender` will be
5773      * allowed to spend on behalf of `owner` through {transferFrom}. This is
5774      * zero by default.
5775      *
5776      * This value changes when {approve} or {transferFrom} are called.
5777      */
5778     function allowance(address owner, address spender)
5779         external
5780         view
5781         returns (uint256);
5782 
5783     /**
5784      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
5785      *
5786      * Returns a boolean value indicating whether the operation succeeded.
5787      *
5788      * IMPORTANT: Beware that changing an allowance with this method brings the risk
5789      * that someone may use both the old and the new allowance by unfortunate
5790      * transaction ordering. One possible solution to mitigate this race
5791      * condition is to first reduce the spender's allowance to 0 and set the
5792      * desired value afterwards:
5793      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
5794      *
5795      * Emits an {Approval} event.
5796      */
5797     function approve(address spender, uint256 amount) external returns (bool);
5798 
5799     /**
5800      * @dev Moves `amount` tokens from `sender` to `recipient` using the
5801      * allowance mechanism. `amount` is then deducted from the caller's
5802      * allowance.
5803      *
5804      * Returns a boolean value indicating whether the operation succeeded.
5805      *
5806      * Emits a {Transfer} event.
5807      */
5808     function transferFrom(
5809         address sender,
5810         address recipient,
5811         uint256 amount
5812     ) external returns (bool);
5813 
5814     /**
5815      * @dev Emitted when `value` tokens are moved from one account (`from`) to
5816      * another (`to`).
5817      *
5818      * Note that `value` may be zero.
5819      */
5820     event Transfer(address indexed from, address indexed to, uint256 value);
5821 
5822     /**
5823      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
5824      * a call to {approve}. `value` is the new allowance.
5825      */
5826     event Approval(
5827         address indexed owner,
5828         address indexed spender,
5829         uint256 value
5830     );
5831 }
5832 
5833 // File: @openzeppelin/contracts/access/Ownable.sol
5834 
5835 pragma solidity >=0.6.0 <0.8.0;
5836 
5837 /**
5838  * @dev Contract module which provides a basic access control mechanism, where
5839  * there is an account (an owner) that can be granted exclusive access to
5840  * specific functions.
5841  *
5842  * By default, the owner account will be the one that deploys the contract. This
5843  * can later be changed with {transferOwnership}.
5844  *
5845  * This module is used through inheritance. It will make available the modifier
5846  * `onlyOwner`, which can be applied to your functions to restrict their use to
5847  * the owner.
5848  */
5849 abstract contract Ownable is Context {
5850     address private _owner;
5851 
5852     event OwnershipTransferred(
5853         address indexed previousOwner,
5854         address indexed newOwner
5855     );
5856 
5857     /**
5858      * @dev Initializes the contract setting the deployer as the initial owner.
5859      */
5860     constructor() internal {
5861         address msgSender = _msgSender();
5862         _owner = msgSender;
5863         emit OwnershipTransferred(address(0), msgSender);
5864     }
5865 
5866     /**
5867      * @dev Returns the address of the current owner.
5868      */
5869     function owner() public view returns (address) {
5870         return _owner;
5871     }
5872 
5873     /**
5874      * @dev Throws if called by any account other than the owner.
5875      */
5876     modifier onlyOwner() {
5877         require(_owner == _msgSender(), "Ownable: caller is not the owner");
5878         _;
5879     }
5880 
5881     /**
5882      * @dev Leaves the contract without owner. It will not be possible to call
5883      * `onlyOwner` functions anymore. Can only be called by the current owner.
5884      *
5885      * NOTE: Renouncing ownership will leave the contract without an owner,
5886      * thereby removing any functionality that is only available to the owner.
5887      */
5888     function renounceOwnership() public virtual onlyOwner {
5889         emit OwnershipTransferred(_owner, address(0));
5890         _owner = address(0);
5891     }
5892 
5893     /**
5894      * @dev Transfers ownership of the contract to a new account (`newOwner`).
5895      * Can only be called by the current owner.
5896      */
5897     function transferOwnership(address newOwner) public virtual onlyOwner {
5898         require(
5899             newOwner != address(0),
5900             "Ownable: new owner is the zero address"
5901         );
5902         emit OwnershipTransferred(_owner, newOwner);
5903         _owner = newOwner;
5904     }
5905 }
5906 
5907 // File: contracts/PIS.sol
5908 
5909 pragma solidity 0.6.12;
5910 
5911 contract PIS is Context, IPISBaseTokenEx, Ownable {
5912     using SafeMath for uint256;
5913     using Address for address;
5914 
5915     struct LockedToken {
5916         bool isUnlocked;
5917         uint256 unlockedTime;
5918         uint256 amount;
5919     }
5920 
5921     mapping(address => uint256) private _balances;
5922 
5923     mapping(address => mapping(address => uint256)) private _allowances;
5924 
5925     uint256 private _totalSupply;
5926 
5927     string private _name;
5928     string private _symbol;
5929     uint8 private _decimals;
5930     uint256 public constant MAX_SUPPLY = 100000e18;
5931 
5932     uint256 public PRIVATE_SALE_PERCENT = 10; //10%
5933     uint256 public PUBLIC_SALE_PERCENT = 30;
5934     uint256 public LIQUIDITY_PERCENT = 30;
5935     uint256 public TEAM_RESERVED_PERCENT = 10;
5936     uint256 public SHIELD_MINING_PERCENT = 20;
5937 
5938     address public privateSaleAddress;
5939     address public publicSaleAddress;
5940     address public liquidityAddress;
5941 
5942     address public shieldMiningAddress;
5943 
5944     uint256 public contractStartTimestamp;
5945 
5946     address public override devFundAddress;
5947     uint256 public devFundTotal;
5948 
5949     LockedToken public privateSaleLockedTokens;
5950     LockedToken public publicSaleLockedTokens;
5951     LockedToken public liquidityLockedTokens;
5952 
5953     LockedToken[] public devFunds;
5954 
5955     function name() public view returns (string memory) {
5956         return _name;
5957     }
5958 
5959     constructor(
5960         address _privateSaleAddress,
5961         address _publicSaleAddress,
5962         address _liquidityAddress,
5963         address _devFundAddress
5964     ) public {
5965         initialSetup(
5966             _privateSaleAddress,
5967             _publicSaleAddress,
5968             _liquidityAddress,
5969             _devFundAddress
5970         );
5971     }
5972 
5973     function initialSetup(
5974         address _privateSaleAddress,
5975         address _publicSaleAddress,
5976         address _liquidityAddress,
5977         address _devFundAddress
5978     ) internal {
5979         _name = "POLKAINSURE.FINANCE";
5980         _symbol = "PIS";
5981         _decimals = 18;
5982         uint256 initialMint = MAX_SUPPLY.mul(100 - SHIELD_MINING_PERCENT).div(
5983             100
5984         );
5985 
5986         devFundAddress = _devFundAddress;
5987         privateSaleAddress = _privateSaleAddress;
5988         publicSaleAddress = _publicSaleAddress;
5989         liquidityAddress = _liquidityAddress;
5990 
5991         {
5992             uint256 privateSaleAmount = MAX_SUPPLY
5993                 .mul(PRIVATE_SALE_PERCENT)
5994                 .div(100);
5995             privateSaleLockedTokens = LockedToken({
5996                 unlockedTime: block.timestamp.add(4 weeks),
5997                 amount: privateSaleAmount,
5998                 isUnlocked: false
5999             });
6000         }
6001 
6002         {
6003             uint256 publicSaleAmount = MAX_SUPPLY.mul(PUBLIC_SALE_PERCENT).div(
6004                 100
6005             );
6006             publicSaleLockedTokens = LockedToken({
6007                 unlockedTime: block.timestamp,
6008                 amount: publicSaleAmount,
6009                 isUnlocked: false
6010             });
6011         }
6012 
6013         {
6014             uint256 liquiditySaleAmount = MAX_SUPPLY.mul(LIQUIDITY_PERCENT).div(
6015                 100
6016             );
6017             liquidityLockedTokens = LockedToken({
6018                 unlockedTime: block.timestamp,
6019                 amount: liquiditySaleAmount,
6020                 isUnlocked: false
6021             });
6022         }
6023 
6024         _mint(address(this), initialMint);
6025         contractStartTimestamp = block.timestamp;
6026         devFundTotal = MAX_SUPPLY.mul(TEAM_RESERVED_PERCENT).div(100);
6027         {
6028             //dev fund in 3 months, release every 2 weeks
6029             uint256 devFundPerRelease = devFundTotal.div(6);
6030             for (uint256 i = 0; i < 5; i++) {
6031                 devFunds.push(
6032                     LockedToken({
6033                         unlockedTime: block.timestamp + i.mul(2 weeks),
6034                         amount: devFundPerRelease,
6035                         isUnlocked: false
6036                     })
6037                 );
6038             }
6039             devFunds.push(
6040                 LockedToken({
6041                     unlockedTime: block.timestamp + uint256(5).mul(2 weeks),
6042                     amount: devFundTotal.sub(devFundPerRelease.mul(5)),
6043                     isUnlocked: false
6044                 })
6045             );
6046         }
6047     }
6048 
6049     function pendingReleasableDevFund() public view returns (uint256) {
6050         if (contractStartTimestamp == 0) return 0;
6051         uint256 ret = 0;
6052         for (uint256 i = 0; i < devFunds.length; i++) {
6053             if (devFunds[i].unlockedTime > block.timestamp) break;
6054             if (!devFunds[i].isUnlocked) {
6055                 ret = ret.add(devFunds[i].amount);
6056             }
6057         }
6058         return ret;
6059     }
6060 
6061     function unlockDevFund() public {
6062         for (uint256 i = 0; i < devFunds.length; i++) {
6063             if (devFunds[i].unlockedTime >= block.timestamp) break;
6064             if (!devFunds[i].isUnlocked) {
6065                 devFunds[i].isUnlocked = true;
6066                 _transfer(address(this), devFundAddress, devFunds[i].amount);
6067             }
6068         }
6069     }
6070 
6071     function unlockPrivateSaleFund() public {
6072         require(
6073             privateSaleLockedTokens.unlockedTime <= block.timestamp &&
6074                 privateSaleLockedTokens.amount > 0,
6075             "!unlock timing"
6076         );
6077 
6078         require(!privateSaleLockedTokens.isUnlocked, "already unlock");
6079         privateSaleLockedTokens.isUnlocked = true;
6080         _transfer(
6081             address(this),
6082             privateSaleAddress,
6083             privateSaleLockedTokens.amount
6084         );
6085     }
6086 
6087     function unlockPublicSaleFund() public {
6088         require(
6089             publicSaleLockedTokens.unlockedTime <= block.timestamp &&
6090                 publicSaleLockedTokens.amount > 0,
6091             "!unlock timing"
6092         );
6093 
6094         require(!publicSaleLockedTokens.isUnlocked, "already unlock");
6095         publicSaleLockedTokens.isUnlocked = true;
6096         _transfer(
6097             address(this),
6098             publicSaleAddress,
6099             publicSaleLockedTokens.amount
6100         );
6101     }
6102 
6103     function unlockLiquidityFund() public {
6104         require(
6105             liquidityLockedTokens.unlockedTime <= block.timestamp &&
6106                 liquidityLockedTokens.amount > 0,
6107             "!unlock timing"
6108         );
6109 
6110         require(!liquidityLockedTokens.isUnlocked, "already unlock");
6111         liquidityLockedTokens.isUnlocked = true;
6112         _transfer(
6113             address(this),
6114             liquidityAddress,
6115             liquidityLockedTokens.amount
6116         );
6117     }
6118 
6119     function symbol() public view returns (string memory) {
6120         return _symbol;
6121     }
6122 
6123     function decimals() public view returns (uint8) {
6124         return _decimals;
6125     }
6126 
6127     function totalSupply() public override view returns (uint256) {
6128         return _totalSupply;
6129     }
6130 
6131     function balanceOf(address _owner) public override view returns (uint256) {
6132         return _balances[_owner];
6133     }
6134 
6135     function setDevFundReciever(address _devaddr) public {
6136         require(devFundAddress == msg.sender, "only dev can change");
6137         devFundAddress = _devaddr;
6138     }
6139 
6140     function transfer(address recipient, uint256 amount)
6141         public
6142         virtual
6143         override
6144         returns (bool)
6145     {
6146         _transfer(_msgSender(), recipient, amount);
6147         return true;
6148     }
6149 
6150     function allowance(address owner, address spender)
6151         public
6152         virtual
6153         override
6154         view
6155         returns (uint256)
6156     {
6157         return _allowances[owner][spender];
6158     }
6159 
6160     function approve(address spender, uint256 amount)
6161         public
6162         virtual
6163         override
6164         returns (bool)
6165     {
6166         _approve(_msgSender(), spender, amount);
6167         return true;
6168     }
6169 
6170     function transferFrom(
6171         address sender,
6172         address recipient,
6173         uint256 amount
6174     ) public virtual override returns (bool) {
6175         _transfer(sender, recipient, amount);
6176         _approve(
6177             sender,
6178             _msgSender(),
6179             _allowances[sender][_msgSender()].sub(
6180                 amount,
6181                 "ERC20: transfer amount exceeds allowance"
6182             )
6183         );
6184         return true;
6185     }
6186 
6187     function increaseAllowance(address spender, uint256 addedValue)
6188         public
6189         virtual
6190         returns (bool)
6191     {
6192         _approve(
6193             _msgSender(),
6194             spender,
6195             _allowances[_msgSender()][spender].add(addedValue)
6196         );
6197         return true;
6198     }
6199 
6200     function decreaseAllowance(address spender, uint256 subtractedValue)
6201         public
6202         virtual
6203         returns (bool)
6204     {
6205         _approve(
6206             _msgSender(),
6207             spender,
6208             _allowances[_msgSender()][spender].sub(
6209                 subtractedValue,
6210                 "ERC20: decreased allowance below zero"
6211             )
6212         );
6213         return true;
6214     }
6215 
6216     function setTransferChecker(address _transferCheckerAddress)
6217         public
6218         onlyOwner
6219     {
6220         transferCheckerAddress = _transferCheckerAddress;
6221     }
6222 
6223     address public override transferCheckerAddress;
6224 
6225     function setFeeDistributor(address _feeDistributor) public onlyOwner {
6226         feeDistributor = _feeDistributor;
6227         _approve(
6228             address(this),
6229             _feeDistributor,
6230             0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
6231         );
6232     }
6233 
6234     address public override feeDistributor;
6235 
6236     function _transfer(
6237         address sender,
6238         address recipient,
6239         uint256 amount
6240     ) internal virtual {
6241         require(sender != address(0), "ERC20: transfer from the zero address");
6242         require(recipient != address(0), "ERC20: transfer to the zero address");
6243 
6244         _beforeTokenTransfer(sender, recipient, amount);
6245 
6246         _balances[sender] = _balances[sender].sub(
6247             amount,
6248             "ERC20: transfer amount exceeds balance"
6249         );
6250 
6251         (
6252             uint256 transferToAmount,
6253             uint256 transferToFeeDistributorAmount
6254         ) = IFeeCalculator(transferCheckerAddress).calculateAmountsAfterFee(
6255             sender,
6256             recipient,
6257             amount
6258         );
6259 
6260         require(
6261             transferToAmount.add(transferToFeeDistributorAmount) == amount,
6262             "Math broke!"
6263         );
6264 
6265         _balances[recipient] = _balances[recipient].add(transferToAmount);
6266         emit Transfer(sender, recipient, transferToAmount);
6267 
6268         if (
6269             transferToFeeDistributorAmount > 0 && feeDistributor != address(0)
6270         ) {
6271             _balances[feeDistributor] = _balances[feeDistributor].add(
6272                 transferToFeeDistributorAmount
6273             );
6274             emit Transfer(
6275                 sender,
6276                 feeDistributor,
6277                 transferToFeeDistributorAmount
6278             );
6279             IPISVault(feeDistributor).updatePendingRewards();
6280         }
6281     }
6282 
6283     function _mint(address account, uint256 amount) internal virtual {
6284         require(account != address(0), "ERC20: mint to the zero address");
6285 
6286         _beforeTokenTransfer(address(0), account, amount);
6287 
6288         _totalSupply = _totalSupply.add(amount);
6289         _balances[account] = _balances[account].add(amount);
6290         emit Transfer(address(0), account, amount);
6291     }
6292 
6293     function _burn(address account, uint256 amount) internal virtual {
6294         require(account != address(0), "ERC20: burn from the zero address");
6295 
6296         _beforeTokenTransfer(account, address(0), amount);
6297 
6298         _balances[account] = _balances[account].sub(
6299             amount,
6300             "ERC20: burn amount exceeds balance"
6301         );
6302         _totalSupply = _totalSupply.sub(amount);
6303         emit Transfer(account, address(0), amount);
6304     }
6305 
6306     function _approve(
6307         address owner,
6308         address spender,
6309         uint256 amount
6310     ) internal virtual {
6311         require(owner != address(0), "ERC20: approve from the zero address");
6312         require(spender != address(0), "ERC20: approve to the zero address");
6313 
6314         _allowances[owner][spender] = amount;
6315         emit Approval(owner, spender, amount);
6316     }
6317 
6318     function _setupDecimals(uint8 decimals_) internal {
6319         _decimals = decimals_;
6320     }
6321 
6322     function _beforeTokenTransfer(
6323         address from,
6324         address to,
6325         uint256 amount
6326     ) internal virtual {}
6327 }