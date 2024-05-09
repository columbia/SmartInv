1 // SPDX-License-Identifier: BUSL-1.1
2 
3 pragma solidity ^0.8.4;
4 
5 // Deployed by @CryptoSamurai031 - Telegram user
6 
7 interface IERC165 {
8     function supportsInterface(bytes4 interfaceId) external view returns (bool);
9 }
10 
11 interface IERC721 is IERC165 {
12     /**
13      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
14      */
15     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
16 
17     /**
18      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
19      */
20     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
21 
22     /**
23      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
24      */
25     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
26 
27     /**
28      * @dev Returns the number of tokens in ``owner``'s account.
29      */
30     function balanceOf(address owner) external view returns (uint256 balance);
31 
32     /**
33      * @dev Returns the owner of the `tokenId` token.
34      *
35      * Requirements:
36      *
37      * - `tokenId` must exist.
38      */
39     function ownerOf(uint256 tokenId) external view returns (address owner);
40 
41     /**
42      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
43      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
44      *
45      * Requirements:
46      *
47      * - `from` cannot be the zero address.
48      * - `to` cannot be the zero address.
49      * - `tokenId` token must exist and be owned by `from`.
50      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
51      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
52      *
53      * Emits a {Transfer} event.
54      */
55     function safeTransferFrom(
56         address from,
57         address to,
58         uint256 tokenId
59     ) external;
60 
61     /**
62      * @dev Transfers `tokenId` token from `from` to `to`.
63      *
64      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must be owned by `from`.
71      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address from,
77         address to,
78         uint256 tokenId
79     ) external;
80 
81     /**
82      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
83      * The approval is cleared when the token is transferred.
84      *
85      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
86      *
87      * Requirements:
88      *
89      * - The caller must own the token or be an approved operator.
90      * - `tokenId` must exist.
91      *
92      * Emits an {Approval} event.
93      */
94     function approve(address to, uint256 tokenId) external;
95 
96     /**
97      * @dev Returns the account approved for `tokenId` token.
98      *
99      * Requirements:
100      *
101      * - `tokenId` must exist.
102      */
103     function getApproved(uint256 tokenId) external view returns (address operator);
104 
105     /**
106      * @dev Approve or remove `operator` as an operator for the caller.
107      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
108      *
109      * Requirements:
110      *
111      * - The `operator` cannot be the caller.
112      *
113      * Emits an {ApprovalForAll} event.
114      */
115     function setApprovalForAll(address operator, bool _approved) external;
116 
117     /**
118      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
119      *
120      * See {setApprovalForAll}
121      */
122     function isApprovedForAll(address owner, address operator) external view returns (bool);
123 
124     /**
125      * @dev Safely transfers `tokenId` token from `from` to `to`.
126      *
127      * Requirements:
128      *
129      * - `from` cannot be the zero address.
130      * - `to` cannot be the zero address.
131      * - `tokenId` token must exist and be owned by `from`.
132      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
133      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
134      *
135      * Emits a {Transfer} event.
136      */
137     function safeTransferFrom(
138         address from,
139         address to,
140         uint256 tokenId,
141         bytes calldata data
142     ) external;
143 }
144 
145 interface IERC721Receiver {
146     /**
147      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
148      * by `operator` from `from`, this function is called.
149      *
150      * It must return its Solidity selector to confirm the token transfer.
151      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
152      *
153      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
154      */
155     function onERC721Received(
156         address operator,
157         address from,
158         uint256 tokenId,
159         bytes calldata data
160     ) external returns (bytes4);
161 }
162 
163 interface IERC721Metadata is IERC721 {
164     /**
165      * @dev Returns the token collection name.
166      */
167     function name() external view returns (string memory);
168 
169     /**
170      * @dev Returns the token collection symbol.
171      */
172     function symbol() external view returns (string memory);
173 
174     /**
175      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
176      */
177     function tokenURI(uint256 tokenId) external view returns (string memory);
178 }
179 
180 
181 interface IERC721Enumerable is IERC721 {
182     /**
183      * @dev Returns the total amount of tokens stored by the contract.
184      */
185     function totalSupply() external view returns (uint256);
186 
187     /**
188      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
189      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
190      */
191     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
192 
193     /**
194      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
195      * Use along with {totalSupply} to enumerate all tokens.
196      */
197     function tokenByIndex(uint256 index) external view returns (uint256);
198 }
199 
200 
201 library Address {
202     function isContract(address account) internal view returns (bool) {
203         // This method relies on extcodesize/address.code.length, which returns 0
204         // for contracts in construction, since the code is only stored at the end
205         // of the constructor execution.
206 
207         return account.code.length > 0;
208     }
209 
210     function sendValue(address payable recipient, uint256 amount) internal {
211         require(address(this).balance >= amount, "Address: insufficient balance");
212 
213         (bool success, ) = recipient.call{value: amount}("");
214         require(success, "Address: unable to send value, recipient may have reverted");
215     }
216 
217     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
218         return functionCall(target, data, "Address: low-level call failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
223      * `errorMessage` as a fallback revert reason when `target` reverts.
224      *
225      * _Available since v3.1._
226      */
227     function functionCall(
228         address target,
229         bytes memory data,
230         string memory errorMessage
231     ) internal returns (bytes memory) {
232         return functionCallWithValue(target, data, 0, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but also transferring `value` wei to `target`.
238      *
239      * Requirements:
240      *
241      * - the calling contract must have an ETH balance of at least `value`.
242      * - the called Solidity function must be `payable`.
243      *
244      * _Available since v3.1._
245      */
246     function functionCallWithValue(
247         address target,
248         bytes memory data,
249         uint256 value
250     ) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
256      * with `errorMessage` as a fallback revert reason when `target` reverts.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(
261         address target,
262         bytes memory data,
263         uint256 value,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         require(address(this).balance >= value, "Address: insufficient balance for call");
267         require(isContract(target), "Address: call to non-contract");
268 
269         (bool success, bytes memory returndata) = target.call{value: value}(data);
270         return verifyCallResult(success, returndata, errorMessage);
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
275      * but performing a static call.
276      *
277      * _Available since v3.3._
278      */
279     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
280         return functionStaticCall(target, data, "Address: low-level static call failed");
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
285      * but performing a static call.
286      *
287      * _Available since v3.3._
288      */
289     function functionStaticCall(
290         address target,
291         bytes memory data,
292         string memory errorMessage
293     ) internal view returns (bytes memory) {
294         require(isContract(target), "Address: static call to non-contract");
295 
296         (bool success, bytes memory returndata) = target.staticcall(data);
297         return verifyCallResult(success, returndata, errorMessage);
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
302      * but performing a delegate call.
303      *
304      * _Available since v3.4._
305      */
306     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
307         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
312      * but performing a delegate call.
313      *
314      * _Available since v3.4._
315      */
316     function functionDelegateCall(
317         address target,
318         bytes memory data,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         require(isContract(target), "Address: delegate call to non-contract");
322 
323         (bool success, bytes memory returndata) = target.delegatecall(data);
324         return verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     /**
328      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
329      * revert reason using the provided one.
330      *
331      * _Available since v4.3._
332      */
333     function verifyCallResult(
334         bool success,
335         bytes memory returndata,
336         string memory errorMessage
337     ) internal pure returns (bytes memory) {
338         if (success) {
339             return returndata;
340         } else {
341             // Look for revert reason and bubble it up if present
342             if (returndata.length > 0) {
343                 // The easiest way to bubble the revert reason is using memory via assembly
344 
345                 assembly {
346                     let returndata_size := mload(returndata)
347                     revert(add(32, returndata), returndata_size)
348                 }
349             } else {
350                 revert(errorMessage);
351             }
352         }
353     }
354 }
355 
356 
357 abstract contract Context {
358     function _msgSender() internal view virtual returns (address) {
359         return msg.sender;
360     }
361 
362     function _msgData() internal view virtual returns (bytes calldata) {
363         return msg.data;
364     }
365 }
366 
367 
368 library Strings {
369     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
370 
371     /**
372      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
373      */
374     function toString(uint256 value) internal pure returns (string memory) {
375         // Inspired by OraclizeAPI's implementation - MIT licence
376         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
377 
378         if (value == 0) {
379             return "0";
380         }
381         uint256 temp = value;
382         uint256 digits;
383         while (temp != 0) {
384             digits++;
385             temp /= 10;
386         }
387         bytes memory buffer = new bytes(digits);
388         while (value != 0) {
389             digits -= 1;
390             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
391             value /= 10;
392         }
393         return string(buffer);
394     }
395 
396     /**
397      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
398      */
399     function toHexString(uint256 value) internal pure returns (string memory) {
400         if (value == 0) {
401             return "0x00";
402         }
403         uint256 temp = value;
404         uint256 length = 0;
405         while (temp != 0) {
406             length++;
407             temp >>= 8;
408         }
409         return toHexString(value, length);
410     }
411 
412     /**
413      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
414      */
415     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
416         bytes memory buffer = new bytes(2 * length + 2);
417         buffer[0] = "0";
418         buffer[1] = "x";
419         for (uint256 i = 2 * length + 1; i > 1; --i) {
420             buffer[i] = _HEX_SYMBOLS[value & 0xf];
421             value >>= 4;
422         }
423         require(value == 0, "Strings: hex length insufficient");
424         return string(buffer);
425     }
426 }
427 
428 
429 abstract contract ERC165 is IERC165 {
430     /**
431      * @dev See {IERC165-supportsInterface}.
432      */
433     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
434         return interfaceId == type(IERC165).interfaceId;
435     }
436 }
437 
438 
439 // 721A made by Chiru Labs
440 
441 error ApprovalCallerNotOwnerNorApproved();
442 error ApprovalQueryForNonexistentToken();
443 error ApproveToCaller();
444 error ApprovalToCurrentOwner();
445 error BalanceQueryForZeroAddress();
446 error MintedQueryForZeroAddress();
447 error BurnedQueryForZeroAddress();
448 error MintToZeroAddress();
449 error MintZeroQuantity();
450 error OwnerIndexOutOfBounds();
451 error OwnerQueryForNonexistentToken();
452 error TokenIndexOutOfBounds();
453 error TransferCallerNotOwnerNorApproved();
454 error TransferFromIncorrectOwner();
455 error TransferToNonERC721ReceiverImplementer();
456 error TransferToZeroAddress();
457 error URIQueryForNonexistentToken();
458 
459 /**
460  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
461  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
462  *
463  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
464  *
465  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
466  *
467  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
468  */
469 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
470     using Address for address;
471     using Strings for uint256;
472 
473     // Compiler will pack this into a single 256bit word.
474     struct TokenOwnership {
475         // The address of the owner.
476         address addr;
477         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
478         uint64 startTimestamp;
479         // Whether the token has been burned.
480         bool burned;
481     }
482 
483     // Compiler will pack this into a single 256bit word.
484     struct AddressData {
485         // Realistically, 2**64-1 is more than enough.
486         uint64 balance;
487         // Keeps track of mint count with minimal overhead for tokenomics.
488         uint64 numberMinted;
489         // Keeps track of burn count with minimal overhead for tokenomics.
490         uint64 numberBurned;
491     }
492 
493     // Compiler will pack the following 
494     // _currentIndex and _burnCounter into a single 256bit word.
495     
496     // The tokenId of the next token to be minted.
497     uint128 internal _currentIndex;
498 
499     // The number of tokens burned.
500     uint128 internal _burnCounter;
501 
502     // Token name
503     string private _name;
504 
505     // Token symbol
506     string private _symbol;
507 
508     // Mapping from token ID to ownership details
509     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
510     mapping(uint256 => TokenOwnership) internal _ownerships;
511 
512     // Mapping owner address to address data
513     mapping(address => AddressData) private _addressData;
514 
515     // Mapping from token ID to approved address
516     mapping(uint256 => address) private _tokenApprovals;
517 
518     // Mapping from owner to operator approvals
519     mapping(address => mapping(address => bool)) private _operatorApprovals;
520 
521     constructor(string memory name_, string memory symbol_) {
522         _name = name_;
523         _symbol = symbol_;
524     }
525 
526     /**
527      * @dev See {IERC721Enumerable-totalSupply}.
528      */
529     function totalSupply() public view override returns (uint256) {
530         // Counter underflow is impossible as _burnCounter cannot be incremented
531         // more than _currentIndex times
532         unchecked {
533             return _currentIndex - _burnCounter;    
534         }
535     }
536 
537     /**
538      * @dev See {IERC721Enumerable-tokenByIndex}.
539      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
540      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
541      */
542     function tokenByIndex(uint256 index) public view override returns (uint256) {
543         uint256 numMintedSoFar = _currentIndex;
544         uint256 tokenIdsIdx;
545 
546         // Counter overflow is impossible as the loop breaks when
547         // uint256 i is equal to another uint256 numMintedSoFar.
548         unchecked {
549             for (uint256 i; i < numMintedSoFar; i++) {
550                 TokenOwnership memory ownership = _ownerships[i];
551                 if (!ownership.burned) {
552                     if (tokenIdsIdx == index) {
553                         return i;
554                     }
555                     tokenIdsIdx++;
556                 }
557             }
558         }
559         revert TokenIndexOutOfBounds();
560     }
561 
562     /**
563      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
564      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
565      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
566      */
567     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
568         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
569         uint256 numMintedSoFar = _currentIndex;
570         uint256 tokenIdsIdx;
571         address currOwnershipAddr;
572 
573         // Counter overflow is impossible as the loop breaks when
574         // uint256 i is equal to another uint256 numMintedSoFar.
575         unchecked {
576             for (uint256 i; i < numMintedSoFar; i++) {
577                 TokenOwnership memory ownership = _ownerships[i];
578                 if (ownership.burned) {
579                     continue;
580                 }
581                 if (ownership.addr != address(0)) {
582                     currOwnershipAddr = ownership.addr;
583                 }
584                 if (currOwnershipAddr == owner) {
585                     if (tokenIdsIdx == index) {
586                         return i;
587                     }
588                     tokenIdsIdx++;
589                 }
590             }
591         }
592 
593         // Execution should never reach this point.
594         revert();
595     }
596 
597     /**
598      * @dev See {IERC165-supportsInterface}.
599      */
600     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
601         return
602             interfaceId == type(IERC721).interfaceId ||
603             interfaceId == type(IERC721Metadata).interfaceId ||
604             interfaceId == type(IERC721Enumerable).interfaceId ||
605             super.supportsInterface(interfaceId);
606     }
607 
608     /**
609      * @dev See {IERC721-balanceOf}.
610      */
611     function balanceOf(address owner) public view override returns (uint256) {
612         if (owner == address(0)) revert BalanceQueryForZeroAddress();
613         return uint256(_addressData[owner].balance);
614     }
615 
616     function _numberMinted(address owner) internal view returns (uint256) {
617         if (owner == address(0)) revert MintedQueryForZeroAddress();
618         return uint256(_addressData[owner].numberMinted);
619     }
620 
621     function _numberBurned(address owner) internal view returns (uint256) {
622         if (owner == address(0)) revert BurnedQueryForZeroAddress();
623         return uint256(_addressData[owner].numberBurned);
624     }
625 
626     /**
627      * Gas spent here starts off proportional to the maximum mint batch size.
628      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
629      */
630     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
631         uint256 curr = tokenId;
632 
633         unchecked {
634             if (curr < _currentIndex) {
635                 TokenOwnership memory ownership = _ownerships[curr];
636                 if (!ownership.burned) {
637                     if (ownership.addr != address(0)) {
638                         return ownership;
639                     }
640                     // Invariant: 
641                     // There will always be an ownership that has an address and is not burned 
642                     // before an ownership that does not have an address and is not burned.
643                     // Hence, curr will not underflow.
644                     while (true) {
645                         curr--;
646                         ownership = _ownerships[curr];
647                         if (ownership.addr != address(0)) {
648                             return ownership;
649                         }
650                     }
651                 }
652             }
653         }
654         revert OwnerQueryForNonexistentToken();
655     }
656 
657     /**
658      * @dev See {IERC721-ownerOf}.
659      */
660     function ownerOf(uint256 tokenId) public view override returns (address) {
661         return ownershipOf(tokenId).addr;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-name}.
666      */
667     function name() public view virtual override returns (string memory) {
668         return _name;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-symbol}.
673      */
674     function symbol() public view virtual override returns (string memory) {
675         return _symbol;
676     }
677 
678     /**
679      * @dev See {IERC721Metadata-tokenURI}.
680      */
681     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
682         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
683 
684         string memory baseURI = _baseURI();
685         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
686     }
687 
688     /**
689      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
690      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
691      * by default, can be overriden in child contracts.
692      */
693     function _baseURI() internal view virtual returns (string memory) {
694         return '';
695     }
696 
697     /**
698      * @dev See {IERC721-approve}.
699      */
700     function approve(address to, uint256 tokenId) public override {
701         address owner = ERC721A.ownerOf(tokenId);
702         if (to == owner) revert ApprovalToCurrentOwner();
703 
704         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
705             revert ApprovalCallerNotOwnerNorApproved();
706         }
707 
708         _approve(to, tokenId, owner);
709     }
710 
711     /**
712      * @dev See {IERC721-getApproved}.
713      */
714     function getApproved(uint256 tokenId) public view override returns (address) {
715         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
716 
717         return _tokenApprovals[tokenId];
718     }
719 
720     /**
721      * @dev See {IERC721-setApprovalForAll}.
722      */
723     function setApprovalForAll(address operator, bool approved) public override {
724         if (operator == _msgSender()) revert ApproveToCaller();
725 
726         _operatorApprovals[_msgSender()][operator] = approved;
727         emit ApprovalForAll(_msgSender(), operator, approved);
728     }
729 
730     /**
731      * @dev See {IERC721-isApprovedForAll}.
732      */
733     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
734         return _operatorApprovals[owner][operator];
735     }
736 
737     /**
738      * @dev See {IERC721-transferFrom}.
739      */
740     function transferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) public virtual override {
745         _transfer(from, to, tokenId);
746     }
747 
748     /**
749      * @dev See {IERC721-safeTransferFrom}.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId
755     ) public virtual override {
756         safeTransferFrom(from, to, tokenId, '');
757     }
758 
759     /**
760      * @dev See {IERC721-safeTransferFrom}.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId,
766         bytes memory _data
767     ) public virtual override {
768         _transfer(from, to, tokenId);
769         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
770             revert TransferToNonERC721ReceiverImplementer();
771         }
772     }
773 
774     /**
775      * @dev Returns whether `tokenId` exists.
776      *
777      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
778      *
779      * Tokens start existing when they are minted (`_mint`),
780      */
781     function _exists(uint256 tokenId) internal view returns (bool) {
782         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
783     }
784 
785     function _safeMint(address to, uint256 quantity) internal {
786         _safeMint(to, quantity, '');
787     }
788 
789     /**
790      * @dev Safely mints `quantity` tokens and transfers them to `to`.
791      *
792      * Requirements:
793      *
794      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
795      * - `quantity` must be greater than 0.
796      *
797      * Emits a {Transfer} event.
798      */
799     function _safeMint(
800         address to,
801         uint256 quantity,
802         bytes memory _data
803     ) internal {
804         _mint(to, quantity, _data, true);
805     }
806 
807     /**
808      * @dev Mints `quantity` tokens and transfers them to `to`.
809      *
810      * Requirements:
811      *
812      * - `to` cannot be the zero address.
813      * - `quantity` must be greater than 0.
814      *
815      * Emits a {Transfer} event.
816      */
817     function _mint(
818         address to,
819         uint256 quantity,
820         bytes memory _data,
821         bool safe
822     ) internal {
823         uint256 startTokenId = _currentIndex;
824         if (to == address(0)) revert MintToZeroAddress();
825         if (quantity == 0) revert MintZeroQuantity();
826 
827         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
828 
829         // Overflows are incredibly unrealistic.
830         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
831         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
832         unchecked {
833             _addressData[to].balance += uint64(quantity);
834             _addressData[to].numberMinted += uint64(quantity);
835 
836             _ownerships[startTokenId].addr = to;
837             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
838 
839             uint256 updatedIndex = startTokenId;
840 
841             for (uint256 i; i < quantity; i++) {
842                 emit Transfer(address(0), to, updatedIndex);
843                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
844                     revert TransferToNonERC721ReceiverImplementer();
845                 }
846                 updatedIndex++;
847             }
848 
849             _currentIndex = uint128(updatedIndex);
850         }
851         _afterTokenTransfers(address(0), to, startTokenId, quantity);
852     }
853 
854     /**
855      * @dev Transfers `tokenId` from `from` to `to`.
856      *
857      * Requirements:
858      *
859      * - `to` cannot be the zero address.
860      * - `tokenId` token must be owned by `from`.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _transfer(
865         address from,
866         address to,
867         uint256 tokenId
868     ) private {
869         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
870 
871         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
872             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
873             getApproved(tokenId) == _msgSender());
874 
875         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
876         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
877         if (to == address(0)) revert TransferToZeroAddress();
878 
879         _beforeTokenTransfers(from, to, tokenId, 1);
880 
881         // Clear approvals from the previous owner
882         _approve(address(0), tokenId, prevOwnership.addr);
883 
884         // Underflow of the sender's balance is impossible because we check for
885         // ownership above and the recipient's balance can't realistically overflow.
886         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
887         unchecked {
888             _addressData[from].balance -= 1;
889             _addressData[to].balance += 1;
890 
891             _ownerships[tokenId].addr = to;
892             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
893 
894             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
895             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
896             uint256 nextTokenId = tokenId + 1;
897             if (_ownerships[nextTokenId].addr == address(0)) {
898                 // This will suffice for checking _exists(nextTokenId),
899                 // as a burned slot cannot contain the zero address.
900                 if (nextTokenId < _currentIndex) {
901                     _ownerships[nextTokenId].addr = prevOwnership.addr;
902                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
903                 }
904             }
905         }
906 
907         emit Transfer(from, to, tokenId);
908         _afterTokenTransfers(from, to, tokenId, 1);
909     }
910 
911     /**
912      * @dev Destroys `tokenId`.
913      * The approval is cleared when the token is burned.
914      *
915      * Requirements:
916      *
917      * - `tokenId` must exist.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _burn(uint256 tokenId) internal virtual {
922         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
923 
924         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
925 
926         // Clear approvals from the previous owner
927         _approve(address(0), tokenId, prevOwnership.addr);
928 
929         // Underflow of the sender's balance is impossible because we check for
930         // ownership above and the recipient's balance can't realistically overflow.
931         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
932         unchecked {
933             _addressData[prevOwnership.addr].balance -= 1;
934             _addressData[prevOwnership.addr].numberBurned += 1;
935 
936             // Keep track of who burned the token, and the timestamp of burning.
937             _ownerships[tokenId].addr = prevOwnership.addr;
938             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
939             _ownerships[tokenId].burned = true;
940 
941             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
942             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
943             uint256 nextTokenId = tokenId + 1;
944             if (_ownerships[nextTokenId].addr == address(0)) {
945                 // This will suffice for checking _exists(nextTokenId),
946                 // as a burned slot cannot contain the zero address.
947                 if (nextTokenId < _currentIndex) {
948                     _ownerships[nextTokenId].addr = prevOwnership.addr;
949                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
950                 }
951             }
952         }
953 
954         emit Transfer(prevOwnership.addr, address(0), tokenId);
955         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
956 
957         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
958         unchecked { 
959             _burnCounter++;
960         }
961     }
962 
963     /**
964      * @dev Approve `to` to operate on `tokenId`
965      *
966      * Emits a {Approval} event.
967      */
968     function _approve(
969         address to,
970         uint256 tokenId,
971         address owner
972     ) private {
973         _tokenApprovals[tokenId] = to;
974         emit Approval(owner, to, tokenId);
975     }
976 
977     /**
978      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
979      * The call is not executed if the target address is not a contract.
980      *
981      * @param from address representing the previous owner of the given token ID
982      * @param to target address that will receive the tokens
983      * @param tokenId uint256 ID of the token to be transferred
984      * @param _data bytes optional data to send along with the call
985      * @return bool whether the call correctly returned the expected magic value
986      */
987     function _checkOnERC721Received(
988         address from,
989         address to,
990         uint256 tokenId,
991         bytes memory _data
992     ) private returns (bool) {
993         if (to.isContract()) {
994             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
995                 return retval == IERC721Receiver(to).onERC721Received.selector;
996             } catch (bytes memory reason) {
997                 if (reason.length == 0) {
998                     revert TransferToNonERC721ReceiverImplementer();
999                 } else {
1000                     assembly {
1001                         revert(add(32, reason), mload(reason))
1002                     }
1003                 }
1004             }
1005         } else {
1006             return true;
1007         }
1008     }
1009 
1010     /**
1011      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1012      * And also called before burning one token.
1013      *
1014      * startTokenId - the first token id to be transferred
1015      * quantity - the amount to be transferred
1016      *
1017      * Calling conditions:
1018      *
1019      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1020      * transferred to `to`.
1021      * - When `from` is zero, `tokenId` will be minted for `to`.
1022      * - When `to` is zero, `tokenId` will be burned by `from`.
1023      * - `from` and `to` are never both zero.
1024      */
1025     function _beforeTokenTransfers(
1026         address from,
1027         address to,
1028         uint256 startTokenId,
1029         uint256 quantity
1030     ) internal virtual {}
1031 
1032     /**
1033      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1034      * minting.
1035      * And also called after one token has been burned.
1036      *
1037      * startTokenId - the first token id to be transferred
1038      * quantity - the amount to be transferred
1039      *
1040      * Calling conditions:
1041      *
1042      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1043      * transferred to `to`.
1044      * - When `from` is zero, `tokenId` has been minted for `to`.
1045      * - When `to` is zero, `tokenId` has been burned by `from`.
1046      * - `from` and `to` are never both zero.
1047      */
1048     function _afterTokenTransfers(
1049         address from,
1050         address to,
1051         uint256 startTokenId,
1052         uint256 quantity
1053     ) internal virtual {}
1054 }
1055 
1056 interface IERC20 {
1057     function transfer(address recipient, uint256 amount) external returns (bool);
1058 }
1059 
1060 abstract contract Ownable is Context {
1061     address private _owner;
1062 
1063     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1064 
1065     constructor() {
1066         _setOwner(_msgSender());
1067     }
1068 
1069     function owner() public view virtual returns (address) {
1070         return _owner;
1071     }
1072 
1073     modifier onlyOwner() {
1074         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1075         _;
1076     }
1077 
1078     function renounceOwnership() public virtual onlyOwner {
1079         _setOwner(address(0));
1080     }
1081 
1082     function transferOwnership(address newOwner) public virtual onlyOwner {
1083         require(newOwner != address(0), "Ownable: new owner is the zero address");
1084         _setOwner(newOwner);
1085     }
1086 
1087     function _setOwner(address newOwner) private {
1088         address oldOwner = _owner;
1089         _owner = newOwner;
1090         emit OwnershipTransferred(oldOwner, newOwner);
1091     }
1092 }
1093 
1094 contract WonkeyDonkey is ERC721A, Ownable {
1095     using Strings for uint256;
1096 
1097     uint256 public maxNfts = 10000;
1098 
1099     uint256 public maxBatch = 5;
1100     uint256 public price = 120000000000000000;
1101     uint256 public maxFree = 1000;
1102     uint256 public freeMinted;
1103 
1104     string private baseURI;
1105     string public hiddenURI;
1106     string public contractMetadata;
1107 
1108     bool public publicStart;
1109     bool public whitelistStart;
1110     bool public freeStart;
1111 
1112     bool private revealed;
1113 
1114     mapping(address => bool) public whitelist;
1115     mapping(address => uint256) public freeList;
1116 
1117     constructor(string memory name_, string memory symbol_, string memory hiddenURI_) ERC721A(name_, symbol_) {
1118         hiddenURI = hiddenURI_;
1119     }
1120 
1121     function _baseURI() internal view virtual override returns (string memory){
1122         return baseURI;
1123     }
1124 
1125     function setBaseURI(string memory _newURI) external onlyOwner {
1126         baseURI = _newURI;
1127     }
1128 
1129     function setMaxBatch(uint256 amount) external onlyOwner {
1130         maxBatch = amount;
1131     }
1132 
1133     function setHiddenURI(string memory _newHiddenURI) external onlyOwner {
1134         hiddenURI = _newHiddenURI;
1135     }
1136 
1137     function setContractMetadataURI(string memory _newURI) external onlyOwner {
1138         contractMetadata = _newURI;
1139     }
1140 
1141     ///@dev price in wei
1142     function setPrice(uint256 price_) external onlyOwner {
1143         price = price_;
1144     }
1145 
1146     function reveal() external onlyOwner {
1147         revealed = true;
1148     }
1149 
1150     function contractURI() public view returns (string memory) {
1151         return contractMetadata;
1152     }
1153 
1154     function toggleWhitelist(address account, bool enable) external onlyOwner {
1155         whitelist[account] = enable;
1156     }
1157 
1158     function bulkWhitelist(address[] calldata accounts) external onlyOwner {
1159         uint256 length = accounts.length;
1160         for(uint256 i = 0; i < length; i++) {
1161             whitelist[accounts[i]] = true;
1162         }
1163     }
1164 
1165     function setFreeList(address account, uint256 number) external onlyOwner {
1166         freeList[account] = number;
1167     }
1168 
1169     function bulkFreeList(address[] calldata accounts, uint256[] calldata quantities) external onlyOwner {
1170         uint256 length = accounts.length;
1171         require(length == quantities.length, "Arrays length must be equal");
1172         for(uint256 i = 0; i < length; i++) {
1173             freeList[accounts[i]] = quantities[i];
1174         }
1175     }
1176 
1177     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1178         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
1179 
1180         if(revealed == false) {
1181             return hiddenURI;
1182         }
1183 
1184         string memory baseURI_ = _baseURI();
1185         return bytes(baseURI_).length > 0
1186             ? string(abi.encodePacked(baseURI_, tokenId.toString(), ".json")) : '.json';
1187     }
1188 
1189     function setPublicStart(bool enable) external onlyOwner {
1190         publicStart = enable;
1191     }
1192 
1193     function setWhitelistStart(bool enable) external onlyOwner {
1194         whitelistStart = enable;
1195     }
1196 
1197     function setFreeStart(bool enable) external onlyOwner {
1198         freeStart = enable;
1199     }
1200 
1201     function tokensOfOwner(address owner)
1202         external
1203         view
1204         returns (uint256[] memory)
1205     {
1206         uint256 count = balanceOf(owner);
1207         uint256[] memory ids = new uint256[](count);
1208         for (uint256 i = 0; i < count; i++) {
1209             ids[i] = tokenOfOwnerByIndex(owner, i);
1210         }
1211         return ids;
1212     }
1213 
1214     function publicMint(uint256 _times) external payable {
1215         require(publicStart, "public mint not started");
1216         require(_times > 0 && _times <= maxBatch, "must mint fewer in each batch");
1217         require(totalSupply() + _times <= maxNfts, "max supply reached!");
1218         require(msg.value == _times * price, "value error, please check price.");
1219 
1220         _safeMint(_msgSender(), _times);
1221     }
1222 
1223     function whitelistMint(uint256 _times) external payable {
1224         require(whitelistStart, "whitelist not started");
1225         require(whitelist[_msgSender()], "not whitelisted");
1226         require(_times > 0 && _times <= maxBatch, "must mint fewer in each batch");
1227         require(totalSupply() + _times <= maxNfts, "max supply reached!");
1228         require(msg.value == _times * price, "value error, please check price.");
1229 
1230         _safeMint(_msgSender(), _times);
1231     }
1232 
1233     function freeMint(uint256 _times) external {
1234         require(freeStart, "free mint not started");
1235         address account = _msgSender();
1236         require(freeList[account] >= _times, "exceed free mint amount");
1237         require(_times > 0 && _times <= maxBatch, "must mint fewer in each batch");
1238         require(totalSupply() + _times <= maxNfts, "max supply reached!");
1239         require(freeMinted + _times <= maxFree, "max free supply reached!");
1240 
1241         freeMinted += _times;
1242         freeList[account] -= _times;
1243         _safeMint(account, _times);
1244     }
1245 
1246     function withdrawEth(uint256 weiAmount) external onlyOwner {
1247         (bool sent, ) = payable(_msgSender()).call{value: weiAmount}("");
1248         require(sent, "Failed to withdraw");
1249     }
1250 
1251     /// @dev amount on token decimals
1252     function withdrawToken(address tokenAddress, uint256 amount) external onlyOwner {
1253         IERC20(tokenAddress).transfer(_msgSender(), amount);
1254     }
1255 
1256     receive() external payable {}
1257 }