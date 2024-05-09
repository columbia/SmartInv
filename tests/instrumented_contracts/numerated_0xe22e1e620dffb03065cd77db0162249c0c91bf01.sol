1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-04
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-10-27
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2021-10-26
11 */
12 
13 // SPDX-License-Identifier: UNLICENSED
14 
15 pragma solidity 0.8.0;
16 
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19 
20     function toString(uint256 value) internal pure returns (string memory) {
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     function toHexString(uint256 value) internal pure returns (string memory) {
41         if (value == 0) {
42             return "0x00";
43         }
44         uint256 temp = value;
45         uint256 length = 0;
46         while (temp != 0) {
47             length++;
48             temp >>= 8;
49         }
50         return toHexString(value, length);
51     }
52 
53     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
54         bytes memory buffer = new bytes(2 * length + 2);
55         buffer[0] = "0";
56         buffer[1] = "x";
57         for (uint256 i = 2 * length + 1; i > 1; --i) {
58             buffer[i] = _HEX_SYMBOLS[value & 0xf];
59             value >>= 4;
60         }
61         require(value == 0, "Strings: hex length insufficient");
62         return string(buffer);
63     }
64 }
65 
66 
67 
68 abstract contract Context {
69     function _msgSender() internal view virtual returns (address) {
70         return msg.sender;
71     }
72 
73     function _msgData() internal view virtual returns (bytes calldata) {
74         return msg.data;
75     }
76 }
77 
78 
79 
80 abstract contract Ownable is Context {
81     address private _owner;
82 
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     constructor() {
86         _setOwner(_msgSender());
87     }
88 
89     function owner() public view virtual returns (address) {
90         return _owner;
91     }
92 
93     modifier onlyOwner() {
94         require(owner() == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     function renounceOwnership() public virtual onlyOwner {
99         _setOwner(address(0));
100     }
101 
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         _setOwner(newOwner);
105     }
106 
107     function _setOwner(address newOwner) private {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 
115 
116 interface BearToken {
117     function balanceOf(address owner) external view returns (uint256 balance);
118     
119     function allowance(address owner, address spender) external view returns (uint256);
120     
121     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
122 }
123 
124 
125 
126 library Address {
127     function isContract(address account) internal view returns (bool) {
128         uint256 size;
129         assembly {
130             size := extcodesize(account)
131         }
132         return size > 0;
133     }
134 
135     function sendValue(address payable recipient, uint256 amount) internal {
136         require(address(this).balance >= amount, "Address: insufficient balance");
137 
138         (bool success, ) = recipient.call{value: amount}("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
143         return functionCall(target, data, "Address: low-level call failed");
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
148      * `errorMessage` as a fallback revert reason when `target` reverts.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(
153         address target,
154         bytes memory data,
155         string memory errorMessage
156     ) internal returns (bytes memory) {
157         return functionCallWithValue(target, data, 0, errorMessage);
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
162      * but also transferring `value` wei to `target`.
163      *
164      * Requirements:
165      *
166      * - the calling contract must have an ETH balance of at least `value`.
167      * - the called Solidity function must be `payable`.
168      *
169      * _Available since v3.1._
170      */
171     function functionCallWithValue(
172         address target,
173         bytes memory data,
174         uint256 value
175     ) internal returns (bytes memory) {
176         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
181      * with `errorMessage` as a fallback revert reason when `target` reverts.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(
186         address target,
187         bytes memory data,
188         uint256 value,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(address(this).balance >= value, "Address: insufficient balance for call");
192         require(isContract(target), "Address: call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.call{value: value}(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
200      * but performing a static call.
201      *
202      * _Available since v3.3._
203      */
204     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
205         return functionStaticCall(target, data, "Address: low-level static call failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(
215         address target,
216         bytes memory data,
217         string memory errorMessage
218     ) internal view returns (bytes memory) {
219         require(isContract(target), "Address: static call to non-contract");
220 
221         (bool success, bytes memory returndata) = target.staticcall(data);
222         return verifyCallResult(success, returndata, errorMessage);
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
227      * but performing a delegate call.
228      *
229      * _Available since v3.4._
230      */
231     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
232         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(
242         address target,
243         bytes memory data,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         require(isContract(target), "Address: delegate call to non-contract");
247 
248         (bool success, bytes memory returndata) = target.delegatecall(data);
249         return verifyCallResult(success, returndata, errorMessage);
250     }
251 
252     /**
253      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
254      * revert reason using the provided one.
255      *
256      * _Available since v4.3._
257      */
258     function verifyCallResult(
259         bool success,
260         bytes memory returndata,
261         string memory errorMessage
262     ) internal pure returns (bytes memory) {
263         if (success) {
264             return returndata;
265         } else {
266             // Look for revert reason and bubble it up if present
267             if (returndata.length > 0) {
268                 // The easiest way to bubble the revert reason is using memory via assembly
269 
270                 assembly {
271                     let returndata_size := mload(returndata)
272                     revert(add(32, returndata), returndata_size)
273                 }
274             } else {
275                 revert(errorMessage);
276             }
277         }
278     }
279 }
280 
281 
282 
283 interface IERC721Receiver {
284     function onERC721Received(
285         address operator,
286         address from,
287         uint256 tokenId,
288         bytes calldata data
289     ) external returns (bytes4);
290 }
291 
292 
293 
294 interface IERC165 {
295     /**
296      * @dev Returns true if this contract implements the interface defined by
297      * `interfaceId`. See the corresponding
298      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
299      * to learn more about how these ids are created.
300      *
301      * This function call must use less than 30 000 gas.
302      */
303     function supportsInterface(bytes4 interfaceId) external view returns (bool);
304 }
305 
306 
307 
308 abstract contract ERC165 is IERC165 {
309     /**
310      * @dev See {IERC165-supportsInterface}.
311      */
312     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313         return interfaceId == type(IERC165).interfaceId;
314     }
315 }
316 
317 
318 
319 interface IERC721 is IERC165 {
320     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
321 
322     /**
323      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
324      */
325     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
326 
327     /**
328      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
329      */
330     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
331 
332     /**
333      * @dev Returns the number of tokens in ``owner``'s account.
334      */
335     function balanceOf(address owner) external view returns (uint256 balance);
336 
337     /**
338      * @dev Returns the owner of the `tokenId` token.
339      *
340      * Requirements:
341      *
342      * - `tokenId` must exist.
343      */
344     function ownerOf(uint256 tokenId) external view returns (address owner);
345 
346     /**
347      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
348      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
349      *
350      * Requirements:
351      *
352      * - `from` cannot be the zero address.
353      * - `to` cannot be the zero address.
354      * - `tokenId` token must exist and be owned by `from`.
355      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
356      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
357      *
358      * Emits a {Transfer} event.
359      */
360     function safeTransferFrom(
361         address from,
362         address to,
363         uint256 tokenId
364     ) external;
365 
366     /**
367      * @dev Transfers `tokenId` token from `from` to `to`.
368      *
369      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
370      *
371      * Requirements:
372      *
373      * - `from` cannot be the zero address.
374      * - `to` cannot be the zero address.
375      * - `tokenId` token must be owned by `from`.
376      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transferFrom(
381         address from,
382         address to,
383         uint256 tokenId
384     ) external;
385 
386     /**
387      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
388      * The approval is cleared when the token is transferred.
389      *
390      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
391      *
392      * Requirements:
393      *
394      * - The caller must own the token or be an approved operator.
395      * - `tokenId` must exist.
396      *
397      * Emits an {Approval} event.
398      */
399     function approve(address to, uint256 tokenId) external;
400 
401     /**
402      * @dev Returns the account approved for `tokenId` token.
403      *
404      * Requirements:
405      *
406      * - `tokenId` must exist.
407      */
408     function getApproved(uint256 tokenId) external view returns (address operator);
409 
410     /**
411      * @dev Approve or remove `operator` as an operator for the caller.
412      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
413      *
414      * Requirements:
415      *
416      * - The `operator` cannot be the caller.
417      *
418      * Emits an {ApprovalForAll} event.
419      */
420     function setApprovalForAll(address operator, bool _approved) external;
421 
422     /**
423      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
424      *
425      * See {setApprovalForAll}
426      */
427     function isApprovedForAll(address owner, address operator) external view returns (bool);
428 
429     /**
430      * @dev Safely transfers `tokenId` token from `from` to `to`.
431      *
432      * Requirements:
433      *
434      * - `from` cannot be the zero address.
435      * - `to` cannot be the zero address.
436      * - `tokenId` token must exist and be owned by `from`.
437      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
438      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
439      *
440      * Emits a {Transfer} event.
441      */
442     function safeTransferFrom(
443         address from,
444         address to,
445         uint256 tokenId,
446         bytes calldata data
447     ) external;
448 }
449 
450 
451 
452 interface IERC721Enumerable is IERC721 {
453     /**
454      * @dev Returns the total amount of tokens stored by the contract.
455      */
456     function totalSupply() external view returns (uint256);
457 
458     /**
459      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
460      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
461      */
462     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
463 
464     /**
465      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
466      * Use along with {totalSupply} to enumerate all tokens.
467      */
468     function tokenByIndex(uint256 index) external view returns (uint256);
469 }
470 
471 
472 
473 interface IERC721Metadata is IERC721 {
474     /**
475      * @dev Returns the token collection name.
476      */
477     function name() external view returns (string memory);
478 
479     /**
480      * @dev Returns the token collection symbol.
481      */
482     function symbol() external view returns (string memory);
483 
484     /**
485      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
486      */
487     function tokenURI(uint256 tokenId) external view returns (string memory);
488 }
489 
490 
491 
492 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
493     using Address for address;
494     using Strings for uint256;
495 
496     // Token name
497     string private _name;
498 
499     // Token symbol
500     string private _symbol;
501 
502     // Mapping from token ID to owner address
503     mapping(uint256 => address) private _owners;
504 
505     // Mapping owner address to token count
506     mapping(address => uint256) private _balances;
507 
508     // Mapping from token ID to approved address
509     mapping(uint256 => address) private _tokenApprovals;
510 
511     // Mapping from owner to operator approvals
512     mapping(address => mapping(address => bool)) private _operatorApprovals;
513 
514     /**
515      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
516      */
517     constructor(string memory name_, string memory symbol_) {
518         _name = name_;
519         _symbol = symbol_;
520     }
521 
522     /**
523      * @dev See {IERC165-supportsInterface}.
524      */
525     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
526         return
527             interfaceId == type(IERC721).interfaceId ||
528             interfaceId == type(IERC721Metadata).interfaceId ||
529             super.supportsInterface(interfaceId);
530     }
531 
532     /**
533      * @dev See {IERC721-balanceOf}.
534      */
535     function balanceOf(address owner) public view virtual override returns (uint256) {
536         require(owner != address(0), "ERC721: balance query for the zero address");
537         return _balances[owner];
538     }
539 
540     /**
541      * @dev See {IERC721-ownerOf}.
542      */
543     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
544         address owner = _owners[tokenId];
545         require(owner != address(0), "ERC721: owner query for nonexistent token");
546         return owner;
547     }
548 
549     /**
550      * @dev See {IERC721Metadata-name}.
551      */
552     function name() public view virtual override returns (string memory) {
553         return _name;
554     }
555 
556     /**
557      * @dev See {IERC721Metadata-symbol}.
558      */
559     function symbol() public view virtual override returns (string memory) {
560         return _symbol;
561     }
562 
563     /**
564      * @dev See {IERC721Metadata-tokenURI}.
565      */
566     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
567         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
568 
569         string memory baseURI = _baseURI();
570         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".png")) : "";
571     }
572 
573     /**
574      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
575      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
576      * by default, can be overriden in child contracts.
577      */
578     function _baseURI() internal view virtual returns (string memory) {
579         return "";
580     }
581 
582     /**
583      * @dev See {IERC721-approve}.
584      */
585     function approve(address to, uint256 tokenId) public virtual override {
586         address owner = ERC721.ownerOf(tokenId);
587         require(to != owner, "ERC721: approval to current owner");
588 
589         require(
590             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
591             "ERC721: approve caller is not owner nor approved for all"
592         );
593 
594         _approve(to, tokenId);
595     }
596 
597     /**
598      * @dev See {IERC721-getApproved}.
599      */
600     function getApproved(uint256 tokenId) public view virtual override returns (address) {
601         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
602 
603         return _tokenApprovals[tokenId];
604     }
605 
606     /**
607      * @dev See {IERC721-setApprovalForAll}.
608      */
609     function setApprovalForAll(address operator, bool approved) public virtual override {
610         require(operator != _msgSender(), "ERC721: approve to caller");
611 
612         _operatorApprovals[_msgSender()][operator] = approved;
613         emit ApprovalForAll(_msgSender(), operator, approved);
614     }
615 
616     /**
617      * @dev See {IERC721-isApprovedForAll}.
618      */
619     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
620         return _operatorApprovals[owner][operator];
621     }
622 
623     /**
624      * @dev See {IERC721-transferFrom}.
625      */
626     function transferFrom(
627         address from,
628         address to,
629         uint256 tokenId
630     ) public virtual override {
631         //solhint-disable-next-line max-line-length
632         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
633 
634         _transfer(from, to, tokenId);
635     }
636 
637     /**
638      * @dev See {IERC721-safeTransferFrom}.
639      */
640     function safeTransferFrom(
641         address from,
642         address to,
643         uint256 tokenId
644     ) public virtual override {
645         safeTransferFrom(from, to, tokenId, "");
646     }
647 
648     /**
649      * @dev See {IERC721-safeTransferFrom}.
650      */
651     function safeTransferFrom(
652         address from,
653         address to,
654         uint256 tokenId,
655         bytes memory _data
656     ) public virtual override {
657         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
658         _safeTransfer(from, to, tokenId, _data);
659     }
660 
661     /**
662      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
663      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
664      *
665      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
666      *
667      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
668      * implement alternative mechanisms to perform token transfer, such as signature-based.
669      *
670      * Requirements:
671      *
672      * - `from` cannot be the zero address.
673      * - `to` cannot be the zero address.
674      * - `tokenId` token must exist and be owned by `from`.
675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
676      *
677      * Emits a {Transfer} event.
678      */
679     function _safeTransfer(
680         address from,
681         address to,
682         uint256 tokenId,
683         bytes memory _data
684     ) internal virtual {
685         _transfer(from, to, tokenId);
686         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
687     }
688 
689     /**
690      * @dev Returns whether `tokenId` exists.
691      *
692      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
693      *
694      * Tokens start existing when they are minted (`_mint`),
695      * and stop existing when they are burned (`_burn`).
696      */
697     function _exists(uint256 tokenId) internal view virtual returns (bool) {
698         return _owners[tokenId] != address(0);
699     }
700 
701     /**
702      * @dev Returns whether `spender` is allowed to manage `tokenId`.
703      *
704      * Requirements:
705      *
706      * - `tokenId` must exist.
707      */
708     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
709         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
710         address owner = ERC721.ownerOf(tokenId);
711         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
712     }
713 
714     /**
715      * @dev Safely mints `tokenId` and transfers it to `to`.
716      *
717      * Requirements:
718      *
719      * - `tokenId` must not exist.
720      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
721      *
722      * Emits a {Transfer} event.
723      */
724     function _safeMint(address to, uint256 tokenId) internal virtual {
725         _safeMint(to, tokenId, "");
726     }
727 
728     /**
729      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
730      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
731      */
732     function _safeMint(
733         address to,
734         uint256 tokenId,
735         bytes memory _data
736     ) internal virtual {
737         _mint(to, tokenId);
738         require(
739             _checkOnERC721Received(address(0), to, tokenId, _data),
740             "ERC721: transfer to non ERC721Receiver implementer"
741         );
742         
743         emit Transfer(address(0), to, tokenId);
744         
745     }
746 
747     /**
748      * @dev Mints `tokenId` and transfers it to `to`.
749      *
750      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
751      *
752      * Requirements:
753      *
754      * - `tokenId` must not exist.
755      * - `to` cannot be the zero address.
756      *
757      * Emits a {Transfer} event.
758      */
759     function _mint(address to, uint256 tokenId) internal virtual {
760         require(to != address(0), "ERC721: mint to the zero address");
761         require(!_exists(tokenId), "ERC721: token already minted");
762 
763         _beforeTokenTransfer(address(0), to, tokenId);
764 
765         _balances[to] += 1;
766         _owners[tokenId] = to;
767 
768         emit Transfer(address(0), to, tokenId);
769     }
770 
771     /**
772      * @dev Destroys `tokenId`.
773      * The approval is cleared when the token is burned.
774      *
775      * Requirements:
776      *
777      * - `tokenId` must exist.
778      *
779      * Emits a {Transfer} event.
780      */
781     function _burn(uint256 tokenId) internal virtual {
782         address owner = ERC721.ownerOf(tokenId);
783 
784         _beforeTokenTransfer(owner, address(0), tokenId);
785 
786         // Clear approvals
787         _approve(address(0), tokenId);
788 
789         _balances[owner] -= 1;
790         delete _owners[tokenId];
791 
792         emit Transfer(owner, address(0), tokenId);
793     }
794 
795     /**
796      * @dev Transfers `tokenId` from `from` to `to`.
797      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
798      *
799      * Requirements:
800      *
801      * - `to` cannot be the zero address.
802      * - `tokenId` token must be owned by `from`.
803      *
804      * Emits a {Transfer} event.
805      */
806     function _transfer(
807         address from,
808         address to,
809         uint256 tokenId
810     ) internal virtual {
811         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
812         require(to != address(0), "ERC721: transfer to the zero address");
813 
814         _beforeTokenTransfer(from, to, tokenId);
815 
816         // Clear approvals from the previous owner
817         _approve(address(0), tokenId);
818 
819         _balances[from] -= 1;
820         _balances[to] += 1;
821         _owners[tokenId] = to;
822 
823         emit Transfer(from, to, tokenId);
824     }
825 
826     /**
827      * @dev Approve `to` to operate on `tokenId`
828      *
829      * Emits a {Approval} event.
830      */
831     function _approve(address to, uint256 tokenId) internal virtual {
832         _tokenApprovals[tokenId] = to;
833         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
834     }
835 
836     /**
837      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
838      * The call is not executed if the target address is not a contract.
839      *
840      * @param from address representing the previous owner of the given token ID
841      * @param to target address that will receive the tokens
842      * @param tokenId uint256 ID of the token to be transferred
843      * @param _data bytes optional data to send along with the call
844      * @return bool whether the call correctly returned the expected magic value
845      */
846     function _checkOnERC721Received(
847         address from,
848         address to,
849         uint256 tokenId,
850         bytes memory _data
851     ) private returns (bool) {
852         if (to.isContract()) {
853             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
854                 return retval == IERC721Receiver.onERC721Received.selector;
855             } catch (bytes memory reason) {
856                 if (reason.length == 0) {
857                     revert("ERC721: transfer to non ERC721Receiver implementer");
858                 } else {
859                     assembly {
860                         revert(add(32, reason), mload(reason))
861                     }
862                 }
863             }
864         } else {
865             return true;
866         }
867     }
868 
869     /**
870      * @dev Hook that is called before any token transfer. This includes minting
871      * and burning.
872      *
873      * Calling conditions:
874      *
875      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
876      * transferred to `to`.
877      * - When `from` is zero, `tokenId` will be minted for `to`.
878      * - When `to` is zero, ``from``'s `tokenId` will be burned.
879      * - `from` and `to` are never both zero.
880      *
881      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
882      */
883     function _beforeTokenTransfer(
884         address from,
885         address to,
886         uint256 tokenId
887     ) internal virtual {}
888 }
889 
890 
891 
892 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
893     // Mapping from owner to list of owned token IDs
894     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
895 
896     // Mapping from token ID to index of the owner tokens list
897     mapping(uint256 => uint256) private _ownedTokensIndex;
898 
899     // Array with all token ids, used for enumeration
900     uint256[] private _allTokens;
901 
902     // Mapping from token id to position in the allTokens array
903     mapping(uint256 => uint256) private _allTokensIndex;
904 
905     /**
906      * @dev See {IERC165-supportsInterface}.
907      */
908     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
909         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
910     }
911 
912     /**
913      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
914      */
915     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
916         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
917         return _ownedTokens[owner][index];
918     }
919 
920     /**
921      * @dev See {IERC721Enumerable-totalSupply}.
922      */
923     function totalSupply() public view virtual override returns (uint256) {
924         return _allTokens.length;
925     }
926 
927     /**
928      * @dev See {IERC721Enumerable-tokenByIndex}.
929      */
930     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
931         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
932         return _allTokens[index];
933     }
934 
935     /**
936      * @dev Hook that is called before any token transfer. This includes minting
937      * and burning.
938      *
939      * Calling conditions:
940      *
941      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
942      * transferred to `to`.
943      * - When `from` is zero, `tokenId` will be minted for `to`.
944      * - When `to` is zero, ``from``'s `tokenId` will be burned.
945      * - `from` cannot be the zero address.
946      * - `to` cannot be the zero address.
947      *
948      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
949      */
950     function _beforeTokenTransfer(
951         address from,
952         address to,
953         uint256 tokenId
954     ) internal virtual override {
955         super._beforeTokenTransfer(from, to, tokenId);
956 
957         if (from == address(0)) {
958             _addTokenToAllTokensEnumeration(tokenId);
959         } else if (from != to) {
960             _removeTokenFromOwnerEnumeration(from, tokenId);
961         }
962         if (to == address(0)) {
963             _removeTokenFromAllTokensEnumeration(tokenId);
964         } else if (to != from) {
965             _addTokenToOwnerEnumeration(to, tokenId);
966         }
967     }
968 
969     /**
970      * @dev Private function to add a token to this extension's ownership-tracking data structures.
971      * @param to address representing the new owner of the given token ID
972      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
973      */
974     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
975         uint256 length = ERC721.balanceOf(to);
976         _ownedTokens[to][length] = tokenId;
977         _ownedTokensIndex[tokenId] = length;
978     }
979 
980     /**
981      * @dev Private function to add a token to this extension's token tracking data structures.
982      * @param tokenId uint256 ID of the token to be added to the tokens list
983      */
984     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
985         _allTokensIndex[tokenId] = _allTokens.length;
986         _allTokens.push(tokenId);
987     }
988 
989     /**
990      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
991      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
992      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
993      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
994      * @param from address representing the previous owner of the given token ID
995      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
996      */
997     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
998         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
999         // then delete the last slot (swap and pop).
1000 
1001         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1002         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1003 
1004         // When the token to delete is the last token, the swap operation is unnecessary
1005         if (tokenIndex != lastTokenIndex) {
1006             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1007 
1008             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1009             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1010         }
1011 
1012         // This also deletes the contents at the last position of the array
1013         delete _ownedTokensIndex[tokenId];
1014         delete _ownedTokens[from][lastTokenIndex];
1015     }
1016 
1017     /**
1018      * @dev Private function to remove a token from this extension's token tracking data structures.
1019      * This has O(1) time complexity, but alters the order of the _allTokens array.
1020      * @param tokenId uint256 ID of the token to be removed from the tokens list
1021      */
1022     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1023         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1024         // then delete the last slot (swap and pop).
1025 
1026         uint256 lastTokenIndex = _allTokens.length - 1;
1027         uint256 tokenIndex = _allTokensIndex[tokenId];
1028 
1029         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1030         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1031         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1032         uint256 lastTokenId = _allTokens[lastTokenIndex];
1033 
1034         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1035         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1036 
1037         // This also deletes the contents at the last position of the array
1038         delete _allTokensIndex[tokenId];
1039         _allTokens.pop();
1040     }
1041 }
1042 
1043 
1044 
1045 contract BearX is ERC721Enumerable, Ownable {
1046 
1047     using Strings for uint256;
1048 
1049     string _baseTokenURI;
1050     uint256 public gif = 6;
1051     uint256 public gifIDs = 1000000000000;
1052     uint256 public breed = 5300;
1053     uint256 public breedIDs = 10000000000000;
1054     uint256 public _maxperWalletWhiteList = 2;
1055     uint256 public _maxperTX = 2;
1056     uint256 public _limit = 3644;
1057     uint256 public _reserved = 50;
1058     uint256 public _price = 0.05 ether;
1059     uint256 public whitelist_count  =  0;
1060     address public fundWallet;
1061     bool public _paused = true;
1062     mapping (address => uint256) public perWallet;
1063     mapping (address => bool) public whitelist;
1064     BearToken public TokenContract;
1065     bool public breedStart = false;
1066     uint256 public breedPrice = 1000 ether;
1067 
1068     constructor(string memory baseURI, address _fundWallet) ERC721("BearX", "BearX")  {
1069         require(_fundWallet != address(0), "Zero address error");
1070         setBaseURI(baseURI);
1071         fundWallet = _fundWallet;
1072     }
1073     
1074     function setBearToken (BearToken _TokenContract) public onlyOwner{
1075         // require(_TokenContract != address(0), "Contract address can't be zero address");
1076         TokenContract = _TokenContract;
1077     }
1078     
1079     function getBearToken(address __address) public view returns(uint256) {
1080         require(__address != address(0), "Contract address can't be zero address");
1081         return TokenContract.balanceOf(__address);
1082     }
1083     
1084     function getBearAllowance(address __address) public view returns(uint256) {
1085         require(__address != address(0), "Contract address can't be zero address");
1086         return TokenContract.allowance(__address, address(this));
1087     }
1088     
1089     function MINT_BY_TOKEN(uint256 __id1, uint256 __id2) public payable {
1090         uint256  supply = totalSupply();
1091         require( breedStart == true,        "Breed paused");
1092         require( TokenContract.balanceOf(msg.sender) >= breedPrice,  "You don't have enough tokens");
1093         require( __id1 != __id2 , "Both Token Ids must be different");
1094         require( ownerOf(__id1) == msg.sender, "Caller must be ownerOf Token Id 1");
1095         require( ownerOf(__id2) == msg.sender, "Caller must be ownerOf Token Id 2");
1096 
1097         _safeMint( msg.sender, breedIDs + 1 );
1098         breed--;
1099         breedIDs++;
1100         supply++;
1101         TokenContract.transferFrom(msg.sender, fundWallet, breedPrice);
1102     }
1103 
1104     function MINT(uint256 num) public payable {
1105         uint256 supply = totalSupply();
1106         require( !_paused,                                       "Sale paused" );
1107         require( num <= _maxperTX,                               "You are exceeding limit of per transaction BEARX" );
1108         require( supply + num <= _limit - _reserved,             "Exceeds maximum BEARX supply" );
1109         require( msg.value >= _price * num,                      "Ether sent is not correct" );
1110 
1111         for(uint256 i; i < num; i++){
1112             _safeMint( msg.sender, supply + i );
1113         }
1114     }
1115 
1116     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1117         require( _to !=  address(0), "Zero address error");
1118         require( _amount <= _reserved, "Exceeds reserved bear supply");
1119 
1120         uint256 supply = totalSupply();
1121         for(uint256 i; i < _amount; i++){
1122             _safeMint( _to, supply + i );
1123         }
1124         _reserved -= _amount;
1125     }
1126     
1127     function mint_g(address _to, uint256 _amount) external onlyOwner() {
1128         require( _to !=  address(0), "Zero address error");
1129         require( _amount <= gif, "Exceeds gif supply" );
1130 
1131         for(uint256 i; i < _amount; i++){
1132             _safeMint( _to, gifIDs );
1133             gif --;
1134             gifIDs++;
1135         }
1136     }
1137     
1138     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1139         uint256 tokenCount = balanceOf(_owner);
1140 
1141         uint256[] memory tokensId = new uint256[](tokenCount);
1142         for(uint256 i; i < tokenCount; i++){
1143             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1144         }
1145         return tokensId;
1146     }
1147 
1148     function WHITELIST_MINT(uint256 num) public payable {
1149         uint256 supply = totalSupply();
1150         require( whitelist[msg.sender] == true,                  "Only WHITELIST can mint" );
1151         require( perWallet[msg.sender] + num <= _maxperWalletWhiteList,   "You are exceeding limit of per wallet BEARX" );
1152         require( supply + num <= _limit - _reserved,             "Exceeds maximum BEARX supply" );
1153         require( msg.value >= _price * num,                      "Ether sent is not correct" );
1154 
1155         for(uint256 i; i < num; i++){
1156             _safeMint( msg.sender, supply + i );
1157         }
1158         perWallet[msg.sender] += num;
1159     }
1160 
1161     function bulk_whitelist(address[] memory addresses) public onlyOwner() {
1162         for(uint i=0; i < addresses.length; i++){
1163             address addr = addresses[i];
1164             if(whitelist[addr] != true && addr != address(0)){
1165                 whitelist[addr] = true;
1166                 whitelist_count++;
1167             }
1168         }
1169     }
1170     
1171     function remove_whitelist(address _address) public onlyOwner() {
1172         require(_address != address(0), "Zero address error");
1173         whitelist[_address] = false;
1174         whitelist_count--;
1175     }
1176     
1177     // Just in case Eth does some crazy stuff
1178     function setPrice(uint256 _newPrice) public onlyOwner() {
1179         _price = _newPrice;
1180     }
1181 
1182     function setFundWallet(address _fundWallet) public onlyOwner() {
1183         require(_fundWallet != address(0), "Zero address error");
1184         fundWallet = _fundWallet;
1185     }
1186 
1187     function _baseURI() internal view virtual override returns (string memory) {
1188         return _baseTokenURI;
1189     }
1190 
1191     function setLimit(uint256 limit) public onlyOwner {
1192         _limit = limit;
1193     }
1194 
1195     // function setMaxPerWallet(uint256 limit) public onlyOwner {
1196     //     _maxperTX = limit;
1197     // }
1198 
1199     function setBaseURI(string memory baseURI) public onlyOwner {
1200         _baseTokenURI = baseURI;
1201     }
1202 
1203     // function getPrice() public view returns (uint256){
1204     //     return _price;
1205     // }
1206 
1207     function pause() public onlyOwner {
1208         _paused = !_paused;
1209     }
1210 
1211     function pauseBreed() public onlyOwner {
1212         breedStart = !breedStart;
1213     }
1214 
1215     function withdrawAll() public payable onlyOwner {
1216         require(payable(fundWallet).send(address(this).balance));
1217     }
1218 }