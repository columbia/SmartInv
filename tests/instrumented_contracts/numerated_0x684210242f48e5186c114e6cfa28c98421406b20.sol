1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 abstract contract ReentrancyGuard {
5     uint256 private constant _NOT_ENTERED = 1;
6     uint256 private constant _ENTERED = 2;
7     uint256 private _status;
8 
9     constructor() {
10         _status = _NOT_ENTERED;
11     }
12 
13     modifier nonReentrant() {
14         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
15         _status = _ENTERED;
16         _;
17         _status = _NOT_ENTERED;
18     }
19 }
20 
21 interface IERC721Receiver {
22     function onERC721Received(
23         address operator,
24         address from,
25         uint256 tokenId,
26         bytes calldata data
27     ) external returns (bytes4);
28 }
29 
30 library Address {
31 
32     function isContract(address account) internal view returns (bool) {
33         uint256 size;
34         assembly {
35             size := extcodesize(account)
36         }
37         return size > 0;
38     }
39 
40     function sendValue(address payable recipient, uint256 amount) internal {
41         require(address(this).balance >= amount, "Address: insufficient balance");
42         (bool success, ) = recipient.call{value: amount}("");
43         require(success, "Address: unable to send value, recipient may have reverted");
44     }
45 
46     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
47         return functionCall(target, data, "Address: low-level call failed");
48     }
49 
50     function functionCall(
51         address target,
52         bytes memory data,
53         string memory errorMessage
54     ) internal returns (bytes memory) {
55         return functionCallWithValue(target, data, 0, errorMessage);
56     }
57 
58     function functionCallWithValue(
59         address target,
60         bytes memory data,
61         uint256 value
62     ) internal returns (bytes memory) {
63         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
64     }
65 
66     function functionCallWithValue(
67         address target,
68         bytes memory data,
69         uint256 value,
70         string memory errorMessage
71     ) internal returns (bytes memory) {
72         require(address(this).balance >= value, "Address: insufficient balance for call");
73         require(isContract(target), "Address: call to non-contract");
74         (bool success, bytes memory returndata) = target.call{value: value}(data);
75         return verifyCallResult(success, returndata, errorMessage);
76     }
77 
78     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
79         return functionStaticCall(target, data, "Address: low-level static call failed");
80     }
81 
82     function functionStaticCall(
83         address target,
84         bytes memory data,
85         string memory errorMessage
86     ) internal view returns (bytes memory) {
87         require(isContract(target), "Address: static call to non-contract");
88         (bool success, bytes memory returndata) = target.staticcall(data);
89         return verifyCallResult(success, returndata, errorMessage);
90     }
91 
92     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
93         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
94     }
95 
96     function functionDelegateCall(
97         address target,
98         bytes memory data,
99         string memory errorMessage
100     ) internal returns (bytes memory) {
101         require(isContract(target), "Address: delegate call to non-contract");
102         (bool success, bytes memory returndata) = target.delegatecall(data);
103         return verifyCallResult(success, returndata, errorMessage);
104     }
105 
106     function verifyCallResult(
107         bool success,
108         bytes memory returndata,
109         string memory errorMessage
110     ) internal pure returns (bytes memory) {
111         if (success) {
112             return returndata;
113         } else {
114             if (returndata.length > 0) {
115                 assembly {
116                     let returndata_size := mload(returndata)
117                     revert(add(32, returndata), returndata_size)
118                 }
119             } else {
120                 revert(errorMessage);
121             }
122         }
123     }
124 }
125 
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view virtual returns (bytes calldata) {
132         return msg.data;
133     }
134 }
135 
136 library Strings {
137     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
138     function toString(uint256 value) internal pure returns (string memory) {
139         if (value == 0) {
140             return "0";
141         }
142         uint256 temp = value;
143         uint256 digits;
144         while (temp != 0) {
145             digits++;
146             temp /= 10;
147         }
148         bytes memory buffer = new bytes(digits);
149         while (value != 0) {
150             digits -= 1;
151             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
152             value /= 10;
153         }
154         return string(buffer);
155     }
156 
157     function toHexString(uint256 value) internal pure returns (string memory) {
158         if (value == 0) {
159             return "0x00";
160         }
161         uint256 temp = value;
162         uint256 length = 0;
163         while (temp != 0) {
164             length++;
165             temp >>= 8;
166         }
167         return toHexString(value, length);
168     }
169 
170     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
171         bytes memory buffer = new bytes(2 * length + 2);
172         buffer[0] = "0";
173         buffer[1] = "x";
174         for (uint256 i = 2 * length + 1; i > 1; --i) {
175             buffer[i] = _HEX_SYMBOLS[value & 0xf];
176             value >>= 4;
177         }
178         require(value == 0, "Strings: hex length insufficient");
179         return string(buffer);
180     }
181 }
182 
183 interface IERC165 {
184     function supportsInterface(bytes4 interfaceId) external view returns (bool);
185 }
186 
187 abstract contract ERC165 is IERC165 {
188     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
189         return interfaceId == type(IERC165).interfaceId;
190     }
191 }
192 
193 interface IERC721 is IERC165 {
194     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
195     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
196     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
197     function balanceOf(address owner) external view returns (uint256 balance);
198     function ownerOf(uint256 tokenId) external view returns (address owner);
199     function safeTransferFrom(
200         address from,
201         address to,
202         uint256 tokenId
203     ) external;
204 
205     function transferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external;
210 
211     function approve(address to, uint256 tokenId) external;
212     function getApproved(uint256 tokenId) external view returns (address operator);
213     function setApprovalForAll(address operator, bool _approved) external;
214     function isApprovedForAll(address owner, address operator) external view returns (bool);
215     function safeTransferFrom(
216         address from,
217         address to,
218         uint256 tokenId,
219         bytes calldata data
220     ) external;
221 }
222 
223 interface IERC721Metadata is IERC721 {
224     function name() external view returns (string memory);
225     function symbol() external view returns (string memory);
226     function tokenURI(uint256 tokenId) external view returns (string memory);
227 }
228 
229 interface IERC721Enumerable is IERC721 {
230     function totalSupply() external view returns (uint256);
231     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
232     function tokenByIndex(uint256 index) external view returns (uint256);
233 }
234 
235 library MerkleProof {
236     
237     function verify(
238         bytes32[] memory proof,
239         bytes32 root,
240         bytes32 leaf
241     ) internal pure returns (bool) {
242         return processProof(proof, leaf) == root;
243     }
244 
245     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
246         bytes32 computedHash = leaf;
247         for (uint256 i = 0; i < proof.length; i++) {
248             bytes32 proofElement = proof[i];
249             if (computedHash <= proofElement) {
250                 // Hash(current computed hash + current element of the proof)
251                 computedHash = _efficientHash(computedHash, proofElement);
252             } else {
253                 // Hash(current element of the proof + current computed hash)
254                 computedHash = _efficientHash(proofElement, computedHash);
255             }
256         }
257         return computedHash;
258     }
259 
260     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
261         assembly {
262             mstore(0x00, a)
263             mstore(0x20, b)
264             value := keccak256(0x00, 0x40)
265         }
266     }
267 }
268 
269 abstract contract Ownable is Context {
270     address private _owner;
271     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
272 
273     constructor() {
274         _setOwner(_msgSender());
275     }
276 
277     function owner() public view virtual returns (address) {
278         return _owner;
279     }
280 
281     modifier onlyOwner() {
282         require(owner() == _msgSender(), "Ownable: caller is not the owner");
283         _;
284     }
285 
286     function renounceOwnership() public virtual onlyOwner {
287         _setOwner(address(0));
288     }
289 
290     function transferOwnership(address newOwner) public virtual onlyOwner {
291         require(newOwner != address(0), "Ownable: new owner is the zero address");
292         _setOwner(newOwner);
293     }
294 
295     function _setOwner(address newOwner) private {
296         address oldOwner = _owner;
297         _owner = newOwner;
298         emit OwnershipTransferred(oldOwner, newOwner);
299     }
300 }
301 
302 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
303     using Address for address;
304     string private _name;
305     string private _symbol;
306     address[] internal _owners;
307     mapping(uint256 => address) private _tokenApprovals;
308     mapping(address => mapping(address => bool)) private _operatorApprovals;     
309     constructor(string memory name_, string memory symbol_) {
310         _name = name_;
311         _symbol = symbol_;
312     }     
313     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
314         return
315             interfaceId == type(IERC721).interfaceId ||
316             interfaceId == type(IERC721Metadata).interfaceId ||
317             super.supportsInterface(interfaceId);
318     }
319     function balanceOf(address owner) public view virtual override returns (uint256) {
320         require(owner != address(0), "ERC721: balance query for the zero address");
321         uint count = 0;
322         uint length = _owners.length;
323         for( uint i = 0; i < length; ++i ){
324           if( owner == _owners[i] ){
325             ++count;
326           }
327         }
328         delete length;
329         return count;
330     }
331     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
332         address owner = _owners[tokenId];
333         require(owner != address(0), "ERC721: owner query for nonexistent token");
334         return owner;
335     }
336     function name() public view virtual override returns (string memory) {
337         return _name;
338     }
339     function symbol() public view virtual override returns (string memory) {
340         return _symbol;
341     }
342     function approve(address to, uint256 tokenId) public virtual override {
343         address owner = ERC721.ownerOf(tokenId);
344         require(to != owner, "ERC721: approval to current owner");
345         require(
346             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
347             "ERC721: approve caller is not owner nor approved for all"
348         );
349         _approve(to, tokenId);
350     }
351     function getApproved(uint256 tokenId) public view virtual override returns (address) {
352         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
353         return _tokenApprovals[tokenId];
354     }
355     function setApprovalForAll(address operator, bool approved) public virtual override {
356         require(operator != _msgSender(), "ERC721: approve to caller");
357         _operatorApprovals[_msgSender()][operator] = approved;
358         emit ApprovalForAll(_msgSender(), operator, approved);
359     }
360     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
361         return _operatorApprovals[owner][operator];
362     }
363     function transferFrom(
364         address from,
365         address to,
366         uint256 tokenId
367     ) public virtual override {
368         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
369         _transfer(from, to, tokenId);
370     }
371     function safeTransferFrom(
372         address from,
373         address to,
374         uint256 tokenId
375     ) public virtual override {
376         safeTransferFrom(from, to, tokenId, "");
377     }
378     function safeTransferFrom(
379         address from,
380         address to,
381         uint256 tokenId,
382         bytes memory _data
383     ) public virtual override {
384         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
385         _safeTransfer(from, to, tokenId, _data);
386     }     
387     function _safeTransfer(
388         address from,
389         address to,
390         uint256 tokenId,
391         bytes memory _data
392     ) internal virtual {
393         _transfer(from, to, tokenId);
394         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
395     }
396 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
397         return tokenId < _owners.length && _owners[tokenId] != address(0);
398     }
399 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
400         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
401         address owner = ERC721.ownerOf(tokenId);
402         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
403     }
404 	function _safeMint(address to, uint256 tokenId) internal virtual {
405         _safeMint(to, tokenId, "");
406     }
407 	function _safeMint(
408         address to,
409         uint256 tokenId,
410         bytes memory _data
411     ) internal virtual {
412         _mint(to, tokenId);
413         require(
414             _checkOnERC721Received(address(0), to, tokenId, _data),
415             "ERC721: transfer to non ERC721Receiver implementer"
416         );
417     }
418 	function _mint(address to, uint256 tokenId) internal virtual {
419         require(to != address(0), "ERC721: mint to the zero address");
420         require(!_exists(tokenId), "ERC721: token already minted");
421         _beforeTokenTransfer(address(0), to, tokenId);
422         _owners.push(to);
423         emit Transfer(address(0), to, tokenId);
424     }
425 	function _burn(uint256 tokenId) internal virtual {
426         address owner = ERC721.ownerOf(tokenId);
427         _beforeTokenTransfer(owner, address(0), tokenId);
428         _approve(address(0), tokenId);
429         _owners[tokenId] = address(0);
430         emit Transfer(owner, address(0), tokenId);
431     }
432 	function _transfer(
433         address from,
434         address to,
435         uint256 tokenId
436     ) internal virtual {
437         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
438         require(to != address(0), "ERC721: transfer to the zero address");
439         _beforeTokenTransfer(from, to, tokenId);
440         _approve(address(0), tokenId);
441         _owners[tokenId] = to;
442         emit Transfer(from, to, tokenId);
443     }
444 	function _approve(address to, uint256 tokenId) internal virtual {
445         _tokenApprovals[tokenId] = to;
446         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
447     }
448 	function _checkOnERC721Received(
449         address from,
450         address to,
451         uint256 tokenId,
452         bytes memory _data
453     ) private returns (bool) {
454         if (to.isContract()) {
455             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
456                 return retval == IERC721Receiver.onERC721Received.selector;
457             } catch (bytes memory reason) {
458                 if (reason.length == 0) {
459                     revert("ERC721: transfer to non ERC721Receiver implementer");
460                 } else {
461                     assembly {
462                         revert(add(32, reason), mload(reason))
463                     }
464                 }
465             }
466         } else {
467             return true;
468         }
469     }
470 	function _beforeTokenTransfer(
471         address from,
472         address to,
473         uint256 tokenId
474     ) internal virtual {}
475 }
476 
477 abstract contract ERC721Enum is ERC721, IERC721Enumerable {
478     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
479         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
480     }
481     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
482         require(index < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
483         uint count;
484         for( uint i; i < _owners.length; ++i ){
485             if( owner == _owners[i] ){
486                 if( count == index )
487                     return i;
488                 else
489                     ++count;
490             }
491         }
492         require(false, "ERC721Enum: owner ioob");
493     }
494     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
495         require(0 < ERC721.balanceOf(owner), "ERC721Enum: owner ioob");
496         uint256 tokenCount = balanceOf(owner);
497         uint256[] memory tokenIds = new uint256[](tokenCount);
498         for (uint256 i = 0; i < tokenCount; i++) {
499             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
500         }
501         return tokenIds;
502     }
503     function totalSupply() public view virtual override returns (uint256) {
504         return _owners.length;
505     }
506     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
507         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
508         return index;
509     }
510 }
511 
512 contract ScrappyPenguins is ERC721Enum, Ownable, ReentrancyGuard {
513 	using Strings for uint256;
514 	string public baseURI;
515 	//sale settings
516     uint256 public preSaleCost = 0.069 ether;
517     uint256 public preSaleSupply = 4000;
518 	uint256 public cost = 0.069 ether;
519 	uint256 public maxSupply = 10000;
520 	uint256 public maxMint = 5;
521 	uint256 public status;
522     uint256 public claims;
523     uint256 public claimAmount = 10;
524     bytes32 public whitelistRoot;
525     bytes32 public claimRoot;
526     address private penguinNFT = 0x330ceed8E9Fc1C5051389FE435C8574A22EFD6B2;
527     address private dev = 0xCbc22d61480c641FA22B11Debad9A1490534c193;
528     address private company = 0x6E24bf4007e28EC44Af9d7E121C87D52c2Cc98D6;
529     
530 
531     mapping (address => bool) public airDrops;
532     mapping (uint256 => bool) public claimed;
533 
534 	constructor(
535 	string memory _name,
536 	string memory _symbol,
537 	string memory _initBaseURI
538 	) ERC721(_name, _symbol){
539 	setBaseURI(_initBaseURI);
540 	}
541 
542 	function _baseURI() internal view virtual returns (string memory) {
543 	    return baseURI;
544 	}
545     function mintPreSale(uint256 _mintAmount, bytes32[] calldata proof) external payable nonReentrant{
546         require(status == 1, "Presale inactive");
547         require(isWhitelisted(msg.sender, proof), "Not whitelisted");
548         require(_mintAmount > 0 && _mintAmount <= maxMint, "0" );
549         require(msg.value >= preSaleCost *_mintAmount,"ETH");
550         uint256 s = totalSupply();
551         require(s + _mintAmount - claims <= preSaleSupply , "Max" );
552         for (uint256 i = 0; i < _mintAmount; ++i) {
553         _safeMint(msg.sender, s + i, "");
554         }
555         delete s;
556 	}
557      function giveAway(bytes32[] calldata proof) external nonReentrant{
558         require(isClaimWhitelisted(msg.sender, proof), "Not whitelisted");
559         require (!airDrops[msg.sender] ,"Claimed");
560         uint256 s = totalSupply();
561         require(s <= maxSupply , "Max" );
562         _safeMint(msg.sender, s , "");
563         airDrops[msg.sender] = true;
564         delete s;
565 	}
566     function mint(uint256 _mintAmount) external payable nonReentrant{
567         require(status == 2, "Sale inactive");
568         require(_mintAmount > 0 && _mintAmount <= maxMint, "0" );
569         require(msg.value >= cost *_mintAmount,"ETH");
570         uint256 s = totalSupply();
571         require(s + _mintAmount <= maxSupply , "Max" );
572         for (uint256 i = 0; i < _mintAmount; ++i) {
573         _safeMint(msg.sender, s + i, "");
574         }
575         delete s;
576 	}
577     function adminMint(address[] calldata recipient) external onlyOwner{
578 	    uint256 s = totalSupply();
579 	    require(s + recipient.length <= maxSupply, "Max" );
580 	    for(uint i = 0; i < recipient.length; ++i){
581 	    _safeMint(recipient[i], s++, "" );
582 	    }
583 	    delete s;
584 	}
585     function claim(uint256[] calldata id) external nonReentrant{
586         require(id.length >= claimAmount, "< 10");
587         uint256 s = totalSupply();
588         uint256 claimable = id.length/claimAmount;
589         require(s + claimable <= maxSupply, "Max" );
590         for(uint256 i=0;i<claimable*claimAmount;++i) {
591             require (msg.sender == IERC721(penguinNFT).ownerOf(id[i]),"Invalid id");
592             require (!claimed[id[i]] ,"Id claimed");
593             claimed[id[i]] = true;
594         }
595         for (uint256 i = 0; i < claimable; ++i) {
596         _safeMint(msg.sender, s + i, "");
597         }
598         delete s;
599         claims+= claimable;
600 	}
601 	function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
602 	    require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
603 	    string memory currentBaseURI = _baseURI();
604 	    return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : "";
605 	}
606 	function isWhitelisted(address account, bytes32[] calldata proof) public view returns (bool) {
607         return _verify(_leaf(account), proof, whitelistRoot);
608     }
609     function isClaimWhitelisted(address account, bytes32[] calldata proof) public view returns (bool) {
610         return _verify(_leaf(account), proof, claimRoot);
611     }
612     function setWhitelistRoot(bytes32 _root) external onlyOwner {
613         whitelistRoot = _root;
614     }
615     function setClaimRoot(bytes32 _root) external onlyOwner {
616         claimRoot = _root;
617     }
618     function _leaf(address account) internal pure returns (bytes32) {
619         return keccak256(abi.encodePacked(account));
620     }
621     function _verify(bytes32 leaf,bytes32[] memory proof,bytes32 root) internal pure returns (bool) {
622         return MerkleProof.verify(proof, root, leaf);
623     }
624 	function setMaxAmount(uint256 _newMaxMintAmount) external onlyOwner {
625 	    maxMint = _newMaxMintAmount;
626 	}
627     function setClaimAmount(uint256 _amount) external onlyOwner {
628 	    claimAmount = _amount;
629 	}
630     function setMaxSupply(uint256 _supply) external onlyOwner {
631 	    maxSupply = _supply;
632 	}
633     function setPreSaleSupply(uint256 _supply) external onlyOwner {
634 	    preSaleSupply = _supply;
635 	}
636     function setCost(uint256 _cost) external onlyOwner {
637 	    cost = _cost;
638 	}
639     function setPreSaleCost(uint256 _cost) external onlyOwner {
640 	    preSaleCost = _cost;
641 	}
642 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
643 	    baseURI = _newBaseURI;
644 	}
645     function setSaleStatus(uint256 _status) external onlyOwner {
646         status = _status;
647 	}
648 	function withdraw() external onlyOwner {
649         (bool success, ) = payable(dev).call{value: address(this).balance*12/100}("");
650         require(success);
651         (bool _success, ) = payable(company).call{value: address(this).balance}("");
652         require(_success);
653 	}
654     function setWithdrawAddress(address _company) external onlyOwner {
655         company = _company;
656     }
657 }