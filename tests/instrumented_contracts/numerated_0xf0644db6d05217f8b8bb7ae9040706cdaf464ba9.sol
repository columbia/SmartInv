1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 library Counters {
5     struct Counter {
6         uint256 _value;
7     }
8 
9     function current(Counter storage counter) internal view returns (uint256) {
10         return counter._value;
11     }
12 
13     function increment(Counter storage counter) internal {
14     unchecked {
15         counter._value += 1;
16     }
17     }
18 
19     function decrement(Counter storage counter) internal {
20         uint256 value = counter._value;
21         require(value > 0, "Counter: decrement overflow");
22     unchecked {
23         counter._value = value - 1;
24     }
25     }
26 
27     function reset(Counter storage counter) internal {
28         counter._value = 0;
29     }
30 }
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         return msg.data;
39     }
40 }
41 
42 interface IERC165 {
43     function supportsInterface(bytes4 interfaceId) external view returns (bool);
44 }
45 
46 interface IERC721 is IERC165 {
47     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     function ownerOf(uint256 tokenId) external view returns (address owner);
54 
55     function safeTransferFrom(address from, address to, uint256 tokenId) external;
56 
57     function transferFrom(address from, address to, uint256 tokenId) external;
58 
59     function approve(address to, uint256 tokenId) external;
60 
61     function getApproved(uint256 tokenId) external view returns (address operator);
62 
63     function setApprovalForAll(address operator, bool _approved) external;
64 
65     function isApprovedForAll(address owner, address operator) external view returns (bool);
66 
67     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
68 }
69 
70 interface IERC721Receiver {
71     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
72 }
73 
74 interface IERC721Metadata is IERC721 {
75     function name() external view returns (string memory);
76 
77     function symbol() external view returns (string memory);
78 
79     function tokenURI(uint256 tokenId) external view returns (string memory);
80 }
81 
82 library Address {
83     function isContract(address account) internal view returns (bool) {
84         uint256 size;
85         assembly {
86             size := extcodesize(account)
87         }
88         return size > 0;
89     }
90 
91     function sendValue(address payable recipient, uint256 amount) internal {
92         require(address(this).balance >= amount, "Address: insufficient balance");
93         (bool success,) = recipient.call{value : amount}("");
94         require(success, "Address: unable to send value, recipient may have reverted");
95     }
96 
97     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
98         return functionCall(target, data, "Address: low-level call failed");
99     }
100 
101     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
106         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
107     }
108 
109     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
110         require(address(this).balance >= value, "Address: insufficient balance for call");
111         require(isContract(target), "Address: call to non-contract");
112         (bool success, bytes memory returndata) = target.call{value : value}(data);
113         return verifyCallResult(success, returndata, errorMessage);
114     }
115 
116     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
117         return functionStaticCall(target, data, "Address: low-level static call failed");
118     }
119 
120     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
121         require(isContract(target), "Address: static call to non-contract");
122         (bool success, bytes memory returndata) = target.staticcall(data);
123         return verifyCallResult(success, returndata, errorMessage);
124     }
125 
126     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
127         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
128     }
129 
130     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
131         require(isContract(target), "Address: delegate call to non-contract");
132         (bool success, bytes memory returndata) = target.delegatecall(data);
133         return verifyCallResult(success, returndata, errorMessage);
134     }
135 
136     function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
137         if (success) {
138             return returndata;
139         } else {
140             if (returndata.length > 0) {
141                 assembly {
142                     let returndata_size := mload(returndata)
143                     revert(add(32, returndata), returndata_size)
144                 }
145             } else {
146                 revert(errorMessage);
147             }
148         }
149     }
150 }
151 
152 library Strings {
153     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
154 
155     function toString(uint256 value) internal pure returns (string memory) {
156         if (value == 0) {
157             return "0";
158         }
159         uint256 temp = value;
160         uint256 digits;
161         while (temp != 0) {
162             digits++;
163             temp /= 10;
164         }
165         bytes memory buffer = new bytes(digits);
166         while (value != 0) {
167             digits -= 1;
168             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
169             value /= 10;
170         }
171         return string(buffer);
172     }
173 
174     function toHexString(uint256 value) internal pure returns (string memory) {
175         if (value == 0) {
176             return "0x00";
177         }
178         uint256 temp = value;
179         uint256 length = 0;
180         while (temp != 0) {
181             length++;
182             temp >>= 8;
183         }
184         return toHexString(value, length);
185     }
186 
187     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
188         bytes memory buffer = new bytes(2 * length + 2);
189         buffer[0] = "0";
190         buffer[1] = "x";
191         for (uint256 i = 2 * length + 1; i > 1; --i) {
192             buffer[i] = _HEX_SYMBOLS[value & 0xf];
193             value >>= 4;
194         }
195         require(value == 0, "Strings: hex length insufficient");
196         return string(buffer);
197     }
198 }
199 
200 abstract contract ERC165 is IERC165 {
201     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
202         return interfaceId == type(IERC165).interfaceId;
203     }
204 }
205 
206 interface IERC721Enumerable is IERC721 {
207     function totalSupply() external view returns (uint256);
208 
209     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
210 
211     function tokenByIndex(uint256 index) external view returns (uint256);
212 }
213 
214 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
215     using Address for address;
216     using Strings for uint256;
217     string private _name;
218     string private _symbol;
219     mapping(uint256 => address) private _owners;
220     mapping(address => uint256) private _balances;
221     mapping(uint256 => address) private _tokenApprovals;
222     mapping(address => mapping(address => bool)) private _operatorApprovals;
223 
224     constructor(string memory name_, string memory symbol_) {
225         _name = name_;
226         _symbol = symbol_;
227     }
228 
229     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
230         return
231         interfaceId == type(IERC721).interfaceId ||
232         interfaceId == type(IERC721Metadata).interfaceId ||
233         super.supportsInterface(interfaceId);
234     }
235 
236     function balanceOf(address owner) public view virtual override returns (uint256) {
237         require(owner != address(0), "ERC721: balance query for the zero address");
238         return _balances[owner];
239     }
240 
241     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
242         address owner = _owners[tokenId];
243         require(owner != address(0), "ERC721: owner query for nonexistent token");
244         return owner;
245     }
246 
247     function name() public view virtual override returns (string memory) {
248         return _name;
249     }
250 
251     function symbol() public view virtual override returns (string memory) {
252         return _symbol;
253     }
254 
255     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
256         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
257         string memory baseURI = _baseURI();
258         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
259     }
260 
261     function _baseURI() internal view virtual returns (string memory) {
262         return "";
263     }
264 
265     function approve(address to, uint256 tokenId) public virtual override {
266         address owner = ERC721.ownerOf(tokenId);
267         require(to != owner, "ERC721: approval to current owner");
268         require(
269             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
270             "ERC721: approve caller is not owner nor approved for all"
271         );
272         _approve(to, tokenId);
273     }
274 
275     function getApproved(uint256 tokenId) public view virtual override returns (address) {
276         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
277         return _tokenApprovals[tokenId];
278     }
279 
280     function setApprovalForAll(address operator, bool approved) public virtual override {
281         require(operator != _msgSender(), "ERC721: approve to caller");
282         _operatorApprovals[_msgSender()][operator] = approved;
283         emit ApprovalForAll(_msgSender(), operator, approved);
284     }
285 
286     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
287         return _operatorApprovals[owner][operator];
288     }
289 
290     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
291         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
292         _transfer(from, to, tokenId);
293     }
294 
295     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
296         safeTransferFrom(from, to, tokenId, "");
297     }
298 
299     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
300         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
301         _safeTransfer(from, to, tokenId, _data);
302     }
303 
304     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
305         _transfer(from, to, tokenId);
306         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
307     }
308 
309     function _exists(uint256 tokenId) internal view virtual returns (bool) {
310         return _owners[tokenId] != address(0);
311     }
312 
313     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
314         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
315         address owner = ERC721.ownerOf(tokenId);
316         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
317     }
318 
319     function _safeMint(address to, uint256 tokenId) internal virtual {
320         _safeMint(to, tokenId, "");
321     }
322 
323     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
324         _mint(to, tokenId);
325         require(
326             _checkOnERC721Received(address(0), to, tokenId, _data),
327             "ERC721: transfer to non ERC721Receiver implementer"
328         );
329     }
330 
331     function _mint(address to, uint256 tokenId) internal virtual {
332         require(to != address(0), "ERC721: mint to the zero address");
333         require(!_exists(tokenId), "ERC721: token already minted");
334         _beforeTokenTransfer(address(0), to, tokenId);
335         _balances[to] += 1;
336         _owners[tokenId] = to;
337         emit Transfer(address(0), to, tokenId);
338     }
339 
340     function _burn(uint256 tokenId) internal virtual {
341         address owner = ERC721.ownerOf(tokenId);
342         _beforeTokenTransfer(owner, address(0), tokenId);
343         _approve(address(0), tokenId);
344         _balances[owner] -= 1;
345         delete _owners[tokenId];
346         emit Transfer(owner, address(0), tokenId);
347     }
348 
349     function _transfer(address from, address to, uint256 tokenId) internal virtual {
350         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
351         require(to != address(0), "ERC721: transfer to the zero address");
352         _beforeTokenTransfer(from, to, tokenId);
353         _approve(address(0), tokenId);
354         _balances[from] -= 1;
355         _balances[to] += 1;
356         _owners[tokenId] = to;
357         emit Transfer(from, to, tokenId);
358     }
359 
360     function _approve(address to, uint256 tokenId) internal virtual {
361         _tokenApprovals[tokenId] = to;
362         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
363     }
364 
365     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
366         if (to.isContract()) {
367             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
368                 return retval == IERC721Receiver.onERC721Received.selector;
369             } catch (bytes memory reason) {
370                 if (reason.length == 0) {
371                     revert("ERC721: transfer to non ERC721Receiver implementer");
372                 } else {
373                     assembly {
374                         revert(add(32, reason), mload(reason))
375                     }
376                 }
377             }
378         } else {
379             return true;
380         }
381     }
382 
383     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}
384 }
385 
386 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
387     uint256[] private _allTokens;
388     mapping(uint256 => uint256) private _allTokensIndex;
389     mapping(uint256 => uint256) private _ownedTokensIndex;
390     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
391 
392     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
393         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
394     }
395 
396     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
397         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
398         return _ownedTokens[owner][index];
399     }
400 
401     function totalSupply() public view virtual override returns (uint256) {
402         return _allTokens.length;
403     }
404 
405     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
406         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
407         return _allTokens[index];
408     }
409 
410     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
411         super._beforeTokenTransfer(from, to, tokenId);
412         if (from == address(0)) {
413             _addTokenToAllTokensEnumeration(tokenId);
414         } else if (from != to) {
415             _removeTokenFromOwnerEnumeration(from, tokenId);
416         }
417         if (to == address(0)) {
418             _removeTokenFromAllTokensEnumeration(tokenId);
419         } else if (to != from) {
420             _addTokenToOwnerEnumeration(to, tokenId);
421         }
422     }
423 
424     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
425         uint256 length = ERC721.balanceOf(to);
426         _ownedTokens[to][length] = tokenId;
427         _ownedTokensIndex[tokenId] = length;
428     }
429 
430     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
431         _allTokensIndex[tokenId] = _allTokens.length;
432         _allTokens.push(tokenId);
433     }
434 
435     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
436         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
437         uint256 tokenIndex = _ownedTokensIndex[tokenId];
438         if (tokenIndex != lastTokenIndex) {
439             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
440             _ownedTokens[from][tokenIndex] = lastTokenId;
441             _ownedTokensIndex[lastTokenId] = tokenIndex;
442         }
443         delete _ownedTokensIndex[tokenId];
444         delete _ownedTokens[from][lastTokenIndex];
445     }
446 
447     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
448         uint256 lastTokenIndex = _allTokens.length - 1;
449         uint256 tokenIndex = _allTokensIndex[tokenId];
450         uint256 lastTokenId = _allTokens[lastTokenIndex];
451         _allTokens[tokenIndex] = lastTokenId;
452         _allTokensIndex[lastTokenId] = tokenIndex;
453         delete _allTokensIndex[tokenId];
454         _allTokens.pop();
455     }
456 }
457 
458 abstract contract Ownable is Context {
459     address private _owner;
460 
461     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
462 
463     constructor() {
464         _setOwner(_msgSender());
465     }
466 
467     modifier onlyOwner() {
468         require(owner() == _msgSender(), "Ownable: caller is not the owner");
469         _;
470     }
471 
472     function owner() public view virtual returns (address) {
473         return _owner;
474     }
475 
476     function renounceOwnership() public virtual onlyOwner {
477         _setOwner(address(0));
478     }
479 
480     function transferOwnership(address newOwner) public virtual onlyOwner {
481         require(newOwner != address(0), "Ownable: new owner is the zero address");
482         _setOwner(newOwner);
483     }
484 
485     function _setOwner(address newOwner) private {
486         address oldOwner = _owner;
487         _owner = newOwner;
488         emit OwnershipTransferred(oldOwner, newOwner);
489     }
490 }
491 
492 contract TrippyGelatoCreamery is Context, Ownable, ERC721Enumerable {
493     using Counters for Counters.Counter;
494     Counters.Counter private _tokenIdTracker;
495 
496     string public constant TOKEN_NAME = "Trippy Gelato Creamery";
497     string public constant TOKEN_SYMBOL = "TGC";
498 
499    using Strings for uint256;
500 
501     //metadata
502     string baseURI;
503 
504     string public blindTokenURI = "ipfs://QmQ2KLgRySyLuVMWtedTpTmpcxLL7Xtw8mu3Ldpo6jQVWZ";
505     //sales
506     uint256 public cost = 0.05 ether;
507 
508     uint256 public presaleSupply = 2000;
509     uint256 public reservedSupply = 51;
510     uint256 public maxSupply = 6000;
511     uint256 public maxMintsPerTransaction = 5;
512 
513     bool public isActive = true;
514     bool public reservedTokensMinted = false;
515 
516     bool public blindBoxOpened = false;
517 
518     mapping(address => bool) public presaleList;
519     mapping(address => uint8) private _allowMaxList;
520 
521     //Sale states
522     bool public presaleEnabled = false;
523     bool public publicSaleEnabled = false;
524 
525     constructor(string memory _initBaseURI) ERC721(TOKEN_NAME, TOKEN_SYMBOL) {
526         setBaseURI(_initBaseURI);   
527     }
528 
529     // metadata region
530     function _baseURI() internal view virtual override returns (string memory) {
531         return baseURI;
532     }
533 
534     function setBaseURI(string memory _newBaseURI) public onlyOwner {
535         baseURI = _newBaseURI;
536     }
537     //endregion
538 
539     //setters and getters for sales region
540     function setCost(uint256 _newCost) public onlyOwner {
541         cost = _newCost;
542     }
543 
544     function setBlindBoxURI(string memory _newURI) public onlyOwner {
545         blindTokenURI = _newURI;
546     }
547 
548     function configurePresale(uint256 _presaleSupply, uint256 _reservedSupply) public onlyOwner {
549         presaleSupply = _presaleSupply;
550         reservedSupply = _reservedSupply;
551     }
552 
553     function setMaxSupply(uint256 _newMaxSupply) public onlyOwner {
554         maxSupply = _newMaxSupply;
555     }
556 
557     function setMaxMintsPerTransaction(uint256 _newmaxMintsPerTransaction) public onlyOwner {
558         maxMintsPerTransaction = _newmaxMintsPerTransaction;
559     }
560 
561     function setPresaleList(address[] memory _allowList, uint8 numAllowedToMint) external onlyOwner {
562         for (uint256 i = 0; i < _allowList.length; i++) {
563             presaleList[_allowList[i]] = true;
564             _allowMaxList[_allowList[i]] = numAllowedToMint;
565         }
566     }
567     //endregion
568 
569     function reserveNFTs(address to) public onlyOwner {
570         require(reservedTokensMinted == false, "Reserve NFT: reserved Tokens have been minted");
571         uint totalMinted = _tokenIdTracker.current();
572         require(totalMinted + reservedSupply < maxSupply, "Reserve NFT: not enough NFTs left to reserve");
573 
574         for (uint i = 0; i < reservedSupply; i++) {
575             _mint(to, _tokenIdTracker.current());
576             _tokenIdTracker.increment();
577         }
578         reservedTokensMinted = true;
579     }
580 
581     function toggleActiveState() public onlyOwner {
582         isActive = !isActive;
583     }
584 
585     function getBalanceFromWallet(address _wallet) external view returns (uint256[] memory) {
586         uint256 amount = balanceOf(_wallet);
587 
588         uint256[] memory amountMemory = new uint256[](amount);
589         for (uint256 i;i < amount;i++) {
590             amountMemory[i] = tokenOfOwnerByIndex(_wallet, i);
591         }
592 
593         return amountMemory;
594     }
595 
596     function withdraw() external onlyOwner {
597         require(address(this).balance > 0, "Withdraw: insufficient funds.");
598         payable(_msgSender()).transfer(address(this).balance);
599     }
600 
601     //mint and airdrop region
602     function mint(uint256 _mintAmount) public payable {
603         require(isActive, "mint: contract paused");       
604         require(publicSaleEnabled == true, "mint: Public sale is not enabled yet");
605         require(_mintAmount > 0, "mint: Can't mint less than 1.");
606         require(_mintAmount <= maxMintsPerTransaction, "mint: Can't mint more than maxMintsPerTransaction.");
607         require(cost * _mintAmount <= msg.value, "mint: Incorrect Ether value.");
608         mintNFTs(msg.sender, _mintAmount);
609     }
610 
611     function presaleMint(uint8 _mintAmount) public payable  {
612         require(isActive, "presaleMint: contract paused");       
613         require(presaleEnabled == true, "presaleMint: Presale is not enabled yet");
614         bool isWhiteListed = presaleList[msg.sender];
615         require(isWhiteListed == true, "presaleMint: Wrong address");
616         require(_mintAmount <= _allowMaxList[msg.sender], "presaleMint: Exceeded max available to purchase");
617         require(_mintAmount <= presaleSupply, "presaleMint: Presale supply is out.");
618         presaleSupply -= _mintAmount;
619         _allowMaxList[msg.sender] -= _mintAmount;
620         mintNFTs(msg.sender, _mintAmount);
621     }
622 
623     function flipBlindBoxStatus() public onlyOwner {
624         blindBoxOpened = !blindBoxOpened;
625     }
626 
627     function flipPresale() public onlyOwner {
628         presaleEnabled = !presaleEnabled;
629     }
630 
631     function flipPublicsale() public onlyOwner {
632         publicSaleEnabled = !publicSaleEnabled;
633     }
634 
635     modifier maxSupplyCheck(uint256 amount)  {
636         uint256 totalAmount = totalSupply() + amount;       
637         if(reservedTokensMinted == false){
638             totalAmount = totalAmount + reservedSupply;
639         }
640         require(totalAmount <= maxSupply, "max Supply Check: Tokens supply reached limit.");
641         _;
642     }
643 
644     function mintNFTs(address to, uint256 amount) internal maxSupplyCheck(amount) {
645         uint256 fromToken = totalSupply() + 1;
646         for (uint256 i = 0; i < amount; i++) {
647             _mint(to, fromToken + i);
648         }
649     }
650 
651     function airdrop(address[] memory addresses, uint256[] memory amounts) external onlyOwner {
652         for (uint256 i = 0; i < addresses.length; i++) {
653             mintNFTs(addresses[i], amounts[i]);
654         }
655     }
656 
657     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
658         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
659         if(blindBoxOpened){
660             return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
661         }else{
662             return blindTokenURI;
663         }
664     }    
665     //endregion
666 }