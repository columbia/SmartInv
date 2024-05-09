1 // File @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol@v0.3.1
2 
3 pragma solidity ^0.8.0;
4 
5 interface AggregatorV3Interface {
6   function decimals() external view returns (uint8);
7 
8   function description() external view returns (string memory);
9 
10   function version() external view returns (uint256);
11 
12   // getRoundData and latestRoundData should both raise "No data present"
13   // if they do not have data to report, instead of returning unset values
14   // which could be misinterpreted as actual reported values.
15   function getRoundData(uint80 _roundId)
16     external
17     view
18     returns (
19       uint80 roundId,
20       int256 answer,
21       uint256 startedAt,
22       uint256 updatedAt,
23       uint80 answeredInRound
24     );
25 
26   function latestRoundData()
27     external
28     view
29     returns (
30       uint80 roundId,
31       int256 answer,
32       uint256 startedAt,
33       uint256 updatedAt,
34       uint80 answeredInRound
35     );
36 }
37 
38 
39 // File contracts/presaleNew.sol
40 
41 // Sources flattened with hardhat v2.8.0 https://hardhat.org
42 
43 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.4.2
44 
45 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
46 
47 pragma solidity ^0.8.0;
48 
49 // CAUTION
50 // This version of SafeMath should only be used with Solidity 0.8 or later,
51 // because it relies on the compiler's built in overflow checks.
52 
53 /**
54  * @dev Wrappers over Solidity's arithmetic operations.
55  *
56  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
57  * now has built in overflow checking.
58  */
59 library SafeMath {
60     /**
61      * @dev Returns the addition of two unsigned integers, with an overflow flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             uint256 c = a + b;
68             if (c < a) return (false, 0);
69             return (true, c);
70         }
71     }
72 
73     /**
74      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
75      *
76      * _Available since v3.4._
77      */
78     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b > a) return (false, 0);
81             return (true, a - b);
82         }
83     }
84 
85     /**
86      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
93             // benefit is lost if 'b' is also tested.
94             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
95             if (a == 0) return (true, 0);
96             uint256 c = a * b;
97             if (c / a != b) return (false, 0);
98             return (true, c);
99         }
100     }
101 
102     /**
103      * @dev Returns the division of two unsigned integers, with a division by zero flag.
104      *
105      * _Available since v3.4._
106      */
107     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
108         unchecked {
109             if (b == 0) return (false, 0);
110             return (true, a / b);
111         }
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
116      *
117      * _Available since v3.4._
118      */
119     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
120         unchecked {
121             if (b == 0) return (false, 0);
122             return (true, a % b);
123         }
124     }
125 
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      *
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a + b;
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a - b;
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `*` operator.
159      *
160      * Requirements:
161      *
162      * - Multiplication cannot overflow.
163      */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         return a * b;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers, reverting on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator.
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return a / b;
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
184      * reverting when dividing by zero.
185      *
186      * Counterpart to Solidity's `%` operator. This function uses a `revert`
187      * opcode (which leaves remaining gas untouched) while Solidity uses an
188      * invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
195         return a % b;
196     }
197 
198     /**
199      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
200      * overflow (when the result is negative).
201      *
202      * CAUTION: This function is deprecated because it requires allocating memory for the error
203      * message unnecessarily. For custom revert reasons use {trySub}.
204      *
205      * Counterpart to Solidity's `-` operator.
206      *
207      * Requirements:
208      *
209      * - Subtraction cannot overflow.
210      */
211     function sub(
212         uint256 a,
213         uint256 b,
214         string memory errorMessage
215     ) internal pure returns (uint256) {
216         unchecked {
217             require(b <= a, errorMessage);
218             return a - b;
219         }
220     }
221 
222     /**
223      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
224      * division by zero. The result is rounded towards zero.
225      *
226      * Counterpart to Solidity's `/` operator. Note: this function uses a
227      * `revert` opcode (which leaves remaining gas untouched) while Solidity
228      * uses an invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function div(
235         uint256 a,
236         uint256 b,
237         string memory errorMessage
238     ) internal pure returns (uint256) {
239         unchecked {
240             require(b > 0, errorMessage);
241             return a / b;
242         }
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * reverting with custom message when dividing by zero.
248      *
249      * CAUTION: This function is deprecated because it requires allocating memory for the error
250      * message unnecessarily. For custom revert reasons use {tryMod}.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(
261         uint256 a,
262         uint256 b,
263         string memory errorMessage
264     ) internal pure returns (uint256) {
265         unchecked {
266             require(b > 0, errorMessage);
267             return a % b;
268         }
269     }
270 }
271 
272 
273 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.2
274 
275 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Interface of the ERC20 standard as defined in the EIP.
281  */
282 interface IERC20 {
283     /**
284      * @dev Returns the amount of tokens in existence.
285      */
286     function totalSupply() external view returns (uint256);
287 
288     /**
289      * @dev Returns the amount of tokens owned by `account`.
290      */
291     function balanceOf(address account) external view returns (uint256);
292 
293     /**
294      * @dev Moves `amount` tokens from the caller's account to `recipient`.
295      *
296      * Returns a boolean value indicating whether the operation succeeded.
297      *
298      * Emits a {Transfer} event.
299      */
300     function transfer(address recipient, uint256 amount) external returns (bool);
301 
302     /**
303      * @dev Returns the remaining number of tokens that `spender` will be
304      * allowed to spend on behalf of `owner` through {transferFrom}. This is
305      * zero by default.
306      *
307      * This value changes when {approve} or {transferFrom} are called.
308      */
309     function allowance(address owner, address spender) external view returns (uint256);
310 
311     /**
312      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
313      *
314      * Returns a boolean value indicating whether the operation succeeded.
315      *
316      * IMPORTANT: Beware that changing an allowance with this method brings the risk
317      * that someone may use both the old and the new allowance by unfortunate
318      * transaction ordering. One possible solution to mitigate this race
319      * condition is to first reduce the spender's allowance to 0 and set the
320      * desired value afterwards:
321      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
322      *
323      * Emits an {Approval} event.
324      */
325     function approve(address spender, uint256 amount) external returns (bool);
326 
327     /**
328      * @dev Moves `amount` tokens from `sender` to `recipient` using the
329      * allowance mechanism. `amount` is then deducted from the caller's
330      * allowance.
331      *
332      * Returns a boolean value indicating whether the operation succeeded.
333      *
334      * Emits a {Transfer} event.
335      */
336     function transferFrom(
337         address sender,
338         address recipient,
339         uint256 amount
340     ) external returns (bool);
341 
342     /**
343      * @dev Emitted when `value` tokens are moved from one account (`from`) to
344      * another (`to`).
345      *
346      * Note that `value` may be zero.
347      */
348     event Transfer(address indexed from, address indexed to, uint256 value);
349 
350     /**
351      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
352      * a call to {approve}. `value` is the new allowance.
353      */
354     event Approval(address indexed owner, address indexed spender, uint256 value);
355 }
356 
357 
358 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
359 
360 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 /**
365  * @dev Provides information about the current execution context, including the
366  * sender of the transaction and its data. While these are generally available
367  * via msg.sender and msg.data, they should not be accessed in such a direct
368  * manner, since when dealing with meta-transactions the account sending and
369  * paying for execution may not be the actual sender (as far as an application
370  * is concerned).
371  *
372  * This contract is only required for intermediate, library-like contracts.
373  */
374 abstract contract Context {
375     function _msgSender() internal view virtual returns (address) {
376         return msg.sender;
377     }
378 
379     function _msgData() internal view virtual returns (bytes calldata) {
380         return msg.data;
381     }
382 }
383 
384 
385 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
386 
387 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 /**
392  * @dev Contract module which provides a basic access control mechanism, where
393  * there is an account (an owner) that can be granted exclusive access to
394  * specific functions.
395  *
396  * By default, the owner account will be the one that deploys the contract. This
397  * can later be changed with {transferOwnership}.
398  *
399  * This module is used through inheritance. It will make available the modifier
400  * `onlyOwner`, which can be applied to your functions to restrict their use to
401  * the owner.
402  */
403 abstract contract Ownable is Context {
404     address private _owner;
405 
406     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
407 
408     /**
409      * @dev Initializes the contract setting the deployer as the initial owner.
410      */
411     constructor() {
412         _transferOwnership(_msgSender());
413     }
414 
415     /**
416      * @dev Returns the address of the current owner.
417      */
418     function owner() public view virtual returns (address) {
419         return _owner;
420     }
421 
422     /**
423      * @dev Throws if called by any account other than the owner.
424      */
425     modifier onlyOwner() {
426         require(owner() == _msgSender(), "Ownable: caller is not the owner");
427         _;
428     }
429 
430     /**
431      * @dev Leaves the contract without owner. It will not be possible to call
432      * `onlyOwner` functions anymore. Can only be called by the current owner.
433      *
434      * NOTE: Renouncing ownership will leave the contract without an owner,
435      * thereby removing any functionality that is only available to the owner.
436      */
437     function renounceOwnership() public virtual onlyOwner {
438         _transferOwnership(address(0));
439     }
440 
441     /**
442      * @dev Transfers ownership of the contract to a new account (`newOwner`).
443      * Can only be called by the current owner.
444      */
445     function transferOwnership(address newOwner) public virtual onlyOwner {
446         require(newOwner != address(0), "Ownable: new owner is the zero address");
447         _transferOwnership(newOwner);
448     }
449 
450     /**
451      * @dev Transfers ownership of the contract to a new account (`newOwner`).
452      * Internal function without access restriction.
453      */
454     function _transferOwnership(address newOwner) internal virtual {
455         address oldOwner = _owner;
456         _owner = newOwner;
457         emit OwnershipTransferred(oldOwner, newOwner);
458     }
459 }
460 
461 
462 // File contracts/OwnerWithdrawable.sol
463 
464 pragma solidity ^0.8.0;
465 
466 
467 
468 contract OwnerWithdrawable is Ownable {
469     using SafeMath for uint256;
470     using SafeERC20 for IERC20;
471 
472     receive() external payable {}
473 
474     fallback() external payable {}
475 
476     function withdraw(address token, uint256 amt) public onlyOwner {
477         IERC20(token).safeTransfer(msg.sender, amt);
478     }
479 
480     function withdrawAll(address token) public onlyOwner {
481         uint256 amt = IERC20(token).balanceOf(address(this));
482         withdraw(token, amt);
483     }
484 
485     function withdrawCurrency(uint256 amt) public onlyOwner {
486         payable(msg.sender).transfer(amt);
487     }
488 
489     // function deposit(address token, uint256 amt) public onlyOwner {
490     //     uint256 allowance = IERC20(token).allowance(msg.sender, address(this));
491     //     require(allowance >= amt, "Check the token allowance");
492     //     IERC20(token).transferFrom(owner(), address(this), amt);
493     // }
494 }
495 
496 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
497 
498 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Collection of functions related to the address type
504  */
505 library Address {
506     /**
507      * @dev Returns true if `account` is a contract.
508      *
509      * [IMPORTANT]
510      * ====
511      * It is unsafe to assume that an address for which this function returns
512      * false is an externally-owned account (EOA) and not a contract.
513      *
514      * Among others, `isContract` will return false for the following
515      * types of addresses:
516      *
517      *  - an externally-owned account
518      *  - a contract in construction
519      *  - an address where a contract will be created
520      *  - an address where a contract lived, but was destroyed
521      * ====
522      */
523     function isContract(address account) internal view returns (bool) {
524         // This method relies on extcodesize, which returns 0 for contracts in
525         // construction, since the code is only stored at the end of the
526         // constructor execution.
527 
528         uint256 size;
529         assembly {
530             size := extcodesize(account)
531         }
532         return size > 0;
533     }
534 
535     /**
536      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
537      * `recipient`, forwarding all available gas and reverting on errors.
538      *
539      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
540      * of certain opcodes, possibly making contracts go over the 2300 gas limit
541      * imposed by `transfer`, making them unable to receive funds via
542      * `transfer`. {sendValue} removes this limitation.
543      *
544      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
545      *
546      * IMPORTANT: because control is transferred to `recipient`, care must be
547      * taken to not create reentrancy vulnerabilities. Consider using
548      * {ReentrancyGuard} or the
549      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
550      */
551     function sendValue(address payable recipient, uint256 amount) internal {
552         require(address(this).balance >= amount, "Address: insufficient balance");
553 
554         (bool success, ) = recipient.call{value: amount}("");
555         require(success, "Address: unable to send value, recipient may have reverted");
556     }
557 
558     /**
559      * @dev Performs a Solidity function call using a low level `call`. A
560      * plain `call` is an unsafe replacement for a function call: use this
561      * function instead.
562      *
563      * If `target` reverts with a revert reason, it is bubbled up by this
564      * function (like regular Solidity function calls).
565      *
566      * Returns the raw returned data. To convert to the expected return value,
567      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
568      *
569      * Requirements:
570      *
571      * - `target` must be a contract.
572      * - calling `target` with `data` must not revert.
573      *
574      * _Available since v3.1._
575      */
576     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
577         return functionCall(target, data, "Address: low-level call failed");
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
582      * `errorMessage` as a fallback revert reason when `target` reverts.
583      *
584      * _Available since v3.1._
585      */
586     function functionCall(
587         address target,
588         bytes memory data,
589         string memory errorMessage
590     ) internal returns (bytes memory) {
591         return functionCallWithValue(target, data, 0, errorMessage);
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
596      * but also transferring `value` wei to `target`.
597      *
598      * Requirements:
599      *
600      * - the calling contract must have an ETH balance of at least `value`.
601      * - the called Solidity function must be `payable`.
602      *
603      * _Available since v3.1._
604      */
605     function functionCallWithValue(
606         address target,
607         bytes memory data,
608         uint256 value
609     ) internal returns (bytes memory) {
610         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
615      * with `errorMessage` as a fallback revert reason when `target` reverts.
616      *
617      * _Available since v3.1._
618      */
619     function functionCallWithValue(
620         address target,
621         bytes memory data,
622         uint256 value,
623         string memory errorMessage
624     ) internal returns (bytes memory) {
625         require(address(this).balance >= value, "Address: insufficient balance for call");
626         require(isContract(target), "Address: call to non-contract");
627 
628         (bool success, bytes memory returndata) = target.call{value: value}(data);
629         return verifyCallResult(success, returndata, errorMessage);
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
634      * but performing a static call.
635      *
636      * _Available since v3.3._
637      */
638     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
639         return functionStaticCall(target, data, "Address: low-level static call failed");
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
644      * but performing a static call.
645      *
646      * _Available since v3.3._
647      */
648     function functionStaticCall(
649         address target,
650         bytes memory data,
651         string memory errorMessage
652     ) internal view returns (bytes memory) {
653         require(isContract(target), "Address: static call to non-contract");
654 
655         (bool success, bytes memory returndata) = target.staticcall(data);
656         return verifyCallResult(success, returndata, errorMessage);
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
661      * but performing a delegate call.
662      *
663      * _Available since v3.4._
664      */
665     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
666         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
671      * but performing a delegate call.
672      *
673      * _Available since v3.4._
674      */
675     function functionDelegateCall(
676         address target,
677         bytes memory data,
678         string memory errorMessage
679     ) internal returns (bytes memory) {
680         require(isContract(target), "Address: delegate call to non-contract");
681 
682         (bool success, bytes memory returndata) = target.delegatecall(data);
683         return verifyCallResult(success, returndata, errorMessage);
684     }
685 
686     /**
687      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
688      * revert reason using the provided one.
689      *
690      * _Available since v4.3._
691      */
692     function verifyCallResult(
693         bool success,
694         bytes memory returndata,
695         string memory errorMessage
696     ) internal pure returns (bytes memory) {
697         if (success) {
698             return returndata;
699         } else {
700             // Look for revert reason and bubble it up if present
701             if (returndata.length > 0) {
702                 // The easiest way to bubble the revert reason is using memory via assembly
703 
704                 assembly {
705                     let returndata_size := mload(returndata)
706                     revert(add(32, returndata), returndata_size)
707                 }
708             } else {
709                 revert(errorMessage);
710             }
711         }
712     }
713 }
714 
715 
716 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.4.2
717 
718 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 
723 /**
724  * @title SafeERC20
725  * @dev Wrappers around ERC20 operations that throw on failure (when the token
726  * contract returns false). Tokens that return no value (and instead revert or
727  * throw on failure) are also supported, non-reverting calls are assumed to be
728  * successful.
729  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
730  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
731  */
732 library SafeERC20 {
733     using Address for address;
734 
735     function safeTransfer(
736         IERC20 token,
737         address to,
738         uint256 value
739     ) internal {
740         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
741     }
742 
743     function safeTransferFrom(
744         IERC20 token,
745         address from,
746         address to,
747         uint256 value
748     ) internal {
749         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
750     }
751 
752     /**
753      * @dev Deprecated. This function has issues similar to the ones found in
754      * {IERC20-approve}, and its usage is discouraged.
755      *
756      * Whenever possible, use {safeIncreaseAllowance} and
757      * {safeDecreaseAllowance} instead.
758      */
759     function safeApprove(
760         IERC20 token,
761         address spender,
762         uint256 value
763     ) internal {
764         // safeApprove should only be called when setting an initial allowance,
765         // or when resetting it to zero. To increase and decrease it, use
766         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
767         require(
768             (value == 0) || (token.allowance(address(this), spender) == 0),
769             "SafeERC20: approve from non-zero to non-zero allowance"
770         );
771         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
772     }
773 
774     function safeIncreaseAllowance(
775         IERC20 token,
776         address spender,
777         uint256 value
778     ) internal {
779         uint256 newAllowance = token.allowance(address(this), spender) + value;
780         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
781     }
782 
783     function safeDecreaseAllowance(
784         IERC20 token,
785         address spender,
786         uint256 value
787     ) internal {
788         unchecked {
789             uint256 oldAllowance = token.allowance(address(this), spender);
790             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
791             uint256 newAllowance = oldAllowance - value;
792             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
793         }
794     }
795 
796     /**
797      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
798      * on the return value: the return value is optional (but if data is returned, it must not be false).
799      * @param token The token targeted by the call.
800      * @param data The call data (encoded using abi.encode or one of its variants).
801      */
802     function _callOptionalReturn(IERC20 token, bytes memory data) private {
803         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
804         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
805         // the target address contains contract code and also asserts for success in the low-level call.
806 
807         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
808         if (returndata.length > 0) {
809             // Return data is optional
810             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
811         }
812     }
813 }
814 
815 
816 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.2
817 
818 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
819 
820 pragma solidity ^0.8.0;
821 
822 /**
823  * @dev Interface for the optional metadata functions from the ERC20 standard.
824  *
825  * _Available since v4.1._
826  */
827 interface IERC20Metadata is IERC20 {
828     /**
829      * @dev Returns the name of the token.
830      */
831     function name() external view returns (string memory);
832 
833     /**
834      * @dev Returns the symbol of the token.
835      */
836     function symbol() external view returns (string memory);
837 
838     /**
839      * @dev Returns the decimals places of the token.
840      */
841     function decimals() external view returns (uint8);
842 }
843 
844 // File contracts/PreSale.sol
845 // SPDX-License-Identifier: MIT
846 // import "hardhat/console.sol";
847 pragma solidity ^0.8.0;
848 
849 contract WNEONPresale is OwnerWithdrawable {
850     using SafeMath for uint256;
851     using SafeERC20 for IERC20;
852     using SafeERC20 for IERC20Metadata;
853 
854     address immutable USDT =  0xdAC17F958D2ee523a2206206994597C13D831ec7; // mainnet
855 
856     AggregatorV3Interface internal priceFeed;
857 
858     //Rate wrt to Native Currency of the chain
859     bool public isEthAutomaticRate;
860     uint256[3] public rate;
861 
862     // Token for which presale is being done
863     address public saleToken;
864     uint public saleTokenDec;
865 
866     //Total tokens to be sold in the presale
867     uint256[3] public totalTokensforSale;
868     uint256[3] public maxBuyLimit;
869     uint256 public minBuyLimit; // Minimum amount of tokens to buy per transaction
870 
871     // Whitelist of tokens to buy from
872     mapping(address => bool) public tokenWL;
873 
874     // 1 Token price in terms of WL tokens
875     mapping(address => uint256[3]) public tokenPrices;
876 
877     //1st locking period for the Token
878     // uint256[4] public lockingPeriods;
879 
880     //locking period for the Token
881     uint256 public lockingPeriod;
882 
883 
884     //Percentage of Tokens available after 1st locking period
885     // uint256[4] public percentTokens;
886 
887     // List of Buyers
888     address[] public buyers;
889 
890     bool public isPresaleStarted;
891     uint256 public presaleEndTime;
892 
893     uint public presalePhase;
894     uint public maxUSDT;
895 
896     // Amounts bought by buyers
897     mapping(address => BuyerTokenDetails) public buyersAmount;
898     mapping(address => uint256[3]) public presaleData;
899 
900     //
901     // Statistics
902     //
903     uint256[3] public totalTokensSold;
904 
905     struct BuyerTokenDetails {
906         uint amount;
907         bool isClaimed;
908     }
909 
910     constructor() {
911         priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419); // mainnet
912     }
913 
914     //modifier to check if the sale has already started
915     modifier saleStarted(){
916         require (!isPresaleStarted, "PreSale: Sale has already started");
917         _;
918     }
919 
920     //function to set information of Token sold in Pre-Sale and its rate in Native currency
921     function setSaleTokenParams(
922         address _saleToken, uint256[3] calldata _totalTokensforSale
923     )external onlyOwner saleStarted{
924         saleToken = _saleToken;
925         saleTokenDec = IERC20Metadata(saleToken).decimals();
926         totalTokensforSale = _totalTokensforSale;
927         uint deposit;
928         for (uint i = 0; i < 3; i++) {
929             deposit = deposit.add(totalTokensforSale[i]);
930         }
931         IERC20(saleToken).safeTransferFrom(msg.sender, address(this), deposit);
932     }
933 
934     //function to set Pre-Sale duration and locking periods
935     function setLockingPeriod(uint _lockingPeriod) external onlyOwner saleStarted {        
936         lockingPeriod = _lockingPeriod;
937     }
938 
939     // Add a token to buy presale token from, with price
940     function addWhiteListedToken(
941         address _token,
942         uint256[3] calldata _prices
943     ) external onlyOwner {
944         tokenWL[_token] = true;
945         for (uint256 i = 0; i < _prices.length; i++) {
946             require(_prices[i] != 0, "Presale: Cannot set price to 0");
947         }
948         tokenPrices[_token] = _prices;
949         if(_token == USDT){
950             _setLimits(maxUSDT);
951         }
952     }
953 
954     function updateEthRate(uint[3] calldata _rate) external  onlyOwner {
955         rate = _rate;
956     }
957 
958     function updateTokenRate(
959         address _token,
960         uint256[3] memory _prices
961     )external onlyOwner{
962         require(tokenWL[_token], "Presale: Token not whitelisted");
963         for (uint256 i = 0; i < _prices.length; i++) {
964             require(_prices[i] != 0, "Presale: Cannot set price to 0");
965         }
966         tokenPrices[_token] = _prices;
967         if(_token == USDT){
968             _setLimits(maxUSDT);
969         }
970     }
971 
972     function toggleEthAutomaticRate() external onlyOwner {
973         isEthAutomaticRate = !isEthAutomaticRate;
974     }
975 
976     function startPresale(uint256 _presaleEndTime) external onlyOwner {
977         require(!isPresaleStarted, "PreSale: Sale has already started");
978         isPresaleStarted = true;
979         presaleEndTime = _presaleEndTime;
980     }
981 
982     function startSalePhase1() external onlyOwner {
983         require(isPresaleStarted, "PreSale: Sale hasn't started yet!");
984         presalePhase = 0;
985     }
986 
987     function startSalePhase2() external onlyOwner {
988         require(isPresaleStarted, "PreSale: Sale hasn't started yet!");
989         presalePhase = 1;
990     }
991 
992     function startSalePhase3() external onlyOwner {
993         require(isPresaleStarted, "PreSale: Sale hasn't started yet!");
994         presalePhase = 2;
995     }
996 
997     // Stop the Sale 
998     function stopSale() external onlyOwner {
999         require(isPresaleStarted, "PreSale: Sale hasn't started yet!");
1000         isPresaleStarted = false;
1001     }
1002 
1003     // Public view function to calculate amount of sale tokens returned if you buy using "amount" of "token"
1004     function getTokenAmount(address token, uint256 amount)
1005         public
1006         view
1007         returns (uint256)
1008     {
1009         if(!isPresaleStarted) {
1010             return 0;
1011         }
1012         uint256 amtOut;
1013         if(token != address(0)){
1014             require(tokenWL[token] == true, "Presale: Token not whitelisted");
1015             // uint tokenDec = IERC20(token).decimals();
1016             uint256 price = tokenPrices[token][presalePhase];
1017             amtOut = amount.mul(10**saleTokenDec).div(price);
1018         }
1019         else{
1020             if (isEthAutomaticRate) {
1021                 (, int256 price, , , ) = priceFeed.latestRoundData();
1022                 amtOut = amount.mul(tokenPrices[USDT][presalePhase]).div(10**6).mul(10**saleTokenDec).div(uint(price).mul(10**10));
1023             } else {
1024                 amtOut = amount.mul(10**saleTokenDec).div(rate[presalePhase]);
1025             }
1026         }
1027         return amtOut;
1028     }
1029 
1030     // Public Function to buy tokens. APPROVAL needs to be done first
1031     function buyToken(address _token, uint256 _amount) external payable{
1032         require(isPresaleStarted, "PreSale: Sale hasn't started yet!");
1033         require(block.timestamp < presaleEndTime, "PreSale: presale has ended, cannot buy");
1034         if (totalTokensforSale[presalePhase] < totalTokensSold[presalePhase] + minBuyLimit) {
1035             if (presalePhase < 2) {
1036                 presalePhase++;
1037             }
1038             else {
1039                 revert("PreSale: Total Token Sale Reached for all phases!");
1040             }
1041         }
1042         uint256 saleTokenAmt;
1043         if(_token != address(0)){
1044             require(_amount > 0, "Presale: Cannot buy with zero amount");
1045             require(tokenWL[_token] == true, "Presale: Token not whitelisted");
1046 
1047             saleTokenAmt = getTokenAmount(_token, _amount);
1048 
1049             // check if saleTokenAmt is greater than minBuyLimit
1050             require(saleTokenAmt >= minBuyLimit, "Presale: Min buy limit not reached");
1051             require((totalTokensSold[presalePhase] + saleTokenAmt) <= totalTokensforSale[presalePhase], "PreSale: Total Token Sale Reached!");
1052 
1053             IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
1054         }
1055         else{
1056             saleTokenAmt = getTokenAmount(address(0), msg.value);
1057 
1058             // check if saleTokenAmt is greater than minBuyLimit
1059             require(saleTokenAmt >= minBuyLimit, "Presale: Min buy limit not reached");
1060             require((totalTokensSold[presalePhase] + saleTokenAmt) <= totalTokensforSale[presalePhase], "PreSale: Total Token Sale Reached!");
1061         }
1062         require(presaleData[msg.sender][presalePhase] + saleTokenAmt <= maxBuyLimit[presalePhase], "Presale: Max buy limit reached for this phase");
1063         totalTokensSold[presalePhase] += saleTokenAmt;
1064         buyersAmount[msg.sender].amount += saleTokenAmt;
1065         presaleData[msg.sender][presalePhase] += saleTokenAmt; 
1066     }
1067 
1068     function withdrawToken() external {
1069         uint256 tokensforWithdraw;
1070         require(buyersAmount[msg.sender].isClaimed == false, "Presale: Already claimed");
1071         require(block.timestamp > lockingPeriod, "Presale: Locking period not over yet");
1072         tokensforWithdraw = buyersAmount[msg.sender].amount;
1073         buyersAmount[msg.sender].isClaimed = true;
1074         IERC20(saleToken).safeTransfer(msg.sender, tokensforWithdraw);
1075     }
1076 
1077     function setMaxUSDT(uint _maxUSDT) external onlyOwner {
1078         maxUSDT = _maxUSDT;
1079         _setLimits(_maxUSDT);
1080     }
1081 
1082     function setMinBuyLimit(uint _minBuyLimit) external onlyOwner {
1083         minBuyLimit = _minBuyLimit;
1084     }
1085 
1086     function _setLimits(uint _usdtAmount) internal {
1087         maxBuyLimit[0] = _usdtAmount.mul(10**saleTokenDec).div(tokenPrices[USDT][0]);
1088         maxBuyLimit[1] = _usdtAmount.mul(10**saleTokenDec).div(tokenPrices[USDT][1]);
1089         maxBuyLimit[2] = _usdtAmount.mul(10**saleTokenDec).div(tokenPrices[USDT][2]);
1090     }
1091 
1092     function getAllTotalTokensSold() external view returns(uint256[3] memory){
1093         return totalTokensSold;
1094     }
1095 
1096     function getAllTotalTokensForSale() external view returns(uint256[3] memory){
1097         return totalTokensforSale;
1098     }
1099 }