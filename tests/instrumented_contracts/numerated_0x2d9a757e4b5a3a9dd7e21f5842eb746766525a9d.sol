1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
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
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
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
174 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
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
203 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
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
230 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
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
449 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
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
475 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
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
544 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
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
573 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
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
985 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol@v4.3.1
986 
987 
988 pragma solidity ^0.8.0;
989 
990 /**
991  * @dev ERC721 token with storage based token URI management.
992  */
993 abstract contract ERC721URIStorage is ERC721 {
994     using Strings for uint256;
995 
996     // Optional mapping for token URIs
997     mapping(uint256 => string) private _tokenURIs;
998 
999     /**
1000      * @dev See {IERC721Metadata-tokenURI}.
1001      */
1002     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1003         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1004 
1005         string memory _tokenURI = _tokenURIs[tokenId];
1006         string memory base = _baseURI();
1007 
1008         // If there is no base URI, return the token URI.
1009         if (bytes(base).length == 0) {
1010             return _tokenURI;
1011         }
1012         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1013         if (bytes(_tokenURI).length > 0) {
1014             return string(abi.encodePacked(base, _tokenURI));
1015         }
1016 
1017         return super.tokenURI(tokenId);
1018     }
1019 
1020     /**
1021      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1022      *
1023      * Requirements:
1024      *
1025      * - `tokenId` must exist.
1026      */
1027     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1028         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1029         _tokenURIs[tokenId] = _tokenURI;
1030     }
1031 
1032     /**
1033      * @dev Destroys `tokenId`.
1034      * The approval is cleared when the token is burned.
1035      *
1036      * Requirements:
1037      *
1038      * - `tokenId` must exist.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _burn(uint256 tokenId) internal virtual override {
1043         super._burn(tokenId);
1044 
1045         if (bytes(_tokenURIs[tokenId]).length != 0) {
1046             delete _tokenURIs[tokenId];
1047         }
1048     }
1049 }
1050 
1051 
1052 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.1
1053 
1054 
1055 pragma solidity ^0.8.0;
1056 
1057 /**
1058  * @title Counters
1059  * @author Matt Condon (@shrugs)
1060  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1061  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1062  *
1063  * Include with `using Counters for Counters.Counter;`
1064  */
1065 library Counters {
1066     struct Counter {
1067         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1068         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1069         // this feature: see https://github.com/ethereum/solidity/issues/4637
1070         uint256 _value; // default: 0
1071     }
1072 
1073     function current(Counter storage counter) internal view returns (uint256) {
1074         return counter._value;
1075     }
1076 
1077     function increment(Counter storage counter) internal {
1078         unchecked {
1079             counter._value += 1;
1080         }
1081     }
1082 
1083     function decrement(Counter storage counter) internal {
1084         uint256 value = counter._value;
1085         require(value > 0, "Counter: decrement overflow");
1086         unchecked {
1087             counter._value = value - 1;
1088         }
1089     }
1090 
1091     function reset(Counter storage counter) internal {
1092         counter._value = 0;
1093     }
1094 }
1095 
1096 
1097 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
1098 
1099 
1100 pragma solidity ^0.8.0;
1101 
1102 /**
1103  * @dev Contract module which provides a basic access control mechanism, where
1104  * there is an account (an owner) that can be granted exclusive access to
1105  * specific functions.
1106  *
1107  * By default, the owner account will be the one that deploys the contract. This
1108  * can later be changed with {transferOwnership}.
1109  *
1110  * This module is used through inheritance. It will make available the modifier
1111  * `onlyOwner`, which can be applied to your functions to restrict their use to
1112  * the owner.
1113  */
1114 abstract contract Ownable is Context {
1115     address private _owner;
1116 
1117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1118 
1119     /**
1120      * @dev Initializes the contract setting the deployer as the initial owner.
1121      */
1122     constructor() {
1123         _setOwner(_msgSender());
1124     }
1125 
1126     /**
1127      * @dev Returns the address of the current owner.
1128      */
1129     function owner() public view virtual returns (address) {
1130         return _owner;
1131     }
1132 
1133     /**
1134      * @dev Throws if called by any account other than the owner.
1135      */
1136     modifier onlyOwner() {
1137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1138         _;
1139     }
1140 
1141     /**
1142      * @dev Leaves the contract without owner. It will not be possible to call
1143      * `onlyOwner` functions anymore. Can only be called by the current owner.
1144      *
1145      * NOTE: Renouncing ownership will leave the contract without an owner,
1146      * thereby removing any functionality that is only available to the owner.
1147      */
1148     function renounceOwnership() public virtual onlyOwner {
1149         _setOwner(address(0));
1150     }
1151 
1152     /**
1153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1154      * Can only be called by the current owner.
1155      */
1156     function transferOwnership(address newOwner) public virtual onlyOwner {
1157         require(newOwner != address(0), "Ownable: new owner is the zero address");
1158         _setOwner(newOwner);
1159     }
1160 
1161     function _setOwner(address newOwner) private {
1162         address oldOwner = _owner;
1163         _owner = newOwner;
1164         emit OwnershipTransferred(oldOwner, newOwner);
1165     }
1166 }
1167 
1168 
1169 // File contracts/GasWarrior-Clones.sol
1170 
1171 pragma solidity ^0.8.0;
1172 
1173 
1174 
1175 
1176 contract GasWarriorsClones is ERC721URIStorage, Ownable {
1177     using Counters for Counters.Counter;
1178     Counters.Counter private _tokenIds;
1179 
1180     uint public fee;
1181     string public baseUri;
1182     uint public maximumMintable;
1183     uint public publicMintingTime;
1184 
1185     bool public hasBeenRevealed;
1186 
1187     uint public numberOfOwnerMints;
1188     address private devAddress;
1189     address public DAOaddressMultisig;
1190 
1191     //Number of mints remaining for a user on the early minting list
1192     mapping (address => uint) earlyMintingRemaining;
1193 
1194     event Minted(address to, uint id, string uri);
1195     event PriceUpdated(uint newPrice);
1196     event UpdatedDAOAddress(address newAddress);
1197 
1198     constructor() ERC721("GasWarrior Clones", "GWC") {
1199       fee = 40000000000000000 wei; //0.04 ETH
1200       baseUri = "ipfs://QmVkoTmbtM74vdQXexSEKAp1pbr9WZNdV86ApPkRaAMT4Z"; //pre-veal
1201       maximumMintable = 8788;
1202       publicMintingTime = 1631700001; // update to wednesday
1203       devAddress = msg.sender;
1204       numberOfOwnerMints = 100;
1205       //future owner 0xD435566E386A9Ae228A89826Ab733981967c30ef
1206       DAOaddressMultisig = 0x874df5B5e489556894FE7c76F06c03e5Cc264c3D;
1207     }
1208 
1209     /**
1210      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1211      */
1212     function toString(uint256 value) internal pure returns (string memory) {
1213         // Inspired by OraclizeAPI's implementation - MIT licence
1214         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1215 
1216         if (value == 0) {
1217             return "0";
1218         }
1219         uint256 temp = value;
1220         uint256 digits;
1221         while (temp != 0) {
1222             digits++;
1223             temp /= 10;
1224         }
1225         bytes memory buffer = new bytes(digits);
1226         while (value != 0) {
1227             digits -= 1;
1228             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1229             value /= 10;
1230         }
1231         return string(buffer);
1232     }
1233 
1234     /*
1235     * Mint Gas Warriors
1236     */
1237     function mint(uint numberOfMints)
1238         public payable
1239         returns (uint256)
1240     {
1241         require(block.timestamp >= publicMintingTime);
1242         require(_tokenIds.current() + numberOfMints <= maximumMintable, "Maximum amount of Clones already minted."); //10000 item cap (9900 public + 100 team mints)
1243         require(msg.value >= fee * numberOfMints, "Fee is not correct.");  //User must pay set fee.`
1244         require(numberOfMints <= 15, "You cant mint more than 15 at a time.");
1245 
1246         for(uint i = 0; i < numberOfMints; i++) {
1247 
1248             _tokenIds.increment();
1249             uint256 newItemId = _tokenIds.current();
1250             _mint(_msgSender(), newItemId);
1251             //removed Mint event here bc of gas intensity of events.
1252         }
1253         return _tokenIds.current();
1254     }
1255 
1256     function ownerMint(uint numberOfMints)
1257       public onlyOwner
1258       returns (uint256)
1259   {
1260       require(_tokenIds.current() + numberOfMints <= maximumMintable + 100, "Maximum amount of Clones already minted."); //10000 item cap (9900 public + 100 team mints)
1261       require(numberOfOwnerMints - numberOfMints >= 0, "Owner is maxed at 100 free mints only.");
1262       numberOfOwnerMints = numberOfOwnerMints - numberOfMints;
1263 
1264       for(uint i = 0; i < numberOfMints; i++) {
1265 
1266           _tokenIds.increment();
1267           uint256 newItemId = _tokenIds.current();
1268           _mint(_msgSender(), newItemId);
1269           //removed Mint event here bc of gas intensity of events.
1270       }
1271       return _tokenIds.current();
1272     }
1273 
1274     function earlyMint(uint numberOfMints) public payable returns(uint256){
1275       require(_tokenIds.current() + numberOfMints <= maximumMintable, "Maximum amount of Clones already minted."); //10000 item cap (9900 public + 100 team mints)
1276       require(msg.value >= fee * numberOfMints, "Fee is not correct.");  //User must pay set fee.`
1277       require(numberOfMints <= 25, "You cant mint more than 25 at a time.");
1278       require(earlyMintingRemaining[_msgSender()] - numberOfMints >= 0, "Your allowance for early mints is too low for that many mints.");
1279 
1280       earlyMintingRemaining[_msgSender()] = earlyMintingRemaining[_msgSender()] - numberOfMints;
1281 
1282       for(uint i = 0; i < numberOfMints; i++) {
1283 
1284           _tokenIds.increment();
1285           uint256 newItemId = _tokenIds.current();
1286           _mint(_msgSender(), newItemId);
1287           //removed Mint event here bc of gas intensity of events.
1288       }
1289       return _tokenIds.current();
1290     }
1291 
1292     function updateFee(uint newFee) public onlyOwner{
1293       fee = newFee;
1294 
1295       emit PriceUpdated(newFee);
1296     }
1297 
1298     function getFee() public view returns (uint) {
1299       return fee;
1300     }
1301 
1302     function OwnerMoveFundsToDAO() public onlyOwner{
1303       //TODO make this a transaction
1304         payable(msg.sender).transfer(address(this).balance * 65/100);
1305         payable(DAOaddressMultisig).transfer(address(this).balance * 20/100);
1306         payable(devAddress).transfer(address(this).balance * 15/100);
1307     }
1308 
1309     function tokenURI(uint _id) public virtual override view returns(string memory){
1310       //doing this logic here instead of setting each individual NFT URI saves gas for minters
1311       if (hasBeenRevealed){
1312         return string(abi.encodePacked(baseUri, toString(_id),  ".json"));
1313       }else{
1314         //not revealed yet. Use basic URI, intact with its own ".json"
1315         return baseUri;
1316       }
1317     }
1318 
1319     //Can only be set once
1320     function ownerReveal(string memory _uri) public{
1321       require(msg.sender == devAddress || msg.sender == owner());
1322       require(!hasBeenRevealed);
1323       hasBeenRevealed = true;
1324       baseUri = _uri;
1325     }
1326 
1327     //only the DAO can update who the DAO is after it is set by constructor
1328     function DAOupdateDAOaddress(address _daoAddress) public {
1329         require(msg.sender == DAOaddressMultisig);
1330         DAOaddressMultisig = _daoAddress;
1331         emit UpdatedDAOAddress(_daoAddress);
1332     }
1333 
1334     //Add a list of supporters to early minting and give them an allowance of 100
1335     function ownerAddSupporters(address[] calldata supporters) public onlyOwner{
1336       for(uint i = 0; i < supporters.length; i++){
1337         earlyMintingRemaining[supporters[i]] = 100;
1338       }
1339     }
1340     //0x029bC12540DC84ed8282d36ebC268b5762A64346
1341 }