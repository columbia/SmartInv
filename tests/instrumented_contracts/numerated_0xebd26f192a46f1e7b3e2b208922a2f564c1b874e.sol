1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
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
161 /**
162  * @title ERC721 token receiver interface
163  * @dev Interface for any contract that wants to support safeTransfers
164  * from ERC721 asset contracts.
165  */
166 interface IERC721Receiver {
167     /**
168      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
169      * by `operator` from `from`, this function is called.
170      *
171      * It must return its Solidity selector to confirm the token transfer.
172      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
173      *
174      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
175      */
176 
177     function onERC721Received(
178         address operator,
179         address from,
180         uint256 tokenId,
181         bytes calldata data
182     ) external returns (bytes4);
183 }
184 /**
185  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
186  * @dev See https://eips.ethereum.org/EIPS/eip-721
187  */
188 interface IERC721Metadata is IERC721 {
189     /**
190      * @dev Returns the token collection name.
191      */
192     function name() external view returns (string memory);
193 
194     /**
195      * @dev Returns the token collection symbol.
196      */
197     function symbol() external view returns (string memory);
198 
199     /**
200      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
201      */
202     function tokenURI(uint256 tokenId) external view returns (string memory);
203 }
204 /**
205  * @dev Collection of functions related to the address type
206  */
207 library Address {
208     /**
209      * @dev Returns true if `account` is a contract.
210      *
211      * [IMPORTANT]
212      * ====
213      * It is unsafe to assume that an address for which this function returns
214      * false is an externally-owned account (EOA) and not a contract.
215      *
216      * Among others, `isContract` will return false for the following
217      * types of addresses:
218      *
219      *  - an externally-owned account
220      *  - a contract in construction
221      *  - an address where a contract will be created
222      *  - an address where a contract lived, but was destroyed
223      * ====
224      */
225     function isContract(address account) internal view returns (bool) {
226         // This method relies on extcodesize, which returns 0 for contracts in
227         // construction, since the code is only stored at the end of the
228         // constructor execution.
229 
230         uint256 size;
231         assembly {
232             size := extcodesize(account)
233         }
234         return size > 0;
235     }
236 
237     /**
238      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
239      * `recipient`, forwarding all available gas and reverting on errors.
240      *
241      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
242      * of certain opcodes, possibly making contracts go over the 2300 gas limit
243      * imposed by `transfer`, making them unable to receive funds via
244      * `transfer`. {sendValue} removes this limitation.
245      *
246      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
247      *
248      * IMPORTANT: because control is transferred to `recipient`, care must be
249      * taken to not create reentrancy vulnerabilities. Consider using
250      * {ReentrancyGuard} or the
251      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
252      */
253     function sendValue(address payable recipient, uint256 amount) internal {
254         require(address(this).balance >= amount, "Address: insufficient balance");
255 
256         (bool success, ) = recipient.call{value: amount}("");
257         require(success, "Address: unable to send value, recipient may have reverted");
258     }
259 
260     /**
261      * @dev Performs a Solidity function call using a low level `call`. A
262      * plain `call` is an unsafe replacement for a function call: use this
263      * function instead.
264      *
265      * If `target` reverts with a revert reason, it is bubbled up by this
266      * function (like regular Solidity function calls).
267      *
268      * Returns the raw returned data. To convert to the expected return value,
269      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
270      *
271      * Requirements:
272      *
273      * - `target` must be a contract.
274      * - calling `target` with `data` must not revert.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionCall(target, data, "Address: low-level call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
284      * `errorMessage` as a fallback revert reason when `target` reverts.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, 0, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but also transferring `value` wei to `target`.
299      *
300      * Requirements:
301      *
302      * - the calling contract must have an ETH balance of at least `value`.
303      * - the called Solidity function must be `payable`.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value
311     ) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
317      * with `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         require(address(this).balance >= value, "Address: insufficient balance for call");
328         require(isContract(target), "Address: call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.call{value: value}(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
341         return functionStaticCall(target, data, "Address: low-level static call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
346      * but performing a static call.
347      *
348      * _Available since v3.3._
349      */
350     function functionStaticCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal view returns (bytes memory) {
355         require(isContract(target), "Address: static call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.staticcall(data);
358         return verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(isContract(target), "Address: delegate call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.delegatecall(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
390      * revert reason using the provided one.
391      *
392      * _Available since v4.3._
393      */
394     function verifyCallResult(
395         bool success,
396         bytes memory returndata,
397         string memory errorMessage
398     ) internal pure returns (bytes memory) {
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 /**
418  * @dev Provides information about the current execution context, including the
419  * sender of the transaction and its data. While these are generally available
420  * via msg.sender and msg.data, they should not be accessed in such a direct
421  * manner, since when dealing with meta-transactions the account sending and
422  * paying for execution may not be the actual sender (as far as an application
423  * is concerned).
424  *
425  * This contract is only required for intermediate, library-like contracts.
426  */
427 abstract contract Context {
428     function _msgSender() internal view virtual returns (address) {
429         return msg.sender;
430     }
431 
432     function _msgData() internal view virtual returns (bytes calldata) {
433         return msg.data;
434     }
435 }
436 
437 
438 /**
439  * @dev String operations.
440  */
441 library Strings {
442     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
443 
444     /**
445      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
446      */
447     function toString(uint256 value) internal pure returns (string memory) {
448         // Inspired by OraclizeAPI's implementation - MIT licence
449         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
450 
451         if (value == 0) {
452             return "0";
453         }
454         uint256 temp = value;
455         uint256 digits;
456         while (temp != 0) {
457             digits++;
458             temp /= 10;
459         }
460         bytes memory buffer = new bytes(digits);
461         while (value != 0) {
462             digits -= 1;
463             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
464             value /= 10;
465         }
466         return string(buffer);
467     }
468 }
469 
470 /**
471  * @dev Implementation of the {IERC165} interface.
472  *
473  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
474  * for the additional interface id that will be supported. For example:
475  *
476  * ```solidity
477  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
478  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
479  * }
480  * ```
481  *
482  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
483  */
484 abstract contract ERC165 is IERC165 {
485     /**
486      * @dev See {IERC165-supportsInterface}.
487      */
488     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489         return interfaceId == type(IERC165).interfaceId;
490     }
491 }
492 
493 /**
494  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
495  * the Metadata extension, but not including the Enumerable extension, which is available separately as
496  * {ERC721Enumerable}.
497  */
498 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
499     using Address for address;
500     using Strings for uint256;
501 
502     // Token name
503     string private _name;
504 
505     // Token symbol
506     string private _symbol;
507 
508     // Mapping from token ID to owner address
509     mapping(uint256 => address) private _owners;
510 
511     // Mapping owner address to token count
512     mapping(address => uint256) private _balances;
513 
514     // Mapping from token ID to approved address
515     mapping(uint256 => address) private _tokenApprovals;
516 
517     // Mapping from owner to operator approvals
518     mapping(address => mapping(address => bool)) private _operatorApprovals;
519 
520     /**
521      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
522      */
523     constructor(string memory name_, string memory symbol_) {
524         _name = name_;
525         _symbol = symbol_;
526     }
527 
528     /**
529      * @dev See {IERC165-supportsInterface}.
530      */
531     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
532         return
533             interfaceId == type(IERC721).interfaceId ||
534             interfaceId == type(IERC721Metadata).interfaceId ||
535             super.supportsInterface(interfaceId);
536     }
537 
538     function _multiMint(uint256 amount, address to) internal virtual {
539         unchecked {
540             _balances[to] += amount;
541         }
542     }
543 
544     /**
545      * @dev See {IERC721-balanceOf}.
546      */
547     function balanceOf(address owner) public view virtual override returns (uint256) {
548         require(owner != address(0), "ERC721: balance query for the zero address");
549         return _balances[owner];
550     }
551 
552     /**
553      * @dev See {IERC721-ownerOf}.
554      */
555     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
556         address owner = _owners[tokenId];
557         require(owner != address(0), "ERC721: owner query for nonexistent token");
558         return owner;
559     }
560 
561     /**
562      * @dev See {IERC721Metadata-name}.
563      */
564     function name() public view virtual override returns (string memory) {
565         return _name;
566     }
567 
568     /**
569      * @dev See {IERC721Metadata-symbol}.
570      */
571     function symbol() public view virtual override returns (string memory) {
572         return _symbol;
573     }
574 
575     /**
576      * @dev See {IERC721Metadata-tokenURI}.
577      */
578     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
579         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
580 
581         string memory baseURI = _baseURI();
582         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
583     }
584 
585     /**
586      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
587      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
588      * by default, can be overriden in child contracts.
589      */
590     function _baseURI() internal view virtual returns (string memory) {
591         return "";
592     }
593 
594     /**
595      * @dev See {IERC721-approve}.
596      */
597     function approve(address to, uint256 tokenId) public virtual override {
598         address owner = ERC721.ownerOf(tokenId);
599         require(to != owner, "ERC721: approval to current owner");
600 
601         require(
602             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
603             "ERC721: approve caller is not owner nor approved for all"
604         );
605 
606         _approve(to, tokenId);
607     }
608 
609     /**
610      * @dev See {IERC721-getApproved}.
611      */
612     function getApproved(uint256 tokenId) public view virtual override returns (address) {
613         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
614 
615         return _tokenApprovals[tokenId];
616     }
617 
618     /**
619      * @dev See {IERC721-setApprovalForAll}.
620      */
621     function setApprovalForAll(address operator, bool approved) public virtual override {
622         _setApprovalForAll(_msgSender(), operator, approved);
623     }
624 
625     /**
626      * @dev See {IERC721-isApprovedForAll}.
627      */
628     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
629         return _operatorApprovals[owner][operator];
630     }
631 
632     /**
633      * @dev See {IERC721-transferFrom}.
634      */
635     function transferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) public virtual override {
640         //solhint-disable-next-line max-line-length
641         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
642 
643         _transfer(from, to, tokenId);
644     }
645 
646     /**
647      * @dev See {IERC721-safeTransferFrom}.
648      */
649     function safeTransferFrom(
650         address from,
651         address to,
652         uint256 tokenId
653     ) public virtual override {
654         safeTransferFrom(from, to, tokenId, "");
655     }
656 
657     /**
658      * @dev See {IERC721-safeTransferFrom}.
659      */
660     function safeTransferFrom(
661         address from,
662         address to,
663         uint256 tokenId,
664         bytes memory _data
665     ) public virtual override {
666         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
667         _safeTransfer(from, to, tokenId, _data);
668     }
669 
670     /**
671      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
672      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
673      *
674      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
675      *
676      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
677      * implement alternative mechanisms to perform token transfer, such as signature-based.
678      *
679      * Requirements:
680      *
681      * - `from` cannot be the zero address.
682      * - `to` cannot be the zero address.
683      * - `tokenId` token must exist and be owned by `from`.
684      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
685      *
686      * Emits a {Transfer} event.
687      */
688     function _safeTransfer(
689         address from,
690         address to,
691         uint256 tokenId,
692         bytes memory _data
693     ) internal virtual {
694         _transfer(from, to, tokenId);
695         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
696     }
697 
698     /**
699      * @dev Returns whether `tokenId` exists.
700      *
701      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
702      *
703      * Tokens start existing when they are minted (`_mint`),
704      * and stop existing when they are burned (`_burn`).
705      */
706     function _exists(uint256 tokenId) internal view virtual returns (bool) {
707         return _owners[tokenId] != address(0);
708     }
709 
710     /**
711      * @dev Returns whether `spender` is allowed to manage `tokenId`.
712      *
713      * Requirements:
714      *
715      * - `tokenId` must exist.
716      */
717     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
718         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
719         address owner = ERC721.ownerOf(tokenId);
720         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
721     }
722 
723     /**
724      * @dev Safely mints `tokenId` and transfers it to `to`.
725      *
726      * Requirements:
727      *
728      * - `tokenId` must not exist.
729      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
730      *
731      * Emits a {Transfer} event.
732      */
733     function _safeMint(address to, uint256 tokenId) internal virtual {
734         _safeMint(to, tokenId, "");
735     }
736 
737     /**
738      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
739      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
740      */
741     function _safeMint(
742         address to,
743         uint256 tokenId,
744         bytes memory _data
745     ) internal virtual {
746         _mint(to, tokenId);
747         require(
748             _checkOnERC721Received(address(0), to, tokenId, _data),
749             "ERC721: transfer to non ERC721Receiver implementer"
750         );
751     }
752 
753     /**
754      * @dev Mints `tokenId` and transfers it to `to`.
755      *
756      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
757      *
758      * Requirements:
759      *
760      * - `tokenId` must not exist.
761      * - `to` cannot be the zero address.
762      *
763      * Emits a {Transfer} event.
764      */
765     function _mint(address to, uint256 tokenId) internal virtual {
766         require(to != address(0), "ERC721: mint to the zero address");
767         require(!_exists(tokenId), "ERC721: token already minted");
768 
769         _beforeTokenTransfer(address(0), to, tokenId);
770 
771         _owners[tokenId] = to;
772 
773         emit Transfer(address(0), to, tokenId);
774     }
775 
776     /**
777      * @dev Destroys `tokenId`.
778      * The approval is cleared when the token is burned.
779      *
780      * Requirements:
781      *
782      * - `tokenId` must exist.
783      *
784      * Emits a {Transfer} event.
785      */
786     function _burn(uint256 tokenId) internal virtual {
787         address owner = ERC721.ownerOf(tokenId);
788 
789         _beforeTokenTransfer(owner, address(0), tokenId);
790 
791         // Clear approvals
792         _approve(address(0), tokenId);
793 
794         _balances[owner] -= 1;
795         delete _owners[tokenId];
796 
797         emit Transfer(owner, address(0), tokenId);
798     }
799 
800     /**
801      * @dev Transfers `tokenId` from `from` to `to`.
802      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
803      *
804      * Requirements:
805      *
806      * - `to` cannot be the zero address.
807      * - `tokenId` token must be owned by `from`.
808      *
809      * Emits a {Transfer} event.
810      */
811     function _transfer(
812         address from,
813         address to,
814         uint256 tokenId
815     ) internal virtual {
816         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
817         require(to != address(0), "ERC721: transfer to the zero address");
818 
819         _beforeTokenTransfer(from, to, tokenId);
820 
821         // Clear approvals from the previous owner
822         _approve(address(0), tokenId);
823 
824         _balances[from] -= 1;
825         _balances[to] += 1;
826         _owners[tokenId] = to;
827 
828 
829         emit Transfer(from, to, tokenId);
830     }
831 
832     /**
833      * @dev Approve `to` to operate on `tokenId`
834      *
835      * Emits a {Approval} event.
836      */
837     function _approve(address to, uint256 tokenId) internal virtual {
838         _tokenApprovals[tokenId] = to;
839         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
840     }
841 
842     /**
843      * @dev Approve `operator` to operate on all of `owner` tokens
844      *
845      * Emits a {ApprovalForAll} event.
846      */
847     function _setApprovalForAll(
848         address owner,
849         address operator,
850         bool approved
851     ) internal virtual {
852         require(owner != operator, "ERC721: approve to caller");
853         _operatorApprovals[owner][operator] = approved;
854         emit ApprovalForAll(owner, operator, approved);
855     }
856 
857     /**
858      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
859      * The call is not executed if the target address is not a contract.
860      *
861      * @param from address representing the previous owner of the given token ID
862      * @param to target address that will receive the tokens
863      * @param tokenId uint256 ID of the token to be transferred
864      * @param _data bytes optional data to send along with the call
865      * @return bool whether the call correctly returned the expected magic value
866      */
867     function _checkOnERC721Received(
868         address from,
869         address to,
870         uint256 tokenId,
871         bytes memory _data
872     ) private returns (bool) {
873         if (to.isContract()) {
874             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
875                 return retval == IERC721Receiver.onERC721Received.selector;
876             } catch (bytes memory reason) {
877                 if (reason.length == 0) {
878                     revert("ERC721: transfer to non ERC721Receiver implementer");
879                 } else {
880                     assembly {
881                         revert(add(32, reason), mload(reason))
882                     }
883                 }
884             }
885         } else {
886             return true;
887         }
888     }
889 
890     /**
891      * @dev Hook that is called before any token transfer. This includes minting
892      * and burning.
893      *
894      * Calling conditions:
895      *
896      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
897      * transferred to `to`.
898      * - When `from` is zero, `tokenId` will be minted for `to`.
899      * - When `to` is zero, ``from``'s `tokenId` will be burned.
900      * - `from` and `to` are never both zero.
901      *
902      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
903      */
904     function _beforeTokenTransfer(
905         address from,
906         address to,
907         uint256 tokenId
908     ) internal virtual {}
909 }
910 
911 /**
912  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
913  * @dev See https://eips.ethereum.org/EIPS/eip-721
914  */
915 interface IERC721Enumerable is IERC721 {
916     /**
917      * @dev Returns the total amount of tokens stored by the contract.
918      */
919     function totalSupply() external view returns (uint256);
920 
921     /**
922      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
923      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
924      */
925     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
926 
927     /**
928      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
929      * Use along with {totalSupply} to enumerate all tokens.
930      */
931     function tokenByIndex(uint256 index) external view returns (uint256);
932 }
933 
934 /**
935  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
936  * enumerability of all the token ids in the contract as well as all token ids owned by each
937  * account.
938  */
939 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
940     // Mapping from owner to list of owned token IDs
941     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
942 
943     // Mapping from token ID to index of the owner tokens list
944     mapping(uint256 => uint256) private _ownedTokensIndex;
945 
946     // Array with all token ids, used for enumeration
947     uint256[] private _allTokens;
948 
949     // Mapping from token id to position in the allTokens array
950     mapping(uint256 => uint256) private _allTokensIndex;
951 
952     /**
953      * @dev See {IERC165-supportsInterface}.
954      */
955     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
956         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
957     }
958 
959     /**
960      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
961      */
962     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
963         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
964         return _ownedTokens[owner][index];
965     }
966 
967     /**
968      * @dev See {IERC721Enumerable-totalSupply}.
969      */
970     function totalSupply() public view virtual override returns (uint256) {
971         return _allTokens.length;
972     }
973 
974     /**
975      * @dev See {IERC721Enumerable-tokenByIndex}.
976      */
977     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
978         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
979         return _allTokens[index];
980     }
981 
982     /**
983      * @dev Hook that is called before any token transfer. This includes minting
984      * and burning.
985      *
986      * Calling conditions:
987      *
988      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
989      * transferred to `to`.
990      * - When `from` is zero, `tokenId` will be minted for `to`.
991      * - When `to` is zero, ``from``'s `tokenId` will be burned.
992      * - `from` cannot be the zero address.
993      * - `to` cannot be the zero address.
994      *
995      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
996      */
997     function _beforeTokenTransfer(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) internal virtual override {
1002         super._beforeTokenTransfer(from, to, tokenId);
1003 
1004         if (from == address(0)) {
1005             _addTokenToAllTokensEnumeration(tokenId);
1006         } else if (from != to) {
1007             _removeTokenFromOwnerEnumeration(from, tokenId);
1008         }
1009         if (to == address(0)) {
1010             _removeTokenFromAllTokensEnumeration(tokenId);
1011         } else if (to != from) {
1012             _addTokenToOwnerEnumeration(to, tokenId);
1013         }
1014     }
1015 
1016     /**
1017      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1018      * @param to address representing the new owner of the given token ID
1019      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1020      */
1021     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1022         uint256 length = ERC721.balanceOf(to);
1023         _ownedTokens[to][length] = tokenId;
1024         _ownedTokensIndex[tokenId] = length;
1025     }
1026 
1027     /**
1028      * @dev Private function to add a token to this extension's token tracking data structures.
1029      * @param tokenId uint256 ID of the token to be added to the tokens list
1030      */
1031     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1032         _allTokensIndex[tokenId] = _allTokens.length;
1033         _allTokens.push(tokenId);
1034     }
1035 
1036     /**
1037      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1038      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1039      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1040      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1041      * @param from address representing the previous owner of the given token ID
1042      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1043      */
1044     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1045         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1046         // then delete the last slot (swap and pop).
1047 
1048         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1049         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1050 
1051         // When the token to delete is the last token, the swap operation is unnecessary
1052         if (tokenIndex != lastTokenIndex) {
1053             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1054 
1055             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1056             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1057         }
1058 
1059         // This also deletes the contents at the last position of the array
1060         delete _ownedTokensIndex[tokenId];
1061         delete _ownedTokens[from][lastTokenIndex];
1062     }
1063 
1064     /**
1065      * @dev Private function to remove a token from this extension's token tracking data structures.
1066      * This has O(1) time complexity, but alters the order of the _allTokens array.
1067      * @param tokenId uint256 ID of the token to be removed from the tokens list
1068      */
1069     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1070         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1071         // then delete the last slot (swap and pop).
1072 
1073         uint256 lastTokenIndex = _allTokens.length - 1;
1074         uint256 tokenIndex = _allTokensIndex[tokenId];
1075 
1076         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1077         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1078         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1079         uint256 lastTokenId = _allTokens[lastTokenIndex];
1080 
1081         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1082         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1083 
1084         // This also deletes the contents at the last position of the array
1085         delete _allTokensIndex[tokenId];
1086         _allTokens.pop();
1087     }
1088 }
1089 
1090 /**
1091  * @dev ERC721 token with storage based token URI management.
1092  */
1093 abstract contract ERC721URIStorage is ERC721 {
1094     using Strings for uint256;
1095 
1096     // Optional mapping for token URIs
1097     mapping(uint256 => string) _tokenURIs;
1098 
1099     /**
1100      * @dev See {IERC721Metadata-tokenURI}.
1101      */
1102     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1103         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1104 
1105         string memory _tokenURI = _tokenURIs[tokenId];
1106         string memory base = _baseURI();
1107 
1108         // If there is no base URI, return the token URI.
1109         if (bytes(base).length == 0) {
1110             return _tokenURI;
1111         }
1112         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1113         if (bytes(_tokenURI).length > 0) {
1114             return string(abi.encodePacked(base, _tokenURI));
1115         }
1116 
1117         return super.tokenURI(tokenId);
1118     }
1119 
1120     /**
1121      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1122      *
1123      * Requirements:
1124      *
1125      * - `tokenId` must exist.
1126      */
1127     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1128         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1129         _tokenURIs[tokenId] = _tokenURI;
1130     }
1131 
1132     /**
1133      * @dev Destroys `tokenId`.
1134      * The approval is cleared when the token is burned.
1135      *
1136      * Requirements:
1137      *
1138      * - `tokenId` must exist.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function _burn(uint256 tokenId) internal virtual override {
1143         super._burn(tokenId);
1144 
1145         if (bytes(_tokenURIs[tokenId]).length != 0) {
1146             delete _tokenURIs[tokenId];
1147         }
1148     }
1149 }
1150 
1151 /**
1152  * @dev Contract module which allows children to implement an emergency stop
1153  * mechanism that can be triggered by an authorized account.
1154  *
1155  * This module is used through inheritance. It will make available the
1156  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1157  * the functions of your contract. Note that they will not be pausable by
1158  * simply including this module, only once the modifiers are put in place.
1159  */
1160 abstract contract Pausable is Context {
1161     /**
1162      * @dev Emitted when the pause is triggered by `account`.
1163      */
1164     event Paused(address account);
1165 
1166     /**
1167      * @dev Emitted when the pause is lifted by `account`.
1168      */
1169     event Unpaused(address account);
1170 
1171     bool private _paused;
1172 
1173     /**
1174      * @dev Initializes the contract in paused state.
1175      */
1176     constructor() {
1177         _paused = true;
1178     }
1179 
1180     /**
1181      * @dev Returns true if the contract is paused, and false otherwise.
1182      */
1183     function paused() public view virtual returns (bool) {
1184         return _paused;
1185     }
1186 
1187     /**
1188      * @dev Modifier to make a function callable only when the contract is not paused.
1189      *
1190      * Requirements:
1191      *
1192      * - The contract must not be paused.
1193      */
1194     modifier whenNotPaused() {
1195         require(!paused(), "Pausable: paused");
1196         _;
1197     }
1198 
1199     /**
1200      * @dev Modifier to make a function callable only when the contract is paused.
1201      *
1202      * Requirements:
1203      *
1204      * - The contract must be paused.
1205      */
1206     modifier whenPaused() {
1207         require(paused(), "Pausable: not paused");
1208         _;
1209     }
1210 
1211     /**
1212      * @dev Triggers stopped state.
1213      *
1214      * Requirements:
1215      *
1216      * - The contract must not be paused.
1217      */
1218     function _pause() internal virtual whenNotPaused {
1219         _paused = true;
1220         emit Paused(_msgSender());
1221     }
1222 
1223     /**
1224      * @dev Returns to normal state.
1225      *
1226      * Requirements:
1227      *
1228      * - The contract must be paused.
1229      */
1230     function _unpause() internal virtual whenPaused {
1231         _paused = false;
1232         emit Unpaused(_msgSender());
1233     }
1234 }
1235 
1236 /**
1237  * @dev Contract module which provides a basic access control mechanism, where
1238  * there is an account (an owner) that can be granted exclusive access to
1239  * specific functions.
1240  *
1241  * By default, the owner account will be the one that deploys the contract. This
1242  * can later be changed with {transferOwnership}.
1243  *
1244  * This module is used through inheritance. It will make available the modifier
1245  * `onlyOwner`, which can be applied to your functions to restrict their use to
1246  * the owner.
1247  */
1248 abstract contract Ownable is Context {
1249     address private _owner;
1250 
1251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1252 
1253     /**
1254      * @dev Initializes the contract setting the deployer as the initial owner.
1255      */
1256     constructor() {
1257         _transferOwnership(_msgSender());
1258     }
1259 
1260     /**
1261      * @dev Returns the address of the current owner.
1262      */
1263     function owner() public view virtual returns (address) {
1264         return _owner;
1265     }
1266 
1267     /**
1268      * @dev Throws if called by any account other than the owner.
1269      */
1270     modifier onlyOwner() {
1271         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1272         _;
1273     }
1274 
1275     /**
1276      * @dev Leaves the contract without owner. It will not be possible to call
1277      * `onlyOwner` functions anymore. Can only be called by the current owner.
1278      *
1279      * NOTE: Renouncing ownership will leave the contract without an owner,
1280      * thereby removing any functionality that is only available to the owner.
1281      */
1282     function renounceOwnership() public virtual onlyOwner {
1283         _transferOwnership(address(0));
1284     }
1285 
1286     /**
1287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1288      * Can only be called by the current owner.
1289      */
1290     function transferOwnership(address newOwner) public virtual onlyOwner {
1291         require(newOwner != address(0), "Ownable: new owner is the zero address");
1292         _transferOwnership(newOwner);
1293     }
1294 
1295     /**
1296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1297      * Internal function without access restriction.
1298      */
1299     function _transferOwnership(address newOwner) internal virtual {
1300         address oldOwner = _owner;
1301         _owner = newOwner;
1302         emit OwnershipTransferred(oldOwner, newOwner);
1303     }
1304 }
1305 
1306 /**
1307  * @title ERC721 Burnable Token
1308  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1309  */
1310 abstract contract ERC721Burnable is Context, ERC721 {
1311     /**
1312      * @dev Burns `tokenId`. See {ERC721-_burn}.
1313      *
1314      * Requirements:
1315      *
1316      * - The caller must own `tokenId` or be an approved operator.
1317      */
1318     function burn(uint256 tokenId) public virtual {
1319         //solhint-disable-next-line max-line-length
1320         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1321         _burn(tokenId);
1322     }
1323 }
1324 
1325 interface IERC20 {
1326     function balanceOf(address account) external view returns (uint256);
1327 }
1328 
1329 contract WCINFT is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
1330     bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
1331     bytes4 internal constant _INTERFACE_ID_ROYALTIES_EIP2981 = 0x2a55205a;
1332     using Strings for uint256;
1333 
1334     uint256 public currentId = 1;
1335 
1336     uint256 gas = 5000000;
1337 
1338     address public constant feeReceiver = 0xCa99f437DE3Af9879b58ea9aD8d856c4b586FFAc;
1339 
1340     uint256 private _royaltyBps;
1341     address payable private _royaltyRecipient;
1342 
1343     IERC20 constant WCIContract = IERC20(0xC5a9BC46A7dbe1c6dE493E84A18f02E70E2c5A32);
1344 
1345     uint256 private status = 0;
1346     
1347     uint256 public constant mintingLimit = 10000;
1348 
1349     uint256 public constant price = 6 * 10**16;
1350     uint256 public constant whitelistPrice = 5 * 10**16;
1351 
1352     mapping(address => bool) _whitelist;
1353     uint256 public maxMint = 10;
1354     uint256 public maxWhitelistMint = 20;
1355     string baseURI = "";
1356     string placeholderURI;
1357     string constant baseExtension = ".json";
1358 
1359     uint256 public futureBlock;
1360     uint256 public randomShift;
1361 
1362     constructor() ERC721("Shib's of football by $WCI", "WCI NFT") {
1363       _royaltyBps = 750;
1364       _royaltyRecipient = payable(feeReceiver);
1365     }
1366     
1367     function setBaseURI(string calldata _base, bool randomize) external onlyOwner {
1368         require(randomShift == 0, "Already randomized");
1369         baseURI = _base;
1370         if(randomize) {
1371           require(futureBlock > 0, "Random block not primed, run primeRandom function");
1372           reveal();
1373         }
1374     }
1375 
1376     function setPlaceholderURI(string calldata _placeholder) external onlyOwner {
1377         placeholderURI = _placeholder;
1378     }
1379     
1380     function setMaxMint(uint256 _maxMint, uint256 _maxWhitelistMint) external onlyOwner {
1381         maxMint = _maxMint;
1382         maxWhitelistMint = _maxWhitelistMint;
1383     }
1384 
1385     function _baseURI() internal view override returns (string memory) {
1386         return baseURI;
1387     }
1388 
1389     function pause() public onlyOwner {
1390         _pause();
1391     }
1392 
1393     function unpause() public onlyOwner {
1394         _unpause();
1395     }
1396 
1397     function batchMint(uint256[] calldata amount, address[] calldata _to) external onlyOwner {
1398         require(status == 0, "Cannot airdrop once paid minting has started");
1399       for(uint256 i = 0; i < amount.length; i++) {
1400         _mintNFTs(amount[i], _to[i]);
1401       }
1402     }
1403 
1404    function mint(uint256 amount, address _to) external onlyOwner {
1405        require(status == 0, "Cannot airdrop once paid minting has started");
1406        _mintNFTs(amount, _to);
1407     }
1408 
1409     function mint(uint256 amount) external payable whenNotPaused {
1410         require(status > 0, "Minting not started yet");
1411         bool whitelisted = whitelist(msg.sender);
1412         uint256 limit = whitelisted ? maxWhitelistMint : maxMint;
1413         require(amount <= limit && amount > 0 && balanceOf(msg.sender) + amount <= limit, "Minting limits exceeded");
1414 
1415         bool isHolding = 5000 * 10**9 <= WCIContract.balanceOf(msg.sender);
1416 
1417         if (status == 1) {
1418             require(whitelisted, "Sorry, whitelist minting only");
1419         } else if (status == 2) {
1420             require(isHolding, "You don't have 5,000 $WSI tokens");
1421         }
1422 
1423         unchecked{
1424         uint256 totalCost = (whitelisted || isHolding ? whitelistPrice : price) * amount;
1425         require (msg.value == totalCost, "Incorrect amount paid");
1426         bool success;
1427         (success, ) = feeReceiver.call{value: msg.value}("");
1428         require(success, "Failed to transfer payment");  
1429         }
1430         
1431         _mintNFTs(amount, msg.sender);
1432     }
1433 
1434     function _mintNFTs(uint256 amount, address to) internal {       
1435       uint256 mintId = currentId;
1436 
1437       unchecked{
1438         require ((mintId-1) + amount <= mintingLimit, "Not enough NFTs remaining");
1439         
1440         for (uint256 i = 0; i < amount; i++){
1441             _safeMint(to, mintId);
1442             mintId++;
1443         }
1444         currentId = mintId;
1445       }
1446 
1447       _multiMint(amount, to);
1448     }
1449 
1450     function claimFunds() external onlyOwner {
1451       bool success;
1452       (success, ) = feeReceiver.call{value: address(this).balance}("");      
1453     }
1454 
1455     function setAllowWhiteListMint() external onlyOwner {
1456         status = 1;
1457     }
1458 
1459     function setAllowHolderMint() external onlyOwner {
1460         status = 2;
1461     }
1462 
1463     function setAllowPublicMint() external onlyOwner {
1464         status = 3;
1465     }
1466 
1467     function mintStatus() public view returns (string memory) {
1468         if (status == 1) {
1469             return "Whitelist minting";
1470         } else if (status == 2) {
1471             return "5,000 $WCI holder minting";
1472         } else if (status == 3) {
1473             return "Public minting";
1474         } else return "Minting not open yet";
1475     }
1476 
1477     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1478         internal
1479         override(ERC721, ERC721Enumerable)
1480     {
1481         super._beforeTokenTransfer(from, to, tokenId);
1482     }
1483 
1484     // The following functions are overrides required by Solidity.
1485 
1486     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1487         super._burn(tokenId);
1488     }
1489 
1490     function tokenURI(uint256 _tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
1491         require(_exists(_tokenId), "ERC721URIStorage: URI query for nonexistent token");
1492         string memory _tokenURI = _tokenURIs[_tokenId];
1493         string memory base = _baseURI();
1494 
1495         if (bytes(_tokenURI).length > 0) {
1496             return _tokenURI;
1497         }
1498 
1499         if (bytes(base).length > 0) {
1500             if(randomShift > 0) {
1501               uint256 totalMinted = totalSupply();
1502               uint256 shift = randomShift % totalMinted;
1503               _tokenId += shift;
1504               if (_tokenId > totalMinted) _tokenId -= totalMinted;
1505             }
1506             return concatenate(base, _tokenId.toString(), baseExtension);
1507         }
1508 
1509         if (bytes(placeholderURI).length > 0) {
1510             return placeholderURI;
1511         }
1512 
1513         return super.tokenURI(_tokenId);
1514     } 
1515 
1516     function listMyNFTs(address me, uint256 start, uint256 limit, uint256 _gas) external view returns (uint256[] memory myNFTIDs, string[] memory myNFTuris, uint256 lastId) {
1517         uint256 balance = balanceOf(me);
1518         if (limit == 0) limit = 1;
1519         if (balance > 0) {
1520             if (start >= balance) start = balance-1;
1521             if (start + limit > balance) limit = balance - start;
1522 
1523             myNFTIDs = new uint256[](limit);
1524             myNFTuris = new string[](limit);
1525             
1526             uint256 gasUsed = 0;
1527             uint256 gasLeft = gasleft();
1528             
1529             for (uint256 i=0; gasUsed < (_gas > 0 ? _gas : gas) && i < limit; i++) {
1530                 lastId = i+start;
1531                 uint256 id = tokenOfOwnerByIndex(me, lastId);
1532                 myNFTIDs[i] = id;
1533                 myNFTuris[i] = tokenURI(id);
1534                 
1535                 gasUsed = gasUsed + (gasLeft - gasleft());
1536                 gasLeft = gasleft();
1537             }
1538         }
1539     }
1540 
1541     function remaining() external view returns(uint256) {
1542         return mintingLimit - (currentId-1);
1543     }
1544 
1545     function supportsInterface(bytes4 interfaceId)
1546         public
1547         view
1548         override(ERC721, ERC721Enumerable)
1549         returns (bool)
1550     {
1551         return super.supportsInterface(interfaceId) || interfaceId == _INTERFACE_ID_ROYALTIES_EIP2981;
1552     }
1553 
1554     function updateRoyalties(address payable recipient, uint256 bps) external onlyOwner {
1555         _royaltyRecipient = recipient;
1556         _royaltyBps = bps;
1557     }
1558 
1559     function royaltyInfo(uint256, uint256 value) external view returns (address, uint256) {
1560         return (_royaltyRecipient, value*_royaltyBps/10000);
1561     }
1562 
1563     function loadWhitelist(address[] calldata addressList, bool _listed) external onlyOwner {
1564       for (uint256 i = 0; i < addressList.length; i++) {
1565           _whitelist[addressList[i]] = _listed;
1566       }
1567     }
1568 
1569     function whitelist(address _wallet) public view returns(bool) {
1570         return 35000 * 10**9 <= WCIContract.balanceOf(_wallet) || _whitelist[_wallet];
1571     }
1572 
1573     function primeRandom() external onlyOwner {
1574         require(futureBlock == 0 || (block.number - futureBlock > 256 && randomShift == 0), "Already primed");
1575         futureBlock = block.number + 5;
1576     }
1577 
1578     function reveal() internal {
1579         require(futureBlock != 0, "Randomization not started");
1580         require(randomShift == 0, "Already randomized");
1581         require(block.number >= futureBlock, "Must wait at least 5 blocks");
1582         require(block.number - futureBlock < 256, "Waited too long");
1583         randomShift = uint256(blockhash(futureBlock));
1584     }
1585 
1586     function concatenate(string memory a, string memory b, string memory c) internal pure returns (string memory) {
1587         return string(abi.encodePacked(a, b, c));
1588     }
1589 }