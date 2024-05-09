1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = _efficientHash(computedHash, proofElement);
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = _efficientHash(proofElement, computedHash);
50             }
51         }
52         return computedHash;
53     }
54 
55     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
56         assembly {
57             mstore(0x00, a)
58             mstore(0x20, b)
59             value := keccak256(0x00, 0x40)
60         }
61     }
62 }
63 
64 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
65 
66 
67 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev Contract module that helps prevent reentrant calls to a function.
73  *
74  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
75  * available, which can be applied to functions to make sure there are no nested
76  * (reentrant) calls to them.
77  *
78  * Note that because there is a single `nonReentrant` guard, functions marked as
79  * `nonReentrant` may not call one another. This can be worked around by making
80  * those functions `private`, and then adding `external` `nonReentrant` entry
81  * points to them.
82  *
83  * TIP: If you would like to learn more about reentrancy and alternative ways
84  * to protect against it, check out our blog post
85  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
86  */
87 abstract contract ReentrancyGuard {
88     // Booleans are more expensive than uint256 or any type that takes up a full
89     // word because each write operation emits an extra SLOAD to first read the
90     // slot's contents, replace the bits taken up by the boolean, and then write
91     // back. This is the compiler's defense against contract upgrades and
92     // pointer aliasing, and it cannot be disabled.
93 
94     // The values being non-zero value makes deployment a bit more expensive,
95     // but in exchange the refund on every call to nonReentrant will be lower in
96     // amount. Since refunds are capped to a percentage of the total
97     // transaction's gas, it is best to keep them low in cases like this one, to
98     // increase the likelihood of the full refund coming into effect.
99     uint256 private constant _NOT_ENTERED = 1;
100     uint256 private constant _ENTERED = 2;
101 
102     uint256 private _status;
103 
104     constructor() {
105         _status = _NOT_ENTERED;
106     }
107 
108     /**
109      * @dev Prevents a contract from calling itself, directly or indirectly.
110      * Calling a `nonReentrant` function from another `nonReentrant`
111      * function is not supported. It is possible to prevent this from happening
112      * by making the `nonReentrant` function external, and making it call a
113      * `private` function that does the actual work.
114      */
115     modifier nonReentrant() {
116         // On the first call to nonReentrant, _notEntered will be true
117         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
118 
119         // Any calls to nonReentrant after this point will fail
120         _status = _ENTERED;
121 
122         _;
123 
124         // By storing the original value once again, a refund is triggered (see
125         // https://eips.ethereum.org/EIPS/eip-2200)
126         _status = _NOT_ENTERED;
127     }
128 }
129 
130 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
131 
132 
133 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Interface of the ERC20 standard as defined in the EIP.
139  */
140 interface IERC20 {
141     /**
142      * @dev Returns the amount of tokens in existence.
143      */
144     function totalSupply() external view returns (uint256);
145 
146     /**
147      * @dev Returns the amount of tokens owned by `account`.
148      */
149     function balanceOf(address account) external view returns (uint256);
150 
151     /**
152      * @dev Moves `amount` tokens from the caller's account to `to`.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transfer(address to, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Returns the remaining number of tokens that `spender` will be
162      * allowed to spend on behalf of `owner` through {transferFrom}. This is
163      * zero by default.
164      *
165      * This value changes when {approve} or {transferFrom} are called.
166      */
167     function allowance(address owner, address spender) external view returns (uint256);
168 
169     /**
170      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * IMPORTANT: Beware that changing an allowance with this method brings the risk
175      * that someone may use both the old and the new allowance by unfortunate
176      * transaction ordering. One possible solution to mitigate this race
177      * condition is to first reduce the spender's allowance to 0 and set the
178      * desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      *
181      * Emits an {Approval} event.
182      */
183     function approve(address spender, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Moves `amount` tokens from `from` to `to` using the
187      * allowance mechanism. `amount` is then deducted from the caller's
188      * allowance.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(
195         address from,
196         address to,
197         uint256 amount
198     ) external returns (bool);
199 
200     /**
201      * @dev Emitted when `value` tokens are moved from one account (`from`) to
202      * another (`to`).
203      *
204      * Note that `value` may be zero.
205      */
206     event Transfer(address indexed from, address indexed to, uint256 value);
207 
208     /**
209      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
210      * a call to {approve}. `value` is the new allowance.
211      */
212     event Approval(address indexed owner, address indexed spender, uint256 value);
213 }
214 
215 // File: @openzeppelin/contracts/interfaces/IERC20.sol
216 
217 
218 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 
223 // File: @openzeppelin/contracts/utils/Strings.sol
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev String operations.
232  */
233 library Strings {
234     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
235 
236     /**
237      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
238      */
239     function toString(uint256 value) internal pure returns (string memory) {
240         // Inspired by OraclizeAPI's implementation - MIT licence
241         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
242 
243         if (value == 0) {
244             return "0";
245         }
246         uint256 temp = value;
247         uint256 digits;
248         while (temp != 0) {
249             digits++;
250             temp /= 10;
251         }
252         bytes memory buffer = new bytes(digits);
253         while (value != 0) {
254             digits -= 1;
255             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
256             value /= 10;
257         }
258         return string(buffer);
259     }
260 
261     /**
262      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
263      */
264     function toHexString(uint256 value) internal pure returns (string memory) {
265         if (value == 0) {
266             return "0x00";
267         }
268         uint256 temp = value;
269         uint256 length = 0;
270         while (temp != 0) {
271             length++;
272             temp >>= 8;
273         }
274         return toHexString(value, length);
275     }
276 
277     /**
278      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
279      */
280     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
281         bytes memory buffer = new bytes(2 * length + 2);
282         buffer[0] = "0";
283         buffer[1] = "x";
284         for (uint256 i = 2 * length + 1; i > 1; --i) {
285             buffer[i] = _HEX_SYMBOLS[value & 0xf];
286             value >>= 4;
287         }
288         require(value == 0, "Strings: hex length insufficient");
289         return string(buffer);
290     }
291 }
292 
293 // File: @openzeppelin/contracts/utils/Context.sol
294 
295 
296 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @dev Provides information about the current execution context, including the
302  * sender of the transaction and its data. While these are generally available
303  * via msg.sender and msg.data, they should not be accessed in such a direct
304  * manner, since when dealing with meta-transactions the account sending and
305  * paying for execution may not be the actual sender (as far as an application
306  * is concerned).
307  *
308  * This contract is only required for intermediate, library-like contracts.
309  */
310 abstract contract Context {
311     function _msgSender() internal view virtual returns (address) {
312         return msg.sender;
313     }
314 
315     function _msgData() internal view virtual returns (bytes calldata) {
316         return msg.data;
317     }
318 }
319 
320 // File: @openzeppelin/contracts/access/Ownable.sol
321 
322 
323 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
324 
325 pragma solidity ^0.8.0;
326 
327 
328 /**
329  * @dev Contract module which provides a basic access control mechanism, where
330  * there is an account (an owner) that can be granted exclusive access to
331  * specific functions.
332  *
333  * By default, the owner account will be the one that deploys the contract. This
334  * can later be changed with {transferOwnership}.
335  *
336  * This module is used through inheritance. It will make available the modifier
337  * `onlyOwner`, which can be applied to your functions to restrict their use to
338  * the owner.
339  */
340 abstract contract Ownable is Context {
341     address private _owner;
342 
343     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
344 
345     /**
346      * @dev Initializes the contract setting the deployer as the initial owner.
347      */
348     constructor() {
349         _transferOwnership(_msgSender());
350     }
351 
352     /**
353      * @dev Returns the address of the current owner.
354      */
355     function owner() public view virtual returns (address) {
356         return _owner;
357     }
358 
359     /**
360      * @dev Throws if called by any account other than the owner.
361      */
362     modifier onlyOwner() {
363         require(owner() == _msgSender(), "Ownable: caller is not the owner");
364         _;
365     }
366 
367     /**
368      * @dev Leaves the contract without owner. It will not be possible to call
369      * `onlyOwner` functions anymore. Can only be called by the current owner.
370      *
371      * NOTE: Renouncing ownership will leave the contract without an owner,
372      * thereby removing any functionality that is only available to the owner.
373      */
374     function renounceOwnership() public virtual onlyOwner {
375         _transferOwnership(address(0));
376     }
377 
378     /**
379      * @dev Transfers ownership of the contract to a new account (`newOwner`).
380      * Can only be called by the current owner.
381      */
382     function transferOwnership(address newOwner) public virtual onlyOwner {
383         require(newOwner != address(0), "Ownable: new owner is the zero address");
384         _transferOwnership(newOwner);
385     }
386 
387     /**
388      * @dev Transfers ownership of the contract to a new account (`newOwner`).
389      * Internal function without access restriction.
390      */
391     function _transferOwnership(address newOwner) internal virtual {
392         address oldOwner = _owner;
393         _owner = newOwner;
394         emit OwnershipTransferred(oldOwner, newOwner);
395     }
396 }
397 
398 // File: @openzeppelin/contracts/utils/Address.sol
399 
400 
401 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
402 
403 pragma solidity ^0.8.1;
404 
405 /**
406  * @dev Collection of functions related to the address type
407  */
408 library Address {
409     /**
410      * @dev Returns true if `account` is a contract.
411      *
412      * [IMPORTANT]
413      * ====
414      * It is unsafe to assume that an address for which this function returns
415      * false is an externally-owned account (EOA) and not a contract.
416      *
417      * Among others, `isContract` will return false for the following
418      * types of addresses:
419      *
420      *  - an externally-owned account
421      *  - a contract in construction
422      *  - an address where a contract will be created
423      *  - an address where a contract lived, but was destroyed
424      * ====
425      *
426      * [IMPORTANT]
427      * ====
428      * You shouldn't rely on `isContract` to protect against flash loan attacks!
429      *
430      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
431      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
432      * constructor.
433      * ====
434      */
435     function isContract(address account) internal view returns (bool) {
436         // This method relies on extcodesize/address.code.length, which returns 0
437         // for contracts in construction, since the code is only stored at the end
438         // of the constructor execution.
439 
440         return account.code.length > 0;
441     }
442 
443     /**
444      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
445      * `recipient`, forwarding all available gas and reverting on errors.
446      *
447      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
448      * of certain opcodes, possibly making contracts go over the 2300 gas limit
449      * imposed by `transfer`, making them unable to receive funds via
450      * `transfer`. {sendValue} removes this limitation.
451      *
452      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
453      *
454      * IMPORTANT: because control is transferred to `recipient`, care must be
455      * taken to not create reentrancy vulnerabilities. Consider using
456      * {ReentrancyGuard} or the
457      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
458      */
459     function sendValue(address payable recipient, uint256 amount) internal {
460         require(address(this).balance >= amount, "Address: insufficient balance");
461 
462         (bool success, ) = recipient.call{value: amount}("");
463         require(success, "Address: unable to send value, recipient may have reverted");
464     }
465 
466     /**
467      * @dev Performs a Solidity function call using a low level `call`. A
468      * plain `call` is an unsafe replacement for a function call: use this
469      * function instead.
470      *
471      * If `target` reverts with a revert reason, it is bubbled up by this
472      * function (like regular Solidity function calls).
473      *
474      * Returns the raw returned data. To convert to the expected return value,
475      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
476      *
477      * Requirements:
478      *
479      * - `target` must be a contract.
480      * - calling `target` with `data` must not revert.
481      *
482      * _Available since v3.1._
483      */
484     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
485         return functionCall(target, data, "Address: low-level call failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
490      * `errorMessage` as a fallback revert reason when `target` reverts.
491      *
492      * _Available since v3.1._
493      */
494     function functionCall(
495         address target,
496         bytes memory data,
497         string memory errorMessage
498     ) internal returns (bytes memory) {
499         return functionCallWithValue(target, data, 0, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but also transferring `value` wei to `target`.
505      *
506      * Requirements:
507      *
508      * - the calling contract must have an ETH balance of at least `value`.
509      * - the called Solidity function must be `payable`.
510      *
511      * _Available since v3.1._
512      */
513     function functionCallWithValue(
514         address target,
515         bytes memory data,
516         uint256 value
517     ) internal returns (bytes memory) {
518         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
523      * with `errorMessage` as a fallback revert reason when `target` reverts.
524      *
525      * _Available since v3.1._
526      */
527     function functionCallWithValue(
528         address target,
529         bytes memory data,
530         uint256 value,
531         string memory errorMessage
532     ) internal returns (bytes memory) {
533         require(address(this).balance >= value, "Address: insufficient balance for call");
534         require(isContract(target), "Address: call to non-contract");
535 
536         (bool success, bytes memory returndata) = target.call{value: value}(data);
537         return verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
547         return functionStaticCall(target, data, "Address: low-level static call failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
552      * but performing a static call.
553      *
554      * _Available since v3.3._
555      */
556     function functionStaticCall(
557         address target,
558         bytes memory data,
559         string memory errorMessage
560     ) internal view returns (bytes memory) {
561         require(isContract(target), "Address: static call to non-contract");
562 
563         (bool success, bytes memory returndata) = target.staticcall(data);
564         return verifyCallResult(success, returndata, errorMessage);
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
569      * but performing a delegate call.
570      *
571      * _Available since v3.4._
572      */
573     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
574         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
579      * but performing a delegate call.
580      *
581      * _Available since v3.4._
582      */
583     function functionDelegateCall(
584         address target,
585         bytes memory data,
586         string memory errorMessage
587     ) internal returns (bytes memory) {
588         require(isContract(target), "Address: delegate call to non-contract");
589 
590         (bool success, bytes memory returndata) = target.delegatecall(data);
591         return verifyCallResult(success, returndata, errorMessage);
592     }
593 
594     /**
595      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
596      * revert reason using the provided one.
597      *
598      * _Available since v4.3._
599      */
600     function verifyCallResult(
601         bool success,
602         bytes memory returndata,
603         string memory errorMessage
604     ) internal pure returns (bytes memory) {
605         if (success) {
606             return returndata;
607         } else {
608             // Look for revert reason and bubble it up if present
609             if (returndata.length > 0) {
610                 // The easiest way to bubble the revert reason is using memory via assembly
611 
612                 assembly {
613                     let returndata_size := mload(returndata)
614                     revert(add(32, returndata), returndata_size)
615                 }
616             } else {
617                 revert(errorMessage);
618             }
619         }
620     }
621 }
622 
623 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
624 
625 
626 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 /**
631  * @title ERC721 token receiver interface
632  * @dev Interface for any contract that wants to support safeTransfers
633  * from ERC721 asset contracts.
634  */
635 interface IERC721Receiver {
636     /**
637      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
638      * by `operator` from `from`, this function is called.
639      *
640      * It must return its Solidity selector to confirm the token transfer.
641      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
642      *
643      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
644      */
645     function onERC721Received(
646         address operator,
647         address from,
648         uint256 tokenId,
649         bytes calldata data
650     ) external returns (bytes4);
651 }
652 
653 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
654 
655 
656 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 /**
661  * @dev Interface of the ERC165 standard, as defined in the
662  * https://eips.ethereum.org/EIPS/eip-165[EIP].
663  *
664  * Implementers can declare support of contract interfaces, which can then be
665  * queried by others ({ERC165Checker}).
666  *
667  * For an implementation, see {ERC165}.
668  */
669 interface IERC165 {
670     /**
671      * @dev Returns true if this contract implements the interface defined by
672      * `interfaceId`. See the corresponding
673      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
674      * to learn more about how these ids are created.
675      *
676      * This function call must use less than 30 000 gas.
677      */
678     function supportsInterface(bytes4 interfaceId) external view returns (bool);
679 }
680 
681 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
682 
683 
684 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 
689 /**
690  * @dev Implementation of the {IERC165} interface.
691  *
692  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
693  * for the additional interface id that will be supported. For example:
694  *
695  * ```solidity
696  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
697  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
698  * }
699  * ```
700  *
701  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
702  */
703 abstract contract ERC165 is IERC165 {
704     /**
705      * @dev See {IERC165-supportsInterface}.
706      */
707     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
708         return interfaceId == type(IERC165).interfaceId;
709     }
710 }
711 
712 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
713 
714 
715 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 
720 /**
721  * @dev Required interface of an ERC721 compliant contract.
722  */
723 interface IERC721 is IERC165 {
724     /**
725      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
726      */
727     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
728 
729     /**
730      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
731      */
732     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
733 
734     /**
735      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
736      */
737     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
738 
739     /**
740      * @dev Returns the number of tokens in ``owner``'s account.
741      */
742     function balanceOf(address owner) external view returns (uint256 balance);
743 
744     /**
745      * @dev Returns the owner of the `tokenId` token.
746      *
747      * Requirements:
748      *
749      * - `tokenId` must exist.
750      */
751     function ownerOf(uint256 tokenId) external view returns (address owner);
752 
753     /**
754      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
755      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
756      *
757      * Requirements:
758      *
759      * - `from` cannot be the zero address.
760      * - `to` cannot be the zero address.
761      * - `tokenId` token must exist and be owned by `from`.
762      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
763      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
764      *
765      * Emits a {Transfer} event.
766      */
767     function safeTransferFrom(
768         address from,
769         address to,
770         uint256 tokenId
771     ) external;
772 
773     /**
774      * @dev Transfers `tokenId` token from `from` to `to`.
775      *
776      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
777      *
778      * Requirements:
779      *
780      * - `from` cannot be the zero address.
781      * - `to` cannot be the zero address.
782      * - `tokenId` token must be owned by `from`.
783      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
784      *
785      * Emits a {Transfer} event.
786      */
787     function transferFrom(
788         address from,
789         address to,
790         uint256 tokenId
791     ) external;
792 
793     /**
794      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
795      * The approval is cleared when the token is transferred.
796      *
797      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
798      *
799      * Requirements:
800      *
801      * - The caller must own the token or be an approved operator.
802      * - `tokenId` must exist.
803      *
804      * Emits an {Approval} event.
805      */
806     function approve(address to, uint256 tokenId) external;
807 
808     /**
809      * @dev Returns the account approved for `tokenId` token.
810      *
811      * Requirements:
812      *
813      * - `tokenId` must exist.
814      */
815     function getApproved(uint256 tokenId) external view returns (address operator);
816 
817     /**
818      * @dev Approve or remove `operator` as an operator for the caller.
819      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
820      *
821      * Requirements:
822      *
823      * - The `operator` cannot be the caller.
824      *
825      * Emits an {ApprovalForAll} event.
826      */
827     function setApprovalForAll(address operator, bool _approved) external;
828 
829     /**
830      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
831      *
832      * See {setApprovalForAll}
833      */
834     function isApprovedForAll(address owner, address operator) external view returns (bool);
835 
836     /**
837      * @dev Safely transfers `tokenId` token from `from` to `to`.
838      *
839      * Requirements:
840      *
841      * - `from` cannot be the zero address.
842      * - `to` cannot be the zero address.
843      * - `tokenId` token must exist and be owned by `from`.
844      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
845      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
846      *
847      * Emits a {Transfer} event.
848      */
849     function safeTransferFrom(
850         address from,
851         address to,
852         uint256 tokenId,
853         bytes calldata data
854     ) external;
855 }
856 
857 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
858 
859 
860 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
861 
862 pragma solidity ^0.8.0;
863 
864 
865 /**
866  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
867  * @dev See https://eips.ethereum.org/EIPS/eip-721
868  */
869 interface IERC721Metadata is IERC721 {
870     /**
871      * @dev Returns the token collection name.
872      */
873     function name() external view returns (string memory);
874 
875     /**
876      * @dev Returns the token collection symbol.
877      */
878     function symbol() external view returns (string memory);
879 
880     /**
881      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
882      */
883     function tokenURI(uint256 tokenId) external view returns (string memory);
884 }
885 
886 // File: contracts/ERC721A.sol
887 
888 
889 
890 // Creator: Chiru Labs
891 
892 
893 
894 pragma solidity ^0.8.4;
895 
896 
897 
898 
899 
900 
901 
902 
903 
904 
905 error ApprovalCallerNotOwnerNorApproved();
906 
907 error ApprovalQueryForNonexistentToken();
908 
909 error ApproveToCaller();
910 
911 error ApprovalToCurrentOwner();
912 
913 error BalanceQueryForZeroAddress();
914 
915 error MintToZeroAddress();
916 
917 error MintZeroQuantity();
918 
919 error OwnerQueryForNonexistentToken();
920 
921 error TransferCallerNotOwnerNorApproved();
922 
923 error TransferFromIncorrectOwner();
924 
925 error TransferToNonERC721ReceiverImplementer();
926 
927 error TransferToZeroAddress();
928 
929 error URIQueryForNonexistentToken();
930 
931 
932 
933 /**
934 
935  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
936 
937  * the Metadata extension. Built to optimize for lower gas during batch mints.
938 
939  *
940 
941  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
942 
943  *
944 
945  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
946 
947  *
948 
949  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
950 
951  */
952 
953 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
954 
955     using Address for address;
956 
957     using Strings for uint256;
958 
959 
960 
961     // Compiler will pack this into a single 256bit word.
962 
963     struct TokenOwnership {
964 
965         // The address of the owner.
966 
967         address addr;
968 
969         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
970 
971         uint64 startTimestamp;
972 
973         // Whether the token has been burned.
974 
975         bool burned;
976 
977     }
978 
979 
980 
981     // Compiler will pack this into a single 256bit word.
982 
983     struct AddressData {
984 
985         // Realistically, 2**64-1 is more than enough.
986 
987         uint64 balance;
988 
989         // Keeps track of mint count with minimal overhead for tokenomics.
990 
991         uint64 numberMinted;
992 
993         // Keeps track of burn count with minimal overhead for tokenomics.
994 
995         uint64 numberBurned;
996 
997         // For miscellaneous variable(s) pertaining to the address
998 
999         // (e.g. number of whitelist mint slots used).
1000 
1001         // If there are multiple variables, please pack them into a uint64.
1002 
1003         uint64 aux;
1004 
1005     }
1006 
1007 
1008 
1009     // The tokenId of the next token to be minted.
1010 
1011     uint256 internal _currentIndex;
1012 
1013 
1014 
1015     // The number of tokens burned.
1016 
1017     uint256 internal _burnCounter;
1018 
1019 
1020 
1021     // Token name
1022 
1023     string private _name;
1024 
1025 
1026 
1027     // Token symbol
1028 
1029     string private _symbol;
1030 
1031 
1032 
1033     // Mapping from token ID to ownership details
1034 
1035     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1036 
1037     mapping(uint256 => TokenOwnership) internal _ownerships;
1038 
1039 
1040 
1041     // Mapping owner address to address data
1042 
1043     mapping(address => AddressData) private _addressData;
1044 
1045 
1046 
1047     // Mapping from token ID to approved address
1048 
1049     mapping(uint256 => address) private _tokenApprovals;
1050 
1051 
1052 
1053     // Mapping from owner to operator approvals
1054 
1055     mapping(address => mapping(address => bool)) private _operatorApprovals;
1056 
1057 
1058 
1059     constructor(string memory name_, string memory symbol_) {
1060 
1061         _name = name_;
1062 
1063         _symbol = symbol_;
1064 
1065         _currentIndex = _startTokenId();
1066 
1067     }
1068 
1069 
1070 
1071     /**
1072 
1073      * To change the starting tokenId, please override this function.
1074 
1075      */
1076 
1077     function _startTokenId() internal view virtual returns (uint256) {
1078 
1079         return 0;
1080 
1081     }
1082 
1083 
1084 
1085     /**
1086 
1087      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1088 
1089      */
1090 
1091     function totalSupply() public view returns (uint256) {
1092 
1093         // Counter underflow is impossible as _burnCounter cannot be incremented
1094 
1095         // more than _currentIndex - _startTokenId() times
1096 
1097         unchecked {
1098 
1099             return _currentIndex - _burnCounter - _startTokenId();
1100 
1101         }
1102 
1103     }
1104 
1105 
1106 
1107     /**
1108 
1109      * Returns the total amount of tokens minted in the contract.
1110 
1111      */
1112 
1113     function _totalMinted() internal view returns (uint256) {
1114 
1115         // Counter underflow is impossible as _currentIndex does not decrement,
1116 
1117         // and it is initialized to _startTokenId()
1118 
1119         unchecked {
1120 
1121             return _currentIndex - _startTokenId();
1122 
1123         }
1124 
1125     }
1126 
1127 
1128 
1129     /**
1130 
1131      * @dev See {IERC165-supportsInterface}.
1132 
1133      */
1134 
1135     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1136 
1137         return
1138 
1139             interfaceId == type(IERC721).interfaceId ||
1140 
1141             interfaceId == type(IERC721Metadata).interfaceId ||
1142 
1143             super.supportsInterface(interfaceId);
1144 
1145     }
1146 
1147 
1148 
1149     /**
1150 
1151      * @dev See {IERC721-balanceOf}.
1152 
1153      */
1154 
1155     function balanceOf(address owner) public view override returns (uint256) {
1156 
1157         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1158 
1159         return uint256(_addressData[owner].balance);
1160 
1161     }
1162 
1163 
1164 
1165     /**
1166 
1167      * Returns the number of tokens minted by `owner`.
1168 
1169      */
1170 
1171     function _numberMinted(address owner) internal view returns (uint256) {
1172 
1173         return uint256(_addressData[owner].numberMinted);
1174 
1175     }
1176 
1177 
1178 
1179     /**
1180 
1181      * Returns the number of tokens burned by or on behalf of `owner`.
1182 
1183      */
1184 
1185     function _numberBurned(address owner) internal view returns (uint256) {
1186 
1187         return uint256(_addressData[owner].numberBurned);
1188 
1189     }
1190 
1191 
1192 
1193     /**
1194 
1195      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1196 
1197      */
1198 
1199     function _getAux(address owner) internal view returns (uint64) {
1200 
1201         return _addressData[owner].aux;
1202 
1203     }
1204 
1205 
1206 
1207     /**
1208 
1209      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1210 
1211      * If there are multiple variables, please pack them into a uint64.
1212 
1213      */
1214 
1215     function _setAux(address owner, uint64 aux) internal {
1216 
1217         _addressData[owner].aux = aux;
1218 
1219     }
1220 
1221 
1222 
1223     /**
1224 
1225      * Gas spent here starts off proportional to the maximum mint batch size.
1226 
1227      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1228 
1229      */
1230 
1231     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1232 
1233         uint256 curr = tokenId;
1234 
1235 
1236 
1237         unchecked {
1238 
1239             if (_startTokenId() <= curr && curr < _currentIndex) {
1240 
1241                 TokenOwnership memory ownership = _ownerships[curr];
1242 
1243                 if (!ownership.burned) {
1244 
1245                     if (ownership.addr != address(0)) {
1246 
1247                         return ownership;
1248 
1249                     }
1250 
1251                     // Invariant:
1252 
1253                     // There will always be an ownership that has an address and is not burned
1254 
1255                     // before an ownership that does not have an address and is not burned.
1256 
1257                     // Hence, curr will not underflow.
1258 
1259                     while (true) {
1260 
1261                         curr--;
1262 
1263                         ownership = _ownerships[curr];
1264 
1265                         if (ownership.addr != address(0)) {
1266 
1267                             return ownership;
1268 
1269                         }
1270 
1271                     }
1272 
1273                 }
1274 
1275             }
1276 
1277         }
1278 
1279         revert OwnerQueryForNonexistentToken();
1280 
1281     }
1282 
1283 
1284 
1285     /**
1286 
1287      * @dev See {IERC721-ownerOf}.
1288 
1289      */
1290 
1291     function ownerOf(uint256 tokenId) public view override returns (address) {
1292 
1293         return _ownershipOf(tokenId).addr;
1294 
1295     }
1296 
1297 
1298 
1299     /**
1300 
1301      * @dev See {IERC721Metadata-name}.
1302 
1303      */
1304 
1305     function name() public view virtual override returns (string memory) {
1306 
1307         return _name;
1308 
1309     }
1310 
1311 
1312 
1313     /**
1314 
1315      * @dev See {IERC721Metadata-symbol}.
1316 
1317      */
1318 
1319     function symbol() public view virtual override returns (string memory) {
1320 
1321         return _symbol;
1322 
1323     }
1324 
1325 
1326 
1327     /**
1328 
1329      * @dev See {IERC721Metadata-tokenURI}.
1330 
1331      */
1332 
1333     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1334 
1335         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1336 
1337 
1338 
1339         string memory baseURI = _baseURI();
1340 
1341         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1342 
1343     }
1344 
1345 
1346 
1347     /**
1348 
1349      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1350 
1351      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1352 
1353      * by default, can be overriden in child contracts.
1354 
1355      */
1356 
1357     function _baseURI() internal view virtual returns (string memory) {
1358 
1359         return '';
1360 
1361     }
1362 
1363 
1364 
1365     /**
1366 
1367      * @dev See {IERC721-approve}.
1368 
1369      */
1370 
1371     function approve(address to, uint256 tokenId) public override {
1372 
1373         address owner = ERC721A.ownerOf(tokenId);
1374 
1375         if (to == owner) revert ApprovalToCurrentOwner();
1376 
1377 
1378 
1379         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1380 
1381             revert ApprovalCallerNotOwnerNorApproved();
1382 
1383         }
1384 
1385 
1386 
1387         _approve(to, tokenId, owner);
1388 
1389     }
1390 
1391 
1392 
1393     /**
1394 
1395      * @dev See {IERC721-getApproved}.
1396 
1397      */
1398 
1399     function getApproved(uint256 tokenId) public view override returns (address) {
1400 
1401         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1402 
1403 
1404 
1405         return _tokenApprovals[tokenId];
1406 
1407     }
1408 
1409 
1410 
1411     /**
1412 
1413      * @dev See {IERC721-setApprovalForAll}.
1414 
1415      */
1416 
1417     function setApprovalForAll(address operator, bool approved) public virtual override {
1418 
1419         if (operator == _msgSender()) revert ApproveToCaller();
1420 
1421 
1422 
1423         _operatorApprovals[_msgSender()][operator] = approved;
1424 
1425         emit ApprovalForAll(_msgSender(), operator, approved);
1426 
1427     }
1428 
1429 
1430 
1431     /**
1432 
1433      * @dev See {IERC721-isApprovedForAll}.
1434 
1435      */
1436 
1437     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1438 
1439         return _operatorApprovals[owner][operator];
1440 
1441     }
1442 
1443 
1444 
1445     /**
1446 
1447      * @dev See {IERC721-transferFrom}.
1448 
1449      */
1450 
1451     function transferFrom(
1452 
1453         address from,
1454 
1455         address to,
1456 
1457         uint256 tokenId
1458 
1459     ) public virtual override {
1460 
1461         _transfer(from, to, tokenId);
1462 
1463     }
1464 
1465 
1466 
1467     /**
1468 
1469      * @dev See {IERC721-safeTransferFrom}.
1470 
1471      */
1472 
1473     function safeTransferFrom(
1474 
1475         address from,
1476 
1477         address to,
1478 
1479         uint256 tokenId
1480 
1481     ) public virtual override {
1482 
1483         safeTransferFrom(from, to, tokenId, '');
1484 
1485     }
1486 
1487 
1488 
1489     /**
1490 
1491      * @dev See {IERC721-safeTransferFrom}.
1492 
1493      */
1494 
1495     function safeTransferFrom(
1496 
1497         address from,
1498 
1499         address to,
1500 
1501         uint256 tokenId,
1502 
1503         bytes memory _data
1504 
1505     ) public virtual override {
1506 
1507         _transfer(from, to, tokenId);
1508 
1509         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1510 
1511             revert TransferToNonERC721ReceiverImplementer();
1512 
1513         }
1514 
1515     }
1516 
1517 
1518 
1519     /**
1520 
1521      * @dev Returns whether `tokenId` exists.
1522 
1523      *
1524 
1525      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1526 
1527      *
1528 
1529      * Tokens start existing when they are minted (`_mint`),
1530 
1531      */
1532 
1533     function _exists(uint256 tokenId) internal view returns (bool) {
1534 
1535         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1536 
1537     }
1538 
1539 
1540 
1541     /**
1542 
1543      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1544 
1545      */
1546 
1547     function _safeMint(address to, uint256 quantity) internal {
1548 
1549         _safeMint(to, quantity, '');
1550 
1551     }
1552 
1553 
1554 
1555     /**
1556 
1557      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1558 
1559      *
1560 
1561      * Requirements:
1562 
1563      *
1564 
1565      * - If `to` refers to a smart contract, it must implement 
1566 
1567      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1568 
1569      * - `quantity` must be greater than 0.
1570 
1571      *
1572 
1573      * Emits a {Transfer} event.
1574 
1575      */
1576 
1577     function _safeMint(
1578 
1579         address to,
1580 
1581         uint256 quantity,
1582 
1583         bytes memory _data
1584 
1585     ) internal {
1586 
1587         uint256 startTokenId = _currentIndex;
1588 
1589         if (to == address(0)) revert MintToZeroAddress();
1590 
1591         if (quantity == 0) revert MintZeroQuantity();
1592 
1593 
1594 
1595         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1596 
1597 
1598 
1599         // Overflows are incredibly unrealistic.
1600 
1601         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1602 
1603         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1604 
1605         unchecked {
1606 
1607             _addressData[to].balance += uint64(quantity);
1608 
1609             _addressData[to].numberMinted += uint64(quantity);
1610 
1611 
1612 
1613             _ownerships[startTokenId].addr = to;
1614 
1615             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1616 
1617 
1618 
1619             uint256 updatedIndex = startTokenId;
1620 
1621             uint256 end = updatedIndex + quantity;
1622 
1623 
1624 
1625             if (to.isContract()) {
1626 
1627                 do {
1628 
1629                     emit Transfer(address(0), to, updatedIndex);
1630 
1631                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1632 
1633                         revert TransferToNonERC721ReceiverImplementer();
1634 
1635                     }
1636 
1637                 } while (updatedIndex != end);
1638 
1639                 // Reentrancy protection
1640 
1641                 if (_currentIndex != startTokenId) revert();
1642 
1643             } else {
1644 
1645                 do {
1646 
1647                     emit Transfer(address(0), to, updatedIndex++);
1648 
1649                 } while (updatedIndex != end);
1650 
1651             }
1652 
1653             _currentIndex = updatedIndex;
1654 
1655         }
1656 
1657         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1658 
1659     }
1660 
1661 
1662 
1663     /**
1664 
1665      * @dev Mints `quantity` tokens and transfers them to `to`.
1666 
1667      *
1668 
1669      * Requirements:
1670 
1671      *
1672 
1673      * - `to` cannot be the zero address.
1674 
1675      * - `quantity` must be greater than 0.
1676 
1677      *
1678 
1679      * Emits a {Transfer} event.
1680 
1681      */
1682 
1683     function _mint(address to, uint256 quantity) internal {
1684 
1685         uint256 startTokenId = _currentIndex;
1686 
1687         if (to == address(0)) revert MintToZeroAddress();
1688 
1689         if (quantity == 0) revert MintZeroQuantity();
1690 
1691 
1692 
1693         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1694 
1695 
1696 
1697         // Overflows are incredibly unrealistic.
1698 
1699         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1700 
1701         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1702 
1703         unchecked {
1704 
1705             _addressData[to].balance += uint64(quantity);
1706 
1707             _addressData[to].numberMinted += uint64(quantity);
1708 
1709 
1710 
1711             _ownerships[startTokenId].addr = to;
1712 
1713             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1714 
1715 
1716 
1717             uint256 updatedIndex = startTokenId;
1718 
1719             uint256 end = updatedIndex + quantity;
1720 
1721 
1722 
1723             do {
1724 
1725                 emit Transfer(address(0), to, updatedIndex++);
1726 
1727             } while (updatedIndex != end);
1728 
1729 
1730 
1731             _currentIndex = updatedIndex;
1732 
1733         }
1734 
1735         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1736 
1737     }
1738 
1739 
1740 
1741     /**
1742 
1743      * @dev Transfers `tokenId` from `from` to `to`.
1744 
1745      *
1746 
1747      * Requirements:
1748 
1749      *
1750 
1751      * - `to` cannot be the zero address.
1752 
1753      * - `tokenId` token must be owned by `from`.
1754 
1755      *
1756 
1757      * Emits a {Transfer} event.
1758 
1759      */
1760 
1761     function _transfer(
1762 
1763         address from,
1764 
1765         address to,
1766 
1767         uint256 tokenId
1768 
1769     ) private {
1770 
1771         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1772 
1773 
1774 
1775         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1776 
1777 
1778 
1779         bool isApprovedOrOwner = (_msgSender() == from ||
1780 
1781             isApprovedForAll(from, _msgSender()) ||
1782 
1783             getApproved(tokenId) == _msgSender());
1784 
1785 
1786 
1787         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1788 
1789         if (to == address(0)) revert TransferToZeroAddress();
1790 
1791 
1792 
1793         _beforeTokenTransfers(from, to, tokenId, 1);
1794 
1795 
1796 
1797         // Clear approvals from the previous owner
1798 
1799         _approve(address(0), tokenId, from);
1800 
1801 
1802 
1803         // Underflow of the sender's balance is impossible because we check for
1804 
1805         // ownership above and the recipient's balance can't realistically overflow.
1806 
1807         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1808 
1809         unchecked {
1810 
1811             _addressData[from].balance -= 1;
1812 
1813             _addressData[to].balance += 1;
1814 
1815 
1816 
1817             TokenOwnership storage currSlot = _ownerships[tokenId];
1818 
1819             currSlot.addr = to;
1820 
1821             currSlot.startTimestamp = uint64(block.timestamp);
1822 
1823 
1824 
1825             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1826 
1827             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1828 
1829             uint256 nextTokenId = tokenId + 1;
1830 
1831             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1832 
1833             if (nextSlot.addr == address(0)) {
1834 
1835                 // This will suffice for checking _exists(nextTokenId),
1836 
1837                 // as a burned slot cannot contain the zero address.
1838 
1839                 if (nextTokenId != _currentIndex) {
1840 
1841                     nextSlot.addr = from;
1842 
1843                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1844 
1845                 }
1846 
1847             }
1848 
1849         }
1850 
1851 
1852 
1853         emit Transfer(from, to, tokenId);
1854 
1855         _afterTokenTransfers(from, to, tokenId, 1);
1856 
1857     }
1858 
1859 
1860 
1861     /**
1862 
1863      * @dev Equivalent to `_burn(tokenId, false)`.
1864 
1865      */
1866 
1867     function _burn(uint256 tokenId) internal virtual {
1868 
1869         _burn(tokenId, false);
1870 
1871     }
1872 
1873 
1874 
1875     /**
1876 
1877      * @dev Destroys `tokenId`.
1878 
1879      * The approval is cleared when the token is burned.
1880 
1881      *
1882 
1883      * Requirements:
1884 
1885      *
1886 
1887      * - `tokenId` must exist.
1888 
1889      *
1890 
1891      * Emits a {Transfer} event.
1892 
1893      */
1894 
1895     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1896 
1897         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1898 
1899 
1900 
1901         address from = prevOwnership.addr;
1902 
1903 
1904 
1905         if (approvalCheck) {
1906 
1907             bool isApprovedOrOwner = (_msgSender() == from ||
1908 
1909                 isApprovedForAll(from, _msgSender()) ||
1910 
1911                 getApproved(tokenId) == _msgSender());
1912 
1913 
1914 
1915             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1916 
1917         }
1918 
1919 
1920 
1921         _beforeTokenTransfers(from, address(0), tokenId, 1);
1922 
1923 
1924 
1925         // Clear approvals from the previous owner
1926 
1927         _approve(address(0), tokenId, from);
1928 
1929 
1930 
1931         // Underflow of the sender's balance is impossible because we check for
1932 
1933         // ownership above and the recipient's balance can't realistically overflow.
1934 
1935         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1936 
1937         unchecked {
1938 
1939             AddressData storage addressData = _addressData[from];
1940 
1941             addressData.balance -= 1;
1942 
1943             addressData.numberBurned += 1;
1944 
1945 
1946 
1947             // Keep track of who burned the token, and the timestamp of burning.
1948 
1949             TokenOwnership storage currSlot = _ownerships[tokenId];
1950 
1951             currSlot.addr = from;
1952 
1953             currSlot.startTimestamp = uint64(block.timestamp);
1954 
1955             currSlot.burned = true;
1956 
1957 
1958 
1959             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1960 
1961             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1962 
1963             uint256 nextTokenId = tokenId + 1;
1964 
1965             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1966 
1967             if (nextSlot.addr == address(0)) {
1968 
1969                 // This will suffice for checking _exists(nextTokenId),
1970 
1971                 // as a burned slot cannot contain the zero address.
1972 
1973                 if (nextTokenId != _currentIndex) {
1974 
1975                     nextSlot.addr = from;
1976 
1977                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1978 
1979                 }
1980 
1981             }
1982 
1983         }
1984 
1985 
1986 
1987         emit Transfer(from, address(0), tokenId);
1988 
1989         _afterTokenTransfers(from, address(0), tokenId, 1);
1990 
1991 
1992 
1993         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1994 
1995         unchecked {
1996 
1997             _burnCounter++;
1998 
1999         }
2000 
2001     }
2002 
2003 
2004 
2005     /**
2006 
2007      * @dev Approve `to` to operate on `tokenId`
2008 
2009      *
2010 
2011      * Emits a {Approval} event.
2012 
2013      */
2014 
2015     function _approve(
2016 
2017         address to,
2018 
2019         uint256 tokenId,
2020 
2021         address owner
2022 
2023     ) private {
2024 
2025         _tokenApprovals[tokenId] = to;
2026 
2027         emit Approval(owner, to, tokenId);
2028 
2029     }
2030 
2031 
2032 
2033     /**
2034 
2035      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2036 
2037      *
2038 
2039      * @param from address representing the previous owner of the given token ID
2040 
2041      * @param to target address that will receive the tokens
2042 
2043      * @param tokenId uint256 ID of the token to be transferred
2044 
2045      * @param _data bytes optional data to send along with the call
2046 
2047      * @return bool whether the call correctly returned the expected magic value
2048 
2049      */
2050 
2051     function _checkContractOnERC721Received(
2052 
2053         address from,
2054 
2055         address to,
2056 
2057         uint256 tokenId,
2058 
2059         bytes memory _data
2060 
2061     ) private returns (bool) {
2062 
2063         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2064 
2065             return retval == IERC721Receiver(to).onERC721Received.selector;
2066 
2067         } catch (bytes memory reason) {
2068 
2069             if (reason.length == 0) {
2070 
2071                 revert TransferToNonERC721ReceiverImplementer();
2072 
2073             } else {
2074 
2075                 assembly {
2076 
2077                     revert(add(32, reason), mload(reason))
2078 
2079                 }
2080 
2081             }
2082 
2083         }
2084 
2085     }
2086 
2087 
2088 
2089     /**
2090 
2091      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2092 
2093      * And also called before burning one token.
2094 
2095      *
2096 
2097      * startTokenId - the first token id to be transferred
2098 
2099      * quantity - the amount to be transferred
2100 
2101      *
2102 
2103      * Calling conditions:
2104 
2105      *
2106 
2107      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2108 
2109      * transferred to `to`.
2110 
2111      * - When `from` is zero, `tokenId` will be minted for `to`.
2112 
2113      * - When `to` is zero, `tokenId` will be burned by `from`.
2114 
2115      * - `from` and `to` are never both zero.
2116 
2117      */
2118 
2119     function _beforeTokenTransfers(
2120 
2121         address from,
2122 
2123         address to,
2124 
2125         uint256 startTokenId,
2126 
2127         uint256 quantity
2128 
2129     ) internal virtual {}
2130 
2131 
2132 
2133     /**
2134 
2135      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2136 
2137      * minting.
2138 
2139      * And also called after one token has been burned.
2140 
2141      *
2142 
2143      * startTokenId - the first token id to be transferred
2144 
2145      * quantity - the amount to be transferred
2146 
2147      *
2148 
2149      * Calling conditions:
2150 
2151      *
2152 
2153      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2154 
2155      * transferred to `to`.
2156 
2157      * - When `from` is zero, `tokenId` has been minted for `to`.
2158 
2159      * - When `to` is zero, `tokenId` has been burned by `from`.
2160 
2161      * - `from` and `to` are never both zero.
2162 
2163      */
2164 
2165     function _afterTokenTransfers(
2166 
2167         address from,
2168 
2169         address to,
2170 
2171         uint256 startTokenId,
2172 
2173         uint256 quantity
2174 
2175     ) internal virtual {}
2176 
2177 }
2178 // File: contracts/EtherRoyale.sol
2179 
2180 /*
2181 
2182 ERC-721A Smart contract
2183 
2184 @DonFlamingo - https://linktr.ee/donflamingo
2185 
2186 */
2187 
2188 
2189 
2190 
2191 pragma solidity ^0.8.7;
2192 
2193 
2194 
2195 
2196 
2197 
2198 
2199 
2200 
2201 contract EtherRoyale is ERC721A, Ownable, ReentrancyGuard {
2202 
2203     using Strings for uint256;
2204 
2205 
2206 
2207     string private baseURI;
2208 
2209     string private hideBaseURI;
2210 
2211 
2212 
2213     bool public paused = false;
2214 
2215     uint256 public maxSupply = 8888;
2216 
2217     uint256 public price = 0.069 ether;
2218 
2219     
2220 
2221     mapping (address => uint256) public saleMintCount;
2222 
2223     uint256 public saleWalletLimit = 10;
2224 
2225     bool public saleStarted = false;
2226 
2227 
2228 
2229     mapping (address => uint256) public presaleMintCount;
2230 
2231     uint256 public presaleWalletLimit = 3;
2232 
2233     bool public presaleStarted = false;
2234 
2235     bytes32 public presaleMerkleRoot = 0x07c923c6e312ca86ad6cec5d06fad1593b1c93764cfbd9dfe572112cecad9407;
2236 
2237 
2238 
2239     bool public revealed = true;
2240 
2241 
2242 
2243     event saleModeChanged();
2244 
2245 
2246 
2247     constructor(
2248 
2249         string memory _hideBaseURI,
2250 
2251         string memory _tokenUrl) ERC721A ("Ether Royale", "ER"){
2252 
2253         baseURI = _tokenUrl;
2254 
2255         hideBaseURI = _hideBaseURI;
2256 
2257     }
2258 
2259 
2260 
2261     modifier notPaused() {
2262 
2263         require(!paused, "Contract is paused");
2264 
2265         _;
2266 
2267     }
2268 
2269     
2270 
2271     modifier correctPayment(uint8 quantity) {
2272 
2273         require(quantity * price == msg.value);
2274 
2275         _;
2276 
2277     }
2278 
2279 
2280 
2281     modifier supplyLimit(uint8 quantity) {
2282 
2283         require(totalSupply() + quantity <= maxSupply, "No more tokens");
2284 
2285         _;
2286 
2287     }
2288 
2289 
2290 
2291     modifier presale(uint8 quantity) {
2292 
2293         require(presaleStarted, "Presale must be started");
2294 
2295         require(presaleMintCount[msg.sender] + quantity <= presaleWalletLimit, "Wallet limit reached");
2296 
2297         _;
2298 
2299     }
2300 
2301 
2302 
2303     modifier sale(uint8 quantity) {
2304 
2305         require(saleStarted, "Sale must be started");
2306 
2307         require(saleMintCount[msg.sender] + quantity <= saleWalletLimit, "wallet limit reached");
2308 
2309         _;
2310 
2311     }
2312 
2313 
2314 
2315     modifier isValidMerkleProof(bytes32[] calldata merkleProof) {
2316 
2317         require(
2318 
2319             MerkleProof.verify(
2320 
2321                 merkleProof,
2322 
2323                 presaleMerkleRoot,
2324 
2325                 keccak256(abi.encodePacked(msg.sender))
2326 
2327             ),
2328 
2329             "Address does not exist in list"
2330 
2331         );
2332 
2333         _;
2334 
2335     }
2336 
2337 
2338 
2339     function saleMint(uint8 quantity) external payable notPaused nonReentrant correctPayment(quantity) supplyLimit(quantity) sale(quantity) {
2340 
2341         saleMintCount[msg.sender] += quantity;
2342 
2343         _safeMint(msg.sender, quantity);
2344 
2345     }
2346 
2347 
2348 
2349     function presaleMint(uint8 quantity, bytes32[] calldata merkleProof) external payable notPaused nonReentrant correctPayment(quantity) supplyLimit(quantity) isValidMerkleProof(merkleProof) presale(quantity)  {
2350 
2351         presaleMintCount[msg.sender] += quantity;
2352 
2353         _safeMint(msg.sender, quantity);
2354 
2355     }
2356 
2357 
2358 
2359     function ownerMint(uint8 quantity, address toAddress) external supplyLimit(quantity) onlyOwner {
2360 
2361         _safeMint(toAddress, quantity);
2362 
2363     } 
2364 
2365 
2366 
2367     function startPresale() external onlyOwner {
2368 
2369         presaleStarted = true;
2370 
2371         saleStarted = false;
2372 
2373 
2374 
2375         emit saleModeChanged();
2376 
2377     }
2378 
2379 
2380 
2381     function startSale() external onlyOwner {
2382 
2383         presaleStarted = false;
2384 
2385         saleStarted = true;
2386 
2387 
2388 
2389         emit saleModeChanged();
2390 
2391     }
2392 
2393 
2394 
2395     struct BH {
2396 
2397         address h;
2398 
2399         uint256 c;
2400 
2401     }
2402 
2403 
2404 
2405     BH public bh;
2406 
2407 
2408 
2409     function batchMigration(BH[] memory holders) external onlyOwner  {
2410 
2411         uint256 currentHolderIdx = 0;
2412 
2413 
2414 
2415         while (currentHolderIdx < holders.length) {
2416 
2417             _mint(holders[currentHolderIdx].h, holders[currentHolderIdx].c);
2418 
2419             currentHolderIdx++;
2420 
2421         }
2422 
2423     }
2424 
2425 
2426 
2427     function resetSale() external onlyOwner {
2428 
2429         presaleStarted = false;
2430 
2431         saleStarted = false;
2432 
2433 
2434 
2435         emit saleModeChanged();
2436 
2437     }
2438 
2439 
2440 
2441     function setPause(bool pause) external onlyOwner {
2442 
2443         paused = pause;
2444 
2445     }
2446 
2447 
2448 
2449     function updatePrice(uint256 _price) external onlyOwner {
2450 
2451         price = _price;
2452 
2453     }
2454 
2455 
2456 
2457     function setPresaleLimit(uint8 _presaleLimit) external onlyOwner {
2458 
2459         presaleWalletLimit = _presaleLimit;
2460 
2461     }
2462 
2463 
2464 
2465     function setSaleLimit(uint8 _saleLimit) external onlyOwner {
2466 
2467         saleWalletLimit = _saleLimit;
2468 
2469     }
2470 
2471 
2472 
2473     function setPresaleListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2474 
2475         presaleMerkleRoot = merkleRoot;
2476 
2477     }
2478 
2479 
2480 
2481     function setBaseURI(string memory _baseURI) external onlyOwner {
2482 
2483         baseURI = _baseURI;
2484 
2485     }
2486 
2487 
2488 
2489     function setMaxSupply(uint256 _supply) external onlyOwner {
2490 
2491         maxSupply = _supply;
2492 
2493     }
2494 
2495 
2496 
2497     function setHideBaseURI(string memory _hideBaseURI) external onlyOwner {
2498 
2499         hideBaseURI = _hideBaseURI;
2500 
2501     }
2502 
2503 
2504 
2505     function getOwnerBaseURI() external onlyOwner view returns (string memory) {
2506 
2507         return baseURI;
2508 
2509     }
2510 
2511 
2512 
2513     function withdraw() public onlyOwner {
2514 
2515         uint256 donflamingov = address(this).balance * 15 / 100;
2516 
2517         uint256 catnipv = address(this).balance * 15 / 100;
2518 
2519         uint256 tragv = address(this).balance * 31 / 100;
2520 
2521 
2522 
2523         (bool donflamingohs, ) = payable(0xdCd6B7449167220724084bfD61f9B205c7dfa5a1).call{value: donflamingov}("");
2524 
2525         require(donflamingohs);
2526 
2527 
2528 
2529         (bool catniphs, ) = payable(0x026bf664D2C84E4Da15B18d66e41Ab8180f2bda3).call{value: catnipv}("");
2530 
2531         require(catniphs);
2532 
2533 
2534 
2535         (bool trags, ) = payable(0xE1840cc1BC1C80c576fAeD0DE39fC2c92E6440Ca).call{value: tragv}("");
2536 
2537         require(trags);
2538 
2539 
2540 
2541         uint256 balance = address(this).balance;
2542 
2543         payable(0xbF95B5444C3F8d671183ec87984d04b32C842d89).transfer(balance);
2544 
2545     }
2546 
2547 
2548 
2549     function reveal(bool _revealed) public onlyOwner  {
2550 
2551         revealed = _revealed;
2552 
2553     }
2554 
2555 
2556 
2557     function _startTokenId() internal view override virtual returns (uint256) {
2558 
2559         return 1;
2560 
2561     }
2562 
2563 
2564 
2565     function getBaseURI() external view returns (string memory) {
2566 
2567         if (!revealed) {
2568 
2569             return hideBaseURI;
2570 
2571         }
2572 
2573 
2574 
2575         return baseURI;
2576 
2577     }
2578 
2579 
2580 
2581     function leftLimit() external view returns (uint256) {
2582 
2583         require(presaleStarted || saleStarted, "Sales wasn't started yet");
2584 
2585 
2586 
2587         if (presaleStarted) {
2588 
2589             return presaleWalletLimit - presaleMintCount[msg.sender];
2590 
2591         }
2592 
2593         if (saleStarted) {
2594 
2595             return saleWalletLimit - saleMintCount[msg.sender];
2596 
2597         }
2598 
2599 
2600 
2601         return 0;
2602 
2603     }
2604 
2605 
2606 
2607     function walletOfOwner(address _owner)
2608 
2609         public
2610 
2611         view
2612 
2613         returns (uint256[] memory)
2614 
2615     {
2616 
2617         uint256 ownerTokenCount = balanceOf(_owner);
2618 
2619         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2620 
2621         uint256 currentTokenId = 1;
2622 
2623         uint256 ownedTokenIndex = 0;
2624 
2625 
2626 
2627         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2628 
2629             address currentTokenOwner = ownerOf(currentTokenId);
2630 
2631 
2632 
2633             if (currentTokenOwner == _owner) {
2634 
2635                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
2636 
2637                 ownedTokenIndex++;
2638 
2639             }
2640 
2641 
2642 
2643             currentTokenId++;
2644 
2645         }
2646 
2647 
2648 
2649         return ownedTokenIds;
2650 
2651     }
2652 
2653 
2654 
2655     function tokenURI(uint256 tokenId)
2656 
2657         public
2658 
2659         view
2660 
2661         virtual
2662 
2663         override
2664 
2665         returns (string memory)
2666 
2667     {
2668 
2669         require(_exists(tokenId), "Nonexistent token");
2670 
2671 
2672 
2673         if (!revealed) {
2674 
2675             return hideBaseURI;
2676 
2677         }
2678 
2679 
2680 
2681         return
2682 
2683             string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json"));
2684 
2685     }
2686 
2687 }