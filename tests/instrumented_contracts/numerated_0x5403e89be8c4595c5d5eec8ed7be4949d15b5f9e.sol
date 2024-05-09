1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 library Counters {
5     struct Counter {
6         uint256 _value; // default: 0
7     }
8     function current(Counter storage counter) internal view returns (uint256) {
9         return counter._value;
10     }
11     function increment(Counter storage counter) internal {
12         unchecked {
13             counter._value += 1;
14         }
15     }
16     function decrement(Counter storage counter) internal {
17         uint256 value = counter._value;
18         require(value > 0, "Counter:decrement overflow");
19         unchecked {
20             counter._value = value - 1;
21         }
22     }
23     function reset(Counter storage counter) internal {
24         counter._value = 0;
25     }
26 }
27 pragma solidity ^0.8.0;
28 
29 library Strings {
30     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31 
32     function toString(uint256 value) internal pure returns (string memory) {
33 
34         if (value == 0) {
35             return "0";
36         }
37         uint256 temp = value;
38         uint256 digits;
39         while (temp != 0) {
40             digits++;
41             temp /= 10;
42         }
43         bytes memory buffer = new bytes(digits);
44         while (value != 0) {
45             digits -= 1;
46             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
47             value /= 10;
48         }
49         return string(buffer);
50     }
51 
52     function toHexString(uint256 value) internal pure returns (string memory) {
53         if (value == 0) {
54             return "0x00";
55         }
56         uint256 temp = value;
57         uint256 length = 0;
58         while (temp != 0) {
59             length++;
60             temp >>= 8;
61         }
62         return toHexString(value, length);
63     }
64 
65     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
66         bytes memory buffer = new bytes(2 * length + 2);
67         buffer[0] = "0";
68         buffer[1] = "x";
69         for (uint256 i = 2 * length + 1; i > 1; --i) {
70             buffer[i] = _HEX_SYMBOLS[value & 0xf];
71             value >>= 4;
72         }
73         require(value == 0, "Strings: hex length insufficient");
74         return string(buffer);
75     }
76 }
77 
78 pragma solidity ^0.8.0;
79 
80 abstract contract Context {
81     function _msgSender() internal view virtual returns (address) {
82         return msg.sender;
83     }
84 
85     function _msgData() internal view virtual returns (bytes calldata) {
86         return msg.data;
87     }
88 }
89 
90 
91 pragma solidity ^0.8.0;
92 
93 abstract contract Ownable is Context {
94     address private _owner;
95 
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     constructor() {
99         _transferOwnership(_msgSender());
100     }
101 
102     function owner() public view virtual returns (address) {
103         return _owner;
104     }
105 
106     modifier onlyOwner() {
107         require(owner() == _msgSender(), "Ownable: caller is not the owner");
108         _;
109     }
110 
111     function renounceOwnership() public virtual onlyOwner {
112         _transferOwnership(address(0));
113     }
114 
115     function transferOwnership(address newOwner) public virtual onlyOwner {
116         require(newOwner != address(0), "Ownable: new owner is the zero address");
117         _transferOwnership(newOwner);
118     }
119 
120     function _transferOwnership(address newOwner) internal virtual {
121         address oldOwner = _owner;
122         _owner = newOwner;
123         emit OwnershipTransferred(oldOwner, newOwner);
124     }
125 }
126 
127 pragma solidity ^0.8.1;
128 
129 library Address {
130 
131     function isContract(address account) internal view returns (bool) {
132 
133         return account.code.length > 0;
134     }
135 
136     function sendValue(address payable recipient, uint256 amount) internal {
137         require(address(this).balance >= amount, "Address: insufficient balance");
138 
139         (bool success, ) = recipient.call{value: amount}("");
140         require(success, "Address: unable to send value, recipient may have reverted");
141     }
142 
143     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
144         return functionCall(target, data, "Address: low-level call failed");
145     }
146 
147     function functionCall(
148         address target,
149         bytes memory data,
150         string memory errorMessage
151     ) internal returns (bytes memory) {
152         return functionCallWithValue(target, data, 0, errorMessage);
153     }
154 
155     function functionCallWithValue(
156         address target,
157         bytes memory data,
158         uint256 value
159     ) internal returns (bytes memory) {
160         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
161     }
162 
163     function functionCallWithValue(
164         address target,
165         bytes memory data,
166         uint256 value,
167         string memory errorMessage
168     ) internal returns (bytes memory) {
169         require(address(this).balance >= value, "Address: insufficient balance for call");
170         require(isContract(target), "Address: call to non-contract");
171 
172         (bool success, bytes memory returndata) = target.call{value: value}(data);
173         return verifyCallResult(success, returndata, errorMessage);
174     }
175 
176     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
177         return functionStaticCall(target, data, "Address: low-level static call failed");
178     }
179 
180     function functionStaticCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal view returns (bytes memory) {
185         require(isContract(target), "Address: static call to non-contract");
186 
187         (bool success, bytes memory returndata) = target.staticcall(data);
188         return verifyCallResult(success, returndata, errorMessage);
189     }
190 
191     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
192         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
193     }
194 
195     function functionDelegateCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         require(isContract(target), "Address: delegate call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.delegatecall(data);
203         return verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     function verifyCallResult(
207         bool success,
208         bytes memory returndata,
209         string memory errorMessage
210     ) internal pure returns (bytes memory) {
211         if (success) {
212             return returndata;
213         } else {
214             // Look for revert reason and bubble it up if present
215             if (returndata.length > 0) {
216                 // The easiest way to bubble the revert reason is using memory via assembly
217 
218                 assembly {
219                     let returndata_size := mload(returndata)
220                     revert(add(32, returndata), returndata_size)
221                 }
222             } else {
223                 revert(errorMessage);
224             }
225         }
226     }
227 }
228 
229 pragma solidity ^0.8.0;
230 
231 interface IERC721Receiver {
232 
233     function onERC721Received(
234         address operator,
235         address from,
236         uint256 tokenId,
237         bytes calldata data
238     ) external returns (bytes4);
239 }
240 
241 pragma solidity ^0.8.0;
242 
243 interface IERC165 {
244 
245     function supportsInterface(bytes4 interfaceId) external view returns (bool);
246 }
247 
248 pragma solidity ^0.8.0;
249 
250 abstract contract ERC165 is IERC165 {
251     /**
252      * @dev See {IERC165-supportsInterface}.
253      */
254     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
255         return interfaceId == type(IERC165).interfaceId;
256     }
257 }
258 
259 pragma solidity ^0.8.0;
260 
261 interface IERC721 is IERC165 {
262 
263     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
264 
265     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
266 
267     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
268 
269     function balanceOf(address owner) external view returns (uint256 balance);
270 
271     function ownerOf(uint256 tokenId) external view returns (address owner);
272 
273     function safeTransferFrom(
274         address from,
275         address to,
276         uint256 tokenId
277     ) external;
278 
279     function transferFrom(
280         address from,
281         address to,
282         uint256 tokenId
283     ) external;
284 
285     function approve(address to, uint256 tokenId) external;
286 
287     function getApproved(uint256 tokenId) external view returns (address operator);
288 
289     function setApprovalForAll(address operator, bool _approved) external;
290 
291     /**
292      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
293      *
294      * See {setApprovalForAll}
295      */
296     function isApprovedForAll(address owner, address operator) external view returns (bool);
297 
298     function safeTransferFrom(
299         address from,
300         address to,
301         uint256 tokenId,
302         bytes calldata data
303     ) external;
304 }
305 
306 
307 pragma solidity ^0.8.0;
308 
309 interface IERC721Enumerable is IERC721 {
310 
311     function totalSupply() external view returns (uint256);
312 
313     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
314 
315     function tokenByIndex(uint256 index) external view returns (uint256);
316 }
317 
318 pragma solidity ^0.8.0;
319 
320 interface IERC721Metadata is IERC721 {
321 
322     function name() external view returns (string memory);
323 
324     function symbol() external view returns (string memory);
325 
326     function tokenURI(uint256 tokenId) external view returns (string memory);
327 }
328 
329 
330 pragma solidity ^0.8.0;
331 
332 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
333     using Address for address;
334     using Strings for uint256;
335 
336     // Token name
337     string private _name;
338 
339     // Token symbol
340     string private _symbol;
341 
342     // Mapping from token ID to owner address
343     mapping(uint256 => address) private _owners;
344 
345     // Mapping owner address to token count
346     mapping(address => uint256) private _balances;
347 
348     // Mapping from token ID to approved address
349     mapping(uint256 => address) private _tokenApprovals;
350 
351     // Mapping from owner to operator approvals
352     mapping(address => mapping(address => bool)) private _operatorApprovals;
353 
354     constructor(string memory name_, string memory symbol_) {
355         _name = name_;
356         _symbol = symbol_;
357     }
358 
359     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
360         return
361             interfaceId == type(IERC721).interfaceId ||
362             interfaceId == type(IERC721Metadata).interfaceId ||
363             super.supportsInterface(interfaceId);
364     }
365 
366     function balanceOf(address owner) public view virtual override returns (uint256) {
367         require(owner != address(0), "ERC721: balance query for the zero address");
368         return _balances[owner];
369     }
370 
371     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
372         address owner = _owners[tokenId];
373         require(owner != address(0), "ERC721: owner query for nonexistent token");
374         return owner;
375     }
376 
377     function name() public view virtual override returns (string memory) {
378         return _name;
379     }
380 
381     function symbol() public view virtual override returns (string memory) {
382         return _symbol;
383     }
384 
385     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
386         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
387 
388         string memory baseURI = _baseURI();
389         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
390     }
391 
392     function _baseURI() internal view virtual returns (string memory) {
393         return "";
394     }
395 
396     function approve(address to, uint256 tokenId) public virtual override {
397         address owner = ERC721.ownerOf(tokenId);
398         require(to != owner, "ERC721: approval to current owner");
399 
400         require(
401             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
402             "ERC721: approve caller is not owner nor approved for all"
403         );
404 
405         _approve(to, tokenId);
406     }
407 
408     function getApproved(uint256 tokenId) public view virtual override returns (address) {
409         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
410 
411         return _tokenApprovals[tokenId];
412     }
413 
414     function setApprovalForAll(address operator, bool approved) public virtual override {
415         _setApprovalForAll(_msgSender(), operator, approved);
416     }
417 
418     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
419         return _operatorApprovals[owner][operator];
420     }
421 
422     function transferFrom(
423         address from,
424         address to,
425         uint256 tokenId
426     ) public virtual override {
427         //solhint-disable-next-line max-line-length
428         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
429 
430         _transfer(from, to, tokenId);
431     }
432 
433     function safeTransferFrom(
434         address from,
435         address to,
436         uint256 tokenId
437     ) public virtual override {
438         safeTransferFrom(from, to, tokenId, "");
439     }
440 
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 tokenId,
445         bytes memory _data
446     ) public virtual override {
447         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
448         _safeTransfer(from, to, tokenId, _data);
449     }
450 
451     function _safeTransfer(
452         address from,
453         address to,
454         uint256 tokenId,
455         bytes memory _data
456     ) internal virtual {
457         _transfer(from, to, tokenId);
458         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
459     }
460 
461     function _exists(uint256 tokenId) internal view virtual returns (bool) {
462         return _owners[tokenId] != address(0);
463     }
464 
465     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
466         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
467         address owner = ERC721.ownerOf(tokenId);
468         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
469     }
470 
471     function _safeMint(address to, uint256 tokenId) internal virtual {
472         _safeMint(to, tokenId, "");
473     }
474 
475     function _safeMint(
476         address to,
477         uint256 tokenId,
478         bytes memory _data
479     ) internal virtual {
480         _mint(to, tokenId);
481         require(
482             _checkOnERC721Received(address(0), to, tokenId, _data),
483             "ERC721: transfer to non ERC721Receiver implementer"
484         );
485     }
486 
487     function _mint(address to, uint256 tokenId) internal virtual {
488         require(to != address(0), "ERC721: mint to the zero address");
489         require(!_exists(tokenId), "ERC721: token already minted");
490 
491         _beforeTokenTransfer(address(0), to, tokenId);
492 
493         _balances[to] += 1;
494         _owners[tokenId] = to;
495 
496         emit Transfer(address(0), to, tokenId);
497 
498         _afterTokenTransfer(address(0), to, tokenId);
499     }
500 
501     function _burn(uint256 tokenId) internal virtual {
502         address owner = ERC721.ownerOf(tokenId);
503 
504         _beforeTokenTransfer(owner, address(0), tokenId);
505 
506         // Clear approvals
507         _approve(address(0), tokenId);
508 
509         _balances[owner] -= 1;
510         delete _owners[tokenId];
511 
512         emit Transfer(owner, address(0), tokenId);
513 
514         _afterTokenTransfer(owner, address(0), tokenId);
515     }
516 
517     function _transfer(
518         address from,
519         address to,
520         uint256 tokenId
521     ) internal virtual {
522         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
523         require(to != address(0), "ERC721: transfer to the zero address");
524 
525         _beforeTokenTransfer(from, to, tokenId);
526 
527         // Clear approvals from the previous owner
528         _approve(address(0), tokenId);
529 
530         _balances[from] -= 1;
531         _balances[to] += 1;
532         _owners[tokenId] = to;
533 
534         emit Transfer(from, to, tokenId);
535 
536         _afterTokenTransfer(from, to, tokenId);
537     }
538 
539     function _approve(address to, uint256 tokenId) internal virtual {
540         _tokenApprovals[tokenId] = to;
541         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
542     }
543 
544     function _setApprovalForAll(
545         address owner,
546         address operator,
547         bool approved
548     ) internal virtual {
549         require(owner != operator, "ERC721: approve to caller");
550         _operatorApprovals[owner][operator] = approved;
551         emit ApprovalForAll(owner, operator, approved);
552     }
553 
554     function _checkOnERC721Received(
555         address from,
556         address to,
557         uint256 tokenId,
558         bytes memory _data
559     ) private returns (bool) {
560         if (to.isContract()) {
561             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
562                 return retval == IERC721Receiver.onERC721Received.selector;
563             } catch (bytes memory reason) {
564                 if (reason.length == 0) {
565                     revert("ERC721: transfer to non ERC721Receiver implementer");
566                 } else {
567                     assembly {
568                         revert(add(32, reason), mload(reason))
569                     }
570                 }
571             }
572         } else {
573             return true;
574         }
575     }
576 
577     function _beforeTokenTransfer(
578         address from,
579         address to,
580         uint256 tokenId
581     ) internal virtual {}
582 
583     function _afterTokenTransfer(
584         address from,
585         address to,
586         uint256 tokenId
587     ) internal virtual {}
588 }
589 
590 
591 pragma solidity ^0.8.0;
592 
593 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
594     // Mapping from owner to list of owned token IDs
595     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
596 
597     // Mapping from token ID to index of the owner tokens list
598     mapping(uint256 => uint256) private _ownedTokensIndex;
599 
600     // Array with all token ids, used for enumeration
601     uint256[] private _allTokens;
602 
603     // Mapping from token id to position in the allTokens array
604     mapping(uint256 => uint256) private _allTokensIndex;
605 
606     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
607         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
608     }
609 
610     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
611         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
612         return _ownedTokens[owner][index];
613     }
614 
615     function totalSupply() public view virtual override returns (uint256) {
616         return _allTokens.length;
617     }
618 
619     /**
620      * @dev See {IERC721Enumerable-tokenByIndex}.
621      */
622     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
623         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
624         return _allTokens[index];
625     }
626 
627     function _beforeTokenTransfer(
628         address from,
629         address to,
630         uint256 tokenId
631     ) internal virtual override {
632         super._beforeTokenTransfer(from, to, tokenId);
633 
634         if (from == address(0)) {
635             _addTokenToAllTokensEnumeration(tokenId);
636         } else if (from != to) {
637             _removeTokenFromOwnerEnumeration(from, tokenId);
638         }
639         if (to == address(0)) {
640             _removeTokenFromAllTokensEnumeration(tokenId);
641         } else if (to != from) {
642             _addTokenToOwnerEnumeration(to, tokenId);
643         }
644     }
645 
646     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
647         uint256 length = ERC721.balanceOf(to);
648         _ownedTokens[to][length] = tokenId;
649         _ownedTokensIndex[tokenId] = length;
650     }
651 
652     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
653         _allTokensIndex[tokenId] = _allTokens.length;
654         _allTokens.push(tokenId);
655     }
656 
657     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
658         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
659         // then delete the last slot (swap and pop).
660 
661         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
662         uint256 tokenIndex = _ownedTokensIndex[tokenId];
663 
664         // When the token to delete is the last token, the swap operation is unnecessary
665         if (tokenIndex != lastTokenIndex) {
666             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
667 
668             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
669             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
670         }
671 
672         // This also deletes the contents at the last position of the array
673         delete _ownedTokensIndex[tokenId];
674         delete _ownedTokens[from][lastTokenIndex];
675     }
676 
677     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
678         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
679         // then delete the last slot (swap and pop).
680 
681         uint256 lastTokenIndex = _allTokens.length - 1;
682         uint256 tokenIndex = _allTokensIndex[tokenId];
683         uint256 lastTokenId = _allTokens[lastTokenIndex];
684 
685         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
686         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
687 
688         // This also deletes the contents at the last position of the array
689         delete _allTokensIndex[tokenId];
690         _allTokens.pop();
691     }
692 }
693 
694 
695 pragma solidity ^0.8.4;
696 
697 error ApprovalCallerNotOwnerNorApproved();
698 error ApprovalQueryForNonexistentToken();
699 error ApproveToCaller();
700 error ApprovalToCurrentOwner();
701 error BalanceQueryForZeroAddress();
702 error MintToZeroAddress();
703 error MintZeroQuantity();
704 error OwnerQueryForNonexistentToken();
705 error TransferCallerNotOwnerNorApproved();
706 error TransferFromIncorrectOwner();
707 error TransferToNonERC721ReceiverImplementer();
708 error TransferToZeroAddress();
709 error URIQueryForNonexistentToken();
710 
711 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
712     using Address for address;
713     using Strings for uint256;
714 
715     // Compiler will pack this into a single 256bit word.
716     struct TokenOwnership {
717         // The address of the owner.
718         address addr;
719         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
720         uint64 startTimestamp;
721         // Whether the token has been burned.
722         bool burned;
723     }
724 
725     struct AddressData {
726         uint64 balance;
727         uint64 numberMinted;
728         uint64 numberBurned;
729         uint64 aux;
730     }
731 
732     uint256 internal _currentIndex;
733 
734     uint256 internal _burnCounter;
735 
736     string private _name;
737 
738     string private _symbol;
739 
740     mapping(uint256 => TokenOwnership) internal _ownerships;
741 
742     mapping(address => AddressData) private _addressData;
743 
744     mapping(uint256 => address) private _tokenApprovals;
745 
746     mapping(address => mapping(address => bool)) private _operatorApprovals;
747 
748     constructor(string memory name_, string memory symbol_) {
749         _name = name_;
750         _symbol = symbol_;
751         _currentIndex = _startTokenId();
752     }
753 
754     function _startTokenId() internal view virtual returns (uint256) {
755         return 0;
756     }
757 
758     function totalSupply() public view returns (uint256) {
759 
760         unchecked {
761             return _currentIndex - _burnCounter - _startTokenId();
762         }
763     }
764 
765     function _totalMinted() internal view returns (uint256) {
766 
767         unchecked {
768             return _currentIndex - _startTokenId();
769         }
770     }
771 
772     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
773         return
774             interfaceId == type(IERC721).interfaceId ||
775             interfaceId == type(IERC721Metadata).interfaceId ||
776             super.supportsInterface(interfaceId);
777     }
778 
779     function balanceOf(address owner) public view override returns (uint256) {
780         if (owner == address(0)) revert BalanceQueryForZeroAddress();
781         return uint256(_addressData[owner].balance);
782     }
783 
784     function _numberMinted(address owner) internal view returns (uint256) {
785         return uint256(_addressData[owner].numberMinted);
786     }
787 
788     function _numberBurned(address owner) internal view returns (uint256) {
789         return uint256(_addressData[owner].numberBurned);
790     }
791 
792     function _getAux(address owner) internal view returns (uint64) {
793         return _addressData[owner].aux;
794     }
795 
796     function _setAux(address owner, uint64 aux) internal {
797         _addressData[owner].aux = aux;
798     }
799 
800     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
801         uint256 curr = tokenId;
802 
803         unchecked {
804             if (_startTokenId() <= curr && curr < _currentIndex) {
805                 TokenOwnership memory ownership = _ownerships[curr];
806                 if (!ownership.burned) {
807                     if (ownership.addr != address(0)) {
808                         return ownership;
809                     }
810 
811                     while (true) {
812                         curr--;
813                         ownership = _ownerships[curr];
814                         if (ownership.addr != address(0)) {
815                             return ownership;
816                         }
817                     }
818                 }
819             }
820         }
821         revert OwnerQueryForNonexistentToken();
822     }
823 
824     function ownerOf(uint256 tokenId) public view override returns (address) {
825         return _ownershipOf(tokenId).addr;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-name}.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-symbol}.
837      */
838     function symbol() public view virtual override returns (string memory) {
839         return _symbol;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-tokenURI}.
844      */
845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
846         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
847 
848         string memory baseURI = _baseURI();
849         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, can be overriden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return '';
859     }
860 
861     /**
862      * @dev See {IERC721-approve}.
863      */
864     function approve(address to, uint256 tokenId) public override {
865         address owner = ERC721A.ownerOf(tokenId);
866         if (to == owner) revert ApprovalToCurrentOwner();
867 
868         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
869             revert ApprovalCallerNotOwnerNorApproved();
870         }
871 
872         _approve(to, tokenId, owner);
873     }
874 
875     /**
876      * @dev See {IERC721-getApproved}.
877      */
878     function getApproved(uint256 tokenId) public view override returns (address) {
879         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
880 
881         return _tokenApprovals[tokenId];
882     }
883 
884     /**
885      * @dev See {IERC721-setApprovalForAll}.
886      */
887     function setApprovalForAll(address operator, bool approved) public virtual override {
888         if (operator == _msgSender()) revert ApproveToCaller();
889 
890         _operatorApprovals[_msgSender()][operator] = approved;
891         emit ApprovalForAll(_msgSender(), operator, approved);
892     }
893 
894     /**
895      * @dev See {IERC721-isApprovedForAll}.
896      */
897     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
898         return _operatorApprovals[owner][operator];
899     }
900 
901     /**
902      * @dev See {IERC721-transferFrom}.
903      */
904     function transferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) public virtual override {
909         _transfer(from, to, tokenId);
910     }
911 
912     /**
913      * @dev See {IERC721-safeTransferFrom}.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         safeTransferFrom(from, to, tokenId, '');
921     }
922 
923     /**
924      * @dev See {IERC721-safeTransferFrom}.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId,
930         bytes memory _data
931     ) public virtual override {
932         _transfer(from, to, tokenId);
933         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
934             revert TransferToNonERC721ReceiverImplementer();
935         }
936     }
937 
938     function _exists(uint256 tokenId) internal view returns (bool) {
939         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
940     }
941 
942     function _safeMint(address to, uint256 quantity) internal {
943         _safeMint(to, quantity, '');
944     }
945 
946     function _safeMint(
947         address to,
948         uint256 quantity,
949         bytes memory _data
950     ) internal {
951         _mint(to, quantity, _data, true);
952     }
953 
954     function _mint(
955         address to,
956         uint256 quantity,
957         bytes memory _data,
958         bool safe
959     ) internal {
960         uint256 startTokenId = _currentIndex;
961         if (to == address(0)) revert MintToZeroAddress();
962         if (quantity == 0) revert MintZeroQuantity();
963 
964         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
965 
966         // Overflows are incredibly unrealistic.
967         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
968         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
969         unchecked {
970             _addressData[to].balance += uint64(quantity);
971             _addressData[to].numberMinted += uint64(quantity);
972 
973             _ownerships[startTokenId].addr = to;
974             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
975 
976             uint256 updatedIndex = startTokenId;
977             uint256 end = updatedIndex + quantity;
978 
979             if (safe && to.isContract()) {
980                 do {
981                     emit Transfer(address(0), to, updatedIndex);
982                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
983                         revert TransferToNonERC721ReceiverImplementer();
984                     }
985                 } while (updatedIndex != end);
986                 // Reentrancy protection
987                 if (_currentIndex != startTokenId) revert();
988             } else {
989                 do {
990                     emit Transfer(address(0), to, updatedIndex++);
991                 } while (updatedIndex != end);
992             }
993             _currentIndex = updatedIndex;
994         }
995         _afterTokenTransfers(address(0), to, startTokenId, quantity);
996     }
997 
998     function _transfer(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) private {
1003         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1004 
1005         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1006 
1007         bool isApprovedOrOwner = (_msgSender() == from ||
1008             isApprovedForAll(from, _msgSender()) ||
1009             getApproved(tokenId) == _msgSender());
1010 
1011         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1012         if (to == address(0)) revert TransferToZeroAddress();
1013 
1014         _beforeTokenTransfers(from, to, tokenId, 1);
1015 
1016         // Clear approvals from the previous owner
1017         _approve(address(0), tokenId, from);
1018 
1019         // Underflow of the sender's balance is impossible because we check for
1020         // ownership above and the recipient's balance can't realistically overflow.
1021         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1022         unchecked {
1023             _addressData[from].balance -= 1;
1024             _addressData[to].balance += 1;
1025 
1026             TokenOwnership storage currSlot = _ownerships[tokenId];
1027             currSlot.addr = to;
1028             currSlot.startTimestamp = uint64(block.timestamp);
1029 
1030             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1031             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1032             uint256 nextTokenId = tokenId + 1;
1033             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1034             if (nextSlot.addr == address(0)) {
1035                 // This will suffice for checking _exists(nextTokenId),
1036                 // as a burned slot cannot contain the zero address.
1037                 if (nextTokenId != _currentIndex) {
1038                     nextSlot.addr = from;
1039                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1040                 }
1041             }
1042         }
1043 
1044         emit Transfer(from, to, tokenId);
1045         _afterTokenTransfers(from, to, tokenId, 1);
1046     }
1047 
1048     /**
1049      * @dev This is equivalent to _burn(tokenId, false)
1050      */
1051     function _burn(uint256 tokenId) internal virtual {
1052         _burn(tokenId, false);
1053     }
1054 
1055     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1056         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1057 
1058         address from = prevOwnership.addr;
1059 
1060         if (approvalCheck) {
1061             bool isApprovedOrOwner = (_msgSender() == from ||
1062                 isApprovedForAll(from, _msgSender()) ||
1063                 getApproved(tokenId) == _msgSender());
1064 
1065             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1066         }
1067 
1068         _beforeTokenTransfers(from, address(0), tokenId, 1);
1069 
1070         // Clear approvals from the previous owner
1071         _approve(address(0), tokenId, from);
1072 
1073         // Underflow of the sender's balance is impossible because we check for
1074         // ownership above and the recipient's balance can't realistically overflow.
1075         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1076         unchecked {
1077             AddressData storage addressData = _addressData[from];
1078             addressData.balance -= 1;
1079             addressData.numberBurned += 1;
1080 
1081             // Keep track of who burned the token, and the timestamp of burning.
1082             TokenOwnership storage currSlot = _ownerships[tokenId];
1083             currSlot.addr = from;
1084             currSlot.startTimestamp = uint64(block.timestamp);
1085             currSlot.burned = true;
1086 
1087             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1088             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1089             uint256 nextTokenId = tokenId + 1;
1090             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1091             if (nextSlot.addr == address(0)) {
1092                 // This will suffice for checking _exists(nextTokenId),
1093                 // as a burned slot cannot contain the zero address.
1094                 if (nextTokenId != _currentIndex) {
1095                     nextSlot.addr = from;
1096                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1097                 }
1098             }
1099         }
1100 
1101         emit Transfer(from, address(0), tokenId);
1102         _afterTokenTransfers(from, address(0), tokenId, 1);
1103 
1104         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1105         unchecked {
1106             _burnCounter++;
1107         }
1108     }
1109 
1110     /**
1111      * @dev Approve `to` to operate on `tokenId`
1112      *
1113      * Emits a {Approval} event.
1114      */
1115     function _approve(
1116         address to,
1117         uint256 tokenId,
1118         address owner
1119     ) private {
1120         _tokenApprovals[tokenId] = to;
1121         emit Approval(owner, to, tokenId);
1122     }
1123 
1124     function _checkContractOnERC721Received(
1125         address from,
1126         address to,
1127         uint256 tokenId,
1128         bytes memory _data
1129     ) private returns (bool) {
1130         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1131             return retval == IERC721Receiver(to).onERC721Received.selector;
1132         } catch (bytes memory reason) {
1133             if (reason.length == 0) {
1134                 revert TransferToNonERC721ReceiverImplementer();
1135             } else {
1136                 assembly {
1137                     revert(add(32, reason), mload(reason))
1138                 }
1139             }
1140         }
1141     }
1142 
1143     function _beforeTokenTransfers(
1144         address from,
1145         address to,
1146         uint256 startTokenId,
1147         uint256 quantity
1148     ) internal virtual {}
1149 
1150     function _afterTokenTransfers(
1151         address from,
1152         address to,
1153         uint256 startTokenId,
1154         uint256 quantity
1155     ) internal virtual {}
1156 }
1157 
1158 
1159 pragma solidity ^0.8.4;
1160 
1161 
1162 contract MoonDevils is ERC721A, Ownable {
1163     using Strings for uint256;
1164     string private baseURI;
1165     string public hiddenMetadataUri;
1166     uint256 public price = 0.00366 ether;
1167     uint256 public maxPerTx = 10;
1168     uint256 public maxFreePerWallet = 2;
1169     uint256 public totalFree = 4444;
1170     uint256 public maxSupply = 4444;
1171     uint public nextId = 0;
1172     bool public mintEnabled = false;
1173     bool public revealed = true;
1174     mapping(address => uint256) private _mintedFreeAmount;
1175     constructor() ERC721A("Moon Devils", "Devils") {
1176     setHiddenMetadataUri("https://api.moondevils.wtf/");
1177     setBaseURI("https://api.moondevils.wtf/");
1178     }
1179     function mint(uint256 count) external payable {
1180       uint256 cost = price;
1181       bool isFree =
1182       ((totalSupply() + count < totalFree + 1) &&
1183       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1184 
1185       if (isFree) {
1186       cost = 0;
1187      }
1188      else {
1189       require(msg.value >= count * price, "Please send the exact amount.");
1190       require(totalSupply() + count <= maxSupply, "No more Devils");
1191       require(mintEnabled, "Minting is not live yet");
1192       require(count <= maxPerTx, "Max per TX reached.");
1193      }
1194       if (isFree) {
1195          _mintedFreeAmount[msg.sender] += count;
1196       }
1197      _safeMint(msg.sender, count);
1198      nextId += count;
1199     }
1200     function _baseURI() internal view virtual override returns (string memory) {
1201         return baseURI;
1202     }
1203     function tokenURI(uint256 tokenId)
1204         public
1205         view
1206         virtual
1207         override
1208         returns (string memory)
1209     {
1210         require(
1211             _exists(tokenId),
1212             "ERC721Metadata: URI query for nonexistent token"
1213         );
1214 
1215         if (revealed == false) {
1216          return string(abi.encodePacked(hiddenMetadataUri));
1217         }
1218     
1219         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1220     }
1221 
1222     function setBaseURI(string memory uri) public onlyOwner {
1223         baseURI = uri;
1224     }
1225 
1226     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1227      hiddenMetadataUri = _hiddenMetadataUri;
1228     }
1229 
1230     function setFreeAmount(uint256 amount) external onlyOwner {
1231         totalFree = amount;
1232     }
1233 
1234     function setPrice(uint256 _newPrice) external onlyOwner {
1235         price = _newPrice;
1236     }
1237     function setRevealed() external onlyOwner {
1238      revealed = !revealed;
1239     }
1240     function flipSale() external onlyOwner {
1241         mintEnabled = !mintEnabled;
1242     }
1243     function getNextId() public view returns(uint){
1244      return nextId;
1245     }
1246     function _startTokenId() internal pure override returns (uint256) {
1247         return 1;
1248     }
1249     function withdraw() external onlyOwner {
1250         (bool success, ) = payable(msg.sender).call{
1251             value: address(this).balance
1252         }("");
1253         require(success, "Transfer failed.");
1254     }
1255     function FreeOwnerMint(address to, uint256 quantity)public onlyOwner{
1256     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1257     _safeMint(to, quantity);
1258   }
1259 }