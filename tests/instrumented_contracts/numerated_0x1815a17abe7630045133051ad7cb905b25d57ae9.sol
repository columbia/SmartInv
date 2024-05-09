1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     constructor() {
20         _setOwner(_msgSender());
21     }
22 
23     function owner() public view virtual returns (address) {
24         return _owner;
25     }
26 
27     modifier onlyOwner() {
28         require(owner() == _msgSender(), "Ownable: caller is not the owner");
29         _;
30     }
31 
32     function renounceOwnership() public virtual onlyOwner {
33         _setOwner(address(0));
34     }
35 
36     function transferOwnership(address newOwner) public virtual onlyOwner {
37         require(newOwner != address(0), "Ownable: new owner is the zero address");
38         _setOwner(newOwner);
39     }
40 
41     function _setOwner(address newOwner) private {
42         address oldOwner = _owner;
43         _owner = newOwner;
44         emit OwnershipTransferred(oldOwner, newOwner);
45     }
46 }
47 
48 interface IERC165 {
49 
50     function supportsInterface(bytes4 interfaceId) external view returns (bool);
51 }
52 
53 interface IERC721 is IERC165 {
54 
55     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
56 
57     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
58 
59     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
60 
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     function safeTransferFrom(
66         address from,
67         address to,
68         uint256 tokenId
69     ) external;
70 
71     function transferFrom(
72         address from,
73         address to,
74         uint256 tokenId
75     ) external;
76 
77     function approve(address to, uint256 tokenId) external;
78 
79     function getApproved(uint256 tokenId) external view returns (address operator);
80 
81     function setApprovalForAll(address operator, bool _approved) external;
82 
83     function isApprovedForAll(address owner, address operator) external view returns (bool);
84 
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId,
89         bytes calldata data
90     ) external;
91 }
92 
93 interface IERC721Enumerable is IERC721 {
94 
95     function totalSupply() external view returns (uint256);
96 
97     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
98 
99     function tokenByIndex(uint256 index) external view returns (uint256);
100 }
101 
102 
103 abstract contract ERC165 is IERC165 {
104     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
105         return interfaceId == type(IERC165).interfaceId;
106     }
107 }
108 
109 library Strings {
110     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
111 
112     function toString(uint256 value) internal pure returns (string memory) {
113 
114         if (value == 0) {
115             return "0";
116         }
117         uint256 temp = value;
118         uint256 digits;
119         while (temp != 0) {
120             digits++;
121             temp /= 10;
122         }
123         bytes memory buffer = new bytes(digits);
124         while (value != 0) {
125             digits -= 1;
126             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
127             value /= 10;
128         }
129         return string(buffer);
130     }
131 
132     function toHexString(uint256 value) internal pure returns (string memory) {
133         if (value == 0) {
134             return "0x00";
135         }
136         uint256 temp = value;
137         uint256 length = 0;
138         while (temp != 0) {
139             length++;
140             temp >>= 8;
141         }
142         return toHexString(value, length);
143     }
144 
145     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
146         bytes memory buffer = new bytes(2 * length + 2);
147         buffer[0] = "0";
148         buffer[1] = "x";
149         for (uint256 i = 2 * length + 1; i > 1; --i) {
150             buffer[i] = _HEX_SYMBOLS[value & 0xf];
151             value >>= 4;
152         }
153         require(value == 0, "Strings: hex length insufficient");
154         return string(buffer);
155     }
156 }
157 
158 library Address {
159 
160     function isContract(address account) internal view returns (bool) {
161 
162         uint256 size;
163         assembly {
164             size := extcodesize(account)
165         }
166         return size > 0;
167     }
168 
169     function sendValue(address payable recipient, uint256 amount) internal {
170         require(address(this).balance >= amount, "Address: insufficient balance");
171 
172         (bool success, ) = recipient.call{value: amount}("");
173         require(success, "Address: unable to send value, recipient may have reverted");
174     }
175 
176     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionCall(target, data, "Address: low-level call failed");
178     }
179 
180     function functionCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, 0, errorMessage);
186     }
187 
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value
192     ) internal returns (bytes memory) {
193         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
194     }
195 
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         require(address(this).balance >= value, "Address: insufficient balance for call");
203         require(isContract(target), "Address: call to non-contract");
204 
205         (bool success, bytes memory returndata) = target.call{value: value}(data);
206         return verifyCallResult(success, returndata, errorMessage);
207     }
208 
209     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
210         return functionStaticCall(target, data, "Address: low-level static call failed");
211     }
212 
213     function functionStaticCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal view returns (bytes memory) {
218         require(isContract(target), "Address: static call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.staticcall(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
225         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
226     }
227 
228     function functionDelegateCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         require(isContract(target), "Address: delegate call to non-contract");
234 
235         (bool success, bytes memory returndata) = target.delegatecall(data);
236         return verifyCallResult(success, returndata, errorMessage);
237     }
238 
239     function verifyCallResult(
240         bool success,
241         bytes memory returndata,
242         string memory errorMessage
243     ) internal pure returns (bytes memory) {
244         if (success) {
245             return returndata;
246         } else {
247 
248             if (returndata.length > 0) {
249 
250                 assembly {
251                     let returndata_size := mload(returndata)
252                     revert(add(32, returndata), returndata_size)
253                 }
254             } else {
255                 revert(errorMessage);
256             }
257         }
258     }
259 }
260 
261 interface IERC721Metadata is IERC721 {
262 
263     function name() external view returns (string memory);
264 
265     function symbol() external view returns (string memory);
266 
267     function tokenURI(uint256 tokenId) external view returns (string memory);
268 }
269 
270 interface IERC721Receiver {
271 
272     function onERC721Received(
273         address operator,
274         address from,
275         uint256 tokenId,
276         bytes calldata data
277     ) external returns (bytes4);
278 }
279 
280 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
281     using Address for address;
282     using Strings for uint256;
283 
284     string private _name;
285 
286     string private _symbol;
287 
288     mapping(uint256 => address) private _owners;
289 
290     mapping(address => uint256) private _balances;
291 
292     mapping(uint256 => address) private _tokenApprovals;
293 
294     mapping(address => mapping(address => bool)) private _operatorApprovals;
295 
296     constructor(string memory name_, string memory symbol_) {
297         _name = name_;
298         _symbol = symbol_;
299     }
300 
301     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
302         return
303             interfaceId == type(IERC721).interfaceId ||
304             interfaceId == type(IERC721Metadata).interfaceId ||
305             super.supportsInterface(interfaceId);
306     }
307 
308     function balanceOf(address owner) public view virtual override returns (uint256) {
309         require(owner != address(0), "ERC721: balance query for the zero address");
310         return _balances[owner];
311     }
312 
313     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
314         address owner = _owners[tokenId];
315         require(owner != address(0), "ERC721: owner query for nonexistent token");
316         return owner;
317     }
318 
319     function name() public view virtual override returns (string memory) {
320         return _name;
321     }
322 
323     function symbol() public view virtual override returns (string memory) {
324         return _symbol;
325     }
326 
327     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
328         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
329 
330         string memory baseURI = _baseURI();
331         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
332     }
333 
334     function _baseURI() internal view virtual returns (string memory) {
335         return "";
336     }
337 
338     function approve(address to, uint256 tokenId) public virtual override {
339         address owner = ERC721.ownerOf(tokenId);
340         require(to != owner, "ERC721: approval to current owner");
341 
342         require(
343             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
344             "ERC721: approve caller is not owner nor approved for all"
345         );
346 
347         _approve(to, tokenId);
348     }
349 
350     function getApproved(uint256 tokenId) public view virtual override returns (address) {
351         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
352 
353         return _tokenApprovals[tokenId];
354     }
355 
356     function setApprovalForAll(address operator, bool approved) public virtual override {
357         require(operator != _msgSender(), "ERC721: approve to caller");
358 
359         _operatorApprovals[_msgSender()][operator] = approved;
360         emit ApprovalForAll(_msgSender(), operator, approved);
361     }
362 
363     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
364         return _operatorApprovals[owner][operator];
365     }
366 
367     function transferFrom(
368         address from,
369         address to,
370         uint256 tokenId
371     ) public virtual override {
372         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
373 
374         _transfer(from, to, tokenId);
375     }
376 
377     function safeTransferFrom(
378         address from,
379         address to,
380         uint256 tokenId
381     ) public virtual override {
382         safeTransferFrom(from, to, tokenId, "");
383     }
384 
385     function safeTransferFrom(
386         address from,
387         address to,
388         uint256 tokenId,
389         bytes memory _data
390     ) public virtual override {
391         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
392         _safeTransfer(from, to, tokenId, _data);
393     }
394 
395     function _safeTransfer(
396         address from,
397         address to,
398         uint256 tokenId,
399         bytes memory _data
400     ) internal virtual {
401         _transfer(from, to, tokenId);
402         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
403     }
404 
405     function _exists(uint256 tokenId) internal view virtual returns (bool) {
406         return _owners[tokenId] != address(0);
407     }
408 
409     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
410         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
411         address owner = ERC721.ownerOf(tokenId);
412         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
413     }
414 
415     function _safeMint(address to, uint256 tokenId) internal virtual {
416         _safeMint(to, tokenId, "");
417     }
418 
419     function _safeMint(
420         address to,
421         uint256 tokenId,
422         bytes memory _data
423     ) internal virtual {
424         _mint(to, tokenId);
425         require(
426             _checkOnERC721Received(address(0), to, tokenId, _data),
427             "ERC721: transfer to non ERC721Receiver implementer"
428         );
429     }
430 
431     function _mint(address to, uint256 tokenId) internal virtual {
432         require(to != address(0), "ERC721: mint to the zero address");
433         require(!_exists(tokenId), "ERC721: token already minted");
434 
435         _beforeTokenTransfer(address(0), to, tokenId);
436 
437         _balances[to] += 1;
438         _owners[tokenId] = to;
439 
440         emit Transfer(address(0), to, tokenId);
441     }
442 
443     function _burn(uint256 tokenId) internal virtual {
444         address owner = ERC721.ownerOf(tokenId);
445 
446         _beforeTokenTransfer(owner, address(0), tokenId);
447 
448         _approve(address(0), tokenId);
449 
450         _balances[owner] -= 1;
451         delete _owners[tokenId];
452 
453         emit Transfer(owner, address(0), tokenId);
454     }
455 
456     function _transfer(
457         address from,
458         address to,
459         uint256 tokenId
460     ) internal virtual {
461         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
462         require(to != address(0), "ERC721: transfer to the zero address");
463 
464         _beforeTokenTransfer(from, to, tokenId);
465 
466         _approve(address(0), tokenId);
467 
468         _balances[from] -= 1;
469         _balances[to] += 1;
470         _owners[tokenId] = to;
471 
472         emit Transfer(from, to, tokenId);
473     }
474 
475     function _approve(address to, uint256 tokenId) internal virtual {
476         _tokenApprovals[tokenId] = to;
477         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
478     }
479 
480     function _checkOnERC721Received(
481         address from,
482         address to,
483         uint256 tokenId,
484         bytes memory _data
485     ) private returns (bool) {
486         if (to.isContract()) {
487             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
488                 return retval == IERC721Receiver.onERC721Received.selector;
489             } catch (bytes memory reason) {
490                 if (reason.length == 0) {
491                     revert("ERC721: transfer to non ERC721Receiver implementer");
492                 } else {
493                     assembly {
494                         revert(add(32, reason), mload(reason))
495                     }
496                 }
497             }
498         } else {
499             return true;
500         }
501     }
502 
503     function _beforeTokenTransfer(
504         address from,
505         address to,
506         uint256 tokenId
507     ) internal virtual {}
508 }
509 
510 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
511     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
512 
513     mapping(uint256 => uint256) private _ownedTokensIndex;
514 
515     uint256[] private _allTokens;
516 
517     mapping(uint256 => uint256) private _allTokensIndex;
518 
519     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
520         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
521     }
522 
523     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
524         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
525         return _ownedTokens[owner][index];
526     }
527 
528     function totalSupply() public view virtual override returns (uint256) {
529         return _allTokens.length;
530     }
531 
532     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
533         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
534         return _allTokens[index];
535     }
536 
537     function _beforeTokenTransfer(
538         address from,
539         address to,
540         uint256 tokenId
541     ) internal virtual override {
542         super._beforeTokenTransfer(from, to, tokenId);
543 
544         if (from == address(0)) {
545             _addTokenToAllTokensEnumeration(tokenId);
546         } else if (from != to) {
547             _removeTokenFromOwnerEnumeration(from, tokenId);
548         }
549         if (to == address(0)) {
550             _removeTokenFromAllTokensEnumeration(tokenId);
551         } else if (to != from) {
552             _addTokenToOwnerEnumeration(to, tokenId);
553         }
554     }
555 
556     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
557         uint256 length = ERC721.balanceOf(to);
558         _ownedTokens[to][length] = tokenId;
559         _ownedTokensIndex[tokenId] = length;
560     }
561 
562     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
563         _allTokensIndex[tokenId] = _allTokens.length;
564         _allTokens.push(tokenId);
565     }
566 
567     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
568 
569         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
570         uint256 tokenIndex = _ownedTokensIndex[tokenId];
571 
572         if (tokenIndex != lastTokenIndex) {
573             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
574 
575             _ownedTokens[from][tokenIndex] = lastTokenId; 
576             _ownedTokensIndex[lastTokenId] = tokenIndex;
577         }
578 
579 
580         delete _ownedTokensIndex[tokenId];
581         delete _ownedTokens[from][lastTokenIndex];
582     }
583 
584     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
585 
586         uint256 lastTokenIndex = _allTokens.length - 1;
587         uint256 tokenIndex = _allTokensIndex[tokenId];
588 
589         uint256 lastTokenId = _allTokens[lastTokenIndex];
590 
591         _allTokens[tokenIndex] = lastTokenId;
592         _allTokensIndex[lastTokenId] = tokenIndex;
593 
594         delete _allTokensIndex[tokenId];
595         _allTokens.pop();
596     }
597 }
598 
599 /**
600  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
601  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
602  *
603  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
604  *
605  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
606  *
607  * Does not support burning tokens to address(0).
608  */
609 contract ERC721A is
610   Context,
611   ERC165,
612   IERC721,
613   IERC721Metadata,
614   IERC721Enumerable
615 {
616   using Address for address;
617   using Strings for uint256;
618 
619   struct TokenOwnership {
620     address addr;
621     uint64 startTimestamp;
622   }
623 
624   struct AddressData {
625     uint128 balance;
626     uint128 numberMinted;
627   }
628 
629   uint256 private currentIndex = 0;
630 
631   uint256 internal immutable collectionSize;
632   uint256 internal immutable maxBatchSize;
633 
634   // Token name
635   string private _name;
636 
637   // Token symbol
638   string private _symbol;
639 
640   // Mapping from token ID to ownership details
641   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
642   mapping(uint256 => TokenOwnership) private _ownerships;
643 
644   // Mapping owner address to address data
645   mapping(address => AddressData) private _addressData;
646 
647   // Mapping from token ID to approved address
648   mapping(uint256 => address) private _tokenApprovals;
649 
650   // Mapping from owner to operator approvals
651   mapping(address => mapping(address => bool)) private _operatorApprovals;
652 
653   /**
654    * @dev
655    * `maxBatchSize` refers to how much a minter can mint at a time.
656    * `collectionSize_` refers to how many tokens are in the collection.
657    */
658   constructor(
659     string memory name_,
660     string memory symbol_,
661     uint256 maxBatchSize_,
662     uint256 collectionSize_
663   ) {
664     require(
665       collectionSize_ > 0,
666       "ERC721A: collection must have a nonzero supply"
667     );
668     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
669     _name = name_;
670     _symbol = symbol_;
671     maxBatchSize = maxBatchSize_;
672     collectionSize = collectionSize_;
673   }
674 
675   /**
676    * @dev See {IERC721Enumerable-totalSupply}.
677    */
678   function totalSupply() public view override returns (uint256) {
679     return currentIndex;
680   }
681 
682   /**
683    * @dev See {IERC721Enumerable-tokenByIndex}.
684    */
685   function tokenByIndex(uint256 index) public view override returns (uint256) {
686     require(index < totalSupply(), "ERC721A: global index out of bounds");
687     return index;
688   }
689 
690   /**
691    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
692    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
693    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
694    */
695   function tokenOfOwnerByIndex(address owner, uint256 index)
696     public
697     view
698     override
699     returns (uint256)
700   {
701     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
702     uint256 numMintedSoFar = totalSupply();
703     uint256 tokenIdsIdx = 0;
704     address currOwnershipAddr = address(0);
705     for (uint256 i = 0; i < numMintedSoFar; i++) {
706       TokenOwnership memory ownership = _ownerships[i];
707       if (ownership.addr != address(0)) {
708         currOwnershipAddr = ownership.addr;
709       }
710       if (currOwnershipAddr == owner) {
711         if (tokenIdsIdx == index) {
712           return i;
713         }
714         tokenIdsIdx++;
715       }
716     }
717     revert("ERC721A: unable to get token of owner by index");
718   }
719 
720   /**
721    * @dev See {IERC165-supportsInterface}.
722    */
723   function supportsInterface(bytes4 interfaceId)
724     public
725     view
726     virtual
727     override(ERC165, IERC165)
728     returns (bool)
729   {
730     return
731       interfaceId == type(IERC721).interfaceId ||
732       interfaceId == type(IERC721Metadata).interfaceId ||
733       interfaceId == type(IERC721Enumerable).interfaceId ||
734       super.supportsInterface(interfaceId);
735   }
736 
737   /**
738    * @dev See {IERC721-balanceOf}.
739    */
740   function balanceOf(address owner) public view override returns (uint256) {
741     require(owner != address(0), "ERC721A: balance query for the zero address");
742     return uint256(_addressData[owner].balance);
743   }
744 
745   function _numberMinted(address owner) internal view returns (uint256) {
746     require(
747       owner != address(0),
748       "ERC721A: number minted query for the zero address"
749     );
750     return uint256(_addressData[owner].numberMinted);
751   }
752 
753   function ownershipOf(uint256 tokenId)
754     internal
755     view
756     returns (TokenOwnership memory)
757   {
758     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
759 
760     uint256 lowestTokenToCheck;
761     if (tokenId >= maxBatchSize) {
762       lowestTokenToCheck = tokenId - maxBatchSize + 1;
763     }
764 
765     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
766       TokenOwnership memory ownership = _ownerships[curr];
767       if (ownership.addr != address(0)) {
768         return ownership;
769       }
770     }
771 
772     revert("ERC721A: unable to determine the owner of token");
773   }
774 
775   /**
776    * @dev See {IERC721-ownerOf}.
777    */
778   function ownerOf(uint256 tokenId) public view override returns (address) {
779     return ownershipOf(tokenId).addr;
780   }
781 
782   /**
783    * @dev See {IERC721Metadata-name}.
784    */
785   function name() public view virtual override returns (string memory) {
786     return _name;
787   }
788 
789   /**
790    * @dev See {IERC721Metadata-symbol}.
791    */
792   function symbol() public view virtual override returns (string memory) {
793     return _symbol;
794   }
795 
796   /**
797    * @dev See {IERC721Metadata-tokenURI}.
798    */
799   function tokenURI(uint256 tokenId)
800     public
801     view
802     virtual
803     override
804     returns (string memory)
805   {
806     require(
807       _exists(tokenId),
808       "ERC721Metadata: URI query for nonexistent token"
809     );
810 
811     string memory baseURI = _baseURI();
812     return
813       bytes(baseURI).length > 0
814         ? string(abi.encodePacked(baseURI, tokenId.toString()))
815         : "";
816   }
817 
818   /**
819    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
820    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
821    * by default, can be overriden in child contracts.
822    */
823   function _baseURI() internal view virtual returns (string memory) {
824     return "";
825   }
826 
827   /**
828    * @dev See {IERC721-approve}.
829    */
830   function approve(address to, uint256 tokenId) public override {
831     address owner = ERC721A.ownerOf(tokenId);
832     require(to != owner, "ERC721A: approval to current owner");
833 
834     require(
835       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
836       "ERC721A: approve caller is not owner nor approved for all"
837     );
838 
839     _approve(to, tokenId, owner);
840   }
841 
842   /**
843    * @dev See {IERC721-getApproved}.
844    */
845   function getApproved(uint256 tokenId) public view override returns (address) {
846     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
847 
848     return _tokenApprovals[tokenId];
849   }
850 
851   /**
852    * @dev See {IERC721-setApprovalForAll}.
853    */
854   function setApprovalForAll(address operator, bool approved) public override {
855     require(operator != _msgSender(), "ERC721A: approve to caller");
856 
857     _operatorApprovals[_msgSender()][operator] = approved;
858     emit ApprovalForAll(_msgSender(), operator, approved);
859   }
860 
861   /**
862    * @dev See {IERC721-isApprovedForAll}.
863    */
864   function isApprovedForAll(address owner, address operator)
865     public
866     view
867     virtual
868     override
869     returns (bool)
870   {
871     return _operatorApprovals[owner][operator];
872   }
873 
874   /**
875    * @dev See {IERC721-transferFrom}.
876    */
877   function transferFrom(
878     address from,
879     address to,
880     uint256 tokenId
881   ) public override {
882     _transfer(from, to, tokenId);
883   }
884 
885   /**
886    * @dev See {IERC721-safeTransferFrom}.
887    */
888   function safeTransferFrom(
889     address from,
890     address to,
891     uint256 tokenId
892   ) public override {
893     safeTransferFrom(from, to, tokenId, "");
894   }
895 
896   /**
897    * @dev See {IERC721-safeTransferFrom}.
898    */
899   function safeTransferFrom(
900     address from,
901     address to,
902     uint256 tokenId,
903     bytes memory _data
904   ) public override {
905     _transfer(from, to, tokenId);
906     require(
907       _checkOnERC721Received(from, to, tokenId, _data),
908       "ERC721A: transfer to non ERC721Receiver implementer"
909     );
910   }
911 
912   /**
913    * @dev Returns whether `tokenId` exists.
914    *
915    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
916    *
917    * Tokens start existing when they are minted (`_mint`),
918    */
919   function _exists(uint256 tokenId) internal view returns (bool) {
920     return tokenId < currentIndex;
921   }
922 
923   function _safeMint(address to, uint256 quantity) internal {
924     _safeMint(to, quantity, "");
925   }
926 
927   /**
928    * @dev Mints `quantity` tokens and transfers them to `to`.
929    *
930    * Requirements:
931    *
932    * - there must be `quantity` tokens remaining unminted in the total collection.
933    * - `to` cannot be the zero address.
934    * - `quantity` cannot be larger than the max batch size.
935    *
936    * Emits a {Transfer} event.
937    */
938   function _safeMint(
939     address to,
940     uint256 quantity,
941     bytes memory _data
942   ) internal {
943     uint256 startTokenId = currentIndex;
944     require(to != address(0), "ERC721A: mint to the zero address");
945     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
946     require(!_exists(startTokenId), "ERC721A: token already minted");
947     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
948 
949     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
950 
951     AddressData memory addressData = _addressData[to];
952     _addressData[to] = AddressData(
953       addressData.balance + uint128(quantity),
954       addressData.numberMinted + uint128(quantity)
955     );
956     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
957 
958     uint256 updatedIndex = startTokenId;
959 
960     for (uint256 i = 0; i < quantity; i++) {
961       emit Transfer(address(0), to, updatedIndex);
962       require(
963         _checkOnERC721Received(address(0), to, updatedIndex, _data),
964         "ERC721A: transfer to non ERC721Receiver implementer"
965       );
966       updatedIndex++;
967     }
968 
969     currentIndex = updatedIndex;
970     _afterTokenTransfers(address(0), to, startTokenId, quantity);
971   }
972 
973   /**
974    * @dev Transfers `tokenId` from `from` to `to`.
975    *
976    * Requirements:
977    *
978    * - `to` cannot be the zero address.
979    * - `tokenId` token must be owned by `from`.
980    *
981    * Emits a {Transfer} event.
982    */
983   function _transfer(
984     address from,
985     address to,
986     uint256 tokenId
987   ) private {
988     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
989 
990     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
991       getApproved(tokenId) == _msgSender() ||
992       isApprovedForAll(prevOwnership.addr, _msgSender()));
993 
994     require(
995       isApprovedOrOwner,
996       "ERC721A: transfer caller is not owner nor approved"
997     );
998 
999     require(
1000       prevOwnership.addr == from,
1001       "ERC721A: transfer from incorrect owner"
1002     );
1003     require(to != address(0), "ERC721A: transfer to the zero address");
1004 
1005     _beforeTokenTransfers(from, to, tokenId, 1);
1006 
1007     // Clear approvals from the previous owner
1008     _approve(address(0), tokenId, prevOwnership.addr);
1009 
1010     _addressData[from].balance -= 1;
1011     _addressData[to].balance += 1;
1012     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1013 
1014     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1015     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1016     uint256 nextTokenId = tokenId + 1;
1017     if (_ownerships[nextTokenId].addr == address(0)) {
1018       if (_exists(nextTokenId)) {
1019         _ownerships[nextTokenId] = TokenOwnership(
1020           prevOwnership.addr,
1021           prevOwnership.startTimestamp
1022         );
1023       }
1024     }
1025 
1026     emit Transfer(from, to, tokenId);
1027     _afterTokenTransfers(from, to, tokenId, 1);
1028   }
1029 
1030   /**
1031    * @dev Approve `to` to operate on `tokenId`
1032    *
1033    * Emits a {Approval} event.
1034    */
1035   function _approve(
1036     address to,
1037     uint256 tokenId,
1038     address owner
1039   ) private {
1040     _tokenApprovals[tokenId] = to;
1041     emit Approval(owner, to, tokenId);
1042   }
1043 
1044   uint256 public nextOwnerToExplicitlySet = 0;
1045 
1046   /**
1047    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1048    */
1049   function _setOwnersExplicit(uint256 quantity) internal {
1050     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1051     require(quantity > 0, "quantity must be nonzero");
1052     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1053     if (endIndex > collectionSize - 1) {
1054       endIndex = collectionSize - 1;
1055     }
1056     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1057     require(_exists(endIndex), "not enough minted yet for this cleanup");
1058     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1059       if (_ownerships[i].addr == address(0)) {
1060         TokenOwnership memory ownership = ownershipOf(i);
1061         _ownerships[i] = TokenOwnership(
1062           ownership.addr,
1063           ownership.startTimestamp
1064         );
1065       }
1066     }
1067     nextOwnerToExplicitlySet = endIndex + 1;
1068   }
1069 
1070   /**
1071    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1072    * The call is not executed if the target address is not a contract.
1073    *
1074    * @param from address representing the previous owner of the given token ID
1075    * @param to target address that will receive the tokens
1076    * @param tokenId uint256 ID of the token to be transferred
1077    * @param _data bytes optional data to send along with the call
1078    * @return bool whether the call correctly returned the expected magic value
1079    */
1080   function _checkOnERC721Received(
1081     address from,
1082     address to,
1083     uint256 tokenId,
1084     bytes memory _data
1085   ) private returns (bool) {
1086     if (to.isContract()) {
1087       try
1088         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1089       returns (bytes4 retval) {
1090         return retval == IERC721Receiver(to).onERC721Received.selector;
1091       } catch (bytes memory reason) {
1092         if (reason.length == 0) {
1093           revert("ERC721A: transfer to non ERC721Receiver implementer");
1094         } else {
1095           assembly {
1096             revert(add(32, reason), mload(reason))
1097           }
1098         }
1099       }
1100     } else {
1101       return true;
1102     }
1103   }
1104 
1105   /**
1106    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1107    *
1108    * startTokenId - the first token id to be transferred
1109    * quantity - the amount to be transferred
1110    *
1111    * Calling conditions:
1112    *
1113    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1114    * transferred to `to`.
1115    * - When `from` is zero, `tokenId` will be minted for `to`.
1116    */
1117   function _beforeTokenTransfers(
1118     address from,
1119     address to,
1120     uint256 startTokenId,
1121     uint256 quantity
1122   ) internal virtual {}
1123 
1124   /**
1125    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1126    * minting.
1127    *
1128    * startTokenId - the first token id to be transferred
1129    * quantity - the amount to be transferred
1130    *
1131    * Calling conditions:
1132    *
1133    * - when `from` and `to` are both non-zero.
1134    * - `from` and `to` are never both zero.
1135    */
1136   function _afterTokenTransfers(
1137     address from,
1138     address to,
1139     uint256 startTokenId,
1140     uint256 quantity
1141   ) internal virtual {}
1142 }
1143 
1144 contract ERC721Holder is IERC721Receiver {
1145 
1146     function onERC721Received(
1147         address,
1148         address,
1149         uint256,
1150         bytes memory
1151     ) public virtual override returns (bytes4) {
1152         return this.onERC721Received.selector;
1153     }
1154 }
1155 
1156 /**
1157  * @dev Contract module that helps prevent reentrant calls to a function.
1158  *
1159  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1160  * available, which can be applied to functions to make sure there are no nested
1161  * (reentrant) calls to them.
1162  *
1163  * Note that because there is a single `nonReentrant` guard, functions marked as
1164  * `nonReentrant` may not call one another. This can be worked around by making
1165  * those functions `private`, and then adding `external` `nonReentrant` entry
1166  * points to them.
1167  *
1168  * TIP: If you would like to learn more about reentrancy and alternative ways
1169  * to protect against it, check out our blog post
1170  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1171  */
1172 abstract contract ReentrancyGuard {
1173     // Booleans are more expensive than uint256 or any type that takes up a full
1174     // word because each write operation emits an extra SLOAD to first read the
1175     // slot's contents, replace the bits taken up by the boolean, and then write
1176     // back. This is the compiler's defense against contract upgrades and
1177     // pointer aliasing, and it cannot be disabled.
1178 
1179     // The values being non-zero value makes deployment a bit more expensive,
1180     // but in exchange the refund on every call to nonReentrant will be lower in
1181     // amount. Since refunds are capped to a percentage of the total
1182     // transaction's gas, it is best to keep them low in cases like this one, to
1183     // increase the likelihood of the full refund coming into effect.
1184     uint256 private constant _NOT_ENTERED = 1;
1185     uint256 private constant _ENTERED = 2;
1186 
1187     uint256 private _status;
1188 
1189     constructor() {
1190         _status = _NOT_ENTERED;
1191     }
1192 
1193     /**
1194      * @dev Prevents a contract from calling itself, directly or indirectly.
1195      * Calling a `nonReentrant` function from another `nonReentrant`
1196      * function is not supported. It is possible to prevent this from happening
1197      * by making the `nonReentrant` function external, and making it call a
1198      * `private` function that does the actual work.
1199      */
1200     modifier nonReentrant() {
1201         // On the first call to nonReentrant, _notEntered will be true
1202         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1203 
1204         // Any calls to nonReentrant after this point will fail
1205         _status = _ENTERED;
1206 
1207         _;
1208 
1209         // By storing the original value once again, a refund is triggered (see
1210         // https://eips.ethereum.org/EIPS/eip-2200)
1211         _status = _NOT_ENTERED;
1212     }
1213 }
1214 
1215 /**
1216  * @dev These functions deal with verification of Merkle Trees proofs.
1217  *
1218  * The proofs can be generated using the JavaScript library
1219  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1220  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1221  *
1222  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1223  */
1224 library MerkleProof {
1225     /**
1226      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1227      * defined by `root`. For this, a `proof` must be provided, containing
1228      * sibling hashes on the branch from the leaf to the root of the tree. Each
1229      * pair of leaves and each pair of pre-images are assumed to be sorted.
1230      */
1231     function verify(
1232         bytes32[] memory proof,
1233         bytes32 root,
1234         bytes32 leaf
1235     ) internal pure returns (bool) {
1236         return processProof(proof, leaf) == root;
1237     }
1238 
1239     /**
1240      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1241      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1242      * hash matches the root of the tree. When processing the proof, the pairs
1243      * of leafs & pre-images are assumed to be sorted.
1244      *
1245      * _Available since v4.4._
1246      */
1247     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1248         bytes32 computedHash = leaf;
1249         for (uint256 i = 0; i < proof.length; i++) {
1250             bytes32 proofElement = proof[i];
1251             if (computedHash <= proofElement) {
1252                 // Hash(current computed hash + current element of the proof)
1253                 computedHash = _efficientHash(computedHash, proofElement);
1254             } else {
1255                 // Hash(current element of the proof + current computed hash)
1256                 computedHash = _efficientHash(proofElement, computedHash);
1257             }
1258         }
1259         return computedHash;
1260     }
1261 
1262     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1263         assembly {
1264             mstore(0x00, a)
1265             mstore(0x20, b)
1266             value := keccak256(0x00, 0x40)
1267         }
1268     }
1269 }
1270 
1271 contract Taiketsu is ERC721A, ERC721Holder, Ownable, ReentrancyGuard{
1272     
1273     using Strings for uint256;
1274     
1275     uint public MAX_TOKENS = 10000;
1276     uint public MAX_TOKENS_IN_TX = 10;
1277     uint public PRICE_PUBLIC = 0.1 ether;
1278     uint public PRICE_PRESALE = 0.07 ether;
1279     uint public PRICE_PREORDER = 0.07 ether;
1280     uint public MAX_RESERVED_FOR_PREORDER = 5000;
1281     uint public MAX_PREORDERS = 3;
1282     uint public MAX_PRESALES = 3;
1283 
1284     uint public saleStatus = 0; // 0 - paused, 1 - public sales, 2 - pre-sales
1285     bool public preorderStatus = true;
1286     
1287     string private _baseTokenURI;
1288     mapping(address => uint256) private presales;
1289     mapping(address => uint256) private preorders;
1290     uint public preordersCounter;
1291 
1292     bytes32 public merkleRoot;
1293 
1294     constructor() ERC721A("Taiketsu", "Taiketsu", MAX_TOKENS_IN_TX, MAX_TOKENS)  {
1295         
1296     }
1297 
1298     function mint(uint256 _count) public payable nonReentrant {
1299         require(totalSupply() < MAX_TOKENS, "Sale end");
1300         require(saleStatus == 1, "Public sales is closed");
1301         require(totalSupply() + _count <= MAX_TOKENS - preordersCounter, "Exceeds MAX limit");
1302         require(_count <= MAX_TOKENS_IN_TX, "Exceeds TX limit");
1303         require(msg.value == _count * PRICE_PUBLIC, "Value below price");
1304         _safeMint(_msgSender(), _count);
1305     }
1306 
1307     function presale(uint256 _count, bytes32[] calldata _merkleProof) public payable nonReentrant {
1308         require(totalSupply() < MAX_TOKENS, "Sale end");
1309         require(saleStatus == 2, "Presale is closed");
1310         require(_count <= MAX_PRESALES - presales[_msgSender()], "Insufficient mints left");
1311         require(_verify(_merkleProof, _msgSender()), "Invalid proof");
1312         require(msg.value == PRICE_PRESALE * _count, "Value below price");
1313         presales[_msgSender()] += _count;
1314         _safeMint(_msgSender(), _count);
1315     }
1316 
1317     function preorder(uint _count) public payable nonReentrant {
1318         require(totalSupply() < MAX_TOKENS, "Sale end");
1319         require(preordersCounter < MAX_RESERVED_FOR_PREORDER, "Exceeds Pre-Orders limit");
1320         require(preorderStatus, "Preorders is not active");
1321         require(totalSupply() + _count <= MAX_TOKENS - preordersCounter, "Exceeds MAX limit");
1322         require(preorders[msg.sender] + _count <= MAX_PREORDERS, "Exceeds preorder limit");
1323         require(msg.value == _count * PRICE_PREORDER, "Value below price");
1324         preorders[msg.sender] += _count;
1325         preordersCounter += _count;
1326     }
1327 
1328     function cancelPreorder() public {
1329         require(preorderStatus, "Preorders is not active");
1330         require(preorders[msg.sender] > 0, "No preorders");
1331         require(payable(msg.sender).send(preorders[msg.sender] * PRICE_PREORDER));
1332         preordersCounter -= preorders[msg.sender];
1333         preorders[msg.sender] = 0;
1334     }
1335 
1336     function mintPreorder() public {
1337         require(totalSupply() < MAX_TOKENS, "Sale end");
1338         require(!preorderStatus, "Distribution closed");
1339         require(preorders[msg.sender] > 0, "No preorders");
1340         _safeMint(msg.sender, preorders[msg.sender]);
1341         preordersCounter -= preorders[msg.sender];
1342         preorders[msg.sender] = 0;
1343     }
1344 
1345     function _baseURI() internal view virtual override returns (string memory) {
1346       return _baseTokenURI;
1347     }
1348 
1349     function preordersAtAddress(address _address) external view returns(uint256) {
1350         return preorders[_address];
1351     }
1352 
1353     function presalesAtAddress(address _address) external view returns(uint256) {
1354         return presales[_address];
1355     }
1356     
1357     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1358         uint tokenCount = balanceOf(_owner);
1359         uint256[] memory tokensId = new uint256[](tokenCount);
1360         for(uint i = 0; i < tokenCount; i++){
1361             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1362         }
1363         return tokensId;
1364     }
1365 
1366     function _verify(bytes32[] calldata merkleProof, address sender) private view returns (bool) {
1367         bytes32 leaf = keccak256(abi.encodePacked(sender));
1368         return MerkleProof.verify(merkleProof, merkleRoot, leaf);
1369     }
1370     
1371     function ownerMint(address _to, uint256 _count) public onlyOwner {
1372         require(totalSupply() < MAX_TOKENS, "Sale end");
1373         require(totalSupply() + _count <= MAX_TOKENS - preordersCounter, "Exceeds MAX limit");
1374         require(_count <= MAX_TOKENS_IN_TX, "Exceeds TX limit");
1375         _safeMint(_to, _count);
1376     }
1377 
1378     function setBaseURI(string memory baseURI) public onlyOwner {
1379         _baseTokenURI = baseURI;
1380     }
1381 
1382     function setStatusSales(uint _saleStatus) public onlyOwner {
1383         require(_saleStatus == 0 || _saleStatus == 1 || _saleStatus == 2);
1384         saleStatus = _saleStatus;
1385     }
1386 
1387     function setStatusPreorders(bool _preordersStatus) public onlyOwner {
1388         preorderStatus = _preordersStatus;
1389     }
1390 
1391     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1392         merkleRoot = _merkleRoot;
1393     }
1394 
1395     function withdrawAll() public payable {
1396       address cofounder = 0xD03c810C126B4f6E18e98A1EC29131605882Dc13;
1397       require(!preorderStatus);
1398       require(msg.sender == owner() || msg.sender == cofounder);
1399       uint256 cofounder_value = address(this).balance / 100 * 50;
1400       uint256 owner_value = address(this).balance - cofounder_value;
1401       require(payable(cofounder).send(cofounder_value));
1402       require(payable(msg.sender).send(owner_value));
1403     }
1404 
1405 }