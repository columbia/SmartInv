1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/access/Ownable.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor() {
128         _transferOwnership(_msgSender());
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view virtual returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public virtual onlyOwner {
154         _transferOwnership(address(0));
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         _transferOwnership(newOwner);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Internal function without access restriction.
169      */
170     function _transferOwnership(address newOwner) internal virtual {
171         address oldOwner = _owner;
172         _owner = newOwner;
173         emit OwnershipTransferred(oldOwner, newOwner);
174     }
175 }
176 
177 // File: @openzeppelin/contracts/utils/Address.sol
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @dev Collection of functions related to the address type
186  */
187 library Address {
188     /**
189      * @dev Returns true if `account` is a contract.
190      *
191      * [IMPORTANT]
192      * ====
193      * It is unsafe to assume that an address for which this function returns
194      * false is an externally-owned account (EOA) and not a contract.
195      *
196      * Among others, `isContract` will return false for the following
197      * types of addresses:
198      *
199      *  - an externally-owned account
200      *  - a contract in construction
201      *  - an address where a contract will be created
202      *  - an address where a contract lived, but was destroyed
203      * ====
204      */
205     function isContract(address account) internal view returns (bool) {
206         // This method relies on extcodesize, which returns 0 for contracts in
207         // construction, since the code is only stored at the end of the
208         // constructor execution.
209 
210         uint256 size;
211         assembly {
212             size := extcodesize(account)
213         }
214         return size > 0;
215     }
216 
217     /**
218      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
219      * `recipient`, forwarding all available gas and reverting on errors.
220      *
221      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
222      * of certain opcodes, possibly making contracts go over the 2300 gas limit
223      * imposed by `transfer`, making them unable to receive funds via
224      * `transfer`. {sendValue} removes this limitation.
225      *
226      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
227      *
228      * IMPORTANT: because control is transferred to `recipient`, care must be
229      * taken to not create reentrancy vulnerabilities. Consider using
230      * {ReentrancyGuard} or the
231      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
232      */
233     function sendValue(address payable recipient, uint256 amount) internal {
234         require(address(this).balance >= amount, "Address: insufficient balance");
235 
236         (bool success, ) = recipient.call{value: amount}("");
237         require(success, "Address: unable to send value, recipient may have reverted");
238     }
239 
240     /**
241      * @dev Performs a Solidity function call using a low level `call`. A
242      * plain `call` is an unsafe replacement for a function call: use this
243      * function instead.
244      *
245      * If `target` reverts with a revert reason, it is bubbled up by this
246      * function (like regular Solidity function calls).
247      *
248      * Returns the raw returned data. To convert to the expected return value,
249      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
250      *
251      * Requirements:
252      *
253      * - `target` must be a contract.
254      * - calling `target` with `data` must not revert.
255      *
256      * _Available since v3.1._
257      */
258     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
259         return functionCall(target, data, "Address: low-level call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
264      * `errorMessage` as a fallback revert reason when `target` reverts.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         return functionCallWithValue(target, data, 0, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but also transferring `value` wei to `target`.
279      *
280      * Requirements:
281      *
282      * - the calling contract must have an ETH balance of at least `value`.
283      * - the called Solidity function must be `payable`.
284      *
285      * _Available since v3.1._
286      */
287     function functionCallWithValue(
288         address target,
289         bytes memory data,
290         uint256 value
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
297      * with `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(address(this).balance >= value, "Address: insufficient balance for call");
308         require(isContract(target), "Address: call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.call{value: value}(data);
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a static call.
317      *
318      * _Available since v3.3._
319      */
320     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
321         return functionStaticCall(target, data, "Address: low-level static call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal view returns (bytes memory) {
335         require(isContract(target), "Address: static call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.staticcall(data);
338         return verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but performing a delegate call.
344      *
345      * _Available since v3.4._
346      */
347     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
348         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
353      * but performing a delegate call.
354      *
355      * _Available since v3.4._
356      */
357     function functionDelegateCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(isContract(target), "Address: delegate call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.delegatecall(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
370      * revert reason using the provided one.
371      *
372      * _Available since v4.3._
373      */
374     function verifyCallResult(
375         bool success,
376         bytes memory returndata,
377         string memory errorMessage
378     ) internal pure returns (bytes memory) {
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
398 
399 
400 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @title ERC721 token receiver interface
406  * @dev Interface for any contract that wants to support safeTransfers
407  * from ERC721 asset contracts.
408  */
409 interface IERC721Receiver {
410     /**
411      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
412      * by `operator` from `from`, this function is called.
413      *
414      * It must return its Solidity selector to confirm the token transfer.
415      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
416      *
417      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
418      */
419     function onERC721Received(
420         address operator,
421         address from,
422         uint256 tokenId,
423         bytes calldata data
424     ) external returns (bytes4);
425 }
426 
427 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
428 
429 
430 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
431 
432 pragma solidity ^0.8.0;
433 
434 /**
435  * @dev Interface of the ERC165 standard, as defined in the
436  * https://eips.ethereum.org/EIPS/eip-165[EIP].
437  *
438  * Implementers can declare support of contract interfaces, which can then be
439  * queried by others ({ERC165Checker}).
440  *
441  * For an implementation, see {ERC165}.
442  */
443 interface IERC165 {
444     /**
445      * @dev Returns true if this contract implements the interface defined by
446      * `interfaceId`. See the corresponding
447      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
448      * to learn more about how these ids are created.
449      *
450      * This function call must use less than 30 000 gas.
451      */
452     function supportsInterface(bytes4 interfaceId) external view returns (bool);
453 }
454 
455 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
456 
457 
458 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
459 
460 pragma solidity ^0.8.0;
461 
462 
463 /**
464  * @dev Implementation of the {IERC165} interface.
465  *
466  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
467  * for the additional interface id that will be supported. For example:
468  *
469  * ```solidity
470  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
471  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
472  * }
473  * ```
474  *
475  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
476  */
477 abstract contract ERC165 is IERC165 {
478     /**
479      * @dev See {IERC165-supportsInterface}.
480      */
481     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
482         return interfaceId == type(IERC165).interfaceId;
483     }
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 
494 /**
495  * @dev Required interface of an ERC721 compliant contract.
496  */
497 interface IERC721 is IERC165 {
498     /**
499      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
500      */
501     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
502 
503     /**
504      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
505      */
506     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
507 
508     /**
509      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
510      */
511     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
512 
513     /**
514      * @dev Returns the number of tokens in ``owner``'s account.
515      */
516     function balanceOf(address owner) external view returns (uint256 balance);
517 
518     /**
519      * @dev Returns the owner of the `tokenId` token.
520      *
521      * Requirements:
522      *
523      * - `tokenId` must exist.
524      */
525     function ownerOf(uint256 tokenId) external view returns (address owner);
526 
527     /**
528      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
529      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
530      *
531      * Requirements:
532      *
533      * - `from` cannot be the zero address.
534      * - `to` cannot be the zero address.
535      * - `tokenId` token must exist and be owned by `from`.
536      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
537      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
538      *
539      * Emits a {Transfer} event.
540      */
541     function safeTransferFrom(
542         address from,
543         address to,
544         uint256 tokenId
545     ) external;
546 
547     /**
548      * @dev Transfers `tokenId` token from `from` to `to`.
549      *
550      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must be owned by `from`.
557      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
558      *
559      * Emits a {Transfer} event.
560      */
561     function transferFrom(
562         address from,
563         address to,
564         uint256 tokenId
565     ) external;
566 
567     /**
568      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
569      * The approval is cleared when the token is transferred.
570      *
571      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
572      *
573      * Requirements:
574      *
575      * - The caller must own the token or be an approved operator.
576      * - `tokenId` must exist.
577      *
578      * Emits an {Approval} event.
579      */
580     function approve(address to, uint256 tokenId) external;
581 
582     /**
583      * @dev Returns the account approved for `tokenId` token.
584      *
585      * Requirements:
586      *
587      * - `tokenId` must exist.
588      */
589     function getApproved(uint256 tokenId) external view returns (address operator);
590 
591     /**
592      * @dev Approve or remove `operator` as an operator for the caller.
593      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
594      *
595      * Requirements:
596      *
597      * - The `operator` cannot be the caller.
598      *
599      * Emits an {ApprovalForAll} event.
600      */
601     function setApprovalForAll(address operator, bool _approved) external;
602 
603     /**
604      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
605      *
606      * See {setApprovalForAll}
607      */
608     function isApprovedForAll(address owner, address operator) external view returns (bool);
609 
610     /**
611      * @dev Safely transfers `tokenId` token from `from` to `to`.
612      *
613      * Requirements:
614      *
615      * - `from` cannot be the zero address.
616      * - `to` cannot be the zero address.
617      * - `tokenId` token must exist and be owned by `from`.
618      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
619      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
620      *
621      * Emits a {Transfer} event.
622      */
623     function safeTransferFrom(
624         address from,
625         address to,
626         uint256 tokenId,
627         bytes calldata data
628     ) external;
629 }
630 
631 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
632 
633 
634 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 
639 /**
640  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
641  * @dev See https://eips.ethereum.org/EIPS/eip-721
642  */
643 interface IERC721Metadata is IERC721 {
644     /**
645      * @dev Returns the token collection name.
646      */
647     function name() external view returns (string memory);
648 
649     /**
650      * @dev Returns the token collection symbol.
651      */
652     function symbol() external view returns (string memory);
653 
654     /**
655      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
656      */
657     function tokenURI(uint256 tokenId) external view returns (string memory);
658 }
659 
660 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 
668 
669 
670 
671 
672 
673 
674 /**
675  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
676  * the Metadata extension, but not including the Enumerable extension, which is available separately as
677  * {ERC721Enumerable}.
678  */
679 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
680     using Address for address;
681     using Strings for uint256;
682 
683     // Token name
684     string private _name;
685 
686     // Token symbol
687     string private _symbol;
688 
689     // Mapping from token ID to owner address
690     mapping(uint256 => address) private _owners;
691 
692     // Mapping owner address to token count
693     mapping(address => uint256) private _balances;
694 
695     // Mapping from token ID to approved address
696     mapping(uint256 => address) private _tokenApprovals;
697 
698     // Mapping from owner to operator approvals
699     mapping(address => mapping(address => bool)) private _operatorApprovals;
700 
701     /**
702      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
703      */
704     constructor(string memory name_, string memory symbol_) {
705         _name = name_;
706         _symbol = symbol_;
707     }
708 
709     /**
710      * @dev See {IERC165-supportsInterface}.
711      */
712     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
713         return
714             interfaceId == type(IERC721).interfaceId ||
715             interfaceId == type(IERC721Metadata).interfaceId ||
716             super.supportsInterface(interfaceId);
717     }
718 
719     /**
720      * @dev See {IERC721-balanceOf}.
721      */
722     function balanceOf(address owner) public view virtual override returns (uint256) {
723         require(owner != address(0), "ERC721: balance query for the zero address");
724         return _balances[owner];
725     }
726 
727     /**
728      * @dev See {IERC721-ownerOf}.
729      */
730     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
731         address owner = _owners[tokenId];
732         require(owner != address(0), "ERC721: owner query for nonexistent token");
733         return owner;
734     }
735 
736     /**
737      * @dev See {IERC721Metadata-name}.
738      */
739     function name() public view virtual override returns (string memory) {
740         return _name;
741     }
742 
743     /**
744      * @dev See {IERC721Metadata-symbol}.
745      */
746     function symbol() public view virtual override returns (string memory) {
747         return _symbol;
748     }
749 
750     /**
751      * @dev See {IERC721Metadata-tokenURI}.
752      */
753     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
754         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
755 
756         string memory baseURI = _baseURI();
757         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
758     }
759 
760     /**
761      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
762      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
763      * by default, can be overriden in child contracts.
764      */
765     function _baseURI() internal view virtual returns (string memory) {
766         return "";
767     }
768 
769     /**
770      * @dev See {IERC721-approve}.
771      */
772     function approve(address to, uint256 tokenId) public virtual override {
773         address owner = ERC721.ownerOf(tokenId);
774         require(to != owner, "ERC721: approval to current owner");
775 
776         require(
777             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
778             "ERC721: approve caller is not owner nor approved for all"
779         );
780 
781         _approve(to, tokenId);
782     }
783 
784     /**
785      * @dev See {IERC721-getApproved}.
786      */
787     function getApproved(uint256 tokenId) public view virtual override returns (address) {
788         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
789 
790         return _tokenApprovals[tokenId];
791     }
792 
793     /**
794      * @dev See {IERC721-setApprovalForAll}.
795      */
796     function setApprovalForAll(address operator, bool approved) public virtual override {
797         _setApprovalForAll(_msgSender(), operator, approved);
798     }
799 
800     /**
801      * @dev See {IERC721-isApprovedForAll}.
802      */
803     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
804         return _operatorApprovals[owner][operator];
805     }
806 
807     /**
808      * @dev See {IERC721-transferFrom}.
809      */
810     function transferFrom(
811         address from,
812         address to,
813         uint256 tokenId
814     ) public virtual override {
815         //solhint-disable-next-line max-line-length
816         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
817 
818         _transfer(from, to, tokenId);
819     }
820 
821     /**
822      * @dev See {IERC721-safeTransferFrom}.
823      */
824     function safeTransferFrom(
825         address from,
826         address to,
827         uint256 tokenId
828     ) public virtual override {
829         safeTransferFrom(from, to, tokenId, "");
830     }
831 
832     /**
833      * @dev See {IERC721-safeTransferFrom}.
834      */
835     function safeTransferFrom(
836         address from,
837         address to,
838         uint256 tokenId,
839         bytes memory _data
840     ) public virtual override {
841         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
842         _safeTransfer(from, to, tokenId, _data);
843     }
844 
845     /**
846      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
847      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
848      *
849      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
850      *
851      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
852      * implement alternative mechanisms to perform token transfer, such as signature-based.
853      *
854      * Requirements:
855      *
856      * - `from` cannot be the zero address.
857      * - `to` cannot be the zero address.
858      * - `tokenId` token must exist and be owned by `from`.
859      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
860      *
861      * Emits a {Transfer} event.
862      */
863     function _safeTransfer(
864         address from,
865         address to,
866         uint256 tokenId,
867         bytes memory _data
868     ) internal virtual {
869         _transfer(from, to, tokenId);
870         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
871     }
872 
873     /**
874      * @dev Returns whether `tokenId` exists.
875      *
876      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
877      *
878      * Tokens start existing when they are minted (`_mint`),
879      * and stop existing when they are burned (`_burn`).
880      */
881     function _exists(uint256 tokenId) internal view virtual returns (bool) {
882         return _owners[tokenId] != address(0);
883     }
884 
885     /**
886      * @dev Returns whether `spender` is allowed to manage `tokenId`.
887      *
888      * Requirements:
889      *
890      * - `tokenId` must exist.
891      */
892     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
893         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
894         address owner = ERC721.ownerOf(tokenId);
895         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
896     }
897 
898     /**
899      * @dev Safely mints `tokenId` and transfers it to `to`.
900      *
901      * Requirements:
902      *
903      * - `tokenId` must not exist.
904      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _safeMint(address to, uint256 tokenId) internal virtual {
909         _safeMint(to, tokenId, "");
910     }
911 
912     /**
913      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
914      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
915      */
916     function _safeMint(
917         address to,
918         uint256 tokenId,
919         bytes memory _data
920     ) internal virtual {
921         _mint(to, tokenId);
922         require(
923             _checkOnERC721Received(address(0), to, tokenId, _data),
924             "ERC721: transfer to non ERC721Receiver implementer"
925         );
926     }
927 
928     /**
929      * @dev Mints `tokenId` and transfers it to `to`.
930      *
931      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
932      *
933      * Requirements:
934      *
935      * - `tokenId` must not exist.
936      * - `to` cannot be the zero address.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _mint(address to, uint256 tokenId) internal virtual {
941         require(to != address(0), "ERC721: mint to the zero address");
942         require(!_exists(tokenId), "ERC721: token already minted");
943 
944         _beforeTokenTransfer(address(0), to, tokenId);
945 
946         _balances[to] += 1;
947         _owners[tokenId] = to;
948 
949         emit Transfer(address(0), to, tokenId);
950     }
951 
952     /**
953      * @dev Destroys `tokenId`.
954      * The approval is cleared when the token is burned.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must exist.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _burn(uint256 tokenId) internal virtual {
963         address owner = ERC721.ownerOf(tokenId);
964 
965         _beforeTokenTransfer(owner, address(0), tokenId);
966 
967         // Clear approvals
968         _approve(address(0), tokenId);
969 
970         _balances[owner] -= 1;
971         delete _owners[tokenId];
972 
973         emit Transfer(owner, address(0), tokenId);
974     }
975 
976     /**
977      * @dev Transfers `tokenId` from `from` to `to`.
978      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
979      *
980      * Requirements:
981      *
982      * - `to` cannot be the zero address.
983      * - `tokenId` token must be owned by `from`.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _transfer(
988         address from,
989         address to,
990         uint256 tokenId
991     ) internal virtual {
992         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
993         require(to != address(0), "ERC721: transfer to the zero address");
994 
995         _beforeTokenTransfer(from, to, tokenId);
996 
997         // Clear approvals from the previous owner
998         _approve(address(0), tokenId);
999 
1000         _balances[from] -= 1;
1001         _balances[to] += 1;
1002         _owners[tokenId] = to;
1003 
1004         emit Transfer(from, to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev Approve `to` to operate on `tokenId`
1009      *
1010      * Emits a {Approval} event.
1011      */
1012     function _approve(address to, uint256 tokenId) internal virtual {
1013         _tokenApprovals[tokenId] = to;
1014         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1015     }
1016 
1017     /**
1018      * @dev Approve `operator` to operate on all of `owner` tokens
1019      *
1020      * Emits a {ApprovalForAll} event.
1021      */
1022     function _setApprovalForAll(
1023         address owner,
1024         address operator,
1025         bool approved
1026     ) internal virtual {
1027         require(owner != operator, "ERC721: approve to caller");
1028         _operatorApprovals[owner][operator] = approved;
1029         emit ApprovalForAll(owner, operator, approved);
1030     }
1031 
1032     /**
1033      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1034      * The call is not executed if the target address is not a contract.
1035      *
1036      * @param from address representing the previous owner of the given token ID
1037      * @param to target address that will receive the tokens
1038      * @param tokenId uint256 ID of the token to be transferred
1039      * @param _data bytes optional data to send along with the call
1040      * @return bool whether the call correctly returned the expected magic value
1041      */
1042     function _checkOnERC721Received(
1043         address from,
1044         address to,
1045         uint256 tokenId,
1046         bytes memory _data
1047     ) private returns (bool) {
1048         if (to.isContract()) {
1049             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1050                 return retval == IERC721Receiver.onERC721Received.selector;
1051             } catch (bytes memory reason) {
1052                 if (reason.length == 0) {
1053                     revert("ERC721: transfer to non ERC721Receiver implementer");
1054                 } else {
1055                     assembly {
1056                         revert(add(32, reason), mload(reason))
1057                     }
1058                 }
1059             }
1060         } else {
1061             return true;
1062         }
1063     }
1064 
1065     /**
1066      * @dev Hook that is called before any token transfer. This includes minting
1067      * and burning.
1068      *
1069      * Calling conditions:
1070      *
1071      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1072      * transferred to `to`.
1073      * - When `from` is zero, `tokenId` will be minted for `to`.
1074      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1075      * - `from` and `to` are never both zero.
1076      *
1077      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1078      */
1079     function _beforeTokenTransfer(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) internal virtual {}
1084 }
1085 
1086 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1087 
1088 
1089 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1090 
1091 pragma solidity ^0.8.0;
1092 
1093 
1094 
1095 /**
1096  * @title ERC721 Burnable Token
1097  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1098  */
1099 abstract contract ERC721Burnable is Context, ERC721 {
1100     /**
1101      * @dev Burns `tokenId`. See {ERC721-_burn}.
1102      *
1103      * Requirements:
1104      *
1105      * - The caller must own `tokenId` or be an approved operator.
1106      */
1107     function burn(uint256 tokenId) public virtual {
1108         //solhint-disable-next-line max-line-length
1109         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1110         _burn(tokenId);
1111     }
1112 }
1113 
1114 // File: contracts/CryptoStampArt.sol
1115 
1116 pragma solidity ^0.8.4;
1117 
1118 //  __/\\\\\\\\\\\\\\\_______/\\\\\_______/\\\________/\\\_____/\\\\\\\\\_____/\\\\\\\\\\\\\____/\\\\\\\\\\\_        
1119 //   _\///////\\\/////______/\\\///\\\____\/\\\_____/\\\//____/\\\\\\\\\\\\\__\/\\\/////////\\\_\/////\\\///__       
1120 //    _______\/\\\_________/\\\/__\///\\\__\/\\\__/\\\//______/\\\/////////\\\_\/\\\_______\/\\\_____\/\\\_____      
1121 //     _______\/\\\________/\\\______\//\\\_\/\\\\\\//\\\_____\/\\\_______\/\\\_\/\\\\\\\\\\\\\/______\/\\\_____     
1122 //      _______\/\\\_______\/\\\_______\/\\\_\/\\\//_\//\\\____\/\\\\\\\\\\\\\\\_\/\\\/////////________\/\\\_____    
1123 //       _______\/\\\_______\//\\\______/\\\__\/\\\____\//\\\___\/\\\/////////\\\_\/\\\_________________\/\\\_____   
1124 //        _______\/\\\________\///\\\__/\\\____\/\\\_____\//\\\__\/\\\_______\/\\\_\/\\\_________________\/\\\_____  
1125 //         _______\/\\\__________\///\\\\\/_____\/\\\______\//\\\_\/\\\_______\/\\\_\/\\\______________/\\\\\\\\\\\_ 
1126 //          _______\///_____________\/////_______\///________\///__\///________\///__\///______________\///////////__
1127 
1128 /// @custom:security-contact thedevs
1129 contract CryptoStampArt is ERC721, ERC721Burnable, Ownable {
1130     constructor() ERC721("Crypto stamp art", "CSA") {}
1131 
1132     string private _baseTokenURI;
1133 
1134     function _baseURI() internal view override returns (string memory) {
1135         return _baseTokenURI;
1136     }
1137 
1138     function safeMint(address to, uint256 tokenId) public onlyOwner {
1139         _safeMint(to, tokenId);
1140     }
1141 
1142     function baseURI() public view returns (string memory) {
1143         return _baseTokenURI;
1144     }
1145     
1146     function setBaseURI(string memory uri) public onlyOwner {
1147         _baseTokenURI = uri;
1148     }
1149 }