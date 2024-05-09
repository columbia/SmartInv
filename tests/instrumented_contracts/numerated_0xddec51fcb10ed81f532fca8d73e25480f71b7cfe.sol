1 //*--- 8888888b.  8888888888        d8888  .d8888b.  8888888888 8888888888 888     888 888           88888888888 .d88888b.        d8888 8888888b. 8888888888P ---*//
2 //*--- 888   Y88b 888              d88888 d88P  Y88b 888        888        888     888 888               888    d88P" "Y88b      d88888 888  "Y88b      d88P  ---*//
3 //*--- 888    888 888             d88P888 888    888 888        888        888     888 888               888    888     888     d88P888 888    888     d88P   ---*//
4 //*--- 888   d88P 8888888        d88P 888 888        8888888    8888888    888     888 888               888    888     888    d88P 888 888    888    d88P    ---*//
5 //*--- 8888888P"  888           d88P  888 888        888        888        888     888 888               888    888     888   d88P  888 888    888   d88P     ---*//
6 //*--- 888        888          d88P   888 888    888 888        888        888     888 888               888    888     888  d88P   888 888    888  d88P      ---*//
7 //*--- 888        888         d8888888888 Y88b  d88P 888        888        Y88b. .d88P 888               888    Y88b. .d88P d8888888888 888  .d88P d88P       ---*//
8 //*--- 888        8888888888 d88P     888  "Y8888P"  8888888888 888         "Y88888P"  88888888          888     "Y88888P" d88P     888 8888888P" d8888888888 ---*//
9 
10 //*--- Website:   https://www.peacefultoadz.com/                ---*//
11 //*--- Twitter:     https://twitter.com/peacefultoadz               ---*//
12 
13 
14 
15 
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @title Counters
23  * @author Matt Condon (@shrugs)
24  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
25  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
26  *
27  * Include with `using Counters for Counters.Counter;`
28  */
29 library Counters {
30     struct Counter {
31         // This variable should never be directly accessed by users of the library: interactions must be restricted to
32         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
33         // this feature: see https://github.com/ethereum/solidity/issues/4637
34         uint256 _value; // default: 0
35     }
36 
37     function current(Counter storage counter) internal view returns (uint256) {
38         return counter._value;
39     }
40 
41     function increment(Counter storage counter) internal {
42         unchecked {
43             counter._value += 1;
44         }
45     }
46 
47     function decrement(Counter storage counter) internal {
48         uint256 value = counter._value;
49         require(value > 0, "Counter: decrement overflow");
50         unchecked {
51             counter._value = value - 1;
52         }
53     }
54 
55     function reset(Counter storage counter) internal {
56         counter._value = 0;
57     }
58 }
59 
60 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
61 
62 
63 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev These functions deal with verification of Merkle Trees proofs.
69  *
70  * The proofs can be generated using the JavaScript library
71  * https://github.com/miguelmota/merkletreejs[merkletreejs].
72  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
73  *
74  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
75  */
76 library MerkleProof {
77     /**
78      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
79      * defined by `root`. For this, a `proof` must be provided, containing
80      * sibling hashes on the branch from the leaf to the root of the tree. Each
81      * pair of leaves and each pair of pre-images are assumed to be sorted.
82      */
83     function verify(
84         bytes32[] memory proof,
85         bytes32 root,
86         bytes32 leaf
87     ) internal pure returns (bool) {
88         return processProof(proof, leaf) == root;
89     }
90 
91     /**
92      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
93      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
94      * hash matches the root of the tree. When processing the proof, the pairs
95      * of leafs & pre-images are assumed to be sorted.
96      *
97      * _Available since v4.4._
98      */
99     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
100         bytes32 computedHash = leaf;
101         for (uint256 i = 0; i < proof.length; i++) {
102             bytes32 proofElement = proof[i];
103             if (computedHash <= proofElement) {
104                 // Hash(current computed hash + current element of the proof)
105                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
106             } else {
107                 // Hash(current element of the proof + current computed hash)
108                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
109             }
110         }
111         return computedHash;
112     }
113 }
114 
115 // File: @openzeppelin/contracts/utils/Strings.sol
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
185 // File: @openzeppelin/contracts/utils/Context.sol
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
212 // File: @openzeppelin/contracts/access/Ownable.sol
213 
214 
215 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
216 
217 pragma solidity ^0.8.0;
218 
219 
220 /**
221  * @dev Contract module which provides a basic access control mechanism, where
222  * there is an account (an owner) that can be granted exclusive access to
223  * specific functions.
224  *
225  * By default, the owner account will be the one that deploys the contract. This
226  * can later be changed with {transferOwnership}.
227  *
228  * This module is used through inheritance. It will make available the modifier
229  * `onlyOwner`, which can be applied to your functions to restrict their use to
230  * the owner.
231  */
232 abstract contract Ownable is Context {
233     address private _owner;
234 
235     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
236 
237     /**
238      * @dev Initializes the contract setting the deployer as the initial owner.
239      */
240     constructor() {
241         _transferOwnership(_msgSender());
242     }
243 
244     /**
245      * @dev Returns the address of the current owner.
246      */
247     function owner() public view virtual returns (address) {
248         return _owner;
249     }
250 
251     /**
252      * @dev Throws if called by any account other than the owner.
253      */
254     modifier onlyOwner() {
255         require(owner() == _msgSender(), "Ownable: caller is not the owner");
256         _;
257     }
258 
259     /**
260      * @dev Leaves the contract without owner. It will not be possible to call
261      * `onlyOwner` functions anymore. Can only be called by the current owner.
262      *
263      * NOTE: Renouncing ownership will leave the contract without an owner,
264      * thereby removing any functionality that is only available to the owner.
265      */
266     function renounceOwnership() public virtual onlyOwner {
267         _transferOwnership(address(0));
268     }
269 
270     /**
271      * @dev Transfers ownership of the contract to a new account (`newOwner`).
272      * Can only be called by the current owner.
273      */
274     function transferOwnership(address newOwner) public virtual onlyOwner {
275         require(newOwner != address(0), "Ownable: new owner is the zero address");
276         _transferOwnership(newOwner);
277     }
278 
279     /**
280      * @dev Transfers ownership of the contract to a new account (`newOwner`).
281      * Internal function without access restriction.
282      */
283     function _transferOwnership(address newOwner) internal virtual {
284         address oldOwner = _owner;
285         _owner = newOwner;
286         emit OwnershipTransferred(oldOwner, newOwner);
287     }
288 }
289 
290 // File: @openzeppelin/contracts/utils/Address.sol
291 
292 
293 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
294 
295 pragma solidity ^0.8.0;
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // This method relies on extcodesize, which returns 0 for contracts in
320         // construction, since the code is only stored at the end of the
321         // constructor execution.
322 
323         uint256 size;
324         assembly {
325             size := extcodesize(account)
326         }
327         return size > 0;
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
776 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
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
1063     }
1064 
1065     /**
1066      * @dev Destroys `tokenId`.
1067      * The approval is cleared when the token is burned.
1068      *
1069      * Requirements:
1070      *
1071      * - `tokenId` must exist.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _burn(uint256 tokenId) internal virtual {
1076         address owner = ERC721.ownerOf(tokenId);
1077 
1078         _beforeTokenTransfer(owner, address(0), tokenId);
1079 
1080         // Clear approvals
1081         _approve(address(0), tokenId);
1082 
1083         _balances[owner] -= 1;
1084         delete _owners[tokenId];
1085 
1086         emit Transfer(owner, address(0), tokenId);
1087     }
1088 
1089     /**
1090      * @dev Transfers `tokenId` from `from` to `to`.
1091      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1092      *
1093      * Requirements:
1094      *
1095      * - `to` cannot be the zero address.
1096      * - `tokenId` token must be owned by `from`.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _transfer(
1101         address from,
1102         address to,
1103         uint256 tokenId
1104     ) internal virtual {
1105         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1106         require(to != address(0), "ERC721: transfer to the zero address");
1107 
1108         _beforeTokenTransfer(from, to, tokenId);
1109 
1110         // Clear approvals from the previous owner
1111         _approve(address(0), tokenId);
1112 
1113         _balances[from] -= 1;
1114         _balances[to] += 1;
1115         _owners[tokenId] = to;
1116 
1117         emit Transfer(from, to, tokenId);
1118     }
1119 
1120     /**
1121      * @dev Approve `to` to operate on `tokenId`
1122      *
1123      * Emits a {Approval} event.
1124      */
1125     function _approve(address to, uint256 tokenId) internal virtual {
1126         _tokenApprovals[tokenId] = to;
1127         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev Approve `operator` to operate on all of `owner` tokens
1132      *
1133      * Emits a {ApprovalForAll} event.
1134      */
1135     function _setApprovalForAll(
1136         address owner,
1137         address operator,
1138         bool approved
1139     ) internal virtual {
1140         require(owner != operator, "ERC721: approve to caller");
1141         _operatorApprovals[owner][operator] = approved;
1142         emit ApprovalForAll(owner, operator, approved);
1143     }
1144 
1145     /**
1146      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1147      * The call is not executed if the target address is not a contract.
1148      *
1149      * @param from address representing the previous owner of the given token ID
1150      * @param to target address that will receive the tokens
1151      * @param tokenId uint256 ID of the token to be transferred
1152      * @param _data bytes optional data to send along with the call
1153      * @return bool whether the call correctly returned the expected magic value
1154      */
1155     function _checkOnERC721Received(
1156         address from,
1157         address to,
1158         uint256 tokenId,
1159         bytes memory _data
1160     ) private returns (bool) {
1161         if (to.isContract()) {
1162             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1163                 return retval == IERC721Receiver.onERC721Received.selector;
1164             } catch (bytes memory reason) {
1165                 if (reason.length == 0) {
1166                     revert("ERC721: transfer to non ERC721Receiver implementer");
1167                 } else {
1168                     assembly {
1169                         revert(add(32, reason), mload(reason))
1170                     }
1171                 }
1172             }
1173         } else {
1174             return true;
1175         }
1176     }
1177 
1178     /**
1179      * @dev Hook that is called before any token transfer. This includes minting
1180      * and burning.
1181      *
1182      * Calling conditions:
1183      *
1184      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1185      * transferred to `to`.
1186      * - When `from` is zero, `tokenId` will be minted for `to`.
1187      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1188      * - `from` and `to` are never both zero.
1189      *
1190      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1191      */
1192     function _beforeTokenTransfer(
1193         address from,
1194         address to,
1195         uint256 tokenId
1196     ) internal virtual {}
1197 }
1198 
1199 // File: peaceful.sol
1200 
1201 pragma solidity 0.8.11; 
1202 
1203 
1204 
1205 
1206 
1207 contract OwnableDelegateProxy {}
1208 
1209 contract ProxyRegistry {
1210     mapping(address => OwnableDelegateProxy) public proxies;
1211 }
1212 
1213 abstract contract Toadz  {
1214     function balanceOf(address ownew) view public virtual returns (uint);
1215 }
1216 abstract contract Groupies {
1217     function balanceOf(address ownew) view public virtual returns (uint);
1218 }
1219 
1220  
1221 contract PeacefulToadz is ERC721, Ownable {
1222 
1223     using Counters for Counters.Counter;
1224     Counters.Counter private _tokenIdCounter;
1225 
1226   //constants
1227     uint public holdersaleCost = 0.066 ether;
1228     uint public presaleCost = 0.066 ether;
1229     uint public publicsaleCost = 0.066 ether;
1230     uint public maxSupply = 8888;
1231     uint private holderMaxMintAmount = 3;
1232     uint private publicMaxMintAmount = 25;
1233     uint private reservedOwnerMint=100;
1234     
1235   //variable s
1236     bool public paused = false;
1237     bool public baseURILocked = false;
1238     bool public publicsale = false;
1239     bool public holdersale = false;
1240     bool public presale = false;
1241     address public proxyRegistryAddress;
1242     bytes32 private merkleRoot;
1243     string public contractURL;
1244     string public baseURI;
1245     string public baseExtension = ".json";
1246 
1247     address public token1address;
1248     address public token2address;
1249     address public coldwallet;
1250   
1251   //Arrays
1252     mapping(address => uint) publicSaleMinted; 
1253     mapping(address => uint) holderSaleRemaining; 
1254     mapping(address => bool) holderSaleUsed; 
1255     mapping(address => uint) whitelistRemaining; 
1256     mapping(address => bool) whitelistUsed; 
1257 
1258   //Actions
1259     event BaseTokenURIChanged(string baseURI);
1260     event ContractURIChanged(string contractURL);
1261 
1262     constructor(string memory _name, string memory _symbol,string memory _initBaseURI,string memory _initcontractURI,address _initProxyAddress,bytes32 _merkleRoot,address _token1address, address _token2address,address _coldwallet) ERC721(_name, _symbol) {   
1263         setcontractURI(_initcontractURI);
1264         setBaseURI(_initBaseURI);
1265         setMerkleRoot(_merkleRoot);
1266         _tokenIdCounter.increment();
1267         token1address=_token1address;
1268         token2address=_token2address;
1269         proxyRegistryAddress=_initProxyAddress;
1270         coldwallet=_coldwallet;
1271         mint_function(reservedOwnerMint);
1272     }
1273 
1274     // internal
1275     function mint_function(uint _mintAmount) internal {
1276         require(!paused,"Contract is paused");
1277         uint current = _tokenIdCounter.current();
1278         require(current + _mintAmount <= maxSupply,"You're exceeding maximum tokens");
1279 
1280         for (uint i = 1; i <= _mintAmount; i++) {
1281           mintInternal();
1282         }
1283     }
1284 
1285     function mintInternal() internal {
1286         uint tokenId = _tokenIdCounter.current();
1287         _tokenIdCounter.increment();
1288         _mint(msg.sender, tokenId);
1289     }
1290   
1291 
1292   // public
1293     function totalSupply() public view returns (uint) {
1294         return _tokenIdCounter.current() - 1;
1295     }
1296 
1297     function holderSaleMint(uint _mintAmount) external payable{
1298         require(holdersale, "Holder minting is not active");
1299         require(msg.value >= holdersaleCost * _mintAmount,"You have unsufficient fund!");
1300         
1301         Groupies token1 = Groupies(token1address);
1302         Toadz token2 = Toadz(token2address);
1303         uint token1Balance = token1.balanceOf(msg.sender);
1304         uint token2Balance = token2.balanceOf(msg.sender);
1305         require(!(token1Balance==0 && token2Balance==0),"You Are Not Holder");
1306 
1307         if (!holderSaleUsed[msg.sender]){
1308             holderSaleUsed[msg.sender]=true;
1309             holderSaleRemaining[msg.sender]=holderMaxMintAmount;
1310         }
1311         require(holderSaleRemaining[msg.sender]-_mintAmount>=0,"You are exceed maximum mint amount");
1312         holderSaleRemaining[msg.sender] -= _mintAmount;
1313         mint_function(_mintAmount); 
1314     }
1315 
1316     function preSaleMint(uint _mintAmount, uint _MaxMintAmount,bool _earlyInvest, bytes32[] memory proof) external payable {
1317         require(presale, "Pre-sale minting is not active");
1318         require(_earlyInvest || msg.value >= presaleCost * _mintAmount,"You have unsufficient fund!");
1319         require( MerkleProof.verify(proof,merkleRoot, keccak256(abi.encodePacked(msg.sender,_MaxMintAmount,_earlyInvest))),"You're not in whitelist!");
1320         
1321         if (!whitelistUsed[msg.sender]){
1322             whitelistUsed[msg.sender]=true;
1323             whitelistRemaining[msg.sender]=_MaxMintAmount;
1324         }
1325         require(whitelistRemaining[msg.sender]-_mintAmount>=0,"You're exceeding registered amount");
1326         whitelistRemaining[msg.sender]-=_mintAmount;
1327         mint_function(_mintAmount);
1328     }
1329     
1330     function publicSaleMint(uint _mintAmount) external payable {
1331         require(publicsale, "Public sale not started yet");
1332         require(_mintAmount <= 5,"You can only 5 mint per TX");
1333         require(publicMaxMintAmount >= publicSaleMinted[msg.sender]+_mintAmount,"You are exceed maximum mint amount");
1334         require(msg.value >= publicsaleCost * _mintAmount,"You have unsufficient fund!");
1335         
1336         publicSaleMinted[msg.sender] += _mintAmount;
1337         mint_function(_mintAmount);
1338     }
1339     
1340     function tokenURI(uint tokenId) public view virtual override returns (string memory)
1341     {
1342         require(  _exists(tokenId),"ERC721Metadata: URI query for nonexistent token" );
1343         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId), baseExtension)) : "";
1344     }
1345     
1346     function contractURI() public view returns (string memory) {
1347       return contractURL;
1348     }
1349     
1350     //ADMIN FUNCTIONS
1351     function lockContract() public onlyOwner(){
1352       baseURILocked=true;
1353     }
1354     
1355     function ownershiptransfer(address _newOwner) public onlyOwner(){
1356         transferOwnership(_newOwner);
1357     }
1358     
1359     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner() {
1360         merkleRoot = _merkleRoot;
1361     }
1362     
1363     function setBaseURI(string memory _newBaseURI) public onlyOwner() {
1364         require(!baseURILocked,"We Can't change baseURI");
1365         baseURI = _newBaseURI;
1366         emit BaseTokenURIChanged(_newBaseURI);
1367     }
1368     
1369     function setBaseExtension(string memory _newBaseExtension) public onlyOwner() {
1370         baseExtension = _newBaseExtension;
1371     }
1372     
1373     function setcontractURI(string memory _newcontractURI) public onlyOwner() {
1374         contractURL = _newcontractURI;
1375         emit ContractURIChanged(_newcontractURI);
1376     }
1377 
1378   
1379 
1380     function toogleSection(uint section) public onlyOwner() {
1381         require (section<4,"Please select section");
1382         if (section==0) paused=!paused;
1383         if (section==1) presale=!presale;
1384         if (section==2) publicsale=!publicsale;
1385         if (section==3) holdersale=!holdersale;
1386     }
1387 
1388 
1389     function changePrice(uint section, uint price) public onlyOwner() {
1390         require (section<4,"Please select section");
1391         if (section==0){
1392             publicsaleCost=price;
1393             presaleCost=price;
1394             holdersaleCost=price;
1395         }
1396         if (section==1) publicsaleCost=price;
1397         if (section==2) presaleCost=price;
1398         if (section==3) holdersaleCost=price;
1399         
1400     }
1401     function setAddress(uint section, address _address) public onlyOwner() {
1402         require (section<4,"Please select section");
1403         if (section==0){
1404             token1address=_address;
1405         }
1406         if (section==1){
1407             token2address=_address;
1408         }
1409         if (section==2){
1410             proxyRegistryAddress=_address;
1411         }
1412         if (section==3){
1413             coldwallet=_address;
1414         }
1415     
1416     }
1417       
1418     function withdraw() public payable {
1419         require(coldwallet != address(0), "coldwallet is the zero address");
1420         require(payable(coldwallet).send(address(this).balance));
1421     }
1422 
1423     function tokensOfOwner(address _owner, uint startId, uint endId) external view returns(uint[] memory ) {
1424         uint tokenCount = balanceOf(_owner);
1425         if (tokenCount == 0) {
1426             return new uint[](0);
1427         } else {
1428             uint[] memory result = new uint[](tokenCount);
1429             uint index = 0;
1430 
1431             for (uint tokenId = startId; tokenId < endId; tokenId++) {
1432                 if (index == tokenCount) break;
1433 
1434                 if (ownerOf(tokenId) == _owner) {
1435                     result[index] = tokenId;
1436                     index++;
1437                 }
1438             }
1439             return result;
1440         }
1441     }
1442     // Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1443     function isApprovedForAll(address owner, address operator) override public view returns (bool)
1444     {
1445         // Whitelist OpenSea proxy contract for easy trading.
1446         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1447         if (address(proxyRegistry.proxies(owner)) == operator) {
1448             return true;
1449         }
1450         return super.isApprovedForAll(owner, operator);
1451     }
1452 }