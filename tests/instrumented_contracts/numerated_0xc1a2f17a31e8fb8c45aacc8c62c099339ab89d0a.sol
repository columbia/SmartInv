1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.13;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         assembly {
37             size := extcodesize(account)
38         }
39         return size > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         (bool success, ) = recipient.call{value: amount}("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain `call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but also transferring `value` wei to `target`.
104      *
105      * Requirements:
106      *
107      * - the calling contract must have an ETH balance of at least `value`.
108      * - the called Solidity function must be `payable`.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
122      * with `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         require(isContract(target), "Address: call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.call{value: value}(data);
136         return verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(isContract(target), "Address: delegate call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     /**
194      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
195      * revert reason using the provided one.
196      *
197      * _Available since v4.3._
198      */
199     function verifyCallResult(
200         bool success,
201         bytes memory returndata,
202         string memory errorMessage
203     ) internal pure returns (bytes memory) {
204         if (success) {
205             return returndata;
206         } else {
207             // Look for revert reason and bubble it up if present
208             if (returndata.length > 0) {
209                 // The easiest way to bubble the revert reason is using memory via assembly
210 
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/Context
223 
224 /**
225  * @dev Provides information about the current execution context, including the
226  * sender of the transaction and its data. While these are generally available
227  * via msg.sender and msg.data, they should not be accessed in such a direct
228  * manner, since when dealing with meta-transactions the account sending and
229  * paying for execution may not be the actual sender (as far as an application
230  * is concerned).
231  *
232  * This contract is only required for intermediate, library-like contracts.
233  */
234 abstract contract Context {
235     function _msgSender() internal view virtual returns (address) {
236         return msg.sender;
237     }
238 
239     function _msgData() internal view virtual returns (bytes calldata) {
240         return msg.data;
241     }
242 }
243 
244 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/IERC165
245 
246 /**
247  * @dev Interface of the ERC165 standard, as defined in the
248  * https://eips.ethereum.org/EIPS/eip-165[EIP].
249  *
250  * Implementers can declare support of contract interfaces, which can then be
251  * queried by others ({ERC165Checker}).
252  *
253  * For an implementation, see {ERC165}.
254  */
255 interface IERC165 {
256     /**
257      * @dev Returns true if this contract implements the interface defined by
258      * `interfaceId`. See the corresponding
259      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
260      * to learn more about how these ids are created.
261      *
262      * This function call must use less than 30 000 gas.
263      */
264     function supportsInterface(bytes4 interfaceId) external view returns (bool);
265 }
266 
267 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/IERC721Receiver
268 
269 /**
270  * @title ERC721 token receiver interface
271  * @dev Interface for any contract that wants to support safeTransfers
272  * from ERC721 asset contracts.
273  */
274 interface IERC721Receiver {
275     /**
276      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
277      * by `operator` from `from`, this function is called.
278      *
279      * It must return its Solidity selector to confirm the token transfer.
280      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
281      *
282      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
283      */
284     function onERC721Received(
285         address operator,
286         address from,
287         uint256 tokenId,
288         bytes calldata data
289     ) external returns (bytes4);
290 }
291 
292 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/MerkleProof
293 
294 /**
295  * @dev These functions deal with verification of Merkle Trees proofs.
296  *
297  * The proofs can be generated using the JavaScript library
298  * https://github.com/miguelmota/merkletreejs[merkletreejs].
299  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
300  *
301  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
302  */
303 library MerkleProof {
304     /**
305      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
306      * defined by `root`. For this, a `proof` must be provided, containing
307      * sibling hashes on the branch from the leaf to the root of the tree. Each
308      * pair of leaves and each pair of pre-images are assumed to be sorted.
309      */
310     function verify(
311         bytes32[] memory proof,
312         bytes32 root,
313         bytes32 leaf
314     ) internal pure returns (bool) {
315         return processProof(proof, leaf) == root;
316     }
317 
318     /**
319      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
320      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
321      * hash matches the root of the tree. When processing the proof, the pairs
322      * of leafs & pre-images are assumed to be sorted.
323      *
324      * _Available since v4.4._
325      */
326     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
327         bytes32 computedHash = leaf;
328         for (uint256 i = 0; i < proof.length; i++) {
329             bytes32 proofElement = proof[i];
330             if (computedHash <= proofElement) {
331                 // Hash(current computed hash + current element of the proof)
332                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
333             } else {
334                 // Hash(current element of the proof + current computed hash)
335                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
336             }
337         }
338         return computedHash;
339     }
340 }
341 
342 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/ReentrancyGuard
343 
344 /**
345  * @dev Contract module that helps prevent reentrant calls to a function.
346  *
347  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
348  * available, which can be applied to functions to make sure there are no nested
349  * (reentrant) calls to them.
350  *
351  * Note that because there is a single `nonReentrant` guard, functions marked as
352  * `nonReentrant` may not call one another. This can be worked around by making
353  * those functions `private`, and then adding `external` `nonReentrant` entry
354  * points to them.
355  *
356  * TIP: If you would like to learn more about reentrancy and alternative ways
357  * to protect against it, check out our blog post
358  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
359  */
360 abstract contract ReentrancyGuard {
361     // Booleans are more expensive than uint256 or any type that takes up a full
362     // word because each write operation emits an extra SLOAD to first read the
363     // slot's contents, replace the bits taken up by the boolean, and then write
364     // back. This is the compiler's defense against contract upgrades and
365     // pointer aliasing, and it cannot be disabled.
366 
367     // The values being non-zero value makes deployment a bit more expensive,
368     // but in exchange the refund on every call to nonReentrant will be lower in
369     // amount. Since refunds are capped to a percentage of the total
370     // transaction's gas, it is best to keep them low in cases like this one, to
371     // increase the likelihood of the full refund coming into effect.
372     uint256 private constant _NOT_ENTERED = 1;
373     uint256 private constant _ENTERED = 2;
374 
375     uint256 private _status;
376 
377     constructor() {
378         _status = _NOT_ENTERED;
379     }
380 
381     /**
382      * @dev Prevents a contract from calling itself, directly or indirectly.
383      * Calling a `nonReentrant` function from another `nonReentrant`
384      * function is not supported. It is possible to prevent this from happening
385      * by making the `nonReentrant` function external, and making it call a
386      * `private` function that does the actual work.
387      */
388     modifier nonReentrant() {
389         // On the first call to nonReentrant, _notEntered will be true
390         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
391 
392         // Any calls to nonReentrant after this point will fail
393         _status = _ENTERED;
394 
395         _;
396 
397         // By storing the original value once again, a refund is triggered (see
398         // https://eips.ethereum.org/EIPS/eip-2200)
399         _status = _NOT_ENTERED;
400     }
401 }
402 
403 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/Strings
404 
405 /**
406  * @dev String operations.
407  */
408 library Strings {
409     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
410 
411     /**
412      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
413      */
414     function toString(uint256 value) internal pure returns (string memory) {
415         // Inspired by OraclizeAPI's implementation - MIT licence
416         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
417 
418         if (value == 0) {
419             return "0";
420         }
421         uint256 temp = value;
422         uint256 digits;
423         while (temp != 0) {
424             digits++;
425             temp /= 10;
426         }
427         bytes memory buffer = new bytes(digits);
428         while (value != 0) {
429             digits -= 1;
430             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
431             value /= 10;
432         }
433         return string(buffer);
434     }
435 
436     /**
437      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
438      */
439     function toHexString(uint256 value) internal pure returns (string memory) {
440         if (value == 0) {
441             return "0x00";
442         }
443         uint256 temp = value;
444         uint256 length = 0;
445         while (temp != 0) {
446             length++;
447             temp >>= 8;
448         }
449         return toHexString(value, length);
450     }
451 
452     /**
453      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
454      */
455     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
456         bytes memory buffer = new bytes(2 * length + 2);
457         buffer[0] = "0";
458         buffer[1] = "x";
459         for (uint256 i = 2 * length + 1; i > 1; --i) {
460             buffer[i] = _HEX_SYMBOLS[value & 0xf];
461             value >>= 4;
462         }
463         require(value == 0, "Strings: hex length insufficient");
464         return string(buffer);
465     }
466 }
467 
468 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/ERC165
469 
470 /**
471  * @dev Implementation of the {IERC165} interface.
472  *
473  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
474  * for the additional interface id that will be supported. For example:
475  *
476  * ```solidity
477  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
478  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
479  * }
480  * ```
481  *
482  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
483  */
484 abstract contract ERC165 is IERC165 {
485     /**
486      * @dev See {IERC165-supportsInterface}.
487      */
488     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489         return interfaceId == type(IERC165).interfaceId;
490     }
491 }
492 
493 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/IERC721
494 
495 /**
496  * @dev Required interface of an ERC721 compliant contract.
497  */
498 interface IERC721 is IERC165 {
499     /**
500      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
501      */
502     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
503 
504     /**
505      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
506      */
507     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
508 
509     /**
510      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
511      */
512     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
513 
514     /**
515      * @dev Returns the number of tokens in ``owner``'s account.
516      */
517     function balanceOf(address owner) external view returns (uint256 balance);
518 
519     /**
520      * @dev Returns the owner of the `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function ownerOf(uint256 tokenId) external view returns (address owner);
527 
528     /**
529      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
530      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
531      *
532      * Requirements:
533      *
534      * - `from` cannot be the zero address.
535      * - `to` cannot be the zero address.
536      * - `tokenId` token must exist and be owned by `from`.
537      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
538      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
539      *
540      * Emits a {Transfer} event.
541      */
542     function safeTransferFrom(
543         address from,
544         address to,
545         uint256 tokenId
546     ) external;
547 
548     /**
549      * @dev Transfers `tokenId` token from `from` to `to`.
550      *
551      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
552      *
553      * Requirements:
554      *
555      * - `from` cannot be the zero address.
556      * - `to` cannot be the zero address.
557      * - `tokenId` token must be owned by `from`.
558      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
559      *
560      * Emits a {Transfer} event.
561      */
562     function transferFrom(
563         address from,
564         address to,
565         uint256 tokenId
566     ) external;
567 
568     /**
569      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
570      * The approval is cleared when the token is transferred.
571      *
572      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
573      *
574      * Requirements:
575      *
576      * - The caller must own the token or be an approved operator.
577      * - `tokenId` must exist.
578      *
579      * Emits an {Approval} event.
580      */
581     function approve(address to, uint256 tokenId) external;
582 
583     /**
584      * @dev Returns the account approved for `tokenId` token.
585      *
586      * Requirements:
587      *
588      * - `tokenId` must exist.
589      */
590     function getApproved(uint256 tokenId) external view returns (address operator);
591 
592     /**
593      * @dev Approve or remove `operator` as an operator for the caller.
594      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
595      *
596      * Requirements:
597      *
598      * - The `operator` cannot be the caller.
599      *
600      * Emits an {ApprovalForAll} event.
601      */
602     function setApprovalForAll(address operator, bool _approved) external;
603 
604     /**
605      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
606      *
607      * See {setApprovalForAll}
608      */
609     function isApprovedForAll(address owner, address operator) external view returns (bool);
610 
611     /**
612      * @dev Safely transfers `tokenId` token from `from` to `to`.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must exist and be owned by `from`.
619      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
620      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
621      *
622      * Emits a {Transfer} event.
623      */
624     function safeTransferFrom(
625         address from,
626         address to,
627         uint256 tokenId,
628         bytes calldata data
629     ) external;
630 }
631 
632 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/Ownable
633 
634 /**
635  * @dev Contract module which provides a basic access control mechanism, where
636  * there is an account (an owner) that can be granted exclusive access to
637  * specific functions.
638  *
639  * By default, the owner account will be the one that deploys the contract. This
640  * can later be changed with {transferOwnership}.
641  *
642  * This module is used through inheritance. It will make available the modifier
643  * `onlyOwner`, which can be applied to your functions to restrict their use to
644  * the owner.
645  */
646 abstract contract Ownable is Context {
647     address private _owner;
648 
649     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
650 
651     /**
652      * @dev Initializes the contract setting the deployer as the initial owner.
653      */
654     constructor() {
655         _transferOwnership(_msgSender());
656     }
657 
658     /**
659      * @dev Returns the address of the current owner.
660      */
661     function owner() public view virtual returns (address) {
662         return _owner;
663     }
664 
665     /**
666      * @dev Throws if called by any account other than the owner.
667      */
668     modifier onlyOwner() {
669         require(owner() == _msgSender(), "Ownable: caller is not the owner");
670         _;
671     }
672 
673     /**
674      * @dev Leaves the contract without owner. It will not be possible to call
675      * `onlyOwner` functions anymore. Can only be called by the current owner.
676      *
677      * NOTE: Renouncing ownership will leave the contract without an owner,
678      * thereby removing any functionality that is only available to the owner.
679      */
680     function renounceOwnership() public virtual onlyOwner {
681         _transferOwnership(address(0));
682     }
683 
684     /**
685      * @dev Transfers ownership of the contract to a new account (`newOwner`).
686      * Can only be called by the current owner.
687      */
688     function transferOwnership(address newOwner) public virtual onlyOwner {
689         require(newOwner != address(0), "Ownable: new owner is the zero address");
690         _transferOwnership(newOwner);
691     }
692 
693     /**
694      * @dev Transfers ownership of the contract to a new account (`newOwner`).
695      * Internal function without access restriction.
696      */
697     function _transferOwnership(address newOwner) internal virtual {
698         address oldOwner = _owner;
699         _owner = newOwner;
700         emit OwnershipTransferred(oldOwner, newOwner);
701     }
702 }
703 
704 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/IERC721Enumerable
705 
706 /**
707  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
708  * @dev See https://eips.ethereum.org/EIPS/eip-721
709  */
710 interface IERC721Enumerable is IERC721 {
711     /**
712      * @dev Returns the total amount of tokens stored by the contract.
713      */
714     function totalSupply() external view returns (uint256);
715 
716     /**
717      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
718      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
719      */
720     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
721 
722     /**
723      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
724      * Use along with {totalSupply} to enumerate all tokens.
725      */
726     function tokenByIndex(uint256 index) external view returns (uint256);
727 }
728 
729 // Part: OpenZeppelin/openzeppelin-contracts@4.4.0/IERC721Metadata
730 
731 /**
732  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
733  * @dev See https://eips.ethereum.org/EIPS/eip-721
734  */
735 interface IERC721Metadata is IERC721 {
736     /**
737      * @dev Returns the token collection name.
738      */
739     function name() external view returns (string memory);
740 
741     /**
742      * @dev Returns the token collection symbol.
743      */
744     function symbol() external view returns (string memory);
745 
746     /**
747      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
748      */
749     function tokenURI(uint256 tokenId) external view returns (string memory);
750 }
751 
752 // Part: ERC721A
753 
754 /**
755  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
756  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
757  *
758  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
759  *
760  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
761  *
762  * Does not support burning tokens to address(0).
763  */
764 contract ERC721A is
765     Context,
766     ERC165,
767     IERC721,
768     IERC721Metadata,
769     IERC721Enumerable
770 {
771     using Address for address;
772     using Strings for uint256;
773 
774     struct TokenOwnership {
775         address addr;
776         uint64 startTimestamp;
777     }
778 
779     struct AddressData {
780         uint128 balance;
781         uint128 numberMinted;
782     }
783 
784     uint256 private currentIndex = 0;
785 
786     uint256 internal immutable collectionSize;
787     uint256 internal immutable maxBatchSize;
788 
789     // Token name
790     string private _name;
791 
792     // Token symbol
793     string private _symbol;
794 
795     // Mapping from token ID to ownership details
796     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
797     mapping(uint256 => TokenOwnership) private _ownerships;
798 
799     // Mapping owner address to address data
800     mapping(address => AddressData) private _addressData;
801 
802     // Mapping from token ID to approved address
803     mapping(uint256 => address) private _tokenApprovals;
804 
805     // Mapping from owner to operator approvals
806     mapping(address => mapping(address => bool)) private _operatorApprovals;
807 
808     /**
809      * @dev
810      * `maxBatchSize` refers to how much a minter can mint at a time.
811      * `collectionSize_` refers to how many tokens are in the collection.
812      */
813     constructor(
814         string memory name_,
815         string memory symbol_,
816         uint256 maxBatchSize_,
817         uint256 collectionSize_
818     ) {
819         require(
820             collectionSize_ > 0,
821             "ERC721A: collection must have a nonzero supply"
822         );
823         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
824         _name = name_;
825         _symbol = symbol_;
826         maxBatchSize = maxBatchSize_;
827         collectionSize = collectionSize_;
828     }
829 
830     /**
831      * @dev See {IERC721Enumerable-totalSupply}.
832      */
833     function totalSupply() public view override returns (uint256) {
834         return currentIndex;
835     }
836 
837     /**
838      * @dev See {IERC721Enumerable-tokenByIndex}.
839      */
840     function tokenByIndex(uint256 index)
841         public
842         view
843         override
844         returns (uint256)
845     {
846         require(index < totalSupply(), "ERC721A: global index out of bounds");
847         return index;
848     }
849 
850     /**
851      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
852      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
853      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
854      */
855     function tokenOfOwnerByIndex(address owner, uint256 index)
856         public
857         view
858         override
859         returns (uint256)
860     {
861         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
862         uint256 numMintedSoFar = totalSupply();
863         uint256 tokenIdsIdx = 0;
864         address currOwnershipAddr = address(0);
865         for (uint256 i = 0; i < numMintedSoFar; i++) {
866             TokenOwnership memory ownership = _ownerships[i];
867             if (ownership.addr != address(0)) {
868                 currOwnershipAddr = ownership.addr;
869             }
870             if (currOwnershipAddr == owner) {
871                 if (tokenIdsIdx == index) {
872                     return i;
873                 }
874                 tokenIdsIdx++;
875             }
876         }
877         revert("ERC721A: unable to get token of owner by index");
878     }
879 
880     /**
881      * @dev See {IERC165-supportsInterface}.
882      */
883     function supportsInterface(bytes4 interfaceId)
884         public
885         view
886         virtual
887         override(ERC165, IERC165)
888         returns (bool)
889     {
890         return
891             interfaceId == type(IERC721).interfaceId ||
892             interfaceId == type(IERC721Metadata).interfaceId ||
893             interfaceId == type(IERC721Enumerable).interfaceId ||
894             super.supportsInterface(interfaceId);
895     }
896 
897     /**
898      * @dev See {IERC721-balanceOf}.
899      */
900     function balanceOf(address owner) public view override returns (uint256) {
901         require(
902             owner != address(0),
903             "ERC721A: balance query for the zero address"
904         );
905         return uint256(_addressData[owner].balance);
906     }
907 
908     function _numberMinted(address owner) internal view returns (uint256) {
909         require(
910             owner != address(0),
911             "ERC721A: number minted query for the zero address"
912         );
913         return uint256(_addressData[owner].numberMinted);
914     }
915 
916     function ownershipOf(uint256 tokenId)
917         internal
918         view
919         returns (TokenOwnership memory)
920     {
921         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
922 
923         uint256 lowestTokenToCheck;
924         if (tokenId >= maxBatchSize) {
925             lowestTokenToCheck = tokenId - maxBatchSize + 1;
926         }
927 
928         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
929             TokenOwnership memory ownership = _ownerships[curr];
930             if (ownership.addr != address(0)) {
931                 return ownership;
932             }
933         }
934 
935         revert("ERC721A: unable to determine the owner of token");
936     }
937 
938     /**
939      * @dev See {IERC721-ownerOf}.
940      */
941     function ownerOf(uint256 tokenId) public view override returns (address) {
942         return ownershipOf(tokenId).addr;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-name}.
947      */
948     function name() public view virtual override returns (string memory) {
949         return _name;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-symbol}.
954      */
955     function symbol() public view virtual override returns (string memory) {
956         return _symbol;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-tokenURI}.
961      */
962     function tokenURI(uint256 tokenId)
963         public
964         view
965         virtual
966         override
967         returns (string memory)
968     {
969         require(
970             _exists(tokenId),
971             "ERC721Metadata: URI query for nonexistent token"
972         );
973 
974         string memory baseURI = _baseURI();
975         return
976             bytes(baseURI).length > 0
977                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
978                 : "";
979     }
980 
981     /**
982      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
983      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
984      * by default, can be overriden in child contracts.
985      */
986     function _baseURI() internal view virtual returns (string memory) {
987         return "";
988     }
989 
990     /**
991      * @dev See {IERC721-approve}.
992      */
993     function approve(address to, uint256 tokenId) public override {
994         address owner = ERC721A.ownerOf(tokenId);
995         require(to != owner, "ERC721A: approval to current owner");
996 
997         require(
998             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
999             "ERC721A: approve caller is not owner nor approved for all"
1000         );
1001 
1002         _approve(to, tokenId, owner);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-getApproved}.
1007      */
1008     function getApproved(uint256 tokenId)
1009         public
1010         view
1011         override
1012         returns (address)
1013     {
1014         require(
1015             _exists(tokenId),
1016             "ERC721A: approved query for nonexistent token"
1017         );
1018 
1019         return _tokenApprovals[tokenId];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-setApprovalForAll}.
1024      */
1025     function setApprovalForAll(address operator, bool approved)
1026         public
1027         override
1028     {
1029         require(operator != _msgSender(), "ERC721A: approve to caller");
1030 
1031         _operatorApprovals[_msgSender()][operator] = approved;
1032         emit ApprovalForAll(_msgSender(), operator, approved);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-isApprovedForAll}.
1037      */
1038     function isApprovedForAll(address owner, address operator)
1039         public
1040         view
1041         virtual
1042         override
1043         returns (bool)
1044     {
1045         return _operatorApprovals[owner][operator];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-transferFrom}.
1050      */
1051     function transferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) public override {
1056         _transfer(from, to, tokenId);
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-safeTransferFrom}.
1061      */
1062     function safeTransferFrom(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) public override {
1067         safeTransferFrom(from, to, tokenId, "");
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-safeTransferFrom}.
1072      */
1073     function safeTransferFrom(
1074         address from,
1075         address to,
1076         uint256 tokenId,
1077         bytes memory _data
1078     ) public override {
1079         _transfer(from, to, tokenId);
1080         require(
1081             _checkOnERC721Received(from, to, tokenId, _data),
1082             "ERC721A: transfer to non ERC721Receiver implementer"
1083         );
1084     }
1085 
1086     /**
1087      * @dev Returns whether `tokenId` exists.
1088      *
1089      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1090      *
1091      * Tokens start existing when they are minted (`_mint`),
1092      */
1093     function _exists(uint256 tokenId) internal view returns (bool) {
1094         return tokenId < currentIndex;
1095     }
1096 
1097     function _safeMint(address to, uint256 quantity) internal {
1098         _safeMint(to, quantity, "");
1099     }
1100 
1101     /**
1102      * @dev Mints `quantity` tokens and transfers them to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - there must be `quantity` tokens remaining unminted in the total collection.
1107      * - `to` cannot be the zero address.
1108      * - `quantity` cannot be larger than the max batch size.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function _safeMint(
1113         address to,
1114         uint256 quantity,
1115         bytes memory _data
1116     ) internal {
1117         uint256 startTokenId = currentIndex;
1118         require(to != address(0), "ERC721A: mint to the zero address");
1119         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1120         require(!_exists(startTokenId), "ERC721A: token already minted");
1121         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1122 
1123         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1124 
1125         AddressData memory addressData = _addressData[to];
1126         _addressData[to] = AddressData(
1127             addressData.balance + uint128(quantity),
1128             addressData.numberMinted + uint128(quantity)
1129         );
1130         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1131 
1132         uint256 updatedIndex = startTokenId;
1133 
1134         for (uint256 i = 0; i < quantity; i++) {
1135             emit Transfer(address(0), to, updatedIndex);
1136             require(
1137                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1138                 "ERC721A: transfer to non ERC721Receiver implementer"
1139             );
1140             updatedIndex++;
1141         }
1142 
1143         currentIndex = updatedIndex;
1144         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1145     }
1146 
1147     /**
1148      * @dev Transfers `tokenId` from `from` to `to`.
1149      *
1150      * Requirements:
1151      *
1152      * - `to` cannot be the zero address.
1153      * - `tokenId` token must be owned by `from`.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function _transfer(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) private {
1162         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1163 
1164         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1165             getApproved(tokenId) == _msgSender() ||
1166             isApprovedForAll(prevOwnership.addr, _msgSender()));
1167 
1168         require(
1169             isApprovedOrOwner,
1170             "ERC721A: transfer caller is not owner nor approved"
1171         );
1172 
1173         require(
1174             prevOwnership.addr == from,
1175             "ERC721A: transfer from incorrect owner"
1176         );
1177         require(to != address(0), "ERC721A: transfer to the zero address");
1178 
1179         _beforeTokenTransfers(from, to, tokenId, 1);
1180 
1181         // Clear approvals from the previous owner
1182         _approve(address(0), tokenId, prevOwnership.addr);
1183 
1184         _addressData[from].balance -= 1;
1185         _addressData[to].balance += 1;
1186         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1187 
1188         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1189         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1190         uint256 nextTokenId = tokenId + 1;
1191         if (_ownerships[nextTokenId].addr == address(0)) {
1192             if (_exists(nextTokenId)) {
1193                 _ownerships[nextTokenId] = TokenOwnership(
1194                     prevOwnership.addr,
1195                     prevOwnership.startTimestamp
1196                 );
1197             }
1198         }
1199 
1200         emit Transfer(from, to, tokenId);
1201         _afterTokenTransfers(from, to, tokenId, 1);
1202     }
1203 
1204     /**
1205      * @dev Approve `to` to operate on `tokenId`
1206      *
1207      * Emits a {Approval} event.
1208      */
1209     function _approve(
1210         address to,
1211         uint256 tokenId,
1212         address owner
1213     ) private {
1214         _tokenApprovals[tokenId] = to;
1215         emit Approval(owner, to, tokenId);
1216     }
1217 
1218     uint256 public nextOwnerToExplicitlySet = 0;
1219 
1220     /**
1221      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1222      */
1223     function _setOwnersExplicit(uint256 quantity) internal {
1224         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1225         require(quantity > 0, "quantity must be nonzero");
1226         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1227         if (endIndex > collectionSize - 1) {
1228             endIndex = collectionSize - 1;
1229         }
1230         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1231         require(_exists(endIndex), "not enough minted yet for this cleanup");
1232         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1233             if (_ownerships[i].addr == address(0)) {
1234                 TokenOwnership memory ownership = ownershipOf(i);
1235                 _ownerships[i] = TokenOwnership(
1236                     ownership.addr,
1237                     ownership.startTimestamp
1238                 );
1239             }
1240         }
1241         nextOwnerToExplicitlySet = endIndex + 1;
1242     }
1243 
1244     /**
1245      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1246      * The call is not executed if the target address is not a contract.
1247      *
1248      * @param from address representing the previous owner of the given token ID
1249      * @param to target address that will receive the tokens
1250      * @param tokenId uint256 ID of the token to be transferred
1251      * @param _data bytes optional data to send along with the call
1252      * @return bool whether the call correctly returned the expected magic value
1253      */
1254     function _checkOnERC721Received(
1255         address from,
1256         address to,
1257         uint256 tokenId,
1258         bytes memory _data
1259     ) private returns (bool) {
1260         if (to.isContract()) {
1261             try
1262                 IERC721Receiver(to).onERC721Received(
1263                     _msgSender(),
1264                     from,
1265                     tokenId,
1266                     _data
1267                 )
1268             returns (bytes4 retval) {
1269                 return retval == IERC721Receiver(to).onERC721Received.selector;
1270             } catch (bytes memory reason) {
1271                 if (reason.length == 0) {
1272                     revert(
1273                         "ERC721A: transfer to non ERC721Receiver implementer"
1274                     );
1275                 } else {
1276                     assembly {
1277                         revert(add(32, reason), mload(reason))
1278                     }
1279                 }
1280             }
1281         } else {
1282             return true;
1283         }
1284     }
1285 
1286     /**
1287      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1288      *
1289      * startTokenId - the first token id to be transferred
1290      * quantity - the amount to be transferred
1291      *
1292      * Calling conditions:
1293      *
1294      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1295      * transferred to `to`.
1296      * - When `from` is zero, `tokenId` will be minted for `to`.
1297      */
1298     function _beforeTokenTransfers(
1299         address from,
1300         address to,
1301         uint256 startTokenId,
1302         uint256 quantity
1303     ) internal virtual {}
1304 
1305     /**
1306      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1307      * minting.
1308      *
1309      * startTokenId - the first token id to be transferred
1310      * quantity - the amount to be transferred
1311      *
1312      * Calling conditions:
1313      *
1314      * - when `from` and `to` are both non-zero.
1315      * - `from` and `to` are never both zero.
1316      */
1317     function _afterTokenTransfers(
1318         address from,
1319         address to,
1320         uint256 startTokenId,
1321         uint256 quantity
1322     ) internal virtual {}
1323 }
1324 
1325 // File: Red.sol
1326 
1327 contract OxRED is Ownable, ERC721A, ReentrancyGuard {
1328     uint256 public immutable maxPerWallet = 50;
1329     uint256 public immutable maxPerFreeMint = 2;
1330     uint256 public immutable freeMints = 300;
1331 
1332     uint256 public immutable devMints;
1333     uint256 public immutable maxPerTx;
1334     uint256 public immutable actualCollectionSize;
1335 
1336     uint256 public publicMintPrice = .02 ether;
1337     bool public publicSaleActive = false;
1338     bool public ogMintActive = false;
1339 
1340     // Merkle Tree
1341     bytes32 public merkleRoot;
1342     mapping(address => uint256) whiteListAmount;
1343 
1344     // dev mint mappings
1345     mapping(address => uint256) amountMintedByDevs;
1346 
1347     constructor(uint256 maxBatchSize_, uint256 collectionSize_, uint256 amountForDevs_)
1348         ERC721A(
1349             "0xRED",
1350             "0xRED",
1351             maxBatchSize_,
1352             collectionSize_
1353         )
1354     {
1355         maxPerTx = maxBatchSize_;
1356         actualCollectionSize = collectionSize_;
1357         devMints = amountForDevs_;
1358     }
1359 
1360     modifier callerIsUser() {
1361         require(tx.origin == msg.sender, "The caller is another contract");
1362         _;
1363     }
1364 
1365     function publicSaleMint(uint256 quantity) external payable callerIsUser {
1366         require(
1367             totalSupply() + quantity <= collectionSize,
1368             "reached max supply"
1369         );
1370         require(
1371             walletQuantity(msg.sender) + quantity <= maxPerWallet,
1372             "can not mint this many"
1373         );
1374         require(quantity <= maxPerTx, "can not mint this many at one time");
1375         require(quantity * publicMintPrice == msg.value, "incorrect funds");
1376         require(publicSaleActive, "public sale has not begun yet");
1377         _safeMint(msg.sender, quantity);
1378     }
1379 
1380     function ogMint(uint256 quantity, bytes32[] calldata _merkleProof) external callerIsUser {
1381         require(
1382             totalSupply() + quantity <= freeMints,
1383             "there are no more free mints!"
1384         );
1385         require(ogMintActive, "free mint is not currently active");
1386         require(whiteListAmount[msg.sender] + quantity <= maxPerFreeMint, "you cant mint anymore og mints");
1387 
1388         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1389         
1390         require(
1391             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1392             "Invalid Merkle Proof."
1393         );
1394 
1395         whiteListAmount[msg.sender]+=quantity;
1396         _safeMint(msg.sender, quantity);
1397     }
1398 
1399     function devMint(uint256 quantity) external onlyOwner {
1400         require(
1401             totalSupply() + quantity <= collectionSize,
1402             "too many already minted before dev mint, try minting less"
1403         );
1404         require(amountMintedByDevs[msg.sender] + quantity <= devMints, "There are no more dev mints");
1405         // come back to this !!!!!
1406         amountMintedByDevs[msg.sender]+=quantity;
1407         _safeMint(msg.sender, quantity);
1408     }
1409 
1410     // base URI
1411 
1412     string private _baseTokenURI;
1413 
1414     function _baseURI() internal view virtual override returns (string memory) {
1415         return _baseTokenURI;
1416     }
1417 
1418     function setBaseURI(string calldata baseURI) external onlyOwner {
1419         _baseTokenURI = baseURI;
1420     }
1421 
1422     // withdraw 
1423 
1424     function withdrawMoney() external onlyOwner nonReentrant {
1425         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1426         require(success, "Transfer failed.");
1427     }
1428 
1429     function setOwnersExplicit(uint256 quantity)
1430         external
1431         onlyOwner
1432         nonReentrant
1433     {
1434         _setOwnersExplicit(quantity);
1435     }
1436 
1437     function walletQuantity(address owner) public view returns (uint256) {
1438         return _numberMinted(owner);
1439     }
1440 
1441     function getOwnershipData(uint256 tokenId)
1442         external
1443         view
1444         returns (TokenOwnership memory)
1445     {
1446         return ownershipOf(tokenId);
1447     }
1448 
1449     function togglePublicMint() public onlyOwner {
1450         publicSaleActive = !publicSaleActive;
1451     }
1452 
1453     function toggleOgMint() public onlyOwner {
1454         ogMintActive = !ogMintActive;
1455     }
1456 
1457     function setMerkleRoot(bytes32 _passedRoot) public onlyOwner {
1458         merkleRoot = _passedRoot;
1459     }
1460 }
