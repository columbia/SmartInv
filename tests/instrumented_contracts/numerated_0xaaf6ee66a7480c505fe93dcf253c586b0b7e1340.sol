1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5     *************        *************      ********************    ********************
6     **          **     **             **            **              **
7     **          **     **             **            **              **
8     **          **     **             **            **              **
9     *************      **             **            **              **************
10     **                 **             **            **              **     
11     **                 **             **            **              **
12     **                 **             **            **              **
13     **                 **             **            **              **
14     **                   *************              **              **          
15 
16     Piggies On The Farm, by Farmer John 
17     
18     The Muddy Buddy everybody needs <3
19 
20     2021       
21 */
22 
23 interface IERC165 {
24     /**
25      * @dev Returns true if this contract implements the interface defined by
26      * `interfaceId`. See the corresponding
27      *
28      * This function call must use less than 30 000 gas.
29      */
30     function supportsInterface(bytes4 interfaceId) external view returns (bool);
31 }
32 
33 //@openzeppelin/contracts/token/ERC721/IERC721.sol
34 pragma solidity ^0.8.0;
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      */
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Emits a {Transfer} event.
69      */
70     function safeTransferFrom(
71         address from,
72         address to,
73         uint256 tokenId
74     ) external;
75 
76     /**
77      * @dev Transfers `tokenId` token from `from` to `to`.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address from,
83         address to,
84         uint256 tokenId
85     ) external;
86 
87     /**
88      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
89      * The approval is cleared when the token is transferred.
90      *
91      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
92      *
93      * Emits an {Approval} event.
94      */
95     function approve(address to, uint256 tokenId) external;
96 
97     /**
98      * @dev Returns the account approved for `tokenId` token.
99      */
100     function getApproved(uint256 tokenId) external view returns (address operator);
101 
102     /**
103      * @dev Approve or remove `operator` as an operator for the caller.
104      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
105      *
106      * Emits an {ApprovalForAll} event.
107      */
108     function setApprovalForAll(address operator, bool _approved) external;
109 
110     /**
111      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
112      *
113      * See {setApprovalForAll}
114      */
115     function isApprovedForAll(address owner, address operator) external view returns (bool);
116 
117     /**
118      * @dev Safely transfers `tokenId` token from `from` to `to`.
119      *
120      * Emits a {Transfer} event.
121      */
122     function safeTransferFrom(
123         address from,
124         address to,
125         uint256 tokenId,
126         bytes calldata data
127     ) external;
128 }
129 
130 
131 //@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
132 pragma solidity ^0.8.0;
133 
134 interface IERC721Enumerable is IERC721 {
135     /**
136      * @dev Returns the total amount of tokens stored by the contract.
137      */
138     function totalSupply() external view returns (uint256);
139 
140     /**
141      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
142      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
143      */
144     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
145 
146     /**
147      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
148      * Use along with {totalSupply} to enumerate all tokens.
149      */
150     function tokenByIndex(uint256 index) external view returns (uint256);
151 }
152 
153 
154 //@openzeppelin/contracts/utils/introspection/ERC165.sol
155 pragma solidity ^0.8.0;
156 /**
157  * @dev Implementation of the {IERC165} interface.
158  */
159 abstract contract ERC165 is IERC165 {
160     /**
161      * @dev See {IERC165-supportsInterface}.
162      */
163     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
164         return interfaceId == type(IERC165).interfaceId;
165     }
166 }
167 
168 //@openzeppelin/contracts/utils/Strings.sol
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @dev String operations.
173  */
174 library Strings {
175     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
176 
177     /**
178      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
179      */
180     function toString(uint256 value) internal pure returns (string memory) {
181 
182         if (value == 0) {
183             return "0";
184         }
185         uint256 temp = value;
186         uint256 digits;
187         while (temp != 0) {
188             digits++;
189             temp /= 10;
190         }
191         bytes memory buffer = new bytes(digits);
192         while (value != 0) {
193             digits -= 1;
194             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
195             value /= 10;
196         }
197         return string(buffer);
198     }
199 
200     /**
201      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
202      */
203     function toHexString(uint256 value) internal pure returns (string memory) {
204         if (value == 0) {
205             return "0x00";
206         }
207         uint256 temp = value;
208         uint256 length = 0;
209         while (temp != 0) {
210             length++;
211             temp >>= 8;
212         }
213         return toHexString(value, length);
214     }
215 
216     /**
217      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
218      */
219     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
220         bytes memory buffer = new bytes(2 * length + 2);
221         buffer[0] = "0";
222         buffer[1] = "x";
223         for (uint256 i = 2 * length + 1; i > 1; --i) {
224             buffer[i] = _HEX_SYMBOLS[value & 0xf];
225             value >>= 4;
226         }
227         require(value == 0, "Strings: hex length insufficient");
228         return string(buffer);
229     }
230 }
231 
232 //@openzeppelin/contracts/utils/Address.sol
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
271      */
272     function sendValue(address payable recipient, uint256 amount) internal {
273         require(address(this).balance >= amount, "Address: insufficient balance");
274 
275         (bool success, ) = recipient.call{value: amount}("");
276         require(success, "Address: unable to send value, recipient may have reverted");
277     }
278 
279     /**
280      * @dev Performs a Solidity function call using a low level `call`. A
281      * plain `call` is an unsafe replacement for a function call: use this
282      * function instead.
283      *
284      * If `target` reverts with a revert reason, it is bubbled up by this
285      * function (like regular Solidity function calls).
286      *
287      * Returns the raw returned data. To convert to the expected return value,
288      */
289     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
290         return functionCall(target, data, "Address: low-level call failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
295      * `errorMessage` as a fallback revert reason when `target` reverts.
296      */
297     function functionCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, 0, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but also transferring `value` wei to `target`.
308      */
309     function functionCallWithValue(
310         address target,
311         bytes memory data,
312         uint256 value
313     ) internal returns (bytes memory) {
314         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
319      * with `errorMessage` as a fallback revert reason when `target` reverts.
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
337      */
338     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
339         return functionStaticCall(target, data, "Address: low-level static call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a static call.
345      */
346     function functionStaticCall(
347         address target,
348         bytes memory data,
349         string memory errorMessage
350     ) internal view returns (bytes memory) {
351         require(isContract(target), "Address: static call to non-contract");
352 
353         (bool success, bytes memory returndata) = target.staticcall(data);
354         return verifyCallResult(success, returndata, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but performing a delegate call.
360      */
361     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
362         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
367      * but performing a delegate call.
368      */
369     function functionDelegateCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         require(isContract(target), "Address: delegate call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.delegatecall(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
382      * revert reason using the provided one.
383      */
384     function verifyCallResult(
385         bool success,
386         bytes memory returndata,
387         string memory errorMessage
388     ) internal pure returns (bytes memory) {
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 //@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
408 pragma solidity ^0.8.0;
409 
410 interface IERC721Metadata is IERC721 {
411     /**
412      * @dev Returns the token collection name.
413      */
414     function name() external view returns (string memory);
415 
416     /**
417      * @dev Returns the token collection symbol.
418      */
419     function symbol() external view returns (string memory);
420 
421     /**
422      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
423      */
424     function tokenURI(uint256 tokenId) external view returns (string memory);
425 }
426 
427 //@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
428 pragma solidity ^0.8.0;
429 
430 interface IERC721Receiver {
431     /**
432      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
433      * by `operator` from `from`, this function is called.
434      */
435     function onERC721Received(
436         address operator,
437         address from,
438         uint256 tokenId,
439         bytes calldata data
440     ) external returns (bytes4);
441 }
442 
443 //@openzeppelin/contracts/utils/Context.sol
444 pragma solidity ^0.8.0;
445 
446 abstract contract Context {
447     function _msgSender() internal view virtual returns (address) {
448         return msg.sender;
449     }
450 
451     function _msgData() internal view virtual returns (bytes calldata) {
452         return msg.data;
453     }
454 }
455 
456 
457 //@openzeppelin/contracts/token/ERC721/ERC721.sol
458 pragma solidity ^0.8.0;
459 
460 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
461     using Address for address;
462     using Strings for uint256;
463 
464     // Token name
465     string private _name;
466 
467     // Token symbol
468     string private _symbol;
469 
470     // Mapping from token ID to owner address
471     mapping(uint256 => address) private _owners;
472 
473     // Mapping owner address to token count
474     mapping(address => uint256) private _balances;
475 
476     // Mapping from token ID to approved address
477     mapping(uint256 => address) private _tokenApprovals;
478 
479     // Mapping from owner to operator approvals
480     mapping(address => mapping(address => bool)) private _operatorApprovals;
481 
482     /**
483      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
484      */
485     constructor(string memory name_, string memory symbol_) {
486         _name = name_;
487         _symbol = symbol_;
488     }
489 
490     /**
491      * @dev See {IERC165-supportsInterface}.
492      */
493     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
494         return
495             interfaceId == type(IERC721).interfaceId ||
496             interfaceId == type(IERC721Metadata).interfaceId ||
497             super.supportsInterface(interfaceId);
498     }
499 
500     /**
501      * @dev See {IERC721-balanceOf}.
502      */
503     function balanceOf(address owner) public view virtual override returns (uint256) {
504         require(owner != address(0), "ERC721: balance query for the zero address");
505         return _balances[owner];
506     }
507 
508     /**
509      * @dev See {IERC721-ownerOf}.
510      */
511     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
512         address owner = _owners[tokenId];
513         require(owner != address(0), "ERC721: owner query for nonexistent token");
514         return owner;
515     }
516 
517     /**
518      * @dev See {IERC721Metadata-name}.
519      */
520     function name() public view virtual override returns (string memory) {
521         return _name;
522     }
523 
524     /**
525      * @dev See {IERC721Metadata-symbol}.
526      */
527     function symbol() public view virtual override returns (string memory) {
528         return _symbol;
529     }
530 
531     /**
532      * @dev See {IERC721Metadata-tokenURI}.
533      */
534     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
535         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
536 
537         string memory baseURI = _baseURI();
538         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
539     }
540 
541     /**
542      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
543      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
544      * by default, can be overriden in child contracts.
545      */
546     function _baseURI() internal view virtual returns (string memory) {
547         return "";
548     }
549 
550     /**
551      * @dev See {IERC721-approve}.
552      */
553     function approve(address to, uint256 tokenId) public virtual override {
554         address owner = ERC721.ownerOf(tokenId);
555         require(to != owner, "ERC721: approval to current owner");
556 
557         require(
558             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
559             "ERC721: approve caller is not owner nor approved for all"
560         );
561 
562         _approve(to, tokenId);
563     }
564 
565     /**
566      * @dev See {IERC721-getApproved}.
567      */
568     function getApproved(uint256 tokenId) public view virtual override returns (address) {
569         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
570 
571         return _tokenApprovals[tokenId];
572     }
573 
574     /**
575      * @dev See {IERC721-setApprovalForAll}.
576      */
577     function setApprovalForAll(address operator, bool approved) public virtual override {
578         require(operator != _msgSender(), "ERC721: approve to caller");
579 
580         _operatorApprovals[_msgSender()][operator] = approved;
581         emit ApprovalForAll(_msgSender(), operator, approved);
582     }
583 
584     /**
585      * @dev See {IERC721-isApprovedForAll}.
586      */
587     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
588         return _operatorApprovals[owner][operator];
589     }
590 
591     /**
592      * @dev See {IERC721-transferFrom}.
593      */
594     function transferFrom(
595         address from,
596         address to,
597         uint256 tokenId
598     ) public virtual override {
599         //solhint-disable-next-line max-line-length
600         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
601 
602         _transfer(from, to, tokenId);
603     }
604 
605     /**
606      * @dev See {IERC721-safeTransferFrom}.
607      */
608     function safeTransferFrom(
609         address from,
610         address to,
611         uint256 tokenId
612     ) public virtual override {
613         safeTransferFrom(from, to, tokenId, "");
614     }
615 
616     /**
617      * @dev See {IERC721-safeTransferFrom}.
618      */
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 tokenId,
623         bytes memory _data
624     ) public virtual override {
625         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
626         _safeTransfer(from, to, tokenId, _data);
627     }
628 
629     /**
630      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
631      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
632      *
633      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
634      * implement alternative mechanisms to perform token transfer, such as signature-based.
635 
636      * Emits a {Transfer} event.
637      */
638     function _safeTransfer(
639         address from,
640         address to,
641         uint256 tokenId,
642         bytes memory _data
643     ) internal virtual {
644         _transfer(from, to, tokenId);
645         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
646     }
647 
648     /**
649      * @dev Returns whether `tokenId` exists.
650      */
651     function _exists(uint256 tokenId) internal view virtual returns (bool) {
652         return _owners[tokenId] != address(0);
653     }
654 
655     /**
656      * @dev Returns whether `spender` is allowed to manage `tokenId`.
657      */
658     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
659         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
660         address owner = ERC721.ownerOf(tokenId);
661         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
662     }
663 
664     /**
665      * @dev Safely mints `tokenId` and transfers it to `to`.
666      *
667      * Emits a {Transfer} event.
668      */
669     function _safeMint(address to, uint256 tokenId) internal virtual {
670         _safeMint(to, tokenId, "");
671     }
672 
673     /**
674      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
675      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
676      */
677     function _safeMint(
678         address to,
679         uint256 tokenId,
680         bytes memory _data
681     ) internal virtual {
682         _mint(to, tokenId);
683         require(
684             _checkOnERC721Received(address(0), to, tokenId, _data),
685             "ERC721: transfer to non ERC721Receiver implementer"
686         );
687     }
688 
689     /**
690      * @dev Mints `tokenId` and transfers it to `to`.
691      *
692      * Emits a {Transfer} event.
693      */
694     function _mint(address to, uint256 tokenId) internal virtual {
695         require(to != address(0), "ERC721: mint to the zero address");
696         require(!_exists(tokenId), "ERC721: token already minted");
697 
698         _beforeTokenTransfer(address(0), to, tokenId);
699 
700         _balances[to] += 1;
701         _owners[tokenId] = to;
702 
703         emit Transfer(address(0), to, tokenId);
704     }
705 
706     /**
707      * @dev Destroys `tokenId`.
708      *
709      * Emits a {Transfer} event.
710      */
711     function _burn(uint256 tokenId) internal virtual {
712         address owner = ERC721.ownerOf(tokenId);
713 
714         _beforeTokenTransfer(owner, address(0), tokenId);
715 
716         // Clear approvals
717         _approve(address(0), tokenId);
718 
719         _balances[owner] -= 1;
720         delete _owners[tokenId];
721 
722         emit Transfer(owner, address(0), tokenId);
723     }
724 
725     /**
726      * @dev Transfers `tokenId` from `from` to `to`.
727      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
728      *
729      * Emits a {Transfer} event.
730      */
731     function _transfer(
732         address from,
733         address to,
734         uint256 tokenId
735     ) internal virtual {
736         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
737         require(to != address(0), "ERC721: transfer to the zero address");
738 
739         _beforeTokenTransfer(from, to, tokenId);
740 
741         // Clear approvals from the previous owner
742         _approve(address(0), tokenId);
743 
744         _balances[from] -= 1;
745         _balances[to] += 1;
746         _owners[tokenId] = to;
747 
748         emit Transfer(from, to, tokenId);
749     }
750 
751     /**
752      * @dev Approve `to` to operate on `tokenId`
753      *
754      * Emits a {Approval} event.
755      */
756     function _approve(address to, uint256 tokenId) internal virtual {
757         _tokenApprovals[tokenId] = to;
758         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
759     }
760 
761     /**
762      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
763      * The call is not executed if the target address is not a contract.
764      *
765      * @param from address representing the previous owner of the given token ID
766      * @param to target address that will receive the tokens
767      * @param tokenId uint256 ID of the token to be transferred
768      * @param _data bytes optional data to send along with the call
769      * @return bool whether the call correctly returned the expected magic value
770      */
771     function _checkOnERC721Received(
772         address from,
773         address to,
774         uint256 tokenId,
775         bytes memory _data
776     ) private returns (bool) {
777         if (to.isContract()) {
778             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
779                 return retval == IERC721Receiver.onERC721Received.selector;
780             } catch (bytes memory reason) {
781                 if (reason.length == 0) {
782                     revert("ERC721: transfer to non ERC721Receiver implementer");
783                 } else {
784                     assembly {
785                         revert(add(32, reason), mload(reason))
786                     }
787                 }
788             }
789         } else {
790             return true;
791         }
792     }
793 
794     /**
795      * @dev Hook that is called before any token transfer. This includes minting
796      * and burning.
797      *
798      * Calling conditions:
799      *
800      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
801      * transferred to `to`.
802      * - When `from` is zero, `tokenId` will be minted for `to`.
803      * - When `to` is zero, ``from``'s `tokenId` will be burned.
804      * - `from` and `to` are never both zero.
805      */
806     function _beforeTokenTransfer(
807         address from,
808         address to,
809         uint256 tokenId
810     ) internal virtual {}
811 }
812 
813 //@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
814 pragma solidity ^0.8.0;
815 
816 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
817     // Mapping from owner to list of owned token IDs
818     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
819 
820     // Mapping from token ID to index of the owner tokens list
821     mapping(uint256 => uint256) private _ownedTokensIndex;
822 
823     // Array with all token ids, used for enumeration
824     uint256[] private _allTokens;
825 
826     // Mapping from token id to position in the allTokens array
827     mapping(uint256 => uint256) private _allTokensIndex;
828 
829     /**
830      * @dev See {IERC165-supportsInterface}.
831      */
832     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
833         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
834     }
835 
836     /**
837      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
838      */
839     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
840         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
841         return _ownedTokens[owner][index];
842     }
843 
844     /**
845      * @dev See {IERC721Enumerable-totalSupply}.
846      */
847     function totalSupply() public view virtual override returns (uint256) {
848         return _allTokens.length;
849     }
850 
851     /**
852      * @dev See {IERC721Enumerable-tokenByIndex}.
853      */
854     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
855         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
856         return _allTokens[index];
857     }
858 
859     /**
860      * @dev Hook that is called before any token transfer. This includes minting
861      * and burning.
862      *
863      * Calling conditions:
864      *
865      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
866      * transferred to `to`.
867      * - When `from` is zero, `tokenId` will be minted for `to`.
868      * - When `to` is zero, ``from``'s `tokenId` will be burned.
869      * - `from` cannot be the zero address.
870      * - `to` cannot be the zero address.
871      */
872     function _beforeTokenTransfer(
873         address from,
874         address to,
875         uint256 tokenId
876     ) internal virtual override {
877         super._beforeTokenTransfer(from, to, tokenId);
878 
879         if (from == address(0)) {
880             _addTokenToAllTokensEnumeration(tokenId);
881         } else if (from != to) {
882             _removeTokenFromOwnerEnumeration(from, tokenId);
883         }
884         if (to == address(0)) {
885             _removeTokenFromAllTokensEnumeration(tokenId);
886         } else if (to != from) {
887             _addTokenToOwnerEnumeration(to, tokenId);
888         }
889     }
890 
891     /**
892      * @dev Private function to add a token to this extension's ownership-tracking data structures.
893      * @param to address representing the new owner of the given token ID
894      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
895      */
896     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
897         uint256 length = ERC721.balanceOf(to);
898         _ownedTokens[to][length] = tokenId;
899         _ownedTokensIndex[tokenId] = length;
900     }
901 
902     /**
903      * @dev Private function to add a token to this extension's token tracking data structures.
904      * @param tokenId uint256 ID of the token to be added to the tokens list
905      */
906     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
907         _allTokensIndex[tokenId] = _allTokens.length;
908         _allTokens.push(tokenId);
909     }
910 
911     /**
912      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
913      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
914      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
915      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
916      * @param from address representing the previous owner of the given token ID
917      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
918      */
919     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
920 
921         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
922         uint256 tokenIndex = _ownedTokensIndex[tokenId];
923 
924         // When the token to delete is the last token, the swap operation is unnecessary
925         if (tokenIndex != lastTokenIndex) {
926             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
927 
928             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
929             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
930         }
931 
932         // This also deletes the contents at the last position of the array
933         delete _ownedTokensIndex[tokenId];
934         delete _ownedTokens[from][lastTokenIndex];
935     }
936 
937     /**
938      * @dev Private function to remove a token from this extension's token tracking data structures.
939      * This has O(1) time complexity, but alters the order of the _allTokens array.
940      * @param tokenId uint256 ID of the token to be removed from the tokens list
941      */
942     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
943 
944         uint256 lastTokenIndex = _allTokens.length - 1;
945         uint256 tokenIndex = _allTokensIndex[tokenId];
946 
947         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
948         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
949         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
950         uint256 lastTokenId = _allTokens[lastTokenIndex];
951 
952         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
953         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
954 
955         // This also deletes the contents at the last position of the array
956         delete _allTokensIndex[tokenId];
957         _allTokens.pop();
958     }
959 }
960 
961 
962 //@openzeppelin/contracts/access/Ownable.sol
963 pragma solidity ^0.8.0;
964 
965 abstract contract Ownable is Context {
966     address private _owner;
967 
968     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
969 
970     /**
971      * @dev Initializes the contract setting the deployer as the initial owner.
972      */
973     constructor() {
974         _setOwner(_msgSender());
975     }
976 
977     /**
978      * @dev Returns the address of the current owner.
979      */
980     function owner() public view virtual returns (address) {
981         return _owner;
982     }
983 
984     /**
985      * @dev Throws if called by any account other than the owner.
986      */
987     modifier onlyOwner() {
988         require(owner() == _msgSender(), "Ownable: caller is not the owner");
989         _;
990     }
991 
992     /**
993      * @dev Leaves the contract without owner. It will not be possible to call
994      * `onlyOwner` functions anymore. Can only be called by the current owner.
995      */
996     function renounceOwnership() public virtual onlyOwner {
997         _setOwner(address(0));
998     }
999 
1000     /**
1001      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1002      * Can only be called by the current owner.
1003      */
1004     function transferOwnership(address newOwner) public virtual onlyOwner {
1005         require(newOwner != address(0), "Ownable: new owner is the zero address");
1006         _setOwner(newOwner);
1007     }
1008 
1009     function _setOwner(address newOwner) private {
1010         address oldOwner = _owner;
1011         _owner = newOwner;
1012         emit OwnershipTransferred(oldOwner, newOwner);
1013     }
1014 }
1015 
1016 pragma solidity >=0.7.0 <0.9.0;
1017 
1018 contract PiggiesOnTheFarm is ERC721Enumerable, Ownable {
1019   using Strings for uint256;
1020 
1021   string baseURI;
1022   string public baseExtension = ".json";
1023   uint256 public cost = 0.02 ether;
1024   uint256 public maxSupply = 9999;
1025   uint256 public maxMintAmount = 20;
1026   bool public paused = true;
1027   bool public revealed = true;
1028 
1029   constructor(
1030     string memory _name,
1031     string memory _symbol,
1032     string memory _initBaseURI
1033   ) ERC721(_name, _symbol) {
1034     setBaseURI(_initBaseURI);
1035   }
1036 
1037   // internal
1038   function _baseURI() internal view virtual override returns (string memory) {
1039     return baseURI;
1040   }
1041 
1042   // public
1043   function mint(uint256 _mintAmount) public payable {
1044     uint256 supply = totalSupply();
1045     require(!paused);
1046     require(_mintAmount > 0);
1047     require(_mintAmount <= maxMintAmount);
1048     require(supply + _mintAmount <= maxSupply);
1049 
1050     if (msg.sender != owner()) {
1051       require(msg.value >= cost * _mintAmount);
1052     }
1053 
1054     for (uint256 i = 1; i <= _mintAmount; i++) {
1055       _safeMint(msg.sender, supply + i);
1056     }
1057   }
1058 
1059   function walletOfOwner(address _owner)
1060     public
1061     view
1062     returns (uint256[] memory)
1063   {
1064     uint256 ownerTokenCount = balanceOf(_owner);
1065     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1066     for (uint256 i; i < ownerTokenCount; i++) {
1067       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1068     }
1069     return tokenIds;
1070   }
1071 
1072   function tokenURI(uint256 tokenId)
1073     public
1074     view
1075     virtual
1076     override
1077     returns (string memory)
1078   {
1079     require(
1080       _exists(tokenId),
1081       "ERC721Metadata: URI query for nonexistent token"
1082     );
1083 
1084     string memory currentBaseURI = _baseURI();
1085     return bytes(currentBaseURI).length > 0
1086         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1087         : "";
1088   }
1089 
1090   //only owner
1091   function reveal() public onlyOwner() {
1092       revealed = true;
1093   }
1094   
1095   function setCost(uint256 _newCost) public onlyOwner() {
1096     cost = _newCost;
1097   }
1098 
1099   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1100     maxMintAmount = _newmaxMintAmount;
1101   }
1102   
1103   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1104     baseURI = _newBaseURI;
1105   }
1106 
1107   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1108     baseExtension = _newBaseExtension;
1109   }
1110 
1111   function pause(bool _state) public onlyOwner {
1112     paused = _state;
1113   }
1114  
1115   function withdraw() public payable onlyOwner {
1116     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1117     require(success);
1118   }
1119 }