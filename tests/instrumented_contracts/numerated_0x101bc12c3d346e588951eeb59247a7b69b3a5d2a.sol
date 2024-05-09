1 // SPDX-License-Identifier: MIT
2 /**
3  \\\    ///   .-.        .-.   \\\  ///    (O))  ((O)      W  W          _      ))     oo_    
4  ((O)  (O)) c(O_O)c    c(O_O)c ((O)(O))     ||    ||   /) (O)(O)  (OO) .' )wWw (Oo)-. /  _)-< 
5   | \  / | ,'.---.`,  ,'.---.`, | \ ||      || /\ || (o)(O) ||     ||_/ .' (O)_ | (_))\__ `.  
6   ||\\//||/ /|_|_|\ \/ /|_|_|\ \||\\||      ||//\\||  //\\  | \    |   /  .' __)|  .'    `. | 
7   || \/ ||| \_____/ || \_____/ ||| \ |      / /  \ \ |(__)| |  `.  ||\ \ (  _)  )|\\     _| | 
8   ||    ||'. `---' .`'. `---' .`||  ||     ( /    \ )/,-. |(.-.__)(/\)\ `.`.__)(/  \) ,-'   | 
9  (_/    \_) `-...-'    `-...-' (_/  \_)     )      (-'   '' `-'        `._)     )    (_..--'  
10 */
11 
12 pragma solidity ^0.8.13;
13 pragma solidity ^0.8.0;
14 interface IERC165 {
15     function supportsInterface(bytes4 interfaceId) external view returns (bool);
16 }
17 pragma solidity ^0.8.0;
18 interface IERC721Receiver {
19     function onERC721Received(
20         address operator,
21         address from,
22         uint256 tokenId,
23         bytes calldata data
24     ) external returns (bytes4);
25 }
26 pragma solidity ^0.8.0;
27 interface IERC721 is IERC165 {
28     event Transfer(
29         address indexed from,
30         address indexed to,
31         uint256 indexed tokenId
32     );
33     event Approval(
34         address indexed owner,
35         address indexed approved,
36         uint256 indexed tokenId
37     );
38     event ApprovalForAll(
39         address indexed owner,
40         address indexed operator,
41         bool approved
42     );
43     function balanceOf(address owner) external view returns (uint256 balance);
44     function ownerOf(uint256 tokenId) external view returns (address owner);
45     function safeTransferFrom(
46         address from,
47         address to,
48         uint256 tokenId
49     ) external;
50     function transferFrom(
51         address from,
52         address to,
53         uint256 tokenId
54     ) external;
55     function approve(address to, uint256 tokenId) external;
56     function getApproved(uint256 tokenId)
57         external
58         view
59         returns (address operator);
60     function setApprovalForAll(address operator, bool _approved) external;
61     function isApprovedForAll(address owner, address operator)
62         external
63         view
64         returns (bool);
65     function safeTransferFrom(
66         address from,
67         address to,
68         uint256 tokenId,
69         bytes calldata data
70     ) external;
71 }
72 pragma solidity ^0.8.0;
73 interface IERC721Metadata is IERC721 {
74     function name() external view returns (string memory);
75     function symbol() external view returns (string memory);
76     function tokenURI(uint256 tokenId) external view returns (string memory);
77 }
78 pragma solidity ^0.8.0;
79 interface IERC721Enumerable is IERC721 {
80     function totalSupply() external view returns (uint256);
81     function tokenOfOwnerByIndex(address owner, uint256 index)
82         external
83         view
84         returns (uint256);
85     function tokenByIndex(uint256 index) external view returns (uint256);
86 }
87 pragma solidity ^0.8.1;
88 library Address {
89     function isContract(address account) internal view returns (bool) {
90 
91         return account.code.length > 0;
92     }
93     function sendValue(address payable recipient, uint256 amount) internal {
94         require(
95             address(this).balance >= amount,
96             "Address: insufficient balance"
97         );
98 
99         (bool success, ) = recipient.call{value: amount}("");
100         require(
101             success,
102             "Address: unable to send value, recipient may have reverted"
103         );
104     }
105     function functionCall(address target, bytes memory data)
106         internal
107         returns (bytes memory)
108     {
109         return functionCall(target, data, "Address: low-level call failed");
110     }
111     function functionCall(
112         address target,
113         bytes memory data,
114         string memory errorMessage
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, 0, errorMessage);
117     }
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return
124             functionCallWithValue(
125                 target,
126                 data,
127                 value,
128                 "Address: low-level call with value failed"
129             );
130     }
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(
138             address(this).balance >= value,
139             "Address: insufficient balance for call"
140         );
141         require(isContract(target), "Address: call to non-contract");
142 
143         (bool success, bytes memory returndata) = target.call{value: value}(
144             data
145         );
146         return verifyCallResult(success, returndata, errorMessage);
147     }
148     function functionStaticCall(address target, bytes memory data)
149         internal
150         view
151         returns (bytes memory)
152     {
153         return
154             functionStaticCall(
155                 target,
156                 data,
157                 "Address: low-level static call failed"
158             );
159     }
160     function functionStaticCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal view returns (bytes memory) {
165         require(isContract(target), "Address: static call to non-contract");
166 
167         (bool success, bytes memory returndata) = target.staticcall(data);
168         return verifyCallResult(success, returndata, errorMessage);
169     }
170     function functionDelegateCall(address target, bytes memory data)
171         internal
172         returns (bytes memory)
173     {
174         return
175             functionDelegateCall(
176                 target,
177                 data,
178                 "Address: low-level delegate call failed"
179             );
180     }
181     function functionDelegateCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         require(isContract(target), "Address: delegate call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.delegatecall(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191     function verifyCallResult(
192         bool success,
193         bytes memory returndata,
194         string memory errorMessage
195     ) internal pure returns (bytes memory) {
196         if (success) {
197             return returndata;
198         } else {
199             if (returndata.length > 0) {
200 
201                 assembly {
202                     let returndata_size := mload(returndata)
203                     revert(add(32, returndata), returndata_size)
204                 }
205             } else {
206                 revert(errorMessage);
207             }
208         }
209     }
210 }
211 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
212 pragma solidity ^0.8.0;
213 abstract contract Context {
214     function _msgSender() internal view virtual returns (address) {
215         return msg.sender;
216     }
217 
218     function _msgData() internal view virtual returns (bytes calldata) {
219         return msg.data;
220     }
221 }
222 
223 pragma solidity ^0.8.0;
224 
225 abstract contract Ownable is Context {
226     address private _owner;
227 
228     event OwnershipTransferred(
229         address indexed previousOwner,
230         address indexed newOwner
231     );
232     constructor() {
233         _setOwner(_msgSender());
234     }
235     function owner() public view virtual returns (address) {
236         return _owner;
237     }
238     modifier onlyOwner() {
239         require(owner() == _msgSender(), "Ownable: caller is not the owner");
240         _;
241     }
242     function renounceOwnership() public virtual onlyOwner {
243         _setOwner(address(0));
244     }
245     function transferOwnership(address newOwner) public virtual onlyOwner {
246         require(
247             newOwner != address(0),
248             "Ownable: new owner is the zero address"
249         );
250         _setOwner(newOwner);
251     }
252 
253     function _setOwner(address newOwner) private {
254         address oldOwner = _owner;
255         _owner = newOwner;
256         emit OwnershipTransferred(oldOwner, newOwner);
257     }
258 }
259 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
260 pragma solidity ^0.8.0;
261 library Strings {
262     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
263     function toString(uint256 value) internal pure returns (string memory) {
264         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
265 
266         if (value == 0) {
267             return "0";
268         }
269         uint256 temp = value;
270         uint256 digits;
271         while (temp != 0) {
272             digits++;
273             temp /= 10;
274         }
275         bytes memory buffer = new bytes(digits);
276         while (value != 0) {
277             digits -= 1;
278             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
279             value /= 10;
280         }
281         return string(buffer);
282     }
283     function toHexString(uint256 value) internal pure returns (string memory) {
284         if (value == 0) {
285             return "0x00";
286         }
287         uint256 temp = value;
288         uint256 length = 0;
289         while (temp != 0) {
290             length++;
291             temp >>= 8;
292         }
293         return toHexString(value, length);
294     }
295     function toHexString(uint256 value, uint256 length)
296         internal
297         pure
298         returns (string memory)
299     {
300         bytes memory buffer = new bytes(2 * length + 2);
301         buffer[0] = "0";
302         buffer[1] = "x";
303         for (uint256 i = 2 * length + 1; i > 1; --i) {
304             buffer[i] = _HEX_SYMBOLS[value & 0xf];
305             value >>= 4;
306         }
307         require(value == 0, "Strings: hex length insufficient");
308         return string(buffer);
309     }
310 }
311 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
312 pragma solidity ^0.8.0;
313 abstract contract ERC165 is IERC165 {
314     function supportsInterface(bytes4 interfaceId)
315         public
316         view
317         virtual
318         override
319         returns (bool)
320     {
321         return interfaceId == type(IERC165).interfaceId;
322     }
323 }
324 
325 pragma solidity ^0.8.0;
326 
327 abstract contract ReentrancyGuard {
328     // word because each write operation emits an extra SLOAD to first read the
329     // back. This is the compiler's defense against contract upgrades and
330 
331     // but in exchange the refund on every call to nonReentrant will be lower in
332     // transaction's gas, it is best to keep them low in cases like this one, to
333     uint256 private constant _NOT_ENTERED = 1;
334     uint256 private constant _ENTERED = 2;
335 
336     uint256 private _status;
337 
338     constructor() {
339         _status = _NOT_ENTERED;
340     }
341     modifier nonReentrant() {
342         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
343         _status = _ENTERED;
344 
345         _;
346         // https://eips.ethereum.org/EIPS/eip-2200)
347         _status = _NOT_ENTERED;
348     }
349 }
350 
351 pragma solidity ^0.8.0;
352 contract ERC721A is
353     Context,
354     ERC165,
355     IERC721,
356     IERC721Metadata,
357     IERC721Enumerable
358 {
359     using Address for address;
360     using Strings for uint256;
361 
362     struct TokenOwnership {
363         address addr;
364         uint64 startTimestamp;
365     }
366 
367     struct AddressData {
368         uint128 balance;
369         uint128 numberMinted;
370     }
371 
372     uint256 private currentIndex = 0;
373 
374     uint256 internal immutable collectionSize;
375     uint256 internal immutable maxBatchSize;
376     string private _name;
377     string private _symbol;
378     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
379     mapping(uint256 => TokenOwnership) private _ownerships;
380     mapping(address => AddressData) private _addressData;
381     mapping(uint256 => address) private _tokenApprovals;
382     mapping(address => mapping(address => bool)) private _operatorApprovals;
383     constructor(
384         string memory name_,
385         string memory symbol_,
386         uint256 maxBatchSize_,
387         uint256 collectionSize_
388     ) {
389         require(
390             collectionSize_ > 0,
391             "ERC721A: collection must have a nonzero supply"
392         );
393         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
394         _name = name_;
395         _symbol = symbol_;
396         maxBatchSize = maxBatchSize_;
397         collectionSize = collectionSize_;
398     }
399     function totalSupply() public view override returns (uint256) {
400         return currentIndex;
401     }
402     function tokenByIndex(uint256 index)
403         public
404         view
405         override
406         returns (uint256)
407     {
408         require(index < totalSupply(), "ERC721A: global index out of bounds");
409         return index;
410     }
411     function tokenOfOwnerByIndex(address owner, uint256 index)
412         public
413         view
414         override
415         returns (uint256)
416     {
417         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
418         uint256 numMintedSoFar = totalSupply();
419         uint256 tokenIdsIdx = 0;
420         address currOwnershipAddr = address(0);
421         for (uint256 i = 0; i < numMintedSoFar; i++) {
422             TokenOwnership memory ownership = _ownerships[i];
423             if (ownership.addr != address(0)) {
424                 currOwnershipAddr = ownership.addr;
425             }
426             if (currOwnershipAddr == owner) {
427                 if (tokenIdsIdx == index) {
428                     return i;
429                 }
430                 tokenIdsIdx++;
431             }
432         }
433         revert("ERC721A: unable to get token of owner by index");
434     }
435     function supportsInterface(bytes4 interfaceId)
436         public
437         view
438         virtual
439         override(ERC165, IERC165)
440         returns (bool)
441     {
442         return
443             interfaceId == type(IERC721).interfaceId ||
444             interfaceId == type(IERC721Metadata).interfaceId ||
445             interfaceId == type(IERC721Enumerable).interfaceId ||
446             super.supportsInterface(interfaceId);
447     }
448     function balanceOf(address owner) public view override returns (uint256) {
449         require(
450             owner != address(0),
451             "ERC721A: balance query for the zero address"
452         );
453         return uint256(_addressData[owner].balance);
454     }
455 
456     function _numberMinted(address owner) internal view returns (uint256) {
457         require(
458             owner != address(0),
459             "ERC721A: number minted query for the zero address"
460         );
461         return uint256(_addressData[owner].numberMinted);
462     }
463 
464     function ownershipOf(uint256 tokenId)
465         internal
466         view
467         returns (TokenOwnership memory)
468     {
469         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
470 
471         uint256 lowestTokenToCheck;
472         if (tokenId >= maxBatchSize) {
473             lowestTokenToCheck = tokenId - maxBatchSize + 1;
474         }
475 
476         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
477             TokenOwnership memory ownership = _ownerships[curr];
478             if (ownership.addr != address(0)) {
479                 return ownership;
480             }
481         }
482 
483         revert("ERC721A: unable to determine the owner of token");
484     }
485     function ownerOf(uint256 tokenId) public view override returns (address) {
486         return ownershipOf(tokenId).addr;
487     }
488     function name() public view virtual override returns (string memory) {
489         return _name;
490     }
491     function symbol() public view virtual override returns (string memory) {
492         return _symbol;
493     }
494     function tokenURI(uint256 tokenId)
495         public
496         view
497         virtual
498         override
499         returns (string memory)
500     {
501         require(
502             _exists(tokenId),
503             "ERC721Metadata: URI query for nonexistent token"
504         );
505 
506         string memory baseURI = _baseURI();
507         return
508             bytes(baseURI).length > 0
509                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
510                 : "";
511     }
512     function _baseURI() internal view virtual returns (string memory) {
513         return "";
514     }
515     function approve(address to, uint256 tokenId) public override {
516         address owner = ERC721A.ownerOf(tokenId);
517         require(to != owner, "ERC721A: approval to current owner");
518 
519         require(
520             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
521             "ERC721A: approve caller is not owner nor approved for all"
522         );
523 
524         _approve(to, tokenId, owner);
525     }
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
539     function setApprovalForAll(address operator, bool approved)
540         public
541         override
542     {
543         require(operator != _msgSender(), "ERC721A: approve to caller");
544 
545         _operatorApprovals[_msgSender()][operator] = approved;
546         emit ApprovalForAll(_msgSender(), operator, approved);
547     }
548     function isApprovedForAll(address owner, address operator)
549         public
550         view
551         virtual
552         override
553         returns (bool)
554     {
555         return _operatorApprovals[owner][operator];
556     }
557     function transferFrom(
558         address from,
559         address to,
560         uint256 tokenId
561     ) public override {
562         _transfer(from, to, tokenId);
563     }
564     function safeTransferFrom(
565         address from,
566         address to,
567         uint256 tokenId
568     ) public override {
569         safeTransferFrom(from, to, tokenId, "");
570     }
571     function safeTransferFrom(
572         address from,
573         address to,
574         uint256 tokenId,
575         bytes memory _data
576     ) public override {
577         _transfer(from, to, tokenId);
578         require(
579             _checkOnERC721Received(from, to, tokenId, _data),
580             "ERC721A: transfer to non ERC721Receiver implementer"
581         );
582     }
583     function _exists(uint256 tokenId) internal view returns (bool) {
584         return tokenId < currentIndex;
585     }
586 
587     function _safeMint(address to, uint256 quantity) internal {
588         _safeMint(to, quantity, "");
589     }
590     function _safeMint(
591         address to,
592         uint256 quantity,
593         bytes memory _data
594     ) internal {
595         uint256 startTokenId = currentIndex;
596         require(to != address(0), "ERC721A: mint to the zero address");
597         require(!_exists(startTokenId), "ERC721A: token already minted");
598         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
599 
600         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
601 
602         AddressData memory addressData = _addressData[to];
603         _addressData[to] = AddressData(
604             addressData.balance + uint128(quantity),
605             addressData.numberMinted + uint128(quantity)
606         );
607         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
608 
609         uint256 updatedIndex = startTokenId;
610 
611         for (uint256 i = 0; i < quantity; i++) {
612             emit Transfer(address(0), to, updatedIndex);
613             require(
614                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
615                 "ERC721A: transfer to non ERC721Receiver implementer"
616             );
617             updatedIndex++;
618         }
619 
620         currentIndex = updatedIndex;
621         _afterTokenTransfers(address(0), to, startTokenId, quantity);
622     }
623     function _transfer(
624         address from,
625         address to,
626         uint256 tokenId
627     ) private {
628         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
629 
630         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
631             getApproved(tokenId) == _msgSender() ||
632             isApprovedForAll(prevOwnership.addr, _msgSender()));
633 
634         require(
635             isApprovedOrOwner,
636             "ERC721A: transfer caller is not owner nor approved"
637         );
638 
639         require(
640             prevOwnership.addr == from,
641             "ERC721A: transfer from incorrect owner"
642         );
643         require(to != address(0), "ERC721A: transfer to the zero address");
644 
645         _beforeTokenTransfers(from, to, tokenId, 1);
646         _approve(address(0), tokenId, prevOwnership.addr);
647 
648         _addressData[from].balance -= 1;
649         _addressData[to].balance += 1;
650         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
651         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
652         uint256 nextTokenId = tokenId + 1;
653         if (_ownerships[nextTokenId].addr == address(0)) {
654             if (_exists(nextTokenId)) {
655                 _ownerships[nextTokenId] = TokenOwnership(
656                     prevOwnership.addr,
657                     prevOwnership.startTimestamp
658                 );
659             }
660         }
661 
662         emit Transfer(from, to, tokenId);
663         _afterTokenTransfers(from, to, tokenId, 1);
664     }
665     function _approve(
666         address to,
667         uint256 tokenId,
668         address owner
669     ) private {
670         _tokenApprovals[tokenId] = to;
671         emit Approval(owner, to, tokenId);
672     }
673 
674     uint256 public nextOwnerToExplicitlySet = 0;
675     function _setOwnersExplicit(uint256 quantity) internal {
676         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
677         require(quantity > 0, "quantity must be nonzero");
678         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
679         if (endIndex > collectionSize - 1) {
680             endIndex = collectionSize - 1;
681         }
682         require(_exists(endIndex), "not enough minted yet for this cleanup");
683         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
684             if (_ownerships[i].addr == address(0)) {
685                 TokenOwnership memory ownership = ownershipOf(i);
686                 _ownerships[i] = TokenOwnership(
687                     ownership.addr,
688                     ownership.startTimestamp
689                 );
690             }
691         }
692         nextOwnerToExplicitlySet = endIndex + 1;
693     }
694     function _checkOnERC721Received(
695         address from,
696         address to,
697         uint256 tokenId,
698         bytes memory _data
699     ) private returns (bool) {
700         if (to.isContract()) {
701             try
702                 IERC721Receiver(to).onERC721Received(
703                     _msgSender(),
704                     from,
705                     tokenId,
706                     _data
707                 )
708             returns (bytes4 retval) {
709                 return retval == IERC721Receiver(to).onERC721Received.selector;
710             } catch (bytes memory reason) {
711                 if (reason.length == 0) {
712                     revert(
713                         "ERC721A: transfer to non ERC721Receiver implementer"
714                     );
715                 } else {
716                     assembly {
717                         revert(add(32, reason), mload(reason))
718                     }
719                 }
720             }
721         } else {
722             return true;
723         }
724     }
725     function _beforeTokenTransfers(
726         address from,
727         address to,
728         uint256 startTokenId,
729         uint256 quantity
730     ) internal virtual {}
731     function _afterTokenTransfers(
732         address from,
733         address to,
734         uint256 startTokenId,
735         uint256 quantity
736     ) internal virtual {}
737 }
738 
739 
740 
741 contract MoonWalkers is Ownable, ERC721A, ReentrancyGuard {
742 
743     bool public publicSale = false;
744     uint256 public maxPerTx = 20; 
745     uint256 public maxPerAddress = 50;
746     uint256 public maxToken = 5000;
747     uint256 public price = 0.001 ether;
748     string private _baseTokenURI;
749 
750     mapping (address => bool) public freeMinted;
751 
752     constructor() ERC721A("Moon Walkers", "MNWLK", maxPerTx, maxToken){
753         _safeMint(msg.sender, 1);
754     }
755 
756     modifier callerIsUser() {
757         require(tx.origin == msg.sender, "The caller is another contract");
758         _;
759     }
760 
761     function numberMinted(address owner) public view returns (uint256) {
762         return _numberMinted(owner);
763     }
764 
765     function getOwnershipData(uint256 tokenId)
766         external
767         view
768         returns (TokenOwnership memory)
769     {
770         return ownershipOf(tokenId);
771     }
772 
773     function tokenURI(uint256 tokenId)
774         public
775         view
776         virtual
777         override
778         returns (string memory)
779     {
780         require(
781             _exists(tokenId),
782             "ERC721Metadata: URI query for nonexistent token"
783         );
784         string memory _tokenURI = super.tokenURI(tokenId);
785         return
786             bytes(_tokenURI).length > 0
787                 ? string(abi.encodePacked(_tokenURI, ".json"))
788                 : "";
789     }
790 
791     
792     function mint(uint256 quantity) external payable callerIsUser {
793         require(publicSale, "SALE_HAS_NOT_STARTED_YET");
794         require(numberMinted(msg.sender) + quantity <= maxPerAddress, "PER_WALLET_LIMIT_REACHED");
795         require(quantity > 0, "INVALID_QUANTITY");
796         require(quantity <= maxPerTx, "CANNOT_MINT_THAT_MANY");
797         require(totalSupply() + quantity <= maxToken, "NOT_ENOUGH_SUPPLY_TO_MINT_DESIRED_AMOUNT");
798         if(freeMinted[msg.sender]){
799             require(msg.value >= price * quantity, "INVALID_ETH");
800         
801         }else{
802             require(msg.value >= (price * quantity) - price, "INVALID_ETH");
803             freeMinted[msg.sender] = true;
804         }
805         _safeMint(msg.sender, quantity);
806     }
807 
808     function _baseURI() internal view virtual override returns (string memory) {
809         return _baseTokenURI;
810     }
811 
812     function setPrice(uint256 _NewPrice) external onlyOwner {
813         price = _NewPrice;
814     }
815 
816     function flipPublicSaleState() external onlyOwner {
817         publicSale = !publicSale;
818     }
819 
820     function setBaseURI(string calldata baseURI) external onlyOwner {
821         _baseTokenURI = baseURI;
822     }
823 
824     function withdraw() external onlyOwner {
825         payable(msg.sender).transfer(address(this).balance);
826     }
827 }