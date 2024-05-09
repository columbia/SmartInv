1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 ██████╗░██╗░░░██╗████████╗███████╗██████╗░██╗███╗░░██╗
6 ██╔══██╗██║░░░██║╚══██╔══╝██╔════╝██╔══██╗██║████╗░██║
7 ██████╦╝██║░░░██║░░░██║░░░█████╗░░██████╔╝██║██╔██╗██║
8 ██╔══██╗██║░░░██║░░░██║░░░██╔══╝░░██╔══██╗██║██║╚████║
9 ██████╦╝╚██████╔╝░░░██║░░░███████╗██║░░██║██║██║░╚███║
10 ╚═════╝░░╚═════╝░░░░╚═╝░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░╚══╝
11 
12 */
13 
14 
15 pragma solidity ^0.8.0;
16 
17 library Counters {
18     struct Counter {
19 
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter:decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 pragma solidity ^0.8.0;
47 
48 library Strings {
49     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
53      */
54     function toString(uint256 value) internal pure returns (string memory) {
55 
56         if (value == 0) {
57             return "0";
58         }
59         uint256 temp = value;
60         uint256 digits;
61         while (temp != 0) {
62             digits++;
63             temp /= 10;
64         }
65         bytes memory buffer = new bytes(digits);
66         while (value != 0) {
67             digits -= 1;
68             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
69             value /= 10;
70         }
71         return string(buffer);
72     }
73 
74     function toHexString(uint256 value) internal pure returns (string memory) {
75         if (value == 0) {
76             return "0x00";
77         }
78         uint256 temp = value;
79         uint256 length = 0;
80         while (temp != 0) {
81             length++;
82             temp >>= 8;
83         }
84         return toHexString(value, length);
85     }
86 
87     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
88         bytes memory buffer = new bytes(2 * length + 2);
89         buffer[0] = "0";
90         buffer[1] = "x";
91         for (uint256 i = 2 * length + 1; i > 1; --i) {
92             buffer[i] = _HEX_SYMBOLS[value & 0xf];
93             value >>= 4;
94         }
95         require(value == 0, "Strings: hex length insufficient");
96         return string(buffer);
97     }
98 }
99 
100 pragma solidity ^0.8.0;
101 
102 abstract contract Context {
103     function _msgSender() internal view virtual returns (address) {
104         return msg.sender;
105     }
106 
107     function _msgData() internal view virtual returns (bytes calldata) {
108         return msg.data;
109     }
110 }
111 
112 pragma solidity ^0.8.0;
113 
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     constructor() {
120         _transferOwnership(_msgSender());
121     }
122 
123     function owner() public view virtual returns (address) {
124         return _owner;
125     }
126 
127     modifier onlyOwner() {
128         require(owner() == _msgSender(), "Ownable: caller is not the owner");
129         _;
130     }
131 
132     function renounceOwnership() public virtual onlyOwner {
133         _transferOwnership(address(0));
134     }
135 
136     function transferOwnership(address newOwner) public virtual onlyOwner {
137         require(newOwner != address(0), "Ownable: new owner is the zero address");
138         _transferOwnership(newOwner);
139     }
140 
141     function _transferOwnership(address newOwner) internal virtual {
142         address oldOwner = _owner;
143         _owner = newOwner;
144         emit OwnershipTransferred(oldOwner, newOwner);
145     }
146 }
147 
148 pragma solidity ^0.8.1;
149 
150 library Address {
151 
152     function isContract(address account) internal view returns (bool) {
153 
154         return account.code.length > 0;
155     }
156 
157     function sendValue(address payable recipient, uint256 amount) internal {
158         require(address(this).balance >= amount, "Address: insufficient balance");
159 
160         (bool success, ) = recipient.call{value: amount}("");
161         require(success, "Address: unable to send value, recipient may have reverted");
162     }
163 
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     function functionCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         return functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     function functionCallWithValue(
177         address target,
178         bytes memory data,
179         uint256 value
180     ) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
182     }
183 
184     function functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 value,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         require(address(this).balance >= value, "Address: insufficient balance for call");
191         require(isContract(target), "Address: call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.call{value: value}(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
198         return functionStaticCall(target, data, "Address: low-level static call failed");
199     }
200 
201     function functionStaticCall(
202         address target,
203         bytes memory data,
204         string memory errorMessage
205     ) internal view returns (bytes memory) {
206         require(isContract(target), "Address: static call to non-contract");
207 
208         (bool success, bytes memory returndata) = target.staticcall(data);
209         return verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
213         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
214     }
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
227     function verifyCallResult(
228         bool success,
229         bytes memory returndata,
230         string memory errorMessage
231     ) internal pure returns (bytes memory) {
232         if (success) {
233             return returndata;
234         } else {
235             // Look for revert reason and bubble it up if present
236             if (returndata.length > 0) {
237                 // The easiest way to bubble the revert reason is using memory via assembly
238 
239                 assembly {
240                     let returndata_size := mload(returndata)
241                     revert(add(32, returndata), returndata_size)
242                 }
243             } else {
244                 revert(errorMessage);
245             }
246         }
247     }
248 }
249 
250 pragma solidity ^0.8.0;
251 
252 interface IERC721Receiver {
253 
254     function onERC721Received(
255         address operator,
256         address from,
257         uint256 tokenId,
258         bytes calldata data
259     ) external returns (bytes4);
260 }
261 
262 pragma solidity ^0.8.0;
263 
264 interface IERC165 {
265 
266     function supportsInterface(bytes4 interfaceId) external view returns (bool);
267 }
268 
269 pragma solidity ^0.8.0;
270 
271 abstract contract ERC165 is IERC165 {
272 
273     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
274         return interfaceId == type(IERC165).interfaceId;
275     }
276 }
277 
278 pragma solidity ^0.8.0;
279 
280 interface IERC721 is IERC165 {
281 
282     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
283     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
284     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
285     function balanceOf(address owner) external view returns (uint256 balance);
286     function ownerOf(uint256 tokenId) external view returns (address owner);
287 
288     function safeTransferFrom(
289         address from,
290         address to,
291         uint256 tokenId
292     ) external;
293 
294     function transferFrom(
295         address from,
296         address to,
297         uint256 tokenId
298     ) external;
299 
300     function approve(address to, uint256 tokenId) external;
301 
302     function getApproved(uint256 tokenId) external view returns (address operator);
303 
304     function setApprovalForAll(address operator, bool _approved) external;
305 
306     function isApprovedForAll(address owner, address operator) external view returns (bool);
307 
308     function safeTransferFrom(
309         address from,
310         address to,
311         uint256 tokenId,
312         bytes calldata data
313     ) external;
314 }
315 
316 pragma solidity ^0.8.0;
317 
318 interface IERC721Enumerable is IERC721 {
319 
320     function totalSupply() external view returns (uint256);
321     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
322     function tokenByIndex(uint256 index) external view returns (uint256);
323 }
324 
325 pragma solidity ^0.8.0;
326 
327 interface IERC721Metadata is IERC721 {
328 
329     function name() external view returns (string memory);
330 
331     function symbol() external view returns (string memory);
332 
333     function tokenURI(uint256 tokenId) external view returns (string memory);
334 }
335 
336 pragma solidity ^0.8.0;
337 
338 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
339     using Address for address;
340     using Strings for uint256;
341 
342     // Token name
343     string private _name;
344 
345     // Token symbol
346     string private _symbol;
347 
348     // Mapping from token ID to owner address
349     mapping(uint256 => address) private _owners;
350 
351     // Mapping owner address to token count
352     mapping(address => uint256) private _balances;
353 
354     // Mapping from token ID to approved address
355     mapping(uint256 => address) private _tokenApprovals;
356 
357     // Mapping from owner to operator approvals
358     mapping(address => mapping(address => bool)) private _operatorApprovals;
359 
360     constructor(string memory name_, string memory symbol_) {
361         _name = name_;
362         _symbol = symbol_;
363     }
364 
365     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
366         return
367             interfaceId == type(IERC721).interfaceId ||
368             interfaceId == type(IERC721Metadata).interfaceId ||
369             super.supportsInterface(interfaceId);
370     }
371 
372     function balanceOf(address owner) public view virtual override returns (uint256) {
373         require(owner != address(0), "ERC721: balance query for the zero address");
374         return _balances[owner];
375     }
376 
377     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
378         address owner = _owners[tokenId];
379         require(owner != address(0), "ERC721: owner query for nonexistent token");
380         return owner;
381     }
382 
383     function name() public view virtual override returns (string memory) {
384         return _name;
385     }
386 
387     function symbol() public view virtual override returns (string memory) {
388         return _symbol;
389     }
390 
391     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
392         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
393 
394         string memory baseURI = _baseURI();
395         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
396     }
397 
398     function _baseURI() internal view virtual returns (string memory) {
399         return "";
400     }
401 
402     function approve(address to, uint256 tokenId) public virtual override {
403         address owner = ERC721.ownerOf(tokenId);
404         require(to != owner, "ERC721: approval to current owner");
405 
406         require(
407             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
408             "ERC721: approve caller is not owner nor approved for all"
409         );
410 
411         _approve(to, tokenId);
412     }
413 
414     function getApproved(uint256 tokenId) public view virtual override returns (address) {
415         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
416 
417         return _tokenApprovals[tokenId];
418     }
419 
420     function setApprovalForAll(address operator, bool approved) public virtual override {
421         _setApprovalForAll(_msgSender(), operator, approved);
422     }
423 
424     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
425         return _operatorApprovals[owner][operator];
426     }
427 
428     function transferFrom(
429         address from,
430         address to,
431         uint256 tokenId
432     ) public virtual override {
433         //solhint-disable-next-line max-line-length
434         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
435 
436         _transfer(from, to, tokenId);
437     }
438 
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId
443     ) public virtual override {
444         safeTransferFrom(from, to, tokenId, "");
445     }
446 
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 tokenId,
451         bytes memory _data
452     ) public virtual override {
453         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
454         _safeTransfer(from, to, tokenId, _data);
455     }
456 
457     function _safeTransfer(
458         address from,
459         address to,
460         uint256 tokenId,
461         bytes memory _data
462     ) internal virtual {
463         _transfer(from, to, tokenId);
464         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
465     }
466 
467     function _exists(uint256 tokenId) internal view virtual returns (bool) {
468         return _owners[tokenId] != address(0);
469     }
470 
471     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
472         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
473         address owner = ERC721.ownerOf(tokenId);
474         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
475     }
476 
477     function _safeMint(address to, uint256 tokenId) internal virtual {
478         _safeMint(to, tokenId, "");
479     }
480 
481     function _safeMint(
482         address to,
483         uint256 tokenId,
484         bytes memory _data
485     ) internal virtual {
486         _mint(to, tokenId);
487         require(
488             _checkOnERC721Received(address(0), to, tokenId, _data),
489             "ERC721: transfer to non ERC721Receiver implementer"
490         );
491     }
492 
493     function _mint(address to, uint256 tokenId) internal virtual {
494         require(to != address(0), "ERC721: mint to the zero address");
495         require(!_exists(tokenId), "ERC721: token already minted");
496 
497         _beforeTokenTransfer(address(0), to, tokenId);
498 
499         _balances[to] += 1;
500         _owners[tokenId] = to;
501 
502         emit Transfer(address(0), to, tokenId);
503 
504         _afterTokenTransfer(address(0), to, tokenId);
505     }
506 
507     function _burn(uint256 tokenId) internal virtual {
508         address owner = ERC721.ownerOf(tokenId);
509 
510         _beforeTokenTransfer(owner, address(0), tokenId);
511 
512         // Clear approvals
513         _approve(address(0), tokenId);
514 
515         _balances[owner] -= 1;
516         delete _owners[tokenId];
517 
518         emit Transfer(owner, address(0), tokenId);
519 
520         _afterTokenTransfer(owner, address(0), tokenId);
521     }
522 
523     function _transfer(
524         address from,
525         address to,
526         uint256 tokenId
527     ) internal virtual {
528         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
529         require(to != address(0), "ERC721: transfer to the zero address");
530 
531         _beforeTokenTransfer(from, to, tokenId);
532 
533         _approve(address(0), tokenId);
534 
535         _balances[from] -= 1;
536         _balances[to] += 1;
537         _owners[tokenId] = to;
538 
539         emit Transfer(from, to, tokenId);
540 
541         _afterTokenTransfer(from, to, tokenId);
542     }
543 
544     function _approve(address to, uint256 tokenId) internal virtual {
545         _tokenApprovals[tokenId] = to;
546         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
547     }
548 
549     function _setApprovalForAll(
550         address owner,
551         address operator,
552         bool approved
553     ) internal virtual {
554         require(owner != operator, "ERC721: approve to caller");
555         _operatorApprovals[owner][operator] = approved;
556         emit ApprovalForAll(owner, operator, approved);
557     }
558 
559     function _checkOnERC721Received(
560         address from,
561         address to,
562         uint256 tokenId,
563         bytes memory _data
564     ) private returns (bool) {
565         if (to.isContract()) {
566             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
567                 return retval == IERC721Receiver.onERC721Received.selector;
568             } catch (bytes memory reason) {
569                 if (reason.length == 0) {
570                     revert("ERC721: transfer to non ERC721Receiver implementer");
571                 } else {
572                     assembly {
573                         revert(add(32, reason), mload(reason))
574                     }
575                 }
576             }
577         } else {
578             return true;
579         }
580     }
581 
582     function _beforeTokenTransfer(
583         address from,
584         address to,
585         uint256 tokenId
586     ) internal virtual {}
587 
588     function _afterTokenTransfer(
589         address from,
590         address to,
591         uint256 tokenId
592     ) internal virtual {}
593 }
594 
595 pragma solidity ^0.8.0;
596 
597 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
598     // Mapping from owner to list of owned token IDs
599     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
600 
601     // Mapping from token ID to index of the owner tokens list
602     mapping(uint256 => uint256) private _ownedTokensIndex;
603 
604     // Array with all token ids, used for enumeration
605     uint256[] private _allTokens;
606 
607     // Mapping from token id to position in the allTokens array
608     mapping(uint256 => uint256) private _allTokensIndex;
609 
610     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
611         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
612     }
613 
614     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
615         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
616         return _ownedTokens[owner][index];
617     }
618 
619     function totalSupply() public view virtual override returns (uint256) {
620         return _allTokens.length;
621     }
622 
623     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
624         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
625         return _allTokens[index];
626     }
627 
628     function _beforeTokenTransfer(
629         address from,
630         address to,
631         uint256 tokenId
632     ) internal virtual override {
633         super._beforeTokenTransfer(from, to, tokenId);
634 
635         if (from == address(0)) {
636             _addTokenToAllTokensEnumeration(tokenId);
637         } else if (from != to) {
638             _removeTokenFromOwnerEnumeration(from, tokenId);
639         }
640         if (to == address(0)) {
641             _removeTokenFromAllTokensEnumeration(tokenId);
642         } else if (to != from) {
643             _addTokenToOwnerEnumeration(to, tokenId);
644         }
645     }
646 
647     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
648         uint256 length = ERC721.balanceOf(to);
649         _ownedTokens[to][length] = tokenId;
650         _ownedTokensIndex[tokenId] = length;
651     }
652 
653     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
654         _allTokensIndex[tokenId] = _allTokens.length;
655         _allTokens.push(tokenId);
656     }
657 
658     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
659         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
660         // then delete the last slot (swap and pop).
661 
662         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
663         uint256 tokenIndex = _ownedTokensIndex[tokenId];
664 
665         // When the token to delete is the last token, the swap operation is unnecessary
666         if (tokenIndex != lastTokenIndex) {
667             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
668 
669             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
670             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
671         }
672 
673         // This also deletes the contents at the last position of the array
674         delete _ownedTokensIndex[tokenId];
675         delete _ownedTokens[from][lastTokenIndex];
676     }
677 
678     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
679         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
680         // then delete the last slot (swap and pop).
681 
682         uint256 lastTokenIndex = _allTokens.length - 1;
683         uint256 tokenIndex = _allTokensIndex[tokenId];
684 
685         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
686         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
687         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
688         uint256 lastTokenId = _allTokens[lastTokenIndex];
689 
690         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
691         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
692 
693         // This also deletes the contents at the last position of the array
694         delete _allTokensIndex[tokenId];
695         _allTokens.pop();
696     }
697 }
698 
699 pragma solidity ^0.8.4;
700 
701 error ApprovalCallerNotOwnerNorApproved();
702 error ApprovalQueryForNonexistentToken();
703 error ApproveToCaller();
704 error ApprovalToCurrentOwner();
705 error BalanceQueryForZeroAddress();
706 error MintToZeroAddress();
707 error MintZeroQuantity();
708 error OwnerQueryForNonexistentToken();
709 error TransferCallerNotOwnerNorApproved();
710 error TransferFromIncorrectOwner();
711 error TransferToNonERC721ReceiverImplementer();
712 error TransferToZeroAddress();
713 error URIQueryForNonexistentToken();
714 
715 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
716     using Address for address;
717     using Strings for uint256;
718 
719     // Compiler will pack this into a single 256bit word.
720     struct TokenOwnership {
721         // The address of the owner.
722         address addr;
723         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
724         uint64 startTimestamp;
725         // Whether the token has been burned.
726         bool burned;
727     }
728 
729     // Compiler will pack this into a single 256bit word.
730     struct AddressData {
731         // Realistically, 2**64-1 is more than enough.
732         uint64 balance;
733         // Keeps track of mint count with minimal overhead for tokenomics.
734         uint64 numberMinted;
735         // Keeps track of burn count with minimal overhead for tokenomics.
736         uint64 numberBurned;
737         // For miscellaneous variable(s) pertaining to the address
738         // (e.g. number of whitelist mint slots used).
739         // If there are multiple variables, please pack them into a uint64.
740         uint64 aux;
741     }
742 
743     // The tokenId of the next token to be minted.
744     uint256 internal _currentIndex;
745 
746     // The number of tokens burned.
747     uint256 internal _burnCounter;
748 
749     // Token name
750     string private _name;
751 
752     // Token symbol
753     string private _symbol;
754 
755     // Mapping from token ID to ownership details
756     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
757     mapping(uint256 => TokenOwnership) internal _ownerships;
758 
759     // Mapping owner address to address data
760     mapping(address => AddressData) private _addressData;
761 
762     // Mapping from token ID to approved address
763     mapping(uint256 => address) private _tokenApprovals;
764 
765     // Mapping from owner to operator approvals
766     mapping(address => mapping(address => bool)) private _operatorApprovals;
767 
768     constructor(string memory name_, string memory symbol_) {
769         _name = name_;
770         _symbol = symbol_;
771         _currentIndex = _startTokenId();
772     }
773 
774     function _startTokenId() internal view virtual returns (uint256) {
775         return 0;
776     }
777 
778     function totalSupply() public view returns (uint256) {
779         unchecked {
780             return _currentIndex - _burnCounter - _startTokenId();
781         }
782     }
783 
784     function _totalMinted() internal view returns (uint256) {
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
1117 contract ProjectButerin is ERC721A, Ownable {
1118     using Strings for uint256;
1119     string private baseURI;
1120     string public hiddenMetadataUri;
1121     uint256 public price = 0.00666 ether;
1122     uint256 public maxPerTx = 6;
1123     uint256 public maxFreePerWallet = 2;
1124     uint256 public totalFree = 6666;
1125     uint256 public maxSupply = 10000;
1126     uint public nextId = 0;
1127     bool public mintEnabled = false;
1128     bool public revealed = true;
1129     mapping(address => uint256) private _mintedFreeAmount;
1130 
1131 constructor() ERC721A("Project Buterin", "BUTERIN") {
1132         setHiddenMetadataUri("https://api.buterin.monster/");
1133         setBaseURI("https://api.buterin.monster/");
1134     }
1135 
1136     function mint(uint256 count) external payable {
1137     require(mintEnabled, "Hey! Mint not live yet!");
1138       uint256 cost = price;
1139       bool isFree =
1140       ((totalSupply() + count < totalFree + 1) &&
1141       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1142 
1143       if (isFree) {
1144       cost = 0;
1145      }
1146 
1147      else {
1148       require(msg.value >= count * price, "Please send the exact amount.");
1149       require(totalSupply() + count <= maxSupply, "No more in stock");
1150       require(count <= maxPerTx, "Max per TX reached.");
1151      }
1152 
1153       if (isFree) {
1154          _mintedFreeAmount[msg.sender] += count;
1155       }
1156 
1157      _safeMint(msg.sender, count);
1158      nextId += count;
1159     }
1160 
1161     function _baseURI() internal view virtual override returns (string memory) {
1162         return baseURI;
1163     }
1164 
1165     function tokenURI(uint256 tokenId)
1166         public
1167         view
1168         virtual
1169         override
1170         returns (string memory)
1171     {
1172         require(
1173             _exists(tokenId),
1174             "ERC721Metadata: URI query for nonexistent token"
1175         );
1176 
1177         if (revealed == false) {
1178          return string(abi.encodePacked(hiddenMetadataUri));
1179         }
1180     
1181         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1182     }
1183 
1184     function setBaseURI(string memory uri) public onlyOwner {
1185         baseURI = uri;
1186     }
1187 
1188     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1189      hiddenMetadataUri = _hiddenMetadataUri;
1190     }
1191 
1192     function setFreeAmount(uint256 amount) external onlyOwner {
1193         totalFree = amount;
1194     }
1195 
1196     function setPrice(uint256 _newPrice) external onlyOwner {
1197         price = _newPrice;
1198     }
1199 
1200     function setRevealed() external onlyOwner {
1201      revealed = !revealed;
1202     }
1203 
1204     function flipSale() external onlyOwner {
1205         mintEnabled = !mintEnabled;
1206     }
1207 
1208     function getNextId() public view returns(uint){
1209      return nextId;
1210     }
1211 
1212     function _startTokenId() internal pure override returns (uint256) {
1213         return 1;
1214     }
1215 
1216     function withdraw() external onlyOwner {
1217         (bool success, ) = payable(msg.sender).call{
1218             value: address(this).balance
1219         }("");
1220         require(success, "Transfer failed.");
1221     }
1222     function setmaxSupply(uint _maxSupply) external onlyOwner {
1223         maxSupply = _maxSupply;
1224     }
1225 
1226     function setmaxFreePerWallet(uint256 _maxFreePerWallet) external onlyOwner {
1227         maxFreePerWallet = _maxFreePerWallet;
1228     }
1229 
1230     function setmaxPerTx(uint256 _maxPerTx) external onlyOwner {
1231         maxPerTx = _maxPerTx;
1232     }
1233 
1234     function MintButerinWL(address to, uint256 quantity)public onlyOwner{
1235     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1236     _safeMint(to, quantity);
1237   }
1238 }