1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-04
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 /**
72  * @dev Provides information about the current execution context, including the
73  * sender of the transaction and its data. While these are generally available
74  * via msg.sender and msg.data, they should not be accessed in such a direct
75  * manner, since when dealing with meta-transactions the account sending and
76  * paying for execution may not be the actual sender (as far as an application
77  * is concerned).
78  *
79  * This contract is only required for intermediate, library-like contracts.
80  */
81 abstract contract Context {
82     function _msgSender() internal view virtual returns (address) {
83         return msg.sender;
84     }
85 
86     function _msgData() internal view virtual returns (bytes calldata) {
87         return msg.data;
88     }
89 }
90 
91 /**
92  * @dev Collection of functions related to the address type
93  */
94 library Address {
95     /**
96      * @dev Returns true if `account` is a contract.
97      *
98      * [IMPORTANT]
99      * ====
100      * It is unsafe to assume that an address for which this function returns
101      * false is an externally-owned account (EOA) and not a contract.
102      *
103      * Among others, `isContract` will return false for the following
104      * types of addresses:
105      *
106      *  - an externally-owned account
107      *  - a contract in construction
108      *  - an address where a contract will be created
109      *  - an address where a contract lived, but was destroyed
110      * ====
111      */
112     function isContract(address account) internal view returns (bool) {
113         // This method relies on extcodesize, which returns 0 for contracts in
114         // construction, since the code is only stored at the end of the
115         // constructor execution.
116 
117         uint256 size;
118         assembly {
119             size := extcodesize(account)
120         }
121         return size > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292 
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 /**
305  * @title ERC721 token receiver interface
306  * @dev Interface for any contract that wants to support safeTransfers
307  * from ERC721 asset contracts.
308  */
309 interface IERC721Receiver {
310     /**
311      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
312      * by `operator` from `from`, this function is called.
313      *
314      * It must return its Solidity selector to confirm the token transfer.
315      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
316      *
317      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
318      */
319     function onERC721Received(
320         address operator,
321         address from,
322         uint256 tokenId,
323         bytes calldata data
324     ) external returns (bytes4);
325 }
326 
327 /**
328  * @dev Interface of the ERC165 standard, as defined in the
329  * https://eips.ethereum.org/EIPS/eip-165[EIP].
330  *
331  * Implementers can declare support of contract interfaces, which can then be
332  * queried by others ({ERC165Checker}).
333  *
334  * For an implementation, see {ERC165}.
335  */
336 interface IERC165 {
337     /**
338      * @dev Returns true if this contract implements the interface defined by
339      * `interfaceId`. See the corresponding
340      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
341      * to learn more about how these ids are created.
342      *
343      * This function call must use less than 30 000 gas.
344      */
345     function supportsInterface(bytes4 interfaceId) external view returns (bool);
346 }
347 
348 /**
349  * @dev Implementation of the {IERC165} interface.
350  *
351  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
352  * for the additional interface id that will be supported. For example:
353  *
354  * ```solidity
355  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
356  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
357  * }
358  * ```
359  *
360  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
361  */
362 abstract contract ERC165 is IERC165 {
363     /**
364      * @dev See {IERC165-supportsInterface}.
365      */
366     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
367         return interfaceId == type(IERC165).interfaceId;
368     }
369 }
370 
371 /**
372  * @dev Required interface of an ERC721 compliant contract.
373  */
374 interface IERC721 is IERC165 {
375     /**
376      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
377      */
378     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
379 
380     /**
381      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
382      */
383     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
384 
385     /**
386      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
387      */
388     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
389 
390     /**
391      * @dev Returns the number of tokens in ``owner``'s account.
392      */
393     function balanceOf(address owner) external view returns (uint256 balance);
394 
395     /**
396      * @dev Returns the owner of the `tokenId` token.
397      *
398      * Requirements:
399      *
400      * - `tokenId` must exist.
401      */
402     function ownerOf(uint256 tokenId) external view returns (address owner);
403 
404     /**
405      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
406      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
407      *
408      * Requirements:
409      *
410      * - `from` cannot be the zero address.
411      * - `to` cannot be the zero address.
412      * - `tokenId` token must exist and be owned by `from`.
413      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
414      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
415      *
416      * Emits a {Transfer} event.
417      */
418     function safeTransferFrom(
419         address from,
420         address to,
421         uint256 tokenId
422     ) external;
423 
424     /**
425      * @dev Transfers `tokenId` token from `from` to `to`.
426      *
427      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must be owned by `from`.
434      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
435      *
436      * Emits a {Transfer} event.
437      */
438     function transferFrom(
439         address from,
440         address to,
441         uint256 tokenId
442     ) external;
443 
444     /**
445      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
446      * The approval is cleared when the token is transferred.
447      *
448      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
449      *
450      * Requirements:
451      *
452      * - The caller must own the token or be an approved operator.
453      * - `tokenId` must exist.
454      *
455      * Emits an {Approval} event.
456      */
457     function approve(address to, uint256 tokenId) external;
458 
459     /**
460      * @dev Returns the account approved for `tokenId` token.
461      *
462      * Requirements:
463      *
464      * - `tokenId` must exist.
465      */
466     function getApproved(uint256 tokenId) external view returns (address operator);
467 
468     /**
469      * @dev Approve or remove `operator` as an operator for the caller.
470      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
471      *
472      * Requirements:
473      *
474      * - The `operator` cannot be the caller.
475      *
476      * Emits an {ApprovalForAll} event.
477      */
478     function setApprovalForAll(address operator, bool _approved) external;
479 
480     /**
481      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
482      *
483      * See {setApprovalForAll}
484      */
485     function isApprovedForAll(address owner, address operator) external view returns (bool);
486 
487     /**
488      * @dev Safely transfers `tokenId` token from `from` to `to`.
489      *
490      * Requirements:
491      *
492      * - `from` cannot be the zero address.
493      * - `to` cannot be the zero address.
494      * - `tokenId` token must exist and be owned by `from`.
495      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
496      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
497      *
498      * Emits a {Transfer} event.
499      */
500     function safeTransferFrom(
501         address from,
502         address to,
503         uint256 tokenId,
504         bytes calldata data
505     ) external;
506 }
507 
508 /**
509  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
510  * @dev See https://eips.ethereum.org/EIPS/eip-721
511  */
512 interface IERC721Metadata is IERC721 {
513     /**
514      * @dev Returns the token collection name.
515      */
516     function name() external view returns (string memory);
517 
518     /**
519      * @dev Returns the token collection symbol.
520      */
521     function symbol() external view returns (string memory);
522 
523     /**
524      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
525      */
526     function tokenURI(uint256 tokenId) external view returns (string memory);
527 }
528 
529 /**
530  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
531  * the Metadata extension, but not including the Enumerable extension, which is available separately as
532  * {ERC721Enumerable}.
533  */
534 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
535     using Address for address;
536     using Strings for uint256;
537 
538     // Token name
539     string private _name;
540 
541     // Token symbol
542     string private _symbol;
543 
544     // Mapping from token ID to owner address
545     mapping(uint256 => address) private _owners;
546 
547     // Mapping owner address to token count
548     mapping(address => uint256) private _balances;
549 
550     // Mapping from token ID to approved address
551     mapping(uint256 => address) private _tokenApprovals;
552 
553     // Mapping from owner to operator approvals
554     mapping(address => mapping(address => bool)) private _operatorApprovals;
555 
556     /**
557      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
558      */
559     constructor(string memory name_, string memory symbol_) {
560         _name = name_;
561         _symbol = symbol_;
562     }
563 
564     /**
565      * @dev See {IERC165-supportsInterface}.
566      */
567     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
568         return
569             interfaceId == type(IERC721).interfaceId ||
570             interfaceId == type(IERC721Metadata).interfaceId ||
571             super.supportsInterface(interfaceId);
572     }
573 
574     /**
575      * @dev See {IERC721-balanceOf}.
576      */
577     function balanceOf(address owner) public view virtual override returns (uint256) {
578         require(owner != address(0), "ERC721: balance query for the zero address");
579         return _balances[owner];
580     }
581 
582     /**
583      * @dev See {IERC721-ownerOf}.
584      */
585     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
586         // address owner = _owners[tokenId];
587         // require(owner != address(0), "ERC721: owner query for nonexistent token");
588         // return owner;
589         return _owners[tokenId];
590     }
591 
592     /**
593      * @dev See {IERC721Metadata-name}.
594      */
595     function name() public view virtual override returns (string memory) {
596         return _name;
597     }
598 
599     /**
600      * @dev See {IERC721Metadata-symbol}.
601      */
602     function symbol() public view virtual override returns (string memory) {
603         return _symbol;
604     }
605 
606     /**
607      * @dev See {IERC721Metadata-tokenURI}.
608      */
609     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
610         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
611 
612         string memory baseURI = _baseURI();
613         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
614     }
615 
616     /**
617      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
618      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
619      * by default, can be overriden in child contracts.
620      */
621     function _baseURI() internal view virtual returns (string memory) {
622         return "";
623     }
624 
625     /**
626      * @dev See {IERC721-approve}.
627      */
628     function approve(address to, uint256 tokenId) public virtual override {
629         address owner = ERC721.ownerOf(tokenId);
630         require(to != owner, "ERC721: approval to current owner");
631 
632         require(
633             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
634             "ERC721: approve caller is not owner nor approved for all"
635         );
636 
637         _approve(to, tokenId);
638     }
639 
640     /**
641      * @dev See {IERC721-getApproved}.
642      */
643     function getApproved(uint256 tokenId) public view virtual override returns (address) {
644         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
645 
646         return _tokenApprovals[tokenId];
647     }
648 
649     /**
650      * @dev See {IERC721-setApprovalForAll}.
651      */
652     function setApprovalForAll(address operator, bool approved) public virtual override {
653         _setApprovalForAll(_msgSender(), operator, approved);
654     }
655 
656     /**
657      * @dev See {IERC721-isApprovedForAll}.
658      */
659     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
660         return _operatorApprovals[owner][operator];
661     }
662 
663     /**
664      * @dev See {IERC721-transferFrom}.
665      */
666     function transferFrom(
667         address from,
668         address to,
669         uint256 tokenId
670     ) public virtual override {
671         //solhint-disable-next-line max-line-length
672         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
673 
674         _transfer(from, to, tokenId);
675     }
676 
677     /**
678      * @dev See {IERC721-safeTransferFrom}.
679      */
680     function safeTransferFrom(
681         address from,
682         address to,
683         uint256 tokenId
684     ) public virtual override {
685         safeTransferFrom(from, to, tokenId, "");
686     }
687 
688     /**
689      * @dev See {IERC721-safeTransferFrom}.
690      */
691     function safeTransferFrom(
692         address from,
693         address to,
694         uint256 tokenId,
695         bytes memory _data
696     ) public virtual override {
697         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
698         _safeTransfer(from, to, tokenId, _data);
699     }
700 
701     /**
702      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
703      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
704      *
705      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
706      *
707      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
708      * implement alternative mechanisms to perform token transfer, such as signature-based.
709      *
710      * Requirements:
711      *
712      * - `from` cannot be the zero address.
713      * - `to` cannot be the zero address.
714      * - `tokenId` token must exist and be owned by `from`.
715      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
716      *
717      * Emits a {Transfer} event.
718      */
719     function _safeTransfer(
720         address from,
721         address to,
722         uint256 tokenId,
723         bytes memory _data
724     ) internal virtual {
725         _transfer(from, to, tokenId);
726         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
727     }
728 
729     /**
730      * @dev Returns whether `tokenId` exists.
731      *
732      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
733      *
734      * Tokens start existing when they are minted (`_mint`),
735      * and stop existing when they are burned (`_burn`).
736      */
737     function _exists(uint256 tokenId) internal view virtual returns (bool) {
738         return _owners[tokenId] != address(0);
739     }
740 
741     /**
742      * @dev Returns whether `spender` is allowed to manage `tokenId`.
743      *
744      * Requirements:
745      *
746      * - `tokenId` must exist.
747      */
748     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
749         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
750         address owner = ERC721.ownerOf(tokenId);
751         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
752     }
753 
754     /**
755      * @dev Safely mints `tokenId` and transfers it to `to`.
756      *
757      * Requirements:
758      *
759      * - `tokenId` must not exist.
760      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
761      *
762      * Emits a {Transfer} event.
763      */
764     function _safeMint(address to, uint256 tokenId) internal virtual {
765         _safeMint(to, tokenId, "");
766     }
767 
768     /**
769      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
770      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
771      */
772     function _safeMint(
773         address to,
774         uint256 tokenId,
775         bytes memory _data
776     ) internal virtual {
777         _mint(to, tokenId);
778         require(
779             _checkOnERC721Received(address(0), to, tokenId, _data),
780             "ERC721: transfer to non ERC721Receiver implementer"
781         );
782     }
783 
784     /**
785      * @dev Mints `tokenId` and transfers it to `to`.
786      *
787      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
788      *
789      * Requirements:
790      *
791      * - `tokenId` must not exist.
792      * - `to` cannot be the zero address.
793      *
794      * Emits a {Transfer} event.
795      */
796     function _mint(address to, uint256 tokenId) internal virtual {
797         require(to != address(0), "ERC721: mint to the zero address");
798         require(!_exists(tokenId), "ERC721: token already minted");
799 
800         _beforeTokenTransfer(address(0), to, tokenId);
801 
802         _balances[to] += 1;
803         _owners[tokenId] = to;
804 
805         emit Transfer(address(0), to, tokenId);
806     }
807 
808     /**
809      * @dev Destroys `tokenId`.
810      * The approval is cleared when the token is burned.
811      *
812      * Requirements:
813      *
814      * - `tokenId` must exist.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _burn(uint256 tokenId) internal virtual {
819         address owner = ERC721.ownerOf(tokenId);
820 
821         _beforeTokenTransfer(owner, address(0), tokenId);
822 
823         // Clear approvals
824         _approve(address(0), tokenId);
825 
826         _balances[owner] -= 1;
827         delete _owners[tokenId];
828 
829         emit Transfer(owner, address(0), tokenId);
830     }
831 
832     /**
833      * @dev Transfers `tokenId` from `from` to `to`.
834      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
835      *
836      * Requirements:
837      *
838      * - `to` cannot be the zero address.
839      * - `tokenId` token must be owned by `from`.
840      *
841      * Emits a {Transfer} event.
842      */
843     function _transfer(
844         address from,
845         address to,
846         uint256 tokenId
847     ) internal virtual {
848         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
849         require(to != address(0), "ERC721: transfer to the zero address");
850 
851         _beforeTokenTransfer(from, to, tokenId);
852 
853         // Clear approvals from the previous owner
854         _approve(address(0), tokenId);
855 
856         _balances[from] -= 1;
857         _balances[to] += 1;
858         _owners[tokenId] = to;
859 
860         emit Transfer(from, to, tokenId);
861     }
862 
863     /**
864      * @dev Approve `to` to operate on `tokenId`
865      *
866      * Emits a {Approval} event.
867      */
868     function _approve(address to, uint256 tokenId) internal virtual {
869         _tokenApprovals[tokenId] = to;
870         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
871     }
872 
873     /**
874      * @dev Approve `operator` to operate on all of `owner` tokens
875      *
876      * Emits a {ApprovalForAll} event.
877      */
878     function _setApprovalForAll(
879         address owner,
880         address operator,
881         bool approved
882     ) internal virtual {
883         require(owner != operator, "ERC721: approve to caller");
884         _operatorApprovals[owner][operator] = approved;
885         emit ApprovalForAll(owner, operator, approved);
886     }
887 
888     /**
889      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
890      * The call is not executed if the target address is not a contract.
891      *
892      * @param from address representing the previous owner of the given token ID
893      * @param to target address that will receive the tokens
894      * @param tokenId uint256 ID of the token to be transferred
895      * @param _data bytes optional data to send along with the call
896      * @return bool whether the call correctly returned the expected magic value
897      */
898     function _checkOnERC721Received(
899         address from,
900         address to,
901         uint256 tokenId,
902         bytes memory _data
903     ) private returns (bool) {
904         if (to.isContract()) {
905             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
906                 return retval == IERC721Receiver.onERC721Received.selector;
907             } catch (bytes memory reason) {
908                 if (reason.length == 0) {
909                     revert("ERC721: transfer to non ERC721Receiver implementer");
910                 } else {
911                     assembly {
912                         revert(add(32, reason), mload(reason))
913                     }
914                 }
915             }
916         } else {
917             return true;
918         }
919     }
920 
921     /**
922      * @dev Hook that is called before any token transfer. This includes minting
923      * and burning.
924      *
925      * Calling conditions:
926      *
927      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
928      * transferred to `to`.
929      * - When `from` is zero, `tokenId` will be minted for `to`.
930      * - When `to` is zero, ``from``'s `tokenId` will be burned.
931      * - `from` and `to` are never both zero.
932      *
933      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
934      */
935     function _beforeTokenTransfer(
936         address from,
937         address to,
938         uint256 tokenId
939     ) internal virtual {}
940 }
941 
942 interface IERC20 {
943     function transferFrom(address from_, address to_, uint256 amount_) external;
944 }
945 // interface IERC721 {
946 //     function transferFrom(address from_, address to_, uint256 tokenId_) external;
947 // }
948 interface IERC1155 {
949     function safeTransferFrom(address from_, address to_, uint256 id_, uint256 amount_, bytes calldata data_) external;
950     function safeBatchTransferFrom(address from_, address to_, uint256[] calldata ids_, uint256[] calldata amounts_, bytes calldata data_) external;
951 }
952 
953 abstract contract ERCWithdrawable {
954     /*  All functions in this abstract contract are marked as internal because it should
955         generally be paired with ownable.
956         Virtual is for overwritability.
957     */
958     function _withdrawERC20(address contractAddress_, uint256 amount_) internal virtual {
959         IERC20(contractAddress_).transferFrom(address(this), msg.sender, amount_);
960     }
961     function _withdrawERC721(address contractAddress_, uint256 tokenId_) internal virtual {
962         IERC721(contractAddress_).transferFrom(address(this), msg.sender, tokenId_);
963     }
964     function _withdrawERC1155(address contractAddress_, uint256 tokenId_, uint256 amount_) internal virtual {
965         IERC1155(contractAddress_).safeTransferFrom(address(this), msg.sender, tokenId_, amount_, "");
966     }
967     function _withdrawERC1155Batch(address contractAddress_, uint256[] calldata ids_, uint256[] calldata amounts_) internal virtual {
968         IERC1155(contractAddress_).safeBatchTransferFrom(address(this), msg.sender, ids_, amounts_, "");
969     }
970 }
971 
972 // Open0x Ownable
973 abstract contract Ownable {
974     address public owner;
975     
976     event OwnershipTransferred(address indexed oldOwner_, address indexed newOwner_);
977 
978     constructor() { owner = msg.sender; }
979 
980     modifier onlyOwner {
981         require(owner == msg.sender, "Ownable: caller is not the owner");
982         _;
983     }
984 
985     function _transferOwnership(address newOwner_) internal virtual {
986         address _oldOwner = owner;
987         owner = newOwner_;
988         emit OwnershipTransferred(_oldOwner, newOwner_);    
989     }
990 
991     function transferOwnership(address newOwner_) public virtual onlyOwner {
992         require(newOwner_ != address(0x0), "Ownable: new owner is the zero address!");
993         _transferOwnership(newOwner_);
994     }
995 
996     function renounceOwnership() public virtual onlyOwner {
997         _transferOwnership(address(0x0));
998     }
999 }
1000 
1001 abstract contract MerkleWhitelist {
1002     bytes32 internal _merkleRoot;
1003     function _setMerkleRoot(bytes32 merkleRoot_) internal virtual {
1004         _merkleRoot = merkleRoot_;
1005     }
1006     function isWhitelisted(address address_, bytes32[] memory proof_) public view returns (bool) {
1007         bytes32 _leaf = keccak256(abi.encodePacked(address_));
1008         for (uint256 i = 0; i < proof_.length; i++) {
1009             _leaf = _leaf < proof_[i] ? keccak256(abi.encodePacked(_leaf, proof_[i])) : keccak256(abi.encodePacked(proof_[i], _leaf));
1010         }
1011         return _leaf == _merkleRoot;
1012     }
1013 }
1014 
1015 interface iRenderer {
1016     function tokenURI(uint256 tokenId_) external view returns (string memory);
1017 }
1018 
1019 interface iYield {
1020     function updateReward(address from_, address to_, uint256 tokenId_) external;
1021 }
1022 
1023 contract RustyHogs is ERC721, MerkleWhitelist, Ownable, ERCWithdrawable {
1024     /*
1025         Features: 
1026         Namable, Descripable (Send to Back-End) [/]
1027         Flexible Interface with ERC20 (Banana, Peel) [/]
1028         Uninstantiated Transfer Hook for Token Yield [/]
1029         Limit to 1 mint per address [/]
1030         Merkle Whitelisting [/]
1031         Public Sale [/]
1032     */
1033 
1034     // Constructor
1035     constructor() ERC721("RustyHogs", "RSH") {}
1036 
1037     // Project Constraints
1038     uint16 immutable public maxTokens = 3000;
1039     
1040     // General NFT Variables
1041     uint256 public mintPrice = 0.08 ether;
1042     uint256 public totalSupply;
1043 
1044     string internal baseTokenURI;
1045     string internal baseTokenURI_EXT;
1046 
1047     // Interfaces
1048     iYield public yieldToken;
1049     mapping(address => bool) public controllers;
1050 
1051     // Whitelist Mappings
1052     mapping(address => uint16) public addressToWhitelistMinted;
1053     mapping(address => uint16) public addressToPublicMinted;
1054 
1055     // Namable
1056     mapping(uint256 => string) public rustyHogsName;
1057     mapping(uint256 => string) public rustyHogsBio;
1058 
1059     // Events
1060     event Mint(address to_, uint256 tokenId_);
1061     event NameChange(uint256 tokenId_, string name_);
1062     event BioChange(uint256 tokenId_, string bio_);
1063 
1064     // Contract Governance
1065     function withdrawEther() external onlyOwner {
1066         payable(msg.sender).transfer(address(this).balance); }
1067     function setMintPrice(uint256 price_) external onlyOwner {
1068         mintPrice = price_; }
1069 
1070     // ERCWithdrawable
1071     function withdrawERC20(address contractAddress_, uint256 amount_) external onlyOwner {
1072         _withdrawERC20(contractAddress_, amount_);
1073     }
1074     function withdrawERC721(address contractAddress_, uint256 tokenId_) external onlyOwner {
1075         _withdrawERC721(contractAddress_, tokenId_);
1076     }
1077     function withdrawERC1155(address contractAddress_, uint256 tokenId_, uint256 amount_) external onlyOwner {
1078         _withdrawERC1155(contractAddress_, tokenId_, amount_);
1079     }
1080 
1081     // MerkleRoot
1082     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
1083         _setMerkleRoot(merkleRoot_); }
1084 
1085     // // Time Setters
1086     // Whitelist Sale
1087     bool public whitelistSaleEnabled;
1088     uint256 public whitelistSaleTime;
1089     function setWhitelistSale(bool bool_, uint256 time_) external onlyOwner {
1090         whitelistSaleEnabled = bool_; whitelistSaleTime = time_; }
1091     modifier whitelistSale {
1092         require(whitelistSaleEnabled && block.timestamp >= whitelistSaleTime, "Whitelist sale not open yet!"); _; }
1093     function whitelistSaleIsEnabled() public view returns (bool) {
1094         return (whitelistSaleEnabled && block.timestamp >= whitelistSaleTime); }
1095 
1096     // Public Sale
1097     bool public publicSaleEnabled;
1098     uint256 public publicSaleTime;
1099     function setPublicSale(bool bool_, uint256 time_) external onlyOwner {
1100         publicSaleEnabled = bool_; publicSaleTime = time_; }
1101     modifier publicSale {
1102         require(publicSaleEnabled && block.timestamp >= publicSaleTime, "Public Sale is not open yet!"); _; }
1103     function publicSaleIsEnabled() public view returns (bool) {
1104         return (publicSaleEnabled && block.timestamp >= publicSaleTime); }
1105 
1106     // Modifiers
1107     modifier onlySender {
1108         require(msg.sender == tx.origin, "No smart contracts!"); _; }
1109     modifier onlyControllers {
1110         require(controllers[msg.sender], "You are not authorized!"); _; }
1111 
1112     // Contract Administration
1113     function setYieldToken(address address_) external onlyOwner {
1114         yieldToken = iYield(address_); }
1115     function setController(address address_, bool bool_) external onlyOwner {
1116         controllers[address_] = bool_; }
1117     function setBaseTokenURI(string memory uri_) external onlyOwner {
1118         baseTokenURI = uri_; }
1119     function setBaseTokenURI_EXT(string memory ext_) external onlyOwner {
1120         baseTokenURI_EXT = ext_; }
1121     
1122     // Controller Functions
1123     function changeName(uint256 tokenId_, string memory name_) public onlyControllers {
1124         rustyHogsName[tokenId_] = name_; }
1125     function changeBio(uint256 tokenId_, string memory bio_) public onlyControllers {
1126         rustyHogsBio[tokenId_] = bio_; }
1127 
1128     // Mint functions
1129     function __getTokenId() internal view returns (uint256) {
1130         return totalSupply + 1;
1131     }
1132     function ownerMint(address to_, uint256 amount_) external onlyOwner {
1133         for (uint256 i = 0; i < amount_; i++) {
1134             _mint(to_, __getTokenId() + i);
1135         }
1136         totalSupply += amount_;
1137     }
1138     function ownerMintToMany(address[] memory tos_, uint256[] memory amounts_) external onlyOwner {
1139         require(tos_.length == amounts_.length, "Length mismatch!");
1140         // Iterate through each request
1141         for (uint256 i = 0; i < tos_.length; i++) {
1142             // Do ownerMint logic
1143             for (uint256 j = 0 ; j < amounts_[i]; j++) {
1144                 _mint(tos_[i], __getTokenId() + j);
1145             }
1146             totalSupply += amounts_[i];
1147         }
1148     }
1149     function whitelistMint(bytes32[] memory proof_, uint256 amount_) external payable onlySender whitelistSale {
1150         require(isWhitelisted(msg.sender, proof_), "You are not whitelisted!");
1151         require(addressToWhitelistMinted[msg.sender]+amount_ < 3, "You have no whitelisted mints remaining!");
1152         require(msg.value == mintPrice*amount_, "Invalid Value Sent!");
1153         require(maxTokens >= totalSupply+amount_, "No enough tokens available!");
1154         for (uint256 i = 0; i < amount_; i++) {
1155             _mint(msg.sender, __getTokenId());
1156             emit Mint(msg.sender, __getTokenId());
1157             addressToWhitelistMinted[msg.sender]++;
1158             totalSupply++;
1159         }
1160     }
1161     function publicMint(uint256 amount_) external payable onlySender publicSale {
1162         require(addressToPublicMinted[msg.sender]+amount_ < 6, "You have no public mints remaining!");
1163         require(msg.value == mintPrice*amount_, "Invalid value sent!");
1164         require(maxTokens >= totalSupply+amount_, "No more tokens available!");
1165         for (uint256 i = 0; i < amount_; i++) {
1166             _mint(msg.sender, __getTokenId());
1167             emit Mint(msg.sender, __getTokenId());
1168             addressToPublicMinted[msg.sender]++;
1169             totalSupply++;
1170         }
1171     }
1172 
1173     // Transfer Hooks 
1174     function transferFrom(address from_, address to_, uint256 tokenId_) public override {
1175         if ( yieldToken != iYield(address(0x0)) ) {
1176             yieldToken.updateReward(from_, to_, tokenId_);
1177         }
1178         ERC721.transferFrom(from_, to_, tokenId_);
1179     }
1180     function safeTransferFrom(address from_, address to_, uint256 tokenId_, bytes memory data_) public override {
1181         if ( yieldToken != iYield(address(0x0)) ) {
1182             yieldToken.updateReward(from_, to_, tokenId_);
1183         }
1184         ERC721.safeTransferFrom(from_, to_, tokenId_, data_);
1185     }
1186 
1187     address public renderer;
1188     bool public useRenderer;
1189     function setRenderer(address address_) external onlyOwner { renderer = address_; }
1190     function setUseRenderer(bool bool_) external onlyOwner { useRenderer = bool_; }
1191 
1192     // View Function for Tokens
1193     function tokenURI(uint256 tokenId_) public view override returns (string memory) {
1194         require(_exists(tokenId_), "Token doesn't exist!");
1195         if (!useRenderer) {
1196             return string(abi.encodePacked(baseTokenURI, Strings.toString(tokenId_), baseTokenURI_EXT));
1197         } else {
1198             return iRenderer(renderer).tokenURI(tokenId_);
1199         }
1200     }
1201 
1202     //Custom Functions for ERC721
1203     function multiTransferFrom(address from_, address to_, uint256[] memory tokenIds_) public {
1204         for (uint256 i = 0; i < tokenIds_.length; i++) {
1205             ERC721.transferFrom(from_, to_, tokenIds_[i]);
1206         }
1207     }
1208     function multiSafeTransferFrom(address from_, address to_, uint256[] memory tokenIds_, bytes[] memory datas_) public {
1209         for (uint256 i = 0; i < tokenIds_.length; i++) {
1210             ERC721.safeTransferFrom(from_, to_, tokenIds_[i], datas_[i]);
1211         }
1212     }
1213     function walletOfOwner(address address_) public view returns (uint256[] memory) {
1214         uint256 _balance = balanceOf(address_);
1215         uint256[] memory _tokens = new uint256[](_balance);
1216         uint256 _index;
1217         for (uint256 i = 0; i < maxTokens; i++) {
1218             if (address_ == ownerOf(i)) { _tokens[_index] = i; _index++; }
1219         }
1220         return _tokens;
1221     }
1222 }