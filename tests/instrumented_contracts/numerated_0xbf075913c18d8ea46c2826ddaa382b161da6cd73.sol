1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 /**
26  * @dev Required interface of an ERC721 compliant contract.
27  */
28 interface IERC721 is IERC165 {
29     /**
30      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
31      */
32     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
33 
34     /**
35      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
36      */
37     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
41      */
42     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
43 
44     /**
45      * @dev Returns the number of tokens in ``owner``'s account.
46      */
47     function balanceOf(address owner) external view returns (uint256 balance);
48 
49     /**
50      * @dev Returns the owner of the `tokenId` token.
51      *
52      * Requirements:
53      *
54      * - `tokenId` must exist.
55      */
56     function ownerOf(uint256 tokenId) external view returns (address owner);
57 
58     /**
59      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
60      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
61      *
62      * Requirements:
63      *
64      * - `from` cannot be the zero address.
65      * - `to` cannot be the zero address.
66      * - `tokenId` token must exist and be owned by `from`.
67      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
68      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
69      *
70      * Emits a {Transfer} event.
71      */
72     function safeTransferFrom(
73         address from,
74         address to,
75         uint256 tokenId
76     ) external;
77 
78     /**
79      * @dev Transfers `tokenId` token from `from` to `to`.
80      *
81      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must be owned by `from`.
88      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
100      * The approval is cleared when the token is transferred.
101      *
102      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
103      *
104      * Requirements:
105      *
106      * - The caller must own the token or be an approved operator.
107      * - `tokenId` must exist.
108      *
109      * Emits an {Approval} event.
110      */
111     function approve(address to, uint256 tokenId) external;
112 
113     /**
114      * @dev Returns the account approved for `tokenId` token.
115      *
116      * Requirements:
117      *
118      * - `tokenId` must exist.
119      */
120     function getApproved(uint256 tokenId) external view returns (address operator);
121 
122     /**
123      * @dev Approve or remove `operator` as an operator for the caller.
124      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
125      *
126      * Requirements:
127      *
128      * - The `operator` cannot be the caller.
129      *
130      * Emits an {ApprovalForAll} event.
131      */
132     function setApprovalForAll(address operator, bool _approved) external;
133 
134     /**
135      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
136      *
137      * See {setApprovalForAll}
138      */
139     function isApprovedForAll(address owner, address operator) external view returns (bool);
140 
141     /**
142      * @dev Safely transfers `tokenId` token from `from` to `to`.
143      *
144      * Requirements:
145      *
146      * - `from` cannot be the zero address.
147      * - `to` cannot be the zero address.
148      * - `tokenId` token must exist and be owned by `from`.
149      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151      *
152      * Emits a {Transfer} event.
153      */
154     function safeTransferFrom(
155         address from,
156         address to,
157         uint256 tokenId,
158         bytes calldata data
159     ) external;
160 }
161 
162 /**
163  * @dev Implementation of the {IERC165} interface.
164  *
165  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
166  * for the additional interface id that will be supported. For example:
167  *
168  * ```solidity
169  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
170  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
171  * }
172  * ```
173  *
174  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
175  */
176 abstract contract ERC165 is IERC165 {
177     /**
178      * @dev See {IERC165-supportsInterface}.
179      */
180     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
181         return interfaceId == type(IERC165).interfaceId;
182     }
183 }
184 
185 /**
186  * @dev String operations.
187  */
188 library Strings {
189     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
190 
191     /**
192      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
193      */
194     function toString(uint256 value) internal pure returns (string memory) {
195         // Inspired by OraclizeAPI's implementation - MIT licence
196         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
197 
198         if (value == 0) {
199             return "0";
200         }
201         uint256 temp = value;
202         uint256 digits;
203         while (temp != 0) {
204             digits++;
205             temp /= 10;
206         }
207         bytes memory buffer = new bytes(digits);
208         while (value != 0) {
209             digits -= 1;
210             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
211             value /= 10;
212         }
213         return string(buffer);
214     }
215 
216     /**
217      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
218      */
219     function toHexString(uint256 value) internal pure returns (string memory) {
220         if (value == 0) {
221             return "0x00";
222         }
223         uint256 temp = value;
224         uint256 length = 0;
225         while (temp != 0) {
226             length++;
227             temp >>= 8;
228         }
229         return toHexString(value, length);
230     }
231 
232     /**
233      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
234      */
235     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
236         bytes memory buffer = new bytes(2 * length + 2);
237         buffer[0] = "0";
238         buffer[1] = "x";
239         for (uint256 i = 2 * length + 1; i > 1; --i) {
240             buffer[i] = _HEX_SYMBOLS[value & 0xf];
241             value >>= 4;
242         }
243         require(value == 0, "Strings: hex length insufficient");
244         return string(buffer);
245     }
246 }
247 
248 /**
249  * @dev Provides information about the current execution context, including the
250  * sender of the transaction and its data. While these are generally available
251  * via msg.sender and msg.data, they should not be accessed in such a direct
252  * manner, since when dealing with meta-transactions the account sending and
253  * paying for execution may not be the actual sender (as far as an application
254  * is concerned).
255  *
256  * This contract is only required for intermediate, library-like contracts.
257  */
258 abstract contract Context {
259     function _msgSender() internal view virtual returns (address) {
260         return msg.sender;
261     }
262 
263     function _msgData() internal view virtual returns (bytes calldata) {
264         return msg.data;
265     }
266 }
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [////IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // This method relies on extcodesize, which returns 0 for contracts in
291         // construction, since the code is only stored at the end of the
292         // constructor execution.
293 
294         uint256 size;
295         assembly {
296             size := extcodesize(account)
297         }
298         return size > 0;
299     }
300 
301     /**
302      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303      * `recipient`, forwarding all available gas and reverting on errors.
304      *
305      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306      * of certain opcodes, possibly making contracts go over the 2300 gas limit
307      * imposed by `transfer`, making them unable to receive funds via
308      * `transfer`. {sendValue} removes this limitation.
309      *
310      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311      *
312      * ////IMPORTANT: because control is transferred to `recipient`, care must be
313      * taken to not create reentrancy vulnerabilities. Consider using
314      * {ReentrancyGuard} or the
315      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316      */
317     function sendValue(address payable recipient, uint256 amount) internal {
318         require(address(this).balance >= amount, "Address: insufficient balance");
319 
320         (bool success, ) = recipient.call{value: amount}("");
321         require(success, "Address: unable to send value, recipient may have reverted");
322     }
323 
324     /**
325      * @dev Performs a Solidity function call using a low level `call`. A
326      * plain `call` is an unsafe replacement for a function call: use this
327      * function instead.
328      *
329      * If `target` reverts with a revert reason, it is bubbled up by this
330      * function (like regular Solidity function calls).
331      *
332      * Returns the raw returned data. To convert to the expected return value,
333      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
334      *
335      * Requirements:
336      *
337      * - `target` must be a contract.
338      * - calling `target` with `data` must not revert.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
343         return functionCall(target, data, "Address: low-level call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
348      * `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, 0, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but also transferring `value` wei to `target`.
363      *
364      * Requirements:
365      *
366      * - the calling contract must have an ETH balance of at least `value`.
367      * - the called Solidity function must be `payable`.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value
375     ) internal returns (bytes memory) {
376         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
381      * with `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(
386         address target,
387         bytes memory data,
388         uint256 value,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(address(this).balance >= value, "Address: insufficient balance for call");
392         require(isContract(target), "Address: call to non-contract");
393 
394         (bool success, bytes memory returndata) = target.call{value: value}(data);
395         return verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
405         return functionStaticCall(target, data, "Address: low-level static call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
410      * but performing a static call.
411      *
412      * _Available since v3.3._
413      */
414     function functionStaticCall(
415         address target,
416         bytes memory data,
417         string memory errorMessage
418     ) internal view returns (bytes memory) {
419         require(isContract(target), "Address: static call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.staticcall(data);
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
432         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437      * but performing a delegate call.
438      *
439      * _Available since v3.4._
440      */
441     function functionDelegateCall(
442         address target,
443         bytes memory data,
444         string memory errorMessage
445     ) internal returns (bytes memory) {
446         require(isContract(target), "Address: delegate call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.delegatecall(data);
449         return verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
454      * revert reason using the provided one.
455      *
456      * _Available since v4.3._
457      */
458     function verifyCallResult(
459         bool success,
460         bytes memory returndata,
461         string memory errorMessage
462     ) internal pure returns (bytes memory) {
463         if (success) {
464             return returndata;
465         } else {
466             // Look for revert reason and bubble it up if present
467             if (returndata.length > 0) {
468                 // The easiest way to bubble the revert reason is using memory via assembly
469 
470                 assembly {
471                     let returndata_size := mload(returndata)
472                     revert(add(32, returndata), returndata_size)
473                 }
474             } else {
475                 revert(errorMessage);
476             }
477         }
478     }
479 }
480 
481 /**
482  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
483  * @dev See https://eips.ethereum.org/EIPS/eip-721
484  */
485 interface IERC721Metadata is IERC721 {
486     /**
487      * @dev Returns the token collection name.
488      */
489     function name() external view returns (string memory);
490 
491     /**
492      * @dev Returns the token collection symbol.
493      */
494     function symbol() external view returns (string memory);
495 
496     /**
497      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
498      */
499     function tokenURI(uint256 tokenId) external view returns (string memory);
500 }
501 
502 /**
503  * @title ERC721 token receiver interface
504  * @dev Interface for any contract that wants to support safeTransfers
505  * from ERC721 asset contracts.
506  */
507 interface IERC721Receiver {
508     /**
509      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
510      * by `operator` from `from`, this function is called.
511      *
512      * It must return its Solidity selector to confirm the token transfer.
513      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
514      *
515      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
516      */
517     function onERC721Received(
518         address operator,
519         address from,
520         uint256 tokenId,
521         bytes calldata data
522     ) external returns (bytes4);
523 }
524 
525 /**
526  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
527  * @dev See https://eips.ethereum.org/EIPS/eip-721
528  */
529 interface IERC721Enumerable is IERC721 {
530     /**
531      * @dev Returns the total amount of tokens stored by the contract.
532      */
533     function totalSupply() external view returns (uint256);
534 
535     /**
536      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
537      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
538      */
539     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
540 
541     /**
542      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
543      * Use along with {totalSupply} to enumerate all tokens.
544      */
545     function tokenByIndex(uint256 index) external view returns (uint256);
546 }
547 
548 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
549     using Address for address;
550     using Strings for uint256;
551 
552     string private _name;
553     string private _symbol;
554 
555     // Mapping from token ID to owner address
556     address[] internal _owners;
557 
558     mapping(uint256 => address) private _tokenApprovals;
559     mapping(address => mapping(address => bool)) private _operatorApprovals;
560 
561     /**
562      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
563      */
564     constructor(string memory name_, string memory symbol_) {
565         _name = name_;
566         _symbol = symbol_;
567     }
568 
569     /**
570      * @dev See {IERC165-supportsInterface}.
571      */
572     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
573         return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
574     }
575 
576     /**
577      * @dev See {IERC721-balanceOf}.
578      */
579     function balanceOf(address owner) public view virtual override returns (uint256) {
580         require(owner != address(0), "ERC721: balance query for the zero address");
581 
582         uint256 count;
583         for (uint256 i; i < _owners.length; ++i) {
584             if (owner == _owners[i]) ++count;
585         }
586         return count;
587     }
588 
589     /**
590      * @dev See {IERC721-ownerOf}.
591      */
592     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
593         address owner = _owners[tokenId];
594         require(owner != address(0), "ERC721: owner query for nonexistent token");
595         return owner;
596     }
597 
598     /**
599      * @dev See {IERC721Metadata-name}.
600      */
601     function name() public view virtual override returns (string memory) {
602         return _name;
603     }
604 
605     /**
606      * @dev See {IERC721Metadata-symbol}.
607      */
608     function symbol() public view virtual override returns (string memory) {
609         return _symbol;
610     }
611 
612     /**
613      * @dev See {IERC721-approve}.
614      */
615     function approve(address to, uint256 tokenId) public virtual override {
616         address owner = ERC721.ownerOf(tokenId);
617         require(to != owner, "ERC721: approval to current owner");
618 
619         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not owner nor approved for all");
620 
621         _approve(to, tokenId);
622     }
623 
624     /**
625      * @dev See {IERC721-getApproved}.
626      */
627     function getApproved(uint256 tokenId) public view virtual override returns (address) {
628         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
629 
630         return _tokenApprovals[tokenId];
631     }
632 
633     /**
634      * @dev See {IERC721-setApprovalForAll}.
635      */
636     function setApprovalForAll(address operator, bool approved) public virtual override {
637         require(operator != _msgSender(), "ERC721: approve to caller");
638 
639         _operatorApprovals[_msgSender()][operator] = approved;
640         emit ApprovalForAll(_msgSender(), operator, approved);
641     }
642 
643     /**
644      * @dev See {IERC721-isApprovedForAll}.
645      */
646     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
647         return _operatorApprovals[owner][operator];
648     }
649 
650     /**
651      * @dev See {IERC721-transferFrom}.
652      */
653     function transferFrom(
654         address from,
655         address to,
656         uint256 tokenId
657     ) public virtual override {
658         //solhint-disable-next-line max-line-length
659         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
660 
661         _transfer(from, to, tokenId);
662     }
663 
664     /**
665      * @dev See {IERC721-safeTransferFrom}.
666      */
667     function safeTransferFrom(
668         address from,
669         address to,
670         uint256 tokenId
671     ) public virtual override {
672         safeTransferFrom(from, to, tokenId, "");
673     }
674 
675     /**
676      * @dev See {IERC721-safeTransferFrom}.
677      */
678     function safeTransferFrom(
679         address from,
680         address to,
681         uint256 tokenId,
682         bytes memory _data
683     ) public virtual override {
684         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
685         _safeTransfer(from, to, tokenId, _data);
686     }
687 
688     /**
689      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
690      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
691      *
692      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
693      *
694      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
695      * implement alternative mechanisms to perform token transfer, such as signature-based.
696      *
697      * Requirements:
698      *
699      * - `from` cannot be the zero address.
700      * - `to` cannot be the zero address.
701      * - `tokenId` token must exist and be owned by `from`.
702      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
703      *
704      * Emits a {Transfer} event.
705      */
706     function _safeTransfer(
707         address from,
708         address to,
709         uint256 tokenId,
710         bytes memory _data
711     ) internal virtual {
712         _transfer(from, to, tokenId);
713         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
714     }
715 
716     /**
717      * @dev Returns whether `tokenId` exists.
718      *
719      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
720      *
721      * Tokens start existing when they are minted (`_mint`),
722      * and stop existing when they are burned (`_burn`).
723      */
724     function _exists(uint256 tokenId) internal view virtual returns (bool) {
725         return tokenId < _owners.length && _owners[tokenId] != address(0);
726     }
727 
728     /**
729      * @dev Returns whether `spender` is allowed to manage `tokenId`.
730      *
731      * Requirements:
732      *
733      * - `tokenId` must exist.
734      */
735     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
736         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
737         address owner = ERC721.ownerOf(tokenId);
738         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
739     }
740 
741     /**
742      * @dev Safely mints `tokenId` and transfers it to `to`.
743      *
744      * Requirements:
745      *
746      * - `tokenId` must not exist.
747      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
748      *
749      * Emits a {Transfer} event.
750      */
751     function _safeMint(address to, uint256 tokenId) internal virtual {
752         _safeMint(to, tokenId, "");
753     }
754 
755     /**
756      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
757      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
758      */
759     function _safeMint(
760         address to,
761         uint256 tokenId,
762         bytes memory _data
763     ) internal virtual {
764         _mint(to, tokenId);
765         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
766     }
767 
768     /**
769      * @dev Mints `tokenId` and transfers it to `to`.
770      *
771      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
772      *
773      * Requirements:
774      *
775      * - `tokenId` must not exist.
776      * - `to` cannot be the zero address.
777      *
778      * Emits a {Transfer} event.
779      */
780     function _mint(address to, uint256 tokenId) internal virtual {
781         require(to != address(0), "ERC721: mint to the zero address");
782         require(!_exists(tokenId), "ERC721: token already minted");
783 
784         _beforeTokenTransfer(address(0), to, tokenId);
785         _owners.push(to);
786 
787         emit Transfer(address(0), to, tokenId);
788     }
789 
790     /**
791      * @dev Destroys `tokenId`.
792      * The approval is cleared when the token is burned.
793      *
794      * Requirements:
795      *
796      * - `tokenId` must exist.
797      *
798      * Emits a {Transfer} event.
799      */
800     function _burn(uint256 tokenId) internal virtual {
801         address owner = ERC721.ownerOf(tokenId);
802 
803         _beforeTokenTransfer(owner, address(0), tokenId);
804 
805         // Clear approvals
806         _approve(address(0), tokenId);
807         _owners[tokenId] = address(0);
808 
809         emit Transfer(owner, address(0), tokenId);
810     }
811 
812     /**
813      * @dev Transfers `tokenId` from `from` to `to`.
814      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
815      *
816      * Requirements:
817      *
818      * - `to` cannot be the zero address.
819      * - `tokenId` token must be owned by `from`.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _transfer(
824         address from,
825         address to,
826         uint256 tokenId
827     ) internal virtual {
828         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
829         require(to != address(0), "ERC721: transfer to the zero address");
830 
831         _beforeTokenTransfer(from, to, tokenId);
832 
833         // Clear approvals from the previous owner
834         _approve(address(0), tokenId);
835         _owners[tokenId] = to;
836 
837         emit Transfer(from, to, tokenId);
838     }
839 
840     /**
841      * @dev Approve `to` to operate on `tokenId`
842      *
843      * Emits a {Approval} event.
844      */
845     function _approve(address to, uint256 tokenId) internal virtual {
846         _tokenApprovals[tokenId] = to;
847         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
848     }
849 
850     /**
851      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
852      * The call is not executed if the target address is not a contract.
853      *
854      * @param from address representing the previous owner of the given token ID
855      * @param to target address that will receive the tokens
856      * @param tokenId uint256 ID of the token to be transferred
857      * @param _data bytes optional data to send along with the call
858      * @return bool whether the call correctly returned the expected magic value
859      */
860     function _checkOnERC721Received(
861         address from,
862         address to,
863         uint256 tokenId,
864         bytes memory _data
865     ) private returns (bool) {
866         if (to.isContract()) {
867             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
868                 return retval == IERC721Receiver.onERC721Received.selector;
869             } catch (bytes memory reason) {
870                 if (reason.length == 0) {
871                     revert("ERC721: transfer to non ERC721Receiver implementer");
872                 } else {
873                     assembly {
874                         revert(add(32, reason), mload(reason))
875                     }
876                 }
877             }
878         } else {
879             return true;
880         }
881     }
882 
883     /**
884      * @dev Hook that is called before any token transfer. This includes minting
885      * and burning.
886      *
887      * Calling conditions:
888      *
889      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
890      * transferred to `to`.
891      * - When `from` is zero, `tokenId` will be minted for `to`.
892      * - When `to` is zero, ``from``'s `tokenId` will be burned.
893      * - `from` and `to` are never both zero.
894      *
895      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
896      */
897     function _beforeTokenTransfer(
898         address from,
899         address to,
900         uint256 tokenId
901     ) internal virtual {}
902 }
903 
904 contract VRFRequestIDBase {
905     /**
906      * @notice returns the seed which is actually input to the VRF coordinator
907      *
908      * @dev To prevent repetition of VRF output due to repetition of the
909      * @dev user-supplied seed, that seed is combined in a hash with the
910      * @dev user-specific nonce, and the address of the consuming contract. The
911      * @dev risk of repetition is mostly mitigated by inclusion of a blockhash in
912      * @dev the final seed, but the nonce does protect against repetition in
913      * @dev requests which are included in a single block.
914      *
915      * @param _userSeed VRF seed input provided by user
916      * @param _requester Address of the requesting contract
917      * @param _nonce User-specific nonce at the time of the request
918      */
919     function makeVRFInputSeed(
920         bytes32 _keyHash,
921         uint256 _userSeed,
922         address _requester,
923         uint256 _nonce
924     ) internal pure returns (uint256) {
925         return uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));
926     }
927 
928     /**
929      * @notice Returns the id for this request
930      * @param _keyHash The serviceAgreement ID to be used for this request
931      * @param _vRFInputSeed The seed to be passed directly to the VRF
932      * @return The id for this request
933      *
934      * @dev Note that _vRFInputSeed is not the seed passed by the consuming
935      * @dev contract, but the one generated by makeVRFInputSeed
936      */
937     function makeRequestId(bytes32 _keyHash, uint256 _vRFInputSeed) internal pure returns (bytes32) {
938         return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
939     }
940 }
941 
942 interface LinkTokenInterface {
943     function allowance(address owner, address spender) external view returns (uint256 remaining);
944 
945     function approve(address spender, uint256 value) external returns (bool success);
946 
947     function balanceOf(address owner) external view returns (uint256 balance);
948 
949     function decimals() external view returns (uint8 decimalPlaces);
950 
951     function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
952 
953     function increaseApproval(address spender, uint256 subtractedValue) external;
954 
955     function name() external view returns (string memory tokenName);
956 
957     function symbol() external view returns (string memory tokenSymbol);
958 
959     function totalSupply() external view returns (uint256 totalTokensIssued);
960 
961     function transfer(address to, uint256 value) external returns (bool success);
962 
963     function transferAndCall(
964         address to,
965         uint256 value,
966         bytes calldata data
967     ) external returns (bool success);
968 
969     function transferFrom(
970         address from,
971         address to,
972         uint256 value
973     ) external returns (bool success);
974 }
975 
976 /**
977  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
978  * enumerability of all the token ids in the contract as well as all token ids owned by each
979  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
980  */
981 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
982     /**
983      * @dev See {IERC165-supportsInterface}.
984      */
985     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
986         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
987     }
988 
989     /**
990      * @dev See {IERC721Enumerable-totalSupply}.
991      */
992     function totalSupply() public view virtual override returns (uint256) {
993         return _owners.length;
994     }
995 
996     /**
997      * @dev See {IERC721Enumerable-tokenByIndex}.
998      */
999     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1000         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
1001         return index;
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1006      */
1007     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1008         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1009 
1010         uint256 count;
1011         for (uint256 i; i < _owners.length; i++) {
1012             if (owner == _owners[i]) {
1013                 if (count == index) return i;
1014                 else count++;
1015             }
1016         }
1017 
1018         revert("ERC721Enumerable: owner index out of bounds");
1019     }
1020 }
1021 
1022 /** ****************************************************************************
1023  * @notice Interface for contracts using VRF randomness
1024  * *****************************************************************************
1025  * @dev PURPOSE
1026  *
1027  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
1028  * @dev to Vera the verifier in such a way that Vera can be sure he's not
1029  * @dev making his output up to suit himself. Reggie provides Vera a public key
1030  * @dev to which he knows the secret key. Each time Vera provides a seed to
1031  * @dev Reggie, he gives back a value which is computed completely
1032  * @dev deterministically from the seed and the secret key.
1033  *
1034  * @dev Reggie provides a proof by which Vera can verify that the output was
1035  * @dev correctly computed once Reggie tells it to her, but without that proof,
1036  * @dev the output is indistinguishable to her from a uniform random sample
1037  * @dev from the output space.
1038  *
1039  * @dev The purpose of this contract is to make it easy for unrelated contracts
1040  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
1041  * @dev simple access to a verifiable source of randomness.
1042  * *****************************************************************************
1043  * @dev USAGE
1044  *
1045  * @dev Calling contracts must inherit from VRFConsumerBase, and can
1046  * @dev initialize VRFConsumerBase's attributes in their constructor as
1047  * @dev shown:
1048  *
1049  * @dev   contract VRFConsumer {
1050  * @dev     constuctor(<other arguments>, address _vrfCoordinator, address _link)
1051  * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
1052  * @dev         <initialization with other arguments goes here>
1053  * @dev       }
1054  * @dev   }
1055  *
1056  * @dev The oracle will have given you an ID for the VRF keypair they have
1057  * @dev committed to (let's call it keyHash), and have told you the minimum LINK
1058  * @dev price for VRF service. Make sure your contract has sufficient LINK, and
1059  * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
1060  * @dev want to generate randomness from.
1061  *
1062  * @dev Once the VRFCoordinator has received and validated the oracle's response
1063  * @dev to your request, it will call your contract's fulfillRandomness method.
1064  *
1065  * @dev The randomness argument to fulfillRandomness is the actual random value
1066  * @dev generated from your seed.
1067  *
1068  * @dev The requestId argument is generated from the keyHash and the seed by
1069  * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
1070  * @dev requests open, you can use the requestId to track which seed is
1071  * @dev associated with which randomness. See VRFRequestIDBase.sol for more
1072  * @dev details. (See "SECURITY CONSIDERATIONS" for principles to keep in mind,
1073  * @dev if your contract could have multiple requests in flight simultaneously.)
1074  *
1075  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
1076  * @dev differ. (Which is critical to making unpredictable randomness! See the
1077  * @dev next section.)
1078  *
1079  * *****************************************************************************
1080  * @dev SECURITY CONSIDERATIONS
1081  *
1082  * @dev A method with the ability to call your fulfillRandomness method directly
1083  * @dev could spoof a VRF response with any random value, so it's critical that
1084  * @dev it cannot be directly called by anything other than this base contract
1085  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
1086  *
1087  * @dev For your users to trust that your contract's random behavior is free
1088  * @dev from malicious interference, it's best if you can write it so that all
1089  * @dev behaviors implied by a VRF response are executed *during* your
1090  * @dev fulfillRandomness method. If your contract must store the response (or
1091  * @dev anything derived from it) and use it later, you must ensure that any
1092  * @dev user-significant behavior which depends on that stored value cannot be
1093  * @dev manipulated by a subsequent VRF request.
1094  *
1095  * @dev Similarly, both miners and the VRF oracle itself have some influence
1096  * @dev over the order in which VRF responses appear on the blockchain, so if
1097  * @dev your contract could have multiple VRF requests in flight simultaneously,
1098  * @dev you must ensure that the order in which the VRF responses arrive cannot
1099  * @dev be used to manipulate your contract's user-significant behavior.
1100  *
1101  * @dev Since the ultimate input to the VRF is mixed with the block hash of the
1102  * @dev block in which the request is made, user-provided seeds have no impact
1103  * @dev on its economic security properties. They are only included for API
1104  * @dev compatability with previous versions of this contract.
1105  *
1106  * @dev Since the block hash of the block which contains the requestRandomness
1107  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
1108  * @dev miner could, in principle, fork the blockchain to evict the block
1109  * @dev containing the request, forcing the request to be included in a
1110  * @dev different block with a different hash, and therefore a different input
1111  * @dev to the VRF. However, such an attack would incur a substantial economic
1112  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
1113  * @dev until it calls responds to a request.
1114  */
1115 abstract contract VRFConsumerBase is VRFRequestIDBase {
1116     /**
1117      * @notice fulfillRandomness handles the VRF response. Your contract must
1118      * @notice implement it. See "SECURITY CONSIDERATIONS" above for ////important
1119      * @notice principles to keep in mind when implementing your fulfillRandomness
1120      * @notice method.
1121      *
1122      * @dev VRFConsumerBase expects its subcontracts to have a method with this
1123      * @dev signature, and will call it once it has verified the proof
1124      * @dev associated with the randomness. (It is triggered via a call to
1125      * @dev rawFulfillRandomness, below.)
1126      *
1127      * @param requestId The Id initially returned by requestRandomness
1128      * @param randomness the VRF output
1129      */
1130     function fulfillRandomness(bytes32 requestId, uint256 randomness) internal virtual;
1131 
1132     /**
1133      * @dev In order to keep backwards compatibility we have kept the user
1134      * seed field around. We remove the use of it because given that the blockhash
1135      * enters later, it overrides whatever randomness the used seed provides.
1136      * Given that it adds no security, and can easily lead to misunderstandings,
1137      * we have removed it from usage and can now provide a simpler API.
1138      */
1139     uint256 private constant USER_SEED_PLACEHOLDER = 0;
1140 
1141     /**
1142      * @notice requestRandomness initiates a request for VRF output given _seed
1143      *
1144      * @dev The fulfillRandomness method receives the output, once it's provided
1145      * @dev by the Oracle, and verified by the vrfCoordinator.
1146      *
1147      * @dev The _keyHash must already be registered with the VRFCoordinator, and
1148      * @dev the _fee must exceed the fee specified during registration of the
1149      * @dev _keyHash.
1150      *
1151      * @dev The _seed parameter is vestigial, and is kept only for API
1152      * @dev compatibility with older versions. It can't *hurt* to mix in some of
1153      * @dev your own randomness, here, but it's not necessary because the VRF
1154      * @dev oracle will mix the hash of the block containing your request into the
1155      * @dev VRF seed it ultimately uses.
1156      *
1157      * @param _keyHash ID of public key against which randomness is generated
1158      * @param _fee The amount of LINK to send with the request
1159      *
1160      * @return requestId unique ID for this request
1161      *
1162      * @dev The returned requestId can be used to distinguish responses to
1163      * @dev concurrent requests. It is passed as the first argument to
1164      * @dev fulfillRandomness.
1165      */
1166     function requestRandomness(bytes32 _keyHash, uint256 _fee) internal returns (bytes32 requestId) {
1167         LINK.transferAndCall(vrfCoordinator, _fee, abi.encode(_keyHash, USER_SEED_PLACEHOLDER));
1168         // This is the seed passed to VRFCoordinator. The oracle will mix this with
1169         // the hash of the block containing this request to obtain the seed/input
1170         // which is finally passed to the VRF cryptographic machinery.
1171         uint256 vRFSeed = makeVRFInputSeed(_keyHash, USER_SEED_PLACEHOLDER, address(this), nonces[_keyHash]);
1172         // nonces[_keyHash] must stay in sync with
1173         // VRFCoordinator.nonces[_keyHash][this], which was incremented by the above
1174         // successful LINK.transferAndCall (in VRFCoordinator.randomnessRequest).
1175         // This provides protection against the user repeating their input seed,
1176         // which would result in a predictable/duplicate output, if multiple such
1177         // requests appeared in the same block.
1178         nonces[_keyHash] = nonces[_keyHash] + 1;
1179         return makeRequestId(_keyHash, vRFSeed);
1180     }
1181 
1182     LinkTokenInterface internal immutable LINK;
1183     address private immutable vrfCoordinator;
1184 
1185     // Nonces for each VRF key from which randomness has been requested.
1186     //
1187     // Must stay in sync with VRFCoordinator[_keyHash][this]
1188     mapping(bytes32 => uint256) /* keyHash */ /* nonce */
1189         private nonces;
1190 
1191     /**
1192      * @param _vrfCoordinator address of VRFCoordinator contract
1193      * @param _link address of LINK token contract
1194      *
1195      * @dev https://docs.chain.link/docs/link-token-contracts
1196      */
1197     constructor(address _vrfCoordinator, address _link) {
1198         vrfCoordinator = _vrfCoordinator;
1199         LINK = LinkTokenInterface(_link);
1200     }
1201 
1202     // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
1203     // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
1204     // the origin of the call
1205     function rawFulfillRandomness(bytes32 requestId, uint256 randomness) external {
1206         require(msg.sender == vrfCoordinator, "Only VRFCoordinator can fulfill");
1207         fulfillRandomness(requestId, randomness);
1208     }
1209 }
1210 
1211 /**
1212  * @dev Interface of the ERC20 standard as defined in the EIP.
1213  */
1214 interface IERC20 {
1215     /**
1216      * @dev Returns the amount of tokens in existence.
1217      */
1218     function totalSupply() external view returns (uint256);
1219 
1220     /**
1221      * @dev Returns the amount of tokens owned by `account`.
1222      */
1223     function balanceOf(address account) external view returns (uint256);
1224 
1225     /**
1226      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1227      *
1228      * Returns a boolean value indicating whether the operation succeeded.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function transfer(address recipient, uint256 amount) external returns (bool);
1233 
1234     /**
1235      * @dev Returns the remaining number of tokens that `spender` will be
1236      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1237      * zero by default.
1238      *
1239      * This value changes when {approve} or {transferFrom} are called.
1240      */
1241     function allowance(address owner, address spender) external view returns (uint256);
1242 
1243     /**
1244      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1245      *
1246      * Returns a boolean value indicating whether the operation succeeded.
1247      *
1248      * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
1249      * that someone may use both the old and the new allowance by unfortunate
1250      * transaction ordering. One possible solution to mitigate this race
1251      * condition is to first reduce the spender's allowance to 0 and set the
1252      * desired value afterwards:
1253      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1254      *
1255      * Emits an {Approval} event.
1256      */
1257     function approve(address spender, uint256 amount) external returns (bool);
1258 
1259     /**
1260      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1261      * allowance mechanism. `amount` is then deducted from the caller's
1262      * allowance.
1263      *
1264      * Returns a boolean value indicating whether the operation succeeded.
1265      *
1266      * Emits a {Transfer} event.
1267      */
1268     function transferFrom(
1269         address sender,
1270         address recipient,
1271         uint256 amount
1272     ) external returns (bool);
1273 
1274     /**
1275      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1276      * another (`to`).
1277      *
1278      * Note that `value` may be zero.
1279      */
1280     event Transfer(address indexed from, address indexed to, uint256 value);
1281 
1282     /**
1283      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1284      * a call to {approve}. `value` is the new allowance.
1285      */
1286     event Approval(address indexed owner, address indexed spender, uint256 value);
1287 }
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
1310         _transferOwnership(_msgSender());
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
1336         _transferOwnership(address(0));
1337     }
1338 
1339     /**
1340      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1341      * Can only be called by the current owner.
1342      */
1343     function transferOwnership(address newOwner) public virtual onlyOwner {
1344         require(newOwner != address(0), "Ownable: new owner is the zero address");
1345         _transferOwnership(newOwner);
1346     }
1347 
1348     /**
1349      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1350      * Internal function without access restriction.
1351      */
1352     function _transferOwnership(address newOwner) internal virtual {
1353         address oldOwner = _owner;
1354         _owner = newOwner;
1355         emit OwnershipTransferred(oldOwner, newOwner);
1356     }
1357 }
1358 
1359 /**
1360  * @dev These functions deal with verification of Merkle Trees proofs.
1361  *
1362  * The proofs can be generated using the JavaScript library
1363  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1364  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1365  *
1366  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1367  */
1368 library MerkleProof {
1369     /**
1370      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1371      * defined by `root`. For this, a `proof` must be provided, containing
1372      * sibling hashes on the branch from the leaf to the root of the tree. Each
1373      * pair of leaves and each pair of pre-images are assumed to be sorted.
1374      */
1375     function verify(
1376         bytes32[] memory proof,
1377         bytes32 root,
1378         bytes32 leaf
1379     ) internal pure returns (bool) {
1380         return processProof(proof, leaf) == root;
1381     }
1382 
1383     /**
1384      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1385      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1386      * hash matches the root of the tree. When processing the proof, the pairs
1387      * of leafs & pre-images are assumed to be sorted.
1388      *
1389      * _Available since v4.4._
1390      */
1391     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1392         bytes32 computedHash = leaf;
1393         for (uint256 i = 0; i < proof.length; i++) {
1394             bytes32 proofElement = proof[i];
1395             if (computedHash <= proofElement) {
1396                 // Hash(current computed hash + current element of the proof)
1397                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1398             } else {
1399                 // Hash(current element of the proof + current computed hash)
1400                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1401             }
1402         }
1403         return computedHash;
1404     }
1405 }
1406 
1407 
1408 contract HOAP is ERC721Enumerable, Ownable, VRFConsumerBase {
1409 
1410     /**************************
1411      *
1412      *  State Variables
1413      *
1414      **************************/
1415     // ***** constants and assignments *****
1416     uint256 public maxMint = 2; // max mint per minter address
1417     uint256 public teamAllocation = 10; // team allocation of collection in increments
1418     uint256 public collectionSize = 3691; // collect supply (indexed)
1419     address public teamWallet = 0x8814bd515E206C4606E807595329Da30008a8e7B; // address of the team wallet
1420 
1421     // ***** merkle minting *****
1422     bool public mintingState; // enable/disable minting
1423     bytes32 public merkleRoot; // Merkle Root
1424 
1425     // ***** Chainlink VRF & tokenID *****
1426     IERC20 public link; // address of Chainlink token contract
1427     uint256 public VRF_fee; // Chainlink VRF fee
1428     uint256 public oneOfoneRandomNum; //number returned from VRF call
1429     bytes32 public VRF_keyHash; // Chainlink VRF random number keyhash
1430     string public baseURI; // URI to HOAP metadata
1431     bool public verifyVRF; // can only be set once, used to validate the Chainlink config prior to mint
1432 
1433     // ***** OpenSea *****
1434     address public proxyRegistryAddress; // proxyRegistry address
1435 
1436     /**************************
1437      *
1438      *  Mappings
1439      *
1440      **************************/
1441     mapping(address => bool) private admins; // mapping of address to an administrative status
1442     mapping(address => bool) public projectProxy; // mapping of address to projectProxy status
1443     mapping(address => bool) public addressToMinted; // mapping of address to minted status
1444 
1445 
1446     /**********************************************************
1447      *
1448      *  Events
1449      *
1450      **********************************************************/
1451 
1452     event RequestedRandomNumber(bytes32 indexed requestId); // emitted when the ChainLink VRF is requested
1453     event RecievedRandomNumber(bytes32 indexed requestId, uint256 randomNumber); // emitted when a random number is recieved by the Chainlink VRF callback()
1454 
1455     /**********************************************************
1456      *
1457      *  Constructor
1458      *
1459      **********************************************************/
1460 
1461     /**
1462      * @dev Initializes the contract by:
1463      *  - setting a `name` and a `symbol` in the ERC721 constructor
1464      *  - setting collection dependant assignments
1465      */
1466 
1467     constructor(
1468         bytes32 _VRF_keyHash,
1469         uint256 _VRF_Fee,
1470         address _vrfCoordinator,
1471         address _linkToken
1472     ) ERC721("Hell of a Party", "HOAP") VRFConsumerBase(_vrfCoordinator, _linkToken) {
1473         VRF_keyHash = _VRF_keyHash;
1474         VRF_fee = _VRF_Fee;
1475         link = IERC20(address(_linkToken));
1476         admins[_msgSender()] = true;
1477         proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1478     }
1479 
1480     /**********************************************************
1481      *
1482      *  Modifiers
1483      *
1484      **********************************************************/
1485 
1486     /**
1487      * @dev Ensures only contract admins can execute privileged functions
1488      */
1489     modifier onlyAdmin() {
1490         require(isAdmin(_msgSender()), "admins only");
1491         _;
1492     }
1493 
1494     /**********************************************************
1495      *
1496      *  Contract Management
1497      *
1498      **********************************************************/
1499 
1500     /**
1501      * @dev Check is an address is an admin
1502      */
1503     function isAdmin(address _addr) public view returns (bool) {
1504         return owner() == _addr || admins[_addr];
1505     }
1506 
1507     /**
1508      * @dev Grant administrative control to an address
1509      */
1510     function addAdmin(address _addr) external onlyAdmin {
1511         admins[_addr] = true;
1512     }
1513 
1514     /**
1515      * @dev Revoke administrative control for an address
1516      */
1517     function removeAdmin(address _addr) external onlyAdmin {
1518         admins[_addr] = false;
1519     }
1520 
1521     /**********************************************************
1522      *
1523      *  Admin and Contract setters
1524      *
1525      **********************************************************/
1526 
1527     /**
1528      *  @dev running this after the constructor adds the deployed address
1529      *  of this contract to the admins
1530      */
1531     function init() external onlyAdmin {
1532         admins[address(this)] = true;
1533     }
1534 
1535     /**
1536      * @dev enables//disables minting state
1537      */
1538     function setMintingState(bool _state) external onlyAdmin {
1539         mintingState = _state;
1540     }
1541 
1542     /**
1543      * @dev set the baseURI.
1544      */
1545     function setBaseURI(string memory _baseURI) public onlyAdmin {
1546         baseURI = _baseURI;
1547     }
1548 
1549     /**
1550      * @dev Set the maxMint
1551      */
1552     function setMaxMint(uint256 _maxMint) external onlyAdmin {
1553         maxMint = _maxMint;
1554     }
1555 
1556     /**********************************************************
1557      *
1558      *  The hoap list
1559      *
1560      **********************************************************/
1561 
1562     /**
1563      * @dev set the merkleTree root
1564      */
1565     function setMerkleRoot(bytes32 _merkleRoot) public onlyAdmin {
1566         merkleRoot = _merkleRoot;
1567     }
1568 
1569     /**
1570      * @dev calculates the leaf hash
1571      */
1572     function leaf(string memory payload) internal pure returns (bytes32) {
1573         return keccak256(abi.encodePacked(payload));
1574     }
1575 
1576     /**
1577      * @dev verifies the inclusion of the leaf hash in the merkleTree
1578      */
1579     function verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1580         return MerkleProof.verify(proof, merkleRoot, leaf);
1581     }
1582 
1583     /**********************************************************
1584      *
1585      *  Token management
1586      *
1587      **********************************************************/
1588 
1589     /**
1590      *  @dev mint leverages merkleTree for the mint, there is no public sale.
1591      *
1592      *  The first token in the collection is 0 and the last token is 3689, which
1593      *  equates to a collection size of 3690. Gas optimization uses an index based
1594      *  model that returns an array size of 3690. As another gas optimization, we
1595      *  refrained from <= or >= and as a result we must +1, hence collectionSize = 3691.
1596      */
1597     function mint(bytes32[] calldata proof) public payable {
1598         string memory payload = string(abi.encodePacked(_msgSender()));
1599         uint256 totalSupply = _owners.length;
1600 
1601         require(mintingState, "mint not active");
1602         require(verify(leaf(payload), proof), "Invalid Merkle Tree proof supplied");
1603         require(addressToMinted[_msgSender()] == false, "can not mint twice");
1604         require(totalSupply + maxMint < collectionSize, "mint amount exceeds supply");
1605 
1606         addressToMinted[_msgSender()] = true;
1607 
1608         for (uint256 i; i < maxMint; i++) {
1609             _mint(_msgSender(), totalSupply + i);
1610         }
1611     }
1612 
1613     function teamMint() external onlyAdmin {
1614 
1615         uint256 totalSupply = _owners.length;
1616         
1617         for (uint256 i = 0; i < teamAllocation; i++) {
1618             _mint(teamWallet, totalSupply + i);
1619         }
1620     } 
1621 
1622     /**
1623      * @dev mints 'tId' to 'address'
1624      */
1625     function _mint(address to, uint256 tId) internal virtual override {
1626         _owners.push(to);
1627         emit Transfer(address(0), to, tId);
1628     }
1629 
1630     /**********************************************************
1631      *
1632      *  TOKEN
1633      *
1634      **********************************************************/
1635 
1636     /**
1637      * @dev Returns the Uniform Resource Identifier (URI) for the `tokenId` token.
1638      */
1639     function tokenURI(uint256 _tId) public view override returns (string memory) {
1640         require(_exists(_tId), "Token does not exist.");
1641         return string(abi.encodePacked(baseURI, Strings.toString(_tId)));
1642     }
1643 
1644     /**
1645      * @dev transfer an array of tokens from '_from' address to '_to' address
1646      */
1647     function batchTransferFrom(
1648         address _from,
1649         address _to,
1650         uint256[] memory _tIds
1651     ) public {
1652         for (uint256 i = 0; i < _tIds.length; i++) {
1653             transferFrom(_from, _to, _tIds[i]);
1654         }
1655     }
1656 
1657     /**
1658      * @dev safe transfer an array of tokens from '_from' address to '_to' address
1659      */
1660     function batchSafeTransferFrom(
1661         address _from,
1662         address _to,
1663         uint256[] memory _tIds,
1664         bytes memory data_
1665     ) public {
1666         for (uint256 i = 0; i < _tIds.length; i++) {
1667             safeTransferFrom(_from, _to, _tIds[i], data_);
1668         }
1669     }
1670 
1671     /**
1672      * @dev returns a confirmation that 'tIds' are owned by 'account'
1673      */
1674     function isOwnerOf(address account, uint256[] calldata _tIds) external view returns (bool) {
1675         for (uint256 i; i < _tIds.length; ++i) {
1676             if (_owners[_tIds[i]] != account) return false;
1677         }
1678 
1679         return true;
1680     }
1681 
1682     /**
1683      * @dev Retunrs the tokenIds of 'owner'
1684      */
1685     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1686         uint256 tokenCount = balanceOf(_owner);
1687         if (tokenCount == 0) return new uint256[](0);
1688 
1689         uint256[] memory tokensId = new uint256[](tokenCount);
1690         for (uint256 i; i < tokenCount; i++) {
1691             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1692         }
1693 
1694         return tokensId;
1695     }
1696 
1697     /**********************************************************
1698      *
1699      *  GENEROSITY + ETH FUNDING
1700      *
1701      **********************************************************/
1702 
1703     /**
1704      * @dev Just in case someone sends ETH to the contract
1705      */
1706     function withdraw() public {
1707         (bool success, ) = teamWallet.call{value: address(this).balance}("");
1708         require(success, "Failed to send.");
1709     }
1710 
1711     receive() external payable {}
1712 
1713         /**********************************************************
1714      *
1715      *  CHAINLINK VRF & TOKEN DNA
1716      *
1717      **********************************************************/
1718 
1719     /**
1720      * @dev Requests a random number from the Chainlink VRF
1721      */
1722     function requestRandomNumber() external onlyAdmin returns (bytes32 requestId) {
1723         require(LINK.balanceOf(address(this)) >= VRF_fee, "Not enough LINK");
1724         requestId = requestRandomness(VRF_keyHash, VRF_fee);
1725 
1726         emit RequestedRandomNumber(requestId);
1727     }
1728 
1729     /**
1730      * @dev Receives the random number from the Chainlink VRF callback
1731      */
1732     function fulfillRandomness(bytes32 _requestId, uint256 _randomNumber) internal override {
1733         oneOfoneRandomNum = _randomNumber;
1734 
1735         emit RecievedRandomNumber(_requestId, _randomNumber);
1736     }
1737 
1738         /**
1739      * @dev this allows you to test the VRF call to ensure it works as expected prior to mint
1740      * It resets the collectionDNA and period counter to defaults prior to minting.
1741      */
1742     function setVerifyVRF() external onlyAdmin {
1743         require(!verifyVRF, "this is a one time function it can not be called once");
1744         oneOfoneRandomNum = 0;
1745         verifyVRF = true;
1746     }
1747 
1748     /**
1749      * @dev Set/change the Chainlink VRF keyHash
1750      */
1751     function setVRFKeyHash(bytes32 _keyHash) external onlyAdmin {
1752         VRF_keyHash = _keyHash;
1753     }
1754 
1755     /**
1756      * @dev Set/change the Chainlink VRF fee
1757      */
1758     function setVRFFee(uint256 _fee) external onlyAdmin {
1759         VRF_fee = _fee;
1760     }
1761 
1762     function get1of1() external view returns (uint256[] memory) {
1763         require(oneOfoneRandomNum > 0, "VRF not yet called");
1764         uint256[] memory oneOfOnes = new uint256[](26);
1765         uint256 counter;
1766         uint256 addCounter;
1767         bool matchStatus;
1768 
1769         while (addCounter < 26) {
1770             uint256 result = (uint256(keccak256(abi.encode(oneOfoneRandomNum, counter))) % 3689);
1771 
1772             for (uint256 i = 0; i < oneOfOnes.length; i++) {
1773                 if (result == oneOfOnes[i]) {
1774                     matchStatus = true;
1775                     break;
1776                 }
1777             }
1778 
1779             if (!matchStatus) {
1780                 oneOfOnes[addCounter] = result;
1781                 addCounter++;
1782             } else {
1783                 matchStatus = false;
1784             }
1785             counter++;
1786         }
1787         return oneOfOnes;
1788     }
1789 
1790 
1791     /**********************************************************
1792      *
1793      *  OPENSEA
1794      *
1795      **********************************************************/
1796 
1797     function setProxyRegistryAddress(address _proxyRegistryAddress) external onlyAdmin {
1798         proxyRegistryAddress = _proxyRegistryAddress;
1799     }
1800 
1801     function flipProxyState(address proxyAddress) public onlyOwner {
1802         projectProxy[proxyAddress] = !projectProxy[proxyAddress];
1803     }
1804 
1805     function isApprovedForAll(address _owner, address operator) public view override returns (bool) {
1806         OpenSeaProxyRegistry proxyRegistry = OpenSeaProxyRegistry(proxyRegistryAddress);
1807         if (address(proxyRegistry.proxies(_owner)) == operator || projectProxy[operator]) return true;
1808         return super.isApprovedForAll(_owner, operator);
1809     }
1810 }
1811 
1812 contract OwnableDelegateProxy {}
1813 
1814 contract OpenSeaProxyRegistry {
1815     mapping(address => OwnableDelegateProxy) public proxies;
1816 }