1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.0;
5 
6 interface IERC165 {
7 
8     function supportsInterface(bytes4 interfaceId) external view returns (bool);
9 }
10 
11 
12 pragma solidity ^0.8.0;
13 
14 interface IERC721 is IERC165 {
15 
16     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
17 
18     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
19 
20     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
21 
22     function balanceOf(address owner) external view returns (uint256 balance);
23 
24     function ownerOf(uint256 tokenId) external view returns (address owner);
25 
26     function safeTransferFrom(
27         address from,
28         address to,
29         uint256 tokenId
30     ) external;
31 
32 
33     function transferFrom(
34         address from,
35         address to,
36         uint256 tokenId
37     ) external;
38 
39  
40     function approve(address to, uint256 tokenId) external;
41 
42 
43     function getApproved(uint256 tokenId) external view returns (address operator);
44 
45 
46     function setApprovalForAll(address operator, bool _approved) external;
47 
48     function isApprovedForAll(address owner, address operator) external view returns (bool);
49 
50 
51     function safeTransferFrom(
52         address from,
53         address to,
54         uint256 tokenId,
55         bytes calldata data
56     ) external;
57 }
58 
59 
60 
61 pragma solidity ^0.8.0;
62 
63 interface IERC721Enumerable is IERC721 {
64 
65     function totalSupply() external view returns (uint256);
66 
67     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
68 
69     function tokenByIndex(uint256 index) external view returns (uint256);
70 }
71 
72 
73 
74 pragma solidity ^0.8.0;
75 
76 abstract contract ERC165 is IERC165 {
77 
78     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
79         return interfaceId == type(IERC165).interfaceId;
80     }
81 }
82 
83 
84 pragma solidity ^0.8.0;
85 
86 
87 library Strings {
88     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
89 
90     function toString(uint256 value) internal pure returns (string memory) {
91  
92         if (value == 0) {
93             return "0";
94         }
95         uint256 temp = value;
96         uint256 digits;
97         while (temp != 0) {
98             digits++;
99             temp /= 10;
100         }
101         bytes memory buffer = new bytes(digits);
102         while (value != 0) {
103             digits -= 1;
104             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
105             value /= 10;
106         }
107         return string(buffer);
108     }
109 
110 
111     function toHexString(uint256 value) internal pure returns (string memory) {
112         if (value == 0) {
113             return "0x00";
114         }
115         uint256 temp = value;
116         uint256 length = 0;
117         while (temp != 0) {
118             length++;
119             temp >>= 8;
120         }
121         return toHexString(value, length);
122     }
123 
124 
125     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
126         bytes memory buffer = new bytes(2 * length + 2);
127         buffer[0] = "0";
128         buffer[1] = "x";
129         for (uint256 i = 2 * length + 1; i > 1; --i) {
130             buffer[i] = _HEX_SYMBOLS[value & 0xf];
131             value >>= 4;
132         }
133         require(value == 0, "Strings: hex length insufficient");
134         return string(buffer);
135     }
136 }
137 
138 
139 pragma solidity ^0.8.0;
140 
141 
142 library Address {
143 
144     function isContract(address account) internal view returns (bool) {
145 
146         uint256 size;
147         assembly {
148             size := extcodesize(account)
149         }
150         return size > 0;
151     }
152 
153 
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         (bool success, ) = recipient.call{value: amount}("");
158         require(success, "Address: unable to send value, recipient may have reverted");
159     }
160 
161 
162     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
163         return functionCall(target, data, "Address: low-level call failed");
164     }
165 
166 
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     function functionCallWithValue(
176         address target,
177         bytes memory data,
178         uint256 value
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
181     }
182 
183 
184     function functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 value,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         require(address(this).balance >= value, "Address: insufficient balance for call");
191         require(isContract(target), "Address: call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.call{value: value}(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197 
198     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
199         return functionStaticCall(target, data, "Address: low-level static call failed");
200     }
201 
202 
203     function functionStaticCall(
204         address target,
205         bytes memory data,
206         string memory errorMessage
207     ) internal view returns (bytes memory) {
208         require(isContract(target), "Address: static call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.staticcall(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214 
215     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
216         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
217     }
218 
219 
220     function functionDelegateCall(
221         address target,
222         bytes memory data,
223         string memory errorMessage
224     ) internal returns (bytes memory) {
225         require(isContract(target), "Address: delegate call to non-contract");
226 
227         (bool success, bytes memory returndata) = target.delegatecall(data);
228         return verifyCallResult(success, returndata, errorMessage);
229     }
230 
231 
232     function verifyCallResult(
233         bool success,
234         bytes memory returndata,
235         string memory errorMessage
236     ) internal pure returns (bytes memory) {
237         if (success) {
238             return returndata;
239         } else {
240             
241             if (returndata.length > 0) {
242                 
243 
244                 assembly {
245                     let returndata_size := mload(returndata)
246                     revert(add(32, returndata), returndata_size)
247                 }
248             } else {
249                 revert(errorMessage);
250             }
251         }
252     }
253 }
254 
255 
256 
257 pragma solidity ^0.8.0;
258 
259 
260 
261 interface IERC721Metadata is IERC721 {
262    
263     function name() external view returns (string memory);
264 
265    
266     function symbol() external view returns (string memory);
267 
268    
269     function tokenURI(uint256 tokenId) external view returns (string memory);
270 }
271 
272 
273 pragma solidity ^0.8.0;
274 
275 
276 interface IERC721Receiver {
277 
278     function onERC721Received(
279         address operator,
280         address from,
281         uint256 tokenId,
282         bytes calldata data
283     ) external returns (bytes4);
284 }
285 
286 
287 pragma solidity ^0.8.0;
288 
289 abstract contract Context {
290     function _msgSender() internal view virtual returns (address) {
291         return msg.sender;
292     }
293 
294     function _msgData() internal view virtual returns (bytes calldata) {
295         return msg.data;
296     }
297 }
298 
299 
300 
301 pragma solidity ^0.8.0;
302 
303 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
304     using Address for address;
305     using Strings for uint256;
306 
307     
308     string private _name;
309 
310     
311     string private _symbol;
312 
313    
314     mapping(uint256 => address) private _owners;
315 
316     
317     mapping(address => uint256) private _balances;
318 
319     
320     mapping(uint256 => address) private _tokenApprovals;
321 
322     
323     mapping(address => mapping(address => bool)) private _operatorApprovals;
324 
325   
326     constructor(string memory name_, string memory symbol_) {
327         _name = name_;
328         _symbol = symbol_;
329     }
330 
331    
332     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
333         return
334             interfaceId == type(IERC721).interfaceId ||
335             interfaceId == type(IERC721Metadata).interfaceId ||
336             super.supportsInterface(interfaceId);
337     }
338 
339 
340     function balanceOf(address owner) public view virtual override returns (uint256) {
341         require(owner != address(0), "ERC721: balance query for the zero address");
342         return _balances[owner];
343     }
344 
345 
346     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
347         address owner = _owners[tokenId];
348         require(owner != address(0), "ERC721: owner query for nonexistent token");
349         return owner;
350     }
351 
352  
353     function name() public view virtual override returns (string memory) {
354         return _name;
355     }
356 
357   
358     function symbol() public view virtual override returns (string memory) {
359         return _symbol;
360     }
361 
362 
363     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
364         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
365 
366         string memory baseURI = _baseURI();
367         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
368     }
369 
370 
371     function _baseURI() internal view virtual returns (string memory) {
372         return "";
373     }
374 
375 
376     function approve(address to, uint256 tokenId) public virtual override {
377         address owner = ERC721.ownerOf(tokenId);
378         require(to != owner, "ERC721: approval to current owner");
379 
380         require(
381             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
382             "ERC721: approve caller is not owner nor approved for all"
383         );
384 
385         _approve(to, tokenId);
386     }
387 
388     function getApproved(uint256 tokenId) public view virtual override returns (address) {
389         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
390 
391         return _tokenApprovals[tokenId];
392     }
393 
394 
395     function setApprovalForAll(address operator, bool approved) public virtual override {
396         require(operator != _msgSender(), "ERC721: approve to caller");
397 
398         _operatorApprovals[_msgSender()][operator] = approved;
399         emit ApprovalForAll(_msgSender(), operator, approved);
400     }
401 
402  
403     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
404         return _operatorApprovals[owner][operator];
405     }
406 
407 
408     function transferFrom(
409         address from,
410         address to,
411         uint256 tokenId
412     ) public virtual override {
413         //solhint-disable-next-line max-line-length
414         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
415 
416         _transfer(from, to, tokenId);
417     }
418 
419 
420     function safeTransferFrom(
421         address from,
422         address to,
423         uint256 tokenId
424     ) public virtual override {
425         safeTransferFrom(from, to, tokenId, "");
426     }
427 
428   
429     function safeTransferFrom(
430         address from,
431         address to,
432         uint256 tokenId,
433         bytes memory _data
434     ) public virtual override {
435         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
436         _safeTransfer(from, to, tokenId, _data);
437     }
438 
439    
440     function _safeTransfer(
441         address from,
442         address to,
443         uint256 tokenId,
444         bytes memory _data
445     ) internal virtual {
446         _transfer(from, to, tokenId);
447         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
448     }
449 
450 
451     function _exists(uint256 tokenId) internal view virtual returns (bool) {
452         return _owners[tokenId] != address(0);
453     }
454 
455 
456     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
457         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
458         address owner = ERC721.ownerOf(tokenId);
459         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
460     }
461 
462 
463     function _safeMint(address to, uint256 tokenId) internal virtual {
464         _safeMint(to, tokenId, "");
465     }
466 
467  
468     function _safeMint(
469         address to,
470         uint256 tokenId,
471         bytes memory _data
472     ) internal virtual {
473         _mint(to, tokenId);
474         require(
475             _checkOnERC721Received(address(0), to, tokenId, _data),
476             "ERC721: transfer to non ERC721Receiver implementer"
477         );
478     }
479 
480 
481     function _mint(address to, uint256 tokenId) internal virtual {
482         require(to != address(0), "ERC721: mint to the zero address");
483         require(!_exists(tokenId), "ERC721: token already minted");
484 
485         _beforeTokenTransfer(address(0), to, tokenId);
486 
487         _balances[to] += 1;
488         _owners[tokenId] = to;
489 
490         emit Transfer(address(0), to, tokenId);
491     }
492 
493 
494     function _burn(uint256 tokenId) internal virtual {
495         address owner = ERC721.ownerOf(tokenId);
496 
497         _beforeTokenTransfer(owner, address(0), tokenId);
498 
499         // Clear approvals
500         _approve(address(0), tokenId);
501 
502         _balances[owner] -= 1;
503         delete _owners[tokenId];
504 
505         emit Transfer(owner, address(0), tokenId);
506     }
507 
508  
509     function _transfer(
510         address from,
511         address to,
512         uint256 tokenId
513     ) internal virtual {
514         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
515         require(to != address(0), "ERC721: transfer to the zero address");
516 
517         _beforeTokenTransfer(from, to, tokenId);
518 
519         
520         _approve(address(0), tokenId);
521 
522         _balances[from] -= 1;
523         _balances[to] += 1;
524         _owners[tokenId] = to;
525 
526         emit Transfer(from, to, tokenId);
527     }
528 
529 
530     function _approve(address to, uint256 tokenId) internal virtual {
531         _tokenApprovals[tokenId] = to;
532         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
533     }
534 
535 
536     function _checkOnERC721Received(
537         address from,
538         address to,
539         uint256 tokenId,
540         bytes memory _data
541     ) private returns (bool) {
542         if (to.isContract()) {
543             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
544                 return retval == IERC721Receiver.onERC721Received.selector;
545             } catch (bytes memory reason) {
546                 if (reason.length == 0) {
547                     revert("ERC721: transfer to non ERC721Receiver implementer");
548                 } else {
549                     assembly {
550                         revert(add(32, reason), mload(reason))
551                     }
552                 }
553             }
554         } else {
555             return true;
556         }
557     }
558 
559     function _beforeTokenTransfer(
560         address from,
561         address to,
562         uint256 tokenId
563     ) internal virtual {}
564 }
565 
566 
567 pragma solidity ^0.8.0;
568 
569 
570 
571 
572 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
573     
574     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
575 
576     
577     mapping(uint256 => uint256) private _ownedTokensIndex;
578 
579     
580     uint256[] private _allTokens;
581 
582     
583     mapping(uint256 => uint256) private _allTokensIndex;
584 
585 
586     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
587         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
588     }
589 
590    
591     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
592         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
593         return _ownedTokens[owner][index];
594     }
595 
596    
597     function totalSupply() public view virtual override returns (uint256) {
598         return _allTokens.length;
599     }
600 
601    
602     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
603         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
604         return _allTokens[index];
605     }
606 
607   
608     function _beforeTokenTransfer(
609         address from,
610         address to,
611         uint256 tokenId
612     ) internal virtual override {
613         super._beforeTokenTransfer(from, to, tokenId);
614 
615         if (from == address(0)) {
616             _addTokenToAllTokensEnumeration(tokenId);
617         } else if (from != to) {
618             _removeTokenFromOwnerEnumeration(from, tokenId);
619         }
620         if (to == address(0)) {
621             _removeTokenFromAllTokensEnumeration(tokenId);
622         } else if (to != from) {
623             _addTokenToOwnerEnumeration(to, tokenId);
624         }
625     }
626 
627    
628     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
629         uint256 length = ERC721.balanceOf(to);
630         _ownedTokens[to][length] = tokenId;
631         _ownedTokensIndex[tokenId] = length;
632     }
633 
634    
635     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
636         _allTokensIndex[tokenId] = _allTokens.length;
637         _allTokens.push(tokenId);
638     }
639 
640    
641     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
642        
643         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
644         uint256 tokenIndex = _ownedTokensIndex[tokenId];
645 
646         if (tokenIndex != lastTokenIndex) {
647             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
648 
649             _ownedTokens[from][tokenIndex] = lastTokenId; 
650             _ownedTokensIndex[lastTokenId] = tokenIndex; 
651         }
652 
653         delete _ownedTokensIndex[tokenId];
654         delete _ownedTokens[from][lastTokenIndex];
655     }
656 
657     
658     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
659       
660         uint256 lastTokenIndex = _allTokens.length - 1;
661         uint256 tokenIndex = _allTokensIndex[tokenId];
662 
663        
664         uint256 lastTokenId = _allTokens[lastTokenIndex];
665 
666         _allTokens[tokenIndex] = lastTokenId;
667         _allTokensIndex[lastTokenId] = tokenIndex; 
668 
669         
670         delete _allTokensIndex[tokenId];
671         _allTokens.pop();
672     }
673 }
674 
675 
676 
677 pragma solidity ^0.8.0;
678 
679 abstract contract Ownable is Context {
680     address private _owner;
681 
682     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
683 
684     constructor() {
685         _setOwner(_msgSender());
686     }
687 
688     
689     function owner() public view virtual returns (address) {
690         return _owner;
691     }
692 
693    
694     modifier onlyOwner() {
695         require(owner() == _msgSender(), "Ownable: caller is not the owner");
696         _;
697     }
698 
699   
700     function renounceOwnership() public virtual onlyOwner {
701         _setOwner(address(0));
702     }
703 
704    
705     function transferOwnership(address newOwner) public virtual onlyOwner {
706         require(newOwner != address(0), "Ownable: new owner is the zero address");
707         _setOwner(newOwner);
708     }
709 
710     function _setOwner(address newOwner) private {
711         address oldOwner = _owner;
712         _owner = newOwner;
713         emit OwnershipTransferred(oldOwner, newOwner);
714     }
715 }
716 
717 pragma solidity >=0.7.0 <0.9.0;
718 
719 contract MBAC is ERC721Enumerable, Ownable {
720   using Strings for uint256;
721 
722   string baseURI;
723   string public baseExtension = ".json";
724   uint256 public cost = 0.01 ether;
725   uint256 public maxSupply = 3333;
726   uint256 public maxMintAmount = 3;
727   bool public paused = true;
728   bool public revealed = true;
729   string public notRevealedUri;
730   mapping(address => bool) public receivedRefund;
731   uint256 public refundsGiven = 0;
732 
733   constructor(
734     string memory _name,
735     string memory _symbol,
736     string memory _initBaseURI,
737     string memory _initNotRevealedUri
738   ) ERC721(_name, _symbol) {
739     setBaseURI(_initBaseURI);
740     setNotRevealedURI(_initNotRevealedUri);
741   }
742 
743   // internal
744   function _baseURI() internal view virtual override returns (string memory) {
745     return baseURI;
746   }
747 
748   // public
749   function mint(uint256 _mintAmount) public payable {
750     uint256 supply = totalSupply();
751     require(!paused,"Mint is paused");
752     require(_mintAmount > 0,"Mint is invalid");
753     require(_mintAmount <= maxMintAmount,"Mint amount is too high");
754     require(supply + _mintAmount <= maxSupply,"supply exceeded");
755     if (refundsGiven < 333 && !receivedRefund[_msgSender()]) {
756       payable(_msgSender()).transfer(cost);
757       receivedRefund[_msgSender()] = true;
758       refundsGiven++;
759     }
760     
761     for (uint256 i = 1; i <= _mintAmount; i++) {
762       _safeMint(msg.sender, supply + i);
763     }
764   }
765 
766   function walletOfOwner(address _owner)
767     public
768     view
769     returns (uint256[] memory)
770   {
771     uint256 ownerTokenCount = balanceOf(_owner);
772     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
773     for (uint256 i; i < ownerTokenCount; i++) {
774       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
775     }
776     return tokenIds;
777   }
778 
779   function tokenURI(uint256 tokenId)
780     public
781     view
782     virtual
783     override
784     returns (string memory)
785   {
786     require(
787       _exists(tokenId),
788       "ERC721Metadata: URI query for nonexistent token"
789     );
790     
791     if(revealed == false) {
792         return notRevealedUri;
793     }
794 
795     string memory currentBaseURI = _baseURI();
796     return bytes(currentBaseURI).length > 0
797         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
798         : "";
799   }
800 
801   //only owner
802   function reveal() public onlyOwner {
803       revealed = true;
804   }
805   
806   function setCost(uint256 _newCost) public onlyOwner {
807     cost = _newCost;
808   }
809 
810   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
811     maxMintAmount = _newmaxMintAmount;
812   }
813   
814   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
815     notRevealedUri = _notRevealedURI;
816   }
817 
818   function setBaseURI(string memory _newBaseURI) public onlyOwner {
819     baseURI = _newBaseURI;
820   }
821 
822   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
823     baseExtension = _newBaseExtension;
824   }
825 
826   function pause(bool _state) public onlyOwner {
827     paused = _state;
828   }
829  
830   function withdraw() public payable onlyOwner {
831     
832    
833     // =============================================================================
834     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
835     require(os);
836     // =============================================================================
837   }
838 }