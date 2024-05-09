1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
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
75 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
102 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
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
180 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
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
400 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
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
430 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
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
458 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
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
489 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
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
631 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
632 
633 
634 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 
639 /**
640  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
641  * @dev See https://eips.ethereum.org/EIPS/eip-721
642  */
643 interface IERC721Enumerable is IERC721 {
644     /**
645      * @dev Returns the total amount of tokens stored by the contract.
646      */
647     function totalSupply() external view returns (uint256);
648 
649     /**
650      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
651      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
652      */
653     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
654 
655     /**
656      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
657      * Use along with {totalSupply} to enumerate all tokens.
658      */
659     function tokenByIndex(uint256 index) external view returns (uint256);
660 }
661 
662 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
663 
664 
665 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 
670 /**
671  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
672  * @dev See https://eips.ethereum.org/EIPS/eip-721
673  */
674 interface IERC721Metadata is IERC721 {
675     /**
676      * @dev Returns the token collection name.
677      */
678     function name() external view returns (string memory);
679 
680     /**
681      * @dev Returns the token collection symbol.
682      */
683     function symbol() external view returns (string memory);
684 
685     /**
686      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
687      */
688     function tokenURI(uint256 tokenId) external view returns (string memory);
689 }
690 
691 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
692 
693 
694 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 
699 
700 
701 
702 
703 
704 
705 /**
706  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
707  * the Metadata extension, but not including the Enumerable extension, which is available separately as
708  * {ERC721Enumerable}.
709  */
710 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
711     using Address for address;
712     using Strings for uint256;
713 
714     // Token name
715     string private _name;
716 
717     // Token symbol
718     string private _symbol;
719 
720     // Mapping from token ID to owner address
721     mapping(uint256 => address) private _owners;
722 
723     // Mapping owner address to token count
724     mapping(address => uint256) private _balances;
725 
726     // Mapping from token ID to approved address
727     mapping(uint256 => address) private _tokenApprovals;
728 
729     // Mapping from owner to operator approvals
730     mapping(address => mapping(address => bool)) private _operatorApprovals;
731 
732     /**
733      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
734      */
735     constructor(string memory name_, string memory symbol_) {
736         _name = name_;
737         _symbol = symbol_;
738     }
739 
740     /**
741      * @dev See {IERC165-supportsInterface}.
742      */
743     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
744         return
745             interfaceId == type(IERC721).interfaceId ||
746             interfaceId == type(IERC721Metadata).interfaceId ||
747             super.supportsInterface(interfaceId);
748     }
749 
750     /**
751      * @dev See {IERC721-balanceOf}.
752      */
753     function balanceOf(address owner) public view virtual override returns (uint256) {
754         require(owner != address(0), "ERC721: balance query for the zero address");
755         return _balances[owner];
756     }
757 
758     /**
759      * @dev See {IERC721-ownerOf}.
760      */
761     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
762         address owner = _owners[tokenId];
763         require(owner != address(0), "ERC721: owner query for nonexistent token");
764         return owner;
765     }
766 
767     /**
768      * @dev See {IERC721Metadata-name}.
769      */
770     function name() public view virtual override returns (string memory) {
771         return _name;
772     }
773 
774     /**
775      * @dev See {IERC721Metadata-symbol}.
776      */
777     function symbol() public view virtual override returns (string memory) {
778         return _symbol;
779     }
780 
781     /**
782      * @dev See {IERC721Metadata-tokenURI}.
783      */
784     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
785         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
786 
787         string memory baseURI = _baseURI();
788         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
789     }
790 
791     /**
792      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
793      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
794      * by default, can be overriden in child contracts.
795      */
796     function _baseURI() internal view virtual returns (string memory) {
797         return "";
798     }
799 
800     /**
801      * @dev See {IERC721-approve}.
802      */
803     function approve(address to, uint256 tokenId) public virtual override {
804         address owner = ERC721.ownerOf(tokenId);
805         require(to != owner, "ERC721: approval to current owner");
806 
807         require(
808             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
809             "ERC721: approve caller is not owner nor approved for all"
810         );
811 
812         _approve(to, tokenId);
813     }
814 
815     /**
816      * @dev See {IERC721-getApproved}.
817      */
818     function getApproved(uint256 tokenId) public view virtual override returns (address) {
819         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
820 
821         return _tokenApprovals[tokenId];
822     }
823 
824     /**
825      * @dev See {IERC721-setApprovalForAll}.
826      */
827     function setApprovalForAll(address operator, bool approved) public virtual override {
828         _setApprovalForAll(_msgSender(), operator, approved);
829     }
830 
831     /**
832      * @dev See {IERC721-isApprovedForAll}.
833      */
834     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
835         return _operatorApprovals[owner][operator];
836     }
837 
838     /**
839      * @dev See {IERC721-transferFrom}.
840      */
841     function transferFrom(
842         address from,
843         address to,
844         uint256 tokenId
845     ) public virtual override {
846         //solhint-disable-next-line max-line-length
847         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
848 
849         _transfer(from, to, tokenId);
850     }
851 
852     /**
853      * @dev See {IERC721-safeTransferFrom}.
854      */
855     function safeTransferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) public virtual override {
860         safeTransferFrom(from, to, tokenId, "");
861     }
862 
863     /**
864      * @dev See {IERC721-safeTransferFrom}.
865      */
866     function safeTransferFrom(
867         address from,
868         address to,
869         uint256 tokenId,
870         bytes memory _data
871     ) public virtual override {
872         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
873         _safeTransfer(from, to, tokenId, _data);
874     }
875 
876     /**
877      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
878      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
879      *
880      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
881      *
882      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
883      * implement alternative mechanisms to perform token transfer, such as signature-based.
884      *
885      * Requirements:
886      *
887      * - `from` cannot be the zero address.
888      * - `to` cannot be the zero address.
889      * - `tokenId` token must exist and be owned by `from`.
890      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _safeTransfer(
895         address from,
896         address to,
897         uint256 tokenId,
898         bytes memory _data
899     ) internal virtual {
900         _transfer(from, to, tokenId);
901         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
902     }
903 
904     /**
905      * @dev Returns whether `tokenId` exists.
906      *
907      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
908      *
909      * Tokens start existing when they are minted (`_mint`),
910      * and stop existing when they are burned (`_burn`).
911      */
912     function _exists(uint256 tokenId) internal view virtual returns (bool) {
913         return _owners[tokenId] != address(0);
914     }
915 
916     /**
917      * @dev Returns whether `spender` is allowed to manage `tokenId`.
918      *
919      * Requirements:
920      *
921      * - `tokenId` must exist.
922      */
923     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
924         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
925         address owner = ERC721.ownerOf(tokenId);
926         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
927     }
928 
929     /**
930      * @dev Safely mints `tokenId` and transfers it to `to`.
931      *
932      * Requirements:
933      *
934      * - `tokenId` must not exist.
935      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _safeMint(address to, uint256 tokenId) internal virtual {
940         _safeMint(to, tokenId, "");
941     }
942 
943     /**
944      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
945      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
946      */
947     function _safeMint(
948         address to,
949         uint256 tokenId,
950         bytes memory _data
951     ) internal virtual {
952         _mint(to, tokenId);
953         require(
954             _checkOnERC721Received(address(0), to, tokenId, _data),
955             "ERC721: transfer to non ERC721Receiver implementer"
956         );
957     }
958 
959     /**
960      * @dev Mints `tokenId` and transfers it to `to`.
961      *
962      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
963      *
964      * Requirements:
965      *
966      * - `tokenId` must not exist.
967      * - `to` cannot be the zero address.
968      *
969      * Emits a {Transfer} event.
970      */
971     function _mint(address to, uint256 tokenId) internal virtual {
972         require(to != address(0), "ERC721: mint to the zero address");
973         require(!_exists(tokenId), "ERC721: token already minted");
974 
975         _beforeTokenTransfer(address(0), to, tokenId);
976 
977         _balances[to] += 1;
978         _owners[tokenId] = to;
979 
980         emit Transfer(address(0), to, tokenId);
981     }
982 
983     /**
984      * @dev Destroys `tokenId`.
985      * The approval is cleared when the token is burned.
986      *
987      * Requirements:
988      *
989      * - `tokenId` must exist.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _burn(uint256 tokenId) internal virtual {
994         address owner = ERC721.ownerOf(tokenId);
995 
996         _beforeTokenTransfer(owner, address(0), tokenId);
997 
998         // Clear approvals
999         _approve(address(0), tokenId);
1000 
1001         _balances[owner] -= 1;
1002         delete _owners[tokenId];
1003 
1004         emit Transfer(owner, address(0), tokenId);
1005     }
1006 
1007     /**
1008      * @dev Transfers `tokenId` from `from` to `to`.
1009      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1010      *
1011      * Requirements:
1012      *
1013      * - `to` cannot be the zero address.
1014      * - `tokenId` token must be owned by `from`.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function _transfer(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) internal virtual {
1023         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1024         require(to != address(0), "ERC721: transfer to the zero address");
1025 
1026         _beforeTokenTransfer(from, to, tokenId);
1027 
1028         // Clear approvals from the previous owner
1029         _approve(address(0), tokenId);
1030 
1031         _balances[from] -= 1;
1032         _balances[to] += 1;
1033         _owners[tokenId] = to;
1034 
1035         emit Transfer(from, to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev Approve `to` to operate on `tokenId`
1040      *
1041      * Emits a {Approval} event.
1042      */
1043     function _approve(address to, uint256 tokenId) internal virtual {
1044         _tokenApprovals[tokenId] = to;
1045         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1046     }
1047 
1048     /**
1049      * @dev Approve `operator` to operate on all of `owner` tokens
1050      *
1051      * Emits a {ApprovalForAll} event.
1052      */
1053     function _setApprovalForAll(
1054         address owner,
1055         address operator,
1056         bool approved
1057     ) internal virtual {
1058         require(owner != operator, "ERC721: approve to caller");
1059         _operatorApprovals[owner][operator] = approved;
1060         emit ApprovalForAll(owner, operator, approved);
1061     }
1062 
1063     /**
1064      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1065      * The call is not executed if the target address is not a contract.
1066      *
1067      * @param from address representing the previous owner of the given token ID
1068      * @param to target address that will receive the tokens
1069      * @param tokenId uint256 ID of the token to be transferred
1070      * @param _data bytes optional data to send along with the call
1071      * @return bool whether the call correctly returned the expected magic value
1072      */
1073     function _checkOnERC721Received(
1074         address from,
1075         address to,
1076         uint256 tokenId,
1077         bytes memory _data
1078     ) private returns (bool) {
1079         if (to.isContract()) {
1080             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1081                 return retval == IERC721Receiver.onERC721Received.selector;
1082             } catch (bytes memory reason) {
1083                 if (reason.length == 0) {
1084                     revert("ERC721: transfer to non ERC721Receiver implementer");
1085                 } else {
1086                     assembly {
1087                         revert(add(32, reason), mload(reason))
1088                     }
1089                 }
1090             }
1091         } else {
1092             return true;
1093         }
1094     }
1095 
1096     /**
1097      * @dev Hook that is called before any token transfer. This includes minting
1098      * and burning.
1099      *
1100      * Calling conditions:
1101      *
1102      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1103      * transferred to `to`.
1104      * - When `from` is zero, `tokenId` will be minted for `to`.
1105      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1106      * - `from` and `to` are never both zero.
1107      *
1108      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1109      */
1110     function _beforeTokenTransfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) internal virtual {}
1115 }
1116 
1117 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1118 
1119 
1120 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1121 
1122 pragma solidity ^0.8.0;
1123 
1124 
1125 
1126 /**
1127  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1128  * enumerability of all the token ids in the contract as well as all token ids owned by each
1129  * account.
1130  */
1131 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1132     // Mapping from owner to list of owned token IDs
1133     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1134 
1135     // Mapping from token ID to index of the owner tokens list
1136     mapping(uint256 => uint256) private _ownedTokensIndex;
1137 
1138     // Array with all token ids, used for enumeration
1139     uint256[] private _allTokens;
1140 
1141     // Mapping from token id to position in the allTokens array
1142     mapping(uint256 => uint256) private _allTokensIndex;
1143 
1144     /**
1145      * @dev See {IERC165-supportsInterface}.
1146      */
1147     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1148         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1149     }
1150 
1151     /**
1152      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1153      */
1154     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1155         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1156         return _ownedTokens[owner][index];
1157     }
1158 
1159     /**
1160      * @dev See {IERC721Enumerable-totalSupply}.
1161      */
1162     function totalSupply() public view virtual override returns (uint256) {
1163         return _allTokens.length;
1164     }
1165 
1166     /**
1167      * @dev See {IERC721Enumerable-tokenByIndex}.
1168      */
1169     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1170         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1171         return _allTokens[index];
1172     }
1173 
1174     /**
1175      * @dev Hook that is called before any token transfer. This includes minting
1176      * and burning.
1177      *
1178      * Calling conditions:
1179      *
1180      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1181      * transferred to `to`.
1182      * - When `from` is zero, `tokenId` will be minted for `to`.
1183      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1184      * - `from` cannot be the zero address.
1185      * - `to` cannot be the zero address.
1186      *
1187      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1188      */
1189     function _beforeTokenTransfer(
1190         address from,
1191         address to,
1192         uint256 tokenId
1193     ) internal virtual override {
1194         super._beforeTokenTransfer(from, to, tokenId);
1195 
1196         if (from == address(0)) {
1197             _addTokenToAllTokensEnumeration(tokenId);
1198         } else if (from != to) {
1199             _removeTokenFromOwnerEnumeration(from, tokenId);
1200         }
1201         if (to == address(0)) {
1202             _removeTokenFromAllTokensEnumeration(tokenId);
1203         } else if (to != from) {
1204             _addTokenToOwnerEnumeration(to, tokenId);
1205         }
1206     }
1207 
1208     /**
1209      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1210      * @param to address representing the new owner of the given token ID
1211      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1212      */
1213     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1214         uint256 length = ERC721.balanceOf(to);
1215         _ownedTokens[to][length] = tokenId;
1216         _ownedTokensIndex[tokenId] = length;
1217     }
1218 
1219     /**
1220      * @dev Private function to add a token to this extension's token tracking data structures.
1221      * @param tokenId uint256 ID of the token to be added to the tokens list
1222      */
1223     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1224         _allTokensIndex[tokenId] = _allTokens.length;
1225         _allTokens.push(tokenId);
1226     }
1227 
1228     /**
1229      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1230      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1231      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1232      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1233      * @param from address representing the previous owner of the given token ID
1234      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1235      */
1236     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1237         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1238         // then delete the last slot (swap and pop).
1239 
1240         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1241         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1242 
1243         // When the token to delete is the last token, the swap operation is unnecessary
1244         if (tokenIndex != lastTokenIndex) {
1245             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1246 
1247             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1248             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1249         }
1250 
1251         // This also deletes the contents at the last position of the array
1252         delete _ownedTokensIndex[tokenId];
1253         delete _ownedTokens[from][lastTokenIndex];
1254     }
1255 
1256     /**
1257      * @dev Private function to remove a token from this extension's token tracking data structures.
1258      * This has O(1) time complexity, but alters the order of the _allTokens array.
1259      * @param tokenId uint256 ID of the token to be removed from the tokens list
1260      */
1261     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1262         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1263         // then delete the last slot (swap and pop).
1264 
1265         uint256 lastTokenIndex = _allTokens.length - 1;
1266         uint256 tokenIndex = _allTokensIndex[tokenId];
1267 
1268         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1269         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1270         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1271         uint256 lastTokenId = _allTokens[lastTokenIndex];
1272 
1273         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1274         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1275 
1276         // This also deletes the contents at the last position of the array
1277         delete _allTokensIndex[tokenId];
1278         _allTokens.pop();
1279     }
1280 }
1281 
1282 // File: ShibaChild.sol
1283 
1284 
1285 
1286 pragma solidity >=0.7.0 <0.9.0;
1287 
1288 
1289 
1290 contract PandaMiners is ERC721Enumerable, Ownable {
1291   using Strings for uint256;
1292 
1293   string public baseURI;
1294   string public baseExtension = ".json";
1295   uint256 public cost = 0.05 ether;
1296   uint256 public maxSupply = 6014;
1297   uint256 public maxMintAmount = 10;
1298   bool public paused = false;
1299   bool public onlyWhitelisted = false;
1300   address[] public whitelistedAddresses;
1301   mapping(address => uint256) public addressMintedBalance;
1302   mapping(uint256 => address) public addressMintedIds;
1303   string public startDate = "12-17-2021";
1304   string public notRevealedUri;
1305   bool public revealed = false;
1306 
1307 
1308   constructor() ERC721("Panda Miners", "PM") {
1309     setBaseURI("https://ipfs.io/ipfs/QmTnM9ch1cocAL8NtZsCfQhpwD7dfCMjyLxNpi4VugiDxY/");
1310     setNotRevealedURI("https://ipfs.io/ipfs/QmbkN9Dmo4vgz8syvtKG9LTuX3HwPcnGyKu6LcAhXTMAok/hidden.json");
1311     mint(50);
1312   }
1313 
1314   // internal
1315   function _baseURI() internal view virtual override returns (string memory) {
1316     return baseURI;
1317   }
1318 
1319   // public
1320   function mint(uint256 _mintAmount) public payable {
1321     require(!paused, "Sale is not active yet");
1322     uint256 supply = totalSupply();
1323     require(_mintAmount > 0, "Need to mint at least 1 NFT");
1324     require(supply + _mintAmount <= maxSupply, "Max NFT limit exceeded");
1325 
1326     if (msg.sender != owner()) {
1327         if(onlyWhitelisted == true) {
1328             require(isWhitelisted(msg.sender), "User is not whitelisted");
1329         }
1330         require(_mintAmount <= maxMintAmount, "Max mint amount per session exceeded");
1331         require(msg.value >= cost * _mintAmount, "insufficient funds");
1332     }
1333     
1334     for (uint256 i = 1; i <= _mintAmount; i++) {
1335         addressMintedBalance[msg.sender]++;
1336         _safeMint(msg.sender, supply + i);
1337     }
1338   }
1339   
1340   function isWhitelisted(address _user) public view returns (bool) {
1341     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1342       if (whitelistedAddresses[i] == _user) {
1343           return true;
1344       }
1345     }
1346     return false;
1347   }
1348 
1349   function reveal(bool _reveal) public onlyOwner() {
1350       revealed = _reveal;
1351   }
1352 
1353   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1354     notRevealedUri = _notRevealedURI;
1355   }
1356 
1357   function walletOfOwner(address _owner)
1358     public
1359     view
1360     returns (uint256[] memory)
1361   {
1362     uint256 ownerTokenCount = balanceOf(_owner);
1363     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1364     for (uint256 i; i < ownerTokenCount; i++) {
1365       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1366     }
1367     return tokenIds;
1368   }
1369 
1370   function tokenURI(uint256 tokenId)
1371     public
1372     view
1373     virtual
1374     override
1375     returns (string memory)
1376   {
1377     require(
1378       _exists(tokenId),
1379       "ERC721Metadata: URI query for nonexistent token"
1380     );
1381 
1382     if(revealed == false) {
1383         return notRevealedUri;
1384     }
1385 
1386     string memory currentBaseURI = _baseURI();
1387     return bytes(currentBaseURI).length > 0
1388         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1389         : "";
1390   }
1391   
1392   function setCost(uint256 _newCost) public onlyOwner {
1393     cost = _newCost;
1394   }
1395 
1396   function setStartDate(string memory date) public onlyOwner {
1397     startDate = date;
1398   }
1399 
1400   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1401     maxMintAmount = _newmaxMintAmount;
1402   }
1403 
1404   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1405     baseURI = _newBaseURI;
1406   }
1407 
1408   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1409     baseExtension = _newBaseExtension;
1410   }
1411   
1412 
1413   function pause(bool _state) public onlyOwner {
1414     paused = _state;
1415   }
1416   
1417   function setOnlyWhitelisted(bool _state) public onlyOwner {
1418     onlyWhitelisted = _state;
1419   }
1420   
1421   function whitelistUsers(address[] calldata _users) public onlyOwner {
1422     delete whitelistedAddresses;
1423     whitelistedAddresses = _users;
1424   }
1425  
1426   function withdraw() public payable onlyOwner {
1427     require(address(this).balance > 0, "Balance is 0");
1428     payable(owner()).transfer(address(this).balance);
1429   }
1430 }