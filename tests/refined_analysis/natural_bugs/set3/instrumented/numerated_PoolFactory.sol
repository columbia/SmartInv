1 // SPDX-License-Identifier: MIT
2 
3 /**
4  *Submitted for verification at BscScan.com on 2021-05-05
5 */
6 
7 // File: @openzeppelin/contracts/utils/Context.sol
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity >=0.6.0 <0.8.0;
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with GSN meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 // File: @openzeppelin/contracts/access/Ownable.sol
35 
36 //pragma solidity >=0.6.0 <0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         emit OwnershipTransferred(_owner, newOwner);
98         _owner = newOwner;
99     }
100 }
101 
102 // File: bsc-library/contracts/IBEP20.sol
103 
104 //pragma solidity >=0.4.0;
105 
106 interface IBEP20 {
107     /**
108      * @dev Returns the amount of tokens in existence.
109      */
110     function totalSupply() external view returns (uint256);
111 
112     /**
113      * @dev Returns the token decimals.
114      */
115     function decimals() external view returns (uint8);
116 
117     /**
118      * @dev Returns the token symbol.
119      */
120     function symbol() external view returns (string memory);
121 
122     /**
123      * @dev Returns the token name.
124      */
125     function name() external view returns (string memory);
126 
127     /**
128      * @dev Returns the bep token owner.
129      */
130     function getOwner() external view returns (address);
131 
132     /**
133      * @dev Returns the amount of tokens owned by `account`.
134      */
135     function balanceOf(address account) external view returns (uint256);
136 
137     /**
138      * @dev Moves `amount` tokens from the caller's account to `recipient`.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transfer(address recipient, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Returns the remaining number of tokens that `spender` will be
148      * allowed to spend on behalf of `owner` through {transferFrom}. This is
149      * zero by default.
150      *
151      * This value changes when {approve} or {transferFrom} are called.
152      */
153     function allowance(address _owner, address spender) external view returns (uint256);
154 
155     /**
156      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * IMPORTANT: Beware that changing an allowance with this method brings the risk
161      * that someone may use both the old and the new allowance by unfortunate
162      * transaction ordering. One possible solution to mitigate this race
163      * condition is to first reduce the spender's allowance to 0 and set the
164      * desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      *
167      * Emits an {Approval} event.
168      */
169     function approve(address spender, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Moves `amount` tokens from `sender` to `recipient` using the
173      * allowance mechanism. `amount` is then deducted from the caller's
174      * allowance.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transferFrom(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) external returns (bool);
185 
186     /**
187      * @dev Emitted when `value` tokens are moved from one account (`from`) to
188      * another (`to`).
189      *
190      * Note that `value` may be zero.
191      */
192     event Transfer(address indexed from, address indexed to, uint256 value);
193 
194     /**
195      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
196      * a call to {approve}. `value` is the new allowance.
197      */
198     event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 // File: @openzeppelin/contracts/math/SafeMath.sol
202 
203 //pragma solidity >=0.6.0 <0.8.0;
204 
205 /**
206  * @dev Wrappers over Solidity's arithmetic operations with added overflow
207  * checks.
208  *
209  * Arithmetic operations in Solidity wrap on overflow. This can easily result
210  * in bugs, because programmers usually assume that an overflow raises an
211  * error, which is the standard behavior in high level programming languages.
212  * `SafeMath` restores this intuition by reverting the transaction when an
213  * operation overflows.
214  *
215  * Using this library instead of the unchecked operations eliminates an entire
216  * class of bugs, so it's recommended to use it always.
217  */
218 library SafeMath {
219     /**
220      * @dev Returns the addition of two unsigned integers, with an overflow flag.
221      *
222      * _Available since v3.4._
223      */
224     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         uint256 c = a + b;
226         if (c < a) return (false, 0);
227         return (true, c);
228     }
229 
230     /**
231      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
232      *
233      * _Available since v3.4._
234      */
235     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
236         if (b > a) return (false, 0);
237         return (true, a - b);
238     }
239 
240     /**
241      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
242      *
243      * _Available since v3.4._
244      */
245     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
246         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
247         // benefit is lost if 'b' is also tested.
248         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
249         if (a == 0) return (true, 0);
250         uint256 c = a * b;
251         if (c / a != b) return (false, 0);
252         return (true, c);
253     }
254 
255     /**
256      * @dev Returns the division of two unsigned integers, with a division by zero flag.
257      *
258      * _Available since v3.4._
259      */
260     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         if (b == 0) return (false, 0);
262         return (true, a / b);
263     }
264 
265     /**
266      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
267      *
268      * _Available since v3.4._
269      */
270     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
271         if (b == 0) return (false, 0);
272         return (true, a % b);
273     }
274 
275     /**
276      * @dev Returns the addition of two unsigned integers, reverting on
277      * overflow.
278      *
279      * Counterpart to Solidity's `+` operator.
280      *
281      * Requirements:
282      *
283      * - Addition cannot overflow.
284      */
285     function add(uint256 a, uint256 b) internal pure returns (uint256) {
286         uint256 c = a + b;
287         require(c >= a, "SafeMath: addition overflow");
288         return c;
289     }
290 
291     /**
292      * @dev Returns the subtraction of two unsigned integers, reverting on
293      * overflow (when the result is negative).
294      *
295      * Counterpart to Solidity's `-` operator.
296      *
297      * Requirements:
298      *
299      * - Subtraction cannot overflow.
300      */
301     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
302         require(b <= a, "SafeMath: subtraction overflow");
303         return a - b;
304     }
305 
306     /**
307      * @dev Returns the multiplication of two unsigned integers, reverting on
308      * overflow.
309      *
310      * Counterpart to Solidity's `*` operator.
311      *
312      * Requirements:
313      *
314      * - Multiplication cannot overflow.
315      */
316     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
317         if (a == 0) return 0;
318         uint256 c = a * b;
319         require(c / a == b, "SafeMath: multiplication overflow");
320         return c;
321     }
322 
323     /**
324      * @dev Returns the integer division of two unsigned integers, reverting on
325      * division by zero. The result is rounded towards zero.
326      *
327      * Counterpart to Solidity's `/` operator. Note: this function uses a
328      * `revert` opcode (which leaves remaining gas untouched) while Solidity
329      * uses an invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      *
333      * - The divisor cannot be zero.
334      */
335     function div(uint256 a, uint256 b) internal pure returns (uint256) {
336         require(b > 0, "SafeMath: division by zero");
337         return a / b;
338     }
339 
340     /**
341      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
342      * reverting when dividing by zero.
343      *
344      * Counterpart to Solidity's `%` operator. This function uses a `revert`
345      * opcode (which leaves remaining gas untouched) while Solidity uses an
346      * invalid opcode to revert (consuming all remaining gas).
347      *
348      * Requirements:
349      *
350      * - The divisor cannot be zero.
351      */
352     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
353         require(b > 0, "SafeMath: modulo by zero");
354         return a % b;
355     }
356 
357     /**
358      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
359      * overflow (when the result is negative).
360      *
361      * CAUTION: This function is deprecated because it requires allocating memory for the error
362      * message unnecessarily. For custom revert reasons use {trySub}.
363      *
364      * Counterpart to Solidity's `-` operator.
365      *
366      * Requirements:
367      *
368      * - Subtraction cannot overflow.
369      */
370     function sub(
371         uint256 a,
372         uint256 b,
373         string memory errorMessage
374     ) internal pure returns (uint256) {
375         require(b <= a, errorMessage);
376         return a - b;
377     }
378 
379     /**
380      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
381      * division by zero. The result is rounded towards zero.
382      *
383      * CAUTION: This function is deprecated because it requires allocating memory for the error
384      * message unnecessarily. For custom revert reasons use {tryDiv}.
385      *
386      * Counterpart to Solidity's `/` operator. Note: this function uses a
387      * `revert` opcode (which leaves remaining gas untouched) while Solidity
388      * uses an invalid opcode to revert (consuming all remaining gas).
389      *
390      * Requirements:
391      *
392      * - The divisor cannot be zero.
393      */
394     function div(
395         uint256 a,
396         uint256 b,
397         string memory errorMessage
398     ) internal pure returns (uint256) {
399         require(b > 0, errorMessage);
400         return a / b;
401     }
402 
403     /**
404      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
405      * reverting with custom message when dividing by zero.
406      *
407      * CAUTION: This function is deprecated because it requires allocating memory for the error
408      * message unnecessarily. For custom revert reasons use {tryMod}.
409      *
410      * Counterpart to Solidity's `%` operator. This function uses a `revert`
411      * opcode (which leaves remaining gas untouched) while Solidity uses an
412      * invalid opcode to revert (consuming all remaining gas).
413      *
414      * Requirements:
415      *
416      * - The divisor cannot be zero.
417      */
418     function mod(
419         uint256 a,
420         uint256 b,
421         string memory errorMessage
422     ) internal pure returns (uint256) {
423         require(b > 0, errorMessage);
424         return a % b;
425     }
426 }
427 
428 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
429 
430 //pragma solidity >=0.6.0 <0.8.0;
431 
432 /**
433  * @dev Contract module that helps prevent reentrant calls to a function.
434  *
435  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
436  * available, which can be applied to functions to make sure there are no nested
437  * (reentrant) calls to them.
438  *
439  * Note that because there is a single `nonReentrant` guard, functions marked as
440  * `nonReentrant` may not call one another. This can be worked around by making
441  * those functions `private`, and then adding `external` `nonReentrant` entry
442  * points to them.
443  *
444  * TIP: If you would like to learn more about reentrancy and alternative ways
445  * to protect against it, check out our blog post
446  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
447  */
448 abstract contract ReentrancyGuard {
449     // Booleans are more expensive than uint256 or any type that takes up a full
450     // word because each write operation emits an extra SLOAD to first read the
451     // slot's contents, replace the bits taken up by the boolean, and then write
452     // back. This is the compiler's defense against contract upgrades and
453     // pointer aliasing, and it cannot be disabled.
454 
455     // The values being non-zero value makes deployment a bit more expensive,
456     // but in exchange the refund on every call to nonReentrant will be lower in
457     // amount. Since refunds are capped to a percentage of the total
458     // transaction's gas, it is best to keep them low in cases like this one, to
459     // increase the likelihood of the full refund coming into effect.
460     uint256 private constant _NOT_ENTERED = 1;
461     uint256 private constant _ENTERED = 2;
462 
463     uint256 private _status;
464 
465     constructor() {
466         _status = _NOT_ENTERED;
467     }
468 
469     /**
470      * @dev Prevents a contract from calling itself, directly or indirectly.
471      * Calling a `nonReentrant` function from another `nonReentrant`
472      * function is not supported. It is possible to prevent this from happening
473      * by making the `nonReentrant` function external, and make it call a
474      * `private` function that does the actual work.
475      */
476     modifier nonReentrant() {
477         // On the first call to nonReentrant, _notEntered will be true
478         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
479 
480         // Any calls to nonReentrant after this point will fail
481         _status = _ENTERED;
482 
483         _;
484 
485         // By storing the original value once again, a refund is triggered (see
486         // https://eips.ethereum.org/EIPS/eip-2200)
487         _status = _NOT_ENTERED;
488     }
489 }
490 
491 // File: @openzeppelin/contracts/utils/Address.sol
492 
493 //pragma solidity >=0.6.2 <0.8.0;
494 
495 /**
496  * @dev Collection of functions related to the address type
497  */
498 library Address {
499     /**
500      * @dev Returns true if `account` is a contract.
501      *
502      * [IMPORTANT]
503      * ====
504      * It is unsafe to assume that an address for which this function returns
505      * false is an externally-owned account (EOA) and not a contract.
506      *
507      * Among others, `isContract` will return false for the following
508      * types of addresses:
509      *
510      *  - an externally-owned account
511      *  - a contract in construction
512      *  - an address where a contract will be created
513      *  - an address where a contract lived, but was destroyed
514      * ====
515      */
516     function isContract(address account) internal view returns (bool) {
517         // This method relies on extcodesize, which returns 0 for contracts in
518         // construction, since the code is only stored at the end of the
519         // constructor execution.
520 
521         uint256 size;
522         // solhint-disable-next-line no-inline-assembly
523         assembly {
524             size := extcodesize(account)
525         }
526         return size > 0;
527     }
528 
529     /**
530      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
531      * `recipient`, forwarding all available gas and reverting on errors.
532      *
533      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
534      * of certain opcodes, possibly making contracts go over the 2300 gas limit
535      * imposed by `transfer`, making them unable to receive funds via
536      * `transfer`. {sendValue} removes this limitation.
537      *
538      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
539      *
540      * IMPORTANT: because control is transferred to `recipient`, care must be
541      * taken to not create reentrancy vulnerabilities. Consider using
542      * {ReentrancyGuard} or the
543      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
544      */
545     function sendValue(address payable recipient, uint256 amount) internal {
546         require(address(this).balance >= amount, "Address: insufficient balance");
547 
548         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
549         (bool success, ) = recipient.call{value: amount}("");
550         require(success, "Address: unable to send value, recipient may have reverted");
551     }
552 
553     /**
554      * @dev Performs a Solidity function call using a low level `call`. A
555      * plain`call` is an unsafe replacement for a function call: use this
556      * function instead.
557      *
558      * If `target` reverts with a revert reason, it is bubbled up by this
559      * function (like regular Solidity function calls).
560      *
561      * Returns the raw returned data. To convert to the expected return value,
562      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
563      *
564      * Requirements:
565      *
566      * - `target` must be a contract.
567      * - calling `target` with `data` must not revert.
568      *
569      * _Available since v3.1._
570      */
571     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
572         return functionCall(target, data, "Address: low-level call failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
577      * `errorMessage` as a fallback revert reason when `target` reverts.
578      *
579      * _Available since v3.1._
580      */
581     function functionCall(
582         address target,
583         bytes memory data,
584         string memory errorMessage
585     ) internal returns (bytes memory) {
586         return functionCallWithValue(target, data, 0, errorMessage);
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
591      * but also transferring `value` wei to `target`.
592      *
593      * Requirements:
594      *
595      * - the calling contract must have an ETH balance of at least `value`.
596      * - the called Solidity function must be `payable`.
597      *
598      * _Available since v3.1._
599      */
600     function functionCallWithValue(
601         address target,
602         bytes memory data,
603         uint256 value
604     ) internal returns (bytes memory) {
605         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
610      * with `errorMessage` as a fallback revert reason when `target` reverts.
611      *
612      * _Available since v3.1._
613      */
614     function functionCallWithValue(
615         address target,
616         bytes memory data,
617         uint256 value,
618         string memory errorMessage
619     ) internal returns (bytes memory) {
620         require(address(this).balance >= value, "Address: insufficient balance for call");
621         require(isContract(target), "Address: call to non-contract");
622 
623         // solhint-disable-next-line avoid-low-level-calls
624         (bool success, bytes memory returndata) = target.call{value: value}(data);
625         return _verifyCallResult(success, returndata, errorMessage);
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
630      * but performing a static call.
631      *
632      * _Available since v3.3._
633      */
634     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
635         return functionStaticCall(target, data, "Address: low-level static call failed");
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
640      * but performing a static call.
641      *
642      * _Available since v3.3._
643      */
644     function functionStaticCall(
645         address target,
646         bytes memory data,
647         string memory errorMessage
648     ) internal view returns (bytes memory) {
649         require(isContract(target), "Address: static call to non-contract");
650 
651         // solhint-disable-next-line avoid-low-level-calls
652         (bool success, bytes memory returndata) = target.staticcall(data);
653         return _verifyCallResult(success, returndata, errorMessage);
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
658      * but performing a delegate call.
659      *
660      * _Available since v3.4._
661      */
662     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
663         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
668      * but performing a delegate call.
669      *
670      * _Available since v3.4._
671      */
672     function functionDelegateCall(
673         address target,
674         bytes memory data,
675         string memory errorMessage
676     ) internal returns (bytes memory) {
677         require(isContract(target), "Address: delegate call to non-contract");
678 
679         // solhint-disable-next-line avoid-low-level-calls
680         (bool success, bytes memory returndata) = target.delegatecall(data);
681         return _verifyCallResult(success, returndata, errorMessage);
682     }
683 
684     function _verifyCallResult(
685         bool success,
686         bytes memory returndata,
687         string memory errorMessage
688     ) private pure returns (bytes memory) {
689         if (success) {
690             return returndata;
691         } else {
692             // Look for revert reason and bubble it up if present
693             if (returndata.length > 0) {
694                 // The easiest way to bubble the revert reason is using memory via assembly
695 
696                 // solhint-disable-next-line no-inline-assembly
697                 assembly {
698                     let returndata_size := mload(returndata)
699                     revert(add(32, returndata), returndata_size)
700                 }
701             } else {
702                 revert(errorMessage);
703             }
704         }
705     }
706 }
707 
708 // File: bsc-library/contracts/SafeBEP20.sol
709 
710 //pragma solidity ^0.6.0;
711 
712 /**
713  * @title SafeBEP20
714  * @dev Wrappers around BEP20 operations that throw on failure (when the token
715  * contract returns false). Tokens that return no value (and instead revert or
716  * throw on failure) are also supported, non-reverting calls are assumed to be
717  * successful.
718  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
719  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
720  */
721 library SafeBEP20 {
722     using SafeMath for uint256;
723     using Address for address;
724 
725     function safeTransfer(
726         IBEP20 token,
727         address to,
728         uint256 value
729     ) internal {
730         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
731     }
732 
733     function safeTransferFrom(
734         IBEP20 token,
735         address from,
736         address to,
737         uint256 value
738     ) internal {
739         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
740     }
741 
742     /**
743      * @dev Deprecated. This function has issues similar to the ones found in
744      * {IBEP20-approve}, and its usage is discouraged.
745      *
746      * Whenever possible, use {safeIncreaseAllowance} and
747      * {safeDecreaseAllowance} instead.
748      */
749     function safeApprove(
750         IBEP20 token,
751         address spender,
752         uint256 value
753     ) internal {
754         // safeApprove should only be called when setting an initial allowance,
755         // or when resetting it to zero. To increase and decrease it, use
756         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
757         // solhint-disable-next-line max-line-length
758         require(
759             (value == 0) || (token.allowance(address(this), spender) == 0),
760             "SafeBEP20: approve from non-zero to non-zero allowance"
761         );
762         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
763     }
764 
765     function safeIncreaseAllowance(
766         IBEP20 token,
767         address spender,
768         uint256 value
769     ) internal {
770         uint256 newAllowance = token.allowance(address(this), spender).add(value);
771         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
772     }
773 
774     function safeDecreaseAllowance(
775         IBEP20 token,
776         address spender,
777         uint256 value
778     ) internal {
779         uint256 newAllowance =
780             token.allowance(address(this), spender).sub(value, "SafeBEP20: decreased allowance below zero");
781         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
782     }
783 
784     /**
785      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
786      * on the return value: the return value is optional (but if data is returned, it must not be false).
787      * @param token The token targeted by the call.
788      * @param data The call data (encoded using abi.encode or one of its variants).
789      */
790     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
791         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
792         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
793         // the target address contains contract code and also asserts for success in the low-level call.
794 
795         bytes memory returndata = address(token).functionCall(data, "SafeBEP20: low-level call failed");
796         if (returndata.length > 0) {
797             // Return data is optional
798             // solhint-disable-next-line max-line-length
799             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
800         }
801     }
802 }
803 
804 // File: contracts/SmartChefInitializable.sol
805 
806 //pragma solidity 0.6.12;
807 
808 contract SmartChefInitializable is Ownable, ReentrancyGuard {
809     using SafeMath for uint256;
810     using SafeBEP20 for IBEP20;
811 
812     // The address of the smart chef factory
813     address public SMART_CHEF_FACTORY;
814 
815     // Whether a limit is set for users
816     bool public hasUserLimit;
817 
818     // Whether it is initialized
819     bool public isInitialized;
820 
821     // Accrued token per share
822     uint256 public accTokenPerShare;
823 
824     // The block number when CAKE mining ends.
825     uint256 public bonusEndBlock;
826 
827     // The block number when CAKE mining starts.
828     uint256 public startBlock;
829 
830     // The block number of the last pool update
831     uint256 public lastRewardBlock;
832 
833     // The pool limit (0 if none)
834     uint256 public poolLimitPerUser;
835 
836     // CAKE tokens created per block.
837     uint256 public rewardPerBlock;
838 
839     // The precision factor
840     uint256 public PRECISION_FACTOR;
841 
842     // The reward token
843     IBEP20 public rewardToken;
844 
845     // The staked token
846     IBEP20 public stakedToken;
847 
848     // Info of each user that stakes tokens (stakedToken)
849     mapping(address => UserInfo) public userInfo;
850 
851     struct UserInfo {
852         uint256 amount; // How many staked tokens the user has provided
853         uint256 rewardDebt; // Reward debt
854     }
855 
856     event AdminTokenRecovery(address tokenRecovered, uint256 amount);
857     event Deposit(address indexed user, uint256 amount);
858     event EmergencyWithdraw(address indexed user, uint256 amount);
859     event NewStartAndEndBlocks(uint256 startBlock, uint256 endBlock);
860     event NewRewardPerBlock(uint256 rewardPerBlock);
861     event NewPoolLimit(uint256 poolLimitPerUser);
862     event RewardsStop(uint256 blockNumber);
863     event Withdraw(address indexed user, uint256 amount);
864 
865     constructor() {
866         SMART_CHEF_FACTORY = msg.sender;
867     }
868 
869     /*
870      * @notice Initialize the contract
871      * @param _stakedToken: staked token address
872      * @param _rewardToken: reward token address
873      * @param _rewardPerBlock: reward per block (in rewardToken)
874      * @param _startBlock: start block
875      * @param _bonusEndBlock: end block
876      * @param _poolLimitPerUser: pool limit per user in stakedToken (if any, else 0)
877      * @param _admin: admin address with ownership
878      */
879     function initialize(
880         IBEP20 _stakedToken,
881         IBEP20 _rewardToken,
882         uint256 _rewardPerBlock,
883         uint256 _startBlock,
884         uint256 _bonusEndBlock,
885         uint256 _poolLimitPerUser,
886         address _admin
887     ) external {
888         require(!isInitialized, "Already initialized");
889         require(msg.sender == SMART_CHEF_FACTORY, "Not factory");
890 
891         // Make this contract initialized
892         isInitialized = true;
893 
894         stakedToken = _stakedToken;
895         rewardToken = _rewardToken;
896         rewardPerBlock = _rewardPerBlock;
897         startBlock = _startBlock;
898         bonusEndBlock = _bonusEndBlock;
899 
900         if (_poolLimitPerUser > 0) {
901             hasUserLimit = true;
902             poolLimitPerUser = _poolLimitPerUser;
903         }
904 
905         uint256 decimalsRewardToken = uint256(rewardToken.decimals());
906         require(decimalsRewardToken < 30, "Must be inferior to 30");
907 
908         PRECISION_FACTOR = uint256(10**(uint256(30).sub(decimalsRewardToken)));
909 
910         // Set the lastRewardBlock as the startBlock
911         lastRewardBlock = startBlock;
912 
913         // Transfer ownership to the admin address who becomes owner of the contract
914         transferOwnership(_admin);
915     }
916 
917     /*
918      * @notice Deposit staked tokens and collect reward tokens (if any)
919      * @param _amount: amount to withdraw (in rewardToken)
920      */
921     function deposit(uint256 _amount) external nonReentrant {
922         UserInfo storage user = userInfo[msg.sender];
923 
924         if (hasUserLimit) {
925             require(_amount.add(user.amount) <= poolLimitPerUser, "User amount above limit");
926         }
927 
928         _updatePool();
929 
930         if (user.amount > 0) {
931             uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
932             if (pending > 0) {
933                 rewardToken.safeTransfer(address(msg.sender), pending);
934             }
935         }
936 
937         if (_amount > 0) {
938             user.amount = user.amount.add(_amount);
939             stakedToken.safeTransferFrom(address(msg.sender), address(this), _amount);
940         }
941 
942         user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
943 
944         emit Deposit(msg.sender, _amount);
945     }
946 
947     /*
948      * @notice Withdraw staked tokens and collect reward tokens
949      * @param _amount: amount to withdraw (in rewardToken)
950      */
951     function withdraw(uint256 _amount) external nonReentrant {
952         UserInfo storage user = userInfo[msg.sender];
953         require(user.amount >= _amount, "Amount to withdraw too high");
954 
955         _updatePool();
956 
957         uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
958 
959         if (_amount > 0) {
960             user.amount = user.amount.sub(_amount);
961             stakedToken.safeTransfer(address(msg.sender), _amount);
962         }
963 
964         if (pending > 0) {
965             rewardToken.safeTransfer(address(msg.sender), pending);
966         }
967 
968         user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
969 
970         emit Withdraw(msg.sender, _amount);
971     }
972 
973     /*
974      * @notice Withdraw staked tokens without caring about rewards rewards
975      * @dev Needs to be for emergency.
976      */
977     function emergencyWithdraw() external nonReentrant {
978         UserInfo storage user = userInfo[msg.sender];
979         uint256 amountToTransfer = user.amount;
980         user.amount = 0;
981         user.rewardDebt = 0;
982 
983         if (amountToTransfer > 0) {
984             stakedToken.safeTransfer(address(msg.sender), amountToTransfer);
985         }
986 
987         emit EmergencyWithdraw(msg.sender, amountToTransfer);
988     }
989 
990     /*
991      * @notice Stop rewards
992      * @dev Only callable by owner. Needs to be for emergency.
993      */
994     function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
995         rewardToken.safeTransfer(address(msg.sender), _amount);
996     }
997 
998     /**
999      * @notice It allows the admin to recover wrong tokens sent to the contract
1000      * @param _tokenAddress: the address of the token to withdraw
1001      * @param _tokenAmount: the number of tokens to withdraw
1002      * @dev This function is only callable by admin.
1003      */
1004     function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
1005         require(_tokenAddress != address(stakedToken), "Cannot be staked token");
1006         require(_tokenAddress != address(rewardToken), "Cannot be reward token");
1007 
1008         IBEP20(_tokenAddress).safeTransfer(address(msg.sender), _tokenAmount);
1009 
1010         emit AdminTokenRecovery(_tokenAddress, _tokenAmount);
1011     }
1012 
1013     /*
1014      * @notice Stop rewards
1015      * @dev Only callable by owner
1016      */
1017     function stopReward() external onlyOwner {
1018         bonusEndBlock = block.number;
1019     }
1020 
1021     /*
1022      * @notice Update pool limit per user
1023      * @dev Only callable by owner.
1024      * @param _hasUserLimit: whether the limit remains forced
1025      * @param _poolLimitPerUser: new pool limit per user
1026      */
1027     function updatePoolLimitPerUser(bool _hasUserLimit, uint256 _poolLimitPerUser) external onlyOwner {
1028         require(hasUserLimit, "Must be set");
1029         if (_hasUserLimit) {
1030             require(_poolLimitPerUser > poolLimitPerUser, "New limit must be higher");
1031             poolLimitPerUser = _poolLimitPerUser;
1032         } else {
1033             hasUserLimit = _hasUserLimit;
1034             poolLimitPerUser = 0;
1035         }
1036         emit NewPoolLimit(poolLimitPerUser);
1037     }
1038 
1039     /*
1040      * @notice Update reward per block
1041      * @dev Only callable by owner.
1042      * @param _rewardPerBlock: the reward per block
1043      */
1044     function updateRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner {
1045         require(block.number < startBlock, "Pool has started");
1046         rewardPerBlock = _rewardPerBlock;
1047         emit NewRewardPerBlock(_rewardPerBlock);
1048     }
1049 
1050     /**
1051      * @notice It allows the admin to update start and end blocks
1052      * @dev This function is only callable by owner.
1053      * @param _startBlock: the new start block
1054      * @param _bonusEndBlock: the new end block
1055      */
1056     function updateStartAndEndBlocks(uint256 _startBlock, uint256 _bonusEndBlock) external onlyOwner {
1057         require(block.number < startBlock, "Pool has started");
1058         require(_startBlock < _bonusEndBlock, "New startBlock must be lower than new endBlock");
1059         require(block.number < _startBlock, "New startBlock must be higher than current block");
1060 
1061         startBlock = _startBlock;
1062         bonusEndBlock = _bonusEndBlock;
1063 
1064         // Set the lastRewardBlock as the startBlock
1065         lastRewardBlock = startBlock;
1066 
1067         emit NewStartAndEndBlocks(_startBlock, _bonusEndBlock);
1068     }
1069 
1070     /*
1071      * @notice View function to see pending reward on frontend.
1072      * @param _user: user address
1073      * @return Pending reward for a given user
1074      */
1075     function pendingReward(address _user) external view returns (uint256) {
1076         UserInfo storage user = userInfo[_user];
1077         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1078         if (block.number > lastRewardBlock && stakedTokenSupply != 0) {
1079             uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1080             uint256 cakeReward = multiplier.mul(rewardPerBlock);
1081             uint256 adjustedTokenPerShare =
1082                 accTokenPerShare.add(cakeReward.mul(PRECISION_FACTOR).div(stakedTokenSupply));
1083             return user.amount.mul(adjustedTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
1084         } else {
1085             return user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
1086         }
1087     }
1088 
1089     /*
1090      * @notice Update reward variables of the given pool to be up-to-date.
1091      */
1092     function _updatePool() internal {
1093         if (block.number <= lastRewardBlock) {
1094             return;
1095         }
1096 
1097         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1098 
1099         if (stakedTokenSupply == 0) {
1100             lastRewardBlock = block.number;
1101             return;
1102         }
1103 
1104         uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1105         uint256 cakeReward = multiplier.mul(rewardPerBlock);
1106         accTokenPerShare = accTokenPerShare.add(cakeReward.mul(PRECISION_FACTOR).div(stakedTokenSupply));
1107         lastRewardBlock = block.number;
1108     }
1109 
1110     /*
1111      * @notice Return reward multiplier over the given _from to _to block.
1112      * @param _from: block to start
1113      * @param _to: block to finish
1114      */
1115     function _getMultiplier(uint256 _from, uint256 _to) internal view returns (uint256) {
1116         if (_to <= bonusEndBlock) {
1117             return _to.sub(_from);
1118         } else if (_from >= bonusEndBlock) {
1119             return 0;
1120         } else {
1121             return bonusEndBlock.sub(_from);
1122         }
1123     }
1124 }
1125 
1126 // File: contracts/SmartChefFactory.sol
1127 
1128 //pragma solidity 0.6.12;
1129 
1130 contract SmartChefFactory is Ownable {
1131     event NewSmartChefContract(address indexed smartChef);
1132 
1133     constructor() {
1134         //
1135     }
1136 
1137     /*
1138      * @notice Deploy the pool
1139      * @param _stakedToken: staked token address
1140      * @param _rewardToken: reward token address
1141      * @param _rewardPerBlock: reward per block (in rewardToken)
1142      * @param _startBlock: start block
1143      * @param _endBlock: end block
1144      * @param _poolLimitPerUser: pool limit per user in stakedToken (if any, else 0)
1145      * @param _admin: admin address with ownership
1146      * @return address of new smart chef contract
1147      */
1148     function deployPool(
1149         IBEP20 _stakedToken,
1150         IBEP20 _rewardToken,
1151         uint256 _rewardPerBlock,
1152         uint256 _startBlock,
1153         uint256 _bonusEndBlock,
1154         uint256 _poolLimitPerUser,
1155         address _admin
1156     ) external onlyOwner {
1157         require(_stakedToken.totalSupply() >= 0);
1158         require(_rewardToken.totalSupply() >= 0);
1159         require(_stakedToken != _rewardToken, "Tokens must be be different");
1160 
1161         bytes memory bytecode = type(SmartChefInitializable).creationCode;
1162         bytes32 salt = keccak256(abi.encodePacked(_stakedToken, _rewardToken, _startBlock));
1163         address smartChefAddress;
1164 
1165         assembly {
1166             smartChefAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
1167         }
1168 
1169         SmartChefInitializable(smartChefAddress).initialize(
1170             _stakedToken,
1171             _rewardToken,
1172             _rewardPerBlock,
1173             _startBlock,
1174             _bonusEndBlock,
1175             _poolLimitPerUser,
1176             _admin
1177         );
1178 
1179         emit NewSmartChefContract(smartChefAddress);
1180     }
1181 }
