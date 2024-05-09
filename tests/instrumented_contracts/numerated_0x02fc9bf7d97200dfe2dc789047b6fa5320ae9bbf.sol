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
64 // File: @openzeppelin/contracts/utils/Counters.sol
65 
66 
67 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @title Counters
73  * @author Matt Condon (@shrugs)
74  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
75  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
76  *
77  * Include with `using Counters for Counters.Counter;`
78  */
79 library Counters {
80     struct Counter {
81         // This variable should never be directly accessed by users of the library: interactions must be restricted to
82         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
83         // this feature: see https://github.com/ethereum/solidity/issues/4637
84         uint256 _value; // default: 0
85     }
86 
87     function current(Counter storage counter) internal view returns (uint256) {
88         return counter._value;
89     }
90 
91     function increment(Counter storage counter) internal {
92         unchecked {
93             counter._value += 1;
94         }
95     }
96 
97     function decrement(Counter storage counter) internal {
98         uint256 value = counter._value;
99         require(value > 0, "Counter: decrement overflow");
100         unchecked {
101             counter._value = value - 1;
102         }
103     }
104 
105     function reset(Counter storage counter) internal {
106         counter._value = 0;
107     }
108 }
109 
110 // File: @openzeppelin/contracts/utils/Strings.sol
111 
112 
113 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev String operations.
119  */
120 library Strings {
121     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
125      */
126     function toString(uint256 value) internal pure returns (string memory) {
127         // Inspired by OraclizeAPI's implementation - MIT licence
128         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
129 
130         if (value == 0) {
131             return "0";
132         }
133         uint256 temp = value;
134         uint256 digits;
135         while (temp != 0) {
136             digits++;
137             temp /= 10;
138         }
139         bytes memory buffer = new bytes(digits);
140         while (value != 0) {
141             digits -= 1;
142             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
143             value /= 10;
144         }
145         return string(buffer);
146     }
147 
148     /**
149      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
150      */
151     function toHexString(uint256 value) internal pure returns (string memory) {
152         if (value == 0) {
153             return "0x00";
154         }
155         uint256 temp = value;
156         uint256 length = 0;
157         while (temp != 0) {
158             length++;
159             temp >>= 8;
160         }
161         return toHexString(value, length);
162     }
163 
164     /**
165      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
166      */
167     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
168         bytes memory buffer = new bytes(2 * length + 2);
169         buffer[0] = "0";
170         buffer[1] = "x";
171         for (uint256 i = 2 * length + 1; i > 1; --i) {
172             buffer[i] = _HEX_SYMBOLS[value & 0xf];
173             value >>= 4;
174         }
175         require(value == 0, "Strings: hex length insufficient");
176         return string(buffer);
177     }
178 }
179 
180 // File: @openzeppelin/contracts/utils/Context.sol
181 
182 
183 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 /**
188  * @dev Provides information about the current execution context, including the
189  * sender of the transaction and its data. While these are generally available
190  * via msg.sender and msg.data, they should not be accessed in such a direct
191  * manner, since when dealing with meta-transactions the account sending and
192  * paying for execution may not be the actual sender (as far as an application
193  * is concerned).
194  *
195  * This contract is only required for intermediate, library-like contracts.
196  */
197 abstract contract Context {
198     function _msgSender() internal view virtual returns (address) {
199         return msg.sender;
200     }
201 
202     function _msgData() internal view virtual returns (bytes calldata) {
203         return msg.data;
204     }
205 }
206 
207 // File: @openzeppelin/contracts/access/Ownable.sol
208 
209 
210 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
211 
212 pragma solidity ^0.8.0;
213 
214 
215 /**
216  * @dev Contract module which provides a basic access control mechanism, where
217  * there is an account (an owner) that can be granted exclusive access to
218  * specific functions.
219  *
220  * By default, the owner account will be the one that deploys the contract. This
221  * can later be changed with {transferOwnership}.
222  *
223  * This module is used through inheritance. It will make available the modifier
224  * `onlyOwner`, which can be applied to your functions to restrict their use to
225  * the owner.
226  */
227 abstract contract Ownable is Context {
228     address private _owner;
229 
230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231 
232     /**
233      * @dev Initializes the contract setting the deployer as the initial owner.
234      */
235     constructor() {
236         _transferOwnership(_msgSender());
237     }
238 
239     /**
240      * @dev Returns the address of the current owner.
241      */
242     function owner() public view virtual returns (address) {
243         return _owner;
244     }
245 
246     /**
247      * @dev Throws if called by any account other than the owner.
248      */
249     modifier onlyOwner() {
250         require(owner() == _msgSender(), "Ownable: caller is not the owner");
251         _;
252     }
253 
254     /**
255      * @dev Leaves the contract without owner. It will not be possible to call
256      * `onlyOwner` functions anymore. Can only be called by the current owner.
257      *
258      * NOTE: Renouncing ownership will leave the contract without an owner,
259      * thereby removing any functionality that is only available to the owner.
260      */
261     function renounceOwnership() public virtual onlyOwner {
262         _transferOwnership(address(0));
263     }
264 
265     /**
266      * @dev Transfers ownership of the contract to a new account (`newOwner`).
267      * Can only be called by the current owner.
268      */
269     function transferOwnership(address newOwner) public virtual onlyOwner {
270         require(newOwner != address(0), "Ownable: new owner is the zero address");
271         _transferOwnership(newOwner);
272     }
273 
274     /**
275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
276      * Internal function without access restriction.
277      */
278     function _transferOwnership(address newOwner) internal virtual {
279         address oldOwner = _owner;
280         _owner = newOwner;
281         emit OwnershipTransferred(oldOwner, newOwner);
282     }
283 }
284 
285 // File: @openzeppelin/contracts/utils/Address.sol
286 
287 
288 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
289 
290 pragma solidity ^0.8.1;
291 
292 /**
293  * @dev Collection of functions related to the address type
294  */
295 library Address {
296     /**
297      * @dev Returns true if `account` is a contract.
298      *
299      * [IMPORTANT]
300      * ====
301      * It is unsafe to assume that an address for which this function returns
302      * false is an externally-owned account (EOA) and not a contract.
303      *
304      * Among others, `isContract` will return false for the following
305      * types of addresses:
306      *
307      *  - an externally-owned account
308      *  - a contract in construction
309      *  - an address where a contract will be created
310      *  - an address where a contract lived, but was destroyed
311      * ====
312      *
313      * [IMPORTANT]
314      * ====
315      * You shouldn't rely on `isContract` to protect against flash loan attacks!
316      *
317      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
318      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
319      * constructor.
320      * ====
321      */
322     function isContract(address account) internal view returns (bool) {
323         // This method relies on extcodesize/address.code.length, which returns 0
324         // for contracts in construction, since the code is only stored at the end
325         // of the constructor execution.
326 
327         return account.code.length > 0;
328     }
329 
330     /**
331      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
332      * `recipient`, forwarding all available gas and reverting on errors.
333      *
334      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
335      * of certain opcodes, possibly making contracts go over the 2300 gas limit
336      * imposed by `transfer`, making them unable to receive funds via
337      * `transfer`. {sendValue} removes this limitation.
338      *
339      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
340      *
341      * IMPORTANT: because control is transferred to `recipient`, care must be
342      * taken to not create reentrancy vulnerabilities. Consider using
343      * {ReentrancyGuard} or the
344      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
345      */
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(address(this).balance >= amount, "Address: insufficient balance");
348 
349         (bool success, ) = recipient.call{value: amount}("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 
353     /**
354      * @dev Performs a Solidity function call using a low level `call`. A
355      * plain `call` is an unsafe replacement for a function call: use this
356      * function instead.
357      *
358      * If `target` reverts with a revert reason, it is bubbled up by this
359      * function (like regular Solidity function calls).
360      *
361      * Returns the raw returned data. To convert to the expected return value,
362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
363      *
364      * Requirements:
365      *
366      * - `target` must be a contract.
367      * - calling `target` with `data` must not revert.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
372         return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal returns (bytes memory) {
386         return functionCallWithValue(target, data, 0, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but also transferring `value` wei to `target`.
392      *
393      * Requirements:
394      *
395      * - the calling contract must have an ETH balance of at least `value`.
396      * - the called Solidity function must be `payable`.
397      *
398      * _Available since v3.1._
399      */
400     function functionCallWithValue(
401         address target,
402         bytes memory data,
403         uint256 value
404     ) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
410      * with `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         require(address(this).balance >= value, "Address: insufficient balance for call");
421         require(isContract(target), "Address: call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.call{value: value}(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but performing a static call.
430      *
431      * _Available since v3.3._
432      */
433     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
434         return functionStaticCall(target, data, "Address: low-level static call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(
444         address target,
445         bytes memory data,
446         string memory errorMessage
447     ) internal view returns (bytes memory) {
448         require(isContract(target), "Address: static call to non-contract");
449 
450         (bool success, bytes memory returndata) = target.staticcall(data);
451         return verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
456      * but performing a delegate call.
457      *
458      * _Available since v3.4._
459      */
460     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
461         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(
471         address target,
472         bytes memory data,
473         string memory errorMessage
474     ) internal returns (bytes memory) {
475         require(isContract(target), "Address: delegate call to non-contract");
476 
477         (bool success, bytes memory returndata) = target.delegatecall(data);
478         return verifyCallResult(success, returndata, errorMessage);
479     }
480 
481     /**
482      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
483      * revert reason using the provided one.
484      *
485      * _Available since v4.3._
486      */
487     function verifyCallResult(
488         bool success,
489         bytes memory returndata,
490         string memory errorMessage
491     ) internal pure returns (bytes memory) {
492         if (success) {
493             return returndata;
494         } else {
495             // Look for revert reason and bubble it up if present
496             if (returndata.length > 0) {
497                 // The easiest way to bubble the revert reason is using memory via assembly
498 
499                 assembly {
500                     let returndata_size := mload(returndata)
501                     revert(add(32, returndata), returndata_size)
502                 }
503             } else {
504                 revert(errorMessage);
505             }
506         }
507     }
508 }
509 
510 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 /**
518  * @title ERC721 token receiver interface
519  * @dev Interface for any contract that wants to support safeTransfers
520  * from ERC721 asset contracts.
521  */
522 interface IERC721Receiver {
523     /**
524      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
525      * by `operator` from `from`, this function is called.
526      *
527      * It must return its Solidity selector to confirm the token transfer.
528      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
529      *
530      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
531      */
532     function onERC721Received(
533         address operator,
534         address from,
535         uint256 tokenId,
536         bytes calldata data
537     ) external returns (bytes4);
538 }
539 
540 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @dev Interface of the ERC165 standard, as defined in the
549  * https://eips.ethereum.org/EIPS/eip-165[EIP].
550  *
551  * Implementers can declare support of contract interfaces, which can then be
552  * queried by others ({ERC165Checker}).
553  *
554  * For an implementation, see {ERC165}.
555  */
556 interface IERC165 {
557     /**
558      * @dev Returns true if this contract implements the interface defined by
559      * `interfaceId`. See the corresponding
560      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
561      * to learn more about how these ids are created.
562      *
563      * This function call must use less than 30 000 gas.
564      */
565     function supportsInterface(bytes4 interfaceId) external view returns (bool);
566 }
567 
568 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 /**
577  * @dev Implementation of the {IERC165} interface.
578  *
579  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
580  * for the additional interface id that will be supported. For example:
581  *
582  * ```solidity
583  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
584  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
585  * }
586  * ```
587  *
588  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
589  */
590 abstract contract ERC165 is IERC165 {
591     /**
592      * @dev See {IERC165-supportsInterface}.
593      */
594     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
595         return interfaceId == type(IERC165).interfaceId;
596     }
597 }
598 
599 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
600 
601 
602 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 
607 /**
608  * @dev Required interface of an ERC721 compliant contract.
609  */
610 interface IERC721 is IERC165 {
611     /**
612      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
613      */
614     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
615 
616     /**
617      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
618      */
619     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
620 
621     /**
622      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
623      */
624     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
625 
626     /**
627      * @dev Returns the number of tokens in ``owner``'s account.
628      */
629     function balanceOf(address owner) external view returns (uint256 balance);
630 
631     /**
632      * @dev Returns the owner of the `tokenId` token.
633      *
634      * Requirements:
635      *
636      * - `tokenId` must exist.
637      */
638     function ownerOf(uint256 tokenId) external view returns (address owner);
639 
640     /**
641      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
642      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must exist and be owned by `from`.
649      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
650      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
651      *
652      * Emits a {Transfer} event.
653      */
654     function safeTransferFrom(
655         address from,
656         address to,
657         uint256 tokenId
658     ) external;
659 
660     /**
661      * @dev Transfers `tokenId` token from `from` to `to`.
662      *
663      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
664      *
665      * Requirements:
666      *
667      * - `from` cannot be the zero address.
668      * - `to` cannot be the zero address.
669      * - `tokenId` token must be owned by `from`.
670      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
671      *
672      * Emits a {Transfer} event.
673      */
674     function transferFrom(
675         address from,
676         address to,
677         uint256 tokenId
678     ) external;
679 
680     /**
681      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
682      * The approval is cleared when the token is transferred.
683      *
684      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
685      *
686      * Requirements:
687      *
688      * - The caller must own the token or be an approved operator.
689      * - `tokenId` must exist.
690      *
691      * Emits an {Approval} event.
692      */
693     function approve(address to, uint256 tokenId) external;
694 
695     /**
696      * @dev Returns the account approved for `tokenId` token.
697      *
698      * Requirements:
699      *
700      * - `tokenId` must exist.
701      */
702     function getApproved(uint256 tokenId) external view returns (address operator);
703 
704     /**
705      * @dev Approve or remove `operator` as an operator for the caller.
706      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
707      *
708      * Requirements:
709      *
710      * - The `operator` cannot be the caller.
711      *
712      * Emits an {ApprovalForAll} event.
713      */
714     function setApprovalForAll(address operator, bool _approved) external;
715 
716     /**
717      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
718      *
719      * See {setApprovalForAll}
720      */
721     function isApprovedForAll(address owner, address operator) external view returns (bool);
722 
723     /**
724      * @dev Safely transfers `tokenId` token from `from` to `to`.
725      *
726      * Requirements:
727      *
728      * - `from` cannot be the zero address.
729      * - `to` cannot be the zero address.
730      * - `tokenId` token must exist and be owned by `from`.
731      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
732      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
733      *
734      * Emits a {Transfer} event.
735      */
736     function safeTransferFrom(
737         address from,
738         address to,
739         uint256 tokenId,
740         bytes calldata data
741     ) external;
742 }
743 
744 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
745 
746 
747 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 
752 /**
753  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
754  * @dev See https://eips.ethereum.org/EIPS/eip-721
755  */
756 interface IERC721Metadata is IERC721 {
757     /**
758      * @dev Returns the token collection name.
759      */
760     function name() external view returns (string memory);
761 
762     /**
763      * @dev Returns the token collection symbol.
764      */
765     function symbol() external view returns (string memory);
766 
767     /**
768      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
769      */
770     function tokenURI(uint256 tokenId) external view returns (string memory);
771 }
772 
773 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
774 
775 
776 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
777 
778 pragma solidity ^0.8.0;
779 
780 
781 
782 
783 
784 
785 
786 
787 /**
788  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
789  * the Metadata extension, but not including the Enumerable extension, which is available separately as
790  * {ERC721Enumerable}.
791  */
792 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
793     using Address for address;
794     using Strings for uint256;
795 
796     // Token name
797     string private _name;
798 
799     // Token symbol
800     string private _symbol;
801 
802     // Mapping from token ID to owner address
803     mapping(uint256 => address) private _owners;
804 
805     // Mapping owner address to token count
806     mapping(address => uint256) private _balances;
807 
808     // Mapping from token ID to approved address
809     mapping(uint256 => address) private _tokenApprovals;
810 
811     // Mapping from owner to operator approvals
812     mapping(address => mapping(address => bool)) private _operatorApprovals;
813 
814     /**
815      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
816      */
817     constructor(string memory name_, string memory symbol_) {
818         _name = name_;
819         _symbol = symbol_;
820     }
821 
822     /**
823      * @dev See {IERC165-supportsInterface}.
824      */
825     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
826         return
827             interfaceId == type(IERC721).interfaceId ||
828             interfaceId == type(IERC721Metadata).interfaceId ||
829             super.supportsInterface(interfaceId);
830     }
831 
832     /**
833      * @dev See {IERC721-balanceOf}.
834      */
835     function balanceOf(address owner) public view virtual override returns (uint256) {
836         require(owner != address(0), "ERC721: balance query for the zero address");
837         return _balances[owner];
838     }
839 
840     /**
841      * @dev See {IERC721-ownerOf}.
842      */
843     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
844         address owner = _owners[tokenId];
845         require(owner != address(0), "ERC721: owner query for nonexistent token");
846         return owner;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-name}.
851      */
852     function name() public view virtual override returns (string memory) {
853         return _name;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-symbol}.
858      */
859     function symbol() public view virtual override returns (string memory) {
860         return _symbol;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-tokenURI}.
865      */
866     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
867         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
868 
869         string memory baseURI = _baseURI();
870         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
871     }
872 
873     /**
874      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
875      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
876      * by default, can be overriden in child contracts.
877      */
878     function _baseURI() internal view virtual returns (string memory) {
879         return "";
880     }
881 
882     /**
883      * @dev See {IERC721-approve}.
884      */
885     function approve(address to, uint256 tokenId) public virtual override {
886         address owner = ERC721.ownerOf(tokenId);
887         require(to != owner, "ERC721: approval to current owner");
888 
889         require(
890             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
891             "ERC721: approve caller is not owner nor approved for all"
892         );
893 
894         _approve(to, tokenId);
895     }
896 
897     /**
898      * @dev See {IERC721-getApproved}.
899      */
900     function getApproved(uint256 tokenId) public view virtual override returns (address) {
901         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
902 
903         return _tokenApprovals[tokenId];
904     }
905 
906     /**
907      * @dev See {IERC721-setApprovalForAll}.
908      */
909     function setApprovalForAll(address operator, bool approved) public virtual override {
910         _setApprovalForAll(_msgSender(), operator, approved);
911     }
912 
913     /**
914      * @dev See {IERC721-isApprovedForAll}.
915      */
916     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
917         return _operatorApprovals[owner][operator];
918     }
919 
920     /**
921      * @dev See {IERC721-transferFrom}.
922      */
923     function transferFrom(
924         address from,
925         address to,
926         uint256 tokenId
927     ) public virtual override {
928         //solhint-disable-next-line max-line-length
929         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
930 
931         _transfer(from, to, tokenId);
932     }
933 
934     /**
935      * @dev See {IERC721-safeTransferFrom}.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public virtual override {
942         safeTransferFrom(from, to, tokenId, "");
943     }
944 
945     /**
946      * @dev See {IERC721-safeTransferFrom}.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) public virtual override {
954         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
955         _safeTransfer(from, to, tokenId, _data);
956     }
957 
958     /**
959      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
960      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
961      *
962      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
963      *
964      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
965      * implement alternative mechanisms to perform token transfer, such as signature-based.
966      *
967      * Requirements:
968      *
969      * - `from` cannot be the zero address.
970      * - `to` cannot be the zero address.
971      * - `tokenId` token must exist and be owned by `from`.
972      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _safeTransfer(
977         address from,
978         address to,
979         uint256 tokenId,
980         bytes memory _data
981     ) internal virtual {
982         _transfer(from, to, tokenId);
983         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
984     }
985 
986     /**
987      * @dev Returns whether `tokenId` exists.
988      *
989      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
990      *
991      * Tokens start existing when they are minted (`_mint`),
992      * and stop existing when they are burned (`_burn`).
993      */
994     function _exists(uint256 tokenId) internal view virtual returns (bool) {
995         return _owners[tokenId] != address(0);
996     }
997 
998     /**
999      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must exist.
1004      */
1005     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1006         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1007         address owner = ERC721.ownerOf(tokenId);
1008         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1009     }
1010 
1011     /**
1012      * @dev Safely mints `tokenId` and transfers it to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - `tokenId` must not exist.
1017      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _safeMint(address to, uint256 tokenId) internal virtual {
1022         _safeMint(to, tokenId, "");
1023     }
1024 
1025     /**
1026      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1027      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1028      */
1029     function _safeMint(
1030         address to,
1031         uint256 tokenId,
1032         bytes memory _data
1033     ) internal virtual {
1034         _mint(to, tokenId);
1035         require(
1036             _checkOnERC721Received(address(0), to, tokenId, _data),
1037             "ERC721: transfer to non ERC721Receiver implementer"
1038         );
1039     }
1040 
1041     /**
1042      * @dev Mints `tokenId` and transfers it to `to`.
1043      *
1044      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1045      *
1046      * Requirements:
1047      *
1048      * - `tokenId` must not exist.
1049      * - `to` cannot be the zero address.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _mint(address to, uint256 tokenId) internal virtual {
1054         require(to != address(0), "ERC721: mint to the zero address");
1055         require(!_exists(tokenId), "ERC721: token already minted");
1056 
1057         _beforeTokenTransfer(address(0), to, tokenId);
1058 
1059         _balances[to] += 1;
1060         _owners[tokenId] = to;
1061 
1062         emit Transfer(address(0), to, tokenId);
1063 
1064         _afterTokenTransfer(address(0), to, tokenId);
1065     }
1066 
1067     /**
1068      * @dev Destroys `tokenId`.
1069      * The approval is cleared when the token is burned.
1070      *
1071      * Requirements:
1072      *
1073      * - `tokenId` must exist.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _burn(uint256 tokenId) internal virtual {
1078         address owner = ERC721.ownerOf(tokenId);
1079 
1080         _beforeTokenTransfer(owner, address(0), tokenId);
1081 
1082         // Clear approvals
1083         _approve(address(0), tokenId);
1084 
1085         _balances[owner] -= 1;
1086         delete _owners[tokenId];
1087 
1088         emit Transfer(owner, address(0), tokenId);
1089 
1090         _afterTokenTransfer(owner, address(0), tokenId);
1091     }
1092 
1093     /**
1094      * @dev Transfers `tokenId` from `from` to `to`.
1095      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1096      *
1097      * Requirements:
1098      *
1099      * - `to` cannot be the zero address.
1100      * - `tokenId` token must be owned by `from`.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _transfer(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) internal virtual {
1109         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1110         require(to != address(0), "ERC721: transfer to the zero address");
1111 
1112         _beforeTokenTransfer(from, to, tokenId);
1113 
1114         // Clear approvals from the previous owner
1115         _approve(address(0), tokenId);
1116 
1117         _balances[from] -= 1;
1118         _balances[to] += 1;
1119         _owners[tokenId] = to;
1120 
1121         emit Transfer(from, to, tokenId);
1122 
1123         _afterTokenTransfer(from, to, tokenId);
1124     }
1125 
1126     /**
1127      * @dev Approve `to` to operate on `tokenId`
1128      *
1129      * Emits a {Approval} event.
1130      */
1131     function _approve(address to, uint256 tokenId) internal virtual {
1132         _tokenApprovals[tokenId] = to;
1133         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1134     }
1135 
1136     /**
1137      * @dev Approve `operator` to operate on all of `owner` tokens
1138      *
1139      * Emits a {ApprovalForAll} event.
1140      */
1141     function _setApprovalForAll(
1142         address owner,
1143         address operator,
1144         bool approved
1145     ) internal virtual {
1146         require(owner != operator, "ERC721: approve to caller");
1147         _operatorApprovals[owner][operator] = approved;
1148         emit ApprovalForAll(owner, operator, approved);
1149     }
1150 
1151     /**
1152      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1153      * The call is not executed if the target address is not a contract.
1154      *
1155      * @param from address representing the previous owner of the given token ID
1156      * @param to target address that will receive the tokens
1157      * @param tokenId uint256 ID of the token to be transferred
1158      * @param _data bytes optional data to send along with the call
1159      * @return bool whether the call correctly returned the expected magic value
1160      */
1161     function _checkOnERC721Received(
1162         address from,
1163         address to,
1164         uint256 tokenId,
1165         bytes memory _data
1166     ) private returns (bool) {
1167         if (to.isContract()) {
1168             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1169                 return retval == IERC721Receiver.onERC721Received.selector;
1170             } catch (bytes memory reason) {
1171                 if (reason.length == 0) {
1172                     revert("ERC721: transfer to non ERC721Receiver implementer");
1173                 } else {
1174                     assembly {
1175                         revert(add(32, reason), mload(reason))
1176                     }
1177                 }
1178             }
1179         } else {
1180             return true;
1181         }
1182     }
1183 
1184     /**
1185      * @dev Hook that is called before any token transfer. This includes minting
1186      * and burning.
1187      *
1188      * Calling conditions:
1189      *
1190      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1191      * transferred to `to`.
1192      * - When `from` is zero, `tokenId` will be minted for `to`.
1193      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1194      * - `from` and `to` are never both zero.
1195      *
1196      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1197      */
1198     function _beforeTokenTransfer(
1199         address from,
1200         address to,
1201         uint256 tokenId
1202     ) internal virtual {}
1203 
1204     /**
1205      * @dev Hook that is called after any transfer of tokens. This includes
1206      * minting and burning.
1207      *
1208      * Calling conditions:
1209      *
1210      * - when `from` and `to` are both non-zero.
1211      * - `from` and `to` are never both zero.
1212      *
1213      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1214      */
1215     function _afterTokenTransfer(
1216         address from,
1217         address to,
1218         uint256 tokenId
1219     ) internal virtual {}
1220 }
1221 
1222 // File: FunkyBunnies.sol
1223 
1224 /*
1225 ███████╗██╗░░░██╗███╗░░██╗██╗░░██╗██╗░░░██╗  ██████╗░██╗░░░██╗███╗░░██╗███╗░░██╗██╗███████╗░██████╗
1226 ██╔════╝██║░░░██║████╗░██║██║░██╔╝╚██╗░██╔╝  ██╔══██╗██║░░░██║████╗░██║████╗░██║██║██╔════╝██╔════╝
1227 █████╗░░██║░░░██║██╔██╗██║█████═╝░░╚████╔╝░  ██████╦╝██║░░░██║██╔██╗██║██╔██╗██║██║█████╗░░╚█████╗░
1228 ██╔══╝░░██║░░░██║██║╚████║██╔═██╗░░░╚██╔╝░░  ██╔══██╗██║░░░██║██║╚████║██║╚████║██║██╔══╝░░░╚═══██╗
1229 ██║░░░░░╚██████╔╝██║░╚███║██║░╚██╗░░░██║░░░  ██████╦╝╚██████╔╝██║░╚███║██║░╚███║██║███████╗██████╔╝
1230 ╚═╝░░░░░░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝░░░╚═╝░░░  ╚═════╝░░╚═════╝░╚═╝░░╚══╝╚═╝░░╚══╝╚═╝╚══════╝╚═════╝░
1231 */
1232 
1233 // Artist: Allen
1234 // Author: KIRA
1235 pragma solidity ^0.8.9;
1236 
1237 
1238 
1239 
1240 
1241 contract FunkyBunnies is ERC721, Ownable {
1242 
1243   using Strings for uint256;
1244 
1245   using Counters for Counters.Counter;
1246 
1247 
1248   Counters.Counter private supply;
1249 
1250 
1251   string public uriPrefix = "";
1252 
1253   string public uriSuffix = ".json";
1254 
1255   string public hiddenMetadataUri = "https://gateway.pinata.cloud/ipfs/QmYSGWGvCpbAeJJAyhRAsPLb6YX1ydRTrmsKB8e5CYb5FH/preview_metadata.json";
1256 
1257   
1258 
1259   uint256 public cost = 0.07 ether;
1260 
1261   uint256 public maxSupply = 3333;
1262 
1263   uint256 public maxMintAmountPerTx = 3;
1264 
1265 
1266   bool public dormant = true;
1267 
1268   bool public paused = false;
1269 
1270   bool public revealed = false;
1271 
1272   bytes32 public merkleRoot = 0x7625da3c79d52d498a046ec7c0e0a0c4711ff548431db5bc5329383c584c07dc;
1273 
1274   address public cet = 0x30b4DB1B25d8Bc64B2CAd8d9AcA58305FF60C514;
1275 
1276   mapping(address => bool) public whitelistClaimed;
1277 
1278 
1279 
1280   constructor() ERC721("Funky Bunnies", "FBC")  {
1281 
1282   }
1283 
1284   modifier mintCompliance(uint256 _mintAmount,bytes32[] calldata _merkleProof) {
1285 
1286     require(!paused, "The contract is paused!");
1287 
1288     require(whitelistClaimed[msg.sender] != true, "Already Claimed !");
1289 
1290     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1291         
1292     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf),"Invalid Merkle Proof !");
1293 
1294     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount !");
1295 
1296     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded !");
1297 
1298     _;
1299 
1300   }
1301 
1302   function mint(uint256 _mintAmount,bytes32[] calldata _merkleProof ) public payable mintCompliance(_mintAmount, _merkleProof) {
1303 
1304     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1305 
1306     _mintLoop(msg.sender, _mintAmount);
1307     
1308     whitelistClaimed[msg.sender]= true;
1309 
1310   }
1311 
1312 
1313 
1314 
1315   function pmint(uint256 _mintAmount) public payable  {
1316 
1317     require(!dormant, "The function is dormant!");  
1318 
1319     require(!paused, "The contract is paused!");
1320 
1321     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount !");
1322 
1323     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded !");
1324 
1325     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1326 
1327     _mintLoop(msg.sender, _mintAmount);
1328 
1329   }
1330 
1331 
1332   
1333   function airdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
1334 
1335     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded !");
1336 
1337     _mintLoop(_receiver, _mintAmount);
1338 
1339   }
1340 
1341   
1342 
1343   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1344 
1345     for (uint256 i = 0; i < _mintAmount; i++) {
1346 
1347       supply.increment();
1348 
1349       _safeMint(_receiver, supply.current());
1350 
1351     }
1352 
1353   }
1354 
1355 
1356 
1357   function walletOfOwner(address _owner) public view returns (uint256[] memory)
1358 
1359   {
1360 
1361     uint256 ownerTokenCount = balanceOf(_owner);
1362 
1363     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1364 
1365     uint256 currentTokenId = 1;
1366 
1367     uint256 ownedTokenIndex = 0;
1368 
1369 
1370 
1371     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1372 
1373       address currentTokenOwner = ownerOf(currentTokenId);
1374 
1375 
1376 
1377       if (currentTokenOwner == _owner) {
1378 
1379         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1380 
1381         ownedTokenIndex++;
1382 
1383       }
1384 
1385       currentTokenId++;
1386 
1387     }
1388 
1389     return ownedTokenIds;
1390 
1391   }
1392 
1393 
1394 
1395   function _baseURI() internal view virtual override returns (string memory) {
1396 
1397     return uriPrefix;
1398 
1399   }
1400 
1401 
1402 
1403   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory)
1404 
1405   {
1406 
1407     require(_exists(_tokenId),"URI query for nonexistent token");
1408 
1409 
1410 
1411     if (revealed == false) {
1412 
1413       return hiddenMetadataUri;
1414 
1415     }
1416 
1417 
1418 
1419     string memory currentBaseURI = _baseURI();
1420 
1421     return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)): "";
1422 
1423   }
1424 
1425 
1426 
1427 
1428   function totalSupply() public view returns (uint256) {
1429 
1430     return supply.current();
1431 
1432   }
1433 
1434 
1435 
1436 
1437   function setmerkleroot(bytes32 _merkleroot) public onlyOwner {
1438 
1439     merkleRoot = _merkleroot;
1440 
1441   }
1442 
1443 
1444 
1445   function setRevealed(bool _state) public onlyOwner {
1446 
1447     revealed = _state;
1448 
1449   }
1450 
1451 
1452 
1453   function setCost(uint256 _cost) public onlyOwner {
1454 
1455     cost = _cost;
1456 
1457   }
1458 
1459 
1460 
1461   function setmaxSupply(uint256 _maxSupply) public onlyOwner {
1462 
1463     maxSupply = _maxSupply;
1464 
1465   }
1466 
1467 
1468 
1469   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1470 
1471     maxMintAmountPerTx = _maxMintAmountPerTx;
1472 
1473   }
1474 
1475 
1476 
1477   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1478 
1479     hiddenMetadataUri = _hiddenMetadataUri;
1480 
1481   }
1482 
1483 
1484 
1485   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1486 
1487     uriPrefix = _uriPrefix;
1488 
1489   }
1490 
1491 
1492 
1493   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1494 
1495     uriSuffix = _uriSuffix;
1496 
1497   }
1498 
1499 
1500 
1501   function setPaused(bool _state) public onlyOwner {
1502 
1503     paused = _state;
1504 
1505   }
1506 
1507   function setdormancy(bool _state) public onlyOwner {
1508 
1509     dormant = _state;
1510 
1511   }
1512 
1513   function setcet(address _address) public onlyOwner {
1514 
1515     cet = _address;
1516 
1517   }
1518 
1519 
1520 
1521   function withdraw() public onlyOwner {
1522 
1523     (bool kira, ) = payable(0x9769Dd9831a96E49B2c73C3C8431ff349AebD328).call{value: address(this).balance * 5 / 100}("");
1524 
1525     require(kira);
1526 
1527     (bool sam, ) = payable(0x5C6161C09c29876596BE53dC5546f7ec5298d896).call{value: address(this).balance * 2 / 100}("");
1528 
1529     require(sam);
1530 
1531     (bool nftg, ) = payable(0x79E8494196aC33048c3907c9751A6C9DB35D5c7C).call{value: address(this).balance * 20 / 100}("");
1532 
1533     require(nftg);
1534 
1535 
1536     (bool cllbm, ) = payable(0x48E9490dDe0fcE89F1f2bc9228AADe05540981Fb).call{value: address(this).balance * 2 / 100}("");
1537 
1538     require(cllbm);
1539 
1540     (bool ce, ) = payable(0x24a7727faF8AaDf9cfF0a6f2C973350574581f2A).call{value: address(this).balance * 1 / 100}("");
1541 
1542     require(ce);
1543 
1544     (bool cetw, ) = payable(cet).call{value: address(this).balance * 1 / 100}("");
1545 
1546     require(cetw);
1547 
1548     (bool karan, ) = payable(0x260E714eE6F1EFf13B1CD1B0bb9049a4CcA5c179).call{value: address(this).balance * 8 / 100}("");
1549 
1550     require(karan);
1551 
1552     (bool jazz, ) = payable(0x093e138363d5A3538CAd3D1237e8ee6A08A4039A).call{value: address(this).balance * 11 / 100}("");
1553 
1554     require(jazz);
1555 
1556     (bool allen, ) = payable(owner()).call{value: address(this).balance}("");
1557 
1558     require(allen);
1559 
1560 
1561   }
1562 
1563 
1564 
1565 }