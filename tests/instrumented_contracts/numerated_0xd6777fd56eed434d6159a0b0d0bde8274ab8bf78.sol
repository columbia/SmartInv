1 // File: @openzeppelin/contracts@4.2.0/utils/Context.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 // File: @openzeppelin/contracts@4.2.0/access/Ownable.sol
26 
27 // SPDX-License-Identifier: MIT
28 
29 pragma solidity ^0.8.0;
30 
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _setOwner(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _setOwner(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _setOwner(newOwner);
89     }
90 
91     function _setOwner(address newOwner) private {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 // File: @openzeppelin/contracts@4.2.0/utils/introspection/IERC165.sol
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev Interface of the ERC165 standard, as defined in the
104  * https://eips.ethereum.org/EIPS/eip-165[EIP].
105  *
106  * Implementers can declare support of contract interfaces, which can then be
107  * queried by others ({ERC165Checker}).
108  *
109  * For an implementation, see {ERC165}.
110  */
111 interface IERC165 {
112     /**
113      * @dev Returns true if this contract implements the interface defined by
114      * `interfaceId`. See the corresponding
115      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
116      * to learn more about how these ids are created.
117      *
118      * This function call must use less than 30 000 gas.
119      */
120     function supportsInterface(bytes4 interfaceId) external view returns (bool);
121 }
122 
123 
124 // File: @openzeppelin/contracts@4.2.0/token/ERC721/IERC721.sol
125 
126 pragma solidity ^0.8.0;
127 
128 
129 /**
130  * @dev Required interface of an ERC721 compliant contract.
131  */
132 interface IERC721 is IERC165 {
133     /**
134      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
140      */
141     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
145      */
146     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
147 
148     /**
149      * @dev Returns the number of tokens in ``owner``'s account.
150      */
151     function balanceOf(address owner) external view returns (uint256 balance);
152 
153     /**
154      * @dev Returns the owner of the `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function ownerOf(uint256 tokenId) external view returns (address owner);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
164      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must exist and be owned by `from`.
171      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173      *
174      * Emits a {Transfer} event.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId
180     ) external;
181 
182     /**
183      * @dev Transfers `tokenId` token from `from` to `to`.
184      *
185      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
186      *
187      * Requirements:
188      *
189      * - `from` cannot be the zero address.
190      * - `to` cannot be the zero address.
191      * - `tokenId` token must be owned by `from`.
192      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transferFrom(
197         address from,
198         address to,
199         uint256 tokenId
200     ) external;
201 
202     /**
203      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
204      * The approval is cleared when the token is transferred.
205      *
206      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
207      *
208      * Requirements:
209      *
210      * - The caller must own the token or be an approved operator.
211      * - `tokenId` must exist.
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address to, uint256 tokenId) external;
216 
217     /**
218      * @dev Returns the account approved for `tokenId` token.
219      *
220      * Requirements:
221      *
222      * - `tokenId` must exist.
223      */
224     function getApproved(uint256 tokenId) external view returns (address operator);
225 
226     /**
227      * @dev Approve or remove `operator` as an operator for the caller.
228      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
240      *
241      * See {setApprovalForAll}
242      */
243     function isApprovedForAll(address owner, address operator) external view returns (bool);
244 
245     /**
246      * @dev Safely transfers `tokenId` token from `from` to `to`.
247      *
248      * Requirements:
249      *
250      * - `from` cannot be the zero address.
251      * - `to` cannot be the zero address.
252      * - `tokenId` token must exist and be owned by `from`.
253      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
254      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
255      *
256      * Emits a {Transfer} event.
257      */
258     function safeTransferFrom(
259         address from,
260         address to,
261         uint256 tokenId,
262         bytes calldata data
263     ) external;
264 }
265 
266 // File: @openzeppelin/contracts@4.2.0/token/ERC721/extensions/IERC721Enumerable.sol
267 
268 pragma solidity ^0.8.0;
269 
270 
271 /**
272  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
273  * @dev See https://eips.ethereum.org/EIPS/eip-721
274  */
275 interface IERC721Enumerable is IERC721 {
276     /**
277      * @dev Returns the total amount of tokens stored by the contract.
278      */
279     function totalSupply() external view returns (uint256);
280 
281     /**
282      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
283      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
284      */
285     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
286 
287     /**
288      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
289      * Use along with {totalSupply} to enumerate all tokens.
290      */
291     function tokenByIndex(uint256 index) external view returns (uint256);
292 }
293 
294 
295 
296 
297 // File: @openzeppelin/contracts@4.2.0/utils/introspection/ERC165.sol
298 
299 pragma solidity ^0.8.0;
300 
301 
302 /**
303  * @dev Implementation of the {IERC165} interface.
304  *
305  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
306  * for the additional interface id that will be supported. For example:
307  *
308  * ```solidity
309  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
310  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
311  * }
312  * ```
313  *
314  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
315  */
316 abstract contract ERC165 is IERC165 {
317     /**
318      * @dev See {IERC165-supportsInterface}.
319      */
320     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
321         return interfaceId == type(IERC165).interfaceId;
322     }
323 }
324 
325 // File: @openzeppelin/contracts@4.2.0/utils/Strings.sol
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev String operations.
331  */
332 library Strings {
333     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
334 
335     /**
336      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
337      */
338     function toString(uint256 value) internal pure returns (string memory) {
339         // Inspired by OraclizeAPI's implementation - MIT licence
340         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
341 
342         if (value == 0) {
343             return "0";
344         }
345         uint256 temp = value;
346         uint256 digits;
347         while (temp != 0) {
348             digits++;
349             temp /= 10;
350         }
351         bytes memory buffer = new bytes(digits);
352         while (value != 0) {
353             digits -= 1;
354             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
355             value /= 10;
356         }
357         return string(buffer);
358     }
359 
360     /**
361      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
362      */
363     function toHexString(uint256 value) internal pure returns (string memory) {
364         if (value == 0) {
365             return "0x00";
366         }
367         uint256 temp = value;
368         uint256 length = 0;
369         while (temp != 0) {
370             length++;
371             temp >>= 8;
372         }
373         return toHexString(value, length);
374     }
375 
376     /**
377      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
378      */
379     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
380         bytes memory buffer = new bytes(2 * length + 2);
381         buffer[0] = "0";
382         buffer[1] = "x";
383         for (uint256 i = 2 * length + 1; i > 1; --i) {
384             buffer[i] = _HEX_SYMBOLS[value & 0xf];
385             value >>= 4;
386         }
387         require(value == 0, "Strings: hex length insufficient");
388         return string(buffer);
389     }
390 }
391 
392 
393 // File: @openzeppelin/contracts@4.2.0/utils/Address.sol
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @dev Collection of functions related to the address type
399  */
400 library Address {
401     /**
402      * @dev Returns true if `account` is a contract.
403      *
404      * [IMPORTANT]
405      * ====
406      * It is unsafe to assume that an address for which this function returns
407      * false is an externally-owned account (EOA) and not a contract.
408      *
409      * Among others, `isContract` will return false for the following
410      * types of addresses:
411      *
412      *  - an externally-owned account
413      *  - a contract in construction
414      *  - an address where a contract will be created
415      *  - an address where a contract lived, but was destroyed
416      * ====
417      */
418     function isContract(address account) internal view returns (bool) {
419         // This method relies on extcodesize, which returns 0 for contracts in
420         // construction, since the code is only stored at the end of the
421         // constructor execution.
422 
423         uint256 size;
424         assembly {
425             size := extcodesize(account)
426         }
427         return size > 0;
428     }
429 
430     /**
431      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
432      * `recipient`, forwarding all available gas and reverting on errors.
433      *
434      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
435      * of certain opcodes, possibly making contracts go over the 2300 gas limit
436      * imposed by `transfer`, making them unable to receive funds via
437      * `transfer`. {sendValue} removes this limitation.
438      *
439      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
440      *
441      * IMPORTANT: because control is transferred to `recipient`, care must be
442      * taken to not create reentrancy vulnerabilities. Consider using
443      * {ReentrancyGuard} or the
444      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
445      */
446     function sendValue(address payable recipient, uint256 amount) internal {
447         require(address(this).balance >= amount, "Address: insufficient balance");
448 
449         (bool success, ) = recipient.call{value: amount}("");
450         require(success, "Address: unable to send value, recipient may have reverted");
451     }
452 
453     /**
454      * @dev Performs a Solidity function call using a low level `call`. A
455      * plain `call` is an unsafe replacement for a function call: use this
456      * function instead.
457      *
458      * If `target` reverts with a revert reason, it is bubbled up by this
459      * function (like regular Solidity function calls).
460      *
461      * Returns the raw returned data. To convert to the expected return value,
462      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
463      *
464      * Requirements:
465      *
466      * - `target` must be a contract.
467      * - calling `target` with `data` must not revert.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
472         return functionCall(target, data, "Address: low-level call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
477      * `errorMessage` as a fallback revert reason when `target` reverts.
478      *
479      * _Available since v3.1._
480      */
481     function functionCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal returns (bytes memory) {
486         return functionCallWithValue(target, data, 0, errorMessage);
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
491      * but also transferring `value` wei to `target`.
492      *
493      * Requirements:
494      *
495      * - the calling contract must have an ETH balance of at least `value`.
496      * - the called Solidity function must be `payable`.
497      *
498      * _Available since v3.1._
499      */
500     function functionCallWithValue(
501         address target,
502         bytes memory data,
503         uint256 value
504     ) internal returns (bytes memory) {
505         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
510      * with `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(
515         address target,
516         bytes memory data,
517         uint256 value,
518         string memory errorMessage
519     ) internal returns (bytes memory) {
520         require(address(this).balance >= value, "Address: insufficient balance for call");
521         require(isContract(target), "Address: call to non-contract");
522 
523         (bool success, bytes memory returndata) = target.call{value: value}(data);
524         return _verifyCallResult(success, returndata, errorMessage);
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
529      * but performing a static call.
530      *
531      * _Available since v3.3._
532      */
533     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
534         return functionStaticCall(target, data, "Address: low-level static call failed");
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
539      * but performing a static call.
540      *
541      * _Available since v3.3._
542      */
543     function functionStaticCall(
544         address target,
545         bytes memory data,
546         string memory errorMessage
547     ) internal view returns (bytes memory) {
548         require(isContract(target), "Address: static call to non-contract");
549 
550         (bool success, bytes memory returndata) = target.staticcall(data);
551         return _verifyCallResult(success, returndata, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but performing a delegate call.
557      *
558      * _Available since v3.4._
559      */
560     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
561         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a delegate call.
567      *
568      * _Available since v3.4._
569      */
570     function functionDelegateCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal returns (bytes memory) {
575         require(isContract(target), "Address: delegate call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.delegatecall(data);
578         return _verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     function _verifyCallResult(
582         bool success,
583         bytes memory returndata,
584         string memory errorMessage
585     ) private pure returns (bytes memory) {
586         if (success) {
587             return returndata;
588         } else {
589             // Look for revert reason and bubble it up if present
590             if (returndata.length > 0) {
591                 // The easiest way to bubble the revert reason is using memory via assembly
592 
593                 assembly {
594                     let returndata_size := mload(returndata)
595                     revert(add(32, returndata), returndata_size)
596                 }
597             } else {
598                 revert(errorMessage);
599             }
600         }
601     }
602 }
603 
604 // File: @openzeppelin/contracts@4.2.0/token/ERC721/extensions/IERC721Metadata.sol
605 
606 pragma solidity ^0.8.0;
607 
608 
609 /**
610  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
611  * @dev See https://eips.ethereum.org/EIPS/eip-721
612  */
613 interface IERC721Metadata is IERC721 {
614     /**
615      * @dev Returns the token collection name.
616      */
617     function name() external view returns (string memory);
618 
619     /**
620      * @dev Returns the token collection symbol.
621      */
622     function symbol() external view returns (string memory);
623 
624     /**
625      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
626      */
627     function tokenURI(uint256 tokenId) external view returns (string memory);
628 }
629 
630 // File: @openzeppelin/contracts@4.2.0/token/ERC721/IERC721Receiver.sol
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @title ERC721 token receiver interface
636  * @dev Interface for any contract that wants to support safeTransfers
637  * from ERC721 asset contracts.
638  */
639 interface IERC721Receiver {
640     /**
641      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
642      * by `operator` from `from`, this function is called.
643      *
644      * It must return its Solidity selector to confirm the token transfer.
645      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
646      *
647      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
648      */
649     function onERC721Received(
650         address operator,
651         address from,
652         uint256 tokenId,
653         bytes calldata data
654     ) external returns (bytes4);
655 }
656 
657 // File: @openzeppelin/contracts@4.2.0/token/ERC721/ERC721.sol
658 
659 pragma solidity ^0.8.0;
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
784         require(operator != _msgSender(), "ERC721: approve to caller");
785 
786         _operatorApprovals[_msgSender()][operator] = approved;
787         emit ApprovalForAll(_msgSender(), operator, approved);
788     }
789 
790     /**
791      * @dev See {IERC721-isApprovedForAll}.
792      */
793     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
794         return _operatorApprovals[owner][operator];
795     }
796 
797     /**
798      * @dev See {IERC721-transferFrom}.
799      */
800     function transferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) public virtual override {
805         //solhint-disable-next-line max-line-length
806         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
807 
808         _transfer(from, to, tokenId);
809     }
810 
811     /**
812      * @dev See {IERC721-safeTransferFrom}.
813      */
814     function safeTransferFrom(
815         address from,
816         address to,
817         uint256 tokenId
818     ) public virtual override {
819         safeTransferFrom(from, to, tokenId, "");
820     }
821 
822     /**
823      * @dev See {IERC721-safeTransferFrom}.
824      */
825     function safeTransferFrom(
826         address from,
827         address to,
828         uint256 tokenId,
829         bytes memory _data
830     ) public virtual override {
831         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
832         _safeTransfer(from, to, tokenId, _data);
833     }
834 
835     /**
836      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
837      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
838      *
839      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
840      *
841      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
842      * implement alternative mechanisms to perform token transfer, such as signature-based.
843      *
844      * Requirements:
845      *
846      * - `from` cannot be the zero address.
847      * - `to` cannot be the zero address.
848      * - `tokenId` token must exist and be owned by `from`.
849      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _safeTransfer(
854         address from,
855         address to,
856         uint256 tokenId,
857         bytes memory _data
858     ) internal virtual {
859         _transfer(from, to, tokenId);
860         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
861     }
862 
863     /**
864      * @dev Returns whether `tokenId` exists.
865      *
866      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
867      *
868      * Tokens start existing when they are minted (`_mint`),
869      * and stop existing when they are burned (`_burn`).
870      */
871     function _exists(uint256 tokenId) internal view virtual returns (bool) {
872         return _owners[tokenId] != address(0);
873     }
874 
875     /**
876      * @dev Returns whether `spender` is allowed to manage `tokenId`.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must exist.
881      */
882     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
883         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
884         address owner = ERC721.ownerOf(tokenId);
885         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
886     }
887 
888     /**
889      * @dev Safely mints `tokenId` and transfers it to `to`.
890      *
891      * Requirements:
892      *
893      * - `tokenId` must not exist.
894      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _safeMint(address to, uint256 tokenId) internal virtual {
899         _safeMint(to, tokenId, "");
900     }
901 
902     /**
903      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
904      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
905      */
906     function _safeMint(
907         address to,
908         uint256 tokenId,
909         bytes memory _data
910     ) internal virtual {
911         _mint(to, tokenId);
912         require(
913             _checkOnERC721Received(address(0), to, tokenId, _data),
914             "ERC721: transfer to non ERC721Receiver implementer"
915         );
916     }
917 
918     /**
919      * @dev Mints `tokenId` and transfers it to `to`.
920      *
921      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
922      *
923      * Requirements:
924      *
925      * - `tokenId` must not exist.
926      * - `to` cannot be the zero address.
927      *
928      * Emits a {Transfer} event.
929      */
930     function _mint(address to, uint256 tokenId) internal virtual {
931         require(to != address(0), "ERC721: mint to the zero address");
932         require(!_exists(tokenId), "ERC721: token already minted");
933 
934         _beforeTokenTransfer(address(0), to, tokenId);
935 
936         _balances[to] += 1;
937         _owners[tokenId] = to;
938 
939         emit Transfer(address(0), to, tokenId);
940     }
941 
942     /**
943      * @dev Destroys `tokenId`.
944      * The approval is cleared when the token is burned.
945      *
946      * Requirements:
947      *
948      * - `tokenId` must exist.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _burn(uint256 tokenId) internal virtual {
953         address owner = ERC721.ownerOf(tokenId);
954 
955         _beforeTokenTransfer(owner, address(0), tokenId);
956 
957         // Clear approvals
958         _approve(address(0), tokenId);
959 
960         _balances[owner] -= 1;
961         delete _owners[tokenId];
962 
963         emit Transfer(owner, address(0), tokenId);
964     }
965 
966     /**
967      * @dev Transfers `tokenId` from `from` to `to`.
968      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
969      *
970      * Requirements:
971      *
972      * - `to` cannot be the zero address.
973      * - `tokenId` token must be owned by `from`.
974      *
975      * Emits a {Transfer} event.
976      */
977     function _transfer(
978         address from,
979         address to,
980         uint256 tokenId
981     ) internal virtual {
982         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
983         require(to != address(0), "ERC721: transfer to the zero address");
984 
985         _beforeTokenTransfer(from, to, tokenId);
986 
987         // Clear approvals from the previous owner
988         _approve(address(0), tokenId);
989 
990         _balances[from] -= 1;
991         _balances[to] += 1;
992         _owners[tokenId] = to;
993 
994         emit Transfer(from, to, tokenId);
995     }
996 
997     /**
998      * @dev Approve `to` to operate on `tokenId`
999      *
1000      * Emits a {Approval} event.
1001      */
1002     function _approve(address to, uint256 tokenId) internal virtual {
1003         _tokenApprovals[tokenId] = to;
1004         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1009      * The call is not executed if the target address is not a contract.
1010      *
1011      * @param from address representing the previous owner of the given token ID
1012      * @param to target address that will receive the tokens
1013      * @param tokenId uint256 ID of the token to be transferred
1014      * @param _data bytes optional data to send along with the call
1015      * @return bool whether the call correctly returned the expected magic value
1016      */
1017     function _checkOnERC721Received(
1018         address from,
1019         address to,
1020         uint256 tokenId,
1021         bytes memory _data
1022     ) private returns (bool) {
1023         if (to.isContract()) {
1024             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1025                 return retval == IERC721Receiver(to).onERC721Received.selector;
1026             } catch (bytes memory reason) {
1027                 if (reason.length == 0) {
1028                     revert("ERC721: transfer to non ERC721Receiver implementer");
1029                 } else {
1030                     assembly {
1031                         revert(add(32, reason), mload(reason))
1032                     }
1033                 }
1034             }
1035         } else {
1036             return true;
1037         }
1038     }
1039 
1040     /**
1041      * @dev Hook that is called before any token transfer. This includes minting
1042      * and burning.
1043      *
1044      * Calling conditions:
1045      *
1046      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1047      * transferred to `to`.
1048      * - When `from` is zero, `tokenId` will be minted for `to`.
1049      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1050      * - `from` and `to` are never both zero.
1051      *
1052      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1053      */
1054     function _beforeTokenTransfer(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) internal virtual {}
1059 }
1060 
1061 // File: @openzeppelin/contracts@4.2.0/token/ERC721/extensions/ERC721Enumerable.sol
1062 
1063 pragma solidity ^0.8.0;
1064 
1065 
1066 
1067 /**
1068  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1069  * enumerability of all the token ids in the contract as well as all token ids owned by each
1070  * account.
1071  */
1072 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1073     // Mapping from owner to list of owned token IDs
1074     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1075 
1076     // Mapping from token ID to index of the owner tokens list
1077     mapping(uint256 => uint256) private _ownedTokensIndex;
1078 
1079     // Array with all token ids, used for enumeration
1080     uint256[] private _allTokens;
1081 
1082     // Mapping from token id to position in the allTokens array
1083     mapping(uint256 => uint256) private _allTokensIndex;
1084 
1085     /**
1086      * @dev See {IERC165-supportsInterface}.
1087      */
1088     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1089         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1090     }
1091 
1092     /**
1093      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1094      */
1095     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1096         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1097         return _ownedTokens[owner][index];
1098     }
1099 
1100     /**
1101      * @dev See {IERC721Enumerable-totalSupply}.
1102      */
1103     function totalSupply() public view virtual override returns (uint256) {
1104         return _allTokens.length;
1105     }
1106 
1107     /**
1108      * @dev See {IERC721Enumerable-tokenByIndex}.
1109      */
1110     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1111         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1112         return _allTokens[index];
1113     }
1114 
1115     /**
1116      * @dev Hook that is called before any token transfer. This includes minting
1117      * and burning.
1118      *
1119      * Calling conditions:
1120      *
1121      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1122      * transferred to `to`.
1123      * - When `from` is zero, `tokenId` will be minted for `to`.
1124      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1125      * - `from` cannot be the zero address.
1126      * - `to` cannot be the zero address.
1127      *
1128      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1129      */
1130     function _beforeTokenTransfer(
1131         address from,
1132         address to,
1133         uint256 tokenId
1134     ) internal virtual override {
1135         super._beforeTokenTransfer(from, to, tokenId);
1136 
1137         if (from == address(0)) {
1138             _addTokenToAllTokensEnumeration(tokenId);
1139         } else if (from != to) {
1140             _removeTokenFromOwnerEnumeration(from, tokenId);
1141         }
1142         if (to == address(0)) {
1143             _removeTokenFromAllTokensEnumeration(tokenId);
1144         } else if (to != from) {
1145             _addTokenToOwnerEnumeration(to, tokenId);
1146         }
1147     }
1148 
1149     /**
1150      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1151      * @param to address representing the new owner of the given token ID
1152      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1153      */
1154     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1155         uint256 length = ERC721.balanceOf(to);
1156         _ownedTokens[to][length] = tokenId;
1157         _ownedTokensIndex[tokenId] = length;
1158     }
1159 
1160     /**
1161      * @dev Private function to add a token to this extension's token tracking data structures.
1162      * @param tokenId uint256 ID of the token to be added to the tokens list
1163      */
1164     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1165         _allTokensIndex[tokenId] = _allTokens.length;
1166         _allTokens.push(tokenId);
1167     }
1168 
1169     /**
1170      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1171      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1172      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1173      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1174      * @param from address representing the previous owner of the given token ID
1175      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1176      */
1177     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1178         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1179         // then delete the last slot (swap and pop).
1180 
1181         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1182         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1183 
1184         // When the token to delete is the last token, the swap operation is unnecessary
1185         if (tokenIndex != lastTokenIndex) {
1186             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1187 
1188             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1189             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1190         }
1191 
1192         // This also deletes the contents at the last position of the array
1193         delete _ownedTokensIndex[tokenId];
1194         delete _ownedTokens[from][lastTokenIndex];
1195     }
1196 
1197     /**
1198      * @dev Private function to remove a token from this extension's token tracking data structures.
1199      * This has O(1) time complexity, but alters the order of the _allTokens array.
1200      * @param tokenId uint256 ID of the token to be removed from the tokens list
1201      */
1202     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1203         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1204         // then delete the last slot (swap and pop).
1205 
1206         uint256 lastTokenIndex = _allTokens.length - 1;
1207         uint256 tokenIndex = _allTokensIndex[tokenId];
1208 
1209         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1210         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1211         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1212         uint256 lastTokenId = _allTokens[lastTokenIndex];
1213 
1214         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1215         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1216 
1217         // This also deletes the contents at the last position of the array
1218         delete _allTokensIndex[tokenId];
1219         _allTokens.pop();
1220     }
1221 }
1222 
1223 // File: @openzeppelin/contracts@4.2.0/utils/math/SafeMath.sol
1224 
1225 pragma solidity ^0.8.0;
1226 
1227 // CAUTION
1228 // This version of SafeMath should only be used with Solidity 0.8 or later,
1229 // because it relies on the compiler's built in overflow checks.
1230 
1231 /**
1232  * @dev Wrappers over Solidity's arithmetic operations.
1233  *
1234  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1235  * now has built in overflow checking.
1236  */
1237 library SafeMath {
1238     /**
1239      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1240      *
1241      * _Available since v3.4._
1242      */
1243     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1244         unchecked {
1245             uint256 c = a + b;
1246             if (c < a) return (false, 0);
1247             return (true, c);
1248         }
1249     }
1250 
1251     /**
1252      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1253      *
1254      * _Available since v3.4._
1255      */
1256     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1257         unchecked {
1258             if (b > a) return (false, 0);
1259             return (true, a - b);
1260         }
1261     }
1262 
1263     /**
1264      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1265      *
1266      * _Available since v3.4._
1267      */
1268     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1269         unchecked {
1270             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1271             // benefit is lost if 'b' is also tested.
1272             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1273             if (a == 0) return (true, 0);
1274             uint256 c = a * b;
1275             if (c / a != b) return (false, 0);
1276             return (true, c);
1277         }
1278     }
1279 
1280     /**
1281      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1282      *
1283      * _Available since v3.4._
1284      */
1285     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1286         unchecked {
1287             if (b == 0) return (false, 0);
1288             return (true, a / b);
1289         }
1290     }
1291 
1292     /**
1293      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1294      *
1295      * _Available since v3.4._
1296      */
1297     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1298         unchecked {
1299             if (b == 0) return (false, 0);
1300             return (true, a % b);
1301         }
1302     }
1303 
1304     /**
1305      * @dev Returns the addition of two unsigned integers, reverting on
1306      * overflow.
1307      *
1308      * Counterpart to Solidity's `+` operator.
1309      *
1310      * Requirements:
1311      *
1312      * - Addition cannot overflow.
1313      */
1314     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1315         return a + b;
1316     }
1317 
1318     /**
1319      * @dev Returns the subtraction of two unsigned integers, reverting on
1320      * overflow (when the result is negative).
1321      *
1322      * Counterpart to Solidity's `-` operator.
1323      *
1324      * Requirements:
1325      *
1326      * - Subtraction cannot overflow.
1327      */
1328     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1329         return a - b;
1330     }
1331 
1332     /**
1333      * @dev Returns the multiplication of two unsigned integers, reverting on
1334      * overflow.
1335      *
1336      * Counterpart to Solidity's `*` operator.
1337      *
1338      * Requirements:
1339      *
1340      * - Multiplication cannot overflow.
1341      */
1342     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1343         return a * b;
1344     }
1345 
1346     /**
1347      * @dev Returns the integer division of two unsigned integers, reverting on
1348      * division by zero. The result is rounded towards zero.
1349      *
1350      * Counterpart to Solidity's `/` operator.
1351      *
1352      * Requirements:
1353      *
1354      * - The divisor cannot be zero.
1355      */
1356     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1357         return a / b;
1358     }
1359 
1360     /**
1361      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1362      * reverting when dividing by zero.
1363      *
1364      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1365      * opcode (which leaves remaining gas untouched) while Solidity uses an
1366      * invalid opcode to revert (consuming all remaining gas).
1367      *
1368      * Requirements:
1369      *
1370      * - The divisor cannot be zero.
1371      */
1372     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1373         return a % b;
1374     }
1375 
1376     /**
1377      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1378      * overflow (when the result is negative).
1379      *
1380      * CAUTION: This function is deprecated because it requires allocating memory for the error
1381      * message unnecessarily. For custom revert reasons use {trySub}.
1382      *
1383      * Counterpart to Solidity's `-` operator.
1384      *
1385      * Requirements:
1386      *
1387      * - Subtraction cannot overflow.
1388      */
1389     function sub(
1390         uint256 a,
1391         uint256 b,
1392         string memory errorMessage
1393     ) internal pure returns (uint256) {
1394         unchecked {
1395             require(b <= a, errorMessage);
1396             return a - b;
1397         }
1398     }
1399 
1400     /**
1401      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1402      * division by zero. The result is rounded towards zero.
1403      *
1404      * Counterpart to Solidity's `/` operator. Note: this function uses a
1405      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1406      * uses an invalid opcode to revert (consuming all remaining gas).
1407      *
1408      * Requirements:
1409      *
1410      * - The divisor cannot be zero.
1411      */
1412     function div(
1413         uint256 a,
1414         uint256 b,
1415         string memory errorMessage
1416     ) internal pure returns (uint256) {
1417         unchecked {
1418             require(b > 0, errorMessage);
1419             return a / b;
1420         }
1421     }
1422 
1423     /**
1424      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1425      * reverting with custom message when dividing by zero.
1426      *
1427      * CAUTION: This function is deprecated because it requires allocating memory for the error
1428      * message unnecessarily. For custom revert reasons use {tryMod}.
1429      *
1430      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1431      * opcode (which leaves remaining gas untouched) while Solidity uses an
1432      * invalid opcode to revert (consuming all remaining gas).
1433      *
1434      * Requirements:
1435      *
1436      * - The divisor cannot be zero.
1437      */
1438     function mod(
1439         uint256 a,
1440         uint256 b,
1441         string memory errorMessage
1442     ) internal pure returns (uint256) {
1443         unchecked {
1444             require(b > 0, errorMessage);
1445             return a % b;
1446         }
1447     }
1448 }
1449 
1450 // File: paymentsplit.sol
1451 
1452 pragma solidity ^0.8.0;
1453 
1454 contract HoboBeardClub is ERC721Enumerable, Ownable {
1455     using SafeMath for uint256;
1456     string public BEARDO_PROVENANCE;
1457     string private baseURI;
1458     uint256 public constant price = 80000000000000000;
1459     uint16 public MAX_BEARDOS = 10000;
1460     bool public saleIsActive = false;
1461     // 25% TO THE COMMUNITY WALLET
1462     address cwpayment = 0x25c9DE88361b2E83f7C82446C7CCca2a369327dd;
1463     
1464     /*     
1465     * Holy Beardo Genesis
1466     */
1467     constructor(string memory uri) ERC721("HoboBeardClub", "HBC") {
1468       setBaseURI(uri);
1469     }
1470     
1471     /*     
1472     * Creation. Just mint yourself a beardo.
1473     */
1474     function mintMyBeardo(address _to, uint _count) public payable {
1475         require(saleIsActive, "Sale is not active yet");
1476         require(totalSupply() < MAX_BEARDOS, "Sale has ended");
1477         require(totalSupply().add(_count) <= MAX_BEARDOS, "Purchase amount exceeds supply");
1478         require(_count <= 20, "You can only mint 20 beardos per tx");
1479         require(msg.value >= price.mul(_count), "Value below price");
1480         for(uint i = 0; i < _count; i++){
1481             _safeMint(_to, totalSupply());
1482         }
1483     }
1484     
1485     /*
1486     * Light. The beardos might burn.
1487     */
1488     function burnBeardos() public onlyOwner {
1489         MAX_BEARDOS = uint16(totalSupply());
1490     }
1491     
1492     /*     
1493     * Truth. Set provenance once it's calculated.
1494     */
1495     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1496         BEARDO_PROVENANCE = provenanceHash;
1497     }
1498     
1499     /*     
1500     * Seed. Start sale.
1501     */
1502     function flipSaleState() public onlyOwner {
1503         saleIsActive = !saleIsActive;
1504     }
1505     
1506     /*
1507     * Growth. Set some beardos aside for giveaways and anyone who helped us along the way.
1508     */
1509     function reserveTokens() public onlyOwner {
1510         require(totalSupply() == 0);
1511         for (uint i = 0; i < 30; i++) {
1512             _safeMint(msg.sender, i);
1513         }
1514     }
1515     
1516     function withdrawAll() public payable onlyOwner {
1517         require(payable(cwpayment).send(address(this).balance));
1518     }
1519 
1520     function _baseURI() internal view override returns (string memory) {
1521       return baseURI;
1522     }
1523     
1524     function setBaseURI(string memory uri) public onlyOwner {
1525       baseURI = uri;
1526     }
1527 
1528 }