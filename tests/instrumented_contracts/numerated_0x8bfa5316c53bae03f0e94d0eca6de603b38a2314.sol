1 pragma solidity 0.8.7;
2 
3 library Strings {
4     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
5 
6     function toString(uint256 value) internal pure returns (string memory) {
7         if (value == 0) {
8             return "0";
9         }
10         uint256 temp = value;
11         uint256 digits;
12         while (temp != 0) {
13             digits++;
14             temp /= 10;
15         }
16         bytes memory buffer = new bytes(digits);
17         while (value != 0) {
18             digits -= 1;
19             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
20             value /= 10;
21         }
22         return string(buffer);
23     }
24     function toHexString(uint256 value) internal pure returns (string memory) {
25         if (value == 0) {
26             return "0x00";
27         }
28         uint256 temp = value;
29         uint256 length = 0;
30         while (temp != 0) {
31             length++;
32             temp >>= 8;
33         }
34         return toHexString(value, length);
35     }
36     function toHexString(uint256 value, uint256 length)
37         internal
38         pure
39         returns (string memory)
40     {
41         bytes memory buffer = new bytes(2 * length + 2);
42         buffer[0] = "0";
43         buffer[1] = "x";
44         for (uint256 i = 2 * length + 1; i > 1; --i) {
45             buffer[i] = _HEX_SYMBOLS[value & 0xf];
46             value >>= 4;
47         }
48         require(value == 0, "Strings: hex length insufficient");
49         return string(buffer);
50     }
51 }
52 abstract contract Context {
53     function _msgSender() internal view virtual returns (address) {
54         return msg.sender;
55     }
56 
57     function _msgData() internal view virtual returns (bytes calldata) {
58         return msg.data;
59     }
60 }
61 library Address {
62     function isContract(address account) internal view returns (bool) {
63         return account.code.length > 0;
64     }
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(
67             address(this).balance >= amount,
68             "Address: insufficient balance"
69         );
70 
71         (bool success, ) = recipient.call{value: amount}("");
72         require(
73             success,
74             "Address: unable to send value, recipient may have reverted"
75         );
76     }
77     function functionCall(address target, bytes memory data)
78         internal
79         returns (bytes memory)
80     {
81         return functionCall(target, data, "Address: low-level call failed");
82     }
83     function functionCall(
84         address target,
85         bytes memory data,
86         string memory errorMessage
87     ) internal returns (bytes memory) {
88         return functionCallWithValue(target, data, 0, errorMessage);
89     }
90     function functionCallWithValue(
91         address target,
92         bytes memory data,
93         uint256 value
94     ) internal returns (bytes memory) {
95         return
96             functionCallWithValue(
97                 target,
98                 data,
99                 value,
100                 "Address: low-level call with value failed"
101             );
102     }
103     function functionCallWithValue(
104         address target,
105         bytes memory data,
106         uint256 value,
107         string memory errorMessage
108     ) internal returns (bytes memory) {
109         require(
110             address(this).balance >= value,
111             "Address: insufficient balance for call"
112         );
113         require(isContract(target), "Address: call to non-contract");
114 
115         (bool success, bytes memory returndata) = target.call{value: value}(
116             data
117         );
118         return verifyCallResult(success, returndata, errorMessage);
119     }
120     function functionStaticCall(address target, bytes memory data)
121         internal
122         view
123         returns (bytes memory)
124     {
125         return
126             functionStaticCall(
127                 target,
128                 data,
129                 "Address: low-level static call failed"
130             );
131     }
132     function functionStaticCall(
133         address target,
134         bytes memory data,
135         string memory errorMessage
136     ) internal view returns (bytes memory) {
137         require(isContract(target), "Address: static call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.staticcall(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142     function functionDelegateCall(address target, bytes memory data)
143         internal
144         returns (bytes memory)
145     {
146         return
147             functionDelegateCall(
148                 target,
149                 data,
150                 "Address: low-level delegate call failed"
151             );
152     }
153     function functionDelegateCall(
154         address target,
155         bytes memory data,
156         string memory errorMessage
157     ) internal returns (bytes memory) {
158         require(isContract(target), "Address: delegate call to non-contract");
159 
160         (bool success, bytes memory returndata) = target.delegatecall(data);
161         return verifyCallResult(success, returndata, errorMessage);
162     }
163     function verifyCallResult(
164         bool success,
165         bytes memory returndata,
166         string memory errorMessage
167     ) internal pure returns (bytes memory) {
168         if (success) {
169             return returndata;
170         } else {
171             if (returndata.length > 0) {
172                 assembly {
173                     let returndata_size := mload(returndata)
174                     revert(add(32, returndata), returndata_size)
175                 }
176             } else {
177                 revert(errorMessage);
178             }
179         }
180     }
181 }
182 interface IERC165 {
183     function supportsInterface(bytes4 interfaceId) external view returns (bool);
184 }
185 abstract contract ERC165 is IERC165 {
186     function supportsInterface(bytes4 interfaceId)
187         public
188         view
189         virtual
190         override
191         returns (bool)
192     {
193         return interfaceId == type(IERC165).interfaceId;
194     }
195 }
196 interface IERC721 is IERC165 {
197     event Transfer(
198         address indexed from,
199         address indexed to,
200         uint256 indexed tokenId
201     );
202     event Approval(
203         address indexed owner,
204         address indexed approved,
205         uint256 indexed tokenId
206     );
207     event ApprovalForAll(
208         address indexed owner,
209         address indexed operator,
210         bool approved
211     );
212     function balanceOf(address owner) external view returns (uint256 balance);
213     function ownerOf(uint256 tokenId) external view returns (address owner);
214     function safeTransferFrom(
215         address from,
216         address to,
217         uint256 tokenId
218     ) external;
219     function transferFrom(
220         address from,
221         address to,
222         uint256 tokenId
223     ) external;
224     function approve(address to, uint256 tokenId) external;
225     function getApproved(uint256 tokenId)
226         external
227         view
228         returns (address operator);
229     function setApprovalForAll(address operator, bool _approved) external;
230     function isApprovedForAll(address owner, address operator)
231         external
232         view
233         returns (bool);
234     function safeTransferFrom(
235         address from,
236         address to,
237         uint256 tokenId,
238         bytes calldata data
239     ) external;
240 }
241 interface IERC721Enumerable is IERC721 {
242     function totalSupply() external view returns (uint256);
243     function tokenOfOwnerByIndex(address owner, uint256 index)
244         external
245         view
246         returns (uint256);
247     function tokenByIndex(uint256 index) external view returns (uint256);
248 }
249 interface IERC721Metadata is IERC721 {
250     function name() external view returns (string memory);
251     function symbol() external view returns (string memory);
252     function tokenURI(uint256 tokenId) external view returns (string memory);
253 }
254 interface IERC721Receiver {
255     function onERC721Received(
256         address operator,
257         address from,
258         uint256 tokenId,
259         bytes calldata data
260     ) external returns (bytes4);
261 }
262 error ApprovalCallerNotOwnerNorApproved();
263 error ApprovalQueryForNonexistentToken();
264 error ApproveToCaller();
265 error ApprovalToCurrentOwner();
266 error BalanceQueryForZeroAddress();
267 error MintedQueryForZeroAddress();
268 error MintToZeroAddress();
269 error MintZeroQuantity();
270 error OwnerIndexOutOfBounds();
271 error OwnerQueryForNonexistentToken();
272 error TokenIndexOutOfBounds();
273 error TransferCallerNotOwnerNorApproved();
274 error TransferFromIncorrectOwner();
275 error TransferToNonERC721ReceiverImplementer();
276 error TransferToZeroAddress();
277 error UnableDetermineTokenOwner();
278 error URIQueryForNonexistentToken();
279 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
280     using Address for address;
281     using Strings for uint256;
282 
283     struct TokenOwnership {
284         address addr;
285         uint64 startTimestamp;
286     }
287 
288     struct AddressData {
289         uint128 balance;
290         uint128 numberMinted;
291     }
292 
293     uint256 internal _currentIndex;
294     string private _name;
295     string private _symbol;
296     mapping(uint256 => TokenOwnership) internal _ownerships;
297     mapping(address => AddressData) private _addressData;
298     mapping(uint256 => address) private _tokenApprovals;
299     mapping(address => mapping(address => bool)) private _operatorApprovals;
300     constructor(string memory name_, string memory symbol_) {
301         _name = name_;
302         _symbol = symbol_;
303     }
304     function totalSupply() public view override returns (uint256) {
305         return _currentIndex;
306     }
307     function tokenByIndex(uint256 index)
308         public
309         view
310         override
311         returns (uint256)
312     {
313         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
314         return index;
315     }
316     function tokenOfOwnerByIndex(address owner, uint256 index)
317         public
318         view
319         override
320         returns (uint256 a)
321     {
322         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
323         uint256 numMintedSoFar = totalSupply();
324         uint256 tokenIdsIdx;
325         address currOwnershipAddr;
326         unchecked {
327             for (uint256 i; i < numMintedSoFar; i++) {
328                 TokenOwnership memory ownership = _ownerships[i];
329                 if (ownership.addr != address(0)) {
330                     currOwnershipAddr = ownership.addr;
331                 }
332                 if (currOwnershipAddr == owner) {
333                     if (tokenIdsIdx == index) {
334                         return i;
335                     }
336                     tokenIdsIdx++;
337                 }
338             }
339         }
340         assert(false);
341     }
342     function supportsInterface(bytes4 interfaceId)
343         public
344         view
345         virtual
346         override(ERC165, IERC165)
347         returns (bool)
348     {
349         return
350             interfaceId == type(IERC721).interfaceId ||
351             interfaceId == type(IERC721Metadata).interfaceId ||
352             interfaceId == type(IERC721Enumerable).interfaceId ||
353             super.supportsInterface(interfaceId);
354     }
355     function balanceOf(address owner) public view override returns (uint256) {
356         if (owner == address(0)) revert BalanceQueryForZeroAddress();
357         return uint256(_addressData[owner].balance);
358     }
359 
360     function _numberMinted(address owner) internal view returns (uint256) {
361         if (owner == address(0)) revert MintedQueryForZeroAddress();
362         return uint256(_addressData[owner].numberMinted);
363     }
364     function ownershipOf(uint256 tokenId)
365         internal
366         view
367         returns (TokenOwnership memory)
368     {
369         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
370 
371         unchecked {
372             for (uint256 curr = tokenId; curr >= 0; curr--) {
373                 TokenOwnership memory ownership = _ownerships[curr];
374                 if (ownership.addr != address(0)) {
375                     return ownership;
376                 }
377             }
378         }
379 
380         revert UnableDetermineTokenOwner();
381     }
382     function ownerOf(uint256 tokenId) public view override returns (address) {
383         return ownershipOf(tokenId).addr;
384     }
385     function name() public view virtual override returns (string memory) {
386         return _name;
387     }
388     function symbol() public view virtual override returns (string memory) {
389         return _symbol;
390     }
391     function tokenURI(uint256 tokenId)
392         public
393         view
394         override
395         returns (string memory)
396     {
397         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
398 
399         string memory baseURI = _baseURI();
400         return
401             bytes(baseURI).length != 0
402                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ""))
403                 : "";
404     }
405     function _baseURI() internal view virtual returns (string memory) {
406         return "";
407     }
408     function approve(address to, uint256 tokenId) public override {
409         address owner = ERC721A.ownerOf(tokenId);
410         if (to == owner) revert ApprovalToCurrentOwner();
411 
412         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender()))
413             revert ApprovalCallerNotOwnerNorApproved();
414 
415         _approve(to, tokenId, owner);
416     }
417     function getApproved(uint256 tokenId)
418         public
419         view
420         override
421         returns (address)
422     {
423         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
424 
425         return _tokenApprovals[tokenId];
426     }
427     function setApprovalForAll(address operator, bool approved)
428         public
429         override
430     {
431         if (operator == _msgSender()) revert ApproveToCaller();
432 
433         _operatorApprovals[_msgSender()][operator] = approved;
434         emit ApprovalForAll(_msgSender(), operator, approved);
435     }
436     function isApprovedForAll(address owner, address operator)
437         public
438         view
439         virtual
440         override
441         returns (bool)
442     {
443         return _operatorApprovals[owner][operator];
444     }
445     function transferFrom(
446         address from,
447         address to,
448         uint256 tokenId
449     ) public virtual override {
450         _transfer(from, to, tokenId);
451     }
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId
456     ) public virtual override {
457         safeTransferFrom(from, to, tokenId, "");
458     }
459     function safeTransferFrom(
460         address from,
461         address to,
462         uint256 tokenId,
463         bytes memory _data
464     ) public override {
465         _transfer(from, to, tokenId);
466         if (!_checkOnERC721Received(from, to, tokenId, _data))
467             revert TransferToNonERC721ReceiverImplementer();
468     }
469     function _exists(uint256 tokenId) internal view returns (bool) {
470         return tokenId < _currentIndex;
471     }
472 
473     function _safeMint(address to, uint256 quantity) internal {
474         _safeMint(to, quantity, "");
475     }
476     function _safeMint(
477         address to,
478         uint256 quantity,
479         bytes memory _data
480     ) internal {
481         _mint(to, quantity, _data, true);
482     }
483     function _mint(
484         address to,
485         uint256 quantity,
486         bytes memory _data,
487         bool safe
488     ) internal {
489         uint256 startTokenId = _currentIndex;
490         if (to == address(0)) revert MintToZeroAddress();
491         unchecked {
492             _addressData[to].balance += uint128(quantity);
493             _addressData[to].numberMinted += uint128(quantity);
494             _ownerships[startTokenId].addr = to;
495             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
496             uint256 updatedIndex = startTokenId;
497             for (uint256 i; i < quantity; i++) {
498                 emit Transfer(address(0), to, updatedIndex);
499                 if (
500                     safe &&
501                     !_checkOnERC721Received(address(0), to, updatedIndex, _data)
502                 ) {
503                     revert TransferToNonERC721ReceiverImplementer();
504                 }
505                 updatedIndex++;
506             }
507             _currentIndex = updatedIndex;
508         }
509 
510         _afterTokenTransfers(address(0), to, startTokenId, quantity);
511     }
512     function _transfer(
513         address from,
514         address to,
515         uint256 tokenId
516     ) private {
517         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
518         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
519             getApproved(tokenId) == _msgSender() ||
520             isApprovedForAll(prevOwnership.addr, _msgSender()));
521         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
522         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
523         if (to == address(0)) revert TransferToZeroAddress();
524         _approve(address(0), tokenId, prevOwnership.addr);
525         unchecked {
526             _addressData[from].balance -= 1;
527             _addressData[to].balance += 1;
528             _ownerships[tokenId].addr = to;
529             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
530             uint256 nextTokenId = tokenId + 1;
531             if (_ownerships[nextTokenId].addr == address(0)) {
532                 if (_exists(nextTokenId)) {
533                     _ownerships[nextTokenId].addr = prevOwnership.addr;
534                     _ownerships[nextTokenId].startTimestamp = prevOwnership
535                         .startTimestamp;
536                 }
537             }
538         }
539         emit Transfer(from, to, tokenId);
540         _afterTokenTransfers(from, to, tokenId, 1);
541     }
542     function _approve(
543         address to,
544         uint256 tokenId,
545         address owner
546     ) private {
547         _tokenApprovals[tokenId] = to;
548         emit Approval(owner, to, tokenId);
549     }
550     function _checkOnERC721Received(
551         address from,
552         address to,
553         uint256 tokenId,
554         bytes memory _data
555     ) private returns (bool) {
556         if (to.isContract()) {
557             try
558                 IERC721Receiver(to).onERC721Received(
559                     _msgSender(),
560                     from,
561                     tokenId,
562                     _data
563                 )
564             returns (bytes4 retval) {
565                 return retval == IERC721Receiver(to).onERC721Received.selector;
566             } catch (bytes memory reason) {
567                 if (reason.length == 0)
568                     revert TransferToNonERC721ReceiverImplementer();
569                 else {
570                     assembly {
571                         revert(add(32, reason), mload(reason))
572                     }
573                 }
574             }
575         } else {
576             return true;
577         }
578     }
579     function _beforeTokenTransfers(
580         address from,
581         address to,
582         uint256 startTokenId,
583         uint256 quantity
584     ) internal virtual {}
585     function _afterTokenTransfers(
586         address from,
587         address to,
588         uint256 startTokenId,
589         uint256 quantity
590     ) internal virtual {}
591 }
592 library MerkleProof {
593     function verify(
594         bytes32[] memory proof,
595         bytes32 root,
596         bytes32 leaf
597     ) internal pure returns (bool) {
598         return processProof(proof, leaf) == root;
599     }
600     function processProof(bytes32[] memory proof, bytes32 leaf)
601         internal
602         pure
603         returns (bytes32)
604     {
605         bytes32 computedHash = leaf;
606         for (uint256 i = 0; i < proof.length; i++) {
607             bytes32 proofElement = proof[i];
608             if (computedHash <= proofElement) {
609                 computedHash = _efficientHash(computedHash, proofElement);
610             } else {
611                 computedHash = _efficientHash(proofElement, computedHash);
612             }
613         }
614         return computedHash;
615     }
616 
617     function _efficientHash(bytes32 a, bytes32 b)
618         private
619         pure
620         returns (bytes32 value)
621     {
622         assembly {
623             mstore(0x00, a)
624             mstore(0x20, b)
625             value := keccak256(0x00, 0x40)
626         }
627     }
628 }
629 abstract contract Ownable is Context {
630     address private _owner;
631     event OwnershipTransferred(
632         address indexed previousOwner,
633         address indexed newOwner
634     );
635     constructor() {
636         _transferOwnership(_msgSender());
637     }
638     function owner() public view virtual returns (address) {
639         return _owner;
640     }
641     modifier onlyOwner() {
642         require(owner() == _msgSender(), "Ownable: caller is not the owner");
643         _;
644     }
645     function renounceOwnership() public virtual onlyOwner {
646         _transferOwnership(address(0));
647     }
648     function transferOwnership(address newOwner) public virtual onlyOwner {
649         require(
650             newOwner != address(0),
651             "Ownable: new owner is the zero address"
652         );
653         _transferOwnership(newOwner);
654     }
655     function _transferOwnership(address newOwner) internal virtual {
656         address oldOwner = _owner;
657         _owner = newOwner;
658         emit OwnershipTransferred(oldOwner, newOwner);
659     }
660 }
661 contract THE_SATOSHI_GIRLS is ERC721A, Ownable {
662     using Strings for uint256;
663 
664     constructor(string memory baseuri, bytes32 finalPreviousCollectionRootHash, bytes32 finalPreSaleRootHash)
665         ERC721A("THE SATOSHI GIRLS", "TSG")
666     {
667         _baseURI1 = baseuri;
668         PreSaleRootHash = finalPreSaleRootHash;
669         PreviousCollectionRootHash = finalPreviousCollectionRootHash;
670     }
671 
672     uint256 public  maxSupply                   = 5000;
673     uint256 public  reserved                    = 100;
674     
675     uint256 public  publicSalePrice             = 0.06 ether;
676     uint256 public  preSalePrice                = 0.04 ether;
677 
678     uint256 public  preSaleMaxQuantity          = 1500;
679 
680     uint256 public  maxPerWallet                = 5;
681 
682     bool public     isPreviousCollectionPaused  = true;
683     bool public     isPreSalePaused             = true;
684     bool public     isPublicSalePaused          = true;
685     
686     string public   _baseURI1;
687     bytes32 private PreSaleRootHash;
688     bytes32 private PreviousCollectionRootHash;
689 
690     struct userAddress {
691         address userAddress;
692         uint256 counter;
693     }
694 
695     mapping(address => userAddress) public _PublicSaleAddresses;
696     mapping(address => bool) public _PublicSaleAddressExist;
697 
698     mapping(address => userAddress) public _PreSaleAddresses;
699     mapping(address => bool) public _PreSaleAddressExist;
700 
701     mapping(address => userAddress) public _PreviousCollectionAddresses;
702     mapping(address => bool) public _PreviousCollectionAddressExist;
703 
704     // Flip Previous Collection, Whitelist And Public Mint Pause Status 
705     function flipPreviousCollectionPauseStatus() public onlyOwner {
706         isPreviousCollectionPaused = !isPreviousCollectionPaused;
707     }
708     function flipPreSalePauseStatus() public onlyOwner {
709         isPreSalePaused = !isPreSalePaused;
710     }
711     function flipPublicSalePauseStatus() public onlyOwner {
712         isPublicSalePaused = !isPublicSalePaused;
713     }
714 
715     // setting merkle root hashes
716     function setPreSaleRootHash(bytes32 _rootHash) public onlyOwner {
717         PreSaleRootHash = _rootHash;
718     }
719     function setPreviousCollectionRootHash(bytes32 _rootHash) public onlyOwner {
720         PreviousCollectionRootHash = _rootHash;
721     }
722 
723     // Setter And Getter base URI Functions
724     function setBaseURI(string memory _newBaseURI) public onlyOwner {
725         _baseURI1 = _newBaseURI;
726     }
727     function _baseURI() internal view virtual override returns (string memory) {
728         return _baseURI1;
729     }
730 
731     // Get Public And Whitelist Price
732     function getPublicPrice(uint256 _quantity) public view returns (uint256) {
733         return _quantity * publicSalePrice;
734     }
735     function getPreSalePrice(uint256 _quantity) public view returns (uint256) {
736         return _quantity * preSalePrice;
737     }
738 
739     // Reserved, Previous Collection, Pre Sale, Free And Normal Mint Functions
740     function mintReservedTokens(uint256 quantity) public onlyOwner {
741         require(quantity <= reserved, "All reserve tokens have bene minted");
742         reserved -= quantity;
743         _safeMint(msg.sender, quantity);
744     }
745     function PreviousCollectionWhiteListMint(bytes32[] calldata _merkleProof, uint256 chosenAmount, uint256 maxPreviousCollectionMintLimit) public payable {
746         if (_PreviousCollectionAddressExist[msg.sender] == false) {
747             _PreviousCollectionAddresses[msg.sender] = userAddress({
748                 userAddress: msg.sender,
749                 counter: 0
750             });
751             _PreviousCollectionAddressExist[msg.sender] = true;
752         }
753         require(isPreviousCollectionPaused == false, "Previous Collection Mint Is Not ACtive Right Now");
754         require(chosenAmount > 0, "Number Of Tokens Can Not Be Less Than Or Equal To 0");
755         require(_PreviousCollectionAddresses[msg.sender].counter + chosenAmount <= maxPreviousCollectionMintLimit, "Max Previous Collection Mint Limit reached");
756         require(totalSupply() + chosenAmount <= maxSupply - reserved, "Presale Limit Reached");
757         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
758         require(MerkleProof.verify(_merkleProof, PreSaleRootHash, leaf), "Invalid Proof");
759 
760         _safeMint(msg.sender, chosenAmount);
761         _PreviousCollectionAddresses[msg.sender].counter += chosenAmount;
762     }
763     function whiteListMint(bytes32[] calldata _merkleProof, uint256 chosenAmount) public payable {
764         if (_PreSaleAddressExist[msg.sender] == false) {
765             _PreSaleAddresses[msg.sender] = userAddress({
766                 userAddress: msg.sender,
767                 counter: 0
768             });
769             _PreSaleAddressExist[msg.sender] = true;
770         }
771         require(isPreSalePaused == false, "Whitelist Mint Is Not Active Right Now");
772         require(chosenAmount > 0, "Number Of Tokens Can Not Be Less Than Or Equal To 0");
773         require(_PreSaleAddresses[msg.sender].counter + chosenAmount <= preSaleMaxQuantity, "Quantity Must Be Lesser Than Max Presale Supply");
774         require(_PreSaleAddresses[msg.sender].counter + chosenAmount <= maxPerWallet, "Max limit per wallet reached");
775         require(totalSupply() + chosenAmount <= maxSupply - reserved, "Presale Limit Reached");
776         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
777         require(MerkleProof.verify(_merkleProof, PreSaleRootHash, leaf), "Invalid Proof");
778         require(preSalePrice * chosenAmount == msg.value, "Sent Ether Value Is Incorrect");
779 
780         _safeMint(msg.sender, chosenAmount);
781         _PreSaleAddresses[msg.sender].counter += chosenAmount;
782     }
783     function mint(uint256 chosenAmount) public payable {
784         if (_PublicSaleAddressExist[msg.sender] == false) {
785             _PublicSaleAddresses[msg.sender] = userAddress({
786                 userAddress: msg.sender,
787                 counter: 0
788             });
789             _PublicSaleAddressExist[msg.sender] = true;
790         }
791         require( isPublicSalePaused == false, "Public Mint Is Not ACtive Right Now" );
792         require( chosenAmount > 0,"Number Of Tokens Can Not Be Less Than Or Equal To 0" );
793         require(_PreSaleAddresses[msg.sender].counter + chosenAmount <= maxPerWallet, "Max limit per wallet reached");
794         require( totalSupply() + chosenAmount <= maxSupply - reserved, "All Tokens Have Been Minted" );
795         require( publicSalePrice * chosenAmount == msg.value, "Sent Ether Value Is Incorrect" );
796         _safeMint(msg.sender, chosenAmount);
797         _PublicSaleAddresses[msg.sender].counter += chosenAmount;
798     }
799     function freeMint(uint quantity) public payable onlyOwner {
800         require(totalSupply() + quantity <= (maxSupply - reserved), "QUANTITY MUST BE LESS THEN MAX SUPPLY");
801         for (uint i = 0; i < quantity; i++) {
802             _safeMint(msg.sender, quantity);
803         }
804     }
805 
806     // Withdraw function
807     function withdraw() public onlyOwner {
808         uint totalBalance   = address(this).balance;
809         payable(msg.sender).transfer(totalBalance);
810     }
811 }