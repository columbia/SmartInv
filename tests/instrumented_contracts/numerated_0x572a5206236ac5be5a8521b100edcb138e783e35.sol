1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 library Counters {
6     struct Counter {
7 
8         uint256 _value; // default: 0
9     }
10 
11     function current(Counter storage counter) internal view returns (uint256) {
12         return counter._value;
13     }
14 
15     function increment(Counter storage counter) internal {
16         unchecked {
17             counter._value += 1;
18         }
19     }
20 
21     function decrement(Counter storage counter) internal {
22         uint256 value = counter._value;
23         require(value > 0, "Counter:decrement overflow");
24         unchecked {
25             counter._value = value - 1;
26         }
27     }
28 
29     function reset(Counter storage counter) internal {
30         counter._value = 0;
31     }
32 }
33 
34 pragma solidity ^0.8.0;
35 
36 library Strings {
37     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
41      */
42     function toString(uint256 value) internal pure returns (string memory) {
43         // Inspired by OraclizeAPI's implementation - MIT licence
44         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
45 
46         if (value == 0) {
47             return "0";
48         }
49         uint256 temp = value;
50         uint256 digits;
51         while (temp != 0) {
52             digits++;
53             temp /= 10;
54         }
55         bytes memory buffer = new bytes(digits);
56         while (value != 0) {
57             digits -= 1;
58             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
59             value /= 10;
60         }
61         return string(buffer);
62     }
63 
64     function toHexString(uint256 value) internal pure returns (string memory) {
65         if (value == 0) {
66             return "0x00";
67         }
68         uint256 temp = value;
69         uint256 length = 0;
70         while (temp != 0) {
71             length++;
72             temp >>= 8;
73         }
74         return toHexString(value, length);
75     }
76 
77     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
78         bytes memory buffer = new bytes(2 * length + 2);
79         buffer[0] = "0";
80         buffer[1] = "x";
81         for (uint256 i = 2 * length + 1; i > 1; --i) {
82             buffer[i] = _HEX_SYMBOLS[value & 0xf];
83             value >>= 4;
84         }
85         require(value == 0, "Strings: hex length insufficient");
86         return string(buffer);
87     }
88 }
89 
90 pragma solidity ^0.8.0;
91 
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 pragma solidity ^0.8.0;
103 
104 abstract contract Ownable is Context {
105     address private _owner;
106 
107     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109     constructor() {
110         _transferOwnership(_msgSender());
111     }
112 
113     function owner() public view virtual returns (address) {
114         return _owner;
115     }
116 
117     modifier onlyOwner() {
118         require(owner() == _msgSender(), "Ownable: caller is not the owner");
119         _;
120     }
121 
122     function renounceOwnership() public virtual onlyOwner {
123         _transferOwnership(address(0));
124     }
125 
126     function transferOwnership(address newOwner) public virtual onlyOwner {
127         require(newOwner != address(0), "Ownable: new owner is the zero address");
128         _transferOwnership(newOwner);
129     }
130 
131     function _transferOwnership(address newOwner) internal virtual {
132         address oldOwner = _owner;
133         _owner = newOwner;
134         emit OwnershipTransferred(oldOwner, newOwner);
135     }
136 }
137 
138 pragma solidity ^0.8.1;
139 
140 library Address {
141 
142     function isContract(address account) internal view returns (bool) {
143 
144         return account.code.length > 0;
145     }
146 
147     function sendValue(address payable recipient, uint256 amount) internal {
148         require(address(this).balance >= amount, "Address: insufficient balance");
149 
150         (bool success, ) = recipient.call{value: amount}("");
151         require(success, "Address: unable to send value, recipient may have reverted");
152     }
153 
154     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
155         return functionCall(target, data, "Address: low-level call failed");
156     }
157 
158     function functionCall(
159         address target,
160         bytes memory data,
161         string memory errorMessage
162     ) internal returns (bytes memory) {
163         return functionCallWithValue(target, data, 0, errorMessage);
164     }
165 
166     function functionCallWithValue(
167         address target,
168         bytes memory data,
169         uint256 value
170     ) internal returns (bytes memory) {
171         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
172     }
173 
174     function functionCallWithValue(
175         address target,
176         bytes memory data,
177         uint256 value,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         require(address(this).balance >= value, "Address: insufficient balance for call");
181         require(isContract(target), "Address: call to non-contract");
182 
183         (bool success, bytes memory returndata) = target.call{value: value}(data);
184         return verifyCallResult(success, returndata, errorMessage);
185     }
186 
187     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
188         return functionStaticCall(target, data, "Address: low-level static call failed");
189     }
190 
191     function functionStaticCall(
192         address target,
193         bytes memory data,
194         string memory errorMessage
195     ) internal view returns (bytes memory) {
196         require(isContract(target), "Address: static call to non-contract");
197 
198         (bool success, bytes memory returndata) = target.staticcall(data);
199         return verifyCallResult(success, returndata, errorMessage);
200     }
201 
202     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
203         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
204     }
205 
206     function functionDelegateCall(
207         address target,
208         bytes memory data,
209         string memory errorMessage
210     ) internal returns (bytes memory) {
211         require(isContract(target), "Address: delegate call to non-contract");
212 
213         (bool success, bytes memory returndata) = target.delegatecall(data);
214         return verifyCallResult(success, returndata, errorMessage);
215     }
216 
217     function verifyCallResult(
218         bool success,
219         bytes memory returndata,
220         string memory errorMessage
221     ) internal pure returns (bytes memory) {
222         if (success) {
223             return returndata;
224         } else {
225             // Look for revert reason and bubble it up if present
226             if (returndata.length > 0) {
227                 // The easiest way to bubble the revert reason is using memory via assembly
228 
229                 assembly {
230                     let returndata_size := mload(returndata)
231                     revert(add(32, returndata), returndata_size)
232                 }
233             } else {
234                 revert(errorMessage);
235             }
236         }
237     }
238 }
239 
240 pragma solidity ^0.8.0;
241 
242 interface IERC721Receiver {
243 
244     function onERC721Received(
245         address operator,
246         address from,
247         uint256 tokenId,
248         bytes calldata data
249     ) external returns (bytes4);
250 }
251 
252 pragma solidity ^0.8.0;
253 
254 interface IERC165 {
255 
256     function supportsInterface(bytes4 interfaceId) external view returns (bool);
257 }
258 
259 pragma solidity ^0.8.0;
260 
261 abstract contract ERC165 is IERC165 {
262 
263     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
264         return interfaceId == type(IERC165).interfaceId;
265     }
266 }
267 
268 pragma solidity ^0.8.0;
269 
270 interface IERC721 is IERC165 {
271 
272     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
273 
274     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
275 
276     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
277 
278     function balanceOf(address owner) external view returns (uint256 balance);
279 
280     function ownerOf(uint256 tokenId) external view returns (address owner);
281 
282     function safeTransferFrom(
283         address from,
284         address to,
285         uint256 tokenId
286     ) external;
287 
288     function transferFrom(
289         address from,
290         address to,
291         uint256 tokenId
292     ) external;
293 
294     function approve(address to, uint256 tokenId) external;
295 
296     function getApproved(uint256 tokenId) external view returns (address operator);
297 
298     function setApprovalForAll(address operator, bool _approved) external;
299 
300     function isApprovedForAll(address owner, address operator) external view returns (bool);
301 
302     function safeTransferFrom(
303         address from,
304         address to,
305         uint256 tokenId,
306         bytes calldata data
307     ) external;
308 }
309 
310 pragma solidity ^0.8.0;
311 
312 interface IERC721Enumerable is IERC721 {
313 
314     function totalSupply() external view returns (uint256);
315 
316     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
317 
318     function tokenByIndex(uint256 index) external view returns (uint256);
319 }
320 
321 pragma solidity ^0.8.0;
322 
323 interface IERC721Metadata is IERC721 {
324 
325     function name() external view returns (string memory);
326 
327     function symbol() external view returns (string memory);
328 
329     function tokenURI(uint256 tokenId) external view returns (string memory);
330 }
331 
332 pragma solidity ^0.8.0;
333 
334 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
335     using Address for address;
336     using Strings for uint256;
337 
338     // Token name
339     string private _name;
340 
341     // Token symbol
342     string private _symbol;
343 
344     // Mapping from token ID to owner address
345     mapping(uint256 => address) private _owners;
346 
347     // Mapping owner address to token count
348     mapping(address => uint256) private _balances;
349 
350     // Mapping from token ID to approved address
351     mapping(uint256 => address) private _tokenApprovals;
352 
353     // Mapping from owner to operator approvals
354     mapping(address => mapping(address => bool)) private _operatorApprovals;
355 
356     constructor(string memory name_, string memory symbol_) {
357         _name = name_;
358         _symbol = symbol_;
359     }
360 
361     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
362         return
363             interfaceId == type(IERC721).interfaceId ||
364             interfaceId == type(IERC721Metadata).interfaceId ||
365             super.supportsInterface(interfaceId);
366     }
367 
368     function balanceOf(address owner) public view virtual override returns (uint256) {
369         require(owner != address(0), "ERC721: balance query for the zero address");
370         return _balances[owner];
371     }
372 
373     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
374         address owner = _owners[tokenId];
375         require(owner != address(0), "ERC721: owner query for nonexistent token");
376         return owner;
377     }
378 
379     function name() public view virtual override returns (string memory) {
380         return _name;
381     }
382 
383     function symbol() public view virtual override returns (string memory) {
384         return _symbol;
385     }
386 
387     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
388         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
389 
390         string memory baseURI = _baseURI();
391         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
392     }
393 
394     function _baseURI() internal view virtual returns (string memory) {
395         return "";
396     }
397 
398     function approve(address to, uint256 tokenId) public virtual override {
399         address owner = ERC721.ownerOf(tokenId);
400         require(to != owner, "ERC721: approval to current owner");
401 
402         require(
403             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
404             "ERC721: approve caller is not owner nor approved for all"
405         );
406 
407         _approve(to, tokenId);
408     }
409 
410     function getApproved(uint256 tokenId) public view virtual override returns (address) {
411         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
412 
413         return _tokenApprovals[tokenId];
414     }
415 
416     function setApprovalForAll(address operator, bool approved) public virtual override {
417         _setApprovalForAll(_msgSender(), operator, approved);
418     }
419 
420     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
421         return _operatorApprovals[owner][operator];
422     }
423 
424     function transferFrom(
425         address from,
426         address to,
427         uint256 tokenId
428     ) public virtual override {
429         //solhint-disable-next-line max-line-length
430         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
431 
432         _transfer(from, to, tokenId);
433     }
434 
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) public virtual override {
440         safeTransferFrom(from, to, tokenId, "");
441     }
442 
443     function safeTransferFrom(
444         address from,
445         address to,
446         uint256 tokenId,
447         bytes memory _data
448     ) public virtual override {
449         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
450         _safeTransfer(from, to, tokenId, _data);
451     }
452 
453     function _safeTransfer(
454         address from,
455         address to,
456         uint256 tokenId,
457         bytes memory _data
458     ) internal virtual {
459         _transfer(from, to, tokenId);
460         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
461     }
462 
463     function _exists(uint256 tokenId) internal view virtual returns (bool) {
464         return _owners[tokenId] != address(0);
465     }
466 
467     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
468         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
469         address owner = ERC721.ownerOf(tokenId);
470         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
471     }
472 
473     function _safeMint(address to, uint256 tokenId) internal virtual {
474         _safeMint(to, tokenId, "");
475     }
476 
477     function _safeMint(
478         address to,
479         uint256 tokenId,
480         bytes memory _data
481     ) internal virtual {
482         _mint(to, tokenId);
483         require(
484             _checkOnERC721Received(address(0), to, tokenId, _data),
485             "ERC721: transfer to non ERC721Receiver implementer"
486         );
487     }
488 
489     function _mint(address to, uint256 tokenId) internal virtual {
490         require(to != address(0), "ERC721: mint to the zero address");
491         require(!_exists(tokenId), "ERC721: token already minted");
492 
493         _beforeTokenTransfer(address(0), to, tokenId);
494 
495         _balances[to] += 1;
496         _owners[tokenId] = to;
497 
498         emit Transfer(address(0), to, tokenId);
499 
500         _afterTokenTransfer(address(0), to, tokenId);
501     }
502 
503     function _burn(uint256 tokenId) internal virtual {
504         address owner = ERC721.ownerOf(tokenId);
505 
506         _beforeTokenTransfer(owner, address(0), tokenId);
507 
508         // Clear approvals
509         _approve(address(0), tokenId);
510 
511         _balances[owner] -= 1;
512         delete _owners[tokenId];
513 
514         emit Transfer(owner, address(0), tokenId);
515 
516         _afterTokenTransfer(owner, address(0), tokenId);
517     }
518 
519     function _transfer(
520         address from,
521         address to,
522         uint256 tokenId
523     ) internal virtual {
524         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
525         require(to != address(0), "ERC721: transfer to the zero address");
526 
527         _beforeTokenTransfer(from, to, tokenId);
528 
529         _approve(address(0), tokenId);
530 
531         _balances[from] -= 1;
532         _balances[to] += 1;
533         _owners[tokenId] = to;
534 
535         emit Transfer(from, to, tokenId);
536 
537         _afterTokenTransfer(from, to, tokenId);
538     }
539 
540     function _approve(address to, uint256 tokenId) internal virtual {
541         _tokenApprovals[tokenId] = to;
542         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
543     }
544 
545     function _setApprovalForAll(
546         address owner,
547         address operator,
548         bool approved
549     ) internal virtual {
550         require(owner != operator, "ERC721: approve to caller");
551         _operatorApprovals[owner][operator] = approved;
552         emit ApprovalForAll(owner, operator, approved);
553     }
554 
555     function _checkOnERC721Received(
556         address from,
557         address to,
558         uint256 tokenId,
559         bytes memory _data
560     ) private returns (bool) {
561         if (to.isContract()) {
562             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
563                 return retval == IERC721Receiver.onERC721Received.selector;
564             } catch (bytes memory reason) {
565                 if (reason.length == 0) {
566                     revert("ERC721: transfer to non ERC721Receiver implementer");
567                 } else {
568                     assembly {
569                         revert(add(32, reason), mload(reason))
570                     }
571                 }
572             }
573         } else {
574             return true;
575         }
576     }
577 
578     function _beforeTokenTransfer(
579         address from,
580         address to,
581         uint256 tokenId
582     ) internal virtual {}
583 
584     function _afterTokenTransfer(
585         address from,
586         address to,
587         uint256 tokenId
588     ) internal virtual {}
589 }
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
619     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
620         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
621         return _allTokens[index];
622     }
623 
624     function _beforeTokenTransfer(
625         address from,
626         address to,
627         uint256 tokenId
628     ) internal virtual override {
629         super._beforeTokenTransfer(from, to, tokenId);
630 
631         if (from == address(0)) {
632             _addTokenToAllTokensEnumeration(tokenId);
633         } else if (from != to) {
634             _removeTokenFromOwnerEnumeration(from, tokenId);
635         }
636         if (to == address(0)) {
637             _removeTokenFromAllTokensEnumeration(tokenId);
638         } else if (to != from) {
639             _addTokenToOwnerEnumeration(to, tokenId);
640         }
641     }
642 
643     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
644         uint256 length = ERC721.balanceOf(to);
645         _ownedTokens[to][length] = tokenId;
646         _ownedTokensIndex[tokenId] = length;
647     }
648 
649     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
650         _allTokensIndex[tokenId] = _allTokens.length;
651         _allTokens.push(tokenId);
652     }
653 
654     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
655         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
656         // then delete the last slot (swap and pop).
657 
658         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
659         uint256 tokenIndex = _ownedTokensIndex[tokenId];
660 
661         // When the token to delete is the last token, the swap operation is unnecessary
662         if (tokenIndex != lastTokenIndex) {
663             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
664 
665             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
666             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
667         }
668 
669         // This also deletes the contents at the last position of the array
670         delete _ownedTokensIndex[tokenId];
671         delete _ownedTokens[from][lastTokenIndex];
672     }
673 
674     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
675         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
676         // then delete the last slot (swap and pop).
677 
678         uint256 lastTokenIndex = _allTokens.length - 1;
679         uint256 tokenIndex = _allTokensIndex[tokenId];
680 
681         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
682         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
683         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
684         uint256 lastTokenId = _allTokens[lastTokenIndex];
685 
686         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
687         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
688 
689         // This also deletes the contents at the last position of the array
690         delete _allTokensIndex[tokenId];
691         _allTokens.pop();
692     }
693 }
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
725     // Compiler will pack this into a single 256bit word.
726     struct AddressData {
727         // Realistically, 2**64-1 is more than enough.
728         uint64 balance;
729         // Keeps track of mint count with minimal overhead for tokenomics.
730         uint64 numberMinted;
731         // Keeps track of burn count with minimal overhead for tokenomics.
732         uint64 numberBurned;
733         // For miscellaneous variable(s) pertaining to the address
734         // (e.g. number of whitelist mint slots used).
735         // If there are multiple variables, please pack them into a uint64.
736         uint64 aux;
737     }
738 
739     // The tokenId of the next token to be minted.
740     uint256 internal _currentIndex;
741 
742     // The number of tokens burned.
743     uint256 internal _burnCounter;
744 
745     // Token name
746     string private _name;
747 
748     // Token symbol
749     string private _symbol;
750 
751     // Mapping from token ID to ownership details
752     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
753     mapping(uint256 => TokenOwnership) internal _ownerships;
754 
755     // Mapping owner address to address data
756     mapping(address => AddressData) private _addressData;
757 
758     // Mapping from token ID to approved address
759     mapping(uint256 => address) private _tokenApprovals;
760 
761     // Mapping from owner to operator approvals
762     mapping(address => mapping(address => bool)) private _operatorApprovals;
763 
764     constructor(string memory name_, string memory symbol_) {
765         _name = name_;
766         _symbol = symbol_;
767         _currentIndex = _startTokenId();
768     }
769 
770     function _startTokenId() internal view virtual returns (uint256) {
771         return 0;
772     }
773 
774     function totalSupply() public view returns (uint256) {
775         // Counter underflow is impossible as _burnCounter cannot be incremented
776         // more than _currentIndex - _startTokenId() times
777         unchecked {
778             return _currentIndex - _burnCounter - _startTokenId();
779         }
780     }
781 
782     function _totalMinted() internal view returns (uint256) {
783         // Counter underflow is impossible as _currentIndex does not decrement,
784         // and it is initialized to _startTokenId()
785         unchecked {
786             return _currentIndex - _startTokenId();
787         }
788     }
789 
790     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
791         return
792             interfaceId == type(IERC721).interfaceId ||
793             interfaceId == type(IERC721Metadata).interfaceId ||
794             super.supportsInterface(interfaceId);
795     }
796 
797     function balanceOf(address owner) public view override returns (uint256) {
798         if (owner == address(0)) revert BalanceQueryForZeroAddress();
799         return uint256(_addressData[owner].balance);
800     }
801 
802     function _numberMinted(address owner) internal view returns (uint256) {
803         return uint256(_addressData[owner].numberMinted);
804     }
805 
806     function _numberBurned(address owner) internal view returns (uint256) {
807         return uint256(_addressData[owner].numberBurned);
808     }
809 
810     function _getAux(address owner) internal view returns (uint64) {
811         return _addressData[owner].aux;
812     }
813 
814     function _setAux(address owner, uint64 aux) internal {
815         _addressData[owner].aux = aux;
816     }
817 
818     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
819         uint256 curr = tokenId;
820 
821         unchecked {
822             if (_startTokenId() <= curr && curr < _currentIndex) {
823                 TokenOwnership memory ownership = _ownerships[curr];
824                 if (!ownership.burned) {
825                     if (ownership.addr != address(0)) {
826                         return ownership;
827                     }
828 
829                     while (true) {
830                         curr--;
831                         ownership = _ownerships[curr];
832                         if (ownership.addr != address(0)) {
833                             return ownership;
834                         }
835                     }
836                 }
837             }
838         }
839         revert OwnerQueryForNonexistentToken();
840     }
841 
842     function ownerOf(uint256 tokenId) public view override returns (address) {
843         return _ownershipOf(tokenId).addr;
844     }
845 
846     function name() public view virtual override returns (string memory) {
847         return _name;
848     }
849 
850     function symbol() public view virtual override returns (string memory) {
851         return _symbol;
852     }
853 
854     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
855         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
856 
857         string memory baseURI = _baseURI();
858         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
859     }
860 
861     function _baseURI() internal view virtual returns (string memory) {
862         return '';
863     }
864 
865     function approve(address to, uint256 tokenId) public override {
866         address owner = ERC721A.ownerOf(tokenId);
867         if (to == owner) revert ApprovalToCurrentOwner();
868 
869         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
870             revert ApprovalCallerNotOwnerNorApproved();
871         }
872 
873         _approve(to, tokenId, owner);
874     }
875 
876     function getApproved(uint256 tokenId) public view override returns (address) {
877         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
878 
879         return _tokenApprovals[tokenId];
880     }
881 
882     function setApprovalForAll(address operator, bool approved) public virtual override {
883         if (operator == _msgSender()) revert ApproveToCaller();
884 
885         _operatorApprovals[_msgSender()][operator] = approved;
886         emit ApprovalForAll(_msgSender(), operator, approved);
887     }
888 
889     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
890         return _operatorApprovals[owner][operator];
891     }
892 
893     function transferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public virtual override {
898         _transfer(from, to, tokenId);
899     }
900 
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public virtual override {
906         safeTransferFrom(from, to, tokenId, '');
907     }
908 
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 tokenId,
913         bytes memory _data
914     ) public virtual override {
915         _transfer(from, to, tokenId);
916         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
917             revert TransferToNonERC721ReceiverImplementer();
918         }
919     }
920 
921     function _exists(uint256 tokenId) internal view returns (bool) {
922         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
923     }
924 
925     function _safeMint(address to, uint256 quantity) internal {
926         _safeMint(to, quantity, '');
927     }
928 
929     function _safeMint(
930         address to,
931         uint256 quantity,
932         bytes memory _data
933     ) internal {
934         _mint(to, quantity, _data, true);
935     }
936 
937     function _mint(
938         address to,
939         uint256 quantity,
940         bytes memory _data,
941         bool safe
942     ) internal {
943         uint256 startTokenId = _currentIndex;
944         if (to == address(0)) revert MintToZeroAddress();
945         if (quantity == 0) revert MintZeroQuantity();
946 
947         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
948 
949         unchecked {
950             _addressData[to].balance += uint64(quantity);
951             _addressData[to].numberMinted += uint64(quantity);
952 
953             _ownerships[startTokenId].addr = to;
954             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
955 
956             uint256 updatedIndex = startTokenId;
957             uint256 end = updatedIndex + quantity;
958 
959             if (safe && to.isContract()) {
960                 do {
961                     emit Transfer(address(0), to, updatedIndex);
962                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
963                         revert TransferToNonERC721ReceiverImplementer();
964                     }
965                 } while (updatedIndex != end);
966                 // Reentrancy protection
967                 if (_currentIndex != startTokenId) revert();
968             } else {
969                 do {
970                     emit Transfer(address(0), to, updatedIndex++);
971                 } while (updatedIndex != end);
972             }
973             _currentIndex = updatedIndex;
974         }
975         _afterTokenTransfers(address(0), to, startTokenId, quantity);
976     }
977 
978     function _transfer(
979         address from,
980         address to,
981         uint256 tokenId
982     ) private {
983         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
984 
985         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
986 
987         bool isApprovedOrOwner = (_msgSender() == from ||
988             isApprovedForAll(from, _msgSender()) ||
989             getApproved(tokenId) == _msgSender());
990 
991         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
992         if (to == address(0)) revert TransferToZeroAddress();
993 
994         _beforeTokenTransfers(from, to, tokenId, 1);
995 
996         // Clear approvals from the previous owner
997         _approve(address(0), tokenId, from);
998 
999         unchecked {
1000             _addressData[from].balance -= 1;
1001             _addressData[to].balance += 1;
1002 
1003             TokenOwnership storage currSlot = _ownerships[tokenId];
1004             currSlot.addr = to;
1005             currSlot.startTimestamp = uint64(block.timestamp);
1006 
1007             uint256 nextTokenId = tokenId + 1;
1008             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1009             if (nextSlot.addr == address(0)) {
1010 
1011                 if (nextTokenId != _currentIndex) {
1012                     nextSlot.addr = from;
1013                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1014                 }
1015             }
1016         }
1017 
1018         emit Transfer(from, to, tokenId);
1019         _afterTokenTransfers(from, to, tokenId, 1);
1020     }
1021 
1022     function _burn(uint256 tokenId) internal virtual {
1023         _burn(tokenId, false);
1024     }
1025 
1026     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1027         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1028 
1029         address from = prevOwnership.addr;
1030 
1031         if (approvalCheck) {
1032             bool isApprovedOrOwner = (_msgSender() == from ||
1033                 isApprovedForAll(from, _msgSender()) ||
1034                 getApproved(tokenId) == _msgSender());
1035 
1036             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1037         }
1038 
1039         _beforeTokenTransfers(from, address(0), tokenId, 1);
1040 
1041         _approve(address(0), tokenId, from);
1042 
1043         unchecked {
1044             AddressData storage addressData = _addressData[from];
1045             addressData.balance -= 1;
1046             addressData.numberBurned += 1;
1047 
1048             TokenOwnership storage currSlot = _ownerships[tokenId];
1049             currSlot.addr = from;
1050             currSlot.startTimestamp = uint64(block.timestamp);
1051             currSlot.burned = true;
1052 
1053             uint256 nextTokenId = tokenId + 1;
1054             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1055             if (nextSlot.addr == address(0)) {
1056 
1057                 if (nextTokenId != _currentIndex) {
1058                     nextSlot.addr = from;
1059                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1060                 }
1061             }
1062         }
1063 
1064         emit Transfer(from, address(0), tokenId);
1065         _afterTokenTransfers(from, address(0), tokenId, 1);
1066 
1067         unchecked {
1068             _burnCounter++;
1069         }
1070     }
1071 
1072     function _approve(
1073         address to,
1074         uint256 tokenId,
1075         address owner
1076     ) private {
1077         _tokenApprovals[tokenId] = to;
1078         emit Approval(owner, to, tokenId);
1079     }
1080 
1081     function _checkContractOnERC721Received(
1082         address from,
1083         address to,
1084         uint256 tokenId,
1085         bytes memory _data
1086     ) private returns (bool) {
1087         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1088             return retval == IERC721Receiver(to).onERC721Received.selector;
1089         } catch (bytes memory reason) {
1090             if (reason.length == 0) {
1091                 revert TransferToNonERC721ReceiverImplementer();
1092             } else {
1093                 assembly {
1094                     revert(add(32, reason), mload(reason))
1095                 }
1096             }
1097         }
1098     }
1099 
1100     function _beforeTokenTransfers(
1101         address from,
1102         address to,
1103         uint256 startTokenId,
1104         uint256 quantity
1105     ) internal virtual {}
1106 
1107     function _afterTokenTransfers(
1108         address from,
1109         address to,
1110         uint256 startTokenId,
1111         uint256 quantity
1112     ) internal virtual {}
1113 }
1114 
1115 pragma solidity ^0.8.4;
1116 
1117 contract BullShitters is ERC721A, Ownable {
1118     using Strings for uint256;
1119     string private baseURI;
1120     string public hiddenMetadataUri;
1121     uint256 public price = 0.01 ether;
1122     uint256 public maxPerTx = 10;
1123     uint256 public maxFreePerWallet = 2;
1124     uint256 public totalFree = 3300;
1125     uint256 public maxSupply = 3300;
1126     uint public nextId = 0;
1127     bool public mintEnabled = false;
1128     bool public revealed = true;
1129     mapping(address => uint256) private _mintedFreeAmount;
1130 
1131 
1132 
1133 constructor() ERC721A("Bullshitters.lol", "Shitters") {
1134         setHiddenMetadataUri("https://api.bullshitters.lol/");
1135         setBaseURI("https://api.bullshitters.lol/");
1136     }
1137 
1138     function mint(uint256 count) external payable {
1139     require(mintEnabled, "Mint not live yet");
1140       uint256 cost = price;
1141       bool isFree =
1142       ((totalSupply() + count < totalFree + 1) &&
1143       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1144 
1145       if (isFree) {
1146       cost = 0;
1147      }
1148 
1149      else {
1150       require(msg.value >= count * price, "Please send the exact amount.");
1151       require(totalSupply() + count <= maxSupply, "No more Shit");
1152       require(count <= maxPerTx, "Max per TX reached.");
1153      }
1154 
1155       if (isFree) {
1156          _mintedFreeAmount[msg.sender] += count;
1157       }
1158 
1159      _safeMint(msg.sender, count);
1160      nextId += count;
1161     }
1162 
1163     function _baseURI() internal view virtual override returns (string memory) {
1164         return baseURI;
1165     }
1166 
1167     function tokenURI(uint256 tokenId)
1168         public
1169         view
1170         virtual
1171         override
1172         returns (string memory)
1173     {
1174         require(
1175             _exists(tokenId),
1176             "ERC721Metadata: URI query for nonexistent token"
1177         );
1178 
1179         if (revealed == false) {
1180          return string(abi.encodePacked(hiddenMetadataUri));
1181         }
1182     
1183         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1184     }
1185 
1186     function setBaseURI(string memory uri) public onlyOwner {
1187         baseURI = uri;
1188     }
1189 
1190     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1191      hiddenMetadataUri = _hiddenMetadataUri;
1192     }
1193 
1194     function setFreeAmount(uint256 amount) external onlyOwner {
1195         totalFree = amount;
1196     }
1197 
1198     function setPrice(uint256 _newPrice) external onlyOwner {
1199         price = _newPrice;
1200     }
1201 
1202     function setRevealed() external onlyOwner {
1203      revealed = !revealed;
1204     }
1205 
1206     function flipSale() external onlyOwner {
1207         mintEnabled = !mintEnabled;
1208     }
1209 
1210     function getNextId() public view returns(uint){
1211      return nextId;
1212     }
1213 
1214     function _startTokenId() internal pure override returns (uint256) {
1215         return 1;
1216     }
1217 
1218     function withdraw() external onlyOwner {
1219         (bool success, ) = payable(msg.sender).call{
1220             value: address(this).balance
1221         }("");
1222         require(success, "Transfer failed.");
1223     }
1224     function setmaxSupply(uint _maxSupply) external onlyOwner {
1225         maxSupply = _maxSupply;
1226     }
1227 
1228     function setmaxFreePerWallet(uint256 _maxFreePerWallet) external onlyOwner {
1229         maxFreePerWallet = _maxFreePerWallet;
1230     }
1231 
1232     function setmaxPerTx(uint256 _maxPerTx) external onlyOwner {
1233         maxPerTx = _maxPerTx;
1234     }
1235 
1236     function MintShitWL(address to, uint256 quantity)public onlyOwner{
1237     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1238     _safeMint(to, quantity);
1239   }
1240 }