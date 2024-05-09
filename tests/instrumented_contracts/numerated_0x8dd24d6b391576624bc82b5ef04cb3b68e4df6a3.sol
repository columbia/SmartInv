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
285   uint256 private currentIndex = 0;
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
312     return currentIndex;
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
631 contract CashCrabs is Ownable, ERC721A, ReentrancyGuard {
632     using Strings for uint256;
633 
634 
635   uint256 public MAX_PER_Transtion = 5; // maximam amount that user can mint
636   uint256 public MAX_PER_Address = 5; // maximam amount that user can mint
637 
638   uint256 public  PRICE = 25*10**15; //0.025 ether 
639 
640   uint256 private constant TotalCollectionSize_ = 10000; // total number of nfts
641   uint256 private constant MaxMintPerBatch_ = 10; //max mint per traction
642 
643   bool public _revelNFT = false;
644   string private _baseTokenURI;
645   string private _uriBeforeRevel;
646 
647   uint public status = 1; //0-pause 2-whitelist 3-public
648 
649   mapping(address => bool) private whitelistedAddresses;
650 
651   constructor() ERC721A("Cash Crabs","CashCrabs", MaxMintPerBatch_, TotalCollectionSize_) {
652     _uriBeforeRevel = "https://cashcrabs.mypinata.cloud/ipfs/QmPXLXoPTKGg9SdacJiZUo2H8ECSQtN2YsdPvm8F5LWyRv";
653     whitelistedAddresses[0xFD845e60eAea6c960d2a2b6F490b53D26925D5cB] = true;
654     whitelistedAddresses[0xFD845e60eAea6c960d2a2b6F490b53D26925D5cB] = true;
655     whitelistedAddresses[0x09C624d5271A1f7e6A2588e778a4d48bb90A6952] = true;
656     whitelistedAddresses[0x720Ff27ee0Cae603D54c915c2c2aAe9E467a3Ae8] = true;
657     whitelistedAddresses[0x4067B5677eef1550C22AfF13477B7a919fA35020] = true;
658     whitelistedAddresses[0xD6d57d174BE03101c29C1EB3a335559014896BC7] = true;
659     whitelistedAddresses[0xfeD7219F6fd43b4D04e4f3F0fA515cFFb5C5de62] = true;
660     whitelistedAddresses[0xeDcDd23C6A0a3B16C0C2d3e92C65D5D3b153290F] = true;
661     whitelistedAddresses[0x0dcD05914C75A62471F35c6f3F361F84c39DfaB5] = true;
662     whitelistedAddresses[0xbb767d5627A75C0943b917d980738E2c601770B6] = true;
663     whitelistedAddresses[0xe2Bb817747136d290E5238Ed2ee2db91C96264cD] = true;
664     whitelistedAddresses[0xb30D955Afc668EaB195f271D746484928A52cd49] = true;
665     whitelistedAddresses[0xCd7aB7280b0DBb253EB109381daA07a0163c58B6] = true;
666     whitelistedAddresses[0xCBF699Fc4FA85BC2Ca45BB63ADBFe78264Cc5813] = true;
667     whitelistedAddresses[0x4De76a2D2A4deCFd68566889E63D571173F930e4] = true;
668     whitelistedAddresses[0x53808009dC1A8e4A36039838B4d56CAea186F9F3] = true;
669     whitelistedAddresses[0x9E5435685733787D1Bb5B6e434353C65cAB7c21d] = true;
670     whitelistedAddresses[0x731464dd177Cac2d5E7aae58ccc58239B5f3aC43] = true;
671     whitelistedAddresses[0x6490cf86E43b1d855fbD7f397E9c63F43dB40eA2] = true;
672     whitelistedAddresses[0xAC065C832679b458008c916B1916cA93CA02568a] = true;
673     whitelistedAddresses[0x40E4D03F8fF764B7857D0Da4181F0f31a7130C34] = true;
674     whitelistedAddresses[0x47673689Fc0a7a22C024079292FfEbBD21A086fE] = true;
675     whitelistedAddresses[0x9D2a6aA0b01118b021Ff3e940956e9659Ad3CCE6] = true;
676     whitelistedAddresses[0x13e9272AE78459bD5c03e7CC33CF3cC83F765e90] = true;
677     whitelistedAddresses[0xcbDAE7c71801BEDcb1bD156ecD665581c43b8112] = true;
678     whitelistedAddresses[0x64d79EBEE793b7e546D7D02A8A2ab942775EaA31] = true;
679     whitelistedAddresses[0x3c132DDfd6A307126226Ab9f82c951E3989e14dc] = true;
680     whitelistedAddresses[0x7595D27eC13Be0A19EDBCFC7d55FE59534d6CC88] = true;
681     whitelistedAddresses[0xF279d2934e937880bC486D19AB9A65A8eF4b49c0] = true;
682     whitelistedAddresses[0xAf1d737345c84fF50b51E51FeF975Ae9ab31A45f] = true;
683     whitelistedAddresses[0x7681712a55587A1E9b6eAb1ea828e4e14059106e] = true;
684     whitelistedAddresses[0xA5D4A2c359C958C0530E37d801e851f7b7F7D69c] = true;
685     whitelistedAddresses[0xE519E23fbF1a88bf9387FeDD662778b0b348e56A] = true;
686     whitelistedAddresses[0x58C0e1CcCfc458f026E67f260BB25D8c71c1de2f] = true;
687     whitelistedAddresses[0x7AeC2A61D9bc8e899Eb6e41CeDAF24983D4B1A7e] = true;
688     whitelistedAddresses[0xa6f17FC0fcc0467fdBeb01f9bEf47d264B0ee772] = true;
689     whitelistedAddresses[0xB868B2ca33365f784df87E31CefAA1E00a8386b5] = true;
690     whitelistedAddresses[0x9A46731349080730299880307193a07D0153293d] = true;
691     whitelistedAddresses[0x7c400954350b1338A7ead552c41521327D121146] = true;
692     whitelistedAddresses[0xfcc1F854c979f61bCA87E651e72E45a72807915b] = true;
693     whitelistedAddresses[0x64aA6b8F0e11473E5ef63a224E6E4E3ac63Ef954] = true;
694     whitelistedAddresses[0x65f7E3EA4c1507F50467B7334E6d8f7547bb41D3] = true;
695     whitelistedAddresses[0xF3Fb8Ba5b9B9DAbec152112A9DDc69D80b1cA07e] = true;
696     whitelistedAddresses[0xb57F96B20ECCDD099845B67f8f590c907f4455CC] = true;
697     whitelistedAddresses[0x19C99c068B4b3292c819429DA4550a2E36f9f943] = true;
698     whitelistedAddresses[0x3Aa26AfDC92b2B09D6AfD3da1a8C11D2EED3772f] = true;
699     whitelistedAddresses[0x70B3f80ed5d612005E784312EB335672DD86b16d] = true;
700     whitelistedAddresses[0x4bFde9c1Ab8887452A2a9fB80b6F60e013108eA2] = true;
701     whitelistedAddresses[0x3F69a1B4fed4408EF9724ad8879d92840d5AaEb2] = true;
702     whitelistedAddresses[0xE4Aae6489A1215D1eEbd0cEE8409A77EE7BE467F] = true;
703     whitelistedAddresses[0x62f841f3d4E299648CF66f23B71c578D755B2bF7] = true;
704     whitelistedAddresses[0x9Cdb12deFD0838E54b4d1EE3261EDe601649E634] = true;
705     whitelistedAddresses[0x7d992C2E88D8d35bFf5d6712eEee2c9445329238] = true;
706     whitelistedAddresses[0x89Dc9bBEe3075a6d745E3Db6ae113A2aD3F1E545] = true;
707     whitelistedAddresses[0x51015f7bfE495Eb5C1daeddaff63d0bA39eDc285] = true;
708     whitelistedAddresses[0x039c8590c9a04Cb2451cDA75734861bc4DA31609] = true;
709     whitelistedAddresses[0x11ab9463418E47Fc5D9Fe2a17f662AdB19B295C1] = true;
710     whitelistedAddresses[0xc03BBC9038b16158d80Dd740F47DE733727E8b23] = true;
711     whitelistedAddresses[0x1E93e03cb1798B853262A2b7cA19D7ae642bC8B7] = true;
712     whitelistedAddresses[0x373FC2d830B2fcF7731F42Ab9D0D89E552da6ccB] = true;
713     whitelistedAddresses[0xb63B9D76324c5BEe81fBF50DfeBB54eB7f3E33a6] = true;
714     whitelistedAddresses[0xc5745B750c91ee9752c0C74FB6f91BCC26e6FC9a] = true;
715     whitelistedAddresses[0x49825062451be8119A78Ac21Ddb7Dc79BDc1f7F6] = true;
716     whitelistedAddresses[0x17171C667608A1d1Aa116Cd9B94e0A7e3620D861] = true;
717     whitelistedAddresses[0xbC4fF24fEb140810ACe88E10883eb23D3880E9b3] = true;
718     whitelistedAddresses[0x216885e1A68daD7d3936E7E012fa79223c6075A4] = true;
719     whitelistedAddresses[0x9D94B5B752555e793F6B1E46eD9654470C459944] = true;
720     whitelistedAddresses[0x28C01C0c0C7C25c763CBCa88446038Dc6B1fbA54] = true;
721     whitelistedAddresses[0x99f18373BA0b123D59f1BE56C7F689ef6DdfDEa2] = true;
722     whitelistedAddresses[0xBe628f65E995242D138A1461c75677B39fAf93C4] = true;
723     whitelistedAddresses[0x34ff8a1B5286753161Baa0bCC446D7D6Dc3857dF] = true;
724     whitelistedAddresses[0x659815937Af07f40B39B93bF16962ac1754ABBfd] = true;
725     whitelistedAddresses[0x4B300A87272db2ca1b30d21d64CDd345C4b80AfC] = true;
726     whitelistedAddresses[0x3c0Dd608611D552cf8cc7A0A4B51Bb8D808Ad886] = true;
727     whitelistedAddresses[0x9DF087ADa77aF80F553DC0d2FB43C18dC5a6B444] = true;
728     whitelistedAddresses[0x746849550373B814dfD93D8fc2a9D37CbC226bB8] = true;
729     whitelistedAddresses[0x962772AE26a8098A49cfE01Fe3f6ce68C92F9B5f] = true;
730     whitelistedAddresses[0x7A420e46405b573C0Aa96b12E80405A3819D3E6b] = true;
731     whitelistedAddresses[0x7b6AEe8165B8e0f3d8c4a8c4651bBd2E89e37631] = true;
732     whitelistedAddresses[0xa36EB29607D5deB20d0d6Dc49810cA7a23EB0B27] = true;
733     whitelistedAddresses[0x96Cb84ac416602cec04B6778fa3F8e588e84cc95] = true;
734     whitelistedAddresses[0x1101AAe94F9d196AC65Bbd440dB1ef0F639E80AE] = true;
735     whitelistedAddresses[0xCef9709b428692C92F99BD193dcbBDf8f76A6C01] = true;
736     whitelistedAddresses[0x647B7881b8A63FD8C6AAb5b0244b9067223d0e12] = true;
737     whitelistedAddresses[0x960104582B294466F3DC3d6d5Ff7a618376772e5] = true;
738     whitelistedAddresses[0x2B143cC08cdd999d92FDf44afeA5eBDC7296d90A] = true;
739     whitelistedAddresses[0x2F22A600c056848bBEBcdea3645f736B62A8B85B] = true;
740     whitelistedAddresses[0xcc2e464CbcE1B11108460cee52e3Cd82E887CbF8] = true;
741     whitelistedAddresses[0x191c445ab08764f12C821857961CFEa5B837f276] = true;
742     whitelistedAddresses[0x98139f943753Bb98ED5b346621d38DaDd51b416f] = true;
743     whitelistedAddresses[0x8D3521b68D831d853A8A383CaA0735E69e3274E0] = true;
744     whitelistedAddresses[0xCC0960243d099BCaE96c0D1AEACDdA01434d2ebc] = true;
745     whitelistedAddresses[0x07cE5Db5F75E58d657926B636b9aD3e3869C91B4] = true;
746     whitelistedAddresses[0x770aeEeFC75134558464d365d6C135f49162A5dB] = true;
747     whitelistedAddresses[0x3Ad82E1312895eEe9720ccaBAd3a7f5F226d44BE] = true;
748     whitelistedAddresses[0x756dA266dbb35f65645A8111516d0F0C09B372b5] = true;
749     whitelistedAddresses[0x76eE43FdcF297AAf373e1981B9F9d4470EdeB71B] = true;
750     whitelistedAddresses[0xEa594C9E54eCA6b36DbED9E1E2b22e592B5a3C1E] = true;
751     whitelistedAddresses[0x76A80D9E29Aa41Fc8A84a827037F977C06B585fA] = true;
752     whitelistedAddresses[0x482F8c1c569A597b6Ad258D979cF919037eb6424] = true;
753     whitelistedAddresses[0x588f288Eb412E00b712C6AC18cD95BA1eB62fec3] = true;
754     whitelistedAddresses[0x31c9b0554DA42f8c09E3458E4603E377FBa1b3Bf] = true;
755     whitelistedAddresses[0x1239F236aA9cadA354B46df3d72b67Bf8eE41469] = true;
756     whitelistedAddresses[0x9ae0816138b67b3CD2bA9680AAF983588243D0fd] = true;
757     whitelistedAddresses[0xa3dE87BFB56690bb0737d4a4db1A61B554d3F81e] = true;
758     whitelistedAddresses[0x8D2DCbBc57092d7DD114EDB923adB31053552DB4] = true;
759     whitelistedAddresses[0xfB7587d77DA8c9c60E5Ab3D92962d045e7aBfa1B] = true;
760     whitelistedAddresses[0x64A0d2ce34c2897D05fcFD6BE9742Fe2Fad182d2] = true;
761     whitelistedAddresses[0x9c9272ee0e9A29E31bDac7d21A9d9a2A3d52e3e8] = true;
762     whitelistedAddresses[0x5f9BE6B4F8025dA41239c608503a0cc998557e46] = true;
763     whitelistedAddresses[0xaCBea6Bae19e4Da3F54f43459B9d7b6F6187B8Ca] = true;
764     whitelistedAddresses[0xfcC99f087f32E560e99eC4feE1188a76F40FEE83] = true;
765     whitelistedAddresses[0x6F941D19Cb5BC61Be7127dFa2e040A2ec17fBA63] = true;
766     whitelistedAddresses[0x337e95D89875D43A57484048B9283b835f74E7Ae] = true;
767     whitelistedAddresses[0x791FcE94B7D9cA5fe0a94636901F3d77E6aEE1E3] = true;
768     whitelistedAddresses[0x43570CFaC4eE5fC682ABE2a2902Fbe1CE22a2841] = true;
769     whitelistedAddresses[0x34DB797738c12DB1547E5C5fbC1BF6e00CBE65C5] = true;
770     whitelistedAddresses[0x50ECfC76876E109bFD367F9C8A1a4ad2A493b063] = true;
771     whitelistedAddresses[0x76D0AD6863b627F5786E7C6d17BC67426A9a2787] = true;
772     whitelistedAddresses[0xb0E1dF6A0E18Fb6312Bdb1B7B0C41902E3420206] = true;
773     whitelistedAddresses[0x2B5b0128B3821cDe5A9e90b921846B53B470e335] = true;
774     whitelistedAddresses[0x07f97E3ad47C61dd67E9b59A9Bb9E83F6f709171] = true;
775     whitelistedAddresses[0x4925de66FA9f53AA69421eD92b4d2EBc13A688D0] = true;
776     whitelistedAddresses[0x2e664181c7E34cC5419c6094AcEb5C30B4972436] = true;
777     whitelistedAddresses[0xc3C07157ed646e42c7Ac977b1603f45276b30F99] = true;
778     whitelistedAddresses[0x1Cc839b23A915944276B7f594F8621E9ea537ECc] = true;
779     whitelistedAddresses[0x705EFF609194673Fd01F0eBB199E65ea84a238cd] = true;
780     whitelistedAddresses[0x7C2acf7ceD1f246f65f4D29fBEe4eB3D285D9738] = true;
781     whitelistedAddresses[0x184b2665B176FEABBeadf63D49B47109121122eb] = true;
782     whitelistedAddresses[0xfFD47BB6245868DC7c263387Ff2745CD998D23CF] = true;
783     whitelistedAddresses[0xa15c2e11bCeDe084dB837c188D06c6EA039A8F74] = true;
784     whitelistedAddresses[0xFE72cC7CfDC090299E1FF451cf1B542E6d4155a4] = true;
785     whitelistedAddresses[0xab24F8ecEf60Ea9ec577e1f556BAdF1483961E9B] = true;
786     whitelistedAddresses[0xB2da8A18710337658D37Ec027FaC3ef97e683D06] = true;
787     whitelistedAddresses[0x2C78A83F0949EDbf8B0d5c4b1cD116194b56ac05] = true;
788     whitelistedAddresses[0x6D624565F1F2070FDc7088474125c5ba80f041cA] = true;
789     whitelistedAddresses[0xbeBcf96eEEd98D495F45407CE7017179738E3552] = true;
790     whitelistedAddresses[0x4bfc251cBf1eeae80D94EB01d6271C0e51f63648] = true;
791     whitelistedAddresses[0x5CE948C7d30e6EF56f75Ce7520e46bae12B454fd] = true;
792     whitelistedAddresses[0x0232670c2F60fddDB3c642cC40C7C491Aa52Ad57] = true;
793     whitelistedAddresses[0xabE8F776B5B33D842188BA42BFC5fC72d23de80E] = true;
794     whitelistedAddresses[0xeE0f9973B2159229AaA0b5E90a704F9da72A8Da1] = true;
795     whitelistedAddresses[0x8908e0318fa424370AC9511E0AC04A846B484D67] = true;
796     whitelistedAddresses[0x1A63AfFE77eF0CD9c7f411633664200b04878E6c] = true;
797     whitelistedAddresses[0xAE9BBAc063Fe60A77e7adBBB04Ce9aBcC39517e5] = true;
798     whitelistedAddresses[0x3Bbf6E6c15C93375e00601a034D13Dc9AFc8a763] = true;
799     whitelistedAddresses[0xD7C5D20e834009aA70B97E2F4760eDc173FDAbaB] = true;
800     whitelistedAddresses[0x18171255F7d009bc21f80D0266F5d175f170C75D] = true;
801     whitelistedAddresses[0x1b48012465eD4b770Ce11AB18aE1e701E6DfaF58] = true;
802     whitelistedAddresses[0xD4D27FbD73fBa326282f3bf178Ed569CcbC4F9b5] = true;
803     whitelistedAddresses[0x3513E4a60Fb4C3a272C8290F76aC924d606EA15d] = true;
804     whitelistedAddresses[0x31F7f4Fe1bce32a99b99a616D81AFeFeC53F1FcB] = true;
805     whitelistedAddresses[0x04D725941898d965A4DdE8cB40590A9BEB193da3] = true;
806     whitelistedAddresses[0xF56535df84290396B92fcda58815812477C4a184] = true;
807     whitelistedAddresses[0x5D54Bd4971ad61f298927dA1a3F85e6d88BCE1B1] = true;
808     whitelistedAddresses[0x79cBd1D0c08217ed8b448A82ed714c3F3205eEe1] = true;
809     whitelistedAddresses[0xE6e566aBc75317c04C39dDb5cD67De735a71f567] = true;
810     whitelistedAddresses[0xaD97112509cbb091BD2FC1Fb2ce6531f1BBCE1c0] = true;
811     whitelistedAddresses[0x73285945fC85CC1F7cE8AE254E3F6d83E3668270] = true;
812     whitelistedAddresses[0x4cbC27Eb49022dC70694Fc3f6297beFb9d96aE18] = true;
813     whitelistedAddresses[0xdb4551F4704Dea5Cd761Ee5d00f371b18Dca1085] = true;
814     whitelistedAddresses[0x8cd5C2d368c1275D5ee8079A48A4fF80298eC314] = true;
815     whitelistedAddresses[0xD0f9DAe23568f78c545A07A9C16228357F6401e8] = true;
816     whitelistedAddresses[0x72169E50e2E3Ce7A767Cf5CD9336e8910D4b13D0] = true;
817     whitelistedAddresses[0x7838950FC3A25234c03a0e63B2AACA978aB1A602] = true;
818     whitelistedAddresses[0x648B5F5A5749749dE6edE1eBc88cD99d28B3ffD9] = true;
819     whitelistedAddresses[0xBb7d11B97f07011f754fb5552248989ACFDECde3] = true;
820     whitelistedAddresses[0x633c17B318b92b708949E4D82d32BCc6859083b0] = true;
821     whitelistedAddresses[0xAddc39cE24076366276f702864E0a4c0aB9798f8] = true;
822     whitelistedAddresses[0x9b5358Abf4C8328FB024ebAB6B5B095B08b5564B] = true;
823     whitelistedAddresses[0x3811c005C183FA8104a72499a6F85Cb6bd644eAc] = true;
824     whitelistedAddresses[0x06Fa86E319D35AAC2006E1f8273a3cA10a4FB2Fa] = true;
825     whitelistedAddresses[0x688d4B0eb01FB0dfEF34818b5D1827fBDeF3184D] = true;
826     whitelistedAddresses[0x3B2263A4a9D02E33E44CcD7bdf248CEF5eC633bc] = true;
827     whitelistedAddresses[0x9bc4c78867a4816688d3F1bE696cdAaFd469bd0D] = true;
828     whitelistedAddresses[0x420a7b48D7e34010a803257A10Ad9d95f8b2f88E] = true;
829     whitelistedAddresses[0x2968B496A7A821B9a67011CF60f672571633CaD6] = true;
830     whitelistedAddresses[0x0F7EEcc8cDfEcF83A3B6E93F34701C85d23a1E62] = true;
831     whitelistedAddresses[0x8f432c6aa4da9298baa589Ae7539eA5746e8C474] = true;
832     whitelistedAddresses[0x9FF4e59895012c634277E99171D1124B0F2c01eD] = true;
833     whitelistedAddresses[0xcAB1EE41b663B712fd58fbaAE2a1f04591107Faa] = true;
834     whitelistedAddresses[0x1D88F10627EcB8e596A5Ab451C2DF958f69BeFDC] = true;
835     whitelistedAddresses[0x5bc53477dA64B971b09BEd40119f5F7bf0dA9667] = true;
836     whitelistedAddresses[0x1688CA553e48049f192DC727fF14414BF1524243] = true;
837     whitelistedAddresses[0x3d218b77bE29900ca97a7bdabaC7d665B05Be84A] = true;
838     whitelistedAddresses[0x6617De1aEFCddA76c458018Bb9608e1E6A25Ad5B] = true;
839     whitelistedAddresses[0x41CFcC63981CD09201A37dF7f515307FBaDf51F8] = true;
840     whitelistedAddresses[0x54BF374c1a0eb4C52017Cc52Cf1633327EE3E985] = true;
841     whitelistedAddresses[0x4efb7B6E34616Ae0f79f2D2644Caeea299ed941a] = true;
842     whitelistedAddresses[0x5C21120970aa4D6a8ED6A8635aC84f21Bb55F1fA] = true;
843     whitelistedAddresses[0xBF89828935484b3A4801Ed5e09718d6Bb60B46b4] = true;
844     whitelistedAddresses[0xFfa4A51dFae1E8d43fA800dC639ca68B68D576b7] = true;
845     whitelistedAddresses[0x7169301ebdBE4f2c86859991423A24EbbF91461E] = true;
846     whitelistedAddresses[0x1c6F0082BE9Cb71DF7609917864FAdBB8A8599E7] = true;
847     whitelistedAddresses[0x14e00A153296881C5A07c778D3Af97E21Ac4f978] = true;
848     whitelistedAddresses[0x5Fe3055DB0D8cF215514E2787f9b414c2a52e6D8] = true;
849     whitelistedAddresses[0x068481A3019C5fd50862C8FfFF53B3b70fa382bF] = true;
850     whitelistedAddresses[0xAF4cF2A6Dc9F530B44b7fd9406B83258C79b2c71] = true;
851     whitelistedAddresses[0xB13E94dd61ab15AE70F6294Ac2F41C578EEd39Dc] = true;
852     whitelistedAddresses[0x9c0b69e3013fe53f276d79698E44E3149c62fa13] = true;
853     whitelistedAddresses[0xB0c5e7CEB566CdD8EFB4B8dA79966FB6aB708F26] = true;
854     whitelistedAddresses[0xc263776D9eA1BB86B4C5cd857a6454d1F47FCa59] = true;
855     whitelistedAddresses[0x504f0BAf0810a9A3265BEBe18ee25474800ffc45] = true;
856     whitelistedAddresses[0x0497E94c77029Af09517A74191ac86e15f3078C3] = true;
857     whitelistedAddresses[0x47fD3F28ABe2CEa99C9c9Be02C7302e2D3bAC0E9] = true;
858     whitelistedAddresses[0x471d62DB54a53dB851155b3Cb7Cb5F78A676B7c6] = true;
859     whitelistedAddresses[0xAE58AA169CF8cE4Ff8FA6C24a1F434ff75c9b012] = true;
860     whitelistedAddresses[0x7032d9D143C5e6750187e4184137104968b4363C] = true;
861     whitelistedAddresses[0x7A504c602e4Db6A5e6f089d2d8539c77a79B5Bb9] = true;
862     whitelistedAddresses[0x7d67ca153360582AE4721bC60589373b3d5Cec63] = true;
863     whitelistedAddresses[0x0fa24CDA3012Fa9186496384c75C09a17Fee5A06] = true;
864     whitelistedAddresses[0x83cAa0744780E228DB4E416F29589c074aB18512] = true;
865     whitelistedAddresses[0x3c72910bc8364F9619F8b43b5A250bE6113995a0] = true;
866     whitelistedAddresses[0x63EcC314a1cfeDA4c78ed516D20a8bE67dA280c2] = true;
867     whitelistedAddresses[0xd6b1370243a68dAA835A14c451d3f0d22116BEc4] = true;
868     whitelistedAddresses[0x97Bb12e8427E6FDC7881927dB0B0dA14445327BB] = true;
869     whitelistedAddresses[0x8fd4f55A3a3f8F3cF461bD4A6a3FfeE937FBF75c] = true;
870     whitelistedAddresses[0x818A9b822aD7840c096E6726321f194b47Ae31c2] = true;
871     whitelistedAddresses[0xA4020bE699215A3B7712ffBa8fcA763820BdbDb6] = true;
872     whitelistedAddresses[0xad3bfc3C00d7509bC01b54A1E07eB4746ffa361b] = true;
873     whitelistedAddresses[0x835bBe0f99c15C2CB8FdF858868c1D3C52a50fa6] = true;
874     whitelistedAddresses[0x976605C094a350c717E2Ed3D033197094AB05334] = true;
875     whitelistedAddresses[0x3B8d244198d6e31aF5dCfaa1E51a920081fA7eAd] = true;
876     whitelistedAddresses[0x853B811892B8107860E8b71e670a83C462B4A507] = true;
877     whitelistedAddresses[0x0Be02eAb1fDF8C899A5086bFDEf0a336A1f12ba4] = true;
878     whitelistedAddresses[0x2C72bc035Ba6242B7f7B7C1bdf0ed171A7c2b945] = true;
879     whitelistedAddresses[0x194b3496E9d2FfAe6AF332350d33Af8B21cA9b5d] = true;
880     whitelistedAddresses[0xa662ad1A0C36a51F6BfC72D5aD2D4a99791740bC] = true;
881     whitelistedAddresses[0x6395303dc74AAdc38CBa51e8689dFa3519a13F0B] = true;
882     whitelistedAddresses[0x3A086A1DEFdD5E9a62297abbFa9E91ab3e1CC16d] = true;
883     whitelistedAddresses[0x8B6A413FB3512b1e56a175C89C32587bC23d91bF] = true;
884     whitelistedAddresses[0x9991A1d42A63e41CD21C80e94c580d62A6E01471] = true;
885     whitelistedAddresses[0xA221F8c497faB925073C182eDb4d305145b20F5F] = true;
886     whitelistedAddresses[0x1B5413F8b60c67f3b4BE84d07ce57DC0D68986DC] = true;
887     whitelistedAddresses[0x29CAa7a393cFE67576F81A8b77A22c7880aF5501] = true;
888     whitelistedAddresses[0x227d93B231e70e7a6618D8bcb7eB68dC3D414F14] = true;
889     whitelistedAddresses[0x46A2Ef74225423Ce13B4Ad479f71cb204b8Cc4B5] = true;
890     whitelistedAddresses[0x3C469cbb8A35d753abcFb364b121647a4E6FEbc2] = true;
891     whitelistedAddresses[0x02951D69f0A8eDed113100883e70AD133aDD3f56] = true;
892     whitelistedAddresses[0xfE3F0624Dbc2036c47DeE835CDE6A19Fc0821538] = true;
893     whitelistedAddresses[0x61109C7033C8003b0dECF6880c58fea718Ddd40e] = true;
894     whitelistedAddresses[0x9BB4DBDb5D763cc5B1F678d5D5ce3f9cf765074F] = true;
895     whitelistedAddresses[0x1124fF6bd2C98fbE62dc4C491a9d415c0FeC1BAF] = true;
896     whitelistedAddresses[0x99da072869087Ce13bE20fCC7F13aE4D2aED4e4F] = true;
897     whitelistedAddresses[0xDAFCe2279325b7314083320e9C82Be13f374E7c9] = true;
898     whitelistedAddresses[0x6d80D27E181715b20Fec6A5492FC0B5f2a93931B] = true;
899     whitelistedAddresses[0xb09511b387e0bbBd987FAc4433AFF5839dee5Ef4] = true;
900     whitelistedAddresses[0x7ED0Fd948688aBf3785C5d8b7EeFCfbf82500fA0] = true;
901     whitelistedAddresses[0x6483AFa117fD0c334f2A6D8D64149cf84FDd1dB2] = true;
902     whitelistedAddresses[0xD281E80C2d2C8f09c22D0039124e94737019620e] = true;
903     whitelistedAddresses[0xc424C67AB3A5A2D33AE5d234A7fd2c9eD55f807D] = true;
904     whitelistedAddresses[0x70C8294446B02C70252992D1bC8Ed2E18E05be46] = true;
905     whitelistedAddresses[0x8621AAA593eE6C2251d02647c67767b4C4EFbe12] = true;
906     whitelistedAddresses[0x96242abC548D13d181857cb6Ffe32995e641fdAf] = true;
907     whitelistedAddresses[0x01f2ea8D6594F6EB69027F7ddcc1D700bBdbBE48] = true;
908     whitelistedAddresses[0x4f4354345088C9c320C9C048D0b36B1a73727Ce6] = true;
909     whitelistedAddresses[0x3c3B59411792cdB893F167B3a7394eA9d125cD9A] = true;
910     whitelistedAddresses[0x6b0e4EA76F522Cc337e4683e01d5B5779ab67f7b] = true;
911     whitelistedAddresses[0xae29968890bFc0ea250abaFd30B0502B46214b81] = true;
912     whitelistedAddresses[0xf82947b13c2a2A91B9c20b7B3b546b5Cb82e94A5] = true;
913     whitelistedAddresses[0x8fB2F9DEFaA5a088E8ccfc01DaD56a938ae499E1] = true;
914     whitelistedAddresses[0x3a61c3F67Df48E3f73509F6E58621a746797a645] = true;
915     whitelistedAddresses[0x7F8235CC263A8Cbe81C642b6cdb53E488227Ca28] = true;
916     whitelistedAddresses[0x6dd46d406BD1b9546c5b35da82E44fE7E141cbE8] = true;
917     whitelistedAddresses[0x60f2f6718801CeFe0D2276a668a73d9EfD69a0A7] = true;
918     whitelistedAddresses[0xF74A8D872597958e2889cc91d45BF2cAd6a3A364] = true;
919     whitelistedAddresses[0x7FBeC09F7CE64b733260fB40acA15BF18528b3BB] = true;
920     whitelistedAddresses[0x706108b116585805AfCC752e45d56C5Fa2f080FA] = true;
921     whitelistedAddresses[0x4019868226fabBfB836d388beE5E870204371F9d] = true;
922     whitelistedAddresses[0x69B3d3BE1D6CcFaEE8b48C9f5E37d634BEc99680] = true;
923     whitelistedAddresses[0x8B56e84623d7Cb650F9863C9aa5CD1ffae3D62BC] = true;
924     whitelistedAddresses[0xFBe871D0Aad0FDab932B60351aFD1006b03fda43] = true;
925     whitelistedAddresses[0x22433e157a87d81D9F6460aaE4b89FfeEC2c382d] = true;
926     whitelistedAddresses[0x04A65E8b543D4e1F7e1cC5d5118cb9B1b7aa20b1] = true;
927     whitelistedAddresses[0x5bE67129914f502BAAd2791be0934F7dBa691500] = true;
928     whitelistedAddresses[0xe8D531dC7122CBdEbD2Dd5E6D43DC09C9D1caAaB] = true;
929     whitelistedAddresses[0xD49322ADD203C8e04ACDD53B7fF14B5E0AC861D7] = true;
930     whitelistedAddresses[0x75eAD7715418F50F2285EAC120Ac003CE2e46227] = true;
931     whitelistedAddresses[0xA6Fe464c7aAFF0827F264289a1E9b2b82cdb961a] = true;
932     whitelistedAddresses[0xAdd9a6a1B6781eb889bB01326b5278032BD8E30e] = true;
933     whitelistedAddresses[0x083eaD940335d6908CDb078df005Fb4C5f83A9b0] = true;
934     whitelistedAddresses[0x9A4763bE8fFaD2F2EC958b8b3742b4D59Ec490e2] = true;
935     whitelistedAddresses[0xd5a9C4a92dDE274e126f82b215Fccb511147Cd8e] = true;
936     whitelistedAddresses[0x188408EF0c26225705f6Cdea6148f3f8Ed802348] = true;
937     whitelistedAddresses[0xd5bB6ac79482467103263B818f2d8462224F6133] = true;
938     whitelistedAddresses[0x6EF9Dca82362509cD878051D1FDC6dB12ddA2989] = true;
939     whitelistedAddresses[0xD72D8eE3Ee73DeaB3137B2622F8e97BaDEa70900] = true;
940     whitelistedAddresses[0xd4A645268CFE2806De8a3beF82c1FA79c99b1e1c] = true;
941     whitelistedAddresses[0x43afdF4acd587b41b40693e820de52Da010A1c19] = true;
942     whitelistedAddresses[0x6C8917547A0Dd8d3A9658DE9176837cFa9dd8933] = true;
943     whitelistedAddresses[0xf873BeBDD61AB385D6b24C135BAF36C729CE8824] = true;
944     whitelistedAddresses[0xEd034B287ea77A14970f1C0c8682a80a9468dBB3] = true;
945     whitelistedAddresses[0x914FF77D2AA22E2604005ADa17a4eb54C2964131] = true;
946     whitelistedAddresses[0x49B59DF9dF381B1634B81e3Ea12fcC0BB6Ae4498] = true;
947     whitelistedAddresses[0xBbf63f18B363C1317aF8e48c6ecF2528955877be] = true;
948     whitelistedAddresses[0x5EEb21cD9535c3130E683e5fFA51d25AE0926150] = true;
949     whitelistedAddresses[0xaCf890389fF734d23aEAE8EA8bCBC1CB7b9fEE08] = true;
950     whitelistedAddresses[0x48Fe093848d1a11B236C7d4450E6b6360B6bA7Ad] = true;
951     whitelistedAddresses[0xB6C5B1a489606028Da263EDa28063186f96fa921] = true;
952     whitelistedAddresses[0x392D688249ddA8C3f75402cc257307E04fcd793c] = true;
953     whitelistedAddresses[0x7896ca4e8Dea26Af540bC466229435bea5457344] = true;
954     whitelistedAddresses[0xfcD51CE91D05FFEF2a678B6b15579cEf0c28680A] = true;
955     whitelistedAddresses[0x9F69b05c6Bb5871905412B998389912D3A4cbE4b] = true;
956     whitelistedAddresses[0x5ef36FB9480b4dD1F217Cef4B054c97ad5857eF0] = true;
957     whitelistedAddresses[0xc039B305CF30f5e7d42Ffa4fd92aF80D4b8d264C] = true;
958     whitelistedAddresses[0xE3162DB6d1f2c4bDc6B97Ee98986FCFB1900238D] = true;
959     whitelistedAddresses[0x6b718E50E4f8549AC3Ee828759477Ca1D8c2EEc5] = true;
960     whitelistedAddresses[0xA1a0e1c77EcCdD42C3424a852d1d950D4f70A195] = true;
961     whitelistedAddresses[0x095E54514a95d7579a9a12E77E33AAE6b5c9EfCc] = true;
962     whitelistedAddresses[0xce33A5485345de213Ba726858Fd5aCbE21D255Bc] = true;
963     whitelistedAddresses[0x1555CE5C0A71490dFCcc65ec1cABD3C5467deA15] = true;
964     whitelistedAddresses[0x6a3bF16Bba8D8e9b9738c0e97940f3F5e55D2417] = true;
965     whitelistedAddresses[0xC300c97E8BDd1De87a89B95f30fFc48beaCbF775] = true;
966     whitelistedAddresses[0x33725931cef75B1b15c85dF10af4aAbfe4f8cb33] = true;
967     whitelistedAddresses[0x8Fa2dd1f61C4784F6A9a5CAff6DeE48320a8574e] = true;
968     whitelistedAddresses[0xAD0043104124fDa20cCbbA6137CA440FF9d2f096] = true;
969     whitelistedAddresses[0xF180f0fF2cDc8F9Ed1CFa98b7D0Ed4aeC28ddbAf] = true;
970     whitelistedAddresses[0x4D5cCe7FFe0b02c1B73678B295f0F3F24e88f854] = true;
971     whitelistedAddresses[0x194F6b93BEf0B66494a83dd8a933f4942219d880] = true;
972     whitelistedAddresses[0xDCc18fEFEBAa22A8b637c8cB1283815aeC35FAe7] = true;
973     whitelistedAddresses[0x0F255AAF6b5131ea0FE46970fD93BeD3314080F2] = true;
974     whitelistedAddresses[0xa99d8E77ce54a2C643E723469C4ec4B70F7212c9] = true;
975     whitelistedAddresses[0xdCbeF5ca2245F2661FD69bA40c6643d7bC8B5BD0] = true;
976     whitelistedAddresses[0x486F636B98C3B955159b46228104028F291c345e] = true;
977     whitelistedAddresses[0xeAA14E5F2AC58692350c64070077355445d3d127] = true;
978     whitelistedAddresses[0xE63c78ADCB7a766DDC48e493De46094b59376Ef5] = true;
979     whitelistedAddresses[0xaE1e8745b14fdC57BD0be7662FFe82C664c25270] = true;
980     whitelistedAddresses[0xFDc695E4DfbEc316eCEb205410A4bdBf171795df] = true;
981     whitelistedAddresses[0x60F008bdEc59Bc57B25a3476E0b05eF4882f093a] = true;
982     whitelistedAddresses[0xfd5dDf939b1453e369810896195c8103A52B9251] = true;
983     whitelistedAddresses[0x1877FA3AF4A6Cec0C05f0932f87a0c386Cbf906B] = true;
984     whitelistedAddresses[0x2FAcE9cC8C4246c38730AB2248eaa30E0e7Dc2d8] = true;
985     whitelistedAddresses[0x731EC28e9314be2da65cDc0B7E55341eFE33A3d8] = true;
986     whitelistedAddresses[0x8aD7a7ae30B3Cef4494C507133211d60a831Aa89] = true;
987     whitelistedAddresses[0x92Cd135c7C2539E4D61CE4e5951f19D4beF7d871] = true;
988     whitelistedAddresses[0xb3441Ac812872226092A401c8Ab0d8F3E919743e] = true;
989     whitelistedAddresses[0xae320F2b5E965C6859834a4c4df41F324d06d1e0] = true;
990     whitelistedAddresses[0xBd74Ba03A439D9B9621dFacc0fa4edE5C86A205C] = true;
991     whitelistedAddresses[0xFa2a9C75Bd768deF7F144FD33d72DFCC6d0F1ff7] = true;
992     whitelistedAddresses[0x1c10cA916EdE22b6ED14efdA442BEba14819CE4B] = true;
993     whitelistedAddresses[0xf99983c1b128b87beD9aE10eC19df12feFDEb822] = true;
994     whitelistedAddresses[0x7A455Da0FB1A70F421aba5b091b1862189942521] = true;
995     whitelistedAddresses[0x5F9E228a454ae4C7de82604f4b4028A95e1705a0] = true;
996     whitelistedAddresses[0xb470f97DAB8be7bb31640007560436cf0A024956] = true;
997     whitelistedAddresses[0x56960880170EAf298826e6D0eE61f853Ee2deef5] = true;
998     whitelistedAddresses[0x67A9F393f8e068B4187da09558a1f5036a3d9b34] = true;
999     whitelistedAddresses[0x49612Fd70fEc2406c77a10a2926F39923D234C5B] = true;
1000     whitelistedAddresses[0xeCB03C8ABDCBD0Ef3f333efd11959d052Fb60b7c] = true;
1001     whitelistedAddresses[0x7Cd31150494AC32E8E42A6D9a31e67B48372a43B] = true;
1002     whitelistedAddresses[0x08e3012f872A5d1163C4069E4325D4D3e0D890f7] = true;
1003     whitelistedAddresses[0x39436E22EC425e93EB5C5136389B04854c142310] = true;
1004     whitelistedAddresses[0x5C57abD3548b87Ef9bAbEa37ed3abD51fad523a3] = true;
1005     whitelistedAddresses[0x5B94DE14d4789C0264a2E20132Ee2cb30F6B7f34] = true;
1006     whitelistedAddresses[0x7E5573836391c3240C95b1698ee3F815Bf01C904] = true;
1007     whitelistedAddresses[0x5cf9b65d03000c3Fb68AE833C5E21C91829BC7d1] = true;
1008     whitelistedAddresses[0x5c29F54cD1aF8636BeeAfBcdD4bE0114f4307ED4] = true;
1009     whitelistedAddresses[0xDcb30978A21C5a083A2C91bF06Dce37c261bFB43] = true;
1010     whitelistedAddresses[0x47F08742e58E2015c9E3d89957579d3e7869A0d8] = true;
1011     whitelistedAddresses[0x361533e1A7f04ea0cb9cAA76277d1BA04F48b1c9] = true;
1012     whitelistedAddresses[0x61FCF5155788A8C71E8E607F094aC4aB72c58CEb] = true;
1013     whitelistedAddresses[0x1B3585C01bA9e8dD6aEFd73f3Ca9D58BBEB666e7] = true;
1014     whitelistedAddresses[0xa9D60735AB0901F84F5D04b465FA2F1a6d0Aa7Ee] = true;
1015     whitelistedAddresses[0x2067baD494367B860D4f5f1C2a3862110ae4D75e] = true;
1016     whitelistedAddresses[0xE2371b3cF4Fc1E290D613FE3bF4a61d285199B17] = true;
1017     whitelistedAddresses[0xd5A771Da32A392036a98f7DA6b11D46D6D1c61f9] = true;
1018     whitelistedAddresses[0x4d7Bd6b18FfE526c901AeC3C7a2B564bD2c376D5] = true;
1019     whitelistedAddresses[0x40C7Fea74E92803f6e9d3Cd9fc0ABaCcc28d46bC] = true;
1020     whitelistedAddresses[0x73E4FDD812a1c28706cFbD03249731ef50F6F520] = true;
1021     whitelistedAddresses[0x2Eaa29D91CA91dB1Af608f9A7dF4F4feb5f01BFE] = true;
1022     whitelistedAddresses[0x73c48Ad7F4eC3E52b8FAB220337DBA7549e8170E] = true;
1023     whitelistedAddresses[0xdd12bF90cF2c48320F988534B3A8Bf246cC3aD0b] = true;
1024     whitelistedAddresses[0x83b127894d6E2bc1dbA6D88F0e022347969a02a3] = true;
1025     whitelistedAddresses[0xf295EFa8c90897D2770F795B3811452Fa3530F81] = true;
1026     whitelistedAddresses[0x9f0e16F48Ce7c7cF0902b1B965bE9D86172c4447] = true;
1027     whitelistedAddresses[0xD1F4Be365dB59548D474cF7C2bedc417209f9eF7] = true;
1028     whitelistedAddresses[0xa5D4c28304a8042A4557579A6229B37cD6736Ce6] = true;
1029     whitelistedAddresses[0x4A9513dAFCBD44C8A4409Ca262C4Da1f70A7064e] = true;
1030     whitelistedAddresses[0x6DE8e62dCe4c4C167626e297Cd3E5498B0096663] = true;
1031     whitelistedAddresses[0x9B809FB7C18fca0985d8b94E3EA6ccc3d6727a00] = true;
1032     whitelistedAddresses[0x1b33A158F6BcDCEcb53ad5D3a1b4f847DFC0a7C6] = true;
1033     whitelistedAddresses[0xE9bD37E8A30e7a15AEa960578DD283513C9BfA2c] = true;
1034     whitelistedAddresses[0x33b22f2578c87bc59F4fa4035A85475bD9C541ab] = true;
1035     whitelistedAddresses[0x8880018BA0517a71c29Da6B043Ee461589a9b529] = true;
1036     whitelistedAddresses[0x0D0bc2AdAf925D4F0F2aF8461b70aa3bC99f08e0] = true;
1037     whitelistedAddresses[0x0cF249aF439a1444910Cb0d7647a83DadF9B912b] = true;
1038     whitelistedAddresses[0x5920d33c06914Df0CdBaA780894FDEc4a23D3022] = true;
1039     whitelistedAddresses[0x707d9277F1966651b2bFA6C17BaED1C2Ee85f586] = true;
1040     whitelistedAddresses[0xbFC4460eF3d8fD49902FB831E73e304B0947ce59] = true;
1041     whitelistedAddresses[0x326262f035bb1925C78443276a3b3F796bd3Cd8C] = true;
1042     whitelistedAddresses[0xd6714f181934eD979344F4A8168581b8048A5e03] = true;
1043     whitelistedAddresses[0x26883856ED417087c828687464427ffe70BbACD7] = true;
1044     whitelistedAddresses[0xB67D0995647303350D9c0b4118759807A0A29B5c] = true;
1045     whitelistedAddresses[0x86F632C48eC142D602012375C793a41D4b97cC05] = true;
1046     whitelistedAddresses[0xB1146ECd00783165eBc41C363bcb2e6FB231dD09] = true;
1047     whitelistedAddresses[0xD3349916bB1aA25c7A459a8aEBB3310Ea5f423B5] = true;
1048     whitelistedAddresses[0x755a1dD37b7f7011F8D11E5043a427532d11C63F] = true;
1049     whitelistedAddresses[0x69B9c615cC9900073B8F200F9D13f882706B6374] = true;
1050     whitelistedAddresses[0xc3793662ceb87129431245E0e22B2A697C7F66E8] = true;
1051     whitelistedAddresses[0xcAb63F60878642BCb8236acDfE8a2ec6cDc14ed4] = true;
1052     whitelistedAddresses[0x0660459b2b658B232f3dB6ADfF5580e7558F60E6] = true;
1053     whitelistedAddresses[0x929dC783b613E6ccd80BA4a4FFD3289cfF82866A] = true;
1054     whitelistedAddresses[0xDffC43C8709De2EdA41AeDd5e4EaF51963c93A44] = true;
1055     whitelistedAddresses[0xCC89EC35fCECC62273603B6031f93ca692a54414] = true;
1056     whitelistedAddresses[0x6F0ca764Ff228C5942dcC4f2B48809236Ba03990] = true;
1057     whitelistedAddresses[0x3F140845EDeC1DbdD8dB54232fBAFDB637773C2F] = true;
1058     whitelistedAddresses[0x93f263bDa652E5061386284A7d3b6Ea0cDD27852] = true;
1059     whitelistedAddresses[0x9F46f9499C20dD3bb111215002ECb3c5fD52fC21] = true;
1060     whitelistedAddresses[0x813D9AFe8da7768c468d5330bb18175916f29c7f] = true;
1061     whitelistedAddresses[0xc76039347c20A331aF1938E3BE73273A965baa08] = true;
1062     whitelistedAddresses[0x7a756813C419D23b0E9A1B8A1D1dAfe662805BB1] = true;
1063     whitelistedAddresses[0xEcCD1694D625a37169189d248f8e7D55bE038a6f] = true;
1064     whitelistedAddresses[0xDa9551D92636D33f5F9712672D67fD08Fd4288e3] = true;
1065     whitelistedAddresses[0xeF745b83FEEa5c811aF76132245374C6a8Be8D08] = true;
1066     whitelistedAddresses[0x3Fb3365b48045208737EcE98aA31b2F7Ac6bbDC7] = true;
1067     whitelistedAddresses[0x3D92898c09614702B5031b42a3AA41F2E7FfFe07] = true;
1068     whitelistedAddresses[0x77d04628A093B243D9750F32893766c3d0B0449d] = true;
1069     whitelistedAddresses[0xD509F14123021f60df832518D08176ca4dfD0Bfa] = true;
1070     whitelistedAddresses[0x70C8825CD741be7750BbC462C776b6A3b6f39551] = true;
1071     whitelistedAddresses[0x95F445cC9e6a90b9445F2Ea805908aC6768A9E18] = true;
1072     whitelistedAddresses[0x84a13DF125ACafe9AC2F11D92A1d662e66f98c3c] = true;
1073     whitelistedAddresses[0x74D5EDf85139c6289f2Ee1ff49DD8E1864B0104C] = true;
1074     whitelistedAddresses[0x7D03e3E2C833018eE3a8cFcf3876296a2186696C] = true;
1075     whitelistedAddresses[0xFD69dfd91Aeb80d36e5B2200f581eB2350b078db] = true;
1076     whitelistedAddresses[0xe0123335BdE05195E0D78F79C9B2776493fa916c] = true;
1077     whitelistedAddresses[0x199fD4BFc1F012bbffa5f53F931B32037266fccC] = true;
1078     whitelistedAddresses[0xF416D9bB6576e15e9587A900134255dEdE849Cf2] = true;
1079     whitelistedAddresses[0x335525B494F659CeCdCe90d329A41Bed94e9d5f7] = true;
1080     whitelistedAddresses[0x7a57312C96d212eC4E77853c301d45C1D26487B0] = true;
1081     whitelistedAddresses[0xBD4c4049bF7B42889D343384743a808F9D6a1f45] = true;
1082     whitelistedAddresses[0x4B8caed2850513795635c123635CD8046A846520] = true;
1083     whitelistedAddresses[0xdaf55518E4EABFe34B39B953291C1A8383eF6020] = true;
1084     whitelistedAddresses[0xA166f681BE8dB248237444F0C48962F8F8940c98] = true;
1085     whitelistedAddresses[0xb366fdB2b665644524df762bd09c87FA3f6D7be4] = true;
1086     whitelistedAddresses[0x3147B17e5eb3B9A36A7CA16144E16Aae6295f499] = true;
1087     whitelistedAddresses[0x1f83404171F76CE8686B62bB89670AE7ab8e2D0D] = true;
1088     whitelistedAddresses[0x8DE02b898091a2401f2D89f6cf3C50307c329492] = true;
1089     whitelistedAddresses[0xd96bE45080e824686694E7f74169330FFc55d1DF] = true;
1090     whitelistedAddresses[0xbe7AC41E85fDb0171207d03BB6a2d8695E4e9033] = true;
1091     whitelistedAddresses[0xf3e4bb46f9C8e06e57996fD6b0337f60E824Be88] = true;
1092     whitelistedAddresses[0xA8b472599193D1BC01acfd6A31A9B6f5dc2a93E6] = true;
1093     whitelistedAddresses[0xd68936188779efb41BEF5659B9183B34Fb7963Fe] = true;
1094     whitelistedAddresses[0x8027e4EaeF12dae0b5A68B81BE3eC46a88e6Ff1a] = true;
1095     whitelistedAddresses[0x3A48B3b3fdf7eFDE99044d1F63ED1d00f61702bC] = true;
1096     whitelistedAddresses[0x15FaA3F30D2691f7Ff8b067938C07468f5Ee6C1F] = true;
1097     whitelistedAddresses[0xe64F4c1793057d8E6Ef4d72dc7547B51b2aaA750] = true;
1098     whitelistedAddresses[0x88Be47aeF010e57B01AC9E9F2272281C6B1e6514] = true;
1099     whitelistedAddresses[0xd6fC56bd9D65a4f00A3969791DB598Bd74f389b4] = true;
1100     whitelistedAddresses[0xf27e69c6Ef6dfC96f62f0B56DBD27FFeDcAF72Ba] = true;
1101     whitelistedAddresses[0xa72726267c804e7508dF6b3AC14014F1EAc2D5Ad] = true;
1102     whitelistedAddresses[0x2Ec79180e470E303AA0a6A3033bc7D19708aD365] = true;
1103     whitelistedAddresses[0x423907a13DcE86f5415a4e4221caCBDfb9cDdF47] = true;
1104     whitelistedAddresses[0x74a8fBB9651dAc3BB9f2f0d7B1af9CA3dE9181CE] = true;
1105     whitelistedAddresses[0x13cBB2dCBe4d39D8743bf1650C4E8C09103a324B] = true;
1106     whitelistedAddresses[0xddBaAEd29761659CB20554c343D656A0cd8095B5] = true;
1107     whitelistedAddresses[0x787551ae0AB07dE8EB91d1535DBD37f379B0111D] = true;
1108     whitelistedAddresses[0x5BaC6fd07ED7c3572ce36cb2b841D6eC84af27f0] = true;
1109   }
1110 
1111   modifier callerIsUser() {
1112     require(tx.origin == msg.sender, "The caller is another contract");
1113     _;
1114   }
1115  
1116   function mint(uint256 quantity) external payable callerIsUser {
1117     require(status == 1 && whitelistedAddresses[msg.sender] || status == 2 , "Sale is not Active");
1118     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1119     require( ( status == 1 && numberMinted(msg.sender) + quantity <= MAX_PER_Address ) || status == 2 , "Quantity exceeds allowed Mints" );
1120     require(  quantity <= MAX_PER_Transtion,"can not mint this many");
1121     require(msg.value >= PRICE * quantity, "Need to send more ETH.");
1122     _safeMint(msg.sender, quantity);    
1123   }
1124 
1125    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1126     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1127     if(_revelNFT){
1128     string memory baseURI = _baseURI();
1129     return
1130       bytes(baseURI).length > 0
1131         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1132         : "";
1133     } else{
1134       return _uriBeforeRevel;
1135     }
1136   }
1137 
1138   function isWhitelisted(address _user) public view returns (bool) {
1139     return whitelistedAddresses[_user];
1140   }
1141 
1142   
1143   function addNewWhitelistUsers(address[] calldata _users) public onlyOwner {
1144     // ["","",""]
1145     for(uint i=0;i<_users.length;i++)
1146         whitelistedAddresses[_users[i]] = true;
1147   }
1148 
1149   function setURIbeforeRevel(string memory URI) external onlyOwner {
1150     _uriBeforeRevel = URI;
1151   }
1152 
1153   function setBaseURI(string memory baseURI) external onlyOwner {
1154     _baseTokenURI = baseURI;
1155   }
1156   function _baseURI() internal view virtual override returns (string memory) {
1157     return _baseTokenURI;
1158   }
1159   function numberMinted(address owner) public view returns (uint256) {
1160     return _numberMinted(owner);
1161   }
1162   function getOwnershipData(uint256 tokenId)
1163     external
1164     view
1165     returns (TokenOwnership memory)
1166   {
1167     return ownershipOf(tokenId);
1168   }
1169   function withdrawMoney() external onlyOwner nonReentrant {
1170     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1171     require(success, "Transfer failed.");
1172   }
1173   function changeRevelStatus() external onlyOwner {
1174     _revelNFT = !_revelNFT;
1175   }
1176   function changeMintPrice(uint256 _newPrice) external onlyOwner
1177   {
1178       PRICE = _newPrice;
1179   }
1180   function changeMAX_PER_Transtion(uint256 q) external onlyOwner
1181   {
1182       MAX_PER_Transtion = q;
1183   }
1184   function changeMAX_PER_Address(uint256 q) external onlyOwner
1185   {
1186       MAX_PER_Address = q;
1187   }
1188 
1189   function setStatus(uint256 s)external onlyOwner{
1190       status = s;
1191   }
1192   function getStatus()public view returns(uint){
1193       return status;
1194   }
1195   function giveaway(address a, uint q)public onlyOwner{
1196     _safeMint(a, q);
1197   }
1198 }