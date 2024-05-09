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
855         string memory baseURI = _baseURI();
856         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
857     }
858 
859     /**
860      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
861      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
862      * by default, can be overriden in child contracts.
863      */
864     function _baseURI() internal view virtual returns (string memory) {
865         return "";
866     }
867 
868     /**
869      * @dev See {IERC721-approve}.
870      */
871     function approve(address to, uint256 tokenId) public virtual override {
872         address owner = ERC721.ownerOf(tokenId);
873         require(to != owner, "ERC721: approval to current owner");
874 
875         require(
876             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
877             "ERC721: approve caller is not owner nor approved for all"
878         );
879 
880         _approve(to, tokenId);
881     }
882 
883     /**
884      * @dev See {IERC721-getApproved}.
885      */
886     function getApproved(uint256 tokenId) public view virtual override returns (address) {
887         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
888 
889         return _tokenApprovals[tokenId];
890     }
891 
892     /**
893      * @dev See {IERC721-setApprovalForAll}.
894      */
895     function setApprovalForAll(address operator, bool approved) public virtual override {
896         _setApprovalForAll(_msgSender(), operator, approved);
897     }
898 
899     /**
900      * @dev See {IERC721-isApprovedForAll}.
901      */
902     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
903         return _operatorApprovals[owner][operator];
904     }
905 
906     /**
907      * @dev See {IERC721-transferFrom}.
908      */
909     function transferFrom(
910         address from,
911         address to,
912         uint256 tokenId
913     ) public virtual override {
914         //solhint-disable-next-line max-line-length
915         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
916 
917         _transfer(from, to, tokenId);
918     }
919 
920     /**
921      * @dev See {IERC721-safeTransferFrom}.
922      */
923     function safeTransferFrom(
924         address from,
925         address to,
926         uint256 tokenId
927     ) public virtual override {
928         safeTransferFrom(from, to, tokenId, "");
929     }
930 
931     /**
932      * @dev See {IERC721-safeTransferFrom}.
933      */
934     function safeTransferFrom(
935         address from,
936         address to,
937         uint256 tokenId,
938         bytes memory _data
939     ) public virtual override {
940         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
941         _safeTransfer(from, to, tokenId, _data);
942     }
943 
944     /**
945      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
946      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
947      *
948      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
949      *
950      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
951      * implement alternative mechanisms to perform token transfer, such as signature-based.
952      *
953      * Requirements:
954      *
955      * - `from` cannot be the zero address.
956      * - `to` cannot be the zero address.
957      * - `tokenId` token must exist and be owned by `from`.
958      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _safeTransfer(
963         address from,
964         address to,
965         uint256 tokenId,
966         bytes memory _data
967     ) internal virtual {
968         _transfer(from, to, tokenId);
969         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
970     }
971 
972     /**
973      * @dev Returns whether `tokenId` exists.
974      *
975      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
976      *
977      * Tokens start existing when they are minted (`_mint`),
978      * and stop existing when they are burned (`_burn`).
979      */
980     function _exists(uint256 tokenId) internal view virtual returns (bool) {
981         return _owners[tokenId] != address(0);
982     }
983 
984     /**
985      * @dev Returns whether `spender` is allowed to manage `tokenId`.
986      *
987      * Requirements:
988      *
989      * - `tokenId` must exist.
990      */
991     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
992         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
993         address owner = ERC721.ownerOf(tokenId);
994         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
995     }
996 
997     /**
998      * @dev Safely mints `tokenId` and transfers it to `to`.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must not exist.
1003      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _safeMint(address to, uint256 tokenId) internal virtual {
1008         _safeMint(to, tokenId, "");
1009     }
1010 
1011     /**
1012      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1013      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1014      */
1015     function _safeMint(
1016         address to,
1017         uint256 tokenId,
1018         bytes memory _data
1019     ) internal virtual {
1020         _mint(to, tokenId);
1021         require(
1022             _checkOnERC721Received(address(0), to, tokenId, _data),
1023             "ERC721: transfer to non ERC721Receiver implementer"
1024         );
1025     }
1026 
1027     /**
1028      * @dev Mints `tokenId` and transfers it to `to`.
1029      *
1030      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1031      *
1032      * Requirements:
1033      *
1034      * - `tokenId` must not exist.
1035      * - `to` cannot be the zero address.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function _mint(address to, uint256 tokenId) internal virtual {
1040         require(to != address(0), "ERC721: mint to the zero address");
1041         require(!_exists(tokenId), "ERC721: token already minted");
1042 
1043         _beforeTokenTransfer(address(0), to, tokenId);
1044 
1045         _balances[to] += 1;
1046         _owners[tokenId] = to;
1047 
1048         emit Transfer(address(0), to, tokenId);
1049 
1050         _afterTokenTransfer(address(0), to, tokenId);
1051     }
1052 
1053     /**
1054      * @dev Destroys `tokenId`.
1055      * The approval is cleared when the token is burned.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must exist.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _burn(uint256 tokenId) internal virtual {
1064         address owner = ERC721.ownerOf(tokenId);
1065 
1066         _beforeTokenTransfer(owner, address(0), tokenId);
1067 
1068         // Clear approvals
1069         _approve(address(0), tokenId);
1070 
1071         _balances[owner] -= 1;
1072         delete _owners[tokenId];
1073 
1074         emit Transfer(owner, address(0), tokenId);
1075 
1076         _afterTokenTransfer(owner, address(0), tokenId);
1077     }
1078 
1079     /**
1080      * @dev Transfers `tokenId` from `from` to `to`.
1081      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1082      *
1083      * Requirements:
1084      *
1085      * - `to` cannot be the zero address.
1086      * - `tokenId` token must be owned by `from`.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _transfer(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) internal virtual {
1095         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1096         require(to != address(0), "ERC721: transfer to the zero address");
1097 
1098         _beforeTokenTransfer(from, to, tokenId);
1099 
1100         // Clear approvals from the previous owner
1101         _approve(address(0), tokenId);
1102 
1103         _balances[from] -= 1;
1104         _balances[to] += 1;
1105         _owners[tokenId] = to;
1106 
1107         emit Transfer(from, to, tokenId);
1108 
1109         _afterTokenTransfer(from, to, tokenId);
1110     }
1111 
1112     /**
1113      * @dev Approve `to` to operate on `tokenId`
1114      *
1115      * Emits a {Approval} event.
1116      */
1117     function _approve(address to, uint256 tokenId) internal virtual {
1118         _tokenApprovals[tokenId] = to;
1119         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1120     }
1121 
1122     /**
1123      * @dev Approve `operator` to operate on all of `owner` tokens
1124      *
1125      * Emits a {ApprovalForAll} event.
1126      */
1127     function _setApprovalForAll(
1128         address owner,
1129         address operator,
1130         bool approved
1131     ) internal virtual {
1132         require(owner != operator, "ERC721: approve to caller");
1133         _operatorApprovals[owner][operator] = approved;
1134         emit ApprovalForAll(owner, operator, approved);
1135     }
1136 
1137     /**
1138      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1139      * The call is not executed if the target address is not a contract.
1140      *
1141      * @param from address representing the previous owner of the given token ID
1142      * @param to target address that will receive the tokens
1143      * @param tokenId uint256 ID of the token to be transferred
1144      * @param _data bytes optional data to send along with the call
1145      * @return bool whether the call correctly returned the expected magic value
1146      */
1147     function _checkOnERC721Received(
1148         address from,
1149         address to,
1150         uint256 tokenId,
1151         bytes memory _data
1152     ) private returns (bool) {
1153         if (to.isContract()) {
1154             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1155                 return retval == IERC721Receiver.onERC721Received.selector;
1156             } catch (bytes memory reason) {
1157                 if (reason.length == 0) {
1158                     revert("ERC721: transfer to non ERC721Receiver implementer");
1159                 } else {
1160                     assembly {
1161                         revert(add(32, reason), mload(reason))
1162                     }
1163                 }
1164             }
1165         } else {
1166             return true;
1167         }
1168     }
1169 
1170     /**
1171      * @dev Hook that is called before any token transfer. This includes minting
1172      * and burning.
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` will be minted for `to`.
1179      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1180      * - `from` and `to` are never both zero.
1181      *
1182      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1183      */
1184     function _beforeTokenTransfer(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) internal virtual {}
1189 
1190     /**
1191      * @dev Hook that is called after any transfer of tokens. This includes
1192      * minting and burning.
1193      *
1194      * Calling conditions:
1195      *
1196      * - when `from` and `to` are both non-zero.
1197      * - `from` and `to` are never both zero.
1198      *
1199      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1200      */
1201     function _afterTokenTransfer(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) internal virtual {}
1206 }
1207 
1208 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1209 
1210 
1211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1212 
1213 pragma solidity ^0.8.0;
1214 
1215 
1216 
1217 /**
1218  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1219  * enumerability of all the token ids in the contract as well as all token ids owned by each
1220  * account.
1221  */
1222 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1223     // Mapping from owner to list of owned token IDs
1224     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1225 
1226     // Mapping from token ID to index of the owner tokens list
1227     mapping(uint256 => uint256) private _ownedTokensIndex;
1228 
1229     // Array with all token ids, used for enumeration
1230     uint256[] private _allTokens;
1231 
1232     // Mapping from token id to position in the allTokens array
1233     mapping(uint256 => uint256) private _allTokensIndex;
1234 
1235     /**
1236      * @dev See {IERC165-supportsInterface}.
1237      */
1238     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1239         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1240     }
1241 
1242     /**
1243      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1244      */
1245     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1246         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1247         return _ownedTokens[owner][index];
1248     }
1249 
1250     /**
1251      * @dev See {IERC721Enumerable-totalSupply}.
1252      */
1253     function totalSupply() public view virtual override returns (uint256) {
1254         return _allTokens.length;
1255     }
1256 
1257     /**
1258      * @dev See {IERC721Enumerable-tokenByIndex}.
1259      */
1260     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1261         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1262         return _allTokens[index];
1263     }
1264 
1265     /**
1266      * @dev Hook that is called before any token transfer. This includes minting
1267      * and burning.
1268      *
1269      * Calling conditions:
1270      *
1271      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1272      * transferred to `to`.
1273      * - When `from` is zero, `tokenId` will be minted for `to`.
1274      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1275      * - `from` cannot be the zero address.
1276      * - `to` cannot be the zero address.
1277      *
1278      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1279      */
1280     function _beforeTokenTransfer(
1281         address from,
1282         address to,
1283         uint256 tokenId
1284     ) internal virtual override {
1285         super._beforeTokenTransfer(from, to, tokenId);
1286 
1287         if (from == address(0)) {
1288             _addTokenToAllTokensEnumeration(tokenId);
1289         } else if (from != to) {
1290             _removeTokenFromOwnerEnumeration(from, tokenId);
1291         }
1292         if (to == address(0)) {
1293             _removeTokenFromAllTokensEnumeration(tokenId);
1294         } else if (to != from) {
1295             _addTokenToOwnerEnumeration(to, tokenId);
1296         }
1297     }
1298 
1299     /**
1300      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1301      * @param to address representing the new owner of the given token ID
1302      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1303      */
1304     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1305         uint256 length = ERC721.balanceOf(to);
1306         _ownedTokens[to][length] = tokenId;
1307         _ownedTokensIndex[tokenId] = length;
1308     }
1309 
1310     /**
1311      * @dev Private function to add a token to this extension's token tracking data structures.
1312      * @param tokenId uint256 ID of the token to be added to the tokens list
1313      */
1314     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1315         _allTokensIndex[tokenId] = _allTokens.length;
1316         _allTokens.push(tokenId);
1317     }
1318 
1319     /**
1320      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1321      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1322      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1323      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1324      * @param from address representing the previous owner of the given token ID
1325      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1326      */
1327     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1328         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1329         // then delete the last slot (swap and pop).
1330 
1331         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1332         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1333 
1334         // When the token to delete is the last token, the swap operation is unnecessary
1335         if (tokenIndex != lastTokenIndex) {
1336             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1337 
1338             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1339             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1340         }
1341 
1342         // This also deletes the contents at the last position of the array
1343         delete _ownedTokensIndex[tokenId];
1344         delete _ownedTokens[from][lastTokenIndex];
1345     }
1346 
1347     /**
1348      * @dev Private function to remove a token from this extension's token tracking data structures.
1349      * This has O(1) time complexity, but alters the order of the _allTokens array.
1350      * @param tokenId uint256 ID of the token to be removed from the tokens list
1351      */
1352     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1353         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1354         // then delete the last slot (swap and pop).
1355 
1356         uint256 lastTokenIndex = _allTokens.length - 1;
1357         uint256 tokenIndex = _allTokensIndex[tokenId];
1358 
1359         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1360         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1361         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1362         uint256 lastTokenId = _allTokens[lastTokenIndex];
1363 
1364         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1365         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1366 
1367         // This also deletes the contents at the last position of the array
1368         delete _allTokensIndex[tokenId];
1369         _allTokens.pop();
1370     }
1371 }
1372 
1373 // File: contracts/PJPP_Ladies.sol
1374 
1375 
1376 
1377 pragma solidity >=0.7.0 <0.9.0;
1378 
1379 
1380 
1381 
1382 contract PJPP_Ladies is ERC721Enumerable, Ownable {
1383     using Strings for uint256;
1384     string public baseURI;
1385     string public baseExtension = ".json";
1386     string public notRevealedUri;
1387     uint256 public cost = 0.3 ether;
1388     uint256 public maxSupply = 3333;
1389     bool public paused = false;
1390     bool public revealed = false;
1391 
1392     mapping(address => uint256) public addressMintedBalance;
1393 
1394     bytes32 public owligarchMerkleRoot;
1395     bytes32 public platinumMerkleRoot;
1396     bytes32 public diamondMerkleRoot;
1397 
1398     uint256 public maxLimitPublic = 2;
1399     uint256 public maxLimitOwligarch = 2;
1400     uint256 public maxLimitPlatinum = 5;
1401     uint256 public maxLimitDiamond = 10;
1402 
1403     bool public publicSale = false;
1404 
1405     constructor(
1406         string memory _name,
1407         string memory _symbol,
1408         string memory _initBaseURI,
1409         string memory _initNotRevealedUri
1410     ) ERC721(_name, _symbol) {
1411         setBaseURI(_initBaseURI);
1412         setNotRevealedURI(_initNotRevealedUri);
1413     }
1414 
1415     function _baseURI() internal view virtual override returns (string memory) {
1416         return baseURI;
1417     }
1418 
1419     function setPublicSale(bool _publicSale) external onlyOwner {
1420         publicSale = _publicSale;
1421     }
1422 
1423     function isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root)
1424         internal
1425         view
1426         returns (bool)
1427     {
1428         return
1429             MerkleProof.verify(
1430                 merkleProof,
1431                 root,
1432                 keccak256(abi.encodePacked(msg.sender))
1433             );
1434     }
1435 
1436     function mint(bytes32[] calldata merkleProof, uint256 _amount)
1437         public
1438         payable
1439     {
1440         require(!paused, "minting is paused");
1441         uint256 supply = totalSupply();
1442         require(supply + _amount <= maxSupply, "max NFT limit exceeded");
1443         uint256 minted = balanceOf(msg.sender);
1444         if (isValidMerkleProof(merkleProof, diamondMerkleRoot)) {
1445             require(
1446                 minted + _amount <= maxLimitDiamond,
1447                 "cannot mint more than dimaond limit"
1448             );
1449         } else if (isValidMerkleProof(merkleProof, platinumMerkleRoot)) {
1450             require(
1451                 minted + _amount <= maxLimitPlatinum,
1452                 "cannot mint more than platinum limit"
1453             );
1454         } else if (isValidMerkleProof(merkleProof, owligarchMerkleRoot)) {
1455             require(
1456                 minted + _amount <= maxLimitOwligarch,
1457                 "cannot mint more than owligarch limit"
1458             );
1459         } else {
1460             require(publicSale == true, "Public sale is not open");
1461             require(
1462                 minted + _amount <= maxLimitPublic,
1463                 "cannot mint more than limit"
1464             );
1465         }
1466         require(msg.value == cost * _amount, "pay price of nft");
1467         for (uint256 i = 1; i <= _amount; i++) {
1468             _safeMint(msg.sender, supply + i);
1469         }
1470     }
1471 
1472     function ownerMint(address _to, uint256 _mintAmount) public onlyOwner {
1473         uint256 supply = totalSupply();
1474         require(_mintAmount > 0);
1475         require(supply + _mintAmount <= maxSupply);
1476         for (uint256 i = 1; i <= _mintAmount; i++) {
1477             _safeMint(_to, supply + i);
1478         }
1479     }
1480 
1481     function setOwligarchMerkleRoot(bytes32 merkleRoot) external onlyOwner {
1482         owligarchMerkleRoot = merkleRoot;
1483     }
1484 
1485     function setPlatinumMerkleRoot(bytes32 merkleRoot) external onlyOwner {
1486         platinumMerkleRoot = merkleRoot;
1487     }
1488 
1489     function setDiamondMerkleRoot(bytes32 merkleRoot) external onlyOwner {
1490         diamondMerkleRoot = merkleRoot;
1491     }
1492 
1493     function walletOfOwner(address _owner)
1494         public
1495         view
1496         returns (uint256[] memory)
1497     {
1498         uint256 ownerTokenCount = balanceOf(_owner);
1499         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1500         for (uint256 i; i < ownerTokenCount; i++) {
1501             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1502         }
1503         return tokenIds;
1504     }
1505 
1506     function tokenURI(uint256 tokenId)
1507         public
1508         view
1509         virtual
1510         override
1511         returns (string memory)
1512     {
1513         require(
1514             _exists(tokenId),
1515             "ERC721Metadata: URI query for nonexistent token"
1516         );
1517 
1518         if (revealed == false) {
1519             return notRevealedUri;
1520         }
1521 
1522         string memory currentBaseURI = _baseURI();
1523         return
1524             bytes(currentBaseURI).length > 0
1525                 ? string(
1526                     abi.encodePacked(
1527                         currentBaseURI,
1528                         tokenId.toString(),
1529                         baseExtension
1530                     )
1531                 )
1532                 : "";
1533     }
1534 
1535     function reveal() public onlyOwner {
1536         revealed = true;
1537     }
1538 
1539     function setCost(uint256 _newCost) public onlyOwner {
1540         cost = _newCost;
1541     }
1542 
1543     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1544         baseURI = _newBaseURI;
1545     }
1546 
1547     function setBaseExtension(string memory _newBaseExtension)
1548         public
1549         onlyOwner
1550     {
1551         baseExtension = _newBaseExtension;
1552     }
1553 
1554     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1555         notRevealedUri = _notRevealedURI;
1556     }
1557 
1558     function pause(bool _state) public onlyOwner {
1559         paused = _state;
1560     }
1561 
1562     function setmaxLimitPublic(uint256 _limit) public onlyOwner {
1563         maxLimitPublic = _limit;
1564     }
1565 
1566     function setMaxLimitOwligarch(uint256 _limit) public onlyOwner {
1567         maxLimitOwligarch = _limit;
1568     }
1569 
1570     function setMaxLimitDiamond(uint256 _limit) public onlyOwner {
1571         maxLimitDiamond = _limit;
1572     }
1573 
1574     function setMaxLimitPlatinum(uint256 _limit) public onlyOwner {
1575         maxLimitPlatinum = _limit;
1576     }
1577 
1578     function setMaxSupply(uint256 _supply) public onlyOwner {
1579         maxSupply = _supply;
1580     }
1581 
1582     function withdraw() public payable onlyOwner {
1583         uint256 amount = address(this).balance;
1584         require(amount > 0, "Ether balance is 0 in contract");
1585         payable(address(owner())).transfer(amount);
1586     }
1587 }