1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
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
91      */
92     function isContract(address account) internal view returns (bool) {
93         // This method relies on extcodesize, which returns 0 for contracts in
94         // construction, since the code is only stored at the end of the
95         // constructor execution.
96 
97         uint256 size;
98         assembly {
99             size := extcodesize(account)
100         }
101         return size > 0;
102     }
103 
104     /**
105      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
106      * `recipient`, forwarding all available gas and reverting on errors.
107      *
108      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
109      * of certain opcodes, possibly making contracts go over the 2300 gas limit
110      * imposed by `transfer`, making them unable to receive funds via
111      * `transfer`. {sendValue} removes this limitation.
112      *
113      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
114      *
115      * IMPORTANT: because control is transferred to `recipient`, care must be
116      * taken to not create reentrancy vulnerabilities. Consider using
117      * {ReentrancyGuard} or the
118      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
119      */
120     function sendValue(address payable recipient, uint256 amount) internal {
121         require(address(this).balance >= amount, "Address: insufficient balance");
122 
123         (bool success, ) = recipient.call{value: amount}("");
124         require(success, "Address: unable to send value, recipient may have reverted");
125     }
126 
127     /**
128      * @dev Performs a Solidity function call using a low level `call`. A
129      * plain `call` is an unsafe replacement for a function call: use this
130      * function instead.
131      *
132      * If `target` reverts with a revert reason, it is bubbled up by this
133      * function (like regular Solidity function calls).
134      *
135      * Returns the raw returned data. To convert to the expected return value,
136      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
137      *
138      * Requirements:
139      *
140      * - `target` must be a contract.
141      * - calling `target` with `data` must not revert.
142      *
143      * _Available since v3.1._
144      */
145     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
146         return functionCall(target, data, "Address: low-level call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
151      * `errorMessage` as a fallback revert reason when `target` reverts.
152      *
153      * _Available since v3.1._
154      */
155     function functionCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal returns (bytes memory) {
160         return functionCallWithValue(target, data, 0, errorMessage);
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
165      * but also transferring `value` wei to `target`.
166      *
167      * Requirements:
168      *
169      * - the calling contract must have an ETH balance of at least `value`.
170      * - the called Solidity function must be `payable`.
171      *
172      * _Available since v3.1._
173      */
174     function functionCallWithValue(
175         address target,
176         bytes memory data,
177         uint256 value
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
184      * with `errorMessage` as a fallback revert reason when `target` reverts.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(address(this).balance >= value, "Address: insufficient balance for call");
195         require(isContract(target), "Address: call to non-contract");
196 
197         (bool success, bytes memory returndata) = target.call{value: value}(data);
198         return verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
203      * but performing a static call.
204      *
205      * _Available since v3.3._
206      */
207     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
208         return functionStaticCall(target, data, "Address: low-level static call failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
213      * but performing a static call.
214      *
215      * _Available since v3.3._
216      */
217     function functionStaticCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal view returns (bytes memory) {
222         require(isContract(target), "Address: static call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.staticcall(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but performing a delegate call.
231      *
232      * _Available since v3.4._
233      */
234     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
235         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
240      * but performing a delegate call.
241      *
242      * _Available since v3.4._
243      */
244     function functionDelegateCall(
245         address target,
246         bytes memory data,
247         string memory errorMessage
248     ) internal returns (bytes memory) {
249         require(isContract(target), "Address: delegate call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.delegatecall(data);
252         return verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
257      * revert reason using the provided one.
258      *
259      * _Available since v4.3._
260      */
261     function verifyCallResult(
262         bool success,
263         bytes memory returndata,
264         string memory errorMessage
265     ) internal pure returns (bytes memory) {
266         if (success) {
267             return returndata;
268         } else {
269             // Look for revert reason and bubble it up if present
270             if (returndata.length > 0) {
271                 // The easiest way to bubble the revert reason is using memory via assembly
272 
273                 assembly {
274                     let returndata_size := mload(returndata)
275                     revert(add(32, returndata), returndata_size)
276                 }
277             } else {
278                 revert(errorMessage);
279             }
280         }
281     }
282 }
283 
284 abstract contract Ownable is Context {
285     address private _owner;
286 
287     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
288 
289     /**
290      * @dev Initializes the contract setting the deployer as the initial owner.
291      */
292     constructor() {
293         _setOwner(_msgSender());
294     }
295 
296     /**
297      * @dev Returns the address of the current owner.
298      */
299     function owner() public view virtual returns (address) {
300         return _owner;
301     }
302 
303     /**
304      * @dev Throws if called by any account other than the owner.
305      */
306     modifier onlyOwner() {
307         require(owner() == _msgSender(), "Ownable: caller is not the owner");
308         _;
309     }
310 
311     /**
312      * @dev Leaves the contract without owner. It will not be possible to call
313      * `onlyOwner` functions anymore. Can only be called by the current owner.
314      *
315      * NOTE: Renouncing ownership will leave the contract without an owner,
316      * thereby removing any functionality that is only available to the owner.
317      */
318     function renounceOwnership() public virtual onlyOwner {
319         _setOwner(address(0));
320     }
321 
322     /**
323      * @dev Transfers ownership of the contract to a new account (`newOwner`).
324      * Can only be called by the current owner.
325      */
326     function transferOwnership(address newOwner) public virtual onlyOwner {
327         require(newOwner != address(0), "Ownable: new owner is the zero address");
328         _setOwner(newOwner);
329     }
330 
331     function _setOwner(address newOwner) private {
332         address oldOwner = _owner;
333         _owner = newOwner;
334         emit OwnershipTransferred(oldOwner, newOwner);
335     }
336 }
337 
338 
339 
340 
341 interface IERC165 {
342     /**
343      * @dev Returns true if this contract implements the interface defined by
344      * `interfaceId`. See the corresponding
345      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
346      * to learn more about how these ids are created.
347      *
348      * This function call must use less than 30 000 gas.
349      */
350     function supportsInterface(bytes4 interfaceId) external view returns (bool);
351 }
352 
353 abstract contract ERC165 is IERC165 {
354     /**
355      * @dev See {IERC165-supportsInterface}.
356      */
357     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
358         return interfaceId == type(IERC165).interfaceId;
359     }
360 }
361 
362 
363 interface IERC721Receiver {
364     /**
365      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
366      * by `operator` from `from`, this function is called.
367      *
368      * It must return its Solidity selector to confirm the token transfer.
369      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
370      *
371      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
372      */
373     function onERC721Received(
374         address operator,
375         address from,
376         uint256 tokenId,
377         bytes calldata data
378     ) external returns (bytes4);
379 }
380 
381 
382 
383 interface IERC721 is IERC165 {
384     /**
385      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
386      */
387     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
388 
389     /**
390      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
391      */
392     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
393 
394     /**
395      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
396      */
397     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
398 
399     /**
400      * @dev Returns the number of tokens in ``owner``'s account.
401      */
402     function balanceOf(address owner) external view returns (uint256 balance);
403 
404     /**
405      * @dev Returns the owner of the `tokenId` token.
406      *
407      * Requirements:
408      *
409      * - `tokenId` must exist.
410      */
411     function ownerOf(uint256 tokenId) external view returns (address owner);
412 
413     /**
414      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
415      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
416      *
417      * Requirements:
418      *
419      * - `from` cannot be the zero address.
420      * - `to` cannot be the zero address.
421      * - `tokenId` token must exist and be owned by `from`.
422      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
423      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
424      *
425      * Emits a {Transfer} event.
426      */
427     function safeTransferFrom(
428         address from,
429         address to,
430         uint256 tokenId
431     ) external;
432 
433     /**
434      * @dev Transfers `tokenId` token from `from` to `to`.
435      *
436      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
437      *
438      * Requirements:
439      *
440      * - `from` cannot be the zero address.
441      * - `to` cannot be the zero address.
442      * - `tokenId` token must be owned by `from`.
443      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
444      *
445      * Emits a {Transfer} event.
446      */
447     function transferFrom(
448         address from,
449         address to,
450         uint256 tokenId
451     ) external;
452 
453     /**
454      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
455      * The approval is cleared when the token is transferred.
456      *
457      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
458      *
459      * Requirements:
460      *
461      * - The caller must own the token or be an approved operator.
462      * - `tokenId` must exist.
463      *
464      * Emits an {Approval} event.
465      */
466     function approve(address to, uint256 tokenId) external;
467 
468     /**
469      * @dev Returns the account approved for `tokenId` token.
470      *
471      * Requirements:
472      *
473      * - `tokenId` must exist.
474      */
475     function getApproved(uint256 tokenId) external view returns (address operator);
476 
477     /**
478      * @dev Approve or remove `operator` as an operator for the caller.
479      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
480      *
481      * Requirements:
482      *
483      * - The `operator` cannot be the caller.
484      *
485      * Emits an {ApprovalForAll} event.
486      */
487     function setApprovalForAll(address operator, bool _approved) external;
488 
489     /**
490      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
491      *
492      * See {setApprovalForAll}
493      */
494     function isApprovedForAll(address owner, address operator) external view returns (bool);
495 
496     /**
497      * @dev Safely transfers `tokenId` token from `from` to `to`.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must exist and be owned by `from`.
504      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
505      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
506      *
507      * Emits a {Transfer} event.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId,
513         bytes calldata data
514     ) external;
515 }
516 
517 interface IERC721Metadata is IERC721 {
518     /**
519      * @dev Returns the token collection name.
520      */
521     function name() external view returns (string memory);
522 
523     /**
524      * @dev Returns the token collection symbol.
525      */
526     function symbol() external view returns (string memory);
527 
528     /**
529      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
530      */
531     function tokenURI(uint256 tokenId) external view returns (string memory);
532 }
533 
534 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
535     using Address for address;
536     using Strings for uint256;
537 
538     // Token name
539     string private _name;
540 
541     // Token symbol
542     string private _symbol;
543 
544     // Mapping from token ID to owner address
545     mapping(uint256 => address) private _owners;
546 
547     // Mapping owner address to token count
548     mapping(address => uint256) private _balances;
549 
550     // Mapping from token ID to approved address
551     mapping(uint256 => address) private _tokenApprovals;
552 
553     // Mapping from owner to operator approvals
554     mapping(address => mapping(address => bool)) private _operatorApprovals;
555 
556     /**
557      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
558      */
559     constructor(string memory name_, string memory symbol_) {
560         _name = name_;
561         _symbol = symbol_;
562     }
563 
564     /**
565      * @dev See {IERC165-supportsInterface}.
566      */
567     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
568         return
569             interfaceId == type(IERC721).interfaceId ||
570             interfaceId == type(IERC721Metadata).interfaceId ||
571             super.supportsInterface(interfaceId);
572     }
573 
574     /**
575      * @dev See {IERC721-balanceOf}.
576      */
577     function balanceOf(address owner) public view virtual override returns (uint256) {
578         require(owner != address(0), "ERC721: balance query for the zero address");
579         return _balances[owner];
580     }
581 
582     /**
583      * @dev See {IERC721-ownerOf}.
584      */
585     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
586         address owner = _owners[tokenId];
587         require(owner != address(0), "ERC721: owner query for nonexistent token");
588         return owner;
589     }
590 
591     /**
592      * @dev See {IERC721Metadata-name}.
593      */
594     function name() public view virtual override returns (string memory) {
595         return _name;
596     }
597 
598     /**
599      * @dev See {IERC721Metadata-symbol}.
600      */
601     function symbol() public view virtual override returns (string memory) {
602         return _symbol;
603     }
604 
605     /**
606      * @dev See {IERC721Metadata-tokenURI}.
607      */
608     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
609         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
610 
611         string memory baseURI = _baseURI();
612         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
613     }
614 
615     /**
616      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
617      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
618      * by default, can be overriden in child contracts.
619      */
620     function _baseURI() internal view virtual returns (string memory) {
621         return "";
622     }
623 
624     /**
625      * @dev See {IERC721-approve}.
626      */
627     function approve(address to, uint256 tokenId) public virtual override {
628         address owner = ERC721.ownerOf(tokenId);
629         require(to != owner, "ERC721: approval to current owner");
630 
631         require(
632             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
633             "ERC721: approve caller is not owner nor approved for all"
634         );
635 
636         _approve(to, tokenId);
637     }
638 
639     /**
640      * @dev See {IERC721-getApproved}.
641      */
642     function getApproved(uint256 tokenId) public view virtual override returns (address) {
643         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
644 
645         return _tokenApprovals[tokenId];
646     }
647 
648     /**
649      * @dev See {IERC721-setApprovalForAll}.
650      */
651     function setApprovalForAll(address operator, bool approved) public virtual override {
652         require(operator != _msgSender(), "ERC721: approve to caller");
653 
654         _operatorApprovals[_msgSender()][operator] = approved;
655         emit ApprovalForAll(_msgSender(), operator, approved);
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
753         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
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
808     }
809 
810     /**
811      * @dev Destroys `tokenId`.
812      * The approval is cleared when the token is burned.
813      *
814      * Requirements:
815      *
816      * - `tokenId` must exist.
817      *
818      * Emits a {Transfer} event.
819      */
820     function _burn(uint256 tokenId) internal virtual {
821         address owner = ERC721.ownerOf(tokenId);
822 
823         _beforeTokenTransfer(owner, address(0), tokenId);
824 
825         // Clear approvals
826         _approve(address(0), tokenId);
827 
828         _balances[owner] -= 1;
829         delete _owners[tokenId];
830 
831         emit Transfer(owner, address(0), tokenId);
832     }
833 
834     /**
835      * @dev Transfers `tokenId` from `from` to `to`.
836      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
837      *
838      * Requirements:
839      *
840      * - `to` cannot be the zero address.
841      * - `tokenId` token must be owned by `from`.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _transfer(
846         address from,
847         address to,
848         uint256 tokenId
849     ) internal virtual {
850         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
851         require(to != address(0), "ERC721: transfer to the zero address");
852 
853         _beforeTokenTransfer(from, to, tokenId);
854 
855         // Clear approvals from the previous owner
856         _approve(address(0), tokenId);
857 
858         _balances[from] -= 1;
859         _balances[to] += 1;
860         _owners[tokenId] = to;
861 
862         emit Transfer(from, to, tokenId);
863     }
864 
865     /**
866      * @dev Approve `to` to operate on `tokenId`
867      *
868      * Emits a {Approval} event.
869      */
870     function _approve(address to, uint256 tokenId) internal virtual {
871         _tokenApprovals[tokenId] = to;
872         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
873     }
874 
875     /**
876      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
877      * The call is not executed if the target address is not a contract.
878      *
879      * @param from address representing the previous owner of the given token ID
880      * @param to target address that will receive the tokens
881      * @param tokenId uint256 ID of the token to be transferred
882      * @param _data bytes optional data to send along with the call
883      * @return bool whether the call correctly returned the expected magic value
884      */
885     function _checkOnERC721Received(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes memory _data
890     ) private returns (bool) {
891         if (to.isContract()) {
892             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
893                 return retval == IERC721Receiver.onERC721Received.selector;
894             } catch (bytes memory reason) {
895                 if (reason.length == 0) {
896                     revert("ERC721: transfer to non ERC721Receiver implementer");
897                 } else {
898                     assembly {
899                         revert(add(32, reason), mload(reason))
900                     }
901                 }
902             }
903         } else {
904             return true;
905         }
906     }
907 
908     /**
909      * @dev Hook that is called before any token transfer. This includes minting
910      * and burning.
911      *
912      * Calling conditions:
913      *
914      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
915      * transferred to `to`.
916      * - When `from` is zero, `tokenId` will be minted for `to`.
917      * - When `to` is zero, ``from``'s `tokenId` will be burned.
918      * - `from` and `to` are never both zero.
919      *
920      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
921      */
922     function _beforeTokenTransfer(
923         address from,
924         address to,
925         uint256 tokenId
926     ) internal virtual {}
927 }
928 
929 
930 
931 
932 interface IERC721Enumerable is IERC721 {
933     /**
934      * @dev Returns the total amount of tokens stored by the contract.
935      */
936     function totalSupply() external view returns (uint256);
937 
938     /**
939      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
940      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
941      */
942     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
943 
944     /**
945      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
946      * Use along with {totalSupply} to enumerate all tokens.
947      */
948     function tokenByIndex(uint256 index) external view returns (uint256);
949 }
950 
951 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
952     // Mapping from owner to list of owned token IDs
953     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
954 
955     // Mapping from token ID to index of the owner tokens list
956     mapping(uint256 => uint256) private _ownedTokensIndex;
957 
958     // Array with all token ids, used for enumeration
959     uint256[] private _allTokens;
960 
961     // Mapping from token id to position in the allTokens array
962     mapping(uint256 => uint256) private _allTokensIndex;
963 
964     /**
965      * @dev See {IERC165-supportsInterface}.
966      */
967     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
968         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
969     }
970 
971     /**
972      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
973      */
974     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
975         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
976         return _ownedTokens[owner][index];
977     }
978 
979     /**
980      * @dev See {IERC721Enumerable-totalSupply}.
981      */
982     function totalSupply() public view virtual override returns (uint256) {
983         return _allTokens.length;
984     }
985 
986     /**
987      * @dev See {IERC721Enumerable-tokenByIndex}.
988      */
989     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
990         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
991         return _allTokens[index];
992     }
993 
994     /**
995      * @dev Hook that is called before any token transfer. This includes minting
996      * and burning.
997      *
998      * Calling conditions:
999      *
1000      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1001      * transferred to `to`.
1002      * - When `from` is zero, `tokenId` will be minted for `to`.
1003      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1004      * - `from` cannot be the zero address.
1005      * - `to` cannot be the zero address.
1006      *
1007      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1008      */
1009     function _beforeTokenTransfer(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) internal virtual override {
1014         super._beforeTokenTransfer(from, to, tokenId);
1015 
1016         if (from == address(0)) {
1017             _addTokenToAllTokensEnumeration(tokenId);
1018         } else if (from != to) {
1019             _removeTokenFromOwnerEnumeration(from, tokenId);
1020         }
1021         if (to == address(0)) {
1022             _removeTokenFromAllTokensEnumeration(tokenId);
1023         } else if (to != from) {
1024             _addTokenToOwnerEnumeration(to, tokenId);
1025         }
1026     }
1027 
1028     /**
1029      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1030      * @param to address representing the new owner of the given token ID
1031      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1032      */
1033     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1034         uint256 length = ERC721.balanceOf(to);
1035         _ownedTokens[to][length] = tokenId;
1036         _ownedTokensIndex[tokenId] = length;
1037     }
1038 
1039     /**
1040      * @dev Private function to add a token to this extension's token tracking data structures.
1041      * @param tokenId uint256 ID of the token to be added to the tokens list
1042      */
1043     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1044         _allTokensIndex[tokenId] = _allTokens.length;
1045         _allTokens.push(tokenId);
1046     }
1047 
1048     /**
1049      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1050      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1051      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1052      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1053      * @param from address representing the previous owner of the given token ID
1054      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1055      */
1056     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1057         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1058         // then delete the last slot (swap and pop).
1059 
1060         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1061         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1062 
1063         // When the token to delete is the last token, the swap operation is unnecessary
1064         if (tokenIndex != lastTokenIndex) {
1065             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1066 
1067             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1068             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1069         }
1070 
1071         // This also deletes the contents at the last position of the array
1072         delete _ownedTokensIndex[tokenId];
1073         delete _ownedTokens[from][lastTokenIndex];
1074     }
1075 
1076     /**
1077      * @dev Private function to remove a token from this extension's token tracking data structures.
1078      * This has O(1) time complexity, but alters the order of the _allTokens array.
1079      * @param tokenId uint256 ID of the token to be removed from the tokens list
1080      */
1081     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1082         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1083         // then delete the last slot (swap and pop).
1084 
1085         uint256 lastTokenIndex = _allTokens.length - 1;
1086         uint256 tokenIndex = _allTokensIndex[tokenId];
1087 
1088         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1089         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1090         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1091         uint256 lastTokenId = _allTokens[lastTokenIndex];
1092 
1093         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1094         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1095 
1096         // This also deletes the contents at the last position of the array
1097         delete _allTokensIndex[tokenId];
1098         _allTokens.pop();
1099     }
1100 }
1101 
1102 
1103 
1104 
1105 
1106 library Base64 {
1107     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
1108     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
1109                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
1110                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
1111                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
1112 
1113     function encode(bytes memory data) internal pure returns (string memory) {
1114         if (data.length == 0) return '';
1115 
1116         // load the table into memory
1117         string memory table = TABLE_ENCODE;
1118 
1119         // multiply by 4/3 rounded up
1120         uint256 encodedLen = 4 * ((data.length + 2) / 3);
1121 
1122         // add some extra buffer at the end required for the writing
1123         string memory result = new string(encodedLen + 32);
1124 
1125         assembly {
1126             // set the actual output length
1127             mstore(result, encodedLen)
1128 
1129             // prepare the lookup table
1130             let tablePtr := add(table, 1)
1131 
1132             // input ptr
1133             let dataPtr := data
1134             let endPtr := add(dataPtr, mload(data))
1135 
1136             // result ptr, jump over length
1137             let resultPtr := add(result, 32)
1138 
1139             // run over the input, 3 bytes at a time
1140             for {} lt(dataPtr, endPtr) {}
1141             {
1142                 // read 3 bytes
1143                 dataPtr := add(dataPtr, 3)
1144                 let input := mload(dataPtr)
1145 
1146                 // write 4 characters
1147                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1148                 resultPtr := add(resultPtr, 1)
1149                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1150                 resultPtr := add(resultPtr, 1)
1151                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
1152                 resultPtr := add(resultPtr, 1)
1153                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
1154                 resultPtr := add(resultPtr, 1)
1155             }
1156 
1157             // padding with '='
1158             switch mod(mload(data), 3)
1159             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
1160             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
1161         }
1162 
1163         return result;
1164     }
1165 
1166     function decode(string memory _data) internal pure returns (bytes memory) {
1167         bytes memory data = bytes(_data);
1168 
1169         if (data.length == 0) return new bytes(0);
1170         require(data.length % 4 == 0, "invalid base64 decoder input");
1171 
1172         // load the table into memory
1173         bytes memory table = TABLE_DECODE;
1174 
1175         // every 4 characters represent 3 bytes
1176         uint256 decodedLen = (data.length / 4) * 3;
1177 
1178         // add some extra buffer at the end required for the writing
1179         bytes memory result = new bytes(decodedLen + 32);
1180 
1181         assembly {
1182             // padding with '='
1183             let lastBytes := mload(add(data, mload(data)))
1184             if eq(and(lastBytes, 0xFF), 0x3d) {
1185                 decodedLen := sub(decodedLen, 1)
1186                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
1187                     decodedLen := sub(decodedLen, 1)
1188                 }
1189             }
1190 
1191             // set the actual output length
1192             mstore(result, decodedLen)
1193 
1194             // prepare the lookup table
1195             let tablePtr := add(table, 1)
1196 
1197             // input ptr
1198             let dataPtr := data
1199             let endPtr := add(dataPtr, mload(data))
1200 
1201             // result ptr, jump over length
1202             let resultPtr := add(result, 32)
1203 
1204             // run over the input, 4 characters at a time
1205             for {} lt(dataPtr, endPtr) {}
1206             {
1207                // read 4 characters
1208                dataPtr := add(dataPtr, 4)
1209                let input := mload(dataPtr)
1210 
1211                // write 3 bytes
1212                let output := add(
1213                    add(
1214                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
1215                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
1216                    add(
1217                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
1218                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
1219                     )
1220                 )
1221                 mstore(resultPtr, shl(232, output))
1222                 resultPtr := add(resultPtr, 3)
1223             }
1224         }
1225 
1226         return result;
1227     }
1228 }
1229 
1230 contract NUDEMENFT {
1231      function seeds(uint256) public pure returns (uint256) {}
1232      function walletOfOwner(address _owner) public view returns (uint256[] memory) {}
1233 }
1234 
1235 contract NUDEMENCLOCK is ERC721Enumerable, Ownable {
1236   using Strings for uint256;
1237   string public baseURI="https://nudemenft.com/clock";
1238   string public baseAniURI = "ipfs://QmRZdvzxow4BHEJGkXnCWYttStsMK6AWzDJ4cLB2Ggg7Uh";  //update
1239   uint256 public cost = 100.00 ether;
1240   uint256 public maxSupply = 999;
1241   uint256 public maxMintAmount = 10;
1242   bool public paused = false;
1243   mapping(uint256 => uint256) public seeds;
1244   NUDEMENFT nmnft;
1245   
1246   constructor() ERC721("NUDEMENCLOCK", "NUDEC") {
1247     mintClock(10);
1248     nmnft = NUDEMENFT(0x32A5C961ed3b41F512952C5Bb824B292B4444dD6); //update
1249   }
1250   
1251   function claimClock(uint256 nudemeNFT_id) public {
1252       require(!paused,"Minting Paused");
1253       require(totalSupply() + 1 <= maxSupply,"Max NFT supply exceeded");
1254       require(!_exists(nudemeNFT_id),"Token already claimed");
1255       uint256[] memory tids=nmnft.walletOfOwner(msg.sender);
1256       bool hasToken = false;
1257     
1258       for (uint i=0; i < tids.length; i++) {
1259          if (nudemeNFT_id == tids[i]) {
1260             hasToken = true;
1261          }
1262       }
1263       require(hasToken, "Token not found in your wallet");
1264       _safeMint(msg.sender, nudemeNFT_id);
1265       seeds[nudemeNFT_id] = nmnft.seeds(nudemeNFT_id);
1266   }
1267   
1268   
1269   function mintClock(uint256 _mintAmount) public payable {
1270     uint256 supply = totalSupply();
1271     require(!paused,"Minting Paused");
1272     require(_mintAmount > 0, "At least 1 NFT to be minted");
1273     require(_mintAmount <= maxMintAmount,"Max mint per TX exceeded");
1274     require(supply + _mintAmount <= maxSupply,"Max NFT supply exceeded");
1275 
1276     if (msg.sender != owner()) {
1277           require(msg.value >= cost * _mintAmount,"Insufficient funds");
1278     }
1279 
1280     for (uint256 i = 1; i <= _mintAmount; i++) {
1281       uint256 tid = 10000+supply + i;
1282       _safeMint(msg.sender, tid);
1283       seeds[tid] = uint256(keccak256(abi.encodePacked(uint256(bytes32(blockhash(block.number - 1))), tid)));
1284     }
1285   }
1286   
1287 
1288   function walletOfOwner(address _owner)
1289     public
1290     view
1291     returns (uint256[] memory)
1292   {
1293     uint256 ownerTokenCount = balanceOf(_owner);
1294     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1295     for (uint256 i; i < ownerTokenCount; i++) {
1296       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1297     }
1298     return tokenIds;
1299   }
1300   
1301   function walletDetailsOfOwner(address _owner)
1302     public
1303     view
1304     returns (uint256[] memory, uint256[] memory)
1305   {
1306     uint256 ownerTokenCount = balanceOf(_owner);
1307     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1308     uint256[] memory s = new uint256[](ownerTokenCount);
1309     for (uint256 i; i < ownerTokenCount; i++) {
1310       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1311       s[i] = seeds[tokenIds[i]];
1312     }
1313     return (tokenIds, s);
1314   }
1315   
1316   function contractURI() public view returns (string memory) {
1317         return string(abi.encodePacked(baseURI, "/metadata.json"));
1318   }
1319 
1320   function tokenURI(uint256 tokenId)
1321     public
1322     view
1323     virtual
1324     override
1325     returns (string memory)
1326   {
1327     require(
1328       _exists(tokenId),
1329       "URI query for nonexistent token"
1330     );
1331 
1332     return(formatTokenURI(tokenId,seeds[tokenId]));
1333 
1334   }
1335   
1336   function tokenAniURI(uint256 tokenId)
1337     public
1338     view
1339     returns (string memory)
1340   {
1341     require(
1342       _exists(tokenId),
1343       "URI query for nonexistent token"
1344     );
1345 
1346     return string(abi.encodePacked(baseAniURI,'/?s=',seeds[tokenId].toString()));
1347   }
1348 
1349  
1350   function setCost(uint256 _newCost) public onlyOwner() {
1351     cost = _newCost;
1352   }
1353 
1354   function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1355     maxMintAmount = _newmaxMintAmount;
1356   }
1357 
1358   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1359     baseURI = _newBaseURI;
1360   }
1361 
1362   function setBaseAniURI(string memory _newBaseAniURI) public onlyOwner {
1363     baseAniURI = _newBaseAniURI;
1364   }
1365 
1366   function pause(bool _state) public onlyOwner {
1367     paused = _state;
1368   }
1369 
1370   function withdraw() public payable onlyOwner {
1371     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1372     require(success);
1373   }
1374   
1375   function substring(string memory str, uint startIndex, uint endIndex) private pure returns (string memory) {
1376     bytes memory strBytes = bytes(str);
1377     bytes memory result = new bytes(endIndex-startIndex);
1378     for(uint i = startIndex; i < endIndex; i++) {
1379         result[i-startIndex] = strBytes[i];
1380     }
1381     return string(result);
1382   }
1383     
1384   function strToUint(string memory _str) private pure returns(uint256 res) {
1385     for (uint256 i = 0; i < bytes(_str).length; i++) {
1386         res += (uint8(bytes(_str)[i]) - 48) * 10**(bytes(_str).length - i - 1);
1387     }
1388     return (res);
1389   }
1390 
1391   function formatTokenURI(uint256 tid, uint256 seed) private view returns (string memory) {
1392         string memory seedStr = seed.toString();
1393         string memory attrA = substring(seedStr,1,11);
1394         string memory attrD = substring(seedStr,11,21);
1395         string memory attrU = substring(seedStr,21,31);
1396         string memory attrL = substring(seedStr,31,41);
1397         string memory attrT = substring(seedStr,41,51);
1398         string memory attrS = substring(seedStr,51,61);
1399         string memory attrP = substring(seedStr,61,71);
1400         string memory extURL = string(abi.encodePacked('"external_url":"',baseURI,'/?s=',seed.toString(),'",'));
1401         string memory aniURL = string(abi.encodePacked('"animation_url":"',baseURI,'/?s=',seed.toString(),'",'));
1402         string memory imgURL = string(abi.encodePacked('"image":"',baseURI,'/img/',tid.toString(),'.png"'));
1403         string memory name =string(abi.encodePacked('"name":"Nudemen #',tid.toString()));
1404 
1405         uint256 num;
1406 
1407         num = strToUint(attrD);
1408         if (num>1000000000) attrD="0";
1409         else attrD="1";
1410         
1411         num = strToUint(attrU);
1412         attrU= (num%101).toString();
1413         
1414         num = strToUint(attrL);
1415         if (num>7000000000) attrL= "100";
1416         else attrL= (num%100).toString();
1417          
1418         num = strToUint(attrT);
1419         attrT= (num%10001).toString();
1420 
1421         num = strToUint(attrS);
1422         if (num>7000000000) attrS= "100";
1423         else attrS= (num%100).toString();
1424         
1425         num = strToUint(attrP);
1426         if (num>7000000000) attrP= "4";
1427         else attrP= (5+num%5).toString();
1428         
1429 
1430         return string(
1431                 abi.encodePacked(
1432                     "data:application/json;base64,",
1433                     Base64.encode(
1434                         bytes(
1435                             abi.encodePacked(
1436                             '{',name,'","description":"The Nudemen Clock is an NFT collection of up to 999 unique interactive clocks living on the Ethereum blockchain.","attributes":[{"trait_type":"A","value":"',
1437                             attrA,'"},{"trait_type":"D","value":"',
1438                             attrD,'"},{"trait_type":"U","value":"',
1439                             attrU,'"},{"trait_type":"L","value":"',
1440                             attrL,'"},{"trait_type":"T","value":"',
1441                             attrT,'"},{"trait_type":"S","value":"',
1442                             attrS,'"},{"trait_type":"P","value":"',
1443                             attrP,'"}],',extURL,aniURL,imgURL,'}'
1444                             )
1445                         )
1446                     )
1447                 )
1448             );
1449   }
1450 }
1451 //end