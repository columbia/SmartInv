1 // SPDX-License-Identifier: GPL-3.0
2 
3 /*
4 
5 NEON APE YACHT CLUB
6 www.neonapeyacht.club
7 www.twitter.com/NeonApeYC
8 
9 */
10 
11 // File: @openzeppelin/contracts/utils/Strings.sol
12 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19 
20     function toString(uint256 value) internal pure returns (string memory) {
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     function toHexString(uint256 value) internal pure returns (string memory) {
41         if (value == 0) {
42             return "0x00";
43         }
44         uint256 temp = value;
45         uint256 length = 0;
46         while (temp != 0) {
47             length++;
48             temp >>= 8;
49         }
50         return toHexString(value, length);
51     }
52 
53 
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Context.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 
75 abstract contract Context {
76     function _msgSender() internal view virtual returns (address) {
77         return msg.sender;
78     }
79 
80     function _msgData() internal view virtual returns (bytes calldata) {
81         return msg.data;
82     }
83 }
84 
85 // File: @openzeppelin/contracts/access/Ownable.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 
93 abstract contract Ownable is Context {
94     address private _owner;
95 
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     constructor() {
99         _transferOwnership(_msgSender());
100     }
101 
102  
103     function owner() public view virtual returns (address) {
104         return _owner;
105     }
106 
107 
108     modifier onlyOwner() {
109         require(owner() == _msgSender(), "Ownable: caller is not the owner");
110         _;
111     }
112 
113 
114     function renounceOwnership() public virtual onlyOwner {
115         _transferOwnership(address(0));
116     }
117 
118 
119     function transferOwnership(address newOwner) public virtual onlyOwner {
120         require(newOwner != address(0), "Ownable: new owner is the zero address");
121         _transferOwnership(newOwner);
122     }
123 
124 
125     function _transferOwnership(address newOwner) internal virtual {
126         address oldOwner = _owner;
127         _owner = newOwner;
128         emit OwnershipTransferred(oldOwner, newOwner);
129     }
130 }
131 
132 // File: @openzeppelin/contracts/utils/Address.sol
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 
140 library Address {
141  
142     function isContract(address account) internal view returns (bool) {
143 
144 
145         uint256 size;
146         assembly {
147             size := extcodesize(account)
148         }
149         return size > 0;
150     }
151 
152 
153     function sendValue(address payable recipient, uint256 amount) internal {
154         require(address(this).balance >= amount, "Address: insufficient balance");
155 
156         (bool success, ) = recipient.call{value: amount}("");
157         require(success, "Address: unable to send value, recipient may have reverted");
158     }
159 
160 
161     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
162         return functionCall(target, data, "Address: low-level call failed");
163     }
164 
165 
166     function functionCall(
167         address target,
168         bytes memory data,
169         string memory errorMessage
170     ) internal returns (bytes memory) {
171         return functionCallWithValue(target, data, 0, errorMessage);
172     }
173 
174     function functionCallWithValue(
175         address target,
176         bytes memory data,
177         uint256 value
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
180     }
181 
182     function functionCallWithValue(
183         address target,
184         bytes memory data,
185         uint256 value,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         require(address(this).balance >= value, "Address: insufficient balance for call");
189         require(isContract(target), "Address: call to non-contract");
190 
191         (bool success, bytes memory returndata) = target.call{value: value}(data);
192         return verifyCallResult(success, returndata, errorMessage);
193     }
194 
195 
196     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
197         return functionStaticCall(target, data, "Address: low-level static call failed");
198     }
199 
200     function functionStaticCall(
201         address target,
202         bytes memory data,
203         string memory errorMessage
204     ) internal view returns (bytes memory) {
205         require(isContract(target), "Address: static call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.staticcall(data);
208         return verifyCallResult(success, returndata, errorMessage);
209     }
210 
211 
212     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
213         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
214     }
215 
216 
217     function functionDelegateCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(isContract(target), "Address: delegate call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.delegatecall(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228 
229     function verifyCallResult(
230         bool success,
231         bytes memory returndata,
232         string memory errorMessage
233     ) internal pure returns (bytes memory) {
234         if (success) {
235             return returndata;
236         } else {
237             if (returndata.length > 0) {
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
250 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
251 
252 
253 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 interface IERC721Receiver {
258 
259     function onERC721Received(
260         address operator,
261         address from,
262         uint256 tokenId,
263         bytes calldata data
264     ) external returns (bytes4);
265 }
266 
267 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
268 
269 
270 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
271 
272 pragma solidity ^0.8.0;
273 
274 
275 interface IERC165 {
276 
277     function supportsInterface(bytes4 interfaceId) external view returns (bool);
278 }
279 
280 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
281 
282 
283 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 
288 abstract contract ERC165 is IERC165 {
289 
290     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
291         return interfaceId == type(IERC165).interfaceId;
292     }
293 }
294 
295 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
296 
297 
298 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 
303 
304 interface IERC721 is IERC165 {
305 
306     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
307 
308 
309     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
310 
311 
312     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
313 
314 
315     function balanceOf(address owner) external view returns (uint256 balance);
316 
317 
318     function ownerOf(uint256 tokenId) external view returns (address owner);
319 
320 
321     function safeTransferFrom(
322         address from,
323         address to,
324         uint256 tokenId
325     ) external;
326 
327 
328     function transferFrom(
329         address from,
330         address to,
331         uint256 tokenId
332     ) external;
333 
334 
335     function approve(address to, uint256 tokenId) external;
336 
337 
338     function getApproved(uint256 tokenId) external view returns (address operator);
339 
340 
341     function setApprovalForAll(address operator, bool _approved) external;
342 
343     function isApprovedForAll(address owner, address operator) external view returns (bool);
344 
345 
346     function safeTransferFrom(
347         address from,
348         address to,
349         uint256 tokenId,
350         bytes calldata data
351     ) external;
352 }
353 
354 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 
362 
363 interface IERC721Metadata is IERC721 {
364 
365     function name() external view returns (string memory);
366 
367 
368     function symbol() external view returns (string memory);
369 
370 
371     function tokenURI(uint256 tokenId) external view returns (string memory);
372 }
373 
374 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
375 
376 
377 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 
382 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
383     using Address for address;
384     using Strings for uint256;
385 
386     string private _name;
387 
388     string private _symbol;
389 
390     mapping(uint256 => address) private _owners;
391 
392     mapping(address => uint256) private _balances;
393 
394     mapping(uint256 => address) private _tokenApprovals;
395 
396     mapping(address => mapping(address => bool)) private _operatorApprovals;
397 
398     constructor(string memory name_, string memory symbol_) {
399         _name = name_;
400         _symbol = symbol_;
401     }
402 
403     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
404         return
405             interfaceId == type(IERC721).interfaceId ||
406             interfaceId == type(IERC721Metadata).interfaceId ||
407             super.supportsInterface(interfaceId);
408     }
409 
410 
411     function balanceOf(address owner) public view virtual override returns (uint256) {
412         require(owner != address(0), "ERC721: balance query for the zero address");
413         return _balances[owner];
414     }
415 
416     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
417         address owner = _owners[tokenId];
418         require(owner != address(0), "ERC721: owner query for nonexistent token");
419         return owner;
420     }
421 
422     function name() public view virtual override returns (string memory) {
423         return _name;
424     }
425 
426     function symbol() public view virtual override returns (string memory) {
427         return _symbol;
428     }
429 
430     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
431         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
432 
433         string memory neonURI = _neonURI();
434         return bytes(neonURI).length > 0 ? string(abi.encodePacked(neonURI, tokenId.toString())) : "";
435     }
436 
437 
438     function _neonURI() internal view virtual returns (string memory) {
439         return "";
440     }
441 
442     function approve(address to, uint256 tokenId) public virtual override {
443         address owner = ERC721.ownerOf(tokenId);
444         require(to != owner, "ERC721: approval to current owner");
445 
446         require(
447             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
448             "ERC721: approve caller is not owner nor approved for all"
449         );
450 
451         _approve(to, tokenId);
452     }
453 
454     function getApproved(uint256 tokenId) public view virtual override returns (address) {
455         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
456 
457         return _tokenApprovals[tokenId];
458     }
459 
460 
461     function setApprovalForAll(address operator, bool approved) public virtual override {
462         _setApprovalForAll(_msgSender(), operator, approved);
463     }
464 
465 
466     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
467         return _operatorApprovals[owner][operator];
468     }
469 
470 
471     function transferFrom(
472         address from,
473         address to,
474         uint256 tokenId
475     ) public virtual override {
476 
477         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
478 
479         _transfer(from, to, tokenId);
480     }
481 
482 
483     function safeTransferFrom(
484         address from,
485         address to,
486         uint256 tokenId
487     ) public virtual override {
488         safeTransferFrom(from, to, tokenId, "");
489     }
490 
491 
492     function safeTransferFrom(
493         address from,
494         address to,
495         uint256 tokenId,
496         bytes memory _data
497     ) public virtual override {
498         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
499         _safeTransfer(from, to, tokenId, _data);
500     }
501 
502     function _safeTransfer(
503         address from,
504         address to,
505         uint256 tokenId,
506         bytes memory _data
507     ) internal virtual {
508         _transfer(from, to, tokenId);
509         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
510     }
511 
512  
513     function _exists(uint256 tokenId) internal view virtual returns (bool) {
514         return _owners[tokenId] != address(0);
515     }
516 
517     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
518         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
519         address owner = ERC721.ownerOf(tokenId);
520         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
521     }
522 
523     function _safeMint(address to, uint256 tokenId) internal virtual {
524         _safeMint(to, tokenId, "");
525     }
526 
527     function _safeMint(
528         address to,
529         uint256 tokenId,
530         bytes memory _data
531     ) internal virtual {
532         _mint(to, tokenId);
533         require(
534             _checkOnERC721Received(address(0), to, tokenId, _data),
535             "ERC721: transfer to non ERC721Receiver implementer"
536         );
537     }
538 
539 
540     function _mint(address to, uint256 tokenId) internal virtual {
541         require(to != address(0), "ERC721: mint to the zero address");
542         require(!_exists(tokenId), "ERC721: token already minted");
543 
544         _beforeTokenTransfer(address(0), to, tokenId);
545 
546         _balances[to] += 1;
547         _owners[tokenId] = to;
548 
549         emit Transfer(address(0), to, tokenId);
550     }
551 
552 
553     function _burn(uint256 tokenId) internal virtual {
554         address owner = ERC721.ownerOf(tokenId);
555 
556         _beforeTokenTransfer(owner, address(0), tokenId);
557 
558         // Clear approvals
559         _approve(address(0), tokenId);
560 
561         _balances[owner] -= 1;
562         delete _owners[tokenId];
563 
564         emit Transfer(owner, address(0), tokenId);
565     }
566 
567 
568     function _transfer(
569         address from,
570         address to,
571         uint256 tokenId
572     ) internal virtual {
573         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
574         require(to != address(0), "ERC721: transfer to the zero address");
575 
576         _beforeTokenTransfer(from, to, tokenId);
577 
578         _approve(address(0), tokenId);
579 
580         _balances[from] -= 1;
581         _balances[to] += 1;
582         _owners[tokenId] = to;
583 
584         emit Transfer(from, to, tokenId);
585     }
586 
587 
588     function _approve(address to, uint256 tokenId) internal virtual {
589         _tokenApprovals[tokenId] = to;
590         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
591     }
592 
593     function _setApprovalForAll(
594         address owner,
595         address operator,
596         bool approved
597     ) internal virtual {
598         require(owner != operator, "ERC721: approve to caller");
599         _operatorApprovals[owner][operator] = approved;
600         emit ApprovalForAll(owner, operator, approved);
601     }
602 
603 
604     function _checkOnERC721Received(
605         address from,
606         address to,
607         uint256 tokenId,
608         bytes memory _data
609     ) private returns (bool) {
610         if (to.isContract()) {
611             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
612                 return retval == IERC721Receiver.onERC721Received.selector;
613             } catch (bytes memory reason) {
614                 if (reason.length == 0) {
615                     revert("ERC721: transfer to non ERC721Receiver implementer");
616                 } else {
617                     assembly {
618                         revert(add(32, reason), mload(reason))
619                     }
620                 }
621             }
622         } else {
623             return true;
624         }
625     }
626 
627 
628     function _beforeTokenTransfer(
629         address from,
630         address to,
631         uint256 tokenId
632     ) internal virtual {}
633 }
634 
635 // File: @openzeppelin/contracts/utils/Counters.sol
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 library Counters {
644     struct Counter {
645 
646         uint256 _value; // default: 0
647     }
648 
649     function current(Counter storage counter) internal view returns (uint256) {
650         return counter._value;
651     }
652 
653     function increment(Counter storage counter) internal {
654         unchecked {
655             counter._value += 1;
656         }
657     }
658 
659     function decrement(Counter storage counter) internal {
660         uint256 value = counter._value;
661         require(value > 0, "Counter: decrement overflow");
662         unchecked {
663             counter._value = value - 1;
664         }
665     }
666 
667     function reset(Counter storage counter) internal {
668         counter._value = 0;
669     }
670 }
671 
672 // File: .deps/NeonApeYachtClub.sol
673 
674 
675 pragma solidity >=0.7.0 <0.9.0;
676 
677 
678 contract NeonApeYachtClub is ERC721, Ownable {
679   using Counters for Counters.Counter;  // cheaper gas fees!
680   using Strings for uint256;
681 
682   Counters.Counter private _tokenSupply;
683   string public neonURI;
684   string public neonExtension = ".json"; 
685   uint256 public cost = 0.006 ether; 
686   uint256 public maxSupply = 6666; 
687   uint256 public freeMints = 2222; 
688   uint256 public maxMintAmount = 10; 
689   bool public paused = false;
690   bool public revealed = false;
691   string public ApeUri;
692   mapping(address => bool) public whitelisted;
693   mapping(address => uint256) private freeMintsWallet;
694 
695   constructor(
696     string memory _name,
697     string memory _symbol,
698     string memory _initNeonURI,
699     string memory _initApeUri
700   ) ERC721(_name, _symbol) {
701     setNeonURI(_initNeonURI);
702     setApeURI(_initApeUri);
703   }
704 
705   function totalSupply() public view returns (uint256) {
706     return _tokenSupply.current();
707   }
708 
709   // internal
710   function _neonURI() internal view virtual override returns (string memory) {
711     return neonURI;
712   }
713   
714   // public
715   function mint(address _to, uint256 _mintAmount) public payable {
716     uint256 supply = _tokenSupply.current();
717     require(!paused);
718     require(_mintAmount > 0);
719     require(_mintAmount <= maxMintAmount);
720     require(supply + _mintAmount <= maxSupply);
721 
722     if (supply + _mintAmount > freeMints) {
723       if(whitelisted[msg.sender] != true) {
724         require(msg.value >= cost * _mintAmount);
725       }
726     }
727     else {
728         require(
729             supply + _mintAmount <= freeMints,
730             "You would exceed the number of free mints"
731         );
732         require(
733             freeMintsWallet[msg.sender] + _mintAmount <= maxMintAmount,
734             "You can only mint 20 assets for free!"
735         );
736         freeMintsWallet[msg.sender] += _mintAmount;
737     }
738 
739     for (uint256 i = 1; i <= _mintAmount; i++) {
740        _tokenSupply.increment();
741       _safeMint(_to, supply + i);
742     }
743   }
744 
745   function tokenURI(uint256 tokenId)
746     public
747     view
748     virtual
749     override
750     returns (string memory)
751   {
752     require(
753       _exists(tokenId),
754       "ERC721Metadata: URI query for nonexistent token"
755     );
756     
757     if(revealed == false) {
758         return ApeUri;
759     }
760 
761     string memory currentNeonURI = _neonURI();
762     return bytes(currentNeonURI).length > 0
763         ? string(abi.encodePacked(currentNeonURI, tokenId.toString(), neonExtension))
764         : "";
765   }
766 
767   //only owner
768   function reveal() public onlyOwner {
769       revealed = true;
770   }
771   
772   function setCost(uint256 _newCost) public onlyOwner {
773     cost = _newCost;
774   }
775 
776   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
777     maxMintAmount = _newmaxMintAmount;
778   }
779   
780   function setApeURI(string memory _ApeURI) public onlyOwner {
781     ApeUri = _ApeURI;
782   }
783 
784   function setNeonURI(string memory _newNeonURI) public onlyOwner {
785     neonURI = _newNeonURI;
786   }
787 
788   function setNeonExtension(string memory _newNeonExtension) public onlyOwner {
789     neonExtension = _newNeonExtension;
790   }
791 
792   function pause(bool _state) public onlyOwner {
793     paused = _state;
794   }
795  
796  function whitelistUser(address _user) public onlyOwner {
797     whitelisted[_user] = true;
798   }
799  
800   function removeWhitelistUser(address _user) public onlyOwner {
801     whitelisted[_user] = false;
802   }
803 
804   function withdraw() public payable onlyOwner {
805 
806     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
807     require(os);
808 
809   }
810 }