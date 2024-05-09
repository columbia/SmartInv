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
64 
65 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
66 pragma solidity ^0.8.0;
67 
68 abstract contract ERC165 is IERC165 {
69  
70     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
71         return interfaceId == type(IERC165).interfaceId;
72     }
73 }
74 
75 
76 pragma solidity ^0.8.0;
77 // conerts to ASCII
78 library Strings {
79     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
80 
81 
82     function toString(uint256 value) internal pure returns (string memory) {
83         // Inspired by OraclizeAPI's implementation - MIT licence
84         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
85 
86         if (value == 0) {
87             return "0";
88         }
89         uint256 temp = value;
90         uint256 digits;
91         while (temp != 0) {
92             digits++;
93             temp /= 10;
94         }
95         bytes memory buffer = new bytes(digits);
96         while (value != 0) {
97             digits -= 1;
98             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
99             value /= 10;
100         }
101         return string(buffer);
102     }
103 
104   
105     function toHexString(uint256 value) internal pure returns (string memory) {
106         if (value == 0) {
107             return "0x00";
108         }
109         uint256 temp = value;
110         uint256 length = 0;
111         while (temp != 0) {
112             length++;
113             temp >>= 8;
114         }
115         return toHexString(value, length);
116     }
117 
118    
119     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
120         bytes memory buffer = new bytes(2 * length + 2);
121         buffer[0] = "0";
122         buffer[1] = "x";
123         for (uint256 i = 2 * length + 1; i > 1; --i) {
124             buffer[i] = _HEX_SYMBOLS[value & 0xf];
125             value >>= 4;
126         }
127         require(value == 0, "Strings: hex length insufficient");
128         return string(buffer);
129     }
130 }
131 
132 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
133 
134 pragma solidity ^0.8.0;
135 //address functions
136 library Address {
137   
138     function isContract(address account) internal view returns (bool) {
139 
140         uint256 size;
141         assembly {
142             size := extcodesize(account)
143         }
144         return size > 0;
145     }
146 
147  
148     function sendValue(address payable recipient, uint256 amount) internal {
149         require(address(this).balance >= amount, "Address: insufficient balance");
150 
151         (bool success, ) = recipient.call{value: amount}("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155 
156     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
157         return functionCall(target, data, "Address: low-level call failed");
158     }
159 
160   
161     function functionCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal returns (bytes memory) {
166         return functionCallWithValue(target, data, 0, errorMessage);
167     }
168 
169   
170     function functionCallWithValue(
171         address target,
172         bytes memory data,
173         uint256 value
174     ) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
176     }
177 
178    
179     function functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 value,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         require(address(this).balance >= value, "Address: insufficient balance for call");
186         require(isContract(target), "Address: call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.call{value: value}(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191 
192    
193     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
194         return functionStaticCall(target, data, "Address: low-level static call failed");
195     }
196 
197    
198     function functionStaticCall(
199         address target,
200         bytes memory data,
201         string memory errorMessage
202     ) internal view returns (bytes memory) {
203         require(isContract(target), "Address: static call to non-contract");
204 
205         (bool success, bytes memory returndata) = target.staticcall(data);
206         return verifyCallResult(success, returndata, errorMessage);
207     }
208 
209   
210     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
211         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
212     }
213 
214 
215     function functionDelegateCall(
216         address target,
217         bytes memory data,
218         string memory errorMessage
219     ) internal returns (bytes memory) {
220         require(isContract(target), "Address: delegate call to non-contract");
221 
222         (bool success, bytes memory returndata) = target.delegatecall(data);
223         return verifyCallResult(success, returndata, errorMessage);
224     }
225 
226   
227     function verifyCallResult(
228         bool success,
229         bytes memory returndata,
230         string memory errorMessage
231     ) internal pure returns (bytes memory) {
232         if (success) {
233             return returndata;
234         } else {
235             
236             if (returndata.length > 0) {
237                 
238 
239                 assembly {
240                     let returndata_size := mload(returndata)
241                     revert(add(32, returndata), returndata_size)
242                 }
243             } else {
244                 revert(errorMessage);
245             }
246         }
247     }
248 }
249 
250 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
251 
252 pragma solidity ^0.8.0;
253 
254 
255 //ERC-721 Token Standard
256  
257 interface IERC721Metadata is IERC721 {
258    
259     function name() external view returns (string memory);
260 
261    
262     function symbol() external view returns (string memory);
263 
264   
265     function tokenURI(uint256 tokenId) external view returns (string memory);
266 }
267 
268 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
269 
270 pragma solidity ^0.8.0;
271 
272 
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
284 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
285 pragma solidity ^0.8.0;
286 
287 abstract contract Context {
288     function _msgSender() internal view virtual returns (address) {
289         return msg.sender;
290     }
291 
292     function _msgData() internal view virtual returns (bytes calldata) {
293         return msg.data;
294     }
295 }
296 
297 
298 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
299 pragma solidity ^0.8.0;
300 
301 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
302     using Address for address;
303     using Strings for uint256;
304 
305     string private _name;
306 
307     string private _symbol;
308 
309     mapping(uint256 => address) private _owners;
310 
311     mapping(address => uint256) private _balances;
312 
313     mapping(uint256 => address) private _tokenApprovals;
314 
315     mapping(address => mapping(address => bool)) private _operatorApprovals;
316 
317 //coolection constructor
318     constructor(string memory name_, string memory symbol_) {
319         _name = name_;
320         _symbol = symbol_;
321     }
322 
323    
324     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
325         return
326             interfaceId == type(IERC721).interfaceId ||
327             interfaceId == type(IERC721Metadata).interfaceId ||
328             super.supportsInterface(interfaceId);
329     }
330 
331 
332     function balanceOf(address owner) public view virtual override returns (uint256) {
333         require(owner != address(0), "ERC721: balance query for the zero address");
334         return _balances[owner];
335     }
336 
337 
338     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
339         address owner = _owners[tokenId];
340         require(owner != address(0), "ERC721: owner query for nonexistent token");
341         return owner;
342     }
343 
344    
345     function name() public view virtual override returns (string memory) {
346         return _name;
347     }
348 
349  
350     function symbol() public view virtual override returns (string memory) {
351         return _symbol;
352     }
353 
354   
355     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
356         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
357 
358         string memory baseURI = _baseURI();
359         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
360     }
361 
362  
363     function _baseURI() internal view virtual returns (string memory) {
364         return "";
365     }
366 
367     function approve(address to, uint256 tokenId) public virtual override {
368         address owner = ERC721.ownerOf(tokenId);
369         require(to != owner, "ERC721: approval to current owner");
370 
371         require(
372             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
373             "ERC721: approve caller is not owner nor approved for all"
374         );
375 
376         _approve(to, tokenId);
377     }
378 
379    
380     function getApproved(uint256 tokenId) public view virtual override returns (address) {
381         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
382 
383         return _tokenApprovals[tokenId];
384     }
385 
386    
387     function setApprovalForAll(address operator, bool approved) public virtual override {
388         require(operator != _msgSender(), "ERC721: approve to caller");
389 
390         _operatorApprovals[_msgSender()][operator] = approved;
391         emit ApprovalForAll(_msgSender(), operator, approved);
392     }
393 
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
404         
405         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
406 
407         _transfer(from, to, tokenId);
408     }
409 
410  
411     function safeTransferFrom(
412         address from,
413         address to,
414         uint256 tokenId
415     ) public virtual override {
416         safeTransferFrom(from, to, tokenId, "");
417     }
418 
419   
420     function safeTransferFrom(
421         address from,
422         address to,
423         uint256 tokenId,
424         bytes memory _data
425     ) public virtual override {
426         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
427         _safeTransfer(from, to, tokenId, _data);
428     }
429 
430    
431     function _safeTransfer(
432         address from,
433         address to,
434         uint256 tokenId,
435         bytes memory _data
436     ) internal virtual {
437         _transfer(from, to, tokenId);
438         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
439     }
440 
441 
442     function _exists(uint256 tokenId) internal view virtual returns (bool) {
443         return _owners[tokenId] != address(0);
444     }
445 
446   
447     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
448         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
449         address owner = ERC721.ownerOf(tokenId);
450         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
451     }
452 
453    
454     function _safeMint(address to, uint256 tokenId) internal virtual {
455         _safeMint(to, tokenId, "");
456     }
457 
458   
459     function _safeMint(
460         address to,
461         uint256 tokenId,
462         bytes memory _data
463     ) internal virtual {
464         _mint(to, tokenId);
465         require(
466             _checkOnERC721Received(address(0), to, tokenId, _data),
467             "ERC721: transfer to non ERC721Receiver implementer"
468         );
469     }
470 
471  
472     function _mint(address to, uint256 tokenId) internal virtual {
473         require(to != address(0), "ERC721: mint to the zero address");
474         require(!_exists(tokenId), "ERC721: token already minted");
475 
476         _beforeTokenTransfer(address(0), to, tokenId);
477 
478         _balances[to] += 1;
479         _owners[tokenId] = to;
480 
481         emit Transfer(address(0), to, tokenId);
482     }
483 
484    
485     function _burn(uint256 tokenId) internal virtual {
486         address owner = ERC721.ownerOf(tokenId);
487 
488         _beforeTokenTransfer(owner, address(0), tokenId);
489 
490 
491         _approve(address(0), tokenId);
492 
493         _balances[owner] -= 1;
494         delete _owners[tokenId];
495 
496         emit Transfer(owner, address(0), tokenId);
497     }
498 
499    
500     function _transfer(
501         address from,
502         address to,
503         uint256 tokenId
504     ) internal virtual {
505         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
506         require(to != address(0), "ERC721: transfer to the zero address");
507 
508         _beforeTokenTransfer(from, to, tokenId);
509 
510     
511         _approve(address(0), tokenId);
512 
513         _balances[from] -= 1;
514         _balances[to] += 1;
515         _owners[tokenId] = to;
516 
517         emit Transfer(from, to, tokenId);
518     }
519 
520   
521     function _approve(address to, uint256 tokenId) internal virtual {
522         _tokenApprovals[tokenId] = to;
523         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
524     }
525 
526     
527     function _checkOnERC721Received(
528         address from,
529         address to,
530         uint256 tokenId,
531         bytes memory _data
532     ) private returns (bool) {
533         if (to.isContract()) {
534             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
535                 return retval == IERC721Receiver.onERC721Received.selector;
536             } catch (bytes memory reason) {
537                 if (reason.length == 0) {
538                     revert("ERC721: transfer to non ERC721Receiver implementer");
539                 } else {
540                     assembly {
541                         revert(add(32, reason), mload(reason))
542                     }
543                 }
544             }
545         } else {
546             return true;
547         }
548     }
549 
550     function _beforeTokenTransfer(
551         address from,
552         address to,
553         uint256 tokenId
554     ) internal virtual {}
555 }
556 
557 
558 
559 
560 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
561 
562 pragma solidity ^0.8.0;
563 // owner only commands
564 abstract contract Ownable is Context {
565     address private _owner;
566 
567     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
568 
569  //owner constructor
570     constructor() {
571         _setOwner(_msgSender());
572     }
573 
574   
575     function owner() public view virtual returns (address) {
576         return _owner;
577     }
578 
579    
580     modifier onlyOwner() {
581         require(owner() == _msgSender(), "Ownable: caller is not the owner");
582         _;
583     }
584 
585 
586     function renounceOwnership() public virtual onlyOwner {
587         _setOwner(address(0));
588     }
589 
590  
591     function transferOwnership(address newOwner) public virtual onlyOwner {
592         require(newOwner != address(0), "Ownable: new owner is the zero address");
593         _setOwner(newOwner);
594     }
595 
596     function _setOwner(address newOwner) private {
597         address oldOwner = _owner;
598         _owner = newOwner;
599         emit OwnershipTransferred(oldOwner, newOwner);
600     }
601 }
602 
603 
604 
605 /*   __        ______   ______  __  ________   __      ___  ___
606     |  |      /       \ |     \|  | |   ____| |  |     \  \/  /
607     |  |      |   _   | |  |\  |  | |  | ___  |  |      \    /
608     |  |      |  |_|  | |  | \    | |   ____| |  |       |  |
609     |  |_____ |       | |  |  \   | |  |____  |  |____   |  |
610     |______ /  \ _ __/  |__|   \__| |_______| |______/   |__|
611 	
612      __        ______   __     __   _______   ______    _________
613     |  |      /       \ \  \  /  / |   ____| |   _  |  |  _______|
614     |  |      |   _   |  \  \/  /  |  | ___  |  |_| /  |  |___
615     |  |      |  |_|  |   \    /   |   ____| |   _  \  |       \
616     |  |_____ |       |    \  /    |  |____  |  | |  |  \____   |
617     |______ /  \ _ __/      \/     |_______| |__| |__|       /  /
618     ________________________________________________________/  /  
619     \_________________________________________________________/ 
620                 ______     __       __   __   ______      
621               /   ___  \  |  |     |  | |  | |   __  \  
622              /  /    \__\ |  |     |  | |  | |  |__|  | 
623             |  |      __  |  |     |  |_|  | |   __ <   
624              \  \____/  / |  |____ |       | |  |__|  | 
625               \________/   \_____/  \_____/  |______ /   
626  	
627 	
628 
629                         f i r e b u g 5 0 9                     
630 */
631 pragma solidity >=0.7.0 <0.9.0;
632 
633 contract LonelyLoversClub is ERC721, Ownable {
634   using Strings for uint256;
635  
636   string public _collectionName= "Lonely Lovers Club";
637   string public _collectionSymbol="LVRS";
638 
639   string baseURI="ipfs://CID/";
640   string public baseExtension = ".json";
641   uint256 public maxSupply = 10000;
642   uint256 public maxMintAmount = 3;
643   bool public lockCollection=false;
644 
645   //track mints
646   uint256 public amountMinted;
647 
648   bool public paused = true;
649   bool public revealed = false;
650   string public notRevealedUri;
651 
652   //claim list toggle
653   bool public claimListActive=false;
654   uint256 public addressCount;
655 
656     //claim list mapping
657     mapping(address => uint256) private _claimList;
658     uint256 public claimCount;
659 
660   //cap
661   bool public cap = false; 
662   uint256 public capCount=9501;
663 
664   constructor() ERC721(_collectionName, _collectionSymbol)
665    {
666     setNotRevealedURI("ipfs://QmfCXtMMuSuk7fH6Gua4R254yZE8bRLHvV3FPtDkhYRP9B/1.json");
667     amountMinted=0;
668     addressCount=0;
669     
670   }
671 
672   function _baseURI() internal view virtual override returns (string memory) {
673     return baseURI;
674   }
675 
676   // public minting fuction
677   function mint(uint256 _mintAmount) public payable {
678 
679     uint256 mintSupply = totalSupply();
680 
681          //added 9500 cap to cut off for claimable time period
682     if(cap==false && (mintSupply+_mintAmount) >= capCount){
683         paused=true;
684         cap=true;
685     }
686 
687 //manage public mint
688  
689       mintSupply=totalSupply();
690     require(!paused, "Contract is paused");
691     require(_mintAmount > 0, "mint amount cant be 0");
692     require(_mintAmount <= maxMintAmount, "Cant mint over the max mint amount");
693     require(mintSupply + _mintAmount <= maxSupply, "Mint amount is too high there may not be enough left to mint that many");
694 
695     for (uint256 i = 1; i <= _mintAmount; i++) {
696       _safeMint(msg.sender, mintSupply + i);
697     }
698     amountMinted+=_mintAmount;
699   
700   }
701   //claimable list mint funtion
702 
703 function mintClaimList(uint256 numberOfTokens) external payable {
704     uint256 currentSupply = totalSupply();
705 
706     require(claimListActive, "Claim list is not active");
707     require(numberOfTokens <= _claimList[msg.sender], "Exceeded max available to purchase");
708     require(currentSupply + numberOfTokens <= maxSupply, "Purchase would exceed max supply");
709     // cost taken down to 0 for claims
710     //require(cost * numberOfTokens <= msg.value, "Eth value sent is not correct");
711 
712     _claimList[msg.sender] -= numberOfTokens;
713     for (uint256 i = 1; i <= (numberOfTokens); i++) {
714         _safeMint(msg.sender, currentSupply + i);
715     }
716     if(_claimList[msg.sender]==0){
717           claimCount-=1;
718       }
719     amountMinted+=numberOfTokens;
720  }
721 
722 //return total supply minted
723  function totalSupply() public view returns (uint256) {
724     return amountMinted;
725   }
726 //gas efficient function to find token ids owned by address
727 
728    function walletOfOwner(address _owner)
729     public
730     view
731     returns (uint256[] memory)
732   {
733     uint256 ownerTokenCount = balanceOf(_owner);
734     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
735     uint256 currentTokenId = 1;
736     uint256 ownedTokenIndex = 0;
737 
738     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
739       address currentTokenOwner = ownerOf(currentTokenId);
740 
741       if (currentTokenOwner == _owner) {
742         ownedTokenIds[ownedTokenIndex] = currentTokenId;
743 
744         ownedTokenIndex++;
745       }
746 
747       currentTokenId++;
748     }
749 
750     return ownedTokenIds;
751   }
752   function tokenURI(uint256 tokenId)
753     public
754     view
755     virtual
756     override
757     returns (string memory)
758   {
759     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
760     
761     if(revealed == false) {
762         return notRevealedUri;
763     }
764     if(tokenId>amountMinted) {
765         return notRevealedUri;
766     }
767 
768     string memory currentBaseURI = _baseURI();
769     return bytes(currentBaseURI).length > 0
770         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
771         : "";
772   }
773   //actions for the owner to interact with contract
774   function setReveal(bool _newBool) public onlyOwner() {
775       revealed = _newBool;
776   }
777  
778 // max mint amount
779   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
780     maxMintAmount = _newmaxMintAmount;
781   }
782 
783 //revealed bool  
784   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
785     notRevealedUri = _notRevealedURI;
786   }
787 //base URI extension
788   function setBaseURI(string memory _newBaseURI) public onlyOwner {
789     baseURI = _newBaseURI;
790   }
791 //set extension (.json)
792   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
793     baseExtension = _newBaseExtension;
794   }
795 //contract paused state
796   function pause(bool _state) public onlyOwner {
797     paused = _state;
798   }
799 //collection Lock
800 function CollectionLock(bool _state) public onlyOwner{
801     lockCollection=_state;
802 }
803 //Set collection amount 
804 function setCollectionAmount(uint256 _newAmount) public onlyOwner{
805     require(lockCollection==false,"collection amount is locked");
806     maxSupply=_newAmount;
807 }
808  
809 //claim functions
810 //set single claim address
811 function setClaimList(address addressInput, uint256 numAllowedToMint) external onlyOwner {
812        
813             _claimList[addressInput] = numAllowedToMint;
814             addressCount+=1;
815     }
816 //set claim list to true or false for active
817     function setClaimListActive(bool _claimListActive) external onlyOwner {
818         claimListActive = _claimListActive;
819     }
820 //reset claimCount (claim list count)
821     function claimCountReset(uint256 _newCount) public onlyOwner {
822         claimCount=_newCount;
823     }
824 //set a full claim address list 
825 function setFullClaimList(address[] calldata addresses, uint256 numAllowedToMint) external onlyOwner {
826     for (uint256 i = 0; i < addresses.length; i++) {
827         _claimList[addresses[i]] = numAllowedToMint;
828     }
829     claimCount+=addresses.length;
830 }
831 
832 //adjust cap cut off point
833   function setCapNumber(uint256 _newCap) public onlyOwner() {
834     capCount=_newCap;
835   }
836 
837   function setCapBool(bool _newCap) public onlyOwner() {
838     cap=_newCap;
839   }
840 
841 //witdraw to retrieve all funds to deployment account 
842   function Withdraw() public payable onlyOwner {
843  
844     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
845     require(success);
846   }
847 }