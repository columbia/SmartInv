1 // SPDX-License-Identifier: MIT
2 
3 
4 //  https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
5 pragma solidity ^0.8.0;
6 
7 interface IERC165 {
8    
9     function supportsInterface(bytes4 interfaceId) external view returns (bool);
10 }
11 
12 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
13 pragma solidity ^0.8.0;
14 
15 interface IERC721 is IERC165 {
16   
17     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
18 
19   
20     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
21 
22  
23     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
24 
25     
26     function balanceOf(address owner) external view returns (uint256 balance);
27 
28  
29     function ownerOf(uint256 tokenId) external view returns (address owner);
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
50     function setApprovalForAll(address operator, bool _approved) external;
51 
52    
53     function isApprovedForAll(address owner, address operator) external view returns (bool);
54 
55     function safeTransferFrom(
56         address from,
57         address to,
58         uint256 tokenId,
59         bytes calldata data
60     ) external;
61 }
62 
63 
64 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Enumerable.sol
65 pragma solidity ^0.8.0;
66 
67 interface IERC721Enumerable is IERC721 {
68   
69     function totalSupply() external view returns (uint256);
70 
71     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
72 
73     function tokenByIndex(uint256 index) external view returns (uint256);
74 }
75 
76 
77 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
78 pragma solidity ^0.8.0;
79 
80 abstract contract ERC165 is IERC165 {
81  
82     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
83         return interfaceId == type(IERC165).interfaceId;
84     }
85 }
86 
87 
88 pragma solidity ^0.8.0;
89 // conerts to ASCII
90 library Strings {
91     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
92 
93 
94     function toString(uint256 value) internal pure returns (string memory) {
95         // Inspired by OraclizeAPI's implementation - MIT licence
96         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
97 
98         if (value == 0) {
99             return "0";
100         }
101         uint256 temp = value;
102         uint256 digits;
103         while (temp != 0) {
104             digits++;
105             temp /= 10;
106         }
107         bytes memory buffer = new bytes(digits);
108         while (value != 0) {
109             digits -= 1;
110             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
111             value /= 10;
112         }
113         return string(buffer);
114     }
115 
116   
117     function toHexString(uint256 value) internal pure returns (string memory) {
118         if (value == 0) {
119             return "0x00";
120         }
121         uint256 temp = value;
122         uint256 length = 0;
123         while (temp != 0) {
124             length++;
125             temp >>= 8;
126         }
127         return toHexString(value, length);
128     }
129 
130    
131     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
132         bytes memory buffer = new bytes(2 * length + 2);
133         buffer[0] = "0";
134         buffer[1] = "x";
135         for (uint256 i = 2 * length + 1; i > 1; --i) {
136             buffer[i] = _HEX_SYMBOLS[value & 0xf];
137             value >>= 4;
138         }
139         require(value == 0, "Strings: hex length insufficient");
140         return string(buffer);
141     }
142 }
143 
144 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
145 
146 pragma solidity ^0.8.0;
147 //address functions
148 library Address {
149   
150     function isContract(address account) internal view returns (bool) {
151 
152         uint256 size;
153         assembly {
154             size := extcodesize(account)
155         }
156         return size > 0;
157     }
158 
159  
160     function sendValue(address payable recipient, uint256 amount) internal {
161         require(address(this).balance >= amount, "Address: insufficient balance");
162 
163         (bool success, ) = recipient.call{value: amount}("");
164         require(success, "Address: unable to send value, recipient may have reverted");
165     }
166 
167 
168     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172   
173     function functionCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal returns (bytes memory) {
178         return functionCallWithValue(target, data, 0, errorMessage);
179     }
180 
181   
182     function functionCallWithValue(
183         address target,
184         bytes memory data,
185         uint256 value
186     ) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
188     }
189 
190    
191     function functionCallWithValue(
192         address target,
193         bytes memory data,
194         uint256 value,
195         string memory errorMessage
196     ) internal returns (bytes memory) {
197         require(address(this).balance >= value, "Address: insufficient balance for call");
198         require(isContract(target), "Address: call to non-contract");
199 
200         (bool success, bytes memory returndata) = target.call{value: value}(data);
201         return verifyCallResult(success, returndata, errorMessage);
202     }
203 
204    
205     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
206         return functionStaticCall(target, data, "Address: low-level static call failed");
207     }
208 
209    
210     function functionStaticCall(
211         address target,
212         bytes memory data,
213         string memory errorMessage
214     ) internal view returns (bytes memory) {
215         require(isContract(target), "Address: static call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.staticcall(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221   
222     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
223         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
224     }
225 
226 
227     function functionDelegateCall(
228         address target,
229         bytes memory data,
230         string memory errorMessage
231     ) internal returns (bytes memory) {
232         require(isContract(target), "Address: delegate call to non-contract");
233 
234         (bool success, bytes memory returndata) = target.delegatecall(data);
235         return verifyCallResult(success, returndata, errorMessage);
236     }
237 
238   
239     function verifyCallResult(
240         bool success,
241         bytes memory returndata,
242         string memory errorMessage
243     ) internal pure returns (bytes memory) {
244         if (success) {
245             return returndata;
246         } else {
247             
248             if (returndata.length > 0) {
249                 
250 
251                 assembly {
252                     let returndata_size := mload(returndata)
253                     revert(add(32, returndata), returndata_size)
254                 }
255             } else {
256                 revert(errorMessage);
257             }
258         }
259     }
260 }
261 
262 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
263 
264 pragma solidity ^0.8.0;
265 
266 
267 //ERC-721 Token Standard
268  
269 interface IERC721Metadata is IERC721 {
270    
271     function name() external view returns (string memory);
272 
273    
274     function symbol() external view returns (string memory);
275 
276   
277     function tokenURI(uint256 tokenId) external view returns (string memory);
278 }
279 
280 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
281 
282 pragma solidity ^0.8.0;
283 
284 
285 
286 interface IERC721Receiver {
287 
288     function onERC721Received(
289         address operator,
290         address from,
291         uint256 tokenId,
292         bytes calldata data
293     ) external returns (bytes4);
294 }
295 
296 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
297 pragma solidity ^0.8.0;
298 
299 abstract contract Context {
300     function _msgSender() internal view virtual returns (address) {
301         return msg.sender;
302     }
303 
304     function _msgData() internal view virtual returns (bytes calldata) {
305         return msg.data;
306     }
307 }
308 
309 
310 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
311 pragma solidity ^0.8.0;
312 
313 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
314     using Address for address;
315     using Strings for uint256;
316 
317     string private _name;
318 
319     string private _symbol;
320 
321     mapping(uint256 => address) private _owners;
322 
323     mapping(address => uint256) private _balances;
324 
325     mapping(uint256 => address) private _tokenApprovals;
326 
327     mapping(address => mapping(address => bool)) private _operatorApprovals;
328 //coolection constructor
329     constructor(string memory name_, string memory symbol_) {
330         _name = name_;
331         _symbol = symbol_;
332     }
333 
334    
335     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
336         return
337             interfaceId == type(IERC721).interfaceId ||
338             interfaceId == type(IERC721Metadata).interfaceId ||
339             super.supportsInterface(interfaceId);
340     }
341 
342 
343     function balanceOf(address owner) public view virtual override returns (uint256) {
344         require(owner != address(0), "ERC721: balance query for the zero address");
345         return _balances[owner];
346     }
347 
348 
349     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
350         address owner = _owners[tokenId];
351         require(owner != address(0), "ERC721: owner query for nonexistent token");
352         return owner;
353     }
354 
355    
356     function name() public view virtual override returns (string memory) {
357         return _name;
358     }
359 
360  
361     function symbol() public view virtual override returns (string memory) {
362         return _symbol;
363     }
364 
365   
366     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
367         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
368 
369         string memory baseURI = _baseURI();
370         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
371     }
372 
373  
374     function _baseURI() internal view virtual returns (string memory) {
375         return "";
376     }
377 
378     function approve(address to, uint256 tokenId) public virtual override {
379         address owner = ERC721.ownerOf(tokenId);
380         require(to != owner, "ERC721: approval to current owner");
381 
382         require(
383             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
384             "ERC721: approve caller is not owner nor approved for all"
385         );
386 
387         _approve(to, tokenId);
388     }
389 
390    
391     function getApproved(uint256 tokenId) public view virtual override returns (address) {
392         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
393 
394         return _tokenApprovals[tokenId];
395     }
396 
397    
398     function setApprovalForAll(address operator, bool approved) public virtual override {
399         require(operator != _msgSender(), "ERC721: approve to caller");
400 
401         _operatorApprovals[_msgSender()][operator] = approved;
402         emit ApprovalForAll(_msgSender(), operator, approved);
403     }
404 
405   
406     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
407         return _operatorApprovals[owner][operator];
408     }
409 
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) public virtual override {
415         
416         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
417 
418         _transfer(from, to, tokenId);
419     }
420 
421  
422     function safeTransferFrom(
423         address from,
424         address to,
425         uint256 tokenId
426     ) public virtual override {
427         safeTransferFrom(from, to, tokenId, "");
428     }
429 
430   
431     function safeTransferFrom(
432         address from,
433         address to,
434         uint256 tokenId,
435         bytes memory _data
436     ) public virtual override {
437         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
438         _safeTransfer(from, to, tokenId, _data);
439     }
440 
441    
442     function _safeTransfer(
443         address from,
444         address to,
445         uint256 tokenId,
446         bytes memory _data
447     ) internal virtual {
448         _transfer(from, to, tokenId);
449         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
450     }
451 
452 
453     function _exists(uint256 tokenId) internal view virtual returns (bool) {
454         return _owners[tokenId] != address(0);
455     }
456 
457   
458     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
459         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
460         address owner = ERC721.ownerOf(tokenId);
461         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
462     }
463 
464    
465     function _safeMint(address to, uint256 tokenId) internal virtual {
466         _safeMint(to, tokenId, "");
467     }
468 
469   
470     function _safeMint(
471         address to,
472         uint256 tokenId,
473         bytes memory _data
474     ) internal virtual {
475         _mint(to, tokenId);
476         require(
477             _checkOnERC721Received(address(0), to, tokenId, _data),
478             "ERC721: transfer to non ERC721Receiver implementer"
479         );
480     }
481 
482  
483     function _mint(address to, uint256 tokenId) internal virtual {
484         require(to != address(0), "ERC721: mint to the zero address");
485         require(!_exists(tokenId), "ERC721: token already minted");
486 
487         _beforeTokenTransfer(address(0), to, tokenId);
488 
489         _balances[to] += 1;
490         _owners[tokenId] = to;
491 
492         emit Transfer(address(0), to, tokenId);
493     }
494 
495    
496     function _burn(uint256 tokenId) internal virtual {
497         address owner = ERC721.ownerOf(tokenId);
498 
499         _beforeTokenTransfer(owner, address(0), tokenId);
500 
501 
502         _approve(address(0), tokenId);
503 
504         _balances[owner] -= 1;
505         delete _owners[tokenId];
506 
507         emit Transfer(owner, address(0), tokenId);
508     }
509 
510    
511     function _transfer(
512         address from,
513         address to,
514         uint256 tokenId
515     ) internal virtual {
516         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
517         require(to != address(0), "ERC721: transfer to the zero address");
518 
519         _beforeTokenTransfer(from, to, tokenId);
520 
521     
522         _approve(address(0), tokenId);
523 
524         _balances[from] -= 1;
525         _balances[to] += 1;
526         _owners[tokenId] = to;
527 
528         emit Transfer(from, to, tokenId);
529     }
530 
531   
532     function _approve(address to, uint256 tokenId) internal virtual {
533         _tokenApprovals[tokenId] = to;
534         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
535     }
536 
537     
538     function _checkOnERC721Received(
539         address from,
540         address to,
541         uint256 tokenId,
542         bytes memory _data
543     ) private returns (bool) {
544         if (to.isContract()) {
545             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
546                 return retval == IERC721Receiver.onERC721Received.selector;
547             } catch (bytes memory reason) {
548                 if (reason.length == 0) {
549                     revert("ERC721: transfer to non ERC721Receiver implementer");
550                 } else {
551                     assembly {
552                         revert(add(32, reason), mload(reason))
553                     }
554                 }
555             }
556         } else {
557             return true;
558         }
559     }
560 
561     function _beforeTokenTransfer(
562         address from,
563         address to,
564         uint256 tokenId
565     ) internal virtual {}
566 }
567 
568 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol
569 
570 
571 pragma solidity ^0.8.0;
572 
573 
574 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
575   
576     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
577 
578     mapping(uint256 => uint256) private _ownedTokensIndex;
579 
580     uint256[] private _allTokens;
581 
582     mapping(uint256 => uint256) private _allTokensIndex;
583 
584     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
585         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
586     }
587 
588     
589     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
590         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
591         return _ownedTokens[owner][index];
592     }
593 
594  
595     function totalSupply() public view virtual override returns (uint256) {
596         return _allTokens.length;
597     }
598 
599     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
600         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
601         return _allTokens[index];
602     }
603 
604   
605     function _beforeTokenTransfer(
606         address from,
607         address to,
608         uint256 tokenId
609     ) internal virtual override {
610         super._beforeTokenTransfer(from, to, tokenId);
611 
612         if (from == address(0)) {
613             _addTokenToAllTokensEnumeration(tokenId);
614         } else if (from != to) {
615             _removeTokenFromOwnerEnumeration(from, tokenId);
616         }
617         if (to == address(0)) {
618             _removeTokenFromAllTokensEnumeration(tokenId);
619         } else if (to != from) {
620             _addTokenToOwnerEnumeration(to, tokenId);
621         }
622     }
623 
624     
625     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
626         uint256 length = ERC721.balanceOf(to);
627         _ownedTokens[to][length] = tokenId;
628         _ownedTokensIndex[tokenId] = length;
629     }
630 
631   
632     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
633         _allTokensIndex[tokenId] = _allTokens.length;
634         _allTokens.push(tokenId);
635     }
636 
637    
638     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
639  
640 
641         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
642         uint256 tokenIndex = _ownedTokensIndex[tokenId];
643 
644       
645         if (tokenIndex != lastTokenIndex) {
646             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
647 
648             _ownedTokens[from][tokenIndex] = lastTokenId; 
649             _ownedTokensIndex[lastTokenId] = tokenIndex; 
650         }
651         
652         delete _ownedTokensIndex[tokenId];
653         delete _ownedTokens[from][lastTokenIndex];
654     }
655 
656   
657     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
658 
659         uint256 lastTokenIndex = _allTokens.length - 1;
660         uint256 tokenIndex = _allTokensIndex[tokenId];
661 
662      
663         uint256 lastTokenId = _allTokens[lastTokenIndex];
664 
665         _allTokens[tokenIndex] = lastTokenId; 
666         _allTokensIndex[lastTokenId] = tokenIndex; 
667 
668 
669         delete _allTokensIndex[tokenId];
670         _allTokens.pop();
671     }
672 }
673 // contract inspired by hashlips git hub repositoroy
674 // https://github.com/HashLips
675 
676 
677 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
678 
679 pragma solidity ^0.8.0;
680 // owner only commands
681 abstract contract Ownable is Context {
682     address private _owner;
683 
684     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
685 
686  //owner constructor
687     constructor() {
688         _setOwner(_msgSender());
689     }
690 
691   
692     function owner() public view virtual returns (address) {
693         return _owner;
694     }
695 
696    
697     modifier onlyOwner() {
698         require(owner() == _msgSender(), "Ownable: caller is not the owner");
699         _;
700     }
701 
702 
703     function renounceOwnership() public virtual onlyOwner {
704         _setOwner(address(0));
705     }
706 
707  
708     function transferOwnership(address newOwner) public virtual onlyOwner {
709         require(newOwner != address(0), "Ownable: new owner is the zero address");
710         _setOwner(newOwner);
711     }
712 
713     function _setOwner(address newOwner) private {
714         address oldOwner = _owner;
715         _owner = newOwner;
716         emit OwnershipTransferred(oldOwner, newOwner);
717     }
718 }
719 /*
720                    _____     _______   ___    ___  _______   ________    _______
721         	      /  __  \  |   _   |  \  \  /  / |   _   | |___  ___|  /       \
722                  |  /  \_|  |  |_|  |   \  \/  /  |  |_|  |    |  |    |   ___   |
723                  |  |   __  |   __  \    \    /   |  _____|    |  |    |  |___|  |
724                  |  \__/  | |  |  |  |    |  |    |  |         |  |    |         |
725                   \_____ /  |__|  |__|    |__|    |__|         |__|     \_______/
726 	
727 	 _____     _______   _____  ___  ____   ___   ________    _______   ________   __      __________
728 	/  __  \  |   _   | |     \|  | |     \|  |  |__    __|  |       | |   __   | |  |     |  _______|
729    |  /  \_|  |  |_|  | |  |\  |  | |  |\  |  |     |  |     |  |_|  | |  |_|   | |  |     |  |___
730    |  |   __  |   __  | |  | \    | |  | \    |     |  |     |      <  |   __   | |  |     |       \
731    |  \__/  | |  |  | | |  |  \   | |  |  \   |    _|  |__   |  |_|  | |  |  |  | |  |____  \____  |
732     \_____ /  |__|  |_| |__|   \__| |__|   \__|   |_______|  |_______| |__|  |__| |_______|     /  /
733 	 __________________________________________________________________________________________/  /
734 	 \___________________________________________________________________________________________/
735 	
736     */
737 pragma solidity >=0.7.0 <0.9.0;
738 
739 contract CryptoCannibalsV2 is ERC721Enumerable, Ownable {
740   using Strings for uint256;
741 
742   string baseURI;
743   string public baseExtension = ".json";
744   uint256 public cost = 0.07 ether;
745   uint256 public maxSupply = 3700;
746   uint256 public maxMintAmount = 10;
747   bool public paused = true;
748   bool public revealed = false;
749   string public notRevealedUri;
750   //cap stops
751   bool public cap = false; 
752   bool public cap2 =false;
753   //claim list toggle
754   bool public claimListActive=false;
755   //cap amounts
756   uint256 public capCount=3001;
757   uint256 public capCount2=3501;
758     //payable adresses on withdraw
759     address private addressOne = 0xf3447A408cea54D7790449f848439657eAa52258;
760     address private addressTwo = 0x9FC1CF0F742bD165910ba8F7C1c95742E2723434;
761     //claimable mapping
762     mapping(address => uint256) private _claimList;
763     uint256 public addressCount=0;
764 
765   constructor(
766     string memory _name,
767     string memory _symbol,
768     string memory _initBaseURI,
769     string memory _initNotRevealedUri
770   ) ERC721(_name, _symbol) {
771     setBaseURI(_initBaseURI);
772     setNotRevealedURI(_initNotRevealedUri);
773   }
774 
775   function _baseURI() internal view virtual override returns (string memory) {
776     return baseURI;
777   }
778 
779   // public minting fuction
780   function mint(uint256 _mintAmount) public payable {
781 
782     uint256 supply = totalSupply();
783 
784         //added 3k cap to cut off for claimable time period
785     if(cap==false && (supply+_mintAmount) >= capCount){
786         paused=true;
787         cap=true;
788     }
789         //added 3.5k cap to cut off for alan
790     if(cap2==false && (supply+ _mintAmount) >= capCount2){
791         paused=true;
792         cap2=true;
793     }
794   
795     require(!paused, "Contract is paused");
796     require(_mintAmount > 0, "mint amount cant be 0");
797     require(_mintAmount <= maxMintAmount, "Cant mint over the max mint amount");
798     require(supply + _mintAmount <= maxSupply, "Mint amount is too high there may not be enough left to mint that many");
799 
800     if (msg.sender != owner()) {
801       require(msg.value >= cost * _mintAmount);
802     }
803   
804 
805     for (uint256 i = 1; i <= _mintAmount; i++) {
806       _safeMint(msg.sender, supply + i);
807     }
808   }
809 //claimable list mint funtion
810 
811 function mintClaimList(uint256 numberOfTokens) external payable {
812     uint256 currentSupply = totalSupply();
813 
814       //added 3k cap to cut off for claimable time period
815     if(cap==false && (currentSupply+numberOfTokens) >= capCount){
816         paused=true;
817         cap=true;
818     }
819         //added 3.5k cap to cut off for alan
820     if(cap2==false && (currentSupply+ numberOfTokens) >= capCount2){
821         paused=true;
822         cap2=true;
823     }
824 
825     require(claimListActive, "Claim list is not active");
826     require(numberOfTokens <= _claimList[msg.sender], "Exceeded max available to purchase");
827     require(currentSupply + numberOfTokens <= maxSupply, "Purchase would exceed max supply");
828     // cost taken down to 0 for claims
829     //require(cost * numberOfTokens <= msg.value, "Eth value sent is not correct");
830 
831     _claimList[msg.sender] -= numberOfTokens;
832     for (uint256 i = 1; i <= (numberOfTokens); i++) {
833         _safeMint(msg.sender, currentSupply + i);
834     }
835  }
836 
837   function walletOfOwner(address _owner)
838     public
839     view
840      returns (uint256[] memory)
841   {
842     uint256 ownerTokenCount = balanceOf(_owner);
843     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
844     for (uint256 i; i < ownerTokenCount; i++) {
845       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
846     }
847     return tokenIds;
848   }
849 
850   function tokenURI(uint256 tokenId)
851     public
852     view
853     virtual
854     override
855     returns (string memory)
856   {
857     require(
858       _exists(tokenId),
859       "ERC721Metadata: URI query for nonexistent token"
860     );
861     
862     if(revealed == false) {
863         return notRevealedUri;
864     }
865 
866     string memory currentBaseURI = _baseURI();
867     return bytes(currentBaseURI).length > 0
868         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
869         : "";
870   }
871 
872   //actions for the owner to interact with contract
873   function reveal() public onlyOwner() {
874       revealed = true;
875   }
876   //adjust claimable cut off point
877   function setClaimableCap(uint256 _newCap) public onlyOwner() {
878     capCount=_newCap;
879   }
880 
881   function setClaimableCap2(uint256 _newCap) public onlyOwner() {
882     capCount2=_newCap;
883   }
884 
885   function setCapBool(bool _newCap) public onlyOwner() {
886     cap=_newCap;
887   }
888 
889  function setCap2Bool(bool _newCap) public onlyOwner() {
890     cap2=_newCap;
891   }
892 
893   function setCost(uint256 _newCost) public onlyOwner() {
894     cost = _newCost;
895   }
896 
897   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
898     maxMintAmount = _newmaxMintAmount;
899   }
900   
901   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
902     notRevealedUri = _notRevealedURI;
903   }
904 
905   function setBaseURI(string memory _newBaseURI) public onlyOwner {
906     baseURI = _newBaseURI;
907   }
908 
909   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
910     baseExtension = _newBaseExtension;
911   }
912 
913   function pause(bool _state) public onlyOwner {
914     paused = _state;
915   }
916 
917   function setClaimList(address addressInput, uint256 numAllowedToMint) external onlyOwner {
918        
919             _claimList[addressInput] = numAllowedToMint;
920             addressCount+=1;
921     }
922 //set claim list to true or false for active
923     function setClaimListActive(bool _claimListActive) external onlyOwner {
924         claimListActive = _claimListActive;
925     }
926 //reset addressCount (claim list count)
927     function addressCountReset(uint256 _newCount) public onlyOwner {
928         addressCount=_newCount;
929     }
930 //set a full address list 
931 function setFullClaimList(address[] calldata addresses, uint256 numAllowedToMint) external onlyOwner {
932     for (uint256 i = 0; i < addresses.length; i++) {
933         _claimList[addresses[i]] = numAllowedToMint;
934         addressCount+=1;
935     }
936 }
937 
938 
939  //primary withdraw withdraw 10% to address 1 90% to address 2
940   function primaryWithdraw() public payable onlyOwner {
941    uint256 CurrentBalance = address(this).balance;
942         payable(addressOne).transfer((CurrentBalance * 10) / 100);
943         payable(addressTwo).transfer((CurrentBalance * 90) / 100);
944 
945   }
946 //backup witdraw to retrieve all funds to deployment account 
947   function backupWithdraw() public payable onlyOwner {
948  
949     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
950     require(success);
951   }
952 }