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
574     // metadata api
575     string baseUri = "ipfs://QmNqUtjuLH2th8pdM39d9AfL2YrqWdaTkSimkUMt7uoXoj/KittyCat"; 
576 
577     /**
578      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
579      */
580     constructor(string memory name_, string memory symbol_) {
581         _name = name_;
582         _symbol = symbol_;
583     }
584 
585     /**
586      * @dev See {IERC165-supportsInterface}.
587      */
588     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
589         return
590             interfaceId == type(IERC721).interfaceId ||
591             interfaceId == type(IERC721Metadata).interfaceId ||
592             super.supportsInterface(interfaceId);
593     }
594 
595     /**
596      * @dev See {IERC721-balanceOf}.
597      */
598     function balanceOf(address owner) public view virtual override returns (uint256) {
599         require(owner != address(0), "ERC721: balance query for the zero address");
600         return _balances[owner];
601     }
602 
603     /**
604      * @dev See {IERC721-ownerOf}.
605      */
606     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
607         address owner = _owners[tokenId];
608         require(owner != address(0), "ERC721: owner query for nonexistent token");
609         return owner;
610     }
611 
612     /**
613      * @dev See {IERC721Metadata-name}.
614      */
615     function name() public view virtual override returns (string memory) {
616         return _name;
617     }
618 
619     /**
620      * @dev See {IERC721Metadata-symbol}.
621      */
622     function symbol() public view virtual override returns (string memory) {
623         return _symbol;
624     }
625     
626 
627     /**
628      * @dev See {IERC721Metadata-tokenURI}.
629      */
630     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
631         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
632 
633         string memory baseURI = _baseURI();
634         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : "";
635     }
636 
637     /**
638      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
639      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
640      * by default, can be overriden in child contracts.
641      */
642     function _baseURI() internal view virtual returns (string memory) {
643         return baseUri;
644     }
645     
646 
647     /**
648      * @dev See {IERC721-approve}.
649      */
650     function approve(address to, uint256 tokenId) public virtual override {
651         address owner = ERC721.ownerOf(tokenId);
652         require(to != owner, "ERC721: approval to current owner");
653 
654         require(
655             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
656             "ERC721: approve caller is not owner nor approved for all"
657         );
658 
659         _approve(to, tokenId);
660     }
661 
662     /**
663      * @dev See {IERC721-getApproved}.
664      */
665     function getApproved(uint256 tokenId) public view virtual override returns (address) {
666         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
667 
668         return _tokenApprovals[tokenId];
669     }
670 
671     /**
672      * @dev See {IERC721-setApprovalForAll}.
673      */
674     function setApprovalForAll(address operator, bool approved) public virtual override {
675         require(operator != _msgSender(), "ERC721: approve to caller");
676 
677         _operatorApprovals[_msgSender()][operator] = approved;
678         emit ApprovalForAll(_msgSender(), operator, approved);
679     }
680 
681     /**
682      * @dev See {IERC721-isApprovedForAll}.
683      */
684     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
685         return _operatorApprovals[owner][operator];
686     }
687 
688     /**
689      * @dev See {IERC721-transferFrom}.
690      */
691     function transferFrom(
692         address from,
693         address to,
694         uint256 tokenId
695     ) public virtual override {
696         //solhint-disable-next-line max-line-length
697         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
698 
699         _transfer(from, to, tokenId);
700     }
701 
702     /**
703      * @dev See {IERC721-safeTransferFrom}.
704      */
705     function safeTransferFrom(
706         address from,
707         address to,
708         uint256 tokenId
709     ) public virtual override {
710         safeTransferFrom(from, to, tokenId, "");
711     }
712 
713     /**
714      * @dev See {IERC721-safeTransferFrom}.
715      */
716     function safeTransferFrom(
717         address from,
718         address to,
719         uint256 tokenId,
720         bytes memory _data
721     ) public virtual override {
722         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
723         _safeTransfer(from, to, tokenId, _data);
724     }
725 
726     /**
727      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
728      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
729      *
730      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
731      *
732      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
733      * implement alternative mechanisms to perform token transfer, such as signature-based.
734      *
735      * Requirements:
736      *
737      * - `from` cannot be the zero address.
738      * - `to` cannot be the zero address.
739      * - `tokenId` token must exist and be owned by `from`.
740      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
741      *
742      * Emits a {Transfer} event.
743      */
744     function _safeTransfer(
745         address from,
746         address to,
747         uint256 tokenId,
748         bytes memory _data
749     ) internal virtual {
750         _transfer(from, to, tokenId);
751         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
752     }
753 
754     /**
755      * @dev Returns whether `tokenId` exists.
756      *
757      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
758      *
759      * Tokens start existing when they are minted (`_mint`),
760      * and stop existing when they are burned (`_burn`).
761      */
762     function _exists(uint256 tokenId) internal view virtual returns (bool) {
763         return _owners[tokenId] != address(0);
764     }
765 
766     /**
767      * @dev Returns whether `spender` is allowed to manage `tokenId`.
768      *
769      * Requirements:
770      *
771      * - `tokenId` must exist.
772      */
773     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
774         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
775         address owner = ERC721.ownerOf(tokenId);
776         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
777     }
778 
779     /**
780      * @dev Safely mints `tokenId` and transfers it to `to`.
781      *
782      * Requirements:
783      *
784      * - `tokenId` must not exist.
785      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
786      *
787      * Emits a {Transfer} event.
788      */
789     function _safeMint(address to, uint256 tokenId) internal virtual {
790         _safeMint(to, tokenId, "");
791     }
792 
793     /**
794      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
795      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
796      */
797     function _safeMint(
798         address to,
799         uint256 tokenId,
800         bytes memory _data
801     ) internal virtual {
802         _mint(to, tokenId);
803         require(
804             _checkOnERC721Received(address(0), to, tokenId, _data),
805             "ERC721: transfer to non ERC721Receiver implementer"
806         );
807     }
808 
809     /**
810      * @dev Mints `tokenId` and transfers it to `to`.
811      *
812      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
813      *
814      * Requirements:
815      *
816      * - `tokenId` must not exist.
817      * - `to` cannot be the zero address.
818      *
819      * Emits a {Transfer} event.
820      */
821     function _mint(address to, uint256 tokenId) internal virtual {
822         require(to != address(0), "ERC721: mint to the zero address");
823         require(!_exists(tokenId), "ERC721: token already minted");
824 
825         _beforeTokenTransfer(address(0), to, tokenId);
826 
827         _balances[to] += 1;
828         _owners[tokenId] = to;
829     
830         emit Transfer(address(0), to, tokenId);
831     }
832 
833     /**
834      * @dev Destroys `tokenId`.
835      * The approval is cleared when the token is burned.
836      *
837      * Requirements:
838      *
839      * - `tokenId` must exist.
840      *
841      * Emits a {Transfer} event.
842      */
843     function _burn(uint256 tokenId) internal virtual {
844         address owner = ERC721.ownerOf(tokenId);
845 
846         _beforeTokenTransfer(owner, address(0), tokenId);
847 
848         // Clear approvals
849         _approve(address(0), tokenId);
850 
851         _balances[owner] -= 1;
852         delete _owners[tokenId];
853 
854         emit Transfer(owner, address(0), tokenId);
855     }
856 
857     /**
858      * @dev Transfers `tokenId` from `from` to `to`.
859      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
860      *
861      * Requirements:
862      *
863      * - `to` cannot be the zero address.
864      * - `tokenId` token must be owned by `from`.
865      *
866      * Emits a {Transfer} event.
867      */
868     function _transfer(
869         address from,
870         address to,
871         uint256 tokenId
872     ) internal virtual {
873         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
874         require(to != address(0), "ERC721: transfer to the zero address");
875 
876         _beforeTokenTransfer(from, to, tokenId);
877 
878         // Clear approvals from the previous owner
879         _approve(address(0), tokenId);
880 
881         _balances[from] -= 1;
882         _balances[to] += 1;
883         _owners[tokenId] = to;
884 
885         emit Transfer(from, to, tokenId);
886     }
887     
888     
889 
890     /**
891      * @dev Approve `to` to operate on `tokenId`
892      *
893      * Emits a {Approval} event.
894      */
895     function _approve(address to, uint256 tokenId) internal virtual {
896         _tokenApprovals[tokenId] = to;
897         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
898     }
899 
900     /**
901      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
902      * The call is not executed if the target address is not a contract.
903      *
904      * @param from address representing the previous owner of the given token ID
905      * @param to target address that will receive the tokens
906      * @param tokenId uint256 ID of the token to be transferred
907      * @param _data bytes optional data to send along with the call
908      * @return bool whether the call correctly returned the expected magic value
909      */
910     function _checkOnERC721Received(
911         address from,
912         address to,
913         uint256 tokenId,
914         bytes memory _data
915     ) private returns (bool) {
916         if (to.isContract()) {
917             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
918                 return retval == IERC721Receiver.onERC721Received.selector;
919             } catch (bytes memory reason) {
920                 if (reason.length == 0) {
921                     revert("ERC721: transfer to non ERC721Receiver implementer");
922                 } else {
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
943      * - `from` and `to` are never both zero.
944      *
945      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
946      */
947     function _beforeTokenTransfer(
948         address from,
949         address to,
950         uint256 tokenId
951     ) internal virtual {}
952 }
953 
954 
955 
956 
957  contract KittyCatNFT is ERC721, Ownable{
958      
959      uint256 public totalSupply = 0; // Total Supply
960      uint256 private constant totalSale = 10000; // for user minting
961      uint256 private constant reserved = 1000;  // for admin
962      uint256 public mintPrice = 4 * 10 ** 16;  // minting price 0.04 ETH
963      bool public publicSaleIsActive = false; // minting paused
964      uint256 public admin_mint = 0;
965      uint256 public user_mint = 0;
966     
967     
968       modifier checkPublicSaleIsActive {
969         require ( publicSaleIsActive == true, "Public Sale is not Started");
970         _;
971       }
972      
973      constructor() ERC721("KittyCatNFT", "KCACT"){}
974     
975     
976       function mintByUser(uint256 quantity) public checkPublicSaleIsActive payable{
977         
978         require(quantity > 0, "Mint Quantity should be more than zero");
979         require(user_mint < totalSale - reserved, "Minting End");
980         require(user_mint + quantity <= totalSale - reserved, "Max Limit To Total Sale");
981         require(quantity <= 10, "Exceeds Public Sale Amount");
982         require(mintPrice * quantity == msg.value, "Invalid Price To Mint");
983         
984         (bool success,) = owner().call{value: msg.value}("");
985          if(!success) {
986             revert("Payment Sending Failed");
987          }
988          else{
989              for (uint256 i=0; i < quantity; i++) {
990               totalSupply++;
991               user_mint++;
992              _safeMint(msg.sender,totalSupply);
993             }     
994          }
995         
996      } 
997      
998     
999     function setPublicSaleStatus() external onlyOwner {
1000         publicSaleIsActive = !publicSaleIsActive;
1001     }
1002     
1003     function setMintPrice(uint256 newPrice) external onlyOwner {
1004         mintPrice = newPrice;
1005     }
1006     
1007     function _setbaseURI(string memory _baseUri) external onlyOwner{
1008          baseUri = _baseUri;
1009     }
1010     
1011     function mintByOwner(address _to, uint256 quantity) public onlyOwner {
1012         require(admin_mint < reserved, "Admin Minting Limit is Exceed");
1013         require(admin_mint + quantity <= reserved, "Max Limit To Admin Mint");
1014 
1015         for (uint256 i=0; i<quantity; i++) {
1016              totalSupply++;
1017              admin_mint++;    
1018             _safeMint(_to,totalSupply);
1019         }
1020         
1021     }
1022     
1023     
1024     function batchMintByOwner(address[] memory mintAddressList,uint256[] memory quantityList) external onlyOwner {
1025         require (mintAddressList.length == quantityList.length, "The length should be same");
1026 
1027         for (uint256 i=0; i<mintAddressList.length; i++) {
1028             mintByOwner(mintAddressList[i], quantityList[i]);
1029         }
1030     }
1031      
1032    
1033 }