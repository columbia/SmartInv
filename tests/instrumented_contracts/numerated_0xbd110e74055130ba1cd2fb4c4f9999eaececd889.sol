1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/math/SafeMath.sol
97 
98 pragma solidity >=0.6.0 <0.8.0;
99 
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations with added overflow
102  * checks.
103  *
104  * Arithmetic operations in Solidity wrap on overflow. This can easily result
105  * in bugs, because programmers usually assume that an overflow raises an
106  * error, which is the standard behavior in high level programming languages.
107  * `SafeMath` restores this intuition by reverting the transaction when an
108  * operation overflows.
109  *
110  * Using this library instead of the unchecked operations eliminates an entire
111  * class of bugs, so it's recommended to use it always.
112  */
113 library SafeMath {
114     /**
115      * @dev Returns the addition of two unsigned integers, with an overflow flag.
116      *
117      * _Available since v3.4._
118      */
119     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
120         uint256 c = a + b;
121         if (c < a) return (false, 0);
122         return (true, c);
123     }
124 
125     /**
126      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
127      *
128      * _Available since v3.4._
129      */
130     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         if (b > a) return (false, 0);
132         return (true, a - b);
133     }
134 
135     /**
136      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
137      *
138      * _Available since v3.4._
139      */
140     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
141         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
142         // benefit is lost if 'b' is also tested.
143         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
144         if (a == 0) return (true, 0);
145         uint256 c = a * b;
146         if (c / a != b) return (false, 0);
147         return (true, c);
148     }
149 
150     /**
151      * @dev Returns the division of two unsigned integers, with a division by zero flag.
152      *
153      * _Available since v3.4._
154      */
155     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         if (b == 0) return (false, 0);
157         return (true, a / b);
158     }
159 
160     /**
161      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
162      *
163      * _Available since v3.4._
164      */
165     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
166         if (b == 0) return (false, 0);
167         return (true, a % b);
168     }
169 
170     /**
171      * @dev Returns the addition of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `+` operator.
175      *
176      * Requirements:
177      *
178      * - Addition cannot overflow.
179      */
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         uint256 c = a + b;
182         require(c >= a, "SafeMath: addition overflow");
183         return c;
184     }
185 
186     /**
187      * @dev Returns the subtraction of two unsigned integers, reverting on
188      * overflow (when the result is negative).
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      *
194      * - Subtraction cannot overflow.
195      */
196     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
197         require(b <= a, "SafeMath: subtraction overflow");
198         return a - b;
199     }
200 
201     /**
202      * @dev Returns the multiplication of two unsigned integers, reverting on
203      * overflow.
204      *
205      * Counterpart to Solidity's `*` operator.
206      *
207      * Requirements:
208      *
209      * - Multiplication cannot overflow.
210      */
211     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
212         if (a == 0) return 0;
213         uint256 c = a * b;
214         require(c / a == b, "SafeMath: multiplication overflow");
215         return c;
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers, reverting on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b) internal pure returns (uint256) {
231         require(b > 0, "SafeMath: division by zero");
232         return a / b;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * reverting when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         require(b > 0, "SafeMath: modulo by zero");
249         return a % b;
250     }
251 
252     /**
253      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
254      * overflow (when the result is negative).
255      *
256      * CAUTION: This function is deprecated because it requires allocating memory for the error
257      * message unnecessarily. For custom revert reasons use {trySub}.
258      *
259      * Counterpart to Solidity's `-` operator.
260      *
261      * Requirements:
262      *
263      * - Subtraction cannot overflow.
264      */
265     function sub(
266         uint256 a,
267         uint256 b,
268         string memory errorMessage
269     ) internal pure returns (uint256) {
270         require(b <= a, errorMessage);
271         return a - b;
272     }
273 
274     /**
275      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
276      * division by zero. The result is rounded towards zero.
277      *
278      * CAUTION: This function is deprecated because it requires allocating memory for the error
279      * message unnecessarily. For custom revert reasons use {tryDiv}.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function div(
290         uint256 a,
291         uint256 b,
292         string memory errorMessage
293     ) internal pure returns (uint256) {
294         require(b > 0, errorMessage);
295         return a / b;
296     }
297 
298     /**
299      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
300      * reverting with custom message when dividing by zero.
301      *
302      * CAUTION: This function is deprecated because it requires allocating memory for the error
303      * message unnecessarily. For custom revert reasons use {tryMod}.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      *
311      * - The divisor cannot be zero.
312      */
313     function mod(
314         uint256 a,
315         uint256 b,
316         string memory errorMessage
317     ) internal pure returns (uint256) {
318         require(b > 0, errorMessage);
319         return a % b;
320     }
321 }
322 
323 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
324 
325 pragma solidity >=0.6.0 <0.8.0;
326 
327 /**
328  * @dev Contract module that helps prevent reentrant calls to a function.
329  *
330  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
331  * available, which can be applied to functions to make sure there are no nested
332  * (reentrant) calls to them.
333  *
334  * Note that because there is a single `nonReentrant` guard, functions marked as
335  * `nonReentrant` may not call one another. This can be worked around by making
336  * those functions `private`, and then adding `external` `nonReentrant` entry
337  * points to them.
338  *
339  * TIP: If you would like to learn more about reentrancy and alternative ways
340  * to protect against it, check out our blog post
341  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
342  */
343 abstract contract ReentrancyGuard {
344     // Booleans are more expensive than uint256 or any type that takes up a full
345     // word because each write operation emits an extra SLOAD to first read the
346     // slot's contents, replace the bits taken up by the boolean, and then write
347     // back. This is the compiler's defense against contract upgrades and
348     // pointer aliasing, and it cannot be disabled.
349 
350     // The values being non-zero value makes deployment a bit more expensive,
351     // but in exchange the refund on every call to nonReentrant will be lower in
352     // amount. Since refunds are capped to a percentage of the total
353     // transaction's gas, it is best to keep them low in cases like this one, to
354     // increase the likelihood of the full refund coming into effect.
355     uint256 private constant _NOT_ENTERED = 1;
356     uint256 private constant _ENTERED = 2;
357 
358     uint256 private _status;
359 
360     constructor() internal {
361         _status = _NOT_ENTERED;
362     }
363 
364     /**
365      * @dev Prevents a contract from calling itself, directly or indirectly.
366      * Calling a `nonReentrant` function from another `nonReentrant`
367      * function is not supported. It is possible to prevent this from happening
368      * by making the `nonReentrant` function external, and make it call a
369      * `private` function that does the actual work.
370      */
371     modifier nonReentrant() {
372         // On the first call to nonReentrant, _notEntered will be true
373         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
374 
375         // Any calls to nonReentrant after this point will fail
376         _status = _ENTERED;
377 
378         _;
379 
380         // By storing the original value once again, a refund is triggered (see
381         // https://eips.ethereum.org/EIPS/eip-2200)
382         _status = _NOT_ENTERED;
383     }
384 }
385 
386 // File: bsc-library/contracts/IBEP20.sol
387 
388 pragma solidity >=0.4.0;
389 
390 interface IBEP20 {
391     /**
392      * @dev Returns the amount of tokens in existence.
393      */
394     function totalSupply() external view returns (uint256);
395 
396     /**
397      * @dev Returns the token decimals.
398      */
399     function decimals() external view returns (uint8);
400 
401     /**
402      * @dev Returns the token symbol.
403      */
404     function symbol() external view returns (string memory);
405 
406     /**
407      * @dev Returns the token name.
408      */
409     function name() external view returns (string memory);
410 
411     /**
412      * @dev Returns the bep token owner.
413      */
414     function getOwner() external view returns (address);
415 
416     /**
417      * @dev Returns the amount of tokens owned by `account`.
418      */
419     function balanceOf(address account) external view returns (uint256);
420 
421     /**
422      * @dev Moves `amount` tokens from the caller's account to `recipient`.
423      *
424      * Returns a boolean value indicating whether the operation succeeded.
425      *
426      * Emits a {Transfer} event.
427      */
428     function transfer(address recipient, uint256 amount) external returns (bool);
429 
430     /**
431      * @dev Returns the remaining number of tokens that `spender` will be
432      * allowed to spend on behalf of `owner` through {transferFrom}. This is
433      * zero by default.
434      *
435      * This value changes when {approve} or {transferFrom} are called.
436      */
437     function allowance(address _owner, address spender) external view returns (uint256);
438 
439     /**
440      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
441      *
442      * Returns a boolean value indicating whether the operation succeeded.
443      *
444      * IMPORTANT: Beware that changing an allowance with this method brings the risk
445      * that someone may use both the old and the new allowance by unfortunate
446      * transaction ordering. One possible solution to mitigate this race
447      * condition is to first reduce the spender's allowance to 0 and set the
448      * desired value afterwards:
449      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
450      *
451      * Emits an {Approval} event.
452      */
453     function approve(address spender, uint256 amount) external returns (bool);
454 
455     /**
456      * @dev Moves `amount` tokens from `sender` to `recipient` using the
457      * allowance mechanism. `amount` is then deducted from the caller's
458      * allowance.
459      *
460      * Returns a boolean value indicating whether the operation succeeded.
461      *
462      * Emits a {Transfer} event.
463      */
464     function transferFrom(
465         address sender,
466         address recipient,
467         uint256 amount
468     ) external returns (bool);
469 
470     /**
471      * @dev Emitted when `value` tokens are moved from one account (`from`) to
472      * another (`to`).
473      *
474      * Note that `value` may be zero.
475      */
476     event Transfer(address indexed from, address indexed to, uint256 value);
477 
478     /**
479      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
480      * a call to {approve}. `value` is the new allowance.
481      */
482     event Approval(address indexed owner, address indexed spender, uint256 value);
483 }
484 
485 // File: @openzeppelin/contracts/utils/Address.sol
486 
487 pragma solidity >=0.6.2 <0.8.0;
488 
489 /**
490  * @dev Collection of functions related to the address type
491  */
492 library Address {
493     /**
494      * @dev Returns true if `account` is a contract.
495      *
496      * [IMPORTANT]
497      * ====
498      * It is unsafe to assume that an address for which this function returns
499      * false is an externally-owned account (EOA) and not a contract.
500      *
501      * Among others, `isContract` will return false for the following
502      * types of addresses:
503      *
504      *  - an externally-owned account
505      *  - a contract in construction
506      *  - an address where a contract will be created
507      *  - an address where a contract lived, but was destroyed
508      * ====
509      */
510     function isContract(address account) internal view returns (bool) {
511         // This method relies on extcodesize, which returns 0 for contracts in
512         // construction, since the code is only stored at the end of the
513         // constructor execution.
514 
515         uint256 size;
516         // solhint-disable-next-line no-inline-assembly
517         assembly {
518             size := extcodesize(account)
519         }
520         return size > 0;
521     }
522 
523     /**
524      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
525      * `recipient`, forwarding all available gas and reverting on errors.
526      *
527      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
528      * of certain opcodes, possibly making contracts go over the 2300 gas limit
529      * imposed by `transfer`, making them unable to receive funds via
530      * `transfer`. {sendValue} removes this limitation.
531      *
532      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
533      *
534      * IMPORTANT: because control is transferred to `recipient`, care must be
535      * taken to not create reentrancy vulnerabilities. Consider using
536      * {ReentrancyGuard} or the
537      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
538      */
539     function sendValue(address payable recipient, uint256 amount) internal {
540         require(address(this).balance >= amount, "Address: insufficient balance");
541 
542         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
543         (bool success, ) = recipient.call{value: amount}("");
544         require(success, "Address: unable to send value, recipient may have reverted");
545     }
546 
547     /**
548      * @dev Performs a Solidity function call using a low level `call`. A
549      * plain`call` is an unsafe replacement for a function call: use this
550      * function instead.
551      *
552      * If `target` reverts with a revert reason, it is bubbled up by this
553      * function (like regular Solidity function calls).
554      *
555      * Returns the raw returned data. To convert to the expected return value,
556      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
557      *
558      * Requirements:
559      *
560      * - `target` must be a contract.
561      * - calling `target` with `data` must not revert.
562      *
563      * _Available since v3.1._
564      */
565     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
566         return functionCall(target, data, "Address: low-level call failed");
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
571      * `errorMessage` as a fallback revert reason when `target` reverts.
572      *
573      * _Available since v3.1._
574      */
575     function functionCall(
576         address target,
577         bytes memory data,
578         string memory errorMessage
579     ) internal returns (bytes memory) {
580         return functionCallWithValue(target, data, 0, errorMessage);
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
585      * but also transferring `value` wei to `target`.
586      *
587      * Requirements:
588      *
589      * - the calling contract must have an ETH balance of at least `value`.
590      * - the called Solidity function must be `payable`.
591      *
592      * _Available since v3.1._
593      */
594     function functionCallWithValue(
595         address target,
596         bytes memory data,
597         uint256 value
598     ) internal returns (bytes memory) {
599         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
604      * with `errorMessage` as a fallback revert reason when `target` reverts.
605      *
606      * _Available since v3.1._
607      */
608     function functionCallWithValue(
609         address target,
610         bytes memory data,
611         uint256 value,
612         string memory errorMessage
613     ) internal returns (bytes memory) {
614         require(address(this).balance >= value, "Address: insufficient balance for call");
615         require(isContract(target), "Address: call to non-contract");
616 
617         // solhint-disable-next-line avoid-low-level-calls
618         (bool success, bytes memory returndata) = target.call{value: value}(data);
619         return _verifyCallResult(success, returndata, errorMessage);
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
624      * but performing a static call.
625      *
626      * _Available since v3.3._
627      */
628     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
629         return functionStaticCall(target, data, "Address: low-level static call failed");
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
634      * but performing a static call.
635      *
636      * _Available since v3.3._
637      */
638     function functionStaticCall(
639         address target,
640         bytes memory data,
641         string memory errorMessage
642     ) internal view returns (bytes memory) {
643         require(isContract(target), "Address: static call to non-contract");
644 
645         // solhint-disable-next-line avoid-low-level-calls
646         (bool success, bytes memory returndata) = target.staticcall(data);
647         return _verifyCallResult(success, returndata, errorMessage);
648     }
649 
650     /**
651      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
652      * but performing a delegate call.
653      *
654      * _Available since v3.4._
655      */
656     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
657         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
658     }
659 
660     /**
661      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
662      * but performing a delegate call.
663      *
664      * _Available since v3.4._
665      */
666     function functionDelegateCall(
667         address target,
668         bytes memory data,
669         string memory errorMessage
670     ) internal returns (bytes memory) {
671         require(isContract(target), "Address: delegate call to non-contract");
672 
673         // solhint-disable-next-line avoid-low-level-calls
674         (bool success, bytes memory returndata) = target.delegatecall(data);
675         return _verifyCallResult(success, returndata, errorMessage);
676     }
677 
678     function _verifyCallResult(
679         bool success,
680         bytes memory returndata,
681         string memory errorMessage
682     ) private pure returns (bytes memory) {
683         if (success) {
684             return returndata;
685         } else {
686             // Look for revert reason and bubble it up if present
687             if (returndata.length > 0) {
688                 // The easiest way to bubble the revert reason is using memory via assembly
689 
690                 // solhint-disable-next-line no-inline-assembly
691                 assembly {
692                     let returndata_size := mload(returndata)
693                     revert(add(32, returndata), returndata_size)
694                 }
695             } else {
696                 revert(errorMessage);
697             }
698         }
699     }
700 }
701 
702 // File: bsc-library/contracts/SafeBEP20.sol
703 
704 pragma solidity ^0.6.0;
705 
706 /**
707  * @title SafeBEP20
708  * @dev Wrappers around BEP20 operations that throw on failure (when the token
709  * contract returns false). Tokens that return no value (and instead revert or
710  * throw on failure) are also supported, non-reverting calls are assumed to be
711  * successful.
712  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
713  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
714  */
715 library SafeBEP20 {
716     using SafeMath for uint256;
717     using Address for address;
718 
719     function safeTransfer(
720         IBEP20 token,
721         address to,
722         uint256 value
723     ) internal {
724         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
725     }
726 
727     function safeTransferFrom(
728         IBEP20 token,
729         address from,
730         address to,
731         uint256 value
732     ) internal {
733         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
734     }
735 
736     /**
737      * @dev Deprecated. This function has issues similar to the ones found in
738      * {IBEP20-approve}, and its usage is discouraged.
739      *
740      * Whenever possible, use {safeIncreaseAllowance} and
741      * {safeDecreaseAllowance} instead.
742      */
743     function safeApprove(
744         IBEP20 token,
745         address spender,
746         uint256 value
747     ) internal {
748         // safeApprove should only be called when setting an initial allowance,
749         // or when resetting it to zero. To increase and decrease it, use
750         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
751         // solhint-disable-next-line max-line-length
752         require(
753             (value == 0) || (token.allowance(address(this), spender) == 0),
754             "SafeBEP20: approve from non-zero to non-zero allowance"
755         );
756         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
757     }
758 
759     function safeIncreaseAllowance(
760         IBEP20 token,
761         address spender,
762         uint256 value
763     ) internal {
764         uint256 newAllowance = token.allowance(address(this), spender).add(value);
765         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
766     }
767 
768     function safeDecreaseAllowance(
769         IBEP20 token,
770         address spender,
771         uint256 value
772     ) internal {
773         uint256 newAllowance =
774             token.allowance(address(this), spender).sub(value, "SafeBEP20: decreased allowance below zero");
775         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
776     }
777 
778     /**
779      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
780      * on the return value: the return value is optional (but if data is returned, it must not be false).
781      * @param token The token targeted by the call.
782      * @param data The call data (encoded using abi.encode or one of its variants).
783      */
784     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
785         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
786         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
787         // the target address contains contract code and also asserts for success in the low-level call.
788 
789         bytes memory returndata = address(token).functionCall(data, "SafeBEP20: low-level call failed");
790         if (returndata.length > 0) {
791             // Return data is optional
792             // solhint-disable-next-line max-line-length
793             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
794         }
795     }
796 }
797 
798 // File: contracts/SmartChefInitializable.sol
799 
800 pragma solidity 0.6.12;
801 
802 contract KishiStaking is Ownable, ReentrancyGuard {
803     using SafeMath for uint256;
804     using SafeBEP20 for IBEP20;
805 
806     // Whether it is initialized
807     bool public isInitialized;
808 
809     // Accrued token per share
810     uint256 public accTokenPerShare;
811 
812     // The block number when KISHI reward ends.
813     uint256 public bonusEndBlock;
814 
815     // The block number when KISHI reward starts.
816     uint256 public startBlock;
817 
818     // The block number of the last pool update
819     uint256 public lastRewardBlock;
820 
821     // KATSUMI tokens reward per block.
822     uint256 public rewardPerBlock;
823     
824     // The precision factor
825     uint256 public PRECISION_FACTOR;
826 
827     // The reward token
828     IBEP20 public rewardToken;
829 
830     // The staked token
831     IBEP20 public stakedToken;
832 
833     // Info of each user that stakes tokens (stakedToken)
834     mapping(address => UserInfo) public userInfo;
835 
836     struct UserInfo {
837         uint256 amount; // How many staked tokens the user has provided
838         uint256 rewardDebt; // Reward debt
839     }
840 
841     event AdminTokenRecovery(address tokenRecovered, uint256 amount);
842     event Deposit(address indexed user, uint256 amount);
843     event EmergencyWithdraw(address indexed user, uint256 amount);
844     event NewStartAndEndBlocks(uint256 startBlock, uint256 endBlock);
845     event NewRewardPerBlock(uint256 rewardPerBlock);
846     event RewardsStop(uint256 blockNumber);
847     event Withdraw(address indexed user, uint256 amount);
848 
849     constructor() public {}
850 
851     /*
852      * @notice Initialize the contract
853      * @param _stakedToken: staked token address
854      * @param _rewardToken: reward token address
855      * @param _rewardPerBlock: reward per block (in rewardToken)
856      * @param _startBlock: start block
857      * @param _bonusEndBlock: end block
858      * @param _poolLimitPerUser: pool limit per user in stakedToken (if any, else 0)
859      * @param _admin: admin address with ownership
860      */
861     function initialize(
862         IBEP20 _stakedToken,
863         IBEP20 _rewardToken,
864         uint256 _rewardPerBlock,
865         uint256 _startBlock,
866         uint256 _bonusEndBlock
867     ) external onlyOwner {
868         require(!isInitialized, "Already initialized");
869 
870         // Make this contract initialized
871         isInitialized = true;
872 
873         stakedToken = _stakedToken;
874         rewardToken = _rewardToken;
875         rewardPerBlock = _rewardPerBlock;
876         startBlock = _startBlock;
877         bonusEndBlock = _bonusEndBlock;
878 
879 
880         uint256 decimalsRewardToken = uint256(rewardToken.decimals());
881         require(decimalsRewardToken < 30, "Must be inferior to 30");
882 
883         PRECISION_FACTOR = uint256(10**(uint256(30).sub(decimalsRewardToken)));
884 
885         // Set the lastRewardBlock as the startBlock
886         lastRewardBlock = startBlock;
887 
888     }
889     
890     function modifyTimes(uint256 _startTime, uint256 _endTime, uint256 _reward) public onlyOwner {
891         startBlock = _startTime;
892         bonusEndBlock = _endTime;
893         rewardPerBlock = _reward;
894         lastRewardBlock = startBlock;
895     }
896 
897     /*
898      * @notice Deposit staked tokens and collect reward tokens (if any)
899      * @param _amount: amount to withdraw (in rewardToken)
900      */
901     function deposit(uint256 _amount) external nonReentrant {
902         UserInfo storage user = userInfo[msg.sender];
903 
904         _updatePool();
905 
906         if (user.amount > 0) {
907             uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
908             if (pending > 0) {
909                 rewardToken.safeTransfer(address(msg.sender), pending);
910             }
911         }
912 
913         if (_amount > 0) {
914             stakedToken.safeTransferFrom(address(msg.sender), address(this), _amount);
915             user.amount = user.amount.add(_amount);
916             
917         }
918 
919         user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
920 
921         emit Deposit(msg.sender, _amount);
922     }
923 
924     function harvest() external nonReentrant {
925         UserInfo storage user = userInfo[msg.sender];
926         require(user.amount > 0, "No staked amount");
927         _updatePool();
928 
929         uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
930         require(pending > 0, "No reward to harvest");
931 
932         rewardToken.safeTransfer(address(msg.sender), pending);
933         user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
934 
935     }
936 
937     /*
938      * @notice Withdraw staked tokens and collect reward tokens
939      * @param _amount: amount to withdraw (in rewardToken)
940      */
941     function withdraw(uint256 _amount) external nonReentrant {
942         UserInfo storage user = userInfo[msg.sender];
943         require(user.amount >= _amount, "Amount to withdraw too high");
944 
945         _updatePool();
946 
947         uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
948 
949         if (_amount > 0) {
950             user.amount = user.amount.sub(_amount);
951             stakedToken.safeTransfer(address(msg.sender), _amount);
952         }
953 
954         if (pending > 0) {
955             rewardToken.safeTransfer(address(msg.sender), pending);
956         }
957 
958         user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
959 
960         emit Withdraw(msg.sender, _amount);
961     }
962 
963     /*
964      * @notice Withdraw staked tokens without caring about rewards rewards
965      * @dev Needs to be for emergency.
966      */
967     function emergencyWithdraw() external nonReentrant {
968         UserInfo storage user = userInfo[msg.sender];
969         uint256 amountToTransfer = user.amount;
970         user.amount = 0;
971         user.rewardDebt = 0;
972 
973         if (amountToTransfer > 0) {
974             stakedToken.safeTransfer(address(msg.sender), amountToTransfer);
975         }
976 
977         emit EmergencyWithdraw(msg.sender, user.amount);
978     }
979 
980     /*
981      * @notice Stop rewards
982      * @dev Only callable by owner. Needs to be for emergency.
983      */
984     function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
985         rewardToken.safeTransfer(address(msg.sender), _amount);
986     }
987 
988     /**
989      * @notice It allows the admin to recover wrong tokens sent to the contract
990      * @param _tokenAddress: the address of the token to withdraw
991      * @param _tokenAmount: the number of tokens to withdraw
992      * @dev This function is only callable by admin.
993      */
994     function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
995         require(_tokenAddress != address(stakedToken), "Cannot be staked token");
996         require(_tokenAddress != address(rewardToken), "Cannot be reward token");
997 
998         IBEP20(_tokenAddress).safeTransfer(address(msg.sender), _tokenAmount);
999 
1000         emit AdminTokenRecovery(_tokenAddress, _tokenAmount);
1001     }
1002 
1003     /*
1004      * @notice Stop rewards
1005      * @dev Only callable by owner
1006      */
1007     function stopReward() external onlyOwner {
1008         bonusEndBlock = block.number;
1009     }
1010 
1011 
1012     /*
1013      * @notice Update reward per block
1014      * @dev Only callable by owner.
1015      * @param _rewardPerBlock: the reward per block
1016      */
1017     function updateRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner {
1018         rewardPerBlock = _rewardPerBlock;
1019         emit NewRewardPerBlock(_rewardPerBlock);
1020     }
1021 
1022     /**
1023      * @notice It allows the admin to update start and end blocks
1024      * @dev This function is only callable by owner.
1025      * @param _startBlock: the new start block
1026      * @param _bonusEndBlock: the new end block
1027      */
1028     function updateStartAndEndBlocks(uint256 _startBlock, uint256 _bonusEndBlock) external onlyOwner {
1029         require(block.number < startBlock, "Pool has started");
1030         require(_startBlock < _bonusEndBlock, "New startBlock must be lower than new endBlock");
1031         require(block.number < _startBlock, "New startBlock must be higher than current block");
1032 
1033         startBlock = _startBlock;
1034         bonusEndBlock = _bonusEndBlock;
1035 
1036         // Set the lastRewardBlock as the startBlock
1037         lastRewardBlock = startBlock;
1038 
1039         emit NewStartAndEndBlocks(_startBlock, _bonusEndBlock);
1040     }
1041 
1042     /*
1043      * @notice View function to see pending reward on frontend.
1044      * @param _user: user address
1045      * @return Pending reward for a given user
1046      */
1047     function pendingReward(address _user) external view returns (uint256) {
1048         UserInfo storage user = userInfo[_user];
1049         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1050         if (block.number > lastRewardBlock && stakedTokenSupply != 0) {
1051             uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1052             uint256 kishiReward = multiplier.mul(rewardPerBlock);
1053             uint256 adjustedTokenPerShare =
1054                 accTokenPerShare.add(kishiReward.mul(PRECISION_FACTOR).div(stakedTokenSupply));
1055             return user.amount.mul(adjustedTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
1056         } else {
1057             return user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
1058         }
1059     }
1060 
1061     /*
1062      * @notice Update reward variables of the given pool to be up-to-date.
1063      */
1064     function _updatePool() internal {
1065         if (block.number <= lastRewardBlock) {
1066             return;
1067         }
1068 
1069         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1070 
1071         if (stakedTokenSupply == 0) {
1072             lastRewardBlock = block.number;
1073             return;
1074         }
1075 
1076         uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1077         uint256 kishiReward = multiplier.mul(rewardPerBlock);
1078         accTokenPerShare = accTokenPerShare.add(kishiReward.mul(PRECISION_FACTOR).div(stakedTokenSupply));
1079         lastRewardBlock = block.number;
1080     }
1081 
1082     /*
1083      * @notice Return reward multiplier over the given _from to _to block.
1084      * @param _from: block to start
1085      * @param _to: block to finish
1086      */
1087     function _getMultiplier(uint256 _from, uint256 _to) internal view returns (uint256) {
1088         if (_to <= bonusEndBlock) {
1089             return _to.sub(_from);
1090         } else if (_from >= bonusEndBlock) {
1091             return 0;
1092         } else {
1093             return bonusEndBlock.sub(_from);
1094         }
1095     }
1096 }