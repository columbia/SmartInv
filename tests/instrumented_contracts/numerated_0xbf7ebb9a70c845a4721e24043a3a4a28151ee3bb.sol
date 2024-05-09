1 // SPDX-License-Identifier: None
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC165 {
6 
7   function supportsInterface(bytes4 interfaceId) external view returns (bool);
8 }
9 
10 interface IERC721 is IERC165 {
11 
12   event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
13   event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
14   event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
15 
16   function balanceOf(address owner) external view returns (uint256 balance);
17   function ownerOf(uint256 tokenId) external view returns (address owner);
18 
19   function safeTransferFrom(
20     address from,
21     address to,
22     uint256 tokenId
23   ) external;
24 
25   function transferFrom(
26     address from,
27     address to,
28     uint256 tokenId
29   ) external;
30 
31   function approve(address to, uint256 tokenId) external;
32   function getApproved(uint256 tokenId) external view returns (address operator);
33   function setApprovalForAll(address operator, bool _approved) external;
34   function isApprovedForAll(address owner, address operator) external view returns (bool);
35 
36   function safeTransferFrom(
37     address from,
38     address to,
39     uint256 tokenId,
40     bytes calldata data
41   ) external;
42 }
43 
44 library Strings {
45 
46   bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
47 
48   function toString(uint256 value) internal pure returns (string memory) {
49     if (value == 0) {
50       return "0";
51     }
52     uint256 temp = value;
53     uint256 digits;
54     while (temp != 0) {
55       digits++;
56       temp /= 10;
57     }
58     bytes memory buffer = new bytes(digits);
59     while (value != 0) {
60       digits -= 1;
61       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
62       value /= 10;
63     }
64     return string(buffer);
65   }
66 
67   function toHexString(uint256 value) internal pure returns (string memory) {
68     if (value == 0) {
69       return "0x00";
70     }
71     uint256 temp = value;
72     uint256 length = 0;
73     while (temp != 0) {
74       length++;
75       temp >>= 8;
76     }
77     return toHexString(value, length);
78   }
79 
80   function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
81     bytes memory buffer = new bytes(2 * length + 2);
82     buffer[0] = "0";
83     buffer[1] = "x";
84     for (uint256 i = 2 * length + 1; i > 1; --i) {
85       buffer[i] = _HEX_SYMBOLS[value & 0xf];
86       value >>= 4;
87     }
88     require(value == 0, "Strings: hex length insufficient");
89     return string(buffer);
90   }
91 
92 }
93 
94 abstract contract Context {
95 
96   function _msgSender() internal view virtual returns (address) {
97     return msg.sender;
98   }
99 
100   function _msgData() internal view virtual returns (bytes calldata) {
101     return msg.data;
102   }
103 
104 }
105 
106 abstract contract Ownable is Context {
107 
108   address private _owner;
109 
110   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112   constructor() {
113     _transferOwnership(_msgSender());
114   }
115 
116   function owner() public view virtual returns (address) {
117     return _owner;
118   }
119 
120   modifier onlyOwner() {
121     require(owner() == _msgSender(), "Ownable: caller is not the owner");
122     _;
123   }
124 
125   function renounceOwnership() public virtual onlyOwner {
126     _transferOwnership(address(0));
127   }
128 
129   function transferOwnership(address newOwner) public virtual onlyOwner {
130     require(newOwner != address(0), "Ownable: new owner is the zero address");
131     _transferOwnership(newOwner);
132   }
133 
134   function _transferOwnership(address newOwner) internal virtual {
135     address oldOwner = _owner;
136     _owner = newOwner;
137     emit OwnershipTransferred(oldOwner, newOwner);
138   }
139 }
140 
141 library Address {
142 
143   function isContract(address account) internal view returns (bool) {
144 
145     uint256 size;
146     assembly {
147       size := extcodesize(account)
148     }
149     return size > 0;
150   }
151 
152   function sendValue(address payable recipient, uint256 amount) internal {
153     require(address(this).balance >= amount, "Address: insufficient balance");
154 
155     (bool success, ) = recipient.call{value: amount}("");
156     require(success, "Address: unable to send value, recipient may have reverted");
157   }
158 
159   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
160     return functionCall(target, data, "Address: low-level call failed");
161   }
162 
163   function functionCall(
164     address target,
165     bytes memory data,
166     string memory errorMessage
167   ) internal returns (bytes memory) {
168     return functionCallWithValue(target, data, 0, errorMessage);
169   }
170 
171   function functionCallWithValue(
172     address target,
173     bytes memory data,
174     uint256 value
175   ) internal returns (bytes memory) {
176     return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
177   }
178 
179   function functionCallWithValue(
180     address target,
181     bytes memory data,
182     uint256 value,
183     string memory errorMessage
184   ) internal returns (bytes memory) {
185     require(address(this).balance >= value, "Address: insufficient balance for call");
186     require(isContract(target), "Address: call to non-contract");
187 
188     (bool success, bytes memory returndata) = target.call{value: value}(data);
189     return _verifyCallResult(success, returndata, errorMessage);
190   }
191 
192   function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
193     return functionStaticCall(target, data, "Address: low-level static call failed");
194   }
195 
196   function functionStaticCall(
197     address target,
198     bytes memory data,
199     string memory errorMessage
200   ) internal view returns (bytes memory) {
201     require(isContract(target), "Address: static call to non-contract");
202 
203     (bool success, bytes memory returndata) = target.staticcall(data);
204     return _verifyCallResult(success, returndata, errorMessage);
205   }
206 
207   function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
208     return functionDelegateCall(target, data, "Address: low-level delegate call failed");
209   }
210 
211   function functionDelegateCall(
212     address target,
213     bytes memory data,
214     string memory errorMessage
215   ) internal returns (bytes memory) {
216     require(isContract(target), "Address: delegate call to non-contract");
217 
218     (bool success, bytes memory returndata) = target.delegatecall(data);
219     return _verifyCallResult(success, returndata, errorMessage);
220   }
221 
222   function _verifyCallResult(
223     bool success,
224     bytes memory returndata,
225     string memory errorMessage
226   ) private pure returns (bytes memory) {
227     if (success) {
228       return returndata;
229     } else {
230       if (returndata.length > 0) {
231         assembly {
232           let returndata_size := mload(returndata)
233           revert(add(32, returndata), returndata_size)
234         }
235       } else {
236         revert(errorMessage);
237       }
238     }
239   }
240 }
241 
242 interface IERC721Receiver {
243 
244   function onERC721Received(
245     address operator,
246     address from,
247     uint256 tokenId,
248     bytes calldata data
249   ) external returns (bytes4);
250 }
251 
252 abstract contract ERC165 is IERC165 {
253 
254   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
255     return interfaceId == type(IERC165).interfaceId;
256   }
257 
258 }
259 
260 interface IERC721Enumerable is IERC721 {
261 
262   function totalSupply() external view returns (uint256);
263   function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
264   function tokenByIndex(uint256 index) external view returns (uint256);
265 
266 }
267 
268 interface IERC721Metadata is IERC721 {
269 
270   function name() external view returns (string memory);
271   function symbol() external view returns (string memory);
272   function tokenURI(uint256 tokenId) external view returns (string memory);
273 
274 }
275 
276 //ERC721A contract was taken as bases, but was modified, so that the indexing would start from 1
277 //Modified version name: ERC721VI
278 contract ERC721VI is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
279 
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
293   uint256 internal currentIndex = 1;
294   uint256 internal immutable maxBatchSize;
295   string private _name;
296   string private _symbol;
297 
298   mapping(uint256 => TokenOwnership) internal _ownerships;
299   mapping(address => AddressData) private _addressData;
300   mapping(uint256 => address) private _tokenApprovals;
301   mapping(address => mapping(address => bool)) private _operatorApprovals;
302 
303   constructor(
304     string memory name_,
305     string memory symbol_,
306     uint256 maxBatchSize_
307   ) {
308     require(maxBatchSize_ > 0, 'ERC721VI: max batch size must be nonzero');
309     _name = name_;
310     _symbol = symbol_;
311     maxBatchSize = maxBatchSize_;
312   }
313 
314   function totalSupply() public view override returns (uint256) {
315     return currentIndex - 1;
316   }
317 
318   function tokenByIndex(uint256 index) public view override returns (uint256) {
319     require(index < totalSupply(), 'ERC721VI: global index out of bounds');
320     return index;
321   }
322 
323   function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
324     require(index < balanceOf(owner), 'ERC721VI: owner index out of bounds');
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
340     revert('ERC721VI: unable to get token of owner by index');
341   }
342 
343   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
344     return
345       interfaceId == type(IERC721).interfaceId ||
346       interfaceId == type(IERC721Metadata).interfaceId ||
347       interfaceId == type(IERC721Enumerable).interfaceId ||
348       super.supportsInterface(interfaceId);
349   }
350 
351   function balanceOf(address owner) public view override returns (uint256) {
352     require(owner != address(0), 'ERC721VI: balance query for the zero address');
353     return uint256(_addressData[owner].balance);
354   }
355 
356   function _numberMinted(address owner) internal view returns (uint256) {
357     require(owner != address(0), 'ERC721VI: number minted query for the zero address');
358     return uint256(_addressData[owner].numberMinted);
359   }
360 
361   function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
362     require(_exists(tokenId), 'ERC721VI: owner query for nonexistent token');
363 
364     uint256 lowestTokenToCheck;
365     if (tokenId >= maxBatchSize) {
366       lowestTokenToCheck = tokenId - maxBatchSize + 1;
367     }
368 
369     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
370       TokenOwnership memory ownership = _ownerships[curr];
371       if (ownership.addr != address(0)) {
372         return ownership;
373       }
374     }
375 
376     revert('ERC721VI: unable to determine the owner of token');
377   }
378 
379   function ownerOf(uint256 tokenId) public view override returns (address) {
380     return ownershipOf(tokenId).addr;
381   }
382 
383   function name() public view virtual override returns (string memory) {
384     return _name;
385   }
386 
387   function symbol() public view virtual override returns (string memory) {
388     return _symbol;
389   }
390 
391   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
392     require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
393 
394     string memory baseURI = _baseURI();
395     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
396   }
397 
398   function _baseURI() internal view virtual returns (string memory) {
399     return '';
400   }
401 
402   function approve(address to, uint256 tokenId) public override {
403     address owner = ERC721VI.ownerOf(tokenId);
404     require(to != owner, 'ERC721VI: approval to current owner');
405 
406     require(
407       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
408       'ERC721VI: approve caller is not owner nor approved for all'
409     );
410 
411     _approve(to, tokenId, owner);
412   }
413 
414   function getApproved(uint256 tokenId) public view override returns (address) {
415     require(_exists(tokenId), 'ERC721VI: approved query for nonexistent token');
416 
417     return _tokenApprovals[tokenId];
418   }
419 
420   function setApprovalForAll(address operator, bool approved) public override {
421     require(operator != _msgSender(), 'ERC721VI: approve to caller');
422 
423     _operatorApprovals[_msgSender()][operator] = approved;
424     emit ApprovalForAll(_msgSender(), operator, approved);
425   }
426 
427   function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
428     return _operatorApprovals[owner][operator];
429   }
430 
431   function transferFrom(
432     address from,
433     address to,
434     uint256 tokenId
435   ) public override {
436     _transfer(from, to, tokenId);
437   }
438 
439   function safeTransferFrom(
440     address from,
441     address to,
442     uint256 tokenId
443   ) public override {
444     safeTransferFrom(from, to, tokenId, '');
445   }
446 
447   function safeTransferFrom(
448     address from,
449     address to,
450     uint256 tokenId,
451     bytes memory _data
452   ) public override {
453     _transfer(from, to, tokenId);
454     require(
455       _checkOnERC721Received(from, to, tokenId, _data),
456       'ERC721VI: transfer to non ERC721Receiver implementer'
457     );
458   }
459 
460   function _exists(uint256 tokenId) internal view returns (bool) {
461     require(tokenId > 0, 'Indexing starts from 1');
462     return tokenId < currentIndex;
463   }
464 
465   function _safeMint(address to, uint256 quantity) internal {
466     _safeMint(to, quantity, '');
467   }
468 
469   function _safeMint(
470     address to,
471     uint256 quantity,
472     bytes memory _data
473   ) internal {
474     uint256 startTokenId = currentIndex;
475     require(to != address(0), 'ERC721VI: mint to the zero address');
476     require(!_exists(startTokenId), 'ERC721VI: token already minted');
477     require(quantity <= maxBatchSize, 'ERC721VI: quantity to mint too high');
478     require(quantity > 0, 'ERC721VI: quantity must be greater 0');
479 
480     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
481 
482     AddressData memory addressData = _addressData[to];
483     _addressData[to] = AddressData(
484       addressData.balance + uint128(quantity),
485       addressData.numberMinted + uint128(quantity)
486     );
487     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
488 
489     uint256 updatedIndex = startTokenId;
490 
491     for (uint256 i = 0; i < quantity; i++) {
492       emit Transfer(address(0), to, updatedIndex);
493       require(
494         _checkOnERC721Received(address(0), to, updatedIndex, _data),
495         'ERC721VI: transfer to non ERC721Receiver implementer'
496       );
497       updatedIndex++;
498     }
499 
500     currentIndex = updatedIndex;
501     _afterTokenTransfers(address(0), to, startTokenId, quantity);
502   }
503 
504   function _transfer(
505     address from,
506     address to,
507     uint256 tokenId
508   ) private {
509     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
510 
511     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
512       getApproved(tokenId) == _msgSender() ||
513       isApprovedForAll(prevOwnership.addr, _msgSender()));
514 
515     require(isApprovedOrOwner, 'ERC721VI: transfer caller is not owner nor approved');
516 
517     require(prevOwnership.addr == from, 'ERC721VI: transfer from incorrect owner');
518     require(to != address(0), 'ERC721VI: transfer to the zero address');
519 
520     _beforeTokenTransfers(from, to, tokenId, 1);
521 
522     _approve(address(0), tokenId, prevOwnership.addr);
523 
524     unchecked {
525       _addressData[from].balance -= 1;
526       _addressData[to].balance += 1;
527     }
528 
529     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
530 
531     uint256 nextTokenId = tokenId + 1;
532     if (_ownerships[nextTokenId].addr == address(0)) {
533       if (_exists(nextTokenId)) {
534         _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
535       }
536     }
537 
538     emit Transfer(from, to, tokenId);
539     _afterTokenTransfers(from, to, tokenId, 1);
540   }
541 
542   function _approve(
543     address to,
544     uint256 tokenId,
545     address owner
546   ) private {
547     _tokenApprovals[tokenId] = to;
548     emit Approval(owner, to, tokenId);
549   }
550 
551   function _checkOnERC721Received(
552     address from,
553     address to,
554     uint256 tokenId,
555     bytes memory _data
556   ) private returns (bool) {
557     if (to.isContract()) {
558       try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
559         return retval == IERC721Receiver(to).onERC721Received.selector;
560       } catch (bytes memory reason) {
561         if (reason.length == 0) {
562           revert('ERC721VI: transfer to non ERC721Receiver implementer');
563         } else {
564           assembly {
565             revert(add(32, reason), mload(reason))
566           }
567         }
568       }
569     } else {
570       return true;
571     }
572   }
573 
574   function _beforeTokenTransfers(
575     address from,
576     address to,
577     uint256 startTokenId,
578     uint256 quantity
579   ) internal virtual {}
580 
581   function _afterTokenTransfers(
582     address from,
583     address to,
584     uint256 startTokenId,
585     uint256 quantity
586   ) internal virtual {}
587 }
588 
589 
590 //██████╗░███████╗██████╗░░█████╗░  ██████╗░░██████╗░░█████╗░███████╗
591 //██╔══██╗██╔════╝██╔══██╗██╔══██╗  ██╔══██╗██╔════╝░██╔══██╗██╔════╝
592 //██████╔╝█████╗░░██████╔╝██║░░██║  ██║░░██║██║░░██╗░███████║█████╗░░
593 //██╔═══╝░██╔══╝░░██╔═══╝░██║░░██║  ██║░░██║██║░░╚██╗██╔══██║██╔══╝░░
594 //██║░░░░░███████╗██║░░░░░╚█████╔╝  ██████╔╝╚██████╔╝██║░░██║██║░░░░░
595 //╚═╝░░░░░╚══════╝╚═╝░░░░░░╚════╝░  ╚═════╝░░╚═════╝░╚═╝░░╚═╝╚═╝░░░░░
596 
597 contract PepoDGAF is ERC721VI, Ownable {
598   using Strings for uint256;
599 
600   string private _apiURI = "";
601   bool public paused = true;
602   uint256 public price = 0.04 ether; 
603   uint256 public maxSupply = 3333; 
604   uint256 public maxPerTx = 10;
605 
606   address token1 = 0x8FA600364B93C53e0c71C7A33d2adE21f4351da3; //Larva Chads
607   address token2 = 0xbad6186E92002E312078b5a1dAfd5ddf63d3f731; //Anonymice
608   address token3 = 0x15Cc16BfE6fAC624247490AA29B6D632Be549F00; //AnonymiceBreeding
609   address token4 = 0x42069ABFE407C60cf4ae4112bEDEaD391dBa1cdB; //CryptoDickbutts
610 
611   constructor() ERC721VI("Pepo DGAF", "PepoDGAF", maxPerTx) {}
612 
613   modifier mintCompliance(uint256 _mintAmount) {
614     require(_mintAmount > 0 && _mintAmount <= maxPerTx, "Invalid mint amount!");
615     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
616     _;
617   }
618 
619   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
620     require(!paused, "The contract is paused for now!");
621 
622     uint _userBalance1 = IERC721(token1).balanceOf(msg.sender);
623     uint _userBalance2 = IERC721(token2).balanceOf(msg.sender);
624     uint _userBalance3 = IERC721(token3).balanceOf(msg.sender);
625     uint _userBalance4 = IERC721(token4).balanceOf(msg.sender);
626 
627     if (_userBalance1 + _userBalance2 + _userBalance3 + _userBalance4 > 0) { // owns one of the nft
628       require(msg.value >= price * _mintAmount / 2, "Insufficient funds!");
629       _safeMint(msg.sender, _mintAmount);
630     } else {
631       require(msg.value >= price * _mintAmount, "Insufficient funds!");
632       _safeMint(msg.sender, _mintAmount);
633     }
634   }
635 
636   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
637     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
638 
639     string memory currentBaseURI = _baseURI();
640     return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : "";
641   }
642 
643   function togglePaused() public onlyOwner {
644     paused = !paused;
645   }
646 
647   function _baseURI() internal view virtual override returns (string memory) {
648     return _apiURI;
649   }
650 
651   function setBaseURI(string memory _uri) public onlyOwner {
652     _apiURI = _uri;
653   }
654 
655   function setMaxPerTx(uint256 _maxPerTx) public onlyOwner {
656     maxPerTx = _maxPerTx;
657   }
658 
659   function setPrice(uint256 _price) public onlyOwner {
660     price = _price;
661   }
662 
663   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
664     maxSupply = _maxSupply;
665   }
666 
667   function withdrawall() public onlyOwner {
668     uint256 _balance = address(this).balance;
669     require(payable(0x58366d849685eE52A1faB9F04e29Cb1A6Ba03029).send(_balance));
670   }
671 }