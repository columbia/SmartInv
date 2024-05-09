1 // SPDX-License-Identifier: MIT
2 
3 //  ▄▄▄▄▄▄  ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ 
4 // █      ██       █       █       █       █   █       █       █
5 // █  ▄    █   ▄   █   ▄   █   ▄▄▄▄█   ▄▄▄▄█   █    ▄▄▄█  ▄▄▄▄▄█
6 // █ █ █   █  █ █  █  █ █  █  █  ▄▄█  █  ▄▄█   █   █▄▄▄█ █▄▄▄▄▄ 
7 // █ █▄█   █  █▄█  █  █▄█  █  █ █  █  █ █  █   █    ▄▄▄█▄▄▄▄▄  █
8 // █       █       █       █  █▄▄█ █  █▄▄█ █   █   █▄▄▄ ▄▄▄▄▄█ █
9 // █▄▄▄▄▄▄██▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█▄▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█
10 //
11 //  ▄▄   ▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄▄  ▄▄▄▄▄▄▄    ▄     ▄ ▄▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄ 
12 // █  █▄█  █      █      ██       █  █ █ ▄ █ █   █       █  █ █  █
13 // █       █  ▄   █  ▄    █    ▄▄▄█  █ ██ ██ █   █▄     ▄█  █▄█  █
14 // █       █ █▄█  █ █ █   █   █▄▄▄   █       █   █ █   █ █       █
15 // █       █      █ █▄█   █    ▄▄▄█  █       █   █ █   █ █   ▄   █
16 // █ ██▄██ █  ▄   █       █   █▄▄▄   █   ▄   █   █ █   █ █  █ █  █
17 // █▄█   █▄█▄█ █▄▄█▄▄▄▄▄▄██▄▄▄▄▄▄▄█  █▄▄█ █▄▄█▄▄▄█ █▄▄▄█ █▄▄█ █▄▄█
18 //
19 //  ▄▄▄     ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄▄▄▄▄ 
20 // █   █   █       █  █ █  █       █
21 // █   █   █   ▄   █  █▄█  █    ▄▄▄█
22 // █   █   █  █ █  █       █   █▄▄▄ 
23 // █   █▄▄▄█  █▄█  █       █    ▄▄▄█
24 // █       █       ██     ██   █▄▄▄ 
25 // █▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█ █▄▄▄█ █▄▄▄▄▄▄▄█
26 //
27 
28 pragma solidity 0.8.10;
29 
30 interface IERC165 {
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 abstract contract ReentrancyGuard {
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor() {
41         _status = _NOT_ENTERED;
42     }
43 
44     modifier nonReentrant() {
45         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
46         // Any calls to nonReentrant after this point will fail
47         _status = _ENTERED;
48         _;
49         _status = _NOT_ENTERED;
50     }
51 }
52 
53 interface IERC721 is IERC165 {
54     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
55     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57     function balanceOf(address owner) external view returns (uint256 balance);
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59     function safeTransferFrom(
60         address from,
61         address to,
62         uint256 tokenId,
63         bytes calldata data
64     ) external;
65     function safeTransferFrom(
66         address from,
67         address to,
68         uint256 tokenId
69     ) external;
70     function transferFrom(
71         address from,
72         address to,
73         uint256 tokenId
74     ) external;
75     function approve(address to, uint256 tokenId) external;
76     function setApprovalForAll(address operator, bool _approved) external;
77     function getApproved(uint256 tokenId) external view returns (address operator);
78     function isApprovedForAll(address owner, address operator) external view returns (bool);
79 }
80 
81 interface IERC1155Receiver is IERC165 {
82     function onERC1155Received(
83         address operator,
84         address from,
85         uint256 id,
86         uint256 value,
87         bytes calldata data
88     ) external returns (bytes4);
89 
90     function onERC1155BatchReceived(
91         address operator,
92         address from,
93         uint256[] calldata ids,
94         uint256[] calldata values,
95         bytes calldata data
96     ) external returns (bytes4);
97 }
98 
99 interface IERC721Receiver {
100     function onERC721Received(
101         address operator,
102         address from,
103         uint256 tokenId,
104         bytes calldata data
105     ) external returns (bytes4);
106 }
107 
108 interface IERC20 {
109     function totalSupply() external view returns (uint256);
110     function balanceOf(address account) external view returns (uint256);
111     function transfer(address recipient, uint256 amount) external returns (bool);
112     function allowance(address owner, address spender) external view returns (uint256);
113     function approve(address spender, uint256 amount) external returns (bool);
114 
115     function transferFrom(
116         address sender,
117         address recipient,
118         uint256 amount
119     ) external returns (bool);
120 
121     event Transfer(address indexed from, address indexed to, uint256 value);
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 library Address {
126     function isContract(address account) internal view returns (bool) {
127         return account.code.length > 0;
128     }
129 }
130 
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 }
136 
137 abstract contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     constructor() {
143         _transferOwnership(_msgSender());
144     }
145 
146     modifier onlyOwner() {
147         _checkOwner();
148         _;
149     }
150 
151     function owner() public view virtual returns (address) {
152         return _owner;
153     }
154 
155     function _checkOwner() internal view virtual {
156         require(owner() == _msgSender(), "Ownable: caller is not the owner");
157     }
158 
159     function transferOwnership(address newOwner) public virtual onlyOwner {
160         require(newOwner != address(0), "Ownable: new owner is the zero address");
161         _transferOwnership(newOwner);
162     }
163 
164     function _transferOwnership(address newOwner) internal virtual {
165         address oldOwner = _owner;
166         _owner = newOwner;
167         emit OwnershipTransferred(oldOwner, newOwner);
168     }
169 }
170 
171 interface IERC1155 is IERC165 {
172     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
173     event TransferBatch(
174         address indexed operator,
175         address indexed from,
176         address indexed to,
177         uint256[] ids,
178         uint256[] values
179     );
180     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
181     event URI(string value, uint256 indexed id);
182     function balanceOf(address account, uint256 id) external view returns (uint256);
183     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
184         external
185         view
186         returns (uint256[] memory);
187     function setApprovalForAll(address operator, bool approved) external;
188     function isApprovedForAll(address account, address operator) external view returns (bool);
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 id,
193         uint256 amount,
194         bytes calldata data
195     ) external;
196     function safeBatchTransferFrom(
197         address from,
198         address to,
199         uint256[] calldata ids,
200         uint256[] calldata amounts,
201         bytes calldata data
202     ) external;
203 }
204 
205 library Strings {
206     function toString(uint256 value) internal pure returns (string memory) {
207         // Inspired by OraclizeAPI's implementation - MIT licence
208         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
209 
210         if (value == 0) {
211             return "0";
212         }
213         uint256 temp = value;
214         uint256 digits;
215         while (temp != 0) {
216             digits++;
217             temp /= 10;
218         }
219         bytes memory buffer = new bytes(digits);
220         while (value != 0) {
221             digits -= 1;
222             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
223             value /= 10;
224         }
225         return string(buffer);
226     }
227 }
228 
229 interface IERC721Metadata is IERC721 {
230     function name() external view returns (string memory);
231     function symbol() external view returns (string memory);
232     function tokenURI(uint256 tokenId) external view returns (string memory);
233 }
234 
235 abstract contract ERC165 is IERC165 {
236     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
237         return interfaceId == type(IERC165).interfaceId;
238     }
239 }
240 
241 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
242     using Address for address;
243     using Strings for uint256;
244     IERC1155 internal dooggies;
245     bool internal _isMintedOut = false;
246 
247     string private _name;
248 
249     string private _symbol;
250 
251     mapping(uint256 => address) internal _owners;
252     mapping(address => uint256) internal _balances;
253     mapping(uint => uint) internal idStakeLockTimes;
254     mapping(uint => bool) internal OGDooggiesMintedNewNew;
255     mapping(uint256 => address) private _tokenApprovals;
256     mapping(address => mapping(address => bool)) private _operatorApprovals;
257 
258     constructor(string memory name_, string memory symbol_, address dooggiesContract) {
259         _name = name_;
260         _symbol = symbol_;
261         dooggies = IERC1155(dooggiesContract);
262     }
263 
264     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
265         return
266             interfaceId == type(IERC721).interfaceId ||
267             interfaceId == type(IERC721Metadata).interfaceId ||
268             super.supportsInterface(interfaceId);
269     }
270 
271     function balanceOf(address owner) external view virtual override returns (uint256) {
272         require(owner != address(0), "ERC721: address zero is not a valid owner");
273         return _balances[owner];
274     }
275 
276     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
277         address owner = _owners[tokenId];
278         require(owner != address(0), "ERC721: owner query for nonexistent token");
279         if(_isMintedOut == false && idStakeLockTimes[tokenId] != 0 && OGDooggiesMintedNewNew[tokenId] == false) {
280             return address(this);
281         }
282         return owner;
283     }
284 
285     function name() external view virtual override returns (string memory) {
286         return _name;
287     }
288 
289     function symbol() external view virtual override returns (string memory) {
290         return _symbol;
291     }
292 
293     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
294         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
295 
296         string memory baseURI = _baseURI();
297         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
298     }
299 
300     function _baseURI() internal view virtual returns (string memory) {
301         return "";
302     }
303 
304     function approve(address to, uint256 tokenId) external virtual override {
305         address owner = ERC721.ownerOf(tokenId);
306         require(to != owner, "ERC721: approval to current owner");
307 
308         require(
309             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
310             "ERC721: approve caller is not owner nor approved for all"
311         );
312 
313         _approve(to, tokenId);
314     }
315 
316     function getApproved(uint256 tokenId) public view virtual override returns (address) {
317         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
318 
319         return _tokenApprovals[tokenId];
320     }
321 
322     function setApprovalForAll(address operator, bool approved) external virtual override {
323         _setApprovalForAll(_msgSender(), operator, approved);
324     }
325 
326     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
327         return _operatorApprovals[owner][operator];
328     }
329 
330     function transferFrom(
331         address from,
332         address to,
333         uint256 tokenId
334     ) external virtual override {
335         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
336         _transfer(from, to, tokenId);
337     }
338 
339     function safeTransferFrom(
340         address from,
341         address to,
342         uint256 tokenId
343     ) public virtual override {
344         safeTransferFrom(from, to, tokenId, "");
345     }
346 
347     function safeTransferFrom(
348         address from,
349         address to,
350         uint256 tokenId,
351         bytes memory _data
352     ) public virtual override {
353         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
354         _safeTransfer(from, to, tokenId, _data);
355     }
356 
357     function _safeTransfer(
358         address from,
359         address to,
360         uint256 tokenId,
361         bytes memory _data
362     ) internal virtual {
363         _transfer(from, to, tokenId);
364         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
365     }
366 
367     function _exists(uint256 tokenId) internal view virtual returns (bool) {
368         return _owners[tokenId] != address(0);
369     }
370 
371     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
372         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
373         address owner = ERC721.ownerOf(tokenId);
374         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender || owner == address(this));
375     }
376 
377     function _transfer(
378         address from,
379         address to,
380         uint256 tokenId
381     ) internal virtual {
382         if(_isMintedOut == false) {
383             require(idStakeLockTimes[tokenId] == 0 || OGDooggiesMintedNewNew[tokenId], "NFT Cant currently be sent cause its staked");
384         }
385         require(ERC721.ownerOf(tokenId) == from || from == address(this), "ERC721: transfer from incorrect owner");
386         require(to != address(0), "ERC721: transfer to the zero address");
387 
388         // Clear approvals from the previous owner
389         _approve(address(0), tokenId);
390 
391         _balances[from] -= 1;
392         _balances[to] += 1;
393         _owners[tokenId] = to;
394 
395         emit Transfer(from, to, tokenId);
396     }
397 
398     function _approve(address to, uint256 tokenId) internal virtual {
399         _tokenApprovals[tokenId] = to;
400         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
401     }
402 
403     function _setApprovalForAll(
404         address owner,
405         address operator,
406         bool approved
407     ) internal virtual {
408         require(owner != operator, "ERC721: approve to caller");
409         _operatorApprovals[owner][operator] = approved;
410         emit ApprovalForAll(owner, operator, approved);
411     }
412 
413     function _checkOnERC721Received(
414         address from,
415         address to,
416         uint256 tokenId,
417         bytes memory _data
418     ) private returns (bool) {
419         if (to.isContract()) {
420             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
421                 return retval == IERC721Receiver.onERC721Received.selector;
422             } catch (bytes memory reason) {
423                 if (reason.length == 0) {
424                     revert("ERC721: transfer to non ERC721Receiver implementer");
425                 } else {
426                     assembly {
427                         revert(add(32, reason), mload(reason))
428                     }
429                 }
430             }
431         } else {
432             return true;
433         }
434     }
435 }
436 
437 error ApprovalCallerNotOwnerNorApproved();
438 error ApprovalQueryForNonexistentToken();
439 error ApproveToCaller();
440 error ApprovalToCurrentOwner();
441 error BalanceQueryForZeroAddress();
442 error MintToZeroAddress();
443 error MintZeroQuantity();
444 error OwnerQueryForNonexistentToken();
445 error TransferCallerNotOwnerNorApproved();
446 error TransferFromIncorrectOwner();
447 error TransferToNonERC721ReceiverImplementer();
448 error TransferToZeroAddress();
449 error URIQueryForNonexistentToken();
450 
451 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
452     using Address for address;
453     using Strings for uint256;
454 
455     // Compiler will pack this into a single 256bit word.
456     struct TokenOwnership {
457         // The address of the owner.
458         address addr;
459         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
460         uint64 startTimestamp;
461     }
462 
463     // Compiler will pack this into a single 256bit word.
464     struct AddressData {
465         // Realistically, 2**64-1 is more than enough.
466         uint64 balance;
467         // Keeps track of mint count with minimal overhead for tokenomics.
468         uint64 numberMinted;
469     }
470 
471     uint256 internal _currentIndex;
472     string private _name;
473     string private _symbol;
474 
475     // Mapping from token ID to ownership details
476     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
477     mapping(uint256 => TokenOwnership) internal _ownerships;
478 
479     // Mapping owner address to address data
480     mapping(address => AddressData) private _addressData;
481 
482     // Mapping from token ID to approved address
483     mapping(uint256 => address) private _tokenApprovals;
484 
485     // Mapping from owner to operator approvals
486     mapping(address => mapping(address => bool)) private _operatorApprovals;
487 
488     constructor(string memory name_, string memory symbol_) {
489         _name = name_;
490         _symbol = symbol_;
491         _currentIndex = _startTokenId();
492     }
493 
494     function _startTokenId() internal view virtual returns (uint256) {
495         return 1;
496     }
497 
498     function totalSupply() public view returns (uint256) {
499         // Counter underflow is impossible as _burnCounter cannot be incremented
500         // more than _currentIndex - _startTokenId() times
501         unchecked {
502             return _currentIndex - _startTokenId();
503         }
504     }
505 
506     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
507         return
508             interfaceId == type(IERC721).interfaceId ||
509             interfaceId == type(IERC721Metadata).interfaceId ||
510             super.supportsInterface(interfaceId);
511     }
512 
513     function balanceOf(address owner) external view override returns (uint256) {
514         if (owner == address(0)) revert BalanceQueryForZeroAddress();
515         return uint256(_addressData[owner].balance);
516     }
517 
518     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
519         uint256 curr = tokenId;
520 
521         unchecked {
522             if (_startTokenId() <= curr && curr < _currentIndex) {
523                 TokenOwnership memory ownership = _ownerships[curr];
524                 if (ownership.addr != address(0)) {
525                     return ownership;
526                 }
527                 while (true) {
528                     curr--;
529                     ownership = _ownerships[curr];
530                     if (ownership.addr != address(0)) {
531                             return ownership;
532                     }
533                 }
534             }
535         }
536         revert OwnerQueryForNonexistentToken();
537     }
538 
539     function ownerOf(uint256 tokenId) public view override returns (address) {
540         return _ownershipOf(tokenId).addr;
541     }
542 
543     function name() external view virtual override returns (string memory) {
544         return _name;
545     }
546 
547     function symbol() external view virtual override returns (string memory) {
548         return _symbol;
549     }
550 
551     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
552         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
553 
554         string memory baseURI = _baseURI();
555         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
556     }
557 
558     function _baseURI() internal view virtual returns (string memory) {
559         return '';
560     }
561 
562     function approve(address to, uint256 tokenId) external override {
563         address owner = ERC721A.ownerOf(tokenId);
564         if (to == owner) revert ApprovalToCurrentOwner();
565 
566         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
567             revert ApprovalCallerNotOwnerNorApproved();
568         }
569 
570         _approve(to, tokenId, owner);
571     }
572 
573     function getApproved(uint256 tokenId) public view override returns (address) {
574         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
575 
576         return _tokenApprovals[tokenId];
577     }
578 
579     function setApprovalForAll(address operator, bool approved) external virtual override {
580         if (operator == _msgSender()) revert ApproveToCaller();
581 
582         _operatorApprovals[_msgSender()][operator] = approved;
583         emit ApprovalForAll(_msgSender(), operator, approved);
584     }
585 
586     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
587         return _operatorApprovals[owner][operator];
588     }
589 
590     function transferFrom(
591         address from,
592         address to,
593         uint256 tokenId
594     ) external virtual override {
595         _transfer(from, to, tokenId);
596     }
597 
598     function safeTransferFrom(
599         address from,
600         address to,
601         uint256 tokenId
602     ) public virtual override {
603         safeTransferFrom(from, to, tokenId, '');
604     }
605 
606     function safeTransferFrom(
607         address from,
608         address to,
609         uint256 tokenId,
610         bytes memory _data
611     ) public virtual override {
612         _transfer(from, to, tokenId);
613         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
614             revert TransferToNonERC721ReceiverImplementer();
615         }
616     }
617 
618     function _exists(uint256 tokenId) internal view returns (bool) {
619         return _startTokenId() <= tokenId && tokenId < _currentIndex;
620     }
621 
622     function _safeMint(address to, uint256 quantity) internal {
623         _safeMint(to, quantity, '');
624     }
625 
626     function _safeMint(
627         address to,
628         uint256 quantity,
629         bytes memory _data
630     ) internal {
631         _mint(to, quantity, _data, true);
632     }
633 
634     function _mint(
635         address to,
636         uint256 quantity,
637         bytes memory _data,
638         bool safe
639     ) internal {
640         uint256 startTokenId = _currentIndex;
641         if (to == address(0)) revert MintToZeroAddress();
642         if (quantity == 0) revert MintZeroQuantity();
643 
644         // Overflows are incredibly unrealistic.
645         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
646         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
647         unchecked {
648             _addressData[to].balance += uint64(quantity);
649             _addressData[to].numberMinted += uint64(quantity);
650 
651             _ownerships[startTokenId].addr = to;
652             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
653 
654             uint256 updatedIndex = startTokenId;
655             uint256 end = updatedIndex + quantity;
656 
657             if (safe && to.isContract()) {
658                 do {
659                     emit Transfer(address(0), to, updatedIndex);
660                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
661                         revert TransferToNonERC721ReceiverImplementer();
662                     }
663                 } while (updatedIndex != end);
664                 // Reentrancy protection
665                 if (_currentIndex != startTokenId) revert();
666             } else {
667                 do {
668                     emit Transfer(address(0), to, updatedIndex++);
669                 } while (updatedIndex != end);
670             }
671             _currentIndex = updatedIndex;
672         }
673     }
674 
675     function _transfer(
676         address from,
677         address to,
678         uint256 tokenId
679     ) private {
680         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
681 
682         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
683 
684         bool isApprovedOrOwner = (_msgSender() == from ||
685             isApprovedForAll(from, _msgSender()) ||
686             getApproved(tokenId) == _msgSender());
687 
688         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
689         if (to == address(0)) revert TransferToZeroAddress();
690 
691         // Clear approvals from the previous owner
692         _approve(address(0), tokenId, from);
693 
694         // Underflow of the sender's balance is impossible because we check for
695         // ownership above and the recipient's balance can't realistically overflow.
696         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
697         unchecked {
698             _addressData[from].balance -= 1;
699             _addressData[to].balance += 1;
700 
701             TokenOwnership storage currSlot = _ownerships[tokenId];
702             currSlot.addr = to;
703             currSlot.startTimestamp = uint64(block.timestamp);
704 
705             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
706             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
707             uint256 nextTokenId = tokenId + 1;
708             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
709             if (nextSlot.addr == address(0)) {
710                 // This will suffice for checking _exists(nextTokenId),
711                 // as a burned slot cannot contain the zero address.
712                 if (nextTokenId != _currentIndex) {
713                     nextSlot.addr = from;
714                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
715                 }
716             }
717         }
718 
719         emit Transfer(from, to, tokenId);
720     }
721 
722     function _approve(
723         address to,
724         uint256 tokenId,
725         address owner
726     ) private {
727         _tokenApprovals[tokenId] = to;
728         emit Approval(owner, to, tokenId);
729     }
730 
731     function _checkContractOnERC721Received(
732         address from,
733         address to,
734         uint256 tokenId,
735         bytes memory _data
736     ) private returns (bool) {
737         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
738             return retval == IERC721Receiver(to).onERC721Received.selector;
739         } catch (bytes memory reason) {
740             if (reason.length == 0) {
741                 revert TransferToNonERC721ReceiverImplementer();
742             } else {
743                 assembly {
744                     revert(add(32, reason), mload(reason))
745                 }
746             }
747         }
748     }
749 }
750 
751 contract DooggiesSnack is ERC721A, Ownable {
752     address private devOwner;
753     address private whoCanMint;
754     bool internal _revealed = false;
755     bool internal mintEnabled = true;
756 
757     string private baseURIForNewNew = "ipfs://QmUtKHbiThL5FikUuUgvLrH7HdNzQ9KmfUtDsE6o3hUKTp";
758     string private baseExt = "";
759 
760     constructor(address owner_, address whoCanMint_) ERC721A("DooggiesSnack", "DooggiesSnack") { // not the real name ;)
761         devOwner = owner_;
762         whoCanMint = whoCanMint_;
763     }
764 
765     receive() external payable {
766         (bool sent, ) = payable(owner()).call{value: msg.value}("");
767         require(sent, "Failed to send Ether");
768     }
769 
770     function mint(uint256 numberOfTokens, address user) external {
771         require(mintEnabled, "Cant mint yet");
772         require(whoCanMint == msg.sender, "You cant mint");
773         require(
774             numberOfTokens + totalSupply() <= 5000,
775             "Not enough supply"
776         );
777         _safeMint(user, numberOfTokens);
778     }
779 
780     function reveal(bool revealed, string calldata _baseURI) external {
781         require(msg.sender == devOwner, "You are not the owner");
782         _revealed = revealed;
783         baseURIForNewNew = _baseURI;
784     }
785 
786     function setExtension(string calldata _baseExt) external {
787         require(msg.sender == devOwner, "You are not the owner");
788         baseExt = _baseExt;
789     }
790 
791     function updateOwner(address owner_) external {
792         require(msg.sender == devOwner, "You are not the owner");
793         require(owner_ != address(0));
794         devOwner = owner_;
795     }
796 
797     function toggleMint() external {
798         require(msg.sender == devOwner, "You are not the owner");
799         mintEnabled = !mintEnabled;
800     }
801 
802     function isMintEnabled() external view returns (bool) {
803         return mintEnabled;
804     }
805 
806     function tokenURI(uint256 tokenId)
807         external
808         view
809         virtual
810         override
811         returns (string memory)
812     {
813         if (_revealed) {
814             return string(abi.encodePacked(baseURIForNewNew, Strings.toString(tokenId), baseExt));
815         } else {
816             return string(abi.encodePacked(baseURIForNewNew));
817         }
818     }
819 }
820 
821 contract WrapYourDooggies is ERC721, ReentrancyGuard, IERC721Receiver, IERC1155Receiver, Ownable {
822     address private devOwner;
823     bool private lockMintForever = false;
824     uint private totalAmount = 0;
825 
826     uint constant private dayCount = 60 days;
827     uint constant private mintOutLock = 365 days;
828     uint private whenDidWeDeploy;
829 
830     string private baseURIForOGDooggies = "ipfs://QmSRPvb4E4oT8J73QoWGyvdFizWzpMkkSozAnCEMjT5K7G/";
831     string private baseExt = "";
832 
833     DooggiesSnack dooggiesSnack; // Hmm you curious what this could be if youre a reader of the github???
834 
835     constructor(address dooggiesContract) ERC721("Dooggies", "Dooggies", dooggiesContract) {
836         devOwner = address(0xf8c45B2375a574BecA18224C47353969C044a9EC);
837         dooggiesSnack = new DooggiesSnack(devOwner, address(this));
838         whenDidWeDeploy = block.timestamp;
839     }
840 
841     receive() external payable {
842         (bool sent, ) = payable(owner()).call{value: msg.value}("");
843         require(sent, "Failed to send Ether");
844     }
845 
846     function wrapMany(uint[] calldata tokenIds) nonReentrant external {
847         require(
848             dooggies.isApprovedForAll(msg.sender, address(this)),
849             "You need approval"
850         );
851         require(tokenIds.length > 0, "Must have something");
852 
853         unchecked {
854             uint count = tokenIds.length;
855             uint[] memory qty = new uint[](count);
856             for(uint i = 0; i < count; i++) {
857                 qty[i] = 1;
858             }
859 
860             dooggies.safeBatchTransferFrom(msg.sender, address(this), tokenIds, qty, "");
861 
862             for(uint i = 0; i < count; i++) {
863                 require(address(this) == ownerOf(tokenIds[i]), "Bruh.. we dont own that");
864                 safeTransferFrom(address(this), msg.sender, tokenIds[i]);
865             }
866         }
867     }
868 
869     function unwrapMany(uint[] calldata tokenIds) nonReentrant external {
870         require(tokenIds.length > 0, "Must have something");
871         unchecked {
872             uint count = tokenIds.length;
873             uint[] memory qty = new uint[](count);
874             for(uint i = 0; i < count; i++) {
875                 require(msg.sender == ownerOf(tokenIds[i]), "Bruh.. you dont own that");
876                 safeTransferFrom(msg.sender, address(this), tokenIds[i]);
877             }
878 
879             for(uint i = 0; i < count; i++) {
880                 qty[i] = 1;
881             }
882 
883             dooggies.safeBatchTransferFrom(address(this), msg.sender, tokenIds, qty, "");
884         }
885     }
886 
887     function wrapManyAndStake(uint[] calldata tokenIds) nonReentrant external {
888         require(
889             dooggies.isApprovedForAll(msg.sender, address(this)),
890             "You need approval"
891         );
892         require(tokenIds.length > 0, "Must have something");
893         require(_isMintedOut == false, "Already minted out");
894 
895         unchecked {
896             uint count = tokenIds.length;
897             uint[] memory qty = new uint[](count);
898             for(uint i = 0; i < count; i++) {
899                 qty[i] = 1;
900             }
901 
902             dooggies.safeBatchTransferFrom(msg.sender, address(this), tokenIds, qty, "");
903 
904             for(uint i = 0; i < count; i++) {
905                 require(idStakeLockTimes[tokenIds[i]] == 0, "This is already staked");
906                 require(address(this) == ownerOf(tokenIds[i]), "Bruh.. we dont own that");
907                 require(OGDooggiesMintedNewNew[tokenIds[i]] == false, "Bruh.. this NFT can only stake once");
908                 _owners[tokenIds[i]] = msg.sender;
909                 idStakeLockTimes[tokenIds[i]] = block.timestamp;
910                 // lol so it shows up on Opensea xD
911                 // since we want to funnel people here on first wrap :)
912                 // This will put it in the users wallet on opensea but not allow
913                 // them to sell since they dont own the asset
914                 emit Transfer(msg.sender, address(this), tokenIds[i]);
915             }
916         }
917     }
918 
919     function stakeMany(uint[] calldata tokenIds) nonReentrant external {
920         require(tokenIds.length > 0, "Must have something");
921         require(_isMintedOut == false, "Already minted out");
922         unchecked {
923             uint count = tokenIds.length;
924             for(uint i = 0; i < count; i++) {
925                 require(msg.sender == ownerOf(tokenIds[i]), "Bruh.. you dont own that");
926                 safeTransferFrom(msg.sender, address(this), tokenIds[i]);
927             }
928 
929             for(uint i = 0; i < count; i++) {
930                 require(idStakeLockTimes[tokenIds[i]] == 0, "This is already staked");
931                 require(address(this) == ownerOf(tokenIds[i]), "Bruh.. we dont own that");
932                 require(OGDooggiesMintedNewNew[tokenIds[i]] == false, "Bruh.. this NFT can only stake once");
933                 _owners[tokenIds[i]] = msg.sender;
934                 idStakeLockTimes[tokenIds[i]] = block.timestamp;
935             }
936         }
937     }
938 
939     function unStakeMany(uint[] calldata tokenIds) nonReentrant external {
940         require(tokenIds.length > 0, "Must have something");
941         unchecked {
942             uint count = tokenIds.length;
943 
944             for(uint i = 0; i < count; i++) {
945                 require(msg.sender == _owners[tokenIds[i]], "Bruh.. you dont own that");
946                 require(OGDooggiesMintedNewNew[tokenIds[i]] == false, "Bruh.. this NFT can only stake once");
947                 require(idStakeLockTimes[tokenIds[i]] != 0, "Bruh.. this is not staked");
948                 idStakeLockTimes[tokenIds[i]] = 0;
949                 safeTransferFrom(address(this), msg.sender, tokenIds[i]);
950             }
951         }
952     }
953 
954     function zMintNewNew(uint[] calldata tokenIds) nonReentrant external {
955         require(_isMintedOut == false, "Already minted out");
956         unchecked {
957             uint count = tokenIds.length;
958             require(count >= 2, "You need at least two dooggies to mint");
959 
960             uint amountToMint = 0;
961             uint8 localCounter = 0;
962             for(uint i = 0; i < count; i++) {
963                 require(OGDooggiesMintedNewNew[tokenIds[i]] == false, "Bruh.. this NFT can only mint once.");
964                 require(msg.sender == _owners[tokenIds[i]], "Bruh.. you dont own that");
965                 if(block.timestamp - idStakeLockTimes[tokenIds[i]] >= dayCount) {
966                     OGDooggiesMintedNewNew[tokenIds[i]] = true;
967                     localCounter += 1;
968                     if(localCounter >= 2) {
969                         localCounter = 0;
970                         amountToMint += 1;
971                     }
972                     safeTransferFrom(address(this), msg.sender, tokenIds[i]);
973                 }
974             }
975             require(amountToMint > 0, "Need to have some to mint");
976 
977             dooggiesSnack.mint(amountToMint, msg.sender);
978         }
979     }
980 
981     function zzMintOutMystery(uint amount) external {
982         require(msg.sender == devOwner, "You are not the owner");
983         
984         // give people time to wrap for the mystery mint. 
985         // they will always be able to wrap but not be able to mint out
986         require(block.timestamp - whenDidWeDeploy >= mintOutLock);
987         
988         dooggiesSnack.mint(amount, msg.sender);
989 
990         if(dooggiesSnack.totalSupply() > 4999) {
991             _isMintedOut = true;
992         }
993     }
994 
995     function zzLockMint() external {
996         require(msg.sender == devOwner, "You are not the owner");
997         require(lockMintForever == false, "Mint is already locked");
998         lockMintForever = true;
999     }
1000 
1001     function zzinitialise(uint256[] calldata tokenIds) external {
1002         require(lockMintForever == false, "You can no longer mint");
1003         require(msg.sender == devOwner, "You are not the owner");
1004 
1005         uint count = tokenIds.length;
1006         require(count > 0, "Must have something");
1007         _balances[address(this)] += count;
1008 
1009         emit Transfer(address(this), address(this), tokenIds[0]);
1010 
1011         unchecked {
1012             totalAmount += count;
1013         }
1014 
1015         // update the balances so that on wrapping the contract logic works
1016         for (uint256 i = 0; i < count; i++) {
1017             require(_owners[tokenIds[i]] == address(0), "You cant mint twice");
1018             _owners[tokenIds[i]] = address(this);
1019         }
1020     }
1021 
1022     function updateOwner(address owner_) external {
1023         require(msg.sender == devOwner, "You are not the owner");
1024         require(owner_ != address(0));
1025         devOwner = owner_;
1026     }
1027 
1028     function setExtension(string calldata _baseExt) external {
1029         require(msg.sender == devOwner, "You are not the owner");
1030         baseExt = _baseExt;
1031     }
1032 
1033     function onERC721Received(address, address, uint256, bytes calldata) pure external returns(bytes4) {
1034         return WrapYourDooggies.onERC721Received.selector;
1035     }
1036 
1037     function onERC1155Received(
1038         address,
1039         address,
1040         uint256,
1041         uint256,
1042         bytes calldata
1043     ) pure external returns (bytes4) {
1044         return WrapYourDooggies.onERC1155Received.selector;
1045     }
1046 
1047     function onERC1155BatchReceived(
1048         address,
1049         address,
1050         uint256[] calldata,
1051         uint256[] calldata,
1052         bytes calldata
1053     ) pure external returns (bytes4) {
1054         return WrapYourDooggies.onERC1155BatchReceived.selector;
1055     }
1056 
1057     function tokenURI(uint256 tokenId)
1058         external
1059         view
1060         virtual
1061         override
1062         returns (string memory)
1063     {
1064         return string(abi.encodePacked(baseURIForOGDooggies, Strings.toString(tokenId), baseExt)); 
1065     }
1066 
1067     function setURIOG(string calldata _baseURI) external {
1068         require(msg.sender == devOwner, "Step off brah");
1069         baseURIForOGDooggies = _baseURI;
1070     }
1071 
1072     function totalSupply() external view returns (uint256) {
1073         return totalAmount;
1074     }
1075 
1076     function newnewAddress() external view returns (address) {
1077         return address(dooggiesSnack);
1078     }
1079 
1080     function timeLeftForID(uint tokenID) external view returns (uint) {
1081         if((block.timestamp - idStakeLockTimes[tokenID]) < dayCount) {
1082             return dayCount - (block.timestamp - idStakeLockTimes[tokenID]);
1083         } else {
1084             return 0;
1085         }
1086     }
1087 
1088     function hasIDBeenMinted(uint tokenID) external view returns (bool) {
1089         return OGDooggiesMintedNewNew[tokenID];
1090     }
1091 
1092     function isStaked(uint tokenID) external view returns (bool) {
1093         return idStakeLockTimes[tokenID] != 0 && OGDooggiesMintedNewNew[tokenID] == false;
1094     }
1095 
1096     function isMintLocked() external view returns (bool) {
1097         return lockMintForever;
1098     }
1099 }