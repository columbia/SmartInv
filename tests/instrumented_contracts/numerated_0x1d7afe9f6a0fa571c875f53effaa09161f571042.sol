1 /**
2  
3 ██████╗░░█████╗░██████╗░███████╗  ░██████╗██╗░░██╗██╗████████╗
4 ██╔══██╗██╔══██╗██╔══██╗██╔════╝  ██╔════╝██║░░██║██║╚══██╔══╝
5 ██║░░██║██║░░██║██████╔╝█████╗░░  ╚█████╗░███████║██║░░░██║░░░
6 ██║░░██║██║░░██║██╔═══╝░██╔══╝░░  ░╚═══██╗██╔══██║██║░░░██║░░░
7 ██████╔╝╚█████╔╝██║░░░░░███████╗  ██████╔╝██║░░██║██║░░░██║░░░
8 ╚═════╝░░╚════╝░╚═╝░░░░░╚══════╝  ╚═════╝░╚═╝░░╚═╝╚═╝░░░╚═╝░░░
9  
10  #GANGFOLLOWGANG
11  #STREETGANG
12 
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity ^0.8.0;
18 
19 library Address {
20 
21     function isContract(address account) internal view returns (bool) {
22 
23         uint256 size;
24         assembly {
25             size := extcodesize(account)
26         }
27         return size > 0;
28     }
29 
30     function sendValue(address payable recipient, uint256 amount) internal {
31         require(address(this).balance >= amount, "Address : insufficient balance");
32 
33         (bool success, ) = recipient.call{value: amount}("");
34         require(success, "Address : unable to send value, recipient may have reverted");
35     }
36 
37     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
38         return functionCall(target, data, "Address : low-level call failed");
39     }
40 
41     function functionCall(
42         address target,
43         bytes memory data,
44         string memory errorMessage
45     ) internal returns (bytes memory) {
46         return functionCallWithValue(target, data, 0, errorMessage);
47     }
48 
49     function functionCallWithValue(
50         address target,
51         bytes memory data,
52         uint256 value
53     ) internal returns (bytes memory) {
54         return functionCallWithValue(target, data, value, "Address : low-level call with value failed");
55     }
56 
57     function functionCallWithValue(
58         address target,
59         bytes memory data,
60         uint256 value,
61         string memory errorMessage
62     ) internal returns (bytes memory) {
63         require(address(this).balance >= value, "Address : insufficient balance for call");
64         require(isContract(target), "Address : call to non-contract");
65 
66         (bool success, bytes memory returndata) = target.call{value: value}(data);
67         return verifyCallResult(success, returndata, errorMessage);
68     }
69 
70     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
71         return functionStaticCall(target, data, "Address : low-level static call failed");
72     }
73 
74     function functionStaticCall(
75         address target,
76         bytes memory data,
77         string memory errorMessage
78     ) internal view returns (bytes memory) {
79         require(isContract(target), "Address : Static call to non-contract");
80 
81         (bool success, bytes memory returndata) = target.staticcall(data);
82         return verifyCallResult(success, returndata, errorMessage);
83     }
84 
85     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
86         return functionDelegateCall(target, data, "Address : Low-level delegate call failed");
87     }
88 
89     function functionDelegateCall(
90         address target,
91         bytes memory data,
92         string memory errorMessage
93     ) internal returns (bytes memory) {
94         require(isContract(target), "Address : Delegate call to non-contract");
95 
96         (bool success, bytes memory returndata) = target.delegatecall(data);
97         return verifyCallResult(success, returndata, errorMessage);
98     }
99 
100     function verifyCallResult(
101         bool success,
102         bytes memory returndata,
103         string memory errorMessage
104     ) internal pure returns (bytes memory) {
105         if (success) {
106             return returndata;
107         } else {
108             if (returndata.length > 0) {
109 
110                 assembly {
111                     let returndata_size := mload(returndata)
112                     revert(add(32, returndata), returndata_size)
113                 }
114             } else {
115                 revert(errorMessage);
116             }
117         }
118     }
119 }
120 
121 pragma solidity ^0.8.0;
122 
123 library Strings {
124     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
125 
126     function toString(uint256 value) internal pure returns (string memory) {
127 
128         if (value == 0) {
129             return "0";
130         }
131         uint256 temp = value;
132         uint256 digits;
133         while (temp != 0) {
134             digits++;
135             temp /= 10;
136         }
137         bytes memory buffer = new bytes(digits);
138         while (value != 0) {
139             digits -= 1;
140             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
141             value /= 10;
142         }
143         return string(buffer);
144     }
145 
146     function toHexString(uint256 value) internal pure returns (string memory) {
147         if (value == 0) {
148             return "0x00";
149         }
150         uint256 temp = value;
151         uint256 length = 0;
152         while (temp != 0) {
153             length++;
154             temp >>= 8;
155         }
156         return toHexString(value, length);
157     }
158 
159     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
160         bytes memory buffer = new bytes(2 * length + 2);
161         buffer[0] = "0";
162         buffer[1] = "x";
163         for (uint256 i = 2 * length + 1; i > 1; --i) {
164             buffer[i] = _HEX_SYMBOLS[value & 0xf];
165             value >>= 4;
166         }
167         require(value == 0, "Strings : Hex length insufficient");
168         return string(buffer);
169     }
170 }
171 
172 
173 pragma solidity ^0.8.0;
174 
175 library Counters {
176     struct Counter {
177 
178         uint256 _value; // default: 0
179     }
180 
181     function current(Counter storage counter) internal view returns (uint256) {
182         return counter._value;
183     }
184 
185     function increment(Counter storage counter) internal {
186         unchecked {
187             counter._value += 1;
188         }
189     }
190 
191     function decrement(Counter storage counter) internal {
192         uint256 value = counter._value;
193         require(value > 0, "Counter : Decrement overflow");
194         unchecked {
195             counter._value = value - 1;
196         }
197     }
198 
199     function reset(Counter storage counter) internal {
200         counter._value = 0;
201     }
202 }
203 
204 pragma solidity ^0.8.0;
205 
206 interface IERC165 {
207 
208     function supportsInterface(bytes4 interfaceId) external view returns (bool);
209 }
210 
211 
212 pragma solidity ^0.8.0;
213 
214 interface IERC721 is IERC165 {
215 
216     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
217 
218     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
219 
220     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
221 
222     function balanceOf(address owner) external view returns (uint256 balance);
223 
224     function ownerOf(uint256 tokenId) external view returns (address owner);
225 
226     function safeTransferFrom(
227         address from,
228         address to,
229         uint256 tokenId
230     ) external;
231 
232     function transferFrom(
233         address from,
234         address to,
235         uint256 tokenId
236     ) external;
237 
238     function approve(address to, uint256 tokenId) external;
239 
240     function getApproved(uint256 tokenId) external view returns (address operator);
241 
242     function setApprovalForAll(address operator, bool _approved) external;
243 
244     function isApprovedForAll(address owner, address operator) external view returns (bool);
245 
246     function safeTransferFrom(
247         address from,
248         address to,
249         uint256 tokenId,
250         bytes calldata data
251     ) external;
252 }
253 
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
267 
268 pragma solidity ^0.8.0;
269 
270 interface IERC721Metadata is IERC721 {
271 
272     function name() external view returns (string memory);
273 
274     function symbol() external view returns (string memory);
275 
276     function tokenURI(uint256 tokenId) external view returns (string memory);
277 }
278 
279 
280 pragma solidity ^0.8.0;
281 
282 abstract contract Context {
283     function _msgSender() internal view virtual returns (address) {
284         return msg.sender;
285     }
286 
287     function _msgData() internal view virtual returns (bytes calldata) {
288         return msg.data;
289     }
290 }
291 
292 
293 pragma solidity ^0.8.0;
294 
295 abstract contract ERC165 is IERC165 {
296 
297     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
298         return interfaceId == type(IERC165).interfaceId;
299     }
300 }
301 
302 
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
334         require(owner != address(0), "ERC721 :Balance query for the zero address");
335         return _balances[owner];
336     }
337 
338     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
339         address owner = _owners[tokenId];
340         require(owner != address(0), "ERC721 : Owner query for nonexistent token");
341         return owner;
342     }
343 
344     /**
345      * @dev See {IERC721Metadata-name}.
346      */
347     function name() public view virtual override returns (string memory) {
348         return _name;
349     }
350 
351     function symbol() public view virtual override returns (string memory) {
352         return _symbol;
353     }
354 
355     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
356         require(_exists(tokenId), "ERC721Metadata : URI query for nonexistent token");
357 
358         string memory baseURI = _baseURI();
359         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
360     }
361 
362     function _baseURI() internal view virtual returns (string memory) {
363         return "";
364     }
365 
366     function approve(address to, uint256 tokenId) public virtual override {
367         address owner = ERC721.ownerOf(tokenId);
368         require(to != owner, "ERC721 : approval to current owner");
369 
370         require(
371             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
372             "ERC721 : approve caller is not owner nor approved for all"
373         );
374 
375         _approve(to, tokenId);
376     }
377 
378     function getApproved(uint256 tokenId) public view virtual override returns (address) {
379         require(_exists(tokenId), "ERC721 : approved query for nonexistent token");
380 
381         return _tokenApprovals[tokenId];
382     }
383 
384 
385     function setApprovalForAll(address operator, bool approved) public virtual override {
386         require(operator != _msgSender(), "ERC721 : approve to caller");
387 
388         _operatorApprovals[_msgSender()][operator] = approved;
389         emit ApprovalForAll(_msgSender(), operator, approved);
390     }
391 
392     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
393         return _operatorApprovals[owner][operator];
394     }
395 
396     function transferFrom(
397         address from,
398         address to,
399         uint256 tokenId
400     ) public virtual override {
401         //solhint-disable-next-line max-line-length
402         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721 : transfer caller is not owner nor approved");
403 
404         _transfer(from, to, tokenId);
405     }
406 
407     function safeTransferFrom(
408         address from,
409         address to,
410         uint256 tokenId
411     ) public virtual override {
412         safeTransferFrom(from, to, tokenId, "");
413     }
414 
415     function safeTransferFrom(
416         address from,
417         address to,
418         uint256 tokenId,
419         bytes memory _data
420     ) public virtual override {
421         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721 : transfer caller is not owner nor approved");
422         _safeTransfer(from, to, tokenId, _data);
423     }
424 
425     function _safeTransfer(
426         address from,
427         address to,
428         uint256 tokenId,
429         bytes memory _data
430     ) internal virtual {
431         _transfer(from, to, tokenId);
432         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721 : transfer to non ERC721Receiver implementer");
433     }
434 
435     function _exists(uint256 tokenId) internal view virtual returns (bool) {
436         return _owners[tokenId] != address(0);
437     }
438 
439     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
440         require(_exists(tokenId), "ERC721 : operator query for nonexistent token");
441         address owner = ERC721.ownerOf(tokenId);
442         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
443     }
444 
445     function _safeMint(address to, uint256 tokenId) internal virtual {
446         _safeMint(to, tokenId, "");
447     }
448 
449     function _safeMint(
450         address to,
451         uint256 tokenId,
452         bytes memory _data
453     ) internal virtual {
454         _mint(to, tokenId);
455         require(
456             _checkOnERC721Received(address(0), to, tokenId, _data),
457             "ERC721 : Transfer to non ERC721Receiver implementer"
458         );
459     }
460 
461     function _mint(address to, uint256 tokenId) internal virtual {
462         require(to != address(0), "ERC721 : mint to the zero address");
463         require(!_exists(tokenId), "ERC721 : token already minted");
464 
465         _beforeTokenTransfer(address(0), to, tokenId);
466 
467         _balances[to] += 1;
468         _owners[tokenId] = to;
469 
470         emit Transfer(address(0), to, tokenId);
471     }
472 
473     function _burn(uint256 tokenId) internal virtual {
474         address owner = ERC721.ownerOf(tokenId);
475 
476         _beforeTokenTransfer(owner, address(0), tokenId);
477 
478         // Clear approvals
479         _approve(address(0), tokenId);
480 
481         _balances[owner] -= 1;
482         delete _owners[tokenId];
483 
484         emit Transfer(owner, address(0), tokenId);
485     }
486 
487     function _transfer(
488         address from,
489         address to,
490         uint256 tokenId
491     ) internal virtual {
492         require(ERC721.ownerOf(tokenId) == from, "ERC721 : Transfer of token that is not own");
493         require(to != address(0), "ERC721 : Transfer to the zero address");
494 
495         _beforeTokenTransfer(from, to, tokenId);
496 
497         // Clear approvals from the previous owner
498         _approve(address(0), tokenId);
499 
500         _balances[from] -= 1;
501         _balances[to] += 1;
502         _owners[tokenId] = to;
503 
504         emit Transfer(from, to, tokenId);
505     }
506 
507     function _approve(address to, uint256 tokenId) internal virtual {
508         _tokenApprovals[tokenId] = to;
509         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
510     }
511 
512     function _checkOnERC721Received(
513         address from,
514         address to,
515         uint256 tokenId,
516         bytes memory _data
517     ) private returns (bool) {
518         if (to.isContract()) {
519             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
520                 return retval == IERC721Receiver.onERC721Received.selector;
521             } catch (bytes memory reason) {
522                 if (reason.length == 0) {
523                     revert("ERC721 : transfer to non ERC721Receiver implementer");
524                 } else {
525                     assembly {
526                         revert(add(32, reason), mload(reason))
527                     }
528                 }
529             }
530         } else {
531             return true;
532         }
533     }
534 
535     function _beforeTokenTransfer(
536         address from,
537         address to,
538         uint256 tokenId
539     ) internal virtual {}
540 }
541 
542 pragma solidity ^0.8.0;
543 
544 interface IERC721Enumerable is IERC721 {
545 
546     function totalSupply() external view returns (uint256);
547 
548     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
549 
550     function tokenByIndex(uint256 index) external view returns (uint256);
551 }
552 
553 
554 pragma solidity ^0.8.0;
555 
556 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
557 
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
571         require(index < ERC721.balanceOf(owner), "ERC721Enumerable : owner index out of bounds");
572         return _ownedTokens[owner][index];
573     }
574 
575     function totalSupply() public view virtual override returns (uint256) {
576         return _allTokens.length;
577     }
578 
579     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
580         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable : global index out of bounds");
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
622             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
623             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
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
637         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
638         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
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
659     uint256 private currentIndex = 0;
660 
661     uint256 internal immutable maxBatchSize;
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
680         require(maxBatchSize_ > 0, "ERC721A : Max batch size must be nonzero");
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
691         require(index < totalSupply(), "ERC721A : Global index out of bounds");
692         return index;
693     }
694 
695     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
696         require(index < balanceOf(owner), "ERC721A : Owner index out of bounds");
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
712         revert("ERC721A : Unable to get token of owner by index");
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
724         require(owner != address(0), "ERC721A : Balance query for the zero address");
725         return uint256(_addressData[owner].balance);
726     }
727 
728     function _numberMinted(address owner) internal view returns (uint256) {
729         require(owner != address(0), "ERC721A : Number minted query for the zero address");
730         return uint256(_addressData[owner].numberMinted);
731     }
732 
733     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
734         require(_exists(tokenId), "ERC721A : Owner query for nonexistent token");
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
748         revert("ERC721A : Unable to determine the owner of token");
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
764         require(_exists(tokenId), "ERC721Metadata : URI Query for nonexistent token");
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
776         require(to != owner, "ERC721A : Approval to current owner");
777 
778         require(
779             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
780             "ERC721A : Approve caller is not owner nor approved for all"
781         );
782 
783         _approve(to, tokenId, owner);
784     }
785 
786     /**
787      * @dev See {IERC721-getApproved}.
788      */
789     function getApproved(uint256 tokenId) public view override returns (address) {
790         require(_exists(tokenId), "ERC721A : Approved query for nonexistent token");
791 
792         return _tokenApprovals[tokenId];
793     }
794 
795     /**
796      * @dev See {IERC721-setApprovalForAll}.
797      */
798     function setApprovalForAll(address operator, bool approved) public override {
799         require(operator != _msgSender(), "ERC721A : Approve to caller");
800 
801         _operatorApprovals[_msgSender()][operator] = approved;
802         emit ApprovalForAll(_msgSender(), operator, approved);
803     }
804 
805     /**
806      * @dev See {IERC721-isApprovedForAll}.
807      */
808     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
809         return _operatorApprovals[owner][operator];
810     }
811 
812     function transferFrom(
813         address from,
814         address to,
815         uint256 tokenId
816     ) public override {
817         _transfer(from, to, tokenId);
818     }
819 
820     function safeTransferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) public override {
825         safeTransferFrom(from, to, tokenId, "");
826     }
827 
828     /**
829      * @dev See {IERC721-safeTransferFrom}.
830      */
831     function safeTransferFrom(
832         address from,
833         address to,
834         uint256 tokenId,
835         bytes memory _data
836     ) public override {
837         _transfer(from, to, tokenId);
838         require(
839             _checkOnERC721Received(from, to, tokenId, _data),
840             "ERC721A : Transfer to non ERC721Receiver implementer"
841         );
842     }
843 
844     function _exists(uint256 tokenId) internal view returns (bool) {
845         return tokenId < currentIndex;
846     }
847 
848     function _safeMint(address to, uint256 quantity) internal {
849         _safeMint(to, quantity, "");
850     }
851 
852     function _safeMint(
853         address to,
854         uint256 quantity,
855         bytes memory _data
856     ) internal {
857         uint256 startTokenId = currentIndex;
858         require(to != address(0), "ERC721A : Mint to the zero address");
859         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
860         require(!_exists(startTokenId), "ERC721A : Token already minted");
861         require(quantity <= maxBatchSize, "ERC721A : Quantity to mint too high");
862 
863         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
864 
865         AddressData memory addressData = _addressData[to];
866         _addressData[to] = AddressData(
867             addressData.balance + uint128(quantity),
868             addressData.numberMinted + uint128(quantity)
869         );
870         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
871 
872         uint256 updatedIndex = startTokenId;
873 
874         for (uint256 i = 0; i < quantity; i++) {
875             emit Transfer(address(0), to, updatedIndex);
876             require(
877                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
878                 "ERC721A : Transfer to non ERC721Receiver implementer"
879             );
880             updatedIndex++;
881         }
882 
883         currentIndex = updatedIndex;
884         _afterTokenTransfers(address(0), to, startTokenId, quantity);
885     }
886 
887     function _transfer(
888         address from,
889         address to,
890         uint256 tokenId
891     ) private {
892         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
893 
894         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
895             getApproved(tokenId) == _msgSender() ||
896             isApprovedForAll(prevOwnership.addr, _msgSender()));
897 
898         require(isApprovedOrOwner, "ERC721A : Transfer caller is not owner nor approved");
899 
900         require(prevOwnership.addr == from, "ERC721A : Transfer from incorrect owner");
901         require(to != address(0), "ERC721A : Transfer to the zero address");
902 
903         _beforeTokenTransfers(from, to, tokenId, 1);
904 
905         // Clear approvals from the previous owner
906         _approve(address(0), tokenId, prevOwnership.addr);
907 
908         _addressData[from].balance -= 1;
909         _addressData[to].balance += 1;
910         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
911 
912         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
913         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
914         uint256 nextTokenId = tokenId + 1;
915         if (_ownerships[nextTokenId].addr == address(0)) {
916             if (_exists(nextTokenId)) {
917                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
918             }
919         }
920 
921         emit Transfer(from, to, tokenId);
922         _afterTokenTransfers(from, to, tokenId, 1);
923     }
924 
925     function _approve(
926         address to,
927         uint256 tokenId,
928         address owner
929     ) private {
930         _tokenApprovals[tokenId] = to;
931         emit Approval(owner, to, tokenId);
932     }
933 
934     uint256 public nextOwnerToExplicitlySet = 0;
935 
936     function _setOwnersExplicit(uint256 quantity) internal {
937         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
938         require(quantity > 0, "Quantity must be nonzero ");
939         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
940         if (endIndex > currentIndex - 1) {
941             endIndex = currentIndex - 1;
942         }
943         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
944         require(_exists(endIndex), "Not enough minted yet for this cleanup ");
945         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
946             if (_ownerships[i].addr == address(0)) {
947                 TokenOwnership memory ownership = ownershipOf(i);
948                 _ownerships[i] = TokenOwnership(ownership.addr, ownership.startTimestamp);
949             }
950         }
951         nextOwnerToExplicitlySet = endIndex + 1;
952     }
953 
954     function _checkOnERC721Received(
955         address from,
956         address to,
957         uint256 tokenId,
958         bytes memory _data
959     ) private returns (bool) {
960         if (to.isContract()) {
961             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
962                 return retval == IERC721Receiver(to).onERC721Received.selector;
963             } catch (bytes memory reason) {
964                 if (reason.length == 0) {
965                     revert("ERC721A: Transfer to non ERC721Receiver implementer");
966                 } else {
967                     assembly {
968                         revert(add(32, reason), mload(reason))
969                     }
970                 }
971             }
972         } else {
973             return true;
974         }
975     }
976 
977     function _beforeTokenTransfers(
978         address from,
979         address to,
980         uint256 startTokenId,
981         uint256 quantity
982     ) internal virtual {}
983 
984     function _afterTokenTransfers(
985         address from,
986         address to,
987         uint256 startTokenId,
988         uint256 quantity
989     ) internal virtual {}
990 }
991 
992 pragma solidity ^0.8.9;
993 
994 contract StreetGang is ERC721A
995 {
996     using Strings for uint256;
997 
998     string public baseURI;
999     uint256 public cost;
1000     uint256 public maxSupply;
1001     uint256 public maxMintAmount = 1;
1002     uint256 public maxMintPerTransaction;
1003     uint256 private warAwardsCount;
1004     address public owner;
1005     bool public preSaleLive;
1006     bool public mintLive;
1007 
1008     mapping(address => bool) private whiteList;
1009     mapping(address => uint256) private mintCount;
1010     mapping(uint256 => string) private warAwards;
1011 
1012     modifier onlyOwner() {
1013         require(owner == msg.sender, "Not Owner");
1014         _;
1015     }
1016 
1017     modifier preSaleIsLive() {
1018         require(preSaleLive, "preSale not Live");
1019         _;
1020     }
1021 
1022     modifier mintIsLive() {
1023         require(mintLive, "mint not Live");
1024         _;
1025     }
1026 
1027     constructor(string memory defaultBaseURI) ERC721A("Street Gang", "SG", maxMintAmount) {
1028         owner = msg.sender;
1029         baseURI = defaultBaseURI;
1030         maxSupply = 2000;
1031         maxMintPerTransaction = 1;
1032         cost = 0 ether;
1033         warAwardsCount = 0;
1034     }
1035 
1036     function isWhiteListed(address _address) public view returns (bool){
1037         return whiteList[_address];
1038     }
1039 
1040     function mintedByAddressCount(address _address) public view returns (uint256){
1041         return mintCount[_address];
1042     }
1043 
1044     function mint(uint256 _mintAmount) external payable mintIsLive {
1045         address _to = msg.sender;
1046         uint256 minted = mintCount[_to];
1047         require(minted + _mintAmount <= maxMintAmount, "mint over max ");
1048         require(_mintAmount <= maxMintPerTransaction, "amount must < max ");
1049         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply ");
1050         require(msg.value >= cost * _mintAmount, "insufficient funds ");
1051 
1052         mintCount[_to] = minted + _mintAmount;
1053         _safeMint(msg.sender, _mintAmount);
1054     }
1055 
1056     function preSaleMint(uint256 _mintAmount) external payable preSaleIsLive {
1057         address _to = msg.sender;
1058         uint256 minted = mintCount[_to];
1059         require(whiteList[_to], "Not whitelisted ");
1060         require(minted + _mintAmount <= maxMintAmount, "Mint over max ");
1061         require(totalSupply() + _mintAmount <= maxSupply, "Mint over supply ");
1062         require(msg.value >= cost * _mintAmount, "Insufficient funds ");
1063 
1064         mintCount[_to] = minted + _mintAmount;
1065         _safeMint(msg.sender, _mintAmount);
1066     }
1067 
1068     // Only Owner executable functions
1069     function mintByOwner(address _to, uint256 _mintAmount) external onlyOwner {
1070         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply ");
1071         if (_mintAmount <= maxBatchSize) {
1072             _safeMint(_to, _mintAmount);
1073             return;
1074         }
1075         
1076         uint256 leftToMint = _mintAmount;
1077         while (leftToMint > 0) {
1078             if (leftToMint <= maxBatchSize) {
1079                 _safeMint(_to, leftToMint);
1080                 return;
1081             }
1082             _safeMint(_to, maxBatchSize);
1083             leftToMint = leftToMint - maxBatchSize;
1084         }
1085     }
1086 
1087     function addToWhiteList(address[] calldata _addresses) external onlyOwner {
1088         for (uint256 i; i < _addresses.length; i++) {
1089             whiteList[_addresses[i]] = true;
1090         }
1091     }
1092 
1093     function togglePreSaleLive() external onlyOwner {
1094         if (preSaleLive) {
1095             preSaleLive = false;
1096             return;
1097         }
1098         preSaleLive = true;
1099     }
1100 
1101     function toggleMintLive() external onlyOwner {
1102         if (mintLive) {
1103             mintLive = false;
1104             return;
1105         }
1106         preSaleLive = false;
1107         mintLive = true;
1108     }
1109 
1110     function setBaseURI(string memory _newURI) external onlyOwner {
1111         baseURI = _newURI;
1112     }
1113 
1114     function withdraw() external payable onlyOwner {
1115         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1116         require(success, "Transfer failed ");
1117     }
1118 
1119     function setOwnersExplicit(uint256 quantity) external onlyOwner {
1120         _setOwnersExplicit(quantity);
1121     }
1122 
1123     // token URI functionality
1124     function setWarAwardTokenURI(uint256 _tokenId, string memory _tokenURI) external onlyOwner {
1125         require(_tokenId < warAwardsCount, "tokenId above max awards ");
1126         warAwards[_tokenId] = _tokenURI;
1127     }
1128 
1129     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1130         require(_exists(_tokenId), "URI query for nonexistent token ");
1131 
1132         if (bytes(warAwards[_tokenId]).length > 0) {
1133             return warAwards[_tokenId];
1134         }
1135 
1136         string memory baseTokenURI = _baseURI();
1137         string memory json = ".json";
1138         return bytes(baseTokenURI).length > 0
1139             ? string(abi.encodePacked(baseTokenURI, _tokenId.toString(), json))
1140             : '';
1141     }
1142 
1143     function _baseURI() internal view virtual override returns (string memory) {
1144         return baseURI;
1145     }
1146 
1147     fallback() external payable { }
1148 
1149     receive() external payable { }
1150 }