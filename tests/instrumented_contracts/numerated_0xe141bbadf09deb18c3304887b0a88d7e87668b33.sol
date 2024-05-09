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
550  
551 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata{
552     using Address for address;
553     using Strings for uint256;
554 
555     // Token name
556     string private _name;
557 
558     // Token symbol
559     string private _symbol;
560     
561 
562     // Mapping from token ID to owner address
563     mapping(uint256 => address) private _owners;
564 
565     // Mapping owner address to token count
566     mapping(address => uint256) private _balances;
567 
568     // Mapping from token ID to approved address
569     mapping(uint256 => address) private _tokenApprovals;
570 
571     // Mapping from owner to operator approvals
572     mapping(address => mapping(address => bool)) private _operatorApprovals;
573     
574     // metadata api after reveal
575     string baseUri = "ipfs://QmQfJQS4FGEQzNfY3E7gDSfVJ4PBcR9dnPaiEsNJmW16Zw/Duck"; 
576 
577     // metadata api before reveal
578     string notRevealedUri = "ipfs://QmQfJQS4FGEQzNfY3E7gDSfVJ4PBcR9dnPaiEsNJmW16Zw/unknown"; 
579 
580     bool public revealed = false; // for reveal NFT
581 
582     /**
583      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
584      */
585     constructor(string memory name_, string memory symbol_) {
586         _name = name_;
587         _symbol = symbol_;
588     }
589 
590     /**
591      * @dev See {IERC165-supportsInterface}.
592      */
593     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
594         return
595             interfaceId == type(IERC721).interfaceId ||
596             interfaceId == type(IERC721Metadata).interfaceId ||
597             super.supportsInterface(interfaceId);
598     }
599 
600     /**
601      * @dev See {IERC721-balanceOf}.
602      */
603     function balanceOf(address owner) public view virtual override returns (uint256) {
604         require(owner != address(0), "ERC721: balance query for the zero address");
605         return _balances[owner];
606     }
607 
608     /**
609      * @dev See {IERC721-ownerOf}.
610      */
611     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
612         address owner = _owners[tokenId];
613         require(owner != address(0), "ERC721: owner query for nonexistent token");
614         return owner;
615     }
616 
617     /**
618      * @dev See {IERC721Metadata-name}.
619      */
620     function name() public view virtual override returns (string memory) {
621         return _name;
622     }
623 
624     /**
625      * @dev See {IERC721Metadata-symbol}.
626      */
627     function symbol() public view virtual override returns (string memory) {
628         return _symbol;
629     }
630     
631 
632     /**
633      * @dev See {IERC721Metadata-tokenURI}.
634      */
635     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
636         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
637 
638         if(revealed == false){
639           // string memory baseURI = _baseURI();
640             return bytes(notRevealedUri).length > 0 ? string(abi.encodePacked(notRevealedUri, ".json")) : "";
641         }
642         else{
643             return bytes(baseUri).length > 0 ? string(abi.encodePacked(baseUri, tokenId.toString(),".json")) : "";
644         }  
645     }
646 
647     /**
648      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
649      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
650      * by default, can be overriden in child contracts.
651      */
652 
653     // function _baseURI() internal view virtual returns (string memory) {
654     //     return baseUri;
655     // }
656     
657 
658     /**
659      * @dev See {IERC721-approve}.
660      */
661     function approve(address to, uint256 tokenId) public virtual override {
662         address owner = ERC721.ownerOf(tokenId);
663         require(to != owner, "ERC721: approval to current owner");
664 
665         require(
666             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
667             "ERC721: approve caller is not owner nor approved for all"
668         );
669 
670         _approve(to, tokenId);
671     }
672 
673     /**
674      * @dev See {IERC721-getApproved}.
675      */
676     function getApproved(uint256 tokenId) public view virtual override returns (address) {
677         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
678 
679         return _tokenApprovals[tokenId];
680     }
681 
682     /**
683      * @dev See {IERC721-setApprovalForAll}.
684      */
685     function setApprovalForAll(address operator, bool approved) public virtual override {
686         require(operator != _msgSender(), "ERC721: approve to caller");
687 
688         _operatorApprovals[_msgSender()][operator] = approved;
689         emit ApprovalForAll(_msgSender(), operator, approved);
690     }
691 
692     /**
693      * @dev See {IERC721-isApprovedForAll}.
694      */
695     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
696         return _operatorApprovals[owner][operator];
697     }
698 
699     /**
700      * @dev See {IERC721-transferFrom}.
701      */
702     function transferFrom(
703         address from,
704         address to,
705         uint256 tokenId
706     ) public virtual override {
707         //solhint-disable-next-line max-line-length
708         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
709 
710         _transfer(from, to, tokenId);
711     }
712 
713     /**
714      * @dev See {IERC721-safeTransferFrom}.
715      */
716     function safeTransferFrom(
717         address from,
718         address to,
719         uint256 tokenId
720     ) public virtual override {
721         safeTransferFrom(from, to, tokenId, "");
722     }
723 
724     /**
725      * @dev See {IERC721-safeTransferFrom}.
726      */
727     function safeTransferFrom(
728         address from,
729         address to,
730         uint256 tokenId,
731         bytes memory _data
732     ) public virtual override {
733         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
734         _safeTransfer(from, to, tokenId, _data);
735     }
736 
737     /**
738      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
739      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
740      *
741      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
742      *
743      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
744      * implement alternative mechanisms to perform token transfer, such as signature-based.
745      *
746      * Requirements:
747      *
748      * - `from` cannot be the zero address.
749      * - `to` cannot be the zero address.
750      * - `tokenId` token must exist and be owned by `from`.
751      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
752      *
753      * Emits a {Transfer} event.
754      */
755     function _safeTransfer(
756         address from,
757         address to,
758         uint256 tokenId,
759         bytes memory _data
760     ) internal virtual {
761         _transfer(from, to, tokenId);
762         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
763     }
764 
765     /**
766      * @dev Returns whether `tokenId` exists.
767      *
768      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
769      *
770      * Tokens start existing when they are minted (`_mint`),
771      * and stop existing when they are burned (`_burn`).
772      */
773     function _exists(uint256 tokenId) internal view virtual returns (bool) {
774         return _owners[tokenId] != address(0);
775     }
776 
777     /**
778      * @dev Returns whether `spender` is allowed to manage `tokenId`.
779      *
780      * Requirements:
781      *
782      * - `tokenId` must exist.
783      */
784     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
785         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
786         address owner = ERC721.ownerOf(tokenId);
787         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
788     }
789 
790     /**
791      * @dev Safely mints `tokenId` and transfers it to `to`.
792      *
793      * Requirements:
794      *
795      * - `tokenId` must not exist.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function _safeMint(address to, uint256 tokenId) internal virtual {
801         _safeMint(to, tokenId, "");
802     }
803 
804     /**
805      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
806      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
807      */
808     function _safeMint(
809         address to,
810         uint256 tokenId,
811         bytes memory _data
812     ) internal virtual {
813         _mint(to, tokenId);
814         require(
815             _checkOnERC721Received(address(0), to, tokenId, _data),
816             "ERC721: transfer to non ERC721Receiver implementer"
817         );
818     }
819 
820     /**
821      * @dev Mints `tokenId` and transfers it to `to`.
822      *
823      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
824      *
825      * Requirements:
826      *
827      * - `tokenId` must not exist.
828      * - `to` cannot be the zero address.
829      *
830      * Emits a {Transfer} event.
831      */
832     function _mint(address to, uint256 tokenId) internal virtual {
833         require(to != address(0), "ERC721: mint to the zero address");
834         require(!_exists(tokenId), "ERC721: token already minted");
835 
836         _beforeTokenTransfer(address(0), to, tokenId);
837 
838         _balances[to] += 1;
839         _owners[tokenId] = to;
840     
841         emit Transfer(address(0), to, tokenId);
842     }
843 
844     /**
845      * @dev Destroys `tokenId`.
846      * The approval is cleared when the token is burned.
847      *
848      * Requirements:
849      *
850      * - `tokenId` must exist.
851      *
852      * Emits a {Transfer} event.
853      */
854     function _burn(uint256 tokenId) internal virtual {
855         address owner = ERC721.ownerOf(tokenId);
856 
857         _beforeTokenTransfer(owner, address(0), tokenId);
858 
859         // Clear approvals
860         _approve(address(0), tokenId);
861 
862         _balances[owner] -= 1;
863         delete _owners[tokenId];
864 
865         emit Transfer(owner, address(0), tokenId);
866     }
867 
868     /**
869      * @dev Transfers `tokenId` from `from` to `to`.
870      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
871      *
872      * Requirements:
873      *
874      * - `to` cannot be the zero address.
875      * - `tokenId` token must be owned by `from`.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _transfer(
880         address from,
881         address to,
882         uint256 tokenId
883     ) internal virtual {
884         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
885         require(to != address(0), "ERC721: transfer to the zero address");
886 
887         _beforeTokenTransfer(from, to, tokenId);
888 
889         // Clear approvals from the previous owner
890         _approve(address(0), tokenId);
891 
892         _balances[from] -= 1;
893         _balances[to] += 1;
894         _owners[tokenId] = to;
895 
896         emit Transfer(from, to, tokenId);
897     }
898     
899     
900 
901     /**
902      * @dev Approve `to` to operate on `tokenId`
903      *
904      * Emits a {Approval} event.
905      */
906     function _approve(address to, uint256 tokenId) internal virtual {
907         _tokenApprovals[tokenId] = to;
908         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
909     }
910 
911     /**
912      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
913      * The call is not executed if the target address is not a contract.
914      *
915      * @param from address representing the previous owner of the given token ID
916      * @param to target address that will receive the tokens
917      * @param tokenId uint256 ID of the token to be transferred
918      * @param _data bytes optional data to send along with the call
919      * @return bool whether the call correctly returned the expected magic value
920      */
921     function _checkOnERC721Received(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) private returns (bool) {
927         if (to.isContract()) {
928             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
929                 return retval == IERC721Receiver.onERC721Received.selector;
930             } catch (bytes memory reason) {
931                 if (reason.length == 0) {
932                     revert("ERC721: transfer to non ERC721Receiver implementer");
933                 } else {
934                     assembly {
935                         revert(add(32, reason), mload(reason))
936                     }
937                 }
938             }
939         } else {
940             return true;
941         }
942     }
943 
944     /**
945      * @dev Hook that is called before any token transfer. This includes minting
946      * and burning.
947      *
948      * Calling conditions:
949      *
950      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
951      * transferred to `to`.
952      * - When `from` is zero, `tokenId` will be minted for `to`.
953      * - When `to` is zero, ``from``'s `tokenId` will be burned.
954      * - `from` and `to` are never both zero.
955      *
956      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
957      */
958     function _beforeTokenTransfer(
959         address from,
960         address to,
961         uint256 tokenId
962     ) internal virtual {}
963 }
964 
965 
966 
967 
968  contract Sandducks is ERC721, Ownable{
969      
970     uint256 public totalSupply = 0; // Total Supply
971     uint256 private constant totalSale = 10000; // for user minting
972     bool public publicSaleIsActive = false; // minting paused
973 
974 
975     modifier checkPublicSaleIsActive {
976         require ( publicSaleIsActive == true, "Public Sale is not Started");
977         _;
978     }
979      
980     constructor() ERC721("Sandducks", "SD"){
981         totalSupply++;
982         _safeMint(owner(),totalSupply);
983     }
984     
985     
986     function mintByUser(uint256 quantity) public checkPublicSaleIsActive{
987     
988         require(quantity > 0 && quantity <= 10, "Invalid Mint Quantity");
989         require(totalSupply < totalSale, "Minting End");
990         require(totalSupply + quantity <= totalSale, "Max Limit To Total Sale");
991        
992         for (uint256 i=0; i < quantity; i++) {
993             totalSupply++;
994             _safeMint(msg.sender,totalSupply);
995         }     
996     } 
997     
998     
999     function setPublicSaleStatus() external onlyOwner {
1000         publicSaleIsActive = !publicSaleIsActive;
1001     }
1002 
1003     function reveal() public onlyOwner {
1004        revealed = !revealed;
1005     }
1006      
1007 }