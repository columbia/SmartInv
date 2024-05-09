1 /**    
2  *      _    _______                      _   
3        | |  |_____  \            _       | |        
4        | |        \  |          | |      | |
5        | |    ____|  |          | |      | |____  
6        | |   |_____  |      ____|_|____  |  ___  \
7        | |         | |     |____| |____| | |    | |
8        | |   _____/  |          | |____  | |    | |
9        |_|  |_______/           |______| |_|    |_|
10 */                                        
11 // SPDX-License-Identifier: MIT
12 //Developer Info: 13th District 
13 
14 
15 pragma solidity ^0.8.0;
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 pragma solidity ^0.8.0;
27 library Strings {
28     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
29 
30     function toString(uint256 value) internal pure returns (string memory) {
31         if (value == 0) {
32             return "0";
33         }
34         uint256 temp = value;
35         uint256 digits;
36         while (temp != 0) {
37             digits++;
38             temp /= 10;
39         }
40         bytes memory buffer = new bytes(digits);
41         while (value != 0) {
42             digits -= 1;
43             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44             value /= 10;
45         }
46         return string(buffer);
47     }
48 
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 
76 pragma solidity ^0.8.1;
77 library Address {
78     function isContract(address account) internal view returns (bool) {
79         return account.code.length > 0;
80     }
81 
82     function sendValue(address payable recipient, uint256 amount) internal {
83         require(address(this).balance >= amount, "Address: insufficient balance");
84 
85         (bool success, ) = recipient.call{value: amount}("");
86         require(success, "Address: unable to send value, recipient may have reverted");
87     }
88 
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     function functionCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     function functionCallWithValue(
102         address target,
103         bytes memory data,
104         uint256 value
105     ) internal returns (bytes memory) {
106         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
107     }
108 
109     function functionCallWithValue(
110         address target,
111         bytes memory data,
112         uint256 value,
113         string memory errorMessage
114     ) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         require(isContract(target), "Address: call to non-contract");
117 
118         (bool success, bytes memory returndata) = target.call{value: value}(data);
119         return verifyCallResult(success, returndata, errorMessage);
120     }
121 
122     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
123         return functionStaticCall(target, data, "Address: low-level static call failed");
124     }
125 
126     function functionStaticCall(
127         address target,
128         bytes memory data,
129         string memory errorMessage
130     ) internal view returns (bytes memory) {
131         require(isContract(target), "Address: static call to non-contract");
132 
133         (bool success, bytes memory returndata) = target.staticcall(data);
134         return verifyCallResult(success, returndata, errorMessage);
135     }
136 
137     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
138         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
139     }
140 
141     function functionDelegateCall(
142         address target,
143         bytes memory data,
144         string memory errorMessage
145     ) internal returns (bytes memory) {
146         require(isContract(target), "Address: delegate call to non-contract");
147 
148         (bool success, bytes memory returndata) = target.delegatecall(data);
149         return verifyCallResult(success, returndata, errorMessage);
150     }
151 
152     function verifyCallResult(
153         bool success,
154         bytes memory returndata,
155         string memory errorMessage
156     ) internal pure returns (bytes memory) {
157         if (success) {
158             return returndata;
159         } else {
160             if (returndata.length > 0) {
161                 assembly {
162                     let returndata_size := mload(returndata)
163                     revert(add(32, returndata), returndata_size)
164                 }
165             } else {
166                 revert(errorMessage);
167             }
168         }
169     }
170 }
171 
172 pragma solidity ^0.8.0;
173 interface IERC721Receiver {
174     function onERC721Received(
175         address operator,
176         address from,
177         uint256 tokenId,
178         bytes calldata data
179     ) external returns (bytes4);
180 }
181 
182 pragma solidity ^0.8.0;
183 interface IERC165 {
184     function supportsInterface(bytes4 interfaceId) external view returns (bool);
185 }
186 
187 pragma solidity ^0.8.0;
188 abstract contract ERC165 is IERC165 {
189     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
190         return interfaceId == type(IERC165).interfaceId;
191     }
192 }
193 
194 pragma solidity ^0.8.0;
195 interface IERC721 is IERC165 {
196     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
197     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
198     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
199     function balanceOf(address owner) external view returns (uint256 balance);
200     function ownerOf(uint256 tokenId) external view returns (address owner);
201     function safeTransferFrom(
202         address from,
203         address to,
204         uint256 tokenId
205     ) external;
206 
207     function transferFrom(
208         address from,
209         address to,
210         uint256 tokenId
211     ) external;
212 
213     function approve(address to, uint256 tokenId) external;
214 
215     function getApproved(uint256 tokenId) external view returns (address operator);
216 
217     function setApprovalForAll(address operator, bool _approved) external;
218 
219     function isApprovedForAll(address owner, address operator) external view returns (bool);
220 
221     function safeTransferFrom(
222         address from,
223         address to,
224         uint256 tokenId,
225         bytes calldata data
226     ) external;
227 }
228 
229 pragma solidity ^0.8.0;
230 interface IERC721Metadata is IERC721 {
231     function name() external view returns (string memory);
232     function symbol() external view returns (string memory);
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 pragma solidity ^0.8.4;
237 error ApprovalCallerNotOwnerNorApproved();
238 error ApprovalQueryForNonexistentToken();
239 error ApproveToCaller();
240 error ApprovalToCurrentOwner();
241 error BalanceQueryForZeroAddress();
242 error MintToZeroAddress();
243 error MintZeroQuantity();
244 error OwnerQueryForNonexistentToken();
245 error TransferCallerNotOwnerNorApproved();
246 error TransferFromIncorrectOwner();
247 error TransferToNonERC721ReceiverImplementer();
248 error TransferToZeroAddress();
249 error URIQueryForNonexistentToken();
250 
251 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
252     using Address for address;
253     using Strings for uint256;
254     struct TokenOwnership {
255         address addr;
256         uint64 startTimestamp;
257         bool burned;
258     }
259 
260     struct AddressData {
261         uint64 balance;
262         uint64 numberMinted;
263         uint64 numberBurned;
264         uint64 aux;
265     }
266 
267     uint256 internal _currentIndex;
268     uint256 internal _burnCounter;
269     string private _name;
270     string private _symbol;
271     mapping(uint256 => TokenOwnership) internal _ownerships;
272     mapping(address => AddressData) private _addressData;
273     mapping(uint256 => address) private _tokenApprovals;
274     mapping(address => mapping(address => bool)) private _operatorApprovals;
275 
276     constructor(string memory name_, string memory symbol_) {
277         _name = name_;
278         _symbol = symbol_;
279         _currentIndex = _startTokenId();
280     }
281 
282     function _startTokenId() internal view virtual returns (uint256) {
283         return 1;
284     }
285 
286     function totalSupply() public view returns (uint256) {
287         unchecked {
288             return _currentIndex - _burnCounter - _startTokenId();
289         }
290     }
291 
292     function _totalMinted() internal view returns (uint256) {
293         unchecked {
294             return _currentIndex - _startTokenId();
295         }
296     }
297 
298     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
299         return
300             interfaceId == type(IERC721).interfaceId ||
301             interfaceId == type(IERC721Metadata).interfaceId ||
302             super.supportsInterface(interfaceId);
303     }
304 
305     function balanceOf(address owner) public view override returns (uint256) {
306         if (owner == address(0)) revert BalanceQueryForZeroAddress();
307         return uint256(_addressData[owner].balance);
308     }
309 
310     function _numberMinted(address owner) internal view returns (uint256) {
311         return uint256(_addressData[owner].numberMinted);
312     }
313 
314     function _numberBurned(address owner) internal view returns (uint256) {
315         return uint256(_addressData[owner].numberBurned);
316     }
317 
318     function _getAux(address owner) internal view returns (uint64) {
319         return _addressData[owner].aux;
320     }
321 
322     function _setAux(address owner, uint64 aux) internal {
323         _addressData[owner].aux = aux;
324     }
325 
326     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
327         uint256 curr = tokenId;
328         unchecked {
329             if (_startTokenId() <= curr && curr < _currentIndex) {
330                 TokenOwnership memory ownership = _ownerships[curr];
331                 if (!ownership.burned) {
332                     if (ownership.addr != address(0)) {
333                         return ownership;
334                     }
335                     while (true) {
336                         curr--;
337                         ownership = _ownerships[curr];
338                         if (ownership.addr != address(0)) {
339                             return ownership;
340                         }
341                     }
342                 }
343             }
344         }
345         revert OwnerQueryForNonexistentToken();
346     }
347 
348     function ownerOf(uint256 tokenId) public view override returns (address) {
349         return _ownershipOf(tokenId).addr;
350     }
351 
352     function name() public view virtual override returns (string memory) {
353         return _name;
354     }
355 
356     function symbol() public view virtual override returns (string memory) {
357         return _symbol;
358     }
359 
360     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
361         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
362 
363         string memory baseURI = _baseURI();
364         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
365     }
366 
367     function _baseURI() internal view virtual returns (string memory) {
368         return '';
369     }
370 
371     function approve(address to, uint256 tokenId) public override {
372         address owner = ERC721A.ownerOf(tokenId);
373         if (to == owner) revert ApprovalToCurrentOwner();
374 
375         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
376             revert ApprovalCallerNotOwnerNorApproved();
377         }
378 
379         _approve(to, tokenId, owner);
380     }
381 
382     function getApproved(uint256 tokenId) public view override returns (address) {
383         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
384 
385         return _tokenApprovals[tokenId];
386     }
387 
388     function setApprovalForAll(address operator, bool approved) public virtual override {
389         if (operator == _msgSender()) revert ApproveToCaller();
390 
391         _operatorApprovals[_msgSender()][operator] = approved;
392         emit ApprovalForAll(_msgSender(), operator, approved);
393     }
394 
395     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
396         return _operatorApprovals[owner][operator];
397     }
398 
399     function transferFrom(
400         address from,
401         address to,
402         uint256 tokenId
403     ) public virtual override {
404         _transfer(from, to, tokenId);
405     }
406 
407     function safeTransferFrom(
408         address from,
409         address to,
410         uint256 tokenId
411     ) public virtual override {
412         safeTransferFrom(from, to, tokenId, '');
413     }
414 
415     function safeTransferFrom(
416         address from,
417         address to,
418         uint256 tokenId,
419         bytes memory _data
420     ) public virtual override {
421         _transfer(from, to, tokenId);
422         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
423             revert TransferToNonERC721ReceiverImplementer();
424         }
425     }
426 
427     function _exists(uint256 tokenId) internal view returns (bool) {
428         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
429             !_ownerships[tokenId].burned;
430     }
431 
432     function _safeMint(address to, uint256 quantity) internal {
433         _safeMint(to, quantity, '');
434     }
435 
436     function _safeMint(
437         address to,
438         uint256 quantity,
439         bytes memory _data
440     ) internal {
441         _mint(to, quantity, _data, true);
442     }
443 
444     function _mint(
445         address to,
446         uint256 quantity,
447         bytes memory _data,
448         bool safe
449     ) internal {
450         uint256 startTokenId = _currentIndex;
451         if (to == address(0)) revert MintToZeroAddress();
452         if (quantity == 0) revert MintZeroQuantity();
453 
454         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
455 
456         unchecked {
457             _addressData[to].balance += uint64(quantity);
458             _addressData[to].numberMinted += uint64(quantity);
459 
460             _ownerships[startTokenId].addr = to;
461             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
462 
463             uint256 updatedIndex = startTokenId;
464             uint256 end = updatedIndex + quantity;
465 
466             if (safe && to.isContract()) {
467                 do {
468                     emit Transfer(address(0), to, updatedIndex);
469                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
470                         revert TransferToNonERC721ReceiverImplementer();
471                     }
472                 } while (updatedIndex != end);
473                 if (_currentIndex != startTokenId) revert();
474             } else {
475                 do {
476                     emit Transfer(address(0), to, updatedIndex++);
477                 } while (updatedIndex != end);
478             }
479             _currentIndex = updatedIndex;
480         }
481         _afterTokenTransfers(address(0), to, startTokenId, quantity);
482     }
483 
484     function _transfer(
485         address from,
486         address to,
487         uint256 tokenId
488     ) private {
489         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
490 
491         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
492 
493         bool isApprovedOrOwner = (_msgSender() == from ||
494             isApprovedForAll(from, _msgSender()) ||
495             getApproved(tokenId) == _msgSender());
496 
497         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
498         if (to == address(0)) revert TransferToZeroAddress();
499 
500         _beforeTokenTransfers(from, to, tokenId, 1);
501 
502         _approve(address(0), tokenId, from);
503 
504         unchecked {
505             _addressData[from].balance -= 1;
506             _addressData[to].balance += 1;
507 
508             TokenOwnership storage currSlot = _ownerships[tokenId];
509             currSlot.addr = to;
510             currSlot.startTimestamp = uint64(block.timestamp);
511 
512             uint256 nextTokenId = tokenId + 1;
513             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
514             if (nextSlot.addr == address(0)) {
515                 if (nextTokenId != _currentIndex) {
516                     nextSlot.addr = from;
517                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
518                 }
519             }
520         }
521 
522         emit Transfer(from, to, tokenId);
523         _afterTokenTransfers(from, to, tokenId, 1);
524     }
525 
526     function _burn(uint256 tokenId) internal virtual {
527         _burn(tokenId, false);
528     }
529 
530     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
531         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
532 
533         address from = prevOwnership.addr;
534 
535         if (approvalCheck) {
536             bool isApprovedOrOwner = (_msgSender() == from ||
537                 isApprovedForAll(from, _msgSender()) ||
538                 getApproved(tokenId) == _msgSender());
539 
540             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
541         }
542 
543         _beforeTokenTransfers(from, address(0), tokenId, 1);
544 
545         _approve(address(0), tokenId, from);
546 
547         unchecked {
548             AddressData storage addressData = _addressData[from];
549             addressData.balance -= 1;
550             addressData.numberBurned += 1;
551 
552             TokenOwnership storage currSlot = _ownerships[tokenId];
553             currSlot.addr = from;
554             currSlot.startTimestamp = uint64(block.timestamp);
555             currSlot.burned = true;
556 
557             uint256 nextTokenId = tokenId + 1;
558             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
559             if (nextSlot.addr == address(0)) {
560                 if (nextTokenId != _currentIndex) {
561                     nextSlot.addr = from;
562                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
563                 }
564             }
565         }
566 
567         emit Transfer(from, address(0), tokenId);
568         _afterTokenTransfers(from, address(0), tokenId, 1);
569 
570         unchecked {
571             _burnCounter++;
572         }
573     }
574 
575     function _approve(
576         address to,
577         uint256 tokenId,
578         address owner
579     ) private {
580         _tokenApprovals[tokenId] = to;
581         emit Approval(owner, to, tokenId);
582     }
583 
584     function _checkContractOnERC721Received(
585         address from,
586         address to,
587         uint256 tokenId,
588         bytes memory _data
589     ) private returns (bool) {
590         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
591             return retval == IERC721Receiver(to).onERC721Received.selector;
592         } catch (bytes memory reason) {
593             if (reason.length == 0) {
594                 revert TransferToNonERC721ReceiverImplementer();
595             } else {
596                 assembly {
597                     revert(add(32, reason), mload(reason))
598                 }
599             }
600         }
601     }
602 
603     function _beforeTokenTransfers(
604         address from,
605         address to,
606         uint256 startTokenId,
607         uint256 quantity
608     ) internal virtual {}
609 
610     function _afterTokenTransfers(
611         address from,
612         address to,
613         uint256 startTokenId,
614         uint256 quantity
615     ) internal virtual {}
616 }
617 
618 abstract contract Ownable is Context {
619     address private _owner;
620 
621     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
622 
623     constructor() {
624         _transferOwnership(_msgSender());
625     }
626 
627     function owner() public view virtual returns (address) {
628         return _owner;
629     }
630 
631     modifier onlyOwner() {
632         require(owner() == _msgSender() , "Ownable: caller is not the owner");
633         _;
634     }
635 
636     function renounceOwnership() public virtual onlyOwner {
637         _transferOwnership(address(0));
638     }
639 
640     function transferOwnership(address newOwner) public virtual onlyOwner {
641         require(newOwner != address(0), "Ownable: new owner is the zero address");
642         _transferOwnership(newOwner);
643     }
644 
645     function _transferOwnership(address newOwner) internal virtual {
646         address oldOwner = _owner;
647         _owner = newOwner;
648         emit OwnershipTransferred(oldOwner, newOwner);
649     }
650 }
651 pragma solidity ^0.8.13;
652 interface IOperatorFilterRegistry {
653     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
654     function register(address registrant) external;
655     function registerAndSubscribe(address registrant, address subscription) external;
656     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
657     function updateOperator(address registrant, address operator, bool filtered) external;
658     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
659     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
660     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
661     function subscribe(address registrant, address registrantToSubscribe) external;
662     function unsubscribe(address registrant, bool copyExistingEntries) external;
663     function subscriptionOf(address addr) external returns (address registrant);
664     function subscribers(address registrant) external returns (address[] memory);
665     function subscriberAt(address registrant, uint256 index) external returns (address);
666     function copyEntriesOf(address registrant, address registrantToCopy) external;
667     function isOperatorFiltered(address registrant, address operator) external returns (bool);
668     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
669     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
670     function filteredOperators(address addr) external returns (address[] memory);
671     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
672     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
673     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
674     function isRegistered(address addr) external returns (bool);
675     function codeHashOf(address addr) external returns (bytes32);
676 }
677 
678 pragma solidity ^0.8.13;
679 abstract contract OperatorFilterer {
680     error OperatorNotAllowed(address operator);
681 
682     IOperatorFilterRegistry constant operatorFilterRegistry =
683         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
684 
685     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
686         if (address(operatorFilterRegistry).code.length > 0) {
687             if (subscribe) {
688                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
689             } else {
690                 if (subscriptionOrRegistrantToCopy != address(0)) {
691                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
692                 } else {
693                     operatorFilterRegistry.register(address(this));
694                 }
695             }
696         }
697     }
698 
699     modifier onlyAllowedOperator(address from) virtual {
700         if (address(operatorFilterRegistry).code.length > 0) {
701             if (from == msg.sender) {
702                 _;
703                 return;
704             }
705             if (
706                 !(
707                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
708                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
709                 )
710             ) {
711                 revert OperatorNotAllowed(msg.sender);
712             }
713         }
714         _;
715     }
716 }
717 
718 pragma solidity ^0.8.13;
719 abstract contract DefaultOperatorFilterer is OperatorFilterer {
720     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
721 
722     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
723 }
724     pragma solidity ^0.8.7;
725     
726     contract ThirteenDistrict is ERC721A, DefaultOperatorFilterer , Ownable {
727     using Strings for uint256;
728 
729 
730   string private uriPrefix ;
731   string private uriSuffix = ".json";
732   string public hiddenURL;
733 
734   uint256 public cost = 0.005 ether;
735  
736   uint16 public maxSupply = 420;
737   uint8 public maxMintAmountPerTx = 2;
738   uint8 public maxMintAmountPerWallet = 2;
739                                                              
740  
741   bool public paused = true;
742   bool public reveal =false;
743 
744   mapping (address => uint8) public NFTPerPublicAddress;
745 
746   constructor() ERC721A("13th District Genesis", "13thDG") { }
747 
748   function mint(uint8 _mintAmount) external payable  {
749 
750     require(!paused, "The contract is paused!");
751     uint16 totalSupply = uint16(totalSupply());
752     uint8 nft = NFTPerPublicAddress[msg.sender];
753     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
754     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
755     require(_mintAmount + nft <= maxMintAmountPerWallet, "Exceeds max mint.");
756     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
757     
758      _safeMint(msg.sender , _mintAmount);
759      NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
760      delete totalSupply;
761      delete _mintAmount;
762   }
763   
764   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
765      uint16 totalSupply = uint16(totalSupply());
766     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
767      _safeMint(_receiver , _mintAmount);
768      delete _mintAmount;
769      delete _receiver;
770      delete totalSupply;
771   }
772 
773   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
774      uint16 totalSupply = uint16(totalSupply());
775      uint totalAmount =   _amountPerAddress * addresses.length;
776     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
777      for (uint256 i = 0; i < addresses.length; i++) {
778             _safeMint(addresses[i], _amountPerAddress);
779         }
780 
781      delete _amountPerAddress;
782      delete totalSupply;
783   }
784 
785   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
786       maxSupply = _maxSupply;
787   }
788 
789   function tokenURI(uint256 _tokenId)
790     public
791     view
792     virtual
793     override
794     returns (string memory) {
795     require(
796       _exists(_tokenId),
797       "ERC721Metadata: URI query for nonexistent token"
798     );
799 
800     if ( reveal == false) {
801         return hiddenURL;
802     }
803     
804     string memory currentBaseURI = _baseURI();
805     return bytes(currentBaseURI).length > 0
806         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
807         : "";
808   }
809  
810  function setMaxLimitPerAddress(uint8 _limit) external onlyOwner{
811     maxMintAmountPerWallet = _limit;
812    delete _limit;
813 
814 }
815   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
816     uriPrefix = _uriPrefix;
817   }
818    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
819     hiddenURL = _uriPrefix;
820   }
821 
822 
823   function setPaused() external onlyOwner {
824     paused = !paused;
825    
826   }
827 
828   function setCost(uint _cost) external onlyOwner{
829       cost = _cost;
830 
831   }
832 
833  function setRevealed() external onlyOwner{
834      reveal = !reveal;
835  }
836 
837   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
838       maxMintAmountPerTx = _maxtx;
839   }
840 
841   function withdraw() external onlyOwner {
842   uint _balance = address(this).balance;
843      payable(msg.sender).transfer(_balance ); 
844        
845   }
846 
847   function _baseURI() internal view  override returns (string memory) {
848     return uriPrefix;
849   }
850 
851     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
852         super.transferFrom(from, to, tokenId);
853     }
854 
855     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
856         super.safeTransferFrom(from, to, tokenId);
857     }
858 
859     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
860         public
861         override
862         onlyAllowedOperator(from)
863     {
864         super.safeTransferFrom(from, to, tokenId, data);
865     }
866 }