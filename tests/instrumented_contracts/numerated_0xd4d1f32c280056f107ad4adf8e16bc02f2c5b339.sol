1 // Sources flattened with hardhat v2.9.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 
208 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721Metadata is IERC721 {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 
237 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
238 
239 
240 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
246  * @dev See https://eips.ethereum.org/EIPS/eip-721
247  */
248 interface IERC721Enumerable is IERC721 {
249     /**
250      * @dev Returns the total amount of tokens stored by the contract.
251      */
252     function totalSupply() external view returns (uint256);
253 
254     /**
255      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
256      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
257      */
258     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
259 
260     /**
261      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
262      * Use along with {totalSupply} to enumerate all tokens.
263      */
264     function tokenByIndex(uint256 index) external view returns (uint256);
265 }
266 
267 
268 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
269 
270 
271 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
272 
273 pragma solidity ^0.8.1;
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      *
296      * [IMPORTANT]
297      * ====
298      * You shouldn't rely on `isContract` to protect against flash loan attacks!
299      *
300      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
301      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
302      * constructor.
303      * ====
304      */
305     function isContract(address account) internal view returns (bool) {
306         // This method relies on extcodesize/address.code.length, which returns 0
307         // for contracts in construction, since the code is only stored at the end
308         // of the constructor execution.
309 
310         return account.code.length > 0;
311     }
312 
313     /**
314      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
315      * `recipient`, forwarding all available gas and reverting on errors.
316      *
317      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
318      * of certain opcodes, possibly making contracts go over the 2300 gas limit
319      * imposed by `transfer`, making them unable to receive funds via
320      * `transfer`. {sendValue} removes this limitation.
321      *
322      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
323      *
324      * IMPORTANT: because control is transferred to `recipient`, care must be
325      * taken to not create reentrancy vulnerabilities. Consider using
326      * {ReentrancyGuard} or the
327      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
328      */
329     function sendValue(address payable recipient, uint256 amount) internal {
330         require(address(this).balance >= amount, "Address: insufficient balance");
331 
332         (bool success, ) = recipient.call{value: amount}("");
333         require(success, "Address: unable to send value, recipient may have reverted");
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain `call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
355         return functionCall(target, data, "Address: low-level call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
360      * `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, 0, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but also transferring `value` wei to `target`.
375      *
376      * Requirements:
377      *
378      * - the calling contract must have an ETH balance of at least `value`.
379      * - the called Solidity function must be `payable`.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value
387     ) internal returns (bytes memory) {
388         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
393      * with `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCallWithValue(
398         address target,
399         bytes memory data,
400         uint256 value,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         require(address(this).balance >= value, "Address: insufficient balance for call");
404         require(isContract(target), "Address: call to non-contract");
405 
406         (bool success, bytes memory returndata) = target.call{value: value}(data);
407         return verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
417         return functionStaticCall(target, data, "Address: low-level static call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal view returns (bytes memory) {
431         require(isContract(target), "Address: static call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.staticcall(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
444         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         require(isContract(target), "Address: delegate call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.delegatecall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
466      * revert reason using the provided one.
467      *
468      * _Available since v4.3._
469      */
470     function verifyCallResult(
471         bool success,
472         bytes memory returndata,
473         string memory errorMessage
474     ) internal pure returns (bytes memory) {
475         if (success) {
476             return returndata;
477         } else {
478             // Look for revert reason and bubble it up if present
479             if (returndata.length > 0) {
480                 // The easiest way to bubble the revert reason is using memory via assembly
481 
482                 assembly {
483                     let returndata_size := mload(returndata)
484                     revert(add(32, returndata), returndata_size)
485                 }
486             } else {
487                 revert(errorMessage);
488             }
489         }
490     }
491 }
492 
493 
494 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Provides information about the current execution context, including the
503  * sender of the transaction and its data. While these are generally available
504  * via msg.sender and msg.data, they should not be accessed in such a direct
505  * manner, since when dealing with meta-transactions the account sending and
506  * paying for execution may not be the actual sender (as far as an application
507  * is concerned).
508  *
509  * This contract is only required for intermediate, library-like contracts.
510  */
511 abstract contract Context {
512     function _msgSender() internal view virtual returns (address) {
513         return msg.sender;
514     }
515 
516     function _msgData() internal view virtual returns (bytes calldata) {
517         return msg.data;
518     }
519 }
520 
521 
522 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev String operations.
531  */
532 library Strings {
533     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
534 
535     /**
536      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
537      */
538     function toString(uint256 value) internal pure returns (string memory) {
539         // Inspired by OraclizeAPI's implementation - MIT licence
540         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
541 
542         if (value == 0) {
543             return "0";
544         }
545         uint256 temp = value;
546         uint256 digits;
547         while (temp != 0) {
548             digits++;
549             temp /= 10;
550         }
551         bytes memory buffer = new bytes(digits);
552         while (value != 0) {
553             digits -= 1;
554             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
555             value /= 10;
556         }
557         return string(buffer);
558     }
559 
560     /**
561      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
562      */
563     function toHexString(uint256 value) internal pure returns (string memory) {
564         if (value == 0) {
565             return "0x00";
566         }
567         uint256 temp = value;
568         uint256 length = 0;
569         while (temp != 0) {
570             length++;
571             temp >>= 8;
572         }
573         return toHexString(value, length);
574     }
575 
576     /**
577      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
578      */
579     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
580         bytes memory buffer = new bytes(2 * length + 2);
581         buffer[0] = "0";
582         buffer[1] = "x";
583         for (uint256 i = 2 * length + 1; i > 1; --i) {
584             buffer[i] = _HEX_SYMBOLS[value & 0xf];
585             value >>= 4;
586         }
587         require(value == 0, "Strings: hex length insufficient");
588         return string(buffer);
589     }
590 }
591 
592 
593 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 /**
601  * @dev Implementation of the {IERC165} interface.
602  *
603  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
604  * for the additional interface id that will be supported. For example:
605  *
606  * ```solidity
607  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
608  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
609  * }
610  * ```
611  *
612  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
613  */
614 abstract contract ERC165 is IERC165 {
615     /**
616      * @dev See {IERC165-supportsInterface}.
617      */
618     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
619         return interfaceId == type(IERC165).interfaceId;
620     }
621 }
622 
623 
624 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
625 
626 
627 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
628 
629 pragma solidity ^0.8.0;
630 
631 /**
632  * @dev Contract module which provides a basic access control mechanism, where
633  * there is an account (an owner) that can be granted exclusive access to
634  * specific functions.
635  *
636  * By default, the owner account will be the one that deploys the contract. This
637  * can later be changed with {transferOwnership}.
638  *
639  * This module is used through inheritance. It will make available the modifier
640  * `onlyOwner`, which can be applied to your functions to restrict their use to
641  * the owner.
642  */
643 abstract contract Ownable is Context {
644     address private _owner;
645 
646     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
647 
648     /**
649      * @dev Initializes the contract setting the deployer as the initial owner.
650      */
651     constructor() {
652         _transferOwnership(_msgSender());
653     }
654 
655     /**
656      * @dev Returns the address of the current owner.
657      */
658     function owner() public view virtual returns (address) {
659         return _owner;
660     }
661 
662     /**
663      * @dev Throws if called by any account other than the owner.
664      */
665     modifier onlyOwner() {
666         require(owner() == _msgSender(), "Ownable: caller is not the owner");
667         _;
668     }
669 
670     /**
671      * @dev Leaves the contract without owner. It will not be possible to call
672      * `onlyOwner` functions anymore. Can only be called by the current owner.
673      *
674      * NOTE: Renouncing ownership will leave the contract without an owner,
675      * thereby removing any functionality that is only available to the owner.
676      */
677     function renounceOwnership() public virtual onlyOwner {
678         _transferOwnership(address(0));
679     }
680 
681     /**
682      * @dev Transfers ownership of the contract to a new account (`newOwner`).
683      * Can only be called by the current owner.
684      */
685     function transferOwnership(address newOwner) public virtual onlyOwner {
686         require(newOwner != address(0), "Ownable: new owner is the zero address");
687         _transferOwnership(newOwner);
688     }
689 
690     /**
691      * @dev Transfers ownership of the contract to a new account (`newOwner`).
692      * Internal function without access restriction.
693      */
694     function _transferOwnership(address newOwner) internal virtual {
695         address oldOwner = _owner;
696         _owner = newOwner;
697         emit OwnershipTransferred(oldOwner, newOwner);
698     }
699 }
700 
701 
702 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
703 
704 
705 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 /**
710  * @dev These functions deal with verification of Merkle Trees proofs.
711  *
712  * The proofs can be generated using the JavaScript library
713  * https://github.com/miguelmota/merkletreejs[merkletreejs].
714  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
715  *
716  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
717  */
718 library MerkleProof {
719     /**
720      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
721      * defined by `root`. For this, a `proof` must be provided, containing
722      * sibling hashes on the branch from the leaf to the root of the tree. Each
723      * pair of leaves and each pair of pre-images are assumed to be sorted.
724      */
725     function verify(
726         bytes32[] memory proof,
727         bytes32 root,
728         bytes32 leaf
729     ) internal pure returns (bool) {
730         return processProof(proof, leaf) == root;
731     }
732 
733     /**
734      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
735      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
736      * hash matches the root of the tree. When processing the proof, the pairs
737      * of leafs & pre-images are assumed to be sorted.
738      *
739      * _Available since v4.4._
740      */
741     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
742         bytes32 computedHash = leaf;
743         for (uint256 i = 0; i < proof.length; i++) {
744             bytes32 proofElement = proof[i];
745             if (computedHash <= proofElement) {
746                 // Hash(current computed hash + current element of the proof)
747                 computedHash = _efficientHash(computedHash, proofElement);
748             } else {
749                 // Hash(current element of the proof + current computed hash)
750                 computedHash = _efficientHash(proofElement, computedHash);
751             }
752         }
753         return computedHash;
754     }
755 
756     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
757         assembly {
758             mstore(0x00, a)
759             mstore(0x20, b)
760             value := keccak256(0x00, 0x40)
761         }
762     }
763 }
764 
765 
766 // File contracts/hoodies.sol
767 
768 pragma solidity ^0.8.4;
769 
770 
771 
772 
773 
774 
775 
776 
777 error ApprovalCallerNotOwnerNorApproved();
778 error ApprovalQueryForNonexistentToken();
779 error ApproveToCaller();
780 error ApprovalToCurrentOwner();
781 error BalanceQueryForZeroAddress();
782 error MintedQueryForZeroAddress();
783 error BurnedQueryForZeroAddress();
784 error MintToZeroAddress();
785 error MintZeroQuantity();
786 error OwnerIndexOutOfBounds();
787 error OwnerQueryForNonexistentToken();
788 error TokenIndexOutOfBounds();
789 error TransferCallerNotOwnerNorApproved();
790 error TransferFromIncorrectOwner();
791 error TransferToNonERC721ReceiverImplementer();
792 error TransferToZeroAddress();
793 error URIQueryForNonexistentToken();
794 
795 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
796     using Address for address;
797     using Strings for uint256;
798 
799     // Compiler will pack this into a single 256bit word.
800     struct TokenOwnership {
801         // The address of the owner.
802         address addr;
803         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
804         uint64 startTimestamp;
805         // Whether the token has been burned.
806         bool burned;
807     }
808 
809     // Compiler will pack this into a single 256bit word.
810     struct AddressData {
811         // Realistically, 2**64-1 is more than enough.
812         uint64 balance;
813         // Keeps track of mint count with minimal overhead for tokenomics.
814         uint64 numberMinted;
815         // Keeps track of burn count with minimal overhead for tokenomics.
816         uint64 numberBurned;
817     }
818 
819     // Compiler will pack the following 
820     // _currentIndex and _burnCounter into a single 256bit word.
821     
822     // The tokenId of the next token to be minted.
823     uint128 internal _currentIndex;
824 
825     // The number of tokens burned.
826     uint128 internal _burnCounter;
827 
828     // Token name
829     string private _name;
830 
831     // Token symbol
832     string private _symbol;
833 
834     // Mapping from token ID to ownership details
835     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
836     mapping(uint256 => TokenOwnership) internal _ownerships;
837 
838     // Mapping owner address to address data
839     mapping(address => AddressData) private _addressData;
840 
841     // Mapping from token ID to approved address
842     mapping(uint256 => address) private _tokenApprovals;
843 
844     // Mapping from owner to operator approvals
845     mapping(address => mapping(address => bool)) private _operatorApprovals;
846 
847     constructor(string memory name_, string memory symbol_) {
848         _name = name_;
849         _symbol = symbol_;
850     }
851 
852     /**
853      * @dev See {IERC721Enumerable-totalSupply}.
854      */
855     function totalSupply() public view override returns (uint256) {
856         // Counter underflow is impossible as _burnCounter cannot be incremented
857         // more than _currentIndex times
858         unchecked {
859             return _currentIndex - _burnCounter;    
860         }
861     }
862 
863     /**
864      * @dev See {IERC721Enumerable-tokenByIndex}.
865      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
866      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
867      */
868     function tokenByIndex(uint256 index) public view override returns (uint256) {
869         uint256 numMintedSoFar = _currentIndex;
870         uint256 tokenIdsIdx;
871 
872         // Counter overflow is impossible as the loop breaks when
873         // uint256 i is equal to another uint256 numMintedSoFar.
874         unchecked {
875             for (uint256 i; i < numMintedSoFar; i++) {
876                 TokenOwnership memory ownership = _ownerships[i];
877                 if (!ownership.burned) {
878                     if (tokenIdsIdx == index) {
879                         return i;
880                     }
881                     tokenIdsIdx++;
882                 }
883             }
884         }
885         revert TokenIndexOutOfBounds();
886     }
887 
888     /**
889      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
890      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
891      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
892      */
893     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
894         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
895         uint256 numMintedSoFar = _currentIndex;
896         uint256 tokenIdsIdx;
897         address currOwnershipAddr;
898 
899         // Counter overflow is impossible as the loop breaks when
900         // uint256 i is equal to another uint256 numMintedSoFar.
901         unchecked {
902             for (uint256 i; i < numMintedSoFar; i++) {
903                 TokenOwnership memory ownership = _ownerships[i];
904                 if (ownership.burned) {
905                     continue;
906                 }
907                 if (ownership.addr != address(0)) {
908                     currOwnershipAddr = ownership.addr;
909                 }
910                 if (currOwnershipAddr == owner) {
911                     if (tokenIdsIdx == index) {
912                         return i;
913                     }
914                     tokenIdsIdx++;
915                 }
916             }
917         }
918 
919         // Execution should never reach this point.
920         revert();
921     }
922 
923     /**
924      * @dev See {IERC165-supportsInterface}.
925      */
926     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
927         return
928             interfaceId == type(IERC721).interfaceId ||
929             interfaceId == type(IERC721Metadata).interfaceId ||
930             interfaceId == type(IERC721Enumerable).interfaceId ||
931             super.supportsInterface(interfaceId);
932     }
933 
934     /**
935      * @dev See {IERC721-balanceOf}.
936      */
937     function balanceOf(address owner) public view override returns (uint256) {
938         if (owner == address(0)) revert BalanceQueryForZeroAddress();
939         return uint256(_addressData[owner].balance);
940     }
941 
942     function _numberMinted(address owner) internal view returns (uint256) {
943         if (owner == address(0)) revert MintedQueryForZeroAddress();
944         return uint256(_addressData[owner].numberMinted);
945     }
946 
947     function _numberBurned(address owner) internal view returns (uint256) {
948         if (owner == address(0)) revert BurnedQueryForZeroAddress();
949         return uint256(_addressData[owner].numberBurned);
950     }
951 
952     /**
953      * Gas spent here starts off proportional to the maximum mint batch size.
954      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
955      */
956     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
957         uint256 curr = tokenId;
958 
959         unchecked {
960             if (curr < _currentIndex) {
961                 TokenOwnership memory ownership = _ownerships[curr];
962                 if (!ownership.burned) {
963                     if (ownership.addr != address(0)) {
964                         return ownership;
965                     }
966                     // Invariant: 
967                     // There will always be an ownership that has an address and is not burned 
968                     // before an ownership that does not have an address and is not burned.
969                     // Hence, curr will not underflow.
970                     while (true) {
971                         curr--;
972                         ownership = _ownerships[curr];
973                         if (ownership.addr != address(0)) {
974                             return ownership;
975                         }
976                     }
977                 }
978             }
979         }
980         revert OwnerQueryForNonexistentToken();
981     }
982 
983     /**
984      * @dev See {IERC721-ownerOf}.
985      */
986     function ownerOf(uint256 tokenId) public view override returns (address) {
987         return ownershipOf(tokenId).addr;
988     }
989 
990     /**
991      * @dev See {IERC721Metadata-name}.
992      */
993     function name() public view virtual override returns (string memory) {
994         return _name;
995     }
996 
997     /**
998      * @dev See {IERC721Metadata-symbol}.
999      */
1000     function symbol() public view virtual override returns (string memory) {
1001         return _symbol;
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Metadata-tokenURI}.
1006      */
1007     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1008         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1009 
1010         string memory baseURI = _baseURI();
1011         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1012     }
1013 
1014     /**
1015      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1016      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1017      * by default, can be overriden in child contracts.
1018      */
1019     function _baseURI() internal view virtual returns (string memory) {
1020         return '';
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-approve}.
1025      */
1026     function approve(address to, uint256 tokenId) public override {
1027         address owner = ERC721A.ownerOf(tokenId);
1028         if (to == owner) revert ApprovalToCurrentOwner();
1029 
1030         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1031             revert ApprovalCallerNotOwnerNorApproved();
1032         }
1033 
1034         _approve(to, tokenId, owner);
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-getApproved}.
1039      */
1040     function getApproved(uint256 tokenId) public view override returns (address) {
1041         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1042 
1043         return _tokenApprovals[tokenId];
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-setApprovalForAll}.
1048      */
1049     function setApprovalForAll(address operator, bool approved) public override {
1050         if (operator == _msgSender()) revert ApproveToCaller();
1051 
1052         _operatorApprovals[_msgSender()][operator] = approved;
1053         emit ApprovalForAll(_msgSender(), operator, approved);
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-isApprovedForAll}.
1058      */
1059     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1060         return _operatorApprovals[owner][operator];
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-transferFrom}.
1065      */
1066     function transferFrom(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) public virtual override {
1071         _transfer(from, to, tokenId);
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-safeTransferFrom}.
1076      */
1077     function safeTransferFrom(
1078         address from,
1079         address to,
1080         uint256 tokenId
1081     ) public virtual override {
1082         safeTransferFrom(from, to, tokenId, '');
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-safeTransferFrom}.
1087      */
1088     function safeTransferFrom(
1089         address from,
1090         address to,
1091         uint256 tokenId,
1092         bytes memory _data
1093     ) public virtual override {
1094         _transfer(from, to, tokenId);
1095         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1096             revert TransferToNonERC721ReceiverImplementer();
1097         }
1098     }
1099 
1100     /**
1101      * @dev Returns whether `tokenId` exists.
1102      *
1103      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1104      *
1105      * Tokens start existing when they are minted (`_mint`),
1106      */
1107     function _exists(uint256 tokenId) internal view returns (bool) {
1108         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1109     }
1110 
1111     function _safeMint(address to, uint256 quantity) internal {
1112         _safeMint(to, quantity, '');
1113     }
1114 
1115     /**
1116      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1121      * - `quantity` must be greater than 0.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function _safeMint(
1126         address to,
1127         uint256 quantity,
1128         bytes memory _data
1129     ) internal {
1130         _mint(to, quantity, _data, true);
1131     }
1132 
1133     /**
1134      * @dev Mints `quantity` tokens and transfers them to `to`.
1135      *
1136      * Requirements:
1137      *
1138      * - `to` cannot be the zero address.
1139      * - `quantity` must be greater than 0.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _mint(
1144         address to,
1145         uint256 quantity,
1146         bytes memory _data,
1147         bool safe
1148     ) internal {
1149         uint256 startTokenId = _currentIndex;
1150         if (to == address(0)) revert MintToZeroAddress();
1151         if (quantity == 0) revert MintZeroQuantity();
1152 
1153         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1154 
1155         // Overflows are incredibly unrealistic.
1156         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1157         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1158         unchecked {
1159             _addressData[to].balance += uint64(quantity);
1160             _addressData[to].numberMinted += uint64(quantity);
1161 
1162             _ownerships[startTokenId].addr = to;
1163             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1164 
1165             uint256 updatedIndex = startTokenId;
1166 
1167             for (uint256 i; i < quantity; i++) {
1168                 emit Transfer(address(0), to, updatedIndex);
1169                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1170                     revert TransferToNonERC721ReceiverImplementer();
1171                 }
1172                 updatedIndex++;
1173             }
1174 
1175             _currentIndex = uint128(updatedIndex);
1176         }
1177         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1178     }
1179 
1180     /**
1181      * @dev Transfers `tokenId` from `from` to `to`.
1182      *
1183      * Requirements:
1184      *
1185      * - `to` cannot be the zero address.
1186      * - `tokenId` token must be owned by `from`.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _transfer(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) private {
1195         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1196 
1197         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1198             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1199             getApproved(tokenId) == _msgSender());
1200 
1201         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1202         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1203         if (to == address(0)) revert TransferToZeroAddress();
1204 
1205         _beforeTokenTransfers(from, to, tokenId, 1);
1206 
1207         // Clear approvals from the previous owner
1208         _approve(address(0), tokenId, prevOwnership.addr);
1209 
1210         // Underflow of the sender's balance is impossible because we check for
1211         // ownership above and the recipient's balance can't realistically overflow.
1212         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1213         unchecked {
1214             _addressData[from].balance -= 1;
1215             _addressData[to].balance += 1;
1216 
1217             _ownerships[tokenId].addr = to;
1218             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1219 
1220             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1221             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1222             uint256 nextTokenId = tokenId + 1;
1223             if (_ownerships[nextTokenId].addr == address(0)) {
1224                 // This will suffice for checking _exists(nextTokenId),
1225                 // as a burned slot cannot contain the zero address.
1226                 if (nextTokenId < _currentIndex) {
1227                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1228                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1229                 }
1230             }
1231         }
1232 
1233         emit Transfer(from, to, tokenId);
1234         _afterTokenTransfers(from, to, tokenId, 1);
1235     }
1236 
1237     /**
1238      * @dev Destroys `tokenId`.
1239      * The approval is cleared when the token is burned.
1240      *
1241      * Requirements:
1242      *
1243      * - `tokenId` must exist.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _burn(uint256 tokenId) internal virtual {
1248         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1249 
1250         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1251 
1252         // Clear approvals from the previous owner
1253         _approve(address(0), tokenId, prevOwnership.addr);
1254 
1255         // Underflow of the sender's balance is impossible because we check for
1256         // ownership above and the recipient's balance can't realistically overflow.
1257         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1258         unchecked {
1259             _addressData[prevOwnership.addr].balance -= 1;
1260             _addressData[prevOwnership.addr].numberBurned += 1;
1261 
1262             // Keep track of who burned the token, and the timestamp of burning.
1263             _ownerships[tokenId].addr = prevOwnership.addr;
1264             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1265             _ownerships[tokenId].burned = true;
1266 
1267             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1268             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1269             uint256 nextTokenId = tokenId + 1;
1270             if (_ownerships[nextTokenId].addr == address(0)) {
1271                 // This will suffice for checking _exists(nextTokenId),
1272                 // as a burned slot cannot contain the zero address.
1273                 if (nextTokenId < _currentIndex) {
1274                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1275                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1276                 }
1277             }
1278         }
1279 
1280         emit Transfer(prevOwnership.addr, address(0), tokenId);
1281         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1282 
1283         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1284         unchecked { 
1285             _burnCounter++;
1286         }
1287     }
1288 
1289     /**
1290      * @dev Approve `to` to operate on `tokenId`
1291      *
1292      * Emits a {Approval} event.
1293      */
1294     function _approve(
1295         address to,
1296         uint256 tokenId,
1297         address owner
1298     ) private {
1299         _tokenApprovals[tokenId] = to;
1300         emit Approval(owner, to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1305      * The call is not executed if the target address is not a contract.
1306      *
1307      * @param from address representing the previous owner of the given token ID
1308      * @param to target address that will receive the tokens
1309      * @param tokenId uint256 ID of the token to be transferred
1310      * @param _data bytes optional data to send along with the call
1311      * @return bool whether the call correctly returned the expected magic value
1312      */
1313     function _checkOnERC721Received(
1314         address from,
1315         address to,
1316         uint256 tokenId,
1317         bytes memory _data
1318     ) private returns (bool) {
1319         if (to.isContract()) {
1320             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1321                 return retval == IERC721Receiver(to).onERC721Received.selector;
1322             } catch (bytes memory reason) {
1323                 if (reason.length == 0) {
1324                     revert TransferToNonERC721ReceiverImplementer();
1325                 } else {
1326                     assembly {
1327                         revert(add(32, reason), mload(reason))
1328                     }
1329                 }
1330             }
1331         } else {
1332             return true;
1333         }
1334     }
1335 
1336     /**
1337      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1338      * And also called before burning one token.
1339      *
1340      * startTokenId - the first token id to be transferred
1341      * quantity - the amount to be transferred
1342      *
1343      * Calling conditions:
1344      *
1345      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1346      * transferred to `to`.
1347      * - When `from` is zero, `tokenId` will be minted for `to`.
1348      * - When `to` is zero, `tokenId` will be burned by `from`.
1349      * - `from` and `to` are never both zero.
1350      */
1351     function _beforeTokenTransfers(
1352         address from,
1353         address to,
1354         uint256 startTokenId,
1355         uint256 quantity
1356     ) internal virtual {}
1357 
1358     /**
1359      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1360      * minting.
1361      * And also called after one token has been burned.
1362      *
1363      * startTokenId - the first token id to be transferred
1364      * quantity - the amount to be transferred
1365      *
1366      * Calling conditions:
1367      *
1368      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1369      * transferred to `to`.
1370      * - When `from` is zero, `tokenId` has been minted for `to`.
1371      * - When `to` is zero, `tokenId` has been burned by `from`.
1372      * - `from` and `to` are never both zero.
1373      */
1374     function _afterTokenTransfers(
1375         address from,
1376         address to,
1377         uint256 startTokenId,
1378         uint256 quantity
1379     ) internal virtual {}
1380 }
1381 
1382 
1383 // SPDX-License-Identifier: MIT
1384 // Creator: Tasties
1385 
1386 
1387 library Counters {
1388     struct Counter {
1389         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1390         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1391         // this feature: see https://github.com/ethereum/solidity/issues/4637
1392         uint256 _value; // default: 0
1393     }
1394 
1395     function current(Counter storage counter) internal view returns (uint256) {
1396         return counter._value;
1397     }
1398 
1399     function increment(Counter storage counter) internal {
1400         unchecked {
1401             counter._value += 1;
1402         }
1403     }
1404 
1405     function decrement(Counter storage counter) internal {
1406         uint256 value = counter._value;
1407         require(value > 0, "Counter: decrement overflow");
1408         unchecked {
1409             counter._value = value - 1;
1410         }
1411     }
1412 
1413     function reset(Counter storage counter) internal {
1414         counter._value = 0;
1415     }
1416 }
1417 
1418 contract TASTIES is ERC721A, Ownable {
1419     using Counters for Counters.Counter;
1420     using Strings for uint256;
1421 
1422     Counters.Counter private _tokenIds;
1423     bool private _saleActive = false;
1424 
1425     string public _prefixURI;
1426     string public _baseExtension;
1427     
1428     uint256 public  _price = 0;
1429     
1430     uint256 private  _maxMint = 1;
1431                             
1432     uint256 private  _maxTokens = 5000;
1433   
1434     mapping (address => uint256) private _saleMints;
1435 
1436     bytes32 private merkleRoot = 0x319fac0faacb792338a9b62e1ac48b7d110bd85611ee36cb58d5105b771c64df;
1437 
1438     constructor() ERC721A("TASTIES", "TASTIES") {}
1439 
1440     modifier callerIsUser() {
1441     require(tx.origin == msg.sender, "The caller is another contract");
1442     _;
1443     }
1444 
1445     modifier hasCorrectAmount(uint256 _wei, uint256 _quantity) {
1446         require(_wei >= _price * _quantity, "Insufficent funds");
1447         _;
1448     }
1449 
1450     function _baseURI() internal view override returns (string memory) {
1451         return _prefixURI;
1452     }
1453 
1454     function setBaseURI(string memory _uri) public onlyOwner {
1455         _prefixURI = _uri;
1456     }
1457 
1458     function baseExtension() internal view returns (string memory) {
1459         return _baseExtension;
1460     }
1461 
1462     function setBaseExtension(string memory _ext) public onlyOwner {
1463         _baseExtension = _ext;
1464     }
1465 
1466     function saleActive() public view returns (bool) {
1467         return _saleActive;
1468     }
1469 
1470     function toggleSale() public onlyOwner {
1471         _saleActive = !_saleActive;
1472     }
1473     
1474     function updateMaxMint(uint256 newMax) public onlyOwner {
1475         _maxMint = newMax;
1476     }
1477 
1478     function setMerkleRoot(bytes32 _root) public onlyOwner {
1479         merkleRoot = _root;
1480     }
1481 
1482     function teamAllocation(address[] memory addrs) public onlyOwner {
1483          uint256 totalMinted = _tokenIds.current();
1484          require(totalMinted + addrs.length <= 5000);
1485         for (uint256 i = 0; i < addrs.length; i++) {
1486            _tokenIds.increment();
1487            _safeMint(addrs[i], 1);
1488         }
1489     }
1490 
1491     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1492         require(_exists(tokenId),"ERC721AMetadata: URI query for nonexistent token");
1493         string memory currentBaseURI = _baseURI();
1494         tokenId.toString();
1495         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), _baseExtension)) : "";
1496     }
1497 
1498     function mintItem(
1499         uint256 _quantity,
1500         bytes32[] calldata proof
1501     )  
1502      external payable callerIsUser
1503      hasCorrectAmount(msg.value, _quantity)
1504     {
1505         require(
1506             _quantity > 0 &&
1507                 _saleMints[msg.sender] + _quantity <=
1508                 1,
1509             "Minting above limit"
1510         );        
1511         require(_saleActive);
1512         uint256 totalMinted = _tokenIds.current();
1513         require(totalMinted + _quantity <= 5000);
1514         require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "You are not in the list!");
1515         require(_saleMints[msg.sender] + _quantity <= _maxMint);
1516         
1517         _saleMints[msg.sender] += _quantity;
1518         _tokenIds.increment();
1519         _safeMint(msg.sender, _quantity);
1520     }
1521 }