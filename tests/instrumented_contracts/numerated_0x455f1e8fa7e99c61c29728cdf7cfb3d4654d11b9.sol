1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 /**
25  * @dev Implementation of the {IERC165} interface.
26  *
27  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
28  * for the additional interface id that will be supported. For example:
29  *
30  * ```solidity
31  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
32  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
33  * }
34  * ```
35  *
36  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
37  */
38 abstract contract ERC165 is IERC165 {
39     /**
40      * @dev See {IERC165-supportsInterface}.
41      */
42     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
43         return interfaceId == type(IERC165).interfaceId;
44     }
45 }
46 
47 /**
48  * @dev String operations.
49  */
50 library Strings {
51     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
55      */
56     function toString(uint256 value) internal pure returns (string memory) {
57         // Inspired by OraclizeAPI's implementation - MIT licence
58         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
59 
60         if (value == 0) {
61             return "0";
62         }
63         uint256 temp = value;
64         uint256 digits;
65         while (temp != 0) {
66             digits++;
67             temp /= 10;
68         }
69         bytes memory buffer = new bytes(digits);
70         while (value != 0) {
71             digits -= 1;
72             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
73             value /= 10;
74         }
75         return string(buffer);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
80      */
81     function toHexString(uint256 value) internal pure returns (string memory) {
82         if (value == 0) {
83             return "0x00";
84         }
85         uint256 temp = value;
86         uint256 length = 0;
87         while (temp != 0) {
88             length++;
89             temp >>= 8;
90         }
91         return toHexString(value, length);
92     }
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
96      */
97     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
98         bytes memory buffer = new bytes(2 * length + 2);
99         buffer[0] = "0";
100         buffer[1] = "x";
101         for (uint256 i = 2 * length + 1; i > 1; --i) {
102             buffer[i] = _HEX_SYMBOLS[value & 0xf];
103             value >>= 4;
104         }
105         require(value == 0, "Strings: hex length insufficient");
106         return string(buffer);
107     }
108 }
109 
110 /**
111  * @dev Provides information about the current execution context, including the
112  * sender of the transaction and its data. While these are generally available
113  * via msg.sender and msg.data, they should not be accessed in such a direct
114  * manner, since when dealing with meta-transactions the account sending and
115  * paying for execution may not be the actual sender (as far as an application
116  * is concerned).
117  *
118  * This contract is only required for intermediate, library-like contracts.
119  */
120 abstract contract Context {
121     function _msgSender() internal view virtual returns (address) {
122         return msg.sender;
123     }
124 
125     function _msgData() internal view virtual returns (bytes calldata) {
126         return msg.data;
127     }
128 }
129 
130 /**
131  * @dev Collection of functions related to the address type
132  */
133 library Address {
134     /**
135      * @dev Returns true if `account` is a contract.
136      *
137      * [IMPORTANT]
138      * ====
139      * It is unsafe to assume that an address for which this function returns
140      * false is an externally-owned account (EOA) and not a contract.
141      *
142      * Among others, `isContract` will return false for the following
143      * types of addresses:
144      *
145      *  - an externally-owned account
146      *  - a contract in construction
147      *  - an address where a contract will be created
148      *  - an address where a contract lived, but was destroyed
149      * ====
150      */
151     function isContract(address account) internal view returns (bool) {
152         // This method relies on extcodesize, which returns 0 for contracts in
153         // construction, since the code is only stored at the end of the
154         // constructor execution.
155 
156         uint256 size;
157         assembly {
158             size := extcodesize(account)
159         }
160         return size > 0;
161     }
162 
163     /**
164      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
165      * `recipient`, forwarding all available gas and reverting on errors.
166      *
167      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
168      * of certain opcodes, possibly making contracts go over the 2300 gas limit
169      * imposed by `transfer`, making them unable to receive funds via
170      * `transfer`. {sendValue} removes this limitation.
171      *
172      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
173      *
174      * IMPORTANT: because control is transferred to `recipient`, care must be
175      * taken to not create reentrancy vulnerabilities. Consider using
176      * {ReentrancyGuard} or the
177      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
178      */
179     function sendValue(address payable recipient, uint256 amount) internal {
180         require(address(this).balance >= amount, "Address: insufficient balance");
181 
182         (bool success, ) = recipient.call{value: amount}("");
183         require(success, "Address: unable to send value, recipient may have reverted");
184     }
185 
186     /**
187      * @dev Performs a Solidity function call using a low level `call`. A
188      * plain `call` is an unsafe replacement for a function call: use this
189      * function instead.
190      *
191      * If `target` reverts with a revert reason, it is bubbled up by this
192      * function (like regular Solidity function calls).
193      *
194      * Returns the raw returned data. To convert to the expected return value,
195      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
196      *
197      * Requirements:
198      *
199      * - `target` must be a contract.
200      * - calling `target` with `data` must not revert.
201      *
202      * _Available since v3.1._
203      */
204     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
205         return functionCall(target, data, "Address: low-level call failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
210      * `errorMessage` as a fallback revert reason when `target` reverts.
211      *
212      * _Available since v3.1._
213      */
214     function functionCall(
215         address target,
216         bytes memory data,
217         string memory errorMessage
218     ) internal returns (bytes memory) {
219         return functionCallWithValue(target, data, 0, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but also transferring `value` wei to `target`.
225      *
226      * Requirements:
227      *
228      * - the calling contract must have an ETH balance of at least `value`.
229      * - the called Solidity function must be `payable`.
230      *
231      * _Available since v3.1._
232      */
233     function functionCallWithValue(
234         address target,
235         bytes memory data,
236         uint256 value
237     ) internal returns (bytes memory) {
238         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
243      * with `errorMessage` as a fallback revert reason when `target` reverts.
244      *
245      * _Available since v3.1._
246      */
247     function functionCallWithValue(
248         address target,
249         bytes memory data,
250         uint256 value,
251         string memory errorMessage
252     ) internal returns (bytes memory) {
253         require(address(this).balance >= value, "Address: insufficient balance for call");
254         require(isContract(target), "Address: call to non-contract");
255 
256         (bool success, bytes memory returndata) = target.call{value: value}(data);
257         return verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
262      * but performing a static call.
263      *
264      * _Available since v3.3._
265      */
266     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
267         return functionStaticCall(target, data, "Address: low-level static call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
272      * but performing a static call.
273      *
274      * _Available since v3.3._
275      */
276     function functionStaticCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal view returns (bytes memory) {
281         require(isContract(target), "Address: static call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.staticcall(data);
284         return verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but performing a delegate call.
290      *
291      * _Available since v3.4._
292      */
293     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
294         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
299      * but performing a delegate call.
300      *
301      * _Available since v3.4._
302      */
303     function functionDelegateCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal returns (bytes memory) {
308         require(isContract(target), "Address: delegate call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.delegatecall(data);
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
316      * revert reason using the provided one.
317      *
318      * _Available since v4.3._
319      */
320     function verifyCallResult(
321         bool success,
322         bytes memory returndata,
323         string memory errorMessage
324     ) internal pure returns (bytes memory) {
325         if (success) {
326             return returndata;
327         } else {
328             // Look for revert reason and bubble it up if present
329             if (returndata.length > 0) {
330                 // The easiest way to bubble the revert reason is using memory via assembly
331 
332                 assembly {
333                     let returndata_size := mload(returndata)
334                     revert(add(32, returndata), returndata_size)
335                 }
336             } else {
337                 revert(errorMessage);
338             }
339         }
340     }
341 }
342 
343 /**
344  * @dev Required interface of an ERC721 compliant contract.
345  */
346 interface IERC721 is IERC165 {
347     /**
348      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
349      */
350     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
351 
352     /**
353      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
354      */
355     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
356 
357     /**
358      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
359      */
360     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
361 
362     /**
363      * @dev Returns the number of tokens in ``owner``'s account.
364      */
365     function balanceOf(address owner) external view returns (uint256 balance);
366 
367     /**
368      * @dev Returns the owner of the `tokenId` token.
369      *
370      * Requirements:
371      *
372      * - `tokenId` must exist.
373      */
374     function ownerOf(uint256 tokenId) external view returns (address owner);
375 
376     /**
377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `tokenId` token must exist and be owned by `from`.
385      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387      *
388      * Emits a {Transfer} event.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Transfers `tokenId` token from `from` to `to`.
398      *
399      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416     /**
417      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - `tokenId` must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Returns the account approved for `tokenId` token.
433      *
434      * Requirements:
435      *
436      * - `tokenId` must exist.
437      */
438     function getApproved(uint256 tokenId) external view returns (address operator);
439 
440     /**
441      * @dev Approve or remove `operator` as an operator for the caller.
442      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
443      *
444      * Requirements:
445      *
446      * - The `operator` cannot be the caller.
447      *
448      * Emits an {ApprovalForAll} event.
449      */
450     function setApprovalForAll(address operator, bool _approved) external;
451 
452     /**
453      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 
459     /**
460      * @dev Safely transfers `tokenId` token from `from` to `to`.
461      *
462      * Requirements:
463      *
464      * - `from` cannot be the zero address.
465      * - `to` cannot be the zero address.
466      * - `tokenId` token must exist and be owned by `from`.
467      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
468      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
469      *
470      * Emits a {Transfer} event.
471      */
472     function safeTransferFrom(
473         address from,
474         address to,
475         uint256 tokenId,
476         bytes calldata data
477     ) external;
478 }
479 
480 /**
481  * @title ERC721 token receiver interface
482  * @dev Interface for any contract that wants to support safeTransfers
483  * from ERC721 asset contracts.
484  */
485 interface IERC721Receiver {
486     /**
487      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
488      * by `operator` from `from`, this function is called.
489      *
490      * It must return its Solidity selector to confirm the token transfer.
491      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
492      *
493      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
494      */
495     function onERC721Received(
496         address operator,
497         address from,
498         uint256 tokenId,
499         bytes calldata data
500     ) external returns (bytes4);
501 }
502 
503 /**
504  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
505  * @dev See https://eips.ethereum.org/EIPS/eip-721
506  */
507 interface IERC721Metadata is IERC721 {
508     /**
509      * @dev Returns the token collection name.
510      */
511     function name() external view returns (string memory);
512 
513     /**
514      * @dev Returns the token collection symbol.
515      */
516     function symbol() external view returns (string memory);
517 
518     /**
519      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
520      */
521     function tokenURI(uint256 tokenId) external view returns (string memory);
522 }
523 
524 /**
525  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
526  * the Metadata extension, but not including the Enumerable extension, which is available separately as
527  * {ERC721Enumerable}.
528  */
529 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
530     using Address for address;
531     using Strings for uint256;
532 
533     // Token name
534     string private _name;
535 
536     // Token symbol
537     string private _symbol;
538 
539     // Mapping from token ID to owner address
540     mapping(uint256 => address) private _owners;
541 
542     // Mapping owner address to token count
543     mapping(address => uint256) private _balances;
544 
545     // Mapping from token ID to approved address
546     mapping(uint256 => address) private _tokenApprovals;
547 
548     // Mapping from owner to operator approvals
549     mapping(address => mapping(address => bool)) private _operatorApprovals;
550 
551     /**
552      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
553      */
554     constructor(string memory name_, string memory symbol_) {
555         _name = name_;
556         _symbol = symbol_;
557     }
558 
559     /**
560      * @dev See {IERC165-supportsInterface}.
561      */
562     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
563         return
564             interfaceId == type(IERC721).interfaceId ||
565             interfaceId == type(IERC721Metadata).interfaceId ||
566             super.supportsInterface(interfaceId);
567     }
568 
569     /**
570      * @dev See {IERC721-balanceOf}.
571      */
572     function balanceOf(address owner) public view virtual override returns (uint256) {
573         require(owner != address(0), "ERC721: balance query for the zero address");
574         return _balances[owner];
575     }
576 
577     /**
578      * @dev See {IERC721-ownerOf}.
579      */
580     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
581         address owner = _owners[tokenId];
582         require(owner != address(0), "ERC721: owner query for nonexistent token");
583         return owner;
584     }
585 
586     /**
587      * @dev See {IERC721Metadata-name}.
588      */
589     function name() public view virtual override returns (string memory) {
590         return _name;
591     }
592 
593     /**
594      * @dev See {IERC721Metadata-symbol}.
595      */
596     function symbol() public view virtual override returns (string memory) {
597         return _symbol;
598     }
599 
600     /**
601      * @dev See {IERC721Metadata-tokenURI}.
602      */
603     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
604         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
605 
606         string memory baseURI = _baseURI();
607         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
608     }
609 
610     /**
611      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
612      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
613      * by default, can be overriden in child contracts.
614      */
615     function _baseURI() internal view virtual returns (string memory) {
616         return "";
617     }
618 
619     /**
620      * @dev See {IERC721-approve}.
621      */
622     function approve(address to, uint256 tokenId) public virtual override {
623         address owner = ERC721.ownerOf(tokenId);
624         require(to != owner, "ERC721: approval to current owner");
625 
626         require(
627             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
628             "ERC721: approve caller is not owner nor approved for all"
629         );
630 
631         _approve(to, tokenId);
632     }
633 
634     /**
635      * @dev See {IERC721-getApproved}.
636      */
637     function getApproved(uint256 tokenId) public view virtual override returns (address) {
638         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
639 
640         return _tokenApprovals[tokenId];
641     }
642 
643     /**
644      * @dev See {IERC721-setApprovalForAll}.
645      */
646     function setApprovalForAll(address operator, bool approved) public virtual override {
647         require(operator != _msgSender(), "ERC721: approve to caller");
648 
649         _operatorApprovals[_msgSender()][operator] = approved;
650         emit ApprovalForAll(_msgSender(), operator, approved);
651     }
652 
653     /**
654      * @dev See {IERC721-isApprovedForAll}.
655      */
656     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
657         return _operatorApprovals[owner][operator];
658     }
659 
660     /**
661      * @dev See {IERC721-transferFrom}.
662      */
663     function transferFrom(
664         address from,
665         address to,
666         uint256 tokenId
667     ) public virtual override {
668         //solhint-disable-next-line max-line-length
669         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
670 
671         _transfer(from, to, tokenId);
672     }
673 
674     /**
675      * @dev See {IERC721-safeTransferFrom}.
676      */
677     function safeTransferFrom(
678         address from,
679         address to,
680         uint256 tokenId
681     ) public virtual override {
682         safeTransferFrom(from, to, tokenId, "");
683     }
684 
685     /**
686      * @dev See {IERC721-safeTransferFrom}.
687      */
688     function safeTransferFrom(
689         address from,
690         address to,
691         uint256 tokenId,
692         bytes memory _data
693     ) public virtual override {
694         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
695         _safeTransfer(from, to, tokenId, _data);
696     }
697 
698     /**
699      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
700      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
701      *
702      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
703      *
704      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
705      * implement alternative mechanisms to perform token transfer, such as signature-based.
706      *
707      * Requirements:
708      *
709      * - `from` cannot be the zero address.
710      * - `to` cannot be the zero address.
711      * - `tokenId` token must exist and be owned by `from`.
712      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
713      *
714      * Emits a {Transfer} event.
715      */
716     function _safeTransfer(
717         address from,
718         address to,
719         uint256 tokenId,
720         bytes memory _data
721     ) internal virtual {
722         _transfer(from, to, tokenId);
723         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
724     }
725 
726     /**
727      * @dev Returns whether `tokenId` exists.
728      *
729      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
730      *
731      * Tokens start existing when they are minted (`_mint`),
732      * and stop existing when they are burned (`_burn`).
733      */
734     function _exists(uint256 tokenId) internal view virtual returns (bool) {
735         return _owners[tokenId] != address(0);
736     }
737 
738     /**
739      * @dev Returns whether `spender` is allowed to manage `tokenId`.
740      *
741      * Requirements:
742      *
743      * - `tokenId` must exist.
744      */
745     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
746         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
747         address owner = ERC721.ownerOf(tokenId);
748         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
749     }
750 
751     /**
752      * @dev Safely mints `tokenId` and transfers it to `to`.
753      *
754      * Requirements:
755      *
756      * - `tokenId` must not exist.
757      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
758      *
759      * Emits a {Transfer} event.
760      */
761     function _safeMint(address to, uint256 tokenId) internal virtual {
762         _safeMint(to, tokenId, "");
763     }
764 
765     /**
766      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
767      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
768      */
769     function _safeMint(
770         address to,
771         uint256 tokenId,
772         bytes memory _data
773     ) internal virtual {
774         _mint(to, tokenId);
775         require(
776             _checkOnERC721Received(address(0), to, tokenId, _data),
777             "ERC721: transfer to non ERC721Receiver implementer"
778         );
779     }
780 
781     /**
782      * @dev Mints `tokenId` and transfers it to `to`.
783      *
784      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
785      *
786      * Requirements:
787      *
788      * - `tokenId` must not exist.
789      * - `to` cannot be the zero address.
790      *
791      * Emits a {Transfer} event.
792      */
793     function _mint(address to, uint256 tokenId) internal virtual {
794         require(to != address(0), "ERC721: mint to the zero address");
795         require(!_exists(tokenId), "ERC721: token already minted");
796 
797         _beforeTokenTransfer(address(0), to, tokenId);
798 
799         _balances[to] += 1;
800         _owners[tokenId] = to;
801 
802         emit Transfer(address(0), to, tokenId);
803     }
804 
805     /**
806      * @dev Destroys `tokenId`.
807      * The approval is cleared when the token is burned.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must exist.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _burn(uint256 tokenId) internal virtual {
816         address owner = ERC721.ownerOf(tokenId);
817 
818         _beforeTokenTransfer(owner, address(0), tokenId);
819 
820         // Clear approvals
821         _approve(address(0), tokenId);
822 
823         _balances[owner] -= 1;
824         delete _owners[tokenId];
825 
826         emit Transfer(owner, address(0), tokenId);
827     }
828 
829     /**
830      * @dev Transfers `tokenId` from `from` to `to`.
831      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
832      *
833      * Requirements:
834      *
835      * - `to` cannot be the zero address.
836      * - `tokenId` token must be owned by `from`.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _transfer(
841         address from,
842         address to,
843         uint256 tokenId
844     ) internal virtual {
845         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
846         require(to != address(0), "ERC721: transfer to the zero address");
847 
848         _beforeTokenTransfer(from, to, tokenId);
849 
850         // Clear approvals from the previous owner
851         _approve(address(0), tokenId);
852 
853         _balances[from] -= 1;
854         _balances[to] += 1;
855         _owners[tokenId] = to;
856 
857         emit Transfer(from, to, tokenId);
858     }
859 
860     /**
861      * @dev Approve `to` to operate on `tokenId`
862      *
863      * Emits a {Approval} event.
864      */
865     function _approve(address to, uint256 tokenId) internal virtual {
866         _tokenApprovals[tokenId] = to;
867         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
868     }
869 
870     /**
871      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
872      * The call is not executed if the target address is not a contract.
873      *
874      * @param from address representing the previous owner of the given token ID
875      * @param to target address that will receive the tokens
876      * @param tokenId uint256 ID of the token to be transferred
877      * @param _data bytes optional data to send along with the call
878      * @return bool whether the call correctly returned the expected magic value
879      */
880     function _checkOnERC721Received(
881         address from,
882         address to,
883         uint256 tokenId,
884         bytes memory _data
885     ) private returns (bool) {
886         if (to.isContract()) {
887             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
888                 return retval == IERC721Receiver.onERC721Received.selector;
889             } catch (bytes memory reason) {
890                 if (reason.length == 0) {
891                     revert("ERC721: transfer to non ERC721Receiver implementer");
892                 } else {
893                     assembly {
894                         revert(add(32, reason), mload(reason))
895                     }
896                 }
897             }
898         } else {
899             return true;
900         }
901     }
902 
903     /**
904      * @dev Hook that is called before any token transfer. This includes minting
905      * and burning.
906      *
907      * Calling conditions:
908      *
909      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
910      * transferred to `to`.
911      * - When `from` is zero, `tokenId` will be minted for `to`.
912      * - When `to` is zero, ``from``'s `tokenId` will be burned.
913      * - `from` and `to` are never both zero.
914      *
915      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
916      */
917     function _beforeTokenTransfer(
918         address from,
919         address to,
920         uint256 tokenId
921     ) internal virtual {}
922 }
923 
924 contract CurseNFTTicket is ERC721 {
925     uint public totalSupply = 1000;
926     uint public maxTypeACnt = 50;
927     uint public maxTypeBCnt = 250;
928     uint public maxTypeCCnt = 700;
929     uint public maxMintCntPerAddress = 10;
930     
931     string public metadataA = "https://ipfs.io/ipfs/QmPpCEYRSo3oNVVfvTSQnzw943Kw2UQLyaHR7qvbnz4TJS?filename=rare.json";
932     string public metadataB = "https://ipfs.io/ipfs/QmPpgquCKBCipDbXD4CQNLusJ6ccTK9qYQ6vQnM3Re8W3t?filename=uncommon.json";
933     string public metadataC = "https://ipfs.io/ipfs/QmaSwEBXdaWXktEZUsNU8n7c7Pqw8a8ypePRZWU1bLTkFf?filename=standard.json";
934     
935     uint public totalMint = 0;
936     
937     mapping (uint => address) public burntWallets;
938     mapping (uint => uint) public tokenType;
939     mapping (uint => uint) public tokenCntByType;
940     
941     mapping (address => uint) public mintCnt;
942     
943     uint private nonce = 0;
944     
945     address private _deployer;
946     
947     uint private mintPrice = 4 * 10 ** 16;
948     
949     address public serviceAddress;
950     
951     constructor() ERC721("CurseTicket", "CURSETICKET") {
952         _deployer = msg.sender;
953         serviceAddress = address(0x634ad02a621888CDd2d1D1B4bF1E6b6Eb46efAF7);
954     }
955     
956     function ownerOf(uint tokenId) public view override returns (address) {
957         return super.ownerOf(tokenId);
958     }
959     
960     function tokenURI(uint tokenId) public view override returns (string memory) {
961         if (tokenType[tokenId] == 1) {
962             return metadataA;
963         } else if (tokenType[tokenId] == 2) {
964             return metadataB;
965         } else if (tokenType[tokenId] == 3) {
966             return metadataC;
967         } else {
968             require(false, "Unknown ticket type.");
969         }
970     }
971     
972     function mint() public payable  {
973         require(totalMint < totalSupply, "There's no token to mint.");
974         require(mintCnt[msg.sender] < maxMintCntPerAddress, "One address can mint 10 tickets.");
975         require(mintPrice == msg.value, "Mint price is not correct.");
976         
977         uint typeACnt = 0;
978         uint typeBCnt = 0;
979         uint typeCCnt = 0;
980         if (tokenCntByType[1] < maxTypeACnt) {
981             typeACnt = maxTypeACnt;
982         }
983         if (tokenCntByType[2] < maxTypeBCnt) {
984             typeBCnt = maxTypeBCnt;
985         }
986         if (tokenCntByType[3] < maxTypeCCnt) {
987             typeCCnt = maxTypeCCnt;
988         }
989         
990         uint randomNumber = random(typeACnt + typeBCnt + typeCCnt);
991         uint token_type = 3;
992         
993         if (randomNumber < typeACnt) {     // type A
994             token_type = 1;
995         } else if (randomNumber < typeACnt + typeBCnt) { // type B
996             token_type = 2;
997         } else { // type C
998             token_type = 3;
999         }
1000         
1001         totalMint++;
1002         tokenCntByType[token_type]++;
1003         tokenType[totalMint] = token_type;
1004         
1005         _safeMint(msg.sender, totalMint);
1006         mintCnt[msg.sender]++;
1007         
1008         address payable _to = payable(serviceAddress);
1009         _to.transfer(mintPrice);
1010     }
1011     
1012     function random(uint maxValue) internal returns (uint) {
1013         uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % maxValue;
1014         randomnumber = randomnumber + 1;
1015         nonce++;
1016         return randomnumber;
1017     }
1018     
1019     function burn(uint256 tokenId) public {
1020         require(ownerOf(tokenId) == msg.sender, "Not owner.");
1021         
1022         _burn(tokenId);
1023         
1024         burntWallets[tokenId] = msg.sender;
1025     }
1026     
1027     function transferOwnership(address _to) public {
1028         require(_deployer == msg.sender, "Only owner can call this function.");
1029         
1030         _deployer = _to;
1031     }
1032     
1033     function withdraw(address payable _to, uint amount) public payable {
1034         require(_deployer == msg.sender, "Only owner can call this function.");
1035         
1036         _to.transfer(amount);
1037     }
1038     
1039     function premint(address _to) public {
1040         require(_deployer == msg.sender, "Only owner can call this function.");
1041         require(totalMint == 0, "Already minted.");
1042         
1043         for (uint i = 1; i <= 5; i++) {
1044             totalMint++;
1045             tokenCntByType[1]++;
1046             tokenType[totalMint] = 1;
1047             
1048             _safeMint(_to, totalMint);
1049             mintCnt[_to]++;
1050         }
1051         
1052         for (uint i = 6; i <= 30; i++) {
1053             totalMint++;
1054             tokenCntByType[2]++;
1055             tokenType[totalMint] = 2;
1056             
1057             _safeMint(_to, totalMint);
1058             mintCnt[_to]++;
1059         }
1060         
1061         for (uint i = 31; i <= 100; i++) {
1062             totalMint++;
1063             tokenCntByType[3]++;
1064             tokenType[totalMint] = 3;
1065             
1066             _safeMint(_to, totalMint);
1067             mintCnt[_to]++;
1068         }
1069     }
1070     
1071     function setMintPrice(uint price) public {
1072         require(_deployer == msg.sender, "Only owner can call this function.");
1073         
1074         mintPrice = price;
1075     }
1076     
1077     function getMyTokens() public view returns (uint[] memory) {
1078         uint[] memory ret = new uint[](mintCnt[msg.sender]);
1079         uint index = 0;
1080         for (uint i = 1; i <= totalMint; i++) {
1081             if (ownerOf(i) == msg.sender) {
1082                 ret[index++] = i;
1083             }
1084         }
1085         return ret;
1086     }
1087     
1088     function setServiceAddress(address _serviceAddress) public {
1089         require(_deployer == msg.sender, "Only owner can call this function.");
1090         
1091         serviceAddress = _serviceAddress;
1092     }
1093 }