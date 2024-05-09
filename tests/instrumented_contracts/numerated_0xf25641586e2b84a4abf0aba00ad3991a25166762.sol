1 /*
2 
3 Doesn't matter who you show this to, they'll never get it.
4 
5 */
6 
7 
8 // SPDX-License-Identifier: GPL-3.0
9 
10 // File: @openzeppelin/contracts/utils/Strings.sol
11 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 
16 library Strings {
17     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
18 
19     function toString(uint256 value) internal pure returns (string memory) {
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52 
53     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
54         bytes memory buffer = new bytes(2 * length + 2);
55         buffer[0] = "0";
56         buffer[1] = "x";
57         for (uint256 i = 2 * length + 1; i > 1; --i) {
58             buffer[i] = _HEX_SYMBOLS[value & 0xf];
59             value >>= 4;
60         }
61         require(value == 0, "Strings: hex length insufficient");
62         return string(buffer);
63     }
64 }
65 
66 // File: @openzeppelin/contracts/utils/Context.sol
67 
68 
69 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 
74 abstract contract Context {
75     function _msgSender() internal view virtual returns (address) {
76         return msg.sender;
77     }
78 
79     function _msgData() internal view virtual returns (bytes calldata) {
80         return msg.data;
81     }
82 }
83 
84 // File: @openzeppelin/contracts/access/Ownable.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 
92 abstract contract Ownable is Context {
93     address private _owner;
94 
95     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
96 
97     constructor() {
98         _transferOwnership(_msgSender());
99     }
100 
101  
102     function owner() public view virtual returns (address) {
103         return _owner;
104     }
105 
106 
107     modifier onlyOwner() {
108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
109         _;
110     }
111 
112 
113     function renounceOwnership() public virtual onlyOwner {
114         _transferOwnership(address(0));
115     }
116 
117 
118     function transferOwnership(address newOwner) public virtual onlyOwner {
119         require(newOwner != address(0), "Ownable: new owner is the zero address");
120         _transferOwnership(newOwner);
121     }
122 
123 
124     function _transferOwnership(address newOwner) internal virtual {
125         address oldOwner = _owner;
126         _owner = newOwner;
127         emit OwnershipTransferred(oldOwner, newOwner);
128     }
129 }
130 
131 // File: @openzeppelin/contracts/utils/Address.sol
132 
133 
134 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
135 
136 pragma solidity ^0.8.0;
137 
138 
139 library Address {
140  
141     function isContract(address account) internal view returns (bool) {
142 
143 
144         uint256 size;
145         assembly {
146             size := extcodesize(account)
147         }
148         return size > 0;
149     }
150 
151 
152     function sendValue(address payable recipient, uint256 amount) internal {
153         require(address(this).balance >= amount, "Address: insufficient balance");
154 
155         (bool success, ) = recipient.call{value: amount}("");
156         require(success, "Address: unable to send value, recipient may have reverted");
157     }
158 
159 
160     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
161         return functionCall(target, data, "Address: low-level call failed");
162     }
163 
164 
165     function functionCall(
166         address target,
167         bytes memory data,
168         string memory errorMessage
169     ) internal returns (bytes memory) {
170         return functionCallWithValue(target, data, 0, errorMessage);
171     }
172 
173     function functionCallWithValue(
174         address target,
175         bytes memory data,
176         uint256 value
177     ) internal returns (bytes memory) {
178         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
179     }
180 
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(address(this).balance >= value, "Address: insufficient balance for call");
188         require(isContract(target), "Address: call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.call{value: value}(data);
191         return verifyCallResult(success, returndata, errorMessage);
192     }
193 
194 
195     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
196         return functionStaticCall(target, data, "Address: low-level static call failed");
197     }
198 
199     function functionStaticCall(
200         address target,
201         bytes memory data,
202         string memory errorMessage
203     ) internal view returns (bytes memory) {
204         require(isContract(target), "Address: static call to non-contract");
205 
206         (bool success, bytes memory returndata) = target.staticcall(data);
207         return verifyCallResult(success, returndata, errorMessage);
208     }
209 
210 
211     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
212         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
213     }
214 
215 
216     function functionDelegateCall(
217         address target,
218         bytes memory data,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         require(isContract(target), "Address: delegate call to non-contract");
222 
223         (bool success, bytes memory returndata) = target.delegatecall(data);
224         return verifyCallResult(success, returndata, errorMessage);
225     }
226 
227 
228     function verifyCallResult(
229         bool success,
230         bytes memory returndata,
231         string memory errorMessage
232     ) internal pure returns (bytes memory) {
233         if (success) {
234             return returndata;
235         } else {
236             if (returndata.length > 0) {
237 
238                 assembly {
239                     let returndata_size := mload(returndata)
240                     revert(add(32, returndata), returndata_size)
241                 }
242             } else {
243                 revert(errorMessage);
244             }
245         }
246     }
247 }
248 
249 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
250 
251 
252 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 interface IERC721Receiver {
257 
258     function onERC721Received(
259         address operator,
260         address from,
261         uint256 tokenId,
262         bytes calldata data
263     ) external returns (bytes4);
264 }
265 
266 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
267 
268 
269 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
270 
271 pragma solidity ^0.8.0;
272 
273 
274 interface IERC165 {
275 
276     function supportsInterface(bytes4 interfaceId) external view returns (bool);
277 }
278 
279 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
280 
281 
282 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
283 
284 pragma solidity ^0.8.0;
285 
286 
287 abstract contract ERC165 is IERC165 {
288 
289     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
290         return interfaceId == type(IERC165).interfaceId;
291     }
292 }
293 
294 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 
302 
303 interface IERC721 is IERC165 {
304 
305     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
306 
307 
308     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
309 
310 
311     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
312 
313 
314     function balanceOf(address owner) external view returns (uint256 balance);
315 
316 
317     function ownerOf(uint256 tokenId) external view returns (address owner);
318 
319 
320     function safeTransferFrom(
321         address from,
322         address to,
323         uint256 tokenId
324     ) external;
325 
326 
327     function transferFrom(
328         address from,
329         address to,
330         uint256 tokenId
331     ) external;
332 
333 
334     function approve(address to, uint256 tokenId) external;
335 
336 
337     function getApproved(uint256 tokenId) external view returns (address operator);
338 
339 
340     function setApprovalForAll(address operator, bool _approved) external;
341 
342     function isApprovedForAll(address owner, address operator) external view returns (bool);
343 
344 
345     function safeTransferFrom(
346         address from,
347         address to,
348         uint256 tokenId,
349         bytes calldata data
350     ) external;
351 }
352 
353 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 
361 
362 interface IERC721Metadata is IERC721 {
363 
364     function name() external view returns (string memory);
365 
366 
367     function symbol() external view returns (string memory);
368 
369 
370     function tokenURI(uint256 tokenId) external view returns (string memory);
371 }
372 
373 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
374 
375 
376 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 
381 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
382     using Address for address;
383     using Strings for uint256;
384 
385     string private _name;
386 
387     string private _symbol;
388 
389     mapping(uint256 => address) private _owners;
390 
391     mapping(address => uint256) private _balances;
392 
393     mapping(uint256 => address) private _tokenApprovals;
394 
395     mapping(address => mapping(address => bool)) private _operatorApprovals;
396 
397     constructor(string memory name_, string memory symbol_) {
398         _name = name_;
399         _symbol = symbol_;
400     }
401 
402     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
403         return
404             interfaceId == type(IERC721).interfaceId ||
405             interfaceId == type(IERC721Metadata).interfaceId ||
406             super.supportsInterface(interfaceId);
407     }
408 
409 
410     function balanceOf(address owner) public view virtual override returns (uint256) {
411         require(owner != address(0), "ERC721: balance query for the zero address");
412         return _balances[owner];
413     }
414 
415     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
416         address owner = _owners[tokenId];
417         require(owner != address(0), "ERC721: owner query for nonexistent token");
418         return owner;
419     }
420 
421     function name() public view virtual override returns (string memory) {
422         return _name;
423     }
424 
425     function symbol() public view virtual override returns (string memory) {
426         return _symbol;
427     }
428 
429     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
430         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
431 
432         string memory doyouURI = _doyouURI();
433         return bytes(doyouURI).length > 0 ? string(abi.encodePacked(doyouURI, tokenId.toString())) : "";
434     }
435 
436 
437     function _doyouURI() internal view virtual returns (string memory) {
438         return "";
439     }
440 
441     function approve(address to, uint256 tokenId) public virtual override {
442         address owner = ERC721.ownerOf(tokenId);
443         require(to != owner, "ERC721: approval to current owner");
444 
445         require(
446             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
447             "ERC721: approve caller is not owner nor approved for all"
448         );
449 
450         _approve(to, tokenId);
451     }
452 
453     function getApproved(uint256 tokenId) public view virtual override returns (address) {
454         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
455 
456         return _tokenApprovals[tokenId];
457     }
458 
459 
460     function setApprovalForAll(address operator, bool approved) public virtual override {
461         _setApprovalForAll(_msgSender(), operator, approved);
462     }
463 
464 
465     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
466         return _operatorApprovals[owner][operator];
467     }
468 
469 
470     function transferFrom(
471         address from,
472         address to,
473         uint256 tokenId
474     ) public virtual override {
475 
476         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
477 
478         _transfer(from, to, tokenId);
479     }
480 
481 
482     function safeTransferFrom(
483         address from,
484         address to,
485         uint256 tokenId
486     ) public virtual override {
487         safeTransferFrom(from, to, tokenId, "");
488     }
489 
490 
491     function safeTransferFrom(
492         address from,
493         address to,
494         uint256 tokenId,
495         bytes memory _data
496     ) public virtual override {
497         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
498         _safeTransfer(from, to, tokenId, _data);
499     }
500 
501     function _safeTransfer(
502         address from,
503         address to,
504         uint256 tokenId,
505         bytes memory _data
506     ) internal virtual {
507         _transfer(from, to, tokenId);
508         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
509     }
510 
511  
512     function _exists(uint256 tokenId) internal view virtual returns (bool) {
513         return _owners[tokenId] != address(0);
514     }
515 
516     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
517         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
518         address owner = ERC721.ownerOf(tokenId);
519         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
520     }
521 
522     function _safeMint(address to, uint256 tokenId) internal virtual {
523         _safeMint(to, tokenId, "");
524     }
525 
526     function _safeMint(
527         address to,
528         uint256 tokenId,
529         bytes memory _data
530     ) internal virtual {
531         _mint(to, tokenId);
532         require(
533             _checkOnERC721Received(address(0), to, tokenId, _data),
534             "ERC721: transfer to non ERC721Receiver implementer"
535         );
536     }
537 
538 
539     function _mint(address to, uint256 tokenId) internal virtual {
540         require(to != address(0), "ERC721: mint to the zero address");
541         require(!_exists(tokenId), "ERC721: token already minted");
542 
543         _beforeTokenTransfer(address(0), to, tokenId);
544 
545         _balances[to] += 1;
546         _owners[tokenId] = to;
547 
548         emit Transfer(address(0), to, tokenId);
549     }
550 
551 
552     function _burn(uint256 tokenId) internal virtual {
553         address owner = ERC721.ownerOf(tokenId);
554 
555         _beforeTokenTransfer(owner, address(0), tokenId);
556 
557         // Clear approvals
558         _approve(address(0), tokenId);
559 
560         _balances[owner] -= 1;
561         delete _owners[tokenId];
562 
563         emit Transfer(owner, address(0), tokenId);
564     }
565 
566 
567     function _transfer(
568         address from,
569         address to,
570         uint256 tokenId
571     ) internal virtual {
572         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
573         require(to != address(0), "ERC721: transfer to the zero address");
574 
575         _beforeTokenTransfer(from, to, tokenId);
576 
577         _approve(address(0), tokenId);
578 
579         _balances[from] -= 1;
580         _balances[to] += 1;
581         _owners[tokenId] = to;
582 
583         emit Transfer(from, to, tokenId);
584     }
585 
586 
587     function _approve(address to, uint256 tokenId) internal virtual {
588         _tokenApprovals[tokenId] = to;
589         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
590     }
591 
592     function _setApprovalForAll(
593         address owner,
594         address operator,
595         bool approved
596     ) internal virtual {
597         require(owner != operator, "ERC721: approve to caller");
598         _operatorApprovals[owner][operator] = approved;
599         emit ApprovalForAll(owner, operator, approved);
600     }
601 
602 
603     function _checkOnERC721Received(
604         address from,
605         address to,
606         uint256 tokenId,
607         bytes memory _data
608     ) private returns (bool) {
609         if (to.isContract()) {
610             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
611                 return retval == IERC721Receiver.onERC721Received.selector;
612             } catch (bytes memory reason) {
613                 if (reason.length == 0) {
614                     revert("ERC721: transfer to non ERC721Receiver implementer");
615                 } else {
616                     assembly {
617                         revert(add(32, reason), mload(reason))
618                     }
619                 }
620             }
621         } else {
622             return true;
623         }
624     }
625 
626 
627     function _beforeTokenTransfer(
628         address from,
629         address to,
630         uint256 tokenId
631     ) internal virtual {}
632 }
633 
634 // File: @openzeppelin/contracts/utils/Counters.sol
635 
636 
637 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 
642 library Counters {
643     struct Counter {
644 
645         uint256 _value; // default: 0
646     }
647 
648     function current(Counter storage counter) internal view returns (uint256) {
649         return counter._value;
650     }
651 
652     function increment(Counter storage counter) internal {
653         unchecked {
654             counter._value += 1;
655         }
656     }
657 
658     function decrement(Counter storage counter) internal {
659         uint256 value = counter._value;
660         require(value > 0, "Counter: decrement overflow");
661         unchecked {
662             counter._value = value - 1;
663         }
664     }
665 
666     function reset(Counter storage counter) internal {
667         counter._value = 0;
668     }
669 }
670 
671 // File: .deps/TNGI.sol
672 
673 
674 pragma solidity >=0.7.0 <0.9.0;
675 
676 
677 contract TNGI is ERC721, Ownable {
678   using Counters for Counters.Counter;  
679   using Strings for uint256;
680 
681   Counters.Counter private _tokenSupply;
682   string public doyouURI;
683   string public doyouExtension = ".json"; 
684   uint256 public cost = 0 ether; 
685   uint256 public maxSupply = 10000; 
686   uint256 public freeMints = 10000; 
687   uint256 public maxMintAmount = 3; 
688   bool public paused = false;
689   bool public revealed = true;
690   string public GetitUri;
691   mapping(address => bool) public whitelisted;
692   mapping(address => uint256) private freeMintsWallet;
693 
694   constructor(
695     string memory _name,
696     string memory _symbol,
697     string memory _initDoyouURI,
698     string memory _initGetitUri
699   ) ERC721(_name, _symbol) {
700     setDoyouURI(_initDoyouURI);
701     setGetitURI(_initGetitUri);
702   }
703 
704   function totalSupply() public view returns (uint256) {
705     return _tokenSupply.current();
706   }
707 
708   // internal
709   function _doyouURI() internal view virtual override returns (string memory) {
710     return doyouURI;
711   }
712   
713   // public
714   function mint(address _to, uint256 _mintAmount) public payable {
715     uint256 supply = _tokenSupply.current();
716     require(!paused);
717     require(_mintAmount > 0);
718     require(_mintAmount <= maxMintAmount);
719     require(supply + _mintAmount <= maxSupply);
720 
721     if (supply + _mintAmount > freeMints) {
722       if(whitelisted[msg.sender] != true) {
723         require(msg.value >= cost * _mintAmount);
724       }
725     }
726     else {
727         require(
728             supply + _mintAmount <= freeMints,
729             "You would exceed the number of free mints"
730         );
731         require(
732             freeMintsWallet[msg.sender] + _mintAmount <= maxMintAmount,
733             "You can only mint 20 assets for free!"
734         );
735         freeMintsWallet[msg.sender] += _mintAmount;
736     }
737 
738     for (uint256 i = 1; i <= _mintAmount; i++) {
739        _tokenSupply.increment();
740       _safeMint(_to, supply + i);
741     }
742   }
743 
744   function tokenURI(uint256 tokenId)
745     public
746     view
747     virtual
748     override
749     returns (string memory)
750   {
751     require(
752       _exists(tokenId),
753       "ERC721Metadata: URI query for nonexistent token"
754     );
755     
756     if(revealed == false) {
757         return GetitUri;
758     }
759 
760     string memory currentDoyouURI = _doyouURI();
761     return bytes(currentDoyouURI).length > 0
762         ? string(abi.encodePacked(currentDoyouURI, tokenId.toString(), doyouExtension))
763         : "";
764   }
765 
766   //only owner
767   function reveal() public onlyOwner {
768       revealed = true;
769   }
770   
771   function setCost(uint256 _newCost) public onlyOwner {
772     cost = _newCost;
773   }
774 
775   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
776     maxMintAmount = _newmaxMintAmount;
777   }
778   
779   function setGetitURI(string memory _GetitURI) public onlyOwner {
780     GetitUri = _GetitURI;
781   }
782 
783   function setDoyouURI(string memory _newDoyouURI) public onlyOwner {
784     doyouURI = _newDoyouURI;
785   }
786 
787   function setDoyouExtension(string memory _newDoyouExtension) public onlyOwner {
788     doyouExtension = _newDoyouExtension;
789   }
790 
791   function pause(bool _state) public onlyOwner {
792     paused = _state;
793   }
794  
795  function whitelistUser(address _user) public onlyOwner {
796     whitelisted[_user] = true;
797   }
798  
799   function removeWhitelistUser(address _user) public onlyOwner {
800     whitelisted[_user] = false;
801   }
802 
803   function withdraw() public payable onlyOwner {
804 
805     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
806     require(os);
807 
808   }
809 }