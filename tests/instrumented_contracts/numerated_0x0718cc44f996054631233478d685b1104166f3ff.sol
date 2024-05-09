1 // SPDX-License-Identifier: MIT
2 
3 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev These functions deal with verification of Merkle Trees proofs.
12  *
13  * The proofs can be generated using the JavaScript library
14  * https://github.com/miguelmota/merkletreejs[merkletreejs].
15  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
16  *
17  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
18  *
19  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
20  * hashing, or use a hash function other than keccak256 for hashing leaves.
21  * This is because the concatenation of a sorted pair of internal nodes in
22  * the merkle tree could be reinterpreted as a leaf value.
23  */
24 // File: @openzeppelin/contracts/utils/Counters.sol
25 
26 
27 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @title Counters
33  * @author Matt Condon (@shrugs)
34  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
35  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
36  *
37  * Include with `using Counters for Counters.Counter;`
38  */
39 library Counters {
40     struct Counter {
41         // This variable should never be directly accessed by users of the library: interactions must be restricted to
42         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
43         // this feature: see https://github.com/ethereum/solidity/issues/4637
44         uint256 _value; // default: 0
45     }
46 
47     function current(Counter storage counter) internal view returns (uint256) {
48         return counter._value;
49     }
50 
51     function increment(Counter storage counter) internal {
52         unchecked {
53             counter._value += 1;
54         }
55     }
56 
57     function decrement(Counter storage counter) internal {
58         uint256 value = counter._value;
59         require(value > 0, "Counter: decrement overflow");
60         unchecked {
61             counter._value = value - 1;
62         }
63     }
64 
65     function reset(Counter storage counter) internal {
66         counter._value = 0;
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Strings.sol
71 
72 
73 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev String operations.
79  */
80 library Strings {
81     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
85      */
86     function toString(uint256 value) internal pure returns (string memory) {
87         // Inspired by OraclizeAPI's implementation - MIT licence
88         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
89 
90         if (value == 0) {
91             return "0";
92         }
93         uint256 temp = value;
94         uint256 digits;
95         while (temp != 0) {
96             digits++;
97             temp /= 10;
98         }
99         bytes memory buffer = new bytes(digits);
100         while (value != 0) {
101             digits -= 1;
102             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
103             value /= 10;
104         }
105         return string(buffer);
106     }
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
110      */
111     function toHexString(uint256 value) internal pure returns (string memory) {
112         if (value == 0) {
113             return "0x00";
114         }
115         uint256 temp = value;
116         uint256 length = 0;
117         while (temp != 0) {
118             length++;
119             temp >>= 8;
120         }
121         return toHexString(value, length);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
126      */
127     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
128         bytes memory buffer = new bytes(2 * length + 2);
129         buffer[0] = "0";
130         buffer[1] = "x";
131         for (uint256 i = 2 * length + 1; i > 1; --i) {
132             buffer[i] = _HEX_SYMBOLS[value & 0xf];
133             value >>= 4;
134         }
135         require(value == 0, "Strings: hex length insufficient");
136         return string(buffer);
137     }
138 }
139 
140 // File: @openzeppelin/contracts/utils/Context.sol
141 
142 
143 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
144 
145 pragma solidity ^0.8.0;
146 
147 /**
148  * @dev Provides information about the current execution context, including the
149  * sender of the transaction and its data. While these are generally available
150  * via msg.sender and msg.data, they should not be accessed in such a direct
151  * manner, since when dealing with meta-transactions the account sending and
152  * paying for execution may not be the actual sender (as far as an application
153  * is concerned).
154  *
155  * This contract is only required for intermediate, library-like contracts.
156  */
157 abstract contract Context {
158     function _msgSender() internal view virtual returns (address) {
159         return msg.sender;
160     }
161 
162     function _msgData() internal view virtual returns (bytes calldata) {
163         return msg.data;
164     }
165 }
166 
167 // File: @openzeppelin/contracts/access/Ownable.sol
168 
169 
170 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 
175 /**
176  * @dev Contract module which provides a basic access control mechanism, where
177  * there is an account (an owner) that can be granted exclusive access to
178  * specific functions.
179  *
180  * By default, the owner account will be the one that deploys the contract. This
181  * can later be changed with {transferOwnership}.
182  *
183  * This module is used through inheritance. It will make available the modifier
184  * `onlyOwner`, which can be applied to your functions to restrict their use to
185  * the owner.
186  */
187 abstract contract Ownable is Context {
188     address private _owner;
189 
190     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
191 
192     /**
193      * @dev Initializes the contract setting the deployer as the initial owner.
194      */
195     constructor() {
196         _transferOwnership(_msgSender());
197     }
198 
199     /**
200      * @dev Returns the address of the current owner.
201      */
202     function owner() public view virtual returns (address) {
203         return _owner;
204     }
205 
206     /**
207      * @dev Throws if called by any account other than the owner.
208      */
209     modifier onlyOwner() {
210         require(owner() == _msgSender(), "Ownable: caller is not the owner");
211         _;
212     }
213 
214     /**
215      * @dev Leaves the contract without owner. It will not be possible to call
216      * `onlyOwner` functions anymore. Can only be called by the current owner.
217      *
218      * NOTE: Renouncing ownership will leave the contract without an owner,
219      * thereby removing any functionality that is only available to the owner.
220      */
221     function renounceOwnership() public virtual onlyOwner {
222         _transferOwnership(address(0));
223     }
224 
225     /**
226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
227      * Can only be called by the current owner.
228      */
229     function transferOwnership(address newOwner) public virtual onlyOwner {
230         require(newOwner != address(0), "Ownable: new owner is the zero address");
231         _transferOwnership(newOwner);
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Internal function without access restriction.
237      */
238     function _transferOwnership(address newOwner) internal virtual {
239         address oldOwner = _owner;
240         _owner = newOwner;
241         emit OwnershipTransferred(oldOwner, newOwner);
242     }
243 }
244 
245 // File: @openzeppelin/contracts/utils/Address.sol
246 
247 
248 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // This method relies on extcodesize, which returns 0 for contracts in
275         // construction, since the code is only stored at the end of the
276         // constructor execution.
277 
278         uint256 size;
279         assembly {
280             size := extcodesize(account)
281         }
282         return size > 0;
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
699 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
709  * @dev See https://eips.ethereum.org/EIPS/eip-721
710  */
711 interface IERC721Metadata is IERC721 {
712     /**
713      * @dev Returns the token collection name.
714      */
715     function name() external view returns (string memory);
716 
717     /**
718      * @dev Returns the token collection symbol.
719      */
720     function symbol() external view returns (string memory);
721 
722     /**
723      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
724      */
725     function tokenURI(uint256 tokenId) external view returns (string memory);
726 }
727 
728 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
729 
730 
731 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
732 
733 pragma solidity ^0.8.0;
734 
735 
736 
737 
738 
739 
740 
741 
742 /**
743  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
744  * the Metadata extension, but not including the Enumerable extension, which is available separately as
745  * {ERC721Enumerable}.
746  */
747 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
748     using Address for address;
749     using Strings for uint256;
750 
751     // Token name
752     string private _name;
753 
754     // Token symbol
755     string private _symbol;
756 
757     // Mapping from token ID to owner address
758     mapping(uint256 => address) private _owners;
759 
760     // Mapping owner address to token count
761     mapping(address => uint256) private _balances;
762 
763     // Mapping from token ID to approved address
764     mapping(uint256 => address) private _tokenApprovals;
765 
766     // Mapping from owner to operator approvals
767     mapping(address => mapping(address => bool)) private _operatorApprovals;
768 
769     /**
770      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
771      */
772     constructor(string memory name_, string memory symbol_) {
773         _name = name_;
774         _symbol = symbol_;
775     }
776 
777     /**
778      * @dev See {IERC165-supportsInterface}.
779      */
780     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
781         return
782             interfaceId == type(IERC721).interfaceId ||
783             interfaceId == type(IERC721Metadata).interfaceId ||
784             super.supportsInterface(interfaceId);
785     }
786 
787     /**
788      * @dev See {IERC721-balanceOf}.
789      */
790     function balanceOf(address owner) public view virtual override returns (uint256) {
791         require(owner != address(0), "ERC721: balance query for the zero address");
792         return _balances[owner];
793     }
794 
795     /**
796      * @dev See {IERC721-ownerOf}.
797      */
798     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
799         address owner = _owners[tokenId];
800         require(owner != address(0), "ERC721: owner query for nonexistent token");
801         return owner;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-name}.
806      */
807     function name() public view virtual override returns (string memory) {
808         return _name;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-symbol}.
813      */
814     function symbol() public view virtual override returns (string memory) {
815         return _symbol;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-tokenURI}.
820      */
821     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
822         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
823 
824         string memory baseURI = _baseURI();
825         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
826     }
827 
828     /**
829      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
830      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
831      * by default, can be overriden in child contracts.
832      */
833     function _baseURI() internal view virtual returns (string memory) {
834         return "";
835     }
836 
837     /**
838      * @dev See {IERC721-approve}.
839      */
840     function approve(address to, uint256 tokenId) public virtual override {
841         address owner = ERC721.ownerOf(tokenId);
842         require(to != owner, "ERC721: approval to current owner");
843 
844         require(
845             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
846             "ERC721: approve caller is not owner nor approved for all"
847         );
848 
849         _approve(to, tokenId);
850     }
851 
852     /**
853      * @dev See {IERC721-getApproved}.
854      */
855     function getApproved(uint256 tokenId) public view virtual override returns (address) {
856         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
857 
858         return _tokenApprovals[tokenId];
859     }
860 
861     /**
862      * @dev See {IERC721-setApprovalForAll}.
863      */
864     function setApprovalForAll(address operator, bool approved) public virtual override {
865         _setApprovalForAll(_msgSender(), operator, approved);
866     }
867 
868     /**
869      * @dev See {IERC721-isApprovedForAll}.
870      */
871     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
872         return _operatorApprovals[owner][operator];
873     }
874 
875     /**
876      * @dev See {IERC721-transferFrom}.
877      */
878     function transferFrom(
879         address from,
880         address to,
881         uint256 tokenId
882     ) public virtual override {
883         //solhint-disable-next-line max-line-length
884         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
885 
886         _transfer(from, to, tokenId);
887     }
888 
889     /**
890      * @dev See {IERC721-safeTransferFrom}.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public virtual override {
897         safeTransferFrom(from, to, tokenId, "");
898     }
899 
900     /**
901      * @dev See {IERC721-safeTransferFrom}.
902      */
903     function safeTransferFrom(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) public virtual override {
909         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
910         _safeTransfer(from, to, tokenId, _data);
911     }
912 
913     /**
914      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
915      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
916      *
917      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
918      *
919      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
920      * implement alternative mechanisms to perform token transfer, such as signature-based.
921      *
922      * Requirements:
923      *
924      * - `from` cannot be the zero address.
925      * - `to` cannot be the zero address.
926      * - `tokenId` token must exist and be owned by `from`.
927      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _safeTransfer(
932         address from,
933         address to,
934         uint256 tokenId,
935         bytes memory _data
936     ) internal virtual {
937         _transfer(from, to, tokenId);
938         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
939     }
940 
941     /**
942      * @dev Returns whether `tokenId` exists.
943      *
944      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
945      *
946      * Tokens start existing when they are minted (`_mint`),
947      * and stop existing when they are burned (`_burn`).
948      */
949     function _exists(uint256 tokenId) internal view virtual returns (bool) {
950         return _owners[tokenId] != address(0);
951     }
952 
953     /**
954      * @dev Returns whether `spender` is allowed to manage `tokenId`.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must exist.
959      */
960     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
961         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
962         address owner = ERC721.ownerOf(tokenId);
963         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
964     }
965 
966     /**
967      * @dev Safely mints `tokenId` and transfers it to `to`.
968      *
969      * Requirements:
970      *
971      * - `tokenId` must not exist.
972      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _safeMint(address to, uint256 tokenId) internal virtual {
977         _safeMint(to, tokenId, "");
978     }
979 
980     /**
981      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
982      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
983      */
984     function _safeMint(
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) internal virtual {
989         _mint(to, tokenId);
990         require(
991             _checkOnERC721Received(address(0), to, tokenId, _data),
992             "ERC721: transfer to non ERC721Receiver implementer"
993         );
994     }
995 
996     /**
997      * @dev Mints `tokenId` and transfers it to `to`.
998      *
999      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must not exist.
1004      * - `to` cannot be the zero address.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _mint(address to, uint256 tokenId) internal virtual {
1009         require(to != address(0), "ERC721: mint to the zero address");
1010         require(!_exists(tokenId), "ERC721: token already minted");
1011 
1012         _beforeTokenTransfer(address(0), to, tokenId);
1013 
1014         _balances[to] += 1;
1015         _owners[tokenId] = to;
1016 
1017         emit Transfer(address(0), to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev Destroys `tokenId`.
1022      * The approval is cleared when the token is burned.
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must exist.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _burn(uint256 tokenId) internal virtual {
1031         address owner = ERC721.ownerOf(tokenId);
1032 
1033         _beforeTokenTransfer(owner, address(0), tokenId);
1034 
1035         // Clear approvals
1036         _approve(address(0), tokenId);
1037 
1038         _balances[owner] -= 1;
1039         delete _owners[tokenId];
1040 
1041         emit Transfer(owner, address(0), tokenId);
1042     }
1043 
1044     /**
1045      * @dev Transfers `tokenId` from `from` to `to`.
1046      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1047      *
1048      * Requirements:
1049      *
1050      * - `to` cannot be the zero address.
1051      * - `tokenId` token must be owned by `from`.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _transfer(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) internal virtual {
1060         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1061         require(to != address(0), "ERC721: transfer to the zero address");
1062 
1063         _beforeTokenTransfer(from, to, tokenId);
1064 
1065         // Clear approvals from the previous owner
1066         _approve(address(0), tokenId);
1067 
1068         _balances[from] -= 1;
1069         _balances[to] += 1;
1070         _owners[tokenId] = to;
1071 
1072         emit Transfer(from, to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev Approve `to` to operate on `tokenId`
1077      *
1078      * Emits a {Approval} event.
1079      */
1080     function _approve(address to, uint256 tokenId) internal virtual {
1081         _tokenApprovals[tokenId] = to;
1082         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev Approve `operator` to operate on all of `owner` tokens
1087      *
1088      * Emits a {ApprovalForAll} event.
1089      */
1090     function _setApprovalForAll(
1091         address owner,
1092         address operator,
1093         bool approved
1094     ) internal virtual {
1095         require(owner != operator, "ERC721: approve to caller");
1096         _operatorApprovals[owner][operator] = approved;
1097         emit ApprovalForAll(owner, operator, approved);
1098     }
1099 
1100     /**
1101      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1102      * The call is not executed if the target address is not a contract.
1103      *
1104      * @param from address representing the previous owner of the given token ID
1105      * @param to target address that will receive the tokens
1106      * @param tokenId uint256 ID of the token to be transferred
1107      * @param _data bytes optional data to send along with the call
1108      * @return bool whether the call correctly returned the expected magic value
1109      */
1110     function _checkOnERC721Received(
1111         address from,
1112         address to,
1113         uint256 tokenId,
1114         bytes memory _data
1115     ) private returns (bool) {
1116         if (to.isContract()) {
1117             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1118                 return retval == IERC721Receiver.onERC721Received.selector;
1119             } catch (bytes memory reason) {
1120                 if (reason.length == 0) {
1121                     revert("ERC721: transfer to non ERC721Receiver implementer");
1122                 } else {
1123                     assembly {
1124                         revert(add(32, reason), mload(reason))
1125                     }
1126                 }
1127             }
1128         } else {
1129             return true;
1130         }
1131     }
1132 
1133     /**
1134      * @dev Hook that is called before any token transfer. This includes minting
1135      * and burning.
1136      *
1137      * Calling conditions:
1138      *
1139      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1140      * transferred to `to`.
1141      * - When `from` is zero, `tokenId` will be minted for `to`.
1142      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1143      * - `from` and `to` are never both zero.
1144      *
1145      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1146      */
1147     function _beforeTokenTransfer(
1148         address from,
1149         address to,
1150         uint256 tokenId
1151     ) internal virtual {}
1152 }
1153 
1154 // File: contracts/MonsterMania.sol
1155 
1156 
1157 
1158 pragma solidity >=0.7.0 <0.9.0;
1159 
1160 
1161 contract MonsterMania is ERC721, Ownable {
1162   using Strings for uint256;
1163   using Counters for Counters.Counter;
1164 
1165   Counters.Counter private supply;
1166 
1167   string public uriPrefix = ""; // BaseURI
1168   string public uriSuffix = ".json";
1169   string public hiddenMetadataUri;
1170   
1171   uint32 publicSaleStartTime;
1172 
1173   uint256 public cost = 0.04 ether;
1174   uint256 public maxSupply = 4444;
1175   uint256 public maxMintAmountPerTx = 5;
1176 
1177   bool public paused = false; // Only for public sale.
1178   bool public revealed = false;
1179 
1180   mapping(address => uint256) public userWallets;
1181 
1182   constructor() ERC721("MonsterMania", "MM") {
1183     setHiddenMetadataUri("ipfs://QmXc9QBz6bnfZ32PGuCZz8pf55Q16GrohSZJHgPSQu7Yw3/hidden.json");
1184     publicSaleStartTime = 1650228240; // 4/17/22 4:44 PM EST
1185 
1186 }
1187 
1188   modifier mintCompliance(uint256 _mintAmount) {
1189     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount");
1190     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1191     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1192     _;
1193   } 
1194 
1195   function totalSupply() public view returns (uint256) {
1196     return supply.current();
1197   }
1198 
1199   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1200     require(!paused, "Public minting is paused. Presale is probably going on.");
1201     require(publicSaleStartTime <= block.timestamp, "Public sale is not active.");
1202 
1203     _mintLoop(msg.sender, _mintAmount);
1204   }
1205   
1206   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1207     _mintLoop(_receiver, _mintAmount);
1208   }
1209 
1210   function walletOfOwner(address _owner)
1211     public
1212     view
1213     returns (uint256[] memory)
1214   {
1215     uint256 ownerTokenCount = balanceOf(_owner);
1216     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1217     uint256 currentTokenId = 1;
1218     uint256 ownedTokenIndex = 0;
1219 
1220     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1221       address currentTokenOwner = ownerOf(currentTokenId);
1222 
1223       if (currentTokenOwner == _owner) {
1224         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1225 
1226         ownedTokenIndex++;
1227       }
1228 
1229       currentTokenId++;
1230     }
1231 
1232     return ownedTokenIds;
1233   }
1234 
1235   function tokenURI(uint256 _tokenId)
1236     public
1237     view
1238     virtual
1239     override
1240     returns (string memory)
1241   {
1242     require( _exists(_tokenId), "ERC721Metadata: URI query for nonexistent token"
1243     );
1244 
1245     if (revealed == false) {
1246       return hiddenMetadataUri;
1247     }
1248 
1249     string memory currentBaseURI = _baseURI();
1250     return bytes(currentBaseURI).length > 0
1251         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1252         : "";
1253   }
1254 
1255   function setRevealed(bool _state) public onlyOwner {
1256     revealed = _state;
1257   }
1258 
1259   function setCost(uint256 _cost) public onlyOwner {
1260     cost = _cost;
1261   }
1262 
1263   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1264     maxMintAmountPerTx = _maxMintAmountPerTx;
1265   }
1266 
1267   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1268     hiddenMetadataUri = _hiddenMetadataUri;
1269   }
1270 
1271   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1272     uriPrefix = _uriPrefix;
1273   }
1274 
1275   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1276     uriSuffix = _uriSuffix;
1277   }
1278 
1279   function setPaused(bool _state) public onlyOwner {
1280     paused = _state;
1281   }
1282 
1283   function emergencyOverridePublicSaleStartTime(uint32 startTime_) public onlyOwner {
1284     publicSaleStartTime = startTime_;
1285   }
1286 
1287   function withdraw() public onlyOwner {
1288     (bool hs, ) = payable(0x348284911bbF67734704b565d0442B5Cece2BCFf).call{value: address(this).balance * 10 / 100}("");
1289     require(hs);
1290 
1291     (bool hsa, ) = payable(0x56BDa1c4e30221cd875C40640fefB5B51Bf37bcA).call{value: address(this).balance * 30 / 100}("");
1292     require(hsa);
1293 
1294     (bool hsb, ) = payable(0xb631B67859063bf88ECbC31B6C7809064c1D91bd).call{value: address(this).balance * 30 / 100}("");
1295     require(hsb);
1296 
1297     (bool hsc, ) = payable(0x38cB1C021668e7c72ec0AFD02d218d805361f331).call{value: address(this).balance * 30 / 100}("");
1298     require(hsc);
1299   }
1300 
1301   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1302     for (uint256 i = 0; i < _mintAmount; i++) {
1303       userWallets[msg.sender]++;
1304       supply.increment();
1305       _safeMint(_receiver, supply.current());
1306     }
1307   }
1308 
1309   function _baseURI() internal view virtual override returns (string memory) {
1310     return uriPrefix;
1311   }
1312 }