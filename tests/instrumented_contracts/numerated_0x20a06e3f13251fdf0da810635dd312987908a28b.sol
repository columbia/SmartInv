1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title ERC721 token receiver interface
11  * @dev Interface for any contract that wants to support safeTransfers
12  * from ERC721 asset contracts.
13  */
14 interface IERC721Receiver {
15     /**
16      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
17      * by `operator` from `from`, this function is called.
18      *
19      * It must return its Solidity selector to confirm the token transfer.
20      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
21      *
22      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
23      */
24     function onERC721Received(
25         address operator,
26         address from,
27         uint256 tokenId,
28         bytes calldata data
29     ) external returns (bytes4);
30 }
31 
32 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Interface of the ERC165 standard, as defined in the
41  * https://eips.ethereum.org/EIPS/eip-165[EIP].
42  *
43  * Implementers can declare support of contract interfaces, which can then be
44  * queried by others ({ERC165Checker}).
45  *
46  * For an implementation, see {ERC165}.
47  */
48 interface IERC165 {
49     /**
50      * @dev Returns true if this contract implements the interface defined by
51      * `interfaceId`. See the corresponding
52      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
53      * to learn more about how these ids are created.
54      *
55      * This function call must use less than 30 000 gas.
56      */
57     function supportsInterface(bytes4 interfaceId) external view returns (bool);
58 }
59 
60 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
61 
62 
63 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 
68 /**
69  * @dev Implementation of the {IERC165} interface.
70  *
71  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
72  * for the additional interface id that will be supported. For example:
73  *
74  * ```solidity
75  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
76  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
77  * }
78  * ```
79  *
80  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
81  */
82 abstract contract ERC165 is IERC165 {
83     /**
84      * @dev See {IERC165-supportsInterface}.
85      */
86     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
87         return interfaceId == type(IERC165).interfaceId;
88     }
89 }
90 
91 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
92 
93 
94 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
95 
96 pragma solidity ^0.8.0;
97 
98 
99 /**
100  * @dev Required interface of an ERC721 compliant contract.
101  */
102 interface IERC721 is IERC165 {
103     /**
104      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
107 
108     /**
109      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
110      */
111     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
112 
113     /**
114      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
115      */
116     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
117 
118     /**
119      * @dev Returns the number of tokens in ``owner``'s account.
120      */
121     function balanceOf(address owner) external view returns (uint256 balance);
122 
123     /**
124      * @dev Returns the owner of the `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function ownerOf(uint256 tokenId) external view returns (address owner);
131 
132     /**
133      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
134      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
135      *
136      * Requirements:
137      *
138      * - `from` cannot be the zero address.
139      * - `to` cannot be the zero address.
140      * - `tokenId` token must exist and be owned by `from`.
141      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
142      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
143      *
144      * Emits a {Transfer} event.
145      */
146     function safeTransferFrom(
147         address from,
148         address to,
149         uint256 tokenId
150     ) external;
151 
152     /**
153      * @dev Transfers `tokenId` token from `from` to `to`.
154      *
155      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transferFrom(
167         address from,
168         address to,
169         uint256 tokenId
170     ) external;
171 
172     /**
173      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
174      * The approval is cleared when the token is transferred.
175      *
176      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
177      *
178      * Requirements:
179      *
180      * - The caller must own the token or be an approved operator.
181      * - `tokenId` must exist.
182      *
183      * Emits an {Approval} event.
184      */
185     function approve(address to, uint256 tokenId) external;
186 
187     /**
188      * @dev Returns the account approved for `tokenId` token.
189      *
190      * Requirements:
191      *
192      * - `tokenId` must exist.
193      */
194     function getApproved(uint256 tokenId) external view returns (address operator);
195 
196     /**
197      * @dev Approve or remove `operator` as an operator for the caller.
198      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
199      *
200      * Requirements:
201      *
202      * - The `operator` cannot be the caller.
203      *
204      * Emits an {ApprovalForAll} event.
205      */
206     function setApprovalForAll(address operator, bool _approved) external;
207 
208     /**
209      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
210      *
211      * See {setApprovalForAll}
212      */
213     function isApprovedForAll(address owner, address operator) external view returns (bool);
214 
215     /**
216      * @dev Safely transfers `tokenId` token from `from` to `to`.
217      *
218      * Requirements:
219      *
220      * - `from` cannot be the zero address.
221      * - `to` cannot be the zero address.
222      * - `tokenId` token must exist and be owned by `from`.
223      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
224      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
225      *
226      * Emits a {Transfer} event.
227      */
228     function safeTransferFrom(
229         address from,
230         address to,
231         uint256 tokenId,
232         bytes calldata data
233     ) external;
234 }
235 
236 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
237 
238 
239 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
240 
241 pragma solidity ^0.8.0;
242 
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
267 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
268 
269 
270 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
271 
272 pragma solidity ^0.8.0;
273 
274 
275 /**
276  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
277  * @dev See https://eips.ethereum.org/EIPS/eip-721
278  */
279 interface IERC721Metadata is IERC721 {
280     /**
281      * @dev Returns the token collection name.
282      */
283     function name() external view returns (string memory);
284 
285     /**
286      * @dev Returns the token collection symbol.
287      */
288     function symbol() external view returns (string memory);
289 
290     /**
291      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
292      */
293     function tokenURI(uint256 tokenId) external view returns (string memory);
294 }
295 
296 // File: @openzeppelin/contracts/utils/Strings.sol
297 
298 
299 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @dev String operations.
305  */
306 library Strings {
307     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
308 
309     /**
310      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
311      */
312     function toString(uint256 value) internal pure returns (string memory) {
313         // Inspired by OraclizeAPI's implementation - MIT licence
314         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
315 
316         if (value == 0) {
317             return "0";
318         }
319         uint256 temp = value;
320         uint256 digits;
321         while (temp != 0) {
322             digits++;
323             temp /= 10;
324         }
325         bytes memory buffer = new bytes(digits);
326         while (value != 0) {
327             digits -= 1;
328             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
329             value /= 10;
330         }
331         return string(buffer);
332     }
333 
334     /**
335      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
336      */
337     function toHexString(uint256 value) internal pure returns (string memory) {
338         if (value == 0) {
339             return "0x00";
340         }
341         uint256 temp = value;
342         uint256 length = 0;
343         while (temp != 0) {
344             length++;
345             temp >>= 8;
346         }
347         return toHexString(value, length);
348     }
349 
350     /**
351      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
352      */
353     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
354         bytes memory buffer = new bytes(2 * length + 2);
355         buffer[0] = "0";
356         buffer[1] = "x";
357         for (uint256 i = 2 * length + 1; i > 1; --i) {
358             buffer[i] = _HEX_SYMBOLS[value & 0xf];
359             value >>= 4;
360         }
361         require(value == 0, "Strings: hex length insufficient");
362         return string(buffer);
363     }
364 }
365 
366 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
367 
368 
369 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
370 
371 pragma solidity ^0.8.0;
372 
373 /**
374  * @dev These functions deal with verification of Merkle Trees proofs.
375  *
376  * The proofs can be generated using the JavaScript library
377  * https://github.com/miguelmota/merkletreejs[merkletreejs].
378  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
379  *
380  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
381  */
382 library MerkleProof {
383     /**
384      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
385      * defined by `root`. For this, a `proof` must be provided, containing
386      * sibling hashes on the branch from the leaf to the root of the tree. Each
387      * pair of leaves and each pair of pre-images are assumed to be sorted.
388      */
389     function verify(
390         bytes32[] memory proof,
391         bytes32 root,
392         bytes32 leaf
393     ) internal pure returns (bool) {
394         return processProof(proof, leaf) == root;
395     }
396 
397     /**
398      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
399      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
400      * hash matches the root of the tree. When processing the proof, the pairs
401      * of leafs & pre-images are assumed to be sorted.
402      *
403      * _Available since v4.4._
404      */
405     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
406         bytes32 computedHash = leaf;
407         for (uint256 i = 0; i < proof.length; i++) {
408             bytes32 proofElement = proof[i];
409             if (computedHash <= proofElement) {
410                 // Hash(current computed hash + current element of the proof)
411                 computedHash = _efficientHash(computedHash, proofElement);
412             } else {
413                 // Hash(current element of the proof + current computed hash)
414                 computedHash = _efficientHash(proofElement, computedHash);
415             }
416         }
417         return computedHash;
418     }
419 
420     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
421         assembly {
422             mstore(0x00, a)
423             mstore(0x20, b)
424             value := keccak256(0x00, 0x40)
425         }
426     }
427 }
428 
429 // File: @openzeppelin/contracts/utils/Address.sol
430 
431 
432 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
433 
434 pragma solidity ^0.8.1;
435 
436 /**
437  * @dev Collection of functions related to the address type
438  */
439 library Address {
440     /**
441      * @dev Returns true if `account` is a contract.
442      *
443      * [IMPORTANT]
444      * ====
445      * It is unsafe to assume that an address for which this function returns
446      * false is an externally-owned account (EOA) and not a contract.
447      *
448      * Among others, `isContract` will return false for the following
449      * types of addresses:
450      *
451      *  - an externally-owned account
452      *  - a contract in construction
453      *  - an address where a contract will be created
454      *  - an address where a contract lived, but was destroyed
455      * ====
456      *
457      * [IMPORTANT]
458      * ====
459      * You shouldn't rely on `isContract` to protect against flash loan attacks!
460      *
461      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
462      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
463      * constructor.
464      * ====
465      */
466     function isContract(address account) internal view returns (bool) {
467         // This method relies on extcodesize/address.code.length, which returns 0
468         // for contracts in construction, since the code is only stored at the end
469         // of the constructor execution.
470 
471         return account.code.length > 0;
472     }
473 
474     /**
475      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
476      * `recipient`, forwarding all available gas and reverting on errors.
477      *
478      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
479      * of certain opcodes, possibly making contracts go over the 2300 gas limit
480      * imposed by `transfer`, making them unable to receive funds via
481      * `transfer`. {sendValue} removes this limitation.
482      *
483      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
484      *
485      * IMPORTANT: because control is transferred to `recipient`, care must be
486      * taken to not create reentrancy vulnerabilities. Consider using
487      * {ReentrancyGuard} or the
488      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
489      */
490     function sendValue(address payable recipient, uint256 amount) internal {
491         require(address(this).balance >= amount, "Address: insufficient balance");
492 
493         (bool success, ) = recipient.call{value: amount}("");
494         require(success, "Address: unable to send value, recipient may have reverted");
495     }
496 
497     /**
498      * @dev Performs a Solidity function call using a low level `call`. A
499      * plain `call` is an unsafe replacement for a function call: use this
500      * function instead.
501      *
502      * If `target` reverts with a revert reason, it is bubbled up by this
503      * function (like regular Solidity function calls).
504      *
505      * Returns the raw returned data. To convert to the expected return value,
506      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
507      *
508      * Requirements:
509      *
510      * - `target` must be a contract.
511      * - calling `target` with `data` must not revert.
512      *
513      * _Available since v3.1._
514      */
515     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
516         return functionCall(target, data, "Address: low-level call failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
521      * `errorMessage` as a fallback revert reason when `target` reverts.
522      *
523      * _Available since v3.1._
524      */
525     function functionCall(
526         address target,
527         bytes memory data,
528         string memory errorMessage
529     ) internal returns (bytes memory) {
530         return functionCallWithValue(target, data, 0, errorMessage);
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
535      * but also transferring `value` wei to `target`.
536      *
537      * Requirements:
538      *
539      * - the calling contract must have an ETH balance of at least `value`.
540      * - the called Solidity function must be `payable`.
541      *
542      * _Available since v3.1._
543      */
544     function functionCallWithValue(
545         address target,
546         bytes memory data,
547         uint256 value
548     ) internal returns (bytes memory) {
549         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
554      * with `errorMessage` as a fallback revert reason when `target` reverts.
555      *
556      * _Available since v3.1._
557      */
558     function functionCallWithValue(
559         address target,
560         bytes memory data,
561         uint256 value,
562         string memory errorMessage
563     ) internal returns (bytes memory) {
564         require(address(this).balance >= value, "Address: insufficient balance for call");
565         require(isContract(target), "Address: call to non-contract");
566 
567         (bool success, bytes memory returndata) = target.call{value: value}(data);
568         return verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
573      * but performing a static call.
574      *
575      * _Available since v3.3._
576      */
577     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
578         return functionStaticCall(target, data, "Address: low-level static call failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
583      * but performing a static call.
584      *
585      * _Available since v3.3._
586      */
587     function functionStaticCall(
588         address target,
589         bytes memory data,
590         string memory errorMessage
591     ) internal view returns (bytes memory) {
592         require(isContract(target), "Address: static call to non-contract");
593 
594         (bool success, bytes memory returndata) = target.staticcall(data);
595         return verifyCallResult(success, returndata, errorMessage);
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
600      * but performing a delegate call.
601      *
602      * _Available since v3.4._
603      */
604     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
605         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
610      * but performing a delegate call.
611      *
612      * _Available since v3.4._
613      */
614     function functionDelegateCall(
615         address target,
616         bytes memory data,
617         string memory errorMessage
618     ) internal returns (bytes memory) {
619         require(isContract(target), "Address: delegate call to non-contract");
620 
621         (bool success, bytes memory returndata) = target.delegatecall(data);
622         return verifyCallResult(success, returndata, errorMessage);
623     }
624 
625     /**
626      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
627      * revert reason using the provided one.
628      *
629      * _Available since v4.3._
630      */
631     function verifyCallResult(
632         bool success,
633         bytes memory returndata,
634         string memory errorMessage
635     ) internal pure returns (bytes memory) {
636         if (success) {
637             return returndata;
638         } else {
639             // Look for revert reason and bubble it up if present
640             if (returndata.length > 0) {
641                 // The easiest way to bubble the revert reason is using memory via assembly
642 
643                 assembly {
644                     let returndata_size := mload(returndata)
645                     revert(add(32, returndata), returndata_size)
646                 }
647             } else {
648                 revert(errorMessage);
649             }
650         }
651     }
652 }
653 
654 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
655 
656 
657 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
658 
659 pragma solidity ^0.8.0;
660 
661 /**
662  * @dev Interface of the ERC20 standard as defined in the EIP.
663  */
664 interface IERC20 {
665     /**
666      * @dev Returns the amount of tokens in existence.
667      */
668     function totalSupply() external view returns (uint256);
669 
670     /**
671      * @dev Returns the amount of tokens owned by `account`.
672      */
673     function balanceOf(address account) external view returns (uint256);
674 
675     /**
676      * @dev Moves `amount` tokens from the caller's account to `to`.
677      *
678      * Returns a boolean value indicating whether the operation succeeded.
679      *
680      * Emits a {Transfer} event.
681      */
682     function transfer(address to, uint256 amount) external returns (bool);
683 
684     /**
685      * @dev Returns the remaining number of tokens that `spender` will be
686      * allowed to spend on behalf of `owner` through {transferFrom}. This is
687      * zero by default.
688      *
689      * This value changes when {approve} or {transferFrom} are called.
690      */
691     function allowance(address owner, address spender) external view returns (uint256);
692 
693     /**
694      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
695      *
696      * Returns a boolean value indicating whether the operation succeeded.
697      *
698      * IMPORTANT: Beware that changing an allowance with this method brings the risk
699      * that someone may use both the old and the new allowance by unfortunate
700      * transaction ordering. One possible solution to mitigate this race
701      * condition is to first reduce the spender's allowance to 0 and set the
702      * desired value afterwards:
703      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
704      *
705      * Emits an {Approval} event.
706      */
707     function approve(address spender, uint256 amount) external returns (bool);
708 
709     /**
710      * @dev Moves `amount` tokens from `from` to `to` using the
711      * allowance mechanism. `amount` is then deducted from the caller's
712      * allowance.
713      *
714      * Returns a boolean value indicating whether the operation succeeded.
715      *
716      * Emits a {Transfer} event.
717      */
718     function transferFrom(
719         address from,
720         address to,
721         uint256 amount
722     ) external returns (bool);
723 
724     /**
725      * @dev Emitted when `value` tokens are moved from one account (`from`) to
726      * another (`to`).
727      *
728      * Note that `value` may be zero.
729      */
730     event Transfer(address indexed from, address indexed to, uint256 value);
731 
732     /**
733      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
734      * a call to {approve}. `value` is the new allowance.
735      */
736     event Approval(address indexed owner, address indexed spender, uint256 value);
737 }
738 
739 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
740 
741 
742 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
743 
744 pragma solidity ^0.8.0;
745 
746 
747 
748 /**
749  * @title SafeERC20
750  * @dev Wrappers around ERC20 operations that throw on failure (when the token
751  * contract returns false). Tokens that return no value (and instead revert or
752  * throw on failure) are also supported, non-reverting calls are assumed to be
753  * successful.
754  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
755  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
756  */
757 library SafeERC20 {
758     using Address for address;
759 
760     function safeTransfer(
761         IERC20 token,
762         address to,
763         uint256 value
764     ) internal {
765         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
766     }
767 
768     function safeTransferFrom(
769         IERC20 token,
770         address from,
771         address to,
772         uint256 value
773     ) internal {
774         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
775     }
776 
777     /**
778      * @dev Deprecated. This function has issues similar to the ones found in
779      * {IERC20-approve}, and its usage is discouraged.
780      *
781      * Whenever possible, use {safeIncreaseAllowance} and
782      * {safeDecreaseAllowance} instead.
783      */
784     function safeApprove(
785         IERC20 token,
786         address spender,
787         uint256 value
788     ) internal {
789         // safeApprove should only be called when setting an initial allowance,
790         // or when resetting it to zero. To increase and decrease it, use
791         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
792         require(
793             (value == 0) || (token.allowance(address(this), spender) == 0),
794             "SafeERC20: approve from non-zero to non-zero allowance"
795         );
796         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
797     }
798 
799     function safeIncreaseAllowance(
800         IERC20 token,
801         address spender,
802         uint256 value
803     ) internal {
804         uint256 newAllowance = token.allowance(address(this), spender) + value;
805         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
806     }
807 
808     function safeDecreaseAllowance(
809         IERC20 token,
810         address spender,
811         uint256 value
812     ) internal {
813         unchecked {
814             uint256 oldAllowance = token.allowance(address(this), spender);
815             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
816             uint256 newAllowance = oldAllowance - value;
817             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
818         }
819     }
820 
821     /**
822      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
823      * on the return value: the return value is optional (but if data is returned, it must not be false).
824      * @param token The token targeted by the call.
825      * @param data The call data (encoded using abi.encode or one of its variants).
826      */
827     function _callOptionalReturn(IERC20 token, bytes memory data) private {
828         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
829         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
830         // the target address contains contract code and also asserts for success in the low-level call.
831 
832         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
833         if (returndata.length > 0) {
834             // Return data is optional
835             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
836         }
837     }
838 }
839 
840 // File: @openzeppelin/contracts/utils/Context.sol
841 
842 
843 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
844 
845 pragma solidity ^0.8.0;
846 
847 /**
848  * @dev Provides information about the current execution context, including the
849  * sender of the transaction and its data. While these are generally available
850  * via msg.sender and msg.data, they should not be accessed in such a direct
851  * manner, since when dealing with meta-transactions the account sending and
852  * paying for execution may not be the actual sender (as far as an application
853  * is concerned).
854  *
855  * This contract is only required for intermediate, library-like contracts.
856  */
857 abstract contract Context {
858     function _msgSender() internal view virtual returns (address) {
859         return msg.sender;
860     }
861 
862     function _msgData() internal view virtual returns (bytes calldata) {
863         return msg.data;
864     }
865 }
866 
867 // File: contracts/ERC721A.sol
868 
869 
870 // Creator: Chiru Labs
871 
872 pragma solidity ^0.8.4;
873 
874 
875 
876 
877 
878 
879 
880 
881 
882 error ApprovalCallerNotOwnerNorApproved();
883 error ApprovalQueryForNonexistentToken();
884 error ApproveToCaller();
885 error ApprovalToCurrentOwner();
886 error BalanceQueryForZeroAddress();
887 error MintedQueryForZeroAddress();
888 error BurnedQueryForZeroAddress();
889 error AuxQueryForZeroAddress();
890 error MintToZeroAddress();
891 error MintZeroQuantity();
892 error OwnerIndexOutOfBounds();
893 error OwnerQueryForNonexistentToken();
894 error TokenIndexOutOfBounds();
895 error TransferCallerNotOwnerNorApproved();
896 error TransferFromIncorrectOwner();
897 error TransferToNonERC721ReceiverImplementer();
898 error TransferToZeroAddress();
899 error URIQueryForNonexistentToken();
900 
901 /**
902  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
903  * the Metadata extension. Built to optimize for lower gas during batch mints.
904  *
905  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
906  *
907  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
908  *
909  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
910  */
911 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
912     using Address for address;
913     using Strings for uint256;
914 
915     // Compiler will pack this into a single 256bit word.
916     struct TokenOwnership {
917         // The address of the owner.
918         address addr;
919         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
920         uint64 startTimestamp;
921         // Whether the token has been burned.
922         bool burned;
923     }
924 
925     // Compiler will pack this into a single 256bit word.
926     struct AddressData {
927         // Realistically, 2**64-1 is more than enough.
928         uint64 balance;
929         // Keeps track of mint count with minimal overhead for tokenomics.
930         uint64 numberMinted;
931         // Keeps track of burn count with minimal overhead for tokenomics.
932         uint64 numberBurned;
933         // For miscellaneous variable(s) pertaining to the address
934         // (e.g. number of whitelist mint slots used).
935         // If there are multiple variables, please pack them into a uint64.
936         uint64 aux;
937     }
938 
939     // The tokenId of the next token to be minted.
940     uint256 internal _currentIndex;
941 
942     // The number of tokens burned.
943     uint256 internal _burnCounter;
944 
945     // Token name
946     string private _name;
947 
948     // Token symbol
949     string private _symbol;
950 
951     // Mapping from token ID to ownership details
952     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
953     mapping(uint256 => TokenOwnership) internal _ownerships;
954 
955     // Mapping owner address to address data
956     mapping(address => AddressData) private _addressData;
957 
958     // Mapping from token ID to approved address
959     mapping(uint256 => address) private _tokenApprovals;
960 
961     // Mapping from owner to operator approvals
962     mapping(address => mapping(address => bool)) private _operatorApprovals;
963 
964     constructor(string memory name_, string memory symbol_) {
965         _name = name_;
966         _symbol = symbol_;
967         _currentIndex = _startTokenId();
968     }
969 
970     /**
971      * To change the starting tokenId, please override this function.
972      */
973     function _startTokenId() internal view virtual returns (uint256) {
974         return 1;
975     }
976 
977     /**
978      * @dev See {IERC721Enumerable-totalSupply}.
979      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
980      */
981     function totalSupply() public view returns (uint256) {
982         // Counter underflow is impossible as _burnCounter cannot be incremented
983         // more than _currentIndex - _startTokenId() times
984         unchecked {
985             return _currentIndex - _burnCounter - _startTokenId();
986         }
987     }
988 
989     /**
990      * Returns the total amount of tokens minted in the contract.
991      */
992     function _totalMinted() internal view returns (uint256) {
993         // Counter underflow is impossible as _currentIndex does not decrement,
994         // and it is initialized to _startTokenId()
995         unchecked {
996             return _currentIndex - _startTokenId();
997         }
998     }
999 
1000     /**
1001      * @dev See {IERC165-supportsInterface}.
1002      */
1003     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1004         return
1005             interfaceId == type(IERC721).interfaceId ||
1006             interfaceId == type(IERC721Metadata).interfaceId ||
1007             super.supportsInterface(interfaceId);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-balanceOf}.
1012      */
1013     function balanceOf(address owner) public view override returns (uint256) {
1014         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1015         return uint256(_addressData[owner].balance);
1016     }
1017 
1018     /**
1019      * Returns the number of tokens minted by `owner`.
1020      */
1021     function _numberMinted(address owner) internal view returns (uint256) {
1022         if (owner == address(0)) revert MintedQueryForZeroAddress();
1023         return uint256(_addressData[owner].numberMinted);
1024     }
1025 
1026     /**
1027      * Returns the number of tokens burned by or on behalf of `owner`.
1028      */
1029     function _numberBurned(address owner) internal view returns (uint256) {
1030         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1031         return uint256(_addressData[owner].numberBurned);
1032     }
1033 
1034     /**
1035      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1036      */
1037     function _getAux(address owner) internal view returns (uint64) {
1038         if (owner == address(0)) revert AuxQueryForZeroAddress();
1039         return _addressData[owner].aux;
1040     }
1041 
1042     /**
1043      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1044      * If there are multiple variables, please pack them into a uint64.
1045      */
1046     function _setAux(address owner, uint64 aux) internal {
1047         if (owner == address(0)) revert AuxQueryForZeroAddress();
1048         _addressData[owner].aux = aux;
1049     }
1050 
1051     /**
1052      * Gas spent here starts off proportional to the maximum mint batch size.
1053      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1054      */
1055     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1056         uint256 curr = tokenId;
1057 
1058         unchecked {
1059             if (_startTokenId() <= curr && curr < _currentIndex) {
1060                 TokenOwnership memory ownership = _ownerships[curr];
1061                 if (!ownership.burned) {
1062                     if (ownership.addr != address(0)) {
1063                         return ownership;
1064                     }
1065                     // Invariant:
1066                     // There will always be an ownership that has an address and is not burned
1067                     // before an ownership that does not have an address and is not burned.
1068                     // Hence, curr will not underflow.
1069                     while (true) {
1070                         curr--;
1071                         ownership = _ownerships[curr];
1072                         if (ownership.addr != address(0)) {
1073                             return ownership;
1074                         }
1075                     }
1076                 }
1077             }
1078         }
1079         revert OwnerQueryForNonexistentToken();
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-ownerOf}.
1084      */
1085     function ownerOf(uint256 tokenId) public view override returns (address) {
1086         return ownershipOf(tokenId).addr;
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Metadata-name}.
1091      */
1092     function name() public view virtual override returns (string memory) {
1093         return _name;
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Metadata-symbol}.
1098      */
1099     function symbol() public view virtual override returns (string memory) {
1100         return _symbol;
1101     }
1102 
1103     /**
1104      * @dev See {IERC721Metadata-tokenURI}.
1105      */
1106     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1107         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1108 
1109         string memory baseURI = _baseURI();
1110         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1111     }
1112 
1113     /**
1114      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1115      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1116      * by default, can be overriden in child contracts.
1117      */
1118     function _baseURI() internal view virtual returns (string memory) {
1119         return '';
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-approve}.
1124      */
1125     function approve(address to, uint256 tokenId) public override {
1126         address owner = ERC721A.ownerOf(tokenId);
1127         if (to == owner) revert ApprovalToCurrentOwner();
1128 
1129         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1130             revert ApprovalCallerNotOwnerNorApproved();
1131         }
1132 
1133         _approve(to, tokenId, owner);
1134     }
1135 
1136     /**
1137      * @dev See {IERC721-getApproved}.
1138      */
1139     function getApproved(uint256 tokenId) public view override returns (address) {
1140         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1141 
1142         return _tokenApprovals[tokenId];
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-setApprovalForAll}.
1147      */
1148     function setApprovalForAll(address operator, bool approved) public override {
1149         if (operator == _msgSender()) revert ApproveToCaller();
1150 
1151         _operatorApprovals[_msgSender()][operator] = approved;
1152         emit ApprovalForAll(_msgSender(), operator, approved);
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-isApprovedForAll}.
1157      */
1158     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1159         return _operatorApprovals[owner][operator];
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-transferFrom}.
1164      */
1165     function transferFrom(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) public virtual override {
1170         _transfer(from, to, tokenId);
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-safeTransferFrom}.
1175      */
1176     function safeTransferFrom(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) public virtual override {
1181         safeTransferFrom(from, to, tokenId, '');
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-safeTransferFrom}.
1186      */
1187     function safeTransferFrom(
1188         address from,
1189         address to,
1190         uint256 tokenId,
1191         bytes memory _data
1192     ) public virtual override {
1193         _transfer(from, to, tokenId);
1194         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1195             revert TransferToNonERC721ReceiverImplementer();
1196         }
1197     }
1198 
1199     /**
1200      * @dev Returns whether `tokenId` exists.
1201      *
1202      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1203      *
1204      * Tokens start existing when they are minted (`_mint`),
1205      */
1206     function _exists(uint256 tokenId) internal view returns (bool) {
1207         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1208             !_ownerships[tokenId].burned;
1209     }
1210 
1211     function _safeMint(address to, uint256 quantity) internal {
1212         _safeMint(to, quantity, '');
1213     }
1214 
1215     /**
1216      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1217      *
1218      * Requirements:
1219      *
1220      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1221      * - `quantity` must be greater than 0.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function _safeMint(
1226         address to,
1227         uint256 quantity,
1228         bytes memory _data
1229     ) internal {
1230         _mint(to, quantity, _data, true);
1231     }
1232 
1233     /**
1234      * @dev Mints `quantity` tokens and transfers them to `to`.
1235      *
1236      * Requirements:
1237      *
1238      * - `to` cannot be the zero address.
1239      * - `quantity` must be greater than 0.
1240      *
1241      * Emits a {Transfer} event.
1242      */
1243     function _mint(
1244         address to,
1245         uint256 quantity,
1246         bytes memory _data,
1247         bool safe
1248     ) internal {
1249         uint256 startTokenId = _currentIndex;
1250         if (to == address(0)) revert MintToZeroAddress();
1251         if (quantity == 0) revert MintZeroQuantity();
1252 
1253         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1254 
1255         // Overflows are incredibly unrealistic.
1256         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1257         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1258         unchecked {
1259             _addressData[to].balance += uint64(quantity);
1260             _addressData[to].numberMinted += uint64(quantity);
1261 
1262             _ownerships[startTokenId].addr = to;
1263             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1264 
1265             uint256 updatedIndex = startTokenId;
1266             uint256 end = updatedIndex + quantity;
1267 
1268             if (safe && to.isContract()) {
1269                 do {
1270                     emit Transfer(address(0), to, updatedIndex);
1271                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1272                         revert TransferToNonERC721ReceiverImplementer();
1273                     }
1274                 } while (updatedIndex != end);
1275                 // Reentrancy protection
1276                 if (_currentIndex != startTokenId) revert();
1277             } else {
1278                 do {
1279                     emit Transfer(address(0), to, updatedIndex++);
1280                 } while (updatedIndex != end);
1281             }
1282             _currentIndex = updatedIndex;
1283         }
1284         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1285     }
1286 
1287     /**
1288      * @dev Transfers `tokenId` from `from` to `to`.
1289      *
1290      * Requirements:
1291      *
1292      * - `to` cannot be the zero address.
1293      * - `tokenId` token must be owned by `from`.
1294      *
1295      * Emits a {Transfer} event.
1296      */
1297     function _transfer(
1298         address from,
1299         address to,
1300         uint256 tokenId
1301     ) private {
1302         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1303 
1304         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1305             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1306             getApproved(tokenId) == _msgSender());
1307 
1308         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1309         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1310         if (to == address(0)) revert TransferToZeroAddress();
1311 
1312         _beforeTokenTransfers(from, to, tokenId, 1);
1313 
1314         // Clear approvals from the previous owner
1315         _approve(address(0), tokenId, prevOwnership.addr);
1316 
1317         // Underflow of the sender's balance is impossible because we check for
1318         // ownership above and the recipient's balance can't realistically overflow.
1319         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1320         unchecked {
1321             _addressData[from].balance -= 1;
1322             _addressData[to].balance += 1;
1323 
1324             _ownerships[tokenId].addr = to;
1325             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1326 
1327             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1328             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1329             uint256 nextTokenId = tokenId + 1;
1330             if (_ownerships[nextTokenId].addr == address(0)) {
1331                 // This will suffice for checking _exists(nextTokenId),
1332                 // as a burned slot cannot contain the zero address.
1333                 if (nextTokenId < _currentIndex) {
1334                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1335                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1336                 }
1337             }
1338         }
1339 
1340         emit Transfer(from, to, tokenId);
1341         _afterTokenTransfers(from, to, tokenId, 1);
1342     }
1343 
1344     /**
1345      * @dev Destroys `tokenId`.
1346      * The approval is cleared when the token is burned.
1347      *
1348      * Requirements:
1349      *
1350      * - `tokenId` must exist.
1351      *
1352      * Emits a {Transfer} event.
1353      */
1354     function _burn(uint256 tokenId) internal virtual {
1355         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1356 
1357         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1358 
1359         // Clear approvals from the previous owner
1360         _approve(address(0), tokenId, prevOwnership.addr);
1361 
1362         // Underflow of the sender's balance is impossible because we check for
1363         // ownership above and the recipient's balance can't realistically overflow.
1364         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1365         unchecked {
1366             _addressData[prevOwnership.addr].balance -= 1;
1367             _addressData[prevOwnership.addr].numberBurned += 1;
1368 
1369             // Keep track of who burned the token, and the timestamp of burning.
1370             _ownerships[tokenId].addr = prevOwnership.addr;
1371             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1372             _ownerships[tokenId].burned = true;
1373 
1374             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1375             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1376             uint256 nextTokenId = tokenId + 1;
1377             if (_ownerships[nextTokenId].addr == address(0)) {
1378                 // This will suffice for checking _exists(nextTokenId),
1379                 // as a burned slot cannot contain the zero address.
1380                 if (nextTokenId < _currentIndex) {
1381                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1382                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1383                 }
1384             }
1385         }
1386 
1387         emit Transfer(prevOwnership.addr, address(0), tokenId);
1388         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1389 
1390         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1391         unchecked {
1392             _burnCounter++;
1393         }
1394     }
1395 
1396     /**
1397      * @dev Approve `to` to operate on `tokenId`
1398      *
1399      * Emits a {Approval} event.
1400      */
1401     function _approve(
1402         address to,
1403         uint256 tokenId,
1404         address owner
1405     ) private {
1406         _tokenApprovals[tokenId] = to;
1407         emit Approval(owner, to, tokenId);
1408     }
1409 
1410     /**
1411      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1412      *
1413      * @param from address representing the previous owner of the given token ID
1414      * @param to target address that will receive the tokens
1415      * @param tokenId uint256 ID of the token to be transferred
1416      * @param _data bytes optional data to send along with the call
1417      * @return bool whether the call correctly returned the expected magic value
1418      */
1419     function _checkContractOnERC721Received(
1420         address from,
1421         address to,
1422         uint256 tokenId,
1423         bytes memory _data
1424     ) private returns (bool) {
1425         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1426             return retval == IERC721Receiver(to).onERC721Received.selector;
1427         } catch (bytes memory reason) {
1428             if (reason.length == 0) {
1429                 revert TransferToNonERC721ReceiverImplementer();
1430             } else {
1431                 assembly {
1432                     revert(add(32, reason), mload(reason))
1433                 }
1434             }
1435         }
1436     }
1437 
1438     /**
1439      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1440      * And also called before burning one token.
1441      *
1442      * startTokenId - the first token id to be transferred
1443      * quantity - the amount to be transferred
1444      *
1445      * Calling conditions:
1446      *
1447      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1448      * transferred to `to`.
1449      * - When `from` is zero, `tokenId` will be minted for `to`.
1450      * - When `to` is zero, `tokenId` will be burned by `from`.
1451      * - `from` and `to` are never both zero.
1452      */
1453     function _beforeTokenTransfers(
1454         address from,
1455         address to,
1456         uint256 startTokenId,
1457         uint256 quantity
1458     ) internal virtual {}
1459 
1460     /**
1461      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1462      * minting.
1463      * And also called after one token has been burned.
1464      *
1465      * startTokenId - the first token id to be transferred
1466      * quantity - the amount to be transferred
1467      *
1468      * Calling conditions:
1469      *
1470      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1471      * transferred to `to`.
1472      * - When `from` is zero, `tokenId` has been minted for `to`.
1473      * - When `to` is zero, `tokenId` has been burned by `from`.
1474      * - `from` and `to` are never both zero.
1475      */
1476     function _afterTokenTransfers(
1477         address from,
1478         address to,
1479         uint256 startTokenId,
1480         uint256 quantity
1481     ) internal virtual {}
1482 }
1483 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
1484 
1485 
1486 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
1487 
1488 pragma solidity ^0.8.0;
1489 
1490 
1491 
1492 
1493 /**
1494  * @title PaymentSplitter
1495  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1496  * that the Ether will be split in this way, since it is handled transparently by the contract.
1497  *
1498  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1499  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1500  * an amount proportional to the percentage of total shares they were assigned.
1501  *
1502  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1503  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1504  * function.
1505  *
1506  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1507  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1508  * to run tests before sending real value to this contract.
1509  */
1510 contract PaymentSplitter is Context {
1511     event PayeeAdded(address account, uint256 shares);
1512     event PaymentReleased(address to, uint256 amount);
1513     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1514     event PaymentReceived(address from, uint256 amount);
1515 
1516     uint256 private _totalShares;
1517     uint256 private _totalReleased;
1518 
1519     mapping(address => uint256) private _shares;
1520     mapping(address => uint256) private _released;
1521     address[] private _payees;
1522 
1523     mapping(IERC20 => uint256) private _erc20TotalReleased;
1524     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1525 
1526     /**
1527      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1528      * the matching position in the `shares` array.
1529      *
1530      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1531      * duplicates in `payees`.
1532      */
1533     constructor(address[] memory payees, uint256[] memory shares_) payable {
1534         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1535         require(payees.length > 0, "PaymentSplitter: no payees");
1536 
1537         for (uint256 i = 0; i < payees.length; i++) {
1538             _addPayee(payees[i], shares_[i]);
1539         }
1540     }
1541 
1542     /**
1543      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1544      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1545      * reliability of the events, and not the actual splitting of Ether.
1546      *
1547      * To learn more about this see the Solidity documentation for
1548      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1549      * functions].
1550      */
1551     receive() external payable virtual {
1552         emit PaymentReceived(_msgSender(), msg.value);
1553     }
1554 
1555     /**
1556      * @dev Getter for the total shares held by payees.
1557      */
1558     function totalShares() public view returns (uint256) {
1559         return _totalShares;
1560     }
1561 
1562     /**
1563      * @dev Getter for the total amount of Ether already released.
1564      */
1565     function totalReleased() public view returns (uint256) {
1566         return _totalReleased;
1567     }
1568 
1569     /**
1570      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1571      * contract.
1572      */
1573     function totalReleased(IERC20 token) public view returns (uint256) {
1574         return _erc20TotalReleased[token];
1575     }
1576 
1577     /**
1578      * @dev Getter for the amount of shares held by an account.
1579      */
1580     function shares(address account) public view returns (uint256) {
1581         return _shares[account];
1582     }
1583 
1584     /**
1585      * @dev Getter for the amount of Ether already released to a payee.
1586      */
1587     function released(address account) public view returns (uint256) {
1588         return _released[account];
1589     }
1590 
1591     /**
1592      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1593      * IERC20 contract.
1594      */
1595     function released(IERC20 token, address account) public view returns (uint256) {
1596         return _erc20Released[token][account];
1597     }
1598 
1599     /**
1600      * @dev Getter for the address of the payee number `index`.
1601      */
1602     function payee(uint256 index) public view returns (address) {
1603         return _payees[index];
1604     }
1605 
1606     /**
1607      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1608      * total shares and their previous withdrawals.
1609      */
1610     function release(address payable account) public virtual {
1611         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1612 
1613         uint256 totalReceived = address(this).balance + totalReleased();
1614         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1615 
1616         require(payment != 0, "PaymentSplitter: account is not due payment");
1617 
1618         _released[account] += payment;
1619         _totalReleased += payment;
1620 
1621         Address.sendValue(account, payment);
1622         emit PaymentReleased(account, payment);
1623     }
1624 
1625     /**
1626      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1627      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1628      * contract.
1629      */
1630     function release(IERC20 token, address account) public virtual {
1631         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1632 
1633         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1634         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1635 
1636         require(payment != 0, "PaymentSplitter: account is not due payment");
1637 
1638         _erc20Released[token][account] += payment;
1639         _erc20TotalReleased[token] += payment;
1640 
1641         SafeERC20.safeTransfer(token, account, payment);
1642         emit ERC20PaymentReleased(token, account, payment);
1643     }
1644 
1645     /**
1646      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1647      * already released amounts.
1648      */
1649     function _pendingPayment(
1650         address account,
1651         uint256 totalReceived,
1652         uint256 alreadyReleased
1653     ) private view returns (uint256) {
1654         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1655     }
1656 
1657     /**
1658      * @dev Add a new payee to the contract.
1659      * @param account The address of the payee to add.
1660      * @param shares_ The number of shares owned by the payee.
1661      */
1662     function _addPayee(address account, uint256 shares_) private {
1663         require(account != address(0), "PaymentSplitter: account is the zero address");
1664         require(shares_ > 0, "PaymentSplitter: shares are 0");
1665         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1666 
1667         _payees.push(account);
1668         _shares[account] = shares_;
1669         _totalShares = _totalShares + shares_;
1670         emit PayeeAdded(account, shares_);
1671     }
1672 }
1673 
1674 // File: @openzeppelin/contracts/access/Ownable.sol
1675 
1676 
1677 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1678 
1679 pragma solidity ^0.8.0;
1680 
1681 
1682 /**
1683  * @dev Contract module which provides a basic access control mechanism, where
1684  * there is an account (an owner) that can be granted exclusive access to
1685  * specific functions.
1686  *
1687  * By default, the owner account will be the one that deploys the contract. This
1688  * can later be changed with {transferOwnership}.
1689  *
1690  * This module is used through inheritance. It will make available the modifier
1691  * `onlyOwner`, which can be applied to your functions to restrict their use to
1692  * the owner.
1693  */
1694 abstract contract Ownable is Context {
1695     address private _owner;
1696 
1697     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1698 
1699     /**
1700      * @dev Initializes the contract setting the deployer as the initial owner.
1701      */
1702     constructor() {
1703         _transferOwnership(_msgSender());
1704     }
1705 
1706     /**
1707      * @dev Returns the address of the current owner.
1708      */
1709     function owner() public view virtual returns (address) {
1710         return _owner;
1711     }
1712 
1713     /**
1714      * @dev Throws if called by any account other than the owner.
1715      */
1716     modifier onlyOwner() {
1717         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1718         _;
1719     }
1720 
1721     /**
1722      * @dev Leaves the contract without owner. It will not be possible to call
1723      * `onlyOwner` functions anymore. Can only be called by the current owner.
1724      *
1725      * NOTE: Renouncing ownership will leave the contract without an owner,
1726      * thereby removing any functionality that is only available to the owner.
1727      */
1728     function renounceOwnership() public virtual onlyOwner {
1729         _transferOwnership(address(0));
1730     }
1731 
1732     /**
1733      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1734      * Can only be called by the current owner.
1735      */
1736     function transferOwnership(address newOwner) public virtual onlyOwner {
1737         require(newOwner != address(0), "Ownable: new owner is the zero address");
1738         _transferOwnership(newOwner);
1739     }
1740 
1741     /**
1742      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1743      * Internal function without access restriction.
1744      */
1745     function _transferOwnership(address newOwner) internal virtual {
1746         address oldOwner = _owner;
1747         _owner = newOwner;
1748         emit OwnershipTransferred(oldOwner, newOwner);
1749     }
1750 }
1751 
1752 // File: contracts/bananz.sol
1753 
1754 
1755 
1756 pragma solidity ^0.8.4;
1757 
1758 
1759 
1760 
1761 
1762 
1763 contract BananaLandz is Ownable, ERC721A, PaymentSplitter {
1764     string private _baseTokenURI;
1765 
1766     constructor() ERC721A("BananaLandz", "BANANALANDZ") PaymentSplitter(_splitterAddressList, _shareList) {}
1767 
1768     //CONSTANTS
1769     uint256 PRICE = .00420 ether;
1770     uint256 MAX_TXN = 5;
1771     uint256 MAX_MINT = 20;
1772     uint256 COLLECTION_SIZE = 3333;
1773     uint256 FREE_AMOUNT = 700;
1774 
1775     //STATE
1776     bool isLive = false;
1777     mapping(address => uint256) public amountMinted;
1778 
1779     //PAYMENT
1780     address[] private _splitterAddressList = [
1781         0x755698050f8DE8d77F2924062119cee2f82ADA86,
1782         0x0370448FE7E1A8724e05c574760a4ec84Af67211,
1783         0x9cE2591D44f5fE9159e6CC772E65DFfA570Cdd30,
1784         0x670343130f750Fd0a07fa2eF003D056A9A8a3145,
1785         0x8DB842F23fda4AAFb96427d224B7353737E3e7bF
1786     ];
1787     uint256[] private _shareList = [20,20,20,20,20];
1788 
1789     function mint(uint256 mintAmount)
1790         public
1791         payable
1792     {
1793         uint256 totalSupply_ = totalSupply();
1794         require(isLive, "Mint not open!");
1795         require(mintAmount > 0, "Mint Amount Incorrect");
1796         require(totalSupply_ + mintAmount < COLLECTION_SIZE + 1, "Reached max supply");
1797         require(mintAmount + amountMinted[msg.sender] < MAX_MINT + 1, "Exceeds per wallet amount");
1798         require(mintAmount < MAX_TXN + 1, "Exceeds max per txn");
1799 
1800         //FREE MINTS -> PARTIAL -> PAID
1801         if(totalSupply_ + mintAmount < FREE_AMOUNT + 1){
1802         }
1803         else if(totalSupply_ < FREE_AMOUNT && totalSupply_ + mintAmount > FREE_AMOUNT){
1804             require(msg.value >= ((totalSupply_ + mintAmount) - FREE_AMOUNT) * PRICE);
1805         }
1806         else{
1807             require(msg.value >= mintAmount * PRICE, "ETH amount incorrect");
1808         }
1809 
1810         amountMinted[msg.sender] += mintAmount;
1811         _safeMint(msg.sender, mintAmount);
1812     }
1813 
1814     function _baseURI() internal view virtual override returns (string memory) {
1815         return _baseTokenURI;
1816     }
1817 
1818     //ADMIN
1819     function devMint(address to, uint256 mintAmount) external onlyOwner {
1820         _safeMint(to, mintAmount);
1821     }
1822 
1823     function setBaseURI(string calldata baseURI) external onlyOwner {
1824         _baseTokenURI = baseURI;
1825     }
1826 
1827     function setMintState(bool active) external onlyOwner{
1828         isLive = active;
1829     }
1830 }