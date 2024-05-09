1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
4 
5 
6 library Counters {
7     struct Counter {
8         // This variable should never be directly accessed by users of the library: interactions must be restricted to
9         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
10         // this feature: see https://github.com/ethereum/solidity/issues/4637
11         uint256 _value; // default: 0
12     }
13 
14     function current(Counter storage counter) internal view returns (uint256) {
15         return counter._value;
16     }
17 
18     function increment(Counter storage counter) internal {
19         unchecked {
20             counter._value += 1;
21         }
22     }
23 
24     function decrement(Counter storage counter) internal {
25         uint256 value = counter._value;
26         require(value > 0, "Counter: decrement overflow");
27         unchecked {
28             counter._value = value - 1;
29         }
30     }
31 
32     function reset(Counter storage counter) internal {
33         counter._value = 0;
34     }
35 }
36 
37 
38 interface IERC721Receiver {
39     /**
40      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
41      * by `operator` from `from`, this function is called.
42      *
43      * It must return its Solidity selector to confirm the token transfer.
44      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
45      *
46      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
47      */
48     function onERC721Received(
49         address operator,
50         address from,
51         uint256 tokenId,
52         bytes calldata data
53     ) external returns (bytes4);
54 }
55 
56 
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 }
116 
117 
118 library Address {
119     /**
120      * @dev Returns true if `account` is a contract.
121      *
122      * [IMPORTANT]
123      * ====
124      * It is unsafe to assume that an address for which this function returns
125      * false is an externally-owned account (EOA) and not a contract.
126      *
127      * Among others, `isContract` will return false for the following
128      * types of addresses:
129      *
130      *  - an externally-owned account
131      *  - a contract in construction
132      *  - an address where a contract will be created
133      *  - an address where a contract lived, but was destroyed
134      * ====
135      */
136     function isContract(address account) internal view returns (bool) {
137         // This method relies on extcodesize, which returns 0 for contracts in
138         // construction, since the code is only stored at the end of the
139         // constructor execution.
140 
141         uint256 size;
142         assembly {
143             size := extcodesize(account)
144         }
145         return size > 0;
146     }
147 
148     /**
149      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
150      * `recipient`, forwarding all available gas and reverting on errors.
151      *
152      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
153      * of certain opcodes, possibly making contracts go over the 2300 gas limit
154      * imposed by `transfer`, making them unable to receive funds via
155      * `transfer`. {sendValue} removes this limitation.
156      *
157      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
158      *
159      * IMPORTANT: because control is transferred to `recipient`, care must be
160      * taken to not create reentrancy vulnerabilities. Consider using
161      * {ReentrancyGuard} or the
162      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
163      */
164     function sendValue(address payable recipient, uint256 amount) internal {
165         require(address(this).balance >= amount, "Address: insufficient balance");
166 
167         (bool success, ) = recipient.call{value: amount}("");
168         require(success, "Address: unable to send value, recipient may have reverted");
169     }
170 
171     /**
172      * @dev Performs a Solidity function call using a low level `call`. A
173      * plain `call` is an unsafe replacement for a function call: use this
174      * function instead.
175      *
176      * If `target` reverts with a revert reason, it is bubbled up by this
177      * function (like regular Solidity function calls).
178      *
179      * Returns the raw returned data. To convert to the expected return value,
180      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
181      *
182      * Requirements:
183      *
184      * - `target` must be a contract.
185      * - calling `target` with `data` must not revert.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
190         return functionCall(target, data, "Address: low-level call failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
195      * `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCall(
200         address target,
201         bytes memory data,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, 0, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but also transferring `value` wei to `target`.
210      *
211      * Requirements:
212      *
213      * - the calling contract must have an ETH balance of at least `value`.
214      * - the called Solidity function must be `payable`.
215      *
216      * _Available since v3.1._
217      */
218     function functionCallWithValue(
219         address target,
220         bytes memory data,
221         uint256 value
222     ) internal returns (bytes memory) {
223         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
228      * with `errorMessage` as a fallback revert reason when `target` reverts.
229      *
230      * _Available since v3.1._
231      */
232     function functionCallWithValue(
233         address target,
234         bytes memory data,
235         uint256 value,
236         string memory errorMessage
237     ) internal returns (bytes memory) {
238         require(address(this).balance >= value, "Address: insufficient balance for call");
239         require(isContract(target), "Address: call to non-contract");
240 
241         (bool success, bytes memory returndata) = target.call{value: value}(data);
242         return verifyCallResult(success, returndata, errorMessage);
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
247      * but performing a static call.
248      *
249      * _Available since v3.3._
250      */
251     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
252         return functionStaticCall(target, data, "Address: low-level static call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
257      * but performing a static call.
258      *
259      * _Available since v3.3._
260      */
261     function functionStaticCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal view returns (bytes memory) {
266         require(isContract(target), "Address: static call to non-contract");
267 
268         (bool success, bytes memory returndata) = target.staticcall(data);
269         return verifyCallResult(success, returndata, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but performing a delegate call.
275      *
276      * _Available since v3.4._
277      */
278     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
284      * but performing a delegate call.
285      *
286      * _Available since v3.4._
287      */
288     function functionDelegateCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         require(isContract(target), "Address: delegate call to non-contract");
294 
295         (bool success, bytes memory returndata) = target.delegatecall(data);
296         return verifyCallResult(success, returndata, errorMessage);
297     }
298 
299     /**
300      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
301      * revert reason using the provided one.
302      *
303      * _Available since v4.3._
304      */
305     function verifyCallResult(
306         bool success,
307         bytes memory returndata,
308         string memory errorMessage
309     ) internal pure returns (bytes memory) {
310         if (success) {
311             return returndata;
312         } else {
313             // Look for revert reason and bubble it up if present
314             if (returndata.length > 0) {
315                 // The easiest way to bubble the revert reason is using memory via assembly
316 
317                 assembly {
318                     let returndata_size := mload(returndata)
319                     revert(add(32, returndata), returndata_size)
320                 }
321             } else {
322                 revert(errorMessage);
323             }
324         }
325     }
326 }
327 
328 
329 interface IERC165 {
330     /**
331      * @dev Returns true if this contract implements the interface defined by
332      * `interfaceId`. See the corresponding
333      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
334      * to learn more about how these ids are created.
335      *
336      * This function call must use less than 30 000 gas.
337      */
338     function supportsInterface(bytes4 interfaceId) external view returns (bool);
339 }
340 
341 interface IERC721 is IERC165 {
342     /**
343      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
344      */
345     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
346 
347     /**
348      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
349      */
350     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
351 
352     /**
353      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
354      */
355     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
356 
357     /**
358      * @dev Returns the number of tokens in ``owner``'s account.
359      */
360     function balanceOf(address owner) external view returns (uint256 balance);
361 
362     /**
363      * @dev Returns the owner of the `tokenId` token.
364      *
365      * Requirements:
366      *
367      * - `tokenId` must exist.
368      */
369     function ownerOf(uint256 tokenId) external view returns (address owner);
370 
371     /**
372      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
373      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
374      *
375      * Requirements:
376      *
377      * - `from` cannot be the zero address.
378      * - `to` cannot be the zero address.
379      * - `tokenId` token must exist and be owned by `from`.
380      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
381      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
382      *
383      * Emits a {Transfer} event.
384      */
385     function safeTransferFrom(
386         address from,
387         address to,
388         uint256 tokenId
389     ) external;
390 
391     /**
392      * @dev Transfers `tokenId` token from `from` to `to`.
393      *
394      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
395      *
396      * Requirements:
397      *
398      * - `from` cannot be the zero address.
399      * - `to` cannot be the zero address.
400      * - `tokenId` token must be owned by `from`.
401      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
402      *
403      * Emits a {Transfer} event.
404      */
405     function transferFrom(
406         address from,
407         address to,
408         uint256 tokenId
409     ) external;
410 
411     /**
412      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
413      * The approval is cleared when the token is transferred.
414      *
415      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
416      *
417      * Requirements:
418      *
419      * - The caller must own the token or be an approved operator.
420      * - `tokenId` must exist.
421      *
422      * Emits an {Approval} event.
423      */
424     function approve(address to, uint256 tokenId) external;
425 
426     /**
427      * @dev Returns the account approved for `tokenId` token.
428      *
429      * Requirements:
430      *
431      * - `tokenId` must exist.
432      */
433     function getApproved(uint256 tokenId) external view returns (address operator);
434 
435     /**
436      * @dev Approve or remove `operator` as an operator for the caller.
437      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
438      *
439      * Requirements:
440      *
441      * - The `operator` cannot be the caller.
442      *
443      * Emits an {ApprovalForAll} event.
444      */
445     function setApprovalForAll(address operator, bool _approved) external;
446 
447     /**
448      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
449      *
450      * See {setApprovalForAll}
451      */
452     function isApprovedForAll(address owner, address operator) external view returns (bool);
453 
454     /**
455      * @dev Safely transfers `tokenId` token from `from` to `to`.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `tokenId` token must exist and be owned by `from`.
462      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
463      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
464      *
465      * Emits a {Transfer} event.
466      */
467     function safeTransferFrom(
468         address from,
469         address to,
470         uint256 tokenId,
471         bytes calldata data
472     ) external;
473 }
474 
475 
476 
477 interface IERC721Metadata is IERC721 {
478     /**
479      * @dev Returns the token collection name.
480      */
481     function name() external view returns (string memory);
482 
483     /**
484      * @dev Returns the token collection symbol.
485      */
486     function symbol() external view returns (string memory);
487 
488     /**
489      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
490      */
491     function tokenURI(uint256 tokenId) external view returns (string memory);
492 }
493 
494 
495 
496 
497 abstract contract ERC165 is IERC165 {
498     /**
499      * @dev See {IERC165-supportsInterface}.
500      */
501     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
502         return interfaceId == type(IERC165).interfaceId;
503     }
504 }
505 
506 
507 
508 
509 
510 abstract contract Context {
511     function _msgSender() internal view virtual returns (address) {
512         return msg.sender;
513     }
514 
515     function _msgData() internal view virtual returns (bytes calldata) {
516         return msg.data;
517     }
518 }
519 
520 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
521     using Address for address;
522     using Strings for uint256;
523 
524     // Token name
525     string private _name;
526 
527     // Token symbol
528     string private _symbol;
529 
530     // Mapping from token ID to owner address
531     mapping(uint256 => address) private _owners;
532 
533     // Mapping owner address to token count
534     mapping(address => uint256) private _balances;
535 
536     // Mapping from token ID to approved address
537     mapping(uint256 => address) private _tokenApprovals;
538 
539     // Mapping from owner to operator approvals
540     mapping(address => mapping(address => bool)) private _operatorApprovals;
541 
542     /**
543      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
544      */
545     constructor(string memory name_, string memory symbol_) {
546         _name = name_;
547         _symbol = symbol_;
548     }
549 
550     /**
551      * @dev See {IERC165-supportsInterface}.
552      */
553     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
554         return
555             interfaceId == type(IERC721).interfaceId ||
556             interfaceId == type(IERC721Metadata).interfaceId ||
557             super.supportsInterface(interfaceId);
558     }
559 
560     /**
561      * @dev See {IERC721-balanceOf}.
562      */
563     function balanceOf(address owner) public view virtual override returns (uint256) {
564         require(owner != address(0), "ERC721: balance query for the zero address");
565         return _balances[owner];
566     }
567 
568     /**
569      * @dev See {IERC721-ownerOf}.
570      */
571     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
572         address owner = _owners[tokenId];
573         require(owner != address(0), "ERC721: owner query for nonexistent token");
574         return owner;
575     }
576 
577     /**
578      * @dev See {IERC721Metadata-name}.
579      */
580     function name() public view virtual override returns (string memory) {
581         return _name;
582     }
583 
584     /**
585      * @dev See {IERC721Metadata-symbol}.
586      */
587     function symbol() public view virtual override returns (string memory) {
588         return _symbol;
589     }
590 
591     /**
592      * @dev See {IERC721Metadata-tokenURI}.
593      */
594     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
595         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
596 
597         string memory baseURI = _baseURI();
598         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
599     }
600 
601     /**
602      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
603      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
604      * by default, can be overriden in child contracts.
605      */
606     function _baseURI() internal view virtual returns (string memory) {
607         return "";
608     }
609 
610     /**
611      * @dev See {IERC721-approve}.
612      */
613     function approve(address to, uint256 tokenId) public virtual override {
614         address owner = ERC721.ownerOf(tokenId);
615         require(to != owner, "ERC721: approval to current owner");
616 
617         require(
618             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
619             "ERC721: approve caller is not owner nor approved for all"
620         );
621 
622         _approve(to, tokenId);
623     }
624 
625     /**
626      * @dev See {IERC721-getApproved}.
627      */
628     function getApproved(uint256 tokenId) public view virtual override returns (address) {
629         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
630 
631         return _tokenApprovals[tokenId];
632     }
633 
634     /**
635      * @dev See {IERC721-setApprovalForAll}.
636      */
637     function setApprovalForAll(address operator, bool approved) public virtual override {
638         require(operator != _msgSender(), "ERC721: approve to caller");
639 
640         _operatorApprovals[_msgSender()][operator] = approved;
641         emit ApprovalForAll(_msgSender(), operator, approved);
642     }
643 
644     /**
645      * @dev See {IERC721-isApprovedForAll}.
646      */
647     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
648         return _operatorApprovals[owner][operator];
649     }
650 
651     /**
652      * @dev See {IERC721-transferFrom}.
653      */
654     function transferFrom(
655         address from,
656         address to,
657         uint256 tokenId
658     ) public virtual override {
659         //solhint-disable-next-line max-line-length
660         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
661 
662         _transfer(from, to, tokenId);
663     }
664 
665     /**
666      * @dev See {IERC721-safeTransferFrom}.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) public virtual override {
673         safeTransferFrom(from, to, tokenId, "");
674     }
675 
676     /**
677      * @dev See {IERC721-safeTransferFrom}.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId,
683         bytes memory _data
684     ) public virtual override {
685         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
686         _safeTransfer(from, to, tokenId, _data);
687     }
688 
689     /**
690      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
691      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
692      *
693      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
694      *
695      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
696      * implement alternative mechanisms to perform token transfer, such as signature-based.
697      *
698      * Requirements:
699      *
700      * - `from` cannot be the zero address.
701      * - `to` cannot be the zero address.
702      * - `tokenId` token must exist and be owned by `from`.
703      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
704      *
705      * Emits a {Transfer} event.
706      */
707     function _safeTransfer(
708         address from,
709         address to,
710         uint256 tokenId,
711         bytes memory _data
712     ) internal virtual {
713         _transfer(from, to, tokenId);
714         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
715     }
716 
717     /**
718      * @dev Returns whether `tokenId` exists.
719      *
720      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
721      *
722      * Tokens start existing when they are minted (`_mint`),
723      * and stop existing when they are burned (`_burn`).
724      */
725     function _exists(uint256 tokenId) internal view virtual returns (bool) {
726         return _owners[tokenId] != address(0);
727     }
728 
729     /**
730      * @dev Returns whether `spender` is allowed to manage `tokenId`.
731      *
732      * Requirements:
733      *
734      * - `tokenId` must exist.
735      */
736     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
737         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
738         address owner = ERC721.ownerOf(tokenId);
739         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
740     }
741 
742     /**
743      * @dev Safely mints `tokenId` and transfers it to `to`.
744      *
745      * Requirements:
746      *
747      * - `tokenId` must not exist.
748      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
749      *
750      * Emits a {Transfer} event.
751      */
752     function _safeMint(address to, uint256 tokenId) internal virtual {
753         _safeMint(to, tokenId, "");
754     }
755 
756     /**
757      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
758      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
759      */
760     function _safeMint(
761         address to,
762         uint256 tokenId,
763         bytes memory _data
764     ) internal virtual {
765         _mint(to, tokenId);
766         require(
767             _checkOnERC721Received(address(0), to, tokenId, _data),
768             "ERC721: transfer to non ERC721Receiver implementer"
769         );
770     }
771 
772     /**
773      * @dev Mints `tokenId` and transfers it to `to`.
774      *
775      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
776      *
777      * Requirements:
778      *
779      * - `tokenId` must not exist.
780      * - `to` cannot be the zero address.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _mint(address to, uint256 tokenId) internal virtual {
785         require(to != address(0), "ERC721: mint to the zero address");
786         require(!_exists(tokenId), "ERC721: token already minted");
787 
788         _beforeTokenTransfer(address(0), to, tokenId);
789 
790         _balances[to] += 1;
791         _owners[tokenId] = to;
792 
793         emit Transfer(address(0), to, tokenId);
794     }
795 
796     /**
797      * @dev Destroys `tokenId`.
798      * The approval is cleared when the token is burned.
799      *
800      * Requirements:
801      *
802      * - `tokenId` must exist.
803      *
804      * Emits a {Transfer} event.
805      */
806     function _burn(uint256 tokenId) internal virtual {
807         address owner = ERC721.ownerOf(tokenId);
808 
809         _beforeTokenTransfer(owner, address(0), tokenId);
810 
811         // Clear approvals
812         _approve(address(0), tokenId);
813 
814         _balances[owner] -= 1;
815         delete _owners[tokenId];
816 
817         emit Transfer(owner, address(0), tokenId);
818     }
819 
820     /**
821      * @dev Transfers `tokenId` from `from` to `to`.
822      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
823      *
824      * Requirements:
825      *
826      * - `to` cannot be the zero address.
827      * - `tokenId` token must be owned by `from`.
828      *
829      * Emits a {Transfer} event.
830      */
831     function _transfer(
832         address from,
833         address to,
834         uint256 tokenId
835     ) internal virtual {
836         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
837         require(to != address(0), "ERC721: transfer to the zero address");
838 
839         _beforeTokenTransfer(from, to, tokenId);
840 
841         // Clear approvals from the previous owner
842         _approve(address(0), tokenId);
843 
844         _balances[from] -= 1;
845         _balances[to] += 1;
846         _owners[tokenId] = to;
847 
848         emit Transfer(from, to, tokenId);
849     }
850 
851     /**
852      * @dev Approve `to` to operate on `tokenId`
853      *
854      * Emits a {Approval} event.
855      */
856     function _approve(address to, uint256 tokenId) internal virtual {
857         _tokenApprovals[tokenId] = to;
858         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
859     }
860 
861     /**
862      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
863      * The call is not executed if the target address is not a contract.
864      *
865      * @param from address representing the previous owner of the given token ID
866      * @param to target address that will receive the tokens
867      * @param tokenId uint256 ID of the token to be transferred
868      * @param _data bytes optional data to send along with the call
869      * @return bool whether the call correctly returned the expected magic value
870      */
871     function _checkOnERC721Received(
872         address from,
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) private returns (bool) {
877         if (to.isContract()) {
878             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
879                 return retval == IERC721Receiver.onERC721Received.selector;
880             } catch (bytes memory reason) {
881                 if (reason.length == 0) {
882                     revert("ERC721: transfer to non ERC721Receiver implementer");
883                 } else {
884                     assembly {
885                         revert(add(32, reason), mload(reason))
886                     }
887                 }
888             }
889         } else {
890             return true;
891         }
892     }
893 
894     /**
895      * @dev Hook that is called before any token transfer. This includes minting
896      * and burning.
897      *
898      * Calling conditions:
899      *
900      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
901      * transferred to `to`.
902      * - When `from` is zero, `tokenId` will be minted for `to`.
903      * - When `to` is zero, ``from``'s `tokenId` will be burned.
904      * - `from` and `to` are never both zero.
905      *
906      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
907      */
908     function _beforeTokenTransfer(
909         address from,
910         address to,
911         uint256 tokenId
912     ) internal virtual {}
913 }
914 
915 
916 abstract contract Ownable is Context {
917     address private _owner;
918 
919     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
920 
921     /**
922      * @dev Initializes the contract setting the deployer as the initial owner.
923      */
924     constructor() {
925         _setOwner(_msgSender());
926     }
927 
928     /**
929      * @dev Returns the address of the current owner.
930      */
931     function owner() public view virtual returns (address) {
932         return _owner;
933     }
934 
935     /**
936      * @dev Throws if called by any account other than the owner.
937      */
938     modifier onlyOwner() {
939         require(owner() == _msgSender(), "Ownable: caller is not the owner");
940         _;
941     }
942 
943     /**
944      * @dev Leaves the contract without owner. It will not be possible to call
945      * `onlyOwner` functions anymore. Can only be called by the current owner.
946      *
947      * NOTE: Renouncing ownership will leave the contract without an owner,
948      * thereby removing any functionality that is only available to the owner.
949      */
950     function renounceOwnership() public virtual onlyOwner {
951         _setOwner(address(0));
952     }
953 
954     /**
955      * @dev Transfers ownership of the contract to a new account (`newOwner`).
956      * Can only be called by the current owner.
957      */
958     function transferOwnership(address newOwner) public virtual onlyOwner {
959         require(newOwner != address(0), "Ownable: new owner is the zero address");
960         _setOwner(newOwner);
961     }
962 
963     function _setOwner(address newOwner) private {
964         address oldOwner = _owner;
965         _owner = newOwner;
966         emit OwnershipTransferred(oldOwner, newOwner);
967     }
968 }
969 
970 
971 abstract contract ERC721URIStorage is ERC721 {
972     using Strings for uint256;
973 
974     // Optional mapping for token URIs
975     mapping(uint256 => string) private _tokenURIs;
976 
977     /**
978      * @dev See {IERC721Metadata-tokenURI}.
979      */
980     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
981         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
982 
983         string memory _tokenURI = _tokenURIs[tokenId];
984         string memory base = _baseURI();
985 
986         // If there is no base URI, return the token URI.
987         if (bytes(base).length == 0) {
988             return _tokenURI;
989         }
990         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
991         if (bytes(_tokenURI).length > 0) {
992             return string(abi.encodePacked(base, _tokenURI));
993         }
994 
995         return super.tokenURI(tokenId);
996     }
997 
998     /**
999      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must exist.
1004      */
1005     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1006         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1007         _tokenURIs[tokenId] = _tokenURI;
1008     }
1009 
1010     /**
1011      * @dev Destroys `tokenId`.
1012      * The approval is cleared when the token is burned.
1013      *
1014      * Requirements:
1015      *
1016      * - `tokenId` must exist.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _burn(uint256 tokenId) internal virtual override {
1021         super._burn(tokenId);
1022 
1023         if (bytes(_tokenURIs[tokenId]).length != 0) {
1024             delete _tokenURIs[tokenId];
1025         }
1026     }
1027 }
1028 
1029 
1030 // inherit from pausable so that we can pause in case anything goes wrong?
1031 contract SierpinskiNFT is ERC721, ERC721URIStorage, Ownable {
1032     bool public isSaleStarted = false; 
1033     string public baseURI; 
1034     uint256 public constant maxSupply = 5555;  
1035     uint256 private reservedTriangle = 1;
1036     uint256 public price = 0.07 ether;
1037     string contractURIAddress;
1038 
1039     using Counters for Counters.Counter; 
1040     Counters.Counter public tokenCount; // default value is 0. public so that we can see how many have been minted
1041 
1042 
1043 
1044     event Minted(address to, uint256 tokenId);
1045     event SaleStarted();
1046     event SaleStopped();
1047 
1048 
1049 
1050     constructor(string memory _newBaseURI, string memory _contractURI) ERC721('Fractal Factory SierpinskiNFT', 'SPK') {
1051         // set the base uri to be the api endpoint that returns the json of token metadata. baseURI/tokenID -> {image: 'ipfs/someHash'}
1052         // initialise the contract metadata here also. 
1053         setBaseURI(_newBaseURI); 
1054         setContractURI(_contractURI);
1055     }
1056 
1057 
1058 
1059     // for listing on opensea. getter function for contractURIAddress
1060     function contractURI() public view returns (string memory) {
1061         return contractURIAddress;
1062     }
1063 
1064     function setContractURI(string memory _contractURI) public onlyOwner {
1065         contractURIAddress = _contractURI;
1066     }
1067 
1068     // impt as it feeds the baseURI to tokenURI()
1069     function _baseURI() internal view virtual override returns (string memory){
1070         return baseURI;
1071     }
1072 
1073     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1074         baseURI = _newBaseURI;
1075     }
1076 
1077     // tokenURI = baseURI + tokenId (leads to api endpoint which returns token specific metadata)
1078     function tokenURI(uint256 tokenId)
1079         public
1080         view
1081         override(ERC721, ERC721URIStorage)
1082         returns (string memory)
1083     {
1084         return super.tokenURI(tokenId);
1085     }
1086 
1087 
1088 
1089     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1090         super._burn(tokenId);
1091     }
1092 
1093 
1094 
1095     // sale contract functions
1096     function startSale() public onlyOwner {
1097         require(!isSaleStarted, 'Sale has already started');
1098         isSaleStarted = true;
1099         emit SaleStarted();
1100     }
1101 
1102     function stopSale() public onlyOwner {
1103         require(isSaleStarted, 'Sale has not started yet');
1104         isSaleStarted = false;
1105         emit SaleStopped();
1106     }
1107 
1108 
1109 
1110     // send all the remaining funds to the owner, if any (backup function)
1111     function returnFunds() public onlyOwner {
1112         payable(owner()).transfer(address(this).balance);
1113     }
1114 
1115     // default in frontend is 1. max is 20
1116     function mint(uint256 numOfTokens) payable public {
1117         require(isSaleStarted, 'Sale has not started');
1118 
1119         require(numOfTokens > 0, 'Cannot mint 0 tokens');
1120         require(numOfTokens <= 20, 'Maximum mint limit is 20');
1121 
1122         require(tokenCount.current() < maxSupply - reservedTriangle, 'All tokens have been minted');
1123         require(tokenCount.current() + numOfTokens <= maxSupply - reservedTriangle, 'Exceeded max mint');
1124  
1125         require(msg.value == price * numOfTokens, 'Invalid value');
1126 
1127         payable(owner()).transfer(msg.value);
1128 
1129         for (uint256 i=0; i<numOfTokens; i++) {
1130             tokenCount.increment();
1131             uint256 tokenId = tokenCount.current();
1132             _safeMint(_msgSender(), tokenId);
1133 
1134             emit Minted(msg.sender, tokenId);
1135         }
1136     }
1137 
1138     // mint reserve for giveaway
1139      function mintReserve() external onlyOwner {
1140         require(tokenCount.current() + reservedTriangle <= maxSupply, "Exceeded max supply supply");
1141         tokenCount.increment();
1142         _safeMint(_msgSender(), tokenCount.current());
1143     }
1144 }