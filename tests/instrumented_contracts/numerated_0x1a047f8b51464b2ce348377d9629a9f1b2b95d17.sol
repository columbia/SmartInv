1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 ██████╗░███████╗██╗░░██╗████████╗███████╗██████╗░
6 ██╔══██╗██╔════╝╚██╗██╔╝╚══██╔══╝██╔════╝██╔══██╗
7 ██████╦╝█████╗░░░╚███╔╝░░░░██║░░░█████╗░░██████╔╝
8 ██╔══██╗██╔══╝░░░██╔██╗░░░░██║░░░██╔══╝░░██╔══██╗
9 ██████╦╝███████╗██╔╝╚██╗░░░██║░░░███████╗██║░░██║
10 ╚═════╝░╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═╝░░╚═╝
11 
12 
13 █▀▀ █▀█ █▀▄▀█ █ █▀▀   █▀ █▀▀ █▀█ █ █▀▀ █▀
14 █▄▄ █▄█ █░▀░█ █ █▄▄   ▄█ ██▄ █▀▄ █ ██▄ ▄█
15 
16 */
17 
18 pragma solidity ^0.8.0;
19 
20 library Counters {
21     struct Counter {
22 
23         uint256 _value; // default: 0
24     }
25 
26     function current(Counter storage counter) internal view returns (uint256) {
27         return counter._value;
28     }
29 
30     function increment(Counter storage counter) internal {
31         unchecked {
32             counter._value += 1;
33         }
34     }
35 
36     function decrement(Counter storage counter) internal {
37         uint256 value = counter._value;
38         require(value > 0, "Counter:decrement overflow");
39         unchecked {
40             counter._value = value - 1;
41         }
42     }
43 
44     function reset(Counter storage counter) internal {
45         counter._value = 0;
46     }
47 }
48 
49 pragma solidity ^0.8.0;
50 
51 library Strings {
52     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
56      */
57     function toString(uint256 value) internal pure returns (string memory) {
58         // Inspired by OraclizeAPI's implementation - MIT licence
59         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
60 
61         if (value == 0) {
62             return "0";
63         }
64         uint256 temp = value;
65         uint256 digits;
66         while (temp != 0) {
67             digits++;
68             temp /= 10;
69         }
70         bytes memory buffer = new bytes(digits);
71         while (value != 0) {
72             digits -= 1;
73             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
74             value /= 10;
75         }
76         return string(buffer);
77     }
78 
79     function toHexString(uint256 value) internal pure returns (string memory) {
80         if (value == 0) {
81             return "0x00";
82         }
83         uint256 temp = value;
84         uint256 length = 0;
85         while (temp != 0) {
86             length++;
87             temp >>= 8;
88         }
89         return toHexString(value, length);
90     }
91 
92     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
93         bytes memory buffer = new bytes(2 * length + 2);
94         buffer[0] = "0";
95         buffer[1] = "x";
96         for (uint256 i = 2 * length + 1; i > 1; --i) {
97             buffer[i] = _HEX_SYMBOLS[value & 0xf];
98             value >>= 4;
99         }
100         require(value == 0, "Strings: hex length insufficient");
101         return string(buffer);
102     }
103 }
104 
105 pragma solidity ^0.8.0;
106 
107 abstract contract Context {
108     function _msgSender() internal view virtual returns (address) {
109         return msg.sender;
110     }
111 
112     function _msgData() internal view virtual returns (bytes calldata) {
113         return msg.data;
114     }
115 }
116 
117 pragma solidity ^0.8.0;
118 
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     constructor() {
125         _transferOwnership(_msgSender());
126     }
127 
128     function owner() public view virtual returns (address) {
129         return _owner;
130     }
131 
132     modifier onlyOwner() {
133         require(owner() == _msgSender(), "Ownable: caller is not the owner");
134         _;
135     }
136 
137     function renounceOwnership() public virtual onlyOwner {
138         _transferOwnership(address(0));
139     }
140 
141     function transferOwnership(address newOwner) public virtual onlyOwner {
142         require(newOwner != address(0), "Ownable: new owner is the zero address");
143         _transferOwnership(newOwner);
144     }
145 
146     function _transferOwnership(address newOwner) internal virtual {
147         address oldOwner = _owner;
148         _owner = newOwner;
149         emit OwnershipTransferred(oldOwner, newOwner);
150     }
151 }
152 
153 pragma solidity ^0.8.1;
154 
155 library Address {
156 
157     function isContract(address account) internal view returns (bool) {
158 
159         return account.code.length > 0;
160     }
161 
162     function sendValue(address payable recipient, uint256 amount) internal {
163         require(address(this).balance >= amount, "Address: insufficient balance");
164 
165         (bool success, ) = recipient.call{value: amount}("");
166         require(success, "Address: unable to send value, recipient may have reverted");
167     }
168 
169     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
170         return functionCall(target, data, "Address: low-level call failed");
171     }
172 
173     function functionCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal returns (bytes memory) {
178         return functionCallWithValue(target, data, 0, errorMessage);
179     }
180 
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     function functionCallWithValue(
190         address target,
191         bytes memory data,
192         uint256 value,
193         string memory errorMessage
194     ) internal returns (bytes memory) {
195         require(address(this).balance >= value, "Address: insufficient balance for call");
196         require(isContract(target), "Address: call to non-contract");
197 
198         (bool success, bytes memory returndata) = target.call{value: value}(data);
199         return verifyCallResult(success, returndata, errorMessage);
200     }
201 
202     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
203         return functionStaticCall(target, data, "Address: low-level static call failed");
204     }
205 
206     function functionStaticCall(
207         address target,
208         bytes memory data,
209         string memory errorMessage
210     ) internal view returns (bytes memory) {
211         require(isContract(target), "Address: static call to non-contract");
212 
213         (bool success, bytes memory returndata) = target.staticcall(data);
214         return verifyCallResult(success, returndata, errorMessage);
215     }
216 
217     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
218         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
219     }
220 
221     function functionDelegateCall(
222         address target,
223         bytes memory data,
224         string memory errorMessage
225     ) internal returns (bytes memory) {
226         require(isContract(target), "Address: delegate call to non-contract");
227 
228         (bool success, bytes memory returndata) = target.delegatecall(data);
229         return verifyCallResult(success, returndata, errorMessage);
230     }
231 
232     function verifyCallResult(
233         bool success,
234         bytes memory returndata,
235         string memory errorMessage
236     ) internal pure returns (bytes memory) {
237         if (success) {
238             return returndata;
239         } else {
240             // Look for revert reason and bubble it up if present
241             if (returndata.length > 0) {
242                 // The easiest way to bubble the revert reason is using memory via assembly
243 
244                 assembly {
245                     let returndata_size := mload(returndata)
246                     revert(add(32, returndata), returndata_size)
247                 }
248             } else {
249                 revert(errorMessage);
250             }
251         }
252     }
253 }
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
267 pragma solidity ^0.8.0;
268 
269 interface IERC165 {
270 
271     function supportsInterface(bytes4 interfaceId) external view returns (bool);
272 }
273 
274 pragma solidity ^0.8.0;
275 
276 abstract contract ERC165 is IERC165 {
277 
278     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
279         return interfaceId == type(IERC165).interfaceId;
280     }
281 }
282 
283 pragma solidity ^0.8.0;
284 
285 interface IERC721 is IERC165 {
286 
287     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
288 
289     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
290 
291     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
292 
293     function balanceOf(address owner) external view returns (uint256 balance);
294 
295     function ownerOf(uint256 tokenId) external view returns (address owner);
296 
297     function safeTransferFrom(
298         address from,
299         address to,
300         uint256 tokenId
301     ) external;
302 
303     function transferFrom(
304         address from,
305         address to,
306         uint256 tokenId
307     ) external;
308 
309     function approve(address to, uint256 tokenId) external;
310 
311     function getApproved(uint256 tokenId) external view returns (address operator);
312 
313     function setApprovalForAll(address operator, bool _approved) external;
314 
315     function isApprovedForAll(address owner, address operator) external view returns (bool);
316 
317     function safeTransferFrom(
318         address from,
319         address to,
320         uint256 tokenId,
321         bytes calldata data
322     ) external;
323 }
324 
325 pragma solidity ^0.8.0;
326 
327 interface IERC721Enumerable is IERC721 {
328 
329     function totalSupply() external view returns (uint256);
330 
331     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
332 
333     function tokenByIndex(uint256 index) external view returns (uint256);
334 }
335 
336 pragma solidity ^0.8.0;
337 
338 interface IERC721Metadata is IERC721 {
339 
340     function name() external view returns (string memory);
341 
342     function symbol() external view returns (string memory);
343 
344     function tokenURI(uint256 tokenId) external view returns (string memory);
345 }
346 
347 pragma solidity ^0.8.0;
348 
349 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
350     using Address for address;
351     using Strings for uint256;
352 
353     // Token name
354     string private _name;
355 
356     // Token symbol
357     string private _symbol;
358 
359     // Mapping from token ID to owner address
360     mapping(uint256 => address) private _owners;
361 
362     // Mapping owner address to token count
363     mapping(address => uint256) private _balances;
364 
365     // Mapping from token ID to approved address
366     mapping(uint256 => address) private _tokenApprovals;
367 
368     // Mapping from owner to operator approvals
369     mapping(address => mapping(address => bool)) private _operatorApprovals;
370 
371     constructor(string memory name_, string memory symbol_) {
372         _name = name_;
373         _symbol = symbol_;
374     }
375 
376     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
377         return
378             interfaceId == type(IERC721).interfaceId ||
379             interfaceId == type(IERC721Metadata).interfaceId ||
380             super.supportsInterface(interfaceId);
381     }
382 
383     function balanceOf(address owner) public view virtual override returns (uint256) {
384         require(owner != address(0), "ERC721: balance query for the zero address");
385         return _balances[owner];
386     }
387 
388     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
389         address owner = _owners[tokenId];
390         require(owner != address(0), "ERC721: owner query for nonexistent token");
391         return owner;
392     }
393 
394     function name() public view virtual override returns (string memory) {
395         return _name;
396     }
397 
398     function symbol() public view virtual override returns (string memory) {
399         return _symbol;
400     }
401 
402     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
403         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
404 
405         string memory baseURI = _baseURI();
406         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
407     }
408 
409     function _baseURI() internal view virtual returns (string memory) {
410         return "";
411     }
412 
413     function approve(address to, uint256 tokenId) public virtual override {
414         address owner = ERC721.ownerOf(tokenId);
415         require(to != owner, "ERC721: approval to current owner");
416 
417         require(
418             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
419             "ERC721: approve caller is not owner nor approved for all"
420         );
421 
422         _approve(to, tokenId);
423     }
424 
425     function getApproved(uint256 tokenId) public view virtual override returns (address) {
426         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
427 
428         return _tokenApprovals[tokenId];
429     }
430 
431     function setApprovalForAll(address operator, bool approved) public virtual override {
432         _setApprovalForAll(_msgSender(), operator, approved);
433     }
434 
435     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
436         return _operatorApprovals[owner][operator];
437     }
438 
439     function transferFrom(
440         address from,
441         address to,
442         uint256 tokenId
443     ) public virtual override {
444         //solhint-disable-next-line max-line-length
445         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
446 
447         _transfer(from, to, tokenId);
448     }
449 
450     function safeTransferFrom(
451         address from,
452         address to,
453         uint256 tokenId
454     ) public virtual override {
455         safeTransferFrom(from, to, tokenId, "");
456     }
457 
458     function safeTransferFrom(
459         address from,
460         address to,
461         uint256 tokenId,
462         bytes memory _data
463     ) public virtual override {
464         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
465         _safeTransfer(from, to, tokenId, _data);
466     }
467 
468     function _safeTransfer(
469         address from,
470         address to,
471         uint256 tokenId,
472         bytes memory _data
473     ) internal virtual {
474         _transfer(from, to, tokenId);
475         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
476     }
477 
478     function _exists(uint256 tokenId) internal view virtual returns (bool) {
479         return _owners[tokenId] != address(0);
480     }
481 
482     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
483         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
484         address owner = ERC721.ownerOf(tokenId);
485         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
486     }
487 
488     function _safeMint(address to, uint256 tokenId) internal virtual {
489         _safeMint(to, tokenId, "");
490     }
491 
492     function _safeMint(
493         address to,
494         uint256 tokenId,
495         bytes memory _data
496     ) internal virtual {
497         _mint(to, tokenId);
498         require(
499             _checkOnERC721Received(address(0), to, tokenId, _data),
500             "ERC721: transfer to non ERC721Receiver implementer"
501         );
502     }
503 
504     function _mint(address to, uint256 tokenId) internal virtual {
505         require(to != address(0), "ERC721: mint to the zero address");
506         require(!_exists(tokenId), "ERC721: token already minted");
507 
508         _beforeTokenTransfer(address(0), to, tokenId);
509 
510         _balances[to] += 1;
511         _owners[tokenId] = to;
512 
513         emit Transfer(address(0), to, tokenId);
514 
515         _afterTokenTransfer(address(0), to, tokenId);
516     }
517 
518     function _burn(uint256 tokenId) internal virtual {
519         address owner = ERC721.ownerOf(tokenId);
520 
521         _beforeTokenTransfer(owner, address(0), tokenId);
522 
523         // Clear approvals
524         _approve(address(0), tokenId);
525 
526         _balances[owner] -= 1;
527         delete _owners[tokenId];
528 
529         emit Transfer(owner, address(0), tokenId);
530 
531         _afterTokenTransfer(owner, address(0), tokenId);
532     }
533 
534     function _transfer(
535         address from,
536         address to,
537         uint256 tokenId
538     ) internal virtual {
539         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
540         require(to != address(0), "ERC721: transfer to the zero address");
541 
542         _beforeTokenTransfer(from, to, tokenId);
543 
544         _approve(address(0), tokenId);
545 
546         _balances[from] -= 1;
547         _balances[to] += 1;
548         _owners[tokenId] = to;
549 
550         emit Transfer(from, to, tokenId);
551 
552         _afterTokenTransfer(from, to, tokenId);
553     }
554 
555     function _approve(address to, uint256 tokenId) internal virtual {
556         _tokenApprovals[tokenId] = to;
557         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
558     }
559 
560     function _setApprovalForAll(
561         address owner,
562         address operator,
563         bool approved
564     ) internal virtual {
565         require(owner != operator, "ERC721: approve to caller");
566         _operatorApprovals[owner][operator] = approved;
567         emit ApprovalForAll(owner, operator, approved);
568     }
569 
570     function _checkOnERC721Received(
571         address from,
572         address to,
573         uint256 tokenId,
574         bytes memory _data
575     ) private returns (bool) {
576         if (to.isContract()) {
577             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
578                 return retval == IERC721Receiver.onERC721Received.selector;
579             } catch (bytes memory reason) {
580                 if (reason.length == 0) {
581                     revert("ERC721: transfer to non ERC721Receiver implementer");
582                 } else {
583                     assembly {
584                         revert(add(32, reason), mload(reason))
585                     }
586                 }
587             }
588         } else {
589             return true;
590         }
591     }
592 
593     function _beforeTokenTransfer(
594         address from,
595         address to,
596         uint256 tokenId
597     ) internal virtual {}
598 
599     function _afterTokenTransfer(
600         address from,
601         address to,
602         uint256 tokenId
603     ) internal virtual {}
604 }
605 
606 pragma solidity ^0.8.0;
607 
608 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
609     // Mapping from owner to list of owned token IDs
610     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
611 
612     // Mapping from token ID to index of the owner tokens list
613     mapping(uint256 => uint256) private _ownedTokensIndex;
614 
615     // Array with all token ids, used for enumeration
616     uint256[] private _allTokens;
617 
618     // Mapping from token id to position in the allTokens array
619     mapping(uint256 => uint256) private _allTokensIndex;
620 
621     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
622         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
623     }
624 
625     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
626         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
627         return _ownedTokens[owner][index];
628     }
629 
630     function totalSupply() public view virtual override returns (uint256) {
631         return _allTokens.length;
632     }
633 
634     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
635         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
636         return _allTokens[index];
637     }
638 
639     function _beforeTokenTransfer(
640         address from,
641         address to,
642         uint256 tokenId
643     ) internal virtual override {
644         super._beforeTokenTransfer(from, to, tokenId);
645 
646         if (from == address(0)) {
647             _addTokenToAllTokensEnumeration(tokenId);
648         } else if (from != to) {
649             _removeTokenFromOwnerEnumeration(from, tokenId);
650         }
651         if (to == address(0)) {
652             _removeTokenFromAllTokensEnumeration(tokenId);
653         } else if (to != from) {
654             _addTokenToOwnerEnumeration(to, tokenId);
655         }
656     }
657 
658     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
659         uint256 length = ERC721.balanceOf(to);
660         _ownedTokens[to][length] = tokenId;
661         _ownedTokensIndex[tokenId] = length;
662     }
663 
664     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
665         _allTokensIndex[tokenId] = _allTokens.length;
666         _allTokens.push(tokenId);
667     }
668 
669     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
670         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
671         // then delete the last slot (swap and pop).
672 
673         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
674         uint256 tokenIndex = _ownedTokensIndex[tokenId];
675 
676         // When the token to delete is the last token, the swap operation is unnecessary
677         if (tokenIndex != lastTokenIndex) {
678             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
679 
680             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
681             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
682         }
683 
684         // This also deletes the contents at the last position of the array
685         delete _ownedTokensIndex[tokenId];
686         delete _ownedTokens[from][lastTokenIndex];
687     }
688 
689     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
690         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
691         // then delete the last slot (swap and pop).
692 
693         uint256 lastTokenIndex = _allTokens.length - 1;
694         uint256 tokenIndex = _allTokensIndex[tokenId];
695 
696         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
697         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
698         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
699         uint256 lastTokenId = _allTokens[lastTokenIndex];
700 
701         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
702         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
703 
704         // This also deletes the contents at the last position of the array
705         delete _allTokensIndex[tokenId];
706         _allTokens.pop();
707     }
708 }
709 
710 pragma solidity ^0.8.4;
711 
712 error ApprovalCallerNotOwnerNorApproved();
713 error ApprovalQueryForNonexistentToken();
714 error ApproveToCaller();
715 error ApprovalToCurrentOwner();
716 error BalanceQueryForZeroAddress();
717 error MintToZeroAddress();
718 error MintZeroQuantity();
719 error OwnerQueryForNonexistentToken();
720 error TransferCallerNotOwnerNorApproved();
721 error TransferFromIncorrectOwner();
722 error TransferToNonERC721ReceiverImplementer();
723 error TransferToZeroAddress();
724 error URIQueryForNonexistentToken();
725 
726 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
727     using Address for address;
728     using Strings for uint256;
729 
730     // Compiler will pack this into a single 256bit word.
731     struct TokenOwnership {
732         // The address of the owner.
733         address addr;
734         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
735         uint64 startTimestamp;
736         // Whether the token has been burned.
737         bool burned;
738     }
739 
740     // Compiler will pack this into a single 256bit word.
741     struct AddressData {
742         // Realistically, 2**64-1 is more than enough.
743         uint64 balance;
744         // Keeps track of mint count with minimal overhead for tokenomics.
745         uint64 numberMinted;
746         // Keeps track of burn count with minimal overhead for tokenomics.
747         uint64 numberBurned;
748         // For miscellaneous variable(s) pertaining to the address
749         // (e.g. number of whitelist mint slots used).
750         // If there are multiple variables, please pack them into a uint64.
751         uint64 aux;
752     }
753 
754     // The tokenId of the next token to be minted.
755     uint256 internal _currentIndex;
756 
757     // The number of tokens burned.
758     uint256 internal _burnCounter;
759 
760     // Token name
761     string private _name;
762 
763     // Token symbol
764     string private _symbol;
765 
766     // Mapping from token ID to ownership details
767     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
768     mapping(uint256 => TokenOwnership) internal _ownerships;
769 
770     // Mapping owner address to address data
771     mapping(address => AddressData) private _addressData;
772 
773     // Mapping from token ID to approved address
774     mapping(uint256 => address) private _tokenApprovals;
775 
776     // Mapping from owner to operator approvals
777     mapping(address => mapping(address => bool)) private _operatorApprovals;
778 
779     constructor(string memory name_, string memory symbol_) {
780         _name = name_;
781         _symbol = symbol_;
782         _currentIndex = _startTokenId();
783     }
784 
785     function _startTokenId() internal view virtual returns (uint256) {
786         return 0;
787     }
788 
789     function totalSupply() public view returns (uint256) {
790         // Counter underflow is impossible as _burnCounter cannot be incremented
791         // more than _currentIndex - _startTokenId() times
792         unchecked {
793             return _currentIndex - _burnCounter - _startTokenId();
794         }
795     }
796 
797     function _totalMinted() internal view returns (uint256) {
798         // Counter underflow is impossible as _currentIndex does not decrement,
799         // and it is initialized to _startTokenId()
800         unchecked {
801             return _currentIndex - _startTokenId();
802         }
803     }
804 
805     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
806         return
807             interfaceId == type(IERC721).interfaceId ||
808             interfaceId == type(IERC721Metadata).interfaceId ||
809             super.supportsInterface(interfaceId);
810     }
811 
812     function balanceOf(address owner) public view override returns (uint256) {
813         if (owner == address(0)) revert BalanceQueryForZeroAddress();
814         return uint256(_addressData[owner].balance);
815     }
816 
817     function _numberMinted(address owner) internal view returns (uint256) {
818         return uint256(_addressData[owner].numberMinted);
819     }
820 
821     function _numberBurned(address owner) internal view returns (uint256) {
822         return uint256(_addressData[owner].numberBurned);
823     }
824 
825     function _getAux(address owner) internal view returns (uint64) {
826         return _addressData[owner].aux;
827     }
828 
829     function _setAux(address owner, uint64 aux) internal {
830         _addressData[owner].aux = aux;
831     }
832 
833     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
834         uint256 curr = tokenId;
835 
836         unchecked {
837             if (_startTokenId() <= curr && curr < _currentIndex) {
838                 TokenOwnership memory ownership = _ownerships[curr];
839                 if (!ownership.burned) {
840                     if (ownership.addr != address(0)) {
841                         return ownership;
842                     }
843 
844                     while (true) {
845                         curr--;
846                         ownership = _ownerships[curr];
847                         if (ownership.addr != address(0)) {
848                             return ownership;
849                         }
850                     }
851                 }
852             }
853         }
854         revert OwnerQueryForNonexistentToken();
855     }
856 
857     function ownerOf(uint256 tokenId) public view override returns (address) {
858         return _ownershipOf(tokenId).addr;
859     }
860 
861     function name() public view virtual override returns (string memory) {
862         return _name;
863     }
864 
865     function symbol() public view virtual override returns (string memory) {
866         return _symbol;
867     }
868 
869     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
870         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
871 
872         string memory baseURI = _baseURI();
873         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
874     }
875 
876     function _baseURI() internal view virtual returns (string memory) {
877         return '';
878     }
879 
880     function approve(address to, uint256 tokenId) public override {
881         address owner = ERC721A.ownerOf(tokenId);
882         if (to == owner) revert ApprovalToCurrentOwner();
883 
884         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
885             revert ApprovalCallerNotOwnerNorApproved();
886         }
887 
888         _approve(to, tokenId, owner);
889     }
890 
891     function getApproved(uint256 tokenId) public view override returns (address) {
892         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
893 
894         return _tokenApprovals[tokenId];
895     }
896 
897     function setApprovalForAll(address operator, bool approved) public virtual override {
898         if (operator == _msgSender()) revert ApproveToCaller();
899 
900         _operatorApprovals[_msgSender()][operator] = approved;
901         emit ApprovalForAll(_msgSender(), operator, approved);
902     }
903 
904     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
905         return _operatorApprovals[owner][operator];
906     }
907 
908     function transferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public virtual override {
913         _transfer(from, to, tokenId);
914     }
915 
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) public virtual override {
921         safeTransferFrom(from, to, tokenId, '');
922     }
923 
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId,
928         bytes memory _data
929     ) public virtual override {
930         _transfer(from, to, tokenId);
931         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
932             revert TransferToNonERC721ReceiverImplementer();
933         }
934     }
935 
936     function _exists(uint256 tokenId) internal view returns (bool) {
937         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
938     }
939 
940     function _safeMint(address to, uint256 quantity) internal {
941         _safeMint(to, quantity, '');
942     }
943 
944     function _safeMint(
945         address to,
946         uint256 quantity,
947         bytes memory _data
948     ) internal {
949         _mint(to, quantity, _data, true);
950     }
951 
952     function _mint(
953         address to,
954         uint256 quantity,
955         bytes memory _data,
956         bool safe
957     ) internal {
958         uint256 startTokenId = _currentIndex;
959         if (to == address(0)) revert MintToZeroAddress();
960         if (quantity == 0) revert MintZeroQuantity();
961 
962         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
963 
964         unchecked {
965             _addressData[to].balance += uint64(quantity);
966             _addressData[to].numberMinted += uint64(quantity);
967 
968             _ownerships[startTokenId].addr = to;
969             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
970 
971             uint256 updatedIndex = startTokenId;
972             uint256 end = updatedIndex + quantity;
973 
974             if (safe && to.isContract()) {
975                 do {
976                     emit Transfer(address(0), to, updatedIndex);
977                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
978                         revert TransferToNonERC721ReceiverImplementer();
979                     }
980                 } while (updatedIndex != end);
981                 // Reentrancy protection
982                 if (_currentIndex != startTokenId) revert();
983             } else {
984                 do {
985                     emit Transfer(address(0), to, updatedIndex++);
986                 } while (updatedIndex != end);
987             }
988             _currentIndex = updatedIndex;
989         }
990         _afterTokenTransfers(address(0), to, startTokenId, quantity);
991     }
992 
993     function _transfer(
994         address from,
995         address to,
996         uint256 tokenId
997     ) private {
998         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
999 
1000         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1001 
1002         bool isApprovedOrOwner = (_msgSender() == from ||
1003             isApprovedForAll(from, _msgSender()) ||
1004             getApproved(tokenId) == _msgSender());
1005 
1006         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1007         if (to == address(0)) revert TransferToZeroAddress();
1008 
1009         _beforeTokenTransfers(from, to, tokenId, 1);
1010 
1011         // Clear approvals from the previous owner
1012         _approve(address(0), tokenId, from);
1013 
1014         unchecked {
1015             _addressData[from].balance -= 1;
1016             _addressData[to].balance += 1;
1017 
1018             TokenOwnership storage currSlot = _ownerships[tokenId];
1019             currSlot.addr = to;
1020             currSlot.startTimestamp = uint64(block.timestamp);
1021 
1022             uint256 nextTokenId = tokenId + 1;
1023             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1024             if (nextSlot.addr == address(0)) {
1025 
1026                 if (nextTokenId != _currentIndex) {
1027                     nextSlot.addr = from;
1028                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1029                 }
1030             }
1031         }
1032 
1033         emit Transfer(from, to, tokenId);
1034         _afterTokenTransfers(from, to, tokenId, 1);
1035     }
1036 
1037     function _burn(uint256 tokenId) internal virtual {
1038         _burn(tokenId, false);
1039     }
1040 
1041     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1042         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1043 
1044         address from = prevOwnership.addr;
1045 
1046         if (approvalCheck) {
1047             bool isApprovedOrOwner = (_msgSender() == from ||
1048                 isApprovedForAll(from, _msgSender()) ||
1049                 getApproved(tokenId) == _msgSender());
1050 
1051             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1052         }
1053 
1054         _beforeTokenTransfers(from, address(0), tokenId, 1);
1055 
1056         _approve(address(0), tokenId, from);
1057 
1058         unchecked {
1059             AddressData storage addressData = _addressData[from];
1060             addressData.balance -= 1;
1061             addressData.numberBurned += 1;
1062 
1063             TokenOwnership storage currSlot = _ownerships[tokenId];
1064             currSlot.addr = from;
1065             currSlot.startTimestamp = uint64(block.timestamp);
1066             currSlot.burned = true;
1067 
1068             uint256 nextTokenId = tokenId + 1;
1069             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1070             if (nextSlot.addr == address(0)) {
1071 
1072                 if (nextTokenId != _currentIndex) {
1073                     nextSlot.addr = from;
1074                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1075                 }
1076             }
1077         }
1078 
1079         emit Transfer(from, address(0), tokenId);
1080         _afterTokenTransfers(from, address(0), tokenId, 1);
1081 
1082         unchecked {
1083             _burnCounter++;
1084         }
1085     }
1086 
1087     function _approve(
1088         address to,
1089         uint256 tokenId,
1090         address owner
1091     ) private {
1092         _tokenApprovals[tokenId] = to;
1093         emit Approval(owner, to, tokenId);
1094     }
1095 
1096     function _checkContractOnERC721Received(
1097         address from,
1098         address to,
1099         uint256 tokenId,
1100         bytes memory _data
1101     ) private returns (bool) {
1102         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1103             return retval == IERC721Receiver(to).onERC721Received.selector;
1104         } catch (bytes memory reason) {
1105             if (reason.length == 0) {
1106                 revert TransferToNonERC721ReceiverImplementer();
1107             } else {
1108                 assembly {
1109                     revert(add(32, reason), mload(reason))
1110                 }
1111             }
1112         }
1113     }
1114 
1115     function _beforeTokenTransfers(
1116         address from,
1117         address to,
1118         uint256 startTokenId,
1119         uint256 quantity
1120     ) internal virtual {}
1121 
1122     function _afterTokenTransfers(
1123         address from,
1124         address to,
1125         uint256 startTokenId,
1126         uint256 quantity
1127     ) internal virtual {}
1128 }
1129 
1130 pragma solidity ^0.8.4;
1131 
1132 contract BexterLife is ERC721A, Ownable {
1133     using Strings for uint256;
1134     string private baseURI;
1135     string public hiddenMetadataUri;
1136     uint256 public price = 0.015 ether;
1137     uint256 public maxPerTx = 20;
1138     uint256 public maxFreePerWallet = 2;
1139     uint256 public totalFree = 0;
1140     uint256 public maxSupply = 6666;
1141     uint public nextId = 0;
1142     bool public mintEnabled = false;
1143     bool public revealed = true;
1144     mapping(address => uint256) private _mintedFreeAmount;
1145 
1146 constructor() ERC721A("Bexter Life", "Bexter") {
1147         setHiddenMetadataUri("https://api.bexter.life/");
1148         setBaseURI("https://api.bexter.life/");
1149     }
1150 
1151     function mint(uint256 count) external payable {
1152     require(mintEnabled, "Mint not live yet");
1153       uint256 cost = price;
1154       bool isFree =
1155       ((totalSupply() + count < totalFree + 1) &&
1156       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1157 
1158       if (isFree) {
1159       cost = 0;
1160      }
1161 
1162      else {
1163       require(msg.value >= count * price, "Please send the exact amount.");
1164       require(totalSupply() + count <= maxSupply, "No more Mania");
1165       require(count <= maxPerTx, "Max per TX reached.");
1166      }
1167 
1168       if (isFree) {
1169          _mintedFreeAmount[msg.sender] += count;
1170       }
1171 
1172      _safeMint(msg.sender, count);
1173      nextId += count;
1174     }
1175 
1176     function _baseURI() internal view virtual override returns (string memory) {
1177         return baseURI;
1178     }
1179 
1180     function tokenURI(uint256 tokenId)
1181         public
1182         view
1183         virtual
1184         override
1185         returns (string memory)
1186     {
1187         require(
1188             _exists(tokenId),
1189             "ERC721Metadata: URI query for nonexistent token"
1190         );
1191 
1192         if (revealed == false) {
1193          return string(abi.encodePacked(hiddenMetadataUri));
1194         }
1195     
1196         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1197     }
1198 
1199     function setBaseURI(string memory uri) public onlyOwner {
1200         baseURI = uri;
1201     }
1202 
1203     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1204      hiddenMetadataUri = _hiddenMetadataUri;
1205     }
1206 
1207     function setFreeAmount(uint256 amount) external onlyOwner {
1208         totalFree = amount;
1209     }
1210 
1211     function setPrice(uint256 _newPrice) external onlyOwner {
1212         price = _newPrice;
1213     }
1214 
1215     function setRevealed() external onlyOwner {
1216      revealed = !revealed;
1217     }
1218 
1219     function flipSale() external onlyOwner {
1220         mintEnabled = !mintEnabled;
1221     }
1222 
1223     function getNextId() public view returns(uint){
1224      return nextId;
1225     }
1226 
1227     function _startTokenId() internal pure override returns (uint256) {
1228         return 1;
1229     }
1230 
1231     function withdraw() external onlyOwner {
1232         (bool success, ) = payable(msg.sender).call{
1233             value: address(this).balance
1234         }("");
1235         require(success, "Transfer failed.");
1236     }
1237     function setmaxSupply(uint _maxSupply) external onlyOwner {
1238         maxSupply = _maxSupply;
1239     }
1240 
1241     function setmaxFreePerWallet(uint256 _maxFreePerWallet) external onlyOwner {
1242         maxFreePerWallet = _maxFreePerWallet;
1243     }
1244 
1245     function setmaxPerTx(uint256 _maxPerTx) external onlyOwner {
1246         maxPerTx = _maxPerTx;
1247     }
1248 
1249     function MintWhiteList(address to, uint256 quantity)public onlyOwner{
1250     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1251     _safeMint(to, quantity);
1252   }
1253 }