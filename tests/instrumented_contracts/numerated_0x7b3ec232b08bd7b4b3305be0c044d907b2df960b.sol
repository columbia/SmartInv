1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File @chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol@v0.1.6
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity >=0.6.0;
7 
8 interface AggregatorV3Interface {
9 
10   function decimals() external view returns (uint8);
11   function description() external view returns (string memory);
12   function version() external view returns (uint256);
13 
14   // getRoundData and latestRoundData should both raise "No data present"
15   // if they do not have data to report, instead of returning unset values
16   // which could be misinterpreted as actual reported values.
17   function getRoundData(uint80 _roundId)
18     external
19     view
20     returns (
21       uint80 roundId,
22       int256 answer,
23       uint256 startedAt,
24       uint256 updatedAt,
25       uint80 answeredInRound
26     );
27   function latestRoundData()
28     external
29     view
30     returns (
31       uint80 roundId,
32       int256 answer,
33       uint256 startedAt,
34       uint256 updatedAt,
35       uint80 answeredInRound
36     );
37 
38 }
39 
40 
41 // File @chainlink/contracts/src/v0.7/interfaces/LinkTokenInterface.sol@v0.1.6
42 
43 pragma solidity ^0.7.0;
44 
45 interface LinkTokenInterface {
46   function allowance(address owner, address spender) external view returns (uint256 remaining);
47   function approve(address spender, uint256 value) external returns (bool success);
48   function balanceOf(address owner) external view returns (uint256 balance);
49   function decimals() external view returns (uint8 decimalPlaces);
50   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
51   function increaseApproval(address spender, uint256 subtractedValue) external;
52   function name() external view returns (string memory tokenName);
53   function symbol() external view returns (string memory tokenSymbol);
54   function totalSupply() external view returns (uint256 totalTokensIssued);
55   function transfer(address to, uint256 value) external returns (bool success);
56   function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool success);
57   function transferFrom(address from, address to, uint256 value) external returns (bool success);
58 }
59 
60 
61 // File @chainlink/contracts/src/v0.7/vendor/SafeMathChainlink.sol@v0.1.6
62 
63 pragma solidity ^0.7.0;
64 
65 /**
66  * @dev Wrappers over Solidity's arithmetic operations with added overflow
67  * checks.
68  *
69  * Arithmetic operations in Solidity wrap on overflow. This can easily result
70  * in bugs, because programmers usually assume that an overflow raises an
71  * error, which is the standard behavior in high level programming languages.
72  * `SafeMath` restores this intuition by reverting the transaction when an
73  * operation overflows.
74  *
75  * Using this library instead of the unchecked operations eliminates an entire
76  * class of bugs, so it's recommended to use it always.
77  */
78 library SafeMathChainlink {
79   /**
80     * @dev Returns the addition of two unsigned integers, reverting on
81     * overflow.
82     *
83     * Counterpart to Solidity's `+` operator.
84     *
85     * Requirements:
86     * - Addition cannot overflow.
87     */
88   function add(uint256 a, uint256 b) internal pure returns (uint256) {
89     uint256 c = a + b;
90     require(c >= a, "SafeMath: addition overflow");
91 
92     return c;
93   }
94 
95   /**
96     * @dev Returns the subtraction of two unsigned integers, reverting on
97     * overflow (when the result is negative).
98     *
99     * Counterpart to Solidity's `-` operator.
100     *
101     * Requirements:
102     * - Subtraction cannot overflow.
103     */
104   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105     require(b <= a, "SafeMath: subtraction overflow");
106     uint256 c = a - b;
107 
108     return c;
109   }
110 
111   /**
112     * @dev Returns the multiplication of two unsigned integers, reverting on
113     * overflow.
114     *
115     * Counterpart to Solidity's `*` operator.
116     *
117     * Requirements:
118     * - Multiplication cannot overflow.
119     */
120   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
122     // benefit is lost if 'b' is also tested.
123     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
124     if (a == 0) {
125       return 0;
126     }
127 
128     uint256 c = a * b;
129     require(c / a == b, "SafeMath: multiplication overflow");
130 
131     return c;
132   }
133 
134   /**
135     * @dev Returns the integer division of two unsigned integers. Reverts on
136     * division by zero. The result is rounded towards zero.
137     *
138     * Counterpart to Solidity's `/` operator. Note: this function uses a
139     * `revert` opcode (which leaves remaining gas untouched) while Solidity
140     * uses an invalid opcode to revert (consuming all remaining gas).
141     *
142     * Requirements:
143     * - The divisor cannot be zero.
144     */
145   function div(uint256 a, uint256 b) internal pure returns (uint256) {
146     // Solidity only automatically asserts when dividing by 0
147     require(b > 0, "SafeMath: division by zero");
148     uint256 c = a / b;
149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150 
151     return c;
152   }
153 
154   /**
155     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156     * Reverts when dividing by zero.
157     *
158     * Counterpart to Solidity's `%` operator. This function uses a `revert`
159     * opcode (which leaves remaining gas untouched) while Solidity uses an
160     * invalid opcode to revert (consuming all remaining gas).
161     *
162     * Requirements:
163     * - The divisor cannot be zero.
164     */
165   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166     require(b != 0, "SafeMath: modulo by zero");
167     return a % b;
168   }
169 }
170 
171 
172 // File contracts/vendor/Owned.sol
173 
174 
175 pragma solidity ^0.7.0;
176 
177 /**
178  * @title The Owned contract
179  * @notice A contract with helpers for basic contract ownership.
180  */
181 contract Owned {
182 
183   address public owner;
184   address private pendingOwner;
185 
186   event OwnershipTransferRequested(
187     address indexed from,
188     address indexed to
189   );
190   event OwnershipTransferred(
191     address indexed from,
192     address indexed to
193   );
194 
195   constructor() {
196     owner = msg.sender;
197   }
198 
199   /**
200    * @dev Allows an owner to begin transferring ownership to a new address,
201    * pending.
202    */
203   function transferOwnership(address _to)
204     external
205     onlyOwner()
206   {
207     pendingOwner = _to;
208 
209     emit OwnershipTransferRequested(owner, _to);
210   }
211 
212   /**
213    * @dev Allows an ownership transfer to be completed by the recipient.
214    */
215   function acceptOwnership()
216     external
217   {
218     require(msg.sender == pendingOwner, "Must be proposed owner");
219 
220     address oldOwner = owner;
221     owner = msg.sender;
222     pendingOwner = address(0);
223 
224     emit OwnershipTransferred(oldOwner, msg.sender);
225   }
226 
227   /**
228    * @dev Reverts if called by anyone other than the contract owner.
229    */
230   modifier onlyOwner() {
231     require(msg.sender == owner, "Only callable by owner");
232     _;
233   }
234 
235 }
236 
237 
238 // File contracts/vendor/Address.sol
239 
240 // github.com/OpenZeppelin/openzeppelin-contracts@fa64a1ced0b70ab89073d5d0b6e01b0778f7e7d6
241 
242 pragma solidity >=0.6.2 <0.8.0;
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // This method relies on extcodesize, which returns 0 for contracts in
267         // construction, since the code is only stored at the end of the
268         // constructor execution.
269 
270         uint256 size;
271         // solhint-disable-next-line no-inline-assembly
272         assembly { size := extcodesize(account) }
273         return size > 0;
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
296         (bool success, ) = recipient.call{ value: amount }("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain`call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319       return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
354         require(address(this).balance >= value, "Address: insufficient balance for call");
355         require(isContract(target), "Address: call to non-contract");
356 
357         // solhint-disable-next-line avoid-low-level-calls
358         (bool success, bytes memory returndata) = target.call{ value: value }(data);
359         return _verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but performing a static call.
365      *
366      * _Available since v3.3._
367      */
368     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
369         return functionStaticCall(target, data, "Address: low-level static call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
374      * but performing a static call.
375      *
376      * _Available since v3.3._
377      */
378     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
379         require(isContract(target), "Address: static call to non-contract");
380 
381         // solhint-disable-next-line avoid-low-level-calls
382         (bool success, bytes memory returndata) = target.staticcall(data);
383         return _verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
403         require(isContract(target), "Address: delegate call to non-contract");
404 
405         // solhint-disable-next-line avoid-low-level-calls
406         (bool success, bytes memory returndata) = target.delegatecall(data);
407         return _verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
411         if (success) {
412             return returndata;
413         } else {
414             // Look for revert reason and bubble it up if present
415             if (returndata.length > 0) {
416                 // The easiest way to bubble the revert reason is using memory via assembly
417 
418                 // solhint-disable-next-line no-inline-assembly
419                 assembly {
420                     let returndata_size := mload(returndata)
421                     revert(add(32, returndata), returndata_size)
422                 }
423             } else {
424                 revert(errorMessage);
425             }
426         }
427     }
428 }
429 
430 
431 // File contracts/vendor/Context.sol
432 
433 // github.com/OpenZeppelin/openzeppelin-contracts@fa64a1ced0b70ab89073d5d0b6e01b0778f7e7d6
434 
435 pragma solidity >=0.6.0 <0.8.0;
436 
437 /*
438  * @dev Provides information about the current execution context, including the
439  * sender of the transaction and its data. While these are generally available
440  * via msg.sender and msg.data, they should not be accessed in such a direct
441  * manner, since when dealing with GSN meta-transactions the account sending and
442  * paying for execution may not be the actual sender (as far as an application
443  * is concerned).
444  *
445  * This contract is only required for intermediate, library-like contracts.
446  */
447 abstract contract Context {
448     function _msgSender() internal view virtual returns (address payable) {
449         return msg.sender;
450     }
451 
452     function _msgData() internal view virtual returns (bytes memory) {
453         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
454         return msg.data;
455     }
456 }
457 
458 
459 // File contracts/vendor/Pausable.sol
460 
461 // github.com/OpenZeppelin/openzeppelin-contracts@fa64a1ced0b70ab89073d5d0b6e01b0778f7e7d6
462 
463 pragma solidity >=0.6.0 <0.8.0;
464 
465 /**
466  * @dev Contract module which allows children to implement an emergency stop
467  * mechanism that can be triggered by an authorized account.
468  *
469  * This module is used through inheritance. It will make available the
470  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
471  * the functions of your contract. Note that they will not be pausable by
472  * simply including this module, only once the modifiers are put in place.
473  */
474 abstract contract Pausable is Context {
475     /**
476      * @dev Emitted when the pause is triggered by `account`.
477      */
478     event Paused(address account);
479 
480     /**
481      * @dev Emitted when the pause is lifted by `account`.
482      */
483     event Unpaused(address account);
484 
485     bool private _paused;
486 
487     /**
488      * @dev Initializes the contract in unpaused state.
489      */
490     constructor () {
491         _paused = false;
492     }
493 
494     /**
495      * @dev Returns true if the contract is paused, and false otherwise.
496      */
497     function paused() public view virtual returns (bool) {
498         return _paused;
499     }
500 
501     /**
502      * @dev Modifier to make a function callable only when the contract is not paused.
503      *
504      * Requirements:
505      *
506      * - The contract must not be paused.
507      */
508     modifier whenNotPaused() {
509         require(!paused(), "Pausable: paused");
510         _;
511     }
512 
513     /**
514      * @dev Modifier to make a function callable only when the contract is paused.
515      *
516      * Requirements:
517      *
518      * - The contract must be paused.
519      */
520     modifier whenPaused() {
521         require(paused(), "Pausable: not paused");
522         _;
523     }
524 
525     /**
526      * @dev Triggers stopped state.
527      *
528      * Requirements:
529      *
530      * - The contract must not be paused.
531      */
532     function _pause() internal virtual whenNotPaused {
533         _paused = true;
534         emit Paused(_msgSender());
535     }
536 
537     /**
538      * @dev Returns to normal state.
539      *
540      * Requirements:
541      *
542      * - The contract must be paused.
543      */
544     function _unpause() internal virtual whenPaused {
545         _paused = false;
546         emit Unpaused(_msgSender());
547     }
548 }
549 
550 
551 // File contracts/vendor/ReentrancyGuard.sol
552 
553 // github.com/OpenZeppelin/openzeppelin-contracts@fa64a1ced0b70ab89073d5d0b6e01b0778f7e7d6
554 
555 pragma solidity >=0.6.0 <0.8.0;
556 
557 /**
558  * @dev Contract module that helps prevent reentrant calls to a function.
559  *
560  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
561  * available, which can be applied to functions to make sure there are no nested
562  * (reentrant) calls to them.
563  *
564  * Note that because there is a single `nonReentrant` guard, functions marked as
565  * `nonReentrant` may not call one another. This can be worked around by making
566  * those functions `private`, and then adding `external` `nonReentrant` entry
567  * points to them.
568  *
569  * TIP: If you would like to learn more about reentrancy and alternative ways
570  * to protect against it, check out our blog post
571  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
572  */
573 abstract contract ReentrancyGuard {
574     // Booleans are more expensive than uint256 or any type that takes up a full
575     // word because each write operation emits an extra SLOAD to first read the
576     // slot's contents, replace the bits taken up by the boolean, and then write
577     // back. This is the compiler's defense against contract upgrades and
578     // pointer aliasing, and it cannot be disabled.
579 
580     // The values being non-zero value makes deployment a bit more expensive,
581     // but in exchange the refund on every call to nonReentrant will be lower in
582     // amount. Since refunds are capped to a percentage of the total
583     // transaction's gas, it is best to keep them low in cases like this one, to
584     // increase the likelihood of the full refund coming into effect.
585     uint256 private constant _NOT_ENTERED = 1;
586     uint256 private constant _ENTERED = 2;
587 
588     uint256 private _status;
589 
590     constructor () {
591         _status = _NOT_ENTERED;
592     }
593 
594     /**
595      * @dev Prevents a contract from calling itself, directly or indirectly.
596      * Calling a `nonReentrant` function from another `nonReentrant`
597      * function is not supported. It is possible to prevent this from happening
598      * by making the `nonReentrant` function external, and make it call a
599      * `private` function that does the actual work.
600      */
601     modifier nonReentrant() {
602         // On the first call to nonReentrant, _notEntered will be true
603         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
604 
605         // Any calls to nonReentrant after this point will fail
606         _status = _ENTERED;
607 
608         _;
609 
610         // By storing the original value once again, a refund is triggered (see
611         // https://eips.ethereum.org/EIPS/eip-2200)
612         _status = _NOT_ENTERED;
613     }
614 }
615 
616 
617 // File contracts/vendor/SignedSafeMath.sol
618 
619 
620 pragma solidity >=0.6.0 <0.8.0;
621 
622 /**
623  * @title SignedSafeMath
624  * @dev Signed math operations with safety checks that revert on error.
625  */
626 library SignedSafeMath {
627     int256 constant private _INT256_MIN = -2**255;
628 
629     /**
630      * @dev Returns the multiplication of two signed integers, reverting on
631      * overflow.
632      *
633      * Counterpart to Solidity's `*` operator.
634      *
635      * Requirements:
636      *
637      * - Multiplication cannot overflow.
638      */
639     function mul(int256 a, int256 b) internal pure returns (int256) {
640         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
641         // benefit is lost if 'b' is also tested.
642         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
643         if (a == 0) {
644             return 0;
645         }
646 
647         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
648 
649         int256 c = a * b;
650         require(c / a == b, "SignedSafeMath: multiplication overflow");
651 
652         return c;
653     }
654 
655     /**
656      * @dev Returns the integer division of two signed integers. Reverts on
657      * division by zero. The result is rounded towards zero.
658      *
659      * Counterpart to Solidity's `/` operator. Note: this function uses a
660      * `revert` opcode (which leaves remaining gas untouched) while Solidity
661      * uses an invalid opcode to revert (consuming all remaining gas).
662      *
663      * Requirements:
664      *
665      * - The divisor cannot be zero.
666      */
667     function div(int256 a, int256 b) internal pure returns (int256) {
668         require(b != 0, "SignedSafeMath: division by zero");
669         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
670 
671         int256 c = a / b;
672 
673         return c;
674     }
675 
676     /**
677      * @dev Returns the subtraction of two signed integers, reverting on
678      * overflow.
679      *
680      * Counterpart to Solidity's `-` operator.
681      *
682      * Requirements:
683      *
684      * - Subtraction cannot overflow.
685      */
686     function sub(int256 a, int256 b) internal pure returns (int256) {
687         int256 c = a - b;
688         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
689 
690         return c;
691     }
692 
693     /**
694      * @dev Returns the addition of two signed integers, reverting on
695      * overflow.
696      *
697      * Counterpart to Solidity's `+` operator.
698      *
699      * Requirements:
700      *
701      * - Addition cannot overflow.
702      */
703     function add(int256 a, int256 b) internal pure returns (int256) {
704         int256 c = a + b;
705         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
706 
707         return c;
708     }
709 }
710 
711 
712 // File contracts/SafeMath96.sol
713 
714 
715 pragma solidity ^0.7.0;
716 
717 /**
718  * @dev Wrappers over Solidity's arithmetic operations with added overflow
719  * checks.
720  *
721  * Arithmetic operations in Solidity wrap on overflow. This can easily result
722  * in bugs, because programmers usually assume that an overflow raises an
723  * error, which is the standard behavior in high level programming languages.
724  * `SafeMath` restores this intuition by reverting the transaction when an
725  * operation overflows.
726  *
727  * Using this library instead of the unchecked operations eliminates an entire
728  * class of bugs, so it's recommended to use it always.
729  *
730  * This library is a version of Open Zeppelin's SafeMath, modified to support
731  * unsigned 96 bit integers.
732  */
733 library SafeMath96 {
734   /**
735     * @dev Returns the addition of two unsigned integers, reverting on
736     * overflow.
737     *
738     * Counterpart to Solidity's `+` operator.
739     *
740     * Requirements:
741     * - Addition cannot overflow.
742     */
743   function add(uint96 a, uint96 b) internal pure returns (uint96) {
744     uint96 c = a + b;
745     require(c >= a, "SafeMath: addition overflow");
746 
747     return c;
748   }
749 
750   /**
751     * @dev Returns the subtraction of two unsigned integers, reverting on
752     * overflow (when the result is negative).
753     *
754     * Counterpart to Solidity's `-` operator.
755     *
756     * Requirements:
757     * - Subtraction cannot overflow.
758     */
759   function sub(uint96 a, uint96 b) internal pure returns (uint96) {
760     require(b <= a, "SafeMath: subtraction overflow");
761     uint96 c = a - b;
762 
763     return c;
764   }
765 
766   /**
767     * @dev Returns the multiplication of two unsigned integers, reverting on
768     * overflow.
769     *
770     * Counterpart to Solidity's `*` operator.
771     *
772     * Requirements:
773     * - Multiplication cannot overflow.
774     */
775   function mul(uint96 a, uint96 b) internal pure returns (uint96) {
776     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
777     // benefit is lost if 'b' is also tested.
778     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
779     if (a == 0) {
780       return 0;
781     }
782 
783     uint96 c = a * b;
784     require(c / a == b, "SafeMath: multiplication overflow");
785 
786     return c;
787   }
788 
789   /**
790     * @dev Returns the integer division of two unsigned integers. Reverts on
791     * division by zero. The result is rounded towards zero.
792     *
793     * Counterpart to Solidity's `/` operator. Note: this function uses a
794     * `revert` opcode (which leaves remaining gas untouched) while Solidity
795     * uses an invalid opcode to revert (consuming all remaining gas).
796     *
797     * Requirements:
798     * - The divisor cannot be zero.
799     */
800   function div(uint96 a, uint96 b) internal pure returns (uint96) {
801     // Solidity only automatically asserts when dividing by 0
802     require(b > 0, "SafeMath: division by zero");
803     uint96 c = a / b;
804     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
805 
806     return c;
807   }
808 
809   /**
810     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
811     * Reverts when dividing by zero.
812     *
813     * Counterpart to Solidity's `%` operator. This function uses a `revert`
814     * opcode (which leaves remaining gas untouched) while Solidity uses an
815     * invalid opcode to revert (consuming all remaining gas).
816     *
817     * Requirements:
818     * - The divisor cannot be zero.
819     */
820   function mod(uint96 a, uint96 b) internal pure returns (uint96) {
821     require(b != 0, "SafeMath: modulo by zero");
822     return a % b;
823   }
824 }
825 
826 
827 // File contracts/KeeperBase.sol
828 
829 
830 pragma solidity 0.7.6;
831 
832 contract KeeperBase {
833 
834   /**
835    * @notice method that allows it to be simulated via eth_call by checking that
836    * the sender is the zero address.
837    */
838   function preventExecution()
839     internal
840     view
841   {
842     require(tx.origin == address(0), "only for simulated backend");
843   }
844 
845   /**
846    * @notice modifier that allows it to be simulated via eth_call by checking
847    * that the sender is the zero address.
848    */
849   modifier cannotExecute()
850   {
851     preventExecution();
852     _;
853   }
854 
855 }
856 
857 
858 // File contracts/KeeperCompatibleInterface.sol
859 
860 
861 pragma solidity 0.7.6;
862 
863 interface KeeperCompatibleInterface {
864 
865   /**
866    * @notice method that is simulated by the keepers to see if any work actually
867    * needs to be performed. This method does does not actually need to be
868    * executable, and since it is only ever simulated it can consume lots of gas.
869    * @dev To ensure that it is never called, you may want to add the
870    * cannotExecute modifier from KeeperBase to your implementation of this
871    * method.
872    * @param checkData specified in the upkeep registration so it is always the
873    * same for a registered upkeep. This can easilly be broken down into specific
874    * arguments using `abi.decode`, so multiple upkeeps can be registered on the
875    * same contract and easily differentiated by the contract.
876    * @return upkeepNeeded boolean to indicate whether the keeper should call
877    * performUpkeep or not.
878    * @return performData bytes that the keeper should call performUpkeep with, if
879    * upkeep is needed. If you would like to encode data to decode later, try
880    * `abi.encode`.
881    */
882   function checkUpkeep(
883     bytes calldata checkData
884   )
885     external
886     returns (
887       bool upkeepNeeded,
888       bytes memory performData
889     );
890   /**
891    * @notice method that is actually executed by the keepers, via the registry.
892    * The data returned by the checkUpkeep simulation will be passed into
893    * this method to actually be executed.
894    * @dev The input to this method should not be trusted, and the caller of the
895    * method should not even be restricted to any single registry. Anyone should
896    * be able call it, and the input should be validated, there is no guarantee
897    * that the data passed in is the performData returned from checkUpkeep. This
898    * could happen due to malicious keepers, racing keepers, or simply a state
899    * change while the performUpkeep transaction is waiting for confirmation.
900    * Always validate the data passed in.
901    * @param performData is the data which was passed back from the checkData
902    * simulation. If it is encoded, it can easily be decoded into other types by
903    * calling `abi.decode`. This data should not be trusted, and should be
904    * validated against the contract's current state.
905    */
906   function performUpkeep(
907     bytes calldata performData
908   ) external;
909 }
910 
911 
912 // File contracts/KeeperRegistryInterface.sol
913 
914 
915 pragma solidity 0.7.6;
916 
917 interface KeeperRegistryBaseInterface {
918   function registerUpkeep(
919     address target,
920     uint32 gasLimit,
921     address admin,
922     bytes calldata checkData
923   ) external returns (
924       uint256 id
925     );
926   function performUpkeep(
927     uint256 id,
928     bytes calldata performData
929   ) external returns (
930       bool success
931     );
932   function cancelUpkeep(
933     uint256 id
934   ) external;
935   function addFunds(
936     uint256 id,
937     uint96 amount
938   ) external;
939 
940   function getUpkeep(uint256 id)
941     external view returns (
942       address target,
943       uint32 executeGas,
944       bytes memory checkData,
945       uint96 balance,
946       address lastKeeper,
947       address admin,
948       uint64 maxValidBlocknumber
949     );
950   function getUpkeepCount()
951     external view returns (uint256);
952   function getCanceledUpkeepList()
953     external view returns (uint256[] memory);
954   function getKeeperList()
955     external view returns (address[] memory);
956   function getKeeperInfo(address query)
957     external view returns (
958       address payee,
959       bool active,
960       uint96 balance
961     );
962   function getConfig()
963     external view returns (
964       uint32 paymentPremiumPPB,
965       uint24 checkFrequencyBlocks,
966       uint32 checkGasLimit,
967       uint24 stalenessSeconds,
968       uint16 gasCeilingMultiplier,
969       uint256 fallbackGasPrice,
970       uint256 fallbackLinkPrice
971     );
972 }
973 
974 /**
975   * @dev The view methods are not actually marked as view in the implementation
976   * but we want them to be easily queried off-chain. Solidity will not compile
977   * if we actually inherrit from this interface, so we document it here.
978   */
979 interface KeeperRegistryInterface is KeeperRegistryBaseInterface {
980   function checkUpkeep(
981     uint256 upkeepId,
982     address from
983   )
984     external
985     view
986     returns (
987       bytes memory performData,
988       uint256 maxLinkPayment,
989       uint256 gasLimit,
990       int256 gasWei,
991       int256 linkEth
992     );
993 }
994 
995 interface KeeperRegistryExecutableInterface is KeeperRegistryBaseInterface {
996   function checkUpkeep(
997     uint256 upkeepId,
998     address from
999   )
1000     external
1001     returns (
1002       bytes memory performData,
1003       uint256 maxLinkPayment,
1004       uint256 gasLimit,
1005       uint256 adjustedGasWei,
1006       uint256 linkEth
1007     );
1008 }
1009 
1010 
1011 // File contracts/KeeperRegistry.sol
1012 
1013 
1014 pragma solidity 0.7.6;
1015 
1016 
1017 
1018 
1019 
1020 
1021 
1022 
1023 
1024 
1025 
1026 
1027 /**
1028   * @notice Registry for adding work for Chainlink Keepers to perform on client
1029   * contracts. Clients must support the Upkeep interface.
1030   */
1031 contract KeeperRegistry is
1032   Owned,
1033   KeeperBase,
1034   ReentrancyGuard,
1035   Pausable,
1036   KeeperRegistryExecutableInterface
1037 {
1038   using Address for address;
1039   using SafeMathChainlink for uint256;
1040   using SafeMath96 for uint96;
1041   using SignedSafeMath for int256;
1042 
1043   address constant private ZERO_ADDRESS = address(0);
1044   address constant private IGNORE_ADDRESS = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
1045   bytes4 constant private CHECK_SELECTOR = KeeperCompatibleInterface.checkUpkeep.selector;
1046   bytes4 constant private PERFORM_SELECTOR = KeeperCompatibleInterface.performUpkeep.selector;
1047   uint256 constant private CALL_GAS_MAX = 5_000_000;
1048   uint256 constant private CALL_GAS_MIN = 2_300;
1049   uint256 constant private CANCELATION_DELAY = 50;
1050   uint256 constant private CUSHION = 5_000;
1051   uint256 constant private REGISTRY_GAS_OVERHEAD = 80_000;
1052   uint256 constant private PPB_BASE = 1_000_000_000;
1053   uint64 constant private UINT64_MAX = 2**64 - 1;
1054   uint96 constant private LINK_TOTAL_SUPPLY = 1e27;
1055 
1056   uint256 private s_upkeepCount;
1057   uint256[] private s_canceledUpkeepList;
1058   address[] private s_keeperList;
1059   mapping(uint256 => Upkeep) private s_upkeep;
1060   mapping(address => KeeperInfo) private s_keeperInfo;
1061   mapping(address => address) private s_proposedPayee;
1062   mapping(uint256 => bytes) private s_checkData;
1063   Config private s_config;
1064   uint256 private s_fallbackGasPrice;  // not in config object for gas savings
1065   uint256 private s_fallbackLinkPrice; // not in config object for gas savings
1066   uint256 private s_expectedLinkBalance;
1067 
1068   LinkTokenInterface public immutable LINK;
1069   AggregatorV3Interface public immutable LINK_ETH_FEED;
1070   AggregatorV3Interface public immutable FAST_GAS_FEED;
1071 
1072   address private s_registrar;
1073 
1074   struct Upkeep {
1075     address target;
1076     uint32 executeGas;
1077     uint96 balance;
1078     address admin;
1079     uint64 maxValidBlocknumber;
1080     address lastKeeper;
1081   }
1082 
1083   struct KeeperInfo {
1084     address payee;
1085     uint96 balance;
1086     bool active;
1087   }
1088 
1089   struct Config {
1090     uint32 paymentPremiumPPB;
1091     uint24 blockCountPerTurn;
1092     uint32 checkGasLimit;
1093     uint24 stalenessSeconds;
1094     uint16 gasCeilingMultiplier;
1095   }
1096 
1097   struct PerformParams {
1098     address from;
1099     uint256 id;
1100     bytes performData;
1101     uint256 maxLinkPayment;
1102     uint256 gasLimit;
1103     uint256 adjustedGasWei;
1104     uint256 linkEth;
1105   }
1106 
1107   event UpkeepRegistered(
1108     uint256 indexed id,
1109     uint32 executeGas,
1110     address admin
1111   );
1112   event UpkeepPerformed(
1113     uint256 indexed id,
1114     bool indexed success,
1115     address indexed from,
1116     uint96 payment,
1117     bytes performData
1118   );
1119   event UpkeepCanceled(
1120     uint256 indexed id,
1121     uint64 indexed atBlockHeight
1122   );
1123   event FundsAdded(
1124     uint256 indexed id,
1125     address indexed from,
1126     uint96 amount
1127   );
1128   event FundsWithdrawn(
1129     uint256 indexed id,
1130     uint256 amount,
1131     address to
1132   );
1133   event ConfigSet(
1134     uint32 paymentPremiumPPB,
1135     uint24 blockCountPerTurn,
1136     uint32 checkGasLimit,
1137     uint24 stalenessSeconds,
1138     uint16 gasCeilingMultiplier,
1139     uint256 fallbackGasPrice,
1140     uint256 fallbackLinkPrice
1141   );
1142   event KeepersUpdated(
1143     address[] keepers,
1144     address[] payees
1145   );
1146   event PaymentWithdrawn(
1147     address indexed keeper,
1148     uint256 indexed amount,
1149     address indexed to,
1150     address payee
1151   );
1152   event PayeeshipTransferRequested(
1153     address indexed keeper,
1154     address indexed from,
1155     address indexed to
1156   );
1157   event PayeeshipTransferred(
1158     address indexed keeper,
1159     address indexed from,
1160     address indexed to
1161   );
1162   event RegistrarChanged(
1163     address indexed from,
1164     address indexed to
1165   );
1166   /**
1167    * @param link address of the LINK Token
1168    * @param linkEthFeed address of the LINK/ETH price feed
1169    * @param fastGasFeed address of the Fast Gas price feed
1170    * @param paymentPremiumPPB payment premium rate oracles receive on top of
1171    * being reimbursed for gas, measured in parts per billion
1172    * @param blockCountPerTurn number of blocks each oracle has during their turn to
1173    * perform upkeep before it will be the next keeper's turn to submit
1174    * @param checkGasLimit gas limit when checking for upkeep
1175    * @param stalenessSeconds number of seconds that is allowed for feed data to
1176    * be stale before switching to the fallback pricing
1177    * @param gasCeilingMultiplier multiplier to apply to the fast gas feed price
1178    * when calculating the payment ceiling for keepers
1179    * @param fallbackGasPrice gas price used if the gas price feed is stale
1180    * @param fallbackLinkPrice LINK price used if the LINK price feed is stale
1181    */
1182   constructor(
1183     address link,
1184     address linkEthFeed,
1185     address fastGasFeed,
1186     uint32 paymentPremiumPPB,
1187     uint24 blockCountPerTurn,
1188     uint32 checkGasLimit,
1189     uint24 stalenessSeconds,
1190     uint16 gasCeilingMultiplier,
1191     uint256 fallbackGasPrice,
1192     uint256 fallbackLinkPrice
1193   ) {
1194     LINK = LinkTokenInterface(link);
1195     LINK_ETH_FEED = AggregatorV3Interface(linkEthFeed);
1196     FAST_GAS_FEED = AggregatorV3Interface(fastGasFeed);
1197 
1198     setConfig(
1199       paymentPremiumPPB,
1200       blockCountPerTurn,
1201       checkGasLimit,
1202       stalenessSeconds,
1203       gasCeilingMultiplier,
1204       fallbackGasPrice,
1205       fallbackLinkPrice
1206     );
1207   }
1208 
1209 
1210   // ACTIONS
1211 
1212   /**
1213    * @notice adds a new upkeep
1214    * @param target address to perform upkeep on
1215    * @param gasLimit amount of gas to provide the target contract when
1216    * performing upkeep
1217    * @param admin address to cancel upkeep and withdraw remaining funds
1218    * @param checkData data passed to the contract when checking for upkeep
1219    */
1220   function registerUpkeep(
1221     address target,
1222     uint32 gasLimit,
1223     address admin,
1224     bytes calldata checkData
1225   )
1226     external
1227     override
1228     onlyOwnerOrRegistrar()
1229     returns (
1230       uint256 id
1231     )
1232   {
1233     require(target.isContract(), "target is not a contract");
1234     require(gasLimit >= CALL_GAS_MIN, "min gas is 2300");
1235     require(gasLimit <= CALL_GAS_MAX, "max gas is 2500000");
1236 
1237     id = s_upkeepCount;
1238     s_upkeep[id] = Upkeep({
1239       target: target,
1240       executeGas: gasLimit,
1241       balance: 0,
1242       admin: admin,
1243       maxValidBlocknumber: UINT64_MAX,
1244       lastKeeper: address(0)
1245     });
1246     s_checkData[id] = checkData;
1247     s_upkeepCount++;
1248 
1249     emit UpkeepRegistered(id, gasLimit, admin);
1250 
1251     return id;
1252   }
1253 
1254   /**
1255    * @notice simulated by keepers via eth_call to see if the upkeep needs to be
1256    * performed. If upkeep is needed, the call then simulates performUpkeep
1257    * to make sure it succeeds. Finally, it returns the success status along with
1258    * payment information and the perform data payload.
1259    * @param id identifier of the upkeep to check
1260    * @param from the address to simulate performing the upkeep from
1261    */
1262   function checkUpkeep(
1263     uint256 id,
1264     address from
1265   )
1266     external
1267     override
1268     whenNotPaused()
1269     cannotExecute()
1270     returns (
1271       bytes memory performData,
1272       uint256 maxLinkPayment,
1273       uint256 gasLimit,
1274       uint256 adjustedGasWei,
1275       uint256 linkEth
1276     )
1277   {
1278     bytes memory callData = abi.encodeWithSelector(CHECK_SELECTOR, s_checkData[id]);
1279     (
1280       bool success,
1281       bytes memory result
1282     ) = s_upkeep[id].target.call{gas: s_config.checkGasLimit}(callData);
1283 
1284     if (!success) {
1285       string memory upkeepRevertReason = getRevertMsg(result);
1286       string memory reason = string(abi.encodePacked("call to check target failed: ", upkeepRevertReason));
1287       revert(reason);
1288     }
1289 
1290     (
1291       success,
1292       performData
1293     ) = abi.decode(result, (bool, bytes));
1294     require(success, "upkeep not needed");
1295 
1296     PerformParams memory params = generatePerformParams(from, id, performData, false);
1297     success = performUpkeepWithParams(params);
1298     require(success, "call to perform upkeep failed");
1299 
1300     return (performData, params.maxLinkPayment, params.gasLimit, params.adjustedGasWei, params.linkEth);
1301   }
1302 
1303 
1304   /**
1305    * @notice executes the upkeep with the perform data returned from
1306    * checkUpkeep, validates the keeper's permissions, and pays the keeper.
1307    * @param id identifier of the upkeep to execute the data with.
1308    * @param performData calldata parameter to be passed to the target upkeep.
1309    */
1310   function performUpkeep(
1311     uint256 id,
1312     bytes calldata performData
1313   )
1314     external
1315     override
1316     returns (
1317       bool success
1318     )
1319   {
1320 
1321     return performUpkeepWithParams(generatePerformParams(
1322       msg.sender,
1323       id,
1324       performData,
1325       true
1326     ));
1327   }
1328 
1329   /**
1330    * @notice prevent an upkeep from being performed in the future
1331    * @param id upkeep to be canceled
1332    */
1333   function cancelUpkeep(
1334     uint256 id
1335   )
1336     external
1337     override
1338   {
1339     uint64 maxValid = s_upkeep[id].maxValidBlocknumber;
1340     bool notCanceled = maxValid == UINT64_MAX;
1341     bool isOwner = msg.sender == owner;
1342     require(notCanceled || (isOwner && maxValid > block.number), "too late to cancel upkeep");
1343     require(isOwner || msg.sender == s_upkeep[id].admin, "only owner or admin");
1344 
1345     uint256 height = block.number;
1346     if (!isOwner) {
1347       height = height.add(CANCELATION_DELAY);
1348     }
1349     s_upkeep[id].maxValidBlocknumber = uint64(height);
1350     if (notCanceled) {
1351       s_canceledUpkeepList.push(id);
1352     }
1353 
1354     emit UpkeepCanceled(id, uint64(height));
1355   }
1356 
1357   /**
1358    * @notice adds LINK funding for an upkeep by tranferring from the sender's
1359    * LINK balance
1360    * @param id upkeep to fund
1361    * @param amount number of LINK to transfer
1362    */
1363   function addFunds(
1364     uint256 id,
1365     uint96 amount
1366   )
1367     external
1368     override
1369   {
1370     require(s_upkeep[id].maxValidBlocknumber == UINT64_MAX, "upkeep must be active");
1371     s_upkeep[id].balance = s_upkeep[id].balance.add(amount);
1372     s_expectedLinkBalance = s_expectedLinkBalance.add(amount);
1373     LINK.transferFrom(msg.sender, address(this), amount);
1374     emit FundsAdded(id, msg.sender, amount);
1375   }
1376 
1377   /**
1378    * @notice uses LINK's transferAndCall to LINK and add funding to an upkeep
1379    * @dev safe to cast uint256 to uint96 as total LINK supply is under UINT96MAX
1380    * @param sender the account which transferred the funds
1381    * @param amount number of LINK transfer
1382    */
1383   function onTokenTransfer(
1384     address sender,
1385     uint256 amount,
1386     bytes calldata data
1387   )
1388     external
1389   {
1390     require(msg.sender == address(LINK), "only callable through LINK");
1391     require(data.length == 32, "data must be 32 bytes");
1392     uint256 id = abi.decode(data, (uint256));
1393     require(s_upkeep[id].maxValidBlocknumber == UINT64_MAX, "upkeep must be active");
1394 
1395     s_upkeep[id].balance = s_upkeep[id].balance.add(uint96(amount));
1396     s_expectedLinkBalance = s_expectedLinkBalance.add(amount);
1397 
1398     emit FundsAdded(id, sender, uint96(amount));
1399   }
1400 
1401   /**
1402    * @notice removes funding from a canceled upkeep
1403    * @param id upkeep to withdraw funds from
1404    * @param to destination address for sending remaining funds
1405    */
1406   function withdrawFunds(
1407     uint256 id,
1408     address to
1409   )
1410     external
1411     validateRecipient(to)
1412   {
1413     require(s_upkeep[id].admin == msg.sender, "only callable by admin");
1414     require(s_upkeep[id].maxValidBlocknumber <= block.number, "upkeep must be canceled");
1415 
1416     uint256 amount = s_upkeep[id].balance;
1417     s_upkeep[id].balance = 0;
1418     s_expectedLinkBalance = s_expectedLinkBalance.sub(amount);
1419     emit FundsWithdrawn(id, amount, to);
1420 
1421     LINK.transfer(to, amount);
1422   }
1423 
1424   /**
1425    * @notice recovers LINK funds improperly transfered to the registry
1426    * @dev In principle this function’s execution cost could exceed block
1427    * gaslimit. However, in our anticipated deployment, the number of upkeeps and
1428    * keepers will be low enough to avoid this problem.
1429    */
1430   function recoverFunds()
1431     external
1432     onlyOwner()
1433   {
1434     uint256 total = LINK.balanceOf(address(this));
1435     LINK.transfer(msg.sender, total.sub(s_expectedLinkBalance));
1436   }
1437 
1438   /**
1439    * @notice withdraws a keeper's payment, callable only by the keeper's payee
1440    * @param from keeper address
1441    * @param to address to send the payment to
1442    */
1443   function withdrawPayment(
1444     address from,
1445     address to
1446   )
1447     external
1448     validateRecipient(to)
1449   {
1450     KeeperInfo memory keeper = s_keeperInfo[from];
1451     require(keeper.payee == msg.sender, "only callable by payee");
1452 
1453     s_keeperInfo[from].balance = 0;
1454     s_expectedLinkBalance = s_expectedLinkBalance.sub(keeper.balance);
1455     emit PaymentWithdrawn(from, keeper.balance, to, msg.sender);
1456 
1457     LINK.transfer(to, keeper.balance);
1458   }
1459 
1460   /**
1461    * @notice proposes the safe transfer of a keeper's payee to another address
1462    * @param keeper address of the keeper to transfer payee role
1463    * @param proposed address to nominate for next payeeship
1464    */
1465   function transferPayeeship(
1466     address keeper,
1467     address proposed
1468   )
1469     external
1470   {
1471     require(s_keeperInfo[keeper].payee == msg.sender, "only callable by payee");
1472     require(proposed != msg.sender, "cannot transfer to self");
1473 
1474     if (s_proposedPayee[keeper] != proposed) {
1475       s_proposedPayee[keeper] = proposed;
1476       emit PayeeshipTransferRequested(keeper, msg.sender, proposed);
1477     }
1478   }
1479 
1480   /**
1481    * @notice accepts the safe transfer of payee role for a keeper
1482    * @param keeper address to accept the payee role for
1483    */
1484   function acceptPayeeship(
1485     address keeper
1486   )
1487     external
1488   {
1489     require(s_proposedPayee[keeper] == msg.sender, "only callable by proposed payee");
1490     address past = s_keeperInfo[keeper].payee;
1491     s_keeperInfo[keeper].payee = msg.sender;
1492     s_proposedPayee[keeper] = ZERO_ADDRESS;
1493 
1494     emit PayeeshipTransferred(keeper, past, msg.sender);
1495   }
1496 
1497   /**
1498    * @notice signals to keepers that they should not perform upkeeps until the
1499    * contract has been unpaused
1500    */
1501   function pause()
1502     external
1503     onlyOwner()
1504   {
1505     _pause();
1506   }
1507 
1508   /**
1509    * @notice signals to keepers that they can perform upkeeps once again after
1510    * having been paused
1511    */
1512   function unpause()
1513     external
1514     onlyOwner()
1515   {
1516     _unpause();
1517   }
1518 
1519 
1520   // SETTERS
1521 
1522   /**
1523    * @notice updates the configuration of the registry
1524    * @param paymentPremiumPPB payment premium rate oracles receive on top of
1525    * being reimbursed for gas, measured in parts per billion
1526    * @param blockCountPerTurn number of blocks an oracle should wait before
1527    * checking for upkeep
1528    * @param checkGasLimit gas limit when checking for upkeep
1529    * @param stalenessSeconds number of seconds that is allowed for feed data to
1530    * be stale before switching to the fallback pricing
1531    * @param fallbackGasPrice gas price used if the gas price feed is stale
1532    * @param fallbackLinkPrice LINK price used if the LINK price feed is stale
1533    */
1534   function setConfig(
1535     uint32 paymentPremiumPPB,
1536     uint24 blockCountPerTurn,
1537     uint32 checkGasLimit,
1538     uint24 stalenessSeconds,
1539     uint16 gasCeilingMultiplier,
1540     uint256 fallbackGasPrice,
1541     uint256 fallbackLinkPrice
1542   )
1543     onlyOwner()
1544     public
1545   {
1546     s_config = Config({
1547       paymentPremiumPPB: paymentPremiumPPB,
1548       blockCountPerTurn: blockCountPerTurn,
1549       checkGasLimit: checkGasLimit,
1550       stalenessSeconds: stalenessSeconds,
1551       gasCeilingMultiplier: gasCeilingMultiplier
1552     });
1553     s_fallbackGasPrice = fallbackGasPrice;
1554     s_fallbackLinkPrice = fallbackLinkPrice;
1555 
1556     emit ConfigSet(
1557       paymentPremiumPPB,
1558       blockCountPerTurn,
1559       checkGasLimit,
1560       stalenessSeconds,
1561       gasCeilingMultiplier,
1562       fallbackGasPrice,
1563       fallbackLinkPrice
1564     );
1565   }
1566 
1567   /**
1568    * @notice update the list of keepers allowed to perform upkeep
1569    * @param keepers list of addresses allowed to perform upkeep
1570    * @param payees addreses corresponding to keepers who are allowed to
1571    * move payments which have been accrued
1572    */
1573   function setKeepers(
1574     address[] calldata keepers,
1575     address[] calldata payees
1576   )
1577     external
1578     onlyOwner()
1579   {
1580     require(keepers.length == payees.length, "address lists not the same length");
1581     require(keepers.length >= 2, "not enough keepers");
1582     for (uint256 i = 0; i < s_keeperList.length; i++) {
1583       address keeper = s_keeperList[i];
1584       s_keeperInfo[keeper].active = false;
1585     }
1586     for (uint256 i = 0; i < keepers.length; i++) {
1587       address keeper = keepers[i];
1588       KeeperInfo storage s_keeper = s_keeperInfo[keeper];
1589       address oldPayee = s_keeper.payee;
1590       address newPayee = payees[i];
1591       require(newPayee != address(0), "cannot set payee to the zero address");
1592       require(oldPayee == ZERO_ADDRESS || oldPayee == newPayee || newPayee == IGNORE_ADDRESS, "cannot change payee");
1593       require(!s_keeper.active, "cannot add keeper twice");
1594       s_keeper.active = true;
1595       if (newPayee != IGNORE_ADDRESS) {
1596         s_keeper.payee = newPayee;
1597       }
1598     }
1599     s_keeperList = keepers;
1600     emit KeepersUpdated(keepers, payees);
1601   }
1602 
1603   /**
1604    * @notice update registrar
1605    * @param registrar new registrar
1606    */
1607   function setRegistrar(
1608     address registrar
1609   )
1610     external
1611     onlyOwnerOrRegistrar()
1612   {
1613     address previous = s_registrar;
1614     require(registrar != previous, "Same registrar");
1615     s_registrar = registrar;
1616     emit RegistrarChanged(previous, registrar);
1617   }
1618 
1619   // GETTERS
1620 
1621   /**
1622    * @notice read all of the details about an upkeep
1623    */
1624   function getUpkeep(
1625     uint256 id
1626   )
1627     external
1628     view
1629     override
1630     returns (
1631       address target,
1632       uint32 executeGas,
1633       bytes memory checkData,
1634       uint96 balance,
1635       address lastKeeper,
1636       address admin,
1637       uint64 maxValidBlocknumber
1638     )
1639   {
1640     Upkeep memory reg = s_upkeep[id];
1641     return (
1642       reg.target,
1643       reg.executeGas,
1644       s_checkData[id],
1645       reg.balance,
1646       reg.lastKeeper,
1647       reg.admin,
1648       reg.maxValidBlocknumber
1649     );
1650   }
1651 
1652   /**
1653    * @notice read the total number of upkeep's registered
1654    */
1655   function getUpkeepCount()
1656     external
1657     view
1658     override
1659     returns (
1660       uint256
1661     )
1662   {
1663     return s_upkeepCount;
1664   }
1665 
1666   /**
1667    * @notice read the current list canceled upkeep IDs
1668    */
1669   function getCanceledUpkeepList()
1670     external
1671     view
1672     override
1673     returns (
1674       uint256[] memory
1675     )
1676   {
1677     return s_canceledUpkeepList;
1678   }
1679 
1680   /**
1681    * @notice read the current list of addresses allowed to perform upkeep
1682    */
1683   function getKeeperList()
1684     external
1685     view
1686     override
1687     returns (
1688       address[] memory
1689     )
1690   {
1691     return s_keeperList;
1692   }
1693 
1694  /**
1695    * @notice read the current registrar
1696    */
1697   function getRegistrar()
1698     external
1699     view
1700     returns (
1701       address
1702     )
1703   {
1704     return s_registrar;
1705   }
1706 
1707   /**
1708    * @notice read the current info about any keeper address
1709    */
1710   function getKeeperInfo(
1711     address query
1712   )
1713     external
1714     view
1715     override
1716     returns (
1717       address payee,
1718       bool active,
1719       uint96 balance
1720     )
1721   {
1722     KeeperInfo memory keeper = s_keeperInfo[query];
1723     return (keeper.payee, keeper.active, keeper.balance);
1724   }
1725 
1726   /**
1727    * @notice read the current configuration of the registry
1728    */
1729   function getConfig()
1730     external
1731     view
1732     override
1733     returns (
1734       uint32 paymentPremiumPPB,
1735       uint24 blockCountPerTurn,
1736       uint32 checkGasLimit,
1737       uint24 stalenessSeconds,
1738       uint16 gasCeilingMultiplier,
1739       uint256 fallbackGasPrice,
1740       uint256 fallbackLinkPrice
1741     )
1742   {
1743     Config memory config = s_config;
1744     return (
1745       config.paymentPremiumPPB,
1746       config.blockCountPerTurn,
1747       config.checkGasLimit,
1748       config.stalenessSeconds,
1749       config.gasCeilingMultiplier,
1750       s_fallbackGasPrice,
1751       s_fallbackLinkPrice
1752     );
1753   }
1754 
1755   /**
1756    * @notice calculates the minimum balance required for an upkeep to remain eligible
1757    */
1758   function getMinBalanceForUpkeep(
1759     uint256 id
1760   )
1761     external
1762     view
1763     returns (
1764       uint96 minBalance
1765     )
1766   {
1767     return getMaxPaymentForGas(s_upkeep[id].executeGas);
1768   }
1769 
1770   /**
1771    * @notice calculates the maximum payment for a given gas limit
1772    */
1773   function getMaxPaymentForGas(
1774     uint256 gasLimit
1775   )
1776     public
1777     view
1778     returns (
1779       uint96 maxPayment
1780     )
1781   {
1782     (uint256 gasWei, uint256 linkEth) = getFeedData();
1783     uint256 adjustedGasWei = adjustGasPrice(gasWei, false);
1784     return calculatePaymentAmount(gasLimit, adjustedGasWei, linkEth);
1785   }
1786 
1787 
1788   // PRIVATE
1789 
1790   /**
1791    * @dev retrieves feed data for fast gas/eth and link/eth prices. if the feed
1792    * data is stale it uses the configured fallback price. Once a price is picked
1793    * for gas it takes the min of gas price in the transaction or the fast gas
1794    * price in order to reduce costs for the upkeep clients.
1795    */
1796   function getFeedData()
1797     private
1798     view
1799     returns (
1800       uint256 gasWei,
1801       uint256 linkEth
1802     )
1803   {
1804     uint32 stalenessSeconds = s_config.stalenessSeconds;
1805     bool staleFallback = stalenessSeconds > 0;
1806     uint256 timestamp;
1807     int256 feedValue;
1808     (,feedValue,,timestamp,) = FAST_GAS_FEED.latestRoundData();
1809     if (staleFallback && stalenessSeconds < block.timestamp - timestamp || feedValue <=0) {
1810       gasWei = s_fallbackGasPrice;
1811     } else {
1812       gasWei = uint256(feedValue);
1813     }
1814     (,feedValue,,timestamp,) = LINK_ETH_FEED.latestRoundData();
1815     if (staleFallback && stalenessSeconds < block.timestamp - timestamp || feedValue <=0) {
1816       linkEth = s_fallbackLinkPrice;
1817     } else {
1818       linkEth = uint256(feedValue);
1819     }
1820     return (gasWei, linkEth);
1821   }
1822 
1823   /**
1824    * @dev calculates LINK paid for gas spent plus a configure premium percentage
1825    */
1826   function calculatePaymentAmount(
1827     uint256 gasLimit,
1828     uint256 gasWei,
1829     uint256 linkEth
1830   )
1831     private
1832     view
1833     returns (
1834       uint96 payment
1835     )
1836   {
1837     uint256 weiForGas = gasWei.mul(gasLimit.add(REGISTRY_GAS_OVERHEAD));
1838     uint256 premium = PPB_BASE.add(s_config.paymentPremiumPPB);
1839     uint256 total = weiForGas.mul(1e9).mul(premium).div(linkEth);
1840     require(total <= LINK_TOTAL_SUPPLY, "payment greater than all LINK");
1841     return uint96(total); // LINK_TOTAL_SUPPLY < UINT96_MAX
1842   }
1843 
1844   /**
1845    * @dev calls target address with exactly gasAmount gas and data as calldata
1846    * or reverts if at least gasAmount gas is not available
1847    */
1848   function callWithExactGas(
1849     uint256 gasAmount,
1850     address target,
1851     bytes memory data
1852   )
1853     private
1854     returns (
1855       bool success
1856     )
1857   {
1858     assembly{
1859       let g := gas()
1860       // Compute g -= CUSHION and check for underflow
1861       if lt(g, CUSHION) { revert(0, 0) }
1862       g := sub(g, CUSHION)
1863       // if g - g//64 <= gasAmount, revert
1864       // (we subtract g//64 because of EIP-150)
1865       if iszero(gt(sub(g, div(g, 64)), gasAmount)) { revert(0, 0) }
1866       // solidity calls check that a contract actually exists at the destination, so we do the same
1867       if iszero(extcodesize(target)) { revert(0, 0) }
1868       // call and return whether we succeeded. ignore return data
1869       success := call(gasAmount, target, 0, add(data, 0x20), mload(data), 0, 0)
1870     }
1871     return success;
1872   }
1873 
1874   /**
1875    * @dev calls the Upkeep target with the performData param passed in by the
1876    * keeper and the exact gas required by the Upkeep
1877    */
1878   function performUpkeepWithParams(
1879     PerformParams memory params
1880   )
1881     private
1882     nonReentrant()
1883     validUpkeep(params.id)
1884     returns (
1885       bool success
1886     )
1887   {
1888     require(s_keeperInfo[params.from].active, "only active keepers");
1889     Upkeep memory upkeep = s_upkeep[params.id];
1890     require(upkeep.balance >= params.maxLinkPayment, "insufficient funds");
1891     require(upkeep.lastKeeper != params.from, "keepers must take turns");
1892 
1893     uint256  gasUsed = gasleft();
1894     bytes memory callData = abi.encodeWithSelector(PERFORM_SELECTOR, params.performData);
1895     success = callWithExactGas(params.gasLimit, upkeep.target, callData);
1896     gasUsed = gasUsed - gasleft();
1897 
1898     uint96 payment = calculatePaymentAmount(gasUsed, params.adjustedGasWei, params.linkEth);
1899     upkeep.balance = upkeep.balance.sub(payment);
1900     upkeep.lastKeeper = params.from;
1901     s_upkeep[params.id] = upkeep;
1902     uint96 newBalance = s_keeperInfo[params.from].balance.add(payment);
1903     s_keeperInfo[params.from].balance = newBalance;
1904 
1905     emit UpkeepPerformed(
1906       params.id,
1907       success,
1908       params.from,
1909       payment,
1910       params.performData
1911     );
1912     return success;
1913   }
1914 
1915   /**
1916    * @dev ensures a upkeep is valid
1917    */
1918   function validateUpkeep(
1919     uint256 id
1920   )
1921     private
1922     view
1923   {
1924     require(s_upkeep[id].maxValidBlocknumber > block.number, "invalid upkeep id");
1925   }
1926 
1927   /**
1928    * @dev adjusts the gas price to min(ceiling, tx.gasprice) or just uses the ceiling if tx.gasprice is disabled
1929    */
1930   function adjustGasPrice(
1931     uint256 gasWei,
1932     bool useTxGasPrice
1933   )
1934     private
1935     view
1936     returns(uint256 adjustedPrice)
1937   {
1938     adjustedPrice = gasWei.mul(s_config.gasCeilingMultiplier);
1939     if (useTxGasPrice && tx.gasprice < adjustedPrice) {
1940       adjustedPrice = tx.gasprice;
1941     }
1942   }
1943 
1944   /**
1945    * @dev generates a PerformParams struct for use in performUpkeepWithParams()
1946    */
1947   function generatePerformParams(
1948     address from,
1949     uint256 id,
1950     bytes memory performData,
1951     bool useTxGasPrice
1952   )
1953     private
1954     view
1955     returns(PerformParams memory)
1956   {
1957     uint256 gasLimit = s_upkeep[id].executeGas;
1958     (uint256 gasWei, uint256 linkEth) = getFeedData();
1959     uint256 adjustedGasWei = adjustGasPrice(gasWei, useTxGasPrice);
1960     uint96 maxLinkPayment = calculatePaymentAmount(gasLimit, adjustedGasWei, linkEth);
1961 
1962     return PerformParams({
1963       from: from,
1964       id: id,
1965       performData: performData,
1966       maxLinkPayment: maxLinkPayment,
1967       gasLimit: gasLimit,
1968       adjustedGasWei: adjustedGasWei,
1969       linkEth: linkEth
1970     });
1971   }
1972 
1973   /**
1974    * @dev extracts a revert reason from a call result payload
1975    */
1976   function getRevertMsg(bytes memory _payload) private pure returns (string memory) {
1977     if (_payload.length < 68) return 'transaction reverted silently';
1978     assembly {
1979         _payload := add(_payload, 0x04)
1980     }
1981     return abi.decode(_payload, (string));
1982   }
1983 
1984   // MODIFIERS
1985 
1986   /**
1987    * @dev ensures a upkeep is valid
1988    */
1989   modifier validUpkeep(
1990     uint256 id
1991   ) {
1992     validateUpkeep(id);
1993     _;
1994   }
1995 
1996   /**
1997    * @dev ensures that burns don't accidentally happen by sending to the zero
1998    * address
1999    */
2000   modifier validateRecipient(
2001     address to
2002   ) {
2003     require(to != address(0), "cannot send to zero address");
2004     _;
2005   }
2006 
2007     /**
2008    * @dev Reverts if called by anyone other than the contract owner or registrar.
2009    */
2010   modifier onlyOwnerOrRegistrar() {
2011     require(msg.sender == owner || msg.sender == s_registrar, "Only callable by owner or registrar");
2012     _;
2013   }
2014 
2015 }