1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0; 
3 
4 library MerkleProof {
5     function verify(
6         bytes32[] memory proof,
7         bytes32 root,
8         bytes32 leaf
9     ) internal pure returns (bool) {
10         return processProof(proof, leaf) == root;
11     }
12    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
13         bytes32 computedHash = leaf;
14         for (uint256 i = 0; i < proof.length; i++) {
15             bytes32 proofElement = proof[i];
16             if (computedHash <= proofElement) {
17                 computedHash = _efficientHash(computedHash, proofElement);
18             } else {
19                 computedHash = _efficientHash(proofElement, computedHash);
20             }
21         }
22         return computedHash;
23     }
24 
25     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
26         assembly {
27             mstore(0x00, a)
28             mstore(0x20, b)
29             value := keccak256(0x00, 0x40)
30         }
31     }
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
43     modifier nonReentrant() {
44         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
45    _status = _ENTERED;
46 
47         _;
48         _status = _NOT_ENTERED;
49     }
50 }
51 
52 library Strings {
53     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
54  
55     function toString(uint256 value) internal pure returns (string memory) { 
56         if (value == 0) {
57             return "0";
58         }
59         uint256 temp = value;
60         uint256 digits;
61         while (temp != 0) {
62             digits++;
63             temp /= 10;
64         }
65         bytes memory buffer = new bytes(digits);
66         while (value != 0) {
67             digits -= 1;
68             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
69             value /= 10;
70         }
71         return string(buffer);
72     }
73  
74     function toHexString(uint256 value) internal pure returns (string memory) {
75         if (value == 0) {
76             return "0x00";
77         }
78         uint256 temp = value;
79         uint256 length = 0;
80         while (temp != 0) {
81             length++;
82             temp >>= 8;
83         }
84         return toHexString(value, length);
85     }
86  
87     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
88         bytes memory buffer = new bytes(2 * length + 2);
89         buffer[0] = "0";
90         buffer[1] = "x";
91         for (uint256 i = 2 * length + 1; i > 1; --i) {
92             buffer[i] = _HEX_SYMBOLS[value & 0xf];
93             value >>= 4;
94         }
95         require(value == 0, "Strings: hex length insufficient");
96         return string(buffer);
97     }
98 }
99  
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes calldata) {
106         return msg.data;
107     }
108 }
109  
110 abstract contract Ownable is Context {
111     address private _owner;
112 
113     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114  
115     constructor() {
116         _transferOwnership(_msgSender());
117     }
118  
119     function owner() public view virtual returns (address) {
120         return _owner;
121     } 
122     modifier onlyOwner() {
123         require(owner() == _msgSender(), "Ownable: caller is not the owner");
124         _;
125     }
126  
127     function renounceOwnership() public virtual onlyOwner {
128         _transferOwnership(address(0));
129     }
130  
131     function transferOwnership(address newOwner) public virtual onlyOwner {
132         require(newOwner != address(0), "Ownable: new owner is the zero address");
133         _transferOwnership(newOwner);
134     }
135  
136     function _transferOwnership(address newOwner) internal virtual {
137         address oldOwner = _owner;
138         _owner = newOwner;
139         emit OwnershipTransferred(oldOwner, newOwner);
140     }
141 }
142  
143 library Address { 
144     function isContract(address account) internal view returns (bool) { 
145         uint256 size;
146         assembly {
147             size := extcodesize(account)
148         }
149         return size > 0;
150     } 
151     function sendValue(address payable recipient, uint256 amount) internal {
152         require(address(this).balance >= amount, "Address: insufficient balance");
153 
154         (bool success, ) = recipient.call{value: amount}("");
155         require(success, "Address: unable to send value, recipient may have reverted");
156     }
157  
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionCall(target, data, "Address: low-level call failed");
160     } 
161     function functionCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal returns (bytes memory) {
166         return functionCallWithValue(target, data, 0, errorMessage);
167     }
168  
169     function functionCallWithValue(
170         address target,
171         bytes memory data,
172         uint256 value
173     ) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
175     }
176  
177     function functionCallWithValue(
178         address target,
179         bytes memory data,
180         uint256 value,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         require(address(this).balance >= value, "Address: insufficient balance for call");
184         require(isContract(target), "Address: call to non-contract");
185 
186         (bool success, bytes memory returndata) = target.call{value: value}(data);
187         return verifyCallResult(success, returndata, errorMessage);
188     } 
189     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
190         return functionStaticCall(target, data, "Address: low-level static call failed");
191     }
192  
193     function functionStaticCall(
194         address target,
195         bytes memory data,
196         string memory errorMessage
197     ) internal view returns (bytes memory) {
198         require(isContract(target), "Address: static call to non-contract");
199 
200         (bool success, bytes memory returndata) = target.staticcall(data);
201         return verifyCallResult(success, returndata, errorMessage);
202     }
203  
204     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
205         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
206     }
207  
208     function functionDelegateCall(
209         address target,
210         bytes memory data,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         require(isContract(target), "Address: delegate call to non-contract");
214 
215         (bool success, bytes memory returndata) = target.delegatecall(data);
216         return verifyCallResult(success, returndata, errorMessage);
217     }
218  
219     function verifyCallResult(
220         bool success,
221         bytes memory returndata,
222         string memory errorMessage
223     ) internal pure returns (bytes memory) {
224         if (success) {
225             return returndata;
226         } else { 
227             if (returndata.length > 0) { 
228 
229                 assembly {
230                     let returndata_size := mload(returndata)
231                     revert(add(32, returndata), returndata_size)
232                 }
233             } else {
234                 revert(errorMessage);
235             }
236         }
237     }
238 }
239  
240 interface IERC721Receiver { 
241     function onERC721Received(
242         address operator,
243         address from,
244         uint256 tokenId,
245         bytes calldata data
246     ) external returns (bytes4);
247 }
248  
249 interface IERC165 { 
250     function supportsInterface(bytes4 interfaceId) external view returns (bool);
251 }
252  
253 abstract contract ERC165 is IERC165 { 
254     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
255         return interfaceId == type(IERC165).interfaceId;
256     }
257 } 
258 interface IERC721 is IERC165 { 
259     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); 
260     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId); 
261     event ApprovalForAll(address indexed owner, address indexed operator, bool approved); 
262     function balanceOf(address owner) external view returns (uint256 balance); 
263     function ownerOf(uint256 tokenId) external view returns (address owner); 
264     function safeTransferFrom(
265         address from,
266         address to,
267         uint256 tokenId
268     ) external; 
269     function transferFrom(
270         address from,
271         address to,
272         uint256 tokenId
273     ) external; 
274     function approve(address to, uint256 tokenId) external;
275  
276     function getApproved(uint256 tokenId) external view returns (address operator); 
277     function setApprovalForAll(address operator, bool _approved) external; 
278     function isApprovedForAll(address owner, address operator) external view returns (bool); 
279     function safeTransferFrom(
280         address from,
281         address to,
282         uint256 tokenId,
283         bytes calldata data
284     ) external;
285 } 
286 interface IERC721Enumerable is IERC721 { 
287     function totalSupply() external view returns (uint256); 
288     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId); 
289     function tokenByIndex(uint256 index) external view returns (uint256);
290 }  
291 interface IERC721Metadata is IERC721 { 
292     function name() external view returns (string memory); 
293     function symbol() external view returns (string memory); 
294     function tokenURI(uint256 tokenId) external view returns (string memory);
295 } 
296 contract ERC721A is
297   Context,
298   ERC165,
299   IERC721,
300   IERC721Metadata,
301   IERC721Enumerable
302 {
303   using Address for address;
304   using Strings for uint256;
305 
306   struct TokenOwnership {
307     address addr;
308     uint64 startTimestamp;
309   }
310 
311   struct AddressData {
312     uint128 balance;
313     uint128 numberMinted;
314   }
315 
316   uint256 private currentIndex = 1;
317 
318   uint256 internal immutable collectionSize;
319   uint256 internal immutable maxBatchSize; 
320   string private _name; 
321   string private _symbol; 
322   mapping(uint256 => TokenOwnership) private _ownerships; 
323   mapping(address => AddressData) private _addressData; 
324   mapping(uint256 => address) private _tokenApprovals; 
325   mapping(address => mapping(address => bool)) private _operatorApprovals; 
326   constructor(
327     string memory name_,
328     string memory symbol_,
329     uint256 maxBatchSize_,
330     uint256 collectionSize_
331   ) {
332     require(
333       collectionSize_ > 0,
334       "ERC721A: collection must have a nonzero supply"
335     );
336     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
337     _name = name_;
338     _symbol = symbol_;
339     maxBatchSize = maxBatchSize_;
340     collectionSize = collectionSize_;
341   } 
342   function totalSupply() public view override returns (uint256) {
343     return currentIndex;
344   } 
345   function tokenByIndex(uint256 index) public view override returns (uint256) {
346     require(index < totalSupply(), "ERC721A: global index out of bounds");
347     return index;
348   } 
349   function tokenOfOwnerByIndex(address owner, uint256 index)
350     public
351     view
352     override
353     returns (uint256)
354   {
355     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
356     uint256 numMintedSoFar = totalSupply();
357     uint256 tokenIdsIdx = 0;
358     address currOwnershipAddr = address(0);
359     for (uint256 i = 0; i < numMintedSoFar; i++) {
360       TokenOwnership memory ownership = _ownerships[i];
361       if (ownership.addr != address(0)) {
362         currOwnershipAddr = ownership.addr;
363       }
364       if (currOwnershipAddr == owner) {
365         if (tokenIdsIdx == index) {
366           return i;
367         }
368         tokenIdsIdx++;
369       }
370     }
371     revert("ERC721A: unable to get token of owner by index");
372   } 
373   function supportsInterface(bytes4 interfaceId)
374     public
375     view
376     virtual
377     override(ERC165, IERC165)
378     returns (bool)
379   {
380     return
381       interfaceId == type(IERC721).interfaceId ||
382       interfaceId == type(IERC721Metadata).interfaceId ||
383       interfaceId == type(IERC721Enumerable).interfaceId ||
384       super.supportsInterface(interfaceId);
385   } 
386   function balanceOf(address owner) public view override returns (uint256) {
387     require(owner != address(0), "ERC721A: balance query for the zero address");
388     return uint256(_addressData[owner].balance);
389   }
390 
391   function _numberMinted(address owner) internal view returns (uint256) {
392     require(
393       owner != address(0),
394       "ERC721A: number minted query for the zero address"
395     );
396     return uint256(_addressData[owner].numberMinted);
397   }
398 
399   function ownershipOf(uint256 tokenId)
400     internal
401     view
402     returns (TokenOwnership memory)
403   {
404     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
405 
406     uint256 lowestTokenToCheck;
407     if (tokenId >= maxBatchSize) {
408       lowestTokenToCheck = tokenId - maxBatchSize + 1;
409     }
410 
411     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
412       TokenOwnership memory ownership = _ownerships[curr];
413       if (ownership.addr != address(0)) {
414         return ownership;
415       }
416     }
417 
418     revert("ERC721A: unable to determine the owner of token");
419   } 
420   function ownerOf(uint256 tokenId) public view override returns (address) {
421     return ownershipOf(tokenId).addr;
422   } 
423   function name() public view virtual override returns (string memory) {
424     return _name;
425   } 
426   function symbol() public view virtual override returns (string memory) {
427     return _symbol;
428   } 
429   function tokenURI(uint256 tokenId)
430     public
431     view
432     virtual
433     override
434     returns (string memory)
435   {
436     require(
437       _exists(tokenId),
438       "ERC721Metadata: URI query for nonexistent token"
439     );
440 
441     string memory baseURI = _baseURI();
442     return
443       bytes(baseURI).length > 0
444         ? string(abi.encodePacked(baseURI, tokenId.toString(),_getUriExtension()))
445         : "";
446   } 
447   function _baseURI() internal view virtual returns (string memory) {
448     return "";
449   }
450 
451   function _getUriExtension() internal view virtual returns (string memory) {
452     return "";
453   }
454  
455   function approve(address to, uint256 tokenId) public override {
456     address owner = ERC721A.ownerOf(tokenId);
457     require(to != owner, "ERC721A: approval to current owner");
458 
459     require(
460       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
461       "ERC721A: approve caller is not owner nor approved for all"
462     );
463 
464     _approve(to, tokenId, owner);
465   } 
466   function getApproved(uint256 tokenId) public view override returns (address) {
467     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
468 
469     return _tokenApprovals[tokenId];
470   } 
471   function setApprovalForAll(address operator, bool approved) public override {
472     require(operator != _msgSender(), "ERC721A: approve to caller");
473 
474     _operatorApprovals[_msgSender()][operator] = approved;
475     emit ApprovalForAll(_msgSender(), operator, approved);
476   }
477  
478   function isApprovedForAll(address owner, address operator)
479     public
480     view
481     virtual
482     override
483     returns (bool)
484   {
485     return _operatorApprovals[owner][operator];
486   }
487  
488   function transferFrom(
489     address from,
490     address to,
491     uint256 tokenId
492   ) public override {
493     _transfer(from, to, tokenId);
494   } 
495   function safeTransferFrom(
496     address from,
497     address to,
498     uint256 tokenId
499   ) public override {
500     safeTransferFrom(from, to, tokenId, "");
501   } 
502   function safeTransferFrom(
503     address from,
504     address to,
505     uint256 tokenId,
506     bytes memory _data
507   ) public override {
508     _transfer(from, to, tokenId);
509     require(
510       _checkOnERC721Received(from, to, tokenId, _data),
511       "ERC721A: transfer to non ERC721Receiver implementer"
512     );
513   } 
514   function _exists(uint256 tokenId) internal view returns (bool) {
515     return tokenId < currentIndex;
516   }
517 
518   function _safeMint(address to, uint256 quantity) internal {
519     _safeMint(to, quantity, "");
520   } 
521   function _safeMint(
522     address to,
523     uint256 quantity,
524     bytes memory _data
525   ) internal {
526     uint256 startTokenId = currentIndex;
527     require(to != address(0), "ERC721A: mint to the zero address"); 
528     require(!_exists(startTokenId), "ERC721A: token already minted");
529     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
530 
531     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
532 
533     AddressData memory addressData = _addressData[to];
534     _addressData[to] = AddressData(
535       addressData.balance + uint128(quantity),
536       addressData.numberMinted + uint128(quantity)
537     );
538     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
539 
540     uint256 updatedIndex = startTokenId;
541 
542     for (uint256 i = 0; i < quantity; i++) {
543       emit Transfer(address(0), to, updatedIndex);
544       require(
545         _checkOnERC721Received(address(0), to, updatedIndex, _data),
546         "ERC721A: transfer to non ERC721Receiver implementer"
547       );
548       updatedIndex++;
549     }
550 
551     currentIndex = updatedIndex;
552     _afterTokenTransfers(address(0), to, startTokenId, quantity);
553   } 
554   function _transfer(
555     address from,
556     address to,
557     uint256 tokenId
558   ) private {
559     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
560 
561     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
562       getApproved(tokenId) == _msgSender() ||
563       isApprovedForAll(prevOwnership.addr, _msgSender()));
564 
565     require(
566       isApprovedOrOwner,
567       "ERC721A: transfer caller is not owner nor approved"
568     );
569 
570     require(
571       prevOwnership.addr == from,
572       "ERC721A: transfer from incorrect owner"
573     );
574     require(to != address(0), "ERC721A: transfer to the zero address");
575 
576     _beforeTokenTransfers(from, to, tokenId, 1); 
577     _approve(address(0), tokenId, prevOwnership.addr);
578 
579     _addressData[from].balance -= 1;
580     _addressData[to].balance += 1;
581     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp)); 
582     uint256 nextTokenId = tokenId + 1;
583     if (_ownerships[nextTokenId].addr == address(0)) {
584       if (_exists(nextTokenId)) {
585         _ownerships[nextTokenId] = TokenOwnership(
586           prevOwnership.addr,
587           prevOwnership.startTimestamp
588         );
589       }
590     }
591 
592     emit Transfer(from, to, tokenId);
593     _afterTokenTransfers(from, to, tokenId, 1);
594   } 
595   function _approve(
596     address to,
597     uint256 tokenId,
598     address owner
599   ) private {
600     _tokenApprovals[tokenId] = to;
601     emit Approval(owner, to, tokenId);
602   }
603 
604   uint256 public nextOwnerToExplicitlySet = 0; 
605   function _setOwnersExplicit(uint256 quantity) internal {
606     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
607     require(quantity > 0, "quantity must be nonzero");
608     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
609     if (endIndex > collectionSize - 1) {
610       endIndex = collectionSize - 1;
611     } 
612     require(_exists(endIndex), "not enough minted yet for this cleanup");
613     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
614       if (_ownerships[i].addr == address(0)) {
615         TokenOwnership memory ownership = ownershipOf(i);
616         _ownerships[i] = TokenOwnership(
617           ownership.addr,
618           ownership.startTimestamp
619         );
620       }
621     }
622     nextOwnerToExplicitlySet = endIndex + 1;
623   } 
624   function _checkOnERC721Received(
625     address from,
626     address to,
627     uint256 tokenId,
628     bytes memory _data
629   ) private returns (bool) {
630     if (to.isContract()) {
631       try
632         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
633       returns (bytes4 retval) {
634         return retval == IERC721Receiver(to).onERC721Received.selector;
635       } catch (bytes memory reason) {
636         if (reason.length == 0) {
637           revert("ERC721A: transfer to non ERC721Receiver implementer");
638         } else {
639           assembly {
640             revert(add(32, reason), mload(reason))
641           }
642         }
643       }
644     } else {
645       return true;
646     }
647   } 
648   function _beforeTokenTransfers(
649     address from,
650     address to,
651     uint256 startTokenId,
652     uint256 quantity
653   ) internal virtual {} 
654   function _afterTokenTransfers(
655     address from,
656     address to,
657     uint256 startTokenId,
658     uint256 quantity
659   ) internal virtual {}
660 }
661 // --------------------------------------------------//
662 
663 contract SpaceHeadz is Ownable, ERC721A, ReentrancyGuard {
664     using Strings for uint256;
665 
666      bytes32 public merkleRoot = 0x6dda27bb24289cd482fe990e245166cbe0ee289047013366bf025558e08fc9ce;
667   function setMerkleRoot(bytes32 m) public onlyOwner{
668     merkleRoot = m;
669   }
670 
671 
672   uint256 public MAX_PER_Transtion = 2; // maximam amount that user can mint
673   uint256 public MAX_PER_Address = 2; // maximam amount that user can mint
674 
675   uint256 public  PRICE = 0.05 ether;
676 
677   uint256 private constant TotalCollectionSize_ = 5555; // total number of nfts
678   uint256 private constant MaxMintPerBatch_ = 50; //max mint per traction
679 
680   bool public _revelNFT = false;
681   string private _baseTokenURI;
682   string private _uriBeforeRevel;
683   uint private stopat = 5555;
684   uint private reserve = 55;
685 
686   uint public status = 0; //0-pause 1-whitelist 2-public
687 
688   mapping(address => bool) private whitelistedAddresses;
689 
690   constructor() ERC721A("Space Headz","SpaceHeadz", MaxMintPerBatch_, TotalCollectionSize_) {
691     _uriBeforeRevel = "ipfs://QmXJXkFTm4u5PUeSubTREAqQW2B4DbvHa8RhDsF3qZExFg/";
692   }
693 
694   modifier callerIsUser() {
695     require(tx.origin == msg.sender, "The caller is another contract");
696     _;
697   }
698  
699   function mint(uint256 quantity) external payable callerIsUser {
700     require(status == 2 , "Sale is not Active");
701     require(totalSupply() + quantity <= collectionSize - reserve, "reached max supply");
702     require( (numberMinted(msg.sender) + quantity <= MAX_PER_Address ) , "Quantity exceeds allowed Mints" );
703     require(  quantity <= MAX_PER_Transtion,"can not mint this many");
704     require(msg.value >= PRICE * quantity, "Need to send more ETH.");
705     _safeMint(msg.sender, quantity);   
706     if(totalSupply() >= stopat) {status = 0;}
707   }
708 
709     function whitelistMint(uint256 quantity, bytes32[] calldata merkleproof) external payable callerIsUser {
710     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
711     require(MerkleProof.verify( merkleproof, merkleRoot, leaf),"Not whitelisted");
712     require(status == 1, "Whitelisting not started");
713     require(totalSupply() + quantity <= TotalCollectionSize_ - reserve, "reached max supply");
714     require( ( numberMinted(msg.sender) + quantity <= MAX_PER_Address ) , "Quantity exceeds allowed Mints" );
715     require(  quantity <= MAX_PER_Transtion,"can not mint this many");
716     require(msg.value >= PRICE * quantity, "Need to send more ETH.");
717     _safeMint(msg.sender, quantity);
718     if(totalSupply() >= stopat) {status = 0;} 
719   }
720 
721 
722 
723    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
724     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
725     if(_revelNFT){
726     string memory baseURI = _baseURI();
727     return
728       bytes(baseURI).length > 0
729         ? string(abi.encodePacked(baseURI, tokenId.toString(),".json"))
730         : "";
731     } else{
732       return _uriBeforeRevel;
733     }
734   }
735 
736   function isWhitelisted(address _user) public view returns (bool) {
737     return whitelistedAddresses[_user];
738   }
739 
740    function conf(uint256 Status , uint256 MaxPerAddress , uint256 MaxPerWallet , uint256 Price, uint256 Stop_At )external onlyOwner{
741       status = Status;
742       stopat = Stop_At;
743       PRICE = Price;
744       MAX_PER_Address = MaxPerAddress;
745       MAX_PER_Transtion = MaxPerWallet;
746   }
747 
748   function setURIbeforeRevel(string memory URI) external onlyOwner {
749     _uriBeforeRevel = URI;
750   }
751 
752   function setBaseURI(string memory baseURI) external onlyOwner {
753     _baseTokenURI = baseURI;
754   }
755   function _baseURI() internal view virtual override returns (string memory) {
756     return _baseTokenURI;
757   }
758   function numberMinted(address owner) public view returns (uint256) {
759     return _numberMinted(owner);
760   }
761   function getOwnershipData(uint256 tokenId)
762     external
763     view
764     returns (TokenOwnership memory)
765   {
766     return ownershipOf(tokenId);
767   }
768   function withdrawMoney() external onlyOwner nonReentrant {
769     (bool success, ) = msg.sender.call{value: address(this).balance}("");
770     require(success, "Transfer failed.");
771   }
772   function changeRevelStatus() external onlyOwner {
773     _revelNFT = !_revelNFT;
774   }
775   function changeMintPrice(uint256 _newPrice) external onlyOwner
776   {
777       PRICE = _newPrice;
778   }
779   function changeMAX_PER_Transtion(uint256 MAXPERTranstion) external onlyOwner
780   {
781       MAX_PER_Transtion = MAXPERTranstion;
782   }
783   function changeMAX_PER_Address(uint256 MAXPERAddress) external onlyOwner
784   {
785       MAX_PER_Address = MAXPERAddress;
786   }
787   function setStatus(uint256 status_)external onlyOwner{
788       status = status_;
789   } 
790   function giveaway(address address_, uint quantity_)public onlyOwner{
791     require(totalSupply() + quantity_ <= collectionSize - reserve, "reached max supply");
792     _safeMint(address_, quantity_);
793   }
794     function setStop(uint256 stopat_)external onlyOwner{
795       stopat = stopat_;
796   }
797   function setReserve(uint256 reserve_)external onlyOwner{
798       reserve = reserve_;
799   }
800 }