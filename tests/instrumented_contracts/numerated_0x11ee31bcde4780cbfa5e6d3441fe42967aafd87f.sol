1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     function toString(uint256 value) internal pure returns (string memory) {
14 
15         if (value == 0) {
16             return "0";
17         }
18         uint256 temp = value;
19         uint256 digits;
20         while (temp != 0) {
21             digits++;
22             temp /= 10;
23         }
24         bytes memory buffer = new bytes(digits);
25         while (value != 0) {
26             digits -= 1;
27             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
28             value /= 10;
29         }
30         return string(buffer);
31     }
32 
33     function toHexString(uint256 value) internal pure returns (string memory) {
34         if (value == 0) {
35             return "0x00";
36         }
37         uint256 temp = value;
38         uint256 length = 0;
39         while (temp != 0) {
40             length++;
41             temp >>= 8;
42         }
43         return toHexString(value, length);
44     }
45 
46 
47     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
48         bytes memory buffer = new bytes(2 * length + 2);
49         buffer[0] = "0";
50         buffer[1] = "x";
51         for (uint256 i = 2 * length + 1; i > 1; --i) {
52             buffer[i] = _HEX_SYMBOLS[value & 0xf];
53             value >>= 4;
54         }
55         require(value == 0, "Strings: hex length insufficient");
56         return string(buffer);
57     }
58 }
59 
60 // File: @openzeppelin/contracts/utils/Context.sol
61 
62 
63 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 
68 abstract contract Context {
69     function _msgSender() internal view virtual returns (address) {
70         return msg.sender;
71     }
72 
73     function _msgData() internal view virtual returns (bytes calldata) {
74         return msg.data;
75     }
76 }
77 
78 // File: @openzeppelin/contracts/access/Ownable.sol
79 
80 
81 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 
86 abstract contract Ownable is Context {
87     address private _owner;
88 
89     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91     constructor() {
92         _transferOwnership(_msgSender());
93     }
94 
95  
96     function owner() public view virtual returns (address) {
97         return _owner;
98     }
99 
100 
101     modifier onlyOwner() {
102         require(owner() == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106 
107     function renounceOwnership() public virtual onlyOwner {
108         _transferOwnership(address(0));
109     }
110 
111 
112     function transferOwnership(address newOwner) public virtual onlyOwner {
113         require(newOwner != address(0), "Ownable: new owner is the zero address");
114         _transferOwnership(newOwner);
115     }
116 
117 
118     function _transferOwnership(address newOwner) internal virtual {
119         address oldOwner = _owner;
120         _owner = newOwner;
121         emit OwnershipTransferred(oldOwner, newOwner);
122     }
123 }
124 
125 // File: @openzeppelin/contracts/utils/Address.sol
126 
127 
128 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
129 
130 pragma solidity ^0.8.0;
131 
132 
133 library Address {
134  
135     function isContract(address account) internal view returns (bool) {
136 
137 
138         uint256 size;
139         assembly {
140             size := extcodesize(account)
141         }
142         return size > 0;
143     }
144 
145 
146     function sendValue(address payable recipient, uint256 amount) internal {
147         require(address(this).balance >= amount, "Address: insufficient balance");
148 
149         (bool success, ) = recipient.call{value: amount}("");
150         require(success, "Address: unable to send value, recipient may have reverted");
151     }
152 
153 
154     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
155         return functionCall(target, data, "Address: low-level call failed");
156     }
157 
158 
159     function functionCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal returns (bytes memory) {
164         return functionCallWithValue(target, data, 0, errorMessage);
165     }
166 
167     function functionCallWithValue(
168         address target,
169         bytes memory data,
170         uint256 value
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
173     }
174 
175     function functionCallWithValue(
176         address target,
177         bytes memory data,
178         uint256 value,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         require(address(this).balance >= value, "Address: insufficient balance for call");
182         require(isContract(target), "Address: call to non-contract");
183 
184         (bool success, bytes memory returndata) = target.call{value: value}(data);
185         return verifyCallResult(success, returndata, errorMessage);
186     }
187 
188 
189     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
190         return functionStaticCall(target, data, "Address: low-level static call failed");
191     }
192 
193     function functionStaticCall(
194         address target,
195         bytes memory data,
196         string memory errorMessage
197     ) internal view returns (bytes memory) {
198         require(isContract(target), "Address: static call to non-contract");
199 
200         (bool success, bytes memory returndata) = target.staticcall(data);
201         return verifyCallResult(success, returndata, errorMessage);
202     }
203 
204 
205     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
206         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
207     }
208 
209 
210     function functionDelegateCall(
211         address target,
212         bytes memory data,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         require(isContract(target), "Address: delegate call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.delegatecall(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221 
222     function verifyCallResult(
223         bool success,
224         bytes memory returndata,
225         string memory errorMessage
226     ) internal pure returns (bytes memory) {
227         if (success) {
228             return returndata;
229         } else {
230             if (returndata.length > 0) {
231 
232                 assembly {
233                     let returndata_size := mload(returndata)
234                     revert(add(32, returndata), returndata_size)
235                 }
236             } else {
237                 revert(errorMessage);
238             }
239         }
240     }
241 }
242 
243 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
244 
245 
246 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 interface IERC721Receiver {
251 
252     function onERC721Received(
253         address operator,
254         address from,
255         uint256 tokenId,
256         bytes calldata data
257     ) external returns (bytes4);
258 }
259 
260 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
261 
262 
263 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 
268 interface IERC165 {
269 
270     function supportsInterface(bytes4 interfaceId) external view returns (bool);
271 }
272 
273 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
274 
275 
276 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
277 
278 pragma solidity ^0.8.0;
279 
280 
281 abstract contract ERC165 is IERC165 {
282 
283     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
284         return interfaceId == type(IERC165).interfaceId;
285     }
286 }
287 
288 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
289 
290 
291 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 
296 
297 interface IERC721 is IERC165 {
298 
299     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
300 
301 
302     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
303 
304 
305     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
306 
307 
308     function balanceOf(address owner) external view returns (uint256 balance);
309 
310 
311     function ownerOf(uint256 tokenId) external view returns (address owner);
312 
313 
314     function safeTransferFrom(
315         address from,
316         address to,
317         uint256 tokenId
318     ) external;
319 
320 
321     function transferFrom(
322         address from,
323         address to,
324         uint256 tokenId
325     ) external;
326 
327 
328     function approve(address to, uint256 tokenId) external;
329 
330 
331     function getApproved(uint256 tokenId) external view returns (address operator);
332 
333 
334     function setApprovalForAll(address operator, bool _approved) external;
335 
336     function isApprovedForAll(address owner, address operator) external view returns (bool);
337 
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
355 
356 interface IERC721Metadata is IERC721 {
357 
358     function name() external view returns (string memory);
359 
360 
361     function symbol() external view returns (string memory);
362 
363 
364     function tokenURI(uint256 tokenId) external view returns (string memory);
365 }
366 
367 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
368 
369 
370 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 
375 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
376     using Address for address;
377     using Strings for uint256;
378 
379     string private _name;
380 
381     string private _symbol;
382 
383     mapping(uint256 => address) private _owners;
384 
385     mapping(address => uint256) private _balances;
386 
387     mapping(uint256 => address) private _tokenApprovals;
388 
389     mapping(address => mapping(address => bool)) private _operatorApprovals;
390 
391     constructor(string memory name_, string memory symbol_) {
392         _name = name_;
393         _symbol = symbol_;
394     }
395 
396     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
397         return
398             interfaceId == type(IERC721).interfaceId ||
399             interfaceId == type(IERC721Metadata).interfaceId ||
400             super.supportsInterface(interfaceId);
401     }
402 
403 
404     function balanceOf(address owner) public view virtual override returns (uint256) {
405         require(owner != address(0), "ERC721: balance query for the zero address");
406         return _balances[owner];
407     }
408 
409     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
410         address owner = _owners[tokenId];
411         require(owner != address(0), "ERC721: owner query for nonexistent token");
412         return owner;
413     }
414 
415     function name() public view virtual override returns (string memory) {
416         return _name;
417     }
418 
419     function symbol() public view virtual override returns (string memory) {
420         return _symbol;
421     }
422 
423     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
424         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
425 
426         string memory picassoURI = _picassoURI();
427         return bytes(picassoURI).length > 0 ? string(abi.encodePacked(picassoURI, tokenId.toString())) : "";
428     }
429 
430 
431     function _picassoURI() internal view virtual returns (string memory) {
432         return "";
433     }
434 
435     function approve(address to, uint256 tokenId) public virtual override {
436         address owner = ERC721.ownerOf(tokenId);
437         require(to != owner, "ERC721: approval to current owner");
438 
439         require(
440             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
441             "ERC721: approve caller is not owner nor approved for all"
442         );
443 
444         _approve(to, tokenId);
445     }
446 
447     function getApproved(uint256 tokenId) public view virtual override returns (address) {
448         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
449 
450         return _tokenApprovals[tokenId];
451     }
452 
453 
454     function setApprovalForAll(address operator, bool approved) public virtual override {
455         _setApprovalForAll(_msgSender(), operator, approved);
456     }
457 
458 
459     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
460         return _operatorApprovals[owner][operator];
461     }
462 
463 
464     function transferFrom(
465         address from,
466         address to,
467         uint256 tokenId
468     ) public virtual override {
469 
470         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
471 
472         _transfer(from, to, tokenId);
473     }
474 
475 
476     function safeTransferFrom(
477         address from,
478         address to,
479         uint256 tokenId
480     ) public virtual override {
481         safeTransferFrom(from, to, tokenId, "");
482     }
483 
484 
485     function safeTransferFrom(
486         address from,
487         address to,
488         uint256 tokenId,
489         bytes memory _data
490     ) public virtual override {
491         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
492         _safeTransfer(from, to, tokenId, _data);
493     }
494 
495     function _safeTransfer(
496         address from,
497         address to,
498         uint256 tokenId,
499         bytes memory _data
500     ) internal virtual {
501         _transfer(from, to, tokenId);
502         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
503     }
504 
505  
506     function _exists(uint256 tokenId) internal view virtual returns (bool) {
507         return _owners[tokenId] != address(0);
508     }
509 
510     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
511         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
512         address owner = ERC721.ownerOf(tokenId);
513         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
514     }
515 
516     function _safeMint(address to, uint256 tokenId) internal virtual {
517         _safeMint(to, tokenId, "");
518     }
519 
520     function _safeMint(
521         address to,
522         uint256 tokenId,
523         bytes memory _data
524     ) internal virtual {
525         _mint(to, tokenId);
526         require(
527             _checkOnERC721Received(address(0), to, tokenId, _data),
528             "ERC721: transfer to non ERC721Receiver implementer"
529         );
530     }
531 
532 
533     function _mint(address to, uint256 tokenId) internal virtual {
534         require(to != address(0), "ERC721: mint to the zero address");
535         require(!_exists(tokenId), "ERC721: token already minted");
536 
537         _beforeTokenTransfer(address(0), to, tokenId);
538 
539         _balances[to] += 1;
540         _owners[tokenId] = to;
541 
542         emit Transfer(address(0), to, tokenId);
543     }
544 
545 
546     function _burn(uint256 tokenId) internal virtual {
547         address owner = ERC721.ownerOf(tokenId);
548 
549         _beforeTokenTransfer(owner, address(0), tokenId);
550 
551         // Clear approvals
552         _approve(address(0), tokenId);
553 
554         _balances[owner] -= 1;
555         delete _owners[tokenId];
556 
557         emit Transfer(owner, address(0), tokenId);
558     }
559 
560 
561     function _transfer(
562         address from,
563         address to,
564         uint256 tokenId
565     ) internal virtual {
566         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
567         require(to != address(0), "ERC721: transfer to the zero address");
568 
569         _beforeTokenTransfer(from, to, tokenId);
570 
571         _approve(address(0), tokenId);
572 
573         _balances[from] -= 1;
574         _balances[to] += 1;
575         _owners[tokenId] = to;
576 
577         emit Transfer(from, to, tokenId);
578     }
579 
580 
581     function _approve(address to, uint256 tokenId) internal virtual {
582         _tokenApprovals[tokenId] = to;
583         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
584     }
585 
586     function _setApprovalForAll(
587         address owner,
588         address operator,
589         bool approved
590     ) internal virtual {
591         require(owner != operator, "ERC721: approve to caller");
592         _operatorApprovals[owner][operator] = approved;
593         emit ApprovalForAll(owner, operator, approved);
594     }
595 
596 
597     function _checkOnERC721Received(
598         address from,
599         address to,
600         uint256 tokenId,
601         bytes memory _data
602     ) private returns (bool) {
603         if (to.isContract()) {
604             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
605                 return retval == IERC721Receiver.onERC721Received.selector;
606             } catch (bytes memory reason) {
607                 if (reason.length == 0) {
608                     revert("ERC721: transfer to non ERC721Receiver implementer");
609                 } else {
610                     assembly {
611                         revert(add(32, reason), mload(reason))
612                     }
613                 }
614             }
615         } else {
616             return true;
617         }
618     }
619 
620 
621     function _beforeTokenTransfer(
622         address from,
623         address to,
624         uint256 tokenId
625     ) internal virtual {}
626 }
627 
628 // File: @openzeppelin/contracts/utils/Counters.sol
629 
630 
631 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
632 
633 pragma solidity ^0.8.0;
634 
635 
636 library Counters {
637     struct Counter {
638 
639         uint256 _value; // default: 0
640     }
641 
642     function current(Counter storage counter) internal view returns (uint256) {
643         return counter._value;
644     }
645 
646     function increment(Counter storage counter) internal {
647         unchecked {
648             counter._value += 1;
649         }
650     }
651 
652     function decrement(Counter storage counter) internal {
653         uint256 value = counter._value;
654         require(value > 0, "Counter: decrement overflow");
655         unchecked {
656             counter._value = value - 1;
657         }
658     }
659 
660     function reset(Counter storage counter) internal {
661         counter._value = 0;
662     }
663 }
664 
665 // File: .deps/PicassoMoonbirds.sol
666 
667 
668 pragma solidity >=0.7.0 <0.9.0;
669 
670 
671 contract PicassoMoonbirds is ERC721, Ownable {
672   using Counters for Counters.Counter;  
673   using Strings for uint256;
674 
675   Counters.Counter private _tokenSupply;
676   string public picassoURI;
677   string public picassoExtension = ".json"; 
678   uint256 public cost = 0.003 ether; 
679   uint256 public maxSupply = 2000; 
680   uint256 public freeMints = 1000; 
681   uint256 public maxMintAmount = 3; 
682   bool public paused = false;
683   bool public revealed = false;
684   string public AiUri;
685   mapping(address => bool) public whitelisted;
686   mapping(address => uint256) private freeMintsWallet;
687 
688   constructor(
689     string memory _name,
690     string memory _symbol,
691     string memory _initPicassoURI,
692     string memory _initAiUri
693   ) ERC721(_name, _symbol) {
694     setPicassoURI(_initPicassoURI);
695     setAiURI(_initAiUri);
696   }
697 
698   function totalSupply() public view returns (uint256) {
699     return _tokenSupply.current();
700   }
701 
702   // internal
703   function _picassoURI() internal view virtual override returns (string memory) {
704     return picassoURI;
705   }
706   
707   // public
708   function mint(address _to, uint256 _mintAmount) public payable {
709     uint256 supply = _tokenSupply.current();
710     require(!paused);
711     require(_mintAmount > 0);
712     require(_mintAmount <= maxMintAmount);
713     require(supply + _mintAmount <= maxSupply);
714 
715     if (supply + _mintAmount > freeMints) {
716       if(whitelisted[msg.sender] != true) {
717         require(msg.value >= cost * _mintAmount);
718       }
719     }
720     else {
721         require(
722             supply + _mintAmount <= freeMints,
723             "You would exceed the number of free mints"
724         );
725         require(
726             freeMintsWallet[msg.sender] + _mintAmount <= maxMintAmount,
727             "You can only mint 20 assets for free!"
728         );
729         freeMintsWallet[msg.sender] += _mintAmount;
730     }
731 
732     for (uint256 i = 1; i <= _mintAmount; i++) {
733        _tokenSupply.increment();
734       _safeMint(_to, supply + i);
735     }
736   }
737 
738   function tokenURI(uint256 tokenId)
739     public
740     view
741     virtual
742     override
743     returns (string memory)
744   {
745     require(
746       _exists(tokenId),
747       "ERC721Metadata: URI query for nonexistent token"
748     );
749     
750     if(revealed == false) {
751         return AiUri;
752     }
753 
754     string memory currentPicassoURI = _picassoURI();
755     return bytes(currentPicassoURI).length > 0
756         ? string(abi.encodePacked(currentPicassoURI, tokenId.toString(), picassoExtension))
757         : "";
758   }
759 
760   //only owner
761   function reveal() public onlyOwner {
762       revealed = true;
763   }
764   
765   function setCost(uint256 _newCost) public onlyOwner {
766     cost = _newCost;
767   }
768 
769   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
770     maxMintAmount = _newmaxMintAmount;
771   }
772   
773   function setAiURI(string memory _AiURI) public onlyOwner {
774     AiUri = _AiURI;
775   }
776 
777   function setPicassoURI(string memory _newPicassoURI) public onlyOwner {
778     picassoURI = _newPicassoURI;
779   }
780 
781   function setPicassoExtension(string memory _newPicassoExtension) public onlyOwner {
782     picassoExtension = _newPicassoExtension;
783   }
784 
785   function pause(bool _state) public onlyOwner {
786     paused = _state;
787   }
788  
789  function whitelistUser(address _user) public onlyOwner {
790     whitelisted[_user] = true;
791   }
792  
793   function removeWhitelistUser(address _user) public onlyOwner {
794     whitelisted[_user] = false;
795   }
796 
797   function withdraw() public payable onlyOwner {
798 
799     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
800     require(os);
801 
802   }
803 }