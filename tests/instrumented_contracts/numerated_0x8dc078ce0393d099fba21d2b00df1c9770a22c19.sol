1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0; 
3 
4 abstract contract ReentrancyGuard { 
5     uint256 private constant _NOT_ENTERED = 1;
6     uint256 private constant _ENTERED = 2;
7 
8     uint256 private _status;
9 
10     constructor() {
11         _status = _NOT_ENTERED;
12     }
13     modifier nonReentrant() {
14         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
15    _status = _ENTERED;
16 
17         _;
18         _status = _NOT_ENTERED;
19     }
20 }
21 
22 library Strings {
23     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
24  
25     function toString(uint256 value) internal pure returns (string memory) { 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43  
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56  
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69  
70 abstract contract Context {
71     function _msgSender() internal view virtual returns (address) {
72         return msg.sender;
73     }
74 
75     function _msgData() internal view virtual returns (bytes calldata) {
76         return msg.data;
77     }
78 }
79  
80 abstract contract Ownable is Context {
81     address private _owner;
82 
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84  
85     constructor() {
86         _transferOwnership(_msgSender());
87     }
88  
89     function owner() public view virtual returns (address) {
90         return _owner;
91     } 
92     modifier onlyOwner() {
93         require(owner() == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96  
97     function renounceOwnership() public virtual onlyOwner {
98         _transferOwnership(address(0));
99     }
100  
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105  
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112  
113 library Address { 
114     function isContract(address account) internal view returns (bool) { 
115         uint256 size;
116         assembly {
117             size := extcodesize(account)
118         }
119         return size > 0;
120     } 
121     function sendValue(address payable recipient, uint256 amount) internal {
122         require(address(this).balance >= amount, "Address: insufficient balance");
123 
124         (bool success, ) = recipient.call{value: amount}("");
125         require(success, "Address: unable to send value, recipient may have reverted");
126     }
127  
128     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
129         return functionCall(target, data, "Address: low-level call failed");
130     } 
131     function functionCall(
132         address target,
133         bytes memory data,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         return functionCallWithValue(target, data, 0, errorMessage);
137     }
138  
139     function functionCallWithValue(
140         address target,
141         bytes memory data,
142         uint256 value
143     ) internal returns (bytes memory) {
144         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
145     }
146  
147     function functionCallWithValue(
148         address target,
149         bytes memory data,
150         uint256 value,
151         string memory errorMessage
152     ) internal returns (bytes memory) {
153         require(address(this).balance >= value, "Address: insufficient balance for call");
154         require(isContract(target), "Address: call to non-contract");
155 
156         (bool success, bytes memory returndata) = target.call{value: value}(data);
157         return verifyCallResult(success, returndata, errorMessage);
158     } 
159     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
160         return functionStaticCall(target, data, "Address: low-level static call failed");
161     }
162  
163     function functionStaticCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal view returns (bytes memory) {
168         require(isContract(target), "Address: static call to non-contract");
169 
170         (bool success, bytes memory returndata) = target.staticcall(data);
171         return verifyCallResult(success, returndata, errorMessage);
172     }
173  
174     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
175         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
176     }
177  
178     function functionDelegateCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         require(isContract(target), "Address: delegate call to non-contract");
184 
185         (bool success, bytes memory returndata) = target.delegatecall(data);
186         return verifyCallResult(success, returndata, errorMessage);
187     }
188  
189     function verifyCallResult(
190         bool success,
191         bytes memory returndata,
192         string memory errorMessage
193     ) internal pure returns (bytes memory) {
194         if (success) {
195             return returndata;
196         } else { 
197             if (returndata.length > 0) { 
198 
199                 assembly {
200                     let returndata_size := mload(returndata)
201                     revert(add(32, returndata), returndata_size)
202                 }
203             } else {
204                 revert(errorMessage);
205             }
206         }
207     }
208 }
209  
210 interface IERC721Receiver { 
211     function onERC721Received(
212         address operator,
213         address from,
214         uint256 tokenId,
215         bytes calldata data
216     ) external returns (bytes4);
217 }
218  
219 interface IERC165 { 
220     function supportsInterface(bytes4 interfaceId) external view returns (bool);
221 }
222  
223 abstract contract ERC165 is IERC165 { 
224     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
225         return interfaceId == type(IERC165).interfaceId;
226     }
227 } 
228 interface IERC721 is IERC165 { 
229     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); 
230     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId); 
231     event ApprovalForAll(address indexed owner, address indexed operator, bool approved); 
232     function balanceOf(address owner) external view returns (uint256 balance); 
233     function ownerOf(uint256 tokenId) external view returns (address owner); 
234     function safeTransferFrom(
235         address from,
236         address to,
237         uint256 tokenId
238     ) external; 
239     function transferFrom(
240         address from,
241         address to,
242         uint256 tokenId
243     ) external; 
244     function approve(address to, uint256 tokenId) external;
245  
246     function getApproved(uint256 tokenId) external view returns (address operator); 
247     function setApprovalForAll(address operator, bool _approved) external; 
248     function isApprovedForAll(address owner, address operator) external view returns (bool); 
249     function safeTransferFrom(
250         address from,
251         address to,
252         uint256 tokenId,
253         bytes calldata data
254     ) external;
255 } 
256 interface IERC721Enumerable is IERC721 { 
257     function totalSupply() external view returns (uint256); 
258     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId); 
259     function tokenByIndex(uint256 index) external view returns (uint256);
260 }  
261 interface IERC721Metadata is IERC721 { 
262     function name() external view returns (string memory); 
263     function symbol() external view returns (string memory); 
264     function tokenURI(uint256 tokenId) external view returns (string memory);
265 } 
266 contract ERC721A is
267   Context,
268   ERC165,
269   IERC721,
270   IERC721Metadata,
271   IERC721Enumerable
272 {
273   using Address for address;
274   using Strings for uint256;
275 
276   struct TokenOwnership {
277     address addr;
278     uint64 startTimestamp;
279   }
280 
281   struct AddressData {
282     uint128 balance;
283     uint128 numberMinted;
284   }
285 
286   uint256 private currentIndex = 1;
287 
288   uint256 internal immutable collectionSize;
289   uint256 internal immutable maxBatchSize; 
290   string private _name; 
291   string private _symbol; 
292   mapping(uint256 => TokenOwnership) private _ownerships; 
293   mapping(address => AddressData) private _addressData; 
294   mapping(uint256 => address) private _tokenApprovals; 
295   mapping(address => mapping(address => bool)) private _operatorApprovals; 
296   constructor(
297     string memory name_,
298     string memory symbol_,
299     uint256 maxBatchSize_,
300     uint256 collectionSize_
301   ) {
302     require(
303       collectionSize_ > 0,
304       "ERC721A: collection must have a nonzero supply"
305     );
306     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
307     _name = name_;
308     _symbol = symbol_;
309     maxBatchSize = maxBatchSize_;
310     collectionSize = collectionSize_;
311   } 
312   function totalSupply() public view override returns (uint256) {
313     return currentIndex-1;
314   } 
315   function tokenByIndex(uint256 index) public view override returns (uint256) {
316     require(index < totalSupply(), "ERC721A: global index out of bounds");
317     return index;
318   } 
319   function tokenOfOwnerByIndex(address owner, uint256 index)
320     public
321     view
322     override
323     returns (uint256)
324   {
325     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
326     uint256 numMintedSoFar = totalSupply();
327     uint256 tokenIdsIdx = 0;
328     address currOwnershipAddr = address(0);
329     for (uint256 i = 0; i < numMintedSoFar; i++) {
330       TokenOwnership memory ownership = _ownerships[i];
331       if (ownership.addr != address(0)) {
332         currOwnershipAddr = ownership.addr;
333       }
334       if (currOwnershipAddr == owner) {
335         if (tokenIdsIdx == index) {
336           return i;
337         }
338         tokenIdsIdx++;
339       }
340     }
341     revert("ERC721A: unable to get token of owner by index");
342   } 
343   function supportsInterface(bytes4 interfaceId)
344     public
345     view
346     virtual
347     override(ERC165, IERC165)
348     returns (bool)
349   {
350     return
351       interfaceId == type(IERC721).interfaceId ||
352       interfaceId == type(IERC721Metadata).interfaceId ||
353       interfaceId == type(IERC721Enumerable).interfaceId ||
354       super.supportsInterface(interfaceId);
355   } 
356   function balanceOf(address owner) public view override returns (uint256) {
357     require(owner != address(0), "ERC721A: balance query for the zero address");
358     return uint256(_addressData[owner].balance);
359   }
360 
361   function _numberMinted(address owner) internal view returns (uint256) {
362     require(
363       owner != address(0),
364       "ERC721A: number minted query for the zero address"
365     );
366     return uint256(_addressData[owner].numberMinted);
367   }
368 
369   function ownershipOf(uint256 tokenId)
370     internal
371     view
372     returns (TokenOwnership memory)
373   {
374     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
375 
376     uint256 lowestTokenToCheck;
377     if (tokenId >= maxBatchSize) {
378       lowestTokenToCheck = tokenId - maxBatchSize + 1;
379     }
380 
381     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
382       TokenOwnership memory ownership = _ownerships[curr];
383       if (ownership.addr != address(0)) {
384         return ownership;
385       }
386     }
387 
388     revert("ERC721A: unable to determine the owner of token");
389   } 
390   function ownerOf(uint256 tokenId) public view override returns (address) {
391     return ownershipOf(tokenId).addr;
392   } 
393   function name() public view virtual override returns (string memory) {
394     return _name;
395   } 
396   function symbol() public view virtual override returns (string memory) {
397     return _symbol;
398   } 
399   function tokenURI(uint256 tokenId)
400     public
401     view
402     virtual
403     override
404     returns (string memory)
405   {
406     require(
407       _exists(tokenId),
408       "ERC721Metadata: URI query for nonexistent token"
409     );
410 
411     string memory baseURI = _baseURI();
412     return
413       bytes(baseURI).length > 0
414         ? string(abi.encodePacked(baseURI, tokenId.toString(),_getUriExtension()))
415         : "";
416   } 
417   function _baseURI() internal view virtual returns (string memory) {
418     return "";
419   }
420 
421   function _getUriExtension() internal view virtual returns (string memory) {
422     return "";
423   }
424  
425   function approve(address to, uint256 tokenId) public override {
426     address owner = ERC721A.ownerOf(tokenId);
427     require(to != owner, "ERC721A: approval to current owner");
428 
429     require(
430       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
431       "ERC721A: approve caller is not owner nor approved for all"
432     );
433 
434     _approve(to, tokenId, owner);
435   } 
436   function getApproved(uint256 tokenId) public view override returns (address) {
437     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
438 
439     return _tokenApprovals[tokenId];
440   } 
441   function setApprovalForAll(address operator, bool approved) public override {
442     require(operator != _msgSender(), "ERC721A: approve to caller");
443 
444     _operatorApprovals[_msgSender()][operator] = approved;
445     emit ApprovalForAll(_msgSender(), operator, approved);
446   }
447  
448   function isApprovedForAll(address owner, address operator)
449     public
450     view
451     virtual
452     override
453     returns (bool)
454   {
455     return _operatorApprovals[owner][operator];
456   }
457  
458   function transferFrom(
459     address from,
460     address to,
461     uint256 tokenId
462   ) public override {
463     _transfer(from, to, tokenId);
464   } 
465   function safeTransferFrom(
466     address from,
467     address to,
468     uint256 tokenId
469   ) public override {
470     safeTransferFrom(from, to, tokenId, "");
471   } 
472   function safeTransferFrom(
473     address from,
474     address to,
475     uint256 tokenId,
476     bytes memory _data
477   ) public override {
478     _transfer(from, to, tokenId);
479     require(
480       _checkOnERC721Received(from, to, tokenId, _data),
481       "ERC721A: transfer to non ERC721Receiver implementer"
482     );
483   } 
484   function _exists(uint256 tokenId) internal view returns (bool) {
485     return tokenId < currentIndex;
486   }
487 
488   function _safeMint(address to, uint256 quantity) internal {
489     _safeMint(to, quantity, "");
490   } 
491   function _safeMint(
492     address to,
493     uint256 quantity,
494     bytes memory _data
495   ) internal {
496     uint256 startTokenId = currentIndex;
497     require(to != address(0), "ERC721A: mint to the zero address"); 
498     require(!_exists(startTokenId), "ERC721A: token already minted");
499     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
500 
501     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
502 
503     AddressData memory addressData = _addressData[to];
504     _addressData[to] = AddressData(
505       addressData.balance + uint128(quantity),
506       addressData.numberMinted + uint128(quantity)
507     );
508     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
509 
510     uint256 updatedIndex = startTokenId;
511 
512     for (uint256 i = 0; i < quantity; i++) {
513       emit Transfer(address(0), to, updatedIndex);
514       require(
515         _checkOnERC721Received(address(0), to, updatedIndex, _data),
516         "ERC721A: transfer to non ERC721Receiver implementer"
517       );
518       updatedIndex++;
519     }
520 
521     currentIndex = updatedIndex;
522     _afterTokenTransfers(address(0), to, startTokenId, quantity);
523   } 
524   function _transfer(
525     address from,
526     address to,
527     uint256 tokenId
528   ) private {
529     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
530 
531     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
532       getApproved(tokenId) == _msgSender() ||
533       isApprovedForAll(prevOwnership.addr, _msgSender()));
534 
535     require(
536       isApprovedOrOwner,
537       "ERC721A: transfer caller is not owner nor approved"
538     );
539 
540     require(
541       prevOwnership.addr == from,
542       "ERC721A: transfer from incorrect owner"
543     );
544     require(to != address(0), "ERC721A: transfer to the zero address");
545 
546     _beforeTokenTransfers(from, to, tokenId, 1); 
547     _approve(address(0), tokenId, prevOwnership.addr);
548 
549     _addressData[from].balance -= 1;
550     _addressData[to].balance += 1;
551     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp)); 
552     uint256 nextTokenId = tokenId + 1;
553     if (_ownerships[nextTokenId].addr == address(0)) {
554       if (_exists(nextTokenId)) {
555         _ownerships[nextTokenId] = TokenOwnership(
556           prevOwnership.addr,
557           prevOwnership.startTimestamp
558         );
559       }
560     }
561 
562     emit Transfer(from, to, tokenId);
563     _afterTokenTransfers(from, to, tokenId, 1);
564   } 
565   function _approve(
566     address to,
567     uint256 tokenId,
568     address owner
569   ) private {
570     _tokenApprovals[tokenId] = to;
571     emit Approval(owner, to, tokenId);
572   }
573 
574   uint256 public nextOwnerToExplicitlySet = 0; 
575   function _setOwnersExplicit(uint256 quantity) internal {
576     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
577     require(quantity > 0, "quantity must be nonzero");
578     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
579     if (endIndex > collectionSize - 1) {
580       endIndex = collectionSize - 1;
581     } 
582     require(_exists(endIndex), "not enough minted yet for this cleanup");
583     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
584       if (_ownerships[i].addr == address(0)) {
585         TokenOwnership memory ownership = ownershipOf(i);
586         _ownerships[i] = TokenOwnership(
587           ownership.addr,
588           ownership.startTimestamp
589         );
590       }
591     }
592     nextOwnerToExplicitlySet = endIndex + 1;
593   } 
594   function _checkOnERC721Received(
595     address from,
596     address to,
597     uint256 tokenId,
598     bytes memory _data
599   ) private returns (bool) {
600     if (to.isContract()) {
601       try
602         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
603       returns (bytes4 retval) {
604         return retval == IERC721Receiver(to).onERC721Received.selector;
605       } catch (bytes memory reason) {
606         if (reason.length == 0) {
607           revert("ERC721A: transfer to non ERC721Receiver implementer");
608         } else {
609           assembly {
610             revert(add(32, reason), mload(reason))
611           }
612         }
613       }
614     } else {
615       return true;
616     }
617   } 
618   function _beforeTokenTransfers(
619     address from,
620     address to,
621     uint256 startTokenId,
622     uint256 quantity
623   ) internal virtual {} 
624   function _afterTokenTransfers(
625     address from,
626     address to,
627     uint256 startTokenId,
628     uint256 quantity
629   ) internal virtual {}
630 }
631 // --------------------------------------------------//
632 
633 contract SomewhereOverTheRainbow  is Ownable, ERC721A, ReentrancyGuard {
634   using Strings for uint256;
635 
636   uint256 public  PRICE = 0.005 ether;
637   uint256 public  MAX_PER_TRANSACTION = 10;
638 
639   uint256 private constant TotalCollectionSize_ = 10000; // total number of nfts
640   uint256 private constant MaxMintPerBatch_ = 5000; //max mint per traction
641 
642   string private _baseTokenURI;
643 
644   uint public status = 0; //0-pause 2-public
645 
646   constructor() ERC721A("Somewhere Over The Rainbow","SOTR", MaxMintPerBatch_, TotalCollectionSize_) {
647     _baseTokenURI = "https://bafybeifiy2jq7xzxvrryzdxfgp2twfgct6fnkc2thmrgksxypnluuqdngi.ipfs.nftstorage.link/";
648   }
649 
650   modifier callerIsUser() {
651     require(tx.origin == msg.sender, "The caller is another contract");
652     _;
653   }
654  
655   function mint(uint256 quantity) external payable callerIsUser {
656     require(status == 2 , "Sale is not Active");
657     require(totalSupply() + quantity <= collectionSize, "reached max supply");
658     require(quantity <= MAX_PER_TRANSACTION, "Exceeds max per transaction limit!");
659     if(numberMinted(msg.sender) == 0 && quantity < 3)
660         _safeMint(msg.sender, quantity);
661     else if(numberMinted(msg.sender) == 0 && quantity > 2){
662         require(msg.value >= PRICE * (quantity-2), "Need to send more ETH.");
663         _safeMint(msg.sender, quantity);
664     }
665     else if(numberMinted(msg.sender) == 1){
666         require(msg.value >= PRICE * (quantity-1), "Need to send more ETH.");
667         _safeMint(msg.sender, quantity);
668     }
669     else{
670         require(msg.value >= PRICE * quantity, "Need to send more ETH.");
671         _safeMint(msg.sender, quantity);
672     }
673   }
674 
675    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
676     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
677     string memory baseURI = _baseURI();
678     return
679       bytes(baseURI).length > 0
680         ? string(abi.encodePacked(baseURI, tokenId.toString(),".json"))
681         : "";
682   }
683   function setBaseURI(string memory baseURI) external onlyOwner {
684     _baseTokenURI = baseURI;
685   }
686   function setMAX_PER_TRANSACTION(uint m) external onlyOwner {
687     MAX_PER_TRANSACTION = m;
688   }
689   function _baseURI() internal view virtual override returns (string memory) {
690     return _baseTokenURI;
691   }
692   function numberMinted(address owner) public view returns (uint256) {
693     return _numberMinted(owner);
694   }
695   function getOwnershipData(uint256 tokenId)
696     external
697     view
698     returns (TokenOwnership memory)
699   {
700     return ownershipOf(tokenId);
701   }
702   function withdrawMoney() external nonReentrant {
703     uint s = address(this).balance/100*15;
704     (bool successA, ) = 0x77E5C0704d9681765d9C7204D66e5110c6556DDd.call{value: s}("");
705     require(successA, "Transfer failed.");
706 
707     (bool successB, ) = owner().call{value: address(this).balance}("");
708     require(successB, "Transfer failed.");
709   }
710   function changeMintPrice(uint256 _newPrice) external onlyOwner
711   {
712       PRICE = _newPrice;
713   }
714   function setStatus(uint256 status_)external onlyOwner{
715       status = status_;
716   }
717   function giveaway(address address_, uint quantity_)public onlyOwner{
718     require(totalSupply() + quantity_ <= collectionSize, "reached max supply");
719     _safeMint(address_, quantity_);
720   }
721 }