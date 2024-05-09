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
857 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
858 
859 
860 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
861 
862 pragma solidity ^0.8.0;
863 
864 
865 /**
866  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
867  * @dev See https://eips.ethereum.org/EIPS/eip-721
868  */
869 interface IERC721Enumerable is IERC721 {
870     /**
871      * @dev Returns the total amount of tokens stored by the contract.
872      */
873     function totalSupply() external view returns (uint256);
874 
875     /**
876      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
877      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
878      */
879     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
880 
881     /**
882      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
883      * Use along with {totalSupply} to enumerate all tokens.
884      */
885     function tokenByIndex(uint256 index) external view returns (uint256);
886 }
887 
888 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
889 
890 
891 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
892 
893 pragma solidity ^0.8.0;
894 
895 
896 /**
897  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
898  * @dev See https://eips.ethereum.org/EIPS/eip-721
899  */
900 interface IERC721Metadata is IERC721 {
901     /**
902      * @dev Returns the token collection name.
903      */
904     function name() external view returns (string memory);
905 
906     /**
907      * @dev Returns the token collection symbol.
908      */
909     function symbol() external view returns (string memory);
910 
911     /**
912      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
913      */
914     function tokenURI(uint256 tokenId) external view returns (string memory);
915 }
916 
917 // File: contracts/ERC721A.sol
918 
919 
920 
921 // Creator: Chiru Labs
922 
923 
924 
925 pragma solidity ^0.8.4;
926 
927 
928 
929 
930 
931 
932 
933 
934 
935 
936 
937 error ApprovalCallerNotOwnerNorApproved();
938 
939 error ApprovalQueryForNonexistentToken();
940 
941 error ApproveToCaller();
942 
943 error ApprovalToCurrentOwner();
944 
945 error BalanceQueryForZeroAddress();
946 
947 error MintedQueryForZeroAddress();
948 
949 error BurnedQueryForZeroAddress();
950 
951 error AuxQueryForZeroAddress();
952 
953 error MintToZeroAddress();
954 
955 error MintZeroQuantity();
956 
957 error OwnerIndexOutOfBounds();
958 
959 error OwnerQueryForNonexistentToken();
960 
961 error TokenIndexOutOfBounds();
962 
963 error TransferCallerNotOwnerNorApproved();
964 
965 error TransferFromIncorrectOwner();
966 
967 error TransferToNonERC721ReceiverImplementer();
968 
969 error TransferToZeroAddress();
970 
971 error URIQueryForNonexistentToken();
972 
973 
974 
975 /**
976 
977  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
978 
979  * the Metadata extension. Built to optimize for lower gas during batch mints.
980 
981  *
982 
983  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
984 
985  *
986 
987  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
988 
989  *
990 
991  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
992 
993  */
994 
995 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
996 
997     using Address for address;
998 
999     using Strings for uint256;
1000 
1001 
1002 
1003     // Compiler will pack this into a single 256bit word.
1004 
1005     struct TokenOwnership {
1006 
1007         // The address of the owner.
1008 
1009         address addr;
1010 
1011         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1012 
1013         uint64 startTimestamp;
1014 
1015         // Whether the token has been burned.
1016 
1017         bool burned;
1018 
1019     }
1020 
1021 
1022 
1023     // Compiler will pack this into a single 256bit word.
1024 
1025     struct AddressData {
1026 
1027         // Realistically, 2**64-1 is more than enough.
1028 
1029         uint64 balance;
1030 
1031         // Keeps track of mint count with minimal overhead for tokenomics.
1032 
1033         uint64 numberMinted;
1034 
1035         // Keeps track of burn count with minimal overhead for tokenomics.
1036 
1037         uint64 numberBurned;
1038 
1039         // For miscellaneous variable(s) pertaining to the address
1040 
1041         // (e.g. number of whitelist mint slots used).
1042 
1043         // If there are multiple variables, please pack them into a uint64.
1044 
1045         uint64 aux;
1046 
1047     }
1048 
1049 
1050 
1051     // The tokenId of the next token to be minted.
1052 
1053     uint256 internal _currentIndex;
1054 
1055 
1056 
1057     // The number of tokens burned.
1058 
1059     uint256 internal _burnCounter;
1060 
1061 
1062 
1063     // Token name
1064 
1065     string private _name;
1066 
1067 
1068 
1069     // Token symbol
1070 
1071     string private _symbol;
1072 
1073 
1074 
1075     // Mapping from token ID to ownership details
1076 
1077     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1078 
1079     mapping(uint256 => TokenOwnership) internal _ownerships;
1080 
1081 
1082 
1083     // Mapping owner address to address data
1084 
1085     mapping(address => AddressData) private _addressData;
1086 
1087 
1088 
1089     // Mapping from token ID to approved address
1090 
1091     mapping(uint256 => address) private _tokenApprovals;
1092 
1093 
1094 
1095     // Mapping from owner to operator approvals
1096 
1097     mapping(address => mapping(address => bool)) private _operatorApprovals;
1098 
1099 
1100 
1101     constructor(string memory name_, string memory symbol_) {
1102 
1103         _name = name_;
1104 
1105         _symbol = symbol_;
1106 
1107         _currentIndex = _startTokenId();
1108 
1109     }
1110 
1111 
1112 
1113     /**
1114 
1115      * To change the starting tokenId, please override this function.
1116 
1117      */
1118 
1119     function _startTokenId() internal view virtual returns (uint256) {
1120 
1121         return 0;
1122 
1123     }
1124 
1125 
1126 
1127     /**
1128 
1129      * @dev See {IERC721Enumerable-totalSupply}.
1130 
1131      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1132 
1133      */
1134 
1135     function totalSupply() public view returns (uint256) {
1136 
1137         // Counter underflow is impossible as _burnCounter cannot be incremented
1138 
1139         // more than _currentIndex - _startTokenId() times
1140 
1141         unchecked {
1142 
1143             return _currentIndex - _burnCounter - _startTokenId();
1144 
1145         }
1146 
1147     }
1148 
1149 
1150 
1151     /**
1152 
1153      * Returns the total amount of tokens minted in the contract.
1154 
1155      */
1156 
1157     function _totalMinted() internal view returns (uint256) {
1158 
1159         // Counter underflow is impossible as _currentIndex does not decrement,
1160 
1161         // and it is initialized to _startTokenId()
1162 
1163         unchecked {
1164 
1165             return _currentIndex - _startTokenId();
1166 
1167         }
1168 
1169     }
1170 
1171 
1172 
1173     /**
1174 
1175      * @dev See {IERC165-supportsInterface}.
1176 
1177      */
1178 
1179     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1180 
1181         return
1182 
1183             interfaceId == type(IERC721).interfaceId ||
1184 
1185             interfaceId == type(IERC721Metadata).interfaceId ||
1186 
1187             super.supportsInterface(interfaceId);
1188 
1189     }
1190 
1191 
1192 
1193     /**
1194 
1195      * @dev See {IERC721-balanceOf}.
1196 
1197      */
1198 
1199     function balanceOf(address owner) public view override returns (uint256) {
1200 
1201         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1202 
1203         return uint256(_addressData[owner].balance);
1204 
1205     }
1206 
1207 
1208 
1209     /**
1210 
1211      * Returns the number of tokens minted by `owner`.
1212 
1213      */
1214 
1215     function _numberMinted(address owner) internal view returns (uint256) {
1216 
1217         if (owner == address(0)) revert MintedQueryForZeroAddress();
1218 
1219         return uint256(_addressData[owner].numberMinted);
1220 
1221     }
1222 
1223 
1224 
1225     /**
1226 
1227      * Returns the number of tokens burned by or on behalf of `owner`.
1228 
1229      */
1230 
1231     function _numberBurned(address owner) internal view returns (uint256) {
1232 
1233         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1234 
1235         return uint256(_addressData[owner].numberBurned);
1236 
1237     }
1238 
1239 
1240 
1241     /**
1242 
1243      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1244 
1245      */
1246 
1247     function _getAux(address owner) internal view returns (uint64) {
1248 
1249         if (owner == address(0)) revert AuxQueryForZeroAddress();
1250 
1251         return _addressData[owner].aux;
1252 
1253     }
1254 
1255 
1256 
1257     /**
1258 
1259      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1260 
1261      * If there are multiple variables, please pack them into a uint64.
1262 
1263      */
1264 
1265     function _setAux(address owner, uint64 aux) internal {
1266 
1267         if (owner == address(0)) revert AuxQueryForZeroAddress();
1268 
1269         _addressData[owner].aux = aux;
1270 
1271     }
1272 
1273 
1274 
1275     /**
1276 
1277      * Gas spent here starts off proportional to the maximum mint batch size.
1278 
1279      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1280 
1281      */
1282 
1283     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1284 
1285         uint256 curr = tokenId;
1286 
1287 
1288 
1289         unchecked {
1290 
1291             if (_startTokenId() <= curr && curr < _currentIndex) {
1292 
1293                 TokenOwnership memory ownership = _ownerships[curr];
1294 
1295                 if (!ownership.burned) {
1296 
1297                     if (ownership.addr != address(0)) {
1298 
1299                         return ownership;
1300 
1301                     }
1302 
1303                     // Invariant:
1304 
1305                     // There will always be an ownership that has an address and is not burned
1306 
1307                     // before an ownership that does not have an address and is not burned.
1308 
1309                     // Hence, curr will not underflow.
1310 
1311                     while (true) {
1312 
1313                         curr--;
1314 
1315                         ownership = _ownerships[curr];
1316 
1317                         if (ownership.addr != address(0)) {
1318 
1319                             return ownership;
1320 
1321                         }
1322 
1323                     }
1324 
1325                 }
1326 
1327             }
1328 
1329         }
1330 
1331         revert OwnerQueryForNonexistentToken();
1332 
1333     }
1334 
1335 
1336 
1337     /**
1338 
1339      * @dev See {IERC721-ownerOf}.
1340 
1341      */
1342 
1343     function ownerOf(uint256 tokenId) public view override returns (address) {
1344 
1345         return ownershipOf(tokenId).addr;
1346 
1347     }
1348 
1349 
1350 
1351     /**
1352 
1353      * @dev See {IERC721Metadata-name}.
1354 
1355      */
1356 
1357     function name() public view virtual override returns (string memory) {
1358 
1359         return _name;
1360 
1361     }
1362 
1363 
1364 
1365     /**
1366 
1367      * @dev See {IERC721Metadata-symbol}.
1368 
1369      */
1370 
1371     function symbol() public view virtual override returns (string memory) {
1372 
1373         return _symbol;
1374 
1375     }
1376 
1377 
1378 
1379     /**
1380 
1381      * @dev See {IERC721Metadata-tokenURI}.
1382 
1383      */
1384 
1385     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1386 
1387         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1388 
1389 
1390 
1391         string memory baseURI = _baseURI();
1392 
1393         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1394 
1395     }
1396 
1397 
1398 
1399     /**
1400 
1401      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1402 
1403      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1404 
1405      * by default, can be overriden in child contracts.
1406 
1407      */
1408 
1409     function _baseURI() internal view virtual returns (string memory) {
1410 
1411         return '';
1412 
1413     }
1414 
1415 
1416 
1417     /**
1418 
1419      * @dev See {IERC721-approve}.
1420 
1421      */
1422 
1423     function approve(address to, uint256 tokenId) public override {
1424 
1425         address owner = ERC721A.ownerOf(tokenId);
1426 
1427         if (to == owner) revert ApprovalToCurrentOwner();
1428 
1429 
1430 
1431         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1432 
1433             revert ApprovalCallerNotOwnerNorApproved();
1434 
1435         }
1436 
1437 
1438 
1439         _approve(to, tokenId, owner);
1440 
1441     }
1442 
1443 
1444 
1445     /**
1446 
1447      * @dev See {IERC721-getApproved}.
1448 
1449      */
1450 
1451     function getApproved(uint256 tokenId) public view override returns (address) {
1452 
1453         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1454 
1455 
1456 
1457         return _tokenApprovals[tokenId];
1458 
1459     }
1460 
1461 
1462 
1463     /**
1464 
1465      * @dev See {IERC721-setApprovalForAll}.
1466 
1467      */
1468 
1469     function setApprovalForAll(address operator, bool approved) public override {
1470 
1471         if (operator == _msgSender()) revert ApproveToCaller();
1472 
1473 
1474 
1475         _operatorApprovals[_msgSender()][operator] = approved;
1476 
1477         emit ApprovalForAll(_msgSender(), operator, approved);
1478 
1479     }
1480 
1481 
1482 
1483     /**
1484 
1485      * @dev See {IERC721-isApprovedForAll}.
1486 
1487      */
1488 
1489     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1490 
1491         return _operatorApprovals[owner][operator];
1492 
1493     }
1494 
1495 
1496 
1497     /**
1498 
1499      * @dev See {IERC721-transferFrom}.
1500 
1501      */
1502 
1503     function transferFrom(
1504 
1505         address from,
1506 
1507         address to,
1508 
1509         uint256 tokenId
1510 
1511     ) public virtual override {
1512 
1513         _transfer(from, to, tokenId);
1514 
1515     }
1516 
1517 
1518 
1519     /**
1520 
1521      * @dev See {IERC721-safeTransferFrom}.
1522 
1523      */
1524 
1525     function safeTransferFrom(
1526 
1527         address from,
1528 
1529         address to,
1530 
1531         uint256 tokenId
1532 
1533     ) public virtual override {
1534 
1535         safeTransferFrom(from, to, tokenId, '');
1536 
1537     }
1538 
1539 
1540 
1541     /**
1542 
1543      * @dev See {IERC721-safeTransferFrom}.
1544 
1545      */
1546 
1547     function safeTransferFrom(
1548 
1549         address from,
1550 
1551         address to,
1552 
1553         uint256 tokenId,
1554 
1555         bytes memory _data
1556 
1557     ) public virtual override {
1558 
1559         _transfer(from, to, tokenId);
1560 
1561         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1562 
1563             revert TransferToNonERC721ReceiverImplementer();
1564 
1565         }
1566 
1567     }
1568 
1569 
1570 
1571     /**
1572 
1573      * @dev Returns whether `tokenId` exists.
1574 
1575      *
1576 
1577      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1578 
1579      *
1580 
1581      * Tokens start existing when they are minted (`_mint`),
1582 
1583      */
1584 
1585     function _exists(uint256 tokenId) internal view returns (bool) {
1586 
1587         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1588 
1589             !_ownerships[tokenId].burned;
1590 
1591     }
1592 
1593 
1594 
1595     function _safeMint(address to, uint256 quantity) internal {
1596 
1597         _safeMint(to, quantity, '');
1598 
1599     }
1600 
1601 
1602 
1603     /**
1604 
1605      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1606 
1607      *
1608 
1609      * Requirements:
1610 
1611      *
1612 
1613      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1614 
1615      * - `quantity` must be greater than 0.
1616 
1617      *
1618 
1619      * Emits a {Transfer} event.
1620 
1621      */
1622 
1623     function _safeMint(
1624 
1625         address to,
1626 
1627         uint256 quantity,
1628 
1629         bytes memory _data
1630 
1631     ) internal {
1632 
1633         _mint(to, quantity, _data, true);
1634 
1635     }
1636 
1637 
1638 
1639     /**
1640 
1641      * @dev Mints `quantity` tokens and transfers them to `to`.
1642 
1643      *
1644 
1645      * Requirements:
1646 
1647      *
1648 
1649      * - `to` cannot be the zero address.
1650 
1651      * - `quantity` must be greater than 0.
1652 
1653      *
1654 
1655      * Emits a {Transfer} event.
1656 
1657      */
1658 
1659     function _mint(
1660 
1661         address to,
1662 
1663         uint256 quantity,
1664 
1665         bytes memory _data,
1666 
1667         bool safe
1668 
1669     ) internal {
1670 
1671         uint256 startTokenId = _currentIndex;
1672 
1673         if (to == address(0)) revert MintToZeroAddress();
1674 
1675         if (quantity == 0) revert MintZeroQuantity();
1676 
1677 
1678 
1679         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1680 
1681 
1682 
1683         // Overflows are incredibly unrealistic.
1684 
1685         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1686 
1687         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1688 
1689         unchecked {
1690 
1691             _addressData[to].balance += uint64(quantity);
1692 
1693             _addressData[to].numberMinted += uint64(quantity);
1694 
1695 
1696 
1697             _ownerships[startTokenId].addr = to;
1698 
1699             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1700 
1701 
1702 
1703             uint256 updatedIndex = startTokenId;
1704 
1705             uint256 end = updatedIndex + quantity;
1706 
1707 
1708 
1709             if (safe && to.isContract()) {
1710 
1711                 do {
1712 
1713                     emit Transfer(address(0), to, updatedIndex);
1714 
1715                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1716 
1717                         revert TransferToNonERC721ReceiverImplementer();
1718 
1719                     }
1720 
1721                 } while (updatedIndex != end);
1722 
1723                 // Reentrancy protection
1724 
1725                 if (_currentIndex != startTokenId) revert();
1726 
1727             } else {
1728 
1729                 do {
1730 
1731                     emit Transfer(address(0), to, updatedIndex++);
1732 
1733                 } while (updatedIndex != end);
1734 
1735             }
1736 
1737             _currentIndex = updatedIndex;
1738 
1739         }
1740 
1741         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1742 
1743     }
1744 
1745 
1746 
1747     /**
1748 
1749      * @dev Transfers `tokenId` from `from` to `to`.
1750 
1751      *
1752 
1753      * Requirements:
1754 
1755      *
1756 
1757      * - `to` cannot be the zero address.
1758 
1759      * - `tokenId` token must be owned by `from`.
1760 
1761      *
1762 
1763      * Emits a {Transfer} event.
1764 
1765      */
1766 
1767     function _transfer(
1768 
1769         address from,
1770 
1771         address to,
1772 
1773         uint256 tokenId
1774 
1775     ) private {
1776 
1777         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1778 
1779 
1780 
1781         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1782 
1783             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1784 
1785             getApproved(tokenId) == _msgSender());
1786 
1787 
1788 
1789         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1790 
1791         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1792 
1793         if (to == address(0)) revert TransferToZeroAddress();
1794 
1795 
1796 
1797         _beforeTokenTransfers(from, to, tokenId, 1);
1798 
1799 
1800 
1801         // Clear approvals from the previous owner
1802 
1803         _approve(address(0), tokenId, prevOwnership.addr);
1804 
1805 
1806 
1807         // Underflow of the sender's balance is impossible because we check for
1808 
1809         // ownership above and the recipient's balance can't realistically overflow.
1810 
1811         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1812 
1813         unchecked {
1814 
1815             _addressData[from].balance -= 1;
1816 
1817             _addressData[to].balance += 1;
1818 
1819 
1820 
1821             _ownerships[tokenId].addr = to;
1822 
1823             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1824 
1825 
1826 
1827             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1828 
1829             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1830 
1831             uint256 nextTokenId = tokenId + 1;
1832 
1833             if (_ownerships[nextTokenId].addr == address(0)) {
1834 
1835                 // This will suffice for checking _exists(nextTokenId),
1836 
1837                 // as a burned slot cannot contain the zero address.
1838 
1839                 if (nextTokenId < _currentIndex) {
1840 
1841                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1842 
1843                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
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
1863      * @dev Destroys `tokenId`.
1864 
1865      * The approval is cleared when the token is burned.
1866 
1867      *
1868 
1869      * Requirements:
1870 
1871      *
1872 
1873      * - `tokenId` must exist.
1874 
1875      *
1876 
1877      * Emits a {Transfer} event.
1878 
1879      */
1880 
1881     function _burn(uint256 tokenId) internal virtual {
1882 
1883         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1884 
1885 
1886 
1887         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1888 
1889 
1890 
1891         // Clear approvals from the previous owner
1892 
1893         _approve(address(0), tokenId, prevOwnership.addr);
1894 
1895 
1896 
1897         // Underflow of the sender's balance is impossible because we check for
1898 
1899         // ownership above and the recipient's balance can't realistically overflow.
1900 
1901         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1902 
1903         unchecked {
1904 
1905             _addressData[prevOwnership.addr].balance -= 1;
1906 
1907             _addressData[prevOwnership.addr].numberBurned += 1;
1908 
1909 
1910 
1911             // Keep track of who burned the token, and the timestamp of burning.
1912 
1913             _ownerships[tokenId].addr = prevOwnership.addr;
1914 
1915             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1916 
1917             _ownerships[tokenId].burned = true;
1918 
1919 
1920 
1921             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1922 
1923             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1924 
1925             uint256 nextTokenId = tokenId + 1;
1926 
1927             if (_ownerships[nextTokenId].addr == address(0)) {
1928 
1929                 // This will suffice for checking _exists(nextTokenId),
1930 
1931                 // as a burned slot cannot contain the zero address.
1932 
1933                 if (nextTokenId < _currentIndex) {
1934 
1935                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1936 
1937                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1938 
1939                 }
1940 
1941             }
1942 
1943         }
1944 
1945 
1946 
1947         emit Transfer(prevOwnership.addr, address(0), tokenId);
1948 
1949         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1950 
1951 
1952 
1953         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1954 
1955         unchecked {
1956 
1957             _burnCounter++;
1958 
1959         }
1960 
1961     }
1962 
1963 
1964 
1965     /**
1966 
1967      * @dev Approve `to` to operate on `tokenId`
1968 
1969      *
1970 
1971      * Emits a {Approval} event.
1972 
1973      */
1974 
1975     function _approve(
1976 
1977         address to,
1978 
1979         uint256 tokenId,
1980 
1981         address owner
1982 
1983     ) private {
1984 
1985         _tokenApprovals[tokenId] = to;
1986 
1987         emit Approval(owner, to, tokenId);
1988 
1989     }
1990 
1991 
1992 
1993     /**
1994 
1995      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1996 
1997      *
1998 
1999      * @param from address representing the previous owner of the given token ID
2000 
2001      * @param to target address that will receive the tokens
2002 
2003      * @param tokenId uint256 ID of the token to be transferred
2004 
2005      * @param _data bytes optional data to send along with the call
2006 
2007      * @return bool whether the call correctly returned the expected magic value
2008 
2009      */
2010 
2011     function _checkContractOnERC721Received(
2012 
2013         address from,
2014 
2015         address to,
2016 
2017         uint256 tokenId,
2018 
2019         bytes memory _data
2020 
2021     ) private returns (bool) {
2022 
2023         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2024 
2025             return retval == IERC721Receiver(to).onERC721Received.selector;
2026 
2027         } catch (bytes memory reason) {
2028 
2029             if (reason.length == 0) {
2030 
2031                 revert TransferToNonERC721ReceiverImplementer();
2032 
2033             } else {
2034 
2035                 assembly {
2036 
2037                     revert(add(32, reason), mload(reason))
2038 
2039                 }
2040 
2041             }
2042 
2043         }
2044 
2045     }
2046 
2047 
2048 
2049     /**
2050 
2051      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2052 
2053      * And also called before burning one token.
2054 
2055      *
2056 
2057      * startTokenId - the first token id to be transferred
2058 
2059      * quantity - the amount to be transferred
2060 
2061      *
2062 
2063      * Calling conditions:
2064 
2065      *
2066 
2067      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2068 
2069      * transferred to `to`.
2070 
2071      * - When `from` is zero, `tokenId` will be minted for `to`.
2072 
2073      * - When `to` is zero, `tokenId` will be burned by `from`.
2074 
2075      * - `from` and `to` are never both zero.
2076 
2077      */
2078 
2079     function _beforeTokenTransfers(
2080 
2081         address from,
2082 
2083         address to,
2084 
2085         uint256 startTokenId,
2086 
2087         uint256 quantity
2088 
2089     ) internal virtual {}
2090 
2091 
2092 
2093     /**
2094 
2095      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2096 
2097      * minting.
2098 
2099      * And also called after one token has been burned.
2100 
2101      *
2102 
2103      * startTokenId - the first token id to be transferred
2104 
2105      * quantity - the amount to be transferred
2106 
2107      *
2108 
2109      * Calling conditions:
2110 
2111      *
2112 
2113      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2114 
2115      * transferred to `to`.
2116 
2117      * - When `from` is zero, `tokenId` has been minted for `to`.
2118 
2119      * - When `to` is zero, `tokenId` has been burned by `from`.
2120 
2121      * - `from` and `to` are never both zero.
2122 
2123      */
2124 
2125     function _afterTokenTransfers(
2126 
2127         address from,
2128 
2129         address to,
2130 
2131         uint256 startTokenId,
2132 
2133         uint256 quantity
2134 
2135     ) internal virtual {}
2136 
2137 }
2138 // File: contracts/EtherRoyale.sol
2139 
2140 /*
2141 
2142 ERC-721A Smart contract
2143 
2144 @DonFlamingo - https://linktr.ee/donflamingo
2145 
2146 */
2147 
2148 
2149 
2150 
2151 pragma solidity ^0.8.7;
2152 
2153 
2154 
2155 
2156 
2157 
2158 
2159 
2160 
2161 contract EtherRoyale is ERC721A, Ownable, ReentrancyGuard {
2162 
2163     using Strings for uint256;
2164 
2165 
2166 
2167     string private baseURI;
2168 
2169     string private hideBaseURI;
2170 
2171 
2172 
2173     bool public paused = false;
2174 
2175     uint256 public maxSupply = 8888;
2176 
2177     uint256 public price = 0.069 ether;
2178 
2179     
2180 
2181     mapping (address => uint256) public saleMintCount;
2182 
2183     uint256 public saleWalletLimit = 10;
2184 
2185     bool public saleStarted = false;
2186 
2187 
2188 
2189     mapping (address => uint256) public presaleMintCount;
2190 
2191     uint256 public presaleWalletLimit = 3;
2192 
2193     bool public presaleStarted = false;
2194 
2195     bytes32 public presaleMerkleRoot = 0x23d67d503c7c3b7c6d70abc12fc1ef10b7eb7dff0eeddb16c65e441cb3d5e214;
2196 
2197 
2198 
2199     bool public revealed = false;
2200 
2201 
2202 
2203     event saleModeChanged();
2204 
2205 
2206 
2207     constructor(
2208 
2209         string memory _hideBaseURI,
2210 
2211         string memory _tokenUrl) ERC721A ("Ether Royale", "ER"){
2212 
2213         baseURI = _tokenUrl;
2214 
2215         hideBaseURI = _hideBaseURI;
2216 
2217     }
2218 
2219 
2220 
2221     modifier notPaused() {
2222 
2223         require(!paused, "Contract is paused");
2224 
2225         _;
2226 
2227     }
2228 
2229     
2230 
2231     modifier correctPayment(uint8 quantity) {
2232 
2233         require(quantity * price == msg.value);
2234 
2235         _;
2236 
2237     }
2238 
2239 
2240 
2241     modifier supplyLimit(uint8 quantity) {
2242 
2243         require(totalSupply() + quantity <= maxSupply, "No more tokens");
2244 
2245         _;
2246 
2247     }
2248 
2249 
2250 
2251     modifier presale(uint8 quantity) {
2252 
2253         require(presaleStarted, "Presale must be started");
2254 
2255         require(presaleMintCount[msg.sender] + quantity <= presaleWalletLimit, "Wallet limit reached");
2256 
2257         _;
2258 
2259     }
2260 
2261 
2262 
2263     modifier sale(uint8 quantity) {
2264 
2265         require(saleStarted, "Sale must be started");
2266 
2267         require(saleMintCount[msg.sender] + quantity <= saleWalletLimit, "wallet limit reached");
2268 
2269         _;
2270 
2271     }
2272 
2273 
2274 
2275     modifier isValidMerkleProof(bytes32[] calldata merkleProof) {
2276 
2277         require(
2278 
2279             MerkleProof.verify(
2280 
2281                 merkleProof,
2282 
2283                 presaleMerkleRoot,
2284 
2285                 keccak256(abi.encodePacked(msg.sender))
2286 
2287             ),
2288 
2289             "Address does not exist in list"
2290 
2291         );
2292 
2293         _;
2294 
2295     }
2296 
2297 
2298 
2299     function saleMint(uint8 quantity) external payable notPaused nonReentrant supplyLimit(quantity) sale(quantity) {
2300 
2301         saleMintCount[msg.sender] += quantity;
2302 
2303         _safeMint(msg.sender, quantity);
2304 
2305     }
2306 
2307 
2308 
2309     function presaleMint(uint8 quantity, bytes32[] calldata merkleProof) external payable notPaused nonReentrant supplyLimit(quantity) isValidMerkleProof(merkleProof) presale(quantity)  {
2310 
2311         presaleMintCount[msg.sender] += quantity;
2312 
2313         _safeMint(msg.sender, quantity);
2314 
2315     }
2316 
2317 
2318 
2319     function ownerMint(uint8 quantity, address toAddress) external supplyLimit(quantity) onlyOwner {
2320 
2321         _safeMint(toAddress, quantity);
2322 
2323     } 
2324 
2325 
2326 
2327     function startPresale() external onlyOwner {
2328 
2329         presaleStarted = true;
2330 
2331         saleStarted = false;
2332 
2333 
2334 
2335         emit saleModeChanged();
2336 
2337     }
2338 
2339 
2340 
2341     function startSale() external onlyOwner {
2342 
2343         presaleStarted = false;
2344 
2345         saleStarted = true;
2346 
2347 
2348 
2349         emit saleModeChanged();
2350 
2351     }
2352 
2353 
2354 
2355     function resetSale() external onlyOwner {
2356 
2357         presaleStarted = false;
2358 
2359         saleStarted = false;
2360 
2361 
2362 
2363         emit saleModeChanged();
2364 
2365     }
2366 
2367 
2368 
2369     function setPause(bool pause) external onlyOwner {
2370 
2371         paused = pause;
2372 
2373     }
2374 
2375 
2376 
2377     function updatePrice(uint256 _price) external onlyOwner {
2378 
2379         price = _price;
2380 
2381     }
2382 
2383 
2384 
2385     function setPresaleLimit(uint8 _presaleLimit) external onlyOwner {
2386 
2387         presaleWalletLimit = _presaleLimit;
2388 
2389     }
2390 
2391 
2392 
2393     function setSaleLimit(uint8 _saleLimit) external onlyOwner {
2394 
2395         saleWalletLimit = _saleLimit;
2396 
2397     }
2398 
2399 
2400 
2401     function setPresaleListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2402 
2403         presaleMerkleRoot = merkleRoot;
2404 
2405     }
2406 
2407 
2408 
2409     function setBaseURI(string memory _baseURI) external onlyOwner {
2410 
2411         baseURI = _baseURI;
2412 
2413     }
2414 
2415 
2416 
2417     function setHideBaseURI(string memory _hideBaseURI) external onlyOwner {
2418 
2419         hideBaseURI = _hideBaseURI;
2420 
2421     }
2422 
2423 
2424 
2425     function getOwnerBaseURI() external onlyOwner view returns (string memory) {
2426 
2427         return baseURI;
2428 
2429     }
2430 
2431 
2432 
2433     function withdraw() public onlyOwner {
2434 
2435         uint256 donflamingov = address(this).balance * 15 / 100;
2436 
2437         uint256 catnipv = address(this).balance * 15 / 100;
2438 
2439         uint256 tragv = address(this).balance * 31 / 100;
2440 
2441 
2442 
2443         (bool donflamingohs, ) = payable(0xdCd6B7449167220724084bfD61f9B205c7dfa5a1).call{value: donflamingov}("");
2444 
2445         require(donflamingohs);
2446 
2447 
2448 
2449         (bool catniphs, ) = payable(0x026bf664D2C84E4Da15B18d66e41Ab8180f2bda3).call{value: catnipv}("");
2450 
2451         require(catniphs);
2452 
2453 
2454 
2455         (bool trags, ) = payable(0xE1840cc1BC1C80c576fAeD0DE39fC2c92E6440Ca).call{value: tragv}("");
2456 
2457         require(trags);
2458 
2459 
2460 
2461         uint256 balance = address(this).balance;
2462 
2463         payable(0xbF95B5444C3F8d671183ec87984d04b32C842d89).transfer(balance);
2464 
2465     }
2466 
2467 
2468 
2469     function reveal(bool _revealed) public onlyOwner  {
2470 
2471         revealed = _revealed;
2472 
2473     }
2474 
2475 
2476 
2477     function _startTokenId() internal view override virtual returns (uint256) {
2478 
2479         return 1;
2480 
2481     }
2482 
2483 
2484 
2485     function getBaseURI() external view returns (string memory) {
2486 
2487         if (!revealed) {
2488 
2489             return hideBaseURI;
2490 
2491         }
2492 
2493 
2494 
2495         return baseURI;
2496 
2497     }
2498 
2499 
2500 
2501     function leftLimit() external view returns (uint256) {
2502 
2503         require(presaleStarted || saleStarted, "Sales wasn't started yet");
2504 
2505 
2506 
2507         if (presaleStarted) {
2508 
2509             return presaleWalletLimit - presaleMintCount[msg.sender];
2510 
2511         }
2512 
2513         if (saleStarted) {
2514 
2515             return saleWalletLimit - saleMintCount[msg.sender];
2516 
2517         }
2518 
2519 
2520 
2521         return 0;
2522 
2523     }
2524 
2525 
2526 
2527     function walletOfOwner(address _owner)
2528 
2529         public
2530 
2531         view
2532 
2533         returns (uint256[] memory)
2534 
2535     {
2536 
2537         uint256 ownerTokenCount = balanceOf(_owner);
2538 
2539         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2540 
2541         uint256 currentTokenId = 1;
2542 
2543         uint256 ownedTokenIndex = 0;
2544 
2545 
2546 
2547         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2548 
2549             address currentTokenOwner = ownerOf(currentTokenId);
2550 
2551 
2552 
2553             if (currentTokenOwner == _owner) {
2554 
2555                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
2556 
2557                 ownedTokenIndex++;
2558 
2559             }
2560 
2561 
2562 
2563             currentTokenId++;
2564 
2565         }
2566 
2567 
2568 
2569         return ownedTokenIds;
2570 
2571     }
2572 
2573 
2574 
2575     function tokenURI(uint256 tokenId)
2576 
2577         public
2578 
2579         view
2580 
2581         virtual
2582 
2583         override
2584 
2585         returns (string memory)
2586 
2587     {
2588 
2589         require(_exists(tokenId), "Nonexistent token");
2590 
2591 
2592 
2593         if (!revealed) {
2594 
2595             return hideBaseURI;
2596 
2597         }
2598 
2599 
2600 
2601         return
2602 
2603             string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json"));
2604 
2605     }
2606 
2607 }