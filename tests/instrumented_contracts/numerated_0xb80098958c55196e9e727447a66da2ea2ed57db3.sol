1 // SPDX-License-Identifier: GPL-3.0
2 
3 /*
4 // MOONBABIES: The affordable Moonbirds baby version PFP.
5 // www.moonbirds.baby
6 */
7 
8 // File: @openzeppelin/contracts/utils/Strings.sol
9 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     function toString(uint256 value) internal pure returns (string memory) {
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37     function toHexString(uint256 value) internal pure returns (string memory) {
38         if (value == 0) {
39             return "0x00";
40         }
41         uint256 temp = value;
42         uint256 length = 0;
43         while (temp != 0) {
44             length++;
45             temp >>= 8;
46         }
47         return toHexString(value, length);
48     }
49 
50 
51     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
52         bytes memory buffer = new bytes(2 * length + 2);
53         buffer[0] = "0";
54         buffer[1] = "x";
55         for (uint256 i = 2 * length + 1; i > 1; --i) {
56             buffer[i] = _HEX_SYMBOLS[value & 0xf];
57             value >>= 4;
58         }
59         require(value == 0, "Strings: hex length insufficient");
60         return string(buffer);
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/Context.sol
65 
66 
67 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 
72 abstract contract Context {
73     function _msgSender() internal view virtual returns (address) {
74         return msg.sender;
75     }
76 
77     function _msgData() internal view virtual returns (bytes calldata) {
78         return msg.data;
79     }
80 }
81 
82 // File: @openzeppelin/contracts/access/Ownable.sol
83 
84 
85 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
86 
87 pragma solidity ^0.8.0;
88 
89 
90 abstract contract Ownable is Context {
91     address private _owner;
92 
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95     constructor() {
96         _transferOwnership(_msgSender());
97     }
98 
99  
100     function owner() public view virtual returns (address) {
101         return _owner;
102     }
103 
104 
105     modifier onlyOwner() {
106         require(owner() == _msgSender(), "Ownable: caller is not the owner");
107         _;
108     }
109 
110 
111     function renounceOwnership() public virtual onlyOwner {
112         _transferOwnership(address(0));
113     }
114 
115 
116     function transferOwnership(address newOwner) public virtual onlyOwner {
117         require(newOwner != address(0), "Ownable: new owner is the zero address");
118         _transferOwnership(newOwner);
119     }
120 
121 
122     function _transferOwnership(address newOwner) internal virtual {
123         address oldOwner = _owner;
124         _owner = newOwner;
125         emit OwnershipTransferred(oldOwner, newOwner);
126     }
127 }
128 
129 // File: @openzeppelin/contracts/utils/Address.sol
130 
131 
132 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
133 
134 pragma solidity ^0.8.0;
135 
136 
137 library Address {
138  
139     function isContract(address account) internal view returns (bool) {
140 
141 
142         uint256 size;
143         assembly {
144             size := extcodesize(account)
145         }
146         return size > 0;
147     }
148 
149 
150     function sendValue(address payable recipient, uint256 amount) internal {
151         require(address(this).balance >= amount, "Address: insufficient balance");
152 
153         (bool success, ) = recipient.call{value: amount}("");
154         require(success, "Address: unable to send value, recipient may have reverted");
155     }
156 
157 
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162 
163     function functionCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal returns (bytes memory) {
168         return functionCallWithValue(target, data, 0, errorMessage);
169     }
170 
171     function functionCallWithValue(
172         address target,
173         bytes memory data,
174         uint256 value
175     ) internal returns (bytes memory) {
176         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
177     }
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
197     function functionStaticCall(
198         address target,
199         bytes memory data,
200         string memory errorMessage
201     ) internal view returns (bytes memory) {
202         require(isContract(target), "Address: static call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.staticcall(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208 
209     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
210         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
211     }
212 
213 
214     function functionDelegateCall(
215         address target,
216         bytes memory data,
217         string memory errorMessage
218     ) internal returns (bytes memory) {
219         require(isContract(target), "Address: delegate call to non-contract");
220 
221         (bool success, bytes memory returndata) = target.delegatecall(data);
222         return verifyCallResult(success, returndata, errorMessage);
223     }
224 
225 
226     function verifyCallResult(
227         bool success,
228         bytes memory returndata,
229         string memory errorMessage
230     ) internal pure returns (bytes memory) {
231         if (success) {
232             return returndata;
233         } else {
234             if (returndata.length > 0) {
235 
236                 assembly {
237                     let returndata_size := mload(returndata)
238                     revert(add(32, returndata), returndata_size)
239                 }
240             } else {
241                 revert(errorMessage);
242             }
243         }
244     }
245 }
246 
247 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
248 
249 
250 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
251 
252 pragma solidity ^0.8.0;
253 
254 interface IERC721Receiver {
255 
256     function onERC721Received(
257         address operator,
258         address from,
259         uint256 tokenId,
260         bytes calldata data
261     ) external returns (bytes4);
262 }
263 
264 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
265 
266 
267 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
268 
269 pragma solidity ^0.8.0;
270 
271 
272 interface IERC165 {
273 
274     function supportsInterface(bytes4 interfaceId) external view returns (bool);
275 }
276 
277 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
278 
279 
280 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 
285 abstract contract ERC165 is IERC165 {
286 
287     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
288         return interfaceId == type(IERC165).interfaceId;
289     }
290 }
291 
292 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 
300 
301 interface IERC721 is IERC165 {
302 
303     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
304 
305 
306     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
307 
308 
309     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
310 
311 
312     function balanceOf(address owner) external view returns (uint256 balance);
313 
314 
315     function ownerOf(uint256 tokenId) external view returns (address owner);
316 
317 
318     function safeTransferFrom(
319         address from,
320         address to,
321         uint256 tokenId
322     ) external;
323 
324 
325     function transferFrom(
326         address from,
327         address to,
328         uint256 tokenId
329     ) external;
330 
331 
332     function approve(address to, uint256 tokenId) external;
333 
334 
335     function getApproved(uint256 tokenId) external view returns (address operator);
336 
337 
338     function setApprovalForAll(address operator, bool _approved) external;
339 
340     function isApprovedForAll(address owner, address operator) external view returns (bool);
341 
342 
343     function safeTransferFrom(
344         address from,
345         address to,
346         uint256 tokenId,
347         bytes calldata data
348     ) external;
349 }
350 
351 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
352 
353 
354 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 
359 
360 interface IERC721Metadata is IERC721 {
361 
362     function name() external view returns (string memory);
363 
364 
365     function symbol() external view returns (string memory);
366 
367 
368     function tokenURI(uint256 tokenId) external view returns (string memory);
369 }
370 
371 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
372 
373 
374 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 
379 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
380     using Address for address;
381     using Strings for uint256;
382 
383     string private _name;
384 
385     string private _symbol;
386 
387     mapping(uint256 => address) private _owners;
388 
389     mapping(address => uint256) private _balances;
390 
391     mapping(uint256 => address) private _tokenApprovals;
392 
393     mapping(address => mapping(address => bool)) private _operatorApprovals;
394 
395     constructor(string memory name_, string memory symbol_) {
396         _name = name_;
397         _symbol = symbol_;
398     }
399 
400     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
401         return
402             interfaceId == type(IERC721).interfaceId ||
403             interfaceId == type(IERC721Metadata).interfaceId ||
404             super.supportsInterface(interfaceId);
405     }
406 
407 
408     function balanceOf(address owner) public view virtual override returns (uint256) {
409         require(owner != address(0), "ERC721: balance query for the zero address");
410         return _balances[owner];
411     }
412 
413     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
414         address owner = _owners[tokenId];
415         require(owner != address(0), "ERC721: owner query for nonexistent token");
416         return owner;
417     }
418 
419     function name() public view virtual override returns (string memory) {
420         return _name;
421     }
422 
423     function symbol() public view virtual override returns (string memory) {
424         return _symbol;
425     }
426 
427     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
428         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
429 
430         string memory mainURI = _mainURI();
431         return bytes(mainURI).length > 0 ? string(abi.encodePacked(mainURI, tokenId.toString())) : "";
432     }
433 
434 
435     function _mainURI() internal view virtual returns (string memory) {
436         return "";
437     }
438 
439     function approve(address to, uint256 tokenId) public virtual override {
440         address owner = ERC721.ownerOf(tokenId);
441         require(to != owner, "ERC721: approval to current owner");
442 
443         require(
444             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
445             "ERC721: approve caller is not owner nor approved for all"
446         );
447 
448         _approve(to, tokenId);
449     }
450 
451     function getApproved(uint256 tokenId) public view virtual override returns (address) {
452         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
453 
454         return _tokenApprovals[tokenId];
455     }
456 
457 
458     function setApprovalForAll(address operator, bool approved) public virtual override {
459         _setApprovalForAll(_msgSender(), operator, approved);
460     }
461 
462 
463     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
464         return _operatorApprovals[owner][operator];
465     }
466 
467 
468     function transferFrom(
469         address from,
470         address to,
471         uint256 tokenId
472     ) public virtual override {
473 
474         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
475 
476         _transfer(from, to, tokenId);
477     }
478 
479 
480     function safeTransferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) public virtual override {
485         safeTransferFrom(from, to, tokenId, "");
486     }
487 
488 
489     function safeTransferFrom(
490         address from,
491         address to,
492         uint256 tokenId,
493         bytes memory _data
494     ) public virtual override {
495         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
496         _safeTransfer(from, to, tokenId, _data);
497     }
498 
499     function _safeTransfer(
500         address from,
501         address to,
502         uint256 tokenId,
503         bytes memory _data
504     ) internal virtual {
505         _transfer(from, to, tokenId);
506         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
507     }
508 
509  
510     function _exists(uint256 tokenId) internal view virtual returns (bool) {
511         return _owners[tokenId] != address(0);
512     }
513 
514     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
515         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
516         address owner = ERC721.ownerOf(tokenId);
517         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
518     }
519 
520     function _safeMint(address to, uint256 tokenId) internal virtual {
521         _safeMint(to, tokenId, "");
522     }
523 
524 
525     function _safeMint(
526         address to,
527         uint256 tokenId,
528         bytes memory _data
529     ) internal virtual {
530         _mint(to, tokenId);
531         require(
532             _checkOnERC721Received(address(0), to, tokenId, _data),
533             "ERC721: transfer to non ERC721Receiver implementer"
534         );
535     }
536 
537 
538     function _mint(address to, uint256 tokenId) internal virtual {
539         require(to != address(0), "ERC721: mint to the zero address");
540         require(!_exists(tokenId), "ERC721: token already minted");
541 
542         _beforeTokenTransfer(address(0), to, tokenId);
543 
544         _balances[to] += 1;
545         _owners[tokenId] = to;
546 
547         emit Transfer(address(0), to, tokenId);
548     }
549 
550 
551     function _burn(uint256 tokenId) internal virtual {
552         address owner = ERC721.ownerOf(tokenId);
553 
554         _beforeTokenTransfer(owner, address(0), tokenId);
555 
556         // Clear approvals
557         _approve(address(0), tokenId);
558 
559         _balances[owner] -= 1;
560         delete _owners[tokenId];
561 
562         emit Transfer(owner, address(0), tokenId);
563     }
564 
565 
566     function _transfer(
567         address from,
568         address to,
569         uint256 tokenId
570     ) internal virtual {
571         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
572         require(to != address(0), "ERC721: transfer to the zero address");
573 
574         _beforeTokenTransfer(from, to, tokenId);
575 
576         _approve(address(0), tokenId);
577 
578         _balances[from] -= 1;
579         _balances[to] += 1;
580         _owners[tokenId] = to;
581 
582         emit Transfer(from, to, tokenId);
583     }
584 
585 
586     function _approve(address to, uint256 tokenId) internal virtual {
587         _tokenApprovals[tokenId] = to;
588         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
589     }
590 
591     function _setApprovalForAll(
592         address owner,
593         address operator,
594         bool approved
595     ) internal virtual {
596         require(owner != operator, "ERC721: approve to caller");
597         _operatorApprovals[owner][operator] = approved;
598         emit ApprovalForAll(owner, operator, approved);
599     }
600 
601 
602     function _checkOnERC721Received(
603         address from,
604         address to,
605         uint256 tokenId,
606         bytes memory _data
607     ) private returns (bool) {
608         if (to.isContract()) {
609             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
610                 return retval == IERC721Receiver.onERC721Received.selector;
611             } catch (bytes memory reason) {
612                 if (reason.length == 0) {
613                     revert("ERC721: transfer to non ERC721Receiver implementer");
614                 } else {
615                     assembly {
616                         revert(add(32, reason), mload(reason))
617                     }
618                 }
619             }
620         } else {
621             return true;
622         }
623     }
624 
625 
626     function _beforeTokenTransfer(
627         address from,
628         address to,
629         uint256 tokenId
630     ) internal virtual {}
631 }
632 
633 // File: @openzeppelin/contracts/utils/Counters.sol
634 
635 
636 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 
641 library Counters {
642     struct Counter {
643 
644         uint256 _value; // default: 0
645     }
646 
647     function current(Counter storage counter) internal view returns (uint256) {
648         return counter._value;
649     }
650 
651     function increment(Counter storage counter) internal {
652         unchecked {
653             counter._value += 1;
654         }
655     }
656 
657     function decrement(Counter storage counter) internal {
658         uint256 value = counter._value;
659         require(value > 0, "Counter: decrement overflow");
660         unchecked {
661             counter._value = value - 1;
662         }
663     }
664 
665     function reset(Counter storage counter) internal {
666         counter._value = 0;
667     }
668 }
669 
670 // File: .deps/Moonbabies.sol
671 
672 
673 pragma solidity >=0.7.0 <0.9.0;
674 
675 
676 contract Moonbabies is ERC721, Ownable {
677   using Counters for Counters.Counter;  // TotalSupply() substitution for Counters to relieve high gas fees.
678   using Strings for uint256;
679 
680   Counters.Counter private _tokenSupply;
681   string public mainURI;
682   string public mainExtension = ".json"; 
683   uint256 public cost = 0.01 ether; 
684   uint256 public maxSupply = 3000; 
685   uint256 public maxMintAmount = 20; 
686   bool public paused = false;
687   bool public revealed = true;
688   string public NotrevealedUri;
689   mapping(address => bool) public whitelisted;
690 
691   constructor(
692     string memory _name,
693     string memory _symbol,
694     string memory _initMainURI,
695     string memory _initNotrevealedUri
696   ) ERC721(_name, _symbol) {
697     setMainURI(_initMainURI);
698     setNotrevealedURI(_initNotrevealedUri);
699   }
700 
701   function totalSupply() public view returns (uint256) {
702     return _tokenSupply.current();
703   }
704 
705   // internal
706   function _mainURI() internal view virtual override returns (string memory) {
707     return mainURI;
708   }
709 
710   // public
711   function mint(address _to, uint256 _mintAmount) public payable {
712     uint256 supply = _tokenSupply.current();
713     require(!paused);
714     require(_mintAmount > 0);
715     require(_mintAmount <= maxMintAmount);
716     require(supply + _mintAmount <= maxSupply);
717 
718     if (msg.sender != owner()) {
719       if(whitelisted[msg.sender] != true) {
720         require(msg.value >= cost * _mintAmount);
721       }
722     }
723 
724     for (uint256 i = 1; i <= _mintAmount; i++) {
725        _tokenSupply.increment();
726       _safeMint(_to, supply + i);
727     }
728   }
729 
730   function tokenURI(uint256 tokenId)
731     public
732     view
733     virtual
734     override
735     returns (string memory)
736   {
737     require(
738       _exists(tokenId),
739       "ERC721Metadata: URI query for nonexistent token"
740     );
741     
742     if(revealed == false) {
743         return NotrevealedUri;
744     }
745 
746     string memory currentMainURI = _mainURI();
747     return bytes(currentMainURI).length > 0
748         ? string(abi.encodePacked(currentMainURI, tokenId.toString(), mainExtension))
749         : "";
750   }
751 
752   //only owner
753   function reveal() public onlyOwner {
754       revealed = true;
755   }
756   
757   function setCost(uint256 _newCost) public onlyOwner {
758     cost = _newCost;
759   }
760 
761   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
762     maxMintAmount = _newmaxMintAmount;
763   }
764   
765   function setNotrevealedURI(string memory _NotrevealedURI) public onlyOwner {
766     NotrevealedUri = _NotrevealedURI;
767   }
768 
769   function setMainURI(string memory _newMainURI) public onlyOwner {
770     mainURI = _newMainURI;
771   }
772 
773   function setMainExtension(string memory _newMainExtension) public onlyOwner {
774     mainExtension = _newMainExtension;
775   }
776 
777   function pause(bool _state) public onlyOwner {
778     paused = _state;
779   }
780  
781  function whitelistUser(address _user) public onlyOwner {
782     whitelisted[_user] = true;
783   }
784  
785   function removeWhitelistUser(address _user) public onlyOwner {
786     whitelisted[_user] = false;
787   }
788 
789   function withdraw() public payable onlyOwner {
790 
791     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
792     require(os);
793 
794   }
795 }