1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7     function _msgData() internal view virtual returns (bytes calldata) {
8         return msg.data;
9     }
10 }
11 abstract contract Ownable is Context {
12     address private _owner;
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14     constructor() {
15         _transferOwnership(_msgSender());
16     }
17     function owner() public view virtual returns (address) {
18         return _owner;
19     }
20     modifier onlyOwner() {
21         require(owner() == _msgSender(), "Ownable: caller is not the owner");
22         _;
23     }
24     function renounceOwnership() public virtual onlyOwner {
25         _transferOwnership(address(0));
26     }
27     function transferOwnership(address newOwner) public virtual onlyOwner {
28         require(newOwner != address(0), "Ownable: new owner is the zero address");
29         _transferOwnership(newOwner);
30     }
31     function _transferOwnership(address newOwner) internal virtual {
32         address oldOwner = _owner;
33         _owner = newOwner;
34         emit OwnershipTransferred(oldOwner, newOwner);
35     }
36 }
37 abstract contract ReentrancyGuard {
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40     uint256 private _status;
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44     modifier nonReentrant() {
45         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
46         _status = _ENTERED;
47         _;
48         _status = _NOT_ENTERED;
49     }
50 }
51 interface IERC20 {
52     function totalSupply() external view returns (uint256);
53     function balanceOf(address account) external view returns (uint256);
54     function transfer(address recipient, uint256 amount) external returns (bool);
55     function allowance(address owner, address spender) external view returns (uint256);
56     function approve(address spender, uint256 amount) external returns (bool);
57     function transferFrom(
58         address sender,
59         address recipient,
60         uint256 amount
61     ) external returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 interface IERC165 {
66     function supportsInterface(bytes4 interfaceId) external view returns (bool);
67 }
68 interface IERC721 is IERC165 {
69     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
70     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
71     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
72     function balanceOf(address owner) external view returns (uint256 balance);
73     function ownerOf(uint256 tokenId) external view returns (address owner);
74     function safeTransferFrom(
75         address from,
76         address to,
77         uint256 tokenId
78     ) external;
79     function transferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84     function approve(address to, uint256 tokenId) external;
85     function getApproved(uint256 tokenId) external view returns (address operator);
86     function setApprovalForAll(address operator, bool _approved) external;
87     function isApprovedForAll(address owner, address operator) external view returns (bool);
88     function safeTransferFrom(
89         address from,
90         address to,
91         uint256 tokenId,
92         bytes calldata data
93     ) external;
94 }
95 interface IERC721Receiver {
96     function onERC721Received(
97         address operator,
98         address from,
99         uint256 tokenId,
100         bytes calldata data
101     ) external returns (bytes4);
102 }
103 interface IERC721Metadata is IERC721 {
104     function name() external view returns (string memory);
105     function symbol() external view returns (string memory);
106     function tokenURI(uint256 tokenId) external view returns (string memory);
107 }
108 interface IERC721Enumerable is IERC721 {
109     function totalSupply() external view returns (uint256);
110     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
111     function tokenByIndex(uint256 index) external view returns (uint256);
112 }
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
123         (bool success, ) = recipient.call{value: amount}("");
124         require(success, "Address: unable to send value, recipient may have reverted");
125     }
126     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
127         return functionCall(target, data, "Address: low-level call failed");
128     }
129     function functionCall(
130         address target,
131         bytes memory data,
132         string memory errorMessage
133     ) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, 0, errorMessage);
135     }
136     function functionCallWithValue(
137         address target,
138         bytes memory data,
139         uint256 value
140     ) internal returns (bytes memory) {
141         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
142     }
143     function functionCallWithValue(
144         address target,
145         bytes memory data,
146         uint256 value,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         require(address(this).balance >= value, "Address: insufficient balance for call");
150         require(isContract(target), "Address: call to non-contract");
151         (bool success, bytes memory returndata) = target.call{value: value}(data);
152         return verifyCallResult(success, returndata, errorMessage);
153     }
154     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
155         return functionStaticCall(target, data, "Address: low-level static call failed");
156     }
157     function functionStaticCall(
158         address target,
159         bytes memory data,
160         string memory errorMessage
161     ) internal view returns (bytes memory) {
162         require(isContract(target), "Address: static call to non-contract");
163         (bool success, bytes memory returndata) = target.staticcall(data);
164         return verifyCallResult(success, returndata, errorMessage);
165     }
166     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
167         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
168     }
169     function functionDelegateCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal returns (bytes memory) {
174         require(isContract(target), "Address: delegate call to non-contract");
175         (bool success, bytes memory returndata) = target.delegatecall(data);
176         return verifyCallResult(success, returndata, errorMessage);
177     }
178     function verifyCallResult(
179         bool success,
180         bytes memory returndata,
181         string memory errorMessage
182     ) internal pure returns (bytes memory) {
183         if (success) {
184             return returndata;
185         } else {
186             if (returndata.length > 0) {
187                 assembly {
188                     let returndata_size := mload(returndata)
189                     revert(add(32, returndata), returndata_size)
190                 }
191             } else {
192                 revert(errorMessage);
193             }
194         }
195     }
196 }
197 library Strings {
198     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
199     function toString(uint256 value) internal pure returns (string memory) {
200         if (value == 0) {
201             return "0";
202         }
203         uint256 temp = value;
204         uint256 digits;
205         while (temp != 0) {
206             digits++;
207             temp /= 10;
208         }
209         bytes memory buffer = new bytes(digits);
210         while (value != 0) {
211             digits -= 1;
212             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
213             value /= 10;
214         }
215         return string(buffer);
216     }
217     function toHexString(uint256 value) internal pure returns (string memory) {
218         if (value == 0) {
219             return "0x00";
220         }
221         uint256 temp = value;
222         uint256 length = 0;
223         while (temp != 0) {
224             length++;
225             temp >>= 8;
226         }
227         return toHexString(value, length);
228     }
229     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
230         bytes memory buffer = new bytes(2 * length + 2);
231         buffer[0] = "0";
232         buffer[1] = "x";
233         for (uint256 i = 2 * length + 1; i > 1; --i) {
234             buffer[i] = _HEX_SYMBOLS[value & 0xf];
235             value >>= 4;
236         }
237         require(value == 0, "Strings: hex length insufficient");
238         return string(buffer);
239     }
240 }
241 abstract contract ERC165 is IERC165 {
242     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
243         return interfaceId == type(IERC165).interfaceId;
244     }
245 }
246 contract ERC721A is
247   Context,
248   ERC165,
249   IERC721,
250   IERC721Metadata,
251   IERC721Enumerable
252 {
253   using Address for address;
254   using Strings for uint256;
255   struct TokenOwnership {
256     address addr;
257     uint64 startTimestamp;
258   }
259   struct AddressData {
260     uint128 balance;
261     uint128 numberMinted;
262   }
263   uint256 private currentIndex = 0;
264   uint256 internal immutable collectionSize;
265   uint256 internal immutable maxBatchSize;
266   string private _name;
267   string private _symbol;
268   mapping(uint256 => TokenOwnership) private _ownerships;
269   mapping(address => AddressData) private _addressData;
270   mapping(uint256 => address) private _tokenApprovals;
271   mapping(address => mapping(address => bool)) private _operatorApprovals;
272   constructor(
273     string memory name_,
274     string memory symbol_,
275     uint256 maxBatchSize_,
276     uint256 collectionSize_
277   ) {
278     require(
279       collectionSize_ > 0,
280       "ERC721A: collection must have a nonzero supply"
281     );
282     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
283     _name = name_;
284     _symbol = symbol_;
285     maxBatchSize = maxBatchSize_;
286     collectionSize = collectionSize_;
287   }
288   function totalSupply() public view override returns (uint256) {
289     return currentIndex;
290   }
291   function tokenByIndex(uint256 index) public view override returns (uint256) {
292     require(index < totalSupply(), "ERC721A: global index out of bounds");
293     return index;
294   }
295   function tokenOfOwnerByIndex(address owner, uint256 index)
296     public
297     view
298     override
299     returns (uint256)
300   {
301     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
302     uint256 numMintedSoFar = totalSupply();
303     uint256 tokenIdsIdx = 0;
304     address currOwnershipAddr = address(0);
305     for (uint256 i = 0; i < numMintedSoFar; i++) {
306       TokenOwnership memory ownership = _ownerships[i];
307       if (ownership.addr != address(0)) {
308         currOwnershipAddr = ownership.addr;
309       }
310       if (currOwnershipAddr == owner) {
311         if (tokenIdsIdx == index) {
312           return i;
313         }
314         tokenIdsIdx++;
315       }
316     }
317     revert("ERC721A: unable to get token of owner by index");
318   }
319   function supportsInterface(bytes4 interfaceId)
320     public
321     view
322     virtual
323     override(ERC165, IERC165)
324     returns (bool)
325   {
326     return
327       interfaceId == type(IERC721).interfaceId ||
328       interfaceId == type(IERC721Metadata).interfaceId ||
329       interfaceId == type(IERC721Enumerable).interfaceId ||
330       super.supportsInterface(interfaceId);
331   }
332   function balanceOf(address owner) public view override returns (uint256) {
333     require(owner != address(0), "ERC721A: balance query for the zero address");
334     return uint256(_addressData[owner].balance);
335   }
336   function _numberMinted(address owner) internal view returns (uint256) {
337     require(
338       owner != address(0),
339       "ERC721A: number minted query for the zero address"
340     );
341     return uint256(_addressData[owner].numberMinted);
342   }
343   function ownershipOf(uint256 tokenId)
344     internal
345     view
346     returns (TokenOwnership memory)
347   {
348     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
349     uint256 lowestTokenToCheck;
350     if (tokenId >= maxBatchSize) {
351       lowestTokenToCheck = tokenId - maxBatchSize + 1;
352     }
353     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
354       TokenOwnership memory ownership = _ownerships[curr];
355       if (ownership.addr != address(0)) {
356         return ownership;
357       }
358     }
359     revert("ERC721A: unable to determine the owner of token");
360   }
361   function ownerOf(uint256 tokenId) public view override returns (address) {
362     return ownershipOf(tokenId).addr;
363   }
364   function name() public view virtual override returns (string memory) {
365     return _name;
366   }
367   function symbol() public view virtual override returns (string memory) {
368     return _symbol;
369   }
370   function tokenURI(uint256 tokenId)
371     public
372     view
373     virtual
374     override
375     returns (string memory)
376   {
377     require(
378       _exists(tokenId),
379       "ERC721Metadata: URI query for nonexistent token"
380     );
381     string memory baseURI = _baseURI();
382     return
383       bytes(baseURI).length > 0
384         ? string(abi.encodePacked(baseURI, tokenId.toString()))
385         : "";
386   }
387   function _baseURI() internal view virtual returns (string memory) {
388     return "";
389   }
390   function approve(address to, uint256 tokenId) public override {
391     address owner = ERC721A.ownerOf(tokenId);
392     require(to != owner, "ERC721A: approval to current owner");
393     require(
394       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
395       "ERC721A: approve caller is not owner nor approved for all"
396     );
397     _approve(to, tokenId, owner);
398   }
399   function getApproved(uint256 tokenId) public view override returns (address) {
400     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
401     return _tokenApprovals[tokenId];
402   }
403   function setApprovalForAll(address operator, bool approved) public override {
404     require(operator != _msgSender(), "ERC721A: approve to caller");
405     _operatorApprovals[_msgSender()][operator] = approved;
406     emit ApprovalForAll(_msgSender(), operator, approved);
407   }
408   function isApprovedForAll(address owner, address operator)
409     public
410     view
411     virtual
412     override
413     returns (bool)
414   {
415     return _operatorApprovals[owner][operator];
416   }
417   function transferFrom(
418     address from,
419     address to,
420     uint256 tokenId
421   ) public override {
422     _transfer(from, to, tokenId);
423   }
424   function safeTransferFrom(
425     address from,
426     address to,
427     uint256 tokenId
428   ) public override {
429     safeTransferFrom(from, to, tokenId, "");
430   }
431   function safeTransferFrom(
432     address from,
433     address to,
434     uint256 tokenId,
435     bytes memory _data
436   ) public override {
437     _transfer(from, to, tokenId);
438     require(
439       _checkOnERC721Received(from, to, tokenId, _data),
440       "ERC721A: transfer to non ERC721Receiver implementer"
441     );
442   }
443   function _exists(uint256 tokenId) internal view returns (bool) {
444     return tokenId < currentIndex;
445   }
446   function _safeMint(address to, uint256 quantity) internal {
447     _safeMint(to, quantity, "");
448   }
449   function _safeMint(
450     address to,
451     uint256 quantity,
452     bytes memory _data
453   ) internal {
454     uint256 startTokenId = currentIndex;
455     require(to != address(0), "ERC721A: mint to the zero address");
456     require(!_exists(startTokenId), "ERC721A: token already minted");
457     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
458     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
459     AddressData memory addressData = _addressData[to];
460     _addressData[to] = AddressData(
461       addressData.balance + uint128(quantity),
462       addressData.numberMinted + uint128(quantity)
463     );
464     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
465     uint256 updatedIndex = startTokenId;
466     for (uint256 i = 0; i < quantity; i++) {
467       emit Transfer(address(0), to, updatedIndex);
468       require(
469         _checkOnERC721Received(address(0), to, updatedIndex, _data),
470         "ERC721A: transfer to non ERC721Receiver implementer"
471       );
472       updatedIndex++;
473     }
474     currentIndex = updatedIndex;
475     _afterTokenTransfers(address(0), to, startTokenId, quantity);
476   }
477   function _transfer(
478     address from,
479     address to,
480     uint256 tokenId
481   ) private {
482     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
483     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
484       getApproved(tokenId) == _msgSender() ||
485       isApprovedForAll(prevOwnership.addr, _msgSender()));
486     require(
487       isApprovedOrOwner,
488       "ERC721A: transfer caller is not owner nor approved"
489     );
490     require(
491       prevOwnership.addr == from,
492       "ERC721A: transfer from incorrect owner"
493     );
494     require(to != address(0), "ERC721A: transfer to the zero address");
495     _beforeTokenTransfers(from, to, tokenId, 1);
496     _approve(address(0), tokenId, prevOwnership.addr);
497     _addressData[from].balance -= 1;
498     _addressData[to].balance += 1;
499     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
500     uint256 nextTokenId = tokenId + 1;
501     if (_ownerships[nextTokenId].addr == address(0)) {
502       if (_exists(nextTokenId)) {
503         _ownerships[nextTokenId] = TokenOwnership(
504           prevOwnership.addr,
505           prevOwnership.startTimestamp
506         );
507       }
508     }
509     emit Transfer(from, to, tokenId);
510     _afterTokenTransfers(from, to, tokenId, 1);
511   }
512   function _approve(
513     address to,
514     uint256 tokenId,
515     address owner
516   ) private {
517     _tokenApprovals[tokenId] = to;
518     emit Approval(owner, to, tokenId);
519   }
520   uint256 public nextOwnerToExplicitlySet = 0;
521   function _setOwnersExplicit(uint256 quantity) internal {
522     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
523     require(quantity > 0, "quantity must be nonzero");
524     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
525     if (endIndex > collectionSize - 1) {
526       endIndex = collectionSize - 1;
527     }
528     require(_exists(endIndex), "not enough minted yet for this cleanup");
529     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
530       if (_ownerships[i].addr == address(0)) {
531         TokenOwnership memory ownership = ownershipOf(i);
532         _ownerships[i] = TokenOwnership(
533           ownership.addr,
534           ownership.startTimestamp
535         );
536       }
537     }
538     nextOwnerToExplicitlySet = endIndex + 1;
539   }
540   function _checkOnERC721Received(
541     address from,
542     address to,
543     uint256 tokenId,
544     bytes memory _data
545   ) private returns (bool) {
546     if (to.isContract()) {
547       try
548         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
549       returns (bytes4 retval) {
550         return retval == IERC721Receiver(to).onERC721Received.selector;
551       } catch (bytes memory reason) {
552         if (reason.length == 0) {
553           revert("ERC721A: transfer to non ERC721Receiver implementer");
554         } else {
555           assembly {
556             revert(add(32, reason), mload(reason))
557           }
558         }
559       }
560     } else {
561       return true;
562     }
563   }
564   function _beforeTokenTransfers(
565     address from,
566     address to,
567     uint256 startTokenId,
568     uint256 quantity
569   ) internal virtual {}
570   function _afterTokenTransfers(
571     address from,
572     address to,
573     uint256 startTokenId,
574     uint256 quantity
575   ) internal virtual {}
576 }
577 contract SEC is ERC721A, Ownable, ReentrancyGuard {
578     string public baseTokenURI;
579     uint256 public collectionsize = 7777;
580     uint256 public reservedsize = 100;
581     uint256 public price = 0.0033 ether;
582     uint256 public maxmint = 5;
583     uint256 public freesize = 2222;
584     uint256 public mintpause=1;
585     mapping(address => uint256) public mintedq;
586 constructor() ERC721A("SecretWords", "SEC",50,7777)
587 {}
588     function _onlyMinter() private view 
589     { 
590 	require(msg.sender == tx.origin);
591     }
592     modifier onlyMinter 
593     {
594 	_onlyMinter();
595 	_;
596     }
597     function ownerMintMulti(address recipient,uint256 value) public onlyOwner returns (uint256) 
598     {
599 	_safeMint(recipient, value);
600 	return 1;
601     }
602     function isOwner(uint256 _id, address _address) public view virtual returns (bool) 
603     {
604 	return ownerOf(_id) == _address;
605     }
606     function mint(uint256 st) external payable onlyMinter nonReentrant
607     {
608 	require(mintpause==0, "Minting is not live yet!");
609 	if ( freesize < totalSupply() )
610 	{
611     	    uint256 r=msg.value%price;
612     	    require(r==0,"Bad ammount of ETH");
613     	    st=msg.value/price;
614     	    require(st>0,"Input amount=0");
615 	}
616         require(mintedq[msg.sender] + st<=maxmint,"This would exceed the maximum NFTs/address!");
617         require(totalSupply() + st <= collectionsize - reservedsize, "Sold out!" );
618         mintedq[msg.sender]+=st;
619 	_safeMint(msg.sender,st);
620     }
621     function _baseURI() internal view virtual override returns (string memory) 
622     {
623 	return baseTokenURI;
624     }
625     function setBaseTokenURI(string memory _b) public onlyOwner 
626     {
627 	baseTokenURI = _b;
628     }
629     function setcollectionsize(uint256 _p) external onlyOwner 
630     {
631 	collectionsize=_p;
632     }
633     function setfreesize(uint256 _p) external onlyOwner 
634     {
635 	freesize=_p;
636     }
637     function setreservedsize(uint256 _p) external onlyOwner 
638     {
639 	reservedsize=_p;
640     }
641     function setmintpause(uint256 _p) external onlyOwner
642     {
643         mintpause = _p;
644     }
645     function setmaxmint(uint256 _p) external onlyOwner 
646     {
647 	maxmint=_p;
648     }
649     function setprice(uint256 _p) external onlyOwner 
650     {
651 	price=_p;
652     }
653     function _sendmoney(address _address, uint256 _amount) private 
654     {
655         (bool success, ) = _address.call{value: _amount}("");
656 	require(success, "Transfer failed.");
657     }
658     function withdraw() public onlyOwner 
659     {
660 	_sendmoney(owner(),address(this).balance);
661     }
662     function withdrawto(address payable to, uint256 amount) public onlyOwner 
663     {
664 	require( address(this).balance >= amount, "Insufficient balance to withdraw");
665 	_sendmoney(to,amount);
666     }
667     function getmintstatus(address minter) public view virtual returns (string memory) 
668     {
669 	string memory o1 = string(abi.encodePacked(
670 	"mintpause:",Strings.toString(mintpause),
671 	";maxmint:",Strings.toString(maxmint),
672 	";price:",Strings.toString(price),
673 	";freesize:",Strings.toString(freesize)
674 	));
675 	string memory o2 = string(abi.encodePacked(
676 	";totalsupply:", Strings.toString(totalSupply()), 
677 	";reservedsize:", Strings.toString(reservedsize), 
678 	";collectionsize:", Strings.toString(collectionsize),
679 	";minted:", Strings.toString(mintedq[minter]) 
680 	));
681 	string memory outstring = string(abi.encodePacked(o1,o2));
682 	return outstring;
683     }
684 }