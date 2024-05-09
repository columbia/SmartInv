1 // SPDX-License-Identifier: MIT
2 
3 // Amended by notGod dev
4 /**
5     notGod
6     666 NFT
7     Free mint
8     max 2 for tx
9 */
10 
11 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
12 pragma solidity ^0.8.0;
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * https://eips.ethereum.org/EIPS/eip-165[EIP].
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others ({ERC165Checker}).
19  *
20  * For an implementation, see {ERC165}.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
35 pragma solidity ^0.8.0;
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
71      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId
87     ) external;
88 
89     /**
90      * @dev Transfers `tokenId` token from `from` to `to`.
91      *
92      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must be owned by `from`.
99      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
111      * The approval is cleared when the token is transferred.
112      *
113      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
114      *
115      * Requirements:
116      *
117      * - The caller must own the token or be an approved operator.
118      * - `tokenId` must exist.
119      *
120      * Emits an {Approval} event.
121      */
122     function approve(address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Returns the account approved for `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function getApproved(uint256 tokenId) external view returns (address operator);
132 
133     /**
134      * @dev Approve or remove `operator` as an operator for the caller.
135      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
136      *
137      * Requirements:
138      *
139      * - The `operator` cannot be the caller.
140      *
141      * Emits an {ApprovalForAll} event.
142      */
143     function setApprovalForAll(address operator, bool _approved) external;
144 
145     /**
146      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
147      *
148      * See {setApprovalForAll}
149      */
150     function isApprovedForAll(address owner, address operator) external view returns (bool);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId,
169         bytes calldata data
170     ) external;
171 }
172 
173 
174 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
175 pragma solidity ^0.8.0;
176 /**
177  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
178  * @dev See https://eips.ethereum.org/EIPS/eip-721
179  */
180 interface IERC721Enumerable is IERC721 {
181     /**
182      * @dev Returns the total amount of tokens stored by the contract.
183      */
184     function totalSupply() external view returns (uint256);
185 
186     /**
187      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
188      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
189      */
190     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
191 
192     /**
193      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
194      * Use along with {totalSupply} to enumerate all tokens.
195      */
196     function tokenByIndex(uint256 index) external view returns (uint256);
197 }
198 
199 
200 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
201 pragma solidity ^0.8.0;
202 /**
203  * @dev Implementation of the {IERC165} interface.
204  *
205  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
206  * for the additional interface id that will be supported. For example:
207  *
208  * ```solidity
209  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
210  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
211  * }
212  * ```
213  *
214  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
215  */
216 abstract contract ERC165 is IERC165 {
217     /**
218      * @dev See {IERC165-supportsInterface}.
219      */
220     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
221         return interfaceId == type(IERC165).interfaceId;
222     }
223 }
224 
225 // File: @openzeppelin/contracts/utils/Strings.sol
226 
227 
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev String operations.
233  */
234 library Strings {
235     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
236 
237     /**
238      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
239      */
240     function toString(uint256 value) internal pure returns (string memory) {
241         // Inspired by OraclizeAPI's implementation - MIT licence
242         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
243 
244         if (value == 0) {
245             return "0";
246         }
247         uint256 temp = value;
248         uint256 digits;
249         while (temp != 0) {
250             digits++;
251             temp /= 10;
252         }
253         bytes memory buffer = new bytes(digits);
254         while (value != 0) {
255             digits -= 1;
256             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
257             value /= 10;
258         }
259         return string(buffer);
260     }
261 
262     /**
263      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
264      */
265     function toHexString(uint256 value) internal pure returns (string memory) {
266         if (value == 0) {
267             return "0x00";
268         }
269         uint256 temp = value;
270         uint256 length = 0;
271         while (temp != 0) {
272             length++;
273             temp >>= 8;
274         }
275         return toHexString(value, length);
276     }
277 
278     /**
279      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
280      */
281     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
282         bytes memory buffer = new bytes(2 * length + 2);
283         buffer[0] = "0";
284         buffer[1] = "x";
285         for (uint256 i = 2 * length + 1; i > 1; --i) {
286             buffer[i] = _HEX_SYMBOLS[value & 0xf];
287             value >>= 4;
288         }
289         require(value == 0, "Strings: hex length insufficient");
290         return string(buffer);
291     }
292 }
293 
294 // File: @openzeppelin/contracts/utils/Address.sol
295 
296 
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @dev Collection of functions related to the address type
302  */
303 library Address {
304     /**
305      * @dev Returns true if `account` is a contract.
306      *
307      * [IMPORTANT]
308      * ====
309      * It is unsafe to assume that an address for which this function returns
310      * false is an externally-owned account (EOA) and not a contract.
311      *
312      * Among others, `isContract` will return false for the following
313      * types of addresses:
314      *
315      *  - an externally-owned account
316      *  - a contract in construction
317      *  - an address where a contract will be created
318      *  - an address where a contract lived, but was destroyed
319      * ====
320      */
321     function isContract(address account) internal view returns (bool) {
322         // This method relies on extcodesize, which returns 0 for contracts in
323         // construction, since the code is only stored at the end of the
324         // constructor execution.
325 
326         uint256 size;
327         assembly {
328             size := extcodesize(account)
329         }
330         return size > 0;
331     }
332 
333     /**
334      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
335      * `recipient`, forwarding all available gas and reverting on errors.
336      *
337      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
338      * of certain opcodes, possibly making contracts go over the 2300 gas limit
339      * imposed by `transfer`, making them unable to receive funds via
340      * `transfer`. {sendValue} removes this limitation.
341      *
342      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
343      *
344      * IMPORTANT: because control is transferred to `recipient`, care must be
345      * taken to not create reentrancy vulnerabilities. Consider using
346      * {ReentrancyGuard} or the
347      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
348      */
349     function sendValue(address payable recipient, uint256 amount) internal {
350         require(address(this).balance >= amount, "Address: insufficient balance");
351 
352         (bool success, ) = recipient.call{value: amount}("");
353         require(success, "Address: unable to send value, recipient may have reverted");
354     }
355 
356     /**
357      * @dev Performs a Solidity function call using a low level `call`. A
358      * plain `call` is an unsafe replacement for a function call: use this
359      * function instead.
360      *
361      * If `target` reverts with a revert reason, it is bubbled up by this
362      * function (like regular Solidity function calls).
363      *
364      * Returns the raw returned data. To convert to the expected return value,
365      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
366      *
367      * Requirements:
368      *
369      * - `target` must be a contract.
370      * - calling `target` with `data` must not revert.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
375         return functionCall(target, data, "Address: low-level call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
380      * `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, 0, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but also transferring `value` wei to `target`.
395      *
396      * Requirements:
397      *
398      * - the calling contract must have an ETH balance of at least `value`.
399      * - the called Solidity function must be `payable`.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(
404         address target,
405         bytes memory data,
406         uint256 value
407     ) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
413      * with `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         require(address(this).balance >= value, "Address: insufficient balance for call");
424         require(isContract(target), "Address: call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.call{value: value}(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a static call.
433      *
434      * _Available since v3.3._
435      */
436     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
437         return functionStaticCall(target, data, "Address: low-level static call failed");
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
442      * but performing a static call.
443      *
444      * _Available since v3.3._
445      */
446     function functionStaticCall(
447         address target,
448         bytes memory data,
449         string memory errorMessage
450     ) internal view returns (bytes memory) {
451         require(isContract(target), "Address: static call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.staticcall(data);
454         return verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but performing a delegate call.
460      *
461      * _Available since v3.4._
462      */
463     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
464         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.4._
472      */
473     function functionDelegateCall(
474         address target,
475         bytes memory data,
476         string memory errorMessage
477     ) internal returns (bytes memory) {
478         require(isContract(target), "Address: delegate call to non-contract");
479 
480         (bool success, bytes memory returndata) = target.delegatecall(data);
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
486      * revert reason using the provided one.
487      *
488      * _Available since v4.3._
489      */
490     function verifyCallResult(
491         bool success,
492         bytes memory returndata,
493         string memory errorMessage
494     ) internal pure returns (bytes memory) {
495         if (success) {
496             return returndata;
497         } else {
498             // Look for revert reason and bubble it up if present
499             if (returndata.length > 0) {
500                 // The easiest way to bubble the revert reason is using memory via assembly
501 
502                 assembly {
503                     let returndata_size := mload(returndata)
504                     revert(add(32, returndata), returndata_size)
505                 }
506             } else {
507                 revert(errorMessage);
508             }
509         }
510     }
511 }
512 
513 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
514 
515 
516 
517 pragma solidity ^0.8.0;
518 
519 
520 /**
521  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
522  * @dev See https://eips.ethereum.org/EIPS/eip-721
523  */
524 interface IERC721Metadata is IERC721 {
525     /**
526      * @dev Returns the token collection name.
527      */
528     function name() external view returns (string memory);
529 
530     /**
531      * @dev Returns the token collection symbol.
532      */
533     function symbol() external view returns (string memory);
534 
535     /**
536      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
537      */
538     function tokenURI(uint256 tokenId) external view returns (string memory);
539 }
540 
541 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
542 
543 
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @title ERC721 token receiver interface
549  * @dev Interface for any contract that wants to support safeTransfers
550  * from ERC721 asset contracts.
551  */
552 interface IERC721Receiver {
553     /**
554      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
555      * by `operator` from `from`, this function is called.
556      *
557      * It must return its Solidity selector to confirm the token transfer.
558      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
559      *
560      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
561      */
562     function onERC721Received(
563         address operator,
564         address from,
565         uint256 tokenId,
566         bytes calldata data
567     ) external returns (bytes4);
568 }
569 
570 // File: @openzeppelin/contracts/utils/Context.sol
571 pragma solidity ^0.8.0;
572 /**
573  * @dev Provides information about the current execution context, including the
574  * sender of the transaction and its data. While these are generally available
575  * via msg.sender and msg.data, they should not be accessed in such a direct
576  * manner, since when dealing with meta-transactions the account sending and
577  * paying for execution may not be the actual sender (as far as an application
578  * is concerned).
579  *
580  * This contract is only required for intermediate, library-like contracts.
581  */
582 abstract contract Context {
583     function _msgSender() internal view virtual returns (address) {
584         return msg.sender;
585     }
586 
587     function _msgData() internal view virtual returns (bytes calldata) {
588         return msg.data;
589     }
590 }
591 
592 
593 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
594 pragma solidity ^0.8.0;
595 /**
596  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
597  * the Metadata extension, but not including the Enumerable extension, which is available separately as
598  * {ERC721Enumerable}.
599  */
600 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
601     using Address for address;
602     using Strings for uint256;
603 
604     // Token name
605     string private _name;
606 
607     // Token symbol
608     string private _symbol;
609 
610     // Mapping from token ID to owner address
611     mapping(uint256 => address) private _owners;
612 
613     // Mapping owner address to token count
614     mapping(address => uint256) private _balances;
615 
616     // Mapping from token ID to approved address
617     mapping(uint256 => address) private _tokenApprovals;
618 
619     // Mapping from owner to operator approvals
620     mapping(address => mapping(address => bool)) private _operatorApprovals;
621 
622     /**
623      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
624      */
625     constructor(string memory name_, string memory symbol_) {
626         _name = name_;
627         _symbol = symbol_;
628     }
629 
630     /**
631      * @dev See {IERC165-supportsInterface}.
632      */
633     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
634         return
635             interfaceId == type(IERC721).interfaceId ||
636             interfaceId == type(IERC721Metadata).interfaceId ||
637             super.supportsInterface(interfaceId);
638     }
639 
640     /**
641      * @dev See {IERC721-balanceOf}.
642      */
643     function balanceOf(address owner) public view virtual override returns (uint256) {
644         require(owner != address(0), "ERC721: balance query for the zero address");
645         return _balances[owner];
646     }
647 
648     /**
649      * @dev See {IERC721-ownerOf}.
650      */
651     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
652         address owner = _owners[tokenId];
653         require(owner != address(0), "ERC721: owner query for nonexistent token");
654         return owner;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-name}.
659      */
660     function name() public view virtual override returns (string memory) {
661         return _name;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-symbol}.
666      */
667     function symbol() public view virtual override returns (string memory) {
668         return _symbol;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-tokenURI}.
673      */
674     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
675         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
676 
677         string memory baseURI = _baseURI();
678         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
679     }
680 
681     /**
682      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
683      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
684      * by default, can be overriden in child contracts.
685      */
686     function _baseURI() internal view virtual returns (string memory) {
687         return "";
688     }
689 
690     /**
691      * @dev See {IERC721-approve}.
692      */
693     function approve(address to, uint256 tokenId) public virtual override {
694         address owner = ERC721.ownerOf(tokenId);
695         require(to != owner, "ERC721: approval to current owner");
696 
697         require(
698             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
699             "ERC721: approve caller is not owner nor approved for all"
700         );
701 
702         _approve(to, tokenId);
703     }
704 
705     /**
706      * @dev See {IERC721-getApproved}.
707      */
708     function getApproved(uint256 tokenId) public view virtual override returns (address) {
709         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
710 
711         return _tokenApprovals[tokenId];
712     }
713 
714     /**
715      * @dev See {IERC721-setApprovalForAll}.
716      */
717     function setApprovalForAll(address operator, bool approved) public virtual override {
718         require(operator != _msgSender(), "ERC721: approve to caller");
719 
720         _operatorApprovals[_msgSender()][operator] = approved;
721         emit ApprovalForAll(_msgSender(), operator, approved);
722     }
723 
724     /**
725      * @dev See {IERC721-isApprovedForAll}.
726      */
727     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
728         return _operatorApprovals[owner][operator];
729     }
730 
731     /**
732      * @dev See {IERC721-transferFrom}.
733      */
734     function transferFrom(
735         address from,
736         address to,
737         uint256 tokenId
738     ) public virtual override {
739         //solhint-disable-next-line max-line-length
740         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
741 
742         _transfer(from, to, tokenId);
743     }
744 
745     /**
746      * @dev See {IERC721-safeTransferFrom}.
747      */
748     function safeTransferFrom(
749         address from,
750         address to,
751         uint256 tokenId
752     ) public virtual override {
753         safeTransferFrom(from, to, tokenId, "");
754     }
755 
756     /**
757      * @dev See {IERC721-safeTransferFrom}.
758      */
759     function safeTransferFrom(
760         address from,
761         address to,
762         uint256 tokenId,
763         bytes memory _data
764     ) public virtual override {
765         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
766         _safeTransfer(from, to, tokenId, _data);
767     }
768 
769     /**
770      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
771      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
772      *
773      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
774      *
775      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
776      * implement alternative mechanisms to perform token transfer, such as signature-based.
777      *
778      * Requirements:
779      *
780      * - `from` cannot be the zero address.
781      * - `to` cannot be the zero address.
782      * - `tokenId` token must exist and be owned by `from`.
783      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
784      *
785      * Emits a {Transfer} event.
786      */
787     function _safeTransfer(
788         address from,
789         address to,
790         uint256 tokenId,
791         bytes memory _data
792     ) internal virtual {
793         _transfer(from, to, tokenId);
794         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
795     }
796 
797     /**
798      * @dev Returns whether `tokenId` exists.
799      *
800      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
801      *
802      * Tokens start existing when they are minted (`_mint`),
803      * and stop existing when they are burned (`_burn`).
804      */
805     function _exists(uint256 tokenId) internal view virtual returns (bool) {
806         return _owners[tokenId] != address(0);
807     }
808 
809     /**
810      * @dev Returns whether `spender` is allowed to manage `tokenId`.
811      *
812      * Requirements:
813      *
814      * - `tokenId` must exist.
815      */
816     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
817         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
818         address owner = ERC721.ownerOf(tokenId);
819         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
820     }
821 
822     /**
823      * @dev Safely mints `tokenId` and transfers it to `to`.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must not exist.
828      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
829      *
830      * Emits a {Transfer} event.
831      */
832     function _safeMint(address to, uint256 tokenId) internal virtual {
833         _safeMint(to, tokenId, "");
834     }
835 
836     /**
837      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
838      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
839      */
840     function _safeMint(
841         address to,
842         uint256 tokenId,
843         bytes memory _data
844     ) internal virtual {
845         _mint(to, tokenId);
846         require(
847             _checkOnERC721Received(address(0), to, tokenId, _data),
848             "ERC721: transfer to non ERC721Receiver implementer"
849         );
850     }
851 
852     /**
853      * @dev Mints `tokenId` and transfers it to `to`.
854      *
855      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
856      *
857      * Requirements:
858      *
859      * - `tokenId` must not exist.
860      * - `to` cannot be the zero address.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _mint(address to, uint256 tokenId) internal virtual {
865         require(to != address(0), "ERC721: mint to the zero address");
866         require(!_exists(tokenId), "ERC721: token already minted");
867 
868         _beforeTokenTransfer(address(0), to, tokenId);
869 
870         _balances[to] += 1;
871         _owners[tokenId] = to;
872 
873         emit Transfer(address(0), to, tokenId);
874     }
875 
876     /**
877      * @dev Destroys `tokenId`.
878      * The approval is cleared when the token is burned.
879      *
880      * Requirements:
881      *
882      * - `tokenId` must exist.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _burn(uint256 tokenId) internal virtual {
887         address owner = ERC721.ownerOf(tokenId);
888 
889         _beforeTokenTransfer(owner, address(0), tokenId);
890 
891         // Clear approvals
892         _approve(address(0), tokenId);
893 
894         _balances[owner] -= 1;
895         delete _owners[tokenId];
896 
897         emit Transfer(owner, address(0), tokenId);
898     }
899 
900     /**
901      * @dev Transfers `tokenId` from `from` to `to`.
902      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
903      *
904      * Requirements:
905      *
906      * - `to` cannot be the zero address.
907      * - `tokenId` token must be owned by `from`.
908      *
909      * Emits a {Transfer} event.
910      */
911     function _transfer(
912         address from,
913         address to,
914         uint256 tokenId
915     ) internal virtual {
916         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
917         require(to != address(0), "ERC721: transfer to the zero address");
918 
919         _beforeTokenTransfer(from, to, tokenId);
920 
921         // Clear approvals from the previous owner
922         _approve(address(0), tokenId);
923 
924         _balances[from] -= 1;
925         _balances[to] += 1;
926         _owners[tokenId] = to;
927 
928         emit Transfer(from, to, tokenId);
929     }
930 
931     /**
932      * @dev Approve `to` to operate on `tokenId`
933      *
934      * Emits a {Approval} event.
935      */
936     function _approve(address to, uint256 tokenId) internal virtual {
937         _tokenApprovals[tokenId] = to;
938         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
939     }
940 
941     /**
942      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
943      * The call is not executed if the target address is not a contract.
944      *
945      * @param from address representing the previous owner of the given token ID
946      * @param to target address that will receive the tokens
947      * @param tokenId uint256 ID of the token to be transferred
948      * @param _data bytes optional data to send along with the call
949      * @return bool whether the call correctly returned the expected magic value
950      */
951     function _checkOnERC721Received(
952         address from,
953         address to,
954         uint256 tokenId,
955         bytes memory _data
956     ) private returns (bool) {
957         if (to.isContract()) {
958             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
959                 return retval == IERC721Receiver.onERC721Received.selector;
960             } catch (bytes memory reason) {
961                 if (reason.length == 0) {
962                     revert("ERC721: transfer to non ERC721Receiver implementer");
963                 } else {
964                     assembly {
965                         revert(add(32, reason), mload(reason))
966                     }
967                 }
968             }
969         } else {
970             return true;
971         }
972     }
973 
974     /**
975      * @dev Hook that is called before any token transfer. This includes minting
976      * and burning.
977      *
978      * Calling conditions:
979      *
980      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
981      * transferred to `to`.
982      * - When `from` is zero, `tokenId` will be minted for `to`.
983      * - When `to` is zero, ``from``'s `tokenId` will be burned.
984      * - `from` and `to` are never both zero.
985      *
986      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
987      */
988     function _beforeTokenTransfer(
989         address from,
990         address to,
991         uint256 tokenId
992     ) internal virtual {}
993 }
994 
995 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
996 
997 
998 
999 pragma solidity ^0.8.0;
1000 
1001 
1002 
1003 /**
1004  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1005  * enumerability of all the token ids in the contract as well as all token ids owned by each
1006  * account.
1007  */
1008 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1009     // Mapping from owner to list of owned token IDs
1010     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1011 
1012     // Mapping from token ID to index of the owner tokens list
1013     mapping(uint256 => uint256) private _ownedTokensIndex;
1014 
1015     // Array with all token ids, used for enumeration
1016     uint256[] private _allTokens;
1017 
1018     // Mapping from token id to position in the allTokens array
1019     mapping(uint256 => uint256) private _allTokensIndex;
1020 
1021     /**
1022      * @dev See {IERC165-supportsInterface}.
1023      */
1024     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1025         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1030      */
1031     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1032         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1033         return _ownedTokens[owner][index];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Enumerable-totalSupply}.
1038      */
1039     function totalSupply() public view virtual override returns (uint256) {
1040         return _allTokens.length;
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Enumerable-tokenByIndex}.
1045      */
1046     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1047         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1048         return _allTokens[index];
1049     }
1050 
1051     /**
1052      * @dev Hook that is called before any token transfer. This includes minting
1053      * and burning.
1054      *
1055      * Calling conditions:
1056      *
1057      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1058      * transferred to `to`.
1059      * - When `from` is zero, `tokenId` will be minted for `to`.
1060      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1061      * - `from` cannot be the zero address.
1062      * - `to` cannot be the zero address.
1063      *
1064      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1065      */
1066     function _beforeTokenTransfer(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) internal virtual override {
1071         super._beforeTokenTransfer(from, to, tokenId);
1072 
1073         if (from == address(0)) {
1074             _addTokenToAllTokensEnumeration(tokenId);
1075         } else if (from != to) {
1076             _removeTokenFromOwnerEnumeration(from, tokenId);
1077         }
1078         if (to == address(0)) {
1079             _removeTokenFromAllTokensEnumeration(tokenId);
1080         } else if (to != from) {
1081             _addTokenToOwnerEnumeration(to, tokenId);
1082         }
1083     }
1084 
1085     /**
1086      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1087      * @param to address representing the new owner of the given token ID
1088      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1089      */
1090     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1091         uint256 length = ERC721.balanceOf(to);
1092         _ownedTokens[to][length] = tokenId;
1093         _ownedTokensIndex[tokenId] = length;
1094     }
1095 
1096     /**
1097      * @dev Private function to add a token to this extension's token tracking data structures.
1098      * @param tokenId uint256 ID of the token to be added to the tokens list
1099      */
1100     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1101         _allTokensIndex[tokenId] = _allTokens.length;
1102         _allTokens.push(tokenId);
1103     }
1104 
1105     /**
1106      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1107      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1108      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1109      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1110      * @param from address representing the previous owner of the given token ID
1111      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1112      */
1113     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1114         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1115         // then delete the last slot (swap and pop).
1116 
1117         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1118         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1119 
1120         // When the token to delete is the last token, the swap operation is unnecessary
1121         if (tokenIndex != lastTokenIndex) {
1122             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1123 
1124             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1125             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1126         }
1127 
1128         // This also deletes the contents at the last position of the array
1129         delete _ownedTokensIndex[tokenId];
1130         delete _ownedTokens[from][lastTokenIndex];
1131     }
1132 
1133     /**
1134      * @dev Private function to remove a token from this extension's token tracking data structures.
1135      * This has O(1) time complexity, but alters the order of the _allTokens array.
1136      * @param tokenId uint256 ID of the token to be removed from the tokens list
1137      */
1138     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1139         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1140         // then delete the last slot (swap and pop).
1141 
1142         uint256 lastTokenIndex = _allTokens.length - 1;
1143         uint256 tokenIndex = _allTokensIndex[tokenId];
1144 
1145         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1146         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1147         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1148         uint256 lastTokenId = _allTokens[lastTokenIndex];
1149 
1150         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1151         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1152 
1153         // This also deletes the contents at the last position of the array
1154         delete _allTokensIndex[tokenId];
1155         _allTokens.pop();
1156     }
1157 }
1158 
1159 
1160 // File: @openzeppelin/contracts/access/Ownable.sol
1161 pragma solidity ^0.8.0;
1162 /**
1163  * @dev Contract module which provides a basic access control mechanism, where
1164  * there is an account (an owner) that can be granted exclusive access to
1165  * specific functions.
1166  *
1167  * By default, the owner account will be the one that deploys the contract. This
1168  * can later be changed with {transferOwnership}.
1169  *
1170  * This module is used through inheritance. It will make available the modifier
1171  * `onlyOwner`, which can be applied to your functions to restrict their use to
1172  * the owner.
1173  */
1174 abstract contract Ownable is Context {
1175     address private _owner;
1176 
1177     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1178 
1179     /**
1180      * @dev Initializes the contract setting the deployer as the initial owner.
1181      */
1182     constructor() {
1183         _setOwner(_msgSender());
1184     }
1185 
1186     /**
1187      * @dev Returns the address of the current owner.
1188      */
1189     function owner() public view virtual returns (address) {
1190         return _owner;
1191     }
1192 
1193     /**
1194      * @dev Throws if called by any account other than the owner.
1195      */
1196     modifier onlyOwner() {
1197         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1198         _;
1199     }
1200 
1201     /**
1202      * @dev Leaves the contract without owner. It will not be possible to call
1203      * `onlyOwner` functions anymore. Can only be called by the current owner.
1204      *
1205      * NOTE: Renouncing ownership will leave the contract without an owner,
1206      * thereby removing any functionality that is only available to the owner.
1207      */
1208     function renounceOwnership() public virtual onlyOwner {
1209         _setOwner(address(0));
1210     }
1211 
1212     /**
1213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1214      * Can only be called by the current owner.
1215      */
1216     function transferOwnership(address newOwner) public virtual onlyOwner {
1217         require(newOwner != address(0), "Ownable: new owner is the zero address");
1218         _setOwner(newOwner);
1219     }
1220 
1221     function _setOwner(address newOwner) private {
1222         address oldOwner = _owner;
1223         _owner = newOwner;
1224         emit OwnershipTransferred(oldOwner, newOwner);
1225     }
1226 }
1227 
1228 pragma solidity >=0.7.0 <0.9.0;
1229 
1230 contract notGod is ERC721Enumerable, Ownable {
1231   using Strings for uint256;
1232 
1233   string baseURI;
1234   string public baseExtension = ".json";
1235   uint256 public cost = 0 ether;
1236   uint256 public maxSupply = 666;
1237   uint256 public maxMintAmount = 2;
1238   bool public paused = true;
1239   bool public revealed = false;
1240   string public notRevealedUri;
1241 
1242   constructor(
1243     string memory _name,
1244     string memory _symbol,
1245     string memory _initBaseURI,
1246     string memory _initNotRevealedUri
1247   ) ERC721(_name, _symbol) {
1248     setBaseURI(_initBaseURI);
1249     setNotRevealedURI(_initNotRevealedUri);
1250   }
1251 
1252   // internal
1253   function _baseURI() internal view virtual override returns (string memory) {
1254     return baseURI;
1255   }
1256 
1257   // public
1258   function mint(uint256 _mintAmount) public payable {
1259     uint256 supply = totalSupply();
1260     require(!paused);
1261     require(_mintAmount > 0);
1262     require(_mintAmount <= maxMintAmount);
1263     require(supply + _mintAmount <= maxSupply);
1264 
1265     if (msg.sender != owner()) {
1266       require(msg.value >= cost * _mintAmount);
1267     }
1268 
1269     for (uint256 i = 1; i <= _mintAmount; i++) {
1270       _safeMint(msg.sender, supply + i);
1271     }
1272   }
1273 
1274   function walletOfOwner(address _owner)
1275     public
1276     view
1277     returns (uint256[] memory)
1278   {
1279     uint256 ownerTokenCount = balanceOf(_owner);
1280     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1281     for (uint256 i; i < ownerTokenCount; i++) {
1282       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1283     }
1284     return tokenIds;
1285   }
1286 
1287   function tokenURI(uint256 tokenId)
1288     public
1289     view
1290     virtual
1291     override
1292     returns (string memory)
1293   {
1294     require(
1295       _exists(tokenId),
1296       "ERC721Metadata: URI query for nonexistent token"
1297     );
1298     
1299     if(revealed == false) {
1300         return notRevealedUri;
1301     }
1302 
1303     string memory currentBaseURI = _baseURI();
1304     return bytes(currentBaseURI).length > 0
1305         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1306         : "";
1307   }
1308 
1309   //only owner
1310   function reveal() public onlyOwner {
1311       revealed = true;
1312   }
1313   
1314   function setCost(uint256 _newCost) public onlyOwner {
1315     cost = _newCost;
1316   }
1317 
1318   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1319     maxMintAmount = _newmaxMintAmount;
1320   }
1321   
1322   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1323     notRevealedUri = _notRevealedURI;
1324   }
1325 
1326   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1327     baseURI = _newBaseURI;
1328   }
1329 
1330   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1331     baseExtension = _newBaseExtension;
1332   }
1333 
1334   function pause(bool _state) public onlyOwner {
1335     paused = _state;
1336   }
1337  
1338   function withdraw() public payable onlyOwner {
1339     // This will pay HashLips 5% of the initial sale.
1340     // You can remove this if you want, or keep it in to support HashLips and his channel.
1341     // =============================================================================
1342     (bool hs, ) = payable(0x943590A42C27D08e3744202c4Ae5eD55c2dE240D).call{value: address(this).balance * 5 / 100}("");
1343     require(hs);
1344     // =============================================================================
1345     
1346     // This will payout the owner 95% of the contract balance.
1347     // Do not remove this otherwise you will not be able to withdraw the funds.
1348     // =============================================================================
1349     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1350     require(os);
1351     // =============================================================================
1352   }
1353 }