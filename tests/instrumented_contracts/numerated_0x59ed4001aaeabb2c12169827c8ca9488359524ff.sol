1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-09
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0; 
7 abstract contract ReentrancyGuard { 
8     uint256 private constant _NOT_ENTERED = 1;
9     uint256 private constant _ENTERED = 2;
10 
11     uint256 private _status;
12 
13     constructor() {
14         _status = _NOT_ENTERED;
15     }
16     modifier nonReentrant() {
17         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
18    _status = _ENTERED;
19 
20         _;
21         _status = _NOT_ENTERED;
22     }
23 }
24 
25 library Strings {
26     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
27  
28     function toString(uint256 value) internal pure returns (string memory) { 
29         if (value == 0) {
30             return "0";
31         }
32         uint256 temp = value;
33         uint256 digits;
34         while (temp != 0) {
35             digits++;
36             temp /= 10;
37         }
38         bytes memory buffer = new bytes(digits);
39         while (value != 0) {
40             digits -= 1;
41             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
42             value /= 10;
43         }
44         return string(buffer);
45     }
46  
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59  
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72  
73 abstract contract Context {
74     function _msgSender() internal view virtual returns (address) {
75         return msg.sender;
76     }
77 
78     function _msgData() internal view virtual returns (bytes calldata) {
79         return msg.data;
80     }
81 }
82  
83 abstract contract Ownable is Context {
84     address private _owner;
85 
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87  
88     constructor() {
89         _transferOwnership(_msgSender());
90     }
91  
92     function owner() public view virtual returns (address) {
93         return _owner;
94     } 
95     modifier onlyOwner() {
96         require(owner() == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99  
100     function renounceOwnership() public virtual onlyOwner {
101         _transferOwnership(address(0));
102     }
103  
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         _transferOwnership(newOwner);
107     }
108  
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115  
116 library Address { 
117     function isContract(address account) internal view returns (bool) { 
118         uint256 size;
119         assembly {
120             size := extcodesize(account)
121         }
122         return size > 0;
123     } 
124     function sendValue(address payable recipient, uint256 amount) internal {
125         require(address(this).balance >= amount, "Address: insufficient balance");
126 
127         (bool success, ) = recipient.call{value: amount}("");
128         require(success, "Address: unable to send value, recipient may have reverted");
129     }
130  
131     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
132         return functionCall(target, data, "Address: low-level call failed");
133     } 
134     function functionCall(
135         address target,
136         bytes memory data,
137         string memory errorMessage
138     ) internal returns (bytes memory) {
139         return functionCallWithValue(target, data, 0, errorMessage);
140     }
141  
142     function functionCallWithValue(
143         address target,
144         bytes memory data,
145         uint256 value
146     ) internal returns (bytes memory) {
147         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
148     }
149  
150     function functionCallWithValue(
151         address target,
152         bytes memory data,
153         uint256 value,
154         string memory errorMessage
155     ) internal returns (bytes memory) {
156         require(address(this).balance >= value, "Address: insufficient balance for call");
157         require(isContract(target), "Address: call to non-contract");
158 
159         (bool success, bytes memory returndata) = target.call{value: value}(data);
160         return verifyCallResult(success, returndata, errorMessage);
161     } 
162     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
163         return functionStaticCall(target, data, "Address: low-level static call failed");
164     }
165  
166     function functionStaticCall(
167         address target,
168         bytes memory data,
169         string memory errorMessage
170     ) internal view returns (bytes memory) {
171         require(isContract(target), "Address: static call to non-contract");
172 
173         (bool success, bytes memory returndata) = target.staticcall(data);
174         return verifyCallResult(success, returndata, errorMessage);
175     }
176  
177     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
179     }
180  
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
191  
192     function verifyCallResult(
193         bool success,
194         bytes memory returndata,
195         string memory errorMessage
196     ) internal pure returns (bytes memory) {
197         if (success) {
198             return returndata;
199         } else { 
200             if (returndata.length > 0) { 
201 
202                 assembly {
203                     let returndata_size := mload(returndata)
204                     revert(add(32, returndata), returndata_size)
205                 }
206             } else {
207                 revert(errorMessage);
208             }
209         }
210     }
211 }
212  
213 interface IERC721Receiver { 
214     function onERC721Received(
215         address operator,
216         address from,
217         uint256 tokenId,
218         bytes calldata data
219     ) external returns (bytes4);
220 }
221  
222 interface IERC165 { 
223     function supportsInterface(bytes4 interfaceId) external view returns (bool);
224 }
225  
226 abstract contract ERC165 is IERC165 { 
227     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
228         return interfaceId == type(IERC165).interfaceId;
229     }
230 } 
231 interface IERC721 is IERC165 { 
232     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); 
233     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId); 
234     event ApprovalForAll(address indexed owner, address indexed operator, bool approved); 
235     function balanceOf(address owner) external view returns (uint256 balance); 
236     function ownerOf(uint256 tokenId) external view returns (address owner); 
237     function safeTransferFrom(
238         address from,
239         address to,
240         uint256 tokenId
241     ) external; 
242     function transferFrom(
243         address from,
244         address to,
245         uint256 tokenId
246     ) external; 
247     function approve(address to, uint256 tokenId) external;
248  
249     function getApproved(uint256 tokenId) external view returns (address operator); 
250     function setApprovalForAll(address operator, bool _approved) external; 
251     function isApprovedForAll(address owner, address operator) external view returns (bool); 
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 tokenId,
256         bytes calldata data
257     ) external;
258 } 
259 interface IERC721Enumerable is IERC721 { 
260     function totalSupply() external view returns (uint256); 
261     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId); 
262     function tokenByIndex(uint256 index) external view returns (uint256);
263 }  
264 interface IERC721Metadata is IERC721 { 
265     function name() external view returns (string memory); 
266     function symbol() external view returns (string memory); 
267     function tokenURI(uint256 tokenId) external view returns (string memory);
268 } 
269 contract ERC721A is
270   Context,
271   ERC165,
272   IERC721,
273   IERC721Metadata,
274   IERC721Enumerable
275 {
276   using Address for address;
277   using Strings for uint256;
278 
279   struct TokenOwnership {
280     address addr;
281     uint64 startTimestamp;
282   }
283 
284   struct AddressData {
285     uint128 balance;
286     uint128 numberMinted;
287   }
288 
289   uint256 private currentIndex = 0;
290 
291   uint256 internal immutable collectionSize;
292   uint256 internal immutable maxBatchSize; 
293   string private _name; 
294   string private _symbol; 
295   mapping(uint256 => TokenOwnership) private _ownerships; 
296   mapping(address => AddressData) private _addressData; 
297   mapping(uint256 => address) private _tokenApprovals; 
298   mapping(address => mapping(address => bool)) private _operatorApprovals; 
299   constructor(
300     string memory name_,
301     string memory symbol_,
302     uint256 maxBatchSize_,
303     uint256 collectionSize_
304   ) {
305     require(
306       collectionSize_ > 0,
307       "ERC721A: collection must have a nonzero supply"
308     );
309     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
310     _name = name_;
311     _symbol = symbol_;
312     maxBatchSize = maxBatchSize_;
313     collectionSize = collectionSize_;
314   } 
315   function totalSupply() public view override returns (uint256) {
316     return currentIndex;
317   } 
318   function tokenByIndex(uint256 index) public view override returns (uint256) {
319     require(index < totalSupply(), "ERC721A: global index out of bounds");
320     return index;
321   } 
322   function tokenOfOwnerByIndex(address owner, uint256 index)
323     public
324     view
325     override
326     returns (uint256)
327   {
328     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
329     uint256 numMintedSoFar = totalSupply();
330     uint256 tokenIdsIdx = 0;
331     address currOwnershipAddr = address(0);
332     for (uint256 i = 0; i < numMintedSoFar; i++) {
333       TokenOwnership memory ownership = _ownerships[i];
334       if (ownership.addr != address(0)) {
335         currOwnershipAddr = ownership.addr;
336       }
337       if (currOwnershipAddr == owner) {
338         if (tokenIdsIdx == index) {
339           return i;
340         }
341         tokenIdsIdx++;
342       }
343     }
344     revert("ERC721A: unable to get token of owner by index");
345   } 
346   function supportsInterface(bytes4 interfaceId)
347     public
348     view
349     virtual
350     override(ERC165, IERC165)
351     returns (bool)
352   {
353     return
354       interfaceId == type(IERC721).interfaceId ||
355       interfaceId == type(IERC721Metadata).interfaceId ||
356       interfaceId == type(IERC721Enumerable).interfaceId ||
357       super.supportsInterface(interfaceId);
358   } 
359   function balanceOf(address owner) public view override returns (uint256) {
360     require(owner != address(0), "ERC721A: balance query for the zero address");
361     return uint256(_addressData[owner].balance);
362   }
363 
364   function _numberMinted(address owner) internal view returns (uint256) {
365     require(
366       owner != address(0),
367       "ERC721A: number minted query for the zero address"
368     );
369     return uint256(_addressData[owner].numberMinted);
370   }
371 
372   function ownershipOf(uint256 tokenId)
373     internal
374     view
375     returns (TokenOwnership memory)
376   {
377     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
378 
379     uint256 lowestTokenToCheck;
380     if (tokenId >= maxBatchSize) {
381       lowestTokenToCheck = tokenId - maxBatchSize + 1;
382     }
383 
384     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
385       TokenOwnership memory ownership = _ownerships[curr];
386       if (ownership.addr != address(0)) {
387         return ownership;
388       }
389     }
390 
391     revert("ERC721A: unable to determine the owner of token");
392   } 
393   function ownerOf(uint256 tokenId) public view override returns (address) {
394     return ownershipOf(tokenId).addr;
395   } 
396   function name() public view virtual override returns (string memory) {
397     return _name;
398   } 
399   function symbol() public view virtual override returns (string memory) {
400     return _symbol;
401   } 
402   function tokenURI(uint256 tokenId)
403     public
404     view
405     virtual
406     override
407     returns (string memory)
408   {
409     require(
410       _exists(tokenId),
411       "ERC721Metadata: URI query for nonexistent token"
412     );
413 
414     string memory baseURI = _baseURI();
415     return
416       bytes(baseURI).length > 0
417         ? string(abi.encodePacked(baseURI, tokenId.toString(),_getUriExtension()))
418         : "";
419   } 
420   function _baseURI() internal view virtual returns (string memory) {
421     return "";
422   }
423 
424   function _getUriExtension() internal view virtual returns (string memory) {
425     return "";
426   }
427  
428   function approve(address to, uint256 tokenId) public override {
429     address owner = ERC721A.ownerOf(tokenId);
430     require(to != owner, "ERC721A: approval to current owner");
431 
432     require(
433       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
434       "ERC721A: approve caller is not owner nor approved for all"
435     );
436 
437     _approve(to, tokenId, owner);
438   } 
439   function getApproved(uint256 tokenId) public view override returns (address) {
440     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
441 
442     return _tokenApprovals[tokenId];
443   } 
444   function setApprovalForAll(address operator, bool approved) public override {
445     require(operator != _msgSender(), "ERC721A: approve to caller");
446 
447     _operatorApprovals[_msgSender()][operator] = approved;
448     emit ApprovalForAll(_msgSender(), operator, approved);
449   }
450  
451   function isApprovedForAll(address owner, address operator)
452     public
453     view
454     virtual
455     override
456     returns (bool)
457   {
458     return _operatorApprovals[owner][operator];
459   }
460  
461   function transferFrom(
462     address from,
463     address to,
464     uint256 tokenId
465   ) public override {
466     _transfer(from, to, tokenId);
467   } 
468   function safeTransferFrom(
469     address from,
470     address to,
471     uint256 tokenId
472   ) public override {
473     safeTransferFrom(from, to, tokenId, "");
474   } 
475   function safeTransferFrom(
476     address from,
477     address to,
478     uint256 tokenId,
479     bytes memory _data
480   ) public override {
481     _transfer(from, to, tokenId);
482     require(
483       _checkOnERC721Received(from, to, tokenId, _data),
484       "ERC721A: transfer to non ERC721Receiver implementer"
485     );
486   } 
487   function _exists(uint256 tokenId) internal view returns (bool) {
488     return tokenId < currentIndex;
489   }
490 
491   function _safeMint(address to, uint256 quantity) internal {
492     _safeMint(to, quantity, "");
493   } 
494   function _safeMint(
495     address to,
496     uint256 quantity,
497     bytes memory _data
498   ) internal {
499     uint256 startTokenId = currentIndex;
500     require(to != address(0), "ERC721A: mint to the zero address"); 
501     require(!_exists(startTokenId), "ERC721A: token already minted");
502     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
503 
504     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
505 
506     AddressData memory addressData = _addressData[to];
507     _addressData[to] = AddressData(
508       addressData.balance + uint128(quantity),
509       addressData.numberMinted + uint128(quantity)
510     );
511     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
512 
513     uint256 updatedIndex = startTokenId;
514 
515     for (uint256 i = 0; i < quantity; i++) {
516       emit Transfer(address(0), to, updatedIndex);
517       require(
518         _checkOnERC721Received(address(0), to, updatedIndex, _data),
519         "ERC721A: transfer to non ERC721Receiver implementer"
520       );
521       updatedIndex++;
522     }
523 
524     currentIndex = updatedIndex;
525     _afterTokenTransfers(address(0), to, startTokenId, quantity);
526   } 
527   function _transfer(
528     address from,
529     address to,
530     uint256 tokenId
531   ) private {
532     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
533 
534     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
535       getApproved(tokenId) == _msgSender() ||
536       isApprovedForAll(prevOwnership.addr, _msgSender()));
537 
538     require(
539       isApprovedOrOwner,
540       "ERC721A: transfer caller is not owner nor approved"
541     );
542 
543     require(
544       prevOwnership.addr == from,
545       "ERC721A: transfer from incorrect owner"
546     );
547     require(to != address(0), "ERC721A: transfer to the zero address");
548 
549     _beforeTokenTransfers(from, to, tokenId, 1); 
550     _approve(address(0), tokenId, prevOwnership.addr);
551 
552     _addressData[from].balance -= 1;
553     _addressData[to].balance += 1;
554     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp)); 
555     uint256 nextTokenId = tokenId + 1;
556     if (_ownerships[nextTokenId].addr == address(0)) {
557       if (_exists(nextTokenId)) {
558         _ownerships[nextTokenId] = TokenOwnership(
559           prevOwnership.addr,
560           prevOwnership.startTimestamp
561         );
562       }
563     }
564 
565     emit Transfer(from, to, tokenId);
566     _afterTokenTransfers(from, to, tokenId, 1);
567   } 
568   function _approve(
569     address to,
570     uint256 tokenId,
571     address owner
572   ) private {
573     _tokenApprovals[tokenId] = to;
574     emit Approval(owner, to, tokenId);
575   }
576 
577   uint256 public nextOwnerToExplicitlySet = 0; 
578   function _setOwnersExplicit(uint256 quantity) internal {
579     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
580     require(quantity > 0, "quantity must be nonzero");
581     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
582     if (endIndex > collectionSize - 1) {
583       endIndex = collectionSize - 1;
584     } 
585     require(_exists(endIndex), "not enough minted yet for this cleanup");
586     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
587       if (_ownerships[i].addr == address(0)) {
588         TokenOwnership memory ownership = ownershipOf(i);
589         _ownerships[i] = TokenOwnership(
590           ownership.addr,
591           ownership.startTimestamp
592         );
593       }
594     }
595     nextOwnerToExplicitlySet = endIndex + 1;
596   } 
597   function _checkOnERC721Received(
598     address from,
599     address to,
600     uint256 tokenId,
601     bytes memory _data
602   ) private returns (bool) {
603     if (to.isContract()) {
604       try
605         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
606       returns (bytes4 retval) {
607         return retval == IERC721Receiver(to).onERC721Received.selector;
608       } catch (bytes memory reason) {
609         if (reason.length == 0) {
610           revert("ERC721A: transfer to non ERC721Receiver implementer");
611         } else {
612           assembly {
613             revert(add(32, reason), mload(reason))
614           }
615         }
616       }
617     } else {
618       return true;
619     }
620   } 
621   function _beforeTokenTransfers(
622     address from,
623     address to,
624     uint256 startTokenId,
625     uint256 quantity
626   ) internal virtual {} 
627   function _afterTokenTransfers(
628     address from,
629     address to,
630     uint256 startTokenId,
631     uint256 quantity
632   ) internal virtual {}
633 }
634 
635 contract EvilApeClub is Ownable, ERC721A, ReentrancyGuard {
636     using Strings for uint256;
637 
638 
639   uint256 public MAX_PER_Transtion = 10; // maximam amount that user can mint
640 
641     uint256 public  PRICE = 0.06 ether; 
642     uint256 public WPRICE = 0.06 ether; 
643     uint256 public SPRICE = 0.065 ether;
644 
645   uint256 private constant TotalCollectionSize_ = 6969; // total number of nfts
646   uint256 private constant MaxMintPerBatch_ = 10; //max mint per traction
647 
648 
649   bool public _revelNFT = false;
650   string private _baseTokenURI;
651   string private _uriBeforeRevel;
652   uint public reserve = 250;
653 
654 
655 
656   uint public status = 0; //0-pause 2-whitelist 3-public
657 
658   mapping(address => bool) private whitelistedAddresses;
659 
660 
661   constructor() ERC721A("Evil Ape Club","EAC", MaxMintPerBatch_, TotalCollectionSize_) {
662     _uriBeforeRevel = "https://gateway.pinata.cloud/ipfs/Qmd8qmncBofLiuq5rwsVmERGFJKAJ1ct3u5DrJeGcgmX5t/revealMeta.json";
663   }
664 
665   modifier callerIsUser() {
666     require(tx.origin == msg.sender, "The caller is another contract");
667     _;
668   }
669  
670   function mint(uint256 quantity) external payable callerIsUser {
671     require(status == 1 || status == 2 , "Sale is not Active");
672     require(totalSupply() + quantity <= collectionSize-reserve-1, "reached max supply");
673     require(quantity <= MAX_PER_Transtion,"can not mint this many");
674     require(msg.value >= PRICE * quantity, "Need to send more ETH.");
675     _safeMint(msg.sender, quantity);
676 
677     uint256 d = 3;
678     if(status == 2) d = 5;
679 
680     if(d == 3){
681         if(quantity >= 3 && quantity < 6){
682         _safeMint(msg.sender, 1);
683 
684         } else if(quantity == 6){
685         _safeMint(msg.sender, 2);
686         }
687     } else if(d == 5) {
688         if(quantity >= 5 && quantity < 10){
689         _safeMint(msg.sender, 1);
690 
691         } else if(quantity == 10){
692         _safeMint(msg.sender, 2);
693         }
694     }
695 
696   }
697 //   string(abi.encodePacked(baseURI, tokenId.toString()))
698 
699    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
700     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
701     if(_revelNFT){
702     string memory baseURI = _baseURI();
703     uint256 tokenID = tokenId + 1;
704     return
705       bytes(baseURI).length > 0
706         ? string(abi.encodePacked(baseURI, "/", tokenID.toString(), ".json")) : "";
707         } else {
708             return _uriBeforeRevel;
709         }
710   }
711 
712     function isWhitelisted(address _user) public view returns (bool) {
713     return whitelistedAddresses[_user];
714   }
715 
716 
717   
718   function addNewWhitelistUsers(address[] calldata _users) public onlyOwner {
719     // ["","",""]
720     for(uint i=0;i<_users.length;i++)
721         whitelistedAddresses[_users[i]] = true;
722   }
723 
724   function setURIbeforeRevel(string memory URI) external onlyOwner {
725     _uriBeforeRevel = URI;
726   }
727 
728   function setBaseURI(string memory baseURI) external onlyOwner {
729     _baseTokenURI = baseURI;
730   }
731   function _baseURI() internal view virtual override returns (string memory) {
732     return _baseTokenURI;
733   }
734   function numberMinted(address owner) public view returns (uint256) {
735     return _numberMinted(owner);
736   }
737   function getOwnershipData(uint256 tokenId)
738     external
739     view
740     returns (TokenOwnership memory)
741   {
742     return ownershipOf(tokenId);
743   }
744 
745   function withdrawMoney() external onlyOwner nonReentrant {
746     (bool success, ) = msg.sender.call{value: address(this).balance}("");
747     require(success, "Transfer failed.");
748   }
749 
750   function changeRevelStatus() external onlyOwner {
751     _revelNFT = !_revelNFT;
752   }
753 
754   function changeMintPrice(uint256 _newPrice) external onlyOwner
755   {
756       PRICE = _newPrice;
757   }
758   function changeMAX_PER_Transtion(uint256 q) external onlyOwner
759   {
760       MAX_PER_Transtion = q;
761   }
762 
763   function setStatus(uint256 s)external onlyOwner{
764       status = s;
765       if(s==1){
766             PRICE = WPRICE;
767             MAX_PER_Transtion = 6;
768       }
769         else {
770             PRICE = SPRICE;
771             MAX_PER_Transtion = 10;
772         }
773   }
774 
775     function setWPrice(uint256 _newPrice) public onlyOwner() {
776         WPRICE = _newPrice;
777     }
778 
779  function setReserveTokens(uint256 _quantity) public onlyOwner {
780         reserve=_quantity;
781     }
782 
783   function getStatus()public view returns(uint){
784       return status;
785   }
786   function getPrice(uint256 _quantity) public view returns (uint256) {
787        
788         return _quantity*PRICE;
789     }
790 
791  function mintReserveTokens(uint quantity) public onlyOwner {
792         require(quantity <= reserve, "The quantity exceeds the reserve.");
793         reserve -= quantity;
794         _safeMint(msg.sender, quantity);
795 
796     }
797 
798   function giveaway(address a, uint q)public onlyOwner{
799     require(totalSupply() + q <= collectionSize, "reached max supply");
800     require(q <= MAX_PER_Transtion,"can not mint this many");
801     _safeMint(a, q);
802   }
803 }