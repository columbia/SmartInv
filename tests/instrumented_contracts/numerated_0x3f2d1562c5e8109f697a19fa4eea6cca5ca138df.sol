1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Address.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev Collection of functions related to the address type
146  */
147 library Address {
148     /**
149      * @dev Returns true if `account` is a contract.
150      *
151      * [IMPORTANT]
152      * ====
153      * It is unsafe to assume that an address for which this function returns
154      * false is an externally-owned account (EOA) and not a contract.
155      *
156      * Among others, `isContract` will return false for the following
157      * types of addresses:
158      *
159      *  - an externally-owned account
160      *  - a contract in construction
161      *  - an address where a contract will be created
162      *  - an address where a contract lived, but was destroyed
163      * ====
164      */
165     function isContract(address account) internal view returns (bool) {
166         // This method relies on extcodesize, which returns 0 for contracts in
167         // construction, since the code is only stored at the end of the
168         // constructor execution.
169 
170         uint256 size;
171         assembly {
172             size := extcodesize(account)
173         }
174         return size > 0;
175     }
176 
177     /**
178      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
179      * `recipient`, forwarding all available gas and reverting on errors.
180      *
181      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
182      * of certain opcodes, possibly making contracts go over the 2300 gas limit
183      * imposed by `transfer`, making them unable to receive funds via
184      * `transfer`. {sendValue} removes this limitation.
185      *
186      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
187      *
188      * IMPORTANT: because control is transferred to `recipient`, care must be
189      * taken to not create reentrancy vulnerabilities. Consider using
190      * {ReentrancyGuard} or the
191      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
192      */
193     function sendValue(address payable recipient, uint256 amount) internal {
194         require(address(this).balance >= amount, "Address: insufficient balance");
195 
196         (bool success, ) = recipient.call{value: amount}("");
197         require(success, "Address: unable to send value, recipient may have reverted");
198     }
199 
200     /**
201      * @dev Performs a Solidity function call using a low level `call`. A
202      * plain `call` is an unsafe replacement for a function call: use this
203      * function instead.
204      *
205      * If `target` reverts with a revert reason, it is bubbled up by this
206      * function (like regular Solidity function calls).
207      *
208      * Returns the raw returned data. To convert to the expected return value,
209      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
210      *
211      * Requirements:
212      *
213      * - `target` must be a contract.
214      * - calling `target` with `data` must not revert.
215      *
216      * _Available since v3.1._
217      */
218     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
219         return functionCall(target, data, "Address: low-level call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
224      * `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, 0, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but also transferring `value` wei to `target`.
239      *
240      * Requirements:
241      *
242      * - the calling contract must have an ETH balance of at least `value`.
243      * - the called Solidity function must be `payable`.
244      *
245      * _Available since v3.1._
246      */
247     function functionCallWithValue(
248         address target,
249         bytes memory data,
250         uint256 value
251     ) internal returns (bytes memory) {
252         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
257      * with `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(
262         address target,
263         bytes memory data,
264         uint256 value,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         require(address(this).balance >= value, "Address: insufficient balance for call");
268         require(isContract(target), "Address: call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.call{value: value}(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but performing a static call.
277      *
278      * _Available since v3.3._
279      */
280     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
281         return functionStaticCall(target, data, "Address: low-level static call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
286      * but performing a static call.
287      *
288      * _Available since v3.3._
289      */
290     function functionStaticCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal view returns (bytes memory) {
295         require(isContract(target), "Address: static call to non-contract");
296 
297         (bool success, bytes memory returndata) = target.staticcall(data);
298         return verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but performing a delegate call.
304      *
305      * _Available since v3.4._
306      */
307     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
313      * but performing a delegate call.
314      *
315      * _Available since v3.4._
316      */
317     function functionDelegateCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         require(isContract(target), "Address: delegate call to non-contract");
323 
324         (bool success, bytes memory returndata) = target.delegatecall(data);
325         return verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
330      * revert reason using the provided one.
331      *
332      * _Available since v4.3._
333      */
334     function verifyCallResult(
335         bool success,
336         bytes memory returndata,
337         string memory errorMessage
338     ) internal pure returns (bytes memory) {
339         if (success) {
340             return returndata;
341         } else {
342             // Look for revert reason and bubble it up if present
343             if (returndata.length > 0) {
344                 // The easiest way to bubble the revert reason is using memory via assembly
345 
346                 assembly {
347                     let returndata_size := mload(returndata)
348                     revert(add(32, returndata), returndata_size)
349                 }
350             } else {
351                 revert(errorMessage);
352             }
353         }
354     }
355 }
356 
357 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
358 
359 
360 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 /**
365  * @title ERC721 token receiver interface
366  * @dev Interface for any contract that wants to support safeTransfers
367  * from ERC721 asset contracts.
368  */
369 interface IERC721Receiver {
370     /**
371      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
372      * by `operator` from `from`, this function is called.
373      *
374      * It must return its Solidity selector to confirm the token transfer.
375      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
376      *
377      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
378      */
379     function onERC721Received(
380         address operator,
381         address from,
382         uint256 tokenId,
383         bytes calldata data
384     ) external returns (bytes4);
385 }
386 
387 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @dev Interface of the ERC165 standard, as defined in the
396  * https://eips.ethereum.org/EIPS/eip-165[EIP].
397  *
398  * Implementers can declare support of contract interfaces, which can then be
399  * queried by others ({ERC165Checker}).
400  *
401  * For an implementation, see {ERC165}.
402  */
403 interface IERC165 {
404     /**
405      * @dev Returns true if this contract implements the interface defined by
406      * `interfaceId`. See the corresponding
407      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
408      * to learn more about how these ids are created.
409      *
410      * This function call must use less than 30 000 gas.
411      */
412     function supportsInterface(bytes4 interfaceId) external view returns (bool);
413 }
414 
415 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
416 
417 
418 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 
423 /**
424  * @dev Implementation of the {IERC165} interface.
425  *
426  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
427  * for the additional interface id that will be supported. For example:
428  *
429  * ```solidity
430  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
431  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
432  * }
433  * ```
434  *
435  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
436  */
437 abstract contract ERC165 is IERC165 {
438     /**
439      * @dev See {IERC165-supportsInterface}.
440      */
441     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
442         return interfaceId == type(IERC165).interfaceId;
443     }
444 }
445 
446 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
447 
448 
449 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 
454 /**
455  * @dev Required interface of an ERC721 compliant contract.
456  */
457 interface IERC721 is IERC165 {
458     /**
459      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
460      */
461     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
462 
463     /**
464      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
465      */
466     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
467 
468     /**
469      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
470      */
471     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
472 
473     /**
474      * @dev Returns the number of tokens in ``owner``'s account.
475      */
476     function balanceOf(address owner) external view returns (uint256 balance);
477 
478     /**
479      * @dev Returns the owner of the `tokenId` token.
480      *
481      * Requirements:
482      *
483      * - `tokenId` must exist.
484      */
485     function ownerOf(uint256 tokenId) external view returns (address owner);
486 
487     /**
488      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
489      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
490      *
491      * Requirements:
492      *
493      * - `from` cannot be the zero address.
494      * - `to` cannot be the zero address.
495      * - `tokenId` token must exist and be owned by `from`.
496      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
497      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
498      *
499      * Emits a {Transfer} event.
500      */
501     function safeTransferFrom(
502         address from,
503         address to,
504         uint256 tokenId
505     ) external;
506 
507     /**
508      * @dev Transfers `tokenId` token from `from` to `to`.
509      *
510      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must be owned by `from`.
517      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
518      *
519      * Emits a {Transfer} event.
520      */
521     function transferFrom(
522         address from,
523         address to,
524         uint256 tokenId
525     ) external;
526 
527     /**
528      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
529      * The approval is cleared when the token is transferred.
530      *
531      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
532      *
533      * Requirements:
534      *
535      * - The caller must own the token or be an approved operator.
536      * - `tokenId` must exist.
537      *
538      * Emits an {Approval} event.
539      */
540     function approve(address to, uint256 tokenId) external;
541 
542     /**
543      * @dev Returns the account approved for `tokenId` token.
544      *
545      * Requirements:
546      *
547      * - `tokenId` must exist.
548      */
549     function getApproved(uint256 tokenId) external view returns (address operator);
550 
551     /**
552      * @dev Approve or remove `operator` as an operator for the caller.
553      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
554      *
555      * Requirements:
556      *
557      * - The `operator` cannot be the caller.
558      *
559      * Emits an {ApprovalForAll} event.
560      */
561     function setApprovalForAll(address operator, bool _approved) external;
562 
563     /**
564      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
565      *
566      * See {setApprovalForAll}
567      */
568     function isApprovedForAll(address owner, address operator) external view returns (bool);
569 
570     /**
571      * @dev Safely transfers `tokenId` token from `from` to `to`.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must exist and be owned by `from`.
578      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
579      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
580      *
581      * Emits a {Transfer} event.
582      */
583     function safeTransferFrom(
584         address from,
585         address to,
586         uint256 tokenId,
587         bytes calldata data
588     ) external;
589 }
590 
591 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
592 
593 
594 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 
599 /**
600  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
601  * @dev See https://eips.ethereum.org/EIPS/eip-721
602  */
603 interface IERC721Metadata is IERC721 {
604     /**
605      * @dev Returns the token collection name.
606      */
607     function name() external view returns (string memory);
608 
609     /**
610      * @dev Returns the token collection symbol.
611      */
612     function symbol() external view returns (string memory);
613 
614     /**
615      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
616      */
617     function tokenURI(uint256 tokenId) external view returns (string memory);
618 }
619 
620 // File: @openzeppelin/contracts/utils/Context.sol
621 
622 
623 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @dev Provides information about the current execution context, including the
629  * sender of the transaction and its data. While these are generally available
630  * via msg.sender and msg.data, they should not be accessed in such a direct
631  * manner, since when dealing with meta-transactions the account sending and
632  * paying for execution may not be the actual sender (as far as an application
633  * is concerned).
634  *
635  * This contract is only required for intermediate, library-like contracts.
636  */
637 abstract contract Context {
638     function _msgSender() internal view virtual returns (address) {
639         return msg.sender;
640     }
641 
642     function _msgData() internal view virtual returns (bytes calldata) {
643         return msg.data;
644     }
645 }
646 
647 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
648 
649 
650 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 
655 
656 
657 
658 
659 
660 
661 /**
662  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
663  * the Metadata extension, but not including the Enumerable extension, which is available separately as
664  * {ERC721Enumerable}.
665  */
666 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
667     using Address for address;
668     using Strings for uint256;
669 
670     // Token name
671     string private _name;
672 
673     // Token symbol
674     string private _symbol;
675 
676     // Mapping from token ID to owner address
677     mapping(uint256 => address) private _owners;
678 
679     // Mapping owner address to token count
680     mapping(address => uint256) private _balances;
681 
682     // Mapping from token ID to approved address
683     mapping(uint256 => address) private _tokenApprovals;
684 
685     // Mapping from owner to operator approvals
686     mapping(address => mapping(address => bool)) private _operatorApprovals;
687 
688     /**
689      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
690      */
691     constructor(string memory name_, string memory symbol_) {
692         _name = name_;
693         _symbol = symbol_;
694     }
695 
696     /**
697      * @dev See {IERC165-supportsInterface}.
698      */
699     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
700         return
701             interfaceId == type(IERC721).interfaceId ||
702             interfaceId == type(IERC721Metadata).interfaceId ||
703             super.supportsInterface(interfaceId);
704     }
705 
706     /**
707      * @dev See {IERC721-balanceOf}.
708      */
709     function balanceOf(address owner) public view virtual override returns (uint256) {
710         require(owner != address(0), "ERC721: balance query for the zero address");
711         return _balances[owner];
712     }
713 
714     /**
715      * @dev See {IERC721-ownerOf}.
716      */
717     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
718         address owner = _owners[tokenId];
719         require(owner != address(0), "ERC721: owner query for nonexistent token");
720         return owner;
721     }
722 
723     /**
724      * @dev See {IERC721Metadata-name}.
725      */
726     function name() public view virtual override returns (string memory) {
727         return _name;
728     }
729 
730     /**
731      * @dev See {IERC721Metadata-symbol}.
732      */
733     function symbol() public view virtual override returns (string memory) {
734         return _symbol;
735     }
736 
737     /**
738      * @dev See {IERC721Metadata-tokenURI}.
739      */
740     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
741         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
742 
743         string memory baseURI = _baseURI();
744         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
745     }
746 
747     /**
748      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
749      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
750      * by default, can be overriden in child contracts.
751      */
752     function _baseURI() internal view virtual returns (string memory) {
753         return "";
754     }
755 
756     /**
757      * @dev See {IERC721-approve}.
758      */
759     function approve(address to, uint256 tokenId) public virtual override {
760         address owner = ERC721.ownerOf(tokenId);
761         require(to != owner, "ERC721: approval to current owner");
762 
763         require(
764             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
765             "ERC721: approve caller is not owner nor approved for all"
766         );
767 
768         _approve(to, tokenId);
769     }
770 
771     /**
772      * @dev See {IERC721-getApproved}.
773      */
774     function getApproved(uint256 tokenId) public view virtual override returns (address) {
775         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
776 
777         return _tokenApprovals[tokenId];
778     }
779 
780     /**
781      * @dev See {IERC721-setApprovalForAll}.
782      */
783     function setApprovalForAll(address operator, bool approved) public virtual override {
784         _setApprovalForAll(_msgSender(), operator, approved);
785     }
786 
787     /**
788      * @dev See {IERC721-isApprovedForAll}.
789      */
790     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
791         return _operatorApprovals[owner][operator];
792     }
793 
794     /**
795      * @dev See {IERC721-transferFrom}.
796      */
797     function transferFrom(
798         address from,
799         address to,
800         uint256 tokenId
801     ) public virtual override {
802         //solhint-disable-next-line max-line-length
803         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
804 
805         _transfer(from, to, tokenId);
806     }
807 
808     /**
809      * @dev See {IERC721-safeTransferFrom}.
810      */
811     function safeTransferFrom(
812         address from,
813         address to,
814         uint256 tokenId
815     ) public virtual override {
816         safeTransferFrom(from, to, tokenId, "");
817     }
818 
819     /**
820      * @dev See {IERC721-safeTransferFrom}.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId,
826         bytes memory _data
827     ) public virtual override {
828         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
829         _safeTransfer(from, to, tokenId, _data);
830     }
831 
832     /**
833      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
834      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
835      *
836      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
837      *
838      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
839      * implement alternative mechanisms to perform token transfer, such as signature-based.
840      *
841      * Requirements:
842      *
843      * - `from` cannot be the zero address.
844      * - `to` cannot be the zero address.
845      * - `tokenId` token must exist and be owned by `from`.
846      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
847      *
848      * Emits a {Transfer} event.
849      */
850     function _safeTransfer(
851         address from,
852         address to,
853         uint256 tokenId,
854         bytes memory _data
855     ) internal virtual {
856         _transfer(from, to, tokenId);
857         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
858     }
859 
860     /**
861      * @dev Returns whether `tokenId` exists.
862      *
863      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
864      *
865      * Tokens start existing when they are minted (`_mint`),
866      * and stop existing when they are burned (`_burn`).
867      */
868     function _exists(uint256 tokenId) internal view virtual returns (bool) {
869         return _owners[tokenId] != address(0);
870     }
871 
872     /**
873      * @dev Returns whether `spender` is allowed to manage `tokenId`.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      */
879     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
880         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
881         address owner = ERC721.ownerOf(tokenId);
882         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
883     }
884 
885     /**
886      * @dev Safely mints `tokenId` and transfers it to `to`.
887      *
888      * Requirements:
889      *
890      * - `tokenId` must not exist.
891      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _safeMint(address to, uint256 tokenId) internal virtual {
896         _safeMint(to, tokenId, "");
897     }
898 
899     /**
900      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
901      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
902      */
903     function _safeMint(
904         address to,
905         uint256 tokenId,
906         bytes memory _data
907     ) internal virtual {
908         _mint(to, tokenId);
909         require(
910             _checkOnERC721Received(address(0), to, tokenId, _data),
911             "ERC721: transfer to non ERC721Receiver implementer"
912         );
913     }
914 
915     /**
916      * @dev Mints `tokenId` and transfers it to `to`.
917      *
918      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
919      *
920      * Requirements:
921      *
922      * - `tokenId` must not exist.
923      * - `to` cannot be the zero address.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _mint(address to, uint256 tokenId) internal virtual {
928         require(to != address(0), "ERC721: mint to the zero address");
929         require(!_exists(tokenId), "ERC721: token already minted");
930 
931         _beforeTokenTransfer(address(0), to, tokenId);
932 
933         _balances[to] += 1;
934         _owners[tokenId] = to;
935 
936         emit Transfer(address(0), to, tokenId);
937     }
938 
939     /**
940      * @dev Destroys `tokenId`.
941      * The approval is cleared when the token is burned.
942      *
943      * Requirements:
944      *
945      * - `tokenId` must exist.
946      *
947      * Emits a {Transfer} event.
948      */
949     function _burn(uint256 tokenId) internal virtual {
950         address owner = ERC721.ownerOf(tokenId);
951 
952         _beforeTokenTransfer(owner, address(0), tokenId);
953 
954         // Clear approvals
955         _approve(address(0), tokenId);
956 
957         _balances[owner] -= 1;
958         delete _owners[tokenId];
959 
960         emit Transfer(owner, address(0), tokenId);
961     }
962 
963     /**
964      * @dev Transfers `tokenId` from `from` to `to`.
965      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
966      *
967      * Requirements:
968      *
969      * - `to` cannot be the zero address.
970      * - `tokenId` token must be owned by `from`.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _transfer(
975         address from,
976         address to,
977         uint256 tokenId
978     ) internal virtual {
979         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
980         require(to != address(0), "ERC721: transfer to the zero address");
981 
982         _beforeTokenTransfer(from, to, tokenId);
983 
984         // Clear approvals from the previous owner
985         _approve(address(0), tokenId);
986 
987         _balances[from] -= 1;
988         _balances[to] += 1;
989         _owners[tokenId] = to;
990 
991         emit Transfer(from, to, tokenId);
992     }
993 
994     /**
995      * @dev Approve `to` to operate on `tokenId`
996      *
997      * Emits a {Approval} event.
998      */
999     function _approve(address to, uint256 tokenId) internal virtual {
1000         _tokenApprovals[tokenId] = to;
1001         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1002     }
1003 
1004     /**
1005      * @dev Approve `operator` to operate on all of `owner` tokens
1006      *
1007      * Emits a {ApprovalForAll} event.
1008      */
1009     function _setApprovalForAll(
1010         address owner,
1011         address operator,
1012         bool approved
1013     ) internal virtual {
1014         require(owner != operator, "ERC721: approve to caller");
1015         _operatorApprovals[owner][operator] = approved;
1016         emit ApprovalForAll(owner, operator, approved);
1017     }
1018 
1019     /**
1020      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1021      * The call is not executed if the target address is not a contract.
1022      *
1023      * @param from address representing the previous owner of the given token ID
1024      * @param to target address that will receive the tokens
1025      * @param tokenId uint256 ID of the token to be transferred
1026      * @param _data bytes optional data to send along with the call
1027      * @return bool whether the call correctly returned the expected magic value
1028      */
1029     function _checkOnERC721Received(
1030         address from,
1031         address to,
1032         uint256 tokenId,
1033         bytes memory _data
1034     ) private returns (bool) {
1035         if (to.isContract()) {
1036             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1037                 return retval == IERC721Receiver.onERC721Received.selector;
1038             } catch (bytes memory reason) {
1039                 if (reason.length == 0) {
1040                     revert("ERC721: transfer to non ERC721Receiver implementer");
1041                 } else {
1042                     assembly {
1043                         revert(add(32, reason), mload(reason))
1044                     }
1045                 }
1046             }
1047         } else {
1048             return true;
1049         }
1050     }
1051 
1052     /**
1053      * @dev Hook that is called before any token transfer. This includes minting
1054      * and burning.
1055      *
1056      * Calling conditions:
1057      *
1058      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1059      * transferred to `to`.
1060      * - When `from` is zero, `tokenId` will be minted for `to`.
1061      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1062      * - `from` and `to` are never both zero.
1063      *
1064      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1065      */
1066     function _beforeTokenTransfer(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) internal virtual {}
1071 }
1072 
1073 // File: @openzeppelin/contracts/access/Ownable.sol
1074 
1075 
1076 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1077 
1078 pragma solidity ^0.8.0;
1079 
1080 
1081 /**
1082  * @dev Contract module which provides a basic access control mechanism, where
1083  * there is an account (an owner) that can be granted exclusive access to
1084  * specific functions.
1085  *
1086  * By default, the owner account will be the one that deploys the contract. This
1087  * can later be changed with {transferOwnership}.
1088  *
1089  * This module is used through inheritance. It will make available the modifier
1090  * `onlyOwner`, which can be applied to your functions to restrict their use to
1091  * the owner.
1092  */
1093 abstract contract Ownable is Context {
1094     address private _owner;
1095 
1096     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1097 
1098     /**
1099      * @dev Initializes the contract setting the deployer as the initial owner.
1100      */
1101     constructor() {
1102         _transferOwnership(_msgSender());
1103     }
1104 
1105     /**
1106      * @dev Returns the address of the current owner.
1107      */
1108     function owner() public view virtual returns (address) {
1109         return _owner;
1110     }
1111 
1112     /**
1113      * @dev Throws if called by any account other than the owner.
1114      */
1115     modifier onlyOwner() {
1116         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1117         _;
1118     }
1119 
1120     /**
1121      * @dev Leaves the contract without owner. It will not be possible to call
1122      * `onlyOwner` functions anymore. Can only be called by the current owner.
1123      *
1124      * NOTE: Renouncing ownership will leave the contract without an owner,
1125      * thereby removing any functionality that is only available to the owner.
1126      */
1127     function renounceOwnership() public virtual onlyOwner {
1128         _transferOwnership(address(0));
1129     }
1130 
1131     /**
1132      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1133      * Can only be called by the current owner.
1134      */
1135     function transferOwnership(address newOwner) public virtual onlyOwner {
1136         require(newOwner != address(0), "Ownable: new owner is the zero address");
1137         _transferOwnership(newOwner);
1138     }
1139 
1140     /**
1141      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1142      * Internal function without access restriction.
1143      */
1144     function _transferOwnership(address newOwner) internal virtual {
1145         address oldOwner = _owner;
1146         _owner = newOwner;
1147         emit OwnershipTransferred(oldOwner, newOwner);
1148     }
1149 }
1150 
1151 // File: CheddarVerse2/Trustable.sol
1152 
1153 pragma solidity ^0.8.0;
1154 
1155 
1156 
1157 abstract contract Trustable is Ownable {
1158     mapping(address=>bool) public _isTrusted;
1159     modifier onlyTrusted {
1160         require(_isTrusted[msg.sender] || msg.sender == owner(), "not trusted");
1161         _;
1162     }
1163 
1164     function addTrusted(address user) public onlyOwner {
1165         _isTrusted[user] = true;
1166     }
1167 
1168     function removeTrusted(address user) public onlyOwner {
1169         _isTrusted[user] = false;
1170     }
1171 }
1172 // File: CheddarVerse2/CheddarverseERC721.sol
1173 
1174 
1175 
1176 pragma solidity ^0.8.0;
1177 
1178 
1179 
1180 
1181 
1182 
1183 contract CheddarverseERC721 is ERC721, Ownable, ReentrancyGuard, Trustable {
1184   using Address for address;
1185   using Strings for uint256;
1186 
1187   uint256 internal _tokenIds;
1188   uint256 internal _reserved;
1189   uint256 internal _presaleSupply;
1190   uint256 internal _tokenOffset;
1191   string internal _baseTokenURI;
1192 
1193   uint256 constant public MAX_MINT = 3;
1194   uint256 constant public PRESALE_MAX_MINT = 1;
1195   uint256 constant public AIRDROP_MAX_MINT = 1;
1196   uint256 constant public NO_MINT = 0;
1197   uint256 constant public MINT_PRICE = 0.082 ether;
1198   uint256 constant public SECOOND_PRESALE_MINT_PRICE = 0.052 ether;
1199   uint256 constant public PRESALE_MINT_PRICE = 0.042 ether;
1200   uint256 constant public MAX_SUPPLY = 5001;
1201   uint256 constant public MAX_RESERVED = 250;
1202   uint256 constant public MAX_PRESALE = 500;
1203 
1204   bool public _revealed = false;
1205   bool public presaleActive;
1206   bool public SecondPresaleActive;
1207   bool public RemainSaleActive;
1208   bool public AirdropActive;
1209   bool public saleActive;
1210   string public metadataURI;
1211   string public notRevealedUri;
1212   string public baseExtension = ".json";
1213 
1214   mapping(uint256 => string) private _tokenURIs;
1215   mapping(address => uint) public airdropMints;
1216   mapping(address => uint) public presaleMints;
1217   mapping(address => uint) public mints;
1218   mapping(address=>bool) public whitelist;
1219   mapping(address=>bool) public secondwhitelist;
1220   mapping(address=>bool) public remainwhitelist;
1221   mapping(address=>bool) public airdroplist;
1222 
1223   modifier onlyWhitelisted() {
1224         require(contains(msg.sender));
1225         _;
1226   }
1227 
1228   modifier onlySecondWhitelisted() {
1229         require(containsSecond(msg.sender));
1230         _;
1231   }
1232 
1233   modifier onlyRemainWhitelisted() {
1234         require(containsRemain(msg.sender));
1235         _;
1236   }
1237 
1238   modifier onlyAirdrop() {
1239         require(containsAirdrop(msg.sender));
1240         _;
1241   }
1242 
1243   constructor(
1244     string memory baseTokenURI,
1245     string memory initNotRevealedUri
1246   )
1247     ERC721("CheddarVerse", "Genesis Mimi")
1248   {
1249     _baseTokenURI = baseTokenURI;
1250     setNotRevealedURI(initNotRevealedUri);
1251   }
1252 
1253 
1254 
1255   function setWallets(address[] memory _wallets) public onlyTrusted {
1256         for (uint i=0; i<_wallets.length; i++) {
1257           address wallet = _wallets[i];
1258           whitelist[wallet] = true;
1259           remainwhitelist[wallet] = true;
1260         }
1261     }
1262   function setSecondWallets(address[] memory _secondwallets) public onlyTrusted {
1263         for (uint i=0; i<_secondwallets.length; i++) {
1264           address secondwallet = _secondwallets[i];
1265           secondwhitelist[secondwallet] = true;
1266           remainwhitelist[secondwallet] = true;
1267         }
1268     }
1269 
1270   function setRemainWallets(address[] memory _remainwallets) public onlyTrusted {
1271         for (uint i=0; i<_remainwallets.length; i++) {
1272           address remainwallet = _remainwallets[i];
1273           remainwhitelist[remainwallet] = true;
1274         }
1275     }
1276   function setAirdrops(address[] memory _airdrops) public onlyTrusted {
1277         for (uint i=0; i<_airdrops.length; i++) {
1278           address airdrop = _airdrops[i];
1279           airdroplist[airdrop] = true;
1280         }
1281     }
1282 
1283   function totalSupply() external view returns (uint256) {
1284     return _tokenIds;
1285   }
1286 
1287   function tokenOffset() public view returns (uint256) {
1288     require(_tokenOffset != 0, "Offset has not been generated");
1289 
1290     return _tokenOffset;
1291   }
1292 
1293   function _baseURI() internal view virtual override returns (string memory) {
1294     return _baseTokenURI;
1295   }
1296 
1297   function contains(address _wallet) public returns (bool) {
1298         return whitelist[_wallet];
1299   }
1300 
1301   function containsSecond(address _secondwallet) public returns (bool) {
1302         return secondwhitelist[_secondwallet];
1303   }
1304 
1305   function containsRemain(address _remainwallet) public returns (bool) {
1306         return remainwhitelist[_remainwallet];
1307   }
1308 
1309   function containsAirdrop(address _airdrops) public returns (bool) {
1310         return airdroplist[_airdrops];
1311   }
1312 
1313   function setBaseTokenURI(string memory URI) public onlyOwner {
1314     _baseTokenURI = URI;
1315   }
1316 
1317   function setMetadataURI(string memory URI) public onlyOwner {
1318     metadataURI = URI;
1319   }
1320 
1321   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1322         notRevealedUri = _notRevealedURI;
1323   }
1324 
1325   function flipReveal() public onlyOwner {
1326         _revealed = !_revealed;
1327   }
1328 
1329   function flipPresaleActive() public onlyOwner {
1330     presaleActive = !presaleActive;
1331   }
1332 
1333   function flipSecondPresaleActive() public onlyOwner {
1334     SecondPresaleActive = !SecondPresaleActive;
1335   }
1336   
1337   function flipRemainSaleActive() public onlyOwner {
1338     RemainSaleActive = !RemainSaleActive;
1339   }
1340 
1341   function flipAirdropActive() public onlyOwner {
1342     AirdropActive = !AirdropActive;
1343   }
1344 
1345   function flipSaleActive() public onlyOwner {
1346     saleActive = !saleActive;
1347   }
1348 
1349   function reserve(uint256 amount, address to) public onlyOwner {
1350     require(_reserved + amount <= MAX_RESERVED, "Exceeds maximum number of reserved tokens");
1351 
1352     _mintAmount(amount, to);
1353     _reserved += amount;
1354   }
1355 
1356   function presaleMint(uint256 amount)
1357     public
1358     payable
1359     nonReentrant
1360     onlyWhitelisted
1361   {
1362     require(presaleActive,                                         "Presale has not started");
1363     require(msg.value == PRESALE_MINT_PRICE * amount,                      "Invalid Ether amount sent");
1364     require(presaleMints[msg.sender] + amount <= PRESALE_MAX_MINT, "Exceeds remaining presale balance");
1365     require(_presaleSupply + amount <= MAX_PRESALE, "Exceeds maximum number of Presale supply");
1366 
1367     _mintAmount(amount, msg.sender);
1368 
1369     presaleMints[msg.sender] += amount;
1370     _presaleSupply += amount;
1371   }
1372 
1373   function SecondPresaleMint(uint256 amount)
1374     public
1375     payable
1376     nonReentrant
1377     onlySecondWhitelisted
1378   {
1379     require(SecondPresaleActive,                                         "Presale has not started");
1380     require(msg.value == SECOOND_PRESALE_MINT_PRICE * amount,      "Invalid Ether amount sent");
1381     require(presaleMints[msg.sender] + amount <= PRESALE_MAX_MINT, "Exceeds remaining presale balance");
1382     require(_presaleSupply + amount <= MAX_PRESALE, "Exceeds maximum number of Second-Presale supply");
1383 
1384     _mintAmount(amount, msg.sender);
1385 
1386     presaleMints[msg.sender] += amount;
1387     _presaleSupply += amount;
1388   }
1389 
1390   function RemainSaleMint(uint256 amount)
1391     public
1392     payable
1393     nonReentrant
1394     onlyRemainWhitelisted
1395   {
1396     require(RemainSaleActive,                      "Presale has not started");
1397     require(msg.value == MINT_PRICE * amount,      "Invalid Ether amount sent");
1398     require(presaleMints[msg.sender] == NO_MINT, "Exceeds remaining presale balance");
1399     require(mints[msg.sender] + amount <= MAX_MINT, "Exceeds the maximum amount to mint at once");
1400 
1401     _mintAmount(amount, msg.sender);
1402     mints[msg.sender] += amount;
1403   }
1404 
1405   function AirdropMint(uint256 amount)
1406     public
1407     nonReentrant
1408     onlyAirdrop
1409   {
1410     require(AirdropActive,                                         "Airdrop has not started");
1411     require(airdropMints[msg.sender] + amount <= AIRDROP_MAX_MINT, "Exceeds remaining presale balance");
1412 
1413     _mintAmount(amount, msg.sender);
1414     airdropMints[msg.sender] += amount;
1415     mints[msg.sender] += amount;
1416   }
1417 
1418   function mint(uint256 amount) public payable nonReentrant {
1419     require(saleActive,                       "Public sale has not started");
1420     require(msg.value == MINT_PRICE * amount, "Invalid Ether amount sent");
1421     require(mints[msg.sender] + amount <= MAX_MINT,               "Exceeds the maximum amount to mint at once");
1422 
1423     _mintAmount(amount, msg.sender);
1424     mints[msg.sender] += amount;
1425   }
1426 
1427   function _mintAmount(uint256 amount, address to) internal {
1428     require(_tokenIds + amount < MAX_SUPPLY,  "Exceeds maximum number of tokens");
1429 
1430     for (uint256 i = 0; i < amount; i++) {
1431       _safeMint(to, _tokenIds);
1432       _tokenIds += 1;
1433     }
1434   }
1435 
1436   function withdraw() nonReentrant public {
1437     require(msg.sender == owner(), "Caller cannot withdraw");
1438 
1439     Address.sendValue(payable(owner()), address(this).balance);
1440   }
1441 
1442   function tokenURI(uint256 tokenId)
1443         public
1444         view
1445         virtual
1446         override
1447         returns (string memory)
1448     {
1449         require(
1450             _exists(tokenId),
1451             "ERC721Metadata: URI query for nonexistent token"
1452         );
1453 
1454         if (_revealed == false) {
1455             return notRevealedUri;
1456         }
1457 
1458         string memory _tokenURI = _tokenURIs[tokenId];
1459         string memory base = _baseURI();
1460 
1461         // If there is no base URI, return the token URI.
1462         if (bytes(base).length == 0) {
1463             return _tokenURI;
1464         }
1465         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1466         if (bytes(_tokenURI).length > 0) {
1467             return string(abi.encodePacked(base, _tokenURI));
1468         }
1469         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1470         return
1471             string(abi.encodePacked(base, tokenId.toString(), baseExtension));
1472     }
1473 
1474 }
1475 // File: CheddarVerse2/Cheddarverse.sol
1476 
1477 
1478 
1479 pragma solidity ^0.8.0;
1480 
1481 
1482 interface ICheesy {
1483   function update(address from, address to) external;
1484   function burn(address from, uint256 amount) external;
1485 }
1486 
1487 contract Cheddarverse is CheddarverseERC721 {
1488   using Address for address;
1489 
1490   struct CheesyInfo {
1491     string name;
1492     string description;
1493   }
1494 
1495   event UpdateName(uint256 indexed tokenId, string name);
1496   event UpdateDescription(uint256 indexed tokenId, string description);
1497 
1498   uint256 constant public UPDATE_NAME_PRICE = 100 ether;
1499   uint256 constant public UPDATE_DESCRIPTION_PRICE = 100 ether;
1500 
1501   ICheesy public Cheesy;
1502   mapping(uint256 => CheesyInfo) public cheesyInfo;
1503 
1504   constructor(
1505     string memory baseTokenURI,
1506     string memory initNotRevealedUri
1507   )
1508     CheddarverseERC721(
1509       baseTokenURI,
1510       initNotRevealedUri
1511     )
1512   {}
1513 
1514   modifier onlyTokenOwner(uint256 tokenId) {
1515     require(ownerOf(tokenId) == msg.sender, "Sender is not the token owner");
1516     _;
1517   }
1518 
1519   function setCheesyAddress(address cheesy) public onlyOwner {
1520     Cheesy = ICheesy(cheesy);
1521   }
1522 
1523   function updateName(uint256 tokenId, string calldata name)
1524     public
1525     onlyTokenOwner(tokenId)
1526   {
1527     require(address(Cheesy) != address(0), "No token contract set");
1528 
1529     bytes memory n = bytes(name);
1530     require(n.length > 0 && n.length < 25, "Invalid name length");
1531     require(
1532       sha256(n) != sha256(bytes(cheesyInfo[tokenId].name)),
1533       "New name is same as current name"
1534     );
1535 
1536     Cheesy.burn(msg.sender, UPDATE_NAME_PRICE);
1537     cheesyInfo[tokenId].name = name;
1538     emit UpdateName(tokenId, name);
1539   }
1540 
1541   function updateDescription(uint256 tokenId, string calldata description)
1542     public
1543     onlyTokenOwner(tokenId)
1544   {
1545     require(address(Cheesy) != address(0), "No token contract set");
1546 
1547     bytes memory d = bytes(description);
1548     require(d.length > 0 && d.length < 280, "Invalid description length");
1549     require(
1550       sha256(bytes(d)) != sha256(bytes(cheesyInfo[tokenId].description)),
1551       "New description is same as current description"
1552     );
1553 
1554     Cheesy.burn(msg.sender, UPDATE_DESCRIPTION_PRICE);
1555     cheesyInfo[tokenId].description = description;
1556     emit UpdateDescription(tokenId, description);
1557   }
1558 
1559   function transferFrom(address from, address to, uint256 tokenId)
1560     public
1561     override
1562     nonReentrant
1563   {
1564     require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1565 
1566     if (address(Cheesy) != address(0)) {
1567       Cheesy.update(from, to);
1568     }
1569 
1570     ERC721.transferFrom(from, to, tokenId);
1571   }
1572 
1573   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1574     public
1575     override
1576     nonReentrant
1577   {
1578     require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1579 
1580     if (address(Cheesy) != address(0)) {
1581       Cheesy.update(from, to);
1582     }
1583 
1584     ERC721.safeTransferFrom(from, to, tokenId, data);
1585   }
1586 }