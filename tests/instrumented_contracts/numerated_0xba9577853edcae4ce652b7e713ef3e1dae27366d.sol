1 // SPDX-License-Identifier: GPL-3.0
2 
3 /*
4 
5     _____       __                                   ______                                          _                    __                        _________                        __         
6    |_   _|     [  |                                 |_   _ `.                                       / \                  [  |                      |  _   _  |                      |  ]        
7      | |  .--.  | |--.   _ .--.   _ .--.    _   __    | | `. \ .---.  _ .--.   _ .--.   .--.       / _ \     _ .--..--.   | |.--.   .---.  _ .--.  |_/ | | \_|__   _   _ .--.   .--.| |  .--.   
8  _   | |/ .'`\ \| .-. | [ `.-. | [ `.-. |  [ \ [  ]   | |  | |/ /__\\[ '/'`\ \[ '/'`\ \( (`\]     / ___ \   [ `.-. .-. |  | '/'`\ \/ /__\\[ `/'`\]     | |   [  | | | [ `/'`\]/ /'`\' | ( (`\]  
9 | |__' || \__. || | | |  | | | |  | | | |   \ '/ /   _| |_.' /| \__., | \__/ | | \__/ | `'.'.   _/ /   \ \_  | | | | | |  |  \__/ || \__., | |        _| |_   | \_/ |, | |    | \__/  |  `'.'.  
10 `.____.' '.__.'[___]|__][___||__][___||__][\_:  /   |______.'  '.__.' | ;.__/  | ;.__/ [\__) ) |____| |____|[___||__||__][__;.__.'  '.__.'[___]      |_____|  '.__.'_/[___]    '.__.;__][\__) ) 
11                                            \__.'                     [__|     [__|                                                                                                              
12 
13 */
14 
15 
16 // File: @openzeppelin/contracts/utils/Strings.sol
17 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 
22 library Strings {
23     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
24 
25     function toString(uint256 value) internal pure returns (string memory) {
26 
27         if (value == 0) {
28             return "0";
29         }
30         uint256 temp = value;
31         uint256 digits;
32         while (temp != 0) {
33             digits++;
34             temp /= 10;
35         }
36         bytes memory buffer = new bytes(digits);
37         while (value != 0) {
38             digits -= 1;
39             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
40             value /= 10;
41         }
42         return string(buffer);
43     }
44 
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58 
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 
80 abstract contract Context {
81     function _msgSender() internal view virtual returns (address) {
82         return msg.sender;
83     }
84 
85     function _msgData() internal view virtual returns (bytes calldata) {
86         return msg.data;
87     }
88 }
89 
90 // File: @openzeppelin/contracts/access/Ownable.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 
98 abstract contract Ownable is Context {
99     address private _owner;
100 
101     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
102 
103     constructor() {
104         _transferOwnership(_msgSender());
105     }
106 
107  
108     function owner() public view virtual returns (address) {
109         return _owner;
110     }
111 
112 
113     modifier onlyOwner() {
114         require(owner() == _msgSender(), "Ownable: caller is not the owner");
115         _;
116     }
117 
118 
119     function renounceOwnership() public virtual onlyOwner {
120         _transferOwnership(address(0));
121     }
122 
123 
124     function transferOwnership(address newOwner) public virtual onlyOwner {
125         require(newOwner != address(0), "Ownable: new owner is the zero address");
126         _transferOwnership(newOwner);
127     }
128 
129 
130     function _transferOwnership(address newOwner) internal virtual {
131         address oldOwner = _owner;
132         _owner = newOwner;
133         emit OwnershipTransferred(oldOwner, newOwner);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Address.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 
145 library Address {
146  
147     function isContract(address account) internal view returns (bool) {
148 
149 
150         uint256 size;
151         assembly {
152             size := extcodesize(account)
153         }
154         return size > 0;
155     }
156 
157 
158     function sendValue(address payable recipient, uint256 amount) internal {
159         require(address(this).balance >= amount, "Address: insufficient balance");
160 
161         (bool success, ) = recipient.call{value: amount}("");
162         require(success, "Address: unable to send value, recipient may have reverted");
163     }
164 
165 
166     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
167         return functionCall(target, data, "Address: low-level call failed");
168     }
169 
170 
171     function functionCall(
172         address target,
173         bytes memory data,
174         string memory errorMessage
175     ) internal returns (bytes memory) {
176         return functionCallWithValue(target, data, 0, errorMessage);
177     }
178 
179     function functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 value
183     ) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
185     }
186 
187     function functionCallWithValue(
188         address target,
189         bytes memory data,
190         uint256 value,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(address(this).balance >= value, "Address: insufficient balance for call");
194         require(isContract(target), "Address: call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.call{value: value}(data);
197         return verifyCallResult(success, returndata, errorMessage);
198     }
199 
200 
201     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
202         return functionStaticCall(target, data, "Address: low-level static call failed");
203     }
204 
205     function functionStaticCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal view returns (bytes memory) {
210         require(isContract(target), "Address: static call to non-contract");
211 
212         (bool success, bytes memory returndata) = target.staticcall(data);
213         return verifyCallResult(success, returndata, errorMessage);
214     }
215 
216 
217     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
218         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
219     }
220 
221 
222     function functionDelegateCall(
223         address target,
224         bytes memory data,
225         string memory errorMessage
226     ) internal returns (bytes memory) {
227         require(isContract(target), "Address: delegate call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.delegatecall(data);
230         return verifyCallResult(success, returndata, errorMessage);
231     }
232 
233 
234     function verifyCallResult(
235         bool success,
236         bytes memory returndata,
237         string memory errorMessage
238     ) internal pure returns (bytes memory) {
239         if (success) {
240             return returndata;
241         } else {
242             if (returndata.length > 0) {
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
255 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
256 
257 
258 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 interface IERC721Receiver {
263 
264     function onERC721Received(
265         address operator,
266         address from,
267         uint256 tokenId,
268         bytes calldata data
269     ) external returns (bytes4);
270 }
271 
272 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
273 
274 
275 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 
280 interface IERC165 {
281 
282     function supportsInterface(bytes4 interfaceId) external view returns (bool);
283 }
284 
285 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
286 
287 
288 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
289 
290 pragma solidity ^0.8.0;
291 
292 
293 abstract contract ERC165 is IERC165 {
294 
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
308 
309 interface IERC721 is IERC165 {
310 
311     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
312 
313 
314     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
315 
316 
317     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
318 
319 
320     function balanceOf(address owner) external view returns (uint256 balance);
321 
322 
323     function ownerOf(uint256 tokenId) external view returns (address owner);
324 
325 
326     function safeTransferFrom(
327         address from,
328         address to,
329         uint256 tokenId
330     ) external;
331 
332 
333     function transferFrom(
334         address from,
335         address to,
336         uint256 tokenId
337     ) external;
338 
339 
340     function approve(address to, uint256 tokenId) external;
341 
342 
343     function getApproved(uint256 tokenId) external view returns (address operator);
344 
345 
346     function setApprovalForAll(address operator, bool _approved) external;
347 
348     function isApprovedForAll(address owner, address operator) external view returns (bool);
349 
350 
351     function safeTransferFrom(
352         address from,
353         address to,
354         uint256 tokenId,
355         bytes calldata data
356     ) external;
357 }
358 
359 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
360 
361 
362 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 
367 
368 interface IERC721Metadata is IERC721 {
369 
370     function name() external view returns (string memory);
371 
372 
373     function symbol() external view returns (string memory);
374 
375 
376     function tokenURI(uint256 tokenId) external view returns (string memory);
377 }
378 
379 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
380 
381 
382 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
383 
384 pragma solidity ^0.8.0;
385 
386 
387 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
388     using Address for address;
389     using Strings for uint256;
390 
391     string private _name;
392 
393     string private _symbol;
394 
395     mapping(uint256 => address) private _owners;
396 
397     mapping(address => uint256) private _balances;
398 
399     mapping(uint256 => address) private _tokenApprovals;
400 
401     mapping(address => mapping(address => bool)) private _operatorApprovals;
402 
403     constructor(string memory name_, string memory symbol_) {
404         _name = name_;
405         _symbol = symbol_;
406     }
407 
408     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
409         return
410             interfaceId == type(IERC721).interfaceId ||
411             interfaceId == type(IERC721Metadata).interfaceId ||
412             super.supportsInterface(interfaceId);
413     }
414 
415 
416     function balanceOf(address owner) public view virtual override returns (uint256) {
417         require(owner != address(0), "ERC721: balance query for the zero address");
418         return _balances[owner];
419     }
420 
421     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
422         address owner = _owners[tokenId];
423         require(owner != address(0), "ERC721: owner query for nonexistent token");
424         return owner;
425     }
426 
427     function name() public view virtual override returns (string memory) {
428         return _name;
429     }
430 
431     function symbol() public view virtual override returns (string memory) {
432         return _symbol;
433     }
434 
435     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
436         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
437 
438         string memory turdsURI = _turdsURI();
439         return bytes(turdsURI).length > 0 ? string(abi.encodePacked(turdsURI, tokenId.toString())) : "";
440     }
441 
442 
443     function _turdsURI() internal view virtual returns (string memory) {
444         return "";
445     }
446 
447     function approve(address to, uint256 tokenId) public virtual override {
448         address owner = ERC721.ownerOf(tokenId);
449         require(to != owner, "ERC721: approval to current owner");
450 
451         require(
452             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
453             "ERC721: approve caller is not owner nor approved for all"
454         );
455 
456         _approve(to, tokenId);
457     }
458 
459     function getApproved(uint256 tokenId) public view virtual override returns (address) {
460         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
461 
462         return _tokenApprovals[tokenId];
463     }
464 
465 
466     function setApprovalForAll(address operator, bool approved) public virtual override {
467         _setApprovalForAll(_msgSender(), operator, approved);
468     }
469 
470 
471     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
472         return _operatorApprovals[owner][operator];
473     }
474 
475 
476     function transferFrom(
477         address from,
478         address to,
479         uint256 tokenId
480     ) public virtual override {
481 
482         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
483 
484         _transfer(from, to, tokenId);
485     }
486 
487 
488     function safeTransferFrom(
489         address from,
490         address to,
491         uint256 tokenId
492     ) public virtual override {
493         safeTransferFrom(from, to, tokenId, "");
494     }
495 
496 
497     function safeTransferFrom(
498         address from,
499         address to,
500         uint256 tokenId,
501         bytes memory _data
502     ) public virtual override {
503         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
504         _safeTransfer(from, to, tokenId, _data);
505     }
506 
507     function _safeTransfer(
508         address from,
509         address to,
510         uint256 tokenId,
511         bytes memory _data
512     ) internal virtual {
513         _transfer(from, to, tokenId);
514         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
515     }
516 
517  
518     function _exists(uint256 tokenId) internal view virtual returns (bool) {
519         return _owners[tokenId] != address(0);
520     }
521 
522     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
523         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
524         address owner = ERC721.ownerOf(tokenId);
525         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
526     }
527 
528     function _safeMint(address to, uint256 tokenId) internal virtual {
529         _safeMint(to, tokenId, "");
530     }
531 
532     function _safeMint(
533         address to,
534         uint256 tokenId,
535         bytes memory _data
536     ) internal virtual {
537         _mint(to, tokenId);
538         require(
539             _checkOnERC721Received(address(0), to, tokenId, _data),
540             "ERC721: transfer to non ERC721Receiver implementer"
541         );
542     }
543 
544 
545     function _mint(address to, uint256 tokenId) internal virtual {
546         require(to != address(0), "ERC721: mint to the zero address");
547         require(!_exists(tokenId), "ERC721: token already minted");
548 
549         _beforeTokenTransfer(address(0), to, tokenId);
550 
551         _balances[to] += 1;
552         _owners[tokenId] = to;
553 
554         emit Transfer(address(0), to, tokenId);
555     }
556 
557 
558     function _burn(uint256 tokenId) internal virtual {
559         address owner = ERC721.ownerOf(tokenId);
560 
561         _beforeTokenTransfer(owner, address(0), tokenId);
562 
563         // Clear approvals
564         _approve(address(0), tokenId);
565 
566         _balances[owner] -= 1;
567         delete _owners[tokenId];
568 
569         emit Transfer(owner, address(0), tokenId);
570     }
571 
572 
573     function _transfer(
574         address from,
575         address to,
576         uint256 tokenId
577     ) internal virtual {
578         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
579         require(to != address(0), "ERC721: transfer to the zero address");
580 
581         _beforeTokenTransfer(from, to, tokenId);
582 
583         _approve(address(0), tokenId);
584 
585         _balances[from] -= 1;
586         _balances[to] += 1;
587         _owners[tokenId] = to;
588 
589         emit Transfer(from, to, tokenId);
590     }
591 
592 
593     function _approve(address to, uint256 tokenId) internal virtual {
594         _tokenApprovals[tokenId] = to;
595         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
596     }
597 
598     function _setApprovalForAll(
599         address owner,
600         address operator,
601         bool approved
602     ) internal virtual {
603         require(owner != operator, "ERC721: approve to caller");
604         _operatorApprovals[owner][operator] = approved;
605         emit ApprovalForAll(owner, operator, approved);
606     }
607 
608 
609     function _checkOnERC721Received(
610         address from,
611         address to,
612         uint256 tokenId,
613         bytes memory _data
614     ) private returns (bool) {
615         if (to.isContract()) {
616             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
617                 return retval == IERC721Receiver.onERC721Received.selector;
618             } catch (bytes memory reason) {
619                 if (reason.length == 0) {
620                     revert("ERC721: transfer to non ERC721Receiver implementer");
621                 } else {
622                     assembly {
623                         revert(add(32, reason), mload(reason))
624                     }
625                 }
626             }
627         } else {
628             return true;
629         }
630     }
631 
632 
633     function _beforeTokenTransfer(
634         address from,
635         address to,
636         uint256 tokenId
637     ) internal virtual {}
638 }
639 
640 // File: @openzeppelin/contracts/utils/Counters.sol
641 
642 
643 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 
648 library Counters {
649     struct Counter {
650 
651         uint256 _value; // default: 0
652     }
653 
654     function current(Counter storage counter) internal view returns (uint256) {
655         return counter._value;
656     }
657 
658     function increment(Counter storage counter) internal {
659         unchecked {
660             counter._value += 1;
661         }
662     }
663 
664     function decrement(Counter storage counter) internal {
665         uint256 value = counter._value;
666         require(value > 0, "Counter: decrement overflow");
667         unchecked {
668             counter._value = value - 1;
669         }
670     }
671 
672     function reset(Counter storage counter) internal {
673         counter._value = 0;
674     }
675 }
676 
677 // File: .deps/JDAmberTurds.sol
678 
679 
680 pragma solidity >=0.7.0 <0.9.0;
681 
682 
683 contract JDAmberTurds is ERC721, Ownable {
684   using Counters for Counters.Counter;  
685   using Strings for uint256;
686 
687   Counters.Counter private _tokenSupply;
688   string public turdsURI;
689   string public turdsExtension = ".json"; 
690   uint256 public cost = 0.002 ether; 
691   uint256 public maxSupply = 5000; 
692   uint256 public freeMints = 1500; 
693   uint256 public maxMintAmount = 10; 
694   bool public paused = false;
695   bool public revealed = false;
696   string public DeppUri;
697   mapping(address => bool) public whitelisted;
698   mapping(address => uint256) private freeMintsWallet;
699 
700   constructor(
701     string memory _name,
702     string memory _symbol,
703     string memory _initTurdsURI,
704     string memory _initDeppUri
705   ) ERC721(_name, _symbol) {
706     setTurdsURI(_initTurdsURI);
707     setDeppURI(_initDeppUri);
708   }
709 
710   function totalSupply() public view returns (uint256) {
711     return _tokenSupply.current();
712   }
713 
714   // internal
715   function _turdsURI() internal view virtual override returns (string memory) {
716     return turdsURI;
717   }
718   
719   // public
720   function mint(address _to, uint256 _mintAmount) public payable {
721     uint256 supply = _tokenSupply.current();
722     require(!paused);
723     require(_mintAmount > 0);
724     require(_mintAmount <= maxMintAmount);
725     require(supply + _mintAmount <= maxSupply);
726 
727     if (supply + _mintAmount > freeMints) {
728       if(whitelisted[msg.sender] != true) {
729         require(msg.value >= cost * _mintAmount);
730       }
731     }
732     else {
733         require(
734             supply + _mintAmount <= freeMints,
735             "You would exceed the number of free mints"
736         );
737         require(
738             freeMintsWallet[msg.sender] + _mintAmount <= maxMintAmount,
739             "You can only mint 20 assets for free!"
740         );
741         freeMintsWallet[msg.sender] += _mintAmount;
742     }
743 
744     for (uint256 i = 1; i <= _mintAmount; i++) {
745        _tokenSupply.increment();
746       _safeMint(_to, supply + i);
747     }
748   }
749 
750   function tokenURI(uint256 tokenId)
751     public
752     view
753     virtual
754     override
755     returns (string memory)
756   {
757     require(
758       _exists(tokenId),
759       "ERC721Metadata: URI query for nonexistent token"
760     );
761     
762     if(revealed == false) {
763         return DeppUri;
764     }
765 
766     string memory currentTurdsURI = _turdsURI();
767     return bytes(currentTurdsURI).length > 0
768         ? string(abi.encodePacked(currentTurdsURI, tokenId.toString(), turdsExtension))
769         : "";
770   }
771 
772   //only owner
773   function reveal() public onlyOwner {
774       revealed = true;
775   }
776   
777   function setCost(uint256 _newCost) public onlyOwner {
778     cost = _newCost;
779   }
780 
781   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
782     maxMintAmount = _newmaxMintAmount;
783   }
784   
785   function setDeppURI(string memory _DeppURI) public onlyOwner {
786     DeppUri = _DeppURI;
787   }
788 
789   function setTurdsURI(string memory _newTurdsURI) public onlyOwner {
790     turdsURI = _newTurdsURI;
791   }
792 
793   function setTurdsExtension(string memory _newTurdsExtension) public onlyOwner {
794     turdsExtension = _newTurdsExtension;
795   }
796 
797   function pause(bool _state) public onlyOwner {
798     paused = _state;
799   }
800  
801  function whitelistUser(address _user) public onlyOwner {
802     whitelisted[_user] = true;
803   }
804  
805   function removeWhitelistUser(address _user) public onlyOwner {
806     whitelisted[_user] = false;
807   }
808 
809   function withdraw() public payable onlyOwner {
810 
811     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
812     require(os);
813 
814   }
815 }