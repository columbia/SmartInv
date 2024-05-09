1 // SPDX-License-Identifier: GPL-3.0
2 
3 /*
4 
5 
6                           (####)
7                         (#######)
8                       (#########)
9                      (#########)        
10                     (#########)
11                    (#########)
12    __&__          (#########)
13   /     \        (#########)   |\/\/\/|     /\ /\  /\               /\
14  |       |      (#########)    |      |     | V  \/  \---.    .----/  \----.
15  |  (o)(o)       (o)(o)(##)    |      |      \_        /       \          /
16  C   .---_)    ,_C     (##)    | (o)(o)       (o)(o)  <__.   .--\ (o)(o) /__.
17   | |.___|    /___,   (##)     C      _)     _C         /     \     ()     /
18   |  \__/       \     (#)       | ,___|     /____,   )  \      >   (C_)   <
19   /_____\        |    |         |   /         \     /----'    /___\____/___\
20  /_____/ \       OOOOOO        /____\          ooooo             /|    |\
21 /         \     /      \      /      \        /     \           /        \
22 
23 
24 */
25 
26 // File: @openzeppelin/contracts/utils/Strings.sol
27 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34 
35     function toString(uint256 value) internal pure returns (string memory) {
36 
37         if (value == 0) {
38             return "0";
39         }
40         uint256 temp = value;
41         uint256 digits;
42         while (temp != 0) {
43             digits++;
44             temp /= 10;
45         }
46         bytes memory buffer = new bytes(digits);
47         while (value != 0) {
48             digits -= 1;
49             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
50             value /= 10;
51         }
52         return string(buffer);
53     }
54 
55     function toHexString(uint256 value) internal pure returns (string memory) {
56         if (value == 0) {
57             return "0x00";
58         }
59         uint256 temp = value;
60         uint256 length = 0;
61         while (temp != 0) {
62             length++;
63             temp >>= 8;
64         }
65         return toHexString(value, length);
66     }
67 
68 
69     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
70         bytes memory buffer = new bytes(2 * length + 2);
71         buffer[0] = "0";
72         buffer[1] = "x";
73         for (uint256 i = 2 * length + 1; i > 1; --i) {
74             buffer[i] = _HEX_SYMBOLS[value & 0xf];
75             value >>= 4;
76         }
77         require(value == 0, "Strings: hex length insufficient");
78         return string(buffer);
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/Context.sol
83 
84 
85 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
86 
87 pragma solidity ^0.8.0;
88 
89 
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/access/Ownable.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 
108 abstract contract Ownable is Context {
109     address private _owner;
110 
111     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112 
113     constructor() {
114         _transferOwnership(_msgSender());
115     }
116 
117  
118     function owner() public view virtual returns (address) {
119         return _owner;
120     }
121 
122 
123     modifier onlyOwner() {
124         require(owner() == _msgSender(), "Ownable: caller is not the owner");
125         _;
126     }
127 
128 
129     function renounceOwnership() public virtual onlyOwner {
130         _transferOwnership(address(0));
131     }
132 
133 
134     function transferOwnership(address newOwner) public virtual onlyOwner {
135         require(newOwner != address(0), "Ownable: new owner is the zero address");
136         _transferOwnership(newOwner);
137     }
138 
139 
140     function _transferOwnership(address newOwner) internal virtual {
141         address oldOwner = _owner;
142         _owner = newOwner;
143         emit OwnershipTransferred(oldOwner, newOwner);
144     }
145 }
146 
147 // File: @openzeppelin/contracts/utils/Address.sol
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 
155 library Address {
156  
157     function isContract(address account) internal view returns (bool) {
158         // This method relies on extcodesize, which returns 0 for contracts in
159         // construction, since the code is only stored at the end of the
160         // constructor execution.
161 
162         uint256 size;
163         assembly {
164             size := extcodesize(account)
165         }
166         return size > 0;
167     }
168 
169 
170     function sendValue(address payable recipient, uint256 amount) internal {
171         require(address(this).balance >= amount, "Address: insufficient balance");
172 
173         (bool success, ) = recipient.call{value: amount}("");
174         require(success, "Address: unable to send value, recipient may have reverted");
175     }
176 
177 
178     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionCall(target, data, "Address: low-level call failed");
180     }
181 
182 
183     function functionCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, 0, errorMessage);
189     }
190 
191     function functionCallWithValue(
192         address target,
193         bytes memory data,
194         uint256 value
195     ) internal returns (bytes memory) {
196         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
197     }
198 
199     function functionCallWithValue(
200         address target,
201         bytes memory data,
202         uint256 value,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(address(this).balance >= value, "Address: insufficient balance for call");
206         require(isContract(target), "Address: call to non-contract");
207 
208         (bool success, bytes memory returndata) = target.call{value: value}(data);
209         return verifyCallResult(success, returndata, errorMessage);
210     }
211 
212 
213     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
214         return functionStaticCall(target, data, "Address: low-level static call failed");
215     }
216 
217     function functionStaticCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal view returns (bytes memory) {
222         require(isContract(target), "Address: static call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.staticcall(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228 
229     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
230         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
231     }
232 
233 
234     function functionDelegateCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal returns (bytes memory) {
239         require(isContract(target), "Address: delegate call to non-contract");
240 
241         (bool success, bytes memory returndata) = target.delegatecall(data);
242         return verifyCallResult(success, returndata, errorMessage);
243     }
244 
245 
246     function verifyCallResult(
247         bool success,
248         bytes memory returndata,
249         string memory errorMessage
250     ) internal pure returns (bytes memory) {
251         if (success) {
252             return returndata;
253         } else {
254             // Look for revert reason and bubble it up if present
255             if (returndata.length > 0) {
256                 // The easiest way to bubble the revert reason is using memory via assembly
257 
258                 assembly {
259                     let returndata_size := mload(returndata)
260                     revert(add(32, returndata), returndata_size)
261                 }
262             } else {
263                 revert(errorMessage);
264             }
265         }
266     }
267 }
268 
269 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
270 
271 
272 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
273 
274 pragma solidity ^0.8.0;
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
286 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 
294 interface IERC165 {
295 
296     function supportsInterface(bytes4 interfaceId) external view returns (bool);
297 }
298 
299 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
300 
301 
302 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
303 
304 pragma solidity ^0.8.0;
305 
306 
307 abstract contract ERC165 is IERC165 {
308 
309     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
310         return interfaceId == type(IERC165).interfaceId;
311     }
312 }
313 
314 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
315 
316 
317 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 
322 
323 interface IERC721 is IERC165 {
324 
325     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
326 
327 
328     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
329 
330 
331     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
332 
333 
334     function balanceOf(address owner) external view returns (uint256 balance);
335 
336 
337     function ownerOf(uint256 tokenId) external view returns (address owner);
338 
339 
340     function safeTransferFrom(
341         address from,
342         address to,
343         uint256 tokenId
344     ) external;
345 
346 
347     function transferFrom(
348         address from,
349         address to,
350         uint256 tokenId
351     ) external;
352 
353 
354     function approve(address to, uint256 tokenId) external;
355 
356 
357     function getApproved(uint256 tokenId) external view returns (address operator);
358 
359 
360     function setApprovalForAll(address operator, bool _approved) external;
361 
362     function isApprovedForAll(address owner, address operator) external view returns (bool);
363 
364 
365     function safeTransferFrom(
366         address from,
367         address to,
368         uint256 tokenId,
369         bytes calldata data
370     ) external;
371 }
372 
373 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
374 
375 
376 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 
381 
382 interface IERC721Metadata is IERC721 {
383 
384     function name() external view returns (string memory);
385 
386 
387     function symbol() external view returns (string memory);
388 
389 
390     function tokenURI(uint256 tokenId) external view returns (string memory);
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
394 
395 
396 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 
401 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
402     using Address for address;
403     using Strings for uint256;
404 
405     // Token name
406     string private _name;
407 
408     // Token symbol
409     string private _symbol;
410 
411     // Mapping from token ID to owner address
412     mapping(uint256 => address) private _owners;
413 
414     // Mapping owner address to token count
415     mapping(address => uint256) private _balances;
416 
417     // Mapping from token ID to approved address
418     mapping(uint256 => address) private _tokenApprovals;
419 
420     // Mapping from owner to operator approvals
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
458         string memory baseURI = _baseURI();
459         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
460     }
461 
462 
463     function _baseURI() internal view virtual returns (string memory) {
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
501         //solhint-disable-next-line max-line-length
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
552 
553     function _safeMint(
554         address to,
555         uint256 tokenId,
556         bytes memory _data
557     ) internal virtual {
558         _mint(to, tokenId);
559         require(
560             _checkOnERC721Received(address(0), to, tokenId, _data),
561             "ERC721: transfer to non ERC721Receiver implementer"
562         );
563     }
564 
565 
566     function _mint(address to, uint256 tokenId) internal virtual {
567         require(to != address(0), "ERC721: mint to the zero address");
568         require(!_exists(tokenId), "ERC721: token already minted");
569 
570         _beforeTokenTransfer(address(0), to, tokenId);
571 
572         _balances[to] += 1;
573         _owners[tokenId] = to;
574 
575         emit Transfer(address(0), to, tokenId);
576     }
577 
578 
579     function _burn(uint256 tokenId) internal virtual {
580         address owner = ERC721.ownerOf(tokenId);
581 
582         _beforeTokenTransfer(owner, address(0), tokenId);
583 
584         // Clear approvals
585         _approve(address(0), tokenId);
586 
587         _balances[owner] -= 1;
588         delete _owners[tokenId];
589 
590         emit Transfer(owner, address(0), tokenId);
591     }
592 
593 
594     function _transfer(
595         address from,
596         address to,
597         uint256 tokenId
598     ) internal virtual {
599         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
600         require(to != address(0), "ERC721: transfer to the zero address");
601 
602         _beforeTokenTransfer(from, to, tokenId);
603 
604         // Clear approvals from the previous owner
605         _approve(address(0), tokenId);
606 
607         _balances[from] -= 1;
608         _balances[to] += 1;
609         _owners[tokenId] = to;
610 
611         emit Transfer(from, to, tokenId);
612     }
613 
614 
615     function _approve(address to, uint256 tokenId) internal virtual {
616         _tokenApprovals[tokenId] = to;
617         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
618     }
619 
620     function _setApprovalForAll(
621         address owner,
622         address operator,
623         bool approved
624     ) internal virtual {
625         require(owner != operator, "ERC721: approve to caller");
626         _operatorApprovals[owner][operator] = approved;
627         emit ApprovalForAll(owner, operator, approved);
628     }
629 
630 
631     function _checkOnERC721Received(
632         address from,
633         address to,
634         uint256 tokenId,
635         bytes memory _data
636     ) private returns (bool) {
637         if (to.isContract()) {
638             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
639                 return retval == IERC721Receiver.onERC721Received.selector;
640             } catch (bytes memory reason) {
641                 if (reason.length == 0) {
642                     revert("ERC721: transfer to non ERC721Receiver implementer");
643                 } else {
644                     assembly {
645                         revert(add(32, reason), mload(reason))
646                     }
647                 }
648             }
649         } else {
650             return true;
651         }
652     }
653 
654 
655     function _beforeTokenTransfer(
656         address from,
657         address to,
658         uint256 tokenId
659     ) internal virtual {}
660 }
661 
662 // File: @openzeppelin/contracts/utils/Counters.sol
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 
670 library Counters {
671     struct Counter {
672         // This variable should never be directly accessed by users of the library: interactions must be restricted to
673         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
674         // this feature: see https://github.com/ethereum/solidity/issues/4637
675         uint256 _value; // default: 0
676     }
677 
678     function current(Counter storage counter) internal view returns (uint256) {
679         return counter._value;
680     }
681 
682     function increment(Counter storage counter) internal {
683         unchecked {
684             counter._value += 1;
685         }
686     }
687 
688     function decrement(Counter storage counter) internal {
689         uint256 value = counter._value;
690         require(value > 0, "Counter: decrement overflow");
691         unchecked {
692             counter._value = value - 1;
693         }
694     }
695 
696     function reset(Counter storage counter) internal {
697         counter._value = 0;
698     }
699 }
700 
701 // File: .deps/TheApesons.sol
702 
703 
704 pragma solidity >=0.7.0 <0.9.0;
705 
706 
707 contract TheApesons is ERC721, Ownable {
708   using Strings for uint256;
709   using Counters for Counters.Counter;  // Counters subsitution for totalSupply(), save up to 70% on gas.
710 
711   Counters.Counter private _tokenSupply;
712   string public baseURI;
713   string public baseExtension = ".json"; // IPFS MD extension.
714   uint256 public cost = 0.022 ether; // Cost per NFT.
715   uint256 public maxSupply = 3456; // Total supply of collection.
716   uint256 public maxMintAmount = 22; // Max mint each transaction.
717   bool public paused = false;
718   bool public revealed = false;
719   string public UnrevealedUri;
720   mapping(address => bool) public whitelisted;
721 
722   constructor(
723     string memory _name,
724     string memory _symbol,
725     string memory _initBaseURI,
726     string memory _initUnrevealedUri
727   ) ERC721(_name, _symbol) {
728     setBaseURI(_initBaseURI);
729     setUnrevealedURI(_initUnrevealedUri);
730   }
731 
732   function totalSupply() public view returns (uint256) {
733     return _tokenSupply.current();
734   }
735 
736   // internal
737   function _baseURI() internal view virtual override returns (string memory) {
738     return baseURI;
739   }
740 
741   // public
742   function mint(address _to, uint256 _mintAmount) public payable {
743     uint256 supply = _tokenSupply.current();
744     require(!paused);
745     require(_mintAmount > 0);
746     require(_mintAmount <= maxMintAmount);
747     require(supply + _mintAmount <= maxSupply);
748 
749     if (msg.sender != owner()) {
750       if(whitelisted[msg.sender] != true) {
751         require(msg.value >= cost * _mintAmount);
752       }
753     }
754 
755     for (uint256 i = 1; i <= _mintAmount; i++) {
756        _tokenSupply.increment();
757       _safeMint(_to, supply + i);
758     }
759   }
760 
761   function tokenURI(uint256 tokenId)
762     public
763     view
764     virtual
765     override
766     returns (string memory)
767   {
768     require(
769       _exists(tokenId),
770       "ERC721Metadata: URI query for nonexistent token"
771     );
772     
773     if(revealed == false) {
774         return UnrevealedUri;
775     }
776 
777     string memory currentBaseURI = _baseURI();
778     return bytes(currentBaseURI).length > 0
779         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
780         : "";
781   }
782 
783   //only owner
784   function reveal() public onlyOwner {
785       revealed = true;
786   }
787   
788   function setCost(uint256 _newCost) public onlyOwner {
789     cost = _newCost;
790   }
791 
792   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
793     maxMintAmount = _newmaxMintAmount;
794   }
795   
796   function setUnrevealedURI(string memory _UnrevealedURI) public onlyOwner {
797     UnrevealedUri = _UnrevealedURI;
798   }
799 
800   function setBaseURI(string memory _newBaseURI) public onlyOwner {
801     baseURI = _newBaseURI;
802   }
803 
804   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
805     baseExtension = _newBaseExtension;
806   }
807 
808   function pause(bool _state) public onlyOwner {
809     paused = _state;
810   }
811  
812  function whitelistUser(address _user) public onlyOwner {
813     whitelisted[_user] = true;
814   }
815  
816   function removeWhitelistUser(address _user) public onlyOwner {
817     whitelisted[_user] = false;
818   }
819 
820   function withdraw() public payable onlyOwner {
821 
822     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
823     require(os);
824 
825   }
826 }