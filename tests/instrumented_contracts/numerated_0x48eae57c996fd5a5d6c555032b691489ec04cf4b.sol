1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0; 
3 abstract contract ReentrancyGuard { 
4     uint256 private constant _NOT_ENTERED = 1;
5     uint256 private constant _ENTERED = 2;
6 
7     uint256 private _status;
8 
9     constructor() {
10         _status = _NOT_ENTERED;
11     }
12     modifier nonReentrant() {
13         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
14    _status = _ENTERED;
15 
16         _;
17         _status = _NOT_ENTERED;
18     }
19 }
20 
21 library Strings {
22     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
23  
24     function toString(uint256 value) internal pure returns (string memory) { 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42  
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55  
56     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
57         bytes memory buffer = new bytes(2 * length + 2);
58         buffer[0] = "0";
59         buffer[1] = "x";
60         for (uint256 i = 2 * length + 1; i > 1; --i) {
61             buffer[i] = _HEX_SYMBOLS[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 }
68  
69 abstract contract Context {
70     function _msgSender() internal view virtual returns (address) {
71         return msg.sender;
72     }
73 
74     function _msgData() internal view virtual returns (bytes calldata) {
75         return msg.data;
76     }
77 }
78  
79 abstract contract Ownable is Context {
80     address private _owner;
81 
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83  
84     constructor() {
85         _transferOwnership(_msgSender());
86     }
87  
88     function owner() public view virtual returns (address) {
89         return _owner;
90     } 
91     modifier onlyOwner() {
92         require(owner() == _msgSender(), "Ownable: caller is not the owner");
93         _;
94     }
95  
96     function renounceOwnership() public virtual onlyOwner {
97         _transferOwnership(address(0));
98     }
99  
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _transferOwnership(newOwner);
103     }
104  
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111  
112 library Address { 
113     function isContract(address account) internal view returns (bool) { 
114         uint256 size;
115         assembly {
116             size := extcodesize(account)
117         }
118         return size > 0;
119     } 
120     function sendValue(address payable recipient, uint256 amount) internal {
121         require(address(this).balance >= amount, "Address: insufficient balance");
122 
123         (bool success, ) = recipient.call{value: amount}("");
124         require(success, "Address: unable to send value, recipient may have reverted");
125     }
126  
127     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
128         return functionCall(target, data, "Address: low-level call failed");
129     } 
130     function functionCall(
131         address target,
132         bytes memory data,
133         string memory errorMessage
134     ) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, 0, errorMessage);
136     }
137  
138     function functionCallWithValue(
139         address target,
140         bytes memory data,
141         uint256 value
142     ) internal returns (bytes memory) {
143         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
144     }
145  
146     function functionCallWithValue(
147         address target,
148         bytes memory data,
149         uint256 value,
150         string memory errorMessage
151     ) internal returns (bytes memory) {
152         require(address(this).balance >= value, "Address: insufficient balance for call");
153         require(isContract(target), "Address: call to non-contract");
154 
155         (bool success, bytes memory returndata) = target.call{value: value}(data);
156         return verifyCallResult(success, returndata, errorMessage);
157     } 
158     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
159         return functionStaticCall(target, data, "Address: low-level static call failed");
160     }
161  
162     function functionStaticCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal view returns (bytes memory) {
167         require(isContract(target), "Address: static call to non-contract");
168 
169         (bool success, bytes memory returndata) = target.staticcall(data);
170         return verifyCallResult(success, returndata, errorMessage);
171     }
172  
173     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
175     }
176  
177     function functionDelegateCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         require(isContract(target), "Address: delegate call to non-contract");
183 
184         (bool success, bytes memory returndata) = target.delegatecall(data);
185         return verifyCallResult(success, returndata, errorMessage);
186     }
187  
188     function verifyCallResult(
189         bool success,
190         bytes memory returndata,
191         string memory errorMessage
192     ) internal pure returns (bytes memory) {
193         if (success) {
194             return returndata;
195         } else { 
196             if (returndata.length > 0) { 
197 
198                 assembly {
199                     let returndata_size := mload(returndata)
200                     revert(add(32, returndata), returndata_size)
201                 }
202             } else {
203                 revert(errorMessage);
204             }
205         }
206     }
207 }
208  
209 interface IERC721Receiver { 
210     function onERC721Received(
211         address operator,
212         address from,
213         uint256 tokenId,
214         bytes calldata data
215     ) external returns (bytes4);
216 }
217  
218 interface IERC165 { 
219     function supportsInterface(bytes4 interfaceId) external view returns (bool);
220 }
221  
222 abstract contract ERC165 is IERC165 { 
223     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
224         return interfaceId == type(IERC165).interfaceId;
225     }
226 } 
227 interface IERC721 is IERC165 { 
228     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); 
229     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId); 
230     event ApprovalForAll(address indexed owner, address indexed operator, bool approved); 
231     function balanceOf(address owner) external view returns (uint256 balance); 
232     function ownerOf(uint256 tokenId) external view returns (address owner); 
233     function safeTransferFrom(
234         address from,
235         address to,
236         uint256 tokenId
237     ) external; 
238     function transferFrom(
239         address from,
240         address to,
241         uint256 tokenId
242     ) external; 
243     function approve(address to, uint256 tokenId) external;
244  
245     function getApproved(uint256 tokenId) external view returns (address operator); 
246     function setApprovalForAll(address operator, bool _approved) external; 
247     function isApprovedForAll(address owner, address operator) external view returns (bool); 
248     function safeTransferFrom(
249         address from,
250         address to,
251         uint256 tokenId,
252         bytes calldata data
253     ) external;
254 } 
255 interface IERC721Enumerable is IERC721 { 
256     function totalSupply() external view returns (uint256); 
257     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId); 
258     function tokenByIndex(uint256 index) external view returns (uint256);
259 }  
260 interface IERC721Metadata is IERC721 { 
261     function name() external view returns (string memory); 
262     function symbol() external view returns (string memory); 
263     function tokenURI(uint256 tokenId) external view returns (string memory);
264 } 
265 contract ERC721A is
266   Context,
267   ERC165,
268   IERC721,
269   IERC721Metadata,
270   IERC721Enumerable
271 {
272   using Address for address;
273   using Strings for uint256;
274 
275   struct TokenOwnership {
276     address addr;
277     uint64 startTimestamp;
278   }
279 
280   struct AddressData {
281     uint128 balance;
282     uint128 numberMinted;
283   }
284 
285   uint256 private currentIndex = 1;
286 
287   uint256 internal immutable collectionSize;
288   uint256 internal immutable maxBatchSize; 
289   string private _name; 
290   string private _symbol; 
291   mapping(uint256 => TokenOwnership) private _ownerships; 
292   mapping(address => AddressData) private _addressData; 
293   mapping(uint256 => address) private _tokenApprovals; 
294   mapping(address => mapping(address => bool)) private _operatorApprovals; 
295   constructor(
296     string memory name_,
297     string memory symbol_,
298     uint256 maxBatchSize_,
299     uint256 collectionSize_
300   ) {
301     require(
302       collectionSize_ > 0,
303       "ERC721A: collection must have a nonzero supply"
304     );
305     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
306     _name = name_;
307     _symbol = symbol_;
308     maxBatchSize = maxBatchSize_;
309     collectionSize = collectionSize_;
310   } 
311   function totalSupply() public view override returns (uint256) {
312     return currentIndex-1;
313   } 
314   function tokenByIndex(uint256 index) public view override returns (uint256) {
315     require(index < totalSupply(), "ERC721A: global index out of bounds");
316     return index;
317   } 
318   function tokenOfOwnerByIndex(address owner, uint256 index)
319     public
320     view
321     override
322     returns (uint256)
323   {
324     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
325     uint256 numMintedSoFar = totalSupply();
326     uint256 tokenIdsIdx = 0;
327     address currOwnershipAddr = address(0);
328     for (uint256 i = 0; i < numMintedSoFar; i++) {
329       TokenOwnership memory ownership = _ownerships[i];
330       if (ownership.addr != address(0)) {
331         currOwnershipAddr = ownership.addr;
332       }
333       if (currOwnershipAddr == owner) {
334         if (tokenIdsIdx == index) {
335           return i;
336         }
337         tokenIdsIdx++;
338       }
339     }
340     revert("ERC721A: unable to get token of owner by index");
341   } 
342   function supportsInterface(bytes4 interfaceId)
343     public
344     view
345     virtual
346     override(ERC165, IERC165)
347     returns (bool)
348   {
349     return
350       interfaceId == type(IERC721).interfaceId ||
351       interfaceId == type(IERC721Metadata).interfaceId ||
352       interfaceId == type(IERC721Enumerable).interfaceId ||
353       super.supportsInterface(interfaceId);
354   } 
355   function balanceOf(address owner) public view override returns (uint256) {
356     require(owner != address(0), "ERC721A: balance query for the zero address");
357     return uint256(_addressData[owner].balance);
358   }
359 
360   function _numberMinted(address owner) internal view returns (uint256) {
361     require(
362       owner != address(0),
363       "ERC721A: number minted query for the zero address"
364     );
365     return uint256(_addressData[owner].numberMinted);
366   }
367 
368   function ownershipOf(uint256 tokenId)
369     internal
370     view
371     returns (TokenOwnership memory)
372   {
373     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
374 
375     uint256 lowestTokenToCheck;
376     if (tokenId >= maxBatchSize) {
377       lowestTokenToCheck = tokenId - maxBatchSize + 1;
378     }
379 
380     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
381       TokenOwnership memory ownership = _ownerships[curr];
382       if (ownership.addr != address(0)) {
383         return ownership;
384       }
385     }
386 
387     revert("ERC721A: unable to determine the owner of token");
388   } 
389   function ownerOf(uint256 tokenId) public view override returns (address) {
390     return ownershipOf(tokenId).addr;
391   } 
392   function name() public view virtual override returns (string memory) {
393     return _name;
394   } 
395   function symbol() public view virtual override returns (string memory) {
396     return _symbol;
397   } 
398   function tokenURI(uint256 tokenId)
399     public
400     view
401     virtual
402     override
403     returns (string memory)
404   {
405     require(
406       _exists(tokenId),
407       "ERC721Metadata: URI query for nonexistent token"
408     );
409 
410     string memory baseURI = _baseURI();
411     return
412       bytes(baseURI).length > 0
413         ? string(abi.encodePacked(baseURI, tokenId.toString(),_getUriExtension()))
414         : "";
415   } 
416   function _baseURI() internal view virtual returns (string memory) {
417     return "";
418   }
419 
420   function _getUriExtension() internal view virtual returns (string memory) {
421     return "";
422   }
423  
424   function approve(address to, uint256 tokenId) public override {
425     address owner = ERC721A.ownerOf(tokenId);
426     require(to != owner, "ERC721A: approval to current owner");
427 
428     require(
429       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
430       "ERC721A: approve caller is not owner nor approved for all"
431     );
432 
433     _approve(to, tokenId, owner);
434   } 
435   function getApproved(uint256 tokenId) public view override returns (address) {
436     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
437 
438     return _tokenApprovals[tokenId];
439   } 
440   function setApprovalForAll(address operator, bool approved) public override {
441     require(operator != _msgSender(), "ERC721A: approve to caller");
442 
443     _operatorApprovals[_msgSender()][operator] = approved;
444     emit ApprovalForAll(_msgSender(), operator, approved);
445   }
446  
447   function isApprovedForAll(address owner, address operator)
448     public
449     view
450     virtual
451     override
452     returns (bool)
453   {
454     return _operatorApprovals[owner][operator];
455   }
456  
457   function transferFrom(
458     address from,
459     address to,
460     uint256 tokenId
461   ) public override {
462     _transfer(from, to, tokenId);
463   } 
464   function safeTransferFrom(
465     address from,
466     address to,
467     uint256 tokenId
468   ) public override {
469     safeTransferFrom(from, to, tokenId, "");
470   } 
471   function safeTransferFrom(
472     address from,
473     address to,
474     uint256 tokenId,
475     bytes memory _data
476   ) public override {
477     _transfer(from, to, tokenId);
478     require(
479       _checkOnERC721Received(from, to, tokenId, _data),
480       "ERC721A: transfer to non ERC721Receiver implementer"
481     );
482   } 
483   function _exists(uint256 tokenId) internal view returns (bool) {
484     return tokenId < currentIndex;
485   }
486 
487   function _safeMint(address to, uint256 quantity) internal {
488     _safeMint(to, quantity, "");
489   } 
490   function _safeMint(
491     address to,
492     uint256 quantity,
493     bytes memory _data
494   ) internal {
495     uint256 startTokenId = currentIndex;
496     require(to != address(0), "ERC721A: mint to the zero address"); 
497     require(!_exists(startTokenId), "ERC721A: token already minted");
498     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
499 
500     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
501 
502     AddressData memory addressData = _addressData[to];
503     _addressData[to] = AddressData(
504       addressData.balance + uint128(quantity),
505       addressData.numberMinted + uint128(quantity)
506     );
507     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
508 
509     uint256 updatedIndex = startTokenId;
510 
511     for (uint256 i = 0; i < quantity; i++) {
512       emit Transfer(address(0), to, updatedIndex);
513       require(
514         _checkOnERC721Received(address(0), to, updatedIndex, _data),
515         "ERC721A: transfer to non ERC721Receiver implementer"
516       );
517       updatedIndex++;
518     }
519 
520     currentIndex = updatedIndex;
521     _afterTokenTransfers(address(0), to, startTokenId, quantity);
522   } 
523   function _transfer(
524     address from,
525     address to,
526     uint256 tokenId
527   ) private {
528     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
529 
530     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
531       getApproved(tokenId) == _msgSender() ||
532       isApprovedForAll(prevOwnership.addr, _msgSender()));
533 
534     require(
535       isApprovedOrOwner,
536       "ERC721A: transfer caller is not owner nor approved"
537     );
538 
539     require(
540       prevOwnership.addr == from,
541       "ERC721A: transfer from incorrect owner"
542     );
543     require(to != address(0), "ERC721A: transfer to the zero address");
544 
545     _beforeTokenTransfers(from, to, tokenId, 1); 
546     _approve(address(0), tokenId, prevOwnership.addr);
547 
548     _addressData[from].balance -= 1;
549     _addressData[to].balance += 1;
550     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp)); 
551     uint256 nextTokenId = tokenId + 1;
552     if (_ownerships[nextTokenId].addr == address(0)) {
553       if (_exists(nextTokenId)) {
554         _ownerships[nextTokenId] = TokenOwnership(
555           prevOwnership.addr,
556           prevOwnership.startTimestamp
557         );
558       }
559     }
560 
561     emit Transfer(from, to, tokenId);
562     _afterTokenTransfers(from, to, tokenId, 1);
563   } 
564   function _approve(
565     address to,
566     uint256 tokenId,
567     address owner
568   ) private {
569     _tokenApprovals[tokenId] = to;
570     emit Approval(owner, to, tokenId);
571   }
572 
573   uint256 public nextOwnerToExplicitlySet = 0; 
574   function _setOwnersExplicit(uint256 quantity) internal {
575     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
576     require(quantity > 0, "quantity must be nonzero");
577     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
578     if (endIndex > collectionSize - 1) {
579       endIndex = collectionSize - 1;
580     } 
581     require(_exists(endIndex), "not enough minted yet for this cleanup");
582     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
583       if (_ownerships[i].addr == address(0)) {
584         TokenOwnership memory ownership = ownershipOf(i);
585         _ownerships[i] = TokenOwnership(
586           ownership.addr,
587           ownership.startTimestamp
588         );
589       }
590     }
591     nextOwnerToExplicitlySet = endIndex + 1;
592   } 
593   function _checkOnERC721Received(
594     address from,
595     address to,
596     uint256 tokenId,
597     bytes memory _data
598   ) private returns (bool) {
599     if (to.isContract()) {
600       try
601         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
602       returns (bytes4 retval) {
603         return retval == IERC721Receiver(to).onERC721Received.selector;
604       } catch (bytes memory reason) {
605         if (reason.length == 0) {
606           revert("ERC721A: transfer to non ERC721Receiver implementer");
607         } else {
608           assembly {
609             revert(add(32, reason), mload(reason))
610           }
611         }
612       }
613     } else {
614       return true;
615     }
616   } 
617   function _beforeTokenTransfers(
618     address from,
619     address to,
620     uint256 startTokenId,
621     uint256 quantity
622   ) internal virtual {} 
623   function _afterTokenTransfers(
624     address from,
625     address to,
626     uint256 startTokenId,
627     uint256 quantity
628   ) internal virtual {}
629 }
630 
631 contract FORMLESS is Ownable, ERC721A, ReentrancyGuard {
632     using Strings for uint256;
633 
634 
635   uint256 public MAX_PER_Transtion = 1; // maximam amount that user can mint per transaction
636   uint256 public MAX_PER_Address = 1;
637 
638   uint256 public  PRICE = 0.069 ether; //
639 
640   uint256 private TotalCollectionSize_ = 500; // total number of nfts
641   uint256 private constant MaxMintPerBatch_ = 1; //max mint per trx
642  
643   mapping(address => bool) private whitelistedAddressesForMint;
644 
645 
646 
647 
648 
649   string private _baseTokenURI;
650 
651 
652   uint public status = 0; //0 - sale pause, 1 - whitelist sale, 2 - public sale
653 
654   constructor() ERC721A("FORMLESS","FORMLESS", MaxMintPerBatch_, TotalCollectionSize_) {
655    
656    
657 
658     
659     _baseTokenURI= "https://gateway.pinata.cloud/ipfs/QmWT2u6UEeXJs5MWcSTQhHFyYC9wKevQNjXC4J3k67ymtQ/";
660 
661 
662   }
663 
664   modifier callerIsUser() {
665     require(tx.origin == msg.sender, "The caller is another contract");
666     _;
667   }
668 
669 function mint(uint256 quantity) external payable callerIsUser {
670     if(status == 1){
671     require(whitelistedAddressesForMint[msg.sender], "You are not White Listed For Mint");
672     require(totalSupply() + quantity <= TotalCollectionSize_, "Reached max supply");
673     require(quantity == 1, "1 NFT per Mint");
674     require(numberMinted(msg.sender) < 1  , "Already minted" );
675     require(msg.value >= PRICE * quantity, "Not enough ETH in your wallet");
676     _safeMint(msg.sender, 1);
677     }
678     else{
679     require(status == 2, "Public Sale is not Active");
680     require(quantity > 0,"Mint Quantity should be more than 0");
681     require(quantity <= MAX_PER_Transtion,"Max 1 NFTs can be minted in a Trx");
682     require(totalSupply() + quantity <= TotalCollectionSize_, "Reached max supply");
683     require(numberMinted(msg.sender) + quantity <= MAX_PER_Address, "Can't mint this much" );
684     require(msg.value >= PRICE * quantity, "Not enough ETH in your wallet");
685     _safeMint(msg.sender, quantity);  
686     }
687     }
688 
689    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
690     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
691  
692     string memory baseURI = _baseURI();
693     return
694       bytes(baseURI).length > 0
695         ? string(abi.encodePacked(baseURI, tokenId.toString(),".json"))
696         : "";
697     } 
698 
699 
700   function isWhitelistedForMint(address _user) public view returns (bool) {
701     return whitelistedAddressesForMint[_user];
702   }
703 
704   
705   function addNewWhitelistUserForMint(address[] calldata _users) public onlyOwner {
706     // ["","",""]
707     for(uint i=0;i<_users.length;i++)
708         whitelistedAddressesForMint[_users[i]] = true;
709   }
710   
711 
712 
713   function setBaseURI(string memory baseURI) external onlyOwner {
714     _baseTokenURI = baseURI;
715   }
716   function _baseURI() internal view virtual override returns (string memory) {
717     return _baseTokenURI;
718   }
719   function numberMinted(address owner) public view returns (uint256) {
720     return _numberMinted(owner);
721   }
722   function getOwnershipData(uint256 tokenId)
723     external
724     view
725     returns (TokenOwnership memory)
726   {
727     return ownershipOf(tokenId);
728   }
729 
730   function withdrawMoney() external onlyOwner nonReentrant {
731     (bool success, ) = msg.sender.call{value: address(this).balance}("");
732     require(success, "Transfer failed.");
733   }
734 
735   function changeMAX_PER_Address(uint256 q) external onlyOwner
736   {
737       MAX_PER_Address = q;
738   }
739 
740   function reserve(address _address, uint256 quantity) public onlyOwner {
741   require(quantity > 0,"Quantity should be more than 0");
742   require(totalSupply() + quantity <= TotalCollectionSize_, "Reached max supply");
743   _safeMint(_address, quantity);
744   }
745 
746 
747 
748   function changeMintPrice(uint256 _newPrice) external onlyOwner
749   {
750       PRICE = _newPrice;
751   }
752 
753   function changeCollectionSize(uint256 _collectionSize) external onlyOwner
754   {
755       TotalCollectionSize_ = _collectionSize;
756   }
757 
758   function changeMAX_PER_Transtion(uint256 q) external onlyOwner
759   {
760       MAX_PER_Transtion = q;
761   }
762  
763   function giveaway(address a, uint q)public onlyOwner{
764     require(totalSupply() + q <= TotalCollectionSize_, "Reached max supply");
765     require(q <= MAX_PER_Transtion, "Can't exceed more than 10");
766     _safeMint(a, q);
767   }
768 
769 
770   function setStatus(uint256 s)external onlyOwner{
771       status = s;
772       if(s==1){
773           PRICE=0.069 ether;
774       }
775       else{
776           PRICE=0.099 ether;
777       }
778 }
779 
780   function getStatus()public view returns(uint){
781 		return status;
782       
783   }
784   
785   function getcollectionSize()public view returns(uint){
786       return TotalCollectionSize_;
787   }
788   
789 }
790 
791 library Base64 {
792     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
793 
794     /// @notice Encodes some bytes to the base64 representation
795     function encode(bytes memory data) internal pure returns (string memory) {
796         uint256 len = data.length;
797         if (len == 0) return "";
798 
799         // multiply by 4/3 rounded up
800         uint256 encodedLen = 4 * ((len + 2) / 3);
801 
802         // Add some extra buffer at the end
803         bytes memory result = new bytes(encodedLen + 32);
804 
805         bytes memory table = TABLE;
806 
807         assembly {
808             let tablePtr := add(table, 1)
809             let resultPtr := add(result, 32)
810 
811             for {
812                 let i := 0
813             } lt(i, len) {
814 
815             } {
816                 i := add(i, 3)
817                 let input := and(mload(add(data, i)), 0xffffff)
818 
819                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
820                 out := shl(8, out)
821                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
822                 out := shl(8, out)
823                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
824                 out := shl(8, out)
825                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
826                 out := shl(224, out)
827 
828                 mstore(resultPtr, out)
829 
830                 resultPtr := add(resultPtr, 4)
831             }
832 
833             switch mod(len, 3)
834             case 1 {
835                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
836             }
837             case 2 {
838                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
839             }
840 
841             mstore(result, encodedLen)
842         }
843 
844         return string(result);
845     }
846 }