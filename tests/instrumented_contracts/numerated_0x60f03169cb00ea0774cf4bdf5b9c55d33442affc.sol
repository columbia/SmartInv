1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 // Sources flattened with hardhat v2.3.0 https://hardhat.org
6 
7 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.1.0
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
30 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.1.0
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52 
53     /**
54      * @dev Returns the number of tokens in ``owner``'s account.
55      */
56     function balanceOf(address owner) external view returns (uint256 balance);
57 
58     /**
59      * @dev Returns the owner of the `tokenId` token.
60      *
61      * Requirements:
62      *
63      * - `tokenId` must exist.
64      */
65     function ownerOf(uint256 tokenId) external view returns (address owner);
66 
67     /**
68      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
69      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(
82         address from,
83         address to,
84         uint256 tokenId
85     ) external;
86 
87     /**
88      * @dev Transfers `tokenId` token from `from` to `to`.
89      *
90      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must be owned by `from`.
97      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
109      * The approval is cleared when the token is transferred.
110      *
111      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
112      *
113      * Requirements:
114      *
115      * - The caller must own the token or be an approved operator.
116      * - `tokenId` must exist.
117      *
118      * Emits an {Approval} event.
119      */
120     function approve(address to, uint256 tokenId) external;
121 
122     /**
123      * @dev Returns the account approved for `tokenId` token.
124      *
125      * Requirements:
126      *
127      * - `tokenId` must exist.
128      */
129     function getApproved(uint256 tokenId) external view returns (address operator);
130 
131     /**
132      * @dev Approve or remove `operator` as an operator for the caller.
133      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
134      *
135      * Requirements:
136      *
137      * - The `operator` cannot be the caller.
138      *
139      * Emits an {ApprovalForAll} event.
140      */
141     function setApprovalForAll(address operator, bool _approved) external;
142 
143     /**
144      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
145      *
146      * See {setApprovalForAll}
147      */
148     function isApprovedForAll(address owner, address operator) external view returns (bool);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must exist and be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
160      *
161      * Emits a {Transfer} event.
162      */
163     function safeTransferFrom(
164         address from,
165         address to,
166         uint256 tokenId,
167         bytes calldata data
168     ) external;
169 }
170 
171 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.1.0
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @title ERC721 token receiver interface
177  * @dev Interface for any contract that wants to support safeTransfers
178  * from ERC721 asset contracts.
179  */
180 interface IERC721Receiver {
181     /**
182      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
183      * by `operator` from `from`, this function is called.
184      *
185      * It must return its Solidity selector to confirm the token transfer.
186      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
187      *
188      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
189      */
190     function onERC721Received(
191         address operator,
192         address from,
193         uint256 tokenId,
194         bytes calldata data
195     ) external returns (bytes4);
196 }
197 
198 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.1.0
199 
200 pragma solidity ^0.8.0;
201 
202 /**
203  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
204  * @dev See https://eips.ethereum.org/EIPS/eip-721
205  */
206 interface IERC721Metadata is IERC721 {
207     /**
208      * @dev Returns the token collection name.
209      */
210     function name() external view returns (string memory);
211 
212     /**
213      * @dev Returns the token collection symbol.
214      */
215     function symbol() external view returns (string memory);
216 
217     /**
218      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
219      */
220     function tokenURI(uint256 tokenId) external view returns (string memory);
221 }
222 
223 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev Collection of functions related to the address type
229  */
230 library Address {
231     /**
232      * @dev Returns true if `account` is a contract.
233      *
234      * [IMPORTANT]
235      * ====
236      * It is unsafe to assume that an address for which this function returns
237      * false is an externally-owned account (EOA) and not a contract.
238      *
239      * Among others, `isContract` will return false for the following
240      * types of addresses:
241      *
242      *  - an externally-owned account
243      *  - a contract in construction
244      *  - an address where a contract will be created
245      *  - an address where a contract lived, but was destroyed
246      * ====
247      */
248     function isContract(address account) internal view returns (bool) {
249         // This method relies on extcodesize, which returns 0 for contracts in
250         // construction, since the code is only stored at the end of the
251         // constructor execution.
252 
253         uint256 size;
254         // solhint-disable-next-line no-inline-assembly
255         assembly {
256             size := extcodesize(account)
257         }
258         return size > 0;
259     }
260 
261     /**
262      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
263      * `recipient`, forwarding all available gas and reverting on errors.
264      *
265      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
266      * of certain opcodes, possibly making contracts go over the 2300 gas limit
267      * imposed by `transfer`, making them unable to receive funds via
268      * `transfer`. {sendValue} removes this limitation.
269      *
270      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
271      *
272      * IMPORTANT: because control is transferred to `recipient`, care must be
273      * taken to not create reentrancy vulnerabilities. Consider using
274      * {ReentrancyGuard} or the
275      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
276      */
277     function sendValue(address payable recipient, uint256 amount) internal {
278         require(address(this).balance >= amount, 'Address: insufficient balance');
279 
280         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
281         (bool success, ) = recipient.call{value: amount}('');
282         require(success, 'Address: unable to send value, recipient may have reverted');
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain`call` is an unsafe replacement for a function call: use this
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
304         return functionCall(target, data, 'Address: low-level call failed');
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
337         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
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
352         require(address(this).balance >= value, 'Address: insufficient balance for call');
353         require(isContract(target), 'Address: call to non-contract');
354 
355         // solhint-disable-next-line avoid-low-level-calls
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return _verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, 'Address: low-level static call failed');
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         require(isContract(target), 'Address: static call to non-contract');
382 
383         // solhint-disable-next-line avoid-low-level-calls
384         (bool success, bytes memory returndata) = target.staticcall(data);
385         return _verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but performing a delegate call.
391      *
392      * _Available since v3.4._
393      */
394     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
395         return functionDelegateCall(target, data, 'Address: low-level delegate call failed');
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
400      * but performing a delegate call.
401      *
402      * _Available since v3.4._
403      */
404     function functionDelegateCall(
405         address target,
406         bytes memory data,
407         string memory errorMessage
408     ) internal returns (bytes memory) {
409         require(isContract(target), 'Address: delegate call to non-contract');
410 
411         // solhint-disable-next-line avoid-low-level-calls
412         (bool success, bytes memory returndata) = target.delegatecall(data);
413         return _verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     function _verifyCallResult(
417         bool success,
418         bytes memory returndata,
419         string memory errorMessage
420     ) private pure returns (bytes memory) {
421         if (success) {
422             return returndata;
423         } else {
424             // Look for revert reason and bubble it up if present
425             if (returndata.length > 0) {
426                 // The easiest way to bubble the revert reason is using memory via assembly
427 
428                 // solhint-disable-next-line no-inline-assembly
429                 assembly {
430                     let returndata_size := mload(returndata)
431                     revert(add(32, returndata), returndata_size)
432                 }
433             } else {
434                 revert(errorMessage);
435             }
436         }
437     }
438 }
439 
440 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
441 
442 pragma solidity ^0.8.0;
443 
444 /*
445  * @dev Provides information about the current execution context, including the
446  * sender of the transaction and its data. While these are generally available
447  * via msg.sender and msg.data, they should not be accessed in such a direct
448  * manner, since when dealing with meta-transactions the account sending and
449  * paying for execution may not be the actual sender (as far as an application
450  * is concerned).
451  *
452  * This contract is only required for intermediate, library-like contracts.
453  */
454 abstract contract Context {
455     function _msgSender() internal view virtual returns (address) {
456         return msg.sender;
457     }
458 
459     function _msgData() internal view virtual returns (bytes calldata) {
460         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
461         return msg.data;
462     }
463 }
464 
465 // File @openzeppelin/contracts/utils/Strings.sol@v4.1.0
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @dev String operations.
471  */
472 library Strings {
473     bytes16 private constant alphabet = '0123456789abcdef';
474 
475     /**
476      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
477      */
478     function toString(uint256 value) internal pure returns (string memory) {
479         // Inspired by OraclizeAPI's implementation - MIT licence
480         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
481 
482         if (value == 0) {
483             return '0';
484         }
485         uint256 temp = value;
486         uint256 digits;
487         while (temp != 0) {
488             digits++;
489             temp /= 10;
490         }
491         bytes memory buffer = new bytes(digits);
492         while (value != 0) {
493             digits -= 1;
494             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
495             value /= 10;
496         }
497         return string(buffer);
498     }
499 
500     /**
501      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
502      */
503     function toHexString(uint256 value) internal pure returns (string memory) {
504         if (value == 0) {
505             return '0x00';
506         }
507         uint256 temp = value;
508         uint256 length = 0;
509         while (temp != 0) {
510             length++;
511             temp >>= 8;
512         }
513         return toHexString(value, length);
514     }
515 
516     /**
517      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
518      */
519     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
520         bytes memory buffer = new bytes(2 * length + 2);
521         buffer[0] = '0';
522         buffer[1] = 'x';
523         for (uint256 i = 2 * length + 1; i > 1; --i) {
524             buffer[i] = alphabet[value & 0xf];
525             value >>= 4;
526         }
527         require(value == 0, 'Strings: hex length insufficient');
528         return string(buffer);
529     }
530 }
531 
532 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.1.0
533 
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @dev Implementation of the {IERC165} interface.
538  *
539  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
540  * for the additional interface id that will be supported. For example:
541  *
542  * ```solidity
543  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
545  * }
546  * ```
547  *
548  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
549  */
550 abstract contract ERC165 is IERC165 {
551     /**
552      * @dev See {IERC165-supportsInterface}.
553      */
554     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
555         return interfaceId == type(IERC165).interfaceId;
556     }
557 }
558 
559 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.1.0
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
565  * the Metadata extension, but not including the Enumerable extension, which is available separately as
566  * {ERC721Enumerable}.
567  */
568 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
569     using Address for address;
570     using Strings for uint256;
571 
572     // Token name
573     string private _name;
574 
575     // Token symbol
576     string private _symbol;
577 
578     // Mapping from token ID to owner address
579     mapping(uint256 => address) private _owners;
580 
581     // Mapping owner address to token count
582     mapping(address => uint256) private _balances;
583 
584     // Mapping from token ID to approved address
585     mapping(uint256 => address) private _tokenApprovals;
586 
587     // Mapping from owner to operator approvals
588     mapping(address => mapping(address => bool)) private _operatorApprovals;
589 
590     /**
591      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
592      */
593     constructor(string memory name_, string memory symbol_) {
594         _name = name_;
595         _symbol = symbol_;
596     }
597 
598     /**
599      * @dev See {IERC165-supportsInterface}.
600      */
601     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
602         return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
603     }
604 
605     /**
606      * @dev See {IERC721-balanceOf}.
607      */
608     function balanceOf(address owner) public view virtual override returns (uint256) {
609         require(owner != address(0), 'ERC721: balance query for the zero address');
610         return _balances[owner];
611     }
612 
613     /**
614      * @dev See {IERC721-ownerOf}.
615      */
616     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
617         address owner = _owners[tokenId];
618         require(owner != address(0), 'ERC721: owner query for nonexistent token');
619         return owner;
620     }
621 
622     /**
623      * @dev See {IERC721Metadata-name}.
624      */
625     function name() public view virtual override returns (string memory) {
626         return _name;
627     }
628 
629     /**
630      * @dev See {IERC721Metadata-symbol}.
631      */
632     function symbol() public view virtual override returns (string memory) {
633         return _symbol;
634     }
635 
636     /**
637      * @dev See {IERC721Metadata-tokenURI}.
638      */
639     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
640         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
641 
642         string memory baseURI = _baseURI();
643         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
644     }
645 
646     /**
647      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
648      * in child contracts.
649      */
650     function _baseURI() internal view virtual returns (string memory) {
651         return '';
652     }
653 
654     /**
655      * @dev See {IERC721-approve}.
656      */
657     function approve(address to, uint256 tokenId) public virtual override {
658         address owner = ERC721.ownerOf(tokenId);
659         require(to != owner, 'ERC721: approval to current owner');
660 
661         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), 'ERC721: approve caller is not owner nor approved for all');
662 
663         _approve(to, tokenId);
664     }
665 
666     /**
667      * @dev See {IERC721-getApproved}.
668      */
669     function getApproved(uint256 tokenId) public view virtual override returns (address) {
670         require(_exists(tokenId), 'ERC721: approved query for nonexistent token');
671 
672         return _tokenApprovals[tokenId];
673     }
674 
675     /**
676      * @dev See {IERC721-setApprovalForAll}.
677      */
678     function setApprovalForAll(address operator, bool approved) public virtual override {
679         require(operator != _msgSender(), 'ERC721: approve to caller');
680 
681         _operatorApprovals[_msgSender()][operator] = approved;
682         emit ApprovalForAll(_msgSender(), operator, approved);
683     }
684 
685     /**
686      * @dev See {IERC721-isApprovedForAll}.
687      */
688     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
689         return _operatorApprovals[owner][operator];
690     }
691 
692     /**
693      * @dev See {IERC721-transferFrom}.
694      */
695     function transferFrom(
696         address from,
697         address to,
698         uint256 tokenId
699     ) public virtual override {
700         //solhint-disable-next-line max-line-length
701         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
702 
703         _transfer(from, to, tokenId);
704     }
705 
706     /**
707      * @dev See {IERC721-safeTransferFrom}.
708      */
709     function safeTransferFrom(
710         address from,
711         address to,
712         uint256 tokenId
713     ) public virtual override {
714         safeTransferFrom(from, to, tokenId, '');
715     }
716 
717     /**
718      * @dev See {IERC721-safeTransferFrom}.
719      */
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 tokenId,
724         bytes memory _data
725     ) public virtual override {
726         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
727         _safeTransfer(from, to, tokenId, _data);
728     }
729 
730     /**
731      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
732      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
733      *
734      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
735      *
736      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
737      * implement alternative mechanisms to perform token transfer, such as signature-based.
738      *
739      * Requirements:
740      *
741      * - `from` cannot be the zero address.
742      * - `to` cannot be the zero address.
743      * - `tokenId` token must exist and be owned by `from`.
744      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
745      *
746      * Emits a {Transfer} event.
747      */
748     function _safeTransfer(
749         address from,
750         address to,
751         uint256 tokenId,
752         bytes memory _data
753     ) internal virtual {
754         _transfer(from, to, tokenId);
755         require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
756     }
757 
758     /**
759      * @dev Returns whether `tokenId` exists.
760      *
761      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
762      *
763      * Tokens start existing when they are minted (`_mint`),
764      * and stop existing when they are burned (`_burn`).
765      */
766     function _exists(uint256 tokenId) internal view virtual returns (bool) {
767         return _owners[tokenId] != address(0);
768     }
769 
770     /**
771      * @dev Returns whether `spender` is allowed to manage `tokenId`.
772      *
773      * Requirements:
774      *
775      * - `tokenId` must exist.
776      */
777     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
778         require(_exists(tokenId), 'ERC721: operator query for nonexistent token');
779         address owner = ERC721.ownerOf(tokenId);
780         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
781     }
782 
783     /**
784      * @dev Safely mints `tokenId` and transfers it to `to`.
785      *
786      * Requirements:
787      *
788      * - `tokenId` must not exist.
789      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
790      *
791      * Emits a {Transfer} event.
792      */
793     function _safeMint(address to, uint256 tokenId) internal virtual {
794         _safeMint(to, tokenId, '');
795     }
796 
797     /**
798      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
799      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
800      */
801     function _safeMint(
802         address to,
803         uint256 tokenId,
804         bytes memory _data
805     ) internal virtual {
806         _mint(to, tokenId);
807         require(_checkOnERC721Received(address(0), to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
808     }
809 
810     /**
811      * @dev Mints `tokenId` and transfers it to `to`.
812      *
813      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
814      *
815      * Requirements:
816      *
817      * - `tokenId` must not exist.
818      * - `to` cannot be the zero address.
819      *
820      * Emits a {Transfer} event.
821      */
822     function _mint(address to, uint256 tokenId) internal virtual {
823         require(to != address(0), 'ERC721: mint to the zero address');
824         require(!_exists(tokenId), 'ERC721: token already minted');
825 
826         _beforeTokenTransfer(address(0), to, tokenId);
827 
828         _balances[to] += 1;
829         _owners[tokenId] = to;
830 
831         emit Transfer(address(0), to, tokenId);
832     }
833 
834     /**
835      * @dev Destroys `tokenId`.
836      * The approval is cleared when the token is burned.
837      *
838      * Requirements:
839      *
840      * - `tokenId` must exist.
841      *
842      * Emits a {Transfer} event.
843      */
844     function _burn(uint256 tokenId) internal virtual {
845         address owner = ERC721.ownerOf(tokenId);
846 
847         _beforeTokenTransfer(owner, address(0), tokenId);
848 
849         // Clear approvals
850         _approve(address(0), tokenId);
851 
852         _balances[owner] -= 1;
853         delete _owners[tokenId];
854 
855         emit Transfer(owner, address(0), tokenId);
856     }
857 
858     /**
859      * @dev Transfers `tokenId` from `from` to `to`.
860      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
861      *
862      * Requirements:
863      *
864      * - `to` cannot be the zero address.
865      * - `tokenId` token must be owned by `from`.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _transfer(
870         address from,
871         address to,
872         uint256 tokenId
873     ) internal virtual {
874         require(ERC721.ownerOf(tokenId) == from, 'ERC721: transfer of token that is not own');
875         require(to != address(0), 'ERC721: transfer to the zero address');
876 
877         _beforeTokenTransfer(from, to, tokenId);
878 
879         // Clear approvals from the previous owner
880         _approve(address(0), tokenId);
881 
882         _balances[from] -= 1;
883         _balances[to] += 1;
884         _owners[tokenId] = to;
885 
886         emit Transfer(from, to, tokenId);
887     }
888 
889     /**
890      * @dev Approve `to` to operate on `tokenId`
891      *
892      * Emits a {Approval} event.
893      */
894     function _approve(address to, uint256 tokenId) internal virtual {
895         _tokenApprovals[tokenId] = to;
896         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
897     }
898 
899     /**
900      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
901      * The call is not executed if the target address is not a contract.
902      *
903      * @param from address representing the previous owner of the given token ID
904      * @param to target address that will receive the tokens
905      * @param tokenId uint256 ID of the token to be transferred
906      * @param _data bytes optional data to send along with the call
907      * @return bool whether the call correctly returned the expected magic value
908      */
909     function _checkOnERC721Received(
910         address from,
911         address to,
912         uint256 tokenId,
913         bytes memory _data
914     ) private returns (bool) {
915         if (to.isContract()) {
916             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
917                 return retval == IERC721Receiver(to).onERC721Received.selector;
918             } catch (bytes memory reason) {
919                 if (reason.length == 0) {
920                     revert('ERC721: transfer to non ERC721Receiver implementer');
921                 } else {
922                     // solhint-disable-next-line no-inline-assembly
923                     assembly {
924                         revert(add(32, reason), mload(reason))
925                     }
926                 }
927             }
928         } else {
929             return true;
930         }
931     }
932 
933     /**
934      * @dev Hook that is called before any token transfer. This includes minting
935      * and burning.
936      *
937      * Calling conditions:
938      *
939      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
940      * transferred to `to`.
941      * - When `from` is zero, `tokenId` will be minted for `to`.
942      * - When `to` is zero, ``from``'s `tokenId` will be burned.
943      * - `from` cannot be the zero address.
944      * - `to` cannot be the zero address.
945      *
946      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
947      */
948     function _beforeTokenTransfer(
949         address from,
950         address to,
951         uint256 tokenId
952     ) internal virtual {}
953 }
954 
955 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.1.0
956 
957 pragma solidity ^0.8.0;
958 
959 /**
960  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
961  * @dev See https://eips.ethereum.org/EIPS/eip-721
962  */
963 interface IERC721Enumerable is IERC721 {
964     /**
965      * @dev Returns the total amount of tokens stored by the contract.
966      */
967     function totalSupply() external view returns (uint256);
968 
969     /**
970      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
971      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
972      */
973     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
974 
975     /**
976      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
977      * Use along with {totalSupply} to enumerate all tokens.
978      */
979     function tokenByIndex(uint256 index) external view returns (uint256);
980 }
981 
982 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.1.0
983 
984 pragma solidity ^0.8.0;
985 
986 /**
987  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
988  * enumerability of all the token ids in the contract as well as all token ids owned by each
989  * account.
990  */
991 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
992     // Mapping from owner to list of owned token IDs
993     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
994 
995     // Mapping from token ID to index of the owner tokens list
996     mapping(uint256 => uint256) private _ownedTokensIndex;
997 
998     // Array with all token ids, used for enumeration
999     uint256[] private _allTokens;
1000 
1001     // Mapping from token id to position in the allTokens array
1002     mapping(uint256 => uint256) private _allTokensIndex;
1003 
1004     /**
1005      * @dev See {IERC165-supportsInterface}.
1006      */
1007     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1008         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1013      */
1014     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1015         require(index < ERC721.balanceOf(owner), 'ERC721Enumerable: owner index out of bounds');
1016         return _ownedTokens[owner][index];
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Enumerable-totalSupply}.
1021      */
1022     function totalSupply() public view virtual override returns (uint256) {
1023         return _allTokens.length;
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Enumerable-tokenByIndex}.
1028      */
1029     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1030         require(index < ERC721Enumerable.totalSupply(), 'ERC721Enumerable: global index out of bounds');
1031         return _allTokens[index];
1032     }
1033 
1034     /**
1035      * @dev Hook that is called before any token transfer. This includes minting
1036      * and burning.
1037      *
1038      * Calling conditions:
1039      *
1040      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1041      * transferred to `to`.
1042      * - When `from` is zero, `tokenId` will be minted for `to`.
1043      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1044      * - `from` cannot be the zero address.
1045      * - `to` cannot be the zero address.
1046      *
1047      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1048      */
1049     function _beforeTokenTransfer(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) internal virtual override {
1054         super._beforeTokenTransfer(from, to, tokenId);
1055 
1056         if (from == address(0)) {
1057             _addTokenToAllTokensEnumeration(tokenId);
1058         } else if (from != to) {
1059             _removeTokenFromOwnerEnumeration(from, tokenId);
1060         }
1061         if (to == address(0)) {
1062             _removeTokenFromAllTokensEnumeration(tokenId);
1063         } else if (to != from) {
1064             _addTokenToOwnerEnumeration(to, tokenId);
1065         }
1066     }
1067 
1068     /**
1069      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1070      * @param to address representing the new owner of the given token ID
1071      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1072      */
1073     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1074         uint256 length = ERC721.balanceOf(to);
1075         _ownedTokens[to][length] = tokenId;
1076         _ownedTokensIndex[tokenId] = length;
1077     }
1078 
1079     /**
1080      * @dev Private function to add a token to this extension's token tracking data structures.
1081      * @param tokenId uint256 ID of the token to be added to the tokens list
1082      */
1083     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1084         _allTokensIndex[tokenId] = _allTokens.length;
1085         _allTokens.push(tokenId);
1086     }
1087 
1088     /**
1089      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1090      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1091      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1092      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1093      * @param from address representing the previous owner of the given token ID
1094      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1095      */
1096     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1097         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1098         // then delete the last slot (swap and pop).
1099 
1100         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1101         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1102 
1103         // When the token to delete is the last token, the swap operation is unnecessary
1104         if (tokenIndex != lastTokenIndex) {
1105             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1106 
1107             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1108             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1109         }
1110 
1111         // This also deletes the contents at the last position of the array
1112         delete _ownedTokensIndex[tokenId];
1113         delete _ownedTokens[from][lastTokenIndex];
1114     }
1115 
1116     /**
1117      * @dev Private function to remove a token from this extension's token tracking data structures.
1118      * This has O(1) time complexity, but alters the order of the _allTokens array.
1119      * @param tokenId uint256 ID of the token to be removed from the tokens list
1120      */
1121     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1122         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1123         // then delete the last slot (swap and pop).
1124 
1125         uint256 lastTokenIndex = _allTokens.length - 1;
1126         uint256 tokenIndex = _allTokensIndex[tokenId];
1127 
1128         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1129         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1130         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1131         uint256 lastTokenId = _allTokens[lastTokenIndex];
1132 
1133         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1134         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1135 
1136         // This also deletes the contents at the last position of the array
1137         delete _allTokensIndex[tokenId];
1138         _allTokens.pop();
1139     }
1140 }
1141 
1142 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol@v4.1.0
1143 
1144 pragma solidity ^0.8.0;
1145 
1146 /**
1147  * @dev ERC721 token with storage based token URI management.
1148  */
1149 abstract contract ERC721URIStorage is ERC721 {
1150     using Strings for uint256;
1151 
1152     // Optional mapping for token URIs
1153     mapping(uint256 => string) private _tokenURIs;
1154 
1155     /**
1156      * @dev See {IERC721Metadata-tokenURI}.
1157      */
1158     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1159         require(_exists(tokenId), 'ERC721URIStorage: URI query for nonexistent token');
1160 
1161         string memory _tokenURI = _tokenURIs[tokenId];
1162         string memory base = _baseURI();
1163 
1164         // If there is no base URI, return the token URI.
1165         if (bytes(base).length == 0) {
1166             return _tokenURI;
1167         }
1168         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1169         if (bytes(_tokenURI).length > 0) {
1170             return string(abi.encodePacked(base, _tokenURI));
1171         }
1172 
1173         return super.tokenURI(tokenId);
1174     }
1175 
1176     /**
1177      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1178      *
1179      * Requirements:
1180      *
1181      * - `tokenId` must exist.
1182      */
1183     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1184         require(_exists(tokenId), 'ERC721URIStorage: URI set of nonexistent token');
1185         _tokenURIs[tokenId] = _tokenURI;
1186     }
1187 
1188     /**
1189      * @dev Destroys `tokenId`.
1190      * The approval is cleared when the token is burned.
1191      *
1192      * Requirements:
1193      *
1194      * - `tokenId` must exist.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function _burn(uint256 tokenId) internal virtual override {
1199         super._burn(tokenId);
1200 
1201         if (bytes(_tokenURIs[tokenId]).length != 0) {
1202             delete _tokenURIs[tokenId];
1203         }
1204     }
1205 }
1206 
1207 // File @openzeppelin/contracts/security/Pausable.sol@v4.1.0
1208 
1209 pragma solidity ^0.8.0;
1210 
1211 /**
1212  * @dev Contract module which allows children to implement an emergency stop
1213  * mechanism that can be triggered by an authorized account.
1214  *
1215  * This module is used through inheritance. It will make available the
1216  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1217  * the functions of your contract. Note that they will not be pausable by
1218  * simply including this module, only once the modifiers are put in place.
1219  */
1220 abstract contract Pausable is Context {
1221     /**
1222      * @dev Emitted when the pause is triggered by `account`.
1223      */
1224     event Paused(address account);
1225 
1226     /**
1227      * @dev Emitted when the pause is lifted by `account`.
1228      */
1229     event Unpaused(address account);
1230 
1231     bool private _paused;
1232 
1233     /**
1234      * @dev Initializes the contract in unpaused state.
1235      */
1236     constructor() {
1237         _paused = false;
1238     }
1239 
1240     /**
1241      * @dev Returns true if the contract is paused, and false otherwise.
1242      */
1243     function paused() public view virtual returns (bool) {
1244         return _paused;
1245     }
1246 
1247     /**
1248      * @dev Modifier to make a function callable only when the contract is not paused.
1249      *
1250      * Requirements:
1251      *
1252      * - The contract must not be paused.
1253      */
1254     modifier whenNotPaused() {
1255         require(!paused(), 'Pausable: paused');
1256         _;
1257     }
1258 
1259     /**
1260      * @dev Modifier to make a function callable only when the contract is paused.
1261      *
1262      * Requirements:
1263      *
1264      * - The contract must be paused.
1265      */
1266     modifier whenPaused() {
1267         require(paused(), 'Pausable: not paused');
1268         _;
1269     }
1270 
1271     /**
1272      * @dev Triggers stopped state.
1273      *
1274      * Requirements:
1275      *
1276      * - The contract must not be paused.
1277      */
1278     function _pause() internal virtual whenNotPaused {
1279         _paused = true;
1280         emit Paused(_msgSender());
1281     }
1282 
1283     /**
1284      * @dev Returns to normal state.
1285      *
1286      * Requirements:
1287      *
1288      * - The contract must be paused.
1289      */
1290     function _unpause() internal virtual whenPaused {
1291         _paused = false;
1292         emit Unpaused(_msgSender());
1293     }
1294 }
1295 
1296 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
1297 
1298 pragma solidity ^0.8.0;
1299 
1300 /**
1301  * @dev Contract module which provides a basic access control mechanism, where
1302  * there is an account (an owner) that can be granted exclusive access to
1303  * specific functions.
1304  *
1305  * By default, the owner account will be the one that deploys the contract. This
1306  * can later be changed with {transferOwnership}.
1307  *
1308  * This module is used through inheritance. It will make available the modifier
1309  * `onlyOwner`, which can be applied to your functions to restrict their use to
1310  * the owner.
1311  */
1312 abstract contract Ownable is Context {
1313     address private _owner;
1314 
1315     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1316 
1317     /**
1318      * @dev Initializes the contract setting the deployer as the initial owner.
1319      */
1320     constructor() {
1321         address msgSender = _msgSender();
1322         _owner = msgSender;
1323         emit OwnershipTransferred(address(0), msgSender);
1324     }
1325 
1326     /**
1327      * @dev Returns the address of the current owner.
1328      */
1329     function owner() public view virtual returns (address) {
1330         return _owner;
1331     }
1332 
1333     /**
1334      * @dev Throws if called by any account other than the owner.
1335      */
1336     modifier onlyOwner() {
1337         require(owner() == _msgSender(), 'Ownable: caller is not the owner');
1338         _;
1339     }
1340 
1341     /**
1342      * @dev Leaves the contract without owner. It will not be possible to call
1343      * `onlyOwner` functions anymore. Can only be called by the current owner.
1344      *
1345      * NOTE: Renouncing ownership will leave the contract without an owner,
1346      * thereby removing any functionality that is only available to the owner.
1347      */
1348     function renounceOwnership() public virtual onlyOwner {
1349         emit OwnershipTransferred(_owner, address(0));
1350         _owner = address(0);
1351     }
1352 
1353     /**
1354      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1355      * Can only be called by the current owner.
1356      */
1357     function transferOwnership(address newOwner) public virtual onlyOwner {
1358         require(newOwner != address(0), 'Ownable: new owner is the zero address');
1359         emit OwnershipTransferred(_owner, newOwner);
1360         _owner = newOwner;
1361     }
1362 }
1363 
1364 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.1.0
1365 
1366 pragma solidity ^0.8.0;
1367 
1368 /**
1369  * @title ERC721 Burnable Token
1370  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1371  */
1372 abstract contract ERC721Burnable is Context, ERC721 {
1373     /**
1374      * @dev Burns `tokenId`. See {ERC721-_burn}.
1375      *
1376      * Requirements:
1377      *
1378      * - The caller must own `tokenId` or be an approved operator.
1379      */
1380     function burn(uint256 tokenId) public virtual {
1381         //solhint-disable-next-line max-line-length
1382         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721Burnable: caller is not owner nor approved');
1383         _burn(tokenId);
1384     }
1385 }
1386 
1387 // File @openzeppelin/contracts/utils/Counters.sol@v4.1.0
1388 
1389 pragma solidity ^0.8.0;
1390 
1391 /**
1392  * @title Counters
1393  * @author Matt Condon (@shrugs)
1394  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1395  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1396  *
1397  * Include with `using Counters for Counters.Counter;`
1398  */
1399 library Counters {
1400     struct Counter {
1401         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1402         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1403         // this feature: see https://github.com/ethereum/solidity/issues/4637
1404         uint256 _value; // default: 0
1405     }
1406 
1407     function current(Counter storage counter) internal view returns (uint256) {
1408         return counter._value;
1409     }
1410 
1411     function increment(Counter storage counter) internal {
1412         unchecked {
1413             counter._value += 1;
1414         }
1415     }
1416 
1417     function decrement(Counter storage counter) internal {
1418         uint256 value = counter._value;
1419         require(value > 0, 'Counter: decrement overflow');
1420         unchecked {
1421             counter._value = value - 1;
1422         }
1423     }
1424 }
1425 
1426 pragma solidity ^0.8.0;
1427 
1428 contract FloatingCities is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
1429     using Counters for Counters.Counter;
1430 
1431     Counters.Counter private _tokenIdCounter;
1432     uint256 public maxSupply = 400;
1433     uint256 public price = 50000000000000000;
1434     bool public saleOpen = false;
1435     bool public presaleOpen = false;
1436     string public baseURI;
1437 
1438     address wallet1 = 0xcBF18174054a53C023dCc69c538BC81AA724F823;
1439     address wallet2 = 0x099EdBA8aB454cc47B940f543D5432C41A69Cf55;
1440     address wallet3 = 0xBE6C3FFEcFE01DeD5DdC97c1Bd4fceef4B9240d8;
1441     address wallet4 = 0xAaAb59789e69F18d3Cd3C3aC0269e3AbAEDC331d;
1442 
1443     mapping(address => uint256) public Whitelist;
1444 
1445     receive() external payable {}
1446 
1447     constructor() ERC721('Floating Cities', 'CITIES') {}
1448 
1449     function reserveMints(address to) public onlyOwner {
1450         for (uint256 i = 0; i < 1; i++) internalMint(to);
1451     }
1452 
1453     function whitelistAddress(address[] memory who, uint256 amount) public onlyOwner {
1454         for (uint256 i = 0; i < who.length; i++) Whitelist[who[i]] = amount;
1455     }
1456 
1457     function withdraw() public onlyOwner {
1458         uint256 balance = address(this).balance;
1459         payable(wallet1).transfer((balance * 250) / 1000);
1460         payable(wallet2).transfer((balance * 250) / 1000);
1461         payable(wallet3).transfer((balance * 250) / 1000);
1462         payable(wallet4).transfer((balance * 250) / 1000);
1463     }
1464 
1465     function pause() public onlyOwner {
1466         _pause();
1467     }
1468 
1469     function unpause() public onlyOwner {
1470         _unpause();
1471     }
1472 
1473     function toggleSale() public onlyOwner {
1474         saleOpen = !saleOpen;
1475     }
1476 
1477     function togglePresale() public onlyOwner {
1478         presaleOpen = !presaleOpen;
1479     }
1480 
1481     function setBaseURI(string memory newBaseURI) public onlyOwner {
1482         baseURI = newBaseURI;
1483     }
1484 
1485     function setPrice(uint256 newPrice) public onlyOwner {
1486         price = newPrice;
1487     }
1488 
1489     function _baseURI() internal view override returns (string memory) {
1490         return baseURI;
1491     }
1492 
1493     function internalMint(address to) internal {
1494         require(totalSupply() < maxSupply, 'supply depleted');
1495         _safeMint(to, _tokenIdCounter.current());
1496         _tokenIdCounter.increment();
1497     }
1498 
1499     function safeMint(address to) public onlyOwner {
1500         internalMint(to);
1501     }
1502 
1503     function mint(uint256 amount) public payable {
1504         require(msg.value >= price * amount, 'not enough was paid');
1505 
1506         if (!saleOpen) {
1507             require(presaleOpen == true, 'presale is not open');
1508             uint256 who = Whitelist[msg.sender];
1509             require(who > 0, 'this address is not whitelisted for the presale');
1510             require(amount <= who, 'this address is not allowed to mint that many during the presale');
1511             for (uint256 i = 0; i < amount; i++) internalMint(msg.sender);
1512             Whitelist[msg.sender] = who - amount;
1513             return;
1514         }
1515 
1516         require(amount <= 3, 'only 3 per transaction allowed');
1517         for (uint256 i = 0; i < amount; i++) internalMint(msg.sender);
1518     }
1519 
1520     function _beforeTokenTransfer(
1521         address from,
1522         address to,
1523         uint256 tokenId
1524     ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
1525         super._beforeTokenTransfer(from, to, tokenId);
1526     }
1527 
1528     // The following functions are overrides required by Solidity.
1529 
1530     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1531         super._burn(tokenId);
1532     }
1533 
1534     function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
1535         return super.tokenURI(tokenId);
1536     }
1537 
1538     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1539         return super.supportsInterface(interfaceId);
1540     }
1541 }