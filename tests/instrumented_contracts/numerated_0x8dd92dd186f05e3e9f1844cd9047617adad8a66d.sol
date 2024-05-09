1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 pragma solidity ^0.8.0;
5 
6 interface IERC165 {
7     
8     function supportsInterface(bytes4 interfaceId) external view returns (bool);
9 }
10 
11 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
12 pragma solidity ^0.8.0;
13 
14 interface IERC721 is IERC165 {
15     
16     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
17 
18     
19     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
20 
21     
22     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
23 
24 
25     function balanceOf(address owner) external view returns (uint256 balance);
26 
27     
28     function ownerOf(uint256 tokenId) external view returns (address owner);
29 
30     
31     function safeTransferFrom(
32         address from,
33         address to,
34         uint256 tokenId
35     ) external;
36 
37     
38     function transferFrom(
39         address from,
40         address to,
41         uint256 tokenId
42     ) external;
43 
44     
45     function approve(address to, uint256 tokenId) external;
46 
47     
48     function getApproved(uint256 tokenId) external view returns (address operator);
49 
50     
51     function setApprovalForAll(address operator, bool _approved) external;
52 
53     
54     function isApprovedForAll(address owner, address operator) external view returns (bool);
55 
56     
57     function safeTransferFrom(
58         address from,
59         address to,
60         uint256 tokenId,
61         bytes calldata data
62     ) external;
63 }
64 
65 
66 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
67 pragma solidity ^0.8.0;
68 
69 interface IERC721Enumerable is IERC721 {
70     
71     function totalSupply() external view returns (uint256);
72 
73    
74     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
75 
76     
77     function tokenByIndex(uint256 index) external view returns (uint256);
78 }
79 
80 
81 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
82 pragma solidity ^0.8.0;
83 
84 abstract contract ERC165 is IERC165 {
85    
86     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
87         return interfaceId == type(IERC165).interfaceId;
88     }
89 }
90 
91 // File: @openzeppelin/contracts/utils/Strings.sol
92 
93 
94 
95 pragma solidity ^0.8.0;
96 
97 
98 library Strings {
99     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
100 
101     
102     function toString(uint256 value) internal pure returns (string memory) {
103         
104 
105         if (value == 0) {
106             return "0";
107         }
108         uint256 temp = value;
109         uint256 digits;
110         while (temp != 0) {
111             digits++;
112             temp /= 10;
113         }
114         bytes memory buffer = new bytes(digits);
115         while (value != 0) {
116             digits -= 1;
117             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
118             value /= 10;
119         }
120         return string(buffer);
121     }
122 
123     
124     function toHexString(uint256 value) internal pure returns (string memory) {
125         if (value == 0) {
126             return "0x00";
127         }
128         uint256 temp = value;
129         uint256 length = 0;
130         while (temp != 0) {
131             length++;
132             temp >>= 8;
133         }
134         return toHexString(value, length);
135     }
136 
137     
138     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
139         bytes memory buffer = new bytes(2 * length + 2);
140         buffer[0] = "0";
141         buffer[1] = "x";
142         for (uint256 i = 2 * length + 1; i > 1; --i) {
143             buffer[i] = _HEX_SYMBOLS[value & 0xf];
144             value >>= 4;
145         }
146         require(value == 0, "Strings: hex length insufficient");
147         return string(buffer);
148     }
149 }
150 
151 // File: @openzeppelin/contracts/utils/Address.sol
152 
153 
154 
155 pragma solidity ^0.8.0;
156 
157 
158 library Address {
159     
160     function isContract(address account) internal view returns (bool) {
161         
162 
163         uint256 size;
164         assembly {
165             size := extcodesize(account)
166         }
167         return size > 0;
168     }
169 
170     
171     function sendValue(address payable recipient, uint256 amount) internal {
172         require(address(this).balance >= amount, "Address: insufficient balance");
173 
174         (bool success, ) = recipient.call{value: amount}("");
175         require(success, "Address: unable to send value, recipient may have reverted");
176     }
177 
178     
179     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionCall(target, data, "Address: low-level call failed");
181     }
182 
183     
184     function functionCall(
185         address target,
186         bytes memory data,
187         string memory errorMessage
188     ) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, 0, errorMessage);
190     }
191 
192     
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value
197     ) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
199     }
200 
201     
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         require(address(this).balance >= value, "Address: insufficient balance for call");
209         require(isContract(target), "Address: call to non-contract");
210 
211         (bool success, bytes memory returndata) = target.call{value: value}(data);
212         return verifyCallResult(success, returndata, errorMessage);
213     }
214 
215   
216     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
217         return functionStaticCall(target, data, "Address: low-level static call failed");
218     }
219 
220     
221     function functionStaticCall(
222         address target,
223         bytes memory data,
224         string memory errorMessage
225     ) internal view returns (bytes memory) {
226         require(isContract(target), "Address: static call to non-contract");
227 
228         (bool success, bytes memory returndata) = target.staticcall(data);
229         return verifyCallResult(success, returndata, errorMessage);
230     }
231 
232     
233     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
234         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
235     }
236 
237     
238     function functionDelegateCall(
239         address target,
240         bytes memory data,
241         string memory errorMessage
242     ) internal returns (bytes memory) {
243         require(isContract(target), "Address: delegate call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.delegatecall(data);
246         return verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     
250     function verifyCallResult(
251         bool success,
252         bytes memory returndata,
253         string memory errorMessage
254     ) internal pure returns (bytes memory) {
255         if (success) {
256             return returndata;
257         } else {
258             // Look for revert reason and bubble it up if present
259             if (returndata.length > 0) {
260                 // The easiest way to bubble the revert reason is using memory via assembly
261 
262                 assembly {
263                     let returndata_size := mload(returndata)
264                     revert(add(32, returndata), returndata_size)
265                 }
266             } else {
267                 revert(errorMessage);
268             }
269         }
270     }
271 }
272 
273 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
274 
275 
276 
277 pragma solidity ^0.8.0;
278 
279 
280 
281 interface IERC721Metadata is IERC721 {
282     
283     function name() external view returns (string memory);
284 
285     
286     function symbol() external view returns (string memory);
287 
288     
289     function tokenURI(uint256 tokenId) external view returns (string memory);
290 }
291 
292 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
293 
294 
295 
296 pragma solidity ^0.8.0;
297 
298 
299 interface IERC721Receiver {
300     
301     function onERC721Received(
302         address operator,
303         address from,
304         uint256 tokenId,
305         bytes calldata data
306     ) external returns (bytes4);
307 }
308 
309 
310 pragma solidity ^0.8.0;
311 
312 abstract contract Context {
313     function _msgSender() internal view virtual returns (address) {
314         return msg.sender;
315     }
316 
317     function _msgData() internal view virtual returns (bytes calldata) {
318         return msg.data;
319     }
320 }
321 
322 
323 
324 pragma solidity ^0.8.0;
325 
326 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
327     using Address for address;
328     using Strings for uint256;
329 
330     string private _name;
331 
332     string private _symbol;
333 
334     mapping(uint256 => address) private _owners;
335 
336     
337     mapping(address => uint256) private _balances;
338 
339     
340     mapping(uint256 => address) private _tokenApprovals;
341 
342     
343     mapping(address => mapping(address => bool)) private _operatorApprovals;
344 
345     
346     constructor(string memory name_, string memory symbol_) {
347         _name = name_;
348         _symbol = symbol_;
349     }
350 
351     
352     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
353         return
354             interfaceId == type(IERC721).interfaceId ||
355             interfaceId == type(IERC721Metadata).interfaceId ||
356             super.supportsInterface(interfaceId);
357     }
358 
359     
360     function balanceOf(address owner) public view virtual override returns (uint256) {
361         require(owner != address(0), "ERC721: balance query for the zero address");
362         return _balances[owner];
363     }
364 
365     
366     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
367         address owner = _owners[tokenId];
368         require(owner != address(0), "ERC721: owner query for nonexistent token");
369         return owner;
370     }
371 
372     
373     function name() public view virtual override returns (string memory) {
374         return _name;
375     }
376 
377     
378     function symbol() public view virtual override returns (string memory) {
379         return _symbol;
380     }
381 
382     
383     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
384         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
385 
386         string memory baseURI = _baseURI();
387         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
388     }
389 
390     
391     function _baseURI() internal view virtual returns (string memory) {
392         return "";
393     }
394 
395     
396     function approve(address to, uint256 tokenId) public virtual override {
397         address owner = ERC721.ownerOf(tokenId);
398         require(to != owner, "ERC721: approval to current owner");
399 
400         require(
401             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
402             "ERC721: approve caller is not owner nor approved for all"
403         );
404 
405         _approve(to, tokenId);
406     }
407 
408     
409     function getApproved(uint256 tokenId) public view virtual override returns (address) {
410         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
411 
412         return _tokenApprovals[tokenId];
413     }
414 
415    
416     function setApprovalForAll(address operator, bool approved) public virtual override {
417         require(operator != _msgSender(), "ERC721: approve to caller");
418 
419         _operatorApprovals[_msgSender()][operator] = approved;
420         emit ApprovalForAll(_msgSender(), operator, approved);
421     }
422 
423     
424     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
425         return _operatorApprovals[owner][operator];
426     }
427 
428     
429     function transferFrom(
430         address from,
431         address to,
432         uint256 tokenId
433     ) public virtual override {
434        
435         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
436 
437         _transfer(from, to, tokenId);
438     }
439 
440    
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 tokenId
445     ) public virtual override {
446         safeTransferFrom(from, to, tokenId, "");
447     }
448 
449    
450     function safeTransferFrom(
451         address from,
452         address to,
453         uint256 tokenId,
454         bytes memory _data
455     ) public virtual override {
456         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
457         _safeTransfer(from, to, tokenId, _data);
458     }
459 
460     
461     function _safeTransfer(
462         address from,
463         address to,
464         uint256 tokenId,
465         bytes memory _data
466     ) internal virtual {
467         _transfer(from, to, tokenId);
468         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
469     }
470 
471     
472     function _exists(uint256 tokenId) internal view virtual returns (bool) {
473         return _owners[tokenId] != address(0);
474     }
475 
476     
477     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
478         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
479         address owner = ERC721.ownerOf(tokenId);
480         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
481     }
482 
483     
484     function _safeMint(address to, uint256 tokenId) internal virtual {
485         _safeMint(to, tokenId, "");
486     }
487 
488    
489     function _safeMint(
490         address to,
491         uint256 tokenId,
492         bytes memory _data
493     ) internal virtual {
494         _mint(to, tokenId);
495         require(
496             _checkOnERC721Received(address(0), to, tokenId, _data),
497             "ERC721: transfer to non ERC721Receiver implementer"
498         );
499     }
500 
501     
502     function _mint(address to, uint256 tokenId) internal virtual {
503         require(to != address(0), "ERC721: mint to the zero address");
504         require(!_exists(tokenId), "ERC721: token already minted");
505 
506         _beforeTokenTransfer(address(0), to, tokenId);
507 
508         _balances[to] += 1;
509         _owners[tokenId] = to;
510 
511         emit Transfer(address(0), to, tokenId);
512     }
513 
514     
515     function _burn(uint256 tokenId) internal virtual {
516         address owner = ERC721.ownerOf(tokenId);
517 
518         _beforeTokenTransfer(owner, address(0), tokenId);
519 
520         // Clear approvals
521         _approve(address(0), tokenId);
522 
523         _balances[owner] -= 1;
524         delete _owners[tokenId];
525 
526         emit Transfer(owner, address(0), tokenId);
527     }
528 
529     
530     function _transfer(
531         address from,
532         address to,
533         uint256 tokenId
534     ) internal virtual {
535         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
536         require(to != address(0), "ERC721: transfer to the zero address");
537 
538         _beforeTokenTransfer(from, to, tokenId);
539 
540         
541         _approve(address(0), tokenId);
542 
543         _balances[from] -= 1;
544         _balances[to] += 1;
545         _owners[tokenId] = to;
546 
547         emit Transfer(from, to, tokenId);
548     }
549 
550     
551     function _approve(address to, uint256 tokenId) internal virtual {
552         _tokenApprovals[tokenId] = to;
553         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
554     }
555 
556     
557     function _checkOnERC721Received(
558         address from,
559         address to,
560         uint256 tokenId,
561         bytes memory _data
562     ) private returns (bool) {
563         if (to.isContract()) {
564             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
565                 return retval == IERC721Receiver.onERC721Received.selector;
566             } catch (bytes memory reason) {
567                 if (reason.length == 0) {
568                     revert("ERC721: transfer to non ERC721Receiver implementer");
569                 } else {
570                     assembly {
571                         revert(add(32, reason), mload(reason))
572                     }
573                 }
574             }
575         } else {
576             return true;
577         }
578     }
579 
580     
581     function _beforeTokenTransfer(
582         address from,
583         address to,
584         uint256 tokenId
585     ) internal virtual {}
586 }
587 
588 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
589 
590 
591 
592 pragma solidity ^0.8.0;
593 
594 
595 
596 
597 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
598 
599     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
600 
601     mapping(uint256 => uint256) private _ownedTokensIndex;
602 
603     uint256[] private _allTokens;
604 
605     
606     mapping(uint256 => uint256) private _allTokensIndex;
607 
608     
609     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
610         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
611     }
612 
613     
614     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
615         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
616         return _ownedTokens[owner][index];
617     }
618 
619    
620     function totalSupply() public view virtual override returns (uint256) {
621         return _allTokens.length;
622     }
623 
624     
625     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
626         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
627         return _allTokens[index];
628     }
629 
630   
631     function _beforeTokenTransfer(
632         address from,
633         address to,
634         uint256 tokenId
635     ) internal virtual override {
636         super._beforeTokenTransfer(from, to, tokenId);
637 
638         if (from == address(0)) {
639             _addTokenToAllTokensEnumeration(tokenId);
640         } else if (from != to) {
641             _removeTokenFromOwnerEnumeration(from, tokenId);
642         }
643         if (to == address(0)) {
644             _removeTokenFromAllTokensEnumeration(tokenId);
645         } else if (to != from) {
646             _addTokenToOwnerEnumeration(to, tokenId);
647         }
648     }
649 
650    
651     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
652         uint256 length = ERC721.balanceOf(to);
653         _ownedTokens[to][length] = tokenId;
654         _ownedTokensIndex[tokenId] = length;
655     }
656 
657     
658     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
659         _allTokensIndex[tokenId] = _allTokens.length;
660         _allTokens.push(tokenId);
661     }
662 
663   
664     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
665     
666 
667         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
668         uint256 tokenIndex = _ownedTokensIndex[tokenId];
669 
670         
671         if (tokenIndex != lastTokenIndex) {
672             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
673 
674             _ownedTokens[from][tokenIndex] = lastTokenId; 
675             _ownedTokensIndex[lastTokenId] = tokenIndex; 
676         }
677 
678        
679         delete _ownedTokensIndex[tokenId];
680         delete _ownedTokens[from][lastTokenIndex];
681     }
682 
683    
684     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
685       
686 
687         uint256 lastTokenIndex = _allTokens.length - 1;
688         uint256 tokenIndex = _allTokensIndex[tokenId];
689 
690         
691         uint256 lastTokenId = _allTokens[lastTokenIndex];
692 
693         _allTokens[tokenIndex] = lastTokenId; 
694         _allTokensIndex[lastTokenId] = tokenIndex; 
695 
696        
697         delete _allTokensIndex[tokenId];
698         _allTokens.pop();
699     }
700 }
701 
702 
703 // File: @openzeppelin/contracts/access/Ownable.sol
704 pragma solidity ^0.8.0;
705 
706 abstract contract Ownable is Context {
707     address private _owner;
708 
709     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
710 
711     /**
712      * @dev Initializes the contract setting the deployer as the initial owner.
713      */
714     constructor() {
715         _setOwner(_msgSender());
716     }
717 
718     /**
719      * @dev Returns the address of the current owner.
720      */
721     function owner() public view virtual returns (address) {
722         return _owner;
723     }
724 
725     /**
726      * @dev Throws if called by any account other than the owner.
727      */
728     modifier onlyOwner() {
729         require(owner() == _msgSender(), "Ownable: caller is not the owner");
730         _;
731     }
732 
733    
734     function renounceOwnership() public virtual onlyOwner {
735         _setOwner(address(0));
736     }
737 
738     
739     function transferOwnership(address newOwner) public virtual onlyOwner {
740         require(newOwner != address(0), "Ownable: new owner is the zero address");
741         _setOwner(newOwner);
742     }
743 
744     function _setOwner(address newOwner) private {
745         address oldOwner = _owner;
746         _owner = newOwner;
747         emit OwnershipTransferred(oldOwner, newOwner);
748     }
749 }
750 
751 
752 pragma solidity >=0.7.0 <0.9.0;
753 
754   contract LazyBunnyNFT is ERC721Enumerable, Ownable {
755   using Strings for uint256;
756 
757   string public baseURI;
758   string public baseExtension = ".json";
759   string public notRevealedUri;
760   uint256 public cost = 0.055 ether;
761   uint256 public maxSupply = 5555;
762   uint256 public maxMintAmount = 5;
763   uint256 public mintingSupply= 0;
764   uint256 public nftPerAddressLimit = 10;
765   bool public paused = false;
766   bool public revealed = false;
767   bool public onlyWhitelisted = true;
768   address[] public whitelistedAddresses;
769   mapping(address => uint256) public addressMintedBalance;
770 
771   constructor(
772     string memory _name,
773     string memory _symbol,
774     string memory _initBaseURI,
775     string memory _initNotRevealedUri
776   ) ERC721(_name, _symbol) {
777     setBaseURI(_initBaseURI);
778     setNotRevealedURI(_initNotRevealedUri);
779   }
780 
781   // internal
782   function _baseURI() internal view virtual override returns (string memory) {
783     return baseURI;
784   }
785 
786   // public
787   function mint(uint256 _mintAmount) public payable {
788     require(!paused, "the contract is paused");
789     uint256 supply = totalSupply();
790     require(_mintAmount > 0, "need to mint at least 1 NFT");
791     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
792     require(supply + _mintAmount <= mintingSupply, "max NFT limit exceeded");
793 
794     if (msg.sender != owner()) {
795         if(onlyWhitelisted == true) {
796             require(isWhitelisted(msg.sender), "user is not whitelisted");
797             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
798             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
799         }
800         require(msg.value >= cost * _mintAmount, "insufficient funds");
801     }
802 
803     for (uint256 i = 1; i <= _mintAmount; i++) {
804       addressMintedBalance[msg.sender]++;
805       _safeMint(msg.sender, supply + i);
806     }
807   }
808   
809   function isWhitelisted(address _user) public view returns (bool) {
810     for (uint i = 0; i < whitelistedAddresses.length; i++) {
811       if (whitelistedAddresses[i] == _user) {
812           return true;
813       }
814     }
815     return false;
816   }
817 
818   function walletOfOwner(address _owner)
819     public
820     view
821     returns (uint256[] memory)
822   {
823     uint256 ownerTokenCount = balanceOf(_owner);
824     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
825     for (uint256 i; i < ownerTokenCount; i++) {
826       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
827     }
828     return tokenIds;
829   }
830 
831   function tokenURI(uint256 tokenId)
832     public
833     view
834     virtual
835     override
836     returns (string memory)
837   {
838     require(
839       _exists(tokenId),
840       "ERC721Metadata: URI query for nonexistent token"
841     );
842     
843     if(revealed == false) {
844         return notRevealedUri;
845     }
846 
847     string memory currentBaseURI = _baseURI();
848     return bytes(currentBaseURI).length > 0
849         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
850         : "";
851   }
852 
853   //only owner
854   function reveal() public onlyOwner() {
855       revealed = true;
856   }
857   function update_minting_supply(uint256 number) public onlyOwner(){
858       mintingSupply= number;
859   }
860   function setNftPerAddressLimit(uint256 _limit) public onlyOwner() {
861     nftPerAddressLimit = _limit;
862   }
863   
864   function setCost(uint256 _newCost) public onlyOwner() {
865     cost = _newCost;
866   }
867 
868   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
869     maxMintAmount = _newmaxMintAmount;
870   }
871 
872   function setBaseURI(string memory _newBaseURI) public onlyOwner {
873     baseURI = _newBaseURI;
874   }
875 
876   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
877     baseExtension = _newBaseExtension;
878   }
879   
880   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
881     notRevealedUri = _notRevealedURI;
882   }
883 
884   function pause(bool _state) public onlyOwner {
885     paused = _state;
886   }
887   
888   function setOnlyWhitelisted(bool _state) public onlyOwner {
889     onlyWhitelisted = _state;
890   }
891   
892   function whitelistUsers(address[] calldata _users) public onlyOwner {
893     delete whitelistedAddresses;
894     whitelistedAddresses = _users;
895   }
896  
897   function withdraw_eth(uint256 amount) external onlyOwner {
898       payable(owner()).transfer(amount);
899   }
900 }