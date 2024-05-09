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
744 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
745 
746 
747 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 
752 /**
753  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
754  * @dev See https://eips.ethereum.org/EIPS/eip-721
755  */
756 interface IERC721Enumerable is IERC721 {
757     /**
758      * @dev Returns the total amount of tokens stored by the contract.
759      */
760     function totalSupply() external view returns (uint256);
761 
762     /**
763      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
764      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
765      */
766     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
767 
768     /**
769      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
770      * Use along with {totalSupply} to enumerate all tokens.
771      */
772     function tokenByIndex(uint256 index) external view returns (uint256);
773 }
774 
775 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
776 
777 
778 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
779 
780 pragma solidity ^0.8.0;
781 
782 
783 /**
784  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
785  * @dev See https://eips.ethereum.org/EIPS/eip-721
786  */
787 interface IERC721Metadata is IERC721 {
788     /**
789      * @dev Returns the token collection name.
790      */
791     function name() external view returns (string memory);
792 
793     /**
794      * @dev Returns the token collection symbol.
795      */
796     function symbol() external view returns (string memory);
797 
798     /**
799      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
800      */
801     function tokenURI(uint256 tokenId) external view returns (string memory);
802 }
803 
804 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
805 
806 
807 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
808 
809 pragma solidity ^0.8.0;
810 
811 
812 
813 
814 
815 
816 
817 
818 /**
819  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
820  * the Metadata extension, but not including the Enumerable extension, which is available separately as
821  * {ERC721Enumerable}.
822  */
823 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
824     using Address for address;
825     using Strings for uint256;
826 
827     // Token name
828     string private _name;
829 
830     // Token symbol
831     string private _symbol;
832 
833     // Mapping from token ID to owner address
834     mapping(uint256 => address) private _owners;
835 
836     // Mapping owner address to token count
837     mapping(address => uint256) private _balances;
838 
839     // Mapping from token ID to approved address
840     mapping(uint256 => address) private _tokenApprovals;
841 
842     // Mapping from owner to operator approvals
843     mapping(address => mapping(address => bool)) private _operatorApprovals;
844 
845     /**
846      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
847      */
848     constructor(string memory name_, string memory symbol_) {
849         _name = name_;
850         _symbol = symbol_;
851     }
852 
853     /**
854      * @dev See {IERC165-supportsInterface}.
855      */
856     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
857         return
858             interfaceId == type(IERC721).interfaceId ||
859             interfaceId == type(IERC721Metadata).interfaceId ||
860             super.supportsInterface(interfaceId);
861     }
862 
863     /**
864      * @dev See {IERC721-balanceOf}.
865      */
866     function balanceOf(address owner) public view virtual override returns (uint256) {
867         require(owner != address(0), "ERC721: balance query for the zero address");
868         return _balances[owner];
869     }
870 
871     /**
872      * @dev See {IERC721-ownerOf}.
873      */
874     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
875         address owner = _owners[tokenId];
876         require(owner != address(0), "ERC721: owner query for nonexistent token");
877         return owner;
878     }
879 
880     /**
881      * @dev See {IERC721Metadata-name}.
882      */
883     function name() public view virtual override returns (string memory) {
884         return _name;
885     }
886 
887     /**
888      * @dev See {IERC721Metadata-symbol}.
889      */
890     function symbol() public view virtual override returns (string memory) {
891         return _symbol;
892     }
893 
894     /**
895      * @dev See {IERC721Metadata-tokenURI}.
896      */
897     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
898         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
899 
900         string memory baseURI = _baseURI();
901         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
902     }
903 
904     /**
905      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
906      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
907      * by default, can be overriden in child contracts.
908      */
909     function _baseURI() internal view virtual returns (string memory) {
910         return "";
911     }
912 
913     /**
914      * @dev See {IERC721-approve}.
915      */
916     function approve(address to, uint256 tokenId) public virtual override {
917         address owner = ERC721.ownerOf(tokenId);
918         require(to != owner, "ERC721: approval to current owner");
919 
920         require(
921             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
922             "ERC721: approve caller is not owner nor approved for all"
923         );
924 
925         _approve(to, tokenId);
926     }
927 
928     /**
929      * @dev See {IERC721-getApproved}.
930      */
931     function getApproved(uint256 tokenId) public view virtual override returns (address) {
932         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
933 
934         return _tokenApprovals[tokenId];
935     }
936 
937     /**
938      * @dev See {IERC721-setApprovalForAll}.
939      */
940     function setApprovalForAll(address operator, bool approved) public virtual override {
941         _setApprovalForAll(_msgSender(), operator, approved);
942     }
943 
944     /**
945      * @dev See {IERC721-isApprovedForAll}.
946      */
947     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
948         return _operatorApprovals[owner][operator];
949     }
950 
951     /**
952      * @dev See {IERC721-transferFrom}.
953      */
954     function transferFrom(
955         address from,
956         address to,
957         uint256 tokenId
958     ) public virtual override {
959         //solhint-disable-next-line max-line-length
960         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
961 
962         _transfer(from, to, tokenId);
963     }
964 
965     /**
966      * @dev See {IERC721-safeTransferFrom}.
967      */
968     function safeTransferFrom(
969         address from,
970         address to,
971         uint256 tokenId
972     ) public virtual override {
973         safeTransferFrom(from, to, tokenId, "");
974     }
975 
976     /**
977      * @dev See {IERC721-safeTransferFrom}.
978      */
979     function safeTransferFrom(
980         address from,
981         address to,
982         uint256 tokenId,
983         bytes memory _data
984     ) public virtual override {
985         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
986         _safeTransfer(from, to, tokenId, _data);
987     }
988 
989     /**
990      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
991      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
992      *
993      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
994      *
995      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
996      * implement alternative mechanisms to perform token transfer, such as signature-based.
997      *
998      * Requirements:
999      *
1000      * - `from` cannot be the zero address.
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must exist and be owned by `from`.
1003      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _safeTransfer(
1008         address from,
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) internal virtual {
1013         _transfer(from, to, tokenId);
1014         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1015     }
1016 
1017     /**
1018      * @dev Returns whether `tokenId` exists.
1019      *
1020      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1021      *
1022      * Tokens start existing when they are minted (`_mint`),
1023      * and stop existing when they are burned (`_burn`).
1024      */
1025     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1026         return _owners[tokenId] != address(0);
1027     }
1028 
1029     /**
1030      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1031      *
1032      * Requirements:
1033      *
1034      * - `tokenId` must exist.
1035      */
1036     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1037         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1038         address owner = ERC721.ownerOf(tokenId);
1039         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1040     }
1041 
1042     /**
1043      * @dev Safely mints `tokenId` and transfers it to `to`.
1044      *
1045      * Requirements:
1046      *
1047      * - `tokenId` must not exist.
1048      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function _safeMint(address to, uint256 tokenId) internal virtual {
1053         _safeMint(to, tokenId, "");
1054     }
1055 
1056     /**
1057      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1058      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1059      */
1060     function _safeMint(
1061         address to,
1062         uint256 tokenId,
1063         bytes memory _data
1064     ) internal virtual {
1065         _mint(to, tokenId);
1066         require(
1067             _checkOnERC721Received(address(0), to, tokenId, _data),
1068             "ERC721: transfer to non ERC721Receiver implementer"
1069         );
1070     }
1071 
1072     /**
1073      * @dev Mints `tokenId` and transfers it to `to`.
1074      *
1075      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1076      *
1077      * Requirements:
1078      *
1079      * - `tokenId` must not exist.
1080      * - `to` cannot be the zero address.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function _mint(address to, uint256 tokenId) internal virtual {
1085         require(to != address(0), "ERC721: mint to the zero address");
1086         require(!_exists(tokenId), "ERC721: token already minted");
1087 
1088         _beforeTokenTransfer(address(0), to, tokenId);
1089 
1090         _balances[to] += 1;
1091         _owners[tokenId] = to;
1092 
1093         emit Transfer(address(0), to, tokenId);
1094 
1095         _afterTokenTransfer(address(0), to, tokenId);
1096     }
1097 
1098     /**
1099      * @dev Destroys `tokenId`.
1100      * The approval is cleared when the token is burned.
1101      *
1102      * Requirements:
1103      *
1104      * - `tokenId` must exist.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _burn(uint256 tokenId) internal virtual {
1109         address owner = ERC721.ownerOf(tokenId);
1110 
1111         _beforeTokenTransfer(owner, address(0), tokenId);
1112 
1113         // Clear approvals
1114         _approve(address(0), tokenId);
1115 
1116         _balances[owner] -= 1;
1117         delete _owners[tokenId];
1118 
1119         emit Transfer(owner, address(0), tokenId);
1120 
1121         _afterTokenTransfer(owner, address(0), tokenId);
1122     }
1123 
1124     /**
1125      * @dev Transfers `tokenId` from `from` to `to`.
1126      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1127      *
1128      * Requirements:
1129      *
1130      * - `to` cannot be the zero address.
1131      * - `tokenId` token must be owned by `from`.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _transfer(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) internal virtual {
1140         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1141         require(to != address(0), "ERC721: transfer to the zero address");
1142 
1143         _beforeTokenTransfer(from, to, tokenId);
1144 
1145         // Clear approvals from the previous owner
1146         _approve(address(0), tokenId);
1147 
1148         _balances[from] -= 1;
1149         _balances[to] += 1;
1150         _owners[tokenId] = to;
1151 
1152         emit Transfer(from, to, tokenId);
1153 
1154         _afterTokenTransfer(from, to, tokenId);
1155     }
1156 
1157     /**
1158      * @dev Approve `to` to operate on `tokenId`
1159      *
1160      * Emits a {Approval} event.
1161      */
1162     function _approve(address to, uint256 tokenId) internal virtual {
1163         _tokenApprovals[tokenId] = to;
1164         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1165     }
1166 
1167     /**
1168      * @dev Approve `operator` to operate on all of `owner` tokens
1169      *
1170      * Emits a {ApprovalForAll} event.
1171      */
1172     function _setApprovalForAll(
1173         address owner,
1174         address operator,
1175         bool approved
1176     ) internal virtual {
1177         require(owner != operator, "ERC721: approve to caller");
1178         _operatorApprovals[owner][operator] = approved;
1179         emit ApprovalForAll(owner, operator, approved);
1180     }
1181 
1182     /**
1183      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1184      * The call is not executed if the target address is not a contract.
1185      *
1186      * @param from address representing the previous owner of the given token ID
1187      * @param to target address that will receive the tokens
1188      * @param tokenId uint256 ID of the token to be transferred
1189      * @param _data bytes optional data to send along with the call
1190      * @return bool whether the call correctly returned the expected magic value
1191      */
1192     function _checkOnERC721Received(
1193         address from,
1194         address to,
1195         uint256 tokenId,
1196         bytes memory _data
1197     ) private returns (bool) {
1198         if (to.isContract()) {
1199             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1200                 return retval == IERC721Receiver.onERC721Received.selector;
1201             } catch (bytes memory reason) {
1202                 if (reason.length == 0) {
1203                     revert("ERC721: transfer to non ERC721Receiver implementer");
1204                 } else {
1205                     assembly {
1206                         revert(add(32, reason), mload(reason))
1207                     }
1208                 }
1209             }
1210         } else {
1211             return true;
1212         }
1213     }
1214 
1215     /**
1216      * @dev Hook that is called before any token transfer. This includes minting
1217      * and burning.
1218      *
1219      * Calling conditions:
1220      *
1221      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1222      * transferred to `to`.
1223      * - When `from` is zero, `tokenId` will be minted for `to`.
1224      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1225      * - `from` and `to` are never both zero.
1226      *
1227      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1228      */
1229     function _beforeTokenTransfer(
1230         address from,
1231         address to,
1232         uint256 tokenId
1233     ) internal virtual {}
1234 
1235     /**
1236      * @dev Hook that is called after any transfer of tokens. This includes
1237      * minting and burning.
1238      *
1239      * Calling conditions:
1240      *
1241      * - when `from` and `to` are both non-zero.
1242      * - `from` and `to` are never both zero.
1243      *
1244      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1245      */
1246     function _afterTokenTransfer(
1247         address from,
1248         address to,
1249         uint256 tokenId
1250     ) internal virtual {}
1251 }
1252 
1253 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1254 
1255 
1256 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1257 
1258 pragma solidity ^0.8.0;
1259 
1260 
1261 
1262 /**
1263  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1264  * enumerability of all the token ids in the contract as well as all token ids owned by each
1265  * account.
1266  */
1267 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1268     // Mapping from owner to list of owned token IDs
1269     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1270 
1271     // Mapping from token ID to index of the owner tokens list
1272     mapping(uint256 => uint256) private _ownedTokensIndex;
1273 
1274     // Array with all token ids, used for enumeration
1275     uint256[] private _allTokens;
1276 
1277     // Mapping from token id to position in the allTokens array
1278     mapping(uint256 => uint256) private _allTokensIndex;
1279 
1280     /**
1281      * @dev See {IERC165-supportsInterface}.
1282      */
1283     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1284         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1285     }
1286 
1287     /**
1288      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1289      */
1290     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1291         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1292         return _ownedTokens[owner][index];
1293     }
1294 
1295     /**
1296      * @dev See {IERC721Enumerable-totalSupply}.
1297      */
1298     function totalSupply() public view virtual override returns (uint256) {
1299         return _allTokens.length;
1300     }
1301 
1302     /**
1303      * @dev See {IERC721Enumerable-tokenByIndex}.
1304      */
1305     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1306         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1307         return _allTokens[index];
1308     }
1309 
1310     /**
1311      * @dev Hook that is called before any token transfer. This includes minting
1312      * and burning.
1313      *
1314      * Calling conditions:
1315      *
1316      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1317      * transferred to `to`.
1318      * - When `from` is zero, `tokenId` will be minted for `to`.
1319      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1320      * - `from` cannot be the zero address.
1321      * - `to` cannot be the zero address.
1322      *
1323      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1324      */
1325     function _beforeTokenTransfer(
1326         address from,
1327         address to,
1328         uint256 tokenId
1329     ) internal virtual override {
1330         super._beforeTokenTransfer(from, to, tokenId);
1331 
1332         if (from == address(0)) {
1333             _addTokenToAllTokensEnumeration(tokenId);
1334         } else if (from != to) {
1335             _removeTokenFromOwnerEnumeration(from, tokenId);
1336         }
1337         if (to == address(0)) {
1338             _removeTokenFromAllTokensEnumeration(tokenId);
1339         } else if (to != from) {
1340             _addTokenToOwnerEnumeration(to, tokenId);
1341         }
1342     }
1343 
1344     /**
1345      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1346      * @param to address representing the new owner of the given token ID
1347      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1348      */
1349     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1350         uint256 length = ERC721.balanceOf(to);
1351         _ownedTokens[to][length] = tokenId;
1352         _ownedTokensIndex[tokenId] = length;
1353     }
1354 
1355     /**
1356      * @dev Private function to add a token to this extension's token tracking data structures.
1357      * @param tokenId uint256 ID of the token to be added to the tokens list
1358      */
1359     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1360         _allTokensIndex[tokenId] = _allTokens.length;
1361         _allTokens.push(tokenId);
1362     }
1363 
1364     /**
1365      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1366      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1367      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1368      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1369      * @param from address representing the previous owner of the given token ID
1370      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1371      */
1372     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1373         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1374         // then delete the last slot (swap and pop).
1375 
1376         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1377         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1378 
1379         // When the token to delete is the last token, the swap operation is unnecessary
1380         if (tokenIndex != lastTokenIndex) {
1381             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1382 
1383             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1384             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1385         }
1386 
1387         // This also deletes the contents at the last position of the array
1388         delete _ownedTokensIndex[tokenId];
1389         delete _ownedTokens[from][lastTokenIndex];
1390     }
1391 
1392     /**
1393      * @dev Private function to remove a token from this extension's token tracking data structures.
1394      * This has O(1) time complexity, but alters the order of the _allTokens array.
1395      * @param tokenId uint256 ID of the token to be removed from the tokens list
1396      */
1397     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1398         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1399         // then delete the last slot (swap and pop).
1400 
1401         uint256 lastTokenIndex = _allTokens.length - 1;
1402         uint256 tokenIndex = _allTokensIndex[tokenId];
1403 
1404         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1405         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1406         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1407         uint256 lastTokenId = _allTokens[lastTokenIndex];
1408 
1409         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1410         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1411 
1412         // This also deletes the contents at the last position of the array
1413         delete _allTokensIndex[tokenId];
1414         _allTokens.pop();
1415     }
1416 }
1417 
1418 // File: DegenHeroes.sol
1419 
1420 // SPDX-Licence-Identifier: MIT
1421 pragma solidity >=0.7.0 <0.9.0;
1422 
1423 
1424 
1425 
1426 
1427 
1428 contract DegenHeroes is ERC721Enumerable, Ownable {
1429     using Strings for uint256;
1430     using Counters for Counters.Counter;
1431 
1432     Counters.Counter private supply;
1433 
1434     string public uriPrefix = "ipfs://QmVjKqPEvZobdpyaZfLLh4AcFYgeeXAgWkDYYcV3WPdFcG/";
1435     string public uriSuffix = ".json";
1436     string public hiddenMetadataUri;
1437 
1438     // Merkle Tree Root Address  - Gas Optimisation
1439     bytes32 public whitelistMerkleRoot = 0x04bdf24b89de0680b378b190475b4c2adad019a7b6831937f0f36b9db9f2dbf5;
1440 
1441     uint256 public presaleCost = .075 ether;
1442     uint256 public publicsaleCost = .075 ether;
1443 
1444     uint256 public maxSupply = 10000;
1445     uint256 public maxMintAmountPerTx = 4;
1446     uint256 public nftPerAddressLimit = 4;
1447 
1448     bool public revealed = false;
1449     bool public paused = false;
1450     bool public presale = true;
1451 
1452     mapping(address => uint256) public addressMintedBalance;
1453     
1454     constructor() ERC721("Degen Heroes", "DH") {
1455         setHiddenMetadataUri("https://degenheroes.mypinata.cloud/ipfs/QmdTpg1KFzzFU7sbtmQifUKxL486Hodvg9q5RnzixC6Epd/prereveal.json");
1456     }
1457 
1458     // Mint Compliance
1459     modifier mintCompliance(uint256 _mintAmount) {
1460         if (msg.sender != owner()) {
1461             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1462             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "Max NFT per address exceeded");
1463             require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount");
1464         }
1465         require(supply.current() + _mintAmount < maxSupply, "Max supply exceeded");
1466         _;
1467     }
1468 
1469     // Mint
1470     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1471         require(!paused, "The contract is paused");
1472         
1473         if (msg.sender != owner()) {
1474             if (presale == true) {
1475                 require(msg.value >= presaleCost * _mintAmount, "Insufficient funds!");
1476             } else {
1477                 require(msg.value >= publicsaleCost * _mintAmount, "Insufficient funds!");
1478             }
1479         }
1480 
1481         _mintLoop(msg.sender, _mintAmount);
1482 
1483     }
1484 
1485     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1486         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1487         require(
1488             MerkleProof.verify(
1489                 merkleProof,
1490                 root,
1491                 leaf
1492             ),
1493             "Address is not whitelisted"
1494         );
1495         _;
1496     }
1497 
1498     // Whitelist mint
1499     function mintWhitelist(bytes32[] calldata merkleProof, uint256 _mintAmount)
1500         public
1501         payable
1502         isValidMerkleProof(merkleProof, whitelistMerkleRoot)
1503         mintCompliance(_mintAmount)
1504     {
1505         require(!paused, "The contract is paused");
1506         if (msg.sender != owner()) {
1507             if (presale == true) {
1508                 require(msg.value >= presaleCost * _mintAmount, "Insufficient funds!");
1509             } else {
1510                 require(presale);
1511             }
1512         }
1513 
1514         _mintLoop(msg.sender, _mintAmount);
1515 
1516     }
1517 
1518     function setWhitelistMerkleRoot(bytes32 merkleRoot) external onlyOwner {
1519         whitelistMerkleRoot = merkleRoot;
1520     }
1521 
1522     // Mint for Addresses
1523     function mintForAddress( uint256 _mintAmount, address _reciever) public mintCompliance(_mintAmount) onlyOwner {
1524         _mintLoop(_reciever, _mintAmount);
1525     }
1526 
1527 
1528     // Mint Loop
1529     function _mintLoop(address _reciever, uint256 _mintAmount) internal {
1530         for (uint256 i = 0; i < _mintAmount; i++) {
1531             supply.increment();
1532             addressMintedBalance[msg.sender]++;
1533             _safeMint(_reciever, supply.current());
1534         }
1535     }
1536 
1537     // Total Supply
1538     function totalSupply() public override view returns(uint256) {
1539         return supply.current();
1540     }
1541 
1542 
1543     // Wallet of Owner
1544     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1545         uint256 ownerTokenCount = balanceOf(_owner);
1546         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1547         uint256 currentTokenId = 1;
1548         uint256 ownedTokenIndex = 0;
1549 
1550         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1551             address currentTokenOwner = ownerOf(currentTokenId);
1552 
1553             if(currentTokenOwner == _owner) {
1554                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1555                 ownedTokenIndex++;
1556             }
1557             
1558             currentTokenId++;
1559         }
1560 
1561         return ownedTokenIds;
1562     }
1563 
1564     // Token URI
1565     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1566         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1567 
1568         if (revealed == false) {
1569             return hiddenMetadataUri;
1570         }
1571 
1572         string memory currentBaseURI = _baseURI();
1573         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)) : "";
1574     }
1575 
1576     // Set Max Mint Amount Per TX
1577     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)  public onlyOwner {
1578         maxMintAmountPerTx = _maxMintAmountPerTx;
1579     }
1580 
1581     // Set Presale Cost
1582     function setPresaleCost(uint256 _cost) public onlyOwner {
1583         presaleCost = _cost;
1584     }
1585 
1586     // Set Publicsale Cost
1587     function setPublicsaleCost(uint256 _cost) public onlyOwner {
1588         publicsaleCost = _cost;
1589     }
1590 
1591     // Set Presale
1592     function setPresale(bool _state) public onlyOwner {
1593         presale = _state;
1594     }
1595 
1596 
1597     // Set Hidden Metadata URI
1598     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1599         hiddenMetadataUri = _hiddenMetadataUri;
1600     }
1601 
1602     // Set URI Prefix
1603     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1604         uriPrefix = _uriPrefix;
1605     }
1606 
1607     // Set URI Sufix
1608     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1609         uriSuffix = _uriSuffix;
1610     }
1611 
1612     // Set Paused 
1613     function setPaused(bool _state) public onlyOwner {
1614         paused = _state;
1615     }
1616 
1617     // Get Cost
1618     function cost() public view returns(uint256) {
1619         if (presale == true) {
1620             return presaleCost;
1621         }
1622         return publicsaleCost;
1623     }
1624 
1625     // Set Revealed 
1626     function setRevealed(bool _state) public onlyOwner {
1627         revealed = _state;
1628     }
1629 
1630     // Base URI
1631     function _baseURI() internal view virtual override returns (string memory) {
1632         return uriPrefix;
1633     }
1634 
1635     // Withdraw
1636     function withDraw() public onlyOwner {
1637         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1638         require(os);
1639     }
1640 }