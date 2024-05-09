1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
4 pragma solidity ^0.8.0;
5 
6 library Address {
7 
8     function isContract(address account) internal view returns (bool) {
9 
10         uint256 size;
11         assembly {
12             size := extcodesize(account)
13         }
14         return size > 0;
15     }
16 
17     function sendValue(address payable recipient, uint256 amount) internal {
18         require(address(this).balance >= amount, "Address: insufficient balance");
19 
20         (bool success, ) = recipient.call{value: amount}("");
21         require(success, "Address: unable to send value, recipient may have reverted");
22     }
23 
24     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
25         return functionCall(target, data, "Address: low-level call failed");
26     }
27 
28     function functionCall(
29         address target,
30         bytes memory data,
31         string memory errorMessage
32     ) internal returns (bytes memory) {
33         return functionCallWithValue(target, data, 0, errorMessage);
34     }
35 
36     function functionCallWithValue(
37         address target,
38         bytes memory data,
39         uint256 value
40     ) internal returns (bytes memory) {
41         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
42     }
43 
44     function functionCallWithValue(
45         address target,
46         bytes memory data,
47         uint256 value,
48         string memory errorMessage
49     ) internal returns (bytes memory) {
50         require(address(this).balance >= value, "Address: insufficient balance for call");
51         require(isContract(target), "Address: call to non-contract");
52 
53         (bool success, bytes memory returndata) = target.call{value: value}(data);
54         return verifyCallResult(success, returndata, errorMessage);
55     }
56 
57     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
58         return functionStaticCall(target, data, "Address: low-level static call failed");
59     }
60 
61     function functionStaticCall(
62         address target,
63         bytes memory data,
64         string memory errorMessage
65     ) internal view returns (bytes memory) {
66         require(isContract(target), "Address: static call to non-contract");
67 
68         (bool success, bytes memory returndata) = target.staticcall(data);
69         return verifyCallResult(success, returndata, errorMessage);
70     }
71 
72     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
73         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
74     }
75 
76     function functionDelegateCall(
77         address target,
78         bytes memory data,
79         string memory errorMessage
80     ) internal returns (bytes memory) {
81         require(isContract(target), "Address: delegate call to non-contract");
82 
83         (bool success, bytes memory returndata) = target.delegatecall(data);
84         return verifyCallResult(success, returndata, errorMessage);
85     }
86 
87     function verifyCallResult(
88         bool success,
89         bytes memory returndata,
90         string memory errorMessage
91     ) internal pure returns (bytes memory) {
92         if (success) {
93             return returndata;
94         } else {
95             
96             if (returndata.length > 0) {
97 
98                 assembly {
99                     let returndata_size := mload(returndata)
100                     revert(add(32, returndata), returndata_size)
101                 }
102             } else {
103                 revert(errorMessage);
104             }
105         }
106     }
107 }
108 
109 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
110 pragma solidity ^0.8.0;
111 
112 library Strings {
113     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
114 
115     function toString(uint256 value) internal pure returns (string memory) {
116 
117         if (value == 0) {
118             return "0";
119         }
120         uint256 temp = value;
121         uint256 digits;
122         while (temp != 0) {
123             digits++;
124             temp /= 10;
125         }
126         bytes memory buffer = new bytes(digits);
127         while (value != 0) {
128             digits -= 1;
129             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
130             value /= 10;
131         }
132         return string(buffer);
133     }
134 
135     function toHexString(uint256 value) internal pure returns (string memory) {
136         if (value == 0) {
137             return "0x00";
138         }
139         uint256 temp = value;
140         uint256 length = 0;
141         while (temp != 0) {
142             length++;
143             temp >>= 8;
144         }
145         return toHexString(value, length);
146     }
147 
148     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
149         bytes memory buffer = new bytes(2 * length + 2);
150         buffer[0] = "0";
151         buffer[1] = "x";
152         for (uint256 i = 2 * length + 1; i > 1; --i) {
153             buffer[i] = _HEX_SYMBOLS[value & 0xf];
154             value >>= 4;
155         }
156         require(value == 0, "Strings: hex length insufficient");
157         return string(buffer);
158     }
159 }
160 
161 
162 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
163 pragma solidity ^0.8.0;
164 
165 library Counters {
166     struct Counter {
167         
168         uint256 _value; // default: 0
169     }
170 
171     function current(Counter storage counter) internal view returns (uint256) {
172         return counter._value;
173     }
174 
175     function increment(Counter storage counter) internal {
176         unchecked {
177             counter._value += 1;
178         }
179     }
180 
181     function decrement(Counter storage counter) internal {
182         uint256 value = counter._value;
183         require(value > 0, "Counter: decrement overflow");
184         unchecked {
185             counter._value = value - 1;
186         }
187     }
188 
189     function reset(Counter storage counter) internal {
190         counter._value = 0;
191     }
192 }
193 
194 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
195 pragma solidity ^0.8.0;
196 
197 interface IERC165 {
198     
199     function supportsInterface(bytes4 interfaceId) external view returns (bool);
200 }
201 
202 
203 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
204 pragma solidity ^0.8.0;
205 
206 interface IERC721 is IERC165 {
207     
208     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
209 
210     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
211 
212     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
213 
214     function balanceOf(address owner) external view returns (uint256 balance);
215 
216     function ownerOf(uint256 tokenId) external view returns (address owner);
217 
218     function safeTransferFrom(
219         address from,
220         address to,
221         uint256 tokenId
222     ) external;
223 
224     function transferFrom(
225         address from,
226         address to,
227         uint256 tokenId
228     ) external;
229 
230     function approve(address to, uint256 tokenId) external;
231 
232     function getApproved(uint256 tokenId) external view returns (address operator);
233 
234     function setApprovalForAll(address operator, bool _approved) external;
235 
236     function isApprovedForAll(address owner, address operator) external view returns (bool);
237 
238     function safeTransferFrom(
239         address from,
240         address to,
241         uint256 tokenId,
242         bytes calldata data
243     ) external;
244 }
245 
246 
247 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
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
260 
261 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
262 pragma solidity ^0.8.0;
263 
264 interface IERC721Metadata is IERC721 {
265     
266     function name() external view returns (string memory);
267 
268     function symbol() external view returns (string memory);
269 
270     function tokenURI(uint256 tokenId) external view returns (string memory);
271 }
272 
273 
274 
275 
276 
277 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
278 pragma solidity ^0.8.0;
279 
280 abstract contract Context {
281     function _msgSender() internal view virtual returns (address) {
282         return msg.sender;
283     }
284 
285     function _msgData() internal view virtual returns (bytes calldata) {
286         return msg.data;
287     }
288 }
289 
290 
291 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
292 pragma solidity ^0.8.0;
293 
294 abstract contract ERC165 is IERC165 {
295 
296     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
297         return interfaceId == type(IERC165).interfaceId;
298     }
299 }
300 
301 
302 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
303 pragma solidity ^0.8.0;
304 
305 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
306     using Address for address;
307     using Strings for uint256;
308 
309     string private _name;
310 
311     string private _symbol;
312 
313     mapping(uint256 => address) private _owners;
314 
315     mapping(address => uint256) private _balances;
316 
317     mapping(uint256 => address) private _tokenApprovals;
318 
319     mapping(address => mapping(address => bool)) private _operatorApprovals;
320 
321     constructor(string memory name_, string memory symbol_) {
322         _name = name_;
323         _symbol = symbol_;
324     }
325 
326     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
327         return
328             interfaceId == type(IERC721).interfaceId ||
329             interfaceId == type(IERC721Metadata).interfaceId ||
330             super.supportsInterface(interfaceId);
331     }
332 
333     function balanceOf(address owner) public view virtual override returns (uint256) {
334         require(owner != address(0), "ERC721: balance query for the zero address");
335         return _balances[owner];
336     }
337 
338     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
339         address owner = _owners[tokenId];
340         require(owner != address(0), "ERC721: owner query for nonexistent token");
341         return owner;
342     }
343 
344     function name() public view virtual override returns (string memory) {
345         return _name;
346     }
347 
348     function symbol() public view virtual override returns (string memory) {
349         return _symbol;
350     }
351 
352     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
353         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
354 
355         string memory baseURI = _baseURI();
356         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
357     }
358 
359     function _baseURI() internal view virtual returns (string memory) {
360         return "";
361     }
362 
363     function approve(address to, uint256 tokenId) public virtual override {
364         address owner = ERC721.ownerOf(tokenId);
365         require(to != owner, "ERC721: approval to current owner");
366 
367         require(
368             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
369             "ERC721: approve caller is not owner nor approved for all"
370         );
371 
372         _approve(to, tokenId);
373     }
374 
375     function getApproved(uint256 tokenId) public view virtual override returns (address) {
376         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
377 
378         return _tokenApprovals[tokenId];
379     }
380 
381     function setApprovalForAll(address operator, bool approved) public virtual override {
382         require(operator != _msgSender(), "ERC721: approve to caller");
383 
384         _operatorApprovals[_msgSender()][operator] = approved;
385         emit ApprovalForAll(_msgSender(), operator, approved);
386     }
387 
388     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
389         return _operatorApprovals[owner][operator];
390     }
391 
392     function transferFrom(
393         address from,
394         address to,
395         uint256 tokenId
396     ) public virtual override {
397         
398         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
399 
400         _transfer(from, to, tokenId);
401     }
402 
403     function safeTransferFrom(
404         address from,
405         address to,
406         uint256 tokenId
407     ) public virtual override {
408         safeTransferFrom(from, to, tokenId, "");
409     }
410 
411     function safeTransferFrom(
412         address from,
413         address to,
414         uint256 tokenId,
415         bytes memory _data
416     ) public virtual override {
417         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
418         _safeTransfer(from, to, tokenId, _data);
419     }
420 
421     function _safeTransfer(
422         address from,
423         address to,
424         uint256 tokenId,
425         bytes memory _data
426     ) internal virtual {
427         _transfer(from, to, tokenId);
428         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
429     }
430 
431     function _exists(uint256 tokenId) internal view virtual returns (bool) {
432         return _owners[tokenId] != address(0);
433     }
434 
435     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
436         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
437         address owner = ERC721.ownerOf(tokenId);
438         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
439     }
440 
441     function _safeMint(address to, uint256 tokenId) internal virtual {
442         _safeMint(to, tokenId, "");
443     }
444 
445     function _safeMint(
446         address to,
447         uint256 tokenId,
448         bytes memory _data
449     ) internal virtual {
450         _mint(to, tokenId);
451         require(
452             _checkOnERC721Received(address(0), to, tokenId, _data),
453             "ERC721: transfer to non ERC721Receiver implementer"
454         );
455     }
456 
457     function _mint(address to, uint256 tokenId) internal virtual {
458         require(to != address(0), "ERC721: mint to the zero address");
459         require(!_exists(tokenId), "ERC721: token already minted");
460 
461         _beforeTokenTransfer(address(0), to, tokenId);
462 
463         _balances[to] += 1;
464         _owners[tokenId] = to;
465 
466         emit Transfer(address(0), to, tokenId);
467     }
468 
469     function _burn(uint256 tokenId) internal virtual {
470         address owner = ERC721.ownerOf(tokenId);
471 
472         _beforeTokenTransfer(owner, address(0), tokenId);
473 
474         _approve(address(0), tokenId);
475 
476         _balances[owner] -= 1;
477         delete _owners[tokenId];
478 
479         emit Transfer(owner, address(0), tokenId);
480     }
481 
482     function _transfer(
483         address from,
484         address to,
485         uint256 tokenId
486     ) internal virtual {
487         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
488         require(to != address(0), "ERC721: transfer to the zero address");
489 
490         _beforeTokenTransfer(from, to, tokenId);
491 
492         _approve(address(0), tokenId);
493 
494         _balances[from] -= 1;
495         _balances[to] += 1;
496         _owners[tokenId] = to;
497 
498         emit Transfer(from, to, tokenId);
499     }
500 
501     function _approve(address to, uint256 tokenId) internal virtual {
502         _tokenApprovals[tokenId] = to;
503         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
504     }
505 
506     function _checkOnERC721Received(
507         address from,
508         address to,
509         uint256 tokenId,
510         bytes memory _data
511     ) private returns (bool) {
512         if (to.isContract()) {
513             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
514                 return retval == IERC721Receiver.onERC721Received.selector;
515             } catch (bytes memory reason) {
516                 if (reason.length == 0) {
517                     revert("ERC721: transfer to non ERC721Receiver implementer");
518                 } else {
519                     assembly {
520                         revert(add(32, reason), mload(reason))
521                     }
522                 }
523             }
524         } else {
525             return true;
526         }
527     }
528 
529     function _beforeTokenTransfer(
530         address from,
531         address to,
532         uint256 tokenId
533     ) internal virtual {}
534 }
535 
536 
537 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
538 
539 
540 pragma solidity ^0.8.0;
541 
542 interface IERC721Enumerable is IERC721 {
543     
544     function totalSupply() external view returns (uint256);
545 
546     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
547 
548     function tokenByIndex(uint256 index) external view returns (uint256);
549 }
550 
551 
552 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
553 
554 
555 pragma solidity ^0.8.0;
556 
557 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
558     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
559 
560     mapping(uint256 => uint256) private _ownedTokensIndex;
561 
562     uint256[] private _allTokens;
563 
564     mapping(uint256 => uint256) private _allTokensIndex;
565 
566     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
567         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
568     }
569 
570     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
571         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
572         return _ownedTokens[owner][index];
573     }
574 
575     function totalSupply() public view virtual override returns (uint256) {
576         return _allTokens.length;
577     }
578 
579     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
580         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
581         return _allTokens[index];
582     }
583 
584     function _beforeTokenTransfer(
585         address from,
586         address to,
587         uint256 tokenId
588     ) internal virtual override {
589         super._beforeTokenTransfer(from, to, tokenId);
590 
591         if (from == address(0)) {
592             _addTokenToAllTokensEnumeration(tokenId);
593         } else if (from != to) {
594             _removeTokenFromOwnerEnumeration(from, tokenId);
595         }
596         if (to == address(0)) {
597             _removeTokenFromAllTokensEnumeration(tokenId);
598         } else if (to != from) {
599             _addTokenToOwnerEnumeration(to, tokenId);
600         }
601     }
602 
603     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
604         uint256 length = ERC721.balanceOf(to);
605         _ownedTokens[to][length] = tokenId;
606         _ownedTokensIndex[tokenId] = length;
607     }
608 
609     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
610         _allTokensIndex[tokenId] = _allTokens.length;
611         _allTokens.push(tokenId);
612     }
613 
614     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
615 
616         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
617         uint256 tokenIndex = _ownedTokensIndex[tokenId];
618 
619         if (tokenIndex != lastTokenIndex) {
620             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
621 
622             _ownedTokens[from][tokenIndex] = lastTokenId;
623             _ownedTokensIndex[lastTokenId] = tokenIndex;
624         }
625 
626         delete _ownedTokensIndex[tokenId];
627         delete _ownedTokens[from][lastTokenIndex];
628     }
629 
630     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
631 
632         uint256 lastTokenIndex = _allTokens.length - 1;
633         uint256 tokenIndex = _allTokensIndex[tokenId];
634 
635         uint256 lastTokenId = _allTokens[lastTokenIndex];
636 
637         _allTokens[tokenIndex] = lastTokenId; 
638         _allTokensIndex[lastTokenId] = tokenIndex; 
639 
640         delete _allTokensIndex[tokenId];
641         _allTokens.pop();
642     }
643 }
644 
645 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
646     using Address for address;
647     using Strings for uint256;
648 
649     struct TokenOwnership {
650         address addr;
651         uint64 startTimestamp;
652     }
653 
654     struct AddressData {
655         uint128 balance;
656         uint128 numberMinted;
657     }
658 
659     uint256 private currentIndex = 1;
660 
661      uint256 internal immutable maxBatchSize;
662 
663     string private _name;
664 
665     string private _symbol;
666 
667     mapping(uint256 => TokenOwnership) private _ownerships;
668 
669     mapping(address => AddressData) private _addressData;
670 
671     mapping(uint256 => address) private _tokenApprovals;
672 
673     mapping(address => mapping(address => bool)) private _operatorApprovals;
674 
675     constructor(
676         string memory name_,
677         string memory symbol_,
678         uint256 maxBatchSize_
679     ) {
680         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
681         _name = name_;
682         _symbol = symbol_;
683         maxBatchSize = maxBatchSize_;
684     }
685 
686     function totalSupply() public view override returns (uint256) {
687         return currentIndex;
688     }
689 
690     function tokenByIndex(uint256 index) public view override returns (uint256) {
691         require(index < totalSupply(), "ERC721A: global index out of bounds");
692         return index;
693     }
694 
695     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
696         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
697         uint256 numMintedSoFar = totalSupply();
698         uint256 tokenIdsIdx = 0;
699         address currOwnershipAddr = address(0);
700         for (uint256 i = 0; i < numMintedSoFar; i++) {
701             TokenOwnership memory ownership = _ownerships[i];
702             if (ownership.addr != address(0)) {
703                 currOwnershipAddr = ownership.addr;
704             }
705             if (currOwnershipAddr == owner) {
706                 if (tokenIdsIdx == index) {
707                     return i;
708                 }
709                 tokenIdsIdx++;
710             }
711         }
712         revert("ERC721A: unable to get token of owner by index");
713     }
714 
715     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
716         return
717             interfaceId == type(IERC721).interfaceId ||
718             interfaceId == type(IERC721Metadata).interfaceId ||
719             interfaceId == type(IERC721Enumerable).interfaceId ||
720             super.supportsInterface(interfaceId);
721     }
722 
723     function balanceOf(address owner) public view override returns (uint256) {
724         require(owner != address(0), "ERC721A: balance query for the zero address");
725         return uint256(_addressData[owner].balance);
726     }
727 
728     function _numberMinted(address owner) internal view returns (uint256) {
729         require(owner != address(0), "ERC721A: number minted query for the zero address");
730         return uint256(_addressData[owner].numberMinted);
731     }
732 
733     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
734         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
735 
736         uint256 lowestTokenToCheck;
737         if (tokenId >= maxBatchSize) {
738             lowestTokenToCheck = tokenId - maxBatchSize + 1;
739         }
740 
741         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
742             TokenOwnership memory ownership = _ownerships[curr];
743             if (ownership.addr != address(0)) {
744                 return ownership;
745             }
746         }
747 
748         revert("ERC721A: unable to determine the owner of token");
749     }
750 
751     function ownerOf(uint256 tokenId) public view override returns (address) {
752         return ownershipOf(tokenId).addr;
753     }
754 
755     function name() public view virtual override returns (string memory) {
756         return _name;
757     }
758 
759     function symbol() public view virtual override returns (string memory) {
760         return _symbol;
761     }
762 
763     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
764         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
765 
766         string memory baseURI = _baseURI();
767         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
768     }
769 
770     function _baseURI() internal view virtual returns (string memory) {
771         return "";
772     }
773 
774     function approve(address to, uint256 tokenId) public override {
775         address owner = ERC721A.ownerOf(tokenId);
776         require(to != owner, "ERC721A: approval to current owner");
777 
778         require(
779             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
780             "ERC721A: approve caller is not owner nor approved for all"
781         );
782 
783         _approve(to, tokenId, owner);
784     }
785 
786     function getApproved(uint256 tokenId) public view override returns (address) {
787         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
788 
789         return _tokenApprovals[tokenId];
790     }
791 
792     function setApprovalForAll(address operator, bool approved) public override {
793         require(operator != _msgSender(), "ERC721A: approve to caller");
794 
795         _operatorApprovals[_msgSender()][operator] = approved;
796         emit ApprovalForAll(_msgSender(), operator, approved);
797     }
798 
799     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
800         return _operatorApprovals[owner][operator];
801     }
802 
803     function transferFrom(
804         address from,
805         address to,
806         uint256 tokenId
807     ) public override {
808         _transfer(from, to, tokenId);
809     }
810 
811     function safeTransferFrom(
812         address from,
813         address to,
814         uint256 tokenId
815     ) public override {
816         safeTransferFrom(from, to, tokenId, "");
817     }
818 
819     function safeTransferFrom(
820         address from,
821         address to,
822         uint256 tokenId,
823         bytes memory _data
824     ) public override {
825         _transfer(from, to, tokenId);
826         require(
827             _checkOnERC721Received(from, to, tokenId, _data),
828             "ERC721A: transfer to non ERC721Receiver implementer"
829         );
830     }
831 
832     function _exists(uint256 tokenId) internal view returns (bool) {
833         return tokenId < currentIndex;
834     }
835 
836     function _safeMint(address to, uint256 quantity) internal {
837         _safeMint(to, quantity, "");
838     }
839 
840     function _safeMint(
841         address to,
842         uint256 quantity,
843         bytes memory _data
844     ) internal {
845         uint256 startTokenId = currentIndex;
846         require(to != address(0), "ERC721A: mint to the zero address");
847         require(!_exists(startTokenId), "ERC721A: token already minted");
848         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
849 
850         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
851 
852         AddressData memory addressData = _addressData[to];
853         _addressData[to] = AddressData(
854             addressData.balance + uint128(quantity),
855             addressData.numberMinted + uint128(quantity)
856         );
857         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
858 
859         uint256 updatedIndex = startTokenId;
860 
861         for (uint256 i = 0; i < quantity; i++) {
862             emit Transfer(address(0), to, updatedIndex);
863             require(
864                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
865                 "ERC721A: transfer to non ERC721Receiver implementer"
866             );
867             updatedIndex++;
868         }
869 
870         currentIndex = updatedIndex;
871         _afterTokenTransfers(address(0), to, startTokenId, quantity);
872     }
873 
874     function _transfer(
875         address from,
876         address to,
877         uint256 tokenId
878     ) private {
879         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
880 
881         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
882             getApproved(tokenId) == _msgSender() ||
883             isApprovedForAll(prevOwnership.addr, _msgSender()));
884 
885         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
886 
887         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
888         require(to != address(0), "ERC721A: transfer to the zero address");
889 
890         _beforeTokenTransfers(from, to, tokenId, 1);
891 
892         _approve(address(0), tokenId, prevOwnership.addr);
893 
894         _addressData[from].balance -= 1;
895         _addressData[to].balance += 1;
896         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
897 
898         uint256 nextTokenId = tokenId + 1;
899         if (_ownerships[nextTokenId].addr == address(0)) {
900             if (_exists(nextTokenId)) {
901                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
902             }
903         }
904 
905         emit Transfer(from, to, tokenId);
906         _afterTokenTransfers(from, to, tokenId, 1);
907     }
908 
909     function _approve(
910         address to,
911         uint256 tokenId,
912         address owner
913     ) private {
914         _tokenApprovals[tokenId] = to;
915         emit Approval(owner, to, tokenId);
916     }
917 
918     uint256 public nextOwnerToExplicitlySet = 0;
919 
920     function _setOwnersExplicit(uint256 quantity) internal {
921         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
922         require(quantity > 0, "quantity must be nonzero");
923         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
924         if (endIndex > currentIndex - 1) {
925             endIndex = currentIndex - 1;
926         }
927         require(_exists(endIndex), "not enough minted yet for this cleanup");
928         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
929             if (_ownerships[i].addr == address(0)) {
930                 TokenOwnership memory ownership = ownershipOf(i);
931                 _ownerships[i] = TokenOwnership(ownership.addr, ownership.startTimestamp);
932             }
933         }
934         nextOwnerToExplicitlySet = endIndex + 1;
935     }
936 
937     function _checkOnERC721Received(
938         address from,
939         address to,
940         uint256 tokenId,
941         bytes memory _data
942     ) private returns (bool) {
943         if (to.isContract()) {
944             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
945                 return retval == IERC721Receiver(to).onERC721Received.selector;
946             } catch (bytes memory reason) {
947                 if (reason.length == 0) {
948                     revert("ERC721A: transfer to non ERC721Receiver implementer");
949                 } else {
950                     assembly {
951                         revert(add(32, reason), mload(reason))
952                     }
953                 }
954             }
955         } else {
956             return true;
957         }
958     }
959 
960     function _beforeTokenTransfers(
961         address from,
962         address to,
963         uint256 startTokenId,
964         uint256 quantity
965     ) internal virtual {}
966 
967     function _afterTokenTransfers(
968         address from,
969         address to,
970         uint256 startTokenId,
971         uint256 quantity
972     ) internal virtual {}
973 }
974 
975 pragma solidity ^0.8.0;
976 
977 contract Bocephi is ERC721A
978 {
979     using Strings for uint256;
980 
981     string public baseURI;
982     uint256 public cost;
983     uint256 public maxSupply;
984     uint256 public maxMintAmount = 2;
985     uint256 public maxMintPerTransaction = 2;
986     address public owner;
987     bool public preSaleLive;
988     bool public mintLive;
989 
990     mapping(address => bool) private whiteList;
991     mapping(address => uint256) private mintCount;
992 
993     modifier onlyOwner() {
994         require(owner == msg.sender, "not owner");
995         _;
996     }
997 
998     modifier preSaleIsLive() {
999         require(preSaleLive, "preSale not live");
1000         _;
1001     }
1002 
1003     modifier mintIsLive() {
1004         require(mintLive, "mint not live");
1005         _;
1006     }
1007 
1008     constructor(string memory defaultBaseURI) ERC721A("Bocephi", "BOCE", maxMintAmount) {
1009         owner = msg.sender;
1010         baseURI = defaultBaseURI;
1011         maxSupply = 421;
1012         maxMintPerTransaction;
1013         cost = 0;
1014     }
1015 
1016     function isWhiteListed(address _address) public view returns (bool){
1017         return whiteList[_address];
1018     }
1019 
1020     function mintedByAddressCount(address _address) public view returns (uint256){
1021         return mintCount[_address];
1022     }
1023 
1024     function setCost(uint256 _newCost) public onlyOwner {
1025         cost = _newCost;
1026     }
1027 
1028     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1029         maxMintAmount = _newmaxMintAmount;
1030     }
1031 
1032     function setmaxMintPerTransaction(uint256 _newmaxMintPerTransaction) public onlyOwner {
1033         maxMintPerTransaction = _newmaxMintPerTransaction;
1034     }
1035 
1036     function mint(uint256 _mintAmount) external payable mintIsLive {
1037         address _to = msg.sender;
1038         uint256 minted = mintCount[_to];
1039         require(minted + _mintAmount <= maxMintAmount, "mint over max");
1040         require(_mintAmount <= maxMintPerTransaction, "amount must < max");
1041         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
1042         require(msg.value >= cost * _mintAmount, "insufficient funds");
1043 
1044         mintCount[_to] = minted + _mintAmount;
1045         _safeMint(msg.sender, _mintAmount);
1046     }
1047 
1048     function preSaleMint(uint256 _mintAmount) external payable preSaleIsLive {
1049         address _to = msg.sender;
1050         uint256 minted = mintCount[_to];
1051         require(whiteList[_to], "not whitelisted");
1052         require(minted + _mintAmount <= maxMintAmount, "mint over max");
1053         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
1054         require(msg.value >= cost * _mintAmount, "insufficient funds");
1055 
1056         mintCount[_to] = minted + _mintAmount;
1057         _safeMint(msg.sender, _mintAmount);
1058     }
1059 
1060     function mintByOwner(address _to, uint256 _mintAmount) external onlyOwner {
1061         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
1062         if (_mintAmount <= maxBatchSize) {
1063             _safeMint(_to, _mintAmount);
1064             return;
1065         }
1066         
1067         uint256 leftToMint = _mintAmount;
1068         while (leftToMint > 0) {
1069             if (leftToMint <= maxBatchSize) {
1070                 _safeMint(_to, leftToMint);
1071                 return;
1072             }
1073             _safeMint(_to, maxBatchSize);
1074             leftToMint = leftToMint - maxBatchSize;
1075         }
1076     }
1077 
1078     function addToWhiteList(address[] calldata _addresses) external onlyOwner {
1079         for (uint256 i; i < _addresses.length; i++) {
1080             whiteList[_addresses[i]] = true;
1081         }
1082     }
1083 
1084     function togglePreSaleLive() external onlyOwner {
1085         if (preSaleLive) {
1086             preSaleLive = false;
1087             return;
1088         }
1089         preSaleLive = true;
1090     }
1091 
1092     function toggleMintLive() external onlyOwner {
1093         if (mintLive) {
1094             mintLive = false;
1095             return;
1096         }
1097         preSaleLive = false;
1098         mintLive = true;
1099     }
1100 
1101     function setBaseURI(string memory _newURI) external onlyOwner {
1102         baseURI = _newURI;
1103     }
1104 
1105     function withdraw() external payable onlyOwner {
1106         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1107         require(success, "Transfer failed");
1108     }
1109 
1110     function setOwnersExplicit(uint256 quantity) external onlyOwner {
1111         _setOwnersExplicit(quantity);
1112     }
1113 
1114     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1115         require(_exists(_tokenId), "URI query for nonexistent token");
1116 
1117         string memory baseTokenURI = _baseURI();
1118         string memory json = ".json";
1119         return bytes(baseTokenURI).length > 0
1120             ? string(abi.encodePacked(baseTokenURI, _tokenId.toString(), json))
1121             : '';
1122     }
1123 
1124     function _baseURI() internal view virtual override returns (string memory) {
1125         return baseURI;
1126     }
1127 
1128     fallback() external payable { }
1129 
1130     receive() external payable { }
1131 }