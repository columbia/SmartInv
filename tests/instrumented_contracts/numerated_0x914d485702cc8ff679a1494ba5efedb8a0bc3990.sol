1 /*
2 ▄▄▄█████▓ ▄▄▄       ██▓ ██ ▄█▀▓█████▄▄▄█████▓  ██████  █    ██ 
3 ▓  ██▒ ▓▒▒████▄    ▓██▒ ██▄█▒ ▓█   ▀▓  ██▒ ▓▒▒██    ▒  ██  ▓██▒
4 ▒ ▓██░ ▒░▒██  ▀█▄  ▒██▒▓███▄░ ▒███  ▒ ▓██░ ▒░░ ▓██▄   ▓██  ▒██░
5 ░ ▓██▓ ░ ░██▄▄▄▄██ ░██░▓██ █▄ ▒▓█  ▄░ ▓██▓ ░   ▒   ██▒▓▓█  ░██░
6   ▒██▒ ░  ▓█   ▓██▒░██░▒██▒ █▄░▒████▒ ▒██▒ ░ ▒██████▒▒▒▒█████▓ 
7   ▒ ░░    ▒▒   ▓▒█░░▓  ▒ ▒▒ ▓▒░░ ▒░ ░ ▒ ░░   ▒ ▒▓▒ ▒ ░░▒▓▒ ▒ ▒ 
8     ░      ▒   ▒▒ ░ ▒ ░░ ░▒ ▒░ ░ ░  ░   ░    ░ ░▒  ░ ░░░▒░ ░ ░ 
9   ░        ░   ▒    ▒ ░░ ░░ ░    ░    ░      ░  ░  ░   ░░░ ░ ░ 
10                ░  ░ ░  ░  ░      ░  ░              ░     ░                                                                    
11 */
12 // SPDX-License-Identifier: MIT
13 pragma solidity ^0.8.0;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 abstract contract Ownable is Context {
26     address private _owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     constructor() {
31         _setOwner(_msgSender());
32     }
33 
34     function owner() public view virtual returns (address) {
35         return _owner;
36     }
37 
38     modifier onlyOwner() {
39         require(owner() == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42 
43     function renounceOwnership() public virtual onlyOwner {
44         _setOwner(address(0));
45     }
46 
47     function transferOwnership(address newOwner) public virtual onlyOwner {
48         require(newOwner != address(0), "Ownable: new owner is the zero address");
49         _setOwner(newOwner);
50     }
51 
52     function _setOwner(address newOwner) private {
53         address oldOwner = _owner;
54         _owner = newOwner;
55         emit OwnershipTransferred(oldOwner, newOwner);
56     }
57 }
58 
59 interface IERC165 {
60 
61     function supportsInterface(bytes4 interfaceId) external view returns (bool);
62 }
63 
64 interface IERC721 is IERC165 {
65 
66     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
67 
68     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
69 
70     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
71 
72     function balanceOf(address owner) external view returns (uint256 balance);
73 
74     function ownerOf(uint256 tokenId) external view returns (address owner);
75 
76     function safeTransferFrom(
77         address from,
78         address to,
79         uint256 tokenId
80     ) external;
81 
82     function transferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
87 
88     function approve(address to, uint256 tokenId) external;
89 
90     function getApproved(uint256 tokenId) external view returns (address operator);
91 
92     function setApprovalForAll(address operator, bool _approved) external;
93 
94     function isApprovedForAll(address owner, address operator) external view returns (bool);
95 
96     function safeTransferFrom(
97         address from,
98         address to,
99         uint256 tokenId,
100         bytes calldata data
101     ) external;
102 }
103 
104 interface IERC721Enumerable is IERC721 {
105 
106     function totalSupply() external view returns (uint256);
107 
108     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
109 
110     function tokenByIndex(uint256 index) external view returns (uint256);
111 }
112 
113 
114 abstract contract ERC165 is IERC165 {
115     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
116         return interfaceId == type(IERC165).interfaceId;
117     }
118 }
119 
120 library Strings {
121     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
122 
123     function toString(uint256 value) internal pure returns (string memory) {
124 
125         if (value == 0) {
126             return "0";
127         }
128         uint256 temp = value;
129         uint256 digits;
130         while (temp != 0) {
131             digits++;
132             temp /= 10;
133         }
134         bytes memory buffer = new bytes(digits);
135         while (value != 0) {
136             digits -= 1;
137             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
138             value /= 10;
139         }
140         return string(buffer);
141     }
142 
143     function toHexString(uint256 value) internal pure returns (string memory) {
144         if (value == 0) {
145             return "0x00";
146         }
147         uint256 temp = value;
148         uint256 length = 0;
149         while (temp != 0) {
150             length++;
151             temp >>= 8;
152         }
153         return toHexString(value, length);
154     }
155 
156     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
157         bytes memory buffer = new bytes(2 * length + 2);
158         buffer[0] = "0";
159         buffer[1] = "x";
160         for (uint256 i = 2 * length + 1; i > 1; --i) {
161             buffer[i] = _HEX_SYMBOLS[value & 0xf];
162             value >>= 4;
163         }
164         require(value == 0, "Strings: hex length insufficient");
165         return string(buffer);
166     }
167 }
168 
169 library Address {
170 
171     function isContract(address account) internal view returns (bool) {
172 
173         uint256 size;
174         assembly {
175             size := extcodesize(account)
176         }
177         return size > 0;
178     }
179 
180     function sendValue(address payable recipient, uint256 amount) internal {
181         require(address(this).balance >= amount, "Address: insufficient balance");
182 
183         (bool success, ) = recipient.call{value: amount}("");
184         require(success, "Address: unable to send value, recipient may have reverted");
185     }
186 
187     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
188         return functionCall(target, data, "Address: low-level call failed");
189     }
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
220     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
221         return functionStaticCall(target, data, "Address: low-level static call failed");
222     }
223 
224     function functionStaticCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal view returns (bytes memory) {
229         require(isContract(target), "Address: static call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.staticcall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
236         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
237     }
238 
239     function functionDelegateCall(
240         address target,
241         bytes memory data,
242         string memory errorMessage
243     ) internal returns (bytes memory) {
244         require(isContract(target), "Address: delegate call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.delegatecall(data);
247         return verifyCallResult(success, returndata, errorMessage);
248     }
249 
250     function verifyCallResult(
251         bool success,
252         bytes memory returndata,
253         string memory errorMessage
254     ) internal pure returns (bytes memory) {
255         if (success) {
256             return returndata;
257         } else {
258 
259             if (returndata.length > 0) {
260 
261                 assembly {
262                     let returndata_size := mload(returndata)
263                     revert(add(32, returndata), returndata_size)
264                 }
265             } else {
266                 revert(errorMessage);
267             }
268         }
269     }
270 }
271 
272 interface IERC721Metadata is IERC721 {
273 
274     function name() external view returns (string memory);
275 
276     function symbol() external view returns (string memory);
277 
278     function tokenURI(uint256 tokenId) external view returns (string memory);
279 }
280 
281 interface IERC721Receiver {
282 
283     function onERC721Received(
284         address operator,
285         address from,
286         uint256 tokenId,
287         bytes calldata data
288     ) external returns (bytes4);
289 }
290 
291 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
292     using Address for address;
293     using Strings for uint256;
294 
295     string private _name;
296 
297     string private _symbol;
298 
299     mapping(uint256 => address) private _owners;
300 
301     mapping(address => uint256) private _balances;
302 
303     mapping(uint256 => address) private _tokenApprovals;
304 
305     mapping(address => mapping(address => bool)) private _operatorApprovals;
306 
307     constructor(string memory name_, string memory symbol_) {
308         _name = name_;
309         _symbol = symbol_;
310     }
311 
312     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
313         return
314             interfaceId == type(IERC721).interfaceId ||
315             interfaceId == type(IERC721Metadata).interfaceId ||
316             super.supportsInterface(interfaceId);
317     }
318 
319     function balanceOf(address owner) public view virtual override returns (uint256) {
320         require(owner != address(0), "ERC721: balance query for the zero address");
321         return _balances[owner];
322     }
323 
324     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
325         address owner = _owners[tokenId];
326         require(owner != address(0), "ERC721: owner query for nonexistent token");
327         return owner;
328     }
329 
330     function name() public view virtual override returns (string memory) {
331         return _name;
332     }
333 
334     function symbol() public view virtual override returns (string memory) {
335         return _symbol;
336     }
337 
338     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
339         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
340 
341         string memory baseURI = _baseURI();
342         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
343     }
344 
345     function _baseURI() internal view virtual returns (string memory) {
346         return "";
347     }
348 
349     function approve(address to, uint256 tokenId) public virtual override {
350         address owner = ERC721.ownerOf(tokenId);
351         require(to != owner, "ERC721: approval to current owner");
352 
353         require(
354             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
355             "ERC721: approve caller is not owner nor approved for all"
356         );
357 
358         _approve(to, tokenId);
359     }
360 
361     function getApproved(uint256 tokenId) public view virtual override returns (address) {
362         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
363 
364         return _tokenApprovals[tokenId];
365     }
366 
367     function setApprovalForAll(address operator, bool approved) public virtual override {
368         require(operator != _msgSender(), "ERC721: approve to caller");
369 
370         _operatorApprovals[_msgSender()][operator] = approved;
371         emit ApprovalForAll(_msgSender(), operator, approved);
372     }
373 
374     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
375         return _operatorApprovals[owner][operator];
376     }
377 
378     function transferFrom(
379         address from,
380         address to,
381         uint256 tokenId
382     ) public virtual override {
383         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
384 
385         _transfer(from, to, tokenId);
386     }
387 
388     function safeTransferFrom(
389         address from,
390         address to,
391         uint256 tokenId
392     ) public virtual override {
393         safeTransferFrom(from, to, tokenId, "");
394     }
395 
396     function safeTransferFrom(
397         address from,
398         address to,
399         uint256 tokenId,
400         bytes memory _data
401     ) public virtual override {
402         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
403         _safeTransfer(from, to, tokenId, _data);
404     }
405 
406     function _safeTransfer(
407         address from,
408         address to,
409         uint256 tokenId,
410         bytes memory _data
411     ) internal virtual {
412         _transfer(from, to, tokenId);
413         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
414     }
415 
416     function _exists(uint256 tokenId) internal view virtual returns (bool) {
417         return _owners[tokenId] != address(0);
418     }
419 
420     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
421         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
422         address owner = ERC721.ownerOf(tokenId);
423         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
424     }
425 
426     function _safeMint(address to, uint256 tokenId) internal virtual {
427         _safeMint(to, tokenId, "");
428     }
429 
430     function _safeMint(
431         address to,
432         uint256 tokenId,
433         bytes memory _data
434     ) internal virtual {
435         _mint(to, tokenId);
436         require(
437             _checkOnERC721Received(address(0), to, tokenId, _data),
438             "ERC721: transfer to non ERC721Receiver implementer"
439         );
440     }
441 
442     function _mint(address to, uint256 tokenId) internal virtual {
443         require(to != address(0), "ERC721: mint to the zero address");
444         require(!_exists(tokenId), "ERC721: token already minted");
445 
446         _beforeTokenTransfer(address(0), to, tokenId);
447 
448         _balances[to] += 1;
449         _owners[tokenId] = to;
450 
451         emit Transfer(address(0), to, tokenId);
452     }
453 
454     function _burn(uint256 tokenId) internal virtual {
455         address owner = ERC721.ownerOf(tokenId);
456 
457         _beforeTokenTransfer(owner, address(0), tokenId);
458 
459         _approve(address(0), tokenId);
460 
461         _balances[owner] -= 1;
462         delete _owners[tokenId];
463 
464         emit Transfer(owner, address(0), tokenId);
465     }
466 
467     function _transfer(
468         address from,
469         address to,
470         uint256 tokenId
471     ) internal virtual {
472         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
473         require(to != address(0), "ERC721: transfer to the zero address");
474 
475         _beforeTokenTransfer(from, to, tokenId);
476 
477         _approve(address(0), tokenId);
478 
479         _balances[from] -= 1;
480         _balances[to] += 1;
481         _owners[tokenId] = to;
482 
483         emit Transfer(from, to, tokenId);
484     }
485 
486     function _approve(address to, uint256 tokenId) internal virtual {
487         _tokenApprovals[tokenId] = to;
488         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
489     }
490 
491     function _checkOnERC721Received(
492         address from,
493         address to,
494         uint256 tokenId,
495         bytes memory _data
496     ) private returns (bool) {
497         if (to.isContract()) {
498             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
499                 return retval == IERC721Receiver.onERC721Received.selector;
500             } catch (bytes memory reason) {
501                 if (reason.length == 0) {
502                     revert("ERC721: transfer to non ERC721Receiver implementer");
503                 } else {
504                     assembly {
505                         revert(add(32, reason), mload(reason))
506                     }
507                 }
508             }
509         } else {
510             return true;
511         }
512     }
513 
514     function _beforeTokenTransfer(
515         address from,
516         address to,
517         uint256 tokenId
518     ) internal virtual {}
519 }
520 
521 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
522     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
523 
524     mapping(uint256 => uint256) private _ownedTokensIndex;
525 
526     uint256[] private _allTokens;
527 
528     mapping(uint256 => uint256) private _allTokensIndex;
529 
530     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
531         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
532     }
533 
534     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
535         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
536         return _ownedTokens[owner][index];
537     }
538 
539     function totalSupply() public view virtual override returns (uint256) {
540         return _allTokens.length;
541     }
542 
543     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
544         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
545         return _allTokens[index];
546     }
547 
548     function _beforeTokenTransfer(
549         address from,
550         address to,
551         uint256 tokenId
552     ) internal virtual override {
553         super._beforeTokenTransfer(from, to, tokenId);
554 
555         if (from == address(0)) {
556             _addTokenToAllTokensEnumeration(tokenId);
557         } else if (from != to) {
558             _removeTokenFromOwnerEnumeration(from, tokenId);
559         }
560         if (to == address(0)) {
561             _removeTokenFromAllTokensEnumeration(tokenId);
562         } else if (to != from) {
563             _addTokenToOwnerEnumeration(to, tokenId);
564         }
565     }
566 
567     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
568         uint256 length = ERC721.balanceOf(to);
569         _ownedTokens[to][length] = tokenId;
570         _ownedTokensIndex[tokenId] = length;
571     }
572 
573     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
574         _allTokensIndex[tokenId] = _allTokens.length;
575         _allTokens.push(tokenId);
576     }
577 
578     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
579 
580         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
581         uint256 tokenIndex = _ownedTokensIndex[tokenId];
582 
583         if (tokenIndex != lastTokenIndex) {
584             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
585 
586             _ownedTokens[from][tokenIndex] = lastTokenId; 
587             _ownedTokensIndex[lastTokenId] = tokenIndex;
588         }
589 
590 
591         delete _ownedTokensIndex[tokenId];
592         delete _ownedTokens[from][lastTokenIndex];
593     }
594 
595     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
596 
597         uint256 lastTokenIndex = _allTokens.length - 1;
598         uint256 tokenIndex = _allTokensIndex[tokenId];
599 
600         uint256 lastTokenId = _allTokens[lastTokenIndex];
601 
602         _allTokens[tokenIndex] = lastTokenId;
603         _allTokensIndex[lastTokenId] = tokenIndex;
604 
605         delete _allTokensIndex[tokenId];
606         _allTokens.pop();
607     }
608 }
609 
610 contract ERC721A is
611   Context,
612   ERC165,
613   IERC721,
614   IERC721Metadata,
615   IERC721Enumerable
616 {
617   using Address for address;
618   using Strings for uint256;
619 
620   struct TokenOwnership {
621     address addr;
622     uint64 startTimestamp;
623   }
624 
625   struct AddressData {
626     uint128 balance;
627     uint128 numberMinted;
628   }
629 
630   uint256 private currentIndex = 0;
631 
632   uint256 internal immutable collectionSize;
633   uint256 internal immutable maxBatchSize;
634 
635   string private _name;
636 
637   string private _symbol;
638 
639   mapping(uint256 => TokenOwnership) private _ownerships;
640 
641   mapping(address => AddressData) private _addressData;
642 
643   mapping(uint256 => address) private _tokenApprovals;
644 
645   mapping(address => mapping(address => bool)) private _operatorApprovals;
646 
647   constructor(
648     string memory name_,
649     string memory symbol_,
650     uint256 maxBatchSize_,
651     uint256 collectionSize_
652   ) {
653     require(
654       collectionSize_ > 0,
655       "ERC721A: collection must have a nonzero supply"
656     );
657     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
658     _name = name_;
659     _symbol = symbol_;
660     maxBatchSize = maxBatchSize_;
661     collectionSize = collectionSize_;
662   }
663 
664   function totalSupply() public view override returns (uint256) {
665     return currentIndex;
666   }
667 
668   function tokenByIndex(uint256 index) public view override returns (uint256) {
669     require(index < totalSupply(), "ERC721A: global index out of bounds");
670     return index;
671   }
672 
673   function tokenOfOwnerByIndex(address owner, uint256 index)
674     public
675     view
676     override
677     returns (uint256)
678   {
679     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
680     uint256 numMintedSoFar = totalSupply();
681     uint256 tokenIdsIdx = 0;
682     address currOwnershipAddr = address(0);
683     for (uint256 i = 0; i < numMintedSoFar; i++) {
684       TokenOwnership memory ownership = _ownerships[i];
685       if (ownership.addr != address(0)) {
686         currOwnershipAddr = ownership.addr;
687       }
688       if (currOwnershipAddr == owner) {
689         if (tokenIdsIdx == index) {
690           return i;
691         }
692         tokenIdsIdx++;
693       }
694     }
695     revert("ERC721A: unable to get token of owner by index");
696   }
697 
698   function supportsInterface(bytes4 interfaceId)
699     public
700     view
701     virtual
702     override(ERC165, IERC165)
703     returns (bool)
704   {
705     return
706       interfaceId == type(IERC721).interfaceId ||
707       interfaceId == type(IERC721Metadata).interfaceId ||
708       interfaceId == type(IERC721Enumerable).interfaceId ||
709       super.supportsInterface(interfaceId);
710   }
711 
712   function balanceOf(address owner) public view override returns (uint256) {
713     require(owner != address(0), "ERC721A: balance query for the zero address");
714     return uint256(_addressData[owner].balance);
715   }
716 
717   function _numberMinted(address owner) internal view returns (uint256) {
718     require(
719       owner != address(0),
720       "ERC721A: number minted query for the zero address"
721     );
722     return uint256(_addressData[owner].numberMinted);
723   }
724 
725   function ownershipOf(uint256 tokenId)
726     internal
727     view
728     returns (TokenOwnership memory)
729   {
730     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
731 
732     uint256 lowestTokenToCheck;
733     if (tokenId >= maxBatchSize) {
734       lowestTokenToCheck = tokenId - maxBatchSize + 1;
735     }
736 
737     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
738       TokenOwnership memory ownership = _ownerships[curr];
739       if (ownership.addr != address(0)) {
740         return ownership;
741       }
742     }
743 
744     revert("ERC721A: unable to determine the owner of token");
745   }
746 
747   function ownerOf(uint256 tokenId) public view override returns (address) {
748     return ownershipOf(tokenId).addr;
749   }
750 
751   function name() public view virtual override returns (string memory) {
752     return _name;
753   }
754 
755   function symbol() public view virtual override returns (string memory) {
756     return _symbol;
757   }
758 
759   function tokenURI(uint256 tokenId)
760     public
761     view
762     virtual
763     override
764     returns (string memory)
765   {
766     require(
767       _exists(tokenId),
768       "ERC721Metadata: URI query for nonexistent token"
769     );
770 
771     string memory baseURI = _baseURI();
772     return
773       bytes(baseURI).length > 0
774         ? string(abi.encodePacked(baseURI, tokenId.toString()))
775         : "";
776   }
777 
778   function _baseURI() internal view virtual returns (string memory) {
779     return "";
780   }
781 
782   function approve(address to, uint256 tokenId) public override {
783     address owner = ERC721A.ownerOf(tokenId);
784     require(to != owner, "ERC721A: approval to current owner");
785 
786     require(
787       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
788       "ERC721A: approve caller is not owner nor approved for all"
789     );
790 
791     _approve(to, tokenId, owner);
792   }
793 
794   function getApproved(uint256 tokenId) public view override returns (address) {
795     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
796 
797     return _tokenApprovals[tokenId];
798   }
799 
800   function setApprovalForAll(address operator, bool approved) public override {
801     require(operator != _msgSender(), "ERC721A: approve to caller");
802 
803     _operatorApprovals[_msgSender()][operator] = approved;
804     emit ApprovalForAll(_msgSender(), operator, approved);
805   }
806 
807   function isApprovedForAll(address owner, address operator)
808     public
809     view
810     virtual
811     override
812     returns (bool)
813   {
814     return _operatorApprovals[owner][operator];
815   }
816 
817   function transferFrom(
818     address from,
819     address to,
820     uint256 tokenId
821   ) public override {
822     _transfer(from, to, tokenId);
823   }
824 
825   function safeTransferFrom(
826     address from,
827     address to,
828     uint256 tokenId
829   ) public override {
830     safeTransferFrom(from, to, tokenId, "");
831   }
832 
833   function safeTransferFrom(
834     address from,
835     address to,
836     uint256 tokenId,
837     bytes memory _data
838   ) public override {
839     _transfer(from, to, tokenId);
840     require(
841       _checkOnERC721Received(from, to, tokenId, _data),
842       "ERC721A: transfer to non ERC721Receiver implementer"
843     );
844   }
845 
846   function _exists(uint256 tokenId) internal view returns (bool) {
847     return tokenId < currentIndex;
848   }
849 
850   function _safeMint(address to, uint256 quantity) internal {
851     _safeMint(to, quantity, "");
852   }
853 
854   function _safeMint(
855     address to,
856     uint256 quantity,
857     bytes memory _data
858   ) internal {
859     uint256 startTokenId = currentIndex;
860     require(to != address(0), "ERC721A: mint to the zero address");
861     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
862     require(!_exists(startTokenId), "ERC721A: token already minted");
863     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
864 
865     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
866 
867     AddressData memory addressData = _addressData[to];
868     _addressData[to] = AddressData(
869       addressData.balance + uint128(quantity),
870       addressData.numberMinted + uint128(quantity)
871     );
872     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
873 
874     uint256 updatedIndex = startTokenId;
875 
876     for (uint256 i = 0; i < quantity; i++) {
877       emit Transfer(address(0), to, updatedIndex);
878       require(
879         _checkOnERC721Received(address(0), to, updatedIndex, _data),
880         "ERC721A: transfer to non ERC721Receiver implementer"
881       );
882       updatedIndex++;
883     }
884 
885     currentIndex = updatedIndex;
886     _afterTokenTransfers(address(0), to, startTokenId, quantity);
887   }
888 
889   function _transfer(
890     address from,
891     address to,
892     uint256 tokenId
893   ) private {
894     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
895 
896     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
897       getApproved(tokenId) == _msgSender() ||
898       isApprovedForAll(prevOwnership.addr, _msgSender()));
899 
900     require(
901       isApprovedOrOwner,
902       "ERC721A: transfer caller is not owner nor approved"
903     );
904 
905     require(
906       prevOwnership.addr == from,
907       "ERC721A: transfer from incorrect owner"
908     );
909     require(to != address(0), "ERC721A: transfer to the zero address");
910 
911     _beforeTokenTransfers(from, to, tokenId, 1);
912 
913     _approve(address(0), tokenId, prevOwnership.addr);
914 
915     _addressData[from].balance -= 1;
916     _addressData[to].balance += 1;
917     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
918 
919     uint256 nextTokenId = tokenId + 1;
920     if (_ownerships[nextTokenId].addr == address(0)) {
921       if (_exists(nextTokenId)) {
922         _ownerships[nextTokenId] = TokenOwnership(
923           prevOwnership.addr,
924           prevOwnership.startTimestamp
925         );
926       }
927     }
928 
929     emit Transfer(from, to, tokenId);
930     _afterTokenTransfers(from, to, tokenId, 1);
931   }
932 
933   function _approve(
934     address to,
935     uint256 tokenId,
936     address owner
937   ) private {
938     _tokenApprovals[tokenId] = to;
939     emit Approval(owner, to, tokenId);
940   }
941 
942   uint256 public nextOwnerToExplicitlySet = 0;
943 
944   function _setOwnersExplicit(uint256 quantity) internal {
945     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
946     require(quantity > 0, "quantity must be nonzero");
947     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
948     if (endIndex > collectionSize - 1) {
949       endIndex = collectionSize - 1;
950     }
951 
952     require(_exists(endIndex), "not enough minted yet for this cleanup");
953     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
954       if (_ownerships[i].addr == address(0)) {
955         TokenOwnership memory ownership = ownershipOf(i);
956         _ownerships[i] = TokenOwnership(
957           ownership.addr,
958           ownership.startTimestamp
959         );
960       }
961     }
962     nextOwnerToExplicitlySet = endIndex + 1;
963   }
964 
965   function _checkOnERC721Received(
966     address from,
967     address to,
968     uint256 tokenId,
969     bytes memory _data
970   ) private returns (bool) {
971     if (to.isContract()) {
972       try
973         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
974       returns (bytes4 retval) {
975         return retval == IERC721Receiver(to).onERC721Received.selector;
976       } catch (bytes memory reason) {
977         if (reason.length == 0) {
978           revert("ERC721A: transfer to non ERC721Receiver implementer");
979         } else {
980           assembly {
981             revert(add(32, reason), mload(reason))
982           }
983         }
984       }
985     } else {
986       return true;
987     }
988   }
989 
990   function _beforeTokenTransfers(
991     address from,
992     address to,
993     uint256 startTokenId,
994     uint256 quantity
995   ) internal virtual {}
996 
997   function _afterTokenTransfers(
998     address from,
999     address to,
1000     uint256 startTokenId,
1001     uint256 quantity
1002   ) internal virtual {}
1003 }
1004 
1005 abstract contract ReentrancyGuard {
1006 
1007     uint256 private constant _NOT_ENTERED = 1;
1008     uint256 private constant _ENTERED = 2;
1009 
1010     uint256 private _status;
1011 
1012     constructor() {
1013         _status = _NOT_ENTERED;
1014     }
1015 
1016     modifier nonReentrant() {
1017         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1018         _status = _ENTERED;
1019         _;
1020         _status = _NOT_ENTERED;
1021     }
1022 }
1023 
1024 library MerkleProof {
1025 
1026     function verify(
1027         bytes32[] memory proof,
1028         bytes32 root,
1029         bytes32 leaf
1030     ) internal pure returns (bool) {
1031         return processProof(proof, leaf) == root;
1032     }
1033 
1034     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1035         bytes32 computedHash = leaf;
1036         for (uint256 i = 0; i < proof.length; i++) {
1037             bytes32 proofElement = proof[i];
1038             if (computedHash <= proofElement) {
1039                 // Hash(current computed hash + current element of the proof)
1040                 computedHash = _efficientHash(computedHash, proofElement);
1041             } else {
1042                 // Hash(current element of the proof + current computed hash)
1043                 computedHash = _efficientHash(proofElement, computedHash);
1044             }
1045         }
1046         return computedHash;
1047     }
1048 
1049     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1050         assembly {
1051             mstore(0x00, a)
1052             mstore(0x20, b)
1053             value := keccak256(0x00, 0x40)
1054         }
1055     }
1056 }
1057 
1058 contract Taiketsu is ERC721A, Ownable, ReentrancyGuard{
1059     
1060     using Strings for uint256;
1061     
1062     uint256 public constant MAX_SUPPLY = 5889;
1063     uint public publicSalePrice = 0.1 ether;
1064     uint public preSalePrice = 0.08 ether;
1065     
1066     address public preordersDataContract = 0x1815a17ABe7630045133051aD7cB905b25d57AE9;
1067 
1068     bool public isPublicSaleActive;
1069     bool public isPreSaleActive;
1070     bool public isPreorderMintActive;
1071 
1072     uint256 public maxPublicSalesPerTransaction = 3;
1073     uint256 public maxPreSalesPerAddress = 2;
1074     uint256 private maxOwnerMint = 10;
1075     
1076     bytes32 public preSaleMerkleRoot;
1077     mapping(address => uint256) private preSalesCounter;
1078     mapping(address => bool) private preordersCheck;
1079     uint256 private ownerMintCounter;
1080 
1081     uint256 public preordersCounter;
1082     bool isPreordersCounterLoaded;
1083 
1084     string private _baseTokenURI;
1085 
1086     constructor() ERC721A("Taiketsu", "TAIKETSU", 3, MAX_SUPPLY)  {
1087       
1088     }
1089 
1090     function publicSale(uint256 _count) public payable nonReentrant {
1091         require(totalSupply() < MAX_SUPPLY, "Sale end");
1092         require(isPublicSaleActive, "Public sales is closed");
1093         require(totalSupply() + _count <= MAX_SUPPLY - preordersCounter, "Exceeds MAX limit");
1094         require(_count <= maxPublicSalesPerTransaction, "Exceeds TX limit");
1095         require(msg.value == _count * publicSalePrice, "Value below price");
1096         _safeMint(_msgSender(), _count);
1097     }
1098 
1099     function preSale(uint256 _count, bytes32[] calldata _merkleProof) public payable nonReentrant {
1100         require(totalSupply() < MAX_SUPPLY, "Sale end");
1101         require(isPreSaleActive, "Presale is closed");
1102         require(totalSupply() + _count <= MAX_SUPPLY - preordersCounter, "Exceeds MAX limit");
1103         require(_count + preSalesCounter[_msgSender()] <= maxPreSalesPerAddress, "Exceeds address limit");
1104         require(_verify(_merkleProof, _msgSender()), "Invalid proof");
1105         require(msg.value == preSalePrice * _count, "Value below price");
1106         preSalesCounter[_msgSender()] += _count;
1107         _safeMint(_msgSender(), _count);
1108     }
1109 
1110     function mintPreorder() public nonReentrant {
1111         require(totalSupply() < MAX_SUPPLY, "Sale end");
1112         require(isPreorderMintActive, "Preorders mint is closed");
1113         uint256 _preorders = preordersAtAddress(msg.sender);
1114         require(_preorders > 0, "No preorders");
1115         require(!preordersCheck[msg.sender], "Already minted");
1116         preordersCheck[msg.sender] = true;
1117         preordersCounter -= _preorders;
1118         _safeMint(msg.sender, _preorders);
1119     }
1120 
1121     function _baseURI() internal view virtual override returns (string memory) {
1122         return _baseTokenURI;
1123     }
1124 
1125     function preordersAtAddress(address _address) public view returns(uint256) {
1126         if (preordersCheck[_address]){
1127           return 0;
1128         } else {
1129           return PREORDERS(preordersDataContract).preordersAtAddress(_address);
1130         }
1131     }
1132 
1133     function presalesAtAddress(address _address) public view returns(uint256) {
1134         return preSalesCounter[_address];
1135     }
1136     
1137     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
1138         uint tokenCount = balanceOf(_owner);
1139         uint256[] memory tokensId = new uint256[](tokenCount);
1140         for(uint i = 0; i < tokenCount; i++){
1141             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1142         }
1143         return tokensId;
1144     }
1145 
1146     function _verify(bytes32[] calldata merkleProof, address sender) private view returns (bool) {
1147         bytes32 leaf = keccak256(abi.encodePacked(sender));
1148         return MerkleProof.verify(merkleProof, preSaleMerkleRoot, leaf);
1149     }
1150     
1151     function ownerMint(address _to, uint256 _count) public onlyOwner{
1152         require(totalSupply() < MAX_SUPPLY, "Sale end");
1153         require(_count + ownerMintCounter <= maxOwnerMint, "Exceeds owner mint limit");
1154         ownerMintCounter += _count;
1155         _safeMint(_to, _count);
1156     }
1157 
1158     function setBaseURI(string memory baseURI) public onlyOwner {
1159         _baseTokenURI = baseURI;
1160     }
1161 
1162     function setStatusPublicSale(bool _status) public onlyOwner {
1163         isPublicSaleActive = _status;
1164     }
1165 
1166     function setStatusPreMint(bool _statusPreSale, bool _statusPreorders) public onlyOwner {
1167         isPreSaleActive = _statusPreSale;
1168         isPreorderMintActive = _statusPreorders;
1169         if (!isPreordersCounterLoaded){
1170           preordersCounter = PREORDERS(preordersDataContract).preordersCounter();
1171           isPreordersCounterLoaded = true;
1172         }
1173     }
1174 
1175     function setPreSalesLimit(uint256 _count) public onlyOwner {
1176         maxPreSalesPerAddress = _count;
1177     }
1178 
1179     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1180         preSaleMerkleRoot = _merkleRoot;
1181     }
1182 
1183     function withdrawAll() public payable onlyOwner{
1184         address cofounder = 0xD03c810C126B4f6E18e98A1EC29131605882Dc13;
1185         uint256 cofounder_value = address(this).balance / 100 * 50;
1186         uint256 owner_value = address(this).balance - cofounder_value;
1187         require(payable(cofounder).send(cofounder_value));
1188         require(payable(owner()).send(owner_value));
1189     }
1190 
1191 }
1192 
1193 interface PREORDERS{
1194     function preordersCounter() external view returns (uint256);
1195     function preordersAtAddress(address _address) external view returns (uint256);
1196 }