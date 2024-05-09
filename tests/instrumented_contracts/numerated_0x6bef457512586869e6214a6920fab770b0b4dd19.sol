1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-17
3  */
4 
5 // SPDX-License-Identifier: NONE
6 
7 pragma solidity 0.8.7;
8 
9 // File: @openzeppelin/contracts/math/SafeMath.sol
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations with added overflow
13  * checks.
14  *
15  * Arithmetic operations in Solidity wrap on overflow. This can easily result
16  * in bugs, because programmers usually assume that an overflow raises an
17  * error, which is the standard behavior in high level programming languages.
18  * `SafeMath` restores this intuition by reverting the transaction when an
19  * operation overflows.
20  *
21  * Using this library instead of the unchecked operations eliminates an entire
22  * class of bugs, so it's recommended to use it always.
23  */
24 library SafeMath {
25     /**
26      * @dev Returns the addition of two unsigned integers, with an overflow flag.
27      *
28      * _Available since v3.4._
29      */
30     function tryAdd(uint256 a, uint256 b)
31         internal
32         pure
33         returns (bool, uint256)
34     {
35         uint256 c = a + b;
36         if (c < a) return (false, 0);
37         return (true, c);
38     }
39 
40     /**
41      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function trySub(uint256 a, uint256 b)
46         internal
47         pure
48         returns (bool, uint256)
49     {
50         if (b > a) return (false, 0);
51         return (true, a - b);
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
56      *
57      * _Available since v3.4._
58      */
59     function tryMul(uint256 a, uint256 b)
60         internal
61         pure
62         returns (bool, uint256)
63     {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67         if (a == 0) return (true, 0);
68         uint256 c = a * b;
69         if (c / a != b) return (false, 0);
70         return (true, c);
71     }
72 
73     /**
74      * @dev Returns the division of two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryDiv(uint256 a, uint256 b)
79         internal
80         pure
81         returns (bool, uint256)
82     {
83         if (b == 0) return (false, 0);
84         return (true, a / b);
85     }
86 
87     /**
88      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
89      *
90      * _Available since v3.4._
91      */
92     function tryMod(uint256 a, uint256 b)
93         internal
94         pure
95         returns (bool, uint256)
96     {
97         if (b == 0) return (false, 0);
98         return (true, a % b);
99     }
100 
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b <= a, "SafeMath: subtraction overflow");
129         return a - b;
130     }
131 
132     /**
133      * @dev Returns the multiplication of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `*` operator.
137      *
138      * Requirements:
139      *
140      * - Multiplication cannot overflow.
141      */
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         if (a == 0) return 0;
144         uint256 c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146         return c;
147     }
148 
149     /**
150      * @dev Returns the integer division of two unsigned integers, reverting on
151      * division by zero. The result is rounded towards zero.
152      *
153      * Counterpart to Solidity's `/` operator. Note: this function uses a
154      * `revert` opcode (which leaves remaining gas untouched) while Solidity
155      * uses an invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         require(b > 0, "SafeMath: division by zero");
163         return a / b;
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * reverting when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b > 0, "SafeMath: modulo by zero");
180         return a % b;
181     }
182 
183     /**
184      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
185      * overflow (when the result is negative).
186      *
187      * CAUTION: This function is deprecated because it requires allocating memory for the error
188      * message unnecessarily. For custom revert reasons use {trySub}.
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      *
194      * - Subtraction cannot overflow.
195      */
196     function sub(
197         uint256 a,
198         uint256 b,
199         string memory errorMessage
200     ) internal pure returns (uint256) {
201         require(b <= a, errorMessage);
202         return a - b;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * CAUTION: This function is deprecated because it requires allocating memory for the error
210      * message unnecessarily. For custom revert reasons use {tryDiv}.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         return a / b;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * reverting with custom message when dividing by zero.
232      *
233      * CAUTION: This function is deprecated because it requires allocating memory for the error
234      * message unnecessarily. For custom revert reasons use {tryMod}.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(
245         uint256 a,
246         uint256 b,
247         string memory errorMessage
248     ) internal pure returns (uint256) {
249         require(b > 0, errorMessage);
250         return a % b;
251     }
252 }
253 
254 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
255 
256 pragma solidity 0.8.7;
257 
258 /**
259  * @dev Interface of the ERC20 standard as defined in the EIP.
260  */
261 interface IERC20 {
262     /**
263      * @dev Returns the amount of tokens in existence.
264      */
265     function totalSupply() external view returns (uint256);
266 
267     /**
268      * @dev Returns the amount of tokens owned by `account`.
269      */
270     function balanceOf(address account) external view returns (uint256);
271 
272     /**
273      * @dev Moves `amount` tokens from the caller's account to `recipient`.
274      *
275      * Returns a boolean value indicating whether the operation succeeded.
276      *
277      * Emits a {Transfer} event.
278      */
279     function transfer(address recipient, uint256 amount)
280         external
281         returns (bool);
282 
283     /**
284      * @dev Returns the remaining number of tokens that `spender` will be
285      * allowed to spend on behalf of `owner` through {transferFrom}. This is
286      * zero by default.
287      *
288      * This value changes when {approve} or {transferFrom} are called.
289      */
290     function allowance(address owner, address spender)
291         external
292         view
293         returns (uint256);
294 
295     /**
296      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
297      *
298      * Returns a boolean value indicating whether the operation succeeded.
299      *
300      * IMPORTANT: Beware that changing an allowance with this method brings the risk
301      * that someone may use both the old and the new allowance by unfortunate
302      * transaction ordering. One possible solution to mitigate this race
303      * condition is to first reduce the spender's allowance to 0 and set the
304      * desired value afterwards:
305      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
306      *
307      * Emits an {Approval} event.
308      */
309     function approve(address spender, uint256 amount) external returns (bool);
310 
311     /**
312      * @dev Moves `amount` tokens from `sender` to `recipient` using the
313      * allowance mechanism. `amount` is then deducted from the caller's
314      * allowance.
315      *
316      * Returns a boolean value indicating whether the operation succeeded.
317      *
318      * Emits a {Transfer} event.
319      */
320     function transferFrom(
321         address sender,
322         address recipient,
323         uint256 amount
324     ) external returns (bool);
325 
326     /**
327      * @dev Emitted when `value` tokens are moved from one account (`from`) to
328      * another (`to`).
329      *
330      * Note that `value` may be zero.
331      */
332     event Transfer(address indexed from, address indexed to, uint256 value);
333 
334     /**
335      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
336      * a call to {approve}. `value` is the new allowance.
337      */
338     event Approval(
339         address indexed owner,
340         address indexed spender,
341         uint256 value
342     );
343 }
344 
345 // File: @openzeppelin/contracts/utils/Address.sol
346 
347 pragma solidity 0.8.7;
348 
349 /**
350  * @dev Collection of functions related to the address type
351  */
352 library Address {
353     /**
354      * @dev Returns true if `account` is a contract.
355      *
356      * [IMPORTANT]
357      * ====
358      * It is unsafe to assume that an address for which this function returns
359      * false is an externally-owned account (EOA) and not a contract.
360      *
361      * Among others, `isContract` will return false for the following
362      * types of addresses:
363      *
364      *  - an externally-owned account
365      *  - a contract in construction
366      *  - an address where a contract will be created
367      *  - an address where a contract lived, but was destroyed
368      * ====
369      */
370     function isContract(address account) internal view returns (bool) {
371         // This method relies on extcodesize, which returns 0 for contracts in
372         // construction, since the code is only stored at the end of the
373         // constructor execution.
374 
375         uint256 size;
376         // solhint-disable-next-line no-inline-assembly
377         assembly {
378             size := extcodesize(account)
379         }
380         return size > 0;
381     }
382 
383     /**
384      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
385      * `recipient`, forwarding all available gas and reverting on errors.
386      *
387      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
388      * of certain opcodes, possibly making contracts go over the 2300 gas limit
389      * imposed by `transfer`, making them unable to receive funds via
390      * `transfer`. {sendValue} removes this limitation.
391      *
392      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
393      *
394      * IMPORTANT: because control is transferred to `recipient`, care must be
395      * taken to not create reentrancy vulnerabilities. Consider using
396      * {ReentrancyGuard} or the
397      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
398      */
399     function sendValue(address payable recipient, uint256 amount) internal {
400         require(
401             address(this).balance >= amount,
402             "Address: insufficient balance"
403         );
404 
405         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
406         (bool success, ) = recipient.call{value: amount}("");
407         require(
408             success,
409             "Address: unable to send value, recipient may have reverted"
410         );
411     }
412 
413     /**
414      * @dev Performs a Solidity function call using a low level `call`. A
415      * plain`call` is an unsafe replacement for a function call: use this
416      * function instead.
417      *
418      * If `target` reverts with a revert reason, it is bubbled up by this
419      * function (like regular Solidity function calls).
420      *
421      * Returns the raw returned data. To convert to the expected return value,
422      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
423      *
424      * Requirements:
425      *
426      * - `target` must be a contract.
427      * - calling `target` with `data` must not revert.
428      *
429      * _Available since v3.1._
430      */
431     function functionCall(address target, bytes memory data)
432         internal
433         returns (bytes memory)
434     {
435         return functionCall(target, data, "Address: low-level call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
440      * `errorMessage` as a fallback revert reason when `target` reverts.
441      *
442      * _Available since v3.1._
443      */
444     function functionCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal returns (bytes memory) {
449         return functionCallWithValue(target, data, 0, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but also transferring `value` wei to `target`.
455      *
456      * Requirements:
457      *
458      * - the calling contract must have an ETH balance of at least `value`.
459      * - the called Solidity function must be `payable`.
460      *
461      * _Available since v3.1._
462      */
463     function functionCallWithValue(
464         address target,
465         bytes memory data,
466         uint256 value
467     ) internal returns (bytes memory) {
468         return
469             functionCallWithValue(
470                 target,
471                 data,
472                 value,
473                 "Address: low-level call with value failed"
474             );
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
479      * with `errorMessage` as a fallback revert reason when `target` reverts.
480      *
481      * _Available since v3.1._
482      */
483     function functionCallWithValue(
484         address target,
485         bytes memory data,
486         uint256 value,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         require(
490             address(this).balance >= value,
491             "Address: insufficient balance for call"
492         );
493         require(isContract(target), "Address: call to non-contract");
494 
495         // solhint-disable-next-line avoid-low-level-calls
496         (bool success, bytes memory returndata) = target.call{value: value}(
497             data
498         );
499         return _verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but performing a static call.
505      *
506      * _Available since v3.3._
507      */
508     function functionStaticCall(address target, bytes memory data)
509         internal
510         view
511         returns (bytes memory)
512     {
513         return
514             functionStaticCall(
515                 target,
516                 data,
517                 "Address: low-level static call failed"
518             );
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
523      * but performing a static call.
524      *
525      * _Available since v3.3._
526      */
527     function functionStaticCall(
528         address target,
529         bytes memory data,
530         string memory errorMessage
531     ) internal view returns (bytes memory) {
532         require(isContract(target), "Address: static call to non-contract");
533 
534         // solhint-disable-next-line avoid-low-level-calls
535         (bool success, bytes memory returndata) = target.staticcall(data);
536         return _verifyCallResult(success, returndata, errorMessage);
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
541      * but performing a delegate call.
542      *
543      * _Available since v3.4._
544      */
545     function functionDelegateCall(address target, bytes memory data)
546         internal
547         returns (bytes memory)
548     {
549         return
550             functionDelegateCall(
551                 target,
552                 data,
553                 "Address: low-level delegate call failed"
554             );
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
559      * but performing a delegate call.
560      *
561      * _Available since v3.4._
562      */
563     function functionDelegateCall(
564         address target,
565         bytes memory data,
566         string memory errorMessage
567     ) internal returns (bytes memory) {
568         require(isContract(target), "Address: delegate call to non-contract");
569 
570         // solhint-disable-next-line avoid-low-level-calls
571         (bool success, bytes memory returndata) = target.delegatecall(data);
572         return _verifyCallResult(success, returndata, errorMessage);
573     }
574 
575     function _verifyCallResult(
576         bool success,
577         bytes memory returndata,
578         string memory errorMessage
579     ) private pure returns (bytes memory) {
580         if (success) {
581             return returndata;
582         } else {
583             // Look for revert reason and bubble it up if present
584             if (returndata.length > 0) {
585                 // The easiest way to bubble the revert reason is using memory via assembly
586 
587                 // solhint-disable-next-line no-inline-assembly
588                 assembly {
589                     let returndata_size := mload(returndata)
590                     revert(add(32, returndata), returndata_size)
591                 }
592             } else {
593                 revert(errorMessage);
594             }
595         }
596     }
597 }
598 
599 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
600 
601 pragma solidity 0.8.7;
602 
603 /**
604  * @title SafeERC20
605  * @dev Wrappers around ERC20 operations that throw on failure (when the token
606  * contract returns false). Tokens that return no value (and instead revert or
607  * throw on failure) are also supported, non-reverting calls are assumed to be
608  * successful.
609  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
610  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
611  */
612 library SafeERC20 {
613     using SafeMath for uint256;
614     using Address for address;
615 
616     function safeTransfer(
617         IERC20 token,
618         address to,
619         uint256 value
620     ) internal {
621         _callOptionalReturn(
622             token,
623             abi.encodeWithSelector(token.transfer.selector, to, value)
624         );
625     }
626 
627     function safeTransferFrom(
628         IERC20 token,
629         address from,
630         address to,
631         uint256 value
632     ) internal {
633         _callOptionalReturn(
634             token,
635             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
636         );
637     }
638 
639     /**
640      * @dev Deprecated. This function has issues similar to the ones found in
641      * {IERC20-approve}, and its usage is discouraged.
642      *
643      * Whenever possible, use {safeIncreaseAllowance} and
644      * {safeDecreaseAllowance} instead.
645      */
646     function safeApprove(
647         IERC20 token,
648         address spender,
649         uint256 value
650     ) internal {
651         // safeApprove should only be called when setting an initial allowance,
652         // or when resetting it to zero. To increase and decrease it, use
653         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
654         // solhint-disable-next-line max-line-length
655         require(
656             (value == 0) || (token.allowance(address(this), spender) == 0),
657             "SafeERC20: approve from non-zero to non-zero allowance"
658         );
659         _callOptionalReturn(
660             token,
661             abi.encodeWithSelector(token.approve.selector, spender, value)
662         );
663     }
664 
665     function safeIncreaseAllowance(
666         IERC20 token,
667         address spender,
668         uint256 value
669     ) internal {
670         uint256 newAllowance = token.allowance(address(this), spender).add(
671             value
672         );
673         _callOptionalReturn(
674             token,
675             abi.encodeWithSelector(
676                 token.approve.selector,
677                 spender,
678                 newAllowance
679             )
680         );
681     }
682 
683     function safeDecreaseAllowance(
684         IERC20 token,
685         address spender,
686         uint256 value
687     ) internal {
688         uint256 newAllowance = token.allowance(address(this), spender).sub(
689             value,
690             "SafeERC20: decreased allowance below zero"
691         );
692         _callOptionalReturn(
693             token,
694             abi.encodeWithSelector(
695                 token.approve.selector,
696                 spender,
697                 newAllowance
698             )
699         );
700     }
701 
702     /**
703      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
704      * on the return value: the return value is optional (but if data is returned, it must not be false).
705      * @param token The token targeted by the call.
706      * @param data The call data (encoded using abi.encode or one of its variants).
707      */
708     function _callOptionalReturn(IERC20 token, bytes memory data) private {
709         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
710         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
711         // the target address contains contract code and also asserts for success in the low-level call.
712 
713         bytes memory returndata = address(token).functionCall(
714             data,
715             "SafeERC20: low-level call failed"
716         );
717         if (returndata.length > 0) {
718             // Return data is optional
719             // solhint-disable-next-line max-line-length
720             require(
721                 abi.decode(returndata, (bool)),
722                 "SafeERC20: ERC20 operation did not succeed"
723             );
724         }
725     }
726 }
727 
728 // File: @openzeppelin/contracts/utils/Context.sol
729 
730 pragma solidity 0.8.7;
731 
732 /*
733  * @dev Provides information about the current execution context, including the
734  * sender of the transaction and its data. While these are generally available
735  * via msg.sender and msg.data, they should not be accessed in such a direct
736  * manner, since when dealing with GSN meta-transactions the account sending and
737  * paying for execution may not be the actual sender (as far as an application
738  * is concerned).
739  *
740  * This contract is only required for intermediate, library-like contracts.
741  */
742 abstract contract Context {
743     function _msgSender() internal view virtual returns (address payable) {
744         return payable(msg.sender);
745     }
746 
747     function _msgData() internal view virtual returns (bytes memory) {
748         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
749         return msg.data;
750     }
751 }
752 
753 // File: @openzeppelin/contracts/access/Ownable.sol
754 
755 pragma solidity 0.8.7;
756 
757 /**
758  * @dev Contract module which provides a basic access control mechanism, where
759  * there is an account (an owner) that can be granted exclusive access to
760  * specific functions.
761  *
762  * By default, the owner account will be the one that deploys the contract. This
763  * can later be changed with {transferOwnership}.
764  *
765  * This module is used through inheritance. It will make available the modifier
766  * `onlyOwner`, which can be applied to your functions to restrict their use to
767  * the owner.
768  */
769 abstract contract Ownable is Context {
770     address private _owner;
771 
772     event OwnershipTransferred(
773         address indexed previousOwner,
774         address indexed newOwner
775     );
776 
777     /**
778      * @dev Initializes the contract setting the deployer as the initial owner.
779      */
780     constructor() {
781         address msgSender = _msgSender();
782         _owner = msgSender;
783         emit OwnershipTransferred(address(0), msgSender);
784     }
785 
786     /**
787      * @dev Returns the address of the current owner.
788      */
789     function owner() public view virtual returns (address) {
790         return _owner;
791     }
792 
793     /**
794      * @dev Throws if called by any account other than the owner.
795      */
796     modifier onlyOwner() {
797         require(owner() == _msgSender(), "Ownable: caller is not the owner");
798         _;
799     }
800 
801     /**
802      * @dev Leaves the contract without owner. It will not be possible to call
803      * `onlyOwner` functions anymore. Can only be called by the current owner.
804      *
805      * NOTE: Renouncing ownership will leave the contract without an owner,
806      * thereby removing any functionality that is only available to the owner.
807      */
808     function renounceOwnership() public virtual onlyOwner {
809         emit OwnershipTransferred(_owner, address(0));
810         _owner = address(0);
811     }
812 
813     /**
814      * @dev Transfers ownership of the contract to a new account (`newOwner`).
815      * Can only be called by the current owner.
816      */
817     function transferOwnership(address newOwner) public virtual onlyOwner {
818         require(
819             newOwner != address(0),
820             "Ownable: new owner is the zero address"
821         );
822         emit OwnershipTransferred(_owner, newOwner);
823         _owner = newOwner;
824     }
825 }
826 
827 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
828 
829 pragma solidity 0.8.7;
830 
831 /**
832  * @dev Contract module that helps prevent reentrant calls to a function.
833  *
834  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
835  * available, which can be applied to functions to make sure there are no nested
836  * (reentrant) calls to them.
837  *
838  * Note that because there is a single `nonReentrant` guard, functions marked as
839  * `nonReentrant` may not call one another. This can be worked around by making
840  * those functions `private`, and then adding `external` `nonReentrant` entry
841  * points to them.
842  *
843  * TIP: If you would like to learn more about reentrancy and alternative ways
844  * to protect against it, check out our blog post
845  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
846  */
847 abstract contract ReentrancyGuard {
848     // Booleans are more expensive than uint256 or any type that takes up a full
849     // word because each write operation emits an extra SLOAD to first read the
850     // slot's contents, replace the bits taken up by the boolean, and then write
851     // back. This is the compiler's defense against contract upgrades and
852     // pointer aliasing, and it cannot be disabled.
853 
854     // The values being non-zero value makes deployment a bit more expensive,
855     // but in exchange the refund on every call to nonReentrant will be lower in
856     // amount. Since refunds are capped to a percentage of the total
857     // transaction's gas, it is best to keep them low in cases like this one, to
858     // increase the likelihood of the full refund coming into effect.
859     uint256 private constant _NOT_ENTERED = 1;
860     uint256 private constant _ENTERED = 2;
861 
862     uint256 private _status;
863 
864     constructor() {
865         _status = _NOT_ENTERED;
866     }
867 
868     /**
869      * @dev Prevents a contract from calling itself, directly or indirectly.
870      * Calling a `nonReentrant` function from another `nonReentrant`
871      * function is not supported. It is possible to prevent this from happening
872      * by making the `nonReentrant` function external, and make it call a
873      * `private` function that does the actual work.
874      */
875     modifier nonReentrant() {
876         // On the first call to nonReentrant, _notEntered will be true
877         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
878 
879         // Any calls to nonReentrant after this point will fail
880         _status = _ENTERED;
881 
882         _;
883 
884         // By storing the original value once again, a refund is triggered (see
885         // https://eips.ethereum.org/EIPS/eip-2200)
886         _status = _NOT_ENTERED;
887     }
888 }
889 
890 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
891 
892 pragma solidity 0.8.7;
893 
894 // File: contracts/ShiryoinuChef.sol
895 
896 contract MetaGochiChef is Ownable, ReentrancyGuard {
897     using SafeMath for uint256;
898     using SafeERC20 for IERC20;
899 
900     IERC20 public rewardToken;
901 
902     IERC20 public stakedToken;
903 
904     IERC20 public stakedLP;
905     uint256 public quantumStakedTokens = 400000000000000000000000; // number of staked tokens needed to earn the reward, 20 trillion x 9 decimals
906     uint256 public quantumLPTokens = 20000000000000000000; // number of LP tokens needed to earn the reward (20) x 18 dec
907     //uint256 public quantumLPTokens = 20000000000000000; // 0.002 for testing
908     uint256 public rewardForTokenPerDuration = 1;
909     uint256 public rewardForLPPerDuration = 2;
910 
911     // uint256 rewardDuration = 7 days;
912     uint256 public rewardDuration = 10 minutes;
913     uint256 public totalClaimed;
914 
915     bool public farming = true;
916 
917     struct userPosition {
918         uint256 totalClaimed;
919         uint256 amountToken;
920         uint256 amountTokenReceived;
921         uint256 amountLP; // quantized
922         uint256 amountLPReceived; // amount received due to transfer tax
923         uint256 lastRewardTimestamp;
924         uint256 grossTotalClaimed;
925     }
926     mapping(address => userPosition) public addressToUserPosition;
927     address[] public tokenStakers;
928 
929     constructor() {
930         rewardToken = IERC20(0x90749BcAE7bDeE78fD7b8829aeAc855c32A56376);
931         stakedToken = IERC20(0xC1a85Faa09c7f7247899F155439c5488B43E8429);
932         stakedLP = IERC20(0xBA470432de1f7cC406137379DEbB0192284A3031);
933     }
934 
935     function _checkAndClaimPacks(address _user) internal {
936         uint256 claimable = claimablePacks(_user);
937         if (claimable > 0) {
938             addressToUserPosition[_user].lastRewardTimestamp = block.timestamp;
939             addressToUserPosition[_user].totalClaimed = claimable;
940             totalClaimed = totalClaimed + claimable;
941             addressToUserPosition[_user].grossTotalClaimed = totalClaimed;
942             rewardToken.safeTransfer(_user, claimable);
943         }
944     }
945 
946     // user functions
947     function deposit(IERC20 _target, uint256 _amount) public nonReentrant {
948         require(_target == stakedToken || _target == stakedLP, "Uknown token.");
949 
950         _checkAndClaimPacks(msg.sender);
951 
952         if (_target == stakedToken) {
953             uint256 current = addressToUserPosition[msg.sender].amountToken;
954             require(
955                 current + _amount >= quantumStakedTokens,
956                 "Not enough tokens staked."
957             );
958             uint256 tokenBalanceBefore = stakedToken.balanceOf(address(this));
959             stakedToken.safeTransferFrom(msg.sender, address(this), _amount);
960             uint256 tokenReceived = stakedToken.balanceOf(address(this)).sub(
961                 tokenBalanceBefore
962             );
963             addressToUserPosition[msg.sender].amountTokenReceived =
964                 addressToUserPosition[msg.sender].amountTokenReceived +
965                 tokenReceived;
966             addressToUserPosition[msg.sender].amountToken = current + _amount;
967             addressToUserPosition[msg.sender].lastRewardTimestamp = block
968                 .timestamp;
969 
970             tokenStakers.push(msg.sender);
971         }
972         if (_target == stakedLP) {
973             uint256 current = addressToUserPosition[msg.sender].amountLP;
974             require(
975                 current + _amount >= quantumLPTokens,
976                 "Not enough LP staked."
977             );
978             uint256 lpBalanceBefore = stakedLP.balanceOf(address(this));
979             stakedLP.safeTransferFrom(msg.sender, address(this), _amount);
980             uint256 lpReceived = stakedLP.balanceOf(address(this)).sub(
981                 lpBalanceBefore
982             );
983             addressToUserPosition[msg.sender].amountLPReceived =
984                 addressToUserPosition[msg.sender].amountLPReceived +
985                 lpReceived;
986             addressToUserPosition[msg.sender].amountLP = current + _amount;
987             addressToUserPosition[msg.sender].lastRewardTimestamp = block
988                 .timestamp;
989         }
990     }
991 
992     function withdraw(IERC20 _target) public nonReentrant {
993         _checkAndClaimPacks(msg.sender);
994 
995         if (
996             _target == stakedToken &&
997             addressToUserPosition[msg.sender].amountToken > 0
998         ) {
999             uint256 current = addressToUserPosition[msg.sender]
1000                 .amountTokenReceived;
1001             addressToUserPosition[msg.sender].amountToken = 0;
1002             addressToUserPosition[msg.sender].amountTokenReceived = 0;
1003             stakedToken.safeTransfer(msg.sender, current);
1004         }
1005         if (
1006             _target == stakedLP &&
1007             addressToUserPosition[msg.sender].amountLP > 0
1008         ) {
1009             uint256 current = addressToUserPosition[msg.sender]
1010                 .amountLPReceived;
1011             addressToUserPosition[msg.sender].amountLP = 0;
1012             addressToUserPosition[msg.sender].amountLPReceived = 0;
1013             stakedLP.safeTransfer(msg.sender, current);
1014         }
1015         addressToUserPosition[msg.sender].lastRewardTimestamp = block.timestamp;
1016     }
1017 
1018     function nextRewardTime(address _user) public view returns (uint256) {
1019         uint256 elapsedTime = block.timestamp -
1020             addressToUserPosition[_user].lastRewardTimestamp;
1021         uint256 next = addressToUserPosition[_user].lastRewardTimestamp +
1022             rewardDuration;
1023         if (elapsedTime >= rewardDuration) {
1024             uint256 durationUnits = elapsedTime.div(rewardDuration).add(1);
1025             next = addressToUserPosition[_user].lastRewardTimestamp.add(
1026                 durationUnits.mul(rewardDuration)
1027             );
1028         }
1029         return next;
1030     }
1031 
1032     function claimablePacks(address _user) public view returns (uint256) {
1033         uint256 claimable = 0;
1034         uint256 elapsedTime = block.timestamp -
1035             addressToUserPosition[_user].lastRewardTimestamp;
1036         if (elapsedTime >= rewardDuration && farming == true) {
1037             uint256 durationUnits = elapsedTime.div(rewardDuration);
1038             uint256 multipleOfTokenQuantums = 0;
1039             if (addressToUserPosition[_user].amountToken > 0) {
1040                 multipleOfTokenQuantums = addressToUserPosition[_user]
1041                     .amountToken
1042                     .div(quantumStakedTokens);
1043             }
1044             uint256 multipleOfLPQuantums = 0;
1045             if (addressToUserPosition[_user].amountLP > 0) {
1046                 multipleOfLPQuantums = addressToUserPosition[_user]
1047                     .amountLP
1048                     .div(quantumLPTokens);
1049             }
1050             claimable = durationUnits.mul(
1051                 rewardForTokenPerDuration.mul(multipleOfTokenQuantums) +
1052                     rewardForLPPerDuration.mul(multipleOfLPQuantums)
1053             );
1054         }
1055         return claimable;
1056     }
1057 
1058     function claim() public {
1059         _checkAndClaimPacks(msg.sender);
1060     }
1061 
1062     // admin functions
1063     function setStakedToken(IERC20 _target) public onlyOwner {
1064         require(address(_target) != address(0x0), "Null address not allowed");
1065         stakedToken = _target;
1066     }
1067 
1068     function setStakedLPT(IERC20 _target) public onlyOwner {
1069         require(address(_target) != address(0x0), "Null address not allowed");
1070         stakedLP = _target;
1071     }
1072 
1073     // sets the reward amount for the target token
1074     function setReward(IERC20 _target, uint256 _amount) public onlyOwner {
1075         require(_target == stakedToken || _target == stakedLP, "Uknown token.");
1076 
1077         if (_target == stakedToken) {
1078             rewardForTokenPerDuration = _amount;
1079         }
1080         if (_target == stakedLP) {
1081             rewardForLPPerDuration = _amount;
1082         }
1083     }
1084 
1085     function setRewardDuration(uint256 _durationSeconds) public onlyOwner {
1086         rewardDuration = _durationSeconds;
1087     }
1088 
1089     function setQuantumLPTokens(uint256 _amount) public onlyOwner {
1090         quantumLPTokens = _amount;
1091     }
1092 
1093     function setQuantumStakedTokens(uint256 _amount) public onlyOwner {
1094         quantumStakedTokens = _amount;
1095     }
1096 
1097     function withdrawRewardToken(uint256 _amount) public onlyOwner {
1098         rewardToken.safeTransfer(msg.sender, _amount);
1099     }
1100 
1101     function setFarming(bool _farming) public onlyOwner {
1102         farming = _farming;
1103     }
1104 }