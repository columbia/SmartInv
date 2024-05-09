1 // File: final/contracts/LetsgoNFTBase.sol
2 
3 //SPDX-License-Identifier: GPL-3.0
4 pragma solidity ^0.8.0;
5 
6 contract LetsgoNFTBase {
7     uint256 public mantissa = 10000;
8 
9     struct AddreessWithPercent {
10         address addr;
11         uint256 value;
12     }
13 
14     function validateCoCreators(AddreessWithPercent[] memory coCreators) external view{
15          require(
16             coCreators.length <= 10,
17             "validateCoCreators: coCreators length should be less or equal to 10"
18         );
19 
20         uint256 coCreatorsSum = 0;
21 
22         for (uint256 i = 0; i < coCreators.length; i++) {
23             require(
24                 coCreators[i].addr != address(0),
25                 "validateCoCreators: coCreator address address can't be empty"
26             );
27             require(
28                 coCreators[i].value > 0,
29                 "validateCoCreators: coCreator value must be higher than 0"
30             );
31             coCreatorsSum += coCreators[i].value;
32         }
33         
34         require(
35             coCreatorsSum <= mantissa,
36             "validateCoCreators: coCreators sum should be less or equal to 100%"
37         );
38     }
39 }
40 // File: final/contracts/MerkleProof.sol
41 
42 
43 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
44 
45 pragma solidity ^0.8.0;
46 
47 /**
48  * @dev These functions deal with verification of Merkle Trees proofs.
49  *
50  * The proofs can be generated using the JavaScript library
51  * https://github.com/miguelmota/merkletreejs[merkletreejs].
52  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
53  *
54  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
55  */
56 library MerkleProof {
57     /**
58      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
59      * defined by `root`. For this, a `proof` must be provided, containing
60      * sibling hashes on the branch from the leaf to the root of the tree. Each
61      * pair of leaves and each pair of pre-images are assumed to be sorted.
62      */
63     function verify(
64         bytes32[] memory proof,
65         bytes32 root,
66         bytes32 leaf
67     ) internal pure returns (bool) {
68         return processProof(proof, leaf) == root;
69     }
70 
71     /**
72      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
73      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
74      * hash matches the root of the tree. When processing the proof, the pairs
75      * of leafs & pre-images are assumed to be sorted.
76      *
77      * _Available since v4.4._
78      */
79     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
80         bytes32 computedHash = leaf;
81         for (uint256 i = 0; i < proof.length; i++) {
82             bytes32 proofElement = proof[i];
83             if (computedHash <= proofElement) {
84                 // Hash(current computed hash + current element of the proof)
85                 computedHash = _efficientHash(computedHash, proofElement);
86             } else {
87                 // Hash(current element of the proof + current computed hash)
88                 computedHash = _efficientHash(proofElement, computedHash);
89             }
90         }
91         return computedHash;
92     }
93 
94     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
95         assembly {
96             mstore(0x00, a)
97             mstore(0x20, b)
98             value := keccak256(0x00, 0x40)
99         }
100     }
101 }
102 // File: @openzeppelin/contracts/utils/Counters.sol
103 
104 
105 // File: @openzeppelin/contracts/utils/Counters.sol
106 
107 
108 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
109 
110 pragma solidity ^0.8.0;
111 
112 /**
113  * @title Counters
114  * @author Matt Condon (@shrugs)
115  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
116  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
117  *
118  * Include with `using Counters for Counters.Counter;`
119  */
120 library Counters {
121     struct Counter {
122         // This variable should never be directly accessed by users of the library: interactions must be restricted to
123         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
124         // this feature: see https://github.com/ethereum/solidity/issues/4637
125         uint256 _value; // default: 0
126     }
127 
128     function current(Counter storage counter) internal view returns (uint256) {
129         return counter._value;
130     }
131 
132     function increment(Counter storage counter) internal {
133         unchecked {
134             counter._value += 1;
135         }
136     }
137 
138     function decrement(Counter storage counter) internal {
139         uint256 value = counter._value;
140         require(value > 0, "Counter: decrement overflow");
141         unchecked {
142             counter._value = value - 1;
143         }
144     }
145 
146     function reset(Counter storage counter) internal {
147         counter._value = 0;
148     }
149 }
150 
151 // File: @openzeppelin/contracts/utils/Strings.sol
152 
153 
154 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
155 
156 pragma solidity ^0.8.0;
157 
158 /**
159  * @dev String operations.
160  */
161 library Strings {
162     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
163 
164     /**
165      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
166      */
167     function toString(uint256 value) internal pure returns (string memory) {
168         // Inspired by OraclizeAPI's implementation - MIT licence
169         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
170 
171         if (value == 0) {
172             return "0";
173         }
174         uint256 temp = value;
175         uint256 digits;
176         while (temp != 0) {
177             digits++;
178             temp /= 10;
179         }
180         bytes memory buffer = new bytes(digits);
181         while (value != 0) {
182             digits -= 1;
183             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
184             value /= 10;
185         }
186         return string(buffer);
187     }
188 
189     /**
190      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
191      */
192     function toHexString(uint256 value) internal pure returns (string memory) {
193         if (value == 0) {
194             return "0x00";
195         }
196         uint256 temp = value;
197         uint256 length = 0;
198         while (temp != 0) {
199             length++;
200             temp >>= 8;
201         }
202         return toHexString(value, length);
203     }
204 
205     /**
206      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
207      */
208     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
209         bytes memory buffer = new bytes(2 * length + 2);
210         buffer[0] = "0";
211         buffer[1] = "x";
212         for (uint256 i = 2 * length + 1; i > 1; --i) {
213             buffer[i] = _HEX_SYMBOLS[value & 0xf];
214             value >>= 4;
215         }
216         require(value == 0, "Strings: hex length insufficient");
217         return string(buffer);
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/Context.sol
222 
223 
224 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev Provides information about the current execution context, including the
230  * sender of the transaction and its data. While these are generally available
231  * via msg.sender and msg.data, they should not be accessed in such a direct
232  * manner, since when dealing with meta-transactions the account sending and
233  * paying for execution may not be the actual sender (as far as an application
234  * is concerned).
235  *
236  * This contract is only required for intermediate, library-like contracts.
237  */
238 abstract contract Context {
239     function _msgSender() internal view virtual returns (address) {
240         return msg.sender;
241     }
242 
243     function _msgData() internal view virtual returns (bytes calldata) {
244         return msg.data;
245     }
246 }
247 
248 // File: @openzeppelin/contracts/access/Ownable.sol
249 
250 
251 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 
256 /**
257  * @dev Contract module which provides a basic access control mechanism, where
258  * there is an account (an owner) that can be granted exclusive access to
259  * specific functions.
260  *
261  * By default, the owner account will be the one that deploys the contract. This
262  * can later be changed with {transferOwnership}.
263  *
264  * This module is used through inheritance. It will make available the modifier
265  * `onlyOwner`, which can be applied to your functions to restrict their use to
266  * the owner.
267  */
268 abstract contract Ownable is Context {
269     address private _owner;
270 
271     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
272 
273     /**
274      * @dev Initializes the contract setting the deployer as the initial owner.
275      */
276     constructor() {
277         _transferOwnership(_msgSender());
278     }
279 
280     /**
281      * @dev Returns the address of the current owner.
282      */
283     function owner() public view virtual returns (address) {
284         return _owner;
285     }
286 
287     /**
288      * @dev Throws if called by any account other than the owner.
289      */
290     modifier onlyOwner() {
291         require(owner() == _msgSender(), "Ownable: caller is not the owner");
292         _;
293     }
294 
295     /**
296      * @dev Leaves the contract without owner. It will not be possible to call
297      * `onlyOwner` functions anymore. Can only be called by the current owner.
298      *
299      * NOTE: Renouncing ownership will leave the contract without an owner,
300      * thereby removing any functionality that is only available to the owner.
301      */
302     function renounceOwnership() public virtual onlyOwner {
303         _transferOwnership(address(0));
304     }
305 
306     /**
307      * @dev Transfers ownership of the contract to a new account (`newOwner`).
308      * Can only be called by the current owner.
309      */
310     function transferOwnership(address newOwner) public virtual onlyOwner {
311         require(newOwner != address(0), "Ownable: new owner is the zero address");
312         _transferOwnership(newOwner);
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Internal function without access restriction.
318      */
319     function _transferOwnership(address newOwner) internal virtual {
320         address oldOwner = _owner;
321         _owner = newOwner;
322         emit OwnershipTransferred(oldOwner, newOwner);
323     }
324 }
325 
326 // File: @openzeppelin/contracts/utils/Address.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Collection of functions related to the address type
335  */
336 library Address {
337     /**
338      * @dev Returns true if `account` is a contract.
339      *
340      * [IMPORTANT]
341      * ====
342      * It is unsafe to assume that an address for which this function returns
343      * false is an externally-owned account (EOA) and not a contract.
344      *
345      * Among others, `isContract` will return false for the following
346      * types of addresses:
347      *
348      *  - an externally-owned account
349      *  - a contract in construction
350      *  - an address where a contract will be created
351      *  - an address where a contract lived, but was destroyed
352      * ====
353      */
354     function isContract(address account) internal view returns (bool) {
355         // This method relies on extcodesize, which returns 0 for contracts in
356         // construction, since the code is only stored at the end of the
357         // constructor execution.
358 
359         uint256 size;
360         assembly {
361             size := extcodesize(account)
362         }
363         return size > 0;
364     }
365 
366     /**
367      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
368      * `recipient`, forwarding all available gas and reverting on errors.
369      *
370      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
371      * of certain opcodes, possibly making contracts go over the 2300 gas limit
372      * imposed by `transfer`, making them unable to receive funds via
373      * `transfer`. {sendValue} removes this limitation.
374      *
375      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
376      *
377      * IMPORTANT: because control is transferred to `recipient`, care must be
378      * taken to not create reentrancy vulnerabilities. Consider using
379      * {ReentrancyGuard} or the
380      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
381      */
382     function sendValue(address payable recipient, uint256 amount) internal {
383         require(address(this).balance >= amount, "Address: insufficient balance");
384 
385         (bool success, ) = recipient.call{value: amount}("");
386         require(success, "Address: unable to send value, recipient may have reverted");
387     }
388 
389     /**
390      * @dev Performs a Solidity function call using a low level `call`. A
391      * plain `call` is an unsafe replacement for a function call: use this
392      * function instead.
393      *
394      * If `target` reverts with a revert reason, it is bubbled up by this
395      * function (like regular Solidity function calls).
396      *
397      * Returns the raw returned data. To convert to the expected return value,
398      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
399      *
400      * Requirements:
401      *
402      * - `target` must be a contract.
403      * - calling `target` with `data` must not revert.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
408         return functionCall(target, data, "Address: low-level call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
413      * `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, 0, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but also transferring `value` wei to `target`.
428      *
429      * Requirements:
430      *
431      * - the calling contract must have an ETH balance of at least `value`.
432      * - the called Solidity function must be `payable`.
433      *
434      * _Available since v3.1._
435      */
436     function functionCallWithValue(
437         address target,
438         bytes memory data,
439         uint256 value
440     ) internal returns (bytes memory) {
441         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
446      * with `errorMessage` as a fallback revert reason when `target` reverts.
447      *
448      * _Available since v3.1._
449      */
450     function functionCallWithValue(
451         address target,
452         bytes memory data,
453         uint256 value,
454         string memory errorMessage
455     ) internal returns (bytes memory) {
456         require(address(this).balance >= value, "Address: insufficient balance for call");
457         require(isContract(target), "Address: call to non-contract");
458 
459         (bool success, bytes memory returndata) = target.call{value: value}(data);
460         return verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465      * but performing a static call.
466      *
467      * _Available since v3.3._
468      */
469     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
470         return functionStaticCall(target, data, "Address: low-level static call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
475      * but performing a static call.
476      *
477      * _Available since v3.3._
478      */
479     function functionStaticCall(
480         address target,
481         bytes memory data,
482         string memory errorMessage
483     ) internal view returns (bytes memory) {
484         require(isContract(target), "Address: static call to non-contract");
485 
486         (bool success, bytes memory returndata) = target.staticcall(data);
487         return verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but performing a delegate call.
493      *
494      * _Available since v3.4._
495      */
496     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
497         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
502      * but performing a delegate call.
503      *
504      * _Available since v3.4._
505      */
506     function functionDelegateCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         require(isContract(target), "Address: delegate call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.delegatecall(data);
514         return verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
519      * revert reason using the provided one.
520      *
521      * _Available since v4.3._
522      */
523     function verifyCallResult(
524         bool success,
525         bytes memory returndata,
526         string memory errorMessage
527     ) internal pure returns (bytes memory) {
528         if (success) {
529             return returndata;
530         } else {
531             // Look for revert reason and bubble it up if present
532             if (returndata.length > 0) {
533                 // The easiest way to bubble the revert reason is using memory via assembly
534 
535                 assembly {
536                     let returndata_size := mload(returndata)
537                     revert(add(32, returndata), returndata_size)
538                 }
539             } else {
540                 revert(errorMessage);
541             }
542         }
543     }
544 }
545 
546 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @title ERC721 token receiver interface
555  * @dev Interface for any contract that wants to support safeTransfers
556  * from ERC721 asset contracts.
557  */
558 interface IERC721Receiver {
559     /**
560      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
561      * by `operator` from `from`, this function is called.
562      *
563      * It must return its Solidity selector to confirm the token transfer.
564      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
565      *
566      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
567      */
568     function onERC721Received(
569         address operator,
570         address from,
571         uint256 tokenId,
572         bytes calldata data
573     ) external returns (bytes4);
574 }
575 
576 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
577 
578 
579 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @dev Interface of the ERC165 standard, as defined in the
585  * https://eips.ethereum.org/EIPS/eip-165[EIP].
586  *
587  * Implementers can declare support of contract interfaces, which can then be
588  * queried by others ({ERC165Checker}).
589  *
590  * For an implementation, see {ERC165}.
591  */
592 interface IERC165 {
593     /**
594      * @dev Returns true if this contract implements the interface defined by
595      * `interfaceId`. See the corresponding
596      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
597      * to learn more about how these ids are created.
598      *
599      * This function call must use less than 30 000 gas.
600      */
601     function supportsInterface(bytes4 interfaceId) external view returns (bool);
602 }
603 
604 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
605 
606 
607 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 
612 /**
613  * @dev Implementation of the {IERC165} interface.
614  *
615  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
616  * for the additional interface id that will be supported. For example:
617  *
618  * ```solidity
619  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
620  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
621  * }
622  * ```
623  *
624  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
625  */
626 abstract contract ERC165 is IERC165 {
627     /**
628      * @dev See {IERC165-supportsInterface}.
629      */
630     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
631         return interfaceId == type(IERC165).interfaceId;
632     }
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @dev Required interface of an ERC721 compliant contract.
645  */
646 interface IERC721 is IERC165 {
647     /**
648      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
649      */
650     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
651 
652     /**
653      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
654      */
655     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
656 
657     /**
658      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
659      */
660     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
661 
662     /**
663      * @dev Returns the number of tokens in ``owner``'s account.
664      */
665     function balanceOf(address owner) external view returns (uint256 balance);
666 
667     /**
668      * @dev Returns the owner of the `tokenId` token.
669      *
670      * Requirements:
671      *
672      * - `tokenId` must exist.
673      */
674     function ownerOf(uint256 tokenId) external view returns (address owner);
675 
676     /**
677      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
678      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
679      *
680      * Requirements:
681      *
682      * - `from` cannot be the zero address.
683      * - `to` cannot be the zero address.
684      * - `tokenId` token must exist and be owned by `from`.
685      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
686      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
687      *
688      * Emits a {Transfer} event.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) external;
695 
696     /**
697      * @dev Transfers `tokenId` token from `from` to `to`.
698      *
699      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
700      *
701      * Requirements:
702      *
703      * - `from` cannot be the zero address.
704      * - `to` cannot be the zero address.
705      * - `tokenId` token must be owned by `from`.
706      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
707      *
708      * Emits a {Transfer} event.
709      */
710     function transferFrom(
711         address from,
712         address to,
713         uint256 tokenId
714     ) external;
715 
716     /**
717      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
718      * The approval is cleared when the token is transferred.
719      *
720      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
721      *
722      * Requirements:
723      *
724      * - The caller must own the token or be an approved operator.
725      * - `tokenId` must exist.
726      *
727      * Emits an {Approval} event.
728      */
729     function approve(address to, uint256 tokenId) external;
730 
731     /**
732      * @dev Returns the account approved for `tokenId` token.
733      *
734      * Requirements:
735      *
736      * - `tokenId` must exist.
737      */
738     function getApproved(uint256 tokenId) external view returns (address operator);
739 
740     /**
741      * @dev Approve or remove `operator` as an operator for the caller.
742      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
743      *
744      * Requirements:
745      *
746      * - The `operator` cannot be the caller.
747      *
748      * Emits an {ApprovalForAll} event.
749      */
750     function setApprovalForAll(address operator, bool _approved) external;
751 
752     /**
753      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
754      *
755      * See {setApprovalForAll}
756      */
757     function isApprovedForAll(address owner, address operator) external view returns (bool);
758 
759     /**
760      * @dev Safely transfers `tokenId` token from `from` to `to`.
761      *
762      * Requirements:
763      *
764      * - `from` cannot be the zero address.
765      * - `to` cannot be the zero address.
766      * - `tokenId` token must exist and be owned by `from`.
767      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
769      *
770      * Emits a {Transfer} event.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 tokenId,
776         bytes calldata data
777     ) external;
778 }
779 
780 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
781 
782 
783 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 
788 /**
789  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
790  * @dev See https://eips.ethereum.org/EIPS/eip-721
791  */
792 interface IERC721Metadata is IERC721 {
793     /**
794      * @dev Returns the token collection name.
795      */
796     function name() external view returns (string memory);
797 
798     /**
799      * @dev Returns the token collection symbol.
800      */
801     function symbol() external view returns (string memory);
802 
803     /**
804      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
805      */
806     function tokenURI(uint256 tokenId) external view returns (string memory);
807 }
808 
809 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
810 
811 
812 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
813 
814 pragma solidity ^0.8.0;
815 
816 
817 
818 
819 
820 
821 
822 
823 /**
824  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
825  * the Metadata extension, but not including the Enumerable extension, which is available separately as
826  * {ERC721Enumerable}.
827  */
828 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
829     using Address for address;
830     using Strings for uint256;
831 
832     // Token name
833     string private _name;
834 
835     // Token symbol
836     string private _symbol;
837 
838     // Mapping from token ID to owner address
839     mapping(uint256 => address) private _owners;
840 
841     // Mapping owner address to token count
842     mapping(address => uint256) private _balances;
843 
844     // Mapping from token ID to approved address
845     mapping(uint256 => address) private _tokenApprovals;
846 
847     // Mapping from owner to operator approvals
848     mapping(address => mapping(address => bool)) private _operatorApprovals;
849 
850     /**
851      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
852      */
853     constructor(string memory name_, string memory symbol_) {
854         _name = name_;
855         _symbol = symbol_;
856     }
857 
858     /**
859      * @dev See {IERC165-supportsInterface}.
860      */
861     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
862         return
863             interfaceId == type(IERC721).interfaceId ||
864             interfaceId == type(IERC721Metadata).interfaceId ||
865             super.supportsInterface(interfaceId);
866     }
867 
868     /**
869      * @dev See {IERC721-balanceOf}.
870      */
871     function balanceOf(address owner) public view virtual override returns (uint256) {
872         require(owner != address(0), "ERC721: balance query for the zero address");
873         return _balances[owner];
874     }
875 
876     /**
877      * @dev See {IERC721-ownerOf}.
878      */
879     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
880         address owner = _owners[tokenId];
881         require(owner != address(0), "ERC721: owner query for nonexistent token");
882         return owner;
883     }
884 
885     /**
886      * @dev See {IERC721Metadata-name}.
887      */
888     function name() public view virtual override returns (string memory) {
889         return _name;
890     }
891 
892     /**
893      * @dev See {IERC721Metadata-symbol}.
894      */
895     function symbol() public view virtual override returns (string memory) {
896         return _symbol;
897     }
898 
899     /**
900      * @dev See {IERC721Metadata-tokenURI}.
901      */
902     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
903         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
904 
905         string memory baseURI = _baseURI();
906         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
907     }
908 
909     /**
910      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
911      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
912      * by default, can be overriden in child contracts.
913      */
914     function _baseURI() internal view virtual returns (string memory) {
915         return "";
916     }
917 
918     /**
919      * @dev See {IERC721-approve}.
920      */
921     function approve(address to, uint256 tokenId) public virtual override {
922         address owner = ERC721.ownerOf(tokenId);
923         require(to != owner, "ERC721: approval to current owner");
924 
925         require(
926             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
927             "ERC721: approve caller is not owner nor approved for all"
928         );
929 
930         _approve(to, tokenId);
931     }
932 
933     /**
934      * @dev See {IERC721-getApproved}.
935      */
936     function getApproved(uint256 tokenId) public view virtual override returns (address) {
937         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
938 
939         return _tokenApprovals[tokenId];
940     }
941 
942     /**
943      * @dev See {IERC721-setApprovalForAll}.
944      */
945     function setApprovalForAll(address operator, bool approved) public virtual override {
946         _setApprovalForAll(_msgSender(), operator, approved);
947     }
948 
949     /**
950      * @dev See {IERC721-isApprovedForAll}.
951      */
952     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
953         return _operatorApprovals[owner][operator];
954     }
955 
956     /**
957      * @dev See {IERC721-transferFrom}.
958      */
959     function transferFrom(
960         address from,
961         address to,
962         uint256 tokenId
963     ) public virtual override {
964         //solhint-disable-next-line max-line-length
965         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
966 
967         _transfer(from, to, tokenId);
968     }
969 
970     /**
971      * @dev See {IERC721-safeTransferFrom}.
972      */
973     function safeTransferFrom(
974         address from,
975         address to,
976         uint256 tokenId
977     ) public virtual override {
978         safeTransferFrom(from, to, tokenId, "");
979     }
980 
981     /**
982      * @dev See {IERC721-safeTransferFrom}.
983      */
984     function safeTransferFrom(
985         address from,
986         address to,
987         uint256 tokenId,
988         bytes memory _data
989     ) public virtual override {
990         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
991         _safeTransfer(from, to, tokenId, _data);
992     }
993 
994     /**
995      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
996      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
997      *
998      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
999      *
1000      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1001      * implement alternative mechanisms to perform token transfer, such as signature-based.
1002      *
1003      * Requirements:
1004      *
1005      * - `from` cannot be the zero address.
1006      * - `to` cannot be the zero address.
1007      * - `tokenId` token must exist and be owned by `from`.
1008      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _safeTransfer(
1013         address from,
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) internal virtual {
1018         _transfer(from, to, tokenId);
1019         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1020     }
1021 
1022     /**
1023      * @dev Returns whether `tokenId` exists.
1024      *
1025      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1026      *
1027      * Tokens start existing when they are minted (`_mint`),
1028      * and stop existing when they are burned (`_burn`).
1029      */
1030     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1031         return _owners[tokenId] != address(0);
1032     }
1033 
1034     /**
1035      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1036      *
1037      * Requirements:
1038      *
1039      * - `tokenId` must exist.
1040      */
1041     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1042         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1043         address owner = ERC721.ownerOf(tokenId);
1044         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1045     }
1046 
1047     /**
1048      * @dev Safely mints `tokenId` and transfers it to `to`.
1049      *
1050      * Requirements:
1051      *
1052      * - `tokenId` must not exist.
1053      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _safeMint(address to, uint256 tokenId) internal virtual {
1058         _safeMint(to, tokenId, "");
1059     }
1060 
1061     /**
1062      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1063      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1064      */
1065     function _safeMint(
1066         address to,
1067         uint256 tokenId,
1068         bytes memory _data
1069     ) internal virtual {
1070         _mint(to, tokenId);
1071         require(
1072             _checkOnERC721Received(address(0), to, tokenId, _data),
1073             "ERC721: transfer to non ERC721Receiver implementer"
1074         );
1075     }
1076 
1077     /**
1078      * @dev Mints `tokenId` and transfers it to `to`.
1079      *
1080      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1081      *
1082      * Requirements:
1083      *
1084      * - `tokenId` must not exist.
1085      * - `to` cannot be the zero address.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _mint(address to, uint256 tokenId) internal virtual {
1090         require(to != address(0), "ERC721: mint to the zero address");
1091         require(!_exists(tokenId), "ERC721: token already minted");
1092 
1093         _beforeTokenTransfer(address(0), to, tokenId);
1094 
1095         _balances[to] += 1;
1096         _owners[tokenId] = to;
1097 
1098         emit Transfer(address(0), to, tokenId);
1099     }
1100 
1101     /**
1102      * @dev Destroys `tokenId`.
1103      * The approval is cleared when the token is burned.
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must exist.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _burn(uint256 tokenId) internal virtual {
1112         address owner = ERC721.ownerOf(tokenId);
1113 
1114         _beforeTokenTransfer(owner, address(0), tokenId);
1115 
1116         // Clear approvals
1117         _approve(address(0), tokenId);
1118 
1119         _balances[owner] -= 1;
1120         delete _owners[tokenId];
1121 
1122         emit Transfer(owner, address(0), tokenId);
1123     }
1124 
1125     /**
1126      * @dev Transfers `tokenId` from `from` to `to`.
1127      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1128      *
1129      * Requirements:
1130      *
1131      * - `to` cannot be the zero address.
1132      * - `tokenId` token must be owned by `from`.
1133      *
1134      * Emits a {Transfer} event.
1135      */
1136     function _transfer(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) internal virtual {
1141         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1142         require(to != address(0), "ERC721: transfer to the zero address");
1143 
1144         _beforeTokenTransfer(from, to, tokenId);
1145 
1146         // Clear approvals from the previous owner
1147         _approve(address(0), tokenId);
1148 
1149         _balances[from] -= 1;
1150         _balances[to] += 1;
1151         _owners[tokenId] = to;
1152 
1153         emit Transfer(from, to, tokenId);
1154     }
1155 
1156     /**
1157      * @dev Approve `to` to operate on `tokenId`
1158      *
1159      * Emits a {Approval} event.
1160      */
1161     function _approve(address to, uint256 tokenId) internal virtual {
1162         _tokenApprovals[tokenId] = to;
1163         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1164     }
1165 
1166     /**
1167      * @dev Approve `operator` to operate on all of `owner` tokens
1168      *
1169      * Emits a {ApprovalForAll} event.
1170      */
1171     function _setApprovalForAll(
1172         address owner,
1173         address operator,
1174         bool approved
1175     ) internal virtual {
1176         require(owner != operator, "ERC721: approve to caller");
1177         _operatorApprovals[owner][operator] = approved;
1178         emit ApprovalForAll(owner, operator, approved);
1179     }
1180 
1181     /**
1182      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1183      * The call is not executed if the target address is not a contract.
1184      *
1185      * @param from address representing the previous owner of the given token ID
1186      * @param to target address that will receive the tokens
1187      * @param tokenId uint256 ID of the token to be transferred
1188      * @param _data bytes optional data to send along with the call
1189      * @return bool whether the call correctly returned the expected magic value
1190      */
1191     function _checkOnERC721Received(
1192         address from,
1193         address to,
1194         uint256 tokenId,
1195         bytes memory _data
1196     ) private returns (bool) {
1197         if (to.isContract()) {
1198             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1199                 return retval == IERC721Receiver.onERC721Received.selector;
1200             } catch (bytes memory reason) {
1201                 if (reason.length == 0) {
1202                     revert("ERC721: transfer to non ERC721Receiver implementer");
1203                 } else {
1204                     assembly {
1205                         revert(add(32, reason), mload(reason))
1206                     }
1207                 }
1208             }
1209         } else {
1210             return true;
1211         }
1212     }
1213 
1214     /**
1215      * @dev Hook that is called before any token transfer. This includes minting
1216      * and burning.
1217      *
1218      * Calling conditions:
1219      *
1220      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1221      * transferred to `to`.
1222      * - When `from` is zero, `tokenId` will be minted for `to`.
1223      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1224      * - `from` and `to` are never both zero.
1225      *
1226      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1227      */
1228     function _beforeTokenTransfer(
1229         address from,
1230         address to,
1231         uint256 tokenId
1232     ) internal virtual {}
1233 }
1234 
1235 // File: final/contracts/NFT_FINAL_CONTRACT_V2 (2).sol
1236 
1237 
1238 
1239 pragma solidity >=0.7.0 <0.9.0;
1240 
1241 // import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol";
1242 
1243 
1244 
1245 
1246 
1247 
1248 contract McNiftyNFT is ERC721, Ownable, LetsgoNFTBase {
1249   using Strings for uint256;
1250   using Counters for Counters.Counter;
1251 
1252   Counters.Counter private supply;
1253 
1254   string public xname = "McNiftyTrump";
1255   string public xsymbol = "MCNFT";
1256 
1257   constructor() ERC721(xname, xsymbol){
1258     status_airdrop = true;
1259     status_presale = true;
1260     status_revealed = true;
1261 
1262     url_revealedJSON = "ipfs://QmcE1zXDX5DDDfxqfz5BvZeCwNW9PBAEyj1xSHXQ4VXfwY/";
1263     url_collection = "https://gateway.pinata.cloud/ipfs/QmWhHAqNFVdtgHagLHKBLWNdm1uVShWdotkQA1STcGPkDe/";
1264 
1265     cost_presale = 100000000000000000;
1266     cost_publicSale = 150000000000000000;
1267 
1268     limit_mintPresale = 20;
1269     limit_mintPublicSale = 20;
1270     limit_airdropClaims = 100;
1271 
1272     total_NFTSupply = 10000;
1273   }
1274 
1275   string private url_revealedJSON;
1276   string private url_hiddenJSON;
1277   string private url_collection;
1278   string private url_hiddenImage;
1279 
1280   bytes32 private merkle_airdrop;
1281 
1282   bool public status_revealed;
1283   bool public status_paused;
1284   bool public status_presale;
1285   bool public status_airdrop;
1286 
1287   uint256 private report_totalWithdrawn;
1288   uint256 private report_totalRoyaltySales;
1289   uint256 private report_totalSales;
1290   uint256 private report_totalAirdropMinted;
1291 
1292   uint256 private limit_mintPresale;
1293   uint256 private limit_mintPublicSale;
1294   uint256 private limit_airdropClaims;
1295 
1296   uint256 private cost_presale;
1297   uint256 private cost_publicSale;
1298 
1299   uint256 private total_NFTSupply;
1300 
1301   uint256[] private list_royaltyAmounts;
1302   address[] private list_royaltyAddresses;
1303   address[] private list_airdropAddresses;
1304   address[] private list_airdropMintingAddresses;
1305   address[] private list_whitelistAddresses;
1306 
1307   mapping(address => uint256) public map_whitelistMinting;
1308   mapping(address => uint256) public map_airdropClaims;
1309   mapping(address => uint256) public map_airdropMintedClaims;
1310 
1311   bytes4 _interfaceId = 0xce77acc3;
1312   uint256 private _royalty = 500;
1313   mapping(uint256 => address) private _creators;
1314 
1315   function totalSupply() public view returns(uint256){
1316     return supply.current();
1317   }
1318 
1319   function _baseURI() internal view virtual override returns (string memory) {
1320     return url_revealedJSON;
1321   }
1322 
1323   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1324     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1325     
1326     if(status_revealed == false) {
1327       return url_hiddenJSON;
1328     }
1329 
1330     string memory currentBaseURI = _baseURI();
1331     return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json")) : "";
1332   }
1333 
1334   function isOwner() public view returns(bool){
1335     return msg.sender == owner();
1336   }
1337 
1338   function setPaused(bool _state) public onlyOwner {
1339     status_paused = _state;
1340   }
1341 
1342   function getCollectionURL(address addr) public view returns(string memory){
1343     if(addr == owner() || status_revealed){
1344       return url_collection;
1345     }
1346     return url_hiddenImage;
1347   }
1348 
1349   function computeCost(uint256 _mintAmount) private view returns(uint256){
1350     return (status_presale ? cost_presale : cost_publicSale) * _mintAmount;
1351   }
1352 
1353   function walletOfOwner(address _owner) public view returns (uint256[] memory){
1354     uint256 ownerTokenCount = balanceOf(_owner);
1355     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1356     
1357     uint256 currentTokenId = 1;
1358     uint256 ownedTokenIndex = 0;
1359 
1360     while(ownedTokenIndex < ownerTokenCount && currentTokenId <= total_NFTSupply){
1361       address currentTokenOwner = ownerOf(currentTokenId);
1362       if(currentTokenOwner == _owner){
1363         tokenIds[ownedTokenIndex] = currentTokenId;
1364         ownedTokenIndex += 1;
1365       }
1366       currentTokenId += 1;
1367     }
1368 
1369     return tokenIds;
1370   }
1371 
1372   function withdraw() public payable onlyOwner {
1373     uint256 amount = 0;
1374     uint256 i = 0; 
1375     uint balance = address(this).balance;
1376     uint256 remaining = balance;
1377     while(i < list_royaltyAmounts.length && remaining > 0){
1378       amount = balance * list_royaltyAmounts[i] / 100;
1379       remaining = remaining - amount;
1380       (bool o,) = payable(list_royaltyAddresses[i]).call{value: amount}("");
1381       require(o);
1382       i += 1;
1383     }
1384 
1385     if(remaining > 0){
1386       (bool a,) = payable(owner()).call{value: remaining}("");
1387       require(a);
1388     }
1389   }
1390 
1391   function mint(uint256 _mintAmount) public payable{
1392     require(!status_paused, "Minting is paused");
1393     require(supply.current() + _mintAmount <= total_NFTSupply, "Mint quantity exceeds max supply");
1394 
1395     if (!isOwner()) {
1396         require(msg.value >= computeCost(_mintAmount), "Cost is too low");
1397     }
1398 
1399     for (uint256 i = 1; i <= _mintAmount; i+=1) {
1400       supply.increment();
1401       _safeMint(msg.sender, supply.current());
1402      
1403       _creators[supply.current()] = msg.sender;
1404     }
1405   }
1406 
1407   function sendAirdrop(address[] memory addresses) public onlyOwner{
1408     require(status_airdrop, "Airdrop is not enabled");
1409     require(supply.current() + addresses.length < total_NFTSupply, "Airdrop addresses exceeds the total NFT supply");
1410     
1411     uint256 i = 0; 
1412     while(i < addresses.length){
1413       supply.increment();
1414       _safeMint(addresses[i], supply.current());
1415       map_airdropClaims[addresses[i]] += 1;
1416       i += 1; 
1417     }
1418   }
1419 
1420   function claimAirdrop(bytes32[] calldata _merkleProof) public {
1421     require(status_airdrop, "Airdrop is not enabled");
1422     require(report_totalAirdropMinted < limit_airdropClaims, "No more available airdrops.");
1423     uint256 claimed = map_airdropMintedClaims[msg.sender];
1424 
1425     require(claimed == 0, "Address already claimed");
1426 
1427     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1428     require(MerkleProof.verify(_merkleProof, merkle_airdrop, leaf), "Invalid proof");
1429     map_airdropMintedClaims[msg.sender] += 1;
1430     supply.increment();
1431     _safeMint(msg.sender, supply.current());
1432     report_totalAirdropMinted += 1;
1433   }
1434 
1435   function bulkTransfer(uint256[] memory tokenIds, address receiver) public{
1436     uint256[] memory ownedTokens = walletOfOwner(msg.sender);
1437 
1438     uint256 i = 0; 
1439     uint256 j = 0;
1440     while(i < tokenIds.length){
1441       j = 0;
1442       while(j < ownedTokens.length){
1443         if(tokenIds[i] == ownedTokens[j]){
1444           _transfer(msg.sender, receiver, ownedTokens[j]);
1445         }
1446         j+=1; 
1447       }
1448       i+=1;
1449     }
1450   }
1451 
1452   function setSettings(
1453     uint256 xPublicSaleCost,
1454     uint256 xPreSaleCost,
1455     uint256 xtotalNFTSupply,
1456     uint256 xMaxMintQuantity,
1457     uint256 xNFTPerAddressLimit,
1458     uint256[] memory xRoyalty,
1459     address[] memory xRoyaltyAddress,
1460     bool xPaused,
1461     bool xRevealed,
1462     bool xPreSaleEnabled
1463     ) public onlyOwner{
1464     cost_publicSale = xPublicSaleCost;
1465     cost_presale = xPreSaleCost;
1466     total_NFTSupply = xtotalNFTSupply;
1467     limit_mintPublicSale = xMaxMintQuantity;
1468     limit_mintPresale = xNFTPerAddressLimit;
1469     list_royaltyAmounts = xRoyalty;
1470     list_royaltyAddresses = xRoyaltyAddress;
1471     status_paused = xPaused;
1472     status_revealed = xRevealed;
1473     status_presale = xPreSaleEnabled;
1474   }
1475 
1476   function setURL(
1477     string memory newBaseURL, 
1478     string memory newNotRevealedURL,
1479     string memory newArtURL,
1480     string memory newHiddenArtURL
1481     ) public onlyOwner{
1482     url_revealedJSON = newBaseURL;
1483     url_hiddenJSON = newNotRevealedURL;
1484     url_collection = newArtURL;
1485     url_hiddenImage = newHiddenArtURL;
1486   }
1487 
1488   function setAirdrop(
1489     bool xAirdropEnabled, 
1490     bytes32 xAirdropAddresses,
1491     bool updateAddress,
1492     uint256 xAirdropLimit
1493     ) public onlyOwner{
1494     status_airdrop = xAirdropEnabled;
1495     limit_airdropClaims = xAirdropLimit;
1496     if(updateAddress){
1497       merkle_airdrop = xAirdropAddresses;
1498     }
1499   }
1500 
1501   function setWhitelist(
1502     address[] memory addresses
1503   ) public onlyOwner{
1504     list_whitelistAddresses = addresses;
1505   }
1506 
1507   function getAirdropClaims(address addr, bool isMinted) public view returns (uint256){
1508     if(isMinted){
1509       return map_airdropMintedClaims[addr];
1510     }
1511     return map_airdropClaims[addr];
1512   }
1513 
1514   function getSettings()public view returns(
1515     uint256, 
1516     uint256, 
1517     uint256, 
1518     uint256, 
1519     uint256, 
1520     uint256, 
1521     uint256[] memory, 
1522     address[] memory, 
1523     bool, bool, bool, 
1524     address[] memory){
1525     return (
1526       cost_publicSale,
1527       cost_presale,
1528       total_NFTSupply,
1529       totalSupply(),
1530       limit_mintPublicSale,
1531       limit_mintPresale,
1532       list_royaltyAmounts,
1533       list_royaltyAddresses,
1534       status_paused,
1535       status_revealed,
1536       status_presale, 
1537       list_whitelistAddresses
1538     );
1539   }
1540 
1541   function getAirdropSettings(address sender) public view returns(
1542     bool, 
1543     uint256,
1544     uint256,
1545     uint256,
1546     uint256,
1547     address[] memory,
1548     address[] memory){
1549     return (
1550       status_airdrop, 
1551       report_totalAirdropMinted,
1552       limit_airdropClaims,
1553       map_airdropClaims[sender], 
1554       map_airdropMintedClaims[sender],
1555       list_airdropAddresses,
1556       list_airdropMintingAddresses
1557     );
1558   }
1559 
1560   function getURLs(address addr) public view returns(
1561     string memory, 
1562     string memory, 
1563     string memory, 
1564     string memory, 
1565     string memory, 
1566     string memory){
1567     return (
1568       url_revealedJSON, 
1569       url_hiddenJSON, 
1570       getCollectionURL(addr), 
1571       url_hiddenImage, 
1572       xname, 
1573       xsymbol
1574     );
1575   }
1576 
1577   function getSales() public view returns(
1578     uint256, 
1579     uint256, 
1580     uint256, 
1581     uint256){
1582     return(
1583       report_totalSales, 
1584       report_totalRoyaltySales, 
1585       report_totalWithdrawn, 
1586       address(this).balance
1587     );
1588   }
1589 
1590    function getRoyalty(uint256 tokenId) external view returns (uint256) {
1591         return _royalty;
1592     }
1593 
1594     function getCreator(uint256 tokenId) external view returns (address) {
1595         return _creators[tokenId];
1596     }
1597 
1598     function getCoCreators(uint256 tokenId) external view returns (AddreessWithPercent[] memory) {
1599         AddreessWithPercent[] memory array;
1600         return array;
1601     }
1602 
1603     function supportsInterface(bytes4 interfaceId)
1604         public
1605         view
1606         virtual
1607         override(ERC721)
1608         returns (bool)
1609     {
1610         return
1611             interfaceId == _interfaceId || super.supportsInterface(interfaceId);
1612     }
1613 }