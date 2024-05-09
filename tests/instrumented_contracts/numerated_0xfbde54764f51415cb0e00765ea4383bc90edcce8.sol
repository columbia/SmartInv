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
316 //coolection constructor
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
330 
331     function balanceOf(address owner) public view virtual override returns (uint256) {
332         require(owner != address(0), "ERC721: balance query for the zero address");
333         return _balances[owner];
334     }
335 
336 
337     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
338         address owner = _owners[tokenId];
339         require(owner != address(0), "ERC721: owner query for nonexistent token");
340         return owner;
341     }
342 
343    
344     function name() public view virtual override returns (string memory) {
345         return _name;
346     }
347 
348  
349     function symbol() public view virtual override returns (string memory) {
350         return _symbol;
351     }
352 
353   
354     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
355         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
356 
357         string memory baseURI = _baseURI();
358         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
359     }
360 
361  
362     function _baseURI() internal view virtual returns (string memory) {
363         return "";
364     }
365 
366     function approve(address to, uint256 tokenId) public virtual override {
367         address owner = ERC721.ownerOf(tokenId);
368         require(to != owner, "ERC721: approval to current owner");
369 
370         require(
371             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
372             "ERC721: approve caller is not owner nor approved for all"
373         );
374 
375         _approve(to, tokenId);
376     }
377 
378    
379     function getApproved(uint256 tokenId) public view virtual override returns (address) {
380         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
381 
382         return _tokenApprovals[tokenId];
383     }
384 
385    
386     function setApprovalForAll(address operator, bool approved) public virtual override {
387         require(operator != _msgSender(), "ERC721: approve to caller");
388 
389         _operatorApprovals[_msgSender()][operator] = approved;
390         emit ApprovalForAll(_msgSender(), operator, approved);
391     }
392 
393   
394     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
395         return _operatorApprovals[owner][operator];
396     }
397 
398     function transferFrom(
399         address from,
400         address to,
401         uint256 tokenId
402     ) public virtual override {
403         
404         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
405 
406         _transfer(from, to, tokenId);
407     }
408 
409  
410     function safeTransferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) public virtual override {
415         safeTransferFrom(from, to, tokenId, "");
416     }
417 
418   
419     function safeTransferFrom(
420         address from,
421         address to,
422         uint256 tokenId,
423         bytes memory _data
424     ) public virtual override {
425         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
426         _safeTransfer(from, to, tokenId, _data);
427     }
428 
429    
430     function _safeTransfer(
431         address from,
432         address to,
433         uint256 tokenId,
434         bytes memory _data
435     ) internal virtual {
436         _transfer(from, to, tokenId);
437         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
438     }
439 
440 
441     function _exists(uint256 tokenId) internal view virtual returns (bool) {
442         return _owners[tokenId] != address(0);
443     }
444 
445   
446     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
447         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
448         address owner = ERC721.ownerOf(tokenId);
449         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
450     }
451 
452    
453     function _safeMint(address to, uint256 tokenId) internal virtual {
454         _safeMint(to, tokenId, "");
455     }
456 
457   
458     function _safeMint(
459         address to,
460         uint256 tokenId,
461         bytes memory _data
462     ) internal virtual {
463         _mint(to, tokenId);
464         require(
465             _checkOnERC721Received(address(0), to, tokenId, _data),
466             "ERC721: transfer to non ERC721Receiver implementer"
467         );
468     }
469 
470  
471     function _mint(address to, uint256 tokenId) internal virtual {
472         require(to != address(0), "ERC721: mint to the zero address");
473         require(!_exists(tokenId), "ERC721: token already minted");
474 
475         _beforeTokenTransfer(address(0), to, tokenId);
476 
477         _balances[to] += 1;
478         _owners[tokenId] = to;
479 
480         emit Transfer(address(0), to, tokenId);
481     }
482 
483    
484     function _burn(uint256 tokenId) internal virtual {
485         address owner = ERC721.ownerOf(tokenId);
486 
487         _beforeTokenTransfer(owner, address(0), tokenId);
488 
489 
490         _approve(address(0), tokenId);
491 
492         _balances[owner] -= 1;
493         delete _owners[tokenId];
494 
495         emit Transfer(owner, address(0), tokenId);
496     }
497 
498    
499     function _transfer(
500         address from,
501         address to,
502         uint256 tokenId
503     ) internal virtual {
504         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
505         require(to != address(0), "ERC721: transfer to the zero address");
506 
507         _beforeTokenTransfer(from, to, tokenId);
508 
509     
510         _approve(address(0), tokenId);
511 
512         _balances[from] -= 1;
513         _balances[to] += 1;
514         _owners[tokenId] = to;
515 
516         emit Transfer(from, to, tokenId);
517     }
518 
519   
520     function _approve(address to, uint256 tokenId) internal virtual {
521         _tokenApprovals[tokenId] = to;
522         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
523     }
524 
525     
526     function _checkOnERC721Received(
527         address from,
528         address to,
529         uint256 tokenId,
530         bytes memory _data
531     ) private returns (bool) {
532         if (to.isContract()) {
533             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
534                 return retval == IERC721Receiver.onERC721Received.selector;
535             } catch (bytes memory reason) {
536                 if (reason.length == 0) {
537                     revert("ERC721: transfer to non ERC721Receiver implementer");
538                 } else {
539                     assembly {
540                         revert(add(32, reason), mload(reason))
541                     }
542                 }
543             }
544         } else {
545             return true;
546         }
547     }
548 
549     function _beforeTokenTransfer(
550         address from,
551         address to,
552         uint256 tokenId
553     ) internal virtual {}
554 }
555 
556 
557 
558 
559 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
560 
561 pragma solidity ^0.8.0;
562 // owner only commands
563 abstract contract Ownable is Context {
564     address private _owner;
565 
566     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
567 
568  //owner constructor
569     constructor() {
570         _setOwner(_msgSender());
571     }
572 
573   
574     function owner() public view virtual returns (address) {
575         return _owner;
576     }
577 
578    
579     modifier onlyOwner() {
580         require(owner() == _msgSender(), "Ownable: caller is not the owner");
581         _;
582     }
583 
584 
585     function renounceOwnership() public virtual onlyOwner {
586         _setOwner(address(0));
587     }
588 
589  
590     function transferOwnership(address newOwner) public virtual onlyOwner {
591         require(newOwner != address(0), "Ownable: new owner is the zero address");
592         _setOwner(newOwner);
593     }
594 
595     function _setOwner(address newOwner) private {
596         address oldOwner = _owner;
597         _owner = newOwner;
598         emit OwnershipTransferred(oldOwner, newOwner);
599     }
600 }
601 
602 
603 
604 /*   __        ______   ______  __  ________   __      ___  ___
605     |  |      /       \ |     \|  | |   ____| |  |     \  \/  /
606     |  |      |   _   | |  |\  |  | |  | ___  |  |      \    /
607     |  |      |  |_|  | |  | \    | |   ____| |  |       |  |
608     |  |_____ |       | |  |  \   | |  |____  |  |____   |  |
609     |______ /  \ _ __/  |__|   \__| |_______| |______/   |__|
610 	
611  	 ______      ______   _____   ___  ________     _________
612     |   __  \   /       \ |     \|  | |   _____|   |  _______|
613     |  |__|  |  |   _   | |  |\  |  | |  |_____    |  |___
614     |   __ <    |  |_|  | |  | \    | |   _____|   |       \
615     |  |__|  |  |       | |  |  \   | |  |_____    \____    |
616     |______ /   \_______/ |__|   \__| |________|        /  /
617  	 __________________________________________________/  /  
618 	 \___________________________________________________/
619 	
620 
621                         f i r e b u g 5 0 9                     
622 */
623 pragma solidity >=0.7.0 <0.9.0;
624 
625 contract lonelyBonesClub is ERC721, Ownable {
626   using Strings for uint256;
627  
628   string public _collectionName= "Lonely Bones Club";
629   string public _collectionSymbol="LB";
630 
631   string baseURI="ipfs://CID/";
632   string public baseExtension = ".json";
633 
634   uint256 public cost = 0.05 ether;
635   uint256 public whiteListCost = 0.035 ether;
636 
637   uint256 public maxSupply = 4444;
638   uint256 public maxMintAmount = 3;
639   uint256 public whiteListMintAmount=2;
640 
641   //track mints
642   uint256 public amountMinted;
643 
644   bool public paused = true;
645   bool public revealed = false;
646   string public notRevealedUri;
647 
648 
649   //white list toggle
650   bool public whiteListActive=false;
651   //claim list toggle
652   bool public claimListActive=false;
653  
654 
655     //payable adresses on withdraw
656     //address one = community wallet
657     address private addressOne = 0x2FA32ec6d1207b2327766b58993B8428ebeCb7Ac;
658     address private addressTwo = 0x7e54507e286a3C54699a8B457294A5B219aE116b;
659 
660     //whitelist mapping
661     mapping(address => uint256) private _whiteList;
662     uint256 public addressCount;
663     //claim list mapping
664     mapping(address => uint256) private _claimList;
665     uint256 public claimCount;
666 
667 
668   constructor(string memory _unRevealedURI) 
669   
670   ERC721(_collectionName, _collectionSymbol)
671    {
672     setNotRevealedURI(_unRevealedURI);
673   
674   }
675 
676   function _baseURI() internal view virtual override returns (string memory) {
677     return baseURI;
678   }
679 
680   // public minting fuction + WL check
681   function mint(uint256 _mintAmount) public payable {
682 
683     uint256 mintSupply = totalSupply();
684 
685 //manage whitelist request
686 
687     if(_whiteList[msg.sender]>0){
688         require(whiteListActive, "whitelist not active");
689         require(_mintAmount<=_whiteList[msg.sender],"Exceeded max available to purchase");
690         require(_mintAmount > 0, "mint amount cant be 0");
691         require(_mintAmount <= whiteListMintAmount, "Cant mint over the max mint amount");
692         require(mintSupply + _mintAmount <= maxSupply, "Purchase would exceed max supply");
693         require(msg.value>= whiteListCost*_mintAmount,"Eth value sent is not correct");
694 
695         _whiteList[msg.sender] -= _mintAmount;
696           for (uint256 i = 1; i <= _mintAmount; i++) {
697       
698       _safeMint(msg.sender, mintSupply + i);
699       
700     }
701      if(_whiteList[msg.sender]==0){
702           addressCount-=1;
703       }
704     amountMinted+=_mintAmount;
705     }
706  
707 //manage public mint
708   else{
709       mintSupply=totalSupply();
710     require(!paused, "Contract is paused");
711     require(_mintAmount > 0, "mint amount cant be 0");
712     require(_mintAmount <= maxMintAmount, "Cant mint over the max mint amount");
713     require(mintSupply + _mintAmount <= maxSupply, "Mint amount is too high there may not be enough left to mint that many");
714 
715     if (msg.sender != owner()) {
716       require(msg.value >= cost * _mintAmount);
717     }
718   
719 
720     for (uint256 i = 1; i <= _mintAmount; i++) {
721       
722       _safeMint(msg.sender, mintSupply + i);
723     }
724     amountMinted+=_mintAmount;
725   }
726 
727   }
728 
729   //claimable list mint funtion
730 
731 function mintClaimList(uint256 numberOfTokens) external payable {
732     uint256 currentSupply = totalSupply();
733 
734     require(claimListActive, "Claim list is not active");
735     require(numberOfTokens <= _claimList[msg.sender], "Exceeded max available to purchase");
736     require(currentSupply + numberOfTokens <= maxSupply, "Purchase would exceed max supply");
737     // cost taken down to 0 for claims
738     //require(cost * numberOfTokens <= msg.value, "Eth value sent is not correct");
739 
740     _claimList[msg.sender] -= numberOfTokens;
741     for (uint256 i = 1; i <= (numberOfTokens); i++) {
742         _safeMint(msg.sender, currentSupply + i);
743     }
744     if(_claimList[msg.sender]==0){
745           claimCount-=1;
746       }
747     amountMinted+=numberOfTokens;
748  }
749 
750 //return total supply minted
751  function totalSupply() public view returns (uint256) {
752     return amountMinted;
753   }
754 //gas efficient function to find token ids owned by address
755 
756    function walletOfOwner(address _owner)
757     public
758     view
759     returns (uint256[] memory)
760   {
761     uint256 ownerTokenCount = balanceOf(_owner);
762     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
763     uint256 currentTokenId = 1;
764     uint256 ownedTokenIndex = 0;
765 
766     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
767       address currentTokenOwner = ownerOf(currentTokenId);
768 
769       if (currentTokenOwner == _owner) {
770         ownedTokenIds[ownedTokenIndex] = currentTokenId;
771 
772         ownedTokenIndex++;
773       }
774 
775       currentTokenId++;
776     }
777 
778     return ownedTokenIds;
779   }
780 
781 
782   function tokenURI(uint256 tokenId)
783     public
784     view
785     virtual
786     override
787     returns (string memory)
788   {
789     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
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
801   //actions for the owner to interact with contract
802   function setReveal(bool _newBool) public onlyOwner() {
803       revealed = _newBool;
804   }
805 
806 // update mint cost
807   function setCost(uint256 _newCost) public onlyOwner() {
808     cost = _newCost;
809   }
810   // update WL mint cost
811   function setWhiteListCost(uint256 _newCost) public onlyOwner() {
812     whiteListCost = _newCost;
813   }
814 // max mint amount
815   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
816     maxMintAmount = _newmaxMintAmount;
817   }
818 //revealed bool  
819   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
820     notRevealedUri = _notRevealedURI;
821   }
822 //base URI extension
823   function setBaseURI(string memory _newBaseURI) public onlyOwner {
824     baseURI = _newBaseURI;
825   }
826 //set extension (.json)
827   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
828     baseExtension = _newBaseExtension;
829   }
830 //contract paused state
831   function pause(bool _state) public onlyOwner {
832     paused = _state;
833   }
834   //white list fuctions
835 //set single address
836   function setwhiteList(address addressInput, uint256 numAllowedToMint) external onlyOwner {
837        
838             _whiteList[addressInput] = numAllowedToMint;
839             addressCount+=1;
840     }
841 //set white list to true or false for active
842     function setwhiteListActive(bool _whiteListActive) external onlyOwner {
843         whiteListActive = _whiteListActive;
844     }
845 //reset addressCount (white list count)
846     function addressCountReset(uint256 _newCount) public onlyOwner {
847        addressCount=_newCount;
848     }
849 //set a full address list 
850 function setFullwhiteList(address[] calldata addresses, uint256 numAllowedToMint) external onlyOwner {
851     for (uint256 i = 0; i < addresses.length; i++) {
852         _whiteList[addresses[i]] = numAllowedToMint;
853     
854     }
855     addressCount+=addresses.length;
856 }
857 //claim functions
858 //set single claim address
859 function setClaimList(address addressInput, uint256 numAllowedToMint) external onlyOwner {
860        
861             _claimList[addressInput] = numAllowedToMint;
862             addressCount+=1;
863     }
864 //set claim list to true or false for active
865     function setClaimListActive(bool _claimListActive) external onlyOwner {
866         claimListActive = _claimListActive;
867     }
868 //reset claimCount (claim list count)
869     function claimCountReset(uint256 _newCount) public onlyOwner {
870         claimCount=_newCount;
871     }
872 //set a full claim address list 
873 function setFullClaimList(address[] calldata addresses, uint256 numAllowedToMint) external onlyOwner {
874     for (uint256 i = 0; i < addresses.length; i++) {
875         _claimList[addresses[i]] = numAllowedToMint;
876     }
877     claimCount+=addresses.length;
878 }
879 
880  //primary withdraw, withdraw % to address 1 % to address 2
881   function primaryWithdraw() public payable onlyOwner {
882    uint256 CurrentBalance = address(this).balance;
883         payable(addressOne).transfer((CurrentBalance * 50) / 100);
884         payable(addressTwo).transfer((CurrentBalance * 50) / 100);
885 
886   }
887 
888 }