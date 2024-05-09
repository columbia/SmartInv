1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-27
3 */
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
6 
7 // SPDX-License-Identifier: MIT
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 abstract contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(
27         address indexed previousOwner,
28         address indexed newOwner
29     );
30 
31     constructor() {
32         _transferOwnership(_msgSender());
33     }
34 
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     function renounceOwnership() public virtual onlyOwner {
45         _transferOwnership(address(0));
46     }
47 
48     function transferOwnership(address newOwner) public virtual onlyOwner {
49         require(
50             newOwner != address(0),
51             "Ownable: new owner is the zero address"
52         );
53         _transferOwnership(newOwner);
54     }
55 
56     function _transferOwnership(address newOwner) internal virtual {
57         address oldOwner = _owner;
58         _owner = newOwner;
59         emit OwnershipTransferred(oldOwner, newOwner);
60     }
61 }
62 
63 library Strings {
64     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
65 
66     function toString(uint256 value) internal pure returns (string memory) {
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
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
99     function toHexString(uint256 value, uint256 length)
100         internal
101         pure
102         returns (string memory)
103     {
104         bytes memory buffer = new bytes(2 * length + 2);
105         buffer[0] = "0";
106         buffer[1] = "x";
107         for (uint256 i = 2 * length + 1; i > 1; --i) {
108             buffer[i] = _HEX_SYMBOLS[value & 0xf];
109             value >>= 4;
110         }
111         require(value == 0, "Strings: hex length insufficient");
112         return string(buffer);
113     }
114 }
115 
116 interface IERC165 {
117     function supportsInterface(bytes4 interfaceId) external view returns (bool);
118 }
119 
120 interface IERC721 is IERC165 {
121     event Transfer(
122         address indexed from,
123         address indexed to,
124         uint256 indexed tokenId
125     );
126 
127     event Approval(
128         address indexed owner,
129         address indexed approved,
130         uint256 indexed tokenId
131     );
132 
133     event ApprovalForAll(
134         address indexed owner,
135         address indexed operator,
136         bool approved
137     );
138 
139     function balanceOf(address owner) external view returns (uint256 balance);
140 
141     function ownerOf(uint256 tokenId) external view returns (address owner);
142 
143     function safeTransferFrom(
144         address from,
145         address to,
146         uint256 tokenId
147     ) external;
148 
149     function transferFrom(
150         address from,
151         address to,
152         uint256 tokenId
153     ) external;
154 
155     function approve(address to, uint256 tokenId) external;
156 
157     function getApproved(uint256 tokenId)
158         external
159         view
160         returns (address operator);
161 
162     function setApprovalForAll(address operator, bool _approved) external;
163 
164     function isApprovedForAll(address owner, address operator)
165         external
166         view
167         returns (bool);
168 
169     function safeTransferFrom(
170         address from,
171         address to,
172         uint256 tokenId,
173         bytes calldata data
174     ) external;
175 }
176 
177 interface IERC721Receiver {
178     function onERC721Received(
179         address operator,
180         address from,
181         uint256 tokenId,
182         bytes calldata data
183     ) external returns (bytes4);
184 }
185 
186 interface IERC721Metadata is IERC721 {
187     function name() external view returns (string memory);
188 
189     function symbol() external view returns (string memory);
190 
191     function tokenURI(uint256 tokenId) external view returns (string memory);
192 }
193 
194 interface IERC721Enumerable is IERC721 {
195     function totalSupply() external view returns (uint256);
196 
197     function tokenOfOwnerByIndex(address owner, uint256 index)
198         external
199         view
200         returns (uint256 tokenId);
201 
202     function tokenByIndex(uint256 index) external view returns (uint256);
203 }
204 
205 library Address {
206     function isContract(address account) internal view returns (bool) {
207 
208         uint256 size;
209         assembly {
210             size := extcodesize(account)
211         }
212         return size > 0;
213     }
214 
215     function sendValue(address payable recipient, uint256 amount) internal {
216         require(
217             address(this).balance >= amount,
218             "Address: insufficient balance"
219         );
220 
221         (bool success, ) = recipient.call{value: amount}("");
222         require(
223             success,
224             "Address: unable to send value, recipient may have reverted"
225         );
226     }
227 
228     function functionCall(address target, bytes memory data)
229         internal
230         returns (bytes memory)
231     {
232         return functionCall(target, data, "Address: low-level call failed");
233     }
234 
235     function functionCall(
236         address target,
237         bytes memory data,
238         string memory errorMessage
239     ) internal returns (bytes memory) {
240         return functionCallWithValue(target, data, 0, errorMessage);
241     }
242 
243     function functionCallWithValue(
244         address target,
245         bytes memory data,
246         uint256 value
247     ) internal returns (bytes memory) {
248         return
249             functionCallWithValue(
250                 target,
251                 data,
252                 value,
253                 "Address: low-level call with value failed"
254             );
255     }
256 
257     function functionCallWithValue(
258         address target,
259         bytes memory data,
260         uint256 value,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         require(
264             address(this).balance >= value,
265             "Address: insufficient balance for call"
266         );
267         require(isContract(target), "Address: call to non-contract");
268 
269         (bool success, bytes memory returndata) = target.call{value: value}(
270             data
271         );
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     function functionStaticCall(address target, bytes memory data)
276         internal
277         view
278         returns (bytes memory)
279     {
280         return
281             functionStaticCall(
282                 target,
283                 data,
284                 "Address: low-level static call failed"
285             );
286     }
287 
288     function functionStaticCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal view returns (bytes memory) {
293         require(isContract(target), "Address: static call to non-contract");
294 
295         (bool success, bytes memory returndata) = target.staticcall(data);
296         return verifyCallResult(success, returndata, errorMessage);
297     }
298 
299     function functionDelegateCall(address target, bytes memory data)
300         internal
301         returns (bytes memory)
302     {
303         return
304             functionDelegateCall(
305                 target,
306                 data,
307                 "Address: low-level delegate call failed"
308             );
309     }
310 
311     function functionDelegateCall(
312         address target,
313         bytes memory data,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         require(isContract(target), "Address: delegate call to non-contract");
317 
318         (bool success, bytes memory returndata) = target.delegatecall(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     function verifyCallResult(
323         bool success,
324         bytes memory returndata,
325         string memory errorMessage
326     ) internal pure returns (bytes memory) {
327         if (success) {
328             return returndata;
329         } else {
330             if (returndata.length > 0) {
331                 assembly {
332                     let returndata_size := mload(returndata)
333                     revert(add(32, returndata), returndata_size)
334                 }
335             } else {
336                 revert(errorMessage);
337             }
338         }
339     }
340 }
341 
342 abstract contract ERC165 is IERC165 {
343     function supportsInterface(bytes4 interfaceId)
344         public
345         view
346         virtual
347         override
348         returns (bool)
349     {
350         return interfaceId == type(IERC165).interfaceId;
351     }
352 }
353 
354 contract ERC721A is
355     Context,
356     ERC165,
357     IERC721,
358     IERC721Metadata,
359     IERC721Enumerable
360 {
361     using Address for address;
362     using Strings for uint256;
363 
364     struct TokenOwnership {
365         address addr;
366         uint64 startTimestamp;
367     }
368 
369     struct AddressData {
370         uint128 balance;
371         uint128 numberMinted;
372     }
373 
374     uint256 internal currentIndex = 1;
375 
376     string private _name;
377 
378     string private _symbol;
379 
380     mapping(uint256 => TokenOwnership) internal _ownerships;
381 
382     mapping(address => AddressData) private _addressData;
383 
384     mapping(uint256 => address) private _tokenApprovals;
385 
386     mapping(address => mapping(address => bool)) private _operatorApprovals;
387 
388     constructor(string memory name_, string memory symbol_) {
389         _name = name_;
390         _symbol = symbol_;
391     }
392 
393     function totalSupply() public view override returns (uint256) {
394         return currentIndex;
395     }
396 
397     function tokenByIndex(uint256 index)
398         public
399         view
400         override
401         returns (uint256)
402     {
403         require(index < totalSupply(), "ERC721A: global index out of bounds");
404         return index;
405     }
406 
407     function tokenOfOwnerByIndex(address owner, uint256 index)
408         public
409         view
410         override
411         returns (uint256)
412     {
413         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
414         uint256 numMintedSoFar = totalSupply();
415         uint256 tokenIdsIdx = 0;
416         address currOwnershipAddr = address(0);
417         for (uint256 i = 0; i < numMintedSoFar; i++) {
418             TokenOwnership memory ownership = _ownerships[i];
419             if (ownership.addr != address(0)) {
420                 currOwnershipAddr = ownership.addr;
421             }
422             if (currOwnershipAddr == owner) {
423                 if (tokenIdsIdx == index) {
424                     return i;
425                 }
426                 tokenIdsIdx++;
427             }
428         }
429         revert("ERC721A: unable to get token of owner by index");
430     }
431 
432     function supportsInterface(bytes4 interfaceId)
433         public
434         view
435         virtual
436         override(ERC165, IERC165)
437         returns (bool)
438     {
439         return
440             interfaceId == type(IERC721).interfaceId ||
441             interfaceId == type(IERC721Metadata).interfaceId ||
442             interfaceId == type(IERC721Enumerable).interfaceId ||
443             super.supportsInterface(interfaceId);
444     }
445 
446     function balanceOf(address owner) public view override returns (uint256) {
447         require(
448             owner != address(0),
449             "ERC721A: balance query for the zero address"
450         );
451         return uint256(_addressData[owner].balance);
452     }
453 
454     function _numberMinted(address owner) internal view returns (uint256) {
455         require(
456             owner != address(0),
457             "ERC721A: number minted query for the zero address"
458         );
459         return uint256(_addressData[owner].numberMinted);
460     }
461 
462     function ownershipOf(uint256 tokenId)
463         internal
464         view
465         returns (TokenOwnership memory)
466     {
467         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
468 
469         for (uint256 curr = tokenId; ; curr--) {
470             TokenOwnership memory ownership = _ownerships[curr];
471             if (ownership.addr != address(0)) {
472                 return ownership;
473             }
474         }
475 
476         revert("ERC721A: unable to determine the owner of token");
477     }
478 
479     function ownerOf(uint256 tokenId) public view override returns (address) {
480         return ownershipOf(tokenId).addr;
481     }
482 
483     function name() public view virtual override returns (string memory) {
484         return _name;
485     }
486 
487     function symbol() public view virtual override returns (string memory) {
488         return _symbol;
489     }
490 
491     function tokenURI(uint256 tokenId)
492         public
493         view
494         virtual
495         override
496         returns (string memory)
497     {
498         require(
499             _exists(tokenId),
500             "ERC721Metadata: URI query for nonexistent token"
501         );
502 
503         string memory baseURI = _baseURI();
504         return
505             bytes(baseURI).length > 0
506                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
507                 : "";
508     }
509 
510     function _baseURI() internal view virtual returns (string memory) {
511         return "";
512     }
513 
514     function approve(address to, uint256 tokenId) public override {
515         address owner = ERC721A.ownerOf(tokenId);
516         require(to != owner, "ERC721A: approval to current owner");
517 
518         require(
519             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
520             "ERC721A: approve caller is not owner nor approved for all"
521         );
522 
523         _approve(to, tokenId, owner);
524     }
525 
526     function getApproved(uint256 tokenId)
527         public
528         view
529         override
530         returns (address)
531     {
532         require(
533             _exists(tokenId),
534             "ERC721A: approved query for nonexistent token"
535         );
536 
537         return _tokenApprovals[tokenId];
538     }
539 
540     function setApprovalForAll(address operator, bool approved)
541         public
542         override
543     {
544         require(operator != _msgSender(), "ERC721A: approve to caller");
545 
546         _operatorApprovals[_msgSender()][operator] = approved;
547         emit ApprovalForAll(_msgSender(), operator, approved);
548     }
549 
550     function isApprovedForAll(address owner, address operator)
551         public
552         view
553         virtual
554         override
555         returns (bool)
556     {
557         return _operatorApprovals[owner][operator];
558     }
559 
560     function transferFrom(
561         address from,
562         address to,
563         uint256 tokenId
564     ) public override {
565         _transfer(from, to, tokenId);
566     }
567 
568     function safeTransferFrom(
569         address from,
570         address to,
571         uint256 tokenId
572     ) public override {
573         safeTransferFrom(from, to, tokenId, "");
574     }
575 
576     function safeTransferFrom(
577         address from,
578         address to,
579         uint256 tokenId,
580         bytes memory _data
581     ) public override {
582         _transfer(from, to, tokenId);
583         require(
584             _checkOnERC721Received(from, to, tokenId, _data),
585             "ERC721A: transfer to non ERC721Receiver implementer"
586         );
587     }
588 
589     function _exists(uint256 tokenId) internal view returns (bool) {
590         return tokenId < currentIndex;
591     }
592 
593     function _safeMint(address to, uint256 quantity) internal {
594         _safeMint(to, quantity, "");
595     }
596 
597     function _safeMint(
598         address to,
599         uint256 quantity,
600         bytes memory _data
601     ) internal {
602         uint256 startTokenId = currentIndex;
603         require(to != address(0), "ERC721A: mint to the zero address");
604         require(!_exists(startTokenId), "ERC721A: token already minted");
605         require(quantity > 0, "ERC721A: quantity must be greater 0");
606 
607         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
608 
609         AddressData memory addressData = _addressData[to];
610         _addressData[to] = AddressData(
611             addressData.balance + uint128(quantity),
612             addressData.numberMinted + uint128(quantity)
613         );
614         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
615 
616         uint256 updatedIndex = startTokenId;
617 
618         for (uint256 i = 0; i < quantity; i++) {
619             emit Transfer(address(0), to, updatedIndex);
620             require(
621                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
622                 "ERC721A: transfer to non ERC721Receiver implementer"
623             );
624             updatedIndex++;
625         }
626 
627         currentIndex = updatedIndex;
628         _afterTokenTransfers(address(0), to, startTokenId, quantity);
629     }
630 
631     function _transfer(
632         address from,
633         address to,
634         uint256 tokenId
635     ) private {
636         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
637 
638         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
639             getApproved(tokenId) == _msgSender() ||
640             isApprovedForAll(prevOwnership.addr, _msgSender()));
641 
642         require(
643             isApprovedOrOwner,
644             "ERC721A: transfer caller is not owner nor approved"
645         );
646 
647         require(
648             prevOwnership.addr == from,
649             "ERC721A: transfer from incorrect owner"
650         );
651         require(to != address(0), "ERC721A: transfer to the zero address");
652 
653         _beforeTokenTransfers(from, to, tokenId, 1);
654 
655         _approve(address(0), tokenId, prevOwnership.addr);
656 
657         unchecked {
658             _addressData[from].balance -= 1;
659             _addressData[to].balance += 1;
660         }
661 
662         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
663 
664         uint256 nextTokenId = tokenId + 1;
665         if (_ownerships[nextTokenId].addr == address(0)) {
666             if (_exists(nextTokenId)) {
667                 _ownerships[nextTokenId] = TokenOwnership(
668                     prevOwnership.addr,
669                     prevOwnership.startTimestamp
670                 );
671             }
672         }
673 
674         emit Transfer(from, to, tokenId);
675         _afterTokenTransfers(from, to, tokenId, 1);
676     }
677 
678     /**
679      * @dev Approve `to` to operate on `tokenId`
680      *
681      * Emits a {Approval} event.
682      */
683     function _approve(
684         address to,
685         uint256 tokenId,
686         address owner
687     ) private {
688         _tokenApprovals[tokenId] = to;
689         emit Approval(owner, to, tokenId);
690     }
691 
692     function _checkOnERC721Received(
693         address from,
694         address to,
695         uint256 tokenId,
696         bytes memory _data
697     ) private returns (bool) {
698         if (to.isContract()) {
699             try
700                 IERC721Receiver(to).onERC721Received(
701                     _msgSender(),
702                     from,
703                     tokenId,
704                     _data
705                 )
706             returns (bytes4 retval) {
707                 return retval == IERC721Receiver(to).onERC721Received.selector;
708             } catch (bytes memory reason) {
709                 if (reason.length == 0) {
710                     revert(
711                         "ERC721A: transfer to non ERC721Receiver implementer"
712                     );
713                 } else {
714                     assembly {
715                         revert(add(32, reason), mload(reason))
716                     }
717                 }
718             }
719         } else {
720             return true;
721         }
722     }
723 
724     function _beforeTokenTransfers(
725         address from,
726         address to,
727         uint256 startTokenId,
728         uint256 quantity
729     ) internal virtual {}
730 
731     function _afterTokenTransfers(
732         address from,
733         address to,
734         uint256 startTokenId,
735         uint256 quantity
736     ) internal virtual {}
737 }
738 
739 contract chonkygoats is ERC721A, Ownable {
740     string public constant baseExtension = ".json";
741     address public constant proxyRegistryAddress =
742         0x37cfB7bb56A8a3dBc7C534249d089dCEA73392a2;
743 
744     string baseURI;
745     string public notRevealedUri;
746     uint256 public price = 0.002 ether;
747     uint256 public MAX_SUPPLY = 1888;
748     uint256 public FREE_MAX_SUPPLY = 888;
749     uint256 public MAX_PER_TX = 5;
750 
751     bool public paused = true;
752     bool public revealed = true;
753 
754     constructor(
755         string memory _initBaseURI
756     ) ERC721A("chonkygoats", "CGOATS") {
757         setBaseURI(_initBaseURI);
758     }
759 
760     function mint(uint256 _amount) public payable {
761         require(!paused, "Paused");
762         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
763         require(_amount > 0, "No 0 mints");
764 
765         if (FREE_MAX_SUPPLY >= totalSupply() + _amount) {
766             require(MAX_PER_TX >= _amount, "Exceeds max per transaction");
767         } else {
768             require(MAX_PER_TX >= _amount, "Exceeds max per transaction");
769             require(msg.value >= _amount * price, "Invalid funds provided");
770         }
771 
772         _safeMint(msg.sender, _amount);
773     }
774 
775     function isApprovedForAll(address owner, address operator)
776         public
777         view
778         override
779         returns (bool)
780     {
781         // Whitelist OpenSea proxy contract for easy trading.
782         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
783         if (address(proxyRegistry.proxies(owner)) == operator) {
784             return true;
785         }
786 
787         return super.isApprovedForAll(owner, operator);
788     }
789 
790     function withdraw() public onlyOwner {
791         (bool success, ) = payable(msg.sender).call{
792             value: address(this).balance
793         }("");
794         require(success);
795     }
796 
797     function pause(bool _state) public onlyOwner {
798         paused = _state;
799     }
800 
801     function reveal(bool _state) public onlyOwner {
802         revealed = _state;
803     }
804 
805     function setPrice(uint256 _newPrice) public onlyOwner {
806         price = _newPrice;
807     }
808 
809     function setMaxSupply(uint256 _newMaxSupply) public onlyOwner {
810         MAX_SUPPLY = _newMaxSupply;
811     }
812 
813     function setFreeMaxSupply(uint256 _newFreeMaxSupply) public onlyOwner {
814         FREE_MAX_SUPPLY = _newFreeMaxSupply;
815     }
816 
817     function setMaxPerTx(uint256 _newMaxPerTx) public onlyOwner {
818         MAX_PER_TX = _newMaxPerTx;
819     }
820 
821     function setBaseURI(string memory baseURI_) public onlyOwner {
822         baseURI = baseURI_;
823     }
824 
825     function tokenURI(uint256 _tokenId)
826         public
827         view
828         override
829         returns (string memory)
830     {
831         require(_exists(_tokenId), "Token does not exist.");
832 
833         if (revealed == false) {
834             return notRevealedUri;
835         }
836 
837         return
838             bytes(baseURI).length > 0
839                 ? string(
840                     abi.encodePacked(
841                         baseURI,
842                         Strings.toString(_tokenId),
843                         baseExtension
844                     )
845                 )
846                 : "";
847     }
848 }
849 
850 contract OwnableDelegateProxy {}
851 
852 contract ProxyRegistry {
853     mapping(address => OwnableDelegateProxy) public proxies;
854 }