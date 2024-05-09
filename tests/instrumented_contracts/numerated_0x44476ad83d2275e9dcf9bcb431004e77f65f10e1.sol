1 // SPDX-License-Identifier: MIT
2  
3 pragma solidity ^0.8.0;
4  
5 abstract contract ReentrancyGuard {
6  
7     uint256 private constant _NOT_ENTERED = 1;
8     uint256 private constant _ENTERED = 2;
9  
10     uint256 private _status;
11  
12     constructor() {
13         _status = _NOT_ENTERED;
14     }
15     modifier nonReentrant() {
16         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
17         _status = _ENTERED;
18         _;
19         _status = _NOT_ENTERED;
20     }
21 }
22  
23  
24 library MerkleProof {
25  
26     function verify(
27         bytes32[] memory proof,
28         bytes32 root,
29         bytes32 leaf
30     ) internal pure returns (bool) {
31         return processProof(proof, leaf) == root;
32     }
33  
34     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
35         bytes32 computedHash = leaf;
36         for (uint256 i = 0; i < proof.length; i++) {
37             bytes32 proofElement = proof[i];
38             if (computedHash <= proofElement) {
39                 // Hash(current computed hash + current element of the proof)
40                 computedHash = _efficientHash(computedHash, proofElement);
41             } else {
42                 // Hash(current element of the proof + current computed hash)
43                 computedHash = _efficientHash(proofElement, computedHash);
44             }
45         }
46         return computedHash;
47     }
48  
49     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
50         assembly {
51             mstore(0x00, a)
52             mstore(0x20, b)
53             value := keccak256(0x00, 0x40)
54         }
55     }
56 }
57  
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60  
61     function toString(uint256 value) internal pure returns (string memory) {
62         // Inspired by OraclizeAPI's implementation - MIT licence
63         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
64  
65         if (value == 0) {
66             return "0";
67         }
68         uint256 temp = value;
69         uint256 digits;
70         while (temp != 0) {
71             digits++;
72             temp /= 10;
73         }
74         bytes memory buffer = new bytes(digits);
75         while (value != 0) {
76             digits -= 1;
77             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
78             value /= 10;
79         }
80         return string(buffer);
81     }
82  
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
85      */
86     function toHexString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0x00";
89         }
90         uint256 temp = value;
91         uint256 length = 0;
92         while (temp != 0) {
93             length++;
94             temp >>= 8;
95         }
96         return toHexString(value, length);
97     }
98  
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
101      */
102     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
103         bytes memory buffer = new bytes(2 * length + 2);
104         buffer[0] = "0";
105         buffer[1] = "x";
106         for (uint256 i = 2 * length + 1; i > 1; --i) {
107             buffer[i] = _HEX_SYMBOLS[value & 0xf];
108             value >>= 4;
109         }
110         require(value == 0, "Strings: hex length insufficient");
111         return string(buffer);
112     }
113 }
114  
115  
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address) {
118         return msg.sender;
119     }
120  
121     function _msgData() internal view virtual returns (bytes calldata) {
122         return msg.data;
123     }
124 }
125  
126  
127 abstract contract Ownable is Context {
128     address private _owner;
129  
130     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131     constructor() {
132         _transferOwnership(_msgSender());
133     }
134  
135     function owner() public view virtual returns (address) {
136         return _owner;
137     }
138  
139     modifier onlyOwner() {
140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
141         _;
142     }
143  
144     function renounceOwnership() public virtual onlyOwner {
145         _transferOwnership(address(0));
146     }
147  
148     function transferOwnership(address newOwner) public virtual onlyOwner {
149         require(newOwner != address(0), "Ownable: new owner is the zero address");
150         _transferOwnership(newOwner);
151     }
152  
153     function _transferOwnership(address newOwner) internal virtual {
154         address oldOwner = _owner;
155         _owner = newOwner;
156         emit OwnershipTransferred(oldOwner, newOwner);
157     }
158 }
159  
160  
161 library Address {
162  
163     function isContract(address account) internal view returns (bool) {
164         return account.code.length > 0;
165     }
166  
167     function sendValue(address payable recipient, uint256 amount) internal {
168         require(address(this).balance >= amount, "Address: insufficient balance");
169  
170         (bool success, ) = recipient.call{value: amount}("");
171         require(success, "Address: unable to send value, recipient may have reverted");
172     }
173  
174     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
175         return functionCall(target, data, "Address: low-level call failed");
176     }
177  
178     function functionCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, 0, errorMessage);
184     }
185  
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
192     }
193  
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         require(address(this).balance >= value, "Address: insufficient balance for call");
201         require(isContract(target), "Address: call to non-contract");
202  
203         (bool success, bytes memory returndata) = target.call{value: value}(data);
204         return verifyCallResult(success, returndata, errorMessage);
205     }
206  
207     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
208         return functionStaticCall(target, data, "Address: low-level static call failed");
209     }
210  
211     function functionStaticCall(
212         address target,
213         bytes memory data,
214         string memory errorMessage
215     ) internal view returns (bytes memory) {
216         require(isContract(target), "Address: static call to non-contract");
217  
218         (bool success, bytes memory returndata) = target.staticcall(data);
219         return verifyCallResult(success, returndata, errorMessage);
220     }
221  
222     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
223         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
224     }
225  
226     function functionDelegateCall(
227         address target,
228         bytes memory data,
229         string memory errorMessage
230     ) internal returns (bytes memory) {
231         require(isContract(target), "Address: delegate call to non-contract");
232  
233         (bool success, bytes memory returndata) = target.delegatecall(data);
234         return verifyCallResult(success, returndata, errorMessage);
235     }
236  
237     function verifyCallResult(
238         bool success,
239         bytes memory returndata,
240         string memory errorMessage
241     ) internal pure returns (bytes memory) {
242         if (success) {
243             return returndata;
244         } else {
245             // Look for revert reason and bubble it up if present
246             if (returndata.length > 0) {
247                 // The easiest way to bubble the revert reason is using memory via assembly
248  
249                 assembly {
250                     let returndata_size := mload(returndata)
251                     revert(add(32, returndata), returndata_size)
252                 }
253             } else {
254                 revert(errorMessage);
255             }
256         }
257     }
258 }
259  
260  
261 interface IERC721Receiver {
262  
263     function onERC721Received(
264         address operator,
265         address from,
266         uint256 tokenId,
267         bytes calldata data
268     ) external returns (bytes4);
269 }
270  
271 interface IERC165 {
272     function supportsInterface(bytes4 interfaceId) external view returns (bool);
273 }
274  
275  
276 abstract contract ERC165 is IERC165 {
277     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
278         return interfaceId == type(IERC165).interfaceId;
279     }
280 }
281  
282  
283 interface IERC721 is IERC165 {
284  
285     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
286  
287     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
288  
289     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
290  
291     function balanceOf(address owner) external view returns (uint256 balance);
292  
293     function ownerOf(uint256 tokenId) external view returns (address owner);
294  
295     function safeTransferFrom(
296         address from,
297         address to,
298         uint256 tokenId
299     ) external;
300  
301     function transferFrom(
302         address from,
303         address to,
304         uint256 tokenId
305     ) external;
306  
307     function approve(address to, uint256 tokenId) external;
308  
309     function getApproved(uint256 tokenId) external view returns (address operator);
310  
311     function setApprovalForAll(address operator, bool _approved) external;
312  
313     function isApprovedForAll(address owner, address operator) external view returns (bool);
314  
315     function safeTransferFrom(
316         address from,
317         address to,
318         uint256 tokenId,
319         bytes calldata data
320     ) external;
321 }
322  
323  
324 interface IERC721Enumerable is IERC721 {
325  
326     function totalSupply() external view returns (uint256);
327  
328     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
329  
330     function tokenByIndex(uint256 index) external view returns (uint256);
331 }
332  
333  
334 interface IERC721Metadata is IERC721 {
335  
336     function name() external view returns (string memory);
337     function symbol() external view returns (string memory);
338     function tokenURI(uint256 tokenId) external view returns (string memory);
339 }
340  
341 error ApprovalCallerNotOwnerNorApproved();
342 error ApprovalQueryForNonexistentToken();
343 error ApproveToCaller();
344 error ApprovalToCurrentOwner();
345 error BalanceQueryForZeroAddress();
346 error MintedQueryForZeroAddress();
347 error BurnedQueryForZeroAddress();
348 error AuxQueryForZeroAddress();
349 error MintToZeroAddress();
350 error MintZeroQuantity();
351 error OwnerIndexOutOfBounds();
352 error OwnerQueryForNonexistentToken();
353 error TokenIndexOutOfBounds();
354 error TransferCallerNotOwnerNorApproved();
355 error TransferFromIncorrectOwner();
356 error TransferToNonERC721ReceiverImplementer();
357 error TransferToZeroAddress();
358 error URIQueryForNonexistentToken();
359  
360  
361 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
362     using Address for address;
363     using Strings for uint256;
364  
365     // Compiler will pack this into a single 256bit word.
366     struct TokenOwnership {
367         // The address of the owner.
368         address addr;
369         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
370         uint64 startTimestamp;
371         // Whether the token has been burned.
372         bool burned;
373     }
374  
375     // Compiler will pack this into a single 256bit word.
376     struct AddressData {
377         // Realistically, 2**64-1 is more than enough.
378         uint64 balance;
379         // Keeps track of mint count with minimal overhead for tokenomics.
380         uint64 numberMinted;
381         // Keeps track of burn count with minimal overhead for tokenomics.
382         uint64 numberBurned;
383         // For miscellaneous variable(s) pertaining to the address
384         // (e.g. number of whitelist mint slots used).
385         // If there are multiple variables, please pack them into a uint64.
386         uint64 aux;
387     }
388  
389     // The tokenId of the next token to be minted.
390     uint256 internal _currentIndex;
391  
392     // The number of tokens burned.
393     uint256 internal _burnCounter;
394  
395     // Token name
396     string private _name;
397  
398     // Token symbol
399     string private _symbol;
400  
401     // Mapping from token ID to ownership details
402     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
403     mapping(uint256 => TokenOwnership) internal _ownerships;
404  
405     // Mapping owner address to address data
406     mapping(address => AddressData) private _addressData;
407  
408     // Mapping from token ID to approved address
409     mapping(uint256 => address) private _tokenApprovals;
410  
411     // Mapping from owner to operator approvals
412     mapping(address => mapping(address => bool)) private _operatorApprovals;
413  
414     constructor(string memory name_, string memory symbol_) {
415         _name = name_;
416         _symbol = symbol_;
417         _currentIndex = _startTokenId();
418     }
419  
420     /**
421      * To change the starting tokenId, please override this function.
422      */
423     function _startTokenId() internal view virtual returns (uint256) {
424         return 0;
425     }
426  
427     /**
428      * @dev See {IERC721Enumerable-totalSupply}.
429      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
430      */
431     function totalSupply() public view returns (uint256) {
432         // Counter underflow is impossible as _burnCounter cannot be incremented
433         // more than _currentIndex - _startTokenId() times
434         unchecked {
435             return _currentIndex - _burnCounter - _startTokenId();
436         }
437     }
438  
439     /**
440      * Returns the total amount of tokens minted in the contract.
441      */
442     function _totalMinted() internal view returns (uint256) {
443         // Counter underflow is impossible as _currentIndex does not decrement,
444         // and it is initialized to _startTokenId()
445         unchecked {
446             return _currentIndex - _startTokenId();
447         }
448     }
449  
450     /**
451      * @dev See {IERC165-supportsInterface}.
452      */
453     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
454         return
455             interfaceId == type(IERC721).interfaceId ||
456             interfaceId == type(IERC721Metadata).interfaceId ||
457             super.supportsInterface(interfaceId);
458     }
459  
460     /**
461      * @dev See {IERC721-balanceOf}.
462      */
463     function balanceOf(address owner) public view override returns (uint256) {
464         if (owner == address(0)) revert BalanceQueryForZeroAddress();
465         return uint256(_addressData[owner].balance);
466     }
467  
468     /**
469      * Returns the number of tokens minted by `owner`.
470      */
471     function _numberMinted(address owner) internal view returns (uint256) {
472         if (owner == address(0)) revert MintedQueryForZeroAddress();
473         return uint256(_addressData[owner].numberMinted);
474     }
475  
476     /**
477      * Returns the number of tokens burned by or on behalf of `owner`.
478      */
479     function _numberBurned(address owner) internal view returns (uint256) {
480         if (owner == address(0)) revert BurnedQueryForZeroAddress();
481         return uint256(_addressData[owner].numberBurned);
482     }
483  
484     /**
485      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
486      */
487     function _getAux(address owner) internal view returns (uint64) {
488         if (owner == address(0)) revert AuxQueryForZeroAddress();
489         return _addressData[owner].aux;
490     }
491  
492     /**
493      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
494      * If there are multiple variables, please pack them into a uint64.
495      */
496     function _setAux(address owner, uint64 aux) internal {
497         if (owner == address(0)) revert AuxQueryForZeroAddress();
498         _addressData[owner].aux = aux;
499     }
500  
501     /**
502      * Gas spent here starts off proportional to the maximum mint batch size.
503      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
504      */
505     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
506         uint256 curr = tokenId;
507  
508         unchecked {
509             if (_startTokenId() <= curr && curr < _currentIndex) {
510                 TokenOwnership memory ownership = _ownerships[curr];
511                 if (!ownership.burned) {
512                     if (ownership.addr != address(0)) {
513                         return ownership;
514                     }
515                     // Invariant:
516                     // There will always be an ownership that has an address and is not burned
517                     // before an ownership that does not have an address and is not burned.
518                     // Hence, curr will not underflow.
519                     while (true) {
520                         curr--;
521                         ownership = _ownerships[curr];
522                         if (ownership.addr != address(0)) {
523                             return ownership;
524                         }
525                     }
526                 }
527             }
528         }
529         revert OwnerQueryForNonexistentToken();
530     }
531  
532     /**
533      * @dev See {IERC721-ownerOf}.
534      */
535     function ownerOf(uint256 tokenId) public view override returns (address) {
536         return ownershipOf(tokenId).addr;
537     }
538  
539     /**
540      * @dev See {IERC721Metadata-name}.
541      */
542     function name() public view virtual override returns (string memory) {
543         return _name;
544     }
545  
546     /**
547      * @dev See {IERC721Metadata-symbol}.
548      */
549     function symbol() public view virtual override returns (string memory) {
550         return _symbol;
551     }
552  
553     /**
554      * @dev See {IERC721Metadata-tokenURI}.
555      */
556     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
557         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
558  
559         string memory baseURI = _baseURI();
560         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
561     }
562  
563     /**
564      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
565      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
566      * by default, can be overriden in child contracts.
567      */
568     function _baseURI() internal view virtual returns (string memory) {
569         return '';
570     }
571  
572     /**
573      * @dev See {IERC721-approve}.
574      */
575     function approve(address to, uint256 tokenId) public override {
576         address owner = ERC721A.ownerOf(tokenId);
577         if (to == owner) revert ApprovalToCurrentOwner();
578  
579         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
580             revert ApprovalCallerNotOwnerNorApproved();
581         }
582  
583         _approve(to, tokenId, owner);
584     }
585  
586     /**
587      * @dev See {IERC721-getApproved}.
588      */
589     function getApproved(uint256 tokenId) public view override returns (address) {
590         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
591  
592         return _tokenApprovals[tokenId];
593     }
594  
595     /**
596      * @dev See {IERC721-setApprovalForAll}.
597      */
598     function setApprovalForAll(address operator, bool approved) public override {
599         if (operator == _msgSender()) revert ApproveToCaller();
600  
601         _operatorApprovals[_msgSender()][operator] = approved;
602         emit ApprovalForAll(_msgSender(), operator, approved);
603     }
604  
605     /**
606      * @dev See {IERC721-isApprovedForAll}.
607      */
608     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
609         return _operatorApprovals[owner][operator];
610     }
611  
612     /**
613      * @dev See {IERC721-transferFrom}.
614      */
615     function transferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) public virtual override {
620         _transfer(from, to, tokenId);
621     }
622  
623     /**
624      * @dev See {IERC721-safeTransferFrom}.
625      */
626     function safeTransferFrom(
627         address from,
628         address to,
629         uint256 tokenId
630     ) public virtual override {
631         safeTransferFrom(from, to, tokenId, '');
632     }
633  
634     /**
635      * @dev See {IERC721-safeTransferFrom}.
636      */
637     function safeTransferFrom(
638         address from,
639         address to,
640         uint256 tokenId,
641         bytes memory _data
642     ) public virtual override {
643         _transfer(from, to, tokenId);
644         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
645             revert TransferToNonERC721ReceiverImplementer();
646         }
647     }
648  
649     /**
650      * @dev Returns whether `tokenId` exists.
651      *
652      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
653      *
654      * Tokens start existing when they are minted (`_mint`),
655      */
656     function _exists(uint256 tokenId) internal view returns (bool) {
657         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
658             !_ownerships[tokenId].burned;
659     }
660  
661     function _safeMint(address to, uint256 quantity) internal {
662         _safeMint(to, quantity, '');
663     }
664  
665     /**
666      * @dev Safely mints `quantity` tokens and transfers them to `to`.
667      *
668      * Requirements:
669      *
670      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
671      * - `quantity` must be greater than 0.
672      *
673      * Emits a {Transfer} event.
674      */
675     function _safeMint(
676         address to,
677         uint256 quantity,
678         bytes memory _data
679     ) internal {
680         _mint(to, quantity, _data, true);
681     }
682  
683     /**
684      * @dev Mints `quantity` tokens and transfers them to `to`.
685      *
686      * Requirements:
687      *
688      * - `to` cannot be the zero address.
689      * - `quantity` must be greater than 0.
690      *
691      * Emits a {Transfer} event.
692      */
693     function _mint(
694         address to,
695         uint256 quantity,
696         bytes memory _data,
697         bool safe
698     ) internal {
699         uint256 startTokenId = _currentIndex;
700         if (to == address(0)) revert MintToZeroAddress();
701         if (quantity == 0) revert MintZeroQuantity();
702  
703         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
704  
705         // Overflows are incredibly unrealistic.
706         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
707         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
708         unchecked {
709             _addressData[to].balance += uint64(quantity);
710             _addressData[to].numberMinted += uint64(quantity);
711  
712             _ownerships[startTokenId].addr = to;
713             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
714  
715             uint256 updatedIndex = startTokenId;
716             uint256 end = updatedIndex + quantity;
717  
718             if (safe && to.isContract()) {
719                 do {
720                     emit Transfer(address(0), to, updatedIndex);
721                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
722                         revert TransferToNonERC721ReceiverImplementer();
723                     }
724                 } while (updatedIndex != end);
725                 // Reentrancy protection
726                 if (_currentIndex != startTokenId) revert();
727             } else {
728                 do {
729                     emit Transfer(address(0), to, updatedIndex++);
730                 } while (updatedIndex != end);
731             }
732             _currentIndex = updatedIndex;
733         }
734         _afterTokenTransfers(address(0), to, startTokenId, quantity);
735     }
736  
737     /**
738      * @dev Transfers `tokenId` from `from` to `to`.
739      *
740      * Requirements:
741      *
742      * - `to` cannot be the zero address.
743      * - `tokenId` token must be owned by `from`.
744      *
745      * Emits a {Transfer} event.
746      */
747     function _transfer(
748         address from,
749         address to,
750         uint256 tokenId
751     ) private {
752         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
753  
754         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
755             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
756             getApproved(tokenId) == _msgSender());
757  
758         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
759         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
760         if (to == address(0)) revert TransferToZeroAddress();
761  
762         _beforeTokenTransfers(from, to, tokenId, 1);
763  
764         // Clear approvals from the previous owner
765         _approve(address(0), tokenId, prevOwnership.addr);
766  
767         // Underflow of the sender's balance is impossible because we check for
768         // ownership above and the recipient's balance can't realistically overflow.
769         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
770         unchecked {
771             _addressData[from].balance -= 1;
772             _addressData[to].balance += 1;
773  
774             _ownerships[tokenId].addr = to;
775             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
776  
777             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
778             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
779             uint256 nextTokenId = tokenId + 1;
780             if (_ownerships[nextTokenId].addr == address(0)) {
781                 // This will suffice for checking _exists(nextTokenId),
782                 // as a burned slot cannot contain the zero address.
783                 if (nextTokenId < _currentIndex) {
784                     _ownerships[nextTokenId].addr = prevOwnership.addr;
785                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
786                 }
787             }
788         }
789  
790         emit Transfer(from, to, tokenId);
791         _afterTokenTransfers(from, to, tokenId, 1);
792     }
793  
794     /**
795      * @dev Destroys `tokenId`.
796      * The approval is cleared when the token is burned.
797      *
798      * Requirements:
799      *
800      * - `tokenId` must exist.
801      *
802      * Emits a {Transfer} event.
803      */
804     function _burn(uint256 tokenId) internal virtual {
805         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
806  
807         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
808  
809         // Clear approvals from the previous owner
810         _approve(address(0), tokenId, prevOwnership.addr);
811  
812         // Underflow of the sender's balance is impossible because we check for
813         // ownership above and the recipient's balance can't realistically overflow.
814         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
815         unchecked {
816             _addressData[prevOwnership.addr].balance -= 1;
817             _addressData[prevOwnership.addr].numberBurned += 1;
818  
819             // Keep track of who burned the token, and the timestamp of burning.
820             _ownerships[tokenId].addr = prevOwnership.addr;
821             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
822             _ownerships[tokenId].burned = true;
823  
824             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
825             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
826             uint256 nextTokenId = tokenId + 1;
827             if (_ownerships[nextTokenId].addr == address(0)) {
828                 // This will suffice for checking _exists(nextTokenId),
829                 // as a burned slot cannot contain the zero address.
830                 if (nextTokenId < _currentIndex) {
831                     _ownerships[nextTokenId].addr = prevOwnership.addr;
832                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
833                 }
834             }
835         }
836  
837         emit Transfer(prevOwnership.addr, address(0), tokenId);
838         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
839  
840         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
841         unchecked {
842             _burnCounter++;
843         }
844     }
845  
846     /**
847      * @dev Approve `to` to operate on `tokenId`
848      *
849      * Emits a {Approval} event.
850      */
851     function _approve(
852         address to,
853         uint256 tokenId,
854         address owner
855     ) private {
856         _tokenApprovals[tokenId] = to;
857         emit Approval(owner, to, tokenId);
858     }
859  
860     /**
861      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
862      *
863      * @param from address representing the previous owner of the given token ID
864      * @param to target address that will receive the tokens
865      * @param tokenId uint256 ID of the token to be transferred
866      * @param _data bytes optional data to send along with the call
867      * @return bool whether the call correctly returned the expected magic value
868      */
869     function _checkContractOnERC721Received(
870         address from,
871         address to,
872         uint256 tokenId,
873         bytes memory _data
874     ) private returns (bool) {
875         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
876             return retval == IERC721Receiver(to).onERC721Received.selector;
877         } catch (bytes memory reason) {
878             if (reason.length == 0) {
879                 revert TransferToNonERC721ReceiverImplementer();
880             } else {
881                 assembly {
882                     revert(add(32, reason), mload(reason))
883                 }
884             }
885         }
886     }
887  
888     /**
889      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
890      * And also called before burning one token.
891      *
892      * startTokenId - the first token id to be transferred
893      * quantity - the amount to be transferred
894      *
895      * Calling conditions:
896      *
897      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
898      * transferred to `to`.
899      * - When `from` is zero, `tokenId` will be minted for `to`.
900      * - When `to` is zero, `tokenId` will be burned by `from`.
901      * - `from` and `to` are never both zero.
902      */
903     function _beforeTokenTransfers(
904         address from,
905         address to,
906         uint256 startTokenId,
907         uint256 quantity
908     ) internal virtual {}
909  
910     /**
911      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
912      * minting.
913      * And also called after one token has been burned.
914      *
915      * startTokenId - the first token id to be transferred
916      * quantity - the amount to be transferred
917      *
918      * Calling conditions:
919      *
920      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
921      * transferred to `to`.
922      * - When `from` is zero, `tokenId` has been minted for `to`.
923      * - When `to` is zero, `tokenId` has been burned by `from`.
924      * - `from` and `to` are never both zero.
925      */
926     function _afterTokenTransfers(
927         address from,
928         address to,
929         uint256 startTokenId,
930         uint256 quantity
931     ) internal virtual {}
932 }
933  
934  
935 error ReserveEmpty();
936 error AllReadyClaimed();
937 error AllBagFull();
938 error LowReserveLeft();
939  
940 contract FloatiesNft is ERC721A, Ownable, ReentrancyGuard {
941  
942     using Strings for uint256;
943  
944     bytes32 public merkleRoot;
945  
946     string public uriPrefix = "";
947     string public uriSuffix = ".json";
948  
949     uint256 public cost = 0.005 ether;
950  
951     uint256 public maxSupply = 3333;  
952  
953     uint public maxMintAmountPerTx;
954     uint public walletLimit;
955  
956     bool public whitelistMintEnabled = false;
957     bool public publicMintEnabled = false;
958  
959     mapping (address => bool) public WhitelistClaimed;
960     mapping (address => uint256) public NftBag;
961  
962     constructor(uint _MaxTx, uint _MaxWallet) ERC721A("Floaties", "FLOAT") {
963         setMaxTxLimit(_MaxTx);
964         setMaxWalletLimit(_MaxWallet);
965     }
966  
967     modifier mintCompliance(uint256 _mintAmount) {
968         require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
969         _;
970     }
971  
972     modifier mintPriceCompliance(uint256 _mintAmount) {
973         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
974         _;
975     }
976  
977     function whitelistMint(bytes32[] calldata _merkleProof) public mintCompliance(1) {
978         require(whitelistMintEnabled,"Whitelist Mint Paused!!");
979         require(tx.origin == msg.sender,"Error: Invalid Caller!");
980         address account = msg.sender;
981         if(WhitelistClaimed[account]) {
982             revert AllReadyClaimed();
983         }
984         bytes32 leaf = keccak256(abi.encodePacked(account));
985         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof!");
986         _safeMint(account, 1);
987         WhitelistClaimed[account] = true;
988     }
989  
990     function publicMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
991         require(publicMintEnabled,"Public Mint Paused!!");
992         require(tx.origin == msg.sender,"Error: Invalid Caller!");
993         require(_mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
994         address account = msg.sender;
995         if(NftBag[account] + _mintAmount > walletLimit) {
996             revert AllBagFull();
997         }
998         _safeMint(account, _mintAmount);
999         NftBag[account] += _mintAmount;
1000     }
1001  
1002  
1003     /* ========================  Owner Minter ========================= */
1004  
1005     function mintTeam(address _adr, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1006         _safeMint(_adr, _mintAmount);
1007     }
1008  
1009     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1010         uint256 ownerTokenCount = balanceOf(_owner);
1011         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1012         uint256 currentTokenId = _startTokenId();
1013         uint256 ownedTokenIndex = 0;
1014         address latestOwnerAddress;
1015  
1016         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1017             TokenOwnership memory ownership = _ownerships[currentTokenId];
1018  
1019             if (!ownership.burned && ownership.addr != address(0)) {
1020                 latestOwnerAddress = ownership.addr;
1021             }
1022  
1023             if (latestOwnerAddress == _owner) {
1024                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1025  
1026                 ownedTokenIndex++;
1027             }
1028  
1029             currentTokenId++;
1030         }
1031  
1032         return ownedTokenIds;
1033     }
1034  
1035     function _startTokenId() internal view virtual override returns (uint256) {
1036         return 1;
1037     }
1038  
1039     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1040         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1041  
1042         string memory currentBaseURI = _baseURI();
1043         return bytes(currentBaseURI).length > 0
1044             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1045             : '';
1046     }
1047  
1048     function enableDisableWhitelistMint(bool _status) public onlyOwner {
1049         whitelistMintEnabled = _status;
1050     }
1051  
1052     function enableDisablePublicMint(bool _status) public onlyOwner {
1053         publicMintEnabled = _status;
1054     }
1055  
1056     function setCost(uint256 _cost) public onlyOwner {
1057         cost = _cost;
1058     }
1059  
1060     function setMaxTxLimit(uint _value) public onlyOwner {
1061         maxMintAmountPerTx = _value;
1062     }
1063  
1064     function setMaxWalletLimit(uint _value) public onlyOwner {
1065         walletLimit = _value;
1066     }
1067  
1068     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1069         uriPrefix = _uriPrefix;
1070     }
1071  
1072     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1073         uriSuffix = _uriSuffix;
1074     }
1075  
1076     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1077         merkleRoot = _merkleRoot;
1078     }
1079  
1080     function withdraw() public onlyOwner nonReentrant {
1081         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1082         require(os);
1083     }
1084  
1085     function _baseURI() internal view virtual override returns (string memory) {
1086         return uriPrefix;
1087     }
1088  
1089 }