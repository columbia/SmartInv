1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-14
3 */
4 
5 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.10;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 
33 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
34 
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
174 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
175 
176 
177 /**
178  * @title ERC721 token receiver interface
179  * @dev Interface for any contract that wants to support safeTransfers
180  * from ERC721 asset contracts.
181  */
182 interface IERC721Receiver {
183     /**
184      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
185      * by `operator` from `from`, this function is called.
186      *
187      * It must return its Solidity selector to confirm the token transfer.
188      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
189      *
190      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
191      */
192     function onERC721Received(
193         address operator,
194         address from,
195         uint256 tokenId,
196         bytes calldata data
197     ) external returns (bytes4);
198 }
199 
200 
201 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
202 
203 
204 /**
205  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
206  * @dev See https://eips.ethereum.org/EIPS/eip-721
207  */
208 interface IERC721Metadata is IERC721 {
209     /**
210      * @dev Returns the token collection name.
211      */
212     function name() external view returns (string memory);
213 
214     /**
215      * @dev Returns the token collection symbol.
216      */
217     function symbol() external view returns (string memory);
218 
219     /**
220      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
221      */
222     function tokenURI(uint256 tokenId) external view returns (string memory);
223 }
224 
225 
226 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
227 
228 
229 /**
230  * @dev Collection of functions related to the address type
231  */
232 library Address {
233     /**
234      * @dev Returns true if `account` is a contract.
235      *
236      * [IMPORTANT]
237      * ====
238      * It is unsafe to assume that an address for which this function returns
239      * false is an externally-owned account (EOA) and not a contract.
240      *
241      * Among others, `isContract` will return false for the following
242      * types of addresses:
243      *
244      *  - an externally-owned account
245      *  - a contract in construction
246      *  - an address where a contract will be created
247      *  - an address where a contract lived, but was destroyed
248      * ====
249      */
250     function isContract(address account) internal view returns (bool) {
251         // This method relies on extcodesize, which returns 0 for contracts in
252         // construction, since the code is only stored at the end of the
253         // constructor execution.
254 
255         uint256 size;
256         assembly {
257             size := extcodesize(account)
258         }
259         return size > 0;
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         (bool success, ) = recipient.call{value: amount}("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain `call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionCall(target, data, "Address: low-level call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
309      * `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         require(isContract(target), "Address: call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.call{value: value}(data);
356         return _verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
366         return functionStaticCall(target, data, "Address: low-level static call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal view returns (bytes memory) {
380         require(isContract(target), "Address: static call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.staticcall(data);
383         return _verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(isContract(target), "Address: delegate call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return _verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     function _verifyCallResult(
414         bool success,
415         bytes memory returndata,
416         string memory errorMessage
417     ) private pure returns (bytes memory) {
418         if (success) {
419             return returndata;
420         } else {
421             // Look for revert reason and bubble it up if present
422             if (returndata.length > 0) {
423                 // The easiest way to bubble the revert reason is using memory via assembly
424 
425                 assembly {
426                     let returndata_size := mload(returndata)
427                     revert(add(32, returndata), returndata_size)
428                 }
429             } else {
430                 revert(errorMessage);
431             }
432         }
433     }
434 }
435 
436 
437 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
438 
439 
440 /*
441  * @dev Provides information about the current execution context, including the
442  * sender of the transaction and its data. While these are generally available
443  * via msg.sender and msg.data, they should not be accessed in such a direct
444  * manner, since when dealing with meta-transactions the account sending and
445  * paying for execution may not be the actual sender (as far as an application
446  * is concerned).
447  *
448  * This contract is only required for intermediate, library-like contracts.
449  */
450 abstract contract Context {
451     function _msgSender() internal view virtual returns (address) {
452         return msg.sender;
453     }
454 
455     function _msgData() internal view virtual returns (bytes calldata) {
456         return msg.data;
457     }
458 }
459 
460 
461 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
462 
463 
464 /**
465  * @dev String operations.
466  */
467 library Strings {
468     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
469 
470     /**
471      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
472      */
473     function toString(uint256 value) internal pure returns (string memory) {
474         // Inspired by OraclizeAPI's implementation - MIT licence
475         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
476 
477         if (value == 0) {
478             return "0";
479         }
480         uint256 temp = value;
481         uint256 digits;
482         while (temp != 0) {
483             digits++;
484             temp /= 10;
485         }
486         bytes memory buffer = new bytes(digits);
487         while (value != 0) {
488             digits -= 1;
489             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
490             value /= 10;
491         }
492         return string(buffer);
493     }
494 
495     /**
496      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
497      */
498     function toHexString(uint256 value) internal pure returns (string memory) {
499         if (value == 0) {
500             return "0x00";
501         }
502         uint256 temp = value;
503         uint256 length = 0;
504         while (temp != 0) {
505             length++;
506             temp >>= 8;
507         }
508         return toHexString(value, length);
509     }
510 
511     /**
512      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
513      */
514     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
515         bytes memory buffer = new bytes(2 * length + 2);
516         buffer[0] = "0";
517         buffer[1] = "x";
518         for (uint256 i = 2 * length + 1; i > 1; --i) {
519             buffer[i] = _HEX_SYMBOLS[value & 0xf];
520             value >>= 4;
521         }
522         require(value == 0, "Strings: hex length insufficient");
523         return string(buffer);
524     }
525 }
526 
527 
528 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
529 
530 
531 /**
532  * @dev Implementation of the {IERC165} interface.
533  *
534  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
535  * for the additional interface id that will be supported. For example:
536  *
537  * ```solidity
538  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
540  * }
541  * ```
542  *
543  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
544  */
545 abstract contract ERC165 is IERC165 {
546     /**
547      * @dev See {IERC165-supportsInterface}.
548      */
549     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550         return interfaceId == type(IERC165).interfaceId;
551     }
552 }
553 
554 
555 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
556 
557 
558 /**
559  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
560  * the Metadata extension, but not including the Enumerable extension, which is available separately as
561  * {ERC721Enumerable}.
562  */
563 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
564     using Address for address;
565     using Strings for uint256;
566 
567     // Token name
568     string private _name;
569 
570     // Token symbol
571     string private _symbol;
572 
573     // Mapping from token ID to owner address
574     mapping(uint256 => address) private _owners;
575 
576     // Mapping owner address to token count
577     mapping(address => uint256) private _balances;
578 
579     // Mapping from token ID to approved address
580     mapping(uint256 => address) private _tokenApprovals;
581 
582     // Mapping from owner to operator approvals
583     mapping(address => mapping(address => bool)) private _operatorApprovals;
584 
585     /**
586      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
587      */
588     constructor(string memory name_, string memory symbol_) {
589         _name = name_;
590         _symbol = symbol_;
591     }
592 
593     /**
594      * @dev See {IERC165-supportsInterface}.
595      */
596     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
597         return
598             interfaceId == type(IERC721).interfaceId ||
599             interfaceId == type(IERC721Metadata).interfaceId ||
600             super.supportsInterface(interfaceId);
601     }
602 
603     /**
604      * @dev See {IERC721-balanceOf}.
605      */
606     function balanceOf(address owner) public view virtual override returns (uint256) {
607         require(owner != address(0), "ERC721: balance query for the zero address");
608         return _balances[owner];
609     }
610 
611     /**
612      * @dev See {IERC721-ownerOf}.
613      */
614     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
615         address owner = _owners[tokenId];
616         require(owner != address(0), "ERC721: owner query for nonexistent token");
617         return owner;
618     }
619 
620     /**
621      * @dev See {IERC721Metadata-name}.
622      */
623     function name() public view virtual override returns (string memory) {
624         return _name;
625     }
626 
627     /**
628      * @dev See {IERC721Metadata-symbol}.
629      */
630     function symbol() public view virtual override returns (string memory) {
631         return _symbol;
632     }
633 
634     /**
635      * @dev See {IERC721Metadata-tokenURI}.
636      */
637     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
638         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
639 
640         string memory baseURI = _baseURI();
641         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : "";
642     }
643 
644     /**
645      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
646      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
647      * by default, can be overriden in child contracts.
648      */
649     function _baseURI() internal view virtual returns (string memory) {
650         return "";
651     }
652 
653     /**
654      * @dev See {IERC721-approve}.
655      */
656     function approve(address to, uint256 tokenId) public virtual override {
657         address owner = ERC721.ownerOf(tokenId);
658         require(to != owner, "ERC721: approval to current owner");
659 
660         require(
661             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
662             "ERC721: approve caller is not owner nor approved for all"
663         );
664 
665         _approve(to, tokenId);
666     }
667 
668     /**
669      * @dev See {IERC721-getApproved}.
670      */
671     function getApproved(uint256 tokenId) public view virtual override returns (address) {
672         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
673 
674         return _tokenApprovals[tokenId];
675     }
676 
677     /**
678      * @dev See {IERC721-setApprovalForAll}.
679      */
680     function setApprovalForAll(address operator, bool approved) public virtual override {
681         require(operator != _msgSender(), "ERC721: approve to caller");
682 
683         _operatorApprovals[_msgSender()][operator] = approved;
684         emit ApprovalForAll(_msgSender(), operator, approved);
685     }
686 
687     /**
688      * @dev See {IERC721-isApprovedForAll}.
689      */
690     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
691         return _operatorApprovals[owner][operator];
692     }
693 
694     /**
695      * @dev See {IERC721-transferFrom}.
696      */
697     function transferFrom(
698         address from,
699         address to,
700         uint256 tokenId
701     ) public virtual override {
702         //solhint-disable-next-line max-line-length
703         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
704 
705         _transfer(from, to, tokenId);
706     }
707 
708     /**
709      * @dev See {IERC721-safeTransferFrom}.
710      */
711     function safeTransferFrom(
712         address from,
713         address to,
714         uint256 tokenId
715     ) public virtual override {
716         safeTransferFrom(from, to, tokenId, "");
717     }
718 
719     /**
720      * @dev See {IERC721-safeTransferFrom}.
721      */
722     function safeTransferFrom(
723         address from,
724         address to,
725         uint256 tokenId,
726         bytes memory _data
727     ) public virtual override {
728         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
729         _safeTransfer(from, to, tokenId, _data);
730     }
731 
732     /**
733      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
734      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
735      *
736      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
737      *
738      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
739      * implement alternative mechanisms to perform token transfer, such as signature-based.
740      *
741      * Requirements:
742      *
743      * - `from` cannot be the zero address.
744      * - `to` cannot be the zero address.
745      * - `tokenId` token must exist and be owned by `from`.
746      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
747      *
748      * Emits a {Transfer} event.
749      */
750     function _safeTransfer(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes memory _data
755     ) internal virtual {
756         _transfer(from, to, tokenId);
757         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
758     }
759 
760     /**
761      * @dev Returns whether `tokenId` exists.
762      *
763      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
764      *
765      * Tokens start existing when they are minted (`_mint`),
766      * and stop existing when they are burned (`_burn`).
767      */
768     function _exists(uint256 tokenId) internal view virtual returns (bool) {
769         return _owners[tokenId] != address(0);
770     }
771 
772     /**
773      * @dev Returns whether `spender` is allowed to manage `tokenId`.
774      *
775      * Requirements:
776      *
777      * - `tokenId` must exist.
778      */
779     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
780         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
781         address owner = ERC721.ownerOf(tokenId);
782         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
783     }
784 
785     /**
786      * @dev Safely mints `tokenId` and transfers it to `to`.
787      *
788      * Requirements:
789      *
790      * - `tokenId` must not exist.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function _safeMint(address to, uint256 tokenId) internal virtual {
796         _safeMint(to, tokenId, "");
797     }
798 
799     /**
800      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
801      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
802      */
803     function _safeMint(
804         address to,
805         uint256 tokenId,
806         bytes memory _data
807     ) internal virtual {
808         _mint(to, tokenId);
809         require(
810             _checkOnERC721Received(address(0), to, tokenId, _data),
811             "ERC721: transfer to non ERC721Receiver implementer"
812         );
813     }
814 
815     /**
816      * @dev Mints `tokenId` and transfers it to `to`.
817      *
818      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
819      *
820      * Requirements:
821      *
822      * - `tokenId` must not exist.
823      * - `to` cannot be the zero address.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _mint(address to, uint256 tokenId) internal virtual {
828         require(to != address(0), "ERC721: mint to the zero address");
829         require(!_exists(tokenId), "ERC721: token already minted");
830 
831         _beforeTokenTransfer(address(0), to, tokenId);
832 
833         _balances[to] += 1;
834         _owners[tokenId] = to;
835 
836         emit Transfer(address(0), to, tokenId);
837     }
838 
839     /**
840      * @dev Destroys `tokenId`.
841      * The approval is cleared when the token is burned.
842      *
843      * Requirements:
844      *
845      * - `tokenId` must exist.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _burn(uint256 tokenId) internal virtual {
850         address owner = ERC721.ownerOf(tokenId);
851 
852         _beforeTokenTransfer(owner, address(0), tokenId);
853 
854         // Clear approvals
855         _approve(address(0), tokenId);
856 
857         _balances[owner] -= 1;
858         delete _owners[tokenId];
859 
860         emit Transfer(owner, address(0), tokenId);
861     }
862 
863     /**
864      * @dev Transfers `tokenId` from `from` to `to`.
865      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
866      *
867      * Requirements:
868      *
869      * - `to` cannot be the zero address.
870      * - `tokenId` token must be owned by `from`.
871      *
872      * Emits a {Transfer} event.
873      */
874     function _transfer(
875         address from,
876         address to,
877         uint256 tokenId
878     ) internal virtual {
879         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
880         require(to != address(0), "ERC721: transfer to the zero address");
881 
882         _beforeTokenTransfer(from, to, tokenId);
883 
884         // Clear approvals from the previous owner
885         _approve(address(0), tokenId);
886 
887         _balances[from] -= 1;
888         _balances[to] += 1;
889         _owners[tokenId] = to;
890 
891         emit Transfer(from, to, tokenId);
892     }
893 
894     /**
895      * @dev Approve `to` to operate on `tokenId`
896      *
897      * Emits a {Approval} event.
898      */
899     function _approve(address to, uint256 tokenId) internal virtual {
900         _tokenApprovals[tokenId] = to;
901         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
902     }
903 
904     /**
905      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
906      * The call is not executed if the target address is not a contract.
907      *
908      * @param from address representing the previous owner of the given token ID
909      * @param to target address that will receive the tokens
910      * @param tokenId uint256 ID of the token to be transferred
911      * @param _data bytes optional data to send along with the call
912      * @return bool whether the call correctly returned the expected magic value
913      */
914     function _checkOnERC721Received(
915         address from,
916         address to,
917         uint256 tokenId,
918         bytes memory _data
919     ) private returns (bool) {
920         if (to.isContract()) {
921             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
922                 return retval == IERC721Receiver(to).onERC721Received.selector;
923             } catch (bytes memory reason) {
924                 if (reason.length == 0) {
925                     revert("ERC721: transfer to non ERC721Receiver implementer");
926                 } else {
927                     assembly {
928                         revert(add(32, reason), mload(reason))
929                     }
930                 }
931             }
932         } else {
933             return true;
934         }
935     }
936 
937     /**
938      * @dev Hook that is called before any token transfer. This includes minting
939      * and burning.
940      *
941      * Calling conditions:
942      *
943      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
944      * transferred to `to`.
945      * - When `from` is zero, `tokenId` will be minted for `to`.
946      * - When `to` is zero, ``from``'s `tokenId` will be burned.
947      * - `from` and `to` are never both zero.
948      *
949      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
950      */
951     function _beforeTokenTransfer(
952         address from,
953         address to,
954         uint256 tokenId
955     ) internal virtual {}
956 }
957 
958 library SafeMath {
959     /**
960      * @dev Returns the addition of two unsigned integers, reverting on
961      * overflow.
962      *
963      * Counterpart to Solidity's `+` operator.
964      *
965      * Requirements:
966      * - Addition cannot overflow.
967      */
968     function add(uint256 a, uint256 b) internal pure returns (uint256) {
969         uint256 c = a + b;
970         require(c >= a, "SafeMath: addition overflow");
971 
972         return c;
973     }
974 
975     /**
976      * @dev Returns the subtraction of two unsigned integers, reverting on
977      * overflow (when the result is negative).
978      *
979      * Counterpart to Solidity's `-` operator.
980      *
981      * Requirements:
982      * - Subtraction cannot overflow.
983      */
984     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
985         return sub(a, b, "SafeMath: subtraction overflow");
986     }
987 
988     /**
989      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
990      * overflow (when the result is negative).
991      *
992      * Counterpart to Solidity's `-` operator.
993      *
994      * Requirements:
995      * - Subtraction cannot overflow.
996      *
997      * _Available since v2.4.0._
998      */
999     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1000         require(b <= a, errorMessage);
1001         uint256 c = a - b;
1002 
1003         return c;
1004     }
1005 
1006     /**
1007      * @dev Returns the multiplication of two unsigned integers, reverting on
1008      * overflow.
1009      *
1010      * Counterpart to Solidity's `*` operator.
1011      *
1012      * Requirements:
1013      * - Multiplication cannot overflow.
1014      */
1015     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1016         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1017         // benefit is lost if 'b' is also tested.
1018         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1019         if (a == 0) {
1020             return 0;
1021         }
1022 
1023         uint256 c = a * b;
1024         require(c / a == b, "SafeMath: multiplication overflow");
1025 
1026         return c;
1027     }
1028 
1029     /**
1030      * @dev Returns the integer division of two unsigned integers. Reverts on
1031      * division by zero. The result is rounded towards zero.
1032      *
1033      * Counterpart to Solidity's `/` operator. Note: this function uses a
1034      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1035      * uses an invalid opcode to revert (consuming all remaining gas).
1036      *
1037      * Requirements:
1038      * - The divisor cannot be zero.
1039      */
1040     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1041         return div(a, b, "SafeMath: division by zero");
1042     }
1043 
1044     /**
1045      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1046      * division by zero. The result is rounded towards zero.
1047      *
1048      * Counterpart to Solidity's `/` operator. Note: this function uses a
1049      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1050      * uses an invalid opcode to revert (consuming all remaining gas).
1051      *
1052      * Requirements:
1053      * - The divisor cannot be zero.
1054      *
1055      * _Available since v2.4.0._
1056      */
1057     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1058         // Solidity only automatically asserts when dividing by 0
1059         require(b > 0, errorMessage);
1060         uint256 c = a / b;
1061         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1062 
1063         return c;
1064     }
1065 
1066     /**
1067      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1068      * Reverts when dividing by zero.
1069      *
1070      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1071      * opcode (which leaves remaining gas untouched) while Solidity uses an
1072      * invalid opcode to revert (consuming all remaining gas).
1073      *
1074      * Requirements:
1075      * - The divisor cannot be zero.
1076      */
1077     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1078         return mod(a, b, "SafeMath: modulo by zero");
1079     }
1080 
1081     /**
1082      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1083      * Reverts with custom message when dividing by zero.
1084      *
1085      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1086      * opcode (which leaves remaining gas untouched) while Solidity uses an
1087      * invalid opcode to revert (consuming all remaining gas).
1088      *
1089      * Requirements:
1090      * - The divisor cannot be zero.
1091      *
1092      * _Available since v2.4.0._
1093      */
1094     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1095         require(b != 0, errorMessage);
1096         return a % b;
1097     }
1098 }
1099 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
1100 
1101 
1102 /**
1103  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1104  * @dev See https://eips.ethereum.org/EIPS/eip-721
1105  */
1106 interface IERC721Enumerable is IERC721 {
1107     /**
1108      * @dev Returns the total amount of tokens stored by the contract.
1109      */
1110     function totalSupply() external view returns (uint256);
1111 
1112     /**
1113      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1114      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1115      */
1116     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1117 
1118     /**
1119      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1120      * Use along with {totalSupply} to enumerate all tokens.
1121      */
1122     function tokenByIndex(uint256 index) external view returns (uint256);
1123 }
1124 
1125 
1126 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1127 
1128 
1129 /**
1130  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1131  * enumerability of all the token ids in the contract as well as all token ids owned by each
1132  * account.
1133  */
1134 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1135     // Mapping from owner to list of owned token IDs
1136     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1137 
1138     // Mapping from token ID to index of the owner tokens list
1139     mapping(uint256 => uint256) private _ownedTokensIndex;
1140 
1141     // Array with all token ids, used for enumeration
1142     uint256[] private _allTokens;
1143 
1144     // Mapping from token id to position in the allTokens array
1145     mapping(uint256 => uint256) private _allTokensIndex;
1146 
1147     /**
1148      * @dev See {IERC165-supportsInterface}.
1149      */
1150     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1151         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1152     }
1153 
1154     /**
1155      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1156      */
1157     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1158         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1159         return _ownedTokens[owner][index];
1160     }
1161 
1162     /**
1163      * @dev See {IERC721Enumerable-totalSupply}.
1164      */
1165     function totalSupply() public view virtual override returns (uint256) {
1166         return _allTokens.length;
1167     }
1168 
1169     /**
1170      * @dev See {IERC721Enumerable-tokenByIndex}.
1171      */
1172     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1173         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1174         return _allTokens[index];
1175     }
1176 
1177     /**
1178      * @dev Hook that is called before any token transfer. This includes minting
1179      * and burning.
1180      *
1181      * Calling conditions:
1182      *
1183      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1184      * transferred to `to`.
1185      * - When `from` is zero, `tokenId` will be minted for `to`.
1186      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1187      * - `from` cannot be the zero address.
1188      * - `to` cannot be the zero address.
1189      *
1190      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1191      */
1192     function _beforeTokenTransfer(
1193         address from,
1194         address to,
1195         uint256 tokenId
1196     ) internal virtual override {
1197         super._beforeTokenTransfer(from, to, tokenId);
1198 
1199         if (from == address(0)) {
1200             _addTokenToAllTokensEnumeration(tokenId);
1201         } else if (from != to) {
1202             _removeTokenFromOwnerEnumeration(from, tokenId);
1203         }
1204         if (to == address(0)) {
1205             _removeTokenFromAllTokensEnumeration(tokenId);
1206         } else if (to != from) {
1207             _addTokenToOwnerEnumeration(to, tokenId);
1208         }
1209     }
1210 
1211     /**
1212      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1213      * @param to address representing the new owner of the given token ID
1214      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1215      */
1216     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1217         uint256 length = ERC721.balanceOf(to);
1218         _ownedTokens[to][length] = tokenId;
1219         _ownedTokensIndex[tokenId] = length;
1220     }
1221 
1222     /**
1223      * @dev Private function to add a token to this extension's token tracking data structures.
1224      * @param tokenId uint256 ID of the token to be added to the tokens list
1225      */
1226     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1227         _allTokensIndex[tokenId] = _allTokens.length;
1228         _allTokens.push(tokenId);
1229     }
1230 
1231     /**
1232      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1233      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1234      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1235      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1236      * @param from address representing the previous owner of the given token ID
1237      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1238      */
1239     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1240         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1241         // then delete the last slot (swap and pop).
1242 
1243         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1244         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1245 
1246         // When the token to delete is the last token, the swap operation is unnecessary
1247         if (tokenIndex != lastTokenIndex) {
1248             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1249 
1250             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1251             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1252         }
1253 
1254         // This also deletes the contents at the last position of the array
1255         delete _ownedTokensIndex[tokenId];
1256         delete _ownedTokens[from][lastTokenIndex];
1257     }
1258 
1259     /**
1260      * @dev Private function to remove a token from this extension's token tracking data structures.
1261      * This has O(1) time complexity, but alters the order of the _allTokens array.
1262      * @param tokenId uint256 ID of the token to be removed from the tokens list
1263      */
1264     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1265         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1266         // then delete the last slot (swap and pop).
1267 
1268         uint256 lastTokenIndex = _allTokens.length - 1;
1269         uint256 tokenIndex = _allTokensIndex[tokenId];
1270 
1271         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1272         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1273         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1274         uint256 lastTokenId = _allTokens[lastTokenIndex];
1275 
1276         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1277         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1278 
1279         // This also deletes the contents at the last position of the array
1280         delete _allTokensIndex[tokenId];
1281         _allTokens.pop();
1282     }
1283 }
1284 
1285 
1286 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
1287 
1288 
1289 /**
1290  * @dev Contract module which provides a basic access control mechanism, where
1291  * there is an account (an owner) that can be granted exclusive access to
1292  * specific functions.
1293  *
1294  * By default, the owner account will be the one that deploys the contract. This
1295  * can later be changed with {transferOwnership}.
1296  *
1297  * This module is used through inheritance. It will make available the modifier
1298  * `onlyOwner`, which can be applied to your functions to restrict their use to
1299  * the owner.
1300  */
1301 abstract contract Ownable is Context {
1302     address private _owner;
1303 
1304     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1305 
1306     /**
1307      * @dev Initializes the contract setting the deployer as the initial owner.
1308      */
1309     constructor() {
1310         _setOwner(_msgSender());
1311     }
1312 
1313     /**
1314      * @dev Returns the address of the current owner.
1315      */
1316     function owner() public view virtual returns (address) {
1317         return _owner;
1318     }
1319 
1320     /**
1321      * @dev Throws if called by any account other than the owner.
1322      */
1323     modifier onlyOwner() {
1324         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1325         _;
1326     }
1327 
1328     /**
1329      * @dev Leaves the contract without owner. It will not be possible to call
1330      * `onlyOwner` functions anymore. Can only be called by the current owner.
1331      *
1332      * NOTE: Renouncing ownership will leave the contract without an owner,
1333      * thereby removing any functionality that is only available to the owner.
1334      */
1335     function renounceOwnership() public virtual onlyOwner {
1336         _setOwner(address(0));
1337     }
1338 
1339     /**
1340      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1341      * Can only be called by the current owner.
1342      */
1343     function transferOwnership(address newOwner) public virtual onlyOwner {
1344         require(newOwner != address(0), "Ownable: new owner is the zero address");
1345         _setOwner(newOwner);
1346     }
1347 
1348     function _setOwner(address newOwner) private {
1349         address oldOwner = _owner;
1350         _owner = newOwner;
1351         emit OwnershipTransferred(oldOwner, newOwner);
1352     }
1353 }
1354 
1355 
1356 
1357 //Arq Skulls Physical Contract//
1358 
1359 contract BoardApeCollective is ERC721Enumerable, Ownable {
1360     
1361     
1362     address private _controlCenter;
1363     uint256 public constant max_apes = 2001;
1364     uint256 private _maxRedemption = 10;
1365     uint256 private _mintLimit = 10;
1366     uint256 private _price = 70000000000000000; //0.5 ETH
1367     uint256 private _memberPrice = 5000000000000000;
1368     uint256 private _publicSaleTime = 1642876500;
1369     uint256 private _whitelistSaleTime = 1642876200;
1370     ControlCenter private cc = ControlCenter(_controlCenter);
1371     string private _uriPrefix;
1372     string private _baseTokenURI;
1373     
1374     string private _provenanceHash;
1375     
1376     mapping(address => uint256) private _walletMinted;
1377 
1378     
1379     
1380 
1381     constructor(string memory baseURI, string memory provenanceHash)
1382         ERC721("Board Ape Collective", "BAC")
1383     {
1384         setBaseURI(baseURI);
1385         _provenanceHash = provenanceHash;
1386         _uriPrefix = "ipfs://"; //default to ipfs 
1387     }
1388     
1389     function getControlCenter() public view returns(address){
1390         return _controlCenter;
1391     }
1392     function setURIPrefix (string memory uriPrefix) public onlyOwner{
1393         _uriPrefix = uriPrefix;
1394     }
1395     function setBaseURI(string memory baseURI) public onlyOwner {
1396         _baseTokenURI = baseURI;
1397     }
1398     function getProvenanceHash() public view returns(string memory) {
1399         return _provenanceHash;
1400     }
1401     function updateControlCenterAddress(address _cca) public onlyOwner {
1402         _controlCenter = _cca;
1403     }
1404 
1405     function _baseURI() internal view virtual override returns (string memory) {
1406         
1407         return string(abi.encodePacked(_uriPrefix,_baseTokenURI));
1408     }
1409     
1410 
1411     function setPublicSaleTime(uint256 _time) public onlyOwner {
1412         _publicSaleTime = _time;
1413     }
1414     function setWhitelistSaleTime(uint256 _time) public onlyOwner {
1415         _whitelistSaleTime = _time;
1416     }
1417 
1418     function getSaleTime(address user) public view returns (uint256) {
1419         ControlCenter c = ControlCenter(_controlCenter);
1420         if(user !=address(0) ){
1421             if(c.getBalance(user) > 0){
1422                 return _whitelistSaleTime;
1423             } else {
1424                 return _publicSaleTime;
1425             }
1426         } else {
1427             return _publicSaleTime;
1428         }
1429     }
1430     function getBlockTime () public view returns(uint256) {
1431     return block.timestamp;}
1432     function getTimeUntilSale (address user) public view returns (uint256){
1433         
1434         uint256 saleTime =  getSaleTime(user);
1435         if(block.timestamp >= saleTime){
1436             return 0;
1437         } else {
1438             return SafeMath.sub(saleTime,block.timestamp);
1439         }
1440     }
1441 
1442     function setPrice(uint256 _newWEIPrice) public onlyOwner {
1443         _price = _newWEIPrice;
1444     }
1445     function setMemberPrice(uint256 _newWEIPrice) public onlyOwner {
1446         _memberPrice = _newWEIPrice;
1447     }
1448 
1449     function getPrice() public view returns (uint256) {
1450         return _price;
1451     }
1452 
1453     
1454     function pairWithControlCenter(address _conCenter) public onlyOwner{
1455         if(_controlCenter != _conCenter){
1456             _controlCenter = _conCenter;
1457         }
1458         ControlCenter controlCenter = ControlCenter(_controlCenter);
1459         controlCenter.pairContract(address(this),_maxRedemption);
1460     }
1461     
1462     function getCallerPrice(uint256 _quantityMint) public view returns (uint256){
1463         ControlCenter controlCenter = ControlCenter(_controlCenter);
1464         uint256 _eligibleBalance = controlCenter.getBalance(msg.sender);
1465         if(_eligibleBalance > 0){
1466           return SafeMath.mul(_memberPrice,_quantityMint);
1467         } else {
1468             return SafeMath.mul(_price,_quantityMint);
1469         }
1470     }
1471 
1472     
1473     function mint(uint256 _count) public payable {
1474         uint256 totSupply = totalSupply();
1475         require(block.timestamp >= getSaleTime(msg.sender), "Sale is not yet open.");
1476         require(totSupply < max_apes, "All Apes have been Claimed.");
1477         require(totSupply + _count <= max_apes,"There are not enough Apes available");
1478         require(_walletMinted[msg.sender] + _count <= _maxRedemption, "Wallet would exceed mint limit");       
1479         require(msg.value == getCallerPrice(_count),"Price was not correct. Please send with the right amount of ETH.");
1480 
1481         for(uint i = 0; i < _count; i++) {
1482             uint mintIndex = totalSupply();
1483             if (mintIndex < max_apes) {
1484                 _safeMint(msg.sender, mintIndex);
1485                 _walletMinted[msg.sender] ++;
1486             }
1487         }
1488     }
1489 
1490     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1491         uint256 tokenCount = balanceOf(_owner);
1492         if (tokenCount == 0) {
1493             return new uint256[](0);
1494         }
1495 
1496         uint256[] memory tokensId = new uint256[](tokenCount);
1497         for (uint256 i; i < tokenCount; i++) {
1498             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1499         }
1500         return tokensId;
1501     }
1502 
1503     function withdrawAll() public payable onlyOwner {
1504         require(payable(msg.sender).send(address(this).balance));
1505     }
1506 }
1507 
1508 abstract contract ControlCenter {
1509     //_tokenContractAddresses: Array of all potential ERC721 contracts that any token that interfaces with ControlCenter can access.
1510     address[] private _tokenContractAddresses;
1511     //_usingControlCenter keeps track of the contracts paired with this ControlCenter.
1512     address[] private _usingControlCenter;
1513     //owner: ControlCenter Owner 
1514     address private owner;
1515     //_maxRedemptions: where address: Child Contract Address (external contract using the ControlCenter) mapped to the maximum number of redemptions allowed for that Child Contract (e.g. contract 0x123 only allows 3 redemptions per wallet);
1516     mapping(address=>uint256) private _maxRedemptions;
1517     //_activeTokenContracts: where address is one of the _contractAddress members mapped to a boolean denoting whether or not to ignore that contract in downstream functions. Setting this to false will effectively 'shut off' a specific contract from any considersations made by the ControlCenter
1518     mapping(address => bool) private _activeTokenContracts;
1519     //_contractEligibility: where address1 = similar to _activeTokenContracts but on a specific Child Contract level, setting [ChildContractAddress][TokenContractAddress] = false removes the [TokenContractAddress] from being considered as a redeemable token contract for the Child Contract. 
1520     mapping(address=> mapping(address=>bool)) private _contractEligibility;
1521     mapping(address => mapping(address => mapping(uint256 => bool))) private tokenVer; //Mapping of [Child Contract] => [Corresponding ERC721 Token Contract] => [Corresponding ERC721 Token's Token ID] => [Redeemed (True/False)] whether a token has been redeemed for a specific Child Contract
1522     //_walletRedeemed: the number of tokens redeemed for a specific Child Contract. [Child Contract Address] => [Wallet Address] => [Number of Tokens Redeemed]
1523     mapping(address => mapping(address=>uint256)) private _walletRedeemed;
1524     
1525     constructor(){
1526         owner = msg.sender;
1527     }
1528     
1529     
1530     /*
1531     *@dev Returns the balance of all active Token Contracts on the ControlCenter
1532     * @param _addy address Wallet address of a given user.
1533     */
1534     function getBalance(address _addy) public view returns (uint256) {
1535         uint256 _balance =0;
1536         for (uint256 i=0;i<_tokenContractAddresses.length;i++){
1537             if (_activeTokenContracts[_tokenContractAddresses[i]]){
1538                 _balance = SafeMath.add(_balance,ERC721(_tokenContractAddresses[i]).balanceOf(_addy));
1539             }
1540         }
1541         return _balance;
1542     }
1543     
1544     /*
1545     *@dev Returns the maximum token redemptions allowed for a given Child Contract
1546     *Used to verify contract was onboarded to the ControlCenter correctly
1547     * @param _childContract address Address of a Child Contract implementing ControlCenter functions
1548     */
1549     function checkContractStats(address _childContract) public view returns(uint256) {
1550         return (_maxRedemptions[_childContract]);
1551     }
1552     
1553     /*@dev This function checks the eligible balance of an address for a certain Child Contract. 
1554     *While a caller may have any number of tokens, eligibility is determined by the maximum number of tokens a Child Contract supports as defined by the _maxRedemptions mapping and how many times a wallet 
1555     *has redeemed tokens (_walletRedeemed) against the Child Contract (also determined by _maxRedemptions)
1556     *@param _childContract address Address of a Child Contract implementing ControlCenter functions
1557     *@param _addy address Wallet address of a given user (typically implemented as msg.sender from the Child Contract).
1558     */
1559     function getEligibleBalance(address _childContract, address _addy) public view returns (uint256){
1560         uint256 foundCount = 0;
1561         for (uint256 i = 0; i<_tokenContractAddresses.length;i++){
1562             if(_contractEligibility[_childContract][_tokenContractAddresses[i]] && _activeTokenContracts[_tokenContractAddresses[i]]){
1563                 ERC721Enumerable con = ERC721Enumerable(_tokenContractAddresses[i]);
1564                 uint256 conBalance = con.balanceOf(_addy);
1565                 if ( conBalance > 0){
1566                     for (uint256 ii = 0; ii<conBalance; ii++){
1567                         ERC721Enumerable conE = ERC721Enumerable(_tokenContractAddresses[i]);
1568                         uint256 tokenID = conE.tokenOfOwnerByIndex(_addy,ii);
1569                         if(tokenVer[_childContract][_tokenContractAddresses[i]][tokenID] == false){
1570                             foundCount++;
1571                         }
1572                     }
1573                 }
1574             }
1575             
1576         }
1577         if (foundCount > 0){
1578             if (foundCount >= _maxRedemptions[_childContract] && _maxRedemptions[_childContract] >= _walletRedeemed[_childContract][_addy]){
1579                 return SafeMath.sub(_maxRedemptions[_childContract], _walletRedeemed[_childContract][_addy]);
1580             } else if (foundCount<=_maxRedemptions[_childContract] && foundCount >= _walletRedeemed[_childContract][_addy]){
1581                 return SafeMath.sub(foundCount,_walletRedeemed[_childContract][_addy]);
1582             } else {
1583                 return 0;
1584             }
1585         }
1586         else {
1587             return 0;
1588         }
1589     }
1590     
1591     /*@dev This function is called when onboarding a new Child Contract to this ControlCenter
1592     *@param _childContract address Address of a Child Contract implementing ControlCenter functions
1593     *@param _maxRed uint256 maximum number of tokens that can be redeemed against a certain Child Contract.
1594     */
1595     function pairContract(address _childContract, uint256 _maxRed) public{
1596         require(msg.sender == owner || msg.sender == _childContract, "Caller not authorized for this function");
1597          _maxRedemptions[_childContract] = _maxRed;
1598         for(uint256 i =0; i<_tokenContractAddresses.length;i++){
1599             _contractEligibility[_childContract][_tokenContractAddresses[i]] = true;
1600         }
1601         activateTokenContract(_childContract);
1602     }
1603     
1604     /*@dev This function can be used to manually override which Token Contracts are eligible to be redeemed for a certain Child Contract
1605     *@param _childContract address Address of a Child Contract implementing ControlCenter functions
1606     *@param _targetContract address Address of a target Token Contract whose state is being modified.
1607     *@param _newEligibility bool Whether or not the _targetContract can be redeemed against the given _childContract
1608     */
1609     function setChildContractEligibility (address _childContract, address _targetContract, bool _newEligibility) public {
1610         require(msg.sender == owner || msg.sender == _childContract, "Caller not authorized for this function.");
1611         _contractEligibility[_childContract][_targetContract] = _newEligibility;
1612         
1613     }
1614     
1615     /*@dev This function handles the interal considerations for token redemptions.
1616     *This function in this version of ControlCenter is pretty indiscriminate in regards to which tokens it takes for redemption.
1617     *It's not so much concerned about what or where the tokens come from, so much as it is concerned that they are or are not available tokens to be redeemed.
1618     *If they are redeeemable per the Child Contract, then they're set to 'redeemed' and cannot be redeemed again for that particular Child Contract.
1619     *Additionally, redeeming a token from any given wallet will count against that wallet's total redemption number for a given Child Contract.
1620     *Once a token has been redeemed for a Child Contract it cannot be redeemed again, similarly a wallet cannot reduce the number of redemptions by sending a token elsewhere.
1621     *@param _childContract address Address of a Child Contract implementing ControlCenter functions
1622     *@param _redemptionNumber uint256 Number of tokens requested to be redeemed.
1623     *@param _addy address Wallet address of a given user (typically implemented as msg.sender from the Child Contract).
1624     */
1625     function redeemEligibleTokens(address _childContract, uint256 _redemptionNumber, address _addy) public {
1626         //Must meet a number of requirements to continue to log a token as redeemed.
1627         require(msg.sender == owner || msg.sender == _childContract,"Caller not authorized for this function");
1628         require(_redemptionNumber > 0, "Cannot redeem 0 tokens, you dork.");
1629         require(_walletRedeemed[_childContract][_addy] < _maxRedemptions[_childContract], "Caller has already redeemed maximum number of Tokens");
1630         require(_redemptionNumber <= getEligibleBalance(_childContract, _addy),"This wallet cannot redeem this many tokens, please adjust_redemptionAmount");
1631         require(getEligibleBalance(_childContract, _addy) > 0, "Caller has no Eligible Tokens for this Contract");
1632         
1633         uint256 _foundCount = 0;
1634         uint256 _functionalLimit = getEligibleBalance(_childContract, _addy);
1635         
1636         //Functional limit is meant to cut down on potential wasted gas by taking the lesser of either what the user has opted to redeem or how many tokens the user is eligible to redeem
1637         if (_functionalLimit > _redemptionNumber) {
1638             _functionalLimit = _redemptionNumber;
1639         }
1640         
1641         if (_functionalLimit > 0){
1642             //Seeks to save gas by breaking out of the loop if the _foundCount reaches the functionalLimit (meaning if it finds enough eligible tokens there's no point continuing to run the loop)
1643             for (uint256 i = 0; i<_tokenContractAddresses.length && _foundCount < _functionalLimit;i++){ 
1644                 if(_contractEligibility[_childContract][_tokenContractAddresses[i]] && _activeTokenContracts[_tokenContractAddresses[i]]){
1645                     ERC721Enumerable con = ERC721Enumerable(_tokenContractAddresses[i]);
1646                     uint256 conBalance = con.balanceOf(_addy); //number of tokens owned by _addy on a given TokenContract[i]
1647                     if ( conBalance > 0){
1648                         //similar gas saving effort here
1649                         for (uint256 ii = 0; ii<conBalance && _foundCount < _functionalLimit; ii++){
1650                             ERC721Enumerable conE = ERC721Enumerable(_tokenContractAddresses[i]);
1651                             uint256 tokenID = conE.tokenOfOwnerByIndex(_addy,ii);
1652                             if(tokenVer[_childContract][_tokenContractAddresses[i]][tokenID] == false){
1653                                 tokenVer[_childContract][_tokenContractAddresses[i]][tokenID] = true; 
1654                                 _foundCount++;
1655                             }
1656                         }
1657                     }
1658                 }
1659                 
1660             }
1661         }
1662         //Adds the number of foundTokens to the wallet's child contract mapping. This only occurs after all of the tokens have been set as redeemed.
1663         _walletRedeemed[_childContract][_addy] = SafeMath.add(_walletRedeemed[_childContract][_addy],_foundCount);
1664     }
1665     
1666     function checkTokenRedemptionStatus(address _childContract,address _tokenAddress, uint256 _tokenID) public view returns (bool){
1667         return (tokenVer[_childContract][_tokenAddress][_tokenID]);
1668     }
1669     
1670     function activateTokenContract(address _contract) public {
1671         require(msg.sender == owner || msg.sender == _contract, "E:ActivateToken - Caller is not the owner");
1672         require(_activeTokenContracts[_contract] == false, "Contract already active");
1673         
1674         if(_isTokenContractOnControlCenter(_contract) == false){
1675             _activeTokenContracts[_contract] = true;
1676             _tokenContractAddresses.push(_contract);
1677         } else {
1678             _activeTokenContracts[_contract] = true;
1679         }
1680         
1681     }
1682     function deactivateTokenContract(address _contract) public {
1683         require(msg.sender == owner, "Sender is not owner");
1684         require(_activeTokenContracts[_contract] == true, "Contract isn't active.");
1685         _activeTokenContracts[_contract] = false;
1686     }
1687     
1688     function _isTokenContractOnControlCenter (address _contract) internal view returns(bool){
1689         uint256 count = 0;
1690         for(uint256 i=0;i<_tokenContractAddresses.length;i++){
1691             if(_tokenContractAddresses[i] == _contract){
1692                 count++;
1693             }
1694         }
1695         return count > 0;
1696     }
1697     
1698     
1699     function checkWalletRedeption(address _addy, address _childContract)public view returns(uint256){
1700         return _walletRedeemed[_childContract][_addy]; 
1701     }
1702     function viewControlCenterContracts() public view returns (address[] memory){
1703         return _tokenContractAddresses;
1704     }
1705     
1706    
1707 }