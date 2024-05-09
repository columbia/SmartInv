1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 /*
5                      .--------------.
6                 .---'  o        .    `---.
7              .-'    .    O  .         .   `-.
8           .-'     @@@@@@       .             `-.
9         .'@@   @@@@@@@@@@@       @@@@@@@   .    `.
10       .'@@@  @@@@@@@@@@@@@@     @@@@@@@@@         `.
11      /@@@  o @@@@@@@@@@@@@@     @@@@@@@@@     O     \
12     /        @@@@@@@@@@@@@@  @   @@@@@@@@@ @@     .  \
13    /@  o      @@@@@@@@@@@   .  @@  @@@@@@@@@@@     @@ \
14   /@@@      .   @@@@@@ o       @  @@@@@@@@@@@@@ o @@@@ \
15  /@@@@@                  @ .      @@@@@@@@@@@@@@  @@@@@ \
16  |@@@@@    O    `.-./  .        .  @@@@@@@@@@@@@   @@@  |
17 / @@@@@        --`-'       o        @@@@@@@@@@@ @@@    . \
18 |@ @@@@ .  @  @    `    @            @@      . @@@@@@    |
19 |   @@                         o    @@   .     @@@@@@    |
20 |  .     @   @ @       o              @@   o   @@@@@@.   |
21 \     @    @       @       .-.       @@@@       @@@      /
22  |  @    @  @              `-'     . @@@@     .    .    |
23  \ .  o       @  @@@@  .              @@  .           . /
24   \      @@@    @@@@@@       .                   o     /
25    \    @@@@@   @@\@@    /        O          .        /
26     \ o  @@@       \ \  /  __        .   .     .--.  /
27      \      .     . \.-.---                   `--'  /
28       `.             `-'      .                   .'
29         `.    o     / | `           O     .     .'
30           `-.      /  |        o             .-'
31              `-.          .         .     .-'
32                 `---.        .       .---'
33                      `--------------'
34 */
35 
36 // File: @openzeppelin/contracts/utils/Strings.sol
37 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
38 
39 pragma solidity ^0.8.0;
40 
41 
42 library Strings {
43     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
44 
45     function toString(uint256 value) internal pure returns (string memory) {
46 
47         if (value == 0) {
48             return "0";
49         }
50         uint256 temp = value;
51         uint256 digits;
52         while (temp != 0) {
53             digits++;
54             temp /= 10;
55         }
56         bytes memory buffer = new bytes(digits);
57         while (value != 0) {
58             digits -= 1;
59             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
60             value /= 10;
61         }
62         return string(buffer);
63     }
64 
65     function toHexString(uint256 value) internal pure returns (string memory) {
66         if (value == 0) {
67             return "0x00";
68         }
69         uint256 temp = value;
70         uint256 length = 0;
71         while (temp != 0) {
72             length++;
73             temp >>= 8;
74         }
75         return toHexString(value, length);
76     }
77 
78 
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 }
91 
92 // File: @openzeppelin/contracts/utils/Context.sol
93 
94 
95 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes calldata) {
106         return msg.data;
107     }
108 }
109 
110 // File: @openzeppelin/contracts/access/Ownable.sol
111 
112 
113 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     constructor() {
124         _transferOwnership(_msgSender());
125     }
126 
127  
128     function owner() public view virtual returns (address) {
129         return _owner;
130     }
131 
132 
133     modifier onlyOwner() {
134         require(owner() == _msgSender(), "Ownable: caller is not the owner");
135         _;
136     }
137 
138 
139     function renounceOwnership() public virtual onlyOwner {
140         _transferOwnership(address(0));
141     }
142 
143 
144     function transferOwnership(address newOwner) public virtual onlyOwner {
145         require(newOwner != address(0), "Ownable: new owner is the zero address");
146         _transferOwnership(newOwner);
147     }
148 
149 
150     function _transferOwnership(address newOwner) internal virtual {
151         address oldOwner = _owner;
152         _owner = newOwner;
153         emit OwnershipTransferred(oldOwner, newOwner);
154     }
155 }
156 
157 // File: @openzeppelin/contracts/utils/Address.sol
158 
159 
160 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
161 
162 pragma solidity ^0.8.0;
163 
164 
165 library Address {
166  
167     function isContract(address account) internal view returns (bool) {
168 
169 
170         uint256 size;
171         assembly {
172             size := extcodesize(account)
173         }
174         return size > 0;
175     }
176 
177 
178     function sendValue(address payable recipient, uint256 amount) internal {
179         require(address(this).balance >= amount, "Address: insufficient balance");
180 
181         (bool success, ) = recipient.call{value: amount}("");
182         require(success, "Address: unable to send value, recipient may have reverted");
183     }
184 
185 
186     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
187         return functionCall(target, data, "Address: low-level call failed");
188     }
189 
190 
191     function functionCall(
192         address target,
193         bytes memory data,
194         string memory errorMessage
195     ) internal returns (bytes memory) {
196         return functionCallWithValue(target, data, 0, errorMessage);
197     }
198 
199     function functionCallWithValue(
200         address target,
201         bytes memory data,
202         uint256 value
203     ) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
205     }
206 
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         require(address(this).balance >= value, "Address: insufficient balance for call");
214         require(isContract(target), "Address: call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.call{value: value}(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220 
221     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
222         return functionStaticCall(target, data, "Address: low-level static call failed");
223     }
224 
225     function functionStaticCall(
226         address target,
227         bytes memory data,
228         string memory errorMessage
229     ) internal view returns (bytes memory) {
230         require(isContract(target), "Address: static call to non-contract");
231 
232         (bool success, bytes memory returndata) = target.staticcall(data);
233         return verifyCallResult(success, returndata, errorMessage);
234     }
235 
236 
237     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
238         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
239     }
240 
241 
242     function functionDelegateCall(
243         address target,
244         bytes memory data,
245         string memory errorMessage
246     ) internal returns (bytes memory) {
247         require(isContract(target), "Address: delegate call to non-contract");
248 
249         (bool success, bytes memory returndata) = target.delegatecall(data);
250         return verifyCallResult(success, returndata, errorMessage);
251     }
252 
253 
254     function verifyCallResult(
255         bool success,
256         bytes memory returndata,
257         string memory errorMessage
258     ) internal pure returns (bytes memory) {
259         if (success) {
260             return returndata;
261         } else {
262             if (returndata.length > 0) {
263 
264                 assembly {
265                     let returndata_size := mload(returndata)
266                     revert(add(32, returndata), returndata_size)
267                 }
268             } else {
269                 revert(errorMessage);
270             }
271         }
272     }
273 }
274 
275 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 interface IERC721Receiver {
283 
284     function onERC721Received(
285         address operator,
286         address from,
287         uint256 tokenId,
288         bytes calldata data
289     ) external returns (bytes4);
290 }
291 
292 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 
300 interface IERC165 {
301 
302     function supportsInterface(bytes4 interfaceId) external view returns (bool);
303 }
304 
305 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 
313 abstract contract ERC165 is IERC165 {
314 
315     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
316         return interfaceId == type(IERC165).interfaceId;
317     }
318 }
319 
320 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
321 
322 
323 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
324 
325 pragma solidity ^0.8.0;
326 
327 
328 
329 interface IERC721 is IERC165 {
330 
331     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
332 
333 
334     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
335 
336 
337     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
338 
339 
340     function balanceOf(address owner) external view returns (uint256 balance);
341 
342 
343     function ownerOf(uint256 tokenId) external view returns (address owner);
344 
345 
346     function safeTransferFrom(
347         address from,
348         address to,
349         uint256 tokenId
350     ) external;
351 
352 
353     function transferFrom(
354         address from,
355         address to,
356         uint256 tokenId
357     ) external;
358 
359 
360     function approve(address to, uint256 tokenId) external;
361 
362 
363     function getApproved(uint256 tokenId) external view returns (address operator);
364 
365 
366     function setApprovalForAll(address operator, bool _approved) external;
367 
368     function isApprovedForAll(address owner, address operator) external view returns (bool);
369 
370 
371     function safeTransferFrom(
372         address from,
373         address to,
374         uint256 tokenId,
375         bytes calldata data
376     ) external;
377 }
378 
379 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
380 
381 
382 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
383 
384 pragma solidity ^0.8.0;
385 
386 
387 
388 interface IERC721Metadata is IERC721 {
389 
390     function name() external view returns (string memory);
391 
392 
393     function symbol() external view returns (string memory);
394 
395 
396     function tokenURI(uint256 tokenId) external view returns (string memory);
397 }
398 
399 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
400 
401 
402 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 
407 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
408     using Address for address;
409     using Strings for uint256;
410 
411     string private _name;
412 
413     string private _symbol;
414 
415     mapping(uint256 => address) private _owners;
416 
417     mapping(address => uint256) private _balances;
418 
419     mapping(uint256 => address) private _tokenApprovals;
420 
421     mapping(address => mapping(address => bool)) private _operatorApprovals;
422 
423     constructor(string memory name_, string memory symbol_) {
424         _name = name_;
425         _symbol = symbol_;
426     }
427 
428     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
429         return
430             interfaceId == type(IERC721).interfaceId ||
431             interfaceId == type(IERC721Metadata).interfaceId ||
432             super.supportsInterface(interfaceId);
433     }
434 
435 
436     function balanceOf(address owner) public view virtual override returns (uint256) {
437         require(owner != address(0), "ERC721: balance query for the zero address");
438         return _balances[owner];
439     }
440 
441     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
442         address owner = _owners[tokenId];
443         require(owner != address(0), "ERC721: owner query for nonexistent token");
444         return owner;
445     }
446 
447     function name() public view virtual override returns (string memory) {
448         return _name;
449     }
450 
451     function symbol() public view virtual override returns (string memory) {
452         return _symbol;
453     }
454 
455     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
456         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
457 
458         string memory moonURI = _moonURI();
459         return bytes(moonURI).length > 0 ? string(abi.encodePacked(moonURI, tokenId.toString())) : "";
460     }
461 
462 
463     function _moonURI() internal view virtual returns (string memory) {
464         return "";
465     }
466 
467     function approve(address to, uint256 tokenId) public virtual override {
468         address owner = ERC721.ownerOf(tokenId);
469         require(to != owner, "ERC721: approval to current owner");
470 
471         require(
472             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
473             "ERC721: approve caller is not owner nor approved for all"
474         );
475 
476         _approve(to, tokenId);
477     }
478 
479     function getApproved(uint256 tokenId) public view virtual override returns (address) {
480         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
481 
482         return _tokenApprovals[tokenId];
483     }
484 
485 
486     function setApprovalForAll(address operator, bool approved) public virtual override {
487         _setApprovalForAll(_msgSender(), operator, approved);
488     }
489 
490 
491     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
492         return _operatorApprovals[owner][operator];
493     }
494 
495 
496     function transferFrom(
497         address from,
498         address to,
499         uint256 tokenId
500     ) public virtual override {
501 
502         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
503 
504         _transfer(from, to, tokenId);
505     }
506 
507 
508     function safeTransferFrom(
509         address from,
510         address to,
511         uint256 tokenId
512     ) public virtual override {
513         safeTransferFrom(from, to, tokenId, "");
514     }
515 
516 
517     function safeTransferFrom(
518         address from,
519         address to,
520         uint256 tokenId,
521         bytes memory _data
522     ) public virtual override {
523         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
524         _safeTransfer(from, to, tokenId, _data);
525     }
526 
527     function _safeTransfer(
528         address from,
529         address to,
530         uint256 tokenId,
531         bytes memory _data
532     ) internal virtual {
533         _transfer(from, to, tokenId);
534         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
535     }
536 
537  
538     function _exists(uint256 tokenId) internal view virtual returns (bool) {
539         return _owners[tokenId] != address(0);
540     }
541 
542     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
543         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
544         address owner = ERC721.ownerOf(tokenId);
545         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
546     }
547 
548     function _safeMint(address to, uint256 tokenId) internal virtual {
549         _safeMint(to, tokenId, "");
550     }
551 
552     function _safeMint(
553         address to,
554         uint256 tokenId,
555         bytes memory _data
556     ) internal virtual {
557         _mint(to, tokenId);
558         require(
559             _checkOnERC721Received(address(0), to, tokenId, _data),
560             "ERC721: transfer to non ERC721Receiver implementer"
561         );
562     }
563 
564 
565     function _mint(address to, uint256 tokenId) internal virtual {
566         require(to != address(0), "ERC721: mint to the zero address");
567         require(!_exists(tokenId), "ERC721: token already minted");
568 
569         _beforeTokenTransfer(address(0), to, tokenId);
570 
571         _balances[to] += 1;
572         _owners[tokenId] = to;
573 
574         emit Transfer(address(0), to, tokenId);
575     }
576 
577 
578     function _burn(uint256 tokenId) internal virtual {
579         address owner = ERC721.ownerOf(tokenId);
580 
581         _beforeTokenTransfer(owner, address(0), tokenId);
582 
583         // Clear approvals
584         _approve(address(0), tokenId);
585 
586         _balances[owner] -= 1;
587         delete _owners[tokenId];
588 
589         emit Transfer(owner, address(0), tokenId);
590     }
591 
592 
593     function _transfer(
594         address from,
595         address to,
596         uint256 tokenId
597     ) internal virtual {
598         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
599         require(to != address(0), "ERC721: transfer to the zero address");
600 
601         _beforeTokenTransfer(from, to, tokenId);
602 
603         _approve(address(0), tokenId);
604 
605         _balances[from] -= 1;
606         _balances[to] += 1;
607         _owners[tokenId] = to;
608 
609         emit Transfer(from, to, tokenId);
610     }
611 
612 
613     function _approve(address to, uint256 tokenId) internal virtual {
614         _tokenApprovals[tokenId] = to;
615         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
616     }
617 
618     function _setApprovalForAll(
619         address owner,
620         address operator,
621         bool approved
622     ) internal virtual {
623         require(owner != operator, "ERC721: approve to caller");
624         _operatorApprovals[owner][operator] = approved;
625         emit ApprovalForAll(owner, operator, approved);
626     }
627 
628 
629     function _checkOnERC721Received(
630         address from,
631         address to,
632         uint256 tokenId,
633         bytes memory _data
634     ) private returns (bool) {
635         if (to.isContract()) {
636             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
637                 return retval == IERC721Receiver.onERC721Received.selector;
638             } catch (bytes memory reason) {
639                 if (reason.length == 0) {
640                     revert("ERC721: transfer to non ERC721Receiver implementer");
641                 } else {
642                     assembly {
643                         revert(add(32, reason), mload(reason))
644                     }
645                 }
646             }
647         } else {
648             return true;
649         }
650     }
651 
652 
653     function _beforeTokenTransfer(
654         address from,
655         address to,
656         uint256 tokenId
657     ) internal virtual {}
658 }
659 
660 // File: @openzeppelin/contracts/utils/Counters.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 
668 library Counters {
669     struct Counter {
670 
671         uint256 _value; // default: 0
672     }
673 
674     function current(Counter storage counter) internal view returns (uint256) {
675         return counter._value;
676     }
677 
678     function increment(Counter storage counter) internal {
679         unchecked {
680             counter._value += 1;
681         }
682     }
683 
684     function decrement(Counter storage counter) internal {
685         uint256 value = counter._value;
686         require(value > 0, "Counter: decrement overflow");
687         unchecked {
688             counter._value = value - 1;
689         }
690     }
691 
692     function reset(Counter storage counter) internal {
693         counter._value = 0;
694     }
695 }
696 
697 // File: .deps/Moonclones.sol
698 
699 
700 pragma solidity >=0.7.0 <0.9.0;
701 
702 
703 contract Moonclones is ERC721, Ownable {
704   using Counters for Counters.Counter;  
705   using Strings for uint256;
706 
707   Counters.Counter private _tokenSupply;
708   string public moonURI;
709   string public moonExtension = ".json"; 
710   uint256 public cost = 0.002 ether; 
711   uint256 public maxSupply = 4444; 
712   uint256 public freeMints = 2222; 
713   uint256 public maxMintAmount = 20; 
714   bool public paused = false;
715   bool public revealed = true;
716   string public ClonesUri;
717   mapping(address => bool) public whitelisted;
718   mapping(address => uint256) private freeMintsWallet;
719 
720   constructor(
721     string memory _name,
722     string memory _symbol,
723     string memory _initMoonURI,
724     string memory _initClonesUri
725   ) ERC721(_name, _symbol) {
726     setMoonURI(_initMoonURI);
727     setClonesURI(_initClonesUri);
728   }
729 
730   function totalSupply() public view returns (uint256) {
731     return _tokenSupply.current();
732   }
733 
734   // internal
735   function _moonURI() internal view virtual override returns (string memory) {
736     return moonURI;
737   }
738   
739   // public
740   function mint(address _to, uint256 _mintAmount) public payable {
741     uint256 supply = _tokenSupply.current();
742     require(!paused);
743     require(_mintAmount > 0);
744     require(_mintAmount <= maxMintAmount);
745     require(supply + _mintAmount <= maxSupply);
746 
747     if (supply + _mintAmount > freeMints) {
748       if(whitelisted[msg.sender] != true) {
749         require(msg.value >= cost * _mintAmount);
750       }
751     }
752     else {
753         require(
754             supply + _mintAmount <= freeMints,
755             "You would exceed the number of free mints"
756         );
757         require(
758             freeMintsWallet[msg.sender] + _mintAmount <= maxMintAmount,
759             "You can only mint 20 assets for free!"
760         );
761         freeMintsWallet[msg.sender] += _mintAmount;
762     }
763 
764     for (uint256 i = 1; i <= _mintAmount; i++) {
765        _tokenSupply.increment();
766       _safeMint(_to, supply + i);
767     }
768   }
769 
770   function tokenURI(uint256 tokenId)
771     public
772     view
773     virtual
774     override
775     returns (string memory)
776   {
777     require(
778       _exists(tokenId),
779       "ERC721Metadata: URI query for nonexistent token"
780     );
781     
782     if(revealed == false) {
783         return ClonesUri;
784     }
785 
786     string memory currentMoonURI = _moonURI();
787     return bytes(currentMoonURI).length > 0
788         ? string(abi.encodePacked(currentMoonURI, tokenId.toString(), moonExtension))
789         : "";
790   }
791 
792   //only owner
793   function reveal() public onlyOwner {
794       revealed = true;
795   }
796   
797   function setCost(uint256 _newCost) public onlyOwner {
798     cost = _newCost;
799   }
800 
801   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
802     maxMintAmount = _newmaxMintAmount;
803   }
804   
805   function setClonesURI(string memory _ClonesURI) public onlyOwner {
806     ClonesUri = _ClonesURI;
807   }
808 
809   function setMoonURI(string memory _newMoonURI) public onlyOwner {
810     moonURI = _newMoonURI;
811   }
812 
813   function setMoonExtension(string memory _newMoonExtension) public onlyOwner {
814     moonExtension = _newMoonExtension;
815   }
816 
817   function pause(bool _state) public onlyOwner {
818     paused = _state;
819   }
820  
821  function whitelistUser(address _user) public onlyOwner {
822     whitelisted[_user] = true;
823   }
824  
825   function removeWhitelistUser(address _user) public onlyOwner {
826     whitelisted[_user] = false;
827   }
828 
829   function withdraw() public payable onlyOwner {
830 
831     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
832     require(os);
833 
834   }
835 }