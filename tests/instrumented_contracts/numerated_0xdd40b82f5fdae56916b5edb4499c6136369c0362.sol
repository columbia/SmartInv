1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/Counters.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 
12 library Counters {
13     struct Counter {
14         // This variable should never be directly accessed by users of the library: interactions must be restricted to
15         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
16         // this feature: see https://github.com/ethereum/solidity/issues/4637
17         uint256 _value; // default: 0
18     }
19 
20     function current(Counter storage counter) internal view returns (uint256) {
21         return counter._value;
22     }
23 
24     function increment(Counter storage counter) internal {
25         unchecked {
26             counter._value += 1;
27         }
28     }
29 
30     function decrement(Counter storage counter) internal {
31         uint256 value = counter._value;
32         require(value > 0, "Counter: decrement overflow");
33         unchecked {
34             counter._value = value - 1;
35         }
36     }
37 
38     function reset(Counter storage counter) internal {
39         counter._value = 0;
40     }
41 }
42 
43 // File: @openzeppelin/contracts/utils/Strings.sol
44 
45 
46 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
47 
48 pragma solidity ^0.8.0;
49 
50 /**
51  * @dev String operations.
52  */
53 library Strings {
54     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
58      */
59     function toString(uint256 value) internal pure returns (string memory) {
60         // Inspired by OraclizeAPI's implementation - MIT licence
61         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
62 
63         if (value == 0) {
64             return "0";
65         }
66         uint256 temp = value;
67         uint256 digits;
68         while (temp != 0) {
69             digits++;
70             temp /= 10;
71         }
72         bytes memory buffer = new bytes(digits);
73         while (value != 0) {
74             digits -= 1;
75             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
76             value /= 10;
77         }
78         return string(buffer);
79     }
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
83      */
84     function toHexString(uint256 value) internal pure returns (string memory) {
85         if (value == 0) {
86             return "0x00";
87         }
88         uint256 temp = value;
89         uint256 length = 0;
90         while (temp != 0) {
91             length++;
92             temp >>= 8;
93         }
94         return toHexString(value, length);
95     }
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
99      */
100     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
101         bytes memory buffer = new bytes(2 * length + 2);
102         buffer[0] = "0";
103         buffer[1] = "x";
104         for (uint256 i = 2 * length + 1; i > 1; --i) {
105             buffer[i] = _HEX_SYMBOLS[value & 0xf];
106             value >>= 4;
107         }
108         require(value == 0, "Strings: hex length insufficient");
109         return string(buffer);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/Context.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 
121 abstract contract Context {
122     function _msgSender() internal view virtual returns (address) {
123         return msg.sender;
124     }
125 
126     function _msgData() internal view virtual returns (bytes calldata) {
127         return msg.data;
128     }
129 }
130 
131 // File: @openzeppelin/contracts/access/Ownable.sol
132 
133 
134 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
135 
136 pragma solidity ^0.8.0;
137 
138 
139 
140 abstract contract Ownable is Context {
141     address private _owner;
142 
143     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145     /**
146      * @dev Initializes the contract setting the deployer as the initial owner.
147      */
148     constructor() {
149         _transferOwnership(_msgSender());
150     }
151 
152     /**
153      * @dev Returns the address of the current owner.
154      */
155     function owner() public view virtual returns (address) {
156         return _owner;
157     }
158 
159     /**
160      * @dev Throws if called by any account other than the owner.
161      */
162     modifier onlyOwner() {
163         require(owner() == _msgSender(), "Ownable: caller is not the owner");
164         _;
165     }
166 
167 
168     function renounceOwnership() public virtual onlyOwner {
169         _transferOwnership(address(0));
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Can only be called by the current owner.
175      */
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         _transferOwnership(newOwner);
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Internal function without access restriction.
184      */
185     function _transferOwnership(address newOwner) internal virtual {
186         address oldOwner = _owner;
187         _owner = newOwner;
188         emit OwnershipTransferred(oldOwner, newOwner);
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Address.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Collection of functions related to the address type
201  */
202 library Address {
203 
204     function isContract(address account) internal view returns (bool) {
205         // This method relies on extcodesize, which returns 0 for contracts in
206         // construction, since the code is only stored at the end of the
207         // constructor execution.
208 
209         uint256 size;
210         assembly {
211             size := extcodesize(account)
212         }
213         return size > 0;
214     }
215 
216     function sendValue(address payable recipient, uint256 amount) internal {
217         require(address(this).balance >= amount, "Address: insufficient balance");
218 
219         (bool success, ) = recipient.call{value: amount}("");
220         require(success, "Address: unable to send value, recipient may have reverted");
221     }
222 
223     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
224         return functionCall(target, data, "Address: low-level call failed");
225     }
226 
227     function functionCall(
228         address target,
229         bytes memory data,
230         string memory errorMessage
231     ) internal returns (bytes memory) {
232         return functionCallWithValue(target, data, 0, errorMessage);
233     }
234 
235    
236     function functionCallWithValue(
237         address target,
238         bytes memory data,
239         uint256 value
240     ) internal returns (bytes memory) {
241         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
242     }
243 
244 
245     function functionCallWithValue(
246         address target,
247         bytes memory data,
248         uint256 value,
249         string memory errorMessage
250     ) internal returns (bytes memory) {
251         require(address(this).balance >= value, "Address: insufficient balance for call");
252         require(isContract(target), "Address: call to non-contract");
253 
254         (bool success, bytes memory returndata) = target.call{value: value}(data);
255         return verifyCallResult(success, returndata, errorMessage);
256     }
257 
258     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
259         return functionStaticCall(target, data, "Address: low-level static call failed");
260     }
261 
262     function functionStaticCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal view returns (bytes memory) {
267         require(isContract(target), "Address: static call to non-contract");
268 
269         (bool success, bytes memory returndata) = target.staticcall(data);
270         return verifyCallResult(success, returndata, errorMessage);
271     }
272 
273     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
274         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
275     }
276 
277     function functionDelegateCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         require(isContract(target), "Address: delegate call to non-contract");
283 
284         (bool success, bytes memory returndata) = target.delegatecall(data);
285         return verifyCallResult(success, returndata, errorMessage);
286     }
287 
288 
289     function verifyCallResult(
290         bool success,
291         bytes memory returndata,
292         string memory errorMessage
293     ) internal pure returns (bytes memory) {
294         if (success) {
295             return returndata;
296         } else {
297             // Look for revert reason and bubble it up if present
298             if (returndata.length > 0) {
299                 // The easiest way to bubble the revert reason is using memory via assembly
300 
301                 assembly {
302                     let returndata_size := mload(returndata)
303                     revert(add(32, returndata), returndata_size)
304                 }
305             } else {
306                 revert(errorMessage);
307             }
308         }
309     }
310 }
311 
312 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
313 
314 
315 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 
320 interface IERC721Receiver {
321  
322     function onERC721Received(
323         address operator,
324         address from,
325         uint256 tokenId,
326         bytes calldata data
327     ) external returns (bytes4);
328 }
329 
330 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 
338 interface IERC165 {
339  
340     function supportsInterface(bytes4 interfaceId) external view returns (bool);
341 }
342 
343 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
344 
345 
346 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 
351 
352 abstract contract ERC165 is IERC165 {
353     /**
354      * @dev See {IERC165-supportsInterface}.
355      */
356     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
357         return interfaceId == type(IERC165).interfaceId;
358     }
359 }
360 
361 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 
369 
370 interface IERC721 is IERC165 {
371 
372     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
373 
374 
375     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
376 
377 
378     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
379 
380  
381     function balanceOf(address owner) external view returns (uint256 balance);
382 
383  
384     function ownerOf(uint256 tokenId) external view returns (address owner);
385 
386  
387     function safeTransferFrom(
388         address from,
389         address to,
390         uint256 tokenId
391     ) external;
392 
393     function transferFrom(
394         address from,
395         address to,
396         uint256 tokenId
397     ) external;
398 
399     function approve(address to, uint256 tokenId) external;
400 
401 
402     function getApproved(uint256 tokenId) external view returns (address operator);
403 
404     function setApprovalForAll(address operator, bool _approved) external;
405 
406 
407     function isApprovedForAll(address owner, address operator) external view returns (bool);
408 
409     function safeTransferFrom(
410         address from,
411         address to,
412         uint256 tokenId,
413         bytes calldata data
414     ) external;
415 }
416 
417 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
418 
419 
420 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 
425 
426 interface IERC721Metadata is IERC721 {
427 
428     function name() external view returns (string memory);
429 
430 
431     function symbol() external view returns (string memory);
432 
433     function tokenURI(uint256 tokenId) external view returns (string memory);
434 }
435 
436 pragma solidity ^0.8.0;
437 
438 
439 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
440     using Address for address;
441     using Strings for uint256;
442 
443     // Token name
444     string private _name;
445 
446     // Token symbol
447     string private _symbol;
448 
449     // Mapping from token ID to owner address
450     mapping(uint256 => address) private _owners;
451 
452     // Mapping owner address to token count
453     mapping(address => uint256) private _balances;
454 
455     // Mapping from token ID to approved address
456     mapping(uint256 => address) private _tokenApprovals;
457 
458     // Mapping from owner to operator approvals
459     mapping(address => mapping(address => bool)) private _operatorApprovals;
460 
461 
462     constructor(string memory name_, string memory symbol_) {
463         _name = name_;
464         _symbol = symbol_;
465     }
466     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
467         return
468             interfaceId == type(IERC721).interfaceId ||
469             interfaceId == type(IERC721Metadata).interfaceId ||
470             super.supportsInterface(interfaceId);
471     }
472     function balanceOf(address owner) public view virtual override returns (uint256) {
473         require(owner != address(0), "ERC721: balance query for the zero address");
474         return _balances[owner];
475     }
476 
477     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
478         address owner = _owners[tokenId];
479         require(owner != address(0), "ERC721: owner query for nonexistent token");
480         return owner;
481     }
482 
483     function name() public view virtual override returns (string memory) {
484         return _name;
485     }
486     function symbol() public view virtual override returns (string memory) {
487         return _symbol;
488     }
489 
490     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
491         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
492 
493         string memory baseURI = _baseURI();
494         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
495     }
496     function _baseURI() internal view virtual returns (string memory) {
497         return "";
498     }
499 
500     function approve(address to, uint256 tokenId) public virtual override {
501         address owner = ERC721.ownerOf(tokenId);
502         require(to != owner, "ERC721: approval to current owner");
503 
504         require(
505             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
506             "ERC721: approve caller is not owner nor approved for all"
507         );
508 
509         _approve(to, tokenId);
510     }
511 
512 
513     function getApproved(uint256 tokenId) public view virtual override returns (address) {
514         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
515 
516         return _tokenApprovals[tokenId];
517     }
518 
519     function setApprovalForAll(address operator, bool approved) public virtual override {
520         _setApprovalForAll(_msgSender(), operator, approved);
521     }
522 
523 
524     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
525         return _operatorApprovals[owner][operator];
526     }
527 
528     function transferFrom(
529         address from,
530         address to,
531         uint256 tokenId
532     ) public virtual override {
533         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
534 
535         _transfer(from, to, tokenId);
536     }
537 
538     function safeTransferFrom(
539         address from,
540         address to,
541         uint256 tokenId
542     ) public virtual override {
543         safeTransferFrom(from, to, tokenId, "");
544     }
545 
546     function safeTransferFrom(
547         address from,
548         address to,
549         uint256 tokenId,
550         bytes memory _data
551     ) public virtual override {
552         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
553         _safeTransfer(from, to, tokenId, _data);
554     }
555 
556     function _safeTransfer(
557         address from,
558         address to,
559         uint256 tokenId,
560         bytes memory _data
561     ) internal virtual {
562         _transfer(from, to, tokenId);
563         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
564     }
565 
566     function _exists(uint256 tokenId) internal view virtual returns (bool) {
567         return _owners[tokenId] != address(0);
568     }
569 
570     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
571         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
572         address owner = ERC721.ownerOf(tokenId);
573         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
574     }
575 
576     function _safeMint(address to, uint256 tokenId) internal virtual {
577         _safeMint(to, tokenId, "");
578     }
579 
580     function _safeMint(
581         address to,
582         uint256 tokenId,
583         bytes memory _data
584     ) internal virtual {
585         _mint(to, tokenId);
586         require(
587             _checkOnERC721Received(address(0), to, tokenId, _data),
588             "ERC721: transfer to non ERC721Receiver implementer"
589         );
590     }
591 
592     function _mint(address to, uint256 tokenId) internal virtual {
593         require(to != address(0), "ERC721: mint to the zero address");
594         require(!_exists(tokenId), "ERC721: token already minted");
595 
596         _beforeTokenTransfer(address(0), to, tokenId);
597 
598         _balances[to] += 1;
599         _owners[tokenId] = to;
600 
601         emit Transfer(address(0), to, tokenId);
602     }
603 
604 
605     function _burn(uint256 tokenId) internal virtual {
606         address owner = ERC721.ownerOf(tokenId);
607 
608         _beforeTokenTransfer(owner, address(0), tokenId);
609 
610         // Clear approvals
611         _approve(address(0), tokenId);
612 
613         _balances[owner] -= 1;
614         delete _owners[tokenId];
615 
616         emit Transfer(owner, address(0), tokenId);
617     }
618 
619     function _transfer(
620         address from,
621         address to,
622         uint256 tokenId
623     ) internal virtual {
624         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
625         require(to != address(0), "ERC721: transfer to the zero address");
626 
627         _beforeTokenTransfer(from, to, tokenId);
628 
629         // Clear approvals from the previous owner
630         _approve(address(0), tokenId);
631 
632         _balances[from] -= 1;
633         _balances[to] += 1;
634         _owners[tokenId] = to;
635 
636         emit Transfer(from, to, tokenId);
637     }
638 
639     function _approve(address to, uint256 tokenId) internal virtual {
640         _tokenApprovals[tokenId] = to;
641         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
642     }
643 
644     function _setApprovalForAll(
645         address owner,
646         address operator,
647         bool approved
648     ) internal virtual {
649         require(owner != operator, "ERC721: approve to caller");
650         _operatorApprovals[owner][operator] = approved;
651         emit ApprovalForAll(owner, operator, approved);
652     }
653 
654     function _checkOnERC721Received(
655         address from,
656         address to,
657         uint256 tokenId,
658         bytes memory _data
659     ) private returns (bool) {
660         if (to.isContract()) {
661             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
662                 return retval == IERC721Receiver.onERC721Received.selector;
663             } catch (bytes memory reason) {
664                 if (reason.length == 0) {
665                     revert("ERC721: transfer to non ERC721Receiver implementer");
666                 } else {
667                     assembly {
668                         revert(add(32, reason), mload(reason))
669                     }
670                 }
671             }
672         } else {
673             return true;
674         }
675     }
676 
677     function _beforeTokenTransfer(
678         address from,
679         address to,
680         uint256 tokenId
681     ) internal virtual {}
682 }
683 
684 
685 pragma solidity >=0.7.0 <0.9.0;
686 
687 
688 contract garydao is ERC721, Ownable {
689   using Strings for uint256;
690   using Counters for Counters.Counter;
691   Counters.Counter private supply;
692 
693   string public baseURI;
694   string public uriSuffix = ".json";
695   uint256 public cost = 0.019 ether;
696   uint256 public maxSupply = 1111;
697   uint256 public maxMintAmountPerTx = 20;
698   
699    constructor(string memory _initBaseURI)
700         ERC721("GaryDAO", "GDO")
701     {
702         setBaseURI(_initBaseURI);
703         
704     }
705 
706   function totalSupply() public view returns (uint256) {
707     return supply.current();
708   }
709   function updateCost() internal view returns (uint256 _cost){
710       if(totalSupply() < 420){
711           return 0.00 ether;
712       }
713       else{return 0.019 ether;}
714 
715   }
716   function mint(uint256 _mintAmount) public payable {
717     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
718     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
719     require(msg.value >= updateCost() * _mintAmount, "Insufficient funds!");
720     _mintLoop(msg.sender, _mintAmount);
721   }
722 
723   function walletOfOwner(address _owner)
724     public
725     view
726     returns (uint256[] memory)
727   {
728     uint256 ownerTokenCount = balanceOf(_owner);
729     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
730     uint256 currentTokenId = 1;
731     uint256 ownedTokenIndex = 0;
732 
733     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
734       address currentTokenOwner = ownerOf(currentTokenId);
735 
736       if (currentTokenOwner == _owner) {
737         ownedTokenIds[ownedTokenIndex] = currentTokenId;
738 
739         ownedTokenIndex++;
740       }
741 
742       currentTokenId++;
743     }
744 
745     return ownedTokenIds;
746   }
747 
748   function tokenURI(uint256 _tokenId)
749     public
750     view
751     virtual
752     override
753     returns (string memory)
754   {
755     require(
756       _exists(_tokenId),
757       "ERC721Metadata: URI query for nonexistent token"
758     );
759 
760     string memory currentBaseURI = _baseURI();
761     return
762             bytes(currentBaseURI).length > 0
763                 ? string(
764                     abi.encodePacked(
765                         currentBaseURI,
766                         _tokenId.toString(),
767                         uriSuffix
768                     )
769                 )
770                 : "";
771   }
772     function _baseURI() internal view override returns (string memory) {
773         return baseURI;
774     }
775     function setBaseURI(string memory _newBaseURI) public onlyOwner {
776         baseURI = _newBaseURI;
777     }
778 
779   function withdraw() public onlyOwner {
780     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
781     require(os);
782   }
783 
784   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
785     for (uint256 i = 0; i < _mintAmount; i++) {
786       supply.increment();
787       _safeMint(_receiver, supply.current());
788     }
789   }
790 
791 }