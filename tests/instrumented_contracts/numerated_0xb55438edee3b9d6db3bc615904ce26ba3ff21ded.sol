1 //SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
31 pragma solidity ^0.8.0;
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
168 
169 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
170 pragma solidity ^0.8.0;
171 /**
172  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
173  * @dev See https://eips.ethereum.org/EIPS/eip-721
174  */
175 interface IERC721Enumerable is IERC721 {
176     /**
177      * @dev Returns the total amount of tokens stored by the contract.
178      */
179     function totalSupply() external view returns (uint256);
180 
181     /**
182      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
183      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
184      */
185     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
186 
187     /**
188      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
189      * Use along with {totalSupply} to enumerate all tokens.
190      */
191     function tokenByIndex(uint256 index) external view returns (uint256);
192 }
193 
194 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
195 
196 
197 
198 pragma solidity ^0.8.0;
199 
200 
201 /**
202  * @dev Implementation of the {IERC165} interface.
203  *
204  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
205  * for the additional interface id that will be supported. For example:
206  *
207  * ```solidity
208  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
209  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
210  * }
211  * ```
212  *
213  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
214  */
215 abstract contract ERC165 is IERC165 {
216     /**
217      * @dev See {IERC165-supportsInterface}.
218      */
219     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
220         return interfaceId == type(IERC165).interfaceId;
221     }
222 }
223 
224 // File: @openzeppelin/contracts/utils/Strings.sol
225 
226 
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev String operations.
232  */
233 library Strings {
234     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
235 
236     /**
237      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
238      */
239     function toString(uint256 value) internal pure returns (string memory) {
240         // Inspired by OraclizeAPI's implementation - MIT licence
241         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
242 
243         if (value == 0) {
244             return "0";
245         }
246         uint256 temp = value;
247         uint256 digits;
248         while (temp != 0) {
249             digits++;
250             temp /= 10;
251         }
252         bytes memory buffer = new bytes(digits);
253         while (value != 0) {
254             digits -= 1;
255             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
256             value /= 10;
257         }
258         return string(buffer);
259     }
260 
261     /**
262      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
263      */
264     function toHexString(uint256 value) internal pure returns (string memory) {
265         if (value == 0) {
266             return "0x00";
267         }
268         uint256 temp = value;
269         uint256 length = 0;
270         while (temp != 0) {
271             length++;
272             temp >>= 8;
273         }
274         return toHexString(value, length);
275     }
276 
277     /**
278      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
279      */
280     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
281         bytes memory buffer = new bytes(2 * length + 2);
282         buffer[0] = "0";
283         buffer[1] = "x";
284         for (uint256 i = 2 * length + 1; i > 1; --i) {
285             buffer[i] = _HEX_SYMBOLS[value & 0xf];
286             value >>= 4;
287         }
288         require(value == 0, "Strings: hex length insufficient");
289         return string(buffer);
290     }
291 }
292 
293 // File: @openzeppelin/contracts/utils/Address.sol
294 
295 
296 
297 pragma solidity ^0.8.0;
298 
299 /**
300  * @dev Collection of functions related to the address type
301  */
302 library Address {
303     /**
304      * @dev Returns true if `account` is a contract.
305      *
306      * [IMPORTANT]
307      * ====
308      * It is unsafe to assume that an address for which this function returns
309      * false is an externally-owned account (EOA) and not a contract.
310      *
311      * Among others, `isContract` will return false for the following
312      * types of addresses:
313      *
314      *  - an externally-owned account
315      *  - a contract in construction
316      *  - an address where a contract will be created
317      *  - an address where a contract lived, but was destroyed
318      * ====
319      */
320     function isContract(address account) internal view returns (bool) {
321         // This method relies on extcodesize, which returns 0 for contracts in
322         // construction, since the code is only stored at the end of the
323         // constructor execution.
324 
325         uint256 size;
326         assembly {
327             size := extcodesize(account)
328         }
329         return size > 0;
330     }
331 
332     /**
333      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
334      * `recipient`, forwarding all available gas and reverting on errors.
335      *
336      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
337      * of certain opcodes, possibly making contracts go over the 2300 gas limit
338      * imposed by `transfer`, making them unable to receive funds via
339      * `transfer`. {sendValue} removes this limitation.
340      *
341      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
342      *
343      * IMPORTANT: because control is transferred to `recipient`, care must be
344      * taken to not create reentrancy vulnerabilities. Consider using
345      * {ReentrancyGuard} or the
346      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
347      */
348     function sendValue(address payable recipient, uint256 amount) internal {
349         require(address(this).balance >= amount, "Address: insufficient balance");
350 
351         (bool success, ) = recipient.call{value: amount}("");
352         require(success, "Address: unable to send value, recipient may have reverted");
353     }
354 
355     /**
356      * @dev Performs a Solidity function call using a low level `call`. A
357      * plain `call` is an unsafe replacement for a function call: use this
358      * function instead.
359      *
360      * If `target` reverts with a revert reason, it is bubbled up by this
361      * function (like regular Solidity function calls).
362      *
363      * Returns the raw returned data. To convert to the expected return value,
364      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
365      *
366      * Requirements:
367      *
368      * - `target` must be a contract.
369      * - calling `target` with `data` must not revert.
370      *
371      * _Available since v3.1._
372      */
373     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
374         return functionCall(target, data, "Address: low-level call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
379      * `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         return functionCallWithValue(target, data, 0, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but also transferring `value` wei to `target`.
394      *
395      * Requirements:
396      *
397      * - the calling contract must have an ETH balance of at least `value`.
398      * - the called Solidity function must be `payable`.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(
403         address target,
404         bytes memory data,
405         uint256 value
406     ) internal returns (bytes memory) {
407         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
412      * with `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(
417         address target,
418         bytes memory data,
419         uint256 value,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(address(this).balance >= value, "Address: insufficient balance for call");
423         require(isContract(target), "Address: call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.call{value: value}(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a static call.
432      *
433      * _Available since v3.3._
434      */
435     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
436         return functionStaticCall(target, data, "Address: low-level static call failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
441      * but performing a static call.
442      *
443      * _Available since v3.3._
444      */
445     function functionStaticCall(
446         address target,
447         bytes memory data,
448         string memory errorMessage
449     ) internal view returns (bytes memory) {
450         require(isContract(target), "Address: static call to non-contract");
451 
452         (bool success, bytes memory returndata) = target.staticcall(data);
453         return verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
463         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
468      * but performing a delegate call.
469      *
470      * _Available since v3.4._
471      */
472     function functionDelegateCall(
473         address target,
474         bytes memory data,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         require(isContract(target), "Address: delegate call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.delegatecall(data);
480         return verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
485      * revert reason using the provided one.
486      *
487      * _Available since v4.3._
488      */
489     function verifyCallResult(
490         bool success,
491         bytes memory returndata,
492         string memory errorMessage
493     ) internal pure returns (bytes memory) {
494         if (success) {
495             return returndata;
496         } else {
497             // Look for revert reason and bubble it up if present
498             if (returndata.length > 0) {
499                 // The easiest way to bubble the revert reason is using memory via assembly
500 
501                 assembly {
502                     let returndata_size := mload(returndata)
503                     revert(add(32, returndata), returndata_size)
504                 }
505             } else {
506                 revert(errorMessage);
507             }
508         }
509     }
510 }
511 
512 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
513 
514 
515 
516 pragma solidity ^0.8.0;
517 
518 
519 /**
520  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
521  * @dev See https://eips.ethereum.org/EIPS/eip-721
522  */
523 interface IERC721Metadata is IERC721 {
524     /**
525      * @dev Returns the token collection name.
526      */
527     function name() external view returns (string memory);
528 
529     /**
530      * @dev Returns the token collection symbol.
531      */
532     function symbol() external view returns (string memory);
533 
534     /**
535      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
536      */
537     function tokenURI(uint256 tokenId) external view returns (string memory);
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
541 
542 
543 
544 pragma solidity ^0.8.0;
545 
546 /**
547  * @title ERC721 token receiver interface
548  * @dev Interface for any contract that wants to support safeTransfers
549  * from ERC721 asset contracts.
550  */
551 interface IERC721Receiver {
552     /**
553      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
554      * by `operator` from `from`, this function is called.
555      *
556      * It must return its Solidity selector to confirm the token transfer.
557      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
558      *
559      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
560      */
561     function onERC721Received(
562         address operator,
563         address from,
564         uint256 tokenId,
565         bytes calldata data
566     ) external returns (bytes4);
567 }
568 
569 // File: @openzeppelin/contracts/utils/Context.sol
570 
571 
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @dev Provides information about the current execution context, including the
577  * sender of the transaction and its data. While these are generally available
578  * via msg.sender and msg.data, they should not be accessed in such a direct
579  * manner, since when dealing with meta-transactions the account sending and
580  * paying for execution may not be the actual sender (as far as an application
581  * is concerned).
582  *
583  * This contract is only required for intermediate, library-like contracts.
584  */
585 abstract contract Context {
586     function _msgSender() internal view virtual returns (address) {
587         return msg.sender;
588     }
589 
590     function _msgData() internal view virtual returns (bytes calldata) {
591         return msg.data;
592     }
593 }
594 
595 
596 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
597 pragma solidity ^0.8.0;
598 /**
599  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
600  * the Metadata extension, but not including the Enumerable extension, which is available separately as
601  * {ERC721Enumerable}.
602  */
603 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
604     using Address for address;
605     using Strings for uint256;
606 
607     // Token name
608     string private _name;
609 
610     // Token symbol
611     string private _symbol;
612 
613     // Mapping from token ID to owner address
614     mapping(uint256 => address) private _owners;
615 
616     // Mapping owner address to token count
617     mapping(address => uint256) private _balances;
618 
619     // Mapping from token ID to approved address
620     mapping(uint256 => address) private _tokenApprovals;
621 
622     // Mapping from owner to operator approvals
623     mapping(address => mapping(address => bool)) private _operatorApprovals;
624 
625     /**
626      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
627      */
628     constructor(string memory name_, string memory symbol_) {
629         _name = name_;
630         _symbol = symbol_;
631     }
632 
633     /**
634      * @dev See {IERC165-supportsInterface}.
635      */
636     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
637         return
638             interfaceId == type(IERC721).interfaceId ||
639             interfaceId == type(IERC721Metadata).interfaceId ||
640             super.supportsInterface(interfaceId);
641     }
642 
643     /**
644      * @dev See {IERC721-balanceOf}.
645      */
646     function balanceOf(address owner) public view virtual override returns (uint256) {
647         require(owner != address(0), "ERC721: balance query for the zero address");
648         return _balances[owner];
649     }
650 
651     /**
652      * @dev See {IERC721-ownerOf}.
653      */
654     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
655         address owner = _owners[tokenId];
656         require(owner != address(0), "ERC721: owner query for nonexistent token");
657         return owner;
658     }
659 
660     /**
661      * @dev See {IERC721Metadata-name}.
662      */
663     function name() public view virtual override returns (string memory) {
664         return _name;
665     }
666 
667     /**
668      * @dev See {IERC721Metadata-symbol}.
669      */
670     function symbol() public view virtual override returns (string memory) {
671         return _symbol;
672     }
673 
674     /**
675      * @dev See {IERC721Metadata-tokenURI}.
676      */
677     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
678         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
679 
680         string memory baseURI = _baseURI();
681         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
682     }
683 
684     /**
685      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
686      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
687      * by default, can be overriden in child contracts.
688      */
689     function _baseURI() internal view virtual returns (string memory) {
690         return "";
691     }
692 
693     /**
694      * @dev See {IERC721-approve}.
695      */
696     function approve(address to, uint256 tokenId) public virtual override {
697         address owner = ERC721.ownerOf(tokenId);
698         require(to != owner, "ERC721: approval to current owner");
699 
700         require(
701             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
702             "ERC721: approve caller is not owner nor approved for all"
703         );
704 
705         _approve(to, tokenId);
706     }
707 
708     /**
709      * @dev See {IERC721-getApproved}.
710      */
711     function getApproved(uint256 tokenId) public view virtual override returns (address) {
712         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
713 
714         return _tokenApprovals[tokenId];
715     }
716 
717     /**
718      * @dev See {IERC721-setApprovalForAll}.
719      */
720     function setApprovalForAll(address operator, bool approved) public virtual override {
721         require(operator != _msgSender(), "ERC721: approve to caller");
722 
723         _operatorApprovals[_msgSender()][operator] = approved;
724         emit ApprovalForAll(_msgSender(), operator, approved);
725     }
726 
727     /**
728      * @dev See {IERC721-isApprovedForAll}.
729      */
730     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
731         return _operatorApprovals[owner][operator];
732     }
733 
734     /**
735      * @dev See {IERC721-transferFrom}.
736      */
737     function transferFrom(
738         address from,
739         address to,
740         uint256 tokenId
741     ) public virtual override {
742         //solhint-disable-next-line max-line-length
743         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
744 
745         _transfer(from, to, tokenId);
746     }
747 
748     /**
749      * @dev See {IERC721-safeTransferFrom}.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId
755     ) public virtual override {
756         safeTransferFrom(from, to, tokenId, "");
757     }
758 
759     /**
760      * @dev See {IERC721-safeTransferFrom}.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId,
766         bytes memory _data
767     ) public virtual override {
768         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
769         _safeTransfer(from, to, tokenId, _data);
770     }
771 
772     /**
773      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
774      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
775      *
776      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
777      *
778      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
779      * implement alternative mechanisms to perform token transfer, such as signature-based.
780      *
781      * Requirements:
782      *
783      * - `from` cannot be the zero address.
784      * - `to` cannot be the zero address.
785      * - `tokenId` token must exist and be owned by `from`.
786      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
787      *
788      * Emits a {Transfer} event.
789      */
790     function _safeTransfer(
791         address from,
792         address to,
793         uint256 tokenId,
794         bytes memory _data
795     ) internal virtual {
796         _transfer(from, to, tokenId);
797         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
798     }
799 
800     /**
801      * @dev Returns whether `tokenId` exists.
802      *
803      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
804      *
805      * Tokens start existing when they are minted (`_mint`),
806      * and stop existing when they are burned (`_burn`).
807      */
808     function _exists(uint256 tokenId) internal view virtual returns (bool) {
809         return _owners[tokenId] != address(0);
810     }
811 
812     /**
813      * @dev Returns whether `spender` is allowed to manage `tokenId`.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must exist.
818      */
819     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
820         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
821         address owner = ERC721.ownerOf(tokenId);
822         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
823     }
824 
825     /**
826      * @dev Safely mints `tokenId` and transfers it to `to`.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must not exist.
831      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _safeMint(address to, uint256 tokenId) internal virtual {
836         _safeMint(to, tokenId, "");
837     }
838 
839     /**
840      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
841      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
842      */
843     function _safeMint(
844         address to,
845         uint256 tokenId,
846         bytes memory _data
847     ) internal virtual {
848         _mint(to, tokenId);
849         require(
850             _checkOnERC721Received(address(0), to, tokenId, _data),
851             "ERC721: transfer to non ERC721Receiver implementer"
852         );
853     }
854 
855     /**
856      * @dev Mints `tokenId` and transfers it to `to`.
857      *
858      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
859      *
860      * Requirements:
861      *
862      * - `tokenId` must not exist.
863      * - `to` cannot be the zero address.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _mint(address to, uint256 tokenId) internal virtual {
868         require(to != address(0), "ERC721: mint to the zero address");
869         require(!_exists(tokenId), "ERC721: token already minted");
870 
871         _beforeTokenTransfer(address(0), to, tokenId);
872 
873         _balances[to] += 1;
874         _owners[tokenId] = to;
875 
876         emit Transfer(address(0), to, tokenId);
877     }
878 
879     /**
880      * @dev Destroys `tokenId`.
881      * The approval is cleared when the token is burned.
882      *
883      * Requirements:
884      *
885      * - `tokenId` must exist.
886      *
887      * Emits a {Transfer} event.
888      */
889     function _burn(uint256 tokenId) internal virtual {
890         address owner = ERC721.ownerOf(tokenId);
891 
892         _beforeTokenTransfer(owner, address(0), tokenId);
893 
894         // Clear approvals
895         _approve(address(0), tokenId);
896 
897         _balances[owner] -= 1;
898         delete _owners[tokenId];
899 
900         emit Transfer(owner, address(0), tokenId);
901     }
902 
903     /**
904      * @dev Transfers `tokenId` from `from` to `to`.
905      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
906      *
907      * Requirements:
908      *
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must be owned by `from`.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _transfer(
915         address from,
916         address to,
917         uint256 tokenId
918     ) internal virtual {
919         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
920         require(to != address(0), "ERC721: transfer to the zero address");
921 
922         _beforeTokenTransfer(from, to, tokenId);
923 
924         // Clear approvals from the previous owner
925         _approve(address(0), tokenId);
926 
927         _balances[from] -= 1;
928         _balances[to] += 1;
929         _owners[tokenId] = to;
930 
931         emit Transfer(from, to, tokenId);
932     }
933 
934     /**
935      * @dev Approve `to` to operate on `tokenId`
936      *
937      * Emits a {Approval} event.
938      */
939     function _approve(address to, uint256 tokenId) internal virtual {
940         _tokenApprovals[tokenId] = to;
941         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
942     }
943 
944     /**
945      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
946      * The call is not executed if the target address is not a contract.
947      *
948      * @param from address representing the previous owner of the given token ID
949      * @param to target address that will receive the tokens
950      * @param tokenId uint256 ID of the token to be transferred
951      * @param _data bytes optional data to send along with the call
952      * @return bool whether the call correctly returned the expected magic value
953      */
954     function _checkOnERC721Received(
955         address from,
956         address to,
957         uint256 tokenId,
958         bytes memory _data
959     ) private returns (bool) {
960         if (to.isContract()) {
961             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
962                 return retval == IERC721Receiver.onERC721Received.selector;
963             } catch (bytes memory reason) {
964                 if (reason.length == 0) {
965                     revert("ERC721: transfer to non ERC721Receiver implementer");
966                 } else {
967                     assembly {
968                         revert(add(32, reason), mload(reason))
969                     }
970                 }
971             }
972         } else {
973             return true;
974         }
975     }
976 
977     /**
978      * @dev Hook that is called before any token transfer. This includes minting
979      * and burning.
980      *
981      * Calling conditions:
982      *
983      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
984      * transferred to `to`.
985      * - When `from` is zero, `tokenId` will be minted for `to`.
986      * - When `to` is zero, ``from``'s `tokenId` will be burned.
987      * - `from` and `to` are never both zero.
988      *
989      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
990      */
991     function _beforeTokenTransfer(
992         address from,
993         address to,
994         uint256 tokenId
995     ) internal virtual {}
996 }
997 
998 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
999 
1000 
1001 
1002 pragma solidity ^0.8.0;
1003 
1004 
1005 
1006 /**
1007  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1008  * enumerability of all the token ids in the contract as well as all token ids owned by each
1009  * account.
1010  */
1011 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1012     // Mapping from owner to list of owned token IDs
1013     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1014 
1015     // Mapping from token ID to index of the owner tokens list
1016     mapping(uint256 => uint256) private _ownedTokensIndex;
1017 
1018     // Array with all token ids, used for enumeration
1019     uint256[] private _allTokens;
1020 
1021     // Mapping from token id to position in the allTokens array
1022     mapping(uint256 => uint256) private _allTokensIndex;
1023 
1024     /**
1025      * @dev See {IERC165-supportsInterface}.
1026      */
1027     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1028         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1033      */
1034     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1035         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1036         return _ownedTokens[owner][index];
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Enumerable-totalSupply}.
1041      */
1042     function totalSupply() public view virtual override returns (uint256) {
1043         return _allTokens.length;
1044     }
1045 
1046     /**
1047      * @dev See {IERC721Enumerable-tokenByIndex}.
1048      */
1049     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1050         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1051         return _allTokens[index];
1052     }
1053 
1054     /**
1055      * @dev Hook that is called before any token transfer. This includes minting
1056      * and burning.
1057      *
1058      * Calling conditions:
1059      *
1060      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1061      * transferred to `to`.
1062      * - When `from` is zero, `tokenId` will be minted for `to`.
1063      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1064      * - `from` cannot be the zero address.
1065      * - `to` cannot be the zero address.
1066      *
1067      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1068      */
1069     function _beforeTokenTransfer(
1070         address from,
1071         address to,
1072         uint256 tokenId
1073     ) internal virtual override {
1074         super._beforeTokenTransfer(from, to, tokenId);
1075 
1076         if (from == address(0)) {
1077             _addTokenToAllTokensEnumeration(tokenId);
1078         } else if (from != to) {
1079             _removeTokenFromOwnerEnumeration(from, tokenId);
1080         }
1081         if (to == address(0)) {
1082             _removeTokenFromAllTokensEnumeration(tokenId);
1083         } else if (to != from) {
1084             _addTokenToOwnerEnumeration(to, tokenId);
1085         }
1086     }
1087 
1088     /**
1089      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1090      * @param to address representing the new owner of the given token ID
1091      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1092      */
1093     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1094         uint256 length = ERC721.balanceOf(to);
1095         _ownedTokens[to][length] = tokenId;
1096         _ownedTokensIndex[tokenId] = length;
1097     }
1098 
1099     /**
1100      * @dev Private function to add a token to this extension's token tracking data structures.
1101      * @param tokenId uint256 ID of the token to be added to the tokens list
1102      */
1103     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1104         _allTokensIndex[tokenId] = _allTokens.length;
1105         _allTokens.push(tokenId);
1106     }
1107 
1108     /**
1109      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1110      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1111      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1112      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1113      * @param from address representing the previous owner of the given token ID
1114      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1115      */
1116     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1117         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1118         // then delete the last slot (swap and pop).
1119 
1120         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1121         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1122 
1123         // When the token to delete is the last token, the swap operation is unnecessary
1124         if (tokenIndex != lastTokenIndex) {
1125             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1126 
1127             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1128             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1129         }
1130 
1131         // This also deletes the contents at the last position of the array
1132         delete _ownedTokensIndex[tokenId];
1133         delete _ownedTokens[from][lastTokenIndex];
1134     }
1135 
1136     /**
1137      * @dev Private function to remove a token from this extension's token tracking data structures.
1138      * This has O(1) time complexity, but alters the order of the _allTokens array.
1139      * @param tokenId uint256 ID of the token to be removed from the tokens list
1140      */
1141     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1142         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1143         // then delete the last slot (swap and pop).
1144 
1145         uint256 lastTokenIndex = _allTokens.length - 1;
1146         uint256 tokenIndex = _allTokensIndex[tokenId];
1147 
1148         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1149         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1150         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1151         uint256 lastTokenId = _allTokens[lastTokenIndex];
1152 
1153         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1154         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1155 
1156         // This also deletes the contents at the last position of the array
1157         delete _allTokensIndex[tokenId];
1158         _allTokens.pop();
1159     }
1160 }
1161 
1162 
1163 
1164 // File: @openzeppelin/contracts/access/Ownable.sol
1165 
1166 
1167 
1168 pragma solidity ^0.8.0;
1169 
1170 
1171 /**
1172  * @dev Contract module which provides a basic access control mechanism, where
1173  * there is an account (an owner) that can be granted exclusive access to
1174  * specific functions.
1175  *
1176  * By default, the owner account will be the one that deploys the contract. This
1177  * can later be changed with {transferOwnership}.
1178  *
1179  * This module is used through inheritance. It will make available the modifier
1180  * `onlyOwner`, which can be applied to your functions to restrict their use to
1181  * the owner.
1182  */
1183 abstract contract Ownable is Context {
1184     address private _owner;
1185 
1186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1187 
1188     /**
1189      * @dev Initializes the contract setting the deployer as the initial owner.
1190      */
1191     constructor() {
1192         _setOwner(_msgSender());
1193     }
1194 
1195     /**
1196      * @dev Returns the address of the current owner.
1197      */
1198     function owner() public view virtual returns (address) {
1199         return _owner;
1200     }
1201 
1202     /**
1203      * @dev Throws if called by any account other than the owner.
1204      */
1205     modifier onlyOwner() {
1206         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1207         _;
1208     }
1209 
1210     /**
1211      * @dev Leaves the contract without owner. It will not be possible to call
1212      * `onlyOwner` functions anymore. Can only be called by the current owner.
1213      *
1214      * NOTE: Renouncing ownership will leave the contract without an owner,
1215      * thereby removing any functionality that is only available to the owner.
1216      */
1217     function renounceOwnership() public virtual onlyOwner {
1218         _setOwner(address(0));
1219     }
1220 
1221     /**
1222      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1223      * Can only be called by the current owner.
1224      */
1225     function transferOwnership(address newOwner) public virtual onlyOwner {
1226         require(newOwner != address(0), "Ownable: new owner is the zero address");
1227         _setOwner(newOwner);
1228     }
1229 
1230     function _setOwner(address newOwner) private {
1231         address oldOwner = _owner;
1232         _owner = newOwner;
1233         emit OwnershipTransferred(oldOwner, newOwner);
1234     }
1235 }
1236 
1237 // File: tests/JustSpliffs.sol
1238 
1239 
1240 
1241 pragma solidity >=0.7.0 <0.9.0;
1242 
1243 
1244 
1245 
1246 contract JustSpliffs is ERC721Enumerable, Ownable {
1247   using Strings for uint256;
1248 
1249   string public baseURI;
1250   string public baseExtension = ".json";
1251   uint256 public cost = 0.042 ether;
1252   uint256 public maxSupply = 420;
1253   uint256 public maxMintAmount = 10;
1254   bool public paused = true;
1255   mapping(address => bool) public whitelisted;
1256 
1257   constructor(
1258     string memory _name,
1259     string memory _symbol,
1260     string memory _initBaseURI
1261   ) ERC721(_name, _symbol) {
1262     setBaseURI(_initBaseURI);
1263    
1264   }
1265 
1266   // internal
1267   function _baseURI() internal view virtual override returns (string memory) {
1268     return baseURI;
1269   }
1270 
1271   // public
1272   function mint(address _to, uint256 _mintAmount) public payable {
1273     uint256 supply = totalSupply();
1274     require(!paused);
1275     require(_mintAmount > 0);
1276     require(_mintAmount <= maxMintAmount);
1277     require(supply + _mintAmount <= maxSupply);
1278     require(msg.value >= cost * _mintAmount);
1279         
1280     
1281 
1282     for (uint256 i = 1; i <= _mintAmount; i++) {
1283       _safeMint(_to, supply + i);
1284     }
1285   }
1286 
1287   function walletOfOwner(address _owner)
1288     public
1289     view
1290     returns (uint256[] memory)
1291   {
1292     uint256 ownerTokenCount = balanceOf(_owner);
1293     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1294     for (uint256 i; i < ownerTokenCount; i++) {
1295       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1296     }
1297     return tokenIds;
1298   }
1299 
1300   function tokenURI(uint256 tokenId)
1301     public
1302     view
1303     virtual
1304     override
1305     returns (string memory)
1306   {
1307     require(
1308       _exists(tokenId),
1309       "ERC721Metadata: URI query for nonexistent token"
1310     );
1311 
1312     string memory currentBaseURI = _baseURI();
1313     return bytes(currentBaseURI).length > 0
1314         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1315         : "";
1316   }
1317 
1318   //only owner
1319   
1320 
1321   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1322     maxMintAmount = _newmaxMintAmount;
1323   }
1324 
1325   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1326     baseURI = _newBaseURI;
1327   }
1328 
1329   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1330     baseExtension = _newBaseExtension;
1331   }
1332 
1333   function pause(bool _state) public onlyOwner {
1334     paused = _state;
1335   }
1336  
1337  
1338 
1339    function withdrawAll() public payable onlyOwner {
1340     require(payable(msg.sender).send(address(this).balance));
1341   }
1342 }