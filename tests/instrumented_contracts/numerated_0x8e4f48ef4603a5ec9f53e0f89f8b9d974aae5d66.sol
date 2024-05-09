1 // SPDX-License-Identifier: GPL-3.0
2 
3 /*
4 
5                 _                           _    __ 
6   _ _ _  _ __ _| |_ _____ __ ___ _  __ __ _| |_ / _|
7  | '_| || / _` |  _/ _ \ V  V / ' \ \ V  V /  _|  _|
8  |_|  \_,_\__, |\__\___/\_/\_/|_||_(_)_/\_/ \__|_|  
9           |___/                                     
10 
11     www.rugtown.wtf
12     www.twitter.com/rugtownwtf
13 
14     Rug Town is a carefully constructed collection of highly accurate hyper realized digital
15     depictions portraying the most prolifically ruthless rug pullers this blockchain has ever
16     intertwined with, 5% secondary royalties, 4% of which goes towards victims of real rug pulls.
17 
18 */
19 
20 // File: @openzeppelin/contracts/utils/Strings.sol
21 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 
26 library Strings {
27     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
28 
29     function toString(uint256 value) internal pure returns (string memory) {
30 
31         if (value == 0) {
32             return "0";
33         }
34         uint256 temp = value;
35         uint256 digits;
36         while (temp != 0) {
37             digits++;
38             temp /= 10;
39         }
40         bytes memory buffer = new bytes(digits);
41         while (value != 0) {
42             digits -= 1;
43             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44             value /= 10;
45         }
46         return string(buffer);
47     }
48 
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62 
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Context.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 // File: @openzeppelin/contracts/access/Ownable.sol
95 
96 
97 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 
102 abstract contract Ownable is Context {
103     address private _owner;
104 
105     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
106 
107     constructor() {
108         _transferOwnership(_msgSender());
109     }
110 
111  
112     function owner() public view virtual returns (address) {
113         return _owner;
114     }
115 
116 
117     modifier onlyOwner() {
118         require(owner() == _msgSender(), "Ownable: caller is not the owner");
119         _;
120     }
121 
122 
123     function renounceOwnership() public virtual onlyOwner {
124         _transferOwnership(address(0));
125     }
126 
127 
128     function transferOwnership(address newOwner) public virtual onlyOwner {
129         require(newOwner != address(0), "Ownable: new owner is the zero address");
130         _transferOwnership(newOwner);
131     }
132 
133 
134     function _transferOwnership(address newOwner) internal virtual {
135         address oldOwner = _owner;
136         _owner = newOwner;
137         emit OwnershipTransferred(oldOwner, newOwner);
138     }
139 }
140 
141 // File: @openzeppelin/contracts/utils/Address.sol
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 
149 library Address {
150  
151     function isContract(address account) internal view returns (bool) {
152 
153 
154         uint256 size;
155         assembly {
156             size := extcodesize(account)
157         }
158         return size > 0;
159     }
160 
161 
162     function sendValue(address payable recipient, uint256 amount) internal {
163         require(address(this).balance >= amount, "Address: insufficient balance");
164 
165         (bool success, ) = recipient.call{value: amount}("");
166         require(success, "Address: unable to send value, recipient may have reverted");
167     }
168 
169 
170     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
171         return functionCall(target, data, "Address: low-level call failed");
172     }
173 
174 
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     function functionCallWithValue(
184         address target,
185         bytes memory data,
186         uint256 value
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
189     }
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
209     function functionStaticCall(
210         address target,
211         bytes memory data,
212         string memory errorMessage
213     ) internal view returns (bytes memory) {
214         require(isContract(target), "Address: static call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.staticcall(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220 
221     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
222         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
223     }
224 
225 
226     function functionDelegateCall(
227         address target,
228         bytes memory data,
229         string memory errorMessage
230     ) internal returns (bytes memory) {
231         require(isContract(target), "Address: delegate call to non-contract");
232 
233         (bool success, bytes memory returndata) = target.delegatecall(data);
234         return verifyCallResult(success, returndata, errorMessage);
235     }
236 
237 
238     function verifyCallResult(
239         bool success,
240         bytes memory returndata,
241         string memory errorMessage
242     ) internal pure returns (bytes memory) {
243         if (success) {
244             return returndata;
245         } else {
246             if (returndata.length > 0) {
247 
248                 assembly {
249                     let returndata_size := mload(returndata)
250                     revert(add(32, returndata), returndata_size)
251                 }
252             } else {
253                 revert(errorMessage);
254             }
255         }
256     }
257 }
258 
259 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
260 
261 
262 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 interface IERC721Receiver {
267 
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
282 
283 
284 interface IERC165 {
285 
286     function supportsInterface(bytes4 interfaceId) external view returns (bool);
287 }
288 
289 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
290 
291 
292 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
293 
294 pragma solidity ^0.8.0;
295 
296 
297 abstract contract ERC165 is IERC165 {
298 
299     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300         return interfaceId == type(IERC165).interfaceId;
301     }
302 }
303 
304 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
305 
306 
307 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 
312 
313 interface IERC721 is IERC165 {
314 
315     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
316 
317 
318     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
319 
320 
321     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
322 
323 
324     function balanceOf(address owner) external view returns (uint256 balance);
325 
326 
327     function ownerOf(uint256 tokenId) external view returns (address owner);
328 
329 
330     function safeTransferFrom(
331         address from,
332         address to,
333         uint256 tokenId
334     ) external;
335 
336 
337     function transferFrom(
338         address from,
339         address to,
340         uint256 tokenId
341     ) external;
342 
343 
344     function approve(address to, uint256 tokenId) external;
345 
346 
347     function getApproved(uint256 tokenId) external view returns (address operator);
348 
349 
350     function setApprovalForAll(address operator, bool _approved) external;
351 
352     function isApprovedForAll(address owner, address operator) external view returns (bool);
353 
354 
355     function safeTransferFrom(
356         address from,
357         address to,
358         uint256 tokenId,
359         bytes calldata data
360     ) external;
361 }
362 
363 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
364 
365 
366 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 
371 
372 interface IERC721Metadata is IERC721 {
373 
374     function name() external view returns (string memory);
375 
376 
377     function symbol() external view returns (string memory);
378 
379 
380     function tokenURI(uint256 tokenId) external view returns (string memory);
381 }
382 
383 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
384 
385 
386 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 
391 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
392     using Address for address;
393     using Strings for uint256;
394 
395     string private _name;
396 
397     string private _symbol;
398 
399     mapping(uint256 => address) private _owners;
400 
401     mapping(address => uint256) private _balances;
402 
403     mapping(uint256 => address) private _tokenApprovals;
404 
405     mapping(address => mapping(address => bool)) private _operatorApprovals;
406 
407     constructor(string memory name_, string memory symbol_) {
408         _name = name_;
409         _symbol = symbol_;
410     }
411 
412     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
413         return
414             interfaceId == type(IERC721).interfaceId ||
415             interfaceId == type(IERC721Metadata).interfaceId ||
416             super.supportsInterface(interfaceId);
417     }
418 
419 
420     function balanceOf(address owner) public view virtual override returns (uint256) {
421         require(owner != address(0), "ERC721: balance query for the zero address");
422         return _balances[owner];
423     }
424 
425     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
426         address owner = _owners[tokenId];
427         require(owner != address(0), "ERC721: owner query for nonexistent token");
428         return owner;
429     }
430 
431     function name() public view virtual override returns (string memory) {
432         return _name;
433     }
434 
435     function symbol() public view virtual override returns (string memory) {
436         return _symbol;
437     }
438 
439     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
440         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
441 
442         string memory rugproofURI = _rugproofURI();
443         return bytes(rugproofURI).length > 0 ? string(abi.encodePacked(rugproofURI, tokenId.toString())) : "";
444     }
445 
446 
447     function _rugproofURI() internal view virtual returns (string memory) {
448         return "";
449     }
450 
451     function approve(address to, uint256 tokenId) public virtual override {
452         address owner = ERC721.ownerOf(tokenId);
453         require(to != owner, "ERC721: approval to current owner");
454 
455         require(
456             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
457             "ERC721: approve caller is not owner nor approved for all"
458         );
459 
460         _approve(to, tokenId);
461     }
462 
463     function getApproved(uint256 tokenId) public view virtual override returns (address) {
464         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
465 
466         return _tokenApprovals[tokenId];
467     }
468 
469 
470     function setApprovalForAll(address operator, bool approved) public virtual override {
471         _setApprovalForAll(_msgSender(), operator, approved);
472     }
473 
474 
475     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
476         return _operatorApprovals[owner][operator];
477     }
478 
479 
480     function transferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) public virtual override {
485 
486         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
487 
488         _transfer(from, to, tokenId);
489     }
490 
491 
492     function safeTransferFrom(
493         address from,
494         address to,
495         uint256 tokenId
496     ) public virtual override {
497         safeTransferFrom(from, to, tokenId, "");
498     }
499 
500 
501     function safeTransferFrom(
502         address from,
503         address to,
504         uint256 tokenId,
505         bytes memory _data
506     ) public virtual override {
507         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
508         _safeTransfer(from, to, tokenId, _data);
509     }
510 
511     function _safeTransfer(
512         address from,
513         address to,
514         uint256 tokenId,
515         bytes memory _data
516     ) internal virtual {
517         _transfer(from, to, tokenId);
518         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
519     }
520 
521  
522     function _exists(uint256 tokenId) internal view virtual returns (bool) {
523         return _owners[tokenId] != address(0);
524     }
525 
526     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
527         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
528         address owner = ERC721.ownerOf(tokenId);
529         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
530     }
531 
532     function _safeMint(address to, uint256 tokenId) internal virtual {
533         _safeMint(to, tokenId, "");
534     }
535 
536     function _safeMint(
537         address to,
538         uint256 tokenId,
539         bytes memory _data
540     ) internal virtual {
541         _mint(to, tokenId);
542         require(
543             _checkOnERC721Received(address(0), to, tokenId, _data),
544             "ERC721: transfer to non ERC721Receiver implementer"
545         );
546     }
547 
548 
549     function _mint(address to, uint256 tokenId) internal virtual {
550         require(to != address(0), "ERC721: mint to the zero address");
551         require(!_exists(tokenId), "ERC721: token already minted");
552 
553         _beforeTokenTransfer(address(0), to, tokenId);
554 
555         _balances[to] += 1;
556         _owners[tokenId] = to;
557 
558         emit Transfer(address(0), to, tokenId);
559     }
560 
561 
562     function _burn(uint256 tokenId) internal virtual {
563         address owner = ERC721.ownerOf(tokenId);
564 
565         _beforeTokenTransfer(owner, address(0), tokenId);
566 
567         // Clear approvals
568         _approve(address(0), tokenId);
569 
570         _balances[owner] -= 1;
571         delete _owners[tokenId];
572 
573         emit Transfer(owner, address(0), tokenId);
574     }
575 
576 
577     function _transfer(
578         address from,
579         address to,
580         uint256 tokenId
581     ) internal virtual {
582         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
583         require(to != address(0), "ERC721: transfer to the zero address");
584 
585         _beforeTokenTransfer(from, to, tokenId);
586 
587         _approve(address(0), tokenId);
588 
589         _balances[from] -= 1;
590         _balances[to] += 1;
591         _owners[tokenId] = to;
592 
593         emit Transfer(from, to, tokenId);
594     }
595 
596 
597     function _approve(address to, uint256 tokenId) internal virtual {
598         _tokenApprovals[tokenId] = to;
599         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
600     }
601 
602     function _setApprovalForAll(
603         address owner,
604         address operator,
605         bool approved
606     ) internal virtual {
607         require(owner != operator, "ERC721: approve to caller");
608         _operatorApprovals[owner][operator] = approved;
609         emit ApprovalForAll(owner, operator, approved);
610     }
611 
612 
613     function _checkOnERC721Received(
614         address from,
615         address to,
616         uint256 tokenId,
617         bytes memory _data
618     ) private returns (bool) {
619         if (to.isContract()) {
620             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
621                 return retval == IERC721Receiver.onERC721Received.selector;
622             } catch (bytes memory reason) {
623                 if (reason.length == 0) {
624                     revert("ERC721: transfer to non ERC721Receiver implementer");
625                 } else {
626                     assembly {
627                         revert(add(32, reason), mload(reason))
628                     }
629                 }
630             }
631         } else {
632             return true;
633         }
634     }
635 
636 
637     function _beforeTokenTransfer(
638         address from,
639         address to,
640         uint256 tokenId
641     ) internal virtual {}
642 }
643 
644 // File: @openzeppelin/contracts/utils/Counters.sol
645 
646 
647 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
648 
649 pragma solidity ^0.8.0;
650 
651 
652 library Counters {
653     struct Counter {
654 
655         uint256 _value; // default: 0
656     }
657 
658     function current(Counter storage counter) internal view returns (uint256) {
659         return counter._value;
660     }
661 
662     function increment(Counter storage counter) internal {
663         unchecked {
664             counter._value += 1;
665         }
666     }
667 
668     function decrement(Counter storage counter) internal {
669         uint256 value = counter._value;
670         require(value > 0, "Counter: decrement overflow");
671         unchecked {
672             counter._value = value - 1;
673         }
674     }
675 
676     function reset(Counter storage counter) internal {
677         counter._value = 0;
678     }
679 }
680 
681 // File: .deps/rugtownwtf.sol
682 
683 
684 pragma solidity >=0.7.0 <0.9.0;
685 
686 
687 contract rugtownwtf is ERC721, Ownable {
688   using Counters for Counters.Counter; 
689   using Strings for uint256;
690 
691   Counters.Counter private _tokenSupply;
692   string public rugproofURI;
693   string public rugproofExtension = ".json"; 
694   uint256 public cost = 0.005 ether; 
695   uint256 public maxSupply = 5000; 
696   uint256 public freeMints = 3750; 
697   uint256 public maxMintAmount = 5; 
698   bool public paused = false;
699   bool public revealed = false;
700   string public TownUri;
701   mapping(address => bool) public whitelisted;
702   mapping(address => uint256) private freeMintsWallet;
703 
704   constructor(
705     string memory _name,
706     string memory _symbol,
707     string memory _initRugproofURI,
708     string memory _initTownUri
709   ) ERC721(_name, _symbol) {
710     setRugproofURI(_initRugproofURI);
711     setTownURI(_initTownUri);
712   }
713 
714   function totalSupply() public view returns (uint256) {
715     return _tokenSupply.current();
716   }
717 
718   // internal
719   function _rugproofURI() internal view virtual override returns (string memory) {
720     return rugproofURI;
721   }
722   
723   // public
724   function mint(address _to, uint256 _mintAmount) public payable {
725     uint256 supply = _tokenSupply.current();
726     require(!paused);
727     require(_mintAmount > 0);
728     require(_mintAmount <= maxMintAmount);
729     require(supply + _mintAmount <= maxSupply);
730 
731     if (supply + _mintAmount > freeMints) {
732       if(whitelisted[msg.sender] != true) {
733         require(msg.value >= cost * _mintAmount);
734       }
735     }
736     else {
737         require(
738             supply + _mintAmount <= freeMints,
739             "You would exceed the number of free mints"
740         );
741         require(
742             freeMintsWallet[msg.sender] + _mintAmount <= maxMintAmount,
743             "You can only mint 20 assets for free!"
744         );
745         freeMintsWallet[msg.sender] += _mintAmount;
746     }
747 
748     for (uint256 i = 1; i <= _mintAmount; i++) {
749        _tokenSupply.increment();
750       _safeMint(_to, supply + i);
751     }
752   }
753 
754   function tokenURI(uint256 tokenId)
755     public
756     view
757     virtual
758     override
759     returns (string memory)
760   {
761     require(
762       _exists(tokenId),
763       "ERC721Metadata: URI query for nonexistent token"
764     );
765     
766     if(revealed == false) {
767         return TownUri;
768     }
769 
770     string memory currentRugproofURI = _rugproofURI();
771     return bytes(currentRugproofURI).length > 0
772         ? string(abi.encodePacked(currentRugproofURI, tokenId.toString(), rugproofExtension))
773         : "";
774   }
775 
776   //only owner
777   function reveal() public onlyOwner {
778       revealed = true;
779   }
780   
781   function setCost(uint256 _newCost) public onlyOwner {
782     cost = _newCost;
783   }
784 
785   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
786     maxMintAmount = _newmaxMintAmount;
787   }
788   
789   function setTownURI(string memory _TownURI) public onlyOwner {
790     TownUri = _TownURI;
791   }
792 
793   function setRugproofURI(string memory _newRugproofURI) public onlyOwner {
794     rugproofURI = _newRugproofURI;
795   }
796 
797   function setRugproofExtension(string memory _newRugproofExtension) public onlyOwner {
798     rugproofExtension = _newRugproofExtension;
799   }
800 
801   function pause(bool _state) public onlyOwner {
802     paused = _state;
803   }
804  
805  function whitelistUser(address _user) public onlyOwner {
806     whitelisted[_user] = true;
807   }
808  
809   function removeWhitelistUser(address _user) public onlyOwner {
810     whitelisted[_user] = false;
811   }
812 
813   function withdraw() public payable onlyOwner {
814 
815     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
816     require(os);
817 
818   }
819 }