1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Trees proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  */
18 library MerkleProof {
19     /**
20      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
21      * defined by `root`. For this, a `proof` must be provided, containing
22      * sibling hashes on the branch from the leaf to the root of the tree. Each
23      * pair of leaves and each pair of pre-images are assumed to be sorted.
24      */
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
35      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
36      * hash matches the root of the tree. When processing the proof, the pairs
37      * of leafs & pre-images are assumed to be sorted.
38      *
39      * _Available since v4.4._
40      */
41     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
42         bytes32 computedHash = leaf;
43         for (uint256 i = 0; i < proof.length; i++) {
44             bytes32 proofElement = proof[i];
45             if (computedHash <= proofElement) {
46                 // Hash(current computed hash + current element of the proof)
47                 computedHash = _efficientHash(computedHash, proofElement);
48             } else {
49                 // Hash(current element of the proof + current computed hash)
50                 computedHash = _efficientHash(proofElement, computedHash);
51             }
52         }
53         return computedHash;
54     }
55 
56     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
57         assembly {
58             mstore(0x00, a)
59             mstore(0x20, b)
60             value := keccak256(0x00, 0x40)
61         }
62     }
63 }
64 
65 // File: @openzeppelin/contracts/utils/Strings.sol
66 
67 
68 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev String operations.
74  */
75 library Strings {
76     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
80      */
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT licence
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
105      */
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
121      */
122     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
123         bytes memory buffer = new bytes(2 * length + 2);
124         buffer[0] = "0";
125         buffer[1] = "x";
126         for (uint256 i = 2 * length + 1; i > 1; --i) {
127             buffer[i] = _HEX_SYMBOLS[value & 0xf];
128             value >>= 4;
129         }
130         require(value == 0, "Strings: hex length insufficient");
131         return string(buffer);
132     }
133 }
134 
135 // File: @openzeppelin/contracts/utils/Context.sol
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev Provides information about the current execution context, including the
144  * sender of the transaction and its data. While these are generally available
145  * via msg.sender and msg.data, they should not be accessed in such a direct
146  * manner, since when dealing with meta-transactions the account sending and
147  * paying for execution may not be the actual sender (as far as an application
148  * is concerned).
149  *
150  * This contract is only required for intermediate, library-like contracts.
151  */
152 abstract contract Context {
153     function _msgSender() internal view virtual returns (address) {
154         return msg.sender;
155     }
156 
157     function _msgData() internal view virtual returns (bytes calldata) {
158         return msg.data;
159     }
160 }
161 
162 // File: @openzeppelin/contracts/access/Ownable.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 
170 /**
171  * @dev Contract module which provides a basic access control mechanism, where
172  * there is an account (an owner) that can be granted exclusive access to
173  * specific functions.
174  *
175  * By default, the owner account will be the one that deploys the contract. This
176  * can later be changed with {transferOwnership}.
177  *
178  * This module is used through inheritance. It will make available the modifier
179  * `onlyOwner`, which can be applied to your functions to restrict their use to
180  * the owner.
181  */
182 abstract contract Ownable is Context {
183     address private _owner;
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187     /**
188      * @dev Initializes the contract setting the deployer as the initial owner.
189      */
190     constructor() {
191         _transferOwnership(_msgSender());
192     }
193 
194     /**
195      * @dev Returns the address of the current owner.
196      */
197     function owner() public view virtual returns (address) {
198         return _owner;
199     }
200 
201     /**
202      * @dev Throws if called by any account other than the owner.
203      */
204     modifier onlyOwner() {
205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
206         _;
207     }
208 
209     /**
210      * @dev Leaves the contract without owner. It will not be possible to call
211      * `onlyOwner` functions anymore. Can only be called by the current owner.
212      *
213      * NOTE: Renouncing ownership will leave the contract without an owner,
214      * thereby removing any functionality that is only available to the owner.
215      */
216     function renounceOwnership() public virtual onlyOwner {
217         _transferOwnership(address(0));
218     }
219 
220     /**
221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
222      * Can only be called by the current owner.
223      */
224     function transferOwnership(address newOwner) public virtual onlyOwner {
225         require(newOwner != address(0), "Ownable: new owner is the zero address");
226         _transferOwnership(newOwner);
227     }
228 
229     /**
230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
231      * Internal function without access restriction.
232      */
233     function _transferOwnership(address newOwner) internal virtual {
234         address oldOwner = _owner;
235         _owner = newOwner;
236         emit OwnershipTransferred(oldOwner, newOwner);
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Address.sol
241 
242 
243 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
244 
245 pragma solidity ^0.8.1;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      *
268      * [IMPORTANT]
269      * ====
270      * You shouldn't rely on `isContract` to protect against flash loan attacks!
271      *
272      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
273      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
274      * constructor.
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // This method relies on extcodesize/address.code.length, which returns 0
279         // for contracts in construction, since the code is only stored at the end
280         // of the constructor execution.
281 
282         return account.code.length > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         (bool success, ) = recipient.call{value: amount}("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain `call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         require(isContract(target), "Address: call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.call{value: value}(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
389         return functionStaticCall(target, data, "Address: low-level static call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal view returns (bytes memory) {
403         require(isContract(target), "Address: static call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.staticcall(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(isContract(target), "Address: delegate call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.delegatecall(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
438      * revert reason using the provided one.
439      *
440      * _Available since v4.3._
441      */
442     function verifyCallResult(
443         bool success,
444         bytes memory returndata,
445         string memory errorMessage
446     ) internal pure returns (bytes memory) {
447         if (success) {
448             return returndata;
449         } else {
450             // Look for revert reason and bubble it up if present
451             if (returndata.length > 0) {
452                 // The easiest way to bubble the revert reason is using memory via assembly
453 
454                 assembly {
455                     let returndata_size := mload(returndata)
456                     revert(add(32, returndata), returndata_size)
457                 }
458             } else {
459                 revert(errorMessage);
460             }
461         }
462     }
463 }
464 
465 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
466 
467 
468 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @title ERC721 token receiver interface
474  * @dev Interface for any contract that wants to support safeTransfers
475  * from ERC721 asset contracts.
476  */
477 interface IERC721Receiver {
478     /**
479      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
480      * by `operator` from `from`, this function is called.
481      *
482      * It must return its Solidity selector to confirm the token transfer.
483      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
484      *
485      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
486      */
487     function onERC721Received(
488         address operator,
489         address from,
490         uint256 tokenId,
491         bytes calldata data
492     ) external returns (bytes4);
493 }
494 
495 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Interface of the ERC165 standard, as defined in the
504  * https://eips.ethereum.org/EIPS/eip-165[EIP].
505  *
506  * Implementers can declare support of contract interfaces, which can then be
507  * queried by others ({ERC165Checker}).
508  *
509  * For an implementation, see {ERC165}.
510  */
511 interface IERC165 {
512     /**
513      * @dev Returns true if this contract implements the interface defined by
514      * `interfaceId`. See the corresponding
515      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
516      * to learn more about how these ids are created.
517      *
518      * This function call must use less than 30 000 gas.
519      */
520     function supportsInterface(bytes4 interfaceId) external view returns (bool);
521 }
522 
523 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
524 
525 
526 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 
531 /**
532  * @dev Implementation of the {IERC165} interface.
533  *
534  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
535  * for the additional interface id that will be supported. For example:
536  *
537  * ```solidity
538  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
540  * }
541  * ```
542  *
543  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
544  */
545 abstract contract ERC165 is IERC165 {
546     /**
547      * @dev See {IERC165-supportsInterface}.
548      */
549     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550         return interfaceId == type(IERC165).interfaceId;
551     }
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 
562 /**
563  * @dev Required interface of an ERC721 compliant contract.
564  */
565 interface IERC721 is IERC165 {
566     /**
567      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
568      */
569     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
570 
571     /**
572      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
573      */
574     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
575 
576     /**
577      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
578      */
579     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
580 
581     /**
582      * @dev Returns the number of tokens in ``owner``'s account.
583      */
584     function balanceOf(address owner) external view returns (uint256 balance);
585 
586     /**
587      * @dev Returns the owner of the `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function ownerOf(uint256 tokenId) external view returns (address owner);
594 
595     /**
596      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
597      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must exist and be owned by `from`.
604      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
606      *
607      * Emits a {Transfer} event.
608      */
609     function safeTransferFrom(
610         address from,
611         address to,
612         uint256 tokenId
613     ) external;
614 
615     /**
616      * @dev Transfers `tokenId` token from `from` to `to`.
617      *
618      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must be owned by `from`.
625      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
626      *
627      * Emits a {Transfer} event.
628      */
629     function transferFrom(
630         address from,
631         address to,
632         uint256 tokenId
633     ) external;
634 
635     /**
636      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
637      * The approval is cleared when the token is transferred.
638      *
639      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
640      *
641      * Requirements:
642      *
643      * - The caller must own the token or be an approved operator.
644      * - `tokenId` must exist.
645      *
646      * Emits an {Approval} event.
647      */
648     function approve(address to, uint256 tokenId) external;
649 
650     /**
651      * @dev Returns the account approved for `tokenId` token.
652      *
653      * Requirements:
654      *
655      * - `tokenId` must exist.
656      */
657     function getApproved(uint256 tokenId) external view returns (address operator);
658 
659     /**
660      * @dev Approve or remove `operator` as an operator for the caller.
661      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
662      *
663      * Requirements:
664      *
665      * - The `operator` cannot be the caller.
666      *
667      * Emits an {ApprovalForAll} event.
668      */
669     function setApprovalForAll(address operator, bool _approved) external;
670 
671     /**
672      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
673      *
674      * See {setApprovalForAll}
675      */
676     function isApprovedForAll(address owner, address operator) external view returns (bool);
677 
678     /**
679      * @dev Safely transfers `tokenId` token from `from` to `to`.
680      *
681      * Requirements:
682      *
683      * - `from` cannot be the zero address.
684      * - `to` cannot be the zero address.
685      * - `tokenId` token must exist and be owned by `from`.
686      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
687      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
688      *
689      * Emits a {Transfer} event.
690      */
691     function safeTransferFrom(
692         address from,
693         address to,
694         uint256 tokenId,
695         bytes calldata data
696     ) external;
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
700 
701 
702 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
709  * @dev See https://eips.ethereum.org/EIPS/eip-721
710  */
711 interface IERC721Enumerable is IERC721 {
712     /**
713      * @dev Returns the total amount of tokens stored by the contract.
714      */
715     function totalSupply() external view returns (uint256);
716 
717     /**
718      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
719      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
720      */
721     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
722 
723     /**
724      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
725      * Use along with {totalSupply} to enumerate all tokens.
726      */
727     function tokenByIndex(uint256 index) external view returns (uint256);
728 }
729 
730 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
731 
732 
733 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
734 
735 pragma solidity ^0.8.0;
736 
737 
738 /**
739  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
740  * @dev See https://eips.ethereum.org/EIPS/eip-721
741  */
742 interface IERC721Metadata is IERC721 {
743     /**
744      * @dev Returns the token collection name.
745      */
746     function name() external view returns (string memory);
747 
748     /**
749      * @dev Returns the token collection symbol.
750      */
751     function symbol() external view returns (string memory);
752 
753     /**
754      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
755      */
756     function tokenURI(uint256 tokenId) external view returns (string memory);
757 }
758 
759 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
760 
761 
762 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 
767 
768 
769 
770 
771 
772 
773 /**
774  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
775  * the Metadata extension, but not including the Enumerable extension, which is available separately as
776  * {ERC721Enumerable}.
777  */
778 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
779     using Address for address;
780     using Strings for uint256;
781 
782     // Token name
783     string private _name;
784 
785     // Token symbol
786     string private _symbol;
787 
788     // Mapping from token ID to owner address
789     mapping(uint256 => address) private _owners;
790 
791     // Mapping owner address to token count
792     mapping(address => uint256) private _balances;
793 
794     // Mapping from token ID to approved address
795     mapping(uint256 => address) private _tokenApprovals;
796 
797     // Mapping from owner to operator approvals
798     mapping(address => mapping(address => bool)) private _operatorApprovals;
799 
800     /**
801      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
802      */
803     constructor(string memory name_, string memory symbol_) {
804         _name = name_;
805         _symbol = symbol_;
806     }
807 
808     /**
809      * @dev See {IERC165-supportsInterface}.
810      */
811     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
812         return
813             interfaceId == type(IERC721).interfaceId ||
814             interfaceId == type(IERC721Metadata).interfaceId ||
815             super.supportsInterface(interfaceId);
816     }
817 
818     /**
819      * @dev See {IERC721-balanceOf}.
820      */
821     function balanceOf(address owner) public view virtual override returns (uint256) {
822         require(owner != address(0), "ERC721: balance query for the zero address");
823         return _balances[owner];
824     }
825 
826     /**
827      * @dev See {IERC721-ownerOf}.
828      */
829     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
830         address owner = _owners[tokenId];
831         require(owner != address(0), "ERC721: owner query for nonexistent token");
832         return owner;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-name}.
837      */
838     function name() public view virtual override returns (string memory) {
839         return _name;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-symbol}.
844      */
845     function symbol() public view virtual override returns (string memory) {
846         return _symbol;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-tokenURI}.
851      */
852     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
853         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
854 
855         return _baseURI();
856     }
857 
858     /**
859      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
860      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
861      * by default, can be overriden in child contracts.
862      */
863     function _baseURI() internal view virtual returns (string memory) {
864         return "";
865     }
866 
867     /**
868      * @dev See {IERC721-approve}.
869      */
870     function approve(address to, uint256 tokenId) public virtual override {
871         address owner = ERC721.ownerOf(tokenId);
872         require(to != owner, "ERC721: approval to current owner");
873 
874         require(
875             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
876             "ERC721: approve caller is not owner nor approved for all"
877         );
878 
879         _approve(to, tokenId);
880     }
881 
882     /**
883      * @dev See {IERC721-getApproved}.
884      */
885     function getApproved(uint256 tokenId) public view virtual override returns (address) {
886         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
887 
888         return _tokenApprovals[tokenId];
889     }
890 
891     /**
892      * @dev See {IERC721-setApprovalForAll}.
893      */
894     function setApprovalForAll(address operator, bool approved) public virtual override {
895         _setApprovalForAll(_msgSender(), operator, approved);
896     }
897 
898     /**
899      * @dev See {IERC721-isApprovedForAll}.
900      */
901     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
902         return _operatorApprovals[owner][operator];
903     }
904 
905     /**
906      * @dev See {IERC721-transferFrom}.
907      */
908     function transferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public virtual override {
913         //solhint-disable-next-line max-line-length
914         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
915 
916         _transfer(from, to, tokenId);
917     }
918 
919     /**
920      * @dev See {IERC721-safeTransferFrom}.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId
926     ) public virtual override {
927         safeTransferFrom(from, to, tokenId, "");
928     }
929 
930     /**
931      * @dev See {IERC721-safeTransferFrom}.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId,
937         bytes memory _data
938     ) public virtual override {
939         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
940         _safeTransfer(from, to, tokenId, _data);
941     }
942 
943     /**
944      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
945      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
946      *
947      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
948      *
949      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
950      * implement alternative mechanisms to perform token transfer, such as signature-based.
951      *
952      * Requirements:
953      *
954      * - `from` cannot be the zero address.
955      * - `to` cannot be the zero address.
956      * - `tokenId` token must exist and be owned by `from`.
957      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _safeTransfer(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes memory _data
966     ) internal virtual {
967         _transfer(from, to, tokenId);
968         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
969     }
970 
971     /**
972      * @dev Returns whether `tokenId` exists.
973      *
974      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
975      *
976      * Tokens start existing when they are minted (`_mint`),
977      * and stop existing when they are burned (`_burn`).
978      */
979     function _exists(uint256 tokenId) internal view virtual returns (bool) {
980         return _owners[tokenId] != address(0);
981     }
982 
983     /**
984      * @dev Returns whether `spender` is allowed to manage `tokenId`.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      */
990     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
991         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
992         address owner = ERC721.ownerOf(tokenId);
993         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
994     }
995 
996     /**
997      * @dev Safely mints `tokenId` and transfers it to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must not exist.
1002      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _safeMint(address to, uint256 tokenId) internal virtual {
1007         _safeMint(to, tokenId, "");
1008     }
1009 
1010     /**
1011      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1012      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1013      */
1014     function _safeMint(
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) internal virtual {
1019         _mint(to, tokenId);
1020         require(
1021             _checkOnERC721Received(address(0), to, tokenId, _data),
1022             "ERC721: transfer to non ERC721Receiver implementer"
1023         );
1024     }
1025 
1026     /**
1027      * @dev Mints `tokenId` and transfers it to `to`.
1028      *
1029      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must not exist.
1034      * - `to` cannot be the zero address.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _mint(address to, uint256 tokenId) internal virtual {
1039         require(to != address(0), "ERC721: mint to the zero address");
1040         require(!_exists(tokenId), "ERC721: token already minted");
1041 
1042         _beforeTokenTransfer(address(0), to, tokenId);
1043 
1044         _balances[to] += 1;
1045         _owners[tokenId] = to;
1046 
1047         emit Transfer(address(0), to, tokenId);
1048 
1049         _afterTokenTransfer(address(0), to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev Destroys `tokenId`.
1054      * The approval is cleared when the token is burned.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must exist.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _burn(uint256 tokenId) internal virtual {
1063         address owner = ERC721.ownerOf(tokenId);
1064 
1065         _beforeTokenTransfer(owner, address(0), tokenId);
1066 
1067         // Clear approvals
1068         _approve(address(0), tokenId);
1069 
1070         _balances[owner] -= 1;
1071         delete _owners[tokenId];
1072 
1073         emit Transfer(owner, address(0), tokenId);
1074 
1075         _afterTokenTransfer(owner, address(0), tokenId);
1076     }
1077 
1078     /**
1079      * @dev Transfers `tokenId` from `from` to `to`.
1080      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1081      *
1082      * Requirements:
1083      *
1084      * - `to` cannot be the zero address.
1085      * - `tokenId` token must be owned by `from`.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _transfer(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) internal virtual {
1094         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1095         require(to != address(0), "ERC721: transfer to the zero address");
1096 
1097         _beforeTokenTransfer(from, to, tokenId);
1098 
1099         // Clear approvals from the previous owner
1100         _approve(address(0), tokenId);
1101 
1102         _balances[from] -= 1;
1103         _balances[to] += 1;
1104         _owners[tokenId] = to;
1105 
1106         emit Transfer(from, to, tokenId);
1107 
1108         _afterTokenTransfer(from, to, tokenId);
1109     }
1110 
1111     /**
1112      * @dev Approve `to` to operate on `tokenId`
1113      *
1114      * Emits a {Approval} event.
1115      */
1116     function _approve(address to, uint256 tokenId) internal virtual {
1117         _tokenApprovals[tokenId] = to;
1118         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1119     }
1120 
1121     /**
1122      * @dev Approve `operator` to operate on all of `owner` tokens
1123      *
1124      * Emits a {ApprovalForAll} event.
1125      */
1126     function _setApprovalForAll(
1127         address owner,
1128         address operator,
1129         bool approved
1130     ) internal virtual {
1131         require(owner != operator, "ERC721: approve to caller");
1132         _operatorApprovals[owner][operator] = approved;
1133         emit ApprovalForAll(owner, operator, approved);
1134     }
1135 
1136     /**
1137      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1138      * The call is not executed if the target address is not a contract.
1139      *
1140      * @param from address representing the previous owner of the given token ID
1141      * @param to target address that will receive the tokens
1142      * @param tokenId uint256 ID of the token to be transferred
1143      * @param _data bytes optional data to send along with the call
1144      * @return bool whether the call correctly returned the expected magic value
1145      */
1146     function _checkOnERC721Received(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory _data
1151     ) private returns (bool) {
1152         if (to.isContract()) {
1153             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1154                 return retval == IERC721Receiver.onERC721Received.selector;
1155             } catch (bytes memory reason) {
1156                 if (reason.length == 0) {
1157                     revert("ERC721: transfer to non ERC721Receiver implementer");
1158                 } else {
1159                     assembly {
1160                         revert(add(32, reason), mload(reason))
1161                     }
1162                 }
1163             }
1164         } else {
1165             return true;
1166         }
1167     }
1168 
1169     /**
1170      * @dev Hook that is called before any token transfer. This includes minting
1171      * and burning.
1172      *
1173      * Calling conditions:
1174      *
1175      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1176      * transferred to `to`.
1177      * - When `from` is zero, `tokenId` will be minted for `to`.
1178      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1179      * - `from` and `to` are never both zero.
1180      *
1181      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1182      */
1183     function _beforeTokenTransfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) internal virtual {}
1188 
1189     /**
1190      * @dev Hook that is called after any transfer of tokens. This includes
1191      * minting and burning.
1192      *
1193      * Calling conditions:
1194      *
1195      * - when `from` and `to` are both non-zero.
1196      * - `from` and `to` are never both zero.
1197      *
1198      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1199      */
1200     function _afterTokenTransfer(
1201         address from,
1202         address to,
1203         uint256 tokenId
1204     ) internal virtual {}
1205 }
1206 
1207 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1208 
1209 
1210 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 
1215 
1216 /**
1217  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1218  * enumerability of all the token ids in the contract as well as all token ids owned by each
1219  * account.
1220  */
1221 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1222     // Mapping from owner to list of owned token IDs
1223     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1224 
1225     // Mapping from token ID to index of the owner tokens list
1226     mapping(uint256 => uint256) private _ownedTokensIndex;
1227 
1228     // Array with all token ids, used for enumeration
1229     uint256[] private _allTokens;
1230 
1231     // Mapping from token id to position in the allTokens array
1232     mapping(uint256 => uint256) private _allTokensIndex;
1233 
1234     /**
1235      * @dev See {IERC165-supportsInterface}.
1236      */
1237     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1238         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1239     }
1240 
1241     /**
1242      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1243      */
1244     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1245         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1246         return _ownedTokens[owner][index];
1247     }
1248 
1249     /**
1250      * @dev See {IERC721Enumerable-totalSupply}.
1251      */
1252     function totalSupply() public view virtual override returns (uint256) {
1253         return _allTokens.length;
1254     }
1255 
1256     /**
1257      * @dev See {IERC721Enumerable-tokenByIndex}.
1258      */
1259     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1260         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1261         return _allTokens[index];
1262     }
1263 
1264     /**
1265      * @dev Hook that is called before any token transfer. This includes minting
1266      * and burning.
1267      *
1268      * Calling conditions:
1269      *
1270      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1271      * transferred to `to`.
1272      * - When `from` is zero, `tokenId` will be minted for `to`.
1273      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1274      * - `from` cannot be the zero address.
1275      * - `to` cannot be the zero address.
1276      *
1277      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1278      */
1279     function _beforeTokenTransfer(
1280         address from,
1281         address to,
1282         uint256 tokenId
1283     ) internal virtual override {
1284         super._beforeTokenTransfer(from, to, tokenId);
1285 
1286         if (from == address(0)) {
1287             _addTokenToAllTokensEnumeration(tokenId);
1288         } else if (from != to) {
1289             _removeTokenFromOwnerEnumeration(from, tokenId);
1290         }
1291         if (to == address(0)) {
1292             _removeTokenFromAllTokensEnumeration(tokenId);
1293         } else if (to != from) {
1294             _addTokenToOwnerEnumeration(to, tokenId);
1295         }
1296     }
1297 
1298     /**
1299      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1300      * @param to address representing the new owner of the given token ID
1301      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1302      */
1303     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1304         uint256 length = ERC721.balanceOf(to);
1305         _ownedTokens[to][length] = tokenId;
1306         _ownedTokensIndex[tokenId] = length;
1307     }
1308 
1309     /**
1310      * @dev Private function to add a token to this extension's token tracking data structures.
1311      * @param tokenId uint256 ID of the token to be added to the tokens list
1312      */
1313     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1314         _allTokensIndex[tokenId] = _allTokens.length;
1315         _allTokens.push(tokenId);
1316     }
1317 
1318     /**
1319      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1320      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1321      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1322      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1323      * @param from address representing the previous owner of the given token ID
1324      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1325      */
1326     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1327         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1328         // then delete the last slot (swap and pop).
1329 
1330         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1331         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1332 
1333         // When the token to delete is the last token, the swap operation is unnecessary
1334         if (tokenIndex != lastTokenIndex) {
1335             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1336 
1337             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1338             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1339         }
1340 
1341         // This also deletes the contents at the last position of the array
1342         delete _ownedTokensIndex[tokenId];
1343         delete _ownedTokens[from][lastTokenIndex];
1344     }
1345 
1346     /**
1347      * @dev Private function to remove a token from this extension's token tracking data structures.
1348      * This has O(1) time complexity, but alters the order of the _allTokens array.
1349      * @param tokenId uint256 ID of the token to be removed from the tokens list
1350      */
1351     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1352         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1353         // then delete the last slot (swap and pop).
1354 
1355         uint256 lastTokenIndex = _allTokens.length - 1;
1356         uint256 tokenIndex = _allTokensIndex[tokenId];
1357 
1358         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1359         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1360         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1361         uint256 lastTokenId = _allTokens[lastTokenIndex];
1362 
1363         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1364         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1365 
1366         // This also deletes the contents at the last position of the array
1367         delete _allTokensIndex[tokenId];
1368         _allTokens.pop();
1369     }
1370 }
1371 
1372 pragma solidity ^0.8.0;
1373 
1374 /**
1375  * @dev Contract module that helps prevent reentrant calls to a function.
1376  *
1377  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1378  * available, which can be applied to functions to make sure there are no nested
1379  * (reentrant) calls to them.
1380  *
1381  * Note that because there is a single `nonReentrant` guard, functions marked as
1382  * `nonReentrant` may not call one another. This can be worked around by making
1383  * those functions `private`, and then adding `external` `nonReentrant` entry
1384  * points to them.
1385  *
1386  * TIP: If you would like to learn more about reentrancy and alternative ways
1387  * to protect against it, check out our blog post
1388  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1389  */
1390 abstract contract ReentrancyGuard {
1391     // Booleans are more expensive than uint256 or any type that takes up a full
1392     // word because each write operation emits an extra SLOAD to first read the
1393     // slot's contents, replace the bits taken up by the boolean, and then write
1394     // back. This is the compiler's defense against contract upgrades and
1395     // pointer aliasing, and it cannot be disabled.
1396 
1397     // The values being non-zero value makes deployment a bit more expensive,
1398     // but in exchange the refund on every call to nonReentrant will be lower in
1399     // amount. Since refunds are capped to a percentage of the total
1400     // transaction's gas, it is best to keep them low in cases like this one, to
1401     // increase the likelihood of the full refund coming into effect.
1402     uint256 private constant _NOT_ENTERED = 1;
1403     uint256 private constant _ENTERED = 2;
1404 
1405     uint256 private _status;
1406 
1407     constructor() {
1408         _status = _NOT_ENTERED;
1409     }
1410 
1411     /**
1412      * @dev Prevents a contract from calling itself, directly or indirectly.
1413      * Calling a `nonReentrant` function from another `nonReentrant`
1414      * function is not supported. It is possible to prevent this from happening
1415      * by making the `nonReentrant` function external, and make it call a
1416      * `private` function that does the actual work.
1417      */
1418     modifier nonReentrant() {
1419         // On the first call to nonReentrant, _notEntered will be true
1420         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1421 
1422         // Any calls to nonReentrant after this point will fail
1423         _status = _ENTERED;
1424 
1425         _;
1426 
1427         // By storing the original value once again, a refund is triggered (see
1428         // https://eips.ethereum.org/EIPS/eip-2200)
1429         _status = _NOT_ENTERED;
1430     }
1431 }
1432 
1433 // File: contracts/Metarelics.sol
1434 
1435 
1436 
1437 pragma solidity >=0.7.0 <0.9.0;
1438 
1439 
1440 
1441 
1442 contract Metarelics is ERC721Enumerable, Ownable, ReentrancyGuard {
1443 	using Strings for uint256;
1444 
1445 	string baseURI;
1446 	string baseExtension = ".json";
1447 	uint256 public cost = .2 ether;
1448 	uint256 public maxSupply = 1000;
1449 	uint256 public maxMintable = 1;
1450 	bool public paused = true;
1451 	bool public isSecondSale = false;
1452 	bool public isBackupSale = false;
1453 	mapping(address => uint256) public addressMintedBalance;
1454 	bytes32 public whitelistMerkleRoot;
1455 	mapping(address => bool) public whitelistedAddressesBackup;
1456 	bool public useWhitelistedAddressesBackup = false;
1457 	mapping(address => bool) public secondMintWinners;
1458 
1459 	constructor(
1460 		string memory _name,
1461 		string memory _symbol,
1462         string memory _URI
1463 	) ERC721(_name, _symbol) {
1464         baseURI = _URI;
1465 	}
1466 
1467 	// internal
1468 	function _baseURI() internal view virtual override returns (string memory) {
1469 		return baseURI;
1470 	}
1471 
1472 	function _generateMerkleLeaf(address account)
1473 		internal
1474 		pure
1475 		returns (bytes32)
1476 	{
1477 		return keccak256(abi.encodePacked(account));
1478 	}
1479 
1480 	/**
1481 	 * Validates a Merkle proof based on a provided merkle root and leaf node.
1482 	 */
1483 	function _verify(
1484 		bytes32[] memory proof,
1485 		bytes32 merkleRoot,
1486 		bytes32 leafNode
1487 	) internal pure returns (bool) {
1488 		return MerkleProof.verify(proof, merkleRoot, leafNode);
1489 	}
1490 
1491 
1492 	// Requires contract is not paused, the mint amount requested is at least 1,
1493 	// & the amount being minted + current supply is less than the max supply.
1494 	function requireChecks(uint256 _mintAmount) internal view {
1495 		require(paused == false, "the contract is paused");
1496 		require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
1497 	}
1498 
1499 	/**
1500 	 * Limit: 1 during presale
1501 	 * Only whitelisted individuals can mint presale. We utilize a Merkle Proof to determine who is whitelisted.
1502 	 * If these cases are not met, the mint WILL fail, and your gas will NOT be refunded.
1503 	 * Please only mint through metarelics.xyz unless you're absolutely sure you know what you're doing!
1504 	 */
1505 	function presaleMint(uint256 _mintAmount, bytes32[] calldata proof)
1506 		public
1507 		payable
1508         nonReentrant
1509 	{
1510 		uint256 supply = totalSupply();
1511 		requireChecks(_mintAmount);
1512 		// The owner of the smart contract can mint at any time, regardless of if the presale is on.
1513 		if (msg.sender != owner()) {
1514 			require (addressMintedBalance[msg.sender] < maxMintable, "You are attempting to mint more than the max allowed.");
1515 			require(msg.value >= cost, "insufficient funds");
1516 
1517 			// uses a traditional array for whitelist in the unlikely event the Merkle tree fails,
1518             // or if someone is unintentionally left out of the presale.  
1519 			if (useWhitelistedAddressesBackup) {
1520 				require(whitelistedAddressesBackup[msg.sender] == true, "user is not whitelisted");
1521 			} else {
1522 				require(
1523 					_verify(
1524 						proof,
1525 						whitelistMerkleRoot,
1526 						_generateMerkleLeaf(msg.sender)
1527 					),
1528 					"user is not whitelisted"
1529 				);
1530 			}
1531 
1532 			_safeMint(msg.sender, supply + 1);
1533 			addressMintedBalance[msg.sender]++;
1534 		} else {
1535 
1536 			// the owner of the contract can mint as many as they like.
1537 			for (uint256 i = 1; i <= _mintAmount; i++) {
1538 				addressMintedBalance[msg.sender]++;
1539 				_safeMint(msg.sender, supply + i);
1540 			}
1541 		}
1542 	}
1543 
1544 
1545 	// mint function for the 2nd wave of sales. Only selected addresses via raffle will be allowed to mint.
1546     // Raffle winners are allowed one extra mint.
1547 	// Owner can also only mint 1. Owner should always invoke presaleMint for minting multiple.
1548     // Call will fail if the contract is paused, if funds are insufficient, if the address invoking 
1549     // SecondaryMint is not eligible to mint, or if an eligible address has already successfully minted
1550     // using the secondaryMint.
1551 	function secondaryMint()
1552 		public
1553 		payable
1554         nonReentrant
1555 	{
1556 		uint256 supply = totalSupply();
1557         requireChecks(1);
1558 		if (msg.sender != owner()) {
1559 			require(msg.value >= cost, "insufficient funds");
1560 			require(secondMintWinners[msg.sender] == true); 
1561 			require(isSecondSale == true, "2nd sale wave not on");
1562 			require(
1563 				addressMintedBalance[msg.sender] == 0,
1564 				"max NFT per address exceeded"
1565 			);
1566 		}
1567 
1568 		_safeMint(msg.sender, supply + 1);
1569 		addressMintedBalance[msg.sender]++;
1570 	}
1571 
1572 	// backup mint function
1573 	function mint() 
1574 		public
1575 		payable
1576         nonReentrant
1577 	{
1578 		uint256 supply = totalSupply();
1579 		if (msg.sender != owner()) {
1580 			requireChecks(1);
1581             require(msg.value >= cost, "insufficient funds");
1582 			require(isBackupSale == true, "Main sale not available.");
1583 			require(addressMintedBalance[msg.sender] == 0, "max NFT per address is 1.");
1584 		}
1585 
1586 		_safeMint(msg.sender, supply + 1);
1587 		addressMintedBalance[msg.sender]++;
1588 	}
1589 
1590 	function walletOfOwner(address _owner)
1591 		public
1592 		view
1593 		returns (uint256[] memory)
1594 	{
1595 		uint256 ownerTokenCount = balanceOf(_owner);
1596 		uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1597 		for (uint256 i; i < ownerTokenCount; i++) {
1598 			tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1599 		}
1600 		return tokenIds;
1601 	}
1602 
1603 	function tokenURI()
1604 		public
1605 		view
1606 		virtual
1607 		returns (string memory)
1608 	{
1609 		return baseURI;
1610 	}
1611 
1612 	// Sets addresses that will be allowed to mint in the second wave.
1613     function setMintWinners(address[] memory winners) public onlyOwner {
1614 		for (uint256 i; i < winners.length; i++) {
1615 			secondMintWinners[winners[i]] = true;
1616 		}
1617     }
1618 
1619 	function setBackupSale(bool _state) public onlyOwner {
1620 		isBackupSale = _state;
1621 	}
1622 
1623 	function setSecondSale(bool _state) public onlyOwner {
1624 		isSecondSale = _state;
1625 	}
1626 
1627 	/** Sets the merkle root for the whitelisted individuals. */
1628 	function setWhiteListMerkleRoot(bytes32 merkleRoot) public onlyOwner {
1629 		whitelistMerkleRoot = merkleRoot;
1630 	}
1631 
1632 	function setWhitelistedAddressesBackup(address[] memory addresses) public onlyOwner {
1633 		for (uint256 i = 0; i < addresses.length; i++) {
1634 			whitelistedAddressesBackup[addresses[i]] = true;
1635 		}
1636 	}
1637 
1638 	function setBackupWhitelistedAddressState(bool state) public onlyOwner {
1639 		useWhitelistedAddressesBackup = state;
1640 	}
1641 
1642 	// cost in Wei
1643 	function setCost(uint256 _newCost) public onlyOwner {
1644 		cost = _newCost;
1645 	}
1646 
1647 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
1648 		baseURI = _newBaseURI;
1649 	}
1650 
1651 	function setBaseExtension(string memory _newBaseExtension)
1652 		public
1653 		onlyOwner
1654 	{
1655 		baseExtension = _newBaseExtension;
1656 	}
1657 
1658 	function pause(bool _state) public onlyOwner {
1659 		paused = _state;
1660 	}
1661 
1662 	function setMaxMintable(uint256 max) public onlyOwner {
1663 		maxMintable = max;
1664 	}
1665 
1666 	// Withdraws the Ethers in the smart contract to the wallet that specified in the smart contract.
1667 	function withdraw() public onlyOwner nonReentrant {
1668         uint256 balance = address(this).balance;
1669         payable(0x120Ee9220CcB8F594483D6e0D5300babb78FAaC7).transfer(balance);
1670 	}
1671 }