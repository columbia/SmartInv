1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-19
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2021-05-05
7  */
8 
9 // File: @openzeppelin/contracts/utils/Context.sol
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity >=0.6.0 <0.8.0;
14 
15 /*
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with GSN meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address payable) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 // File: @openzeppelin/contracts/access/Ownable.sol
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
53     event OwnershipTransferred(
54         address indexed previousOwner,
55         address indexed newOwner
56     );
57 
58     /**
59      * @dev Initializes the contract setting the deployer as the initial owner.
60      */
61     constructor() {
62         address msgSender = _msgSender();
63         _owner = msgSender;
64         emit OwnershipTransferred(address(0), msgSender);
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(
100             newOwner != address(0),
101             "Ownable: new owner is the zero address"
102         );
103         emit OwnershipTransferred(_owner, newOwner);
104         _owner = newOwner;
105     }
106 }
107 
108 // File: @openzeppelin/contracts/math/SafeMath.sol
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, with an overflow flag.
126      *
127      * _Available since v3.4._
128      */
129     function tryAdd(uint256 a, uint256 b)
130         internal
131         pure
132         returns (bool, uint256)
133     {
134         uint256 c = a + b;
135         if (c < a) return (false, 0);
136         return (true, c);
137     }
138 
139     /**
140      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function trySub(uint256 a, uint256 b)
145         internal
146         pure
147         returns (bool, uint256)
148     {
149         if (b > a) return (false, 0);
150         return (true, a - b);
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
155      *
156      * _Available since v3.4._
157      */
158     function tryMul(uint256 a, uint256 b)
159         internal
160         pure
161         returns (bool, uint256)
162     {
163         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164         // benefit is lost if 'b' is also tested.
165         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
166         if (a == 0) return (true, 0);
167         uint256 c = a * b;
168         if (c / a != b) return (false, 0);
169         return (true, c);
170     }
171 
172     /**
173      * @dev Returns the division of two unsigned integers, with a division by zero flag.
174      *
175      * _Available since v3.4._
176      */
177     function tryDiv(uint256 a, uint256 b)
178         internal
179         pure
180         returns (bool, uint256)
181     {
182         if (b == 0) return (false, 0);
183         return (true, a / b);
184     }
185 
186     /**
187      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
188      *
189      * _Available since v3.4._
190      */
191     function tryMod(uint256 a, uint256 b)
192         internal
193         pure
194         returns (bool, uint256)
195     {
196         if (b == 0) return (false, 0);
197         return (true, a % b);
198     }
199 
200     /**
201      * @dev Returns the addition of two unsigned integers, reverting on
202      * overflow.
203      *
204      * Counterpart to Solidity's `+` operator.
205      *
206      * Requirements:
207      *
208      * - Addition cannot overflow.
209      */
210     function add(uint256 a, uint256 b) internal pure returns (uint256) {
211         uint256 c = a + b;
212         require(c >= a, "SafeMath: addition overflow");
213         return c;
214     }
215 
216     /**
217      * @dev Returns the subtraction of two unsigned integers, reverting on
218      * overflow (when the result is negative).
219      *
220      * Counterpart to Solidity's `-` operator.
221      *
222      * Requirements:
223      *
224      * - Subtraction cannot overflow.
225      */
226     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
227         require(b <= a, "SafeMath: subtraction overflow");
228         return a - b;
229     }
230 
231     /**
232      * @dev Returns the multiplication of two unsigned integers, reverting on
233      * overflow.
234      *
235      * Counterpart to Solidity's `*` operator.
236      *
237      * Requirements:
238      *
239      * - Multiplication cannot overflow.
240      */
241     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
242         if (a == 0) return 0;
243         uint256 c = a * b;
244         require(c / a == b, "SafeMath: multiplication overflow");
245         return c;
246     }
247 
248     /**
249      * @dev Returns the integer division of two unsigned integers, reverting on
250      * division by zero. The result is rounded towards zero.
251      *
252      * Counterpart to Solidity's `/` operator. Note: this function uses a
253      * `revert` opcode (which leaves remaining gas untouched) while Solidity
254      * uses an invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function div(uint256 a, uint256 b) internal pure returns (uint256) {
261         require(b > 0, "SafeMath: division by zero");
262         return a / b;
263     }
264 
265     /**
266      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
267      * reverting when dividing by zero.
268      *
269      * Counterpart to Solidity's `%` operator. This function uses a `revert`
270      * opcode (which leaves remaining gas untouched) while Solidity uses an
271      * invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
278         require(b > 0, "SafeMath: modulo by zero");
279         return a % b;
280     }
281 
282     /**
283      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
284      * overflow (when the result is negative).
285      *
286      * CAUTION: This function is deprecated because it requires allocating memory for the error
287      * message unnecessarily. For custom revert reasons use {trySub}.
288      *
289      * Counterpart to Solidity's `-` operator.
290      *
291      * Requirements:
292      *
293      * - Subtraction cannot overflow.
294      */
295     function sub(
296         uint256 a,
297         uint256 b,
298         string memory errorMessage
299     ) internal pure returns (uint256) {
300         require(b <= a, errorMessage);
301         return a - b;
302     }
303 
304     /**
305      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
306      * division by zero. The result is rounded towards zero.
307      *
308      * CAUTION: This function is deprecated because it requires allocating memory for the error
309      * message unnecessarily. For custom revert reasons use {tryDiv}.
310      *
311      * Counterpart to Solidity's `/` operator. Note: this function uses a
312      * `revert` opcode (which leaves remaining gas untouched) while Solidity
313      * uses an invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function div(
320         uint256 a,
321         uint256 b,
322         string memory errorMessage
323     ) internal pure returns (uint256) {
324         require(b > 0, errorMessage);
325         return a / b;
326     }
327 
328     /**
329      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
330      * reverting with custom message when dividing by zero.
331      *
332      * CAUTION: This function is deprecated because it requires allocating memory for the error
333      * message unnecessarily. For custom revert reasons use {tryMod}.
334      *
335      * Counterpart to Solidity's `%` operator. This function uses a `revert`
336      * opcode (which leaves remaining gas untouched) while Solidity uses an
337      * invalid opcode to revert (consuming all remaining gas).
338      *
339      * Requirements:
340      *
341      * - The divisor cannot be zero.
342      */
343     function mod(
344         uint256 a,
345         uint256 b,
346         string memory errorMessage
347     ) internal pure returns (uint256) {
348         require(b > 0, errorMessage);
349         return a % b;
350     }
351 }
352 
353 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
354 
355 /**
356  * @dev Contract module that helps prevent reentrant calls to a function.
357  *
358  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
359  * available, which can be applied to functions to make sure there are no nested
360  * (reentrant) calls to them.
361  *
362  * Note that because there is a single `nonReentrant` guard, functions marked as
363  * `nonReentrant` may not call one another. This can be worked around by making
364  * those functions `private`, and then adding `external` `nonReentrant` entry
365  * points to them.
366  *
367  * TIP: If you would like to learn more about reentrancy and alternative ways
368  * to protect against it, check out our blog post
369  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
370  */
371 abstract contract ReentrancyGuard {
372     // Booleans are more expensive than uint256 or any type that takes up a full
373     // word because each write operation emits an extra SLOAD to first read the
374     // slot's contents, replace the bits taken up by the boolean, and then write
375     // back. This is the compiler's defense against contract upgrades and
376     // pointer aliasing, and it cannot be disabled.
377 
378     // The values being non-zero value makes deployment a bit more expensive,
379     // but in exchange the refund on every call to nonReentrant will be lower in
380     // amount. Since refunds are capped to a percentage of the total
381     // transaction's gas, it is best to keep them low in cases like this one, to
382     // increase the likelihood of the full refund coming into effect.
383     uint256 private constant _NOT_ENTERED = 1;
384     uint256 private constant _ENTERED = 2;
385 
386     uint256 private _status;
387 
388     constructor() {
389         _status = _NOT_ENTERED;
390     }
391 
392     /**
393      * @dev Prevents a contract from calling itself, directly or indirectly.
394      * Calling a `nonReentrant` function from another `nonReentrant`
395      * function is not supported. It is possible to prevent this from happening
396      * by making the `nonReentrant` function external, and make it call a
397      * `private` function that does the actual work.
398      */
399     modifier nonReentrant() {
400         // On the first call to nonReentrant, _notEntered will be true
401         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
402 
403         // Any calls to nonReentrant after this point will fail
404         _status = _ENTERED;
405 
406         _;
407 
408         // By storing the original value once again, a refund is triggered (see
409         // https://eips.ethereum.org/EIPS/eip-2200)
410         _status = _NOT_ENTERED;
411     }
412 }
413 
414 // File: bsc-library/contracts/IBEP20.sol
415 
416 interface IBEP20 {
417     /**
418      * @dev Returns the amount of tokens in existence.
419      */
420     function totalSupply() external view returns (uint256);
421 
422     /**
423      * @dev Returns the token decimals.
424      */
425     function decimals() external view returns (uint8);
426 
427     /**
428      * @dev Returns the token symbol.
429      */
430     function symbol() external view returns (string memory);
431 
432     /**
433      * @dev Returns the token name.
434      */
435     function name() external view returns (string memory);
436 
437     /**
438      * @dev Returns the bep token owner.
439      */
440     function getOwner() external view returns (address);
441 
442     /**
443      * @dev Returns the amount of tokens owned by `account`.
444      */
445     function balanceOf(address account) external view returns (uint256);
446 
447     /**
448      * @dev Moves `amount` tokens from the caller's account to `recipient`.
449      *
450      * Returns a boolean value indicating whether the operation succeeded.
451      *
452      * Emits a {Transfer} event.
453      */
454     function transfer(address recipient, uint256 amount)
455         external
456         returns (bool);
457 
458     /**
459      * @dev Returns the remaining number of tokens that `spender` will be
460      * allowed to spend on behalf of `owner` through {transferFrom}. This is
461      * zero by default.
462      *
463      * This value changes when {approve} or {transferFrom} are called.
464      */
465     function allowance(address _owner, address spender)
466         external
467         view
468         returns (uint256);
469 
470     /**
471      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
472      *
473      * Returns a boolean value indicating whether the operation succeeded.
474      *
475      * IMPORTANT: Beware that changing an allowance with this method brings the risk
476      * that someone may use both the old and the new allowance by unfortunate
477      * transaction ordering. One possible solution to mitigate this race
478      * condition is to first reduce the spender's allowance to 0 and set the
479      * desired value afterwards:
480      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
481      *
482      * Emits an {Approval} event.
483      */
484     function approve(address spender, uint256 amount) external returns (bool);
485 
486     /**
487      * @dev Moves `amount` tokens from `sender` to `recipient` using the
488      * allowance mechanism. `amount` is then deducted from the caller's
489      * allowance.
490      *
491      * Returns a boolean value indicating whether the operation succeeded.
492      *
493      * Emits a {Transfer} event.
494      */
495     function transferFrom(
496         address sender,
497         address recipient,
498         uint256 amount
499     ) external returns (bool);
500 
501     /**
502      * @dev Emitted when `value` tokens are moved from one account (`from`) to
503      * another (`to`).
504      *
505      * Note that `value` may be zero.
506      */
507     event Transfer(address indexed from, address indexed to, uint256 value);
508 
509     /**
510      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
511      * a call to {approve}. `value` is the new allowance.
512      */
513     event Approval(
514         address indexed owner,
515         address indexed spender,
516         uint256 value
517     );
518 }
519 
520 // File: @openzeppelin/contracts/utils/Address.sol
521 
522 /**
523  * @dev Collection of functions related to the address type
524  */
525 library Address {
526     /**
527      * @dev Returns true if `account` is a contract.
528      *
529      * [IMPORTANT]
530      * ====
531      * It is unsafe to assume that an address for which this function returns
532      * false is an externally-owned account (EOA) and not a contract.
533      *
534      * Among others, `isContract` will return false for the following
535      * types of addresses:
536      *
537      *  - an externally-owned account
538      *  - a contract in construction
539      *  - an address where a contract will be created
540      *  - an address where a contract lived, but was destroyed
541      * ====
542      */
543     function isContract(address account) internal view returns (bool) {
544         // This method relies on extcodesize, which returns 0 for contracts in
545         // construction, since the code is only stored at the end of the
546         // constructor execution.
547 
548         uint256 size;
549         // solhint-disable-next-line no-inline-assembly
550         assembly {
551             size := extcodesize(account)
552         }
553         return size > 0;
554     }
555 
556     /**
557      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
558      * `recipient`, forwarding all available gas and reverting on errors.
559      *
560      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
561      * of certain opcodes, possibly making contracts go over the 2300 gas limit
562      * imposed by `transfer`, making them unable to receive funds via
563      * `transfer`. {sendValue} removes this limitation.
564      *
565      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
566      *
567      * IMPORTANT: because control is transferred to `recipient`, care must be
568      * taken to not create reentrancy vulnerabilities. Consider using
569      * {ReentrancyGuard} or the
570      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
571      */
572     function sendValue(address payable recipient, uint256 amount) internal {
573         require(
574             address(this).balance >= amount,
575             "Address: insufficient balance"
576         );
577 
578         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
579         (bool success, ) = recipient.call{value: amount}("");
580         require(
581             success,
582             "Address: unable to send value, recipient may have reverted"
583         );
584     }
585 
586     /**
587      * @dev Performs a Solidity function call using a low level `call`. A
588      * plain`call` is an unsafe replacement for a function call: use this
589      * function instead.
590      *
591      * If `target` reverts with a revert reason, it is bubbled up by this
592      * function (like regular Solidity function calls).
593      *
594      * Returns the raw returned data. To convert to the expected return value,
595      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
596      *
597      * Requirements:
598      *
599      * - `target` must be a contract.
600      * - calling `target` with `data` must not revert.
601      *
602      * _Available since v3.1._
603      */
604     function functionCall(address target, bytes memory data)
605         internal
606         returns (bytes memory)
607     {
608         return functionCall(target, data, "Address: low-level call failed");
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
613      * `errorMessage` as a fallback revert reason when `target` reverts.
614      *
615      * _Available since v3.1._
616      */
617     function functionCall(
618         address target,
619         bytes memory data,
620         string memory errorMessage
621     ) internal returns (bytes memory) {
622         return functionCallWithValue(target, data, 0, errorMessage);
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
627      * but also transferring `value` wei to `target`.
628      *
629      * Requirements:
630      *
631      * - the calling contract must have an ETH balance of at least `value`.
632      * - the called Solidity function must be `payable`.
633      *
634      * _Available since v3.1._
635      */
636     function functionCallWithValue(
637         address target,
638         bytes memory data,
639         uint256 value
640     ) internal returns (bytes memory) {
641         return
642             functionCallWithValue(
643                 target,
644                 data,
645                 value,
646                 "Address: low-level call with value failed"
647             );
648     }
649 
650     /**
651      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
652      * with `errorMessage` as a fallback revert reason when `target` reverts.
653      *
654      * _Available since v3.1._
655      */
656     function functionCallWithValue(
657         address target,
658         bytes memory data,
659         uint256 value,
660         string memory errorMessage
661     ) internal returns (bytes memory) {
662         require(
663             address(this).balance >= value,
664             "Address: insufficient balance for call"
665         );
666         require(isContract(target), "Address: call to non-contract");
667 
668         // solhint-disable-next-line avoid-low-level-calls
669         (bool success, bytes memory returndata) = target.call{value: value}(
670             data
671         );
672         return _verifyCallResult(success, returndata, errorMessage);
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
677      * but performing a static call.
678      *
679      * _Available since v3.3._
680      */
681     function functionStaticCall(address target, bytes memory data)
682         internal
683         view
684         returns (bytes memory)
685     {
686         return
687             functionStaticCall(
688                 target,
689                 data,
690                 "Address: low-level static call failed"
691             );
692     }
693 
694     /**
695      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
696      * but performing a static call.
697      *
698      * _Available since v3.3._
699      */
700     function functionStaticCall(
701         address target,
702         bytes memory data,
703         string memory errorMessage
704     ) internal view returns (bytes memory) {
705         require(isContract(target), "Address: static call to non-contract");
706 
707         // solhint-disable-next-line avoid-low-level-calls
708         (bool success, bytes memory returndata) = target.staticcall(data);
709         return _verifyCallResult(success, returndata, errorMessage);
710     }
711 
712     /**
713      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
714      * but performing a delegate call.
715      *
716      * _Available since v3.4._
717      */
718     function functionDelegateCall(address target, bytes memory data)
719         internal
720         returns (bytes memory)
721     {
722         return
723             functionDelegateCall(
724                 target,
725                 data,
726                 "Address: low-level delegate call failed"
727             );
728     }
729 
730     /**
731      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
732      * but performing a delegate call.
733      *
734      * _Available since v3.4._
735      */
736     function functionDelegateCall(
737         address target,
738         bytes memory data,
739         string memory errorMessage
740     ) internal returns (bytes memory) {
741         require(isContract(target), "Address: delegate call to non-contract");
742 
743         // solhint-disable-next-line avoid-low-level-calls
744         (bool success, bytes memory returndata) = target.delegatecall(data);
745         return _verifyCallResult(success, returndata, errorMessage);
746     }
747 
748     function _verifyCallResult(
749         bool success,
750         bytes memory returndata,
751         string memory errorMessage
752     ) private pure returns (bytes memory) {
753         if (success) {
754             return returndata;
755         } else {
756             // Look for revert reason and bubble it up if present
757             if (returndata.length > 0) {
758                 // The easiest way to bubble the revert reason is using memory via assembly
759 
760                 // solhint-disable-next-line no-inline-assembly
761                 assembly {
762                     let returndata_size := mload(returndata)
763                     revert(add(32, returndata), returndata_size)
764                 }
765             } else {
766                 revert(errorMessage);
767             }
768         }
769     }
770 }
771 
772 // File: bsc-library/contracts/SafeBEP20.sol
773 
774 /**
775  * @title SafeBEP20
776  * @dev Wrappers around BEP20 operations that throw on failure (when the token
777  * contract returns false). Tokens that return no value (and instead revert or
778  * throw on failure) are also supported, non-reverting calls are assumed to be
779  * successful.
780  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
781  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
782  */
783 library SafeBEP20 {
784     using SafeMath for uint256;
785     using Address for address;
786 
787     function safeTransfer(
788         IBEP20 token,
789         address to,
790         uint256 value
791     ) internal {
792         _callOptionalReturn(
793             token,
794             abi.encodeWithSelector(token.transfer.selector, to, value)
795         );
796     }
797 
798     function safeTransferFrom(
799         IBEP20 token,
800         address from,
801         address to,
802         uint256 value
803     ) internal {
804         _callOptionalReturn(
805             token,
806             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
807         );
808     }
809 
810     /**
811      * @dev Deprecated. This function has issues similar to the ones found in
812      * {IBEP20-approve}, and its usage is discouraged.
813      *
814      * Whenever possible, use {safeIncreaseAllowance} and
815      * {safeDecreaseAllowance} instead.
816      */
817     function safeApprove(
818         IBEP20 token,
819         address spender,
820         uint256 value
821     ) internal {
822         // safeApprove should only be called when setting an initial allowance,
823         // or when resetting it to zero. To increase and decrease it, use
824         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
825         // solhint-disable-next-line max-line-length
826         require(
827             (value == 0) || (token.allowance(address(this), spender) == 0),
828             "SafeBEP20: approve from non-zero to non-zero allowance"
829         );
830         _callOptionalReturn(
831             token,
832             abi.encodeWithSelector(token.approve.selector, spender, value)
833         );
834     }
835 
836     function safeIncreaseAllowance(
837         IBEP20 token,
838         address spender,
839         uint256 value
840     ) internal {
841         uint256 newAllowance = token.allowance(address(this), spender).add(
842             value
843         );
844         _callOptionalReturn(
845             token,
846             abi.encodeWithSelector(
847                 token.approve.selector,
848                 spender,
849                 newAllowance
850             )
851         );
852     }
853 
854     function safeDecreaseAllowance(
855         IBEP20 token,
856         address spender,
857         uint256 value
858     ) internal {
859         uint256 newAllowance = token.allowance(address(this), spender).sub(
860             value,
861             "SafeBEP20: decreased allowance below zero"
862         );
863         _callOptionalReturn(
864             token,
865             abi.encodeWithSelector(
866                 token.approve.selector,
867                 spender,
868                 newAllowance
869             )
870         );
871     }
872 
873     /**
874      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
875      * on the return value: the return value is optional (but if data is returned, it must not be false).
876      * @param token The token targeted by the call.
877      * @param data The call data (encoded using abi.encode or one of its variants).
878      */
879     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
880         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
881         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
882         // the target address contains contract code and also asserts for success in the low-level call.
883 
884         bytes memory returndata = address(token).functionCall(
885             data,
886             "SafeBEP20: low-level call failed"
887         );
888         if (returndata.length > 0) {
889             // Return data is optional
890             // solhint-disable-next-line max-line-length
891             require(
892                 abi.decode(returndata, (bool)),
893                 "SafeBEP20: BEP20 operation did not succeed"
894             );
895         }
896     }
897 }
898 
899 // File: contracts/SmartChefInitializable.sol
900 
901 contract SmartChefInitializable is Ownable, ReentrancyGuard {
902     using SafeMath for uint256;
903     using SafeBEP20 for IBEP20;
904 
905     address public dev1;
906     address public dev2;
907     address public dev3;
908 
909     // Deposit fee in basis points
910     uint256 public depositFeeBP = 300; //3%
911 
912     // Withdraw fee in basis points
913     uint256 public withdrawFeeBP = 300; //3%
914 
915     // Claim fee in basis points
916     uint256 public HarvestfeeBP = 1000; //10%
917 
918     // The address of the smart chef factory
919     address public SMART_CHEF_FACTORY;
920 
921     // Whether a limit is set for users
922     bool public hasUserLimit;
923 
924     // Whether it is initialized
925     bool public isInitialized;
926 
927     // Accrued token per share
928     uint256 public accTokenPerShare;
929 
930     // The block number when Chedda mining ends.
931     uint256 public bonusEndBlock;
932 
933     // The block number when Chedda mining starts.
934     uint256 public startBlock;
935 
936     // The block number of the last pool update
937     uint256 public lastRewardBlock;
938 
939     // The pool limit (0 if none)
940     uint256 public poolLimitPerUser;
941 
942     // Chedda tokens created per block.
943     uint256 public rewardPerBlock;
944 
945     // The precision factor
946     uint256 public PRECISION_FACTOR;
947 
948     // The reward token
949     IBEP20 public rewardToken;
950 
951     // The staked token
952     IBEP20 public stakedToken;
953 
954     // Info of each user that stakes tokens (stakedToken)
955     mapping(address => UserInfo) public userInfo;
956 
957     struct UserInfo {
958         address playerAddy;
959         uint256 amount; // How many staked tokens the user has provided
960         uint256 rewardDebt; // Reward debt
961     }
962 
963     UserInfo[] public UsersInfo;
964 
965     event AdminTokenRecovery(address tokenRecovered, uint256 amount);
966     event Deposit(address indexed user, uint256 amount);
967     event EmergencyWithdraw(address indexed user, uint256 amount);
968     event NewStartAndEndBlocks(uint256 startBlock, uint256 endBlock);
969     event NewRewardPerBlock(uint256 rewardPerBlock);
970     event NewPoolLimit(uint256 poolLimitPerUser);
971     event RewardsStop(uint256 blockNumber);
972     event Withdraw(address indexed user, uint256 amount);
973     event SetDevs(address dev1, address dev2, address dev3);
974     event SetDepositFee(uint256 depositFeeBP);
975     event SetWithdrawFee(uint256 withdrawFeeBP);
976     event SetHarvestfee(uint256 HarvestfeeBP);
977 
978     constructor() {
979         SMART_CHEF_FACTORY = msg.sender;
980     }
981 
982     /*
983      * @notice Initialize the contract
984      * @param _stakedToken: staked token address
985      * @param _rewardToken: reward token address
986      * @param _rewardPerBlock: reward per block (in rewardToken)
987      * @param _startBlock: start block
988      * @param _bonusEndBlock: end block
989      * @param _poolLimitPerUser: pool limit per user in stakedToken (if any, else 0)
990      * @param _admin: admin address with ownership
991      */
992 
993     function initialize(
994         IBEP20 _stakedToken,
995         IBEP20 _rewardToken,
996         uint256 _rewardPerBlock,
997         uint256 _startBlock,
998         uint256 _bonusEndBlock,
999         uint256 _poolLimitPerUser,
1000         address _admin
1001     ) external {
1002         require(!isInitialized, "Already initialized");
1003         require(msg.sender == SMART_CHEF_FACTORY, "Not factory");
1004 
1005         // Make this contract initialized
1006         isInitialized = true;
1007 
1008         stakedToken = _stakedToken;
1009         rewardToken = _rewardToken;
1010         rewardPerBlock = _rewardPerBlock;
1011         startBlock = _startBlock;
1012         bonusEndBlock = _bonusEndBlock;
1013 
1014         if (_poolLimitPerUser > 0) {
1015             hasUserLimit = true;
1016             poolLimitPerUser = _poolLimitPerUser;
1017         }
1018 
1019         uint256 decimalsRewardToken = uint256(rewardToken.decimals());
1020         require(decimalsRewardToken < 30, "Must be inferior to 30");
1021 
1022         PRECISION_FACTOR = uint256(10**(uint256(30).sub(decimalsRewardToken)));
1023 
1024         // Set the lastRewardBlock as the startBlock
1025         lastRewardBlock = startBlock;
1026 
1027         // Transfer ownership to the admin address who becomes owner of the contract
1028         transferOwnership(_admin);
1029     }
1030 
1031     /*
1032      * @notice Deposit staked tokens and collect reward tokens (if any)
1033      * @param _amount: amount to withdraw (in rewardToken)
1034      */
1035     function deposit(uint256 _amount) external nonReentrant {
1036         UserInfo storage user = userInfo[msg.sender];
1037 
1038         if (user.playerAddy != msg.sender) {
1039             user.playerAddy = msg.sender;
1040             UsersInfo.push(user);
1041         }
1042 
1043         if (hasUserLimit) {
1044             require(
1045                 _amount.add(user.amount) <= poolLimitPerUser,
1046                 "User amount above limit"
1047             );
1048         }
1049         _updatePool();
1050 
1051         if (user.amount > 0) {
1052             uint256 pending = user
1053                 .amount
1054                 .mul(accTokenPerShare)
1055                 .div(PRECISION_FACTOR)
1056                 .sub(user.rewardDebt);
1057             if (pending > 0) {
1058                 uint256 Harvestfee = (pending * HarvestfeeBP) / 10000;
1059                 rewardToken.safeTransfer(address(msg.sender), pending);
1060                 rewardToken.safeTransfer(dev3, Harvestfee);
1061             }
1062         }
1063 
1064         if (_amount > 0) {
1065             uint256 depositFee = (_amount * depositFeeBP) / 10000;
1066             uint256 depositAmount = _amount.sub(depositFee);
1067             user.amount = user.amount.add(depositAmount);
1068             stakedToken.safeTransferFrom(
1069                 address(msg.sender),
1070                 address(this),
1071                 depositAmount
1072             );
1073             stakedToken.safeTransferFrom(address(msg.sender), dev2, depositFee);
1074         }
1075 
1076         user.rewardDebt = user.amount.mul(accTokenPerShare).div(
1077             PRECISION_FACTOR
1078         );
1079 
1080         emit Deposit(msg.sender, _amount);
1081     }
1082 
1083     /*
1084      * @notice Withdraw staked tokens and collect reward tokens
1085      * @param _amount: amount to withdraw (in rewardToken)
1086      */
1087     function withdraw(uint256 _amount) external nonReentrant {
1088         UserInfo storage user = userInfo[msg.sender];
1089         require(user.amount >= _amount, "Amount to withdraw too high");
1090 
1091         _updatePool();
1092 
1093         uint256 pending = user
1094             .amount
1095             .mul(accTokenPerShare)
1096             .div(PRECISION_FACTOR)
1097             .sub(user.rewardDebt);
1098 
1099         if (_amount > 0) {
1100             user.amount = user.amount.sub(_amount);
1101             uint256 WithdrawFee = (_amount * withdrawFeeBP) / 10000;
1102             stakedToken.safeTransfer(
1103                 address(msg.sender),
1104                 _amount.sub(WithdrawFee)
1105             );
1106             stakedToken.safeTransfer(dev1, WithdrawFee);
1107         }
1108 
1109         if (pending > 0) {
1110             uint256 Harvestfee = (pending * HarvestfeeBP) / 10000;
1111             rewardToken.safeTransfer(address(msg.sender), pending);
1112             rewardToken.safeTransfer(dev3, Harvestfee);
1113         }
1114 
1115         user.rewardDebt = user.amount.mul(accTokenPerShare).div(
1116             PRECISION_FACTOR
1117         );
1118         emit Withdraw(msg.sender, _amount);
1119     }
1120 
1121     /*
1122      * @notice Withdraw staked tokens without caring about rewards rewards
1123      * @dev Needs to be for emergency.
1124      */
1125     function emergencyWithdraw() external nonReentrant {
1126         UserInfo storage user = userInfo[msg.sender];
1127 
1128         if (user.amount > 0) {
1129             uint256 WithdrawFee = (user.amount * withdrawFeeBP) / 10000;
1130             stakedToken.safeTransfer(
1131                 address(msg.sender),
1132                 user.amount.sub(WithdrawFee)
1133             );
1134             stakedToken.safeTransfer(dev1, WithdrawFee);
1135         }
1136 
1137         user.amount = 0;
1138         user.rewardDebt = 0;
1139         emit EmergencyWithdraw(msg.sender, user.amount);
1140     }
1141 
1142     /*
1143      * @notice Stop rewards
1144      * @dev Only callable by owner. Needs to be for emergency.
1145      */
1146     function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
1147         rewardToken.safeTransfer(address(msg.sender), _amount);
1148     }
1149 
1150     /**
1151      * @notice It allows the admin to recover wrong tokens sent to the contract
1152      * @param _tokenAddress: the address of the token to withdraw
1153      * @param _tokenAmount: the number of tokens to withdraw
1154      * @dev This function is only callable by admin.
1155      */
1156 
1157     function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount)
1158         external
1159         onlyOwner
1160     {
1161         require(
1162             _tokenAddress != address(stakedToken),
1163             "Cannot be staked token"
1164         );
1165         require(
1166             _tokenAddress != address(rewardToken),
1167             "Cannot be reward token"
1168         );
1169 
1170         IBEP20(_tokenAddress).safeTransfer(address(msg.sender), _tokenAmount);
1171 
1172         emit AdminTokenRecovery(_tokenAddress, _tokenAmount);
1173     }
1174 
1175     /*
1176      * @notice Stop rewards
1177      * @dev Only callable by owner
1178      */
1179     function stopReward() external onlyOwner {
1180         bonusEndBlock = block.number;
1181     }
1182 
1183     /*
1184      * @notice Update pool limit per user
1185      * @dev Only callable by owner.
1186      * @param _hasUserLimit: whether the limit remains forced
1187      * @param _poolLimitPerUser: new pool limit per user
1188      */
1189 
1190     function updatePoolLimitPerUser(
1191         bool _hasUserLimit,
1192         uint256 _poolLimitPerUser
1193     ) external onlyOwner {
1194         require(hasUserLimit, "Must be set");
1195         if (_hasUserLimit) {
1196             require(
1197                 _poolLimitPerUser > poolLimitPerUser,
1198                 "New limit must be higher"
1199             );
1200             poolLimitPerUser = _poolLimitPerUser;
1201         } else {
1202             hasUserLimit = _hasUserLimit;
1203             poolLimitPerUser = 0;
1204         }
1205         emit NewPoolLimit(poolLimitPerUser);
1206     }
1207 
1208     /*
1209      * @notice Update reward per block
1210      * @dev Only callable by owner.
1211      * @param _rewardPerBlock: the reward per block
1212      */
1213     function updateRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner {
1214         rewardPerBlock = _rewardPerBlock;
1215         emit NewRewardPerBlock(_rewardPerBlock);
1216     }
1217 
1218     /**
1219      * @notice It allows the admin to update start and end blocks
1220      * @dev This function is only callable by owner.
1221      * @param _startBlock: the new start block
1222      * @param _bonusEndBlock: the new end block
1223      */
1224 
1225     function updateStartAndEndBlocks(
1226         uint256 _startBlock,
1227         uint256 _bonusEndBlock
1228     ) external onlyOwner {
1229         require(block.number < startBlock, "Pool has started");
1230         require(
1231             _startBlock < _bonusEndBlock,
1232             "New startBlock must be lower than new endBlock"
1233         );
1234         require(
1235             block.number < _startBlock,
1236             "New startBlock must be higher than current block"
1237         );
1238 
1239         startBlock = _startBlock;
1240         bonusEndBlock = _bonusEndBlock;
1241 
1242         // Set the lastRewardBlock as the startBlock
1243         lastRewardBlock = startBlock;
1244 
1245         emit NewStartAndEndBlocks(_startBlock, _bonusEndBlock);
1246     }
1247 
1248     /*
1249      * @notice View function to see pending reward on frontend.
1250      * @param _user: user address
1251      * @return Pending reward for a given user
1252      */
1253 
1254     function pendingRewards() public view returns (uint256) {
1255         uint256 pendingRewardsTotal = 0;
1256         for (uint256 i = 0; i < UsersInfo.length; i++) {
1257             pendingRewardsTotal += pendingReward(UsersInfo[i].playerAddy);
1258         }
1259         return pendingRewardsTotal;
1260     }
1261 
1262     function effectiveRewards() public view returns (uint256) {
1263         uint256 effectiveReward=0;
1264         if (rewardToken.balanceOf(address(this)) > pendingRewards())
1265         {
1266         effectiveReward = rewardToken.balanceOf(address(this)).sub(
1267             pendingRewards()
1268         );
1269         }
1270         return effectiveReward;
1271     }
1272 
1273     function pendingReward(address _user) public view returns (uint256) {
1274         UserInfo storage user = userInfo[_user];
1275         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1276         if (block.number > lastRewardBlock && stakedTokenSupply != 0) {
1277             uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1278             uint256 CheddaReward = multiplier.mul(rewardPerBlock);
1279             uint256 adjustedTokenPerShare = accTokenPerShare.add(
1280                 CheddaReward.mul(PRECISION_FACTOR).div(stakedTokenSupply)
1281             );
1282             return
1283                 user
1284                     .amount
1285                     .mul(adjustedTokenPerShare)
1286                     .div(PRECISION_FACTOR)
1287                     .sub(user.rewardDebt);
1288         } else {
1289             return
1290                 user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(
1291                     user.rewardDebt
1292                 );
1293         }
1294     }
1295 
1296     /*
1297      * @notice Update reward variables of the given pool to be up-to-date.
1298      */
1299     function _updatePool() internal {
1300         if (block.number <= lastRewardBlock) {
1301             return;
1302         }
1303 
1304         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1305 
1306         if (stakedTokenSupply == 0) {
1307             lastRewardBlock = block.number;
1308             return;
1309         }
1310 
1311         uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1312         uint256 CheddaReward = multiplier.mul(rewardPerBlock);
1313         accTokenPerShare = accTokenPerShare.add(
1314             CheddaReward.mul(PRECISION_FACTOR).div(stakedTokenSupply)
1315         );
1316         lastRewardBlock = block.number;
1317     }
1318 
1319     /*
1320      * @notice Return reward multiplier over the given _from to _to block.
1321      * @param _from: block to start
1322      * @param _to: block to finish
1323      */
1324     function _getMultiplier(uint256 _from, uint256 _to)
1325         internal
1326         view
1327         returns (uint256)
1328     {
1329         if (_to <= bonusEndBlock) {
1330             return _to.sub(_from);
1331         } else if (_from >= bonusEndBlock) {
1332             return 0;
1333         } else {
1334             return bonusEndBlock.sub(_from);
1335         }
1336     }
1337 
1338  function ChangedevAddress(address _dev1, address _dev2, address _dev3) external onlyOwner {
1339         require(_dev1 != address(0), "!nonzero");
1340         require(_dev2 != address(0), "!nonzero");
1341         require(_dev3 != address(0), "!nonzero");
1342         dev1 = _dev1;
1343         dev2 = _dev2;
1344         dev3 = _dev3;
1345         emit SetDevs(_dev1, _dev2, _dev3);
1346     }
1347 
1348     function ChangedepositFeeBP(uint256 _depositFeeBP) external onlyOwner {
1349         depositFeeBP = _depositFeeBP;
1350         emit SetDepositFee(_depositFeeBP);
1351     }
1352 
1353     function ChangewithdrawFeeBP(uint256 _withdrawFeeBP) external onlyOwner {
1354         withdrawFeeBP = _withdrawFeeBP;
1355         emit SetWithdrawFee(_withdrawFeeBP);
1356     }
1357 
1358     function ChangeHarvestfeeBP(uint256 _HarvestfeeBP) external onlyOwner {
1359         require(_HarvestfeeBP < 2000, "max 20%");
1360         HarvestfeeBP = _HarvestfeeBP;
1361         emit SetHarvestfee(_HarvestfeeBP);
1362     }
1363 }