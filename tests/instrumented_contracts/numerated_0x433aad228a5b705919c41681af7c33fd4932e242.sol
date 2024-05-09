1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC165 {
6    
7     function supportsInterface(bytes4 interfaceId) external view returns (bool);
8 }
9 
10 pragma solidity ^0.8.0;
11 
12 interface IERC721 is IERC165 {
13 
14     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
15 
16     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
17 
18     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
19 
20     function balanceOf(address owner) external view returns (uint256 balance);
21 
22     function ownerOf(uint256 tokenId) external view returns (address owner);
23 
24     function safeTransferFrom(
25         address from,
26         address to,
27         uint256 tokenId
28     ) external;
29 
30     function transferFrom(
31         address from,
32         address to,
33         uint256 tokenId
34     ) external;
35 
36     function approve(address to, uint256 tokenId) external;
37 
38     function getApproved(uint256 tokenId) external view returns (address operator);
39 
40     function setApprovalForAll(address operator, bool _approved) external;
41 
42     function isApprovedForAll(address owner, address operator) external view returns (bool);
43 
44     function safeTransferFrom(
45         address from,
46         address to,
47         uint256 tokenId,
48         bytes calldata data
49     ) external;
50 }
51 
52 pragma solidity ^0.8.0;
53 
54 interface IERC721Enumerable is IERC721 {
55 
56     function totalSupply() external view returns (uint256);
57 
58     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
59 
60     function tokenByIndex(uint256 index) external view returns (uint256);
61 }
62 
63 pragma solidity ^0.8.0;
64 
65 abstract contract ERC165 is IERC165 {
66     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
67         return interfaceId == type(IERC165).interfaceId;
68     }
69 }
70 
71 pragma solidity ^0.8.0;
72 
73 library Strings {
74     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
75 
76     function toString(uint256 value) internal pure returns (string memory) {
77         
78         if (value == 0) {
79             return "0";
80         }
81         uint256 temp = value;
82         uint256 digits;
83         while (temp != 0) {
84             digits++;
85             temp /= 10;
86         }
87         bytes memory buffer = new bytes(digits);
88         while (value != 0) {
89             digits -= 1;
90             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
91             value /= 10;
92         }
93         return string(buffer);
94     }
95 
96     function toHexString(uint256 value) internal pure returns (string memory) {
97         if (value == 0) {
98             return "0x00";
99         }
100         uint256 temp = value;
101         uint256 length = 0;
102         while (temp != 0) {
103             length++;
104             temp >>= 8;
105         }
106         return toHexString(value, length);
107     }
108 
109     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
110         bytes memory buffer = new bytes(2 * length + 2);
111         buffer[0] = "0";
112         buffer[1] = "x";
113         for (uint256 i = 2 * length + 1; i > 1; --i) {
114             buffer[i] = _HEX_SYMBOLS[value & 0xf];
115             value >>= 4;
116         }
117         require(value == 0, "Strings: hex length insufficient");
118         return string(buffer);
119     }
120 }
121 
122 pragma solidity ^0.8.0;
123 
124 library Address {
125 
126     function isContract(address account) internal view returns (bool) {
127 
128         uint256 size;
129         assembly {
130             size := extcodesize(account)
131         }
132         return size > 0;
133     }
134 
135     function sendValue(address payable recipient, uint256 amount) internal {
136         require(address(this).balance >= amount, "Address: insufficient balance");
137 
138         (bool success, ) = recipient.call{value: amount}("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
143         return functionCall(target, data, "Address: low-level call failed");
144     }
145 
146     function functionCall(
147         address target,
148         bytes memory data,
149         string memory errorMessage
150     ) internal returns (bytes memory) {
151         return functionCallWithValue(target, data, 0, errorMessage);
152     }
153 
154     function functionCallWithValue(
155         address target,
156         bytes memory data,
157         uint256 value
158     ) internal returns (bytes memory) {
159         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
160     }
161 
162     function functionCallWithValue(
163         address target,
164         bytes memory data,
165         uint256 value,
166         string memory errorMessage
167     ) internal returns (bytes memory) {
168         require(address(this).balance >= value, "Address: insufficient balance for call");
169         require(isContract(target), "Address: call to non-contract");
170 
171         (bool success, bytes memory returndata) = target.call{value: value}(data);
172         return verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
176         return functionStaticCall(target, data, "Address: low-level static call failed");
177     }
178 
179     function functionStaticCall(
180         address target,
181         bytes memory data,
182         string memory errorMessage
183     ) internal view returns (bytes memory) {
184         require(isContract(target), "Address: static call to non-contract");
185 
186         (bool success, bytes memory returndata) = target.staticcall(data);
187         return verifyCallResult(success, returndata, errorMessage);
188     }
189 
190     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
191         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
192     }
193 
194     function functionDelegateCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         require(isContract(target), "Address: delegate call to non-contract");
200 
201         (bool success, bytes memory returndata) = target.delegatecall(data);
202         return verifyCallResult(success, returndata, errorMessage);
203     }
204 
205     function verifyCallResult(
206         bool success,
207         bytes memory returndata,
208         string memory errorMessage
209     ) internal pure returns (bytes memory) {
210         if (success) {
211             return returndata;
212         } else {
213         
214             if (returndata.length > 0) {
215 
216                 assembly {
217                     let returndata_size := mload(returndata)
218                     revert(add(32, returndata), returndata_size)
219                 }
220             } else {
221                 revert(errorMessage);
222             }
223         }
224     }
225 }
226 
227 library SafeMath {
228     
229     function add(uint256 a, uint256 b) internal pure returns (uint256) {
230         uint256 c = a + b;
231         require(c >= a, "SafeMath: addition overflow");
232         return c;
233     }
234     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
235         require(b <= a, "SafeMath: subtraction overflow");
236         uint256 c = a - b;
237         return c;
238     }
239     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
240        if (a == 0) {
241             return 0;
242         }
243         uint256 c = a * b;
244         require(c / a == b, "SafeMath: multiplication overflow");
245         return c;
246     }
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         // Solidity only automatically asserts when dividing by 0
249         require(b > 0, "SafeMath: division by zero");
250         uint256 c = a / b;
251         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
252 
253         return c;
254     }
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         require(b != 0, "SafeMath: modulo by zero");
257         return a % b;
258     }
259 }
260 
261 pragma solidity ^0.8.0;
262 
263 interface IERC721Metadata is IERC721 {
264 
265     function name() external view returns (string memory);
266 
267     function symbol() external view returns (string memory);
268 
269     function tokenURI(uint256 tokenId) external view returns (string memory);
270 }
271 
272 pragma solidity ^0.8.0;
273 
274 interface IERC721Receiver {
275 
276     function onERC721Received(
277         address operator,
278         address from,
279         uint256 tokenId,
280         bytes calldata data
281     ) external returns (bytes4);
282 }
283 
284 pragma solidity ^0.8.0;
285 
286 abstract contract Context {
287     function _msgSender() internal view virtual returns (address) {
288         return msg.sender;
289     }
290 
291     function _msgData() internal view virtual returns (bytes calldata) {
292         return msg.data;
293     }
294 }
295 
296 pragma solidity ^0.8.0;
297 
298 
299 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
300     using Address for address;
301     using Strings for uint256;
302 
303     string private _name;
304 
305     string private _symbol;
306 
307     mapping(uint256 => address) private _owners;
308 
309     mapping(address => uint256) private _balances;
310 
311     mapping(uint256 => address) private _tokenApprovals;
312 
313     mapping(address => mapping(address => bool)) private _operatorApprovals;
314 
315     mapping(address=>mapping(uint256=>uint256)) userPerIdMintingTime;
316 
317     constructor(string memory name_, string memory symbol_) {
318         _name = name_;
319         _symbol = symbol_;
320     }
321 
322 
323     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
324         return
325             interfaceId == type(IERC721).interfaceId ||
326             interfaceId == type(IERC721Metadata).interfaceId ||
327             super.supportsInterface(interfaceId);
328     }
329 
330     function balanceOf(address owner) public view virtual override returns (uint256) {
331         require(owner != address(0), "ERC721: balance query for the zero address");
332         return _balances[owner];
333     }
334 
335     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
336         address owner = _owners[tokenId];
337         require(owner != address(0), "ERC721: owner query for nonexistent token");
338         return owner;
339     }
340 
341     function name() public view virtual override returns (string memory) {
342         return _name;
343     }
344 
345     function symbol() public view virtual override returns (string memory) {
346         return _symbol;
347     }
348 
349     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
350         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
351 
352         string memory baseURI = _baseURI();
353         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
354     }
355 
356     function _baseURI() internal view virtual returns (string memory) {
357         return "";
358     }
359 
360     function approve(address to, uint256 tokenId) public virtual override {
361         address owner = ERC721.ownerOf(tokenId);
362         require(to != owner, "ERC721: approval to current owner");
363 
364         require(
365             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
366             "ERC721: approve caller is not owner nor approved for all"
367         );
368 
369         _approve(to, tokenId);
370     }
371 
372     function getApproved(uint256 tokenId) public view virtual override returns (address) {
373         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
374 
375         return _tokenApprovals[tokenId];
376     }
377 
378     function setApprovalForAll(address operator, bool approved) public virtual override {
379         require(operator != _msgSender(), "ERC721: approve to caller");
380 
381         _operatorApprovals[_msgSender()][operator] = approved;
382         emit ApprovalForAll(_msgSender(), operator, approved);
383     }
384 
385     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
386         return _operatorApprovals[owner][operator];
387     }
388 
389     function transferFrom(
390         address from,
391         address to,
392         uint256 tokenId
393     ) public virtual override {
394         
395         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
396 
397         _transfer(from, to, tokenId);
398     }
399 
400     function safeTransferFrom(
401         address from,
402         address to,
403         uint256 tokenId
404     ) public virtual override {
405         safeTransferFrom(from, to, tokenId, "");
406     }
407 
408     function safeTransferFrom(
409         address from,
410         address to,
411         uint256 tokenId,
412         bytes memory _data
413     ) public virtual override {
414         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
415         _safeTransfer(from, to, tokenId, _data);
416     }
417 
418 
419     function _safeTransfer(
420         address from,
421         address to,
422         uint256 tokenId,
423         bytes memory _data
424     ) internal virtual {
425         _transfer(from, to, tokenId);
426         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
427     }
428 
429 
430     function _exists(uint256 tokenId) internal view virtual returns (bool) {
431         return _owners[tokenId] != address(0);
432     }
433 
434     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
435         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
436         address owner = ERC721.ownerOf(tokenId);
437         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
438     }
439 
440     function _safeMint(address to, uint256 tokenId) internal virtual {
441         _safeMint(to, tokenId, "");
442     }
443 
444     function _safeMint(
445         address to,
446         uint256 tokenId,
447         bytes memory _data
448     ) internal virtual {
449         _mint(to, tokenId);
450         require(
451             _checkOnERC721Received(address(0), to, tokenId, _data),
452             "ERC721: transfer to non ERC721Receiver implementer"
453         );
454     }
455 
456     function _mint(address to, uint256 tokenId) internal virtual {
457         require(to != address(0), "ERC721: mint to the zero address");
458         require(!_exists(tokenId), "ERC721: token already minted");
459 
460         _beforeTokenTransfer(address(0), to, tokenId);
461 
462         _balances[to] += 1;
463         _owners[tokenId] = to;
464 
465         emit Transfer(address(0), to, tokenId);
466     }
467 
468     function _burn(uint256 tokenId) internal virtual {
469         address owner = ERC721.ownerOf(tokenId);
470 
471         _beforeTokenTransfer(owner, address(0), tokenId);
472 
473         _approve(address(0), tokenId);
474 
475         _balances[owner] -= 1;
476         delete _owners[tokenId];
477 
478         emit Transfer(owner, address(0), tokenId);
479     }
480 
481     function _transfer(
482         address from,
483         address to,
484         uint256 tokenId
485     ) internal virtual {
486         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
487         require(to != address(0), "ERC721: transfer to the zero address");
488 
489         _beforeTokenTransfer(from, to, tokenId);
490 
491         _approve(address(0), tokenId);
492 
493         _balances[from] -= 1;
494         _balances[to] += 1;
495         _owners[tokenId] = to;
496 
497         userPerIdMintingTime[from][tokenId] = 0;
498         emit Transfer(from, to, tokenId);
499     }
500 
501     function _approve(address to, uint256 tokenId) internal virtual {
502         _tokenApprovals[tokenId] = to;
503         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
504     }
505 
506     function _checkOnERC721Received(
507         address from,
508         address to,
509         uint256 tokenId,
510         bytes memory _data
511     ) private returns (bool) {
512         if (to.isContract()) {
513             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
514                 return retval == IERC721Receiver.onERC721Received.selector;
515             } catch (bytes memory reason) {
516                 if (reason.length == 0) {
517                     revert("ERC721: transfer to non ERC721Receiver implementer");
518                 } else {
519                     assembly {
520                         revert(add(32, reason), mload(reason))
521                     }
522                 }
523             }
524         } else {
525             return true;
526         }
527     }
528 
529     function _beforeTokenTransfer(
530         address from,
531         address to,
532         uint256 tokenId
533     ) internal virtual {}
534 }
535 
536 pragma solidity ^0.8.0;
537 
538 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
539     
540     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
541 
542     mapping(uint256 => uint256) private _ownedTokensIndex;
543 
544     uint256[] private _allTokens;
545 
546     mapping(uint256 => uint256) private _allTokensIndex;
547 
548     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
549         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
550     }
551 
552     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
553         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
554         return _ownedTokens[owner][index];
555     }
556 
557     function totalSupply() public view virtual override returns (uint256) {
558         return _allTokens.length;
559     }
560 
561     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
562         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
563         return _allTokens[index];
564     }
565 
566     function _beforeTokenTransfer(
567         address from,
568         address to,
569         uint256 tokenId
570     ) internal virtual override {
571         super._beforeTokenTransfer(from, to, tokenId);
572 
573         if (from == address(0)) {
574             _addTokenToAllTokensEnumeration(tokenId);
575         } else if (from != to) {
576             _removeTokenFromOwnerEnumeration(from, tokenId);
577         }
578         if (to == address(0)) {
579             _removeTokenFromAllTokensEnumeration(tokenId);
580         } else if (to != from) {
581             _addTokenToOwnerEnumeration(to, tokenId);
582         }
583     }
584 
585     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
586         uint256 length = ERC721.balanceOf(to);
587         _ownedTokens[to][length] = tokenId;
588         _ownedTokensIndex[tokenId] = length;
589     }
590 
591     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
592         _allTokensIndex[tokenId] = _allTokens.length;
593         _allTokens.push(tokenId);
594     }
595 
596     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
597 
598         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
599         uint256 tokenIndex = _ownedTokensIndex[tokenId];
600 
601         
602         if (tokenIndex != lastTokenIndex) {
603             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
604 
605             _ownedTokens[from][tokenIndex] = lastTokenId;
606             _ownedTokensIndex[lastTokenId] = tokenIndex;
607         }
608 
609         delete _ownedTokensIndex[tokenId];
610         delete _ownedTokens[from][lastTokenIndex];
611     }
612 
613     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
614        
615         uint256 lastTokenIndex = _allTokens.length - 1;
616         uint256 tokenIndex = _allTokensIndex[tokenId];
617 
618         uint256 lastTokenId = _allTokens[lastTokenIndex];
619 
620         _allTokens[tokenIndex] = lastTokenId;
621         _allTokensIndex[lastTokenId] = tokenIndex; 
622 
623         delete _allTokensIndex[tokenId];
624         _allTokens.pop();
625     }
626 }
627 
628 pragma solidity ^0.8.0;
629 
630 abstract contract Ownable is Context {
631     address private _owner;
632 
633     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
634 
635     constructor() {
636         _setOwner(_msgSender());
637     }
638 
639     function owner() public view virtual returns (address) {
640         return _owner;
641     }
642 
643     modifier onlyOwner() {
644         require(owner() == _msgSender(), "Ownable: caller is not the owner");
645         _;
646     }
647 
648     function renounceOwnership() public virtual onlyOwner {
649         _setOwner(address(0));
650     }
651 
652     function transferOwnership(address newOwner) public virtual onlyOwner {
653         require(newOwner != address(0), "Ownable: new owner is the zero address");
654         _setOwner(newOwner);
655     }
656 
657     function _setOwner(address newOwner) private {
658         address oldOwner = _owner;
659         _owner = newOwner;
660         emit OwnershipTransferred(oldOwner, newOwner);
661     }
662 }
663 
664 interface Savage {
665     function totalSupply() external view returns (uint256);
666     function balanceOf(address account) external view returns (uint256);
667     function transfer(address recipient, uint256 amount) external returns (bool);
668     function allowance(address owner, address spender) external view returns (uint256);
669     function approve(address spender, uint256 amount) external returns (bool);
670     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
671     event Transfer(address indexed from, address indexed to, uint256 value);
672     event Approval(address indexed owner, address indexed spender, uint256 value);
673 }
674 
675 
676 
677 pragma solidity ^0.8.0;
678 
679 contract SavageWolves is ERC721Enumerable, Ownable {
680 
681     Savage public savage;
682     using Strings for uint256;
683     using SafeMath for uint256;
684 
685     string public baseURI;
686     string private baseExtension = ".json";
687 
688     bool public revealed = false;
689     string public notRevealedUri;
690 
691     //mint cost
692     uint256 public presaleCost = 0.08 ether;
693     uint256 public publicCost = 0.08 ether;
694 
695     //max supply
696     uint256 public presaleMaxSupply = 2000;
697     uint256 public publicMaxSupply = 2000;
698 
699     //max mint
700     uint256 public presaleMintLimit = 3;
701     uint256 public publicMintLimit = 5;
702 
703     bool public isPresaleStart = false;
704     bool public isPublicStart = false;
705 
706     mapping(address => bool) public isWhitelisted;
707     mapping(address=>mapping(uint256=>bool)) private isMinter;
708 
709     mapping(address=>uint256) private mintedNFTs;
710     uint256 private presaleMinted;
711     uint256 private publicMinted;
712 
713     constructor(
714         string memory _name,
715         string memory _symbol,
716         string memory _initBaseURI,
717         string memory _initNotRevealedUri,
718         Savage _savage
719     ) ERC721(_name, _symbol) {
720         setBaseURI(_initBaseURI);
721         setNotRevealedURI(_initNotRevealedUri);
722         savage = _savage;
723     }
724 
725     
726 
727     function mint(uint256 _mintAmount) public payable {
728         require(isPresaleStart == true || isPublicStart == true, "Neither of the sale is started yet!");
729         uint256 supply = totalSupply();
730         require(_mintAmount > 0, "need to mint at least 1 NFT");
731 
732         if(isPresaleStart == true){
733             require(isWhitelisted[msg.sender]==true, "You're not whitelisted!");
734             require(_mintAmount <= presaleMintLimit, "You can mint in range (1-3) NFT!");
735             require(msg.value >= presaleCost.mul(_mintAmount), "insufficient funds");
736             require(presaleMinted.add(_mintAmount) <= presaleMaxSupply, "max NFT presale limit exceeded");
737             require(mintedNFTs[msg.sender].add(_mintAmount) <= presaleMintLimit, "You can mint max 3 NFTs!");
738             for (uint8 i = 1; i <= _mintAmount; i++) {  
739                 _safeMint(msg.sender, supply + i);
740                 userPerIdMintingTime[msg.sender][supply + i] = block.timestamp;
741                 isMinter[msg.sender][supply+i] = true;
742             }
743             mintedNFTs[msg.sender]+=_mintAmount;
744             presaleMinted += _mintAmount;
745         }
746 
747         else if(isPublicStart == true){
748             require(_mintAmount <= publicMintLimit, "You can mint in range (1-5) NFT!");
749             require(msg.value >= publicCost.mul(_mintAmount), "insufficient funds");
750             require(publicMinted.add(_mintAmount) <= publicMaxSupply, "max NFT presale limit exceeded");
751             require(mintedNFTs[msg.sender].add(_mintAmount) <= publicMintLimit, "You can mint max 5 NFTs!");
752             for (uint8 i = 1; i <= _mintAmount; i++) {  
753                 _safeMint(msg.sender, supply + i);
754                 userPerIdMintingTime[msg.sender][supply + i] = block.timestamp;
755                 isMinter[msg.sender][supply+i] = true;
756             }
757             mintedNFTs[msg.sender]+=_mintAmount;
758             publicMinted += _mintAmount;
759         }
760         
761     }
762 
763 
764     function calculateTokens(address _user) public view returns(uint256){
765         uint256 tokens;
766         for(uint8 i=0; i < walletOfOwner(_user).length; i++){
767             if(isMinter[_user][walletOfOwner(_user)[i]] == true && userPerIdMintingTime[_user][walletOfOwner(_user)[i]]>0){
768                 if(_user == ownerOf(walletOfOwner(_user)[i])){
769                     tokens+=((block.timestamp - userPerIdMintingTime[_user][walletOfOwner(_user)[i]]).div(1 days)).mul(5);
770                 }
771             } 
772         }
773        return tokens;
774        
775     }
776 
777     function calculateTokensId(address _user, uint256 _id) public view returns(uint256){
778         uint256 tokens;
779         if(_user == ownerOf(_id)){
780             if(isMinter[_user][_id] == true && userPerIdMintingTime[_user][_id]>0){
781             tokens+= ((block.timestamp - userPerIdMintingTime[_user][_id])/(1 days))*5;
782             }
783         }
784         
785         return tokens;
786     }
787 
788     function claimTokens() public {
789         require(calculateTokens(msg.sender) > 0,"You don't have tokens for reward!");
790         uint256 tokens = calculateTokens(msg.sender)*10**18;
791         savage.transfer(msg.sender,tokens);
792         
793         for(uint8 i=0; i < walletOfOwner(msg.sender).length; i++){
794             userPerIdMintingTime[msg.sender][walletOfOwner(msg.sender)[i]] = block.timestamp; 
795         }
796     }
797 
798     function claimById(uint8 _tokenId) public{
799         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
800         require(ownerOf(_tokenId)==msg.sender,"You don't own this NFT!");
801         require(calculateTokens(msg.sender) > 0,"You don't have tokens for reward!");
802         uint256 tokensById = calculateTokensId(msg.sender, _tokenId)*10**18;
803         savage.transfer(msg.sender,tokensById);
804         userPerIdMintingTime[msg.sender][_tokenId] = block.timestamp;
805     }
806 
807     // internal
808     function _baseURI() internal view virtual override returns (string memory) {
809         return baseURI;
810     }
811 
812     //UTILITIES
813     function setPresaleStatus(bool _state) public onlyOwner{
814         isPresaleStart = _state;
815     }
816 
817     function setPublicMintStatus(bool _state) public onlyOwner{
818         isPublicStart = _state;
819     }
820 
821     function setPresaleMaxSupply(uint256 _newSupply) public onlyOwner{
822         presaleMaxSupply=_newSupply;
823     }
824 
825     function setPublicMaxSupply(uint256 _newSupply) public onlyOwner{
826         publicMaxSupply=_newSupply;
827     }
828 
829     function setPresaleCost(uint256 _newCost) public onlyOwner{
830         presaleCost=_newCost;
831     }
832 
833     function setPublicCost(uint256 _newCost) public onlyOwner{
834         publicCost=_newCost;
835     }
836 
837     function addWhitelist(address[] memory _addresses) external onlyOwner {
838         for(uint i = 0; i < _addresses.length; i++) {
839         isWhitelisted[_addresses[i]] = true;
840         }
841     }
842 
843     function removeWhitelist(address[] memory _addresses) external onlyOwner {
844             for(uint i = 0; i < _addresses.length; i++) {
845             isWhitelisted[_addresses[i]] = false;
846             }
847     }
848 
849     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
850         uint256 ownerTokenCount = balanceOf(_owner);
851         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
852         for (uint256 i; i < ownerTokenCount; i++) {
853         tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
854         }
855         return tokenIds;
856     }
857 
858     function tokenURI(uint256 tokenId)
859     public
860     view
861     virtual
862     override
863     returns (string memory){
864         require(
865         _exists(tokenId),
866         "ERC721Metadata: URI query for nonexistent token"
867         );
868         
869         if(revealed == false) {
870             return notRevealedUri;
871         }
872 
873         string memory currentBaseURI = _baseURI();
874         return bytes(currentBaseURI).length > 0
875             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
876             : "";
877     }
878 
879     function reveal() public onlyOwner {
880       revealed = true;
881     }
882     
883     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
884         notRevealedUri = _notRevealedURI;
885     }
886 
887     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
888         publicMintLimit = _limit;
889     }
890 
891     function setNftPresaleLimit(uint256 _limit) public onlyOwner {
892         presaleMintLimit = _limit;
893     }
894 
895     function setBaseURI(string memory _newBaseURI) public onlyOwner {
896         baseURI = _newBaseURI;
897     }
898     
899     function contractBalance() public view returns(uint256){
900         return address(this).balance;
901     }
902 
903     function withdraw(uint256 _amount) public payable onlyOwner {
904         require(contractBalance() >= 0, "contract has no ethers!");
905         require(_amount <= contractBalance(), "contract has not enough ethers!");
906         require(_amount > 0, "Enter more than 0 amount!");
907         uint256 balance = contractBalance();
908         balance -= _amount;
909         (bool os, ) = payable(owner()).call{value: _amount}("");
910         require(os);
911         
912     }
913 }