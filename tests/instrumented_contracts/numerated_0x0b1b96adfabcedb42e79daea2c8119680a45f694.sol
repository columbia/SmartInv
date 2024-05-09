1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity >=0.7.0 <0.9.0;
8 
9 library Counters {
10     struct Counter {
11 
12         uint256 _value; // default: 0
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
38 
39 
40 pragma solidity >=0.7.0 <0.9.0;
41 
42 /**
43  * @dev String operations.
44  */
45 library Strings {
46     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
50      */
51     function toString(uint256 value) internal pure returns (string memory) {
52 
53 
54         if (value == 0) {
55             return "0";
56         }
57         uint256 temp = value;
58         uint256 digits;
59         while (temp != 0) {
60             digits++;
61             temp /= 10;
62         }
63         bytes memory buffer = new bytes(digits);
64         while (value != 0) {
65             digits -= 1;
66             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
67             value /= 10;
68         }
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
74      */
75     function toHexString(uint256 value) internal pure returns (string memory) {
76         if (value == 0) {
77             return "0x00";
78         }
79         uint256 temp = value;
80         uint256 length = 0;
81         while (temp != 0) {
82             length++;
83             temp >>= 8;
84         }
85         return toHexString(value, length);
86     }
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
90      */
91     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
92         bytes memory buffer = new bytes(2 * length + 2);
93         buffer[0] = "0";
94         buffer[1] = "x";
95         for (uint256 i = 2 * length + 1; i > 1; --i) {
96             buffer[i] = _HEX_SYMBOLS[value & 0xf];
97             value >>= 4;
98         }
99         require(value == 0, "Strings: hex length insufficient");
100         return string(buffer);
101     }
102 }
103 
104 // File: @openzeppelin/contracts/utils/Context.sol
105 
106 
107 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
108 
109 pragma solidity >=0.7.0 <0.9.0;
110 
111 abstract contract Context {
112     function _msgSender() internal view virtual returns (address) {
113         return msg.sender;
114     }
115 
116     function _msgData() internal view virtual returns (bytes calldata) {
117         return msg.data;
118     }
119 }
120 
121 // File: @openzeppelin/contracts/access/Ownable.sol
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
125 
126 pragma solidity >=0.7.0 <0.9.0;
127 
128 
129 abstract contract Ownable is Context {
130     address private _owner;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134     /**
135      * @dev Initializes the contract setting the deployer as the initial owner.
136      */
137     constructor() {
138         _transferOwnership(_msgSender());
139     }
140 
141     /**
142      * @dev Returns the address of the current owner.
143      */
144     function owner() public view virtual returns (address) {
145         return _owner;
146     }
147 
148     /**
149      * @dev Throws if called by any account other than the owner.
150      */
151     modifier onlyOwner() {
152         require(owner() == _msgSender(), "Ownable: caller is not the owner");
153         _;
154     }
155 
156     function renounceOwnership() public virtual onlyOwner {
157         _transferOwnership(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         _transferOwnership(newOwner);
167     }
168 
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Address.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
180 
181 pragma solidity >=0.7.0 <0.9.0;
182 
183 /**
184  * @dev Collection of functions related to the address type
185  */
186 library Address {
187 
188     function isContract(address account) internal view returns (bool) {
189 
190 
191         uint256 size;
192         assembly {
193             size := extcodesize(account)
194         }
195         return size > 0;
196     }
197 
198     function sendValue(address payable recipient, uint256 amount) internal {
199         require(address(this).balance >= amount, "Address: insufficient balance");
200 
201         (bool success, ) = recipient.call{value: amount}("");
202         require(success, "Address: unable to send value, recipient may have reverted");
203     }
204 
205 
206     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
207         return functionCall(target, data, "Address: low-level call failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
212      * `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCall(
217         address target,
218         bytes memory data,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         return functionCallWithValue(target, data, 0, errorMessage);
222     }
223 
224 
225     function functionCallWithValue(
226         address target,
227         bytes memory data,
228         uint256 value
229     ) internal returns (bytes memory) {
230         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
231     }
232 
233     function functionCallWithValue(
234         address target,
235         bytes memory data,
236         uint256 value,
237         string memory errorMessage
238     ) internal returns (bytes memory) {
239         require(address(this).balance >= value, "Address: insufficient balance for call");
240         require(isContract(target), "Address: call to non-contract");
241 
242         (bool success, bytes memory returndata) = target.call{value: value}(data);
243         return verifyCallResult(success, returndata, errorMessage);
244     }
245 
246 
247     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
248         return functionStaticCall(target, data, "Address: low-level static call failed");
249     }
250 
251  
252     function functionStaticCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal view returns (bytes memory) {
257         require(isContract(target), "Address: static call to non-contract");
258 
259         (bool success, bytes memory returndata) = target.staticcall(data);
260         return verifyCallResult(success, returndata, errorMessage);
261     }
262 
263 
264     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
266     }
267 
268   
269     function functionDelegateCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         require(isContract(target), "Address: delegate call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.delegatecall(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280  
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292 
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
305 
306 
307 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
308 
309 pragma solidity >=0.7.0 <0.9.0;
310 
311 interface IERC721Receiver {
312 
313     function onERC721Received(
314         address operator,
315         address from,
316         uint256 tokenId,
317         bytes calldata data
318     ) external returns (bytes4);
319 }
320 
321 
322 
323 pragma solidity >=0.7.0 <0.9.0;
324 
325 
326 interface IERC165 {
327 
328     function supportsInterface(bytes4 interfaceId) external view returns (bool);
329 }
330 
331 
332 pragma solidity >=0.7.0 <0.9.0;
333 
334 
335 abstract contract ERC165 is IERC165 {
336     /**
337      * @dev See {IERC165-supportsInterface}.
338      */
339     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
340         return interfaceId == type(IERC165).interfaceId;
341     }
342 }
343 
344 
345 
346 pragma solidity >=0.7.0 <0.9.0;
347 
348 
349 /**
350  * @dev Required interface of an ERC721 compliant contract.
351  */
352 interface IERC721 is IERC165 {
353     /**
354      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
355      */
356     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
357 
358     /**
359      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
360      */
361     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
362 
363     /**
364      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
365      */
366     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
367 
368     /**
369      * @dev Returns the number of tokens in ``owner``'s account.
370      */
371     function balanceOf(address owner) external view returns (uint256 balance);
372 
373     function ownerOf(uint256 tokenId) external view returns (address owner);
374 
375     function safeTransferFrom(
376         address from,
377         address to,
378         uint256 tokenId
379     ) external;
380 
381 
382     function transferFrom(
383         address from,
384         address to,
385         uint256 tokenId
386     ) external;
387 
388 
389     function approve(address to, uint256 tokenId) external;
390 
391 
392     function getApproved(uint256 tokenId) external view returns (address operator);
393 
394     function setApprovalForAll(address operator, bool _approved) external;
395 
396     function isApprovedForAll(address owner, address operator) external view returns (bool);
397 
398     
399     function safeTransferFrom(
400         address from,
401         address to,
402         uint256 tokenId,
403         bytes calldata data
404     ) external;
405 }
406 
407 
408 
409 pragma solidity >=0.7.0 <0.9.0;
410 
411 
412 
413 interface IERC721Metadata is IERC721 {
414     /**
415      * @dev Returns the token collection name.
416      */
417     function name() external view returns (string memory);
418 
419     /**
420      * @dev Returns the token collection symbol.
421      */
422     function symbol() external view returns (string memory);
423 
424     /**
425      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
426      */
427     function tokenURI(uint256 tokenId) external view returns (string memory);
428 }
429 
430 
431 pragma solidity >=0.7.0 <0.9.0;
432 
433 
434 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
435     using Address for address;
436     using Strings for uint256;
437 
438     // Token name
439     string private _name;
440 
441     // Token symbol
442     string private _symbol;
443 
444     // Mapping from token ID to owner address
445     mapping(uint256 => address) private _owners;
446 
447     // Mapping owner address to token count
448     mapping(address => uint256) private _balances;
449 
450     // Mapping from token ID to approved address
451     mapping(uint256 => address) private _tokenApprovals;
452 
453     // Mapping from owner to operator approvals
454     mapping(address => mapping(address => bool)) private _operatorApprovals;
455 
456     /**
457      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
458      */
459     constructor(string memory name_, string memory symbol_) {
460         _name = name_;
461         _symbol = symbol_;
462     }
463 
464     /**
465      * @dev See {IERC165-supportsInterface}.
466      */
467     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
468         return
469             interfaceId == type(IERC721).interfaceId ||
470             interfaceId == type(IERC721Metadata).interfaceId ||
471             super.supportsInterface(interfaceId);
472     }
473 
474     /**
475      * @dev See {IERC721-balanceOf}.
476      */
477     function balanceOf(address owner) public view virtual override returns (uint256) {
478         require(owner != address(0), "ERC721: balance query for the zero address");
479         return _balances[owner];
480     }
481 
482     /**
483      * @dev See {IERC721-ownerOf}.
484      */
485     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
486         address owner = _owners[tokenId];
487         require(owner != address(0), "ERC721: owner query for nonexistent token");
488         return owner;
489     }
490 
491     /**
492      * @dev See {IERC721Metadata-name}.
493      */
494     function name() public view virtual override returns (string memory) {
495         return _name;
496     }
497 
498     /**
499      * @dev See {IERC721Metadata-symbol}.
500      */
501     function symbol() public view virtual override returns (string memory) {
502         return _symbol;
503     }
504 
505     /**
506      * @dev See {IERC721Metadata-tokenURI}.
507      */
508     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
509         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
510 
511         string memory baseURI = _baseURI();
512         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
513     }
514 
515 
516     function _baseURI() internal view virtual returns (string memory) {
517         return "";
518     }
519 
520     /**
521      * @dev See {IERC721-approve}.
522      */
523     function approve(address to, uint256 tokenId) public virtual override {
524         address owner = ERC721.ownerOf(tokenId);
525         require(to != owner, "ERC721: approval to current owner");
526 
527         require(
528             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
529             "ERC721: approve caller is not owner nor approved for all"
530         );
531 
532         _approve(to, tokenId);
533     }
534 
535     /**
536      * @dev See {IERC721-getApproved}.
537      */
538     function getApproved(uint256 tokenId) public view virtual override returns (address) {
539         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
540 
541         return _tokenApprovals[tokenId];
542     }
543 
544     /**
545      * @dev See {IERC721-setApprovalForAll}.
546      */
547     function setApprovalForAll(address operator, bool approved) public virtual override {
548         _setApprovalForAll(_msgSender(), operator, approved);
549     }
550 
551     /**
552      * @dev See {IERC721-isApprovedForAll}.
553      */
554     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
555         return _operatorApprovals[owner][operator];
556     }
557 
558     /**
559      * @dev See {IERC721-transferFrom}.
560      */
561     function transferFrom(
562         address from,
563         address to,
564         uint256 tokenId
565     ) public virtual override {
566         //solhint-disable-next-line max-line-length
567         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
568 
569         _transfer(from, to, tokenId);
570     }
571 
572     /**
573      * @dev See {IERC721-safeTransferFrom}.
574      */
575     function safeTransferFrom(
576         address from,
577         address to,
578         uint256 tokenId
579     ) public virtual override {
580         safeTransferFrom(from, to, tokenId, "");
581     }
582 
583     /**
584      * @dev See {IERC721-safeTransferFrom}.
585      */
586     function safeTransferFrom(
587         address from,
588         address to,
589         uint256 tokenId,
590         bytes memory _data
591     ) public virtual override {
592         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
593         _safeTransfer(from, to, tokenId, _data);
594     }
595 
596 
597     function _safeTransfer(
598         address from,
599         address to,
600         uint256 tokenId,
601         bytes memory _data
602     ) internal virtual {
603         _transfer(from, to, tokenId);
604         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
605     }
606 
607 
608     function _exists(uint256 tokenId) internal view virtual returns (bool) {
609         return _owners[tokenId] != address(0);
610     }
611 
612 
613     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
614         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
615         address owner = ERC721.ownerOf(tokenId);
616         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
617     }
618 
619 
620     function _safeMint(address to, uint256 tokenId) internal virtual {
621         _safeMint(to, tokenId, "");
622     }
623 
624   
625     function _safeMint(
626         address to,
627         uint256 tokenId,
628         bytes memory _data
629     ) internal virtual {
630         _mint(to, tokenId);
631         require(
632             _checkOnERC721Received(address(0), to, tokenId, _data),
633             "ERC721: transfer to non ERC721Receiver implementer"
634         );
635     }
636 
637 
638     function _mint(address to, uint256 tokenId) internal virtual {
639         require(to != address(0), "ERC721: mint to the zero address");
640         require(!_exists(tokenId), "ERC721: token already minted");
641 
642         _beforeTokenTransfer(address(0), to, tokenId);
643 
644         _balances[to] += 1;
645         _owners[tokenId] = to;
646 
647         emit Transfer(address(0), to, tokenId);
648     }
649 
650     function _burn(uint256 tokenId) internal virtual {
651         address owner = ERC721.ownerOf(tokenId);
652 
653         _beforeTokenTransfer(owner, address(0), tokenId);
654 
655         // Clear approvals
656         _approve(address(0), tokenId);
657 
658         _balances[owner] -= 1;
659         delete _owners[tokenId];
660 
661         emit Transfer(owner, address(0), tokenId);
662     }
663 
664 
665     function _transfer(
666         address from,
667         address to,
668         uint256 tokenId
669     ) internal virtual {
670         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
671         require(to != address(0), "ERC721: transfer to the zero address");
672 
673         _beforeTokenTransfer(from, to, tokenId);
674 
675         // Clear approvals from the previous owner
676         _approve(address(0), tokenId);
677 
678         _balances[from] -= 1;
679         _balances[to] += 1;
680         _owners[tokenId] = to;
681 
682         emit Transfer(from, to, tokenId);
683     }
684 
685 
686     function _approve(address to, uint256 tokenId) internal virtual {
687         _tokenApprovals[tokenId] = to;
688         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
689     }
690 
691 
692     function _setApprovalForAll(
693         address owner,
694         address operator,
695         bool approved
696     ) internal virtual {
697         require(owner != operator, "ERC721: approve to caller");
698         _operatorApprovals[owner][operator] = approved;
699         emit ApprovalForAll(owner, operator, approved);
700     }
701 
702 
703     function _checkOnERC721Received(
704         address from,
705         address to,
706         uint256 tokenId,
707         bytes memory _data
708     ) private returns (bool) {
709         if (to.isContract()) {
710             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
711                 return retval == IERC721Receiver.onERC721Received.selector;
712             } catch (bytes memory reason) {
713                 if (reason.length == 0) {
714                     revert("ERC721: transfer to non ERC721Receiver implementer");
715                 } else {
716                     assembly {
717                         revert(add(32, reason), mload(reason))
718                     }
719                 }
720             }
721         } else {
722             return true;
723         }
724     }
725 
726 
727     function _beforeTokenTransfer(
728         address from,
729         address to,
730         uint256 tokenId
731     ) internal virtual {}
732 }
733 
734 
735 // File: contracts/Parrot1.sol
736 
737 
738 
739 pragma solidity >=0.7.0 <0.9.0;
740 
741 contract Ogreland is ERC721, Ownable {
742   using Strings for uint256;
743   using Counters for Counters.Counter;
744 
745   Counters.Counter private supply;
746 
747   string public uriPrefix = "";
748   string public uriSuffix = ".json";
749   string public hiddenMetadataUri;
750   
751   uint256 public cost2 = 0 ether;
752   uint256 public cost = 0.0009 ether;
753   uint256 public maxSupply = 10000;
754   uint256 public maxSupplyPublic = 9500;
755   uint256 public maxMintAmountPerTx = 2;
756   uint256 public nftPerAddressLimit = 2;
757 
758   bool public paused = true;
759   bool public revealed = false;
760 
761   mapping(address => uint256) public addressMintedBalance;
762 
763   constructor() ERC721("Ogreland", "OGRE") {
764     setHiddenMetadataUri("ipfs://QmY1yHhe5N5kkBBm9LjgX9oexsC9SCCaSji3r9ERxfPvk5/hidden.json");
765   }
766 
767   modifier mintCompliance(uint256 _mintAmount) {
768     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
769     require(supply.current() + _mintAmount <= maxSupplyPublic, "Max Public supply exceeded!");
770     _;
771   }
772 
773   modifier mintCompliance2(uint256 _mintAmount) {
774     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
775     _;
776   }
777 
778   function totalSupply() public view returns (uint256) {
779     return supply.current();
780   }
781 
782   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
783     require(!paused, "The contract is paused!");
784     if ( supply.current() < 5000 ){
785         require(msg.value >= cost2 * _mintAmount, "Insufficient funds!");
786     }
787     else{
788         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
789     }
790     
791     _mintLoop(msg.sender, _mintAmount);
792   }
793   
794   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance2(_mintAmount) onlyOwner {
795     _mintLoop2(_receiver, _mintAmount);
796   }
797 
798   function walletOfOwner(address _owner)
799     public
800     view
801     returns (uint256[] memory)
802   {
803     uint256 ownerTokenCount = balanceOf(_owner);
804     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
805     uint256 currentTokenId = 1;
806     uint256 ownedTokenIndex = 0;
807 
808     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
809       address currentTokenOwner = ownerOf(currentTokenId);
810 
811       if (currentTokenOwner == _owner) {
812         ownedTokenIds[ownedTokenIndex] = currentTokenId;
813 
814         ownedTokenIndex++;
815       }
816 
817       currentTokenId++;
818     }
819 
820     return ownedTokenIds;
821   }
822 
823   function tokenURI(uint256 _tokenId)
824     public
825     view
826     virtual
827     override
828     returns (string memory)
829   {
830     require(
831       _exists(_tokenId),
832       "ERC721Metadata: URI query for nonexistent token"
833     );
834 
835     if (revealed == false) {
836       return hiddenMetadataUri;
837     }
838 
839     string memory currentBaseURI = _baseURI();
840     return bytes(currentBaseURI).length > 0
841         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
842         : "";
843   }
844 
845   function setRevealed(bool _state) public onlyOwner {
846     revealed = _state;
847   }
848 
849   function setCost(uint256 _cost) public onlyOwner {
850     cost = _cost;
851   }
852 
853   function setCost2(uint256 _cost2) public onlyOwner {
854     cost2 = _cost2;
855   }
856 
857   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
858     maxMintAmountPerTx = _maxMintAmountPerTx;
859   }
860 
861   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
862     maxSupply = _maxSupply;
863   }
864 
865   function setMaxSupplyPublic(uint256 _maxSupplyPublic) public onlyOwner {
866     maxSupplyPublic = _maxSupplyPublic;
867   }
868 
869   function setnftPerAddressLimit(uint256 _nftPerAddressLimit) public onlyOwner {
870     nftPerAddressLimit = _nftPerAddressLimit;
871   }
872 
873   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
874     hiddenMetadataUri = _hiddenMetadataUri;
875   }
876 
877   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
878     uriPrefix = _uriPrefix;
879   }
880 
881   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
882     uriSuffix = _uriSuffix;
883   }
884 
885   function setPaused(bool _state) public onlyOwner {
886     paused = _state;
887   }
888 
889   function withdraw() public onlyOwner {
890     // =============================================================================
891     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
892     require(os);
893     // =============================================================================
894   }
895 
896   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
897 
898     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
899     require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
900     
901     for (uint256 i = 0; i < _mintAmount; i++) {
902       supply.increment();
903       addressMintedBalance[msg.sender]++;
904       _safeMint(_receiver, supply.current());
905     }
906   }
907 
908   function _mintLoop2(address _receiver, uint256 _mintAmount) internal {
909     for (uint256 i = 0; i < _mintAmount; i++) {
910       supply.increment();
911       _safeMint(_receiver, supply.current());
912     }
913   }
914 
915   function _baseURI() internal view virtual override returns (string memory) {
916     return uriPrefix;
917   }
918 }