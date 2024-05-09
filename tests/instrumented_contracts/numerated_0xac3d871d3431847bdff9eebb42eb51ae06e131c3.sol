1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.0;
4 
5 library Strings {
6     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
7 
8     function toString(uint256 value) internal pure returns (string memory) {
9 
10         if (value == 0) {
11             return "0";
12         }
13         uint256 temp = value;
14         uint256 digits;
15         while (temp != 0) {
16             digits++;
17             temp /= 10;
18         }
19         bytes memory buffer = new bytes(digits);
20         while (value != 0) {
21             digits -= 1;
22             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
23             value /= 10;
24         }
25         return string(buffer);
26     }
27 
28     function toHexString(uint256 value) internal pure returns (string memory) {
29         if (value == 0) {
30             return "0x00";
31         }
32         uint256 temp = value;
33         uint256 length = 0;
34         while (temp != 0) {
35             length++;
36             temp >>= 8;
37         }
38         return toHexString(value, length);
39     }
40 
41     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
42         bytes memory buffer = new bytes(2 * length + 2);
43         buffer[0] = "0";
44         buffer[1] = "x";
45         for (uint256 i = 2 * length + 1; i > 1; --i) {
46             buffer[i] = _HEX_SYMBOLS[value & 0xf];
47             value >>= 4;
48         }
49         require(value == 0, "Strings: hex length insufficient");
50         return string(buffer);
51     }
52 }
53 
54 
55 
56 abstract contract Context {
57     function _msgSender() internal view virtual returns (address) {
58         return msg.sender;
59     }
60 
61     function _msgData() internal view virtual returns (bytes calldata) {
62         return msg.data;
63     }
64 }
65 
66 
67 
68 abstract contract Ownable is Context {
69     address private _owner;
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor() {
74         _setOwner(_msgSender());
75     }
76 
77     function owner() public view virtual returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         _setOwner(address(0));
88     }
89 
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _setOwner(newOwner);
93     }
94 
95     function _setOwner(address newOwner) private {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 
103 
104 library Address {
105     function isContract(address account) internal view returns (bool) {
106         uint256 size;
107         assembly {
108             size := extcodesize(account)
109         }
110         return size > 0;
111     }
112 
113     function sendValue(address payable recipient, uint256 amount) internal {
114         require(address(this).balance >= amount, "Address: insufficient balance");
115 
116         (bool success, ) = recipient.call{value: amount}("");
117         require(success, "Address: unable to send value, recipient may have reverted");
118     }
119 
120     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
121         return functionCall(target, data, "Address: low-level call failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
126      * `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCall(
131         address target,
132         bytes memory data,
133         string memory errorMessage
134     ) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, 0, errorMessage);
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
140      * but also transferring `value` wei to `target`.
141      *
142      * Requirements:
143      *
144      * - the calling contract must have an ETH balance of at least `value`.
145      * - the called Solidity function must be `payable`.
146      *
147      * _Available since v3.1._
148      */
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value
153     ) internal returns (bytes memory) {
154         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
159      * with `errorMessage` as a fallback revert reason when `target` reverts.
160      *
161      * _Available since v3.1._
162      */
163     function functionCallWithValue(
164         address target,
165         bytes memory data,
166         uint256 value,
167         string memory errorMessage
168     ) internal returns (bytes memory) {
169         require(address(this).balance >= value, "Address: insufficient balance for call");
170         require(isContract(target), "Address: call to non-contract");
171 
172         (bool success, bytes memory returndata) = target.call{value: value}(data);
173         return verifyCallResult(success, returndata, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but performing a static call.
179      *
180      * _Available since v3.3._
181      */
182     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
183         return functionStaticCall(target, data, "Address: low-level static call failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
188      * but performing a static call.
189      *
190      * _Available since v3.3._
191      */
192     function functionStaticCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal view returns (bytes memory) {
197         require(isContract(target), "Address: static call to non-contract");
198 
199         (bool success, bytes memory returndata) = target.staticcall(data);
200         return verifyCallResult(success, returndata, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but performing a delegate call.
206      *
207      * _Available since v3.4._
208      */
209     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
210         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
215      * but performing a delegate call.
216      *
217      * _Available since v3.4._
218      */
219     function functionDelegateCall(
220         address target,
221         bytes memory data,
222         string memory errorMessage
223     ) internal returns (bytes memory) {
224         require(isContract(target), "Address: delegate call to non-contract");
225 
226         (bool success, bytes memory returndata) = target.delegatecall(data);
227         return verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     /**
231      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
232      * revert reason using the provided one.
233      *
234      * _Available since v4.3._
235      */
236     function verifyCallResult(
237         bool success,
238         bytes memory returndata,
239         string memory errorMessage
240     ) internal pure returns (bytes memory) {
241         if (success) {
242             return returndata;
243         } else {
244             // Look for revert reason and bubble it up if present
245             if (returndata.length > 0) {
246                 // The easiest way to bubble the revert reason is using memory via assembly
247 
248                 assembly {
249                     let returndata_size := mload(returndata)
250                     revert(add(32, returndata), returndata_size)
251                 }
252             } else {
253                 revert(errorMessage);
254             }
255         }
256     }
257 }
258 
259 
260 
261 interface IERC721Receiver {
262     function onERC721Received(
263         address operator,
264         address from,
265         uint256 tokenId,
266         bytes calldata data
267     ) external returns (bytes4);
268 }
269 
270 
271 
272 interface IERC165 {
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 }
283 
284 
285 
286 abstract contract ERC165 is IERC165 {
287     /**
288      * @dev See {IERC165-supportsInterface}.
289      */
290     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
291         return interfaceId == type(IERC165).interfaceId;
292     }
293 }
294 
295 
296 
297 interface IERC721 is IERC165 {
298     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
299 
300     /**
301      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
302      */
303     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
304 
305     /**
306      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
307      */
308     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
309 
310     /**
311      * @dev Returns the number of tokens in ``owner``'s account.
312      */
313     function balanceOf(address owner) external view returns (uint256 balance);
314 
315     /**
316      * @dev Returns the owner of the `tokenId` token.
317      *
318      * Requirements:
319      *
320      * - `tokenId` must exist.
321      */
322     function ownerOf(uint256 tokenId) external view returns (address owner);
323 
324     /**
325      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
326      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
327      *
328      * Requirements:
329      *
330      * - `from` cannot be the zero address.
331      * - `to` cannot be the zero address.
332      * - `tokenId` token must exist and be owned by `from`.
333      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
334      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
335      *
336      * Emits a {Transfer} event.
337      */
338     function safeTransferFrom(
339         address from,
340         address to,
341         uint256 tokenId
342     ) external;
343 
344     /**
345      * @dev Transfers `tokenId` token from `from` to `to`.
346      *
347      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
348      *
349      * Requirements:
350      *
351      * - `from` cannot be the zero address.
352      * - `to` cannot be the zero address.
353      * - `tokenId` token must be owned by `from`.
354      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
355      *
356      * Emits a {Transfer} event.
357      */
358     function transferFrom(
359         address from,
360         address to,
361         uint256 tokenId
362     ) external;
363 
364     /**
365      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
366      * The approval is cleared when the token is transferred.
367      *
368      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
369      *
370      * Requirements:
371      *
372      * - The caller must own the token or be an approved operator.
373      * - `tokenId` must exist.
374      *
375      * Emits an {Approval} event.
376      */
377     function approve(address to, uint256 tokenId) external;
378 
379     /**
380      * @dev Returns the account approved for `tokenId` token.
381      *
382      * Requirements:
383      *
384      * - `tokenId` must exist.
385      */
386     function getApproved(uint256 tokenId) external view returns (address operator);
387 
388     /**
389      * @dev Approve or remove `operator` as an operator for the caller.
390      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
391      *
392      * Requirements:
393      *
394      * - The `operator` cannot be the caller.
395      *
396      * Emits an {ApprovalForAll} event.
397      */
398     function setApprovalForAll(address operator, bool _approved) external;
399 
400     /**
401      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
402      *
403      * See {setApprovalForAll}
404      */
405     function isApprovedForAll(address owner, address operator) external view returns (bool);
406 
407     /**
408      * @dev Safely transfers `tokenId` token from `from` to `to`.
409      *
410      * Requirements:
411      *
412      * - `from` cannot be the zero address.
413      * - `to` cannot be the zero address.
414      * - `tokenId` token must exist and be owned by `from`.
415      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
416      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
417      *
418      * Emits a {Transfer} event.
419      */
420     function safeTransferFrom(
421         address from,
422         address to,
423         uint256 tokenId,
424         bytes calldata data
425     ) external;
426 }
427 
428 
429 
430 interface IERC721Enumerable is IERC721 {
431     /**
432      * @dev Returns the total amount of tokens stored by the contract.
433      */
434     function totalSupply() external view returns (uint256);
435 
436     /**
437      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
438      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
439      */
440     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
441 
442     /**
443      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
444      * Use along with {totalSupply} to enumerate all tokens.
445      */
446     function tokenByIndex(uint256 index) external view returns (uint256);
447 }
448 
449 
450 
451 interface IERC721Metadata is IERC721 {
452     /**
453      * @dev Returns the token collection name.
454      */
455     function name() external view returns (string memory);
456 
457     /**
458      * @dev Returns the token collection symbol.
459      */
460     function symbol() external view returns (string memory);
461 
462     /**
463      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
464      */
465     function tokenURI(uint256 tokenId) external view returns (string memory);
466 }
467 
468 
469 
470 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
471     using Address for address;
472     using Strings for uint256;
473 
474     // Token name
475     string private _name;
476 
477     // Token symbol
478     string private _symbol;
479 
480     // Mapping from token ID to owner address
481     mapping(uint256 => address) private _owners;
482 
483     // Mapping owner address to token count
484     mapping(address => uint256) private _balances;
485 
486     // Mapping from token ID to approved address
487     mapping(uint256 => address) private _tokenApprovals;
488 
489     // Mapping from owner to operator approvals
490     mapping(address => mapping(address => bool)) private _operatorApprovals;
491 
492     /**
493      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
494      */
495     constructor(string memory name_, string memory symbol_) {
496         _name = name_;
497         _symbol = symbol_;
498     }
499 
500     /**
501      * @dev See {IERC165-supportsInterface}.
502      */
503     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
504         return
505             interfaceId == type(IERC721).interfaceId ||
506             interfaceId == type(IERC721Metadata).interfaceId ||
507             super.supportsInterface(interfaceId);
508     }
509 
510     /**
511      * @dev See {IERC721-balanceOf}.
512      */
513     function balanceOf(address owner) public view virtual override returns (uint256) {
514         require(owner != address(0), "ERC721: balance query for the zero address");
515         return _balances[owner];
516     }
517 
518     /**
519      * @dev See {IERC721-ownerOf}.
520      */
521     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
522         address owner = _owners[tokenId];
523         require(owner != address(0), "ERC721: owner query for nonexistent token");
524         return owner;
525     }
526 
527     /**
528      * @dev See {IERC721Metadata-name}.
529      */
530     function name() public view virtual override returns (string memory) {
531         return _name;
532     }
533 
534     /**
535      * @dev See {IERC721Metadata-symbol}.
536      */
537     function symbol() public view virtual override returns (string memory) {
538         return _symbol;
539     }
540 
541     /**
542      * @dev See {IERC721Metadata-tokenURI}.
543      */
544     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
545         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
546 
547         string memory baseURI = _baseURI();
548         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
549     }
550 
551     /**
552      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
553      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
554      * by default, can be overriden in child contracts.
555      */
556     function _baseURI() internal view virtual returns (string memory) {
557         return "";
558     }
559 
560     /**
561      * @dev See {IERC721-approve}.
562      */
563     function approve(address to, uint256 tokenId) public virtual override {
564         address owner = ERC721.ownerOf(tokenId);
565         require(to != owner, "ERC721: approval to current owner");
566 
567         require(
568             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
569             "ERC721: approve caller is not owner nor approved for all"
570         );
571 
572         _approve(to, tokenId);
573     }
574 
575     /**
576      * @dev See {IERC721-getApproved}.
577      */
578     function getApproved(uint256 tokenId) public view virtual override returns (address) {
579         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
580 
581         return _tokenApprovals[tokenId];
582     }
583 
584     /**
585      * @dev See {IERC721-setApprovalForAll}.
586      */
587     function setApprovalForAll(address operator, bool approved) public virtual override {
588         require(operator != _msgSender(), "ERC721: approve to caller");
589 
590         _operatorApprovals[_msgSender()][operator] = approved;
591         emit ApprovalForAll(_msgSender(), operator, approved);
592     }
593 
594     /**
595      * @dev See {IERC721-isApprovedForAll}.
596      */
597     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
598         return _operatorApprovals[owner][operator];
599     }
600 
601     /**
602      * @dev See {IERC721-transferFrom}.
603      */
604     function transferFrom(
605         address from,
606         address to,
607         uint256 tokenId
608     ) public virtual override {
609         //solhint-disable-next-line max-line-length
610         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
611 
612         _transfer(from, to, tokenId);
613     }
614 
615     /**
616      * @dev See {IERC721-safeTransferFrom}.
617      */
618     function safeTransferFrom(
619         address from,
620         address to,
621         uint256 tokenId
622     ) public virtual override {
623         safeTransferFrom(from, to, tokenId, "");
624     }
625 
626     /**
627      * @dev See {IERC721-safeTransferFrom}.
628      */
629     function safeTransferFrom(
630         address from,
631         address to,
632         uint256 tokenId,
633         bytes memory _data
634     ) public virtual override {
635         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
636         _safeTransfer(from, to, tokenId, _data);
637     }
638 
639     /**
640      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
641      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
642      *
643      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
644      *
645      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
646      * implement alternative mechanisms to perform token transfer, such as signature-based.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must exist and be owned by `from`.
653      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
654      *
655      * Emits a {Transfer} event.
656      */
657     function _safeTransfer(
658         address from,
659         address to,
660         uint256 tokenId,
661         bytes memory _data
662     ) internal virtual {
663         _transfer(from, to, tokenId);
664         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
665     }
666 
667     /**
668      * @dev Returns whether `tokenId` exists.
669      *
670      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
671      *
672      * Tokens start existing when they are minted (`_mint`),
673      * and stop existing when they are burned (`_burn`).
674      */
675     function _exists(uint256 tokenId) internal view virtual returns (bool) {
676         return _owners[tokenId] != address(0);
677     }
678 
679     /**
680      * @dev Returns whether `spender` is allowed to manage `tokenId`.
681      *
682      * Requirements:
683      *
684      * - `tokenId` must exist.
685      */
686     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
687         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
688         address owner = ERC721.ownerOf(tokenId);
689         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
690     }
691 
692     /**
693      * @dev Safely mints `tokenId` and transfers it to `to`.
694      *
695      * Requirements:
696      *
697      * - `tokenId` must not exist.
698      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
699      *
700      * Emits a {Transfer} event.
701      */
702     function _safeMint(address to, uint256 tokenId) internal virtual {
703         _safeMint(to, tokenId, "");
704     }
705 
706     /**
707      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
708      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
709      */
710     function _safeMint(
711         address to,
712         uint256 tokenId,
713         bytes memory _data
714     ) internal virtual {
715         _mint(to, tokenId);
716         require(
717             _checkOnERC721Received(address(0), to, tokenId, _data),
718             "ERC721: transfer to non ERC721Receiver implementer"
719         );
720         
721         emit Transfer(address(0), to, tokenId);
722         
723     }
724 
725     /**
726      * @dev Mints `tokenId` and transfers it to `to`.
727      *
728      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
729      *
730      * Requirements:
731      *
732      * - `tokenId` must not exist.
733      * - `to` cannot be the zero address.
734      *
735      * Emits a {Transfer} event.
736      */
737     function _mint(address to, uint256 tokenId) internal virtual {
738         require(to != address(0), "ERC721: mint to the zero address");
739         require(!_exists(tokenId), "ERC721: token already minted");
740 
741         _beforeTokenTransfer(address(0), to, tokenId);
742 
743         _balances[to] += 1;
744         _owners[tokenId] = to;
745 
746         emit Transfer(address(0), to, tokenId);
747     }
748 
749     /**
750      * @dev Destroys `tokenId`.
751      * The approval is cleared when the token is burned.
752      *
753      * Requirements:
754      *
755      * - `tokenId` must exist.
756      *
757      * Emits a {Transfer} event.
758      */
759     function _burn(uint256 tokenId) internal virtual {
760         address owner = ERC721.ownerOf(tokenId);
761 
762         _beforeTokenTransfer(owner, address(0), tokenId);
763 
764         // Clear approvals
765         _approve(address(0), tokenId);
766 
767         _balances[owner] -= 1;
768         delete _owners[tokenId];
769 
770         emit Transfer(owner, address(0), tokenId);
771     }
772 
773     /**
774      * @dev Transfers `tokenId` from `from` to `to`.
775      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
776      *
777      * Requirements:
778      *
779      * - `to` cannot be the zero address.
780      * - `tokenId` token must be owned by `from`.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _transfer(
785         address from,
786         address to,
787         uint256 tokenId
788     ) internal virtual {
789         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
790         require(to != address(0), "ERC721: transfer to the zero address");
791 
792         _beforeTokenTransfer(from, to, tokenId);
793 
794         // Clear approvals from the previous owner
795         _approve(address(0), tokenId);
796 
797         _balances[from] -= 1;
798         _balances[to] += 1;
799         _owners[tokenId] = to;
800 
801         emit Transfer(from, to, tokenId);
802     }
803 
804     /**
805      * @dev Approve `to` to operate on `tokenId`
806      *
807      * Emits a {Approval} event.
808      */
809     function _approve(address to, uint256 tokenId) internal virtual {
810         _tokenApprovals[tokenId] = to;
811         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
812     }
813 
814     /**
815      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
816      * The call is not executed if the target address is not a contract.
817      *
818      * @param from address representing the previous owner of the given token ID
819      * @param to target address that will receive the tokens
820      * @param tokenId uint256 ID of the token to be transferred
821      * @param _data bytes optional data to send along with the call
822      * @return bool whether the call correctly returned the expected magic value
823      */
824     function _checkOnERC721Received(
825         address from,
826         address to,
827         uint256 tokenId,
828         bytes memory _data
829     ) private returns (bool) {
830         if (to.isContract()) {
831             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
832                 return retval == IERC721Receiver.onERC721Received.selector;
833             } catch (bytes memory reason) {
834                 if (reason.length == 0) {
835                     revert("ERC721: transfer to non ERC721Receiver implementer");
836                 } else {
837                     assembly {
838                         revert(add(32, reason), mload(reason))
839                     }
840                 }
841             }
842         } else {
843             return true;
844         }
845     }
846 
847     /**
848      * @dev Hook that is called before any token transfer. This includes minting
849      * and burning.
850      *
851      * Calling conditions:
852      *
853      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
854      * transferred to `to`.
855      * - When `from` is zero, `tokenId` will be minted for `to`.
856      * - When `to` is zero, ``from``'s `tokenId` will be burned.
857      * - `from` and `to` are never both zero.
858      *
859      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
860      */
861     function _beforeTokenTransfer(
862         address from,
863         address to,
864         uint256 tokenId
865     ) internal virtual {}
866 }
867 
868 
869 
870 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
871     // Mapping from owner to list of owned token IDs
872     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
873 
874     // Mapping from token ID to index of the owner tokens list
875     mapping(uint256 => uint256) private _ownedTokensIndex;
876 
877     // Array with all token ids, used for enumeration
878     uint256[] private _allTokens;
879 
880     // Mapping from token id to position in the allTokens array
881     mapping(uint256 => uint256) private _allTokensIndex;
882 
883     /**
884      * @dev See {IERC165-supportsInterface}.
885      */
886     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
887         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
888     }
889 
890     /**
891      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
892      */
893     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
894         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
895         return _ownedTokens[owner][index];
896     }
897 
898     /**
899      * @dev See {IERC721Enumerable-totalSupply}.
900      */
901     function totalSupply() public view virtual override returns (uint256) {
902         return _allTokens.length;
903     }
904 
905     /**
906      * @dev See {IERC721Enumerable-tokenByIndex}.
907      */
908     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
909         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
910         return _allTokens[index];
911     }
912 
913     /**
914      * @dev Hook that is called before any token transfer. This includes minting
915      * and burning.
916      *
917      * Calling conditions:
918      *
919      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
920      * transferred to `to`.
921      * - When `from` is zero, `tokenId` will be minted for `to`.
922      * - When `to` is zero, ``from``'s `tokenId` will be burned.
923      * - `from` cannot be the zero address.
924      * - `to` cannot be the zero address.
925      *
926      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
927      */
928     function _beforeTokenTransfer(
929         address from,
930         address to,
931         uint256 tokenId
932     ) internal virtual override {
933         super._beforeTokenTransfer(from, to, tokenId);
934 
935         if (from == address(0)) {
936             _addTokenToAllTokensEnumeration(tokenId);
937         } else if (from != to) {
938             _removeTokenFromOwnerEnumeration(from, tokenId);
939         }
940         if (to == address(0)) {
941             _removeTokenFromAllTokensEnumeration(tokenId);
942         } else if (to != from) {
943             _addTokenToOwnerEnumeration(to, tokenId);
944         }
945     }
946 
947     /**
948      * @dev Private function to add a token to this extension's ownership-tracking data structures.
949      * @param to address representing the new owner of the given token ID
950      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
951      */
952     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
953         uint256 length = ERC721.balanceOf(to);
954         _ownedTokens[to][length] = tokenId;
955         _ownedTokensIndex[tokenId] = length;
956     }
957 
958     /**
959      * @dev Private function to add a token to this extension's token tracking data structures.
960      * @param tokenId uint256 ID of the token to be added to the tokens list
961      */
962     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
963         _allTokensIndex[tokenId] = _allTokens.length;
964         _allTokens.push(tokenId);
965     }
966 
967     /**
968      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
969      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
970      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
971      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
972      * @param from address representing the previous owner of the given token ID
973      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
974      */
975     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
976         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
977         // then delete the last slot (swap and pop).
978 
979         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
980         uint256 tokenIndex = _ownedTokensIndex[tokenId];
981 
982         // When the token to delete is the last token, the swap operation is unnecessary
983         if (tokenIndex != lastTokenIndex) {
984             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
985 
986             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
987             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
988         }
989 
990         // This also deletes the contents at the last position of the array
991         delete _ownedTokensIndex[tokenId];
992         delete _ownedTokens[from][lastTokenIndex];
993     }
994 
995     /**
996      * @dev Private function to remove a token from this extension's token tracking data structures.
997      * This has O(1) time complexity, but alters the order of the _allTokens array.
998      * @param tokenId uint256 ID of the token to be removed from the tokens list
999      */
1000     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1001         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1002         // then delete the last slot (swap and pop).
1003 
1004         uint256 lastTokenIndex = _allTokens.length - 1;
1005         uint256 tokenIndex = _allTokensIndex[tokenId];
1006 
1007         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1008         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1009         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1010         uint256 lastTokenId = _allTokens[lastTokenIndex];
1011 
1012         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1013         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1014 
1015         // This also deletes the contents at the last position of the array
1016         delete _allTokensIndex[tokenId];
1017         _allTokens.pop();
1018     }
1019 }
1020 
1021 
1022 
1023 contract NFTgurus is ERC721Enumerable, Ownable {
1024 
1025     using Strings for uint256;
1026 
1027     string _baseTokenURI;
1028     uint256 public _maxperTX = 77;
1029     uint256 public _limit = 1100;
1030     uint256 public _reserved = 323;
1031     uint256 public _price = 0.09 ether;
1032     address public fundWallet;
1033     bool public _paused = true;
1034 
1035     constructor(string memory baseURI, address _fundWallet) ERC721("NFT Gurus", "GURU")  {
1036         require(_fundWallet != address(0), "Zero address error");
1037         setBaseURI(baseURI);
1038         fundWallet = _fundWallet;
1039     }
1040     
1041     function MINT(uint256 num) public payable {
1042         uint256 supply = totalSupply();
1043         require( !_paused,                                       "Sale paused" );
1044         require( num <= _maxperTX,                               "You are exceeding limit of per transaction GURUS" );
1045         require( supply + num <= _limit - _reserved,             "Exceeds maximum GURUS supply" );
1046         require( msg.value >= _price * num,                      "Ether sent is not correct" );
1047 
1048         for(uint256 i; i < num; i++){
1049             _safeMint( msg.sender, supply + i );
1050         }
1051     }
1052 
1053     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1054         require( _to !=  address(0), "Zero address error");
1055         require( _amount <= _reserved, "Exceeds reserved GURUS supply");
1056 
1057         uint256 supply = totalSupply();
1058         for(uint256 i; i < _amount; i++){
1059             _safeMint( _to, supply + i );
1060         }
1061         _reserved -= _amount;
1062     }
1063     
1064     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1065         uint256 tokenCount = balanceOf(_owner);
1066 
1067         uint256[] memory tokensId = new uint256[](tokenCount);
1068         for(uint256 i; i < tokenCount; i++){
1069             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1070         }
1071         return tokensId;
1072     }
1073 
1074     // Just in case Eth does some crazy stuff
1075     function setPrice(uint256 _newPrice) public onlyOwner() {
1076         _price = _newPrice;
1077     }
1078 
1079     function setFundWallet(address _fundWallet) public onlyOwner() {
1080         require(_fundWallet != address(0), "Zero address error");
1081         fundWallet = _fundWallet;
1082     }
1083 
1084     function _baseURI() internal view virtual override returns (string memory) {
1085         return _baseTokenURI;
1086     }
1087 
1088     function setLimit(uint256 limit) public onlyOwner {
1089         _limit = limit;
1090     }
1091 
1092     function setMaxPerWallet(uint256 limit) public onlyOwner {
1093         _maxperTX = limit;
1094     }
1095 
1096     function setBaseURI(string memory baseURI) public onlyOwner {
1097         _baseTokenURI = baseURI;
1098     }
1099 
1100     function pause() public onlyOwner {
1101         _paused = !_paused;
1102     }
1103 
1104     function withdrawAll() public payable onlyOwner {
1105         require(payable(fundWallet).send(address(this).balance));
1106     }
1107 }