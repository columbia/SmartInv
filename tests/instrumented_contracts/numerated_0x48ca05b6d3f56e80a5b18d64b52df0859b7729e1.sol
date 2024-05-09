1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 /**
7  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
8  * the Metadata extension, but not including the Enumerable extension, which is available separately as
9  * {ERC721Enumerable}.
10  */
11 
12 interface IERC721Receiver {
13     /**
14      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
15      * by `operator` from `from`, this function is called.
16      *
17      * It must return its Solidity selector to confirm the token transfer.
18      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
19      *
20      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
21      */
22     function onERC721Received(
23         address operator,
24         address from,
25         uint256 tokenId,
26         bytes calldata data
27     ) external returns (bytes4);
28 }
29 
30 
31 library Address {
32     /**
33      * @dev Returns true if `account` is a contract.
34      *
35      * [IMPORTANT]
36      * ====
37      * It is unsafe to assume that an address for which this function returns
38      * false is an externally-owned account (EOA) and not a contract.
39      *
40      * Among others, `isContract` will return false for the following
41      * types of addresses:
42      *
43      *  - an externally-owned account
44      *  - a contract in construction
45      *  - an address where a contract will be created
46      *  - an address where a contract lived, but was destroyed
47      * ====
48      */
49     function isContract(address account) internal view returns (bool) {
50         // This method relies on extcodesize, which returns 0 for contracts in
51         // construction, since the code is only stored at the end of the
52         // constructor execution.
53 
54         uint256 size;
55         assembly {
56             size := extcodesize(account)
57         }
58         return size > 0;
59     }
60 
61     /**
62      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
63      * `recipient`, forwarding all available gas and reverting on errors.
64      *
65      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
66      * of certain opcodes, possibly making contracts go over the 2300 gas limit
67      * imposed by `transfer`, making them unable to receive funds via
68      * `transfer`. {sendValue} removes this limitation.
69      *
70      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
71      *
72      * IMPORTANT: because control is transferred to `recipient`, care must be
73      * taken to not create reentrancy vulnerabilities. Consider using
74      * {ReentrancyGuard} or the
75      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
76      */
77     function sendValue(address payable recipient, uint256 amount) internal {
78         require(address(this).balance >= amount, "Address: insufficient balance");
79 
80         (bool success, ) = recipient.call{value: amount}("");
81         require(success, "Address: unable to send value, recipient may have reverted");
82     }
83 
84     /**
85      * @dev Performs a Solidity function call using a low level `call`. A
86      * plain `call` is an unsafe replacement for a function call: use this
87      * function instead.
88      *
89      * If `target` reverts with a revert reason, it is bubbled up by this
90      * function (like regular Solidity function calls).
91      *
92      * Returns the raw returned data. To convert to the expected return value,
93      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
94      *
95      * Requirements:
96      *
97      * - `target` must be a contract.
98      * - calling `target` with `data` must not revert.
99      *
100      * _Available since v3.1._
101      */
102     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
103         return functionCall(target, data, "Address: low-level call failed");
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
108      * `errorMessage` as a fallback revert reason when `target` reverts.
109      *
110      * _Available since v3.1._
111      */
112     function functionCall(
113         address target,
114         bytes memory data,
115         string memory errorMessage
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, 0, errorMessage);
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
122      * but also transferring `value` wei to `target`.
123      *
124      * Requirements:
125      *
126      * - the calling contract must have an ETH balance of at least `value`.
127      * - the called Solidity function must be `payable`.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value
135     ) internal returns (bytes memory) {
136         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
141      * with `errorMessage` as a fallback revert reason when `target` reverts.
142      *
143      * _Available since v3.1._
144      */
145     function functionCallWithValue(
146         address target,
147         bytes memory data,
148         uint256 value,
149         string memory errorMessage
150     ) internal returns (bytes memory) {
151         require(address(this).balance >= value, "Address: insufficient balance for call");
152         require(isContract(target), "Address: call to non-contract");
153 
154         (bool success, bytes memory returndata) = target.call{value: value}(data);
155         return verifyCallResult(success, returndata, errorMessage);
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
160      * but performing a static call.
161      *
162      * _Available since v3.3._
163      */
164     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
165         return functionStaticCall(target, data, "Address: low-level static call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
170      * but performing a static call.
171      *
172      * _Available since v3.3._
173      */
174     function functionStaticCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal view returns (bytes memory) {
179         require(isContract(target), "Address: static call to non-contract");
180 
181         (bool success, bytes memory returndata) = target.staticcall(data);
182         return verifyCallResult(success, returndata, errorMessage);
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
187      * but performing a delegate call.
188      *
189      * _Available since v3.4._
190      */
191     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
192         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
197      * but performing a delegate call.
198      *
199      * _Available since v3.4._
200      */
201     function functionDelegateCall(
202         address target,
203         bytes memory data,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(isContract(target), "Address: delegate call to non-contract");
207 
208         (bool success, bytes memory returndata) = target.delegatecall(data);
209         return verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     /**
213      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
214      * revert reason using the provided one.
215      *
216      * _Available since v4.3._
217      */
218     function verifyCallResult(
219         bool success,
220         bytes memory returndata,
221         string memory errorMessage
222     ) internal pure returns (bytes memory) {
223         if (success) {
224             return returndata;
225         } else {
226             // Look for revert reason and bubble it up if present
227             if (returndata.length > 0) {
228                 // The easiest way to bubble the revert reason is using memory via assembly
229 
230                 assembly {
231                     let returndata_size := mload(returndata)
232                     revert(add(32, returndata), returndata_size)
233                 }
234             } else {
235                 revert(errorMessage);
236             }
237         }
238     }
239 }
240 
241 
242 abstract contract Context {
243     function _msgSender() internal view virtual returns (address) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view virtual returns (bytes calldata) {
248         return msg.data;
249     }
250 }
251 
252 
253 abstract contract Ownable is Context {
254     address private _owner;
255 
256     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
257 
258     /**
259      * @dev Initializes the contract setting the deployer as the initial owner.
260      */
261     constructor() {
262         _transferOwnership(_msgSender());
263     }
264 
265     /**
266      * @dev Returns the address of the current owner.
267      */
268     function owner() public view virtual returns (address) {
269         return _owner;
270     }
271 
272     /**
273      * @dev Throws if called by any account other than the owner.
274      */
275     modifier onlyOwner() {
276         require(owner() == _msgSender(), "Ownable: caller is not the owner");
277         _;
278     }
279 
280     /**
281      * @dev Leaves the contract without owner. It will not be possible to call
282      * `onlyOwner` functions anymore. Can only be called by the current owner.
283      *
284      * NOTE: Renouncing ownership will leave the contract without an owner,
285      * thereby removing any functionality that is only available to the owner.
286      */
287     function renounceOwnership() public virtual onlyOwner {
288         _transferOwnership(address(0));
289     }
290 
291     /**
292      * @dev Transfers ownership of the contract to a new account (`newOwner`).
293      * Can only be called by the current owner.
294      */
295     function transferOwnership(address newOwner) public virtual onlyOwner {
296         require(newOwner != address(0), "Ownable: new owner is the zero address");
297         _transferOwnership(newOwner);
298     }
299 
300     /**
301      * @dev Transfers ownership of the contract to a new account (`newOwner`).
302      * Internal function without access restriction.
303      */
304     function _transferOwnership(address newOwner) internal virtual {
305         address oldOwner = _owner;
306         _owner = newOwner;
307         emit OwnershipTransferred(oldOwner, newOwner);
308     }
309 }
310 
311 
312 library Strings {
313     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
314 
315     /**
316      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
317      */
318     function toString(uint256 value) internal pure returns (string memory) {
319         // Inspired by OraclizeAPI's implementation - MIT licence
320         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
321 
322         if (value == 0) {
323             return "0";
324         }
325         uint256 temp = value;
326         uint256 digits;
327         while (temp != 0) {
328             digits++;
329             temp /= 10;
330         }
331         bytes memory buffer = new bytes(digits);
332         while (value != 0) {
333             digits -= 1;
334             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
335             value /= 10;
336         }
337         return string(buffer);
338     }
339 
340     /**
341      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
342      */
343     function toHexString(uint256 value) internal pure returns (string memory) {
344         if (value == 0) {
345             return "0x00";
346         }
347         uint256 temp = value;
348         uint256 length = 0;
349         while (temp != 0) {
350             length++;
351             temp >>= 8;
352         }
353         return toHexString(value, length);
354     }
355 
356     /**
357      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
358      */
359     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
360         bytes memory buffer = new bytes(2 * length + 2);
361         buffer[0] = "0";
362         buffer[1] = "x";
363         for (uint256 i = 2 * length + 1; i > 1; --i) {
364             buffer[i] = _HEX_SYMBOLS[value & 0xf];
365             value >>= 4;
366         }
367         require(value == 0, "Strings: hex length insufficient");
368         return string(buffer);
369     }
370 }
371 
372 
373 interface IERC165 {
374     /**
375      * @dev Returns true if this contract implements the interface defined by
376      * `interfaceId`. See the corresponding
377      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
378      * to learn more about how these ids are created.
379      *
380      * This function call must use less than 30 000 gas.
381      */
382     function supportsInterface(bytes4 interfaceId) external view returns (bool);
383 }
384 
385 
386 abstract contract ERC165 is IERC165 {
387     /**
388      * @dev See {IERC165-supportsInterface}.
389      */
390     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
391         return interfaceId == type(IERC165).interfaceId;
392     }
393 }
394 
395 interface IERC721 is IERC165 {
396     /**
397      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
398      */
399     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
400 
401     /**
402      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
403      */
404     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
405 
406     /**
407      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
408      */
409     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
410 
411     /**
412      * @dev Returns the number of tokens in ``owner``'s account.
413      */
414     function balanceOf(address owner) external view returns (uint256 balance);
415 
416     /**
417      * @dev Returns the owner of the `tokenId` token.
418      *
419      * Requirements:
420      *
421      * - `tokenId` must exist.
422      */
423     function ownerOf(uint256 tokenId) external view returns (address owner);
424 
425     /**
426      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
427      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
436      *
437      * Emits a {Transfer} event.
438      */
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId
443     ) external;
444 
445     /**
446      * @dev Transfers `tokenId` token from `from` to `to`.
447      *
448      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `tokenId` token must be owned by `from`.
455      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
456      *
457      * Emits a {Transfer} event.
458      */
459     function transferFrom(
460         address from,
461         address to,
462         uint256 tokenId
463     ) external;
464 
465     /**
466      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
467      * The approval is cleared when the token is transferred.
468      *
469      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
470      *
471      * Requirements:
472      *
473      * - The caller must own the token or be an approved operator.
474      * - `tokenId` must exist.
475      *
476      * Emits an {Approval} event.
477      */
478     function approve(address to, uint256 tokenId) external;
479 
480     /**
481      * @dev Returns the account approved for `tokenId` token.
482      *
483      * Requirements:
484      *
485      * - `tokenId` must exist.
486      */
487     function getApproved(uint256 tokenId) external view returns (address operator);
488 
489     /**
490      * @dev Approve or remove `operator` as an operator for the caller.
491      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
492      *
493      * Requirements:
494      *
495      * - The `operator` cannot be the caller.
496      *
497      * Emits an {ApprovalForAll} event.
498      */
499     function setApprovalForAll(address operator, bool _approved) external;
500 
501     /**
502      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
503      *
504      * See {setApprovalForAll}
505      */
506     function isApprovedForAll(address owner, address operator) external view returns (bool);
507 
508     /**
509      * @dev Safely transfers `tokenId` token from `from` to `to`.
510      *
511      * Requirements:
512      *
513      * - `from` cannot be the zero address.
514      * - `to` cannot be the zero address.
515      * - `tokenId` token must exist and be owned by `from`.
516      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
517      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
518      *
519      * Emits a {Transfer} event.
520      */
521     function safeTransferFrom(
522         address from,
523         address to,
524         uint256 tokenId,
525         bytes calldata data
526     ) external;
527 }
528 
529 
530 
531 interface IERC721Metadata is IERC721 {
532     /**
533      * @dev Returns the token collection name.
534      */
535     function name() external view returns (string memory);
536 
537     /**
538      * @dev Returns the token collection symbol.
539      */
540     function symbol() external view returns (string memory);
541 
542     /**
543      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
544      */
545     function tokenURI(uint256 tokenId) external view returns (string memory);
546 }
547 
548 
549 
550 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata{
551     using Address for address;
552     using Strings for uint256;
553 
554     // Token name
555     string private _name;
556 
557     // Token symbol
558     string private _symbol;
559     
560 
561     // Mapping from token ID to owner address
562     mapping(uint256 => address) private _owners;
563 
564     // Mapping owner address to token count
565     mapping(address => uint256) private _balances;
566 
567     // Mapping from token ID to approved address
568     mapping(uint256 => address) private _tokenApprovals;
569 
570     // Mapping from owner to operator approvals
571     mapping(address => mapping(address => bool)) private _operatorApprovals;
572     
573     // metadata api
574     string baseUri = "ipfs://QmXuoQtta6Z8JMcpdxoNbTo8uVHVHLQeffBHW7ZDNdFz4F/"; 
575 
576     /**
577      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
578      */
579     constructor(string memory name_, string memory symbol_) {
580         _name = name_;
581         _symbol = symbol_;
582     }
583 
584     /**
585      * @dev See {IERC165-supportsInterface}.
586      */
587     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
588         return
589             interfaceId == type(IERC721).interfaceId ||
590             interfaceId == type(IERC721Metadata).interfaceId ||
591             super.supportsInterface(interfaceId);
592     }
593 
594     /**
595      * @dev See {IERC721-balanceOf}.
596      */
597     function balanceOf(address owner) public view virtual override returns (uint256) {
598         require(owner != address(0), "ERC721: balance query for the zero address");
599         return _balances[owner];
600     }
601 
602     /**
603      * @dev See {IERC721-ownerOf}.
604      */
605     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
606         address owner = _owners[tokenId];
607         require(owner != address(0), "ERC721: owner query for nonexistent token");
608         return owner;
609     }
610 
611     /**
612      * @dev See {IERC721Metadata-name}.
613      */
614     function name() public view virtual override returns (string memory) {
615         return _name;
616     }
617 
618     /**
619      * @dev See {IERC721Metadata-symbol}.
620      */
621     function symbol() public view virtual override returns (string memory) {
622         return _symbol;
623     }
624     
625 
626     /**
627      * @dev See {IERC721Metadata-tokenURI}.
628      */
629     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
630         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
631 
632         string memory baseURI = _baseURI();
633         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
634     }
635 
636     /**
637      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
638      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
639      * by default, can be overriden in child contracts.
640      */
641     function _baseURI() internal view virtual returns (string memory) {
642         return baseUri;
643     }
644     
645 
646     /**
647      * @dev See {IERC721-approve}.
648      */
649     function approve(address to, uint256 tokenId) public virtual override {
650         address owner = ERC721.ownerOf(tokenId);
651         require(to != owner, "ERC721: approval to current owner");
652 
653         require(
654             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
655             "ERC721: approve caller is not owner nor approved for all"
656         );
657 
658         _approve(to, tokenId);
659     }
660 
661     /**
662      * @dev See {IERC721-getApproved}.
663      */
664     function getApproved(uint256 tokenId) public view virtual override returns (address) {
665         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
666 
667         return _tokenApprovals[tokenId];
668     }
669 
670     /**
671      * @dev See {IERC721-setApprovalForAll}.
672      */
673     function setApprovalForAll(address operator, bool approved) public virtual override {
674         require(operator != _msgSender(), "ERC721: approve to caller");
675 
676         _operatorApprovals[_msgSender()][operator] = approved;
677         emit ApprovalForAll(_msgSender(), operator, approved);
678     }
679 
680     /**
681      * @dev See {IERC721-isApprovedForAll}.
682      */
683     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
684         return _operatorApprovals[owner][operator];
685     }
686 
687     /**
688      * @dev See {IERC721-transferFrom}.
689      */
690     function transferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) public virtual override {
695         //solhint-disable-next-line max-line-length
696         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
697 
698         _transfer(from, to, tokenId);
699     }
700 
701     /**
702      * @dev See {IERC721-safeTransferFrom}.
703      */
704     function safeTransferFrom(
705         address from,
706         address to,
707         uint256 tokenId
708     ) public virtual override {
709         safeTransferFrom(from, to, tokenId, "");
710     }
711 
712     /**
713      * @dev See {IERC721-safeTransferFrom}.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId,
719         bytes memory _data
720     ) public virtual override {
721         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
722         _safeTransfer(from, to, tokenId, _data);
723     }
724 
725     /**
726      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
727      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
728      *
729      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
730      *
731      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
732      * implement alternative mechanisms to perform token transfer, such as signature-based.
733      *
734      * Requirements:
735      *
736      * - `from` cannot be the zero address.
737      * - `to` cannot be the zero address.
738      * - `tokenId` token must exist and be owned by `from`.
739      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
740      *
741      * Emits a {Transfer} event.
742      */
743     function _safeTransfer(
744         address from,
745         address to,
746         uint256 tokenId,
747         bytes memory _data
748     ) internal virtual {
749         _transfer(from, to, tokenId);
750         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
751     }
752 
753     /**
754      * @dev Returns whether `tokenId` exists.
755      *
756      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
757      *
758      * Tokens start existing when they are minted (`_mint`),
759      * and stop existing when they are burned (`_burn`).
760      */
761     function _exists(uint256 tokenId) internal view virtual returns (bool) {
762         return _owners[tokenId] != address(0);
763     }
764 
765     /**
766      * @dev Returns whether `spender` is allowed to manage `tokenId`.
767      *
768      * Requirements:
769      *
770      * - `tokenId` must exist.
771      */
772     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
773         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
774         address owner = ERC721.ownerOf(tokenId);
775         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
776     }
777 
778     /**
779      * @dev Safely mints `tokenId` and transfers it to `to`.
780      *
781      * Requirements:
782      *
783      * - `tokenId` must not exist.
784      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
785      *
786      * Emits a {Transfer} event.
787      */
788     function _safeMint(address to, uint256 tokenId) internal virtual {
789         _safeMint(to, tokenId, "");
790     }
791 
792     /**
793      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
794      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
795      */
796     function _safeMint(
797         address to,
798         uint256 tokenId,
799         bytes memory _data
800     ) internal virtual {
801         _mint(to, tokenId);
802         require(
803             _checkOnERC721Received(address(0), to, tokenId, _data),
804             "ERC721: transfer to non ERC721Receiver implementer"
805         );
806     }
807 
808     /**
809      * @dev Mints `tokenId` and transfers it to `to`.
810      *
811      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
812      *
813      * Requirements:
814      *
815      * - `tokenId` must not exist.
816      * - `to` cannot be the zero address.
817      *
818      * Emits a {Transfer} event.
819      */
820     function _mint(address to, uint256 tokenId) internal virtual {
821         require(to != address(0), "ERC721: mint to the zero address");
822         require(!_exists(tokenId), "ERC721: token already minted");
823 
824         _beforeTokenTransfer(address(0), to, tokenId);
825 
826         _balances[to] += 1;
827         _owners[tokenId] = to;
828     
829         emit Transfer(address(0), to, tokenId);
830     }
831 
832     /**
833      * @dev Destroys `tokenId`.
834      * The approval is cleared when the token is burned.
835      *
836      * Requirements:
837      *
838      * - `tokenId` must exist.
839      *
840      * Emits a {Transfer} event.
841      */
842     function _burn(uint256 tokenId) internal virtual {
843         address owner = ERC721.ownerOf(tokenId);
844 
845         _beforeTokenTransfer(owner, address(0), tokenId);
846 
847         // Clear approvals
848         _approve(address(0), tokenId);
849 
850         _balances[owner] -= 1;
851         delete _owners[tokenId];
852 
853         emit Transfer(owner, address(0), tokenId);
854     }
855 
856     /**
857      * @dev Transfers `tokenId` from `from` to `to`.
858      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
859      *
860      * Requirements:
861      *
862      * - `to` cannot be the zero address.
863      * - `tokenId` token must be owned by `from`.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _transfer(
868         address from,
869         address to,
870         uint256 tokenId
871     ) internal virtual {
872         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
873         require(to != address(0), "ERC721: transfer to the zero address");
874 
875         _beforeTokenTransfer(from, to, tokenId);
876 
877         // Clear approvals from the previous owner
878         _approve(address(0), tokenId);
879 
880         _balances[from] -= 1;
881         _balances[to] += 1;
882         _owners[tokenId] = to;
883 
884         emit Transfer(from, to, tokenId);
885     }
886     
887     
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
917                 return retval == IERC721Receiver.onERC721Received.selector;
918             } catch (bytes memory reason) {
919                 if (reason.length == 0) {
920                     revert("ERC721: transfer to non ERC721Receiver implementer");
921                 } else {
922                     assembly {
923                         revert(add(32, reason), mload(reason))
924                     }
925                 }
926             }
927         } else {
928             return true;
929         }
930     }
931 
932     /**
933      * @dev Hook that is called before any token transfer. This includes minting
934      * and burning.
935      *
936      * Calling conditions:
937      *
938      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
939      * transferred to `to`.
940      * - When `from` is zero, `tokenId` will be minted for `to`.
941      * - When `to` is zero, ``from``'s `tokenId` will be burned.
942      * - `from` and `to` are never both zero.
943      *
944      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
945      */
946     function _beforeTokenTransfer(
947         address from,
948         address to,
949         uint256 tokenId
950     ) internal virtual {}
951 }
952 
953 contract VerifySignature is Ownable {
954     
955     function getMessageHash(
956         address _to
957     ) public pure returns (bytes32) {
958         return keccak256(abi.encodePacked(_to));
959     }
960 
961     function getEthSignedMessageHash(bytes32 _messageHash)
962         private
963         pure
964         returns (bytes32)
965     {
966         return
967             keccak256(
968                 abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
969             );
970     }
971 
972     function verify(
973         address _signer,
974         bytes memory signature
975     ) public view returns (bool) {
976         require(_signer == owner(), "Signer should be owner only.");
977         bytes32 messageHash = getMessageHash(msg.sender);
978         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
979 
980         return recoverSigner(ethSignedMessageHash, signature) == _signer;
981     }
982 
983     function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
984         private
985         pure
986         returns (address)
987     {
988         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
989 
990         return ecrecover(_ethSignedMessageHash, v, r, s);
991     }
992 
993     function splitSignature(bytes memory sig)
994         private
995         pure
996         returns (
997             bytes32 r,
998             bytes32 s,
999             uint8 v
1000         )
1001     {
1002         require(sig.length == 65, "invalid signature length");
1003 
1004         assembly {
1005             /*
1006             First 32 bytes stores the length of the signature
1007 
1008             add(sig, 32) = pointer of sig + 32
1009             effectively, skips first 32 bytes of signature
1010 
1011             mload(p) loads next 32 bytes starting at the memory address p into memory
1012             */
1013 
1014             // first 32 bytes, after the length prefix
1015             r := mload(add(sig, 32))
1016             // second 32 bytes
1017             s := mload(add(sig, 64))
1018             // final byte (first byte of the next 32 bytes)
1019             v := byte(0, mload(add(sig, 96)))
1020         }
1021 
1022     }
1023 }
1024 
1025 contract SuburbanColors is ERC721, Ownable, VerifySignature{
1026      
1027     uint256 public totalSupply = 0; // Total Minted Supply
1028     uint256 private constant totalSale = 2199; // total NFTs
1029     uint256 public reserved = 0; // reserved for whitelist users
1030     uint256 public mintPrice = 3 * 10 ** 16;  // minting price 0.03 ETH
1031     uint256 public launchedAt; 
1032 
1033     mapping(address => uint256) public whitelistMinted;
1034 
1035     constructor(uint256 _launchedAt, uint256 _reserved) ERC721("RebelCoin", "SUB"){
1036         launchedAt = _launchedAt;
1037         reserved = _reserved;
1038     }
1039     
1040     function presaleMint(bytes memory _signature, uint256 quantity) public payable{
1041         require(verify(owner(), _signature), "You are not Whitelisted.");
1042         require((whitelistMinted[msg.sender] + quantity) <= 3, "You have mint your all NFTs.");
1043         require(msg.value >= (mintPrice * quantity), "Invalid Price To Mint");
1044         require(reserved > 0, "All reserved NFTs are minted.");
1045 
1046         (bool success,) = owner().call{value: msg.value}("");
1047         if(!success) {
1048             revert("Payment Sending Failed");
1049         }
1050         else{
1051             for (uint256 i=0; i < quantity; i++) {
1052                 totalSupply++;
1053                 _safeMint(msg.sender, totalSupply);
1054                 whitelistMinted[msg.sender] += 1;
1055             }
1056             reserved = reserved - quantity;     
1057         }
1058     } 
1059 
1060     function mintByUser(uint256 quantity) public payable{
1061         require(block.timestamp >= launchedAt, "Minting is not started.");
1062         require((totalSupply + quantity) <= (totalSale - reserved), "Max Limit To Total Sale");
1063         require(quantity > 0 && quantity <=3, "Invalid Mint Quantity");
1064         require(msg.value >= (mintPrice * quantity), "Invalid Price To Mint");
1065 
1066         (bool success,) = owner().call{value: msg.value}("");
1067         if(!success) {
1068             revert("Payment Sending Failed");
1069         }
1070         else{
1071             for (uint256 i=0; i < quantity; i++) {
1072                 totalSupply++;
1073                 _safeMint(msg.sender,totalSupply);
1074             }     
1075         }
1076         
1077     } 
1078     
1079     function setMintPrice(uint256 newPrice) external onlyOwner {
1080         mintPrice = newPrice;
1081     }
1082     
1083     function _setbaseURI(string memory _baseUri) external onlyOwner{
1084         baseUri = _baseUri;
1085     }
1086     
1087     function mintByOwner(address _to, uint256 quantity) public onlyOwner {
1088       require(totalSupply + quantity <= totalSale - reserved, "Max Limit To Admin Mint");
1089         for (uint256 i=0; i<quantity; i++) {
1090              totalSupply++;
1091             _safeMint(_to,totalSupply);
1092         }   
1093     }
1094     
1095     function batchMintByOwner(address[] memory mintAddressList,uint256[] memory quantityList) external onlyOwner {
1096         require (mintAddressList.length == quantityList.length, "The length should be same");
1097 
1098         for (uint256 i=0; i<mintAddressList.length; i++) {
1099             mintByOwner(mintAddressList[i], quantityList[i]);
1100         }
1101     }
1102 }