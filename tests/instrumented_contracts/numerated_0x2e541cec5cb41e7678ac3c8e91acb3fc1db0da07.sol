1 // File: @openzeppelin/contracts@4.6.0/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
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
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
39      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
40      * hash matches the root of the tree. When processing the proof, the pairs
41      * of leafs & pre-images are assumed to be sorted.
42      *
43      * _Available since v4.4._
44      */
45     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
46         bytes32 computedHash = leaf;
47         for (uint256 i = 0; i < proof.length; i++) {
48             bytes32 proofElement = proof[i];
49             if (computedHash <= proofElement) {
50                 // Hash(current computed hash + current element of the proof)
51                 computedHash = _efficientHash(computedHash, proofElement);
52             } else {
53                 // Hash(current element of the proof + current computed hash)
54                 computedHash = _efficientHash(proofElement, computedHash);
55             }
56         }
57         return computedHash;
58     }
59 
60     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
61         assembly {
62             mstore(0x00, a)
63             mstore(0x20, b)
64             value := keccak256(0x00, 0x40)
65         }
66     }
67 }
68 
69 // File: @openzeppelin/contracts@4.6.0/utils/Counters.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @title Counters
78  * @author Matt Condon (@shrugs)
79  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
80  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
81  *
82  * Include with `using Counters for Counters.Counter;`
83  */
84 library Counters {
85     struct Counter {
86         // This variable should never be directly accessed by users of the library: interactions must be restricted to
87         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
88         // this feature: see https://github.com/ethereum/solidity/issues/4637
89         uint256 _value; // default: 0
90     }
91 
92     function current(Counter storage counter) internal view returns (uint256) {
93         return counter._value;
94     }
95 
96     function increment(Counter storage counter) internal {
97         unchecked {
98             counter._value += 1;
99         }
100     }
101 
102     function decrement(Counter storage counter) internal {
103         uint256 value = counter._value;
104         require(value > 0, "Counter: decrement overflow");
105         unchecked {
106             counter._value = value - 1;
107         }
108     }
109 
110     function reset(Counter storage counter) internal {
111         counter._value = 0;
112     }
113 }
114 
115 // File: @openzeppelin/contracts@4.6.0/utils/Strings.sol
116 
117 
118 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev String operations.
124  */
125 library Strings {
126     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
130      */
131     function toString(uint256 value) internal pure returns (string memory) {
132         // Inspired by OraclizeAPI's implementation - MIT licence
133         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
134 
135         if (value == 0) {
136             return "0";
137         }
138         uint256 temp = value;
139         uint256 digits;
140         while (temp != 0) {
141             digits++;
142             temp /= 10;
143         }
144         bytes memory buffer = new bytes(digits);
145         while (value != 0) {
146             digits -= 1;
147             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
148             value /= 10;
149         }
150         return string(buffer);
151     }
152 
153     /**
154      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
155      */
156     function toHexString(uint256 value) internal pure returns (string memory) {
157         if (value == 0) {
158             return "0x00";
159         }
160         uint256 temp = value;
161         uint256 length = 0;
162         while (temp != 0) {
163             length++;
164             temp >>= 8;
165         }
166         return toHexString(value, length);
167     }
168 
169     /**
170      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
171      */
172     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
173         bytes memory buffer = new bytes(2 * length + 2);
174         buffer[0] = "0";
175         buffer[1] = "x";
176         for (uint256 i = 2 * length + 1; i > 1; --i) {
177             buffer[i] = _HEX_SYMBOLS[value & 0xf];
178             value >>= 4;
179         }
180         require(value == 0, "Strings: hex length insufficient");
181         return string(buffer);
182     }
183 }
184 
185 // File: @openzeppelin/contracts@4.6.0/utils/Context.sol
186 
187 
188 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 /**
193  * @dev Provides information about the current execution context, including the
194  * sender of the transaction and its data. While these are generally available
195  * via msg.sender and msg.data, they should not be accessed in such a direct
196  * manner, since when dealing with meta-transactions the account sending and
197  * paying for execution may not be the actual sender (as far as an application
198  * is concerned).
199  *
200  * This contract is only required for intermediate, library-like contracts.
201  */
202 abstract contract Context {
203     function _msgSender() internal view virtual returns (address) {
204         return msg.sender;
205     }
206 
207     function _msgData() internal view virtual returns (bytes calldata) {
208         return msg.data;
209     }
210 }
211 
212 // File: @openzeppelin/contracts@4.6.0/security/Pausable.sol
213 
214 
215 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
216 
217 pragma solidity ^0.8.0;
218 
219 
220 /**
221  * @dev Contract module which allows children to implement an emergency stop
222  * mechanism that can be triggered by an authorized account.
223  *
224  * This module is used through inheritance. It will make available the
225  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
226  * the functions of your contract. Note that they will not be pausable by
227  * simply including this module, only once the modifiers are put in place.
228  */
229 abstract contract Pausable is Context {
230     /**
231      * @dev Emitted when the pause is triggered by `account`.
232      */
233     event Paused(address account);
234 
235     /**
236      * @dev Emitted when the pause is lifted by `account`.
237      */
238     event Unpaused(address account);
239 
240     bool private _paused;
241 
242     /**
243      * @dev Initializes the contract in unpaused state.
244      */
245     constructor() {
246         _paused = false;
247     }
248 
249     /**
250      * @dev Returns true if the contract is paused, and false otherwise.
251      */
252     function paused() public view virtual returns (bool) {
253         return _paused;
254     }
255 
256     /**
257      * @dev Modifier to make a function callable only when the contract is not paused.
258      *
259      * Requirements:
260      *
261      * - The contract must not be paused.
262      */
263     modifier whenNotPaused() {
264         require(!paused(), "Pausable: paused");
265         _;
266     }
267 
268     /**
269      * @dev Modifier to make a function callable only when the contract is paused.
270      *
271      * Requirements:
272      *
273      * - The contract must be paused.
274      */
275     modifier whenPaused() {
276         require(paused(), "Pausable: not paused");
277         _;
278     }
279 
280     /**
281      * @dev Triggers stopped state.
282      *
283      * Requirements:
284      *
285      * - The contract must not be paused.
286      */
287     function _pause() internal virtual whenNotPaused {
288         _paused = true;
289         emit Paused(_msgSender());
290     }
291 
292     /**
293      * @dev Returns to normal state.
294      *
295      * Requirements:
296      *
297      * - The contract must be paused.
298      */
299     function _unpause() internal virtual whenPaused {
300         _paused = false;
301         emit Unpaused(_msgSender());
302     }
303 }
304 
305 // File: @openzeppelin/contracts@4.6.0/access/Ownable.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 
313 /**
314  * @dev Contract module which provides a basic access control mechanism, where
315  * there is an account (an owner) that can be granted exclusive access to
316  * specific functions.
317  *
318  * By default, the owner account will be the one that deploys the contract. This
319  * can later be changed with {transferOwnership}.
320  *
321  * This module is used through inheritance. It will make available the modifier
322  * `onlyOwner`, which can be applied to your functions to restrict their use to
323  * the owner.
324  */
325 abstract contract Ownable is Context {
326     address private _owner;
327 
328     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
329 
330     /**
331      * @dev Initializes the contract setting the deployer as the initial owner.
332      */
333     constructor() {
334         _transferOwnership(_msgSender());
335     }
336 
337     /**
338      * @dev Returns the address of the current owner.
339      */
340     function owner() public view virtual returns (address) {
341         return _owner;
342     }
343 
344     /**
345      * @dev Throws if called by any account other than the owner.
346      */
347     modifier onlyOwner() {
348         require(owner() == _msgSender(), "Ownable: caller is not the owner");
349         _;
350     }
351 
352     /**
353      * @dev Leaves the contract without owner. It will not be possible to call
354      * `onlyOwner` functions anymore. Can only be called by the current owner.
355      *
356      * NOTE: Renouncing ownership will leave the contract without an owner,
357      * thereby removing any functionality that is only available to the owner.
358      */
359     function renounceOwnership() public virtual onlyOwner {
360         _transferOwnership(address(0));
361     }
362 
363     /**
364      * @dev Transfers ownership of the contract to a new account (`newOwner`).
365      * Can only be called by the current owner.
366      */
367     function transferOwnership(address newOwner) public virtual onlyOwner {
368         require(newOwner != address(0), "Ownable: new owner is the zero address");
369         _transferOwnership(newOwner);
370     }
371 
372     /**
373      * @dev Transfers ownership of the contract to a new account (`newOwner`).
374      * Internal function without access restriction.
375      */
376     function _transferOwnership(address newOwner) internal virtual {
377         address oldOwner = _owner;
378         _owner = newOwner;
379         emit OwnershipTransferred(oldOwner, newOwner);
380     }
381 }
382 
383 // File: @openzeppelin/contracts@4.6.0/utils/Address.sol
384 
385 
386 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
387 
388 pragma solidity ^0.8.1;
389 
390 /**
391  * @dev Collection of functions related to the address type
392  */
393 library Address {
394     /**
395      * @dev Returns true if `account` is a contract.
396      *
397      * [IMPORTANT]
398      * ====
399      * It is unsafe to assume that an address for which this function returns
400      * false is an externally-owned account (EOA) and not a contract.
401      *
402      * Among others, `isContract` will return false for the following
403      * types of addresses:
404      *
405      *  - an externally-owned account
406      *  - a contract in construction
407      *  - an address where a contract will be created
408      *  - an address where a contract lived, but was destroyed
409      * ====
410      *
411      * [IMPORTANT]
412      * ====
413      * You shouldn't rely on `isContract` to protect against flash loan attacks!
414      *
415      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
416      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
417      * constructor.
418      * ====
419      */
420     function isContract(address account) internal view returns (bool) {
421         // This method relies on extcodesize/address.code.length, which returns 0
422         // for contracts in construction, since the code is only stored at the end
423         // of the constructor execution.
424 
425         return account.code.length > 0;
426     }
427 
428     /**
429      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
430      * `recipient`, forwarding all available gas and reverting on errors.
431      *
432      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
433      * of certain opcodes, possibly making contracts go over the 2300 gas limit
434      * imposed by `transfer`, making them unable to receive funds via
435      * `transfer`. {sendValue} removes this limitation.
436      *
437      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
438      *
439      * IMPORTANT: because control is transferred to `recipient`, care must be
440      * taken to not create reentrancy vulnerabilities. Consider using
441      * {ReentrancyGuard} or the
442      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
443      */
444     function sendValue(address payable recipient, uint256 amount) internal {
445         require(address(this).balance >= amount, "Address: insufficient balance");
446 
447         (bool success, ) = recipient.call{value: amount}("");
448         require(success, "Address: unable to send value, recipient may have reverted");
449     }
450 
451     /**
452      * @dev Performs a Solidity function call using a low level `call`. A
453      * plain `call` is an unsafe replacement for a function call: use this
454      * function instead.
455      *
456      * If `target` reverts with a revert reason, it is bubbled up by this
457      * function (like regular Solidity function calls).
458      *
459      * Returns the raw returned data. To convert to the expected return value,
460      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
461      *
462      * Requirements:
463      *
464      * - `target` must be a contract.
465      * - calling `target` with `data` must not revert.
466      *
467      * _Available since v3.1._
468      */
469     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
470         return functionCall(target, data, "Address: low-level call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
475      * `errorMessage` as a fallback revert reason when `target` reverts.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(
480         address target,
481         bytes memory data,
482         string memory errorMessage
483     ) internal returns (bytes memory) {
484         return functionCallWithValue(target, data, 0, errorMessage);
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
489      * but also transferring `value` wei to `target`.
490      *
491      * Requirements:
492      *
493      * - the calling contract must have an ETH balance of at least `value`.
494      * - the called Solidity function must be `payable`.
495      *
496      * _Available since v3.1._
497      */
498     function functionCallWithValue(
499         address target,
500         bytes memory data,
501         uint256 value
502     ) internal returns (bytes memory) {
503         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
508      * with `errorMessage` as a fallback revert reason when `target` reverts.
509      *
510      * _Available since v3.1._
511      */
512     function functionCallWithValue(
513         address target,
514         bytes memory data,
515         uint256 value,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         require(address(this).balance >= value, "Address: insufficient balance for call");
519         require(isContract(target), "Address: call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.call{value: value}(data);
522         return verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
527      * but performing a static call.
528      *
529      * _Available since v3.3._
530      */
531     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
532         return functionStaticCall(target, data, "Address: low-level static call failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
537      * but performing a static call.
538      *
539      * _Available since v3.3._
540      */
541     function functionStaticCall(
542         address target,
543         bytes memory data,
544         string memory errorMessage
545     ) internal view returns (bytes memory) {
546         require(isContract(target), "Address: static call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.staticcall(data);
549         return verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but performing a delegate call.
555      *
556      * _Available since v3.4._
557      */
558     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
559         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
564      * but performing a delegate call.
565      *
566      * _Available since v3.4._
567      */
568     function functionDelegateCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal returns (bytes memory) {
573         require(isContract(target), "Address: delegate call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.delegatecall(data);
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
581      * revert reason using the provided one.
582      *
583      * _Available since v4.3._
584      */
585     function verifyCallResult(
586         bool success,
587         bytes memory returndata,
588         string memory errorMessage
589     ) internal pure returns (bytes memory) {
590         if (success) {
591             return returndata;
592         } else {
593             // Look for revert reason and bubble it up if present
594             if (returndata.length > 0) {
595                 // The easiest way to bubble the revert reason is using memory via assembly
596 
597                 assembly {
598                     let returndata_size := mload(returndata)
599                     revert(add(32, returndata), returndata_size)
600                 }
601             } else {
602                 revert(errorMessage);
603             }
604         }
605     }
606 }
607 
608 // File: @openzeppelin/contracts@4.6.0/token/ERC721/IERC721Receiver.sol
609 
610 
611 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 /**
616  * @title ERC721 token receiver interface
617  * @dev Interface for any contract that wants to support safeTransfers
618  * from ERC721 asset contracts.
619  */
620 interface IERC721Receiver {
621     /**
622      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
623      * by `operator` from `from`, this function is called.
624      *
625      * It must return its Solidity selector to confirm the token transfer.
626      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
627      *
628      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
629      */
630     function onERC721Received(
631         address operator,
632         address from,
633         uint256 tokenId,
634         bytes calldata data
635     ) external returns (bytes4);
636 }
637 
638 // File: @openzeppelin/contracts@4.6.0/utils/introspection/IERC165.sol
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 /**
646  * @dev Interface of the ERC165 standard, as defined in the
647  * https://eips.ethereum.org/EIPS/eip-165[EIP].
648  *
649  * Implementers can declare support of contract interfaces, which can then be
650  * queried by others ({ERC165Checker}).
651  *
652  * For an implementation, see {ERC165}.
653  */
654 interface IERC165 {
655     /**
656      * @dev Returns true if this contract implements the interface defined by
657      * `interfaceId`. See the corresponding
658      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
659      * to learn more about how these ids are created.
660      *
661      * This function call must use less than 30 000 gas.
662      */
663     function supportsInterface(bytes4 interfaceId) external view returns (bool);
664 }
665 
666 // File: @openzeppelin/contracts@4.6.0/interfaces/IERC2981.sol
667 
668 
669 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @dev Interface for the NFT Royalty Standard.
676  *
677  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
678  * support for royalty payments across all NFT marketplaces and ecosystem participants.
679  *
680  * _Available since v4.5._
681  */
682 interface IERC2981 is IERC165 {
683     /**
684      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
685      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
686      */
687     function royaltyInfo(uint256 tokenId, uint256 salePrice)
688         external
689         view
690         returns (address receiver, uint256 royaltyAmount);
691 }
692 
693 // File: @openzeppelin/contracts@4.6.0/utils/introspection/ERC165.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @dev Implementation of the {IERC165} interface.
703  *
704  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
705  * for the additional interface id that will be supported. For example:
706  *
707  * ```solidity
708  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
709  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
710  * }
711  * ```
712  *
713  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
714  */
715 abstract contract ERC165 is IERC165 {
716     /**
717      * @dev See {IERC165-supportsInterface}.
718      */
719     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
720         return interfaceId == type(IERC165).interfaceId;
721     }
722 }
723 
724 // File: @openzeppelin/contracts@4.6.0/token/ERC721/IERC721.sol
725 
726 
727 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @dev Required interface of an ERC721 compliant contract.
734  */
735 interface IERC721 is IERC165 {
736     /**
737      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
738      */
739     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
740 
741     /**
742      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
743      */
744     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
745 
746     /**
747      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
748      */
749     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
750 
751     /**
752      * @dev Returns the number of tokens in ``owner``'s account.
753      */
754     function balanceOf(address owner) external view returns (uint256 balance);
755 
756     /**
757      * @dev Returns the owner of the `tokenId` token.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function ownerOf(uint256 tokenId) external view returns (address owner);
764 
765     /**
766      * @dev Safely transfers `tokenId` token from `from` to `to`.
767      *
768      * Requirements:
769      *
770      * - `from` cannot be the zero address.
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must exist and be owned by `from`.
773      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function safeTransferFrom(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes calldata data
783     ) external;
784 
785     /**
786      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
787      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
788      *
789      * Requirements:
790      *
791      * - `from` cannot be the zero address.
792      * - `to` cannot be the zero address.
793      * - `tokenId` token must exist and be owned by `from`.
794      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
795      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
796      *
797      * Emits a {Transfer} event.
798      */
799     function safeTransferFrom(
800         address from,
801         address to,
802         uint256 tokenId
803     ) external;
804 
805     /**
806      * @dev Transfers `tokenId` token from `from` to `to`.
807      *
808      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
816      *
817      * Emits a {Transfer} event.
818      */
819     function transferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) external;
824 
825     /**
826      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
827      * The approval is cleared when the token is transferred.
828      *
829      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
830      *
831      * Requirements:
832      *
833      * - The caller must own the token or be an approved operator.
834      * - `tokenId` must exist.
835      *
836      * Emits an {Approval} event.
837      */
838     function approve(address to, uint256 tokenId) external;
839 
840     /**
841      * @dev Approve or remove `operator` as an operator for the caller.
842      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
843      *
844      * Requirements:
845      *
846      * - The `operator` cannot be the caller.
847      *
848      * Emits an {ApprovalForAll} event.
849      */
850     function setApprovalForAll(address operator, bool _approved) external;
851 
852     /**
853      * @dev Returns the account approved for `tokenId` token.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must exist.
858      */
859     function getApproved(uint256 tokenId) external view returns (address operator);
860 
861     /**
862      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
863      *
864      * See {setApprovalForAll}
865      */
866     function isApprovedForAll(address owner, address operator) external view returns (bool);
867 }
868 
869 // File: @openzeppelin/contracts@4.6.0/token/ERC721/extensions/IERC721Metadata.sol
870 
871 
872 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
873 
874 pragma solidity ^0.8.0;
875 
876 
877 /**
878  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
879  * @dev See https://eips.ethereum.org/EIPS/eip-721
880  */
881 interface IERC721Metadata is IERC721 {
882     /**
883      * @dev Returns the token collection name.
884      */
885     function name() external view returns (string memory);
886 
887     /**
888      * @dev Returns the token collection symbol.
889      */
890     function symbol() external view returns (string memory);
891 
892     /**
893      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
894      */
895     function tokenURI(uint256 tokenId) external view returns (string memory);
896 }
897 
898 // File: @openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol
899 
900 
901 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
902 
903 pragma solidity ^0.8.0;
904 
905 
906 
907 
908 
909 
910 
911 
912 /**
913  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
914  * the Metadata extension, but not including the Enumerable extension, which is available separately as
915  * {ERC721Enumerable}.
916  */
917 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
918     using Address for address;
919     using Strings for uint256;
920 
921     // Token name
922     string private _name;
923 
924     // Token symbol
925     string private _symbol;
926 
927     // Mapping from token ID to owner address
928     mapping(uint256 => address) private _owners;
929 
930     // Mapping owner address to token count
931     mapping(address => uint256) private _balances;
932 
933     // Mapping from token ID to approved address
934     mapping(uint256 => address) private _tokenApprovals;
935 
936     // Mapping from owner to operator approvals
937     mapping(address => mapping(address => bool)) private _operatorApprovals;
938 
939     /**
940      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
941      */
942     constructor(string memory name_, string memory symbol_) {
943         _name = name_;
944         _symbol = symbol_;
945     }
946 
947     /**
948      * @dev See {IERC165-supportsInterface}.
949      */
950     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
951         return
952             interfaceId == type(IERC721).interfaceId ||
953             interfaceId == type(IERC721Metadata).interfaceId ||
954             super.supportsInterface(interfaceId);
955     }
956 
957     /**
958      * @dev See {IERC721-balanceOf}.
959      */
960     function balanceOf(address owner) public view virtual override returns (uint256) {
961         require(owner != address(0), "ERC721: balance query for the zero address");
962         return _balances[owner];
963     }
964 
965     /**
966      * @dev See {IERC721-ownerOf}.
967      */
968     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
969         address owner = _owners[tokenId];
970         require(owner != address(0), "ERC721: owner query for nonexistent token");
971         return owner;
972     }
973 
974     /**
975      * @dev See {IERC721Metadata-name}.
976      */
977     function name() public view virtual override returns (string memory) {
978         return _name;
979     }
980 
981     /**
982      * @dev See {IERC721Metadata-symbol}.
983      */
984     function symbol() public view virtual override returns (string memory) {
985         return _symbol;
986     }
987 
988     /**
989      * @dev See {IERC721Metadata-tokenURI}.
990      */
991     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
992         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
993 
994         string memory baseURI = _baseURI();
995         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
996     }
997 
998     /**
999      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1000      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1001      * by default, can be overridden in child contracts.
1002      */
1003     function _baseURI() internal view virtual returns (string memory) {
1004         return "";
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-approve}.
1009      */
1010     function approve(address to, uint256 tokenId) public virtual override {
1011         address owner = ERC721.ownerOf(tokenId);
1012         require(to != owner, "ERC721: approval to current owner");
1013 
1014         require(
1015             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1016             "ERC721: approve caller is not owner nor approved for all"
1017         );
1018 
1019         _approve(to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-getApproved}.
1024      */
1025     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1026         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1027 
1028         return _tokenApprovals[tokenId];
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-setApprovalForAll}.
1033      */
1034     function setApprovalForAll(address operator, bool approved) public virtual override {
1035         _setApprovalForAll(_msgSender(), operator, approved);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-isApprovedForAll}.
1040      */
1041     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1042         return _operatorApprovals[owner][operator];
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-transferFrom}.
1047      */
1048     function transferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) public virtual override {
1053         //solhint-disable-next-line max-line-length
1054         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1055 
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
1066     ) public virtual override {
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
1078     ) public virtual override {
1079         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1080         _safeTransfer(from, to, tokenId, _data);
1081     }
1082 
1083     /**
1084      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1085      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1086      *
1087      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1088      *
1089      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1090      * implement alternative mechanisms to perform token transfer, such as signature-based.
1091      *
1092      * Requirements:
1093      *
1094      * - `from` cannot be the zero address.
1095      * - `to` cannot be the zero address.
1096      * - `tokenId` token must exist and be owned by `from`.
1097      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101     function _safeTransfer(
1102         address from,
1103         address to,
1104         uint256 tokenId,
1105         bytes memory _data
1106     ) internal virtual {
1107         _transfer(from, to, tokenId);
1108         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1109     }
1110 
1111     /**
1112      * @dev Returns whether `tokenId` exists.
1113      *
1114      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1115      *
1116      * Tokens start existing when they are minted (`_mint`),
1117      * and stop existing when they are burned (`_burn`).
1118      */
1119     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1120         return _owners[tokenId] != address(0);
1121     }
1122 
1123     /**
1124      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1125      *
1126      * Requirements:
1127      *
1128      * - `tokenId` must exist.
1129      */
1130     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1131         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1132         address owner = ERC721.ownerOf(tokenId);
1133         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1134     }
1135 
1136     /**
1137      * @dev Safely mints `tokenId` and transfers it to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - `tokenId` must not exist.
1142      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _safeMint(address to, uint256 tokenId) internal virtual {
1147         _safeMint(to, tokenId, "");
1148     }
1149 
1150     /**
1151      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1152      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1153      */
1154     function _safeMint(
1155         address to,
1156         uint256 tokenId,
1157         bytes memory _data
1158     ) internal virtual {
1159         _mint(to, tokenId);
1160         require(
1161             _checkOnERC721Received(address(0), to, tokenId, _data),
1162             "ERC721: transfer to non ERC721Receiver implementer"
1163         );
1164     }
1165 
1166     /**
1167      * @dev Mints `tokenId` and transfers it to `to`.
1168      *
1169      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1170      *
1171      * Requirements:
1172      *
1173      * - `tokenId` must not exist.
1174      * - `to` cannot be the zero address.
1175      *
1176      * Emits a {Transfer} event.
1177      */
1178     function _mint(address to, uint256 tokenId) internal virtual {
1179         require(to != address(0), "ERC721: mint to the zero address");
1180         require(!_exists(tokenId), "ERC721: token already minted");
1181 
1182         _beforeTokenTransfer(address(0), to, tokenId);
1183 
1184         _balances[to] += 1;
1185         _owners[tokenId] = to;
1186 
1187         emit Transfer(address(0), to, tokenId);
1188 
1189         _afterTokenTransfer(address(0), to, tokenId);
1190     }
1191 
1192     /**
1193      * @dev Destroys `tokenId`.
1194      * The approval is cleared when the token is burned.
1195      *
1196      * Requirements:
1197      *
1198      * - `tokenId` must exist.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _burn(uint256 tokenId) internal virtual {
1203         address owner = ERC721.ownerOf(tokenId);
1204 
1205         _beforeTokenTransfer(owner, address(0), tokenId);
1206 
1207         // Clear approvals
1208         _approve(address(0), tokenId);
1209 
1210         _balances[owner] -= 1;
1211         delete _owners[tokenId];
1212 
1213         emit Transfer(owner, address(0), tokenId);
1214 
1215         _afterTokenTransfer(owner, address(0), tokenId);
1216     }
1217 
1218     /**
1219      * @dev Transfers `tokenId` from `from` to `to`.
1220      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1221      *
1222      * Requirements:
1223      *
1224      * - `to` cannot be the zero address.
1225      * - `tokenId` token must be owned by `from`.
1226      *
1227      * Emits a {Transfer} event.
1228      */
1229     function _transfer(
1230         address from,
1231         address to,
1232         uint256 tokenId
1233     ) internal virtual {
1234         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1235         require(to != address(0), "ERC721: transfer to the zero address");
1236 
1237         _beforeTokenTransfer(from, to, tokenId);
1238 
1239         // Clear approvals from the previous owner
1240         _approve(address(0), tokenId);
1241 
1242         _balances[from] -= 1;
1243         _balances[to] += 1;
1244         _owners[tokenId] = to;
1245 
1246         emit Transfer(from, to, tokenId);
1247 
1248         _afterTokenTransfer(from, to, tokenId);
1249     }
1250 
1251     /**
1252      * @dev Approve `to` to operate on `tokenId`
1253      *
1254      * Emits a {Approval} event.
1255      */
1256     function _approve(address to, uint256 tokenId) internal virtual {
1257         _tokenApprovals[tokenId] = to;
1258         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1259     }
1260 
1261     /**
1262      * @dev Approve `operator` to operate on all of `owner` tokens
1263      *
1264      * Emits a {ApprovalForAll} event.
1265      */
1266     function _setApprovalForAll(
1267         address owner,
1268         address operator,
1269         bool approved
1270     ) internal virtual {
1271         require(owner != operator, "ERC721: approve to caller");
1272         _operatorApprovals[owner][operator] = approved;
1273         emit ApprovalForAll(owner, operator, approved);
1274     }
1275 
1276     /**
1277      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1278      * The call is not executed if the target address is not a contract.
1279      *
1280      * @param from address representing the previous owner of the given token ID
1281      * @param to target address that will receive the tokens
1282      * @param tokenId uint256 ID of the token to be transferred
1283      * @param _data bytes optional data to send along with the call
1284      * @return bool whether the call correctly returned the expected magic value
1285      */
1286     function _checkOnERC721Received(
1287         address from,
1288         address to,
1289         uint256 tokenId,
1290         bytes memory _data
1291     ) private returns (bool) {
1292         if (to.isContract()) {
1293             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1294                 return retval == IERC721Receiver.onERC721Received.selector;
1295             } catch (bytes memory reason) {
1296                 if (reason.length == 0) {
1297                     revert("ERC721: transfer to non ERC721Receiver implementer");
1298                 } else {
1299                     assembly {
1300                         revert(add(32, reason), mload(reason))
1301                     }
1302                 }
1303             }
1304         } else {
1305             return true;
1306         }
1307     }
1308 
1309     /**
1310      * @dev Hook that is called before any token transfer. This includes minting
1311      * and burning.
1312      *
1313      * Calling conditions:
1314      *
1315      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1316      * transferred to `to`.
1317      * - When `from` is zero, `tokenId` will be minted for `to`.
1318      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1319      * - `from` and `to` are never both zero.
1320      *
1321      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1322      */
1323     function _beforeTokenTransfer(
1324         address from,
1325         address to,
1326         uint256 tokenId
1327     ) internal virtual {}
1328 
1329     /**
1330      * @dev Hook that is called after any transfer of tokens. This includes
1331      * minting and burning.
1332      *
1333      * Calling conditions:
1334      *
1335      * - when `from` and `to` are both non-zero.
1336      * - `from` and `to` are never both zero.
1337      *
1338      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1339      */
1340     function _afterTokenTransfer(
1341         address from,
1342         address to,
1343         uint256 tokenId
1344     ) internal virtual {}
1345 }
1346 
1347 // File: ForTheCulture.sol
1348 
1349 
1350 pragma solidity 0.8.4;
1351 
1352 
1353 
1354 
1355 
1356 
1357 
1358 contract ForTheCulture is ERC721, Ownable, Pausable {
1359 
1360   using Strings for uint256;
1361   using Counters for Counters.Counter;
1362 
1363   Counters.Counter private supply;
1364   mapping (address => uint) nftCounts;
1365 
1366   bytes32 merkleRoot = 0x02d2116e529b013a2a97c380516706c46e0bf071f96cae1702ec5f41034a4d4b;
1367 
1368   string public uriPrefix = "https://nftftc.s3.eu-west-1.amazonaws.com/test_metadata/";
1369   string public uriSuffix = ".json";
1370 
1371   uint256 constant fee = 0.01 ether;
1372   uint256 constant maxSupply = 6969;
1373 
1374   uint256 constant mintAmount = 1;
1375   uint256 constant maxMintAmountPerTx = 1;
1376   uint256 constant maxMintAmountPerWallet = 1;
1377 
1378   bool public isWhitelistMintActive = false;
1379 
1380   address constant public royaltiesPayoutAddress = 0xfb4f09CEfD99b2e27dfB381ae7cA07D4551e7b3A;
1381   uint256 public royaltiesPercent = 1000; // out of 10000 = 10%
1382 
1383   event Received(address, uint);
1384 
1385   receive() external payable {
1386     emit Received(msg.sender, msg.value);
1387   }
1388 
1389   constructor() ERC721("For the Culture", "FTC") {}
1390 
1391   modifier onlyOrigin () {
1392     require(msg.sender == tx.origin, "Contract calls are not allowed");
1393     _;
1394   }
1395 
1396   function pause() public onlyOwner {
1397         _pause();
1398   }
1399 
1400   function unpause() public onlyOwner {
1401         _unpause();
1402   }
1403 
1404   function whitelistMint(bytes32[] calldata proof) external payable onlyOrigin {
1405 
1406     uint256 balance = address(this).balance;
1407 
1408     require(isWhitelistMintActive, "Whitelist mint is not active!");
1409     require(balance >= fee, "Insufficient funds!");
1410     require(nftCounts[msg.sender] + mintAmount <= maxMintAmountPerWallet, "Exceeds mint amount per wallet!");
1411     require(supply.current() + mintAmount <= maxSupply, "Max supply exceeded!");
1412     require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "You are not whitelisted!");
1413 
1414     _withdraw(payable(msg.sender), fee);
1415     nftCounts[msg.sender] += mintAmount;
1416     supply.increment();
1417     _safeMint(msg.sender, supply.current());
1418   }
1419 
1420   function ownerMint(uint256 _mintAmount, address _receiver) external onlyOwner {
1421 
1422     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1423 
1424     for (uint256 i = 0; i < _mintAmount; i++) {
1425       supply.increment();
1426       _safeMint(_receiver, supply.current());
1427     }
1428   }
1429 
1430   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1431     require(_exists(_tokenId), "Non-existent token given!");
1432 
1433     string memory currentBaseURI = _baseURI();
1434     return bytes(currentBaseURI).length > 0
1435         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1436         : "";
1437   }
1438 
1439   function _baseURI() internal view virtual override returns (string memory) {
1440     return uriPrefix;
1441   }
1442 
1443   function totalSupply() external view returns (uint256) {
1444     return supply.current();
1445   }
1446 
1447   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1448     uriPrefix = _uriPrefix;
1449   }
1450 
1451   function setUriSuffix(string memory _uriSuffix) external onlyOwner {
1452     uriSuffix = _uriSuffix;
1453   }
1454 
1455   function setIsWhitelistMintActive(bool _state) external onlyOwner {
1456     isWhitelistMintActive = _state;
1457   }
1458 
1459   function setMerkleRoot(bytes32 _root) external onlyOwner {
1460     merkleRoot = _root;
1461   }
1462 
1463   function withdrawAll() external onlyOwner {
1464     uint256 balance = address(this).balance;
1465     require(balance > 0);
1466 
1467     _withdraw(owner(), address(this).balance);
1468   }
1469 
1470   function _withdraw(address _address, uint256 _amount) private {
1471     (bool success, ) = _address.call{value: _amount}("");
1472     require(success, "Transfer failed.");
1473   }
1474 
1475   function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal whenNotPaused override {
1476     super._beforeTokenTransfer(from, to, tokenId);
1477   }
1478 
1479   function royaltyInfo(uint256 tokenId, uint256 salePrice) external view returns (address receiver, uint256 royaltyAmount) {
1480     require(_exists(tokenId), "Non-existent token given!");
1481     require(salePrice > 0, "Sale price must be greater than 0!");
1482     return (royaltiesPayoutAddress, (salePrice * royaltiesPercent) / 10000);
1483   }
1484 
1485   function setRoyaltiesPercent(uint256 _royalitesPercent) external onlyOwner {
1486     require(_royalitesPercent > 0, "Royalties percent must be greater than 0!");
1487     require(_royalitesPercent <= 10000, "Royalties percent must be less than or equal to 10000!");
1488     royaltiesPercent = _royalitesPercent;
1489   }
1490 
1491   function supportsInterface(bytes4 interfaceId) public view virtual override (ERC721) returns (bool) {
1492       return (interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId));
1493   }
1494 }