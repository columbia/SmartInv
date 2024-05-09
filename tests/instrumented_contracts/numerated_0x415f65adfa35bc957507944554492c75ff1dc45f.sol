1 // SPDX-License-Identifier: MIT
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
759 // File: erc721a/contracts/ERC721A.sol
760 
761 
762 // Creator: Chiru Labs
763 
764 pragma solidity ^0.8.4;
765 
766 
767 
768 
769 
770 
771 
772 
773 
774 error ApprovalCallerNotOwnerNorApproved();
775 error ApprovalQueryForNonexistentToken();
776 error ApproveToCaller();
777 error ApprovalToCurrentOwner();
778 error BalanceQueryForZeroAddress();
779 error MintedQueryForZeroAddress();
780 error BurnedQueryForZeroAddress();
781 error MintToZeroAddress();
782 error MintZeroQuantity();
783 error OwnerIndexOutOfBounds();
784 error OwnerQueryForNonexistentToken();
785 error TokenIndexOutOfBounds();
786 error TransferCallerNotOwnerNorApproved();
787 error TransferFromIncorrectOwner();
788 error TransferToNonERC721ReceiverImplementer();
789 error TransferToZeroAddress();
790 error URIQueryForNonexistentToken();
791 
792 /**
793  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
794  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
795  *
796  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
797  *
798  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
799  *
800  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
801  */
802 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
803     using Address for address;
804     using Strings for uint256;
805 
806     // Compiler will pack this into a single 256bit word.
807     struct TokenOwnership {
808         // The address of the owner.
809         address addr;
810         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
811         uint64 startTimestamp;
812         // Whether the token has been burned.
813         bool burned;
814     }
815 
816     // Compiler will pack this into a single 256bit word.
817     struct AddressData {
818         // Realistically, 2**64-1 is more than enough.
819         uint64 balance;
820         // Keeps track of mint count with minimal overhead for tokenomics.
821         uint64 numberMinted;
822         // Keeps track of burn count with minimal overhead for tokenomics.
823         uint64 numberBurned;
824     }
825 
826     // Compiler will pack the following 
827     // _currentIndex and _burnCounter into a single 256bit word.
828     
829     // The tokenId of the next token to be minted.
830     uint128 internal _currentIndex;
831 
832     // The number of tokens burned.
833     uint128 internal _burnCounter;
834 
835     // Token name
836     string private _name;
837 
838     // Token symbol
839     string private _symbol;
840 
841     // Mapping from token ID to ownership details
842     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
843     mapping(uint256 => TokenOwnership) internal _ownerships;
844 
845     // Mapping owner address to address data
846     mapping(address => AddressData) private _addressData;
847 
848     // Mapping from token ID to approved address
849     mapping(uint256 => address) private _tokenApprovals;
850 
851     // Mapping from owner to operator approvals
852     mapping(address => mapping(address => bool)) private _operatorApprovals;
853 
854     constructor(string memory name_, string memory symbol_) {
855         _name = name_;
856         _symbol = symbol_;
857     }
858 
859     /**
860      * @dev See {IERC721Enumerable-totalSupply}.
861      */
862     function totalSupply() public view override returns (uint256) {
863         // Counter underflow is impossible as _burnCounter cannot be incremented
864         // more than _currentIndex times
865         unchecked {
866             return _currentIndex - _burnCounter;    
867         }
868     }
869 
870     /**
871      * @dev See {IERC721Enumerable-tokenByIndex}.
872      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
873      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
874      */
875     function tokenByIndex(uint256 index) public view override returns (uint256) {
876         uint256 numMintedSoFar = _currentIndex;
877         uint256 tokenIdsIdx;
878 
879         // Counter overflow is impossible as the loop breaks when
880         // uint256 i is equal to another uint256 numMintedSoFar.
881         unchecked {
882             for (uint256 i; i < numMintedSoFar; i++) {
883                 TokenOwnership memory ownership = _ownerships[i];
884                 if (!ownership.burned) {
885                     if (tokenIdsIdx == index) {
886                         return i;
887                     }
888                     tokenIdsIdx++;
889                 }
890             }
891         }
892         revert TokenIndexOutOfBounds();
893     }
894 
895     /**
896      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
897      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
898      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
899      */
900     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
901         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
902         uint256 numMintedSoFar = _currentIndex;
903         uint256 tokenIdsIdx;
904         address currOwnershipAddr;
905 
906         // Counter overflow is impossible as the loop breaks when
907         // uint256 i is equal to another uint256 numMintedSoFar.
908         unchecked {
909             for (uint256 i; i < numMintedSoFar; i++) {
910                 TokenOwnership memory ownership = _ownerships[i];
911                 if (ownership.burned) {
912                     continue;
913                 }
914                 if (ownership.addr != address(0)) {
915                     currOwnershipAddr = ownership.addr;
916                 }
917                 if (currOwnershipAddr == owner) {
918                     if (tokenIdsIdx == index) {
919                         return i;
920                     }
921                     tokenIdsIdx++;
922                 }
923             }
924         }
925 
926         // Execution should never reach this point.
927         revert();
928     }
929 
930     /**
931      * @dev See {IERC165-supportsInterface}.
932      */
933     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
934         return
935             interfaceId == type(IERC721).interfaceId ||
936             interfaceId == type(IERC721Metadata).interfaceId ||
937             interfaceId == type(IERC721Enumerable).interfaceId ||
938             super.supportsInterface(interfaceId);
939     }
940 
941     /**
942      * @dev See {IERC721-balanceOf}.
943      */
944     function balanceOf(address owner) public view override returns (uint256) {
945         if (owner == address(0)) revert BalanceQueryForZeroAddress();
946         return uint256(_addressData[owner].balance);
947     }
948 
949     function _numberMinted(address owner) internal view returns (uint256) {
950         if (owner == address(0)) revert MintedQueryForZeroAddress();
951         return uint256(_addressData[owner].numberMinted);
952     }
953 
954     function _numberBurned(address owner) internal view returns (uint256) {
955         if (owner == address(0)) revert BurnedQueryForZeroAddress();
956         return uint256(_addressData[owner].numberBurned);
957     }
958 
959     /**
960      * Gas spent here starts off proportional to the maximum mint batch size.
961      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
962      */
963     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
964         uint256 curr = tokenId;
965 
966         unchecked {
967             if (curr < _currentIndex) {
968                 TokenOwnership memory ownership = _ownerships[curr];
969                 if (!ownership.burned) {
970                     if (ownership.addr != address(0)) {
971                         return ownership;
972                     }
973                     // Invariant: 
974                     // There will always be an ownership that has an address and is not burned 
975                     // before an ownership that does not have an address and is not burned.
976                     // Hence, curr will not underflow.
977                     while (true) {
978                         curr--;
979                         ownership = _ownerships[curr];
980                         if (ownership.addr != address(0)) {
981                             return ownership;
982                         }
983                     }
984                 }
985             }
986         }
987         revert OwnerQueryForNonexistentToken();
988     }
989 
990     /**
991      * @dev See {IERC721-ownerOf}.
992      */
993     function ownerOf(uint256 tokenId) public view override returns (address) {
994         return ownershipOf(tokenId).addr;
995     }
996 
997     /**
998      * @dev See {IERC721Metadata-name}.
999      */
1000     function name() public view virtual override returns (string memory) {
1001         return _name;
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Metadata-symbol}.
1006      */
1007     function symbol() public view virtual override returns (string memory) {
1008         return _symbol;
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Metadata-tokenURI}.
1013      */
1014     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1015         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1016 
1017         string memory baseURI = _baseURI();
1018         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1019     }
1020 
1021     /**
1022      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1023      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1024      * by default, can be overriden in child contracts.
1025      */
1026     function _baseURI() internal view virtual returns (string memory) {
1027         return '';
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-approve}.
1032      */
1033     function approve(address to, uint256 tokenId) public override {
1034         address owner = ERC721A.ownerOf(tokenId);
1035         if (to == owner) revert ApprovalToCurrentOwner();
1036 
1037         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1038             revert ApprovalCallerNotOwnerNorApproved();
1039         }
1040 
1041         _approve(to, tokenId, owner);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-getApproved}.
1046      */
1047     function getApproved(uint256 tokenId) public view override returns (address) {
1048         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1049 
1050         return _tokenApprovals[tokenId];
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-setApprovalForAll}.
1055      */
1056     function setApprovalForAll(address operator, bool approved) public override {
1057         if (operator == _msgSender()) revert ApproveToCaller();
1058 
1059         _operatorApprovals[_msgSender()][operator] = approved;
1060         emit ApprovalForAll(_msgSender(), operator, approved);
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-isApprovedForAll}.
1065      */
1066     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1067         return _operatorApprovals[owner][operator];
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-transferFrom}.
1072      */
1073     function transferFrom(
1074         address from,
1075         address to,
1076         uint256 tokenId
1077     ) public virtual override {
1078         _transfer(from, to, tokenId);
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-safeTransferFrom}.
1083      */
1084     function safeTransferFrom(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) public virtual override {
1089         safeTransferFrom(from, to, tokenId, '');
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-safeTransferFrom}.
1094      */
1095     function safeTransferFrom(
1096         address from,
1097         address to,
1098         uint256 tokenId,
1099         bytes memory _data
1100     ) public virtual override {
1101         _transfer(from, to, tokenId);
1102         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1103             revert TransferToNonERC721ReceiverImplementer();
1104         }
1105     }
1106 
1107     /**
1108      * @dev Returns whether `tokenId` exists.
1109      *
1110      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1111      *
1112      * Tokens start existing when they are minted (`_mint`),
1113      */
1114     function _exists(uint256 tokenId) internal view returns (bool) {
1115         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1116     }
1117 
1118     function _safeMint(address to, uint256 quantity) internal {
1119         _safeMint(to, quantity, '');
1120     }
1121 
1122     /**
1123      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1124      *
1125      * Requirements:
1126      *
1127      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1128      * - `quantity` must be greater than 0.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _safeMint(
1133         address to,
1134         uint256 quantity,
1135         bytes memory _data
1136     ) internal {
1137         _mint(to, quantity, _data, true);
1138     }
1139 
1140     /**
1141      * @dev Mints `quantity` tokens and transfers them to `to`.
1142      *
1143      * Requirements:
1144      *
1145      * - `to` cannot be the zero address.
1146      * - `quantity` must be greater than 0.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _mint(
1151         address to,
1152         uint256 quantity,
1153         bytes memory _data,
1154         bool safe
1155     ) internal {
1156         uint256 startTokenId = _currentIndex;
1157         if (to == address(0)) revert MintToZeroAddress();
1158         if (quantity == 0) revert MintZeroQuantity();
1159 
1160         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1161 
1162         // Overflows are incredibly unrealistic.
1163         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1164         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1165         unchecked {
1166             _addressData[to].balance += uint64(quantity);
1167             _addressData[to].numberMinted += uint64(quantity);
1168 
1169             _ownerships[startTokenId].addr = to;
1170             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1171 
1172             uint256 updatedIndex = startTokenId;
1173 
1174             for (uint256 i; i < quantity; i++) {
1175                 emit Transfer(address(0), to, updatedIndex);
1176                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1177                     revert TransferToNonERC721ReceiverImplementer();
1178                 }
1179                 updatedIndex++;
1180             }
1181 
1182             _currentIndex = uint128(updatedIndex);
1183         }
1184         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1185     }
1186 
1187     /**
1188      * @dev Transfers `tokenId` from `from` to `to`.
1189      *
1190      * Requirements:
1191      *
1192      * - `to` cannot be the zero address.
1193      * - `tokenId` token must be owned by `from`.
1194      *
1195      * Emits a {Transfer} event.
1196      */
1197     function _transfer(
1198         address from,
1199         address to,
1200         uint256 tokenId
1201     ) private {
1202         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1203 
1204         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1205             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1206             getApproved(tokenId) == _msgSender());
1207 
1208         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1209         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1210         if (to == address(0)) revert TransferToZeroAddress();
1211 
1212         _beforeTokenTransfers(from, to, tokenId, 1);
1213 
1214         // Clear approvals from the previous owner
1215         _approve(address(0), tokenId, prevOwnership.addr);
1216 
1217         // Underflow of the sender's balance is impossible because we check for
1218         // ownership above and the recipient's balance can't realistically overflow.
1219         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1220         unchecked {
1221             _addressData[from].balance -= 1;
1222             _addressData[to].balance += 1;
1223 
1224             _ownerships[tokenId].addr = to;
1225             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1226 
1227             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1228             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1229             uint256 nextTokenId = tokenId + 1;
1230             if (_ownerships[nextTokenId].addr == address(0)) {
1231                 // This will suffice for checking _exists(nextTokenId),
1232                 // as a burned slot cannot contain the zero address.
1233                 if (nextTokenId < _currentIndex) {
1234                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1235                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1236                 }
1237             }
1238         }
1239 
1240         emit Transfer(from, to, tokenId);
1241         _afterTokenTransfers(from, to, tokenId, 1);
1242     }
1243 
1244     /**
1245      * @dev Destroys `tokenId`.
1246      * The approval is cleared when the token is burned.
1247      *
1248      * Requirements:
1249      *
1250      * - `tokenId` must exist.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _burn(uint256 tokenId) internal virtual {
1255         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1256 
1257         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1258 
1259         // Clear approvals from the previous owner
1260         _approve(address(0), tokenId, prevOwnership.addr);
1261 
1262         // Underflow of the sender's balance is impossible because we check for
1263         // ownership above and the recipient's balance can't realistically overflow.
1264         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1265         unchecked {
1266             _addressData[prevOwnership.addr].balance -= 1;
1267             _addressData[prevOwnership.addr].numberBurned += 1;
1268 
1269             // Keep track of who burned the token, and the timestamp of burning.
1270             _ownerships[tokenId].addr = prevOwnership.addr;
1271             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1272             _ownerships[tokenId].burned = true;
1273 
1274             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1275             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1276             uint256 nextTokenId = tokenId + 1;
1277             if (_ownerships[nextTokenId].addr == address(0)) {
1278                 // This will suffice for checking _exists(nextTokenId),
1279                 // as a burned slot cannot contain the zero address.
1280                 if (nextTokenId < _currentIndex) {
1281                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1282                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1283                 }
1284             }
1285         }
1286 
1287         emit Transfer(prevOwnership.addr, address(0), tokenId);
1288         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1289 
1290         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1291         unchecked { 
1292             _burnCounter++;
1293         }
1294     }
1295 
1296     /**
1297      * @dev Approve `to` to operate on `tokenId`
1298      *
1299      * Emits a {Approval} event.
1300      */
1301     function _approve(
1302         address to,
1303         uint256 tokenId,
1304         address owner
1305     ) private {
1306         _tokenApprovals[tokenId] = to;
1307         emit Approval(owner, to, tokenId);
1308     }
1309 
1310     /**
1311      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1312      * The call is not executed if the target address is not a contract.
1313      *
1314      * @param from address representing the previous owner of the given token ID
1315      * @param to target address that will receive the tokens
1316      * @param tokenId uint256 ID of the token to be transferred
1317      * @param _data bytes optional data to send along with the call
1318      * @return bool whether the call correctly returned the expected magic value
1319      */
1320     function _checkOnERC721Received(
1321         address from,
1322         address to,
1323         uint256 tokenId,
1324         bytes memory _data
1325     ) private returns (bool) {
1326         if (to.isContract()) {
1327             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1328                 return retval == IERC721Receiver(to).onERC721Received.selector;
1329             } catch (bytes memory reason) {
1330                 if (reason.length == 0) {
1331                     revert TransferToNonERC721ReceiverImplementer();
1332                 } else {
1333                     assembly {
1334                         revert(add(32, reason), mload(reason))
1335                     }
1336                 }
1337             }
1338         } else {
1339             return true;
1340         }
1341     }
1342 
1343     /**
1344      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1345      * And also called before burning one token.
1346      *
1347      * startTokenId - the first token id to be transferred
1348      * quantity - the amount to be transferred
1349      *
1350      * Calling conditions:
1351      *
1352      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1353      * transferred to `to`.
1354      * - When `from` is zero, `tokenId` will be minted for `to`.
1355      * - When `to` is zero, `tokenId` will be burned by `from`.
1356      * - `from` and `to` are never both zero.
1357      */
1358     function _beforeTokenTransfers(
1359         address from,
1360         address to,
1361         uint256 startTokenId,
1362         uint256 quantity
1363     ) internal virtual {}
1364 
1365     /**
1366      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1367      * minting.
1368      * And also called after one token has been burned.
1369      *
1370      * startTokenId - the first token id to be transferred
1371      * quantity - the amount to be transferred
1372      *
1373      * Calling conditions:
1374      *
1375      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1376      * transferred to `to`.
1377      * - When `from` is zero, `tokenId` has been minted for `to`.
1378      * - When `to` is zero, `tokenId` has been burned by `from`.
1379      * - `from` and `to` are never both zero.
1380      */
1381     function _afterTokenTransfers(
1382         address from,
1383         address to,
1384         uint256 startTokenId,
1385         uint256 quantity
1386     ) internal virtual {}
1387 }
1388 
1389 // File: contracts/PepeUniverse.sol
1390 
1391 
1392 
1393 pragma solidity ^0.8.12;
1394 
1395 
1396 
1397 
1398 contract PepeUniverse is ERC721A, Ownable {
1399     using Strings for uint256;
1400 
1401     uint256 public tokenPricePresale = 0.00 ether;
1402     uint256 public tokenPricePublicSale = 0.08 ether;
1403 
1404     uint256 public maxTokensPerWalletPresale = 1;
1405     uint256 public maxTokensPerWalletPublicSale = 2;
1406 
1407     string public tokenBaseURI = "ipfs://QmVqw3VEU71mcuyzTmnzKLDbANsd9axf1bMJpURVsUu9qa/";
1408 
1409     bool public hasPresaleStarted = false;
1410     bool public hasPublicSaleStarted = false;
1411 
1412     uint256 public tokensToBuyAmount = 10000;
1413     
1414     bytes32 public whitelistRoot;
1415     mapping(address => uint256) public presalePurchased;
1416     mapping(address => uint256) public publicSalePurchased;
1417 
1418     constructor() ERC721A("Pepe Universe", "PEPE") {
1419         
1420     }
1421 
1422     function setMaxTokensPerWalletPresale(uint256 val) external onlyOwner {
1423         maxTokensPerWalletPresale = val;
1424     }
1425 
1426     function setMaxTokensPerWalletPublicSale(uint256 val) external onlyOwner {
1427         maxTokensPerWalletPublicSale = val;
1428     }
1429 
1430     function setPresale(bool val) external onlyOwner {
1431         hasPresaleStarted = val;
1432     }
1433 
1434     function setPublicSale(bool val) external onlyOwner {
1435         hasPublicSaleStarted = val;
1436     }
1437     
1438     function tokenPrice() public view returns (uint256) {
1439       if (hasPublicSaleStarted) {
1440         return tokenPricePublicSale;
1441       }
1442       return tokenPricePresale;
1443     }
1444 
1445     function setTokenPricePresale(uint256 val) external onlyOwner {
1446       tokenPricePresale = val;
1447     }
1448 
1449     function setTokenPricePublicSale(uint256 val) external onlyOwner {
1450       tokenPricePublicSale = val;
1451     }
1452 
1453     function setWhitelistRoot(bytes32 _whitelistRoot) public onlyOwner {
1454         whitelistRoot = _whitelistRoot;
1455     }
1456 
1457     function verify(address account, bytes32[] memory proof) public
1458         view
1459         returns (bool)
1460     {
1461         bytes32 leaf = keccak256(abi.encodePacked(account));
1462         return MerkleProof.verify(proof, whitelistRoot, leaf);
1463     }
1464 
1465     function mint(uint256 amount, bytes32[] memory proof) external payable {
1466         require(msg.value >= tokenPrice() * amount, "Incorrect ETH");
1467         require(hasPresaleStarted, "Cannot mint before presale");
1468         require(hasPublicSaleStarted || verify(msg.sender, proof), "Buyer not whitelisted for presale");
1469         require(amount <= tokensToBuyAmount, "No tokens left for minting");
1470         if (hasPublicSaleStarted) {
1471             require(publicSalePurchased[msg.sender] + amount <= maxTokensPerWalletPublicSale,
1472                 "Cannot mint more than the max tokens per address");
1473         } else {
1474             require(presalePurchased[msg.sender] + amount <= maxTokensPerWalletPresale,
1475                 "Cannot mint more than the max tokens per address");
1476         }
1477         
1478         _safeMint(msg.sender, amount);
1479 
1480         if (hasPublicSaleStarted) {
1481             publicSalePurchased[msg.sender] += amount;
1482         } else {
1483             presalePurchased[msg.sender] += amount;
1484         }
1485 
1486         tokensToBuyAmount -= amount;
1487     }
1488 
1489     function gift(uint256 amount, address to) external onlyOwner {
1490         require(amount <= tokensToBuyAmount, "No tokens left");
1491         _safeMint(to, amount);
1492         tokensToBuyAmount -= amount;
1493     }
1494 
1495     function giftToMultiple(uint256 amount, address[] calldata toAddresses) external onlyOwner {
1496         uint256 totalAmount = amount * toAddresses.length;
1497         require(totalAmount <= tokensToBuyAmount, "No tokens left");
1498 
1499         for (uint256 i = 0; i < toAddresses.length; i++) {
1500             _safeMint(toAddresses[i], amount);
1501         }
1502 
1503         tokensToBuyAmount -= totalAmount;
1504     }
1505 
1506     function _baseURI() internal view override(ERC721A) returns (string memory) {
1507         return tokenBaseURI;
1508     }
1509    
1510     function setBaseURI(string calldata URI) external onlyOwner {
1511         tokenBaseURI = URI;
1512     }
1513 
1514     function withdraw() external onlyOwner {
1515         require(payable(msg.sender).send(address(this).balance));
1516     }
1517 }