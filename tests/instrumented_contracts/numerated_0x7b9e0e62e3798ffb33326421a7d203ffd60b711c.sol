1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.14;
3 
4 library Strings {
5     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
6 
7     /**
8      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
9      */
10     function toString(uint256 value) internal pure returns (string memory) {
11         // Inspired by OraclizeAPI's implementation - MIT licence
12         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
13 
14         if (value == 0) {
15             return "0";
16         }
17         uint256 temp = value;
18         uint256 digits;
19         while (temp != 0) {
20             digits++;
21             temp /= 10;
22         }
23         bytes memory buffer = new bytes(digits);
24         while (value != 0) {
25             digits -= 1;
26             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
27             value /= 10;
28         }
29         return string(buffer);
30     }
31 
32     /**
33      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
34      */
35     function toHexString(uint256 value) internal pure returns (string memory) {
36         if (value == 0) {
37             return "0x00";
38         }
39         uint256 temp = value;
40         uint256 length = 0;
41         while (temp != 0) {
42             length++;
43             temp >>= 8;
44         }
45         return toHexString(value, length);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
50      */
51     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
52         bytes memory buffer = new bytes(2 * length + 2);
53         buffer[0] = "0";
54         buffer[1] = "x";
55         for (uint256 i = 2 * length + 1; i > 1; --i) {
56             buffer[i] = _HEX_SYMBOLS[value & 0xf];
57             value >>= 4;
58         }
59         require(value == 0, "Strings: hex length insufficient");
60         return string(buffer);
61     }
62 }
63 
64 abstract contract Context {
65     function _msgSender() internal view virtual returns (address) {
66         return msg.sender;
67     }
68 
69     function _msgData() internal view virtual returns (bytes calldata) {
70         return msg.data;
71     }
72 }
73 
74 library Address {
75     /**
76      * @dev Returns true if `account` is a contract.
77      *
78      * [IMPORTANT]
79      * ====
80      * It is unsafe to assume that an address for which this function returns
81      * false is an externally-owned account (EOA) and not a contract.
82      *
83      * Among others, `isContract` will return false for the following
84      * types of addresses:
85      *
86      *  - an externally-owned account
87      *  - a contract in construction
88      *  - an address where a contract will be created
89      *  - an address where a contract lived, but was destroyed
90      * ====
91      *
92      * [IMPORTANT]
93      * ====
94      * You shouldn't rely on `isContract` to protect against flash loan attacks!
95      *
96      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
97      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
98      * constructor.
99      * ====
100      */
101     function isContract(address account) internal view returns (bool) {
102         // This method relies on extcodesize/address.code.length, which returns 0
103         // for contracts in construction, since the code is only stored at the end
104         // of the constructor execution.
105 
106         return account.code.length > 0;
107     }
108 
109     /**
110      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
111      * `recipient`, forwarding all available gas and reverting on errors.
112      *
113      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
114      * of certain opcodes, possibly making contracts go over the 2300 gas limit
115      * imposed by `transfer`, making them unable to receive funds via
116      * `transfer`. {sendValue} removes this limitation.
117      *
118      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
119      *
120      * IMPORTANT: because control is transferred to `recipient`, care must be
121      * taken to not create reentrancy vulnerabilities. Consider using
122      * {ReentrancyGuard} or the
123      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
124      */
125     function sendValue(address payable recipient, uint256 amount) internal {
126         require(address(this).balance >= amount, "Address: insufficient balance");
127 
128         (bool success, ) = recipient.call{value: amount}("");
129         require(success, "Address: unable to send value, recipient may have reverted");
130     }
131 
132     /**
133      * @dev Performs a Solidity function call using a low level `call`. A
134      * plain `call` is an unsafe replacement for a function call: use this
135      * function instead.
136      *
137      * If `target` reverts with a revert reason, it is bubbled up by this
138      * function (like regular Solidity function calls).
139      *
140      * Returns the raw returned data. To convert to the expected return value,
141      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
142      *
143      * Requirements:
144      *
145      * - `target` must be a contract.
146      * - calling `target` with `data` must not revert.
147      *
148      * _Available since v3.1._
149      */
150     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
151         return functionCall(target, data, "Address: low-level call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
156      * `errorMessage` as a fallback revert reason when `target` reverts.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal returns (bytes memory) {
165         return functionCallWithValue(target, data, 0, errorMessage);
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
170      * but also transferring `value` wei to `target`.
171      *
172      * Requirements:
173      *
174      * - the calling contract must have an ETH balance of at least `value`.
175      * - the called Solidity function must be `payable`.
176      *
177      * _Available since v3.1._
178      */
179     function functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 value
183     ) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
189      * with `errorMessage` as a fallback revert reason when `target` reverts.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         require(address(this).balance >= value, "Address: insufficient balance for call");
200         require(isContract(target), "Address: call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.call{value: value}(data);
203         return verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
208      * but performing a static call.
209      *
210      * _Available since v3.3._
211      */
212     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
213         return functionStaticCall(target, data, "Address: low-level static call failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
218      * but performing a static call.
219      *
220      * _Available since v3.3._
221      */
222     function functionStaticCall(
223         address target,
224         bytes memory data,
225         string memory errorMessage
226     ) internal view returns (bytes memory) {
227         require(isContract(target), "Address: static call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.staticcall(data);
230         return verifyCallResult(success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but performing a delegate call.
236      *
237      * _Available since v3.4._
238      */
239     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
240         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
245      * but performing a delegate call.
246      *
247      * _Available since v3.4._
248      */
249     function functionDelegateCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal returns (bytes memory) {
254         require(isContract(target), "Address: delegate call to non-contract");
255 
256         (bool success, bytes memory returndata) = target.delegatecall(data);
257         return verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
262      * revert reason using the provided one.
263      *
264      * _Available since v4.3._
265      */
266     function verifyCallResult(
267         bool success,
268         bytes memory returndata,
269         string memory errorMessage
270     ) internal pure returns (bytes memory) {
271         if (success) {
272             return returndata;
273         } else {
274             // Look for revert reason and bubble it up if present
275             if (returndata.length > 0) {
276                 // The easiest way to bubble the revert reason is using memory via assembly
277 
278                 assembly {
279                     let returndata_size := mload(returndata)
280                     revert(add(32, returndata), returndata_size)
281                 }
282             } else {
283                 revert(errorMessage);
284             }
285         }
286     }
287 }
288 
289 abstract contract Ownable is Context {
290     address private _owner;
291 
292     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
293 
294     /**
295      * @dev Initializes the contract setting the deployer as the initial owner.
296      */
297     constructor() {
298         _transferOwnership(_msgSender());
299     }
300 
301     /**
302      * @dev Returns the address of the current owner.
303      */
304     function owner() public view virtual returns (address) {
305         return _owner;
306     }
307 
308     /**
309      * @dev Throws if called by any account other than the owner.
310      */
311     modifier onlyOwner() {
312         require(owner() == _msgSender(), "Ownable: caller is not the owner");
313         _;
314     }
315 
316     /**
317      * @dev Leaves the contract without owner. It will not be possible to call
318      * `onlyOwner` functions anymore. Can only be called by the current owner.
319      *
320      * NOTE: Renouncing ownership will leave the contract without an owner,
321      * thereby removing any functionality that is only available to the owner.
322      */
323     function renounceOwnership() public virtual onlyOwner {
324         _transferOwnership(address(0));
325     }
326 
327     /**
328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
329      * Can only be called by the current owner.
330      */
331     function transferOwnership(address newOwner) public virtual onlyOwner {
332         require(newOwner != address(0), "Ownable: new owner is the zero address");
333         _transferOwnership(newOwner);
334     }
335 
336     /**
337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
338      * Internal function without access restriction.
339      */
340     function _transferOwnership(address newOwner) internal virtual {
341         address oldOwner = _owner;
342         _owner = newOwner;
343         emit OwnershipTransferred(oldOwner, newOwner);
344     }
345 }
346 
347 interface IERC721Receiver {
348     /**
349      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
350      * by `operator` from `from`, this function is called.
351      *
352      * It must return its Solidity selector to confirm the token transfer.
353      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
354      *
355      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
356      */
357     function onERC721Received(
358         address operator,
359         address from,
360         uint256 tokenId,
361         bytes calldata data
362     ) external returns (bytes4);
363 }
364 
365 interface IERC165 {
366     /**
367      * @dev Returns true if this contract implements the interface defined by
368      * `interfaceId`. See the corresponding
369      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
370      * to learn more about how these ids are created.
371      *
372      * This function call must use less than 30 000 gas.
373      */
374     function supportsInterface(bytes4 interfaceId) external view returns (bool);
375 }
376 
377 abstract contract ERC165 is IERC165 {
378     /**
379      * @dev See {IERC165-supportsInterface}.
380      */
381     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
382         return interfaceId == type(IERC165).interfaceId;
383     }
384 }
385 
386 interface IERC721 is IERC165 {
387     /**
388      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
389      */
390     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
391 
392     /**
393      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
394      */
395     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
399      */
400     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
401 
402     /**
403      * @dev Returns the number of tokens in ``owner``'s account.
404      */
405     function balanceOf(address owner) external view returns (uint256 balance);
406 
407     /**
408      * @dev Returns the owner of the `tokenId` token.
409      *
410      * Requirements:
411      *
412      * - `tokenId` must exist.
413      */
414     function ownerOf(uint256 tokenId) external view returns (address owner);
415 
416     /**
417      * @dev Safely transfers `tokenId` token from `from` to `to`.
418      *
419      * Requirements:
420      *
421      * - `from` cannot be the zero address.
422      * - `to` cannot be the zero address.
423      * - `tokenId` token must exist and be owned by `from`.
424      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
426      *
427      * Emits a {Transfer} event.
428      */
429     function safeTransferFrom(
430         address from,
431         address to,
432         uint256 tokenId,
433         bytes calldata data
434     ) external;
435 
436     /**
437      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
438      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must exist and be owned by `from`.
445      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
446      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
447      *
448      * Emits a {Transfer} event.
449      */
450     function safeTransferFrom(
451         address from,
452         address to,
453         uint256 tokenId
454     ) external;
455 
456     /**
457      * @dev Transfers `tokenId` token from `from` to `to`.
458      *
459      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `tokenId` token must be owned by `from`.
466      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
467      *
468      * Emits a {Transfer} event.
469      */
470     function transferFrom(
471         address from,
472         address to,
473         uint256 tokenId
474     ) external;
475 
476     /**
477      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
478      * The approval is cleared when the token is transferred.
479      *
480      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
481      *
482      * Requirements:
483      *
484      * - The caller must own the token or be an approved operator.
485      * - `tokenId` must exist.
486      *
487      * Emits an {Approval} event.
488      */
489     function approve(address to, uint256 tokenId) external;
490 
491     /**
492      * @dev Approve or remove `operator` as an operator for the caller.
493      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
494      *
495      * Requirements:
496      *
497      * - The `operator` cannot be the caller.
498      *
499      * Emits an {ApprovalForAll} event.
500      */
501     function setApprovalForAll(address operator, bool _approved) external;
502 
503     /**
504      * @dev Returns the account approved for `tokenId` token.
505      *
506      * Requirements:
507      *
508      * - `tokenId` must exist.
509      */
510     function getApproved(uint256 tokenId) external view returns (address operator);
511 
512     /**
513      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
514      *
515      * See {setApprovalForAll}
516      */
517     function isApprovedForAll(address owner, address operator) external view returns (bool);
518 }
519 
520 interface IERC721Metadata is IERC721 {
521     /**
522      * @dev Returns the token collection name.
523      */
524     function name() external view returns (string memory);
525 
526     /**
527      * @dev Returns the token collection symbol.
528      */
529     function symbol() external view returns (string memory);
530 
531     /**
532      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
533      */
534     function tokenURI(uint256 tokenId) external view returns (string memory);
535 }
536 
537 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
538     using Address for address;
539     using Strings for uint256;
540 
541     // Token name
542     string private _name;
543 
544     // Token symbol
545     string private _symbol;
546 
547     // Mapping from token ID to owner address
548     mapping(uint256 => address) private _owners;
549 
550     // Mapping owner address to token count
551     mapping(address => uint256) private _balances;
552 
553     // Mapping from token ID to approved address
554     mapping(uint256 => address) private _tokenApprovals;
555 
556     // Mapping from owner to operator approvals
557     mapping(address => mapping(address => bool)) private _operatorApprovals;
558 
559     /**
560      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
561      */
562     constructor(string memory name_, string memory symbol_) {
563         _name = name_;
564         _symbol = symbol_;
565     }
566 
567     /**
568      * @dev See {IERC165-supportsInterface}.
569      */
570     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
571         return
572             interfaceId == type(IERC721).interfaceId ||
573             interfaceId == type(IERC721Metadata).interfaceId ||
574             super.supportsInterface(interfaceId);
575     }
576 
577     /**
578      * @dev See {IERC721-balanceOf}.
579      */
580     function balanceOf(address owner) public view virtual override returns (uint256) {
581         require(owner != address(0), "ERC721: balance query for the zero address");
582         return _balances[owner];
583     }
584 
585     /**
586      * @dev See {IERC721-ownerOf}.
587      */
588     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
589         address owner = _owners[tokenId];
590         require(owner != address(0), "ERC721: owner query for nonexistent token");
591         return owner;
592     }
593 
594     /**
595      * @dev See {IERC721Metadata-name}.
596      */
597     function name() public view virtual override returns (string memory) {
598         return _name;
599     }
600 
601     /**
602      * @dev See {IERC721Metadata-symbol}.
603      */
604     function symbol() public view virtual override returns (string memory) {
605         return _symbol;
606     }
607 
608     /**
609      * @dev See {IERC721Metadata-tokenURI}.
610      */
611     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
612         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
613 
614         string memory baseURI = _baseURI();
615         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
616     }
617 
618     /**
619      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
620      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
621      * by default, can be overridden in child contracts.
622      */
623     function _baseURI() internal view virtual returns (string memory) {
624         return "";
625     }
626 
627     /**
628      * @dev See {IERC721-approve}.
629      */
630     function approve(address to, uint256 tokenId) public virtual override {
631         address owner = ERC721.ownerOf(tokenId);
632         require(to != owner, "ERC721: approval to current owner");
633 
634         require(
635             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
636             "ERC721: approve caller is not owner nor approved for all"
637         );
638 
639         _approve(to, tokenId);
640     }
641 
642     /**
643      * @dev See {IERC721-getApproved}.
644      */
645     function getApproved(uint256 tokenId) public view virtual override returns (address) {
646         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
647 
648         return _tokenApprovals[tokenId];
649     }
650 
651     /**
652      * @dev See {IERC721-setApprovalForAll}.
653      */
654     function setApprovalForAll(address operator, bool approved) public virtual override {
655         _setApprovalForAll(_msgSender(), operator, approved);
656     }
657 
658     /**
659      * @dev See {IERC721-isApprovedForAll}.
660      */
661     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
662         return _operatorApprovals[owner][operator];
663     }
664 
665     /**
666      * @dev See {IERC721-transferFrom}.
667      */
668     function transferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) public virtual override {
673         //solhint-disable-next-line max-line-length
674         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
675 
676         _transfer(from, to, tokenId);
677     }
678 
679     /**
680      * @dev See {IERC721-safeTransferFrom}.
681      */
682     function safeTransferFrom(
683         address from,
684         address to,
685         uint256 tokenId
686     ) public virtual override {
687         safeTransferFrom(from, to, tokenId, "");
688     }
689 
690     /**
691      * @dev See {IERC721-safeTransferFrom}.
692      */
693     function safeTransferFrom(
694         address from,
695         address to,
696         uint256 tokenId,
697         bytes memory _data
698     ) public virtual override {
699         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
700         _safeTransfer(from, to, tokenId, _data);
701     }
702 
703     /**
704      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
705      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
706      *
707      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
708      *
709      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
710      * implement alternative mechanisms to perform token transfer, such as signature-based.
711      *
712      * Requirements:
713      *
714      * - `from` cannot be the zero address.
715      * - `to` cannot be the zero address.
716      * - `tokenId` token must exist and be owned by `from`.
717      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
718      *
719      * Emits a {Transfer} event.
720      */
721     function _safeTransfer(
722         address from,
723         address to,
724         uint256 tokenId,
725         bytes memory _data
726     ) internal virtual {
727         _transfer(from, to, tokenId);
728         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
729     }
730 
731     /**
732      * @dev Returns whether `tokenId` exists.
733      *
734      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
735      *
736      * Tokens start existing when they are minted (`_mint`),
737      * and stop existing when they are burned (`_burn`).
738      */
739     function _exists(uint256 tokenId) internal view virtual returns (bool) {
740         return _owners[tokenId] != address(0);
741     }
742 
743     /**
744      * @dev Returns whether `spender` is allowed to manage `tokenId`.
745      *
746      * Requirements:
747      *
748      * - `tokenId` must exist.
749      */
750     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
751         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
752         address owner = ERC721.ownerOf(tokenId);
753         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
754     }
755 
756     /**
757      * @dev Safely mints `tokenId` and transfers it to `to`.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must not exist.
762      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
763      *
764      * Emits a {Transfer} event.
765      */
766     function _safeMint(address to, uint256 tokenId) internal virtual {
767         _safeMint(to, tokenId, "");
768     }
769 
770     /**
771      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
772      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
773      */
774     function _safeMint(
775         address to,
776         uint256 tokenId,
777         bytes memory _data
778     ) internal virtual {
779         _mint(to, tokenId);
780         require(
781             _checkOnERC721Received(address(0), to, tokenId, _data),
782             "ERC721: transfer to non ERC721Receiver implementer"
783         );
784     }
785 
786     /**
787      * @dev Mints `tokenId` and transfers it to `to`.
788      *
789      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
790      *
791      * Requirements:
792      *
793      * - `tokenId` must not exist.
794      * - `to` cannot be the zero address.
795      *
796      * Emits a {Transfer} event.
797      */
798     function _mint(address to, uint256 tokenId) internal virtual {
799         require(to != address(0), "ERC721: mint to the zero address");
800         require(!_exists(tokenId), "ERC721: token already minted");
801 
802         _beforeTokenTransfer(address(0), to, tokenId);
803 
804         _balances[to] += 1;
805         _owners[tokenId] = to;
806 
807         emit Transfer(address(0), to, tokenId);
808 
809         _afterTokenTransfer(address(0), to, tokenId);
810     }
811 
812     /**
813      * @dev Destroys `tokenId`.
814      * The approval is cleared when the token is burned.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must exist.
819      *
820      * Emits a {Transfer} event.
821      */
822     function _burn(uint256 tokenId) internal virtual {
823         address owner = ERC721.ownerOf(tokenId);
824 
825         _beforeTokenTransfer(owner, address(0), tokenId);
826 
827         // Clear approvals
828         _approve(address(0), tokenId);
829 
830         _balances[owner] -= 1;
831         delete _owners[tokenId];
832 
833         emit Transfer(owner, address(0), tokenId);
834 
835         _afterTokenTransfer(owner, address(0), tokenId);
836     }
837 
838     /**
839      * @dev Transfers `tokenId` from `from` to `to`.
840      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
841      *
842      * Requirements:
843      *
844      * - `to` cannot be the zero address.
845      * - `tokenId` token must be owned by `from`.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _transfer(
850         address from,
851         address to,
852         uint256 tokenId
853     ) internal virtual {
854         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
855         require(to != address(0), "ERC721: transfer to the zero address");
856 
857         _beforeTokenTransfer(from, to, tokenId);
858 
859         // Clear approvals from the previous owner
860         _approve(address(0), tokenId);
861 
862         _balances[from] -= 1;
863         _balances[to] += 1;
864         _owners[tokenId] = to;
865 
866         emit Transfer(from, to, tokenId);
867 
868         _afterTokenTransfer(from, to, tokenId);
869     }
870 
871     /**
872      * @dev Approve `to` to operate on `tokenId`
873      *
874      * Emits a {Approval} event.
875      */
876     function _approve(address to, uint256 tokenId) internal virtual {
877         _tokenApprovals[tokenId] = to;
878         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
879     }
880 
881     /**
882      * @dev Approve `operator` to operate on all of `owner` tokens
883      *
884      * Emits a {ApprovalForAll} event.
885      */
886     function _setApprovalForAll(
887         address owner,
888         address operator,
889         bool approved
890     ) internal virtual {
891         require(owner != operator, "ERC721: approve to caller");
892         _operatorApprovals[owner][operator] = approved;
893         emit ApprovalForAll(owner, operator, approved);
894     }
895 
896     /**
897      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
898      * The call is not executed if the target address is not a contract.
899      *
900      * @param from address representing the previous owner of the given token ID
901      * @param to target address that will receive the tokens
902      * @param tokenId uint256 ID of the token to be transferred
903      * @param _data bytes optional data to send along with the call
904      * @return bool whether the call correctly returned the expected magic value
905      */
906     function _checkOnERC721Received(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) private returns (bool) {
912         if (to.isContract()) {
913             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
914                 return retval == IERC721Receiver.onERC721Received.selector;
915             } catch (bytes memory reason) {
916                 if (reason.length == 0) {
917                     revert("ERC721: transfer to non ERC721Receiver implementer");
918                 } else {
919                     assembly {
920                         revert(add(32, reason), mload(reason))
921                     }
922                 }
923             }
924         } else {
925             return true;
926         }
927     }
928 
929     /**
930      * @dev Hook that is called before any token transfer. This includes minting
931      * and burning.
932      *
933      * Calling conditions:
934      *
935      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
936      * transferred to `to`.
937      * - When `from` is zero, `tokenId` will be minted for `to`.
938      * - When `to` is zero, ``from``'s `tokenId` will be burned.
939      * - `from` and `to` are never both zero.
940      *
941      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
942      */
943     function _beforeTokenTransfer(
944         address from,
945         address to,
946         uint256 tokenId
947     ) internal virtual {}
948 
949     /**
950      * @dev Hook that is called after any transfer of tokens. This includes
951      * minting and burning.
952      *
953      * Calling conditions:
954      *
955      * - when `from` and `to` are both non-zero.
956      * - `from` and `to` are never both zero.
957      *
958      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
959      */
960     function _afterTokenTransfer(
961         address from,
962         address to,
963         uint256 tokenId
964     ) internal virtual {}
965 }
966 
967 abstract contract ReentrancyGuard {
968     // Booleans are more expensive than uint256 or any type that takes up a full
969     // word because each write operation emits an extra SLOAD to first read the
970     // slot's contents, replace the bits taken up by the boolean, and then write
971     // back. This is the compiler's defense against contract upgrades and
972     // pointer aliasing, and it cannot be disabled.
973 
974     // The values being non-zero value makes deployment a bit more expensive,
975     // but in exchange the refund on every call to nonReentrant will be lower in
976     // amount. Since refunds are capped to a percentage of the total
977     // transaction's gas, it is best to keep them low in cases like this one, to
978     // increase the likelihood of the full refund coming into effect.
979     uint256 private constant _NOT_ENTERED = 1;
980     uint256 private constant _ENTERED = 2;
981 
982     uint256 private _status;
983 
984     constructor() {
985         _status = _NOT_ENTERED;
986     }
987 
988     /**
989      * @dev Prevents a contract from calling itself, directly or indirectly.
990      * Calling a `nonReentrant` function from another `nonReentrant`
991      * function is not supported. It is possible to prevent this from happening
992      * by making the `nonReentrant` function external, and making it call a
993      * `private` function that does the actual work.
994      */
995     modifier nonReentrant() {
996         // On the first call to nonReentrant, _notEntered will be true
997         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
998 
999         // Any calls to nonReentrant after this point will fail
1000         _status = _ENTERED;
1001 
1002         _;
1003 
1004         // By storing the original value once again, a refund is triggered (see
1005         // https://eips.ethereum.org/EIPS/eip-2200)
1006         _status = _NOT_ENTERED;
1007     }
1008 }
1009 
1010 contract NFT is ERC721, ReentrancyGuard, Ownable {
1011     using Address for address;
1012     using Strings for uint256;
1013 
1014     struct TokenInfo {
1015         uint8 rarity; // 0 - community, 1 - ultimate
1016     }
1017 
1018     mapping(uint256 => TokenInfo) public tokenInfo;
1019 
1020     address private sys;
1021 
1022     uint256 private supply;
1023     uint256 private community_supply;
1024     uint256 private ultimate_supply;
1025     uint256 private reserveUltimateMinted;
1026     uint256 private reserveCommunityMinted;
1027 
1028     uint256 private immutable MAX_SUPPLY = 4500;
1029     uint256 private immutable MAX_COMMUNITY = 4000;
1030     uint256 private immutable MAX_ULTIMATE = 500;
1031     uint256 private immutable MAX_SALE_COMMUNITY = 3800;
1032     uint256 private immutable MAX_SALE_ULTIMATE = 475;
1033     uint256 private immutable MAX_MINT_PRIVATE = 1900;
1034 
1035     uint256 private immutable community_price = 0.05 ether;
1036     uint256 private immutable ultimate_price = 1 ether;
1037 
1038     uint256 public unlimited_pass_mint_start = 1654790400;
1039     uint256 public unlimited_pass_mint_end = 1655049600;
1040 
1041     uint256 public private_mint_start = 1654876800;
1042     uint256 public private_mint_end = 1655049600;
1043 
1044     uint256 public public_mint_start = 1655067600;
1045     uint256 public public_mint_nex = 1655154000;
1046 
1047     mapping(address => uint256) private publicMintCount;
1048     mapping(address => uint256) private privateMintCount;
1049     mapping(address => bool) private ultimateMinted;
1050 
1051     bool private uriForEach;
1052     string private baseURI_;
1053     string private baseExtension_;
1054     string private communityURI;
1055     string private ultimateURI;
1056 
1057     constructor(address _sys, string memory commURI, string memory ultiURI) ERC721("InfiniGods", "INFG") {
1058         sys = _sys;
1059         communityURI = commURI;
1060         ultimateURI = ultiURI;
1061     }
1062 
1063     /// @dev View Functions
1064 
1065     function totalSupply() external view virtual returns (uint256) {
1066         return supply;
1067     }
1068 
1069     function communitySupply() external view virtual returns (uint256) {
1070         return community_supply;
1071     }
1072 
1073     function ultimateSupply() external view virtual returns (uint256) {
1074         return ultimate_supply;
1075     }
1076 
1077     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1078         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1079         if (uriForEach) {
1080             string memory baseURI = _baseURI();
1081             string memory baseExtension = _baseExtension();
1082             return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension)) : "";
1083         } else {
1084             if (tokenInfo[tokenId].rarity == 1) {
1085                 return ultimateURI;
1086             } else {
1087                 return communityURI;
1088             }
1089         }
1090         
1091     }
1092 
1093     function hasMintedUltimate(address wallet) external view returns (bool) {
1094         return ultimateMinted[wallet];
1095     }
1096 
1097     function hasMintedPrivate(address wallet) external view returns (bool) {
1098         return privateMintCount[wallet] == 1;
1099     }
1100 
1101     function canMintPublic(address wallet) external view returns (uint256) {
1102         if (block.timestamp < public_mint_start) {
1103             return 0;
1104         } else if (block.timestamp >= public_mint_start && block.timestamp < public_mint_nex) {
1105             return 1 - publicMintCount[wallet];
1106         } else if (block.timestamp >= public_mint_nex) {
1107             uint256 can = 5 - publicMintCount[wallet];
1108             if (can > MAX_SALE_COMMUNITY - community_supply) {
1109                 return MAX_SALE_COMMUNITY - community_supply;
1110             } else {
1111                 return can;
1112             }
1113         }
1114     }
1115 
1116     function getTokenRarity(uint256 tokenId) external view virtual returns (uint8) {
1117         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1118         return tokenInfo[tokenId].rarity;
1119     }
1120 
1121     function getLeftForCurrentRound() external view virtual returns (uint256 _ultimate, uint256 _private, uint256 _public, uint256 _totalCommunity) {
1122         if (block.timestamp <= unlimited_pass_mint_end) {
1123             _ultimate = MAX_SALE_ULTIMATE - ultimate_supply;
1124         }
1125         if (block.timestamp <= private_mint_end) {
1126             _private = MAX_MINT_PRIVATE - community_supply;
1127         }
1128         if (block.timestamp >= public_mint_start) {
1129             _public = MAX_SALE_COMMUNITY - community_supply;
1130         }
1131         _totalCommunity = MAX_SALE_COMMUNITY - community_supply;
1132     }
1133 
1134     /// @dev Public Functions
1135 
1136     function mintUltimate(bytes memory sig) external payable nonReentrant {
1137         require(block.timestamp >= unlimited_pass_mint_start, "Minting has not yet started (Unlim)");
1138         require(block.timestamp <= unlimited_pass_mint_end, "Minting has finished (Unlim)");
1139         require(verify(_msgSender(), 1, sig), "Verification failed!");
1140         require(ultimate_price <= msg.value, "Not enough payed");
1141         require(ultimate_supply + 1 <= MAX_SALE_ULTIMATE, "Supply would be exceeded. Try minting less");
1142         require(!ultimateMinted[_msgSender()], "You have already minted in this round");
1143         ultimateMinted[_msgSender()] = true;
1144         ultimate_supply += 1;
1145         supply += 1;
1146         _safeMint(_msgSender(), supply);
1147         tokenInfo[supply].rarity = 1;
1148         if (msg.value > ultimate_price) {
1149             payable(_msgSender()).transfer(msg.value - ultimate_price);
1150         }
1151     } 
1152 
1153     function mintCommunity(uint256 amount, bytes memory sig) external payable nonReentrant {
1154         require(amount != 0);
1155         require(block.timestamp >= private_mint_start, "Minting has not started (Comm)");
1156         require(msg.value >= community_price * amount, "Not enough payed!");
1157         if (block.timestamp > private_mint_end) { // Public Mint
1158             require(block.timestamp >= public_mint_start, "Minting is not active");
1159             require(community_supply + amount <= MAX_SALE_COMMUNITY, "Community supply would be exceeded");
1160             if (block.timestamp < public_mint_nex) {
1161                 require(publicMintCount[_msgSender()] == 0, "You have already minted your limit, please come back later");
1162                 _mintPublic(1, _msgSender());
1163                 if (msg.value > community_price) {
1164                     payable(_msgSender()).transfer(msg.value - community_price);
1165                 }
1166             } else {
1167                 require(publicMintCount[_msgSender()] + amount <= 5, "Limit reached!");
1168                 _mintPublic(amount, _msgSender());
1169                 if (msg.value > community_price * amount) {
1170                     payable(_msgSender()).transfer(msg.value - community_price);
1171                 }
1172             }
1173         } else { // Private Mint
1174             require(verify(_msgSender(), 2, sig), "Access denied!");
1175             require(privateMintCount[_msgSender()] == 0, "Only one NFT per wallet during private mint");
1176             require(community_supply + 1 <= MAX_MINT_PRIVATE, "Total of 1900 NFTs has been minted!");
1177             _mintPrivate(_msgSender());
1178             if (msg.value > community_price) {
1179                 payable(_msgSender()).transfer(msg.value - community_price);
1180             }
1181         }
1182     }
1183 
1184     /// @dev OnlyOwner Functions
1185 
1186     function changeStdUri(string memory commUri, string memory ultiUri) external onlyOwner {
1187         communityURI = commUri;
1188         ultimateURI = ultiUri;
1189     }
1190 
1191     function changeURIForAll(bool value) external onlyOwner {
1192         uriForEach = value;
1193     }
1194 
1195     function withdraw() external onlyOwner {
1196         payable(owner()).transfer(address(this).balance);
1197     }
1198 
1199     function freeMintUltimate(uint256 amount) external onlyOwner {
1200         if (block.timestamp <= unlimited_pass_mint_end) {
1201             require(reserveUltimateMinted + amount <= MAX_ULTIMATE - MAX_SALE_ULTIMATE);
1202         } else {
1203             uint256 available = (MAX_ULTIMATE - reserveUltimateMinted - ultimate_supply);
1204             require(amount <= available);
1205         }
1206         reserveUltimateMinted += amount;
1207         for (uint256 i; i < amount; i++) {
1208             supply ++;
1209             _safeMint(owner(), supply);
1210             tokenInfo[supply].rarity = 1;
1211         }
1212     }
1213 
1214     function freeMintStandard(uint256 amount) external onlyOwner {
1215         require(reserveCommunityMinted + amount <= MAX_COMMUNITY - MAX_SALE_COMMUNITY);
1216         reserveCommunityMinted += amount;
1217         for (uint256 i; i < amount; i++) {
1218             supply ++;
1219             _safeMint(owner(), supply);
1220         }
1221     }
1222 
1223     function setBaseURI(string memory _newURI) external onlyOwner {
1224         baseURI_ = _newURI;
1225     }
1226 
1227     function setBaseExtension(string memory _newExtension) external onlyOwner {
1228         baseExtension_ = _newExtension;
1229     }
1230 
1231     function changeSys(address _sys) external onlyOwner {
1232         sys = _sys;
1233     }
1234 
1235     /// @dev Internal Functions
1236 
1237     function _baseURI() internal view virtual override returns (string memory) {
1238         return baseURI_;
1239     }
1240 
1241     function _baseExtension() internal view virtual returns (string memory) {
1242         return baseExtension_;
1243     }
1244 
1245     function _mintPrivate(address user) internal {
1246         privateMintCount[user] = 1;
1247         community_supply += 1;
1248         supply += 1;
1249         _safeMint(user, supply);
1250     }
1251 
1252     function _mintPublic(uint256 amount, address user) internal {
1253         publicMintCount[user] += amount;
1254         community_supply += amount;
1255         for (uint256 i; i < amount; i++) {
1256             supply += 1;
1257             _safeMint(user, supply);
1258         }
1259     }
1260 
1261     function verify(address user, uint256 round, bytes memory sig) internal view returns (bool) {
1262         bytes32 messageHash = getMessageHash(user, round);
1263         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
1264         return recoverSigner(ethSignedMessageHash, sig) == sys;
1265     }
1266 
1267     function getMessageHash(address user, uint256 round) public pure returns (bytes32) {
1268         return keccak256(abi.encodePacked(user, round));
1269     }
1270 
1271     function getEthSignedMessageHash(bytes32 _messageHash) internal pure returns (bytes32) {
1272         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
1273     }
1274 
1275     function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) internal pure returns (address) {
1276         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
1277         return ecrecover(_ethSignedMessageHash, v, r, s);
1278     }
1279 
1280     function splitSignature(bytes memory sig) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
1281         require(sig.length == 65, "invalid signature length");
1282         assembly {
1283             r := mload(add(sig, 32))
1284             s := mload(add(sig, 64))
1285             v := byte(0, mload(add(sig, 96)))
1286         }
1287     }
1288 
1289 }