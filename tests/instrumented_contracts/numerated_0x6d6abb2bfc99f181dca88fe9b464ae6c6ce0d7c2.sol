1 // SPDX-License-Identifier: AGPL V3.0
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts-upgradeable@3.3.0/Initializable
8 
9 /**
10  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
11  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
12  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
13  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
14  * 
15  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
16  * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
17  * 
18  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
19  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
20  */
21 abstract contract Initializable {
22 
23     /**
24      * @dev Indicates that the contract has been initialized.
25      */
26     bool private _initialized;
27 
28     /**
29      * @dev Indicates that the contract is in the process of being initialized.
30      */
31     bool private _initializing;
32 
33     /**
34      * @dev Modifier to protect an initializer function from being invoked twice.
35      */
36     modifier initializer() {
37         require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");
38 
39         bool isTopLevelCall = !_initializing;
40         if (isTopLevelCall) {
41             _initializing = true;
42             _initialized = true;
43         }
44 
45         _;
46 
47         if (isTopLevelCall) {
48             _initializing = false;
49         }
50     }
51 
52     /// @dev Returns true if and only if the function is running in the constructor
53     function _isConstructor() private view returns (bool) {
54         // extcodesize checks the size of the code stored in an address, and
55         // address returns the current address. Since the code is still not
56         // deployed when running a constructor, any checks on its code size will
57         // yield zero, making it an effective way to detect if a contract is
58         // under construction or not.
59         address self = address(this);
60         uint256 cs;
61         // solhint-disable-next-line no-inline-assembly
62         assembly { cs := extcodesize(self) }
63         return cs == 0;
64     }
65 }
66 
67 // Part: OpenZeppelin/openzeppelin-contracts-upgradeable@3.3.0/MerkleProofUpgradeable
68 
69 /**
70  * @dev These functions deal with verification of Merkle trees (hash trees),
71  */
72 library MerkleProofUpgradeable {
73     /**
74      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
75      * defined by `root`. For this, a `proof` must be provided, containing
76      * sibling hashes on the branch from the leaf to the root of the tree. Each
77      * pair of leaves and each pair of pre-images are assumed to be sorted.
78      */
79     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
80         bytes32 computedHash = leaf;
81 
82         for (uint256 i = 0; i < proof.length; i++) {
83             bytes32 proofElement = proof[i];
84 
85             if (computedHash <= proofElement) {
86                 // Hash(current computed hash + current element of the proof)
87                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
88             } else {
89                 // Hash(current element of the proof + current computed hash)
90                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
91             }
92         }
93 
94         // Check if the computed hash (root) is equal to the provided root
95         return computedHash == root;
96     }
97 }
98 
99 // Part: OpenZeppelin/openzeppelin-contracts-upgradeable@3.3.0/SafeMathUpgradeable
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114 library SafeMathUpgradeable {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         return sub(a, b, "SafeMath: subtraction overflow");
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b <= a, errorMessage);
158         uint256 c = a - b;
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the multiplication of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `*` operator.
168      *
169      * Requirements:
170      *
171      * - Multiplication cannot overflow.
172      */
173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
175         // benefit is lost if 'b' is also tested.
176         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
177         if (a == 0) {
178             return 0;
179         }
180 
181         uint256 c = a * b;
182         require(c / a == b, "SafeMath: multiplication overflow");
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         return mod(a, b, "SafeMath: modulo by zero");
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts with custom message when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b != 0, errorMessage);
253         return a % b;
254     }
255 }
256 
257 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/Address
258 
259 /**
260  * @dev Collection of functions related to the address type
261  */
262 library Address {
263     /**
264      * @dev Returns true if `account` is a contract.
265      *
266      * [IMPORTANT]
267      * ====
268      * It is unsafe to assume that an address for which this function returns
269      * false is an externally-owned account (EOA) and not a contract.
270      *
271      * Among others, `isContract` will return false for the following
272      * types of addresses:
273      *
274      *  - an externally-owned account
275      *  - a contract in construction
276      *  - an address where a contract will be created
277      *  - an address where a contract lived, but was destroyed
278      * ====
279      */
280     function isContract(address account) internal view returns (bool) {
281         // This method relies on extcodesize, which returns 0 for contracts in
282         // construction, since the code is only stored at the end of the
283         // constructor execution.
284 
285         uint256 size;
286         // solhint-disable-next-line no-inline-assembly
287         assembly { size := extcodesize(account) }
288         return size > 0;
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
311         (bool success, ) = recipient.call{ value: amount }("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 
315     /**
316      * @dev Performs a Solidity function call using a low level `call`. A
317      * plain`call` is an unsafe replacement for a function call: use this
318      * function instead.
319      *
320      * If `target` reverts with a revert reason, it is bubbled up by this
321      * function (like regular Solidity function calls).
322      *
323      * Returns the raw returned data. To convert to the expected return value,
324      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
325      *
326      * Requirements:
327      *
328      * - `target` must be a contract.
329      * - calling `target` with `data` must not revert.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
334       return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339      * `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but also transferring `value` wei to `target`.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least `value`.
354      * - the called Solidity function must be `payable`.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         require(isContract(target), "Address: call to non-contract");
371 
372         // solhint-disable-next-line avoid-low-level-calls
373         (bool success, bytes memory returndata) = target.call{ value: value }(data);
374         return _verifyCallResult(success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but performing a static call.
380      *
381      * _Available since v3.3._
382      */
383     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
384         return functionStaticCall(target, data, "Address: low-level static call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
389      * but performing a static call.
390      *
391      * _Available since v3.3._
392      */
393     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
394         require(isContract(target), "Address: static call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.staticcall(data);
398         return _verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
402         if (success) {
403             return returndata;
404         } else {
405             // Look for revert reason and bubble it up if present
406             if (returndata.length > 0) {
407                 // The easiest way to bubble the revert reason is using memory via assembly
408 
409                 // solhint-disable-next-line no-inline-assembly
410                 assembly {
411                     let returndata_size := mload(returndata)
412                     revert(add(32, returndata), returndata_size)
413                 }
414             } else {
415                 revert(errorMessage);
416             }
417         }
418     }
419 }
420 
421 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/IERC20
422 
423 /**
424  * @dev Interface of the ERC20 standard as defined in the EIP.
425  */
426 interface IERC20 {
427     /**
428      * @dev Returns the amount of tokens in existence.
429      */
430     function totalSupply() external view returns (uint256);
431 
432     /**
433      * @dev Returns the amount of tokens owned by `account`.
434      */
435     function balanceOf(address account) external view returns (uint256);
436 
437     /**
438      * @dev Moves `amount` tokens from the caller's account to `recipient`.
439      *
440      * Returns a boolean value indicating whether the operation succeeded.
441      *
442      * Emits a {Transfer} event.
443      */
444     function transfer(address recipient, uint256 amount) external returns (bool);
445 
446     /**
447      * @dev Returns the remaining number of tokens that `spender` will be
448      * allowed to spend on behalf of `owner` through {transferFrom}. This is
449      * zero by default.
450      *
451      * This value changes when {approve} or {transferFrom} are called.
452      */
453     function allowance(address owner, address spender) external view returns (uint256);
454 
455     /**
456      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
457      *
458      * Returns a boolean value indicating whether the operation succeeded.
459      *
460      * IMPORTANT: Beware that changing an allowance with this method brings the risk
461      * that someone may use both the old and the new allowance by unfortunate
462      * transaction ordering. One possible solution to mitigate this race
463      * condition is to first reduce the spender's allowance to 0 and set the
464      * desired value afterwards:
465      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
466      *
467      * Emits an {Approval} event.
468      */
469     function approve(address spender, uint256 amount) external returns (bool);
470 
471     /**
472      * @dev Moves `amount` tokens from `sender` to `recipient` using the
473      * allowance mechanism. `amount` is then deducted from the caller's
474      * allowance.
475      *
476      * Returns a boolean value indicating whether the operation succeeded.
477      *
478      * Emits a {Transfer} event.
479      */
480     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
481 
482     /**
483      * @dev Emitted when `value` tokens are moved from one account (`from`) to
484      * another (`to`).
485      *
486      * Note that `value` may be zero.
487      */
488     event Transfer(address indexed from, address indexed to, uint256 value);
489 
490     /**
491      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
492      * a call to {approve}. `value` is the new allowance.
493      */
494     event Approval(address indexed owner, address indexed spender, uint256 value);
495 }
496 
497 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/SafeMath
498 
499 /**
500  * @dev Wrappers over Solidity's arithmetic operations with added overflow
501  * checks.
502  *
503  * Arithmetic operations in Solidity wrap on overflow. This can easily result
504  * in bugs, because programmers usually assume that an overflow raises an
505  * error, which is the standard behavior in high level programming languages.
506  * `SafeMath` restores this intuition by reverting the transaction when an
507  * operation overflows.
508  *
509  * Using this library instead of the unchecked operations eliminates an entire
510  * class of bugs, so it's recommended to use it always.
511  */
512 library SafeMath {
513     /**
514      * @dev Returns the addition of two unsigned integers, reverting on
515      * overflow.
516      *
517      * Counterpart to Solidity's `+` operator.
518      *
519      * Requirements:
520      *
521      * - Addition cannot overflow.
522      */
523     function add(uint256 a, uint256 b) internal pure returns (uint256) {
524         uint256 c = a + b;
525         require(c >= a, "SafeMath: addition overflow");
526 
527         return c;
528     }
529 
530     /**
531      * @dev Returns the subtraction of two unsigned integers, reverting on
532      * overflow (when the result is negative).
533      *
534      * Counterpart to Solidity's `-` operator.
535      *
536      * Requirements:
537      *
538      * - Subtraction cannot overflow.
539      */
540     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
541         return sub(a, b, "SafeMath: subtraction overflow");
542     }
543 
544     /**
545      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
546      * overflow (when the result is negative).
547      *
548      * Counterpart to Solidity's `-` operator.
549      *
550      * Requirements:
551      *
552      * - Subtraction cannot overflow.
553      */
554     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
555         require(b <= a, errorMessage);
556         uint256 c = a - b;
557 
558         return c;
559     }
560 
561     /**
562      * @dev Returns the multiplication of two unsigned integers, reverting on
563      * overflow.
564      *
565      * Counterpart to Solidity's `*` operator.
566      *
567      * Requirements:
568      *
569      * - Multiplication cannot overflow.
570      */
571     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
572         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
573         // benefit is lost if 'b' is also tested.
574         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
575         if (a == 0) {
576             return 0;
577         }
578 
579         uint256 c = a * b;
580         require(c / a == b, "SafeMath: multiplication overflow");
581 
582         return c;
583     }
584 
585     /**
586      * @dev Returns the integer division of two unsigned integers. Reverts on
587      * division by zero. The result is rounded towards zero.
588      *
589      * Counterpart to Solidity's `/` operator. Note: this function uses a
590      * `revert` opcode (which leaves remaining gas untouched) while Solidity
591      * uses an invalid opcode to revert (consuming all remaining gas).
592      *
593      * Requirements:
594      *
595      * - The divisor cannot be zero.
596      */
597     function div(uint256 a, uint256 b) internal pure returns (uint256) {
598         return div(a, b, "SafeMath: division by zero");
599     }
600 
601     /**
602      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
603      * division by zero. The result is rounded towards zero.
604      *
605      * Counterpart to Solidity's `/` operator. Note: this function uses a
606      * `revert` opcode (which leaves remaining gas untouched) while Solidity
607      * uses an invalid opcode to revert (consuming all remaining gas).
608      *
609      * Requirements:
610      *
611      * - The divisor cannot be zero.
612      */
613     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
614         require(b > 0, errorMessage);
615         uint256 c = a / b;
616         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
617 
618         return c;
619     }
620 
621     /**
622      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
623      * Reverts when dividing by zero.
624      *
625      * Counterpart to Solidity's `%` operator. This function uses a `revert`
626      * opcode (which leaves remaining gas untouched) while Solidity uses an
627      * invalid opcode to revert (consuming all remaining gas).
628      *
629      * Requirements:
630      *
631      * - The divisor cannot be zero.
632      */
633     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
634         return mod(a, b, "SafeMath: modulo by zero");
635     }
636 
637     /**
638      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
639      * Reverts with custom message when dividing by zero.
640      *
641      * Counterpart to Solidity's `%` operator. This function uses a `revert`
642      * opcode (which leaves remaining gas untouched) while Solidity uses an
643      * invalid opcode to revert (consuming all remaining gas).
644      *
645      * Requirements:
646      *
647      * - The divisor cannot be zero.
648      */
649     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
650         require(b != 0, errorMessage);
651         return a % b;
652     }
653 }
654 
655 // Part: OpenZeppelin/openzeppelin-contracts-upgradeable@3.3.0/ContextUpgradeable
656 
657 /*
658  * @dev Provides information about the current execution context, including the
659  * sender of the transaction and its data. While these are generally available
660  * via msg.sender and msg.data, they should not be accessed in such a direct
661  * manner, since when dealing with GSN meta-transactions the account sending and
662  * paying for execution may not be the actual sender (as far as an application
663  * is concerned).
664  *
665  * This contract is only required for intermediate, library-like contracts.
666  */
667 abstract contract ContextUpgradeable is Initializable {
668     function __Context_init() internal initializer {
669         __Context_init_unchained();
670     }
671 
672     function __Context_init_unchained() internal initializer {
673     }
674     function _msgSender() internal view virtual returns (address payable) {
675         return msg.sender;
676     }
677 
678     function _msgData() internal view virtual returns (bytes memory) {
679         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
680         return msg.data;
681     }
682     uint256[50] private __gap;
683 }
684 
685 // Part: OpenZeppelin/openzeppelin-contracts-upgradeable@3.3.0/ReentrancyGuardUpgradeable
686 
687 /**
688  * @dev Contract module that helps prevent reentrant calls to a function.
689  *
690  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
691  * available, which can be applied to functions to make sure there are no nested
692  * (reentrant) calls to them.
693  *
694  * Note that because there is a single `nonReentrant` guard, functions marked as
695  * `nonReentrant` may not call one another. This can be worked around by making
696  * those functions `private`, and then adding `external` `nonReentrant` entry
697  * points to them.
698  *
699  * TIP: If you would like to learn more about reentrancy and alternative ways
700  * to protect against it, check out our blog post
701  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
702  */
703 abstract contract ReentrancyGuardUpgradeable is Initializable {
704     // Booleans are more expensive than uint256 or any type that takes up a full
705     // word because each write operation emits an extra SLOAD to first read the
706     // slot's contents, replace the bits taken up by the boolean, and then write
707     // back. This is the compiler's defense against contract upgrades and
708     // pointer aliasing, and it cannot be disabled.
709 
710     // The values being non-zero value makes deployment a bit more expensive,
711     // but in exchange the refund on every call to nonReentrant will be lower in
712     // amount. Since refunds are capped to a percentage of the total
713     // transaction's gas, it is best to keep them low in cases like this one, to
714     // increase the likelihood of the full refund coming into effect.
715     uint256 private constant _NOT_ENTERED = 1;
716     uint256 private constant _ENTERED = 2;
717 
718     uint256 private _status;
719 
720     function __ReentrancyGuard_init() internal initializer {
721         __ReentrancyGuard_init_unchained();
722     }
723 
724     function __ReentrancyGuard_init_unchained() internal initializer {
725         _status = _NOT_ENTERED;
726     }
727 
728     /**
729      * @dev Prevents a contract from calling itself, directly or indirectly.
730      * Calling a `nonReentrant` function from another `nonReentrant`
731      * function is not supported. It is possible to prevent this from happening
732      * by making the `nonReentrant` function external, and make it call a
733      * `private` function that does the actual work.
734      */
735     modifier nonReentrant() {
736         // On the first call to nonReentrant, _notEntered will be true
737         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
738 
739         // Any calls to nonReentrant after this point will fail
740         _status = _ENTERED;
741 
742         _;
743 
744         // By storing the original value once again, a refund is triggered (see
745         // https://eips.ethereum.org/EIPS/eip-2200)
746         _status = _NOT_ENTERED;
747     }
748     uint256[49] private __gap;
749 }
750 
751 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/SafeERC20
752 
753 /**
754  * @title SafeERC20
755  * @dev Wrappers around ERC20 operations that throw on failure (when the token
756  * contract returns false). Tokens that return no value (and instead revert or
757  * throw on failure) are also supported, non-reverting calls are assumed to be
758  * successful.
759  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
760  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
761  */
762 library SafeERC20 {
763     using SafeMath for uint256;
764     using Address for address;
765 
766     function safeTransfer(IERC20 token, address to, uint256 value) internal {
767         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
768     }
769 
770     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
771         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
772     }
773 
774     /**
775      * @dev Deprecated. This function has issues similar to the ones found in
776      * {IERC20-approve}, and its usage is discouraged.
777      *
778      * Whenever possible, use {safeIncreaseAllowance} and
779      * {safeDecreaseAllowance} instead.
780      */
781     function safeApprove(IERC20 token, address spender, uint256 value) internal {
782         // safeApprove should only be called when setting an initial allowance,
783         // or when resetting it to zero. To increase and decrease it, use
784         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
785         // solhint-disable-next-line max-line-length
786         require((value == 0) || (token.allowance(address(this), spender) == 0),
787             "SafeERC20: approve from non-zero to non-zero allowance"
788         );
789         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
790     }
791 
792     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
793         uint256 newAllowance = token.allowance(address(this), spender).add(value);
794         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
795     }
796 
797     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
798         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
799         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
800     }
801 
802     /**
803      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
804      * on the return value: the return value is optional (but if data is returned, it must not be false).
805      * @param token The token targeted by the call.
806      * @param data The call data (encoded using abi.encode or one of its variants).
807      */
808     function _callOptionalReturn(IERC20 token, bytes memory data) private {
809         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
810         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
811         // the target address contains contract code and also asserts for success in the low-level call.
812 
813         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
814         if (returndata.length > 0) { // Return data is optional
815             // solhint-disable-next-line max-line-length
816             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
817         }
818     }
819 }
820 
821 // Part: OpenZeppelin/openzeppelin-contracts-upgradeable@3.3.0/OwnableUpgradeable
822 
823 /**
824  * @dev Contract module which provides a basic access control mechanism, where
825  * there is an account (an owner) that can be granted exclusive access to
826  * specific functions.
827  *
828  * By default, the owner account will be the one that deploys the contract. This
829  * can later be changed with {transferOwnership}.
830  *
831  * This module is used through inheritance. It will make available the modifier
832  * `onlyOwner`, which can be applied to your functions to restrict their use to
833  * the owner.
834  */
835 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
836     address private _owner;
837 
838     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
839 
840     /**
841      * @dev Initializes the contract setting the deployer as the initial owner.
842      */
843     function __Ownable_init() internal initializer {
844         __Context_init_unchained();
845         __Ownable_init_unchained();
846     }
847 
848     function __Ownable_init_unchained() internal initializer {
849         address msgSender = _msgSender();
850         _owner = msgSender;
851         emit OwnershipTransferred(address(0), msgSender);
852     }
853 
854     /**
855      * @dev Returns the address of the current owner.
856      */
857     function owner() public view returns (address) {
858         return _owner;
859     }
860 
861     /**
862      * @dev Throws if called by any account other than the owner.
863      */
864     modifier onlyOwner() {
865         require(_owner == _msgSender(), "Ownable: caller is not the owner");
866         _;
867     }
868 
869     /**
870      * @dev Leaves the contract without owner. It will not be possible to call
871      * `onlyOwner` functions anymore. Can only be called by the current owner.
872      *
873      * NOTE: Renouncing ownership will leave the contract without an owner,
874      * thereby removing any functionality that is only available to the owner.
875      */
876     function renounceOwnership() public virtual onlyOwner {
877         emit OwnershipTransferred(_owner, address(0));
878         _owner = address(0);
879     }
880 
881     /**
882      * @dev Transfers ownership of the contract to a new account (`newOwner`).
883      * Can only be called by the current owner.
884      */
885     function transferOwnership(address newOwner) public virtual onlyOwner {
886         require(newOwner != address(0), "Ownable: new owner is the zero address");
887         emit OwnershipTransferred(_owner, newOwner);
888         _owner = newOwner;
889     }
890     uint256[49] private __gap;
891 }
892 
893 // Part: OpenZeppelin/openzeppelin-contracts-upgradeable@3.3.0/PausableUpgradeable
894 
895 /**
896  * @dev Contract module which allows children to implement an emergency stop
897  * mechanism that can be triggered by an authorized account.
898  *
899  * This module is used through inheritance. It will make available the
900  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
901  * the functions of your contract. Note that they will not be pausable by
902  * simply including this module, only once the modifiers are put in place.
903  */
904 abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
905     /**
906      * @dev Emitted when the pause is triggered by `account`.
907      */
908     event Paused(address account);
909 
910     /**
911      * @dev Emitted when the pause is lifted by `account`.
912      */
913     event Unpaused(address account);
914 
915     bool private _paused;
916 
917     /**
918      * @dev Initializes the contract in unpaused state.
919      */
920     function __Pausable_init() internal initializer {
921         __Context_init_unchained();
922         __Pausable_init_unchained();
923     }
924 
925     function __Pausable_init_unchained() internal initializer {
926         _paused = false;
927     }
928 
929     /**
930      * @dev Returns true if the contract is paused, and false otherwise.
931      */
932     function paused() public view returns (bool) {
933         return _paused;
934     }
935 
936     /**
937      * @dev Modifier to make a function callable only when the contract is not paused.
938      *
939      * Requirements:
940      *
941      * - The contract must not be paused.
942      */
943     modifier whenNotPaused() {
944         require(!_paused, "Pausable: paused");
945         _;
946     }
947 
948     /**
949      * @dev Modifier to make a function callable only when the contract is paused.
950      *
951      * Requirements:
952      *
953      * - The contract must be paused.
954      */
955     modifier whenPaused() {
956         require(_paused, "Pausable: not paused");
957         _;
958     }
959 
960     /**
961      * @dev Triggers stopped state.
962      *
963      * Requirements:
964      *
965      * - The contract must not be paused.
966      */
967     function _pause() internal virtual whenNotPaused {
968         _paused = true;
969         emit Paused(_msgSender());
970     }
971 
972     /**
973      * @dev Returns to normal state.
974      *
975      * Requirements:
976      *
977      * - The contract must be paused.
978      */
979     function _unpause() internal virtual whenPaused {
980         _paused = false;
981         emit Unpaused(_msgSender());
982     }
983     uint256[49] private __gap;
984 }
985 
986 // File: Rewards.sol
987 
988 contract Rewards is OwnableUpgradeable, ReentrancyGuardUpgradeable, PausableUpgradeable {
989     using SafeERC20 for IERC20;
990     using SafeMathUpgradeable for uint256;
991 
992     event Claimed(address indexed receiver, uint256 amount);
993 
994     uint256 public minAmountToClaim = 0;
995     bytes32[] public merkleRoots;
996     mapping (address => uint256) public claimed;
997     IERC20 public token;
998 
999     modifier enough(uint256 _claimAmount) {
1000         require(_claimAmount > 0 && _claimAmount >= minAmountToClaim, "Insufficient token amount");
1001         _;
1002     }
1003 
1004     function initialize(address _token) virtual public initializer {
1005         __Ownable_init();
1006         __Pausable_init();
1007         __ReentrancyGuard_init();
1008 
1009         token = IERC20(_token);
1010     }
1011 
1012     /**
1013      * @notice Sets the minimum amount of  which can be swapped. 0 by default
1014      * @param _minAmount Minimum amount in wei (the least decimals)
1015      */
1016     function setMinClaimAmount(uint256 _minAmount) external onlyOwner {
1017         minAmountToClaim = _minAmount;
1018     }
1019 
1020     /**
1021      * @notice Sets the Merkle roots
1022      * @param _merkleRoots Array of hashes
1023      */
1024     function setMerkleRoots(bytes32[] memory _merkleRoots) external onlyOwner {
1025         require(_merkleRoots.length > 0, "Incorrect data");
1026         if (merkleRoots.length > 0) {
1027             delete merkleRoots;
1028         }
1029         merkleRoots = new bytes32[](_merkleRoots.length);
1030         merkleRoots = _merkleRoots;
1031     }
1032 
1033     /**
1034      * @notice Withdraws all tokens collected on a Rewards contract
1035      * @param _recipient Recepient of token.
1036      */
1037     function withdrawToken(address _recipient) external onlyOwner {
1038         require(_recipient != address(0), "Zero address");
1039         uint256 amount = IERC20(token).balanceOf(address(this));
1040         IERC20(token).safeTransfer(_recipient, amount);
1041     }
1042 
1043     /**
1044      * @notice Allows to claim token from the wallet
1045      * @param _merkleRootIndex Index of a merkle root to be used for calculations
1046      * @param _amountAllowedToClaim Maximum token allowed for a user to swap
1047      * @param _merkleProofs Array of consiquent merkle hashes
1048      */
1049     function claim(
1050         uint256 _merkleRootIndex,
1051         uint256 _amountAllowedToClaim,
1052         bytes32[] memory _merkleProofs
1053     )
1054         external nonReentrant whenNotPaused enough(_amountAllowedToClaim)
1055     {
1056         require(verifyMerkleProofs(_msgSender(), _merkleRootIndex, _amountAllowedToClaim, _merkleProofs), "Merkle proofs not verified");
1057         uint256 availableAmount = _amountAllowedToClaim.sub(claimed[_msgSender()]);
1058         require(availableAmount != 0 && availableAmount >= minAmountToClaim, "Not enough tokens");
1059         claimed[_msgSender()] = claimed[_msgSender()].add(availableAmount);
1060         token.safeTransfer(_msgSender(), availableAmount);
1061         emit Claimed(_msgSender(), availableAmount);
1062     }
1063 
1064     /**
1065      * @notice Verifies merkle proofs of user to be elligible for swap
1066      * @param _account Address of a user
1067      * @param _merkleRootIndex Index of a merkle root to be used for calculations
1068      * @param _amountAllowedToClaim Maximum ADEL allowed for a user to swap
1069      * @param _merkleProofs Array of consiquent merkle hashes
1070      */
1071     function verifyMerkleProofs(
1072         address _account,
1073         uint256 _merkleRootIndex,
1074         uint256 _amountAllowedToClaim,
1075         bytes32[] memory _merkleProofs) virtual public view returns(bool)
1076     {
1077         require(_merkleProofs.length > 0, "No Merkle proofs");
1078         require(_merkleRootIndex < merkleRoots.length, "Merkle roots are not set");
1079 
1080         bytes32 node = keccak256(abi.encodePacked(_account, _amountAllowedToClaim));
1081         return MerkleProofUpgradeable.verify(_merkleProofs, merkleRoots[_merkleRootIndex], node);
1082     }
1083 
1084     /**
1085      * @notice Called by the owner to pause, deny claim reward
1086      */
1087     function pause() onlyOwner whenNotPaused external {
1088         _pause();
1089     }
1090 
1091     /**
1092      * @notice Called by the owner to unpause, allow claim reward
1093      */
1094     function unpause() onlyOwner whenPaused external {
1095         _unpause();
1096     }
1097 }