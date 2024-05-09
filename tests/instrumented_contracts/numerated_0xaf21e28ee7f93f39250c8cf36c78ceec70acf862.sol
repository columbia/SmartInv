1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 library Counters {
11     struct Counter {
12         uint256 _value; 
13     }
14 
15     function current(Counter storage counter) internal view returns (uint256) {
16         return counter._value;
17     }
18 
19     function increment(Counter storage counter) internal {
20         unchecked {
21             counter._value += 1;
22         }
23     }
24 
25     function decrement(Counter storage counter) internal {
26         uint256 value = counter._value;
27         require(value > 0, "Counter: decrement overflow");
28         unchecked {
29             counter._value = value - 1;
30         }
31     }
32 
33     function reset(Counter storage counter) internal {
34         counter._value = 0;
35     }
36 }
37 
38 // File: @openzeppelin/contracts/utils/Strings.sol
39 
40 
41 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
42 
43 pragma solidity ^0.8.0;
44 
45 library Strings {
46     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
47 
48     function toString(uint256 value) internal pure returns (string memory) {
49 
50         if (value == 0) {
51             return "0";
52         }
53         uint256 temp = value;
54         uint256 digits;
55         while (temp != 0) {
56             digits++;
57             temp /= 10;
58         }
59         bytes memory buffer = new bytes(digits);
60         while (value != 0) {
61             digits -= 1;
62             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
63             value /= 10;
64         }
65         return string(buffer);
66     }
67 
68     function toHexString(uint256 value) internal pure returns (string memory) {
69         if (value == 0) {
70             return "0x00";
71         }
72         uint256 temp = value;
73         uint256 length = 0;
74         while (temp != 0) {
75             length++;
76             temp >>= 8;
77         }
78         return toHexString(value, length);
79     }
80 
81     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
82         bytes memory buffer = new bytes(2 * length + 2);
83         buffer[0] = "0";
84         buffer[1] = "x";
85         for (uint256 i = 2 * length + 1; i > 1; --i) {
86             buffer[i] = _HEX_SYMBOLS[value & 0xf];
87             value >>= 4;
88         }
89         require(value == 0, "Strings: hex length insufficient");
90         return string(buffer);
91     }
92 }
93 
94 // File: @openzeppelin/contracts/utils/Context.sol
95 
96 
97 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/access/Ownable.sol
112 
113 
114 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     constructor() {
125         _transferOwnership(_msgSender());
126     }
127 
128     function owner() public view virtual returns (address) {
129         return _owner;
130     }
131 
132     modifier onlyOwner() {
133         require(owner() == _msgSender(), "Ownable: caller is not the owner");
134         _;
135     }
136 
137     function renounceOwnership() public virtual onlyOwner {
138         _transferOwnership(address(0));
139     }
140 
141     function transferOwnership(address newOwner) public virtual onlyOwner {
142         require(newOwner != address(0), "Ownable: new owner is the zero address");
143         _transferOwnership(newOwner);
144     }
145 
146     function _transferOwnership(address newOwner) internal virtual {
147         address oldOwner = _owner;
148         _owner = newOwner;
149         emit OwnershipTransferred(oldOwner, newOwner);
150     }
151 }
152 
153 // File: @openzeppelin/contracts/utils/Address.sol
154 
155 
156 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 library Address {
161     function isContract(address account) internal view returns (bool) {
162         uint256 size;
163         assembly {
164             size := extcodesize(account)
165         }
166         return size > 0;
167     }
168 
169     function sendValue(address payable recipient, uint256 amount) internal {
170         require(address(this).balance >= amount, "Address: insufficient balance");
171 
172         (bool success, ) = recipient.call{value: amount}("");
173         require(success, "Address: unable to send value, recipient may have reverted");
174     }
175 
176     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionCall(target, data, "Address: low-level call failed");
178     }
179 
180     function functionCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, 0, errorMessage);
186     }
187 
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value
192     ) internal returns (bytes memory) {
193         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
194     }
195 
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         require(address(this).balance >= value, "Address: insufficient balance for call");
203         require(isContract(target), "Address: call to non-contract");
204 
205         (bool success, bytes memory returndata) = target.call{value: value}(data);
206         return verifyCallResult(success, returndata, errorMessage);
207     }
208 
209     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
210         return functionStaticCall(target, data, "Address: low-level static call failed");
211     }
212 
213     function functionStaticCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal view returns (bytes memory) {
218         require(isContract(target), "Address: static call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.staticcall(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
225         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
226     }
227 
228     function functionDelegateCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         require(isContract(target), "Address: delegate call to non-contract");
234 
235         (bool success, bytes memory returndata) = target.delegatecall(data);
236         return verifyCallResult(success, returndata, errorMessage);
237     }
238 
239     function verifyCallResult(
240         bool success,
241         bytes memory returndata,
242         string memory errorMessage
243     ) internal pure returns (bytes memory) {
244         if (success) {
245             return returndata;
246         } else {
247             if (returndata.length > 0) {
248 
249                 assembly {
250                     let returndata_size := mload(returndata)
251                     revert(add(32, returndata), returndata_size)
252                 }
253             } else {
254                 revert(errorMessage);
255             }
256         }
257     }
258 }
259 
260 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
261 
262 
263 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 interface IERC721Receiver {
268     function onERC721Received(
269         address operator,
270         address from,
271         uint256 tokenId,
272         bytes calldata data
273     ) external returns (bytes4);
274 }
275 
276 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
277 
278 
279 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
280 
281 pragma solidity ^0.8.0;
282 interface IERC165 {
283     function supportsInterface(bytes4 interfaceId) external view returns (bool);
284 }
285 
286 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 
294 abstract contract ERC165 is IERC165 {
295     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
296         return interfaceId == type(IERC165).interfaceId;
297     }
298 }
299 
300 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
301 
302 
303 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
304 
305 pragma solidity ^0.8.0;
306 
307 
308 interface IERC721 is IERC165 {
309     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
310 
311     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
312 
313     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
314 
315     function balanceOf(address owner) external view returns (uint256 balance);
316 
317     function ownerOf(uint256 tokenId) external view returns (address owner);
318 
319     function safeTransferFrom(
320         address from,
321         address to,
322         uint256 tokenId
323     ) external;
324 
325     function transferFrom(
326         address from,
327         address to,
328         uint256 tokenId
329     ) external;
330 
331     function approve(address to, uint256 tokenId) external;
332 
333     function getApproved(uint256 tokenId) external view returns (address operator);
334 
335     function setApprovalForAll(address operator, bool _approved) external;
336 
337     function isApprovedForAll(address owner, address operator) external view returns (bool);
338 
339     function safeTransferFrom(
340         address from,
341         address to,
342         uint256 tokenId,
343         bytes calldata data
344     ) external;
345 }
346 
347 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
348 
349 
350 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 
355 /**
356  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
357  */
358 interface IERC721Metadata is IERC721 {
359     function name() external view returns (string memory);
360 
361     function symbol() external view returns (string memory);
362 
363     function tokenURI(uint256 tokenId) external view returns (string memory);
364 }
365 
366 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
367 
368 
369 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
370 
371 pragma solidity ^0.8.0;
372 
373 
374 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
375     using Address for address;
376     using Strings for uint256;
377 
378     string private _name;
379 
380     string private _symbol;
381 
382     mapping(uint256 => address) private _owners;
383 
384     mapping(address => uint256) private _balances;
385 
386     mapping(uint256 => address) private _tokenApprovals;
387 
388     mapping(address => mapping(address => bool)) private _operatorApprovals;
389 
390     constructor(string memory name_, string memory symbol_) {
391         _name = name_;
392         _symbol = symbol_;
393     }
394 
395     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
396         return
397             interfaceId == type(IERC721).interfaceId ||
398             interfaceId == type(IERC721Metadata).interfaceId ||
399             super.supportsInterface(interfaceId);
400     }
401 
402     function balanceOf(address owner) public view virtual override returns (uint256) {
403         require(owner != address(0), "ERC721: balance query for the zero address");
404         return _balances[owner];
405     }
406 
407     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
408         address owner = _owners[tokenId];
409         require(owner != address(0), "ERC721: owner query for nonexistent token");
410         return owner;
411     }
412 
413     function name() public view virtual override returns (string memory) {
414         return _name;
415     }
416 
417     function symbol() public view virtual override returns (string memory) {
418         return _symbol;
419     }
420 
421     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
422         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
423 
424         string memory baseURI = _baseURI();
425         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
426     }
427 
428     function _baseURI() internal view virtual returns (string memory) {
429         return "";
430     }
431 
432     function approve(address to, uint256 tokenId) public virtual override {
433         address owner = ERC721.ownerOf(tokenId);
434         require(to != owner, "ERC721: approval to current owner");
435 
436         require(
437             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
438             "ERC721: approve caller is not owner nor approved for all"
439         );
440 
441         _approve(to, tokenId);
442     }
443 
444     function getApproved(uint256 tokenId) public view virtual override returns (address) {
445         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
446 
447         return _tokenApprovals[tokenId];
448     }
449 
450     function setApprovalForAll(address operator, bool approved) public virtual override {
451         _setApprovalForAll(_msgSender(), operator, approved);
452     }
453 
454     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
455         return _operatorApprovals[owner][operator];
456     }
457 
458     function transferFrom(
459         address from,
460         address to,
461         uint256 tokenId
462     ) public virtual override {
463         //solhint-disable-next-line max-line-length
464         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
465 
466         _transfer(from, to, tokenId);
467     }
468 
469     function safeTransferFrom(
470         address from,
471         address to,
472         uint256 tokenId
473     ) public virtual override {
474         safeTransferFrom(from, to, tokenId, "");
475     }
476 
477     function safeTransferFrom(
478         address from,
479         address to,
480         uint256 tokenId,
481         bytes memory _data
482     ) public virtual override {
483         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
484         _safeTransfer(from, to, tokenId, _data);
485     }
486 
487     function _safeTransfer(
488         address from,
489         address to,
490         uint256 tokenId,
491         bytes memory _data
492     ) internal virtual {
493         _transfer(from, to, tokenId);
494         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
495     }
496 
497     function _exists(uint256 tokenId) internal view virtual returns (bool) {
498         return _owners[tokenId] != address(0);
499     }
500 
501     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
502         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
503         address owner = ERC721.ownerOf(tokenId);
504         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
505     }
506 
507     function _safeMint(address to, uint256 tokenId) internal virtual {
508         _safeMint(to, tokenId, "");
509     }
510 
511     function _safeMint(
512         address to,
513         uint256 tokenId,
514         bytes memory _data
515     ) internal virtual {
516         _mint(to, tokenId);
517         require(
518             _checkOnERC721Received(address(0), to, tokenId, _data),
519             "ERC721: transfer to non ERC721Receiver implementer"
520         );
521     }
522 
523     function _mint(address to, uint256 tokenId) internal virtual {
524         require(to != address(0), "ERC721: mint to the zero address");
525         require(!_exists(tokenId), "ERC721: token already minted");
526 
527         _beforeTokenTransfer(address(0), to, tokenId);
528 
529         _balances[to] += 1;
530         _owners[tokenId] = to;
531 
532         emit Transfer(address(0), to, tokenId);
533     }
534 
535     function _burn(uint256 tokenId) internal virtual {
536         address owner = ERC721.ownerOf(tokenId);
537 
538         _beforeTokenTransfer(owner, address(0), tokenId);
539 
540         _approve(address(0), tokenId);
541 
542         _balances[owner] -= 1;
543         delete _owners[tokenId];
544 
545         emit Transfer(owner, address(0), tokenId);
546     }
547 
548     function _transfer(
549         address from,
550         address to,
551         uint256 tokenId
552     ) internal virtual {
553         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
554         require(to != address(0), "ERC721: transfer to the zero address");
555 
556         _beforeTokenTransfer(from, to, tokenId);
557 
558         _approve(address(0), tokenId);
559 
560         _balances[from] -= 1;
561         _balances[to] += 1;
562         _owners[tokenId] = to;
563 
564         emit Transfer(from, to, tokenId);
565     }
566 
567     function _approve(address to, uint256 tokenId) internal virtual {
568         _tokenApprovals[tokenId] = to;
569         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
570     }
571 
572     function _setApprovalForAll(
573         address owner,
574         address operator,
575         bool approved
576     ) internal virtual {
577         require(owner != operator, "ERC721: approve to caller");
578         _operatorApprovals[owner][operator] = approved;
579         emit ApprovalForAll(owner, operator, approved);
580     }
581    
582     function _checkOnERC721Received(
583         address from,
584         address to,
585         uint256 tokenId,
586         bytes memory _data
587     ) private returns (bool) {
588         if (to.isContract()) {
589             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
590                 return retval == IERC721Receiver.onERC721Received.selector;
591             } catch (bytes memory reason) {
592                 if (reason.length == 0) {
593                     revert("ERC721: transfer to non ERC721Receiver implementer");
594                 } else {
595                     assembly {
596                         revert(add(32, reason), mload(reason))
597                     }
598                 }
599             }
600         } else {
601             return true;
602         }
603     }
604 
605     function _beforeTokenTransfer(
606         address from,
607         address to,
608         uint256 tokenId
609     ) internal virtual {}
610 }
611 
612 pragma solidity >=0.7.0 <0.9.0;
613 
614 
615 
616 
617 contract DeadDiamondSociety is ERC721, Ownable {
618   using Strings for uint256;
619   using Counters for Counters.Counter;
620 
621   Counters.Counter private supply;
622 
623   string public uriPrefix = "";
624   string public uriSuffix = ".json";
625   string public hiddenMetadataUri;
626   
627   uint256 public cost = 0 ether;
628   uint256 public maxSupply = 2500;
629   uint256 public maxMintAmountPerTx = 250;
630   uint256 public nftPerAddressLimit = 250;
631 
632   bool public paused = true;
633   bool public revealed = false;
634   bool public onlyWhitelisted = true;
635   address[] public whitelistedAddressess;
636 
637   constructor() ERC721("DeadDiamondSociety", "DDS") {
638     setHiddenMetadataUri("ipfs://QmVQYsJFd7FbmyNuLfVPTMuYzBTq64tqCspEBSKLhgFf1b/hidden.json");
639   }
640 
641   modifier mintCompliance(uint256 _mintAmount) {
642     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
643     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
644     _;
645   }
646 
647   function totalSupply() public view returns (uint256) {
648     return supply.current();
649   }
650 
651   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
652     require(!paused, "The contract is paused!");
653     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
654     if (onlyWhitelisted == true) {
655         require(isWhitelisted(msg.sender), "User is not whitelisted");
656         uint256 ownerTokenCount = balanceOf(msg.sender);
657         require(ownerTokenCount < nftPerAddressLimit, "Max supply exceeded!");
658     }
659     _mintLoop(msg.sender, _mintAmount);
660   }
661   
662   function isWhitelisted(address _user) public view returns (bool) {
663         for(uint256 i = 0; i < whitelistedAddressess.length; i++ ) {
664             if (whitelistedAddressess[i] == _user) {
665                 return true;
666             }
667         }
668         return false;
669   }
670   
671   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
672     _mintLoop(_receiver, _mintAmount);
673   }
674 
675   function walletOfOwner(address _owner)
676     public
677     view
678     returns (uint256[] memory)
679   {
680     uint256 ownerTokenCount = balanceOf(_owner);
681     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
682     uint256 currentTokenId = 1;
683     uint256 ownedTokenIndex = 0;
684 
685     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
686       address currentTokenOwner = ownerOf(currentTokenId);
687 
688       if (currentTokenOwner == _owner) {
689         ownedTokenIds[ownedTokenIndex] = currentTokenId;
690 
691         ownedTokenIndex++;
692       }
693 
694       currentTokenId++;
695     }
696 
697     return ownedTokenIds;
698   }
699 
700   function tokenURI(uint256 _tokenId)
701     public
702     view
703     virtual
704     override
705     returns (string memory)
706   {
707     require(
708       _exists(_tokenId),
709       "ERC721Metadata: URI query for nonexistent token"
710     );
711 
712     if (revealed == false) {
713       return hiddenMetadataUri;
714     }
715 
716     string memory currentBaseURI = _baseURI();
717     return bytes(currentBaseURI).length > 0
718         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
719         : "";
720   }
721 
722   function setRevealed(bool _state) public onlyOwner {
723     revealed = _state;
724   }
725 
726   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
727     nftPerAddressLimit = _limit;
728   }
729   
730   function setCost(uint256 _cost) public onlyOwner {
731     cost = _cost;
732   }
733 
734   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
735     maxMintAmountPerTx = _maxMintAmountPerTx;
736   }
737 
738   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
739     hiddenMetadataUri = _hiddenMetadataUri;
740   }
741 
742   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
743     uriPrefix = _uriPrefix;
744   }
745 
746   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
747     uriSuffix = _uriSuffix;
748   }
749 
750   function setPaused(bool _state) public onlyOwner {
751     paused = _state;
752   }
753 
754   function setOnlyWhitelisted(bool _state) public onlyOwner {
755     onlyWhitelisted = _state;
756   }
757 
758   function whitelistUsers(address[] calldata _users) public onlyOwner {
759       delete whitelistedAddressess;
760       whitelistedAddressess = _users;
761   }
762 
763   function withdraw() public onlyOwner {
764     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
765     require(os);
766   }
767 
768   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
769     for (uint256 i = 0; i < _mintAmount; i++) {
770       supply.increment();
771       _safeMint(_receiver, supply.current());
772     }
773   }
774 
775   function _baseURI() internal view virtual override returns (string memory) {
776     return uriPrefix;
777   }
778 }