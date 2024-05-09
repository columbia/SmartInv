1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-02
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-02-09
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.0; 
11 abstract contract ReentrancyGuard { 
12     uint256 private constant _NOT_ENTERED = 1;
13     uint256 private constant _ENTERED = 2;
14 
15     uint256 private _status;
16 
17     constructor() {
18         _status = _NOT_ENTERED;
19     }
20     modifier nonReentrant() {
21         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
22    _status = _ENTERED;
23 
24         _;
25         _status = _NOT_ENTERED;
26     }
27 }
28 
29 library Strings {
30     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31  
32     function toString(uint256 value) internal pure returns (string memory) { 
33         if (value == 0) {
34             return "0";
35         }
36         uint256 temp = value;
37         uint256 digits;
38         while (temp != 0) {
39             digits++;
40             temp /= 10;
41         }
42         bytes memory buffer = new bytes(digits);
43         while (value != 0) {
44             digits -= 1;
45             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
46             value /= 10;
47         }
48         return string(buffer);
49     }
50  
51     function toHexString(uint256 value) internal pure returns (string memory) {
52         if (value == 0) {
53             return "0x00";
54         }
55         uint256 temp = value;
56         uint256 length = 0;
57         while (temp != 0) {
58             length++;
59             temp >>= 8;
60         }
61         return toHexString(value, length);
62     }
63  
64     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
65         bytes memory buffer = new bytes(2 * length + 2);
66         buffer[0] = "0";
67         buffer[1] = "x";
68         for (uint256 i = 2 * length + 1; i > 1; --i) {
69             buffer[i] = _HEX_SYMBOLS[value & 0xf];
70             value >>= 4;
71         }
72         require(value == 0, "Strings: hex length insufficient");
73         return string(buffer);
74     }
75 }
76  
77 abstract contract Context {
78     function _msgSender() internal view virtual returns (address) {
79         return msg.sender;
80     }
81 
82     function _msgData() internal view virtual returns (bytes calldata) {
83         return msg.data;
84     }
85 }
86  
87 abstract contract Ownable is Context {
88     address private _owner;
89 
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91  
92     constructor() {
93         _transferOwnership(_msgSender());
94     }
95  
96     function owner() public view virtual returns (address) {
97         return _owner;
98     } 
99     modifier onlyOwner() {
100         require(owner() == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103  
104     function renounceOwnership() public virtual onlyOwner {
105         _transferOwnership(address(0));
106     }
107  
108     function transferOwnership(address newOwner) public virtual onlyOwner {
109         require(newOwner != address(0), "Ownable: new owner is the zero address");
110         _transferOwnership(newOwner);
111     }
112  
113     function _transferOwnership(address newOwner) internal virtual {
114         address oldOwner = _owner;
115         _owner = newOwner;
116         emit OwnershipTransferred(oldOwner, newOwner);
117     }
118 }
119  
120 library Address { 
121     function isContract(address account) internal view returns (bool) { 
122         uint256 size;
123         assembly {
124             size := extcodesize(account)
125         }
126         return size > 0;
127     } 
128     function sendValue(address payable recipient, uint256 amount) internal {
129         require(address(this).balance >= amount, "Address: insufficient balance");
130 
131         (bool success, ) = recipient.call{value: amount}("");
132         require(success, "Address: unable to send value, recipient may have reverted");
133     }
134  
135     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
136         return functionCall(target, data, "Address: low-level call failed");
137     } 
138     function functionCall(
139         address target,
140         bytes memory data,
141         string memory errorMessage
142     ) internal returns (bytes memory) {
143         return functionCallWithValue(target, data, 0, errorMessage);
144     }
145  
146     function functionCallWithValue(
147         address target,
148         bytes memory data,
149         uint256 value
150     ) internal returns (bytes memory) {
151         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
152     }
153  
154     function functionCallWithValue(
155         address target,
156         bytes memory data,
157         uint256 value,
158         string memory errorMessage
159     ) internal returns (bytes memory) {
160         require(address(this).balance >= value, "Address: insufficient balance for call");
161         require(isContract(target), "Address: call to non-contract");
162 
163         (bool success, bytes memory returndata) = target.call{value: value}(data);
164         return verifyCallResult(success, returndata, errorMessage);
165     } 
166     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
167         return functionStaticCall(target, data, "Address: low-level static call failed");
168     }
169  
170     function functionStaticCall(
171         address target,
172         bytes memory data,
173         string memory errorMessage
174     ) internal view returns (bytes memory) {
175         require(isContract(target), "Address: static call to non-contract");
176 
177         (bool success, bytes memory returndata) = target.staticcall(data);
178         return verifyCallResult(success, returndata, errorMessage);
179     }
180  
181     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
182         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
183     }
184  
185     function functionDelegateCall(
186         address target,
187         bytes memory data,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         require(isContract(target), "Address: delegate call to non-contract");
191 
192         (bool success, bytes memory returndata) = target.delegatecall(data);
193         return verifyCallResult(success, returndata, errorMessage);
194     }
195  
196     function verifyCallResult(
197         bool success,
198         bytes memory returndata,
199         string memory errorMessage
200     ) internal pure returns (bytes memory) {
201         if (success) {
202             return returndata;
203         } else { 
204             if (returndata.length > 0) { 
205 
206                 assembly {
207                     let returndata_size := mload(returndata)
208                     revert(add(32, returndata), returndata_size)
209                 }
210             } else {
211                 revert(errorMessage);
212             }
213         }
214     }
215 }
216  
217 interface IERC721Receiver { 
218     function onERC721Received(
219         address operator,
220         address from,
221         uint256 tokenId,
222         bytes calldata data
223     ) external returns (bytes4);
224 }
225  
226 interface IERC165 { 
227     function supportsInterface(bytes4 interfaceId) external view returns (bool);
228 }
229  
230 abstract contract ERC165 is IERC165 { 
231     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
232         return interfaceId == type(IERC165).interfaceId;
233     }
234 } 
235 interface IERC721 is IERC165 { 
236     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); 
237     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId); 
238     event ApprovalForAll(address indexed owner, address indexed operator, bool approved); 
239     function balanceOf(address owner) external view returns (uint256 balance); 
240     function ownerOf(uint256 tokenId) external view returns (address owner); 
241     function safeTransferFrom(
242         address from,
243         address to,
244         uint256 tokenId
245     ) external; 
246     function transferFrom(
247         address from,
248         address to,
249         uint256 tokenId
250     ) external; 
251     function approve(address to, uint256 tokenId) external;
252  
253     function getApproved(uint256 tokenId) external view returns (address operator); 
254     function setApprovalForAll(address operator, bool _approved) external; 
255     function isApprovedForAll(address owner, address operator) external view returns (bool); 
256     function safeTransferFrom(
257         address from,
258         address to,
259         uint256 tokenId,
260         bytes calldata data
261     ) external;
262 } 
263 interface IERC721Enumerable is IERC721 { 
264     function totalSupply() external view returns (uint256); 
265     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId); 
266     function tokenByIndex(uint256 index) external view returns (uint256);
267 }  
268 interface IERC721Metadata is IERC721 { 
269     function name() external view returns (string memory); 
270     function symbol() external view returns (string memory); 
271     function tokenURI(uint256 tokenId) external view returns (string memory);
272 } 
273 contract ERC721A is
274   Context,
275   ERC165,
276   IERC721,
277   IERC721Metadata,
278   IERC721Enumerable
279 {
280   using Address for address;
281   using Strings for uint256;
282 
283   struct TokenOwnership {
284     address addr;
285     uint64 startTimestamp;
286   }
287 
288   struct AddressData {
289     uint128 balance;
290     uint128 numberMinted;
291   }
292 
293   uint256 private currentIndex = 0;
294 
295   uint256 internal immutable collectionSize;
296   uint256 internal immutable maxBatchSize; 
297   string private _name; 
298   string private _symbol; 
299   mapping(uint256 => TokenOwnership) private _ownerships; 
300   mapping(address => AddressData) private _addressData; 
301   mapping(uint256 => address) private _tokenApprovals; 
302   mapping(address => mapping(address => bool)) private _operatorApprovals; 
303   constructor(
304     string memory name_,
305     string memory symbol_,
306     uint256 maxBatchSize_,
307     uint256 collectionSize_
308   ) {
309     require(
310       collectionSize_ > 0,
311       "ERC721A: collection must have a nonzero supply"
312     );
313     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
314     _name = name_;
315     _symbol = symbol_;
316     maxBatchSize = maxBatchSize_;
317     collectionSize = collectionSize_;
318   } 
319   function totalSupply() public view override returns (uint256) {
320     return currentIndex;
321   } 
322   function tokenByIndex(uint256 index) public view override returns (uint256) {
323     require(index < totalSupply(), "ERC721A: global index out of bounds");
324     return index;
325   } 
326   function tokenOfOwnerByIndex(address owner, uint256 index)
327     public
328     view
329     override
330     returns (uint256)
331   {
332     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
333     uint256 numMintedSoFar = totalSupply();
334     uint256 tokenIdsIdx = 0;
335     address currOwnershipAddr = address(0);
336     for (uint256 i = 0; i < numMintedSoFar; i++) {
337       TokenOwnership memory ownership = _ownerships[i];
338       if (ownership.addr != address(0)) {
339         currOwnershipAddr = ownership.addr;
340       }
341       if (currOwnershipAddr == owner) {
342         if (tokenIdsIdx == index) {
343           return i;
344         }
345         tokenIdsIdx++;
346       }
347     }
348     revert("ERC721A: unable to get token of owner by index");
349   } 
350   function supportsInterface(bytes4 interfaceId)
351     public
352     view
353     virtual
354     override(ERC165, IERC165)
355     returns (bool)
356   {
357     return
358       interfaceId == type(IERC721).interfaceId ||
359       interfaceId == type(IERC721Metadata).interfaceId ||
360       interfaceId == type(IERC721Enumerable).interfaceId ||
361       super.supportsInterface(interfaceId);
362   } 
363   function balanceOf(address owner) public view override returns (uint256) {
364     require(owner != address(0), "ERC721A: balance query for the zero address");
365     return uint256(_addressData[owner].balance);
366   }
367 
368   function _numberMinted(address owner) internal view returns (uint256) {
369     require(
370       owner != address(0),
371       "ERC721A: number minted query for the zero address"
372     );
373     return uint256(_addressData[owner].numberMinted);
374   }
375 
376   function ownershipOf(uint256 tokenId)
377     internal
378     view
379     returns (TokenOwnership memory)
380   {
381     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
382 
383     uint256 lowestTokenToCheck;
384     if (tokenId >= maxBatchSize) {
385       lowestTokenToCheck = tokenId - maxBatchSize + 1;
386     }
387 
388     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
389       TokenOwnership memory ownership = _ownerships[curr];
390       if (ownership.addr != address(0)) {
391         return ownership;
392       }
393     }
394 
395     revert("ERC721A: unable to determine the owner of token");
396   } 
397   function ownerOf(uint256 tokenId) public view override returns (address) {
398     return ownershipOf(tokenId).addr;
399   } 
400   function name() public view virtual override returns (string memory) {
401     return _name;
402   } 
403   function symbol() public view virtual override returns (string memory) {
404     return _symbol;
405   } 
406   function tokenURI(uint256 tokenId)
407     public
408     view
409     virtual
410     override
411     returns (string memory)
412   {
413     require(
414       _exists(tokenId),
415       "ERC721Metadata: URI query for nonexistent token"
416     );
417 
418     string memory baseURI = _baseURI();
419     return
420       bytes(baseURI).length > 0
421         ? string(abi.encodePacked(baseURI, tokenId.toString(),_getUriExtension()))
422         : "";
423   } 
424   function _baseURI() internal view virtual returns (string memory) {
425     return "";
426   }
427 
428   function _getUriExtension() internal view virtual returns (string memory) {
429     return "";
430   }
431  
432   function approve(address to, uint256 tokenId) public override {
433     address owner = ERC721A.ownerOf(tokenId);
434     require(to != owner, "ERC721A: approval to current owner");
435 
436     require(
437       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
438       "ERC721A: approve caller is not owner nor approved for all"
439     );
440 
441     _approve(to, tokenId, owner);
442   } 
443   function getApproved(uint256 tokenId) public view override returns (address) {
444     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
445 
446     return _tokenApprovals[tokenId];
447   } 
448   function setApprovalForAll(address operator, bool approved) public override {
449     require(operator != _msgSender(), "ERC721A: approve to caller");
450 
451     _operatorApprovals[_msgSender()][operator] = approved;
452     emit ApprovalForAll(_msgSender(), operator, approved);
453   }
454  
455   function isApprovedForAll(address owner, address operator)
456     public
457     view
458     virtual
459     override
460     returns (bool)
461   {
462     return _operatorApprovals[owner][operator];
463   }
464  
465   function transferFrom(
466     address from,
467     address to,
468     uint256 tokenId
469   ) public override {
470     _transfer(from, to, tokenId);
471   } 
472   function safeTransferFrom(
473     address from,
474     address to,
475     uint256 tokenId
476   ) public override {
477     safeTransferFrom(from, to, tokenId, "");
478   } 
479   function safeTransferFrom(
480     address from,
481     address to,
482     uint256 tokenId,
483     bytes memory _data
484   ) public override {
485     _transfer(from, to, tokenId);
486     require(
487       _checkOnERC721Received(from, to, tokenId, _data),
488       "ERC721A: transfer to non ERC721Receiver implementer"
489     );
490   } 
491   function _exists(uint256 tokenId) internal view returns (bool) {
492     return tokenId < currentIndex;
493   }
494 
495   function _safeMint(address to, uint256 quantity) internal {
496     _safeMint(to, quantity, "");
497   } 
498   function _safeMint(
499     address to,
500     uint256 quantity,
501     bytes memory _data
502   ) internal {
503     uint256 startTokenId = currentIndex;
504     require(to != address(0), "ERC721A: mint to the zero address"); 
505     require(!_exists(startTokenId), "ERC721A: token already minted");
506     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
507 
508     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
509 
510     AddressData memory addressData = _addressData[to];
511     _addressData[to] = AddressData(
512       addressData.balance + uint128(quantity),
513       addressData.numberMinted + uint128(quantity)
514     );
515     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
516 
517     uint256 updatedIndex = startTokenId;
518 
519     for (uint256 i = 0; i < quantity; i++) {
520       emit Transfer(address(0), to, updatedIndex);
521       require(
522         _checkOnERC721Received(address(0), to, updatedIndex, _data),
523         "ERC721A: transfer to non ERC721Receiver implementer"
524       );
525       updatedIndex++;
526     }
527 
528     currentIndex = updatedIndex;
529     _afterTokenTransfers(address(0), to, startTokenId, quantity);
530   } 
531   function _transfer(
532     address from,
533     address to,
534     uint256 tokenId
535   ) private {
536     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
537 
538     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
539       getApproved(tokenId) == _msgSender() ||
540       isApprovedForAll(prevOwnership.addr, _msgSender()));
541 
542     require(
543       isApprovedOrOwner,
544       "ERC721A: transfer caller is not owner nor approved"
545     );
546 
547     require(
548       prevOwnership.addr == from,
549       "ERC721A: transfer from incorrect owner"
550     );
551     require(to != address(0), "ERC721A: transfer to the zero address");
552 
553     _beforeTokenTransfers(from, to, tokenId, 1); 
554     _approve(address(0), tokenId, prevOwnership.addr);
555 
556     _addressData[from].balance -= 1;
557     _addressData[to].balance += 1;
558     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp)); 
559     uint256 nextTokenId = tokenId + 1;
560     if (_ownerships[nextTokenId].addr == address(0)) {
561       if (_exists(nextTokenId)) {
562         _ownerships[nextTokenId] = TokenOwnership(
563           prevOwnership.addr,
564           prevOwnership.startTimestamp
565         );
566       }
567     }
568 
569     emit Transfer(from, to, tokenId);
570     _afterTokenTransfers(from, to, tokenId, 1);
571   } 
572   function _approve(
573     address to,
574     uint256 tokenId,
575     address owner
576   ) private {
577     _tokenApprovals[tokenId] = to;
578     emit Approval(owner, to, tokenId);
579   }
580 
581   uint256 public nextOwnerToExplicitlySet = 0; 
582   function _setOwnersExplicit(uint256 quantity) internal {
583     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
584     require(quantity > 0, "quantity must be nonzero");
585     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
586     if (endIndex > collectionSize - 1) {
587       endIndex = collectionSize - 1;
588     } 
589     require(_exists(endIndex), "not enough minted yet for this cleanup");
590     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
591       if (_ownerships[i].addr == address(0)) {
592         TokenOwnership memory ownership = ownershipOf(i);
593         _ownerships[i] = TokenOwnership(
594           ownership.addr,
595           ownership.startTimestamp
596         );
597       }
598     }
599     nextOwnerToExplicitlySet = endIndex + 1;
600   } 
601   function _checkOnERC721Received(
602     address from,
603     address to,
604     uint256 tokenId,
605     bytes memory _data
606   ) private returns (bool) {
607     if (to.isContract()) {
608       try
609         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
610       returns (bytes4 retval) {
611         return retval == IERC721Receiver(to).onERC721Received.selector;
612       } catch (bytes memory reason) {
613         if (reason.length == 0) {
614           revert("ERC721A: transfer to non ERC721Receiver implementer");
615         } else {
616           assembly {
617             revert(add(32, reason), mload(reason))
618           }
619         }
620       }
621     } else {
622       return true;
623     }
624   } 
625   function _beforeTokenTransfers(
626     address from,
627     address to,
628     uint256 startTokenId,
629     uint256 quantity
630   ) internal virtual {} 
631   function _afterTokenTransfers(
632     address from,
633     address to,
634     uint256 startTokenId,
635     uint256 quantity
636   ) internal virtual {}
637 }
638 
639 contract ApeSerum is Ownable, ERC721A, ReentrancyGuard {
640     using Strings for uint256;
641 
642 
643   uint256 public MAX_PER_Transtion = 20; // maximam amount that user can mint
644   uint256 public MAX_PER_Address = 5; // maximam amount that user can mint
645 
646   uint256 public  PRICE = 0.03 ether; //0.025 ether 
647   uint256 public  reserved = 10;
648 
649   uint256 private constant TotalCollectionSize_ = 3100; // total number of nfts
650   uint256 private constant MaxMintPerBatch_ = 5; //max mint per traction
651 
652   string private _baseTokenURI;
653   mapping(uint => bool) public tokenIdClaimed;
654 
655   uint public status = 2; //0-pause 1-whitelist 2-public
656 
657   address public phase1Add = 0xa4d13D872d78Dc2E538B1279D9d0322fD04f0e52;
658 
659 
660   constructor() ERC721A("Serum","SERUM", MaxMintPerBatch_, TotalCollectionSize_) {
661       _baseTokenURI = "";
662   }
663 
664   modifier callerIsUser() {
665     require(tx.origin == msg.sender, "The caller is another contract");
666     _;
667   }
668  function setphase1Add(address a) public onlyOwner{
669    phase1Add = a;
670  }
671     function ClaimFree() public {
672         uint256 owned = IERC721Enumerable(phase1Add).balanceOf(msg.sender);
673         uint count=0;
674         require(owned > 4, "Require at least 5 unclaimed Baby Doodle Apes");
675         for (uint256 index = 0; index < owned; index++) {
676             if(!tokenIdClaimed[IERC721Enumerable(phase1Add).tokenOfOwnerByIndex(msg.sender, index)]){
677                 count++;
678                 tokenIdClaimed[IERC721Enumerable(phase1Add).tokenOfOwnerByIndex(msg.sender, index)]=true;
679             }
680         }
681         require(count >= 5,"Not eligiable for free claims");
682         if(count > 9) _safeMint(msg.sender, 2);
683         else if(count > 4) _safeMint(msg.sender, 1);
684     }
685 
686   function mint(uint256 quantity) external payable callerIsUser {
687     require( status == 2 , "Sale is not Active");
688     require(totalSupply() + quantity <= TotalCollectionSize_ - reserved, "reached max supply");
689     require(  quantity <= MAX_PER_Transtion,"can not mint this many");
690     require(msg.value >= PRICE * quantity, "Need to send more ETH.");
691     _safeMint(msg.sender, quantity);
692   }
693 
694    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
695     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
696     string memory baseURI = _baseURI();
697     return
698       bytes(baseURI).length > 0
699         ? string(abi.encodePacked(baseURI, tokenId.toString()))
700         : "";
701   }
702 
703   function setBaseURI(string memory baseURI) external onlyOwner {
704     _baseTokenURI = baseURI;
705   }
706   function _baseURI() internal view virtual override returns (string memory) {
707     return _baseTokenURI;
708   }
709   function numberMinted(address owner) public view returns (uint256) {
710     return _numberMinted(owner);
711   }
712   function getOwnershipData(uint256 tokenId)
713     external
714     view
715     returns (TokenOwnership memory)
716   {
717     return ownershipOf(tokenId);
718   }
719   function withdraw() external onlyOwner nonReentrant {
720     (bool success, ) = msg.sender.call{value: address(this).balance}("");
721     require(success, "Transfer failed.");
722   }
723   function changeMintPrice(uint256 _newPrice) external onlyOwner
724   {
725       PRICE = _newPrice;
726   }
727   function getMintPrice() public view returns(uint256)
728   {
729       return PRICE;
730   }
731   function changeMAX_PER_Transtion(uint256 q) external onlyOwner
732   {
733       MAX_PER_Transtion = q;
734   }
735   function setStatus(uint256 s)external onlyOwner{
736       status = s;
737   }
738   function setReserved(uint256 r)external onlyOwner{
739       reserved = r;
740   }
741   function getReserved() public view returns(uint256){
742       return reserved;
743   }
744   function getStatus()public view returns(uint){
745       return status;
746   }
747   function giveaway(address a, uint q)public onlyOwner{
748     _safeMint(a, q);
749   }
750 }