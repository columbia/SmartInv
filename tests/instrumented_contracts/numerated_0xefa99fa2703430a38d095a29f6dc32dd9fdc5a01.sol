1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount)
29         external
30         returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender)
40         external
41         view
42         returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(
88         address indexed owner,
89         address indexed spender,
90         uint256 value
91     );
92 }
93 
94 // File: @openzeppelin/contracts/math/SafeMath.sol
95 
96 pragma solidity >=0.6.0 <0.8.0;
97 
98 /**
99  * @dev Wrappers over Solidity's arithmetic operations with added overflow
100  * checks.
101  *
102  * Arithmetic operations in Solidity wrap on overflow. This can easily result
103  * in bugs, because programmers usually assume that an overflow raises an
104  * error, which is the standard behavior in high level programming languages.
105  * `SafeMath` restores this intuition by reverting the transaction when an
106  * operation overflows.
107  *
108  * Using this library instead of the unchecked operations eliminates an entire
109  * class of bugs, so it's recommended to use it always.
110  */
111 library SafeMath {
112     /**
113      * @dev Returns the addition of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `+` operator.
117      *
118      * Requirements:
119      *
120      * - Addition cannot overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a, "SafeMath: addition overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(
154         uint256 a,
155         uint256 b,
156         string memory errorMessage
157     ) internal pure returns (uint256) {
158         require(b <= a, errorMessage);
159         uint256 c = a - b;
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the multiplication of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `*` operator.
169      *
170      * Requirements:
171      *
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(
217         uint256 a,
218         uint256 b,
219         string memory errorMessage
220     ) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(
257         uint256 a,
258         uint256 b,
259         string memory errorMessage
260     ) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 // File: @openzeppelin/contracts/utils/Address.sol
267 
268 pragma solidity >=0.6.2 <0.8.0;
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies on extcodesize, which returns 0 for contracts in
293         // construction, since the code is only stored at the end of the
294         // constructor execution.
295 
296         uint256 size;
297         // solhint-disable-next-line no-inline-assembly
298         assembly {
299             size := extcodesize(account)
300         }
301         return size > 0;
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      */
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(
322             address(this).balance >= amount,
323             "Address: insufficient balance"
324         );
325 
326         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
327         (bool success, ) = recipient.call{value: amount}("");
328         require(
329             success,
330             "Address: unable to send value, recipient may have reverted"
331         );
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain`call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data)
353         internal
354         returns (bytes memory)
355     {
356         return functionCall(target, data, "Address: low-level call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
361      * `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but also transferring `value` wei to `target`.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least `value`.
380      * - the called Solidity function must be `payable`.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value
388     ) internal returns (bytes memory) {
389         return
390             functionCallWithValue(
391                 target,
392                 data,
393                 value,
394                 "Address: low-level call with value failed"
395             );
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
400      * with `errorMessage` as a fallback revert reason when `target` reverts.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(
405         address target,
406         bytes memory data,
407         uint256 value,
408         string memory errorMessage
409     ) internal returns (bytes memory) {
410         require(
411             address(this).balance >= value,
412             "Address: insufficient balance for call"
413         );
414         require(isContract(target), "Address: call to non-contract");
415 
416         // solhint-disable-next-line avoid-low-level-calls
417         (bool success, bytes memory returndata) =
418             target.call{value: value}(data);
419         return _verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(address target, bytes memory data)
429         internal
430         view
431         returns (bytes memory)
432     {
433         return
434             functionStaticCall(
435                 target,
436                 data,
437                 "Address: low-level static call failed"
438             );
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal view returns (bytes memory) {
452         require(isContract(target), "Address: static call to non-contract");
453 
454         // solhint-disable-next-line avoid-low-level-calls
455         (bool success, bytes memory returndata) = target.staticcall(data);
456         return _verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     function _verifyCallResult(
460         bool success,
461         bytes memory returndata,
462         string memory errorMessage
463     ) private pure returns (bytes memory) {
464         if (success) {
465             return returndata;
466         } else {
467             // Look for revert reason and bubble it up if present
468             if (returndata.length > 0) {
469                 // The easiest way to bubble the revert reason is using memory via assembly
470 
471                 // solhint-disable-next-line no-inline-assembly
472                 assembly {
473                     let returndata_size := mload(returndata)
474                     revert(add(32, returndata), returndata_size)
475                 }
476             } else {
477                 revert(errorMessage);
478             }
479         }
480     }
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
484 
485 pragma solidity >=0.6.0 <0.8.0;
486 
487 /**
488  * @title SafeERC20
489  * @dev Wrappers around ERC20 operations that throw on failure (when the token
490  * contract returns false). Tokens that return no value (and instead revert or
491  * throw on failure) are also supported, non-reverting calls are assumed to be
492  * successful.
493  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
494  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
495  */
496 library SafeERC20 {
497     using SafeMath for uint256;
498     using Address for address;
499 
500     function safeTransfer(
501         IERC20 token,
502         address to,
503         uint256 value
504     ) internal {
505         _callOptionalReturn(
506             token,
507             abi.encodeWithSelector(token.transfer.selector, to, value)
508         );
509     }
510 
511     function safeTransferFrom(
512         IERC20 token,
513         address from,
514         address to,
515         uint256 value
516     ) internal {
517         _callOptionalReturn(
518             token,
519             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
520         );
521     }
522 
523     /**
524      * @dev Deprecated. This function has issues similar to the ones found in
525      * {IERC20-approve}, and its usage is discouraged.
526      *
527      * Whenever possible, use {safeIncreaseAllowance} and
528      * {safeDecreaseAllowance} instead.
529      */
530     function safeApprove(
531         IERC20 token,
532         address spender,
533         uint256 value
534     ) internal {
535         // safeApprove should only be called when setting an initial allowance,
536         // or when resetting it to zero. To increase and decrease it, use
537         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
538         // solhint-disable-next-line max-line-length
539         require(
540             (value == 0) || (token.allowance(address(this), spender) == 0),
541             "SafeERC20: approve from non-zero to non-zero allowance"
542         );
543         _callOptionalReturn(
544             token,
545             abi.encodeWithSelector(token.approve.selector, spender, value)
546         );
547     }
548 
549     function safeIncreaseAllowance(
550         IERC20 token,
551         address spender,
552         uint256 value
553     ) internal {
554         uint256 newAllowance =
555             token.allowance(address(this), spender).add(value);
556         _callOptionalReturn(
557             token,
558             abi.encodeWithSelector(
559                 token.approve.selector,
560                 spender,
561                 newAllowance
562             )
563         );
564     }
565 
566     function safeDecreaseAllowance(
567         IERC20 token,
568         address spender,
569         uint256 value
570     ) internal {
571         uint256 newAllowance =
572             token.allowance(address(this), spender).sub(
573                 value,
574                 "SafeERC20: decreased allowance below zero"
575             );
576         _callOptionalReturn(
577             token,
578             abi.encodeWithSelector(
579                 token.approve.selector,
580                 spender,
581                 newAllowance
582             )
583         );
584     }
585 
586     /**
587      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
588      * on the return value: the return value is optional (but if data is returned, it must not be false).
589      * @param token The token targeted by the call.
590      * @param data The call data (encoded using abi.encode or one of its variants).
591      */
592     function _callOptionalReturn(IERC20 token, bytes memory data) private {
593         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
594         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
595         // the target address contains contract code and also asserts for success in the low-level call.
596 
597         bytes memory returndata =
598             address(token).functionCall(
599                 data,
600                 "SafeERC20: low-level call failed"
601             );
602         if (returndata.length > 0) {
603             // Return data is optional
604             // solhint-disable-next-line max-line-length
605             require(
606                 abi.decode(returndata, (bool)),
607                 "SafeERC20: ERC20 operation did not succeed"
608             );
609         }
610     }
611 }
612 
613 // File: contracts/interface/IProxy.sol
614 
615 pragma solidity ^0.6.0;
616 pragma experimental ABIEncoderV2;
617 
618 interface IProxy {
619     function batchExec(
620         address[] calldata tos,
621         bytes32[] calldata configs,
622         bytes[] memory datas
623     ) external payable;
624 
625     function execs(
626         address[] calldata tos,
627         bytes32[] calldata configs,
628         bytes[] memory datas
629     ) external payable;
630 }
631 
632 // File: contracts/interface/IRegistry.sol
633 
634 pragma solidity ^0.6.0;
635 
636 interface IRegistry {
637     function handlers(address) external view returns (bytes32);
638 
639     function callers(address) external view returns (bytes32);
640 
641     function bannedAgents(address) external view returns (uint256);
642 
643     function fHalt() external view returns (bool);
644 
645     function isValidHandler(address handler) external view returns (bool);
646 
647     function isValidCaller(address handler) external view returns (bool);
648 }
649 
650 // File: contracts/Config.sol
651 
652 pragma solidity ^0.6.0;
653 
654 contract Config {
655     // function signature of "postProcess()"
656     bytes4 public constant POSTPROCESS_SIG = 0xc2722916;
657 
658     // The base amount of percentage function
659     uint256 public constant PERCENTAGE_BASE = 1 ether;
660 
661     // Handler post-process type. Others should not happen now.
662     enum HandlerType {Token, Custom, Others}
663 }
664 
665 // File: contracts/lib/LibCache.sol
666 
667 pragma solidity ^0.6.0;
668 
669 library LibCache {
670     function set(
671         mapping(bytes32 => bytes32) storage _cache,
672         bytes32 _key,
673         bytes32 _value
674     ) internal {
675         _cache[_key] = _value;
676     }
677 
678     function setAddress(
679         mapping(bytes32 => bytes32) storage _cache,
680         bytes32 _key,
681         address _value
682     ) internal {
683         _cache[_key] = bytes32(uint256(uint160(_value)));
684     }
685 
686     function setUint256(
687         mapping(bytes32 => bytes32) storage _cache,
688         bytes32 _key,
689         uint256 _value
690     ) internal {
691         _cache[_key] = bytes32(_value);
692     }
693 
694     function getAddress(
695         mapping(bytes32 => bytes32) storage _cache,
696         bytes32 _key
697     ) internal view returns (address ret) {
698         ret = address(uint160(uint256(_cache[_key])));
699     }
700 
701     function getUint256(
702         mapping(bytes32 => bytes32) storage _cache,
703         bytes32 _key
704     ) internal view returns (uint256 ret) {
705         ret = uint256(_cache[_key]);
706     }
707 
708     function get(mapping(bytes32 => bytes32) storage _cache, bytes32 _key)
709         internal
710         view
711         returns (bytes32 ret)
712     {
713         ret = _cache[_key];
714     }
715 }
716 
717 // File: contracts/lib/LibStack.sol
718 
719 pragma solidity ^0.6.0;
720 
721 library LibStack {
722     function setAddress(bytes32[] storage _stack, address _input) internal {
723         _stack.push(bytes32(uint256(uint160(_input))));
724     }
725 
726     function set(bytes32[] storage _stack, bytes32 _input) internal {
727         _stack.push(_input);
728     }
729 
730     function setHandlerType(bytes32[] storage _stack, Config.HandlerType _input)
731         internal
732     {
733         _stack.push(bytes12(uint96(_input)));
734     }
735 
736     function getAddress(bytes32[] storage _stack)
737         internal
738         returns (address ret)
739     {
740         ret = address(uint160(uint256(peek(_stack))));
741         _stack.pop();
742     }
743 
744     function getSig(bytes32[] storage _stack) internal returns (bytes4 ret) {
745         ret = bytes4(peek(_stack));
746         _stack.pop();
747     }
748 
749     function get(bytes32[] storage _stack) internal returns (bytes32 ret) {
750         ret = peek(_stack);
751         _stack.pop();
752     }
753 
754     function peek(bytes32[] storage _stack)
755         internal
756         view
757         returns (bytes32 ret)
758     {
759         require(_stack.length > 0, "stack empty");
760         ret = _stack[_stack.length - 1];
761     }
762 }
763 
764 // File: contracts/Storage.sol
765 
766 pragma solidity ^0.6.0;
767 
768 /// @notice A cache structure composed by a bytes32 array
769 contract Storage {
770     using LibCache for mapping(bytes32 => bytes32);
771     using LibStack for bytes32[];
772 
773     bytes32[] public stack;
774     mapping(bytes32 => bytes32) public cache;
775 
776     // keccak256 hash of "msg.sender"
777     // prettier-ignore
778     bytes32 public constant MSG_SENDER_KEY = 0xb2f2618cecbbb6e7468cc0f2aa43858ad8d153e0280b22285e28e853bb9d453a;
779 
780     // keccak256 hash of "cube.counter"
781     // prettier-ignore
782     bytes32 public constant CUBE_COUNTER_KEY = 0xf9543f11459ccccd21306c8881aaab675ff49d988c1162fd1dd9bbcdbe4446be;
783 
784     modifier isStackEmpty() {
785         require(stack.length == 0, "Stack not empty");
786         _;
787     }
788 
789     modifier isCubeCounterZero() {
790         require(_getCubeCounter() == 0, "Cube counter not zero");
791         _;
792     }
793 
794     modifier isInitialized() {
795         require(_getSender() != address(0), "Sender is not initialized");
796         _;
797     }
798 
799     modifier isNotInitialized() {
800         require(_getSender() == address(0), "Sender is initialized");
801         _;
802     }
803 
804     function _setSender() internal isNotInitialized {
805         cache.setAddress(MSG_SENDER_KEY, msg.sender);
806     }
807 
808     function _resetSender() internal {
809         cache.setAddress(MSG_SENDER_KEY, address(0));
810     }
811 
812     function _getSender() internal view returns (address) {
813         return cache.getAddress(MSG_SENDER_KEY);
814     }
815 
816     function _addCubeCounter() internal {
817         cache.setUint256(CUBE_COUNTER_KEY, _getCubeCounter() + 1);
818     }
819 
820     function _resetCubeCounter() internal {
821         cache.setUint256(CUBE_COUNTER_KEY, 0);
822     }
823 
824     function _getCubeCounter() internal view returns (uint256) {
825         return cache.getUint256(CUBE_COUNTER_KEY);
826     }
827 }
828 
829 // File: contracts/lib/LibParam.sol
830 
831 pragma solidity ^0.6.0;
832 
833 library LibParam {
834     bytes32 private constant STATIC_MASK =
835         0x0100000000000000000000000000000000000000000000000000000000000000;
836     bytes32 private constant PARAMS_MASK =
837         0x0000000000000000000000000000000000000000000000000000000000000001;
838     bytes32 private constant REFS_MASK =
839         0x00000000000000000000000000000000000000000000000000000000000000FF;
840     bytes32 private constant RETURN_NUM_MASK =
841         0x00FF000000000000000000000000000000000000000000000000000000000000;
842 
843     uint256 private constant REFS_LIMIT = 22;
844     uint256 private constant PARAMS_SIZE_LIMIT = 64;
845     uint256 private constant RETURN_NUM_OFFSET = 240;
846 
847     function isStatic(bytes32 conf) internal pure returns (bool) {
848         if (conf & STATIC_MASK == 0) return true;
849         else return false;
850     }
851 
852     function isReferenced(bytes32 conf) internal pure returns (bool) {
853         if (getReturnNum(conf) == 0) return false;
854         else return true;
855     }
856 
857     function getReturnNum(bytes32 conf) internal pure returns (uint256 num) {
858         bytes32 temp = (conf & RETURN_NUM_MASK) >> RETURN_NUM_OFFSET;
859         num = uint256(temp);
860     }
861 
862     function getParams(bytes32 conf)
863         internal
864         pure
865         returns (uint256[] memory refs, uint256[] memory params)
866     {
867         require(!isStatic(conf), "Static params");
868         uint256 n = REFS_LIMIT;
869         while (conf & REFS_MASK == REFS_MASK && n > 0) {
870             n--;
871             conf = conf >> 8;
872         }
873         require(n > 0, "No dynamic param");
874         refs = new uint256[](n);
875         params = new uint256[](n);
876         for (uint256 i = 0; i < n; i++) {
877             refs[i] = uint256(conf & REFS_MASK);
878             conf = conf >> 8;
879         }
880         uint256 i = 0;
881         for (uint256 k = 0; k < PARAMS_SIZE_LIMIT; k++) {
882             if (conf & PARAMS_MASK != 0) {
883                 require(i < n, "Location count exceeds ref count");
884                 params[i] = k * 32 + 4;
885                 i++;
886             }
887             conf = conf >> 1;
888         }
889         require(i == n, "Location count less than ref count");
890     }
891 }
892 
893 // File: contracts/Proxy.sol
894 
895 pragma solidity ^0.6.0;
896 
897 /**
898  * @title The entrance of Furucombo
899  * @author Ben Huang
900  */
901 contract Proxy is IProxy, Storage, Config {
902     using Address for address;
903     using SafeERC20 for IERC20;
904     using LibParam for bytes32;
905 
906     modifier isNotBanned(address agent) {
907         require(registry.bannedAgents(agent) == 0, "Banned");
908         _;
909     }
910 
911     modifier isNotHalted() {
912         require(registry.fHalt() == false, "Halted");
913         _;
914     }
915 
916     IRegistry public immutable registry;
917 
918     constructor(address _registry) public {
919         registry = IRegistry(_registry);
920     }
921 
922     /**
923      * @notice Direct transfer from EOA should be reverted.
924      * @dev Callback function will be handled here.
925      */
926     fallback()
927         external
928         payable
929         isNotHalted
930         isNotBanned(msg.sender)
931         isInitialized
932     {
933         // If triggered by a function call, caller should be registered in
934         // registry.
935         // The function call will then be forwarded to the location registered
936         // in registry.
937         require(_isValidCaller(msg.sender), "Invalid caller");
938 
939         address target = address(bytes20(registry.callers(msg.sender)));
940         bytes memory result = _exec(target, msg.data);
941 
942         // return result for aave v2 flashloan()
943         uint256 size = result.length;
944         assembly {
945             let loc := add(result, 0x20)
946             return(loc, size)
947         }
948     }
949 
950     /**
951      * @notice Direct transfer from EOA should be reverted.
952      */
953     receive() external payable {
954         require(Address.isContract(msg.sender), "Not allowed from EOA");
955     }
956 
957     /**
958      * @notice Combo execution function. Including three phases: pre-process,
959      * exection and post-process.
960      * @param tos The handlers of combo.
961      * @param configs The configurations of executing cubes.
962      * @param datas The combo datas.
963      */
964     function batchExec(
965         address[] calldata tos,
966         bytes32[] calldata configs,
967         bytes[] memory datas
968     ) external payable override isNotHalted isNotBanned(msg.sender) {
969         _preProcess();
970         _execs(tos, configs, datas);
971         _postProcess();
972     }
973 
974     /**
975      * @notice The execution interface for callback function to be executed.
976      * @dev This function can only be called through the handler, which makes
977      * the caller become proxy itself.
978      */
979     function execs(
980         address[] calldata tos,
981         bytes32[] calldata configs,
982         bytes[] memory datas
983     )
984         external
985         payable
986         override
987         isNotHalted
988         isNotBanned(msg.sender)
989         isInitialized
990     {
991         require(msg.sender == address(this), "Does not allow external calls");
992         _execs(tos, configs, datas);
993     }
994 
995     /**
996      * @notice The execution phase.
997      * @param tos The handlers of combo.
998      * @param configs The configurations of executing cubes.
999      * @param datas The combo datas.
1000      */
1001     function _execs(
1002         address[] memory tos,
1003         bytes32[] memory configs,
1004         bytes[] memory datas
1005     ) internal {
1006         bytes32[256] memory localStack;
1007         uint256 index = 0;
1008 
1009         require(
1010             tos.length == datas.length,
1011             "Tos and datas length inconsistent"
1012         );
1013         require(
1014             tos.length == configs.length,
1015             "Tos and configs length inconsistent"
1016         );
1017         for (uint256 i = 0; i < tos.length; i++) {
1018             bytes32 config = configs[i];
1019             // Check if the data contains dynamic parameter
1020             if (!config.isStatic()) {
1021                 // If so, trim the exectution data base on the configuration and stack content
1022                 _trim(datas[i], config, localStack, index);
1023             }
1024             // Check if the output will be referenced afterwards
1025             bytes memory result = _exec(tos[i], datas[i]);
1026             if (config.isReferenced()) {
1027                 // If so, parse the output and place it into local stack
1028                 uint256 num = config.getReturnNum();
1029                 uint256 newIndex = _parse(localStack, result, index);
1030                 require(
1031                     newIndex == index + num,
1032                     "Return num and parsed return num not matched"
1033                 );
1034                 index = newIndex;
1035             }
1036 
1037             // Setup the process to be triggered in the post-process phase
1038             _setPostProcess(tos[i]);
1039         }
1040     }
1041 
1042     /**
1043      * @notice Trimming the execution data.
1044      * @param data The execution data.
1045      * @param config The configuration.
1046      * @param localStack The stack the be referenced.
1047      * @param index Current element count of localStack.
1048      */
1049     function _trim(
1050         bytes memory data,
1051         bytes32 config,
1052         bytes32[256] memory localStack,
1053         uint256 index
1054     ) internal pure {
1055         // Fetch the parameter configuration from config
1056         (uint256[] memory refs, uint256[] memory params) = config.getParams();
1057         // Trim the data with the reference and parameters
1058         for (uint256 i = 0; i < refs.length; i++) {
1059             require(refs[i] < index, "Reference to out of localStack");
1060             bytes32 ref = localStack[refs[i]];
1061             uint256 offset = params[i];
1062             uint256 base = PERCENTAGE_BASE;
1063             assembly {
1064                 let loc := add(add(data, 0x20), offset)
1065                 let m := mload(loc)
1066                 // Adjust the value by multiplier if a dynamic parameter is not zero
1067                 if iszero(iszero(m)) {
1068                     // Assert no overflow first
1069                     let p := mul(m, ref)
1070                     if iszero(eq(div(p, m), ref)) {
1071                         revert(0, 0)
1072                     } // require(p / m == ref)
1073                     ref := div(p, base)
1074                 }
1075                 mstore(loc, ref)
1076             }
1077         }
1078     }
1079 
1080     /**
1081      * @notice Parse the return data to the local stack.
1082      * @param localStack The local stack to place the return values.
1083      * @param ret The return data.
1084      * @param index The current tail.
1085      */
1086     function _parse(
1087         bytes32[256] memory localStack,
1088         bytes memory ret,
1089         uint256 index
1090     ) internal pure returns (uint256 newIndex) {
1091         uint256 len = ret.length;
1092         // The return value should be multiple of 32-bytes to be parsed.
1093         require(len % 32 == 0, "illegal length for _parse");
1094         // Estimate the tail after the process.
1095         newIndex = index + len / 32;
1096         require(newIndex <= 256, "stack overflow");
1097         assembly {
1098             let offset := shl(5, index)
1099             // Store the data into localStack
1100             for {
1101                 let i := 0
1102             } lt(i, len) {
1103                 i := add(i, 0x20)
1104             } {
1105                 mstore(
1106                     add(localStack, add(i, offset)),
1107                     mload(add(add(ret, i), 0x20))
1108                 )
1109             }
1110         }
1111     }
1112 
1113     /**
1114      * @notice The execution of a single cube.
1115      * @param _to The handler of cube.
1116      * @param _data The cube execution data.
1117      */
1118     function _exec(address _to, bytes memory _data)
1119         internal
1120         returns (bytes memory result)
1121     {
1122         require(_isValidHandler(_to), "Invalid handler");
1123         _addCubeCounter();
1124         assembly {
1125             let succeeded := delegatecall(
1126                 sub(gas(), 5000),
1127                 _to,
1128                 add(_data, 0x20),
1129                 mload(_data),
1130                 0,
1131                 0
1132             )
1133             let size := returndatasize()
1134 
1135             result := mload(0x40)
1136             mstore(
1137                 0x40,
1138                 add(result, and(add(add(size, 0x20), 0x1f), not(0x1f)))
1139             )
1140             mstore(result, size)
1141             returndatacopy(add(result, 0x20), 0, size)
1142 
1143             switch iszero(succeeded)
1144                 case 1 {
1145                     revert(add(result, 0x20), size)
1146                 }
1147         }
1148     }
1149 
1150     /**
1151      * @notice Setup the post-process.
1152      * @param _to The handler of post-process.
1153      */
1154     function _setPostProcess(address _to) internal {
1155         // If the stack length equals 0, just skip
1156         // If the top is a custom post-process, replace it with the handler
1157         // address.
1158         if (stack.length == 0) {
1159             return;
1160         } else if (
1161             stack.peek() == bytes32(bytes12(uint96(HandlerType.Custom)))
1162         ) {
1163             stack.pop();
1164             // Check if the handler is already set.
1165             if (bytes4(stack.peek()) != 0x00000000) stack.setAddress(_to);
1166             stack.setHandlerType(HandlerType.Custom);
1167         }
1168     }
1169 
1170     /// @notice The pre-process phase.
1171     function _preProcess() internal virtual isStackEmpty isCubeCounterZero {
1172         // Set the sender.
1173         _setSender();
1174     }
1175 
1176     /// @notice The post-process phase.
1177     function _postProcess() internal {
1178         // If the top of stack is HandlerType.Custom (which makes it being zero
1179         // address when `stack.getAddress()`), get the handler address and execute
1180         // the handler with it and the post-process function selector.
1181         // If not, use it as token address and send the token back to user.
1182         while (stack.length > 0) {
1183             address addr = stack.getAddress();
1184             if (addr == address(0)) {
1185                 addr = stack.getAddress();
1186                 _exec(addr, abi.encodeWithSelector(POSTPROCESS_SIG));
1187             } else {
1188                 uint256 amount = IERC20(addr).balanceOf(address(this));
1189                 if (amount > 0) IERC20(addr).safeTransfer(msg.sender, amount);
1190             }
1191         }
1192 
1193         // Balance should also be returned to user
1194         uint256 amount = address(this).balance;
1195         if (amount > 0) msg.sender.transfer(amount);
1196 
1197         // Reset the msg.sender and cube counter
1198         _resetSender();
1199         _resetCubeCounter();
1200     }
1201 
1202     /// @notice Check if the handler is valid in registry.
1203     function _isValidHandler(address handler) internal view returns (bool) {
1204         return registry.isValidHandler(handler);
1205     }
1206 
1207     /// @notice Check if the caller is valid in registry.
1208     function _isValidCaller(address caller) internal view returns (bool) {
1209         return registry.isValidCaller(caller);
1210     }
1211 }