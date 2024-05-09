1 // SPDX-License-Identifier: GPL-3.0
2 
3 // www.KidKongz.com
4 
5 // Ooo-oo-ah-ah! 4,000 Kid Kongz looking for their Daddies.
6 
7 // www.discord.gg/KidKongz
8 // www.twitter.com/KidKongz
9 
10 // File: @openzeppelin/contracts/utils/Strings.sol
11 
12 pragma solidity ^0.8.0;
13 
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     function toString(uint256 value) internal pure returns (string memory) {
18 
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
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
51     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
52         bytes memory buffer = new bytes(2 * length + 2);
53         buffer[0] = "0";
54         buffer[1] = "x";
55         for (uint256 i = 2 * length + 1; i > 1; --i) {
56             buffer[i] = _HEX_SYMBOLS[value & 0xf];
57             value >>= 4;
58         }
59         require(value == 0, "Strings: hex length insufficient");
60         return string(buffer);
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/Context.sol
65 
66 
67 
68 pragma solidity ^0.8.0;
69 
70 abstract contract Context {
71     function _msgSender() internal view virtual returns (address) {
72         return msg.sender;
73     }
74 
75     function _msgData() internal view virtual returns (bytes calldata) {
76         return msg.data;
77     }
78 }
79 
80 // File: @openzeppelin/contracts/access/Ownable.sol
81 
82 
83 
84 pragma solidity ^0.8.0;
85 
86 
87 abstract contract Ownable is Context {
88     address private _owner;
89 
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92 
93     constructor() {
94         _setOwner(_msgSender());
95     }
96 
97     function owner() public view virtual returns (address) {
98         return _owner;
99     }
100 
101     modifier onlyOwner() {
102         require(owner() == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106 
107     function renounceOwnership() public virtual onlyOwner {
108         _setOwner(address(0));
109     }
110 
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         _setOwner(newOwner);
114     }
115 
116     function _setOwner(address newOwner) private {
117         address oldOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(oldOwner, newOwner);
120     }
121 }
122 
123 // File: @openzeppelin/contracts/utils/Address.sol
124 
125 
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Collection of functions related to the address type
131  */
132 library Address {
133     /**
134      * @dev Returns true if `account` is a contract.
135      *
136      * [IMPORTANT]
137      * ====
138      * It is unsafe to assume that an address for which this function returns
139      * false is an externally-owned account (EOA) and not a contract.
140      *
141      * Among others, `isContract` will return false for the following
142      * types of addresses:
143      *
144      *  - an externally-owned account
145      *  - a contract in construction
146      *  - an address where a contract will be created
147      *  - an address where a contract lived, but was destroyed
148      * ====
149      */
150     function isContract(address account) internal view returns (bool) {
151         // This method relies on extcodesize, which returns 0 for contracts in
152         // construction, since the code is only stored at the end of the
153         // constructor execution.
154 
155         uint256 size;
156         assembly {
157             size := extcodesize(account)
158         }
159         return size > 0;
160     }
161 
162     /**
163      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
164      * `recipient`, forwarding all available gas and reverting on errors.
165      *
166      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
167      * of certain opcodes, possibly making contracts go over the 2300 gas limit
168      * imposed by `transfer`, making them unable to receive funds via
169      * `transfer`. {sendValue} removes this limitation.
170      *
171      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
172      *
173      * IMPORTANT: because control is transferred to `recipient`, care must be
174      * taken to not create reentrancy vulnerabilities. Consider using
175      * {ReentrancyGuard} or the
176      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
177      */
178     function sendValue(address payable recipient, uint256 amount) internal {
179         require(address(this).balance >= amount, "Address: insufficient balance");
180 
181         (bool success, ) = recipient.call{value: amount}("");
182         require(success, "Address: unable to send value, recipient may have reverted");
183     }
184 
185     /**
186      * @dev Performs a Solidity function call using a low level `call`. A
187      * plain `call` is an unsafe replacement for a function call: use this
188      * function instead.
189      *
190      * If `target` reverts with a revert reason, it is bubbled up by this
191      * function (like regular Solidity function calls).
192      *
193      * Returns the raw returned data. To convert to the expected return value,
194      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
195      *
196      * Requirements:
197      *
198      * - `target` must be a contract.
199      * - calling `target` with `data` must not revert.
200      *
201      * _Available since v3.1._
202      */
203     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
204         return functionCall(target, data, "Address: low-level call failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
209      * `errorMessage` as a fallback revert reason when `target` reverts.
210      *
211      * _Available since v3.1._
212      */
213     function functionCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, 0, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but also transferring `value` wei to `target`.
224      *
225      * Requirements:
226      *
227      * - the calling contract must have an ETH balance of at least `value`.
228      * - the called Solidity function must be `payable`.
229      *
230      * _Available since v3.1._
231      */
232     function functionCallWithValue(
233         address target,
234         bytes memory data,
235         uint256 value
236     ) internal returns (bytes memory) {
237         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
242      * with `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCallWithValue(
247         address target,
248         bytes memory data,
249         uint256 value,
250         string memory errorMessage
251     ) internal returns (bytes memory) {
252         require(address(this).balance >= value, "Address: insufficient balance for call");
253         require(isContract(target), "Address: call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.call{value: value}(data);
256         return verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
261      * but performing a static call.
262      *
263      * _Available since v3.3._
264      */
265     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
266         return functionStaticCall(target, data, "Address: low-level static call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
271      * but performing a static call.
272      *
273      * _Available since v3.3._
274      */
275     function functionStaticCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal view returns (bytes memory) {
280         require(isContract(target), "Address: static call to non-contract");
281 
282         (bool success, bytes memory returndata) = target.staticcall(data);
283         return verifyCallResult(success, returndata, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but performing a delegate call.
289      *
290      * _Available since v3.4._
291      */
292     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
293         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
298      * but performing a delegate call.
299      *
300      * _Available since v3.4._
301      */
302     function functionDelegateCall(
303         address target,
304         bytes memory data,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(isContract(target), "Address: delegate call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.delegatecall(data);
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
315      * revert reason using the provided one.
316      *
317      * _Available since v4.3._
318      */
319     function verifyCallResult(
320         bool success,
321         bytes memory returndata,
322         string memory errorMessage
323     ) internal pure returns (bytes memory) {
324         if (success) {
325             return returndata;
326         } else {
327             // Look for revert reason and bubble it up if present
328             if (returndata.length > 0) {
329                 // The easiest way to bubble the revert reason is using memory via assembly
330 
331                 assembly {
332                     let returndata_size := mload(returndata)
333                     revert(add(32, returndata), returndata_size)
334                 }
335             } else {
336                 revert(errorMessage);
337             }
338         }
339     }
340 }
341 
342 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
343 
344 
345 
346 pragma solidity ^0.8.0;
347 
348 /**
349  * @title ERC721 token receiver interface
350  * @dev Interface for any contract that wants to support safeTransfers
351  * from ERC721 asset contracts.
352  */
353 interface IERC721Receiver {
354     /**
355      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
356      * by `operator` from `from`, this function is called.
357      *
358      * It must return its Solidity selector to confirm the token transfer.
359      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
360      *
361      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
362      */
363     function onERC721Received(
364         address operator,
365         address from,
366         uint256 tokenId,
367         bytes calldata data
368     ) external returns (bytes4);
369 }
370 
371 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
372 
373 
374 
375 pragma solidity ^0.8.0;
376 
377 /**
378  * @dev Interface of the ERC165 standard, as defined in the
379  * https://eips.ethereum.org/EIPS/eip-165[EIP].
380  *
381  * Implementers can declare support of contract interfaces, which can then be
382  * queried by others ({ERC165Checker}).
383  *
384  * For an implementation, see {ERC165}.
385  */
386 interface IERC165 {
387     /**
388      * @dev Returns true if this contract implements the interface defined by
389      * `interfaceId`. See the corresponding
390      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
391      * to learn more about how these ids are created.
392      *
393      * This function call must use less than 30 000 gas.
394      */
395     function supportsInterface(bytes4 interfaceId) external view returns (bool);
396 }
397 
398 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
399 
400 
401 
402 pragma solidity ^0.8.0;
403 
404 
405 /**
406  * @dev Implementation of the {IERC165} interface.
407  *
408  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
409  * for the additional interface id that will be supported. For example:
410  *
411  * ```solidity
412  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
413  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
414  * }
415  * ```
416  *
417  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
418  */
419 abstract contract ERC165 is IERC165 {
420     /**
421      * @dev See {IERC165-supportsInterface}.
422      */
423     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
424         return interfaceId == type(IERC165).interfaceId;
425     }
426 }
427 
428 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
429 
430 
431 
432 pragma solidity ^0.8.0;
433 
434 
435 /**
436  * @dev Required interface of an ERC721 compliant contract.
437  */
438 interface IERC721 is IERC165 {
439     /**
440      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
441      */
442     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
443 
444     /**
445      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
446      */
447     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
448 
449     /**
450      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
451      */
452     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
453 
454     /**
455      * @dev Returns the number of tokens in ``owner``'s account.
456      */
457     function balanceOf(address owner) external view returns (uint256 balance);
458 
459     /**
460      * @dev Returns the owner of the `tokenId` token.
461      *
462      * Requirements:
463      *
464      * - `tokenId` must exist.
465      */
466     function ownerOf(uint256 tokenId) external view returns (address owner);
467 
468     /**
469      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
470      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
471      *
472      * Requirements:
473      *
474      * - `from` cannot be the zero address.
475      * - `to` cannot be the zero address.
476      * - `tokenId` token must exist and be owned by `from`.
477      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
478      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
479      *
480      * Emits a {Transfer} event.
481      */
482     function safeTransferFrom(
483         address from,
484         address to,
485         uint256 tokenId
486     ) external;
487 
488     /**
489      * @dev Transfers `tokenId` token from `from` to `to`.
490      *
491      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must be owned by `from`.
498      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
499      *
500      * Emits a {Transfer} event.
501      */
502     function transferFrom(
503         address from,
504         address to,
505         uint256 tokenId
506     ) external;
507 
508     /**
509      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
510      * The approval is cleared when the token is transferred.
511      *
512      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
513      *
514      * Requirements:
515      *
516      * - The caller must own the token or be an approved operator.
517      * - `tokenId` must exist.
518      *
519      * Emits an {Approval} event.
520      */
521     function approve(address to, uint256 tokenId) external;
522 
523     /**
524      * @dev Returns the account approved for `tokenId` token.
525      *
526      * Requirements:
527      *
528      * - `tokenId` must exist.
529      */
530     function getApproved(uint256 tokenId) external view returns (address operator);
531 
532     /**
533      * @dev Approve or remove `operator` as an operator for the caller.
534      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
535      *
536      * Requirements:
537      *
538      * - The `operator` cannot be the caller.
539      *
540      * Emits an {ApprovalForAll} event.
541      */
542     function setApprovalForAll(address operator, bool _approved) external;
543 
544     /**
545      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
546      *
547      * See {setApprovalForAll}
548      */
549     function isApprovedForAll(address owner, address operator) external view returns (bool);
550 
551     /**
552      * @dev Safely transfers `tokenId` token from `from` to `to`.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must exist and be owned by `from`.
559      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
560      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
561      *
562      * Emits a {Transfer} event.
563      */
564     function safeTransferFrom(
565         address from,
566         address to,
567         uint256 tokenId,
568         bytes calldata data
569     ) external;
570 }
571 
572 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
573 
574 
575 
576 pragma solidity ^0.8.0;
577 
578 
579 /**
580  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
581  * @dev See https://eips.ethereum.org/EIPS/eip-721
582  */
583 interface IERC721Enumerable is IERC721 {
584     /**
585      * @dev Returns the total amount of tokens stored by the contract.
586      */
587     function totalSupply() external view returns (uint256);
588 
589     /**
590      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
591      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
592      */
593     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
594 
595     /**
596      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
597      * Use along with {totalSupply} to enumerate all tokens.
598      */
599     function tokenByIndex(uint256 index) external view returns (uint256);
600 }
601 
602 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
603 
604 
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
630 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
631 
632 
633 
634 pragma solidity ^0.8.0;
635 
636 
637 
638 
639 
640 
641 
642 
643 /**
644  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
645  * the Metadata extension, but not including the Enumerable extension, which is available separately as
646  * {ERC721Enumerable}.
647  */
648 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
649     using Address for address;
650     using Strings for uint256;
651 
652     // Token name
653     string private _name;
654 
655     // Token symbol
656     string private _symbol;
657 
658     // Mapping from token ID to owner address
659     mapping(uint256 => address) private _owners;
660 
661     // Mapping owner address to token count
662     mapping(address => uint256) private _balances;
663 
664     // Mapping from token ID to approved address
665     mapping(uint256 => address) private _tokenApprovals;
666 
667     // Mapping from owner to operator approvals
668     mapping(address => mapping(address => bool)) private _operatorApprovals;
669 
670     /**
671      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
672      */
673     constructor(string memory name_, string memory symbol_) {
674         _name = name_;
675         _symbol = symbol_;
676     }
677 
678     /**
679      * @dev See {IERC165-supportsInterface}.
680      */
681     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
682         return
683             interfaceId == type(IERC721).interfaceId ||
684             interfaceId == type(IERC721Metadata).interfaceId ||
685             super.supportsInterface(interfaceId);
686     }
687 
688     /**
689      * @dev See {IERC721-balanceOf}.
690      */
691     function balanceOf(address owner) public view virtual override returns (uint256) {
692         require(owner != address(0), "ERC721: balance query for the zero address");
693         return _balances[owner];
694     }
695 
696     /**
697      * @dev See {IERC721-ownerOf}.
698      */
699     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
700         address owner = _owners[tokenId];
701         require(owner != address(0), "ERC721: owner query for nonexistent token");
702         return owner;
703     }
704 
705     /**
706      * @dev See {IERC721Metadata-name}.
707      */
708     function name() public view virtual override returns (string memory) {
709         return _name;
710     }
711 
712     /**
713      * @dev See {IERC721Metadata-symbol}.
714      */
715     function symbol() public view virtual override returns (string memory) {
716         return _symbol;
717     }
718 
719     /**
720      * @dev See {IERC721Metadata-tokenURI}.
721      */
722     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
723         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
724 
725         string memory baseURI = _baseURI();
726         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
727     }
728 
729     /**
730      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
731      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
732      * by default, can be overriden in child contracts.
733      */
734     function _baseURI() internal view virtual returns (string memory) {
735         return "";
736     }
737 
738     /**
739      * @dev See {IERC721-approve}.
740      */
741     function approve(address to, uint256 tokenId) public virtual override {
742         address owner = ERC721.ownerOf(tokenId);
743         require(to != owner, "ERC721: approval to current owner");
744 
745         require(
746             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
747             "ERC721: approve caller is not owner nor approved for all"
748         );
749 
750         _approve(to, tokenId);
751     }
752 
753     /**
754      * @dev See {IERC721-getApproved}.
755      */
756     function getApproved(uint256 tokenId) public view virtual override returns (address) {
757         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
758 
759         return _tokenApprovals[tokenId];
760     }
761 
762     /**
763      * @dev See {IERC721-setApprovalForAll}.
764      */
765     function setApprovalForAll(address operator, bool approved) public virtual override {
766         require(operator != _msgSender(), "ERC721: approve to caller");
767 
768         _operatorApprovals[_msgSender()][operator] = approved;
769         emit ApprovalForAll(_msgSender(), operator, approved);
770     }
771 
772     /**
773      * @dev See {IERC721-isApprovedForAll}.
774      */
775     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
776         return _operatorApprovals[owner][operator];
777     }
778 
779     /**
780      * @dev See {IERC721-transferFrom}.
781      */
782     function transferFrom(
783         address from,
784         address to,
785         uint256 tokenId
786     ) public virtual override {
787         //solhint-disable-next-line max-line-length
788         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
789 
790         _transfer(from, to, tokenId);
791     }
792 
793     /**
794      * @dev See {IERC721-safeTransferFrom}.
795      */
796     function safeTransferFrom(
797         address from,
798         address to,
799         uint256 tokenId
800     ) public virtual override {
801         safeTransferFrom(from, to, tokenId, "");
802     }
803 
804     /**
805      * @dev See {IERC721-safeTransferFrom}.
806      */
807     function safeTransferFrom(
808         address from,
809         address to,
810         uint256 tokenId,
811         bytes memory _data
812     ) public virtual override {
813         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
814         _safeTransfer(from, to, tokenId, _data);
815     }
816 
817     /**
818      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
819      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
820      *
821      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
822      *
823      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
824      * implement alternative mechanisms to perform token transfer, such as signature-based.
825      *
826      * Requirements:
827      *
828      * - `from` cannot be the zero address.
829      * - `to` cannot be the zero address.
830      * - `tokenId` token must exist and be owned by `from`.
831      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _safeTransfer(
836         address from,
837         address to,
838         uint256 tokenId,
839         bytes memory _data
840     ) internal virtual {
841         _transfer(from, to, tokenId);
842         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
843     }
844 
845     /**
846      * @dev Returns whether `tokenId` exists.
847      *
848      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
849      *
850      * Tokens start existing when they are minted (`_mint`),
851      * and stop existing when they are burned (`_burn`).
852      */
853     function _exists(uint256 tokenId) internal view virtual returns (bool) {
854         return _owners[tokenId] != address(0);
855     }
856 
857     /**
858      * @dev Returns whether `spender` is allowed to manage `tokenId`.
859      *
860      * Requirements:
861      *
862      * - `tokenId` must exist.
863      */
864     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
865         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
866         address owner = ERC721.ownerOf(tokenId);
867         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
868     }
869 
870     /**
871      * @dev Safely mints `tokenId` and transfers it to `to`.
872      *
873      * Requirements:
874      *
875      * - `tokenId` must not exist.
876      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
877      *
878      * Emits a {Transfer} event.
879      */
880     function _safeMint(address to, uint256 tokenId) internal virtual {
881         _safeMint(to, tokenId, "");
882     }
883 
884     /**
885      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
886      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
887      */
888     function _safeMint(
889         address to,
890         uint256 tokenId,
891         bytes memory _data
892     ) internal virtual {
893         _mint(to, tokenId);
894         require(
895             _checkOnERC721Received(address(0), to, tokenId, _data),
896             "ERC721: transfer to non ERC721Receiver implementer"
897         );
898     }
899 
900     /**
901      * @dev Mints `tokenId` and transfers it to `to`.
902      *
903      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
904      *
905      * Requirements:
906      *
907      * - `tokenId` must not exist.
908      * - `to` cannot be the zero address.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _mint(address to, uint256 tokenId) internal virtual {
913         require(to != address(0), "ERC721: mint to the zero address");
914         require(!_exists(tokenId), "ERC721: token already minted");
915 
916         _beforeTokenTransfer(address(0), to, tokenId);
917 
918         _balances[to] += 1;
919         _owners[tokenId] = to;
920 
921         emit Transfer(address(0), to, tokenId);
922     }
923 
924     /**
925      * @dev Destroys `tokenId`.
926      * The approval is cleared when the token is burned.
927      *
928      * Requirements:
929      *
930      * - `tokenId` must exist.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _burn(uint256 tokenId) internal virtual {
935         address owner = ERC721.ownerOf(tokenId);
936 
937         _beforeTokenTransfer(owner, address(0), tokenId);
938 
939         // Clear approvals
940         _approve(address(0), tokenId);
941 
942         _balances[owner] -= 1;
943         delete _owners[tokenId];
944 
945         emit Transfer(owner, address(0), tokenId);
946     }
947 
948     /**
949      * @dev Transfers `tokenId` from `from` to `to`.
950      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
951      *
952      * Requirements:
953      *
954      * - `to` cannot be the zero address.
955      * - `tokenId` token must be owned by `from`.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _transfer(
960         address from,
961         address to,
962         uint256 tokenId
963     ) internal virtual {
964         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
965         require(to != address(0), "ERC721: transfer to the zero address");
966 
967         _beforeTokenTransfer(from, to, tokenId);
968 
969         // Clear approvals from the previous owner
970         _approve(address(0), tokenId);
971 
972         _balances[from] -= 1;
973         _balances[to] += 1;
974         _owners[tokenId] = to;
975 
976         emit Transfer(from, to, tokenId);
977     }
978 
979     /**
980      * @dev Approve `to` to operate on `tokenId`
981      *
982      * Emits a {Approval} event.
983      */
984     function _approve(address to, uint256 tokenId) internal virtual {
985         _tokenApprovals[tokenId] = to;
986         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
987     }
988 
989     /**
990      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
991      * The call is not executed if the target address is not a contract.
992      *
993      * @param from address representing the previous owner of the given token ID
994      * @param to target address that will receive the tokens
995      * @param tokenId uint256 ID of the token to be transferred
996      * @param _data bytes optional data to send along with the call
997      * @return bool whether the call correctly returned the expected magic value
998      */
999     function _checkOnERC721Received(
1000         address from,
1001         address to,
1002         uint256 tokenId,
1003         bytes memory _data
1004     ) private returns (bool) {
1005         if (to.isContract()) {
1006             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1007                 return retval == IERC721Receiver.onERC721Received.selector;
1008             } catch (bytes memory reason) {
1009                 if (reason.length == 0) {
1010                     revert("ERC721: transfer to non ERC721Receiver implementer");
1011                 } else {
1012                     assembly {
1013                         revert(add(32, reason), mload(reason))
1014                     }
1015                 }
1016             }
1017         } else {
1018             return true;
1019         }
1020     }
1021 
1022     /**
1023      * @dev Hook that is called before any token transfer. This includes minting
1024      * and burning.
1025      *
1026      * Calling conditions:
1027      *
1028      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1029      * transferred to `to`.
1030      * - When `from` is zero, `tokenId` will be minted for `to`.
1031      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1032      * - `from` and `to` are never both zero.
1033      *
1034      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1035      */
1036     function _beforeTokenTransfer(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) internal virtual {}
1041 }
1042 
1043 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1044 
1045 
1046 
1047 pragma solidity ^0.8.0;
1048 
1049 
1050 
1051 /**
1052  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1053  * enumerability of all the token ids in the contract as well as all token ids owned by each
1054  * account.
1055  */
1056 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1057     // Mapping from owner to list of owned token IDs
1058     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1059 
1060     // Mapping from token ID to index of the owner tokens list
1061     mapping(uint256 => uint256) private _ownedTokensIndex;
1062 
1063     // Array with all token ids, used for enumeration
1064     uint256[] private _allTokens;
1065 
1066     // Mapping from token id to position in the allTokens array
1067     mapping(uint256 => uint256) private _allTokensIndex;
1068 
1069     /**
1070      * @dev See {IERC165-supportsInterface}.
1071      */
1072     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1073         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1074     }
1075 
1076     /**
1077      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1078      */
1079     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1080         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1081         return _ownedTokens[owner][index];
1082     }
1083 
1084     /**
1085      * @dev See {IERC721Enumerable-totalSupply}.
1086      */
1087     function totalSupply() public view virtual override returns (uint256) {
1088         return _allTokens.length;
1089     }
1090 
1091     /**
1092      * @dev See {IERC721Enumerable-tokenByIndex}.
1093      */
1094     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1095         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1096         return _allTokens[index];
1097     }
1098 
1099     /**
1100      * @dev Hook that is called before any token transfer. This includes minting
1101      * and burning.
1102      *
1103      * Calling conditions:
1104      *
1105      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1106      * transferred to `to`.
1107      * - When `from` is zero, `tokenId` will be minted for `to`.
1108      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1109      * - `from` cannot be the zero address.
1110      * - `to` cannot be the zero address.
1111      *
1112      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1113      */
1114     function _beforeTokenTransfer(
1115         address from,
1116         address to,
1117         uint256 tokenId
1118     ) internal virtual override {
1119         super._beforeTokenTransfer(from, to, tokenId);
1120 
1121         if (from == address(0)) {
1122             _addTokenToAllTokensEnumeration(tokenId);
1123         } else if (from != to) {
1124             _removeTokenFromOwnerEnumeration(from, tokenId);
1125         }
1126         if (to == address(0)) {
1127             _removeTokenFromAllTokensEnumeration(tokenId);
1128         } else if (to != from) {
1129             _addTokenToOwnerEnumeration(to, tokenId);
1130         }
1131     }
1132 
1133     /**
1134      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1135      * @param to address representing the new owner of the given token ID
1136      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1137      */
1138     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1139         uint256 length = ERC721.balanceOf(to);
1140         _ownedTokens[to][length] = tokenId;
1141         _ownedTokensIndex[tokenId] = length;
1142     }
1143 
1144     /**
1145      * @dev Private function to add a token to this extension's token tracking data structures.
1146      * @param tokenId uint256 ID of the token to be added to the tokens list
1147      */
1148     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1149         _allTokensIndex[tokenId] = _allTokens.length;
1150         _allTokens.push(tokenId);
1151     }
1152 
1153     /**
1154      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1155      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1156      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1157      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1158      * @param from address representing the previous owner of the given token ID
1159      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1160      */
1161     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1162         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1163         // then delete the last slot (swap and pop).
1164 
1165         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1166         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1167 
1168         // When the token to delete is the last token, the swap operation is unnecessary
1169         if (tokenIndex != lastTokenIndex) {
1170             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1171 
1172             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1173             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1174         }
1175 
1176         // This also deletes the contents at the last position of the array
1177         delete _ownedTokensIndex[tokenId];
1178         delete _ownedTokens[from][lastTokenIndex];
1179     }
1180 
1181     /**
1182      * @dev Private function to remove a token from this extension's token tracking data structures.
1183      * This has O(1) time complexity, but alters the order of the _allTokens array.
1184      * @param tokenId uint256 ID of the token to be removed from the tokens list
1185      */
1186     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1187         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1188         // then delete the last slot (swap and pop).
1189 
1190         uint256 lastTokenIndex = _allTokens.length - 1;
1191         uint256 tokenIndex = _allTokensIndex[tokenId];
1192 
1193         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1194         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1195         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1196         uint256 lastTokenId = _allTokens[lastTokenIndex];
1197 
1198         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1199         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1200 
1201         // This also deletes the contents at the last position of the array
1202         delete _allTokensIndex[tokenId];
1203         _allTokens.pop();
1204     }
1205 }
1206 
1207 // File: contracts/KidKongz.sol
1208 
1209 
1210 pragma solidity >=0.7.0 <0.9.0;
1211 
1212 
1213 
1214 contract KidKongz is ERC721Enumerable, Ownable {
1215   using Strings for uint256;
1216 
1217 // Set metadata for revealed Kid Kongz
1218   string public baseURI;
1219 // Extension for metata files
1220   string public baseExtension = ".json";
1221 // Not revealed metadata
1222   string public notRevealedUri;
1223 // Cost per Kid Kongz
1224   uint256 public cost = 0.04 ether;
1225 // Max amount of Kid Kongz
1226   uint256 public maxSupply = 4000;
1227 // Max amount to mint per transaction
1228   uint256 public maxMintAmount = 20;
1229 // Max amount of Kid Kongz per wallet
1230   uint256 public nftPerAddressLimit = 60;
1231 
1232   bool public paused = false;
1233   bool public revealed = false;
1234   bool public onlyWl = false;
1235   address[] public wlAddresses;
1236   mapping(address => uint256) public addressMintedBalance;
1237 
1238 
1239   constructor(
1240     string memory _name,
1241     string memory _symbol,
1242     string memory _initBaseURI,
1243     string memory _initNotRevealedUri
1244   ) ERC721(_name, _symbol) {
1245     setBaseURI(_initBaseURI);
1246     setNotRevealedURI(_initNotRevealedUri);
1247   }
1248 
1249   // internal
1250   function _baseURI() internal view virtual override returns (string memory) {
1251     return baseURI;
1252   }
1253 
1254   // public
1255   function mint(uint256 _mintAmount) public payable {
1256     require(!paused, "the contract is paused");
1257     uint256 supply = totalSupply();
1258     require(_mintAmount > 0, "need to mint at least 1 NFT");
1259     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1260     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1261 
1262     if (msg.sender != owner()) {
1263         if(onlyWl == true) {
1264             require(isWl(msg.sender), "user is not whitelisted");
1265             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1266             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1267         }
1268         require(msg.value >= cost * _mintAmount, "insufficient funds");
1269     }
1270     
1271     for (uint256 i = 1; i <= _mintAmount; i++) {
1272         addressMintedBalance[msg.sender]++;
1273       _safeMint(msg.sender, supply + i);
1274     }
1275   }
1276   
1277   function isWl(address _user) public view returns (bool) {
1278     for (uint i = 0; i < wlAddresses.length; i++) {
1279       if (wlAddresses[i] == _user) {
1280           return true;
1281       }
1282     }
1283     return false;
1284   }
1285 
1286   function walletOfOwner(address _owner)
1287     public
1288     view
1289     returns (uint256[] memory)
1290   {
1291     uint256 ownerTokenCount = balanceOf(_owner);
1292     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1293     for (uint256 i; i < ownerTokenCount; i++) {
1294       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1295     }
1296     return tokenIds;
1297   }
1298 
1299   function tokenURI(uint256 tokenId)
1300     public
1301     view
1302     virtual
1303     override
1304     returns (string memory)
1305   {
1306     require(
1307       _exists(tokenId),
1308       "ERC721Metadata: URI query for nonexistent token"
1309     );
1310     
1311     if(revealed == false) {
1312         return notRevealedUri;
1313     }
1314 
1315     string memory currentBaseURI = _baseURI();
1316     return bytes(currentBaseURI).length > 0
1317         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1318         : "";
1319   }
1320 
1321   //only owner
1322   function reveal() public onlyOwner {
1323       revealed = true;
1324   }
1325   
1326   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1327     nftPerAddressLimit = _limit;
1328   }
1329   
1330   function setCost(uint256 _newCost) public onlyOwner {
1331     cost = _newCost;
1332   }
1333 
1334   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1335     maxMintAmount = _newmaxMintAmount;
1336   }
1337 
1338   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1339     baseURI = _newBaseURI;
1340   }
1341 
1342   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1343     baseExtension = _newBaseExtension;
1344   }
1345   
1346   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1347     notRevealedUri = _notRevealedURI;
1348   }
1349 
1350   function pause(bool _state) public onlyOwner {
1351     paused = _state;
1352   }
1353   
1354   function setOnlyWl(bool _state) public onlyOwner {
1355     onlyWl = _state;
1356   }
1357   
1358   function wlUsers(address[] calldata _users) public onlyOwner {
1359     delete wlAddresses;
1360     wlAddresses = _users;
1361   }
1362  
1363   function withdraw() public payable onlyOwner {
1364 
1365     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1366     require(os);
1367 
1368   }
1369 }