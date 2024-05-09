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
602 /*
603                              __     __     __   _______   __________
604                             \   \  /  \  /   / |   ____| |___    ___|
605                              \   \/    \/   /  |  |____      |  |
606                               \            /   |   ____|     |  |
607                                \    /\    /    |  |____   ___|  |___
608                                 \__/  \__/     |_______| |__________|
609 
610   __     __     __    _____      _______     ________    __________    _____    ________    ________
611  \   \  /  \  /   /  /      \   |    _   |  |    _   |  |___    ___|  /     \  |   _    |  /  _____/                        
612   \   \/    \/   /  /   /\   \  |   |_|  /  |   |_|  /      |  |     |   _   | |  |_|   / |  |___                         
613    \            /  |    __    | |   __  \   |   __  \       |  |     |  |_|  | |   __  \   \___  \                    
614     \    /\    /   |   |  |   | |  |  \  \  |  |  \  \   ___|  |___  |       | |  |  \  \      |  |                    
615      \__/  \__/    |___|  |___| |__|   \__\ |__|   \__\ |__________|  \_____/  |__|   \__\     /  /                    
616        _______________________________________________________________________________________/  /                                                                                                                                                                                                                     
617        \________________________________________________________________________________________/                         
618 
619 
620                                          f i r e b u g 5 0 9                     
621 */
622 
623 pragma solidity >=0.7.0 <0.9.0;
624 
625 contract WeiWarriorCollection is ERC721, Ownable {
626   using Strings for uint256;
627  
628   string public _collectionName= "Wei Warrior Collection";
629   string public _collectionSymbol="CWEI";
630 
631   string baseURI="ipfs://CID/";
632   string public baseExtension = ".json";
633 
634   uint256 public cost = 0.07 ether;
635   uint256 public whiteListCost = 0.07 ether;
636 
637   uint256 public maxSupply = 888;
638   uint256 public maxMintAmount = 10;
639   uint256 public whiteListMintAmount=5;
640 
641   //track mints
642   uint256 public amountMinted;
643 
644   bool public paused = true;
645   bool public revealed = false;
646   string public notRevealedUri;
647 
648   //white list toggle
649   bool public whiteListActive=false;
650 
651     //payable adresses on withdraw
652     //add1= community | add2=Dev | add3=creator | add4 CommunityAdmin  |  add5= artist
653     address private addressOne = 0x5Eebaf6DAFE9183DA0b06B5c1105ed51ebDD5871;
654     address private addressTwo = 0xf3447A408cea54D7790449f848439657eAa52258;
655     address private addressThree = 0xB91f11EACF139aab8dFD16AB923E9756C4d973f9;
656     address private addressFour = 0x885b677A3Af27cCA4C3da1D6E2D72797dE7F8f60;
657     address private addressFive = 0xDD3b00A5a07e33dE588fe1d21e4CdbF863233302;
658  
659     //whitelist mapping
660     mapping(address => uint256) private _whiteList;
661     uint256 public addressCount;
662 
663   constructor() ERC721(_collectionName, _collectionSymbol)
664    {
665     setNotRevealedURI("ipfs://QmUjEBEBMzT2RXWwHn7zDrzgP5tVGFeAJUCfQ557sL38Li/HiddenMetadata.json");
666     amountMinted=0;
667     addressCount=0;
668 
669   }
670 
671   function _baseURI() internal view virtual override returns (string memory) {
672     return baseURI;
673   }
674 
675   // public minting fuction + WL check
676   function mint(uint256 _mintAmount) public payable {
677 
678     uint256 mintSupply = totalSupply();
679 
680 //manage whitelist request
681    
682     if(_whiteList[msg.sender]>0){
683         require(whiteListActive, "whitelist not active");
684         require(_mintAmount<=_whiteList[msg.sender],"Exceeded max available to purchase");
685         require(_mintAmount > 0, "mint amount cant be 0");
686         require(_mintAmount <= whiteListMintAmount, "Cant mint over the max mint amount");
687         require(mintSupply + _mintAmount <= maxSupply, "Purchase would exceed max supply");
688         require(msg.value>= whiteListCost*_mintAmount,"Eth value sent is not correct");
689 
690         _whiteList[msg.sender] -= _mintAmount;
691           for (uint256 i = 1; i <= _mintAmount; i++) {
692       
693       _safeMint(msg.sender, mintSupply + i);
694       
695     }
696      if(_whiteList[msg.sender]==0){
697           addressCount-=1;
698       }
699     amountMinted+=_mintAmount;
700     }
701     
702 //manage public mint
703   else{
704       mintSupply=totalSupply();
705     require(!paused, "Contract is paused");
706     require(_mintAmount > 0, "mint amount cant be 0");
707     require(_mintAmount <= maxMintAmount, "Cant mint over the max mint amount");
708     require(mintSupply + _mintAmount <= maxSupply, "Mint amount is too high there may not be enough left to mint that many");
709 
710     if (msg.sender != owner()) {
711       require(msg.value >= cost * _mintAmount);
712     }
713     for (uint256 i = 1; i <= _mintAmount; i++) {
714       _safeMint(msg.sender, mintSupply + i);
715     }
716     amountMinted+=_mintAmount;
717   }
718   }
719 
720 //return total supply minted
721  function totalSupply() public view returns (uint256) {
722     return amountMinted;
723   }
724 //gas efficient function to find token ids owned by address
725 
726    function walletOfOwner(address _owner)
727     public
728     view
729     returns (uint256[] memory)
730   {
731     uint256 ownerTokenCount = balanceOf(_owner);
732     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
733     uint256 currentTokenId = 1;
734     uint256 ownedTokenIndex = 0;
735 
736     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
737       address currentTokenOwner = ownerOf(currentTokenId);
738 
739       if (currentTokenOwner == _owner) {
740         ownedTokenIds[ownedTokenIndex] = currentTokenId;
741 
742         ownedTokenIndex++;
743       }
744 
745       currentTokenId++;
746     }
747 
748     return ownedTokenIds;
749   }
750   function tokenURI(uint256 tokenId)
751     public
752     view
753     virtual
754     override
755     returns (string memory)
756   {
757     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
758     
759     if(revealed == false) {
760         return notRevealedUri;
761     }
762     string memory currentBaseURI = _baseURI();
763     return bytes(currentBaseURI).length > 0
764         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
765         : "";
766   }
767   //actions for the owner to interact with contract
768   function setReveal(bool _newBool) public onlyOwner() {
769       revealed = _newBool;
770   }
771 // update mint cost
772   function setCost(uint256 _newCost) public onlyOwner() {
773     cost = _newCost;
774   }
775   // update WL mint cost
776   function setWhiteListCost(uint256 _newCost) public onlyOwner() {
777     whiteListCost = _newCost;
778   }
779 // max mint amount
780   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
781     maxMintAmount = _newmaxMintAmount;
782   }
783 // max WL amount
784   function setMaxWlAmount(uint256 _newMaxWlAmount) public onlyOwner() {
785     whiteListMintAmount= _newMaxWlAmount;
786   }
787 //revealed bool  
788   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
789     notRevealedUri = _notRevealedURI;
790   }
791 //base URI extension
792   function setBaseURI(string memory _newBaseURI) public onlyOwner {
793     baseURI = _newBaseURI;
794   }
795 //set extension (.json)
796   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
797     baseExtension = _newBaseExtension;
798   }
799 //contract paused state
800   function pause(bool _state) public onlyOwner {
801     paused = _state;
802   }
803   //white list fuctions
804 //set single address
805   function setwhiteList(address addressInput, uint256 numAllowedToMint) external onlyOwner {
806        
807             _whiteList[addressInput] = numAllowedToMint;
808             addressCount+=1;
809     }
810 //set white list to true or false for active
811     function setwhiteListActive(bool _whiteListActive) external onlyOwner {
812         whiteListActive = _whiteListActive;
813     }
814 //reset addressCount (white list count)
815     function addressCountReset(uint256 _newCount) public onlyOwner {
816        addressCount=_newCount;
817     }
818 //set a full address list 
819 function setFullwhiteList(address[] calldata addresses, uint256 numAllowedToMint) external onlyOwner {
820     for (uint256 i = 0; i < addresses.length; i++) {
821         _whiteList[addresses[i]] = numAllowedToMint;
822     
823     }
824     addressCount+=addresses.length;
825 }
826 //set address 4 for payable
827 function setAddressFour(address _newAddress) external onlyOwner{
828     addressFour=_newAddress;
829 }
830 
831  //primary withdraw, withdraw % to address 1 % to address 2
832   function primaryWithdraw() public payable onlyOwner {
833    uint256 CurrentBalance = address(this).balance;
834         payable(addressOne).transfer((CurrentBalance * 50) / 100);
835         payable(addressTwo).transfer((CurrentBalance * 9) / 100);
836         payable(addressThree).transfer((CurrentBalance * 37) / 100);
837         payable(addressFour).transfer((CurrentBalance * 3) / 100);
838         payable(addressFive).transfer((CurrentBalance * 1) / 100);
839        
840 
841   }     
842 
843 }