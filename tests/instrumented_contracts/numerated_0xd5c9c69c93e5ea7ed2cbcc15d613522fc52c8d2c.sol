1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;        }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Context.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 // File: @openzeppelin/contracts/access/Ownable.sol
95 
96 
97 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     /**
127      * @dev Returns the address of the current owner.
128      */
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
138         _;
139     }
140 
141     /**
142      * @dev Leaves the contract without owner. It will not be possible to call
143      * `onlyOwner` functions anymore. Can only be called by the current owner.
144      *
145      * NOTE: Renouncing ownership will leave the contract without an owner,
146      * thereby removing any functionality that is only available to the owner.
147      */
148     function renounceOwnership() public virtual onlyOwner {
149         _transferOwnership(address(0));
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         _transferOwnership(newOwner);
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Internal function without access restriction.
164      */
165     function _transferOwnership(address newOwner) internal virtual {
166         address oldOwner = _owner;
167         _owner = newOwner;
168         emit OwnershipTransferred(oldOwner, newOwner);
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/Address.sol
173 
174 
175 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev Collection of functions related to the address type
181  */
182 library Address {
183     /**
184      * @dev Returns true if `account` is a contract.
185      *
186      * [IMPORTANT]
187      * ====
188      * It is unsafe to assume that an address for which this function returns
189      * false is an externally-owned account (EOA) and not a contract.
190      *
191      * Among others, `isContract` will return false for the following
192      * types of addresses:
193      *
194      *  - an externally-owned account
195      *  - a contract in construction
196      *  - an address where a contract will be created
197      *  - an address where a contract lived, but was destroyed
198      * ====
199      */
200     function isContract(address account) internal view returns (bool) {
201         // This method relies on extcodesize, which returns 0 for contracts in
202         // construction, since the code is only stored at the end of the
203         // constructor execution.
204 
205         uint256 size;
206         assembly {
207             size := extcodesize(account)
208         }
209         return size > 0;
210     }
211 
212     /**
213      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
214      * `recipient`, forwarding all available gas and reverting on errors.
215      *
216      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
217      * of certain opcodes, possibly making contracts go over the 2300 gas limit
218      * imposed by `transfer`, making them unable to receive funds via
219      * `transfer`. {sendValue} removes this limitation.
220      *
221      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
222      *
223      * IMPORTANT: because control is transferred to `recipient`, care must be
224      * taken to not create reentrancy vulnerabilities. Consider using
225      * {ReentrancyGuard} or the
226      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
227      */
228     function sendValue(address payable recipient, uint256 amount) internal {
229         require(address(this).balance >= amount, "Address: insufficient balance");
230 
231         (bool success, ) = recipient.call{value: amount}("");
232         require(success, "Address: unable to send value, recipient may have reverted");
233     }
234 
235     /**
236      * @dev Performs a Solidity function call using a low level `call`. A
237      * plain `call` is an unsafe replacement for a function call: use this
238      * function instead.
239      *
240      * If `target` reverts with a revert reason, it is bubbled up by this
241      * function (like regular Solidity function calls).
242      *
243      * Returns the raw returned data. To convert to the expected return value,
244      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
245      *
246      * Requirements:
247      *
248      * - `target` must be a contract.
249      * - calling `target` with `data` must not revert.
250      *
251      * _Available since v3.1._
252      */
253     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionCall(target, data, "Address: low-level call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
259      * `errorMessage` as a fallback revert reason when `target` reverts.
260      *
261      * _Available since v3.1._
262      */
263     function functionCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         return functionCallWithValue(target, data, 0, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but also transferring `value` wei to `target`.
274      *
275      * Requirements:
276      *
277      * - the calling contract must have an ETH balance of at least `value`.
278      * - the called Solidity function must be `payable`.
279      *
280      * _Available since v3.1._
281      */
282     function functionCallWithValue(
283         address target,
284         bytes memory data,
285         uint256 value
286     ) internal returns (bytes memory) {
287         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
292      * with `errorMessage` as a fallback revert reason when `target` reverts.
293      *
294      * _Available since v3.1._
295      */
296     function functionCallWithValue(
297         address target,
298         bytes memory data,
299         uint256 value,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         require(address(this).balance >= value, "Address: insufficient balance for call");
303         require(isContract(target), "Address: call to non-contract");
304 
305         (bool success, bytes memory returndata) = target.call{value: value}(data);
306         return verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but performing a static call.
312      *
313      * _Available since v3.3._
314      */
315     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
316         return functionStaticCall(target, data, "Address: low-level static call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
321      * but performing a static call.
322      *
323      * _Available since v3.3._
324      */
325     function functionStaticCall(
326         address target,
327         bytes memory data,
328         string memory errorMessage
329     ) internal view returns (bytes memory) {
330         require(isContract(target), "Address: static call to non-contract");
331 
332         (bool success, bytes memory returndata) = target.staticcall(data);
333         return verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a delegate call.
339      *
340      * _Available since v3.4._
341      */
342     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
343         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a delegate call.
349      *
350      * _Available since v3.4._
351      */
352     function functionDelegateCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         require(isContract(target), "Address: delegate call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.delegatecall(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
365      * revert reason using the provided one.
366      *
367      * _Available since v4.3._
368      */
369     function verifyCallResult(
370         bool success,
371         bytes memory returndata,
372         string memory errorMessage
373     ) internal pure returns (bytes memory) {
374         if (success) {
375             return returndata;
376         } else {
377             // Look for revert reason and bubble it up if present
378             if (returndata.length > 0) {
379                 // The easiest way to bubble the revert reason is using memory via assembly
380 
381                 assembly {
382                     let returndata_size := mload(returndata)
383                     revert(add(32, returndata), returndata_size)
384                 }
385             } else {
386                 revert(errorMessage);
387             }
388         }
389     }
390 }
391 
392 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
393 
394 
395 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 /**
400  * @title ERC721 token receiver interface
401  * @dev Interface for any contract that wants to support safeTransfers
402  * from ERC721 asset contracts.
403  */
404 interface IERC721Receiver {
405     /**
406      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
407      * by `operator` from `from`, this function is called.
408      *
409      * It must return its Solidity selector to confirm the token transfer.
410      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
411      *
412      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
413      */
414     function onERC721Received(
415         address operator,
416         address from,
417         uint256 tokenId,
418         bytes calldata data
419     ) external returns (bytes4);
420 }
421 
422 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
423 
424 
425 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @dev Interface of the ERC165 standard, as defined in the
431  * https://eips.ethereum.org/EIPS/eip-165[EIP].
432  *
433  * Implementers can declare support of contract interfaces, which can then be
434  * queried by others ({ERC165Checker}).
435  *
436  * For an implementation, see {ERC165}.
437  */
438 interface IERC165 {
439     /**
440      * @dev Returns true if this contract implements the interface defined by
441      * `interfaceId`. See the corresponding
442      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
443      * to learn more about how these ids are created.
444      *
445      * This function call must use less than 30 000 gas.
446      */
447     function supportsInterface(bytes4 interfaceId) external view returns (bool);
448 }
449 
450 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
451 
452 
453 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 
458 /**
459  * @dev Implementation of the {IERC165} interface.
460  *
461  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
462  * for the additional interface id that will be supported. For example:
463  *
464  * ```solidity
465  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
466  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
467  * }
468  * ```
469  *
470  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
471  */
472 abstract contract ERC165 is IERC165 {
473     /**
474      * @dev See {IERC165-supportsInterface}.
475      */
476     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
477         return interfaceId == type(IERC165).interfaceId;
478     }
479 }
480 
481 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
482 
483 
484 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 
489 /**
490  * @dev Required interface of an ERC721 compliant contract.
491  */
492 interface IERC721 is IERC165 {
493     /**
494      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
495      */
496     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
497 
498     /**
499      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
500      */
501     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
502 
503     /**
504      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
505      */
506     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
507 
508     /**
509      * @dev Returns the number of tokens in ``owner``'s account.
510      */
511     function balanceOf(address owner) external view returns (uint256 balance);
512 
513     /**
514      * @dev Returns the owner of the `tokenId` token.
515      *
516      * Requirements:
517      *
518      * - `tokenId` must exist.
519      */
520     function ownerOf(uint256 tokenId) external view returns (address owner);
521 
522     /**
523      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
524      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
525      *
526      * Requirements:
527      *
528      * - `from` cannot be the zero address.
529      * - `to` cannot be the zero address.
530      * - `tokenId` token must exist and be owned by `from`.
531      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
532      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
533      *
534      * Emits a {Transfer} event.
535      */
536     function safeTransferFrom(
537         address from,
538         address to,
539         uint256 tokenId
540     ) external;
541 
542     /**
543      * @dev Transfers `tokenId` token from `from` to `to`.
544      *
545      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
546      *
547      * Requirements:
548      *
549      * - `from` cannot be the zero address.
550      * - `to` cannot be the zero address.
551      * - `tokenId` token must be owned by `from`.
552      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
553      *
554      * Emits a {Transfer} event.
555      */
556     function transferFrom(
557         address from,
558         address to,
559         uint256 tokenId
560     ) external;
561 
562     /**
563      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
564      * The approval is cleared when the token is transferred.
565      *
566      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
567      *
568      * Requirements:
569      *
570      * - The caller must own the token or be an approved operator.
571      * - `tokenId` must exist.
572      *
573      * Emits an {Approval} event.
574      */
575     function approve(address to, uint256 tokenId) external;
576 
577     /**
578      * @dev Returns the account approved for `tokenId` token.
579      *
580      * Requirements:
581      *
582      * - `tokenId` must exist.
583      */
584     function getApproved(uint256 tokenId) external view returns (address operator);
585 
586     /**
587      * @dev Approve or remove `operator` as an operator for the caller.
588      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
589      *
590      * Requirements:
591      *
592      * - The `operator` cannot be the caller.
593      *
594      * Emits an {ApprovalForAll} event.
595      */
596     function setApprovalForAll(address operator, bool _approved) external;
597 
598     /**
599      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
600      *
601      * See {setApprovalForAll}
602      */
603     function isApprovedForAll(address owner, address operator) external view returns (bool);
604 
605     /**
606      * @dev Safely transfers `tokenId` token from `from` to `to`.
607      *
608      * Requirements:
609      *
610      * - `from` cannot be the zero address.
611      * - `to` cannot be the zero address.
612      * - `tokenId` token must exist and be owned by `from`.
613      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
614      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
615      *
616      * Emits a {Transfer} event.
617      */
618     function safeTransferFrom(
619         address from,
620         address to,
621         uint256 tokenId,
622         bytes calldata data
623     ) external;
624 }
625 
626 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
627 
628 
629 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 
634 /**
635  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
636  * @dev See https://eips.ethereum.org/EIPS/eip-721
637  */
638 interface IERC721Metadata is IERC721 {
639     /**
640      * @dev Returns the token collection name.
641      */
642     function name() external view returns (string memory);
643 
644     /**
645      * @dev Returns the token collection symbol.
646      */
647     function symbol() external view returns (string memory);
648 
649     /**
650      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
651      */
652     function tokenURI(uint256 tokenId) external view returns (string memory);
653 }
654 
655 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
656 
657 
658 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
659 
660 pragma solidity ^0.8.0;
661 
662 
663 
664 
665 
666 
667 
668 
669 /**
670  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
671  * the Metadata extension, but not including the Enumerable extension, which is available separately as
672  * {ERC721Enumerable}.
673  */
674 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
675     using Address for address;
676     using Strings for uint256;
677 
678     // Token name
679     string private _name;
680 
681     // Token symbol
682     string private _symbol;
683 
684     // Mapping from token ID to owner address
685     mapping(uint256 => address) private _owners;
686 
687     // Mapping owner address to token count
688     mapping(address => uint256) private _balances;
689 
690     // Mapping from token ID to approved address
691     mapping(uint256 => address) private _tokenApprovals;
692 
693     // Mapping from owner to operator approvals
694     mapping(address => mapping(address => bool)) private _operatorApprovals;
695 
696     /**
697      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
698      */
699     constructor(string memory name_, string memory symbol_) {
700         _name = name_;
701         _symbol = symbol_;
702     }
703 
704     /**
705      * @dev See {IERC165-supportsInterface}.
706      */
707     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
708         return
709             interfaceId == type(IERC721).interfaceId ||
710             interfaceId == type(IERC721Metadata).interfaceId ||
711             super.supportsInterface(interfaceId);
712     }
713 
714     /**
715      * @dev See {IERC721-balanceOf}.
716      */
717     function balanceOf(address owner) public view virtual override returns (uint256) {
718         require(owner != address(0), "ERC721: balance query for the zero address");
719         return _balances[owner];
720     }
721 
722     /**
723      * @dev See {IERC721-ownerOf}.
724      */
725     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
726         address owner = _owners[tokenId];
727         require(owner != address(0), "ERC721: owner query for nonexistent token");
728         return owner;
729     }
730 
731     /**
732      * @dev See {IERC721Metadata-name}.
733      */
734     function name() public view virtual override returns (string memory) {
735         return _name;
736     }
737 
738     /**
739      * @dev See {IERC721Metadata-symbol}.
740      */
741     function symbol() public view virtual override returns (string memory) {
742         return _symbol;
743     }
744 
745     /**
746      * @dev See {IERC721Metadata-tokenURI}.
747      */
748     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
749         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
750 
751         string memory baseURI = _baseURI();
752         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
753     }
754 
755     /**
756      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
757      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
758      * by default, can be overriden in child contracts.
759      */
760     function _baseURI() internal view virtual returns (string memory) {
761         return "";
762     }
763 
764     /**
765      * @dev See {IERC721-approve}.
766      */
767     function approve(address to, uint256 tokenId) public virtual override {
768         address owner = ERC721.ownerOf(tokenId);
769         require(to != owner, "ERC721: approval to current owner");
770 
771         require(
772             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
773             "ERC721: approve caller is not owner nor approved for all"
774         );
775 
776         _approve(to, tokenId);
777     }
778 
779     /**
780      * @dev See {IERC721-getApproved}.
781      */
782     function getApproved(uint256 tokenId) public view virtual override returns (address) {
783         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
784 
785         return _tokenApprovals[tokenId];
786     }
787 
788     /**
789      * @dev See {IERC721-setApprovalForAll}.
790      */
791     function setApprovalForAll(address operator, bool approved) public virtual override {
792         _setApprovalForAll(_msgSender(), operator, approved);
793     }
794 
795     /**
796      * @dev See {IERC721-isApprovedForAll}.
797      */
798     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
799         return _operatorApprovals[owner][operator];
800     }
801 
802     /**
803      * @dev See {IERC721-transferFrom}.
804      */
805     function transferFrom(
806         address from,
807         address to,
808         uint256 tokenId
809     ) public virtual override {
810         //solhint-disable-next-line max-line-length
811         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
812 
813         _transfer(from, to, tokenId);
814     }
815 
816     /**
817      * @dev See {IERC721-safeTransferFrom}.
818      */
819     function safeTransferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) public virtual override {
824         safeTransferFrom(from, to, tokenId, "");
825     }
826 
827     /**
828      * @dev See {IERC721-safeTransferFrom}.
829      */
830     function safeTransferFrom(
831         address from,
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) public virtual override {
836         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
837         _safeTransfer(from, to, tokenId, _data);
838     }
839 
840     /**
841      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
842      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
843      *
844      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
845      *
846      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
847      * implement alternative mechanisms to perform token transfer, such as signature-based.
848      *
849      * Requirements:
850      *
851      * - `from` cannot be the zero address.
852      * - `to` cannot be the zero address.
853      * - `tokenId` token must exist and be owned by `from`.
854      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _safeTransfer(
859         address from,
860         address to,
861         uint256 tokenId,
862         bytes memory _data
863     ) internal virtual {
864         _transfer(from, to, tokenId);
865         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
866     }
867 
868     /**
869      * @dev Returns whether `tokenId` exists.
870      *
871      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
872      *
873      * Tokens start existing when they are minted (`_mint`),
874      * and stop existing when they are burned (`_burn`).
875      */
876     function _exists(uint256 tokenId) internal view virtual returns (bool) {
877         return _owners[tokenId] != address(0);
878     }
879 
880     /**
881      * @dev Returns whether `spender` is allowed to manage `tokenId`.
882      *
883      * Requirements:
884      *
885      * - `tokenId` must exist.
886      */
887     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
888         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
889         address owner = ERC721.ownerOf(tokenId);
890         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
891     }
892 
893     /**
894      * @dev Safely mints `tokenId` and transfers it to `to`.
895      *
896      * Requirements:
897      *
898      * - `tokenId` must not exist.
899      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _safeMint(address to, uint256 tokenId) internal virtual {
904         _safeMint(to, tokenId, "");
905     }
906 
907     /**
908      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
909      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
910      */
911     function _safeMint(
912         address to,
913         uint256 tokenId,
914         bytes memory _data
915     ) internal virtual {
916         _mint(to, tokenId);
917         require(
918             _checkOnERC721Received(address(0), to, tokenId, _data),
919             "ERC721: transfer to non ERC721Receiver implementer"
920         );
921     }
922 
923     /**
924      * @dev Mints `tokenId` and transfers it to `to`.
925      *
926      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
927      *
928      * Requirements:
929      *
930      * - `tokenId` must not exist.
931      * - `to` cannot be the zero address.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _mint(address to, uint256 tokenId) internal virtual {
936         require(to != address(0), "ERC721: mint to the zero address");
937         require(!_exists(tokenId), "ERC721: token already minted");
938 
939         _beforeTokenTransfer(address(0), to, tokenId);
940 
941         _balances[to] += 1;
942         _owners[tokenId] = to;
943 
944         emit Transfer(address(0), to, tokenId);
945     }
946 
947     /**
948      * @dev Destroys `tokenId`.
949      * The approval is cleared when the token is burned.
950      *
951      * Requirements:
952      *
953      * - `tokenId` must exist.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _burn(uint256 tokenId) internal virtual {
958         address owner = ERC721.ownerOf(tokenId);
959 
960         _beforeTokenTransfer(owner, address(0), tokenId);
961 
962         // Clear approvals
963         _approve(address(0), tokenId);
964 
965         _balances[owner] -= 1;
966         delete _owners[tokenId];
967 
968         emit Transfer(owner, address(0), tokenId);
969     }
970 
971     /**
972      * @dev Transfers `tokenId` from `from` to `to`.
973      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
974      *
975      * Requirements:
976      *
977      * - `to` cannot be the zero address.
978      * - `tokenId` token must be owned by `from`.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _transfer(
983         address from,
984         address to,
985         uint256 tokenId
986     ) internal virtual {
987         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
988         require(to != address(0), "ERC721: transfer to the zero address");
989 
990         _beforeTokenTransfer(from, to, tokenId);
991 
992         // Clear approvals from the previous owner
993         _approve(address(0), tokenId);
994 
995         _balances[from] -= 1;
996         _balances[to] += 1;
997         _owners[tokenId] = to;
998 
999         emit Transfer(from, to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev Approve `to` to operate on `tokenId`
1004      *
1005      * Emits a {Approval} event.
1006      */
1007     function _approve(address to, uint256 tokenId) internal virtual {
1008         _tokenApprovals[tokenId] = to;
1009         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev Approve `operator` to operate on all of `owner` tokens
1014      *
1015      * Emits a {ApprovalForAll} event.
1016      */
1017     function _setApprovalForAll(
1018         address owner,
1019         address operator,
1020         bool approved
1021     ) internal virtual {
1022         require(owner != operator, "ERC721: approve to caller");
1023         _operatorApprovals[owner][operator] = approved;
1024         emit ApprovalForAll(owner, operator, approved);
1025     }
1026 
1027     /**
1028      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1029      * The call is not executed if the target address is not a contract.
1030      *
1031      * @param from address representing the previous owner of the given token ID
1032      * @param to target address that will receive the tokens
1033      * @param tokenId uint256 ID of the token to be transferred
1034      * @param _data bytes optional data to send along with the call
1035      * @return bool whether the call correctly returned the expected magic value
1036      */
1037     function _checkOnERC721Received(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) private returns (bool) {
1043         if (to.isContract()) {
1044             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1045                 return retval == IERC721Receiver.onERC721Received.selector;
1046             } catch (bytes memory reason) {
1047                 if (reason.length == 0) {
1048                     revert("ERC721: transfer to non ERC721Receiver implementer");
1049                 } else {
1050                     assembly {
1051                         revert(add(32, reason), mload(reason))
1052                     }
1053                 }
1054             }
1055         } else {
1056             return true;
1057         }
1058     }
1059 
1060     /**
1061      * @dev Hook that is called before any token transfer. This includes minting
1062      * and burning.
1063      *
1064      * Calling conditions:
1065      *
1066      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1067      * transferred to `to`.
1068      * - When `from` is zero, `tokenId` will be minted for `to`.
1069      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1070      * - `from` and `to` are never both zero.
1071      *
1072      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1073      */
1074     function _beforeTokenTransfer(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) internal virtual {}
1079 }
1080 
1081 /**
1082  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1083  * @dev See https://eips.ethereum.org/EIPS/eip-721
1084  */
1085 interface IERC721Enumerable is IERC721 {
1086     /**
1087      * @dev Returns the total amount of tokens stored by the contract.
1088      */
1089     function totalSupply() external view returns (uint256);
1090 }
1091 
1092 contract littlefrens is ERC721, Ownable, IERC721Enumerable {
1093 
1094     mapping (address => bool) public _whitelisted;
1095     mapping (address => uint) public _minted;
1096 
1097     uint public salePrice;
1098     uint public whitelistPrice;
1099     uint public maxSupply;
1100     uint public maxPerTx;
1101     uint public maxPerWallet;
1102     uint public counter = 1;
1103 
1104     bool public publicMintStatus;
1105 
1106     string public baseURI;
1107 
1108     function _baseURI() internal view override returns (string memory) {
1109         return baseURI;
1110     }
1111     
1112     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1113         baseURI = _newBaseURI;
1114     }
1115 
1116     function setSalePrice(uint price) external onlyOwner {
1117         salePrice = price;
1118     }
1119 
1120     function setWhitelistPrice(uint price) external onlyOwner {
1121         whitelistPrice = price;
1122     }
1123 
1124     function setMaxSupply(uint supply) external onlyOwner {
1125         maxSupply = supply;
1126     }
1127 
1128     function addToWhitelist(address[] memory whitelisted) external onlyOwner {
1129         for(uint i=0; i < whitelisted.length; i++){
1130             _whitelisted[whitelisted[i]] = !_whitelisted[whitelisted[i]];
1131         }
1132     }
1133 
1134     function setMaxPerTx(uint max) external onlyOwner {
1135         maxPerTx = max;
1136     }
1137 
1138     function setMaxPerWallet(uint max) external onlyOwner {
1139         maxPerWallet = max;
1140     }
1141 
1142     function setPublicMintStatus() external onlyOwner {
1143         publicMintStatus = !publicMintStatus;
1144     }
1145 
1146     function totalSupply() public view virtual override returns(uint) {
1147         return counter - 1;
1148     }
1149 
1150     function withdraw() external onlyOwner {
1151         payable(msg.sender).transfer(address(this).balance);
1152     }
1153 
1154     constructor() ERC721("littlefrens", "LFRENS") {}
1155 
1156     function publicMint(uint amount) external payable {
1157         require(publicMintStatus, "Sale not active!");
1158         require(counter + amount <= maxSupply + 1, "Not enough tokens to sell!");
1159         require(amount <= maxPerTx, "Incorrect amount!");
1160         require(_minted[msg.sender] + amount <= maxPerWallet, "Incorrect amount!");
1161         if(_whitelisted[msg.sender]){
1162             require(msg.value == whitelistPrice * amount, "Incorrect amount!");
1163             for(uint i=0; i < amount; i++){
1164                 _safeMint(msg.sender, counter++);
1165                 _minted[msg.sender]++;
1166             }
1167         }else{
1168             require(msg.value == salePrice * amount, "Incorrect amount!");
1169             for(uint i=0; i < amount; i++){
1170                 _safeMint(msg.sender, counter++);
1171                 _minted[msg.sender]++;
1172             }
1173         }
1174     }
1175 }