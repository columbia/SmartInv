1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Interface of the ERC20 standard as defined in the EIP.
56  */
57 interface IERC20 {
58     /**
59      * @dev Returns the amount of tokens in existence.
60      */
61     function totalSupply() external view returns (uint256);
62 
63     /**
64      * @dev Returns the amount of tokens owned by `account`.
65      */
66     function balanceOf(address account) external view returns (uint256);
67 
68     /**
69      * @dev Moves `amount` tokens from the caller's account to `recipient`.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Returns the remaining number of tokens that `spender` will be
79      * allowed to spend on behalf of `owner` through {transferFrom}. This is
80      * zero by default.
81      *
82      * This value changes when {approve} or {transferFrom} are called.
83      */
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     /**
87      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * IMPORTANT: Beware that changing an allowance with this method brings the risk
92      * that someone may use both the old and the new allowance by unfortunate
93      * transaction ordering. One possible solution to mitigate this race
94      * condition is to first reduce the spender's allowance to 0 and set the
95      * desired value afterwards:
96      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
97      *
98      * Emits an {Approval} event.
99      */
100     function approve(address spender, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Moves `amount` tokens from `sender` to `recipient` using the
104      * allowance mechanism. `amount` is then deducted from the caller's
105      * allowance.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(
112         address sender,
113         address recipient,
114         uint256 amount
115     ) external returns (bool);
116 
117     /**
118      * @dev Emitted when `value` tokens are moved from one account (`from`) to
119      * another (`to`).
120      *
121      * Note that `value` may be zero.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /**
126      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
127      * a call to {approve}. `value` is the new allowance.
128      */
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev These functions deal with verification of Merkle Trees proofs.
141  *
142  * The proofs can be generated using the JavaScript library
143  * https://github.com/miguelmota/merkletreejs[merkletreejs].
144  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
145  *
146  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
147  */
148 library MerkleProof {
149     /**
150      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
151      * defined by `root`. For this, a `proof` must be provided, containing
152      * sibling hashes on the branch from the leaf to the root of the tree. Each
153      * pair of leaves and each pair of pre-images are assumed to be sorted.
154      */
155     function verify(
156         bytes32[] memory proof,
157         bytes32 root,
158         bytes32 leaf
159     ) internal pure returns (bool) {
160         return processProof(proof, leaf) == root;
161     }
162 
163     /**
164      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
165      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
166      * hash matches the root of the tree. When processing the proof, the pairs
167      * of leafs & pre-images are assumed to be sorted.
168      *
169      * _Available since v4.4._
170      */
171     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
172         bytes32 computedHash = leaf;
173         for (uint256 i = 0; i < proof.length; i++) {
174             bytes32 proofElement = proof[i];
175             if (computedHash <= proofElement) {
176                 // Hash(current computed hash + current element of the proof)
177                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
178             } else {
179                 // Hash(current element of the proof + current computed hash)
180                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
181             }
182         }
183         return computedHash;
184     }
185 }
186 
187 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
188 
189 
190 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @dev Contract module that helps prevent reentrant calls to a function.
196  *
197  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
198  * available, which can be applied to functions to make sure there are no nested
199  * (reentrant) calls to them.
200  *
201  * Note that because there is a single `nonReentrant` guard, functions marked as
202  * `nonReentrant` may not call one another. This can be worked around by making
203  * those functions `private`, and then adding `external` `nonReentrant` entry
204  * points to them.
205  *
206  * TIP: If you would like to learn more about reentrancy and alternative ways
207  * to protect against it, check out our blog post
208  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
209  */
210 abstract contract ReentrancyGuard {
211     // Booleans are more expensive than uint256 or any type that takes up a full
212     // word because each write operation emits an extra SLOAD to first read the
213     // slot's contents, replace the bits taken up by the boolean, and then write
214     // back. This is the compiler's defense against contract upgrades and
215     // pointer aliasing, and it cannot be disabled.
216 
217     // The values being non-zero value makes deployment a bit more expensive,
218     // but in exchange the refund on every call to nonReentrant will be lower in
219     // amount. Since refunds are capped to a percentage of the total
220     // transaction's gas, it is best to keep them low in cases like this one, to
221     // increase the likelihood of the full refund coming into effect.
222     uint256 private constant _NOT_ENTERED = 1;
223     uint256 private constant _ENTERED = 2;
224 
225     uint256 private _status;
226 
227     constructor() {
228         _status = _NOT_ENTERED;
229     }
230 
231     /**
232      * @dev Prevents a contract from calling itself, directly or indirectly.
233      * Calling a `nonReentrant` function from another `nonReentrant`
234      * function is not supported. It is possible to prevent this from happening
235      * by making the `nonReentrant` function external, and making it call a
236      * `private` function that does the actual work.
237      */
238     modifier nonReentrant() {
239         // On the first call to nonReentrant, _notEntered will be true
240         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
241 
242         // Any calls to nonReentrant after this point will fail
243         _status = _ENTERED;
244 
245         _;
246 
247         // By storing the original value once again, a refund is triggered (see
248         // https://eips.ethereum.org/EIPS/eip-2200)
249         _status = _NOT_ENTERED;
250     }
251 }
252 
253 // File: @openzeppelin/contracts/utils/Strings.sol
254 
255 
256 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 /**
261  * @dev String operations.
262  */
263 library Strings {
264     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
265 
266     /**
267      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
268      */
269     function toString(uint256 value) internal pure returns (string memory) {
270         // Inspired by OraclizeAPI's implementation - MIT licence
271         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
272 
273         if (value == 0) {
274             return "0";
275         }
276         uint256 temp = value;
277         uint256 digits;
278         while (temp != 0) {
279             digits++;
280             temp /= 10;
281         }
282         bytes memory buffer = new bytes(digits);
283         while (value != 0) {
284             digits -= 1;
285             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
286             value /= 10;
287         }
288         return string(buffer);
289     }
290 
291     /**
292      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
293      */
294     function toHexString(uint256 value) internal pure returns (string memory) {
295         if (value == 0) {
296             return "0x00";
297         }
298         uint256 temp = value;
299         uint256 length = 0;
300         while (temp != 0) {
301             length++;
302             temp >>= 8;
303         }
304         return toHexString(value, length);
305     }
306 
307     /**
308      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
309      */
310     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
311         bytes memory buffer = new bytes(2 * length + 2);
312         buffer[0] = "0";
313         buffer[1] = "x";
314         for (uint256 i = 2 * length + 1; i > 1; --i) {
315             buffer[i] = _HEX_SYMBOLS[value & 0xf];
316             value >>= 4;
317         }
318         require(value == 0, "Strings: hex length insufficient");
319         return string(buffer);
320     }
321 }
322 
323 // File: @openzeppelin/contracts/utils/Context.sol
324 
325 
326 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @dev Provides information about the current execution context, including the
332  * sender of the transaction and its data. While these are generally available
333  * via msg.sender and msg.data, they should not be accessed in such a direct
334  * manner, since when dealing with meta-transactions the account sending and
335  * paying for execution may not be the actual sender (as far as an application
336  * is concerned).
337  *
338  * This contract is only required for intermediate, library-like contracts.
339  */
340 abstract contract Context {
341     function _msgSender() internal view virtual returns (address) {
342         return msg.sender;
343     }
344 
345     function _msgData() internal view virtual returns (bytes calldata) {
346         return msg.data;
347     }
348 }
349 
350 // File: @openzeppelin/contracts/access/Ownable.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @dev Contract module which provides a basic access control mechanism, where
360  * there is an account (an owner) that can be granted exclusive access to
361  * specific functions.
362  *
363  * By default, the owner account will be the one that deploys the contract. This
364  * can later be changed with {transferOwnership}.
365  *
366  * This module is used through inheritance. It will make available the modifier
367  * `onlyOwner`, which can be applied to your functions to restrict their use to
368  * the owner.
369  */
370 abstract contract Ownable is Context {
371     address private _owner;
372 
373     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375     /**
376      * @dev Initializes the contract setting the deployer as the initial owner.
377      */
378     constructor() {
379         _transferOwnership(_msgSender());
380     }
381 
382     /**
383      * @dev Returns the address of the current owner.
384      */
385     function owner() public view virtual returns (address) {
386         return _owner;
387     }
388 
389     /**
390      * @dev Throws if called by any account other than the owner.
391      */
392     modifier onlyOwner() {
393         require(owner() == _msgSender(), "Ownable: caller is not the owner");
394         _;
395     }
396 
397     /**
398      * @dev Leaves the contract without owner. It will not be possible to call
399      * `onlyOwner` functions anymore. Can only be called by the current owner.
400      *
401      * NOTE: Renouncing ownership will leave the contract without an owner,
402      * thereby removing any functionality that is only available to the owner.
403      */
404     function renounceOwnership() public virtual onlyOwner {
405         _transferOwnership(address(0));
406     }
407 
408     /**
409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
410      * Can only be called by the current owner.
411      */
412     function transferOwnership(address newOwner) public virtual onlyOwner {
413         require(newOwner != address(0), "Ownable: new owner is the zero address");
414         _transferOwnership(newOwner);
415     }
416 
417     /**
418      * @dev Transfers ownership of the contract to a new account (`newOwner`).
419      * Internal function without access restriction.
420      */
421     function _transferOwnership(address newOwner) internal virtual {
422         address oldOwner = _owner;
423         _owner = newOwner;
424         emit OwnershipTransferred(oldOwner, newOwner);
425     }
426 }
427 
428 // File: @openzeppelin/contracts/utils/Address.sol
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev Collection of functions related to the address type
437  */
438 library Address {
439     /**
440      * @dev Returns true if `account` is a contract.
441      *
442      * [IMPORTANT]
443      * ====
444      * It is unsafe to assume that an address for which this function returns
445      * false is an externally-owned account (EOA) and not a contract.
446      *
447      * Among others, `isContract` will return false for the following
448      * types of addresses:
449      *
450      *  - an externally-owned account
451      *  - a contract in construction
452      *  - an address where a contract will be created
453      *  - an address where a contract lived, but was destroyed
454      * ====
455      */
456     function isContract(address account) internal view returns (bool) {
457         // This method relies on extcodesize, which returns 0 for contracts in
458         // construction, since the code is only stored at the end of the
459         // constructor execution.
460 
461         uint256 size;
462         assembly {
463             size := extcodesize(account)
464         }
465         return size > 0;
466     }
467 
468     /**
469      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
470      * `recipient`, forwarding all available gas and reverting on errors.
471      *
472      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
473      * of certain opcodes, possibly making contracts go over the 2300 gas limit
474      * imposed by `transfer`, making them unable to receive funds via
475      * `transfer`. {sendValue} removes this limitation.
476      *
477      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
478      *
479      * IMPORTANT: because control is transferred to `recipient`, care must be
480      * taken to not create reentrancy vulnerabilities. Consider using
481      * {ReentrancyGuard} or the
482      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
483      */
484     function sendValue(address payable recipient, uint256 amount) internal {
485         require(address(this).balance >= amount, "Address: insufficient balance");
486 
487         (bool success, ) = recipient.call{value: amount}("");
488         require(success, "Address: unable to send value, recipient may have reverted");
489     }
490 
491     /**
492      * @dev Performs a Solidity function call using a low level `call`. A
493      * plain `call` is an unsafe replacement for a function call: use this
494      * function instead.
495      *
496      * If `target` reverts with a revert reason, it is bubbled up by this
497      * function (like regular Solidity function calls).
498      *
499      * Returns the raw returned data. To convert to the expected return value,
500      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
501      *
502      * Requirements:
503      *
504      * - `target` must be a contract.
505      * - calling `target` with `data` must not revert.
506      *
507      * _Available since v3.1._
508      */
509     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
510         return functionCall(target, data, "Address: low-level call failed");
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
515      * `errorMessage` as a fallback revert reason when `target` reverts.
516      *
517      * _Available since v3.1._
518      */
519     function functionCall(
520         address target,
521         bytes memory data,
522         string memory errorMessage
523     ) internal returns (bytes memory) {
524         return functionCallWithValue(target, data, 0, errorMessage);
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
529      * but also transferring `value` wei to `target`.
530      *
531      * Requirements:
532      *
533      * - the calling contract must have an ETH balance of at least `value`.
534      * - the called Solidity function must be `payable`.
535      *
536      * _Available since v3.1._
537      */
538     function functionCallWithValue(
539         address target,
540         bytes memory data,
541         uint256 value
542     ) internal returns (bytes memory) {
543         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
548      * with `errorMessage` as a fallback revert reason when `target` reverts.
549      *
550      * _Available since v3.1._
551      */
552     function functionCallWithValue(
553         address target,
554         bytes memory data,
555         uint256 value,
556         string memory errorMessage
557     ) internal returns (bytes memory) {
558         require(address(this).balance >= value, "Address: insufficient balance for call");
559         require(isContract(target), "Address: call to non-contract");
560 
561         (bool success, bytes memory returndata) = target.call{value: value}(data);
562         return verifyCallResult(success, returndata, errorMessage);
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
567      * but performing a static call.
568      *
569      * _Available since v3.3._
570      */
571     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
572         return functionStaticCall(target, data, "Address: low-level static call failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
577      * but performing a static call.
578      *
579      * _Available since v3.3._
580      */
581     function functionStaticCall(
582         address target,
583         bytes memory data,
584         string memory errorMessage
585     ) internal view returns (bytes memory) {
586         require(isContract(target), "Address: static call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.staticcall(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
594      * but performing a delegate call.
595      *
596      * _Available since v3.4._
597      */
598     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
599         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
604      * but performing a delegate call.
605      *
606      * _Available since v3.4._
607      */
608     function functionDelegateCall(
609         address target,
610         bytes memory data,
611         string memory errorMessage
612     ) internal returns (bytes memory) {
613         require(isContract(target), "Address: delegate call to non-contract");
614 
615         (bool success, bytes memory returndata) = target.delegatecall(data);
616         return verifyCallResult(success, returndata, errorMessage);
617     }
618 
619     /**
620      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
621      * revert reason using the provided one.
622      *
623      * _Available since v4.3._
624      */
625     function verifyCallResult(
626         bool success,
627         bytes memory returndata,
628         string memory errorMessage
629     ) internal pure returns (bytes memory) {
630         if (success) {
631             return returndata;
632         } else {
633             // Look for revert reason and bubble it up if present
634             if (returndata.length > 0) {
635                 // The easiest way to bubble the revert reason is using memory via assembly
636 
637                 assembly {
638                     let returndata_size := mload(returndata)
639                     revert(add(32, returndata), returndata_size)
640                 }
641             } else {
642                 revert(errorMessage);
643             }
644         }
645     }
646 }
647 
648 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
649 
650 
651 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 
656 
657 /**
658  * @title SafeERC20
659  * @dev Wrappers around ERC20 operations that throw on failure (when the token
660  * contract returns false). Tokens that return no value (and instead revert or
661  * throw on failure) are also supported, non-reverting calls are assumed to be
662  * successful.
663  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
664  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
665  */
666 library SafeERC20 {
667     using Address for address;
668 
669     function safeTransfer(
670         IERC20 token,
671         address to,
672         uint256 value
673     ) internal {
674         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
675     }
676 
677     function safeTransferFrom(
678         IERC20 token,
679         address from,
680         address to,
681         uint256 value
682     ) internal {
683         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
684     }
685 
686     /**
687      * @dev Deprecated. This function has issues similar to the ones found in
688      * {IERC20-approve}, and its usage is discouraged.
689      *
690      * Whenever possible, use {safeIncreaseAllowance} and
691      * {safeDecreaseAllowance} instead.
692      */
693     function safeApprove(
694         IERC20 token,
695         address spender,
696         uint256 value
697     ) internal {
698         // safeApprove should only be called when setting an initial allowance,
699         // or when resetting it to zero. To increase and decrease it, use
700         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
701         require(
702             (value == 0) || (token.allowance(address(this), spender) == 0),
703             "SafeERC20: approve from non-zero to non-zero allowance"
704         );
705         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
706     }
707 
708     function safeIncreaseAllowance(
709         IERC20 token,
710         address spender,
711         uint256 value
712     ) internal {
713         uint256 newAllowance = token.allowance(address(this), spender) + value;
714         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
715     }
716 
717     function safeDecreaseAllowance(
718         IERC20 token,
719         address spender,
720         uint256 value
721     ) internal {
722         unchecked {
723             uint256 oldAllowance = token.allowance(address(this), spender);
724             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
725             uint256 newAllowance = oldAllowance - value;
726             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
727         }
728     }
729 
730     /**
731      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
732      * on the return value: the return value is optional (but if data is returned, it must not be false).
733      * @param token The token targeted by the call.
734      * @param data The call data (encoded using abi.encode or one of its variants).
735      */
736     function _callOptionalReturn(IERC20 token, bytes memory data) private {
737         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
738         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
739         // the target address contains contract code and also asserts for success in the low-level call.
740 
741         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
742         if (returndata.length > 0) {
743             // Return data is optional
744             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
745         }
746     }
747 }
748 
749 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
750 
751 
752 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 
757 
758 
759 /**
760  * @title PaymentSplitter
761  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
762  * that the Ether will be split in this way, since it is handled transparently by the contract.
763  *
764  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
765  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
766  * an amount proportional to the percentage of total shares they were assigned.
767  *
768  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
769  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
770  * function.
771  *
772  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
773  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
774  * to run tests before sending real value to this contract.
775  */
776 contract PaymentSplitter is Context {
777     event PayeeAdded(address account, uint256 shares);
778     event PaymentReleased(address to, uint256 amount);
779     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
780     event PaymentReceived(address from, uint256 amount);
781 
782     uint256 private _totalShares;
783     uint256 private _totalReleased;
784 
785     mapping(address => uint256) private _shares;
786     mapping(address => uint256) private _released;
787     address[] private _payees;
788 
789     mapping(IERC20 => uint256) private _erc20TotalReleased;
790     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
791 
792     /**
793      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
794      * the matching position in the `shares` array.
795      *
796      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
797      * duplicates in `payees`.
798      */
799     constructor(address[] memory payees, uint256[] memory shares_) payable {
800         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
801         require(payees.length > 0, "PaymentSplitter: no payees");
802 
803         for (uint256 i = 0; i < payees.length; i++) {
804             _addPayee(payees[i], shares_[i]);
805         }
806     }
807 
808     /**
809      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
810      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
811      * reliability of the events, and not the actual splitting of Ether.
812      *
813      * To learn more about this see the Solidity documentation for
814      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
815      * functions].
816      */
817     receive() external payable virtual {
818         emit PaymentReceived(_msgSender(), msg.value);
819     }
820 
821     /**
822      * @dev Getter for the total shares held by payees.
823      */
824     function totalShares() public view returns (uint256) {
825         return _totalShares;
826     }
827 
828     /**
829      * @dev Getter for the total amount of Ether already released.
830      */
831     function totalReleased() public view returns (uint256) {
832         return _totalReleased;
833     }
834 
835     /**
836      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
837      * contract.
838      */
839     function totalReleased(IERC20 token) public view returns (uint256) {
840         return _erc20TotalReleased[token];
841     }
842 
843     /**
844      * @dev Getter for the amount of shares held by an account.
845      */
846     function shares(address account) public view returns (uint256) {
847         return _shares[account];
848     }
849 
850     /**
851      * @dev Getter for the amount of Ether already released to a payee.
852      */
853     function released(address account) public view returns (uint256) {
854         return _released[account];
855     }
856 
857     /**
858      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
859      * IERC20 contract.
860      */
861     function released(IERC20 token, address account) public view returns (uint256) {
862         return _erc20Released[token][account];
863     }
864 
865     /**
866      * @dev Getter for the address of the payee number `index`.
867      */
868     function payee(uint256 index) public view returns (address) {
869         return _payees[index];
870     }
871 
872     /**
873      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
874      * total shares and their previous withdrawals.
875      */
876     function release(address payable account) public virtual {
877         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
878 
879         uint256 totalReceived = address(this).balance + totalReleased();
880         uint256 payment = _pendingPayment(account, totalReceived, released(account));
881 
882         require(payment != 0, "PaymentSplitter: account is not due payment");
883 
884         _released[account] += payment;
885         _totalReleased += payment;
886 
887         Address.sendValue(account, payment);
888         emit PaymentReleased(account, payment);
889     }
890 
891     /**
892      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
893      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
894      * contract.
895      */
896     function release(IERC20 token, address account) public virtual {
897         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
898 
899         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
900         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
901 
902         require(payment != 0, "PaymentSplitter: account is not due payment");
903 
904         _erc20Released[token][account] += payment;
905         _erc20TotalReleased[token] += payment;
906 
907         SafeERC20.safeTransfer(token, account, payment);
908         emit ERC20PaymentReleased(token, account, payment);
909     }
910 
911     /**
912      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
913      * already released amounts.
914      */
915     function _pendingPayment(
916         address account,
917         uint256 totalReceived,
918         uint256 alreadyReleased
919     ) private view returns (uint256) {
920         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
921     }
922 
923     /**
924      * @dev Add a new payee to the contract.
925      * @param account The address of the payee to add.
926      * @param shares_ The number of shares owned by the payee.
927      */
928     function _addPayee(address account, uint256 shares_) private {
929         require(account != address(0), "PaymentSplitter: account is the zero address");
930         require(shares_ > 0, "PaymentSplitter: shares are 0");
931         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
932 
933         _payees.push(account);
934         _shares[account] = shares_;
935         _totalShares = _totalShares + shares_;
936         emit PayeeAdded(account, shares_);
937     }
938 }
939 
940 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
941 
942 
943 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
944 
945 pragma solidity ^0.8.0;
946 
947 /**
948  * @title ERC721 token receiver interface
949  * @dev Interface for any contract that wants to support safeTransfers
950  * from ERC721 asset contracts.
951  */
952 interface IERC721Receiver {
953     /**
954      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
955      * by `operator` from `from`, this function is called.
956      *
957      * It must return its Solidity selector to confirm the token transfer.
958      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
959      *
960      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
961      */
962     function onERC721Received(
963         address operator,
964         address from,
965         uint256 tokenId,
966         bytes calldata data
967     ) external returns (bytes4);
968 }
969 
970 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
971 
972 
973 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
974 
975 pragma solidity ^0.8.0;
976 
977 /**
978  * @dev Interface of the ERC165 standard, as defined in the
979  * https://eips.ethereum.org/EIPS/eip-165[EIP].
980  *
981  * Implementers can declare support of contract interfaces, which can then be
982  * queried by others ({ERC165Checker}).
983  *
984  * For an implementation, see {ERC165}.
985  */
986 interface IERC165 {
987     /**
988      * @dev Returns true if this contract implements the interface defined by
989      * `interfaceId`. See the corresponding
990      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
991      * to learn more about how these ids are created.
992      *
993      * This function call must use less than 30 000 gas.
994      */
995     function supportsInterface(bytes4 interfaceId) external view returns (bool);
996 }
997 
998 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
999 
1000 
1001 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1002 
1003 pragma solidity ^0.8.0;
1004 
1005 
1006 /**
1007  * @dev Implementation of the {IERC165} interface.
1008  *
1009  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1010  * for the additional interface id that will be supported. For example:
1011  *
1012  * ```solidity
1013  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1014  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1015  * }
1016  * ```
1017  *
1018  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1019  */
1020 abstract contract ERC165 is IERC165 {
1021     /**
1022      * @dev See {IERC165-supportsInterface}.
1023      */
1024     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1025         return interfaceId == type(IERC165).interfaceId;
1026     }
1027 }
1028 
1029 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1030 
1031 
1032 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1033 
1034 pragma solidity ^0.8.0;
1035 
1036 
1037 /**
1038  * @dev Required interface of an ERC721 compliant contract.
1039  */
1040 interface IERC721 is IERC165 {
1041     /**
1042      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1043      */
1044     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1045 
1046     /**
1047      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1048      */
1049     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1050 
1051     /**
1052      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1053      */
1054     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1055 
1056     /**
1057      * @dev Returns the number of tokens in ``owner``'s account.
1058      */
1059     function balanceOf(address owner) external view returns (uint256 balance);
1060 
1061     /**
1062      * @dev Returns the owner of the `tokenId` token.
1063      *
1064      * Requirements:
1065      *
1066      * - `tokenId` must exist.
1067      */
1068     function ownerOf(uint256 tokenId) external view returns (address owner);
1069 
1070     /**
1071      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1072      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1073      *
1074      * Requirements:
1075      *
1076      * - `from` cannot be the zero address.
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must exist and be owned by `from`.
1079      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1080      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function safeTransferFrom(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) external;
1089 
1090     /**
1091      * @dev Transfers `tokenId` token from `from` to `to`.
1092      *
1093      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1094      *
1095      * Requirements:
1096      *
1097      * - `from` cannot be the zero address.
1098      * - `to` cannot be the zero address.
1099      * - `tokenId` token must be owned by `from`.
1100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function transferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) external;
1109 
1110     /**
1111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1112      * The approval is cleared when the token is transferred.
1113      *
1114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1115      *
1116      * Requirements:
1117      *
1118      * - The caller must own the token or be an approved operator.
1119      * - `tokenId` must exist.
1120      *
1121      * Emits an {Approval} event.
1122      */
1123     function approve(address to, uint256 tokenId) external;
1124 
1125     /**
1126      * @dev Returns the account approved for `tokenId` token.
1127      *
1128      * Requirements:
1129      *
1130      * - `tokenId` must exist.
1131      */
1132     function getApproved(uint256 tokenId) external view returns (address operator);
1133 
1134     /**
1135      * @dev Approve or remove `operator` as an operator for the caller.
1136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1137      *
1138      * Requirements:
1139      *
1140      * - The `operator` cannot be the caller.
1141      *
1142      * Emits an {ApprovalForAll} event.
1143      */
1144     function setApprovalForAll(address operator, bool _approved) external;
1145 
1146     /**
1147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1148      *
1149      * See {setApprovalForAll}
1150      */
1151     function isApprovedForAll(address owner, address operator) external view returns (bool);
1152 
1153     /**
1154      * @dev Safely transfers `tokenId` token from `from` to `to`.
1155      *
1156      * Requirements:
1157      *
1158      * - `from` cannot be the zero address.
1159      * - `to` cannot be the zero address.
1160      * - `tokenId` token must exist and be owned by `from`.
1161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1163      *
1164      * Emits a {Transfer} event.
1165      */
1166     function safeTransferFrom(
1167         address from,
1168         address to,
1169         uint256 tokenId,
1170         bytes calldata data
1171     ) external;
1172 }
1173 
1174 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1175 
1176 
1177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1178 
1179 pragma solidity ^0.8.0;
1180 
1181 
1182 /**
1183  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1184  * @dev See https://eips.ethereum.org/EIPS/eip-721
1185  */
1186 interface IERC721Enumerable is IERC721 {
1187     /**
1188      * @dev Returns the total amount of tokens stored by the contract.
1189      */
1190     function totalSupply() external view returns (uint256);
1191 
1192     /**
1193      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1194      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1195      */
1196     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1197 
1198     /**
1199      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1200      * Use along with {totalSupply} to enumerate all tokens.
1201      */
1202     function tokenByIndex(uint256 index) external view returns (uint256);
1203 }
1204 
1205 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1206 
1207 
1208 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1209 
1210 pragma solidity ^0.8.0;
1211 
1212 
1213 /**
1214  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1215  * @dev See https://eips.ethereum.org/EIPS/eip-721
1216  */
1217 interface IERC721Metadata is IERC721 {
1218     /**
1219      * @dev Returns the token collection name.
1220      */
1221     function name() external view returns (string memory);
1222 
1223     /**
1224      * @dev Returns the token collection symbol.
1225      */
1226     function symbol() external view returns (string memory);
1227 
1228     /**
1229      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1230      */
1231     function tokenURI(uint256 tokenId) external view returns (string memory);
1232 }
1233 
1234 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1235 
1236 
1237 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1238 
1239 pragma solidity ^0.8.0;
1240 
1241 
1242 
1243 
1244 
1245 
1246 
1247 
1248 /**
1249  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1250  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1251  * {ERC721Enumerable}.
1252  */
1253 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1254     using Address for address;
1255     using Strings for uint256;
1256 
1257     // Token name
1258     string private _name;
1259 
1260     // Token symbol
1261     string private _symbol;
1262 
1263     // Mapping from token ID to owner address
1264     mapping(uint256 => address) private _owners;
1265 
1266     // Mapping owner address to token count
1267     mapping(address => uint256) private _balances;
1268 
1269     // Mapping from token ID to approved address
1270     mapping(uint256 => address) private _tokenApprovals;
1271 
1272     // Mapping from owner to operator approvals
1273     mapping(address => mapping(address => bool)) private _operatorApprovals;
1274 
1275     /**
1276      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1277      */
1278     constructor(string memory name_, string memory symbol_) {
1279         _name = name_;
1280         _symbol = symbol_;
1281     }
1282 
1283     /**
1284      * @dev See {IERC165-supportsInterface}.
1285      */
1286     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1287         return
1288             interfaceId == type(IERC721).interfaceId ||
1289             interfaceId == type(IERC721Metadata).interfaceId ||
1290             super.supportsInterface(interfaceId);
1291     }
1292 
1293     /**
1294      * @dev See {IERC721-balanceOf}.
1295      */
1296     function balanceOf(address owner) public view virtual override returns (uint256) {
1297         require(owner != address(0), "ERC721: balance query for the zero address");
1298         return _balances[owner];
1299     }
1300 
1301     /**
1302      * @dev See {IERC721-ownerOf}.
1303      */
1304     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1305         address owner = _owners[tokenId];
1306         require(owner != address(0), "ERC721: owner query for nonexistent token");
1307         return owner;
1308     }
1309 
1310     /**
1311      * @dev See {IERC721Metadata-name}.
1312      */
1313     function name() public view virtual override returns (string memory) {
1314         return _name;
1315     }
1316 
1317     /**
1318      * @dev See {IERC721Metadata-symbol}.
1319      */
1320     function symbol() public view virtual override returns (string memory) {
1321         return _symbol;
1322     }
1323 
1324     /**
1325      * @dev See {IERC721Metadata-tokenURI}.
1326      */
1327     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1328         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1329 
1330         string memory baseURI = _baseURI();
1331         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1332     }
1333 
1334     /**
1335      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1336      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1337      * by default, can be overriden in child contracts.
1338      */
1339     function _baseURI() internal view virtual returns (string memory) {
1340         return "";
1341     }
1342 
1343     /**
1344      * @dev See {IERC721-approve}.
1345      */
1346     function approve(address to, uint256 tokenId) public virtual override {
1347         address owner = ERC721.ownerOf(tokenId);
1348         require(to != owner, "ERC721: approval to current owner");
1349 
1350         require(
1351             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1352             "ERC721: approve caller is not owner nor approved for all"
1353         );
1354 
1355         _approve(to, tokenId);
1356     }
1357 
1358     /**
1359      * @dev See {IERC721-getApproved}.
1360      */
1361     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1362         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1363 
1364         return _tokenApprovals[tokenId];
1365     }
1366 
1367     /**
1368      * @dev See {IERC721-setApprovalForAll}.
1369      */
1370     function setApprovalForAll(address operator, bool approved) public virtual override {
1371         _setApprovalForAll(_msgSender(), operator, approved);
1372     }
1373 
1374     /**
1375      * @dev See {IERC721-isApprovedForAll}.
1376      */
1377     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1378         return _operatorApprovals[owner][operator];
1379     }
1380 
1381     /**
1382      * @dev See {IERC721-transferFrom}.
1383      */
1384     function transferFrom(
1385         address from,
1386         address to,
1387         uint256 tokenId
1388     ) public virtual override {
1389         //solhint-disable-next-line max-line-length
1390         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1391 
1392         _transfer(from, to, tokenId);
1393     }
1394 
1395     /**
1396      * @dev See {IERC721-safeTransferFrom}.
1397      */
1398     function safeTransferFrom(
1399         address from,
1400         address to,
1401         uint256 tokenId
1402     ) public virtual override {
1403         safeTransferFrom(from, to, tokenId, "");
1404     }
1405 
1406     /**
1407      * @dev See {IERC721-safeTransferFrom}.
1408      */
1409     function safeTransferFrom(
1410         address from,
1411         address to,
1412         uint256 tokenId,
1413         bytes memory _data
1414     ) public virtual override {
1415         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1416         _safeTransfer(from, to, tokenId, _data);
1417     }
1418 
1419     /**
1420      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1421      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1422      *
1423      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1424      *
1425      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1426      * implement alternative mechanisms to perform token transfer, such as signature-based.
1427      *
1428      * Requirements:
1429      *
1430      * - `from` cannot be the zero address.
1431      * - `to` cannot be the zero address.
1432      * - `tokenId` token must exist and be owned by `from`.
1433      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1434      *
1435      * Emits a {Transfer} event.
1436      */
1437     function _safeTransfer(
1438         address from,
1439         address to,
1440         uint256 tokenId,
1441         bytes memory _data
1442     ) internal virtual {
1443         _transfer(from, to, tokenId);
1444         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1445     }
1446 
1447     /**
1448      * @dev Returns whether `tokenId` exists.
1449      *
1450      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1451      *
1452      * Tokens start existing when they are minted (`_mint`),
1453      * and stop existing when they are burned (`_burn`).
1454      */
1455     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1456         return _owners[tokenId] != address(0);
1457     }
1458 
1459     /**
1460      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1461      *
1462      * Requirements:
1463      *
1464      * - `tokenId` must exist.
1465      */
1466     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1467         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1468         address owner = ERC721.ownerOf(tokenId);
1469         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1470     }
1471 
1472     /**
1473      * @dev Safely mints `tokenId` and transfers it to `to`.
1474      *
1475      * Requirements:
1476      *
1477      * - `tokenId` must not exist.
1478      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1479      *
1480      * Emits a {Transfer} event.
1481      */
1482     function _safeMint(address to, uint256 tokenId) internal virtual {
1483         _safeMint(to, tokenId, "");
1484     }
1485 
1486     /**
1487      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1488      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1489      */
1490     function _safeMint(
1491         address to,
1492         uint256 tokenId,
1493         bytes memory _data
1494     ) internal virtual {
1495         _mint(to, tokenId);
1496         require(
1497             _checkOnERC721Received(address(0), to, tokenId, _data),
1498             "ERC721: transfer to non ERC721Receiver implementer"
1499         );
1500     }
1501 
1502     /**
1503      * @dev Mints `tokenId` and transfers it to `to`.
1504      *
1505      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1506      *
1507      * Requirements:
1508      *
1509      * - `tokenId` must not exist.
1510      * - `to` cannot be the zero address.
1511      *
1512      * Emits a {Transfer} event.
1513      */
1514     function _mint(address to, uint256 tokenId) internal virtual {
1515         require(to != address(0), "ERC721: mint to the zero address");
1516         require(!_exists(tokenId), "ERC721: token already minted");
1517 
1518         _beforeTokenTransfer(address(0), to, tokenId);
1519 
1520         _balances[to] += 1;
1521         _owners[tokenId] = to;
1522 
1523         emit Transfer(address(0), to, tokenId);
1524     }
1525 
1526     /**
1527      * @dev Destroys `tokenId`.
1528      * The approval is cleared when the token is burned.
1529      *
1530      * Requirements:
1531      *
1532      * - `tokenId` must exist.
1533      *
1534      * Emits a {Transfer} event.
1535      */
1536     function _burn(uint256 tokenId) internal virtual {
1537         address owner = ERC721.ownerOf(tokenId);
1538 
1539         _beforeTokenTransfer(owner, address(0), tokenId);
1540 
1541         // Clear approvals
1542         _approve(address(0), tokenId);
1543 
1544         _balances[owner] -= 1;
1545         delete _owners[tokenId];
1546 
1547         emit Transfer(owner, address(0), tokenId);
1548     }
1549 
1550     /**
1551      * @dev Transfers `tokenId` from `from` to `to`.
1552      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1553      *
1554      * Requirements:
1555      *
1556      * - `to` cannot be the zero address.
1557      * - `tokenId` token must be owned by `from`.
1558      *
1559      * Emits a {Transfer} event.
1560      */
1561     function _transfer(
1562         address from,
1563         address to,
1564         uint256 tokenId
1565     ) internal virtual {
1566         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1567         require(to != address(0), "ERC721: transfer to the zero address");
1568 
1569         _beforeTokenTransfer(from, to, tokenId);
1570 
1571         // Clear approvals from the previous owner
1572         _approve(address(0), tokenId);
1573 
1574         _balances[from] -= 1;
1575         _balances[to] += 1;
1576         _owners[tokenId] = to;
1577 
1578         emit Transfer(from, to, tokenId);
1579     }
1580 
1581     /**
1582      * @dev Approve `to` to operate on `tokenId`
1583      *
1584      * Emits a {Approval} event.
1585      */
1586     function _approve(address to, uint256 tokenId) internal virtual {
1587         _tokenApprovals[tokenId] = to;
1588         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1589     }
1590 
1591     /**
1592      * @dev Approve `operator` to operate on all of `owner` tokens
1593      *
1594      * Emits a {ApprovalForAll} event.
1595      */
1596     function _setApprovalForAll(
1597         address owner,
1598         address operator,
1599         bool approved
1600     ) internal virtual {
1601         require(owner != operator, "ERC721: approve to caller");
1602         _operatorApprovals[owner][operator] = approved;
1603         emit ApprovalForAll(owner, operator, approved);
1604     }
1605 
1606     /**
1607      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1608      * The call is not executed if the target address is not a contract.
1609      *
1610      * @param from address representing the previous owner of the given token ID
1611      * @param to target address that will receive the tokens
1612      * @param tokenId uint256 ID of the token to be transferred
1613      * @param _data bytes optional data to send along with the call
1614      * @return bool whether the call correctly returned the expected magic value
1615      */
1616     function _checkOnERC721Received(
1617         address from,
1618         address to,
1619         uint256 tokenId,
1620         bytes memory _data
1621     ) private returns (bool) {
1622         if (to.isContract()) {
1623             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1624                 return retval == IERC721Receiver.onERC721Received.selector;
1625             } catch (bytes memory reason) {
1626                 if (reason.length == 0) {
1627                     revert("ERC721: transfer to non ERC721Receiver implementer");
1628                 } else {
1629                     assembly {
1630                         revert(add(32, reason), mload(reason))
1631                     }
1632                 }
1633             }
1634         } else {
1635             return true;
1636         }
1637     }
1638 
1639     /**
1640      * @dev Hook that is called before any token transfer. This includes minting
1641      * and burning.
1642      *
1643      * Calling conditions:
1644      *
1645      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1646      * transferred to `to`.
1647      * - When `from` is zero, `tokenId` will be minted for `to`.
1648      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1649      * - `from` and `to` are never both zero.
1650      *
1651      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1652      */
1653     function _beforeTokenTransfer(
1654         address from,
1655         address to,
1656         uint256 tokenId
1657     ) internal virtual {}
1658 }
1659 
1660 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1661 
1662 
1663 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1664 
1665 pragma solidity ^0.8.0;
1666 
1667 
1668 
1669 /**
1670  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1671  * enumerability of all the token ids in the contract as well as all token ids owned by each
1672  * account.
1673  */
1674 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1675     // Mapping from owner to list of owned token IDs
1676     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1677 
1678     // Mapping from token ID to index of the owner tokens list
1679     mapping(uint256 => uint256) private _ownedTokensIndex;
1680 
1681     // Array with all token ids, used for enumeration
1682     uint256[] private _allTokens;
1683 
1684     // Mapping from token id to position in the allTokens array
1685     mapping(uint256 => uint256) private _allTokensIndex;
1686 
1687     /**
1688      * @dev See {IERC165-supportsInterface}.
1689      */
1690     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1691         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1692     }
1693 
1694     /**
1695      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1696      */
1697     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1698         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1699         return _ownedTokens[owner][index];
1700     }
1701 
1702     /**
1703      * @dev See {IERC721Enumerable-totalSupply}.
1704      */
1705     function totalSupply() public view virtual override returns (uint256) {
1706         return _allTokens.length;
1707     }
1708 
1709     /**
1710      * @dev See {IERC721Enumerable-tokenByIndex}.
1711      */
1712     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1713         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1714         return _allTokens[index];
1715     }
1716 
1717     /**
1718      * @dev Hook that is called before any token transfer. This includes minting
1719      * and burning.
1720      *
1721      * Calling conditions:
1722      *
1723      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1724      * transferred to `to`.
1725      * - When `from` is zero, `tokenId` will be minted for `to`.
1726      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1727      * - `from` cannot be the zero address.
1728      * - `to` cannot be the zero address.
1729      *
1730      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1731      */
1732     function _beforeTokenTransfer(
1733         address from,
1734         address to,
1735         uint256 tokenId
1736     ) internal virtual override {
1737         super._beforeTokenTransfer(from, to, tokenId);
1738 
1739         if (from == address(0)) {
1740             _addTokenToAllTokensEnumeration(tokenId);
1741         } else if (from != to) {
1742             _removeTokenFromOwnerEnumeration(from, tokenId);
1743         }
1744         if (to == address(0)) {
1745             _removeTokenFromAllTokensEnumeration(tokenId);
1746         } else if (to != from) {
1747             _addTokenToOwnerEnumeration(to, tokenId);
1748         }
1749     }
1750 
1751     /**
1752      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1753      * @param to address representing the new owner of the given token ID
1754      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1755      */
1756     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1757         uint256 length = ERC721.balanceOf(to);
1758         _ownedTokens[to][length] = tokenId;
1759         _ownedTokensIndex[tokenId] = length;
1760     }
1761 
1762     /**
1763      * @dev Private function to add a token to this extension's token tracking data structures.
1764      * @param tokenId uint256 ID of the token to be added to the tokens list
1765      */
1766     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1767         _allTokensIndex[tokenId] = _allTokens.length;
1768         _allTokens.push(tokenId);
1769     }
1770 
1771     /**
1772      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1773      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1774      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1775      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1776      * @param from address representing the previous owner of the given token ID
1777      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1778      */
1779     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1780         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1781         // then delete the last slot (swap and pop).
1782 
1783         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1784         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1785 
1786         // When the token to delete is the last token, the swap operation is unnecessary
1787         if (tokenIndex != lastTokenIndex) {
1788             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1789 
1790             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1791             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1792         }
1793 
1794         // This also deletes the contents at the last position of the array
1795         delete _ownedTokensIndex[tokenId];
1796         delete _ownedTokens[from][lastTokenIndex];
1797     }
1798 
1799     /**
1800      * @dev Private function to remove a token from this extension's token tracking data structures.
1801      * This has O(1) time complexity, but alters the order of the _allTokens array.
1802      * @param tokenId uint256 ID of the token to be removed from the tokens list
1803      */
1804     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1805         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1806         // then delete the last slot (swap and pop).
1807 
1808         uint256 lastTokenIndex = _allTokens.length - 1;
1809         uint256 tokenIndex = _allTokensIndex[tokenId];
1810 
1811         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1812         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1813         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1814         uint256 lastTokenId = _allTokens[lastTokenIndex];
1815 
1816         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1817         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1818 
1819         // This also deletes the contents at the last position of the array
1820         delete _allTokensIndex[tokenId];
1821         _allTokens.pop();
1822     }
1823 }
1824 
1825 // File: contracts/BoredMutantBunny.sol
1826 
1827 
1828 
1829 pragma solidity ^0.8.4;
1830 
1831 
1832 
1833 
1834 
1835 
1836 
1837 contract BoredMutantBunny is
1838     ERC721Enumerable,
1839     Ownable,
1840     PaymentSplitter
1841 {
1842     using Strings for uint256;
1843     using Counters for Counters.Counter;
1844 
1845     uint256 public maxSupply = 3000;
1846     uint256 public totalNFT;
1847 
1848     string public baseURI;
1849     string public notRevealedUri;
1850     string public baseExtension = ".json";
1851 
1852     bool public isBurnEnabled = false;
1853     bool public revealed = false;
1854 
1855     bool public paused = false;
1856     bool public whitelistMintState = false;
1857     bool public publicState = false;
1858 
1859     mapping(address => uint256) public _whitelistClaimed;
1860 
1861     uint256 _price = 250000000000000000; //0.25 ETH
1862 
1863     bytes32 public whitelistMintRoot;
1864 
1865     Counters.Counter private _tokenIds;
1866 
1867     uint256[] private _teamShares = [50, 50];
1868     address[] private _team = [
1869         0x0e04Ba718d3C7AC4d7c8fA357ab73ABdD45d89dC,
1870         0x9C8DbC726637cA085cFCa161Baf9baa3eBF990f8
1871     ];
1872 
1873     constructor()
1874         ERC721("Bored Mutant Bunny", "BMB")
1875         PaymentSplitter(_team, _teamShares)
1876     {}
1877 
1878     function changePauseState() public onlyOwner {
1879         paused = !paused;
1880     }
1881 
1882     function changeWhitelistMintState() public onlyOwner {
1883         whitelistMintState = !whitelistMintState;
1884     }
1885 
1886     function changePublicState() public onlyOwner {
1887         publicState = !publicState;
1888     }
1889 
1890     function setBaseURI(string calldata _tokenBaseURI) external onlyOwner {
1891         baseURI = _tokenBaseURI;
1892     }
1893 
1894     function _baseURI() internal view override returns (string memory) {
1895         return baseURI;
1896     }
1897 
1898     function reveal() public onlyOwner {
1899         revealed = true;
1900     }
1901 
1902     function setIsBurnEnabled(bool _isBurnEnabled) external onlyOwner {
1903         isBurnEnabled = _isBurnEnabled;
1904     }
1905 
1906 
1907     function giftMint(address[] calldata _addresses) external onlyOwner {
1908         require(
1909             totalNFT + _addresses.length <= maxSupply,
1910             "Bored Mutant Bunny: max total supply exceeded"
1911         );
1912 
1913         uint256 _newItemId;
1914         for (uint256 ind = 0; ind < _addresses.length; ind++) {
1915             require(
1916                 _addresses[ind] != address(0),
1917                 "Bored Mutant Bunny: recepient is the null address"
1918             );
1919             _tokenIds.increment();
1920             _newItemId = _tokenIds.current();
1921             _safeMint(_addresses[ind], _newItemId);
1922             totalNFT = totalNFT + 1;
1923         }
1924     }
1925 
1926     function whitelistMint(uint256 _amount, bytes32[] memory proof) external payable {
1927         require(whitelistMintState, "Bored Mutant Bunny: Whitelist Mint is OFF");
1928         require(!paused, "Bored Mutant Bunny: contract is paused");
1929         require(
1930             _amount <= 2,
1931             "Bored Mutant Bunny: You can't mint so much tokens"
1932         );
1933         require(
1934             _whitelistClaimed[msg.sender] + _amount <= 2,
1935             "Bored Mutant Bunny: You can't mint so much tokens"
1936         );
1937 
1938         require(verifyWhitelistMint(msg.sender, proof), "Bored Mutant Bunny: You are not whitelisted");
1939 
1940         require(
1941             totalNFT + _amount <= maxSupply,
1942             "Bored Mutant Bunny: max supply exceeded"
1943         );
1944         require(
1945             _price * _amount <= msg.value,
1946             "Bored Mutant Bunny: Ether value sent is not correct"
1947         );
1948         uint256 _newItemId;
1949         for (uint256 ind = 0; ind < _amount; ind++) {
1950             _tokenIds.increment();
1951             _newItemId = _tokenIds.current();
1952             _safeMint(msg.sender, _newItemId);
1953             _whitelistClaimed[msg.sender] = _whitelistClaimed[msg.sender] + 1;
1954             totalNFT = totalNFT + 1;
1955             
1956         }
1957     }
1958 
1959     function publicMint(uint256 _amount) external payable {
1960         require(publicState, "Bored Mutant Bunny: Public is OFF");
1961         require(_amount > 0, "Bored Mutant Bunny: zero amount");
1962         require(
1963             totalNFT + _amount <= maxSupply,
1964             "Bored Mutant Bunny: max supply exceeded"
1965         );
1966         require(
1967             _price * _amount <= msg.value,
1968             "Bored Mutant Bunny: Ether value sent is not correct"
1969         );
1970         require(!paused, "Bored Mutant Bunny: contract is paused");
1971         uint256 _newItemId;
1972         for (uint256 ind = 0; ind < _amount; ind++) {
1973             _tokenIds.increment();
1974             _newItemId = _tokenIds.current();
1975             _safeMint(msg.sender, _newItemId);
1976             totalNFT = totalNFT + 1;
1977         }
1978     }
1979 
1980     function tokenURI(uint256 tokenId)
1981         public
1982         view
1983         virtual
1984         override
1985         returns (string memory)
1986     {
1987         require(
1988             _exists(tokenId),
1989             "ERC721Metadata: URI query for nonexistent token"
1990         );
1991         if (revealed == false) {
1992             return notRevealedUri;
1993         }
1994 
1995         string memory currentBaseURI = _baseURI();
1996         return
1997             bytes(currentBaseURI).length > 0
1998                 ? string(
1999                     abi.encodePacked(
2000                         currentBaseURI,
2001                         tokenId.toString(),
2002                         baseExtension
2003                     )
2004                 )
2005                 : "";
2006     }
2007 
2008     function setBaseExtension(string memory _newBaseExtension)
2009         public
2010         onlyOwner
2011     {
2012         baseExtension = _newBaseExtension;
2013     }
2014 
2015     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2016         notRevealedUri = _notRevealedURI;
2017     }
2018 
2019     function changeTotalSupply(uint256 _newSupply) public onlyOwner {
2020         maxSupply = _newSupply;
2021     }
2022 
2023     function changeWhitelistMintRoot(bytes32 _whitelistMintRoot) public onlyOwner {
2024         whitelistMintRoot = _whitelistMintRoot;
2025     }
2026 
2027     function burn(uint256 tokenId) external {
2028         require(isBurnEnabled, "Bored Mutant Bunny : burning disabled");
2029         require(
2030             _isApprovedOrOwner(msg.sender, tokenId),
2031             "Bored Mutant Bunny : burn caller is not owner nor approved"
2032         );
2033         _burn(tokenId);
2034         totalNFT = totalNFT - 1;
2035     }
2036 
2037     function verifyWhitelistMint(address account, bytes32[] memory proof) public
2038         view
2039         returns (bool)
2040     {
2041         bytes32 leaf = keccak256(abi.encodePacked(account));
2042         return MerkleProof.verify(proof, whitelistMintRoot, leaf);
2043     }
2044 }