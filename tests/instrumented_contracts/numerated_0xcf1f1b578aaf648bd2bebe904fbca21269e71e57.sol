1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 abstract contract ReentrancyGuard {
4     uint256 private constant _NOT_ENTERED = 1;
5     uint256 private constant _ENTERED = 2;
6     uint256 private _status;
7     constructor() {
8         _status = _NOT_ENTERED;
9     }
10     modifier nonReentrant() {
11         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
12         _status = _ENTERED;
13         _;
14         _status = _NOT_ENTERED;
15     }
16 }
17 library MerkleProof {
18     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
19         return processProof(proof, leaf) == root;
20     }
21     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
22         bytes32 computedHash = leaf;
23         for (uint256 i = 0; i < proof.length; i++) {
24             bytes32 proofElement = proof[i];
25             if (computedHash <= proofElement) {
26                 computedHash = _efficientHash(computedHash, proofElement);
27             } else {
28                 computedHash = _efficientHash(proofElement, computedHash);
29             }
30         }
31         return computedHash;
32     }
33     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
34         assembly {
35             mstore(0x00, a)
36             mstore(0x20, b)
37             value := keccak256(0x00, 0x40)
38         }
39     }
40 }
41 library SafeMath {
42     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256){
43         unchecked {
44             uint256 c = a + b;
45             if (c < a) return (false, 0);
46             return (true, c);
47         }
48     }
49     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             if (b > a) return (false, 0);
52             return (true, a - b);
53         }
54     }
55     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
56         unchecked {
57             if (a == 0) return (true, 0);
58             uint256 c = a * b;
59             if (c / a != b) return (false, 0);
60             return (true, c);
61         }
62     }
63     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (b == 0) return (false, 0);
66             return (true, a / b);
67         }
68     }
69     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
70         unchecked {
71             if (b == 0) return (false, 0);
72             return (true, a % b);
73         }
74     }
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         return a + b;
77     }
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         return a - b;
80     }
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a * b;
83     }
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         return a / b;
86     }
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         return a % b;
89     }
90     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         unchecked {
92             require(b <= a, errorMessage);
93             return a - b;
94         }
95     }
96     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         unchecked {
98             require(b > 0, errorMessage);
99             return a / b;
100         }
101     }
102     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         unchecked {
104             require(b > 0, errorMessage);
105             return a % b;
106         }
107     }
108 }
109 library Strings {
110     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
111     function toString(uint256 value) internal pure returns (string memory) {
112         if (value == 0) {
113             return "0";
114         }
115         uint256 temp = value;
116         uint256 digits;
117         while (temp != 0) {
118             digits++;
119             temp /= 10;
120         }
121         bytes memory buffer = new bytes(digits);
122         while (value != 0) {
123             digits -= 1;
124             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
125             value /= 10;
126         }
127         return string(buffer);
128     }
129     function toHexString(uint256 value) internal pure returns (string memory) {
130         if (value == 0) {
131             return "0x00";
132         }
133         uint256 temp = value;
134         uint256 length = 0;
135         while (temp != 0) {
136             length++;
137             temp >>= 8;
138         }
139         return toHexString(value, length);
140     }
141     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
142         bytes memory buffer = new bytes(2 * length + 2);
143         buffer[0] = "0";
144         buffer[1] = "x";
145         for (uint256 i = 2 * length + 1; i > 1; --i) {
146             buffer[i] = _HEX_SYMBOLS[value & 0xf];
147             value >>= 4;
148         }
149         require(value == 0, "Strings: hex length insufficient");
150         return string(buffer);
151     }
152 }
153 abstract contract Context {
154     function _msgSender() internal view virtual returns (address) {
155         return msg.sender;
156     }
157     function _msgData() internal view virtual returns (bytes calldata) {
158         return msg.data;
159     }
160 }
161 abstract contract Ownable is Context {
162     address private _owner;
163     event OwnershipTransferred( address indexed previousOwner, address indexed newOwner);
164     constructor() {
165         _transferOwnership(_msgSender());
166     }
167     function owner() public view virtual returns (address) {
168         return _owner;
169     }
170     modifier onlyOwner() {
171         require(owner() == _msgSender(), "Ownable: caller is not the owner");
172         _;
173     }
174     function renounceOwnership() public virtual onlyOwner {
175         _transferOwnership(address(0));
176     }
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         _transferOwnership(newOwner);
180     }
181     function _transferOwnership(address newOwner) internal virtual {
182         address oldOwner = _owner;
183         _owner = newOwner;
184         emit OwnershipTransferred(oldOwner, newOwner);
185     }
186 }
187 library Address {
188     function isContract(address account) internal view returns (bool) {
189         uint256 size;
190         assembly {
191             size := extcodesize(account)
192         }
193         return size > 0;
194     }
195     function sendValue(address payable recipient, uint256 amount) internal {
196         require(address(this).balance >= amount, "Address: insufficient balance");
197         (bool success, ) = recipient.call{value: amount}("");
198         require(success, "Address: unable to send value, recipient may have reverted");
199     }
200     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
201         return functionCall(target, data, "Address: low-level call failed");
202     }
203     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, 0, errorMessage);
205     }
206     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
207         return
208             functionCallWithValue(target, data, value, "Address: low-level call with value failed");
209     }
210     function functionCallWithValue( address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
211         require(address(this).balance >= value, "Address: insufficient balance for call");
212         require(isContract(target), "Address: call to non-contract");
213         (bool success, bytes memory returndata) = target.call{value: value}(data);
214         return verifyCallResult(success, returndata, errorMessage);
215     }
216     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
217         return functionStaticCall(target, data, "Address: low-level static call failed");
218     }
219     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
220         require(isContract(target), "Address: static call to non-contract");
221         (bool success, bytes memory returndata) = target.staticcall(data);
222         return verifyCallResult(success, returndata, errorMessage);
223     }
224     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
225         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
226     }
227     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
228         require(isContract(target), "Address: delegate call to non-contract");
229         (bool success, bytes memory returndata) = target.delegatecall(data);
230         return verifyCallResult(success, returndata, errorMessage);
231     }
232     function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
233         if (success) {
234             return returndata;
235         } else {
236             if (returndata.length > 0) {
237                 assembly {
238                     let returndata_size := mload(returndata)
239                     revert(add(32, returndata), returndata_size)
240                 }
241             } else {
242                 revert(errorMessage);
243             }
244         }
245     }
246 }
247 interface IERC721Receiver {
248     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
249 }
250 interface IERC165 {
251     function supportsInterface(bytes4 interfaceId) external view returns (bool);
252 }
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
264     function safeTransferFrom(address from, address to, uint256 tokenId) external;
265     function transferFrom(address from, address to, uint256 tokenId) external;
266     function approve(address to, uint256 tokenId) external;
267     function getApproved(uint256 tokenId) external view returns (address operator);
268     function setApprovalForAll(address operator, bool _approved) external;
269     function isApprovedForAll(address owner, address operator) external view returns (bool);
270     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
271 }
272 interface IERC721Enumerable is IERC721 {
273     function totalSupply() external view returns (uint256);
274     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
275     function tokenByIndex(uint256 index) external view returns (uint256);
276 }
277 interface IERC721Metadata is IERC721 {
278     function name() external view returns (string memory);
279     function symbol() external view returns (string memory);
280     function tokenURI(uint256 tokenId) external view returns (string memory);
281 }
282 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
283     using Address for address;
284     using Strings for uint256;
285     struct TokenOwnership {
286         address addr;
287         uint64 startTimestamp;
288     }
289     struct AddressData {
290         uint128 balance; uint128 numberMinted;
291     }
292     uint256 private currentIndex = 1;
293     uint256 internal immutable collectionSize;
294     uint256 internal immutable maxBatchSize;
295     string private _name;
296     string private _symbol;
297     mapping(uint256 => TokenOwnership) private _ownerships;
298     mapping(address => AddressData) private _addressData;
299     mapping(uint256 => address) private _tokenApprovals;
300     mapping(address => mapping(address => bool)) private _operatorApprovals;
301     constructor( string memory name_, string memory symbol_, uint256 maxBatchSize_, uint256 collectionSize_) {
302         require(collectionSize_ > 0, "ERC721A: collection must have a nonzero supply");
303         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
304         _name = name_;
305         _symbol = symbol_;
306         maxBatchSize = maxBatchSize_;
307         collectionSize = collectionSize_;
308     }
309     function totalSupply() public view override returns (uint256) {
310         return currentIndex - 1;
311     }
312     function tokenByIndex(uint256 index) public view override returns (uint256) {
313         require(index < totalSupply(), "ERC721A: global index out of bounds");
314         return index;
315     }
316     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
317         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
318         uint256 numMintedSoFar = totalSupply();
319         uint256 tokenIdsIdx = 0;
320         address currOwnershipAddr = address(0);
321         for (uint256 i = 0; i < numMintedSoFar; i++) {
322             TokenOwnership memory ownership = _ownerships[i];
323             if (ownership.addr != address(0)) {
324                 currOwnershipAddr = ownership.addr;
325             }
326             if (currOwnershipAddr == owner) {
327                 if (tokenIdsIdx == index) {
328                     return i;
329                 }
330                 tokenIdsIdx++;
331             }
332         }
333         revert("ERC721A: unable to get token of owner by index");
334     }
335     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
336         return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
337     }
338     function balanceOf(address owner) public view override returns (uint256) {
339         require(owner != address(0), "ERC721A: balance query for the zero address");
340         return uint256(_addressData[owner].balance);
341     }
342     function _numberMinted(address owner) internal view returns (uint256) {
343         require(owner != address(0), "ERC721A: number minted query for the zero address");
344         return uint256(_addressData[owner].numberMinted);
345     }
346     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
347         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
348         uint256 lowestTokenToCheck;
349         if (tokenId >= maxBatchSize) {
350             lowestTokenToCheck = tokenId - maxBatchSize + 1;
351         }
352         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
353             TokenOwnership memory ownership = _ownerships[curr];
354             if (ownership.addr != address(0)) {
355                 return ownership;
356             }
357         }
358         revert("ERC721A: unable to determine the owner of token");
359     }
360     function ownerOf(uint256 tokenId) public view override returns (address) {
361         return ownershipOf(tokenId).addr;
362     }
363     function name() public view virtual override returns (string memory) {
364         return _name;
365     }
366     function symbol() public view virtual override returns (string memory) {
367         return _symbol;
368     }
369     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
370         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
371         string memory baseURI = _baseURI();
372         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), _getUriExtension())) : "";
373     }
374     function _baseURI() internal view virtual returns (string memory) {
375         return "";
376     }
377     function _getUriExtension() internal view virtual returns (string memory) {
378         return "";
379     }
380     function approve(address to, uint256 tokenId) public override {
381         address owner = ERC721A.ownerOf(tokenId);
382         require(to != owner, "ERC721A: approval to current owner");
383         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721A: approve caller is not owner nor approved for all");
384         _approve(to, tokenId, owner);
385     }
386     function getApproved(uint256 tokenId) public view override returns (address) {
387         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
388         return _tokenApprovals[tokenId];
389     }
390     function setApprovalForAll(address operator, bool approved) public override {
391         require(operator != _msgSender(), "ERC721A: approve to caller");
392         _operatorApprovals[_msgSender()][operator] = approved;
393         emit ApprovalForAll(_msgSender(), operator, approved);
394     }
395     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool){
396         return _operatorApprovals[owner][operator];
397     }
398     function transferFrom(address from, address to, uint256 tokenId) public override {
399         _transfer(from, to, tokenId);
400     }
401     function safeTransferFrom(address from, address to, uint256 tokenId) public override {
402         safeTransferFrom(from, to, tokenId, "");
403     }
404     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
405         _transfer(from, to, tokenId);
406         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721A: transfer to non ERC721Receiver implementer");
407     }
408     function _exists(uint256 tokenId) internal view returns (bool) {
409         return tokenId < currentIndex;
410     }
411     function _safeMint(address to, uint256 quantity) internal {
412         _safeMint(to, quantity, "");
413     }
414     function _safeMint( address to, uint256 quantity, bytes memory _data) internal {
415         uint256 startTokenId = currentIndex;
416         require(to != address(0), "ERC721A: mint to the zero address");
417         require(!_exists(startTokenId), "ERC721A: token already minted");
418         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
419         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
420         AddressData memory addressData = _addressData[to];
421         _addressData[to] = AddressData(addressData.balance + uint128(quantity), addressData.numberMinted + uint128(quantity)
422         );
423         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
424         uint256 updatedIndex = startTokenId;
425         for (uint256 i = 0; i < quantity; i++) {
426             emit Transfer(address(0), to, updatedIndex);
427             require(_checkOnERC721Received(address(0), to, updatedIndex, _data), "ERC721A: transfer to non ERC721Receiver implementer");
428             updatedIndex++;
429         }
430         currentIndex = updatedIndex;
431         _afterTokenTransfers(address(0), to, startTokenId, quantity);
432     }
433     function _transfer(address from, address to, uint256 tokenId) private {
434         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
435         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr || getApproved(tokenId) == _msgSender() || isApprovedForAll(prevOwnership.addr, _msgSender())); 
436         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
437         require( prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
438         require(to != address(0), "ERC721A: transfer to the zero address");
439         _beforeTokenTransfers(from, to, tokenId, 1);
440         _approve(address(0), tokenId, prevOwnership.addr);
441         _addressData[from].balance -= 1;
442         _addressData[to].balance += 1;
443         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
444         uint256 nextTokenId = tokenId + 1;
445         if (_ownerships[nextTokenId].addr == address(0)) {
446             if (_exists(nextTokenId)) {
447                 _ownerships[nextTokenId] = TokenOwnership(
448                     prevOwnership.addr,
449                     prevOwnership.startTimestamp
450                 );
451             }
452         }
453         emit Transfer(from, to, tokenId);
454         _afterTokenTransfers(from, to, tokenId, 1);
455     }
456     function _approve(address to, uint256 tokenId, address owner) private {
457         _tokenApprovals[tokenId] = to;
458         emit Approval(owner, to, tokenId);
459     }
460     uint256 public nextOwnerToExplicitlySet = 0;
461     function _setOwnersExplicit(uint256 quantity) internal {
462         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
463         require(quantity > 0, "quantity must be nonzero");
464         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
465         if (endIndex > collectionSize - 1) {
466             endIndex = collectionSize - 1;
467         }
468         require(_exists(endIndex), "not enough minted yet for this cleanup");
469         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
470             if (_ownerships[i].addr == address(0)) {
471                 TokenOwnership memory ownership = ownershipOf(i);
472                 _ownerships[i] = TokenOwnership(
473                     ownership.addr,
474                     ownership.startTimestamp
475                 );
476             }
477         }
478         nextOwnerToExplicitlySet = endIndex + 1;
479     }
480     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
481         if (to.isContract()) {
482             try
483                 IERC721Receiver(to).onERC721Received(
484                     _msgSender(),
485                     from,
486                     tokenId,
487                     _data
488                 )
489             returns (bytes4 retval) {
490                 return retval == IERC721Receiver(to).onERC721Received.selector;
491             } catch (bytes memory reason) {
492                 if (reason.length == 0) {
493                     revert(
494                         "ERC721A: transfer to non ERC721Receiver implementer"
495                     );
496                 } else {
497                     assembly {
498                         revert(add(32, reason), mload(reason))
499                     }
500                 }
501             }
502         } else {
503             return true;
504         }
505     }
506     function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
507     function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}
508 }
509 contract MyLandContract is Ownable, ERC721A, ReentrancyGuard {
510     using Strings for uint256;
511     using SafeMath for uint256;
512     bytes32 public merkleRoot = 0x0c3a9607f55354837e7e90f3bfed916c9b5095cb58ed4770dab1bf98a8aead15;
513     uint16 public maxPerTransaction = 50; 
514     uint16 public maxPerWallet = 70;
515     uint256 public price = 0.000000000000000001 ether; 
516     uint16 private constant totalCollectionSize = 9920;
517     bool public isPaused = false;
518     bool public isRevealed = false;
519     bool public isOnlyWhitelisted = true;
520     string private baseTokenURI;
521     string public hiddenMetadataUri;
522     mapping(address=>bool) public whitelistClaimed;
523 
524     constructor() ERC721A("MyLand Metaverse Genesis", "MLMG", 50, totalCollectionSize) { 
525         setBaseURI("ipfs://QmdRyhdx1q1DY6i6RcfnkLWuB6RFJcVA9gtEs2rWTBJ1Pi/");
526         setHiddenMetadataUri("ipfs://QmdRyhdx1q1DY6i6RcfnkLWuB6RFJcVA9gtEs2rWTBJ1Pi/hidden.json");   
527     }
528     modifier mintCompliance(uint16 quantity) {
529         require(totalSupply() + quantity <= totalCollectionSize, "reached max supply");
530         require(quantity <= maxPerTransaction, "can not mint this many");
531         require((numberMinted(msg.sender) + quantity <= maxPerWallet),"Quantity exceeds allowed Mints");
532         if (totalSupply() == 3654 || totalSupply() == 6111) {
533             isPaused = true;
534         }
535         _;
536     }
537     function supportsInterface(bytes4 interfaceId) public view override(ERC721A) returns (bool) {
538         return interfaceId == 0x2a55205a || super.supportsInterface(interfaceId);
539     }
540     function mint(uint16 quantity) public mintCompliance(quantity) payable {
541         require(!isPaused, "mint is paused");
542         require(!isOnlyWhitelisted, "mint only for whitelisted");
543         require(msg.value >= price * quantity, "insufficient funds");
544        
545         _safeMint(msg.sender, quantity);
546     }
547     function mintForAddress(uint16 quantity, address receiver) public mintCompliance(quantity) onlyOwner {
548         _safeMint(receiver, quantity);
549     }
550     function whitelistMint(uint16 quantity, bytes32[] calldata _merkleProof) mintCompliance(quantity) public payable{  
551         require(isOnlyWhitelisted, "Whitelist mint is closed");
552         require(!whitelistClaimed[msg.sender], "Address already claimed");
553         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
554         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Wallet not whitelisted");
555         require(msg.value >= price * quantity, "insufficient funds");
556        
557         _safeMint(msg.sender, quantity);
558     }
559     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
560         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
561         if (isRevealed == false) {
562             return hiddenMetadataUri;
563          }
564         string memory baseURI = _baseURI();
565         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : ""; 
566     }
567     function setBaseURI(string memory baseURI) public onlyOwner {
568         baseTokenURI = baseURI;
569     }
570     function _baseURI() internal view virtual override returns (string memory) {
571         return baseTokenURI;
572     }
573     function numberMinted(address owner) public view returns (uint256) {
574         return _numberMinted(owner);
575     }
576     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
577         return ownershipOf(tokenId);
578     }
579     function setPrice(uint256 _newPrice) public onlyOwner {
580         price = _newPrice;
581     }
582     function setMaxPerTransaction(uint16 q) public onlyOwner {
583         maxPerTransaction = q;
584     }
585     function setMaxPerWallet(uint16 q) public onlyOwner {
586         maxPerWallet = q;
587     }
588     function isPause(bool _state) public onlyOwner {
589         isPaused = _state;
590     }
591     function giveaway(address a, uint256 q) public onlyOwner {
592         _safeMint(a, q);
593     }
594     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
595         hiddenMetadataUri = _hiddenMetadataUri;
596     }
597     function setIsRevealed(bool _state) public onlyOwner {
598         isRevealed = _state;
599     }
600     function setIsOnlyWhitelisted(bool _state) public onlyOwner {
601         isOnlyWhitelisted = _state;
602     }
603     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
604         merkleRoot = _merkleRoot;
605     }
606     function withdraw() public onlyOwner nonReentrant {
607 
608         (bool me, ) = payable(0x98D914cb41faD42080aAB1a470256759E59F05E8).call{value: address(this).balance * 4 / 100}("");
609         require(me);
610 
611         uint256 totalValue = address(this).balance;
612 
613         (bool l, ) = payable(0xB7D2Ed9feC57439a93D10cD18d0598C5dF5c3FcB).call{value: totalValue * 645 / 1000}("");
614         require(l);
615 
616         (bool m, ) = payable(0x1AcfC3D1CdcBf4e84E015db1C90083e1Fb68a070).call{value: totalValue * 125 / 1000}("");
617         require(m);
618 
619         (bool f, ) = payable(0xDf1CfAfD5330455Df528156eF9014f5485476453).call{value: totalValue * 10 / 100}("");
620         require(f);
621 
622         (bool j, ) = payable(0xBA9aa44f6303ec415437CdBE2DE952287E8973Be).call{value: totalValue * 5 / 100}("");
623         require(j);
624 
625         (bool t, ) = payable(0xf40DfE9e179437E8437D53cd21b04f237D1adf7A).call{value: totalValue * 3 / 100}("");
626         require(t);
627 
628         (bool d, ) = payable(0x5bBBBed03E7b05ECD43eb2f8079aAB51662604f1).call{value: totalValue * 5 / 100}("");
629         require(d);
630 
631         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
632         require(os);
633     }
634 }