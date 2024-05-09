1 // Sources flattened with hardhat v2.6.5 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
4 
5 // SPDX-License-Identifier: MIT
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
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
32 
33 
34 pragma solidity ^0.8.0;
35 
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
174 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
175 
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @title ERC721 token receiver interface
181  * @dev Interface for any contract that wants to support safeTransfers
182  * from ERC721 asset contracts.
183  */
184 interface IERC721Receiver {
185     /**
186      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
187      * by `operator` from `from`, this function is called.
188      *
189      * It must return its Solidity selector to confirm the token transfer.
190      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
191      *
192      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
193      */
194     function onERC721Received(
195         address operator,
196         address from,
197         uint256 tokenId,
198         bytes calldata data
199     ) external returns (bytes4);
200 }
201 
202 
203 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
204 
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
210  * @dev See https://eips.ethereum.org/EIPS/eip-721
211  */
212 interface IERC721Metadata is IERC721 {
213     /**
214      * @dev Returns the token collection name.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the token collection symbol.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
225      */
226     function tokenURI(uint256 tokenId) external view returns (string memory);
227 }
228 
229 
230 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
231 
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // This method relies on extcodesize, which returns 0 for contracts in
258         // construction, since the code is only stored at the end of the
259         // constructor execution.
260 
261         uint256 size;
262         assembly {
263             size := extcodesize(account)
264         }
265         return size > 0;
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         (bool success, ) = recipient.call{value: amount}("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain `call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         require(isContract(target), "Address: call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.call{value: value}(data);
362         return verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal view returns (bytes memory) {
386         require(isContract(target), "Address: static call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.staticcall(data);
389         return verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
399         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(isContract(target), "Address: delegate call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.delegatecall(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
421      * revert reason using the provided one.
422      *
423      * _Available since v4.3._
424      */
425     function verifyCallResult(
426         bool success,
427         bytes memory returndata,
428         string memory errorMessage
429     ) internal pure returns (bytes memory) {
430         if (success) {
431             return returndata;
432         } else {
433             // Look for revert reason and bubble it up if present
434             if (returndata.length > 0) {
435                 // The easiest way to bubble the revert reason is using memory via assembly
436 
437                 assembly {
438                     let returndata_size := mload(returndata)
439                     revert(add(32, returndata), returndata_size)
440                 }
441             } else {
442                 revert(errorMessage);
443             }
444         }
445     }
446 }
447 
448 
449 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
450 
451 
452 pragma solidity ^0.8.0;
453 
454 /**
455  * @dev Provides information about the current execution context, including the
456  * sender of the transaction and its data. While these are generally available
457  * via msg.sender and msg.data, they should not be accessed in such a direct
458  * manner, since when dealing with meta-transactions the account sending and
459  * paying for execution may not be the actual sender (as far as an application
460  * is concerned).
461  *
462  * This contract is only required for intermediate, library-like contracts.
463  */
464 abstract contract Context {
465     function _msgSender() internal view virtual returns (address) {
466         return msg.sender;
467     }
468 
469     function _msgData() internal view virtual returns (bytes calldata) {
470         return msg.data;
471     }
472 }
473 
474 
475 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
476 
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev String operations.
482  */
483 library Strings {
484     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
485 
486     /**
487      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
488      */
489     function toString(uint256 value) internal pure returns (string memory) {
490         // Inspired by OraclizeAPI's implementation - MIT licence
491         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
492 
493         if (value == 0) {
494             return "0";
495         }
496         uint256 temp = value;
497         uint256 digits;
498         while (temp != 0) {
499             digits++;
500             temp /= 10;
501         }
502         bytes memory buffer = new bytes(digits);
503         while (value != 0) {
504             digits -= 1;
505             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
506             value /= 10;
507         }
508         return string(buffer);
509     }
510 
511     /**
512      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
513      */
514     function toHexString(uint256 value) internal pure returns (string memory) {
515         if (value == 0) {
516             return "0x00";
517         }
518         uint256 temp = value;
519         uint256 length = 0;
520         while (temp != 0) {
521             length++;
522             temp >>= 8;
523         }
524         return toHexString(value, length);
525     }
526 
527     /**
528      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
529      */
530     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
531         bytes memory buffer = new bytes(2 * length + 2);
532         buffer[0] = "0";
533         buffer[1] = "x";
534         for (uint256 i = 2 * length + 1; i > 1; --i) {
535             buffer[i] = _HEX_SYMBOLS[value & 0xf];
536             value >>= 4;
537         }
538         require(value == 0, "Strings: hex length insufficient");
539         return string(buffer);
540     }
541 }
542 
543 
544 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
545 
546 
547 pragma solidity ^0.8.0;
548 
549 /**
550  * @dev Implementation of the {IERC165} interface.
551  *
552  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
553  * for the additional interface id that will be supported. For example:
554  *
555  * ```solidity
556  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
558  * }
559  * ```
560  *
561  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
562  */
563 abstract contract ERC165 is IERC165 {
564     /**
565      * @dev See {IERC165-supportsInterface}.
566      */
567     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568         return interfaceId == type(IERC165).interfaceId;
569     }
570 }
571 
572 
573 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
574 
575 
576 pragma solidity ^0.8.0;
577 
578 
579 
580 
581 
582 
583 
584 /**
585  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
586  * the Metadata extension, but not including the Enumerable extension, which is available separately as
587  * {ERC721Enumerable}.
588  */
589 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
590     using Address for address;
591     using Strings for uint256;
592 
593     // Token name
594     string private _name;
595 
596     // Token symbol
597     string private _symbol;
598 
599     // Mapping from token ID to owner address
600     mapping(uint256 => address) private _owners;
601 
602     // Mapping owner address to token count
603     mapping(address => uint256) private _balances;
604 
605     // Mapping from token ID to approved address
606     mapping(uint256 => address) private _tokenApprovals;
607 
608     // Mapping from owner to operator approvals
609     mapping(address => mapping(address => bool)) private _operatorApprovals;
610 
611     /**
612      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
613      */
614     constructor(string memory name_, string memory symbol_) {
615         _name = name_;
616         _symbol = symbol_;
617     }
618 
619     /**
620      * @dev See {IERC165-supportsInterface}.
621      */
622     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
623         return
624             interfaceId == type(IERC721).interfaceId ||
625             interfaceId == type(IERC721Metadata).interfaceId ||
626             super.supportsInterface(interfaceId);
627     }
628 
629     /**
630      * @dev See {IERC721-balanceOf}.
631      */
632     function balanceOf(address owner) public view virtual override returns (uint256) {
633         require(owner != address(0), "ERC721: balance query for the zero address");
634         return _balances[owner];
635     }
636 
637     /**
638      * @dev See {IERC721-ownerOf}.
639      */
640     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
641         address owner = _owners[tokenId];
642         require(owner != address(0), "ERC721: owner query for nonexistent token");
643         return owner;
644     }
645 
646     /**
647      * @dev See {IERC721Metadata-name}.
648      */
649     function name() public view virtual override returns (string memory) {
650         return _name;
651     }
652 
653     /**
654      * @dev See {IERC721Metadata-symbol}.
655      */
656     function symbol() public view virtual override returns (string memory) {
657         return _symbol;
658     }
659 
660     /**
661      * @dev See {IERC721Metadata-tokenURI}.
662      */
663     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
664         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
665 
666         string memory baseURI = _baseURI();
667         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
668     }
669 
670     /**
671      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
672      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
673      * by default, can be overriden in child contracts.
674      */
675     function _baseURI() internal view virtual returns (string memory) {
676         return "";
677     }
678 
679     /**
680      * @dev See {IERC721-approve}.
681      */
682     function approve(address to, uint256 tokenId) public virtual override {
683         address owner = ERC721.ownerOf(tokenId);
684         require(to != owner, "ERC721: approval to current owner");
685 
686         require(
687             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
688             "ERC721: approve caller is not owner nor approved for all"
689         );
690 
691         _approve(to, tokenId);
692     }
693 
694     /**
695      * @dev See {IERC721-getApproved}.
696      */
697     function getApproved(uint256 tokenId) public view virtual override returns (address) {
698         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
699 
700         return _tokenApprovals[tokenId];
701     }
702 
703     /**
704      * @dev See {IERC721-setApprovalForAll}.
705      */
706     function setApprovalForAll(address operator, bool approved) public virtual override {
707         require(operator != _msgSender(), "ERC721: approve to caller");
708 
709         _operatorApprovals[_msgSender()][operator] = approved;
710         emit ApprovalForAll(_msgSender(), operator, approved);
711     }
712 
713     /**
714      * @dev See {IERC721-isApprovedForAll}.
715      */
716     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
717         return _operatorApprovals[owner][operator];
718     }
719 
720     /**
721      * @dev See {IERC721-transferFrom}.
722      */
723     function transferFrom(
724         address from,
725         address to,
726         uint256 tokenId
727     ) public virtual override {
728         //solhint-disable-next-line max-line-length
729         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
730 
731         _transfer(from, to, tokenId);
732     }
733 
734     /**
735      * @dev See {IERC721-safeTransferFrom}.
736      */
737     function safeTransferFrom(
738         address from,
739         address to,
740         uint256 tokenId
741     ) public virtual override {
742         safeTransferFrom(from, to, tokenId, "");
743     }
744 
745     /**
746      * @dev See {IERC721-safeTransferFrom}.
747      */
748     function safeTransferFrom(
749         address from,
750         address to,
751         uint256 tokenId,
752         bytes memory _data
753     ) public virtual override {
754         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
755         _safeTransfer(from, to, tokenId, _data);
756     }
757 
758     /**
759      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
760      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
761      *
762      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
763      *
764      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
765      * implement alternative mechanisms to perform token transfer, such as signature-based.
766      *
767      * Requirements:
768      *
769      * - `from` cannot be the zero address.
770      * - `to` cannot be the zero address.
771      * - `tokenId` token must exist and be owned by `from`.
772      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
773      *
774      * Emits a {Transfer} event.
775      */
776     function _safeTransfer(
777         address from,
778         address to,
779         uint256 tokenId,
780         bytes memory _data
781     ) internal virtual {
782         _transfer(from, to, tokenId);
783         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
784     }
785 
786     /**
787      * @dev Returns whether `tokenId` exists.
788      *
789      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
790      *
791      * Tokens start existing when they are minted (`_mint`),
792      * and stop existing when they are burned (`_burn`).
793      */
794     function _exists(uint256 tokenId) internal view virtual returns (bool) {
795         return _owners[tokenId] != address(0);
796     }
797 
798     /**
799      * @dev Returns whether `spender` is allowed to manage `tokenId`.
800      *
801      * Requirements:
802      *
803      * - `tokenId` must exist.
804      */
805     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
806         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
807         address owner = ERC721.ownerOf(tokenId);
808         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
809     }
810 
811     /**
812      * @dev Safely mints `tokenId` and transfers it to `to`.
813      *
814      * Requirements:
815      *
816      * - `tokenId` must not exist.
817      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
818      *
819      * Emits a {Transfer} event.
820      */
821     function _safeMint(address to, uint256 tokenId) internal virtual {
822         _safeMint(to, tokenId, "");
823     }
824 
825     /**
826      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
827      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
828      */
829     function _safeMint(
830         address to,
831         uint256 tokenId,
832         bytes memory _data
833     ) internal virtual {
834         _mint(to, tokenId);
835         require(
836             _checkOnERC721Received(address(0), to, tokenId, _data),
837             "ERC721: transfer to non ERC721Receiver implementer"
838         );
839     }
840 
841     /**
842      * @dev Mints `tokenId` and transfers it to `to`.
843      *
844      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
845      *
846      * Requirements:
847      *
848      * - `tokenId` must not exist.
849      * - `to` cannot be the zero address.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _mint(address to, uint256 tokenId) internal virtual {
854         require(to != address(0), "ERC721: mint to the zero address");
855         require(!_exists(tokenId), "ERC721: token already minted");
856 
857         _beforeTokenTransfer(address(0), to, tokenId);
858 
859         _balances[to] += 1;
860         _owners[tokenId] = to;
861 
862         emit Transfer(address(0), to, tokenId);
863     }
864 
865     /**
866      * @dev Destroys `tokenId`.
867      * The approval is cleared when the token is burned.
868      *
869      * Requirements:
870      *
871      * - `tokenId` must exist.
872      *
873      * Emits a {Transfer} event.
874      */
875     function _burn(uint256 tokenId) internal virtual {
876         address owner = ERC721.ownerOf(tokenId);
877 
878         _beforeTokenTransfer(owner, address(0), tokenId);
879 
880         // Clear approvals
881         _approve(address(0), tokenId);
882 
883         _balances[owner] -= 1;
884         delete _owners[tokenId];
885 
886         emit Transfer(owner, address(0), tokenId);
887     }
888 
889     /**
890      * @dev Transfers `tokenId` from `from` to `to`.
891      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
892      *
893      * Requirements:
894      *
895      * - `to` cannot be the zero address.
896      * - `tokenId` token must be owned by `from`.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _transfer(
901         address from,
902         address to,
903         uint256 tokenId
904     ) internal virtual {
905         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
906         require(to != address(0), "ERC721: transfer to the zero address");
907 
908         _beforeTokenTransfer(from, to, tokenId);
909 
910         // Clear approvals from the previous owner
911         _approve(address(0), tokenId);
912 
913         _balances[from] -= 1;
914         _balances[to] += 1;
915         _owners[tokenId] = to;
916 
917         emit Transfer(from, to, tokenId);
918     }
919 
920     /**
921      * @dev Approve `to` to operate on `tokenId`
922      *
923      * Emits a {Approval} event.
924      */
925     function _approve(address to, uint256 tokenId) internal virtual {
926         _tokenApprovals[tokenId] = to;
927         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
928     }
929 
930     /**
931      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
932      * The call is not executed if the target address is not a contract.
933      *
934      * @param from address representing the previous owner of the given token ID
935      * @param to target address that will receive the tokens
936      * @param tokenId uint256 ID of the token to be transferred
937      * @param _data bytes optional data to send along with the call
938      * @return bool whether the call correctly returned the expected magic value
939      */
940     function _checkOnERC721Received(
941         address from,
942         address to,
943         uint256 tokenId,
944         bytes memory _data
945     ) private returns (bool) {
946         if (to.isContract()) {
947             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
948                 return retval == IERC721Receiver.onERC721Received.selector;
949             } catch (bytes memory reason) {
950                 if (reason.length == 0) {
951                     revert("ERC721: transfer to non ERC721Receiver implementer");
952                 } else {
953                     assembly {
954                         revert(add(32, reason), mload(reason))
955                     }
956                 }
957             }
958         } else {
959             return true;
960         }
961     }
962 
963     /**
964      * @dev Hook that is called before any token transfer. This includes minting
965      * and burning.
966      *
967      * Calling conditions:
968      *
969      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
970      * transferred to `to`.
971      * - When `from` is zero, `tokenId` will be minted for `to`.
972      * - When `to` is zero, ``from``'s `tokenId` will be burned.
973      * - `from` and `to` are never both zero.
974      *
975      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
976      */
977     function _beforeTokenTransfer(
978         address from,
979         address to,
980         uint256 tokenId
981     ) internal virtual {}
982 }
983 
984 
985 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
986 
987 
988 pragma solidity ^0.8.0;
989 
990 /**
991  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
992  * @dev See https://eips.ethereum.org/EIPS/eip-721
993  */
994 interface IERC721Enumerable is IERC721 {
995     /**
996      * @dev Returns the total amount of tokens stored by the contract.
997      */
998     function totalSupply() external view returns (uint256);
999 
1000     /**
1001      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1002      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1003      */
1004     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1005 
1006     /**
1007      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1008      * Use along with {totalSupply} to enumerate all tokens.
1009      */
1010     function tokenByIndex(uint256 index) external view returns (uint256);
1011 }
1012 
1013 
1014 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1015 
1016 
1017 pragma solidity ^0.8.0;
1018 
1019 
1020 /**
1021  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1022  * enumerability of all the token ids in the contract as well as all token ids owned by each
1023  * account.
1024  */
1025 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1026     // Mapping from owner to list of owned token IDs
1027     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1028 
1029     // Mapping from token ID to index of the owner tokens list
1030     mapping(uint256 => uint256) private _ownedTokensIndex;
1031 
1032     // Array with all token ids, used for enumeration
1033     uint256[] private _allTokens;
1034 
1035     // Mapping from token id to position in the allTokens array
1036     mapping(uint256 => uint256) private _allTokensIndex;
1037 
1038     /**
1039      * @dev See {IERC165-supportsInterface}.
1040      */
1041     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1042         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1043     }
1044 
1045     /**
1046      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1047      */
1048     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1049         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1050         return _ownedTokens[owner][index];
1051     }
1052 
1053     /**
1054      * @dev See {IERC721Enumerable-totalSupply}.
1055      */
1056     function totalSupply() public view virtual override returns (uint256) {
1057         return _allTokens.length;
1058     }
1059 
1060     /**
1061      * @dev See {IERC721Enumerable-tokenByIndex}.
1062      */
1063     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1064         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1065         return _allTokens[index];
1066     }
1067 
1068     /**
1069      * @dev Hook that is called before any token transfer. This includes minting
1070      * and burning.
1071      *
1072      * Calling conditions:
1073      *
1074      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1075      * transferred to `to`.
1076      * - When `from` is zero, `tokenId` will be minted for `to`.
1077      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1078      * - `from` cannot be the zero address.
1079      * - `to` cannot be the zero address.
1080      *
1081      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1082      */
1083     function _beforeTokenTransfer(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) internal virtual override {
1088         super._beforeTokenTransfer(from, to, tokenId);
1089 
1090         if (from == address(0)) {
1091             _addTokenToAllTokensEnumeration(tokenId);
1092         } else if (from != to) {
1093             _removeTokenFromOwnerEnumeration(from, tokenId);
1094         }
1095         if (to == address(0)) {
1096             _removeTokenFromAllTokensEnumeration(tokenId);
1097         } else if (to != from) {
1098             _addTokenToOwnerEnumeration(to, tokenId);
1099         }
1100     }
1101 
1102     /**
1103      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1104      * @param to address representing the new owner of the given token ID
1105      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1106      */
1107     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1108         uint256 length = ERC721.balanceOf(to);
1109         _ownedTokens[to][length] = tokenId;
1110         _ownedTokensIndex[tokenId] = length;
1111     }
1112 
1113     /**
1114      * @dev Private function to add a token to this extension's token tracking data structures.
1115      * @param tokenId uint256 ID of the token to be added to the tokens list
1116      */
1117     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1118         _allTokensIndex[tokenId] = _allTokens.length;
1119         _allTokens.push(tokenId);
1120     }
1121 
1122     /**
1123      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1124      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1125      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1126      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1127      * @param from address representing the previous owner of the given token ID
1128      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1129      */
1130     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1131         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1132         // then delete the last slot (swap and pop).
1133 
1134         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1135         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1136 
1137         // When the token to delete is the last token, the swap operation is unnecessary
1138         if (tokenIndex != lastTokenIndex) {
1139             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1140 
1141             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1142             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1143         }
1144 
1145         // This also deletes the contents at the last position of the array
1146         delete _ownedTokensIndex[tokenId];
1147         delete _ownedTokens[from][lastTokenIndex];
1148     }
1149 
1150     /**
1151      * @dev Private function to remove a token from this extension's token tracking data structures.
1152      * This has O(1) time complexity, but alters the order of the _allTokens array.
1153      * @param tokenId uint256 ID of the token to be removed from the tokens list
1154      */
1155     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1156         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1157         // then delete the last slot (swap and pop).
1158 
1159         uint256 lastTokenIndex = _allTokens.length - 1;
1160         uint256 tokenIndex = _allTokensIndex[tokenId];
1161 
1162         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1163         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1164         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1165         uint256 lastTokenId = _allTokens[lastTokenIndex];
1166 
1167         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1168         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1169 
1170         // This also deletes the contents at the last position of the array
1171         delete _allTokensIndex[tokenId];
1172         _allTokens.pop();
1173     }
1174 }
1175 
1176 
1177 // File @openzeppelin/contracts/security/Pausable.sol@v4.3.2
1178 
1179 
1180 pragma solidity ^0.8.0;
1181 
1182 /**
1183  * @dev Contract module which allows children to implement an emergency stop
1184  * mechanism that can be triggered by an authorized account.
1185  *
1186  * This module is used through inheritance. It will make available the
1187  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1188  * the functions of your contract. Note that they will not be pausable by
1189  * simply including this module, only once the modifiers are put in place.
1190  */
1191 abstract contract Pausable is Context {
1192     /**
1193      * @dev Emitted when the pause is triggered by `account`.
1194      */
1195     event Paused(address account);
1196 
1197     /**
1198      * @dev Emitted when the pause is lifted by `account`.
1199      */
1200     event Unpaused(address account);
1201 
1202     bool private _paused;
1203 
1204     /**
1205      * @dev Initializes the contract in unpaused state.
1206      */
1207     constructor() {
1208         _paused = false;
1209     }
1210 
1211     /**
1212      * @dev Returns true if the contract is paused, and false otherwise.
1213      */
1214     function paused() public view virtual returns (bool) {
1215         return _paused;
1216     }
1217 
1218     /**
1219      * @dev Modifier to make a function callable only when the contract is not paused.
1220      *
1221      * Requirements:
1222      *
1223      * - The contract must not be paused.
1224      */
1225     modifier whenNotPaused() {
1226         require(!paused(), "Pausable: paused");
1227         _;
1228     }
1229 
1230     /**
1231      * @dev Modifier to make a function callable only when the contract is paused.
1232      *
1233      * Requirements:
1234      *
1235      * - The contract must be paused.
1236      */
1237     modifier whenPaused() {
1238         require(paused(), "Pausable: not paused");
1239         _;
1240     }
1241 
1242     /**
1243      * @dev Triggers stopped state.
1244      *
1245      * Requirements:
1246      *
1247      * - The contract must not be paused.
1248      */
1249     function _pause() internal virtual whenNotPaused {
1250         _paused = true;
1251         emit Paused(_msgSender());
1252     }
1253 
1254     /**
1255      * @dev Returns to normal state.
1256      *
1257      * Requirements:
1258      *
1259      * - The contract must be paused.
1260      */
1261     function _unpause() internal virtual whenPaused {
1262         _paused = false;
1263         emit Unpaused(_msgSender());
1264     }
1265 }
1266 
1267 
1268 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1269 
1270 
1271 pragma solidity ^0.8.0;
1272 
1273 /**
1274  * @dev Contract module which provides a basic access control mechanism, where
1275  * there is an account (an owner) that can be granted exclusive access to
1276  * specific functions.
1277  *
1278  * By default, the owner account will be the one that deploys the contract. This
1279  * can later be changed with {transferOwnership}.
1280  *
1281  * This module is used through inheritance. It will make available the modifier
1282  * `onlyOwner`, which can be applied to your functions to restrict their use to
1283  * the owner.
1284  */
1285 abstract contract Ownable is Context {
1286     address private _owner;
1287 
1288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1289 
1290     /**
1291      * @dev Initializes the contract setting the deployer as the initial owner.
1292      */
1293     constructor() {
1294         _setOwner(_msgSender());
1295     }
1296 
1297     /**
1298      * @dev Returns the address of the current owner.
1299      */
1300     function owner() public view virtual returns (address) {
1301         return _owner;
1302     }
1303 
1304     /**
1305      * @dev Throws if called by any account other than the owner.
1306      */
1307     modifier onlyOwner() {
1308         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1309         _;
1310     }
1311 
1312     /**
1313      * @dev Leaves the contract without owner. It will not be possible to call
1314      * `onlyOwner` functions anymore. Can only be called by the current owner.
1315      *
1316      * NOTE: Renouncing ownership will leave the contract without an owner,
1317      * thereby removing any functionality that is only available to the owner.
1318      */
1319     function renounceOwnership() public virtual onlyOwner {
1320         _setOwner(address(0));
1321     }
1322 
1323     /**
1324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1325      * Can only be called by the current owner.
1326      */
1327     function transferOwnership(address newOwner) public virtual onlyOwner {
1328         require(newOwner != address(0), "Ownable: new owner is the zero address");
1329         _setOwner(newOwner);
1330     }
1331 
1332     function _setOwner(address newOwner) private {
1333         address oldOwner = _owner;
1334         _owner = newOwner;
1335         emit OwnershipTransferred(oldOwner, newOwner);
1336     }
1337 }
1338 
1339 
1340 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.3.2
1341 
1342 
1343 pragma solidity ^0.8.0;
1344 
1345 
1346 /**
1347  * @title ERC721 Burnable Token
1348  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1349  */
1350 abstract contract ERC721Burnable is Context, ERC721 {
1351     /**
1352      * @dev Burns `tokenId`. See {ERC721-_burn}.
1353      *
1354      * Requirements:
1355      *
1356      * - The caller must own `tokenId` or be an approved operator.
1357      */
1358     function burn(uint256 tokenId) public virtual {
1359         //solhint-disable-next-line max-line-length
1360         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1361         _burn(tokenId);
1362     }
1363 }
1364 
1365 
1366 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
1367 
1368 
1369 pragma solidity ^0.8.0;
1370 
1371 /**
1372  * @title Counters
1373  * @author Matt Condon (@shrugs)
1374  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1375  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1376  *
1377  * Include with `using Counters for Counters.Counter;`
1378  */
1379 library Counters {
1380     struct Counter {
1381         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1382         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1383         // this feature: see https://github.com/ethereum/solidity/issues/4637
1384         uint256 _value; // default: 0
1385     }
1386 
1387     function current(Counter storage counter) internal view returns (uint256) {
1388         return counter._value;
1389     }
1390 
1391     function increment(Counter storage counter) internal {
1392         unchecked {
1393             counter._value += 1;
1394         }
1395     }
1396 
1397     function decrement(Counter storage counter) internal {
1398         uint256 value = counter._value;
1399         require(value > 0, "Counter: decrement overflow");
1400         unchecked {
1401             counter._value = value - 1;
1402         }
1403     }
1404 
1405     function reset(Counter storage counter) internal {
1406         counter._value = 0;
1407     }
1408 }
1409 
1410 
1411 // File contracts/SameKongNFT.sol
1412 
1413 pragma solidity ^0.8.2;
1414 
1415 
1416 
1417 
1418 
1419 
1420 contract SameKongz is
1421     ERC721,
1422     ERC721Enumerable,
1423     Pausable,
1424     Ownable,
1425     ERC721Burnable
1426 {
1427     using Counters for Counters.Counter;
1428 
1429     Counters.Counter private _tokenIdCounter;
1430 
1431     string public baseURI;
1432     uint256 public cost = 0.05 ether;
1433     uint256 public maxSupply = 3888;
1434     uint256 public maxMintAmount = 10;
1435 
1436     constructor(string memory defaultBaseURI) ERC721("SameKongz", "SKONGZ") {
1437         setBaseURI(defaultBaseURI);
1438     }
1439 
1440     // Minting
1441 
1442     function mint(address _to, uint256 _mintAmount) public payable {
1443         uint256 supply = totalSupply();
1444         require(_mintAmount > 0, "amount must be >0");
1445         require(_mintAmount <= maxMintAmount, "amount must < max");
1446         require(supply + _mintAmount <= maxSupply, "Mint sold out!");
1447 
1448         if (msg.sender != owner()) {
1449             require(msg.value >= cost * _mintAmount, "insufficient funds");
1450         }
1451 
1452         for (uint256 i = 1; i <= _mintAmount; i++) {
1453             _tokenIdCounter.increment();
1454             _safeMint(_to, _tokenIdCounter.current());
1455         }
1456     }
1457 
1458     function withdraw() public payable onlyOwner {
1459         require(
1460             payable(msg.sender).send(address(this).balance),
1461             "could not withdraw"
1462         );
1463     }
1464 
1465     // internal
1466     function _baseURI() internal view virtual override returns (string memory) {
1467         return baseURI;
1468     }
1469 
1470     function setBaseURI(string memory _newURI) public onlyOwner {
1471         baseURI = _newURI;
1472     }
1473 
1474     function pause() public onlyOwner {
1475         _pause();
1476     }
1477 
1478     function unpause() public onlyOwner {
1479         _unpause();
1480     }
1481 
1482     function safeMint(address to) public onlyOwner {
1483         _tokenIdCounter.increment();
1484         _safeMint(to, _tokenIdCounter.current());
1485     }
1486 
1487     function _beforeTokenTransfer(
1488         address from,
1489         address to,
1490         uint256 tokenId
1491     ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
1492         super._beforeTokenTransfer(from, to, tokenId);
1493     }
1494 
1495     // The following functions are overrides required by Solidity.
1496 
1497     function supportsInterface(bytes4 interfaceId)
1498         public
1499         view
1500         override(ERC721, ERC721Enumerable)
1501         returns (bool)
1502     {
1503         return super.supportsInterface(interfaceId);
1504     }
1505 }