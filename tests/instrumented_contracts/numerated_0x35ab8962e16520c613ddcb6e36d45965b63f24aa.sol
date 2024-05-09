1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6 
7 ██████╗░██╗██████╗░░█████╗░████████╗███████╗  ███████╗████████╗██╗░░██╗
8 ██╔══██╗██║██╔══██╗██╔══██╗╚══██╔══╝██╔════╝  ██╔════╝╚══██╔══╝██║░░██║
9 ██████╔╝██║██████╔╝███████║░░░██║░░░█████╗░░  █████╗░░░░░██║░░░███████║
10 ██╔═══╝░██║██╔══██╗██╔══██║░░░██║░░░██╔══╝░░  ██╔══╝░░░░░██║░░░██╔══██║
11 ██║░░░░░██║██║░░██║██║░░██║░░░██║░░░███████╗  ███████╗░░░██║░░░██║░░██║
12 ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝  ╚══════╝░░░╚═╝░░░╚═╝░░╚═╝
13 
14 ░█████╗░██╗░░██╗███████╗░██████╗████████╗
15 ██╔══██╗██║░░██║██╔════╝██╔════╝╚══██╔══╝
16 ██║░░╚═╝███████║█████╗░░╚█████╗░░░░██║░░░
17 ██║░░██╗██╔══██║██╔══╝░░░╚═══██╗░░░██║░░░
18 ╚█████╔╝██║░░██║███████╗██████╔╝░░░██║░░░
19 ░╚════╝░╚═╝░░╚═╝╚══════╝╚═════╝░░░░╚═╝░░░
20 
21 */
22 
23 library Counters {
24     struct Counter {
25 
26         uint256 _value; // default: 0
27     }
28 
29     function current(Counter storage counter) internal view returns (uint256) {
30         return counter._value;
31     }
32 
33     function increment(Counter storage counter) internal {
34         unchecked {
35             counter._value += 1;
36         }
37     }
38 
39     function decrement(Counter storage counter) internal {
40         uint256 value = counter._value;
41         require(value > 0, "Counter:decrement overflow");
42         unchecked {
43             counter._value = value - 1;
44         }
45     }
46 
47     function reset(Counter storage counter) internal {
48         counter._value = 0;
49     }
50 }
51 
52 pragma solidity ^0.8.0;
53 
54 library Strings {
55     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
59      */
60     function toString(uint256 value) internal pure returns (string memory) {
61         // Inspired by OraclizeAPI's implementation - MIT licence
62         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
63 
64         if (value == 0) {
65             return "0";
66         }
67         uint256 temp = value;
68         uint256 digits;
69         while (temp != 0) {
70             digits++;
71             temp /= 10;
72         }
73         bytes memory buffer = new bytes(digits);
74         while (value != 0) {
75             digits -= 1;
76             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
77             value /= 10;
78         }
79         return string(buffer);
80     }
81 
82     function toHexString(uint256 value) internal pure returns (string memory) {
83         if (value == 0) {
84             return "0x00";
85         }
86         uint256 temp = value;
87         uint256 length = 0;
88         while (temp != 0) {
89             length++;
90             temp >>= 8;
91         }
92         return toHexString(value, length);
93     }
94 
95     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
96         bytes memory buffer = new bytes(2 * length + 2);
97         buffer[0] = "0";
98         buffer[1] = "x";
99         for (uint256 i = 2 * length + 1; i > 1; --i) {
100             buffer[i] = _HEX_SYMBOLS[value & 0xf];
101             value >>= 4;
102         }
103         require(value == 0, "Strings: hex length insufficient");
104         return string(buffer);
105     }
106 }
107 
108 pragma solidity ^0.8.0;
109 
110 abstract contract Context {
111     function _msgSender() internal view virtual returns (address) {
112         return msg.sender;
113     }
114 
115     function _msgData() internal view virtual returns (bytes calldata) {
116         return msg.data;
117     }
118 }
119 
120 pragma solidity ^0.8.0;
121 
122 abstract contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     constructor() {
128         _transferOwnership(_msgSender());
129     }
130 
131     function owner() public view virtual returns (address) {
132         return _owner;
133     }
134 
135     modifier onlyOwner() {
136         require(owner() == _msgSender(), "Ownable: caller is not the owner");
137         _;
138     }
139 
140     function renounceOwnership() public virtual onlyOwner {
141         _transferOwnership(address(0));
142     }
143 
144     function transferOwnership(address newOwner) public virtual onlyOwner {
145         require(newOwner != address(0), "Ownable: new owner is the zero address");
146         _transferOwnership(newOwner);
147     }
148 
149     function _transferOwnership(address newOwner) internal virtual {
150         address oldOwner = _owner;
151         _owner = newOwner;
152         emit OwnershipTransferred(oldOwner, newOwner);
153     }
154 }
155 
156 pragma solidity ^0.8.1;
157 
158 library Address {
159 
160     function isContract(address account) internal view returns (bool) {
161 
162         return account.code.length > 0;
163     }
164 
165     function sendValue(address payable recipient, uint256 amount) internal {
166         require(address(this).balance >= amount, "Address: insufficient balance");
167 
168         (bool success, ) = recipient.call{value: amount}("");
169         require(success, "Address: unable to send value, recipient may have reverted");
170     }
171 
172     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionCall(target, data, "Address: low-level call failed");
174     }
175 
176     function functionCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, 0, errorMessage);
182     }
183 
184     function functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 value
188     ) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
190     }
191 
192     function functionCallWithValue(
193         address target,
194         bytes memory data,
195         uint256 value,
196         string memory errorMessage
197     ) internal returns (bytes memory) {
198         require(address(this).balance >= value, "Address: insufficient balance for call");
199         require(isContract(target), "Address: call to non-contract");
200 
201         (bool success, bytes memory returndata) = target.call{value: value}(data);
202         return verifyCallResult(success, returndata, errorMessage);
203     }
204 
205     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
206         return functionStaticCall(target, data, "Address: low-level static call failed");
207     }
208 
209     function functionStaticCall(
210         address target,
211         bytes memory data,
212         string memory errorMessage
213     ) internal view returns (bytes memory) {
214         require(isContract(target), "Address: static call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.staticcall(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
221         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
222     }
223 
224     function functionDelegateCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal returns (bytes memory) {
229         require(isContract(target), "Address: delegate call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.delegatecall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     function verifyCallResult(
236         bool success,
237         bytes memory returndata,
238         string memory errorMessage
239     ) internal pure returns (bytes memory) {
240         if (success) {
241             return returndata;
242         } else {
243             // Look for revert reason and bubble it up if present
244             if (returndata.length > 0) {
245                 // The easiest way to bubble the revert reason is using memory via assembly
246 
247                 assembly {
248                     let returndata_size := mload(returndata)
249                     revert(add(32, returndata), returndata_size)
250                 }
251             } else {
252                 revert(errorMessage);
253             }
254         }
255     }
256 }
257 
258 pragma solidity ^0.8.0;
259 
260 interface IERC721Receiver {
261 
262     function onERC721Received(
263         address operator,
264         address from,
265         uint256 tokenId,
266         bytes calldata data
267     ) external returns (bytes4);
268 }
269 
270 pragma solidity ^0.8.0;
271 
272 interface IERC165 {
273 
274     function supportsInterface(bytes4 interfaceId) external view returns (bool);
275 }
276 
277 pragma solidity ^0.8.0;
278 
279 abstract contract ERC165 is IERC165 {
280 
281     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
282         return interfaceId == type(IERC165).interfaceId;
283     }
284 }
285 
286 pragma solidity ^0.8.0;
287 
288 interface IERC721 is IERC165 {
289 
290     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
291 
292     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
293 
294     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
295 
296     function balanceOf(address owner) external view returns (uint256 balance);
297 
298     function ownerOf(uint256 tokenId) external view returns (address owner);
299 
300     function safeTransferFrom(
301         address from,
302         address to,
303         uint256 tokenId
304     ) external;
305 
306     function transferFrom(
307         address from,
308         address to,
309         uint256 tokenId
310     ) external;
311 
312     function approve(address to, uint256 tokenId) external;
313 
314     function getApproved(uint256 tokenId) external view returns (address operator);
315 
316     function setApprovalForAll(address operator, bool _approved) external;
317 
318     function isApprovedForAll(address owner, address operator) external view returns (bool);
319 
320     function safeTransferFrom(
321         address from,
322         address to,
323         uint256 tokenId,
324         bytes calldata data
325     ) external;
326 }
327 
328 pragma solidity ^0.8.0;
329 
330 interface IERC721Enumerable is IERC721 {
331 
332     function totalSupply() external view returns (uint256);
333 
334     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
335 
336     function tokenByIndex(uint256 index) external view returns (uint256);
337 }
338 
339 pragma solidity ^0.8.0;
340 
341 interface IERC721Metadata is IERC721 {
342 
343     function name() external view returns (string memory);
344 
345     function symbol() external view returns (string memory);
346 
347     function tokenURI(uint256 tokenId) external view returns (string memory);
348 }
349 
350 pragma solidity ^0.8.0;
351 
352 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
353     using Address for address;
354     using Strings for uint256;
355 
356     // Token name
357     string private _name;
358 
359     // Token symbol
360     string private _symbol;
361 
362     // Mapping from token ID to owner address
363     mapping(uint256 => address) private _owners;
364 
365     // Mapping owner address to token count
366     mapping(address => uint256) private _balances;
367 
368     // Mapping from token ID to approved address
369     mapping(uint256 => address) private _tokenApprovals;
370 
371     // Mapping from owner to operator approvals
372     mapping(address => mapping(address => bool)) private _operatorApprovals;
373 
374     constructor(string memory name_, string memory symbol_) {
375         _name = name_;
376         _symbol = symbol_;
377     }
378 
379     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
380         return
381             interfaceId == type(IERC721).interfaceId ||
382             interfaceId == type(IERC721Metadata).interfaceId ||
383             super.supportsInterface(interfaceId);
384     }
385 
386     function balanceOf(address owner) public view virtual override returns (uint256) {
387         require(owner != address(0), "ERC721: balance query for the zero address");
388         return _balances[owner];
389     }
390 
391     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
392         address owner = _owners[tokenId];
393         require(owner != address(0), "ERC721: owner query for nonexistent token");
394         return owner;
395     }
396 
397     function name() public view virtual override returns (string memory) {
398         return _name;
399     }
400 
401     function symbol() public view virtual override returns (string memory) {
402         return _symbol;
403     }
404 
405     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
406         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
407 
408         string memory baseURI = _baseURI();
409         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
410     }
411 
412     function _baseURI() internal view virtual returns (string memory) {
413         return "";
414     }
415 
416     function approve(address to, uint256 tokenId) public virtual override {
417         address owner = ERC721.ownerOf(tokenId);
418         require(to != owner, "ERC721: approval to current owner");
419 
420         require(
421             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
422             "ERC721: approve caller is not owner nor approved for all"
423         );
424 
425         _approve(to, tokenId);
426     }
427 
428     function getApproved(uint256 tokenId) public view virtual override returns (address) {
429         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
430 
431         return _tokenApprovals[tokenId];
432     }
433 
434     function setApprovalForAll(address operator, bool approved) public virtual override {
435         _setApprovalForAll(_msgSender(), operator, approved);
436     }
437 
438     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
439         return _operatorApprovals[owner][operator];
440     }
441 
442     function transferFrom(
443         address from,
444         address to,
445         uint256 tokenId
446     ) public virtual override {
447         //solhint-disable-next-line max-line-length
448         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
449 
450         _transfer(from, to, tokenId);
451     }
452 
453     function safeTransferFrom(
454         address from,
455         address to,
456         uint256 tokenId
457     ) public virtual override {
458         safeTransferFrom(from, to, tokenId, "");
459     }
460 
461     function safeTransferFrom(
462         address from,
463         address to,
464         uint256 tokenId,
465         bytes memory _data
466     ) public virtual override {
467         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
468         _safeTransfer(from, to, tokenId, _data);
469     }
470 
471     function _safeTransfer(
472         address from,
473         address to,
474         uint256 tokenId,
475         bytes memory _data
476     ) internal virtual {
477         _transfer(from, to, tokenId);
478         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
479     }
480 
481     function _exists(uint256 tokenId) internal view virtual returns (bool) {
482         return _owners[tokenId] != address(0);
483     }
484 
485     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
486         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
487         address owner = ERC721.ownerOf(tokenId);
488         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
489     }
490 
491     function _safeMint(address to, uint256 tokenId) internal virtual {
492         _safeMint(to, tokenId, "");
493     }
494 
495     function _safeMint(
496         address to,
497         uint256 tokenId,
498         bytes memory _data
499     ) internal virtual {
500         _mint(to, tokenId);
501         require(
502             _checkOnERC721Received(address(0), to, tokenId, _data),
503             "ERC721: transfer to non ERC721Receiver implementer"
504         );
505     }
506 
507     function _mint(address to, uint256 tokenId) internal virtual {
508         require(to != address(0), "ERC721: mint to the zero address");
509         require(!_exists(tokenId), "ERC721: token already minted");
510 
511         _beforeTokenTransfer(address(0), to, tokenId);
512 
513         _balances[to] += 1;
514         _owners[tokenId] = to;
515 
516         emit Transfer(address(0), to, tokenId);
517 
518         _afterTokenTransfer(address(0), to, tokenId);
519     }
520 
521     function _burn(uint256 tokenId) internal virtual {
522         address owner = ERC721.ownerOf(tokenId);
523 
524         _beforeTokenTransfer(owner, address(0), tokenId);
525 
526         // Clear approvals
527         _approve(address(0), tokenId);
528 
529         _balances[owner] -= 1;
530         delete _owners[tokenId];
531 
532         emit Transfer(owner, address(0), tokenId);
533 
534         _afterTokenTransfer(owner, address(0), tokenId);
535     }
536 
537     function _transfer(
538         address from,
539         address to,
540         uint256 tokenId
541     ) internal virtual {
542         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
543         require(to != address(0), "ERC721: transfer to the zero address");
544 
545         _beforeTokenTransfer(from, to, tokenId);
546 
547         _approve(address(0), tokenId);
548 
549         _balances[from] -= 1;
550         _balances[to] += 1;
551         _owners[tokenId] = to;
552 
553         emit Transfer(from, to, tokenId);
554 
555         _afterTokenTransfer(from, to, tokenId);
556     }
557 
558     function _approve(address to, uint256 tokenId) internal virtual {
559         _tokenApprovals[tokenId] = to;
560         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
561     }
562 
563     function _setApprovalForAll(
564         address owner,
565         address operator,
566         bool approved
567     ) internal virtual {
568         require(owner != operator, "ERC721: approve to caller");
569         _operatorApprovals[owner][operator] = approved;
570         emit ApprovalForAll(owner, operator, approved);
571     }
572 
573     function _checkOnERC721Received(
574         address from,
575         address to,
576         uint256 tokenId,
577         bytes memory _data
578     ) private returns (bool) {
579         if (to.isContract()) {
580             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
581                 return retval == IERC721Receiver.onERC721Received.selector;
582             } catch (bytes memory reason) {
583                 if (reason.length == 0) {
584                     revert("ERC721: transfer to non ERC721Receiver implementer");
585                 } else {
586                     assembly {
587                         revert(add(32, reason), mload(reason))
588                     }
589                 }
590             }
591         } else {
592             return true;
593         }
594     }
595 
596     function _beforeTokenTransfer(
597         address from,
598         address to,
599         uint256 tokenId
600     ) internal virtual {}
601 
602     function _afterTokenTransfer(
603         address from,
604         address to,
605         uint256 tokenId
606     ) internal virtual {}
607 }
608 
609 pragma solidity ^0.8.0;
610 
611 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
612     // Mapping from owner to list of owned token IDs
613     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
614 
615     // Mapping from token ID to index of the owner tokens list
616     mapping(uint256 => uint256) private _ownedTokensIndex;
617 
618     // Array with all token ids, used for enumeration
619     uint256[] private _allTokens;
620 
621     // Mapping from token id to position in the allTokens array
622     mapping(uint256 => uint256) private _allTokensIndex;
623 
624     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
625         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
626     }
627 
628     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
629         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
630         return _ownedTokens[owner][index];
631     }
632 
633     function totalSupply() public view virtual override returns (uint256) {
634         return _allTokens.length;
635     }
636 
637     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
638         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
639         return _allTokens[index];
640     }
641 
642     function _beforeTokenTransfer(
643         address from,
644         address to,
645         uint256 tokenId
646     ) internal virtual override {
647         super._beforeTokenTransfer(from, to, tokenId);
648 
649         if (from == address(0)) {
650             _addTokenToAllTokensEnumeration(tokenId);
651         } else if (from != to) {
652             _removeTokenFromOwnerEnumeration(from, tokenId);
653         }
654         if (to == address(0)) {
655             _removeTokenFromAllTokensEnumeration(tokenId);
656         } else if (to != from) {
657             _addTokenToOwnerEnumeration(to, tokenId);
658         }
659     }
660 
661     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
662         uint256 length = ERC721.balanceOf(to);
663         _ownedTokens[to][length] = tokenId;
664         _ownedTokensIndex[tokenId] = length;
665     }
666 
667     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
668         _allTokensIndex[tokenId] = _allTokens.length;
669         _allTokens.push(tokenId);
670     }
671 
672     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
673         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
674         // then delete the last slot (swap and pop).
675 
676         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
677         uint256 tokenIndex = _ownedTokensIndex[tokenId];
678 
679         // When the token to delete is the last token, the swap operation is unnecessary
680         if (tokenIndex != lastTokenIndex) {
681             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
682 
683             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
684             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
685         }
686 
687         // This also deletes the contents at the last position of the array
688         delete _ownedTokensIndex[tokenId];
689         delete _ownedTokens[from][lastTokenIndex];
690     }
691 
692     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
693         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
694         // then delete the last slot (swap and pop).
695 
696         uint256 lastTokenIndex = _allTokens.length - 1;
697         uint256 tokenIndex = _allTokensIndex[tokenId];
698 
699         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
700         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
701         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
702         uint256 lastTokenId = _allTokens[lastTokenIndex];
703 
704         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
705         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
706 
707         // This also deletes the contents at the last position of the array
708         delete _allTokensIndex[tokenId];
709         _allTokens.pop();
710     }
711 }
712 
713 pragma solidity ^0.8.4;
714 
715 error ApprovalCallerNotOwnerNorApproved();
716 error ApprovalQueryForNonexistentToken();
717 error ApproveToCaller();
718 error ApprovalToCurrentOwner();
719 error BalanceQueryForZeroAddress();
720 error MintToZeroAddress();
721 error MintZeroQuantity();
722 error OwnerQueryForNonexistentToken();
723 error TransferCallerNotOwnerNorApproved();
724 error TransferFromIncorrectOwner();
725 error TransferToNonERC721ReceiverImplementer();
726 error TransferToZeroAddress();
727 error URIQueryForNonexistentToken();
728 
729 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
730     using Address for address;
731     using Strings for uint256;
732 
733     // Compiler will pack this into a single 256bit word.
734     struct TokenOwnership {
735         // The address of the owner.
736         address addr;
737         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
738         uint64 startTimestamp;
739         // Whether the token has been burned.
740         bool burned;
741     }
742 
743     // Compiler will pack this into a single 256bit word.
744     struct AddressData {
745         // Realistically, 2**64-1 is more than enough.
746         uint64 balance;
747         // Keeps track of mint count with minimal overhead for tokenomics.
748         uint64 numberMinted;
749         // Keeps track of burn count with minimal overhead for tokenomics.
750         uint64 numberBurned;
751         // For miscellaneous variable(s) pertaining to the address
752         // (e.g. number of whitelist mint slots used).
753         // If there are multiple variables, please pack them into a uint64.
754         uint64 aux;
755     }
756 
757     // The tokenId of the next token to be minted.
758     uint256 internal _currentIndex;
759 
760     // The number of tokens burned.
761     uint256 internal _burnCounter;
762 
763     // Token name
764     string private _name;
765 
766     // Token symbol
767     string private _symbol;
768 
769     // Mapping from token ID to ownership details
770     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
771     mapping(uint256 => TokenOwnership) internal _ownerships;
772 
773     // Mapping owner address to address data
774     mapping(address => AddressData) private _addressData;
775 
776     // Mapping from token ID to approved address
777     mapping(uint256 => address) private _tokenApprovals;
778 
779     // Mapping from owner to operator approvals
780     mapping(address => mapping(address => bool)) private _operatorApprovals;
781 
782     constructor(string memory name_, string memory symbol_) {
783         _name = name_;
784         _symbol = symbol_;
785         _currentIndex = _startTokenId();
786     }
787 
788     function _startTokenId() internal view virtual returns (uint256) {
789         return 0;
790     }
791 
792     function totalSupply() public view returns (uint256) {
793         // Counter underflow is impossible as _burnCounter cannot be incremented
794         // more than _currentIndex - _startTokenId() times
795         unchecked {
796             return _currentIndex - _burnCounter - _startTokenId();
797         }
798     }
799 
800     function _totalMinted() internal view returns (uint256) {
801         // Counter underflow is impossible as _currentIndex does not decrement,
802         // and it is initialized to _startTokenId()
803         unchecked {
804             return _currentIndex - _startTokenId();
805         }
806     }
807 
808     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
809         return
810             interfaceId == type(IERC721).interfaceId ||
811             interfaceId == type(IERC721Metadata).interfaceId ||
812             super.supportsInterface(interfaceId);
813     }
814 
815     function balanceOf(address owner) public view override returns (uint256) {
816         if (owner == address(0)) revert BalanceQueryForZeroAddress();
817         return uint256(_addressData[owner].balance);
818     }
819 
820     function _numberMinted(address owner) internal view returns (uint256) {
821         return uint256(_addressData[owner].numberMinted);
822     }
823 
824     function _numberBurned(address owner) internal view returns (uint256) {
825         return uint256(_addressData[owner].numberBurned);
826     }
827 
828     function _getAux(address owner) internal view returns (uint64) {
829         return _addressData[owner].aux;
830     }
831 
832     function _setAux(address owner, uint64 aux) internal {
833         _addressData[owner].aux = aux;
834     }
835 
836     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
837         uint256 curr = tokenId;
838 
839         unchecked {
840             if (_startTokenId() <= curr && curr < _currentIndex) {
841                 TokenOwnership memory ownership = _ownerships[curr];
842                 if (!ownership.burned) {
843                     if (ownership.addr != address(0)) {
844                         return ownership;
845                     }
846 
847                     while (true) {
848                         curr--;
849                         ownership = _ownerships[curr];
850                         if (ownership.addr != address(0)) {
851                             return ownership;
852                         }
853                     }
854                 }
855             }
856         }
857         revert OwnerQueryForNonexistentToken();
858     }
859 
860     function ownerOf(uint256 tokenId) public view override returns (address) {
861         return _ownershipOf(tokenId).addr;
862     }
863 
864     function name() public view virtual override returns (string memory) {
865         return _name;
866     }
867 
868     function symbol() public view virtual override returns (string memory) {
869         return _symbol;
870     }
871 
872     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
873         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
874 
875         string memory baseURI = _baseURI();
876         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
877     }
878 
879     function _baseURI() internal view virtual returns (string memory) {
880         return '';
881     }
882 
883     function approve(address to, uint256 tokenId) public override {
884         address owner = ERC721A.ownerOf(tokenId);
885         if (to == owner) revert ApprovalToCurrentOwner();
886 
887         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
888             revert ApprovalCallerNotOwnerNorApproved();
889         }
890 
891         _approve(to, tokenId, owner);
892     }
893 
894     function getApproved(uint256 tokenId) public view override returns (address) {
895         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
896 
897         return _tokenApprovals[tokenId];
898     }
899 
900     function setApprovalForAll(address operator, bool approved) public virtual override {
901         if (operator == _msgSender()) revert ApproveToCaller();
902 
903         _operatorApprovals[_msgSender()][operator] = approved;
904         emit ApprovalForAll(_msgSender(), operator, approved);
905     }
906 
907     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
908         return _operatorApprovals[owner][operator];
909     }
910 
911     function transferFrom(
912         address from,
913         address to,
914         uint256 tokenId
915     ) public virtual override {
916         _transfer(from, to, tokenId);
917     }
918 
919     function safeTransferFrom(
920         address from,
921         address to,
922         uint256 tokenId
923     ) public virtual override {
924         safeTransferFrom(from, to, tokenId, '');
925     }
926 
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) public virtual override {
933         _transfer(from, to, tokenId);
934         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
935             revert TransferToNonERC721ReceiverImplementer();
936         }
937     }
938 
939     function _exists(uint256 tokenId) internal view returns (bool) {
940         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
941     }
942 
943     function _safeMint(address to, uint256 quantity) internal {
944         _safeMint(to, quantity, '');
945     }
946 
947     function _safeMint(
948         address to,
949         uint256 quantity,
950         bytes memory _data
951     ) internal {
952         _mint(to, quantity, _data, true);
953     }
954 
955     function _mint(
956         address to,
957         uint256 quantity,
958         bytes memory _data,
959         bool safe
960     ) internal {
961         uint256 startTokenId = _currentIndex;
962         if (to == address(0)) revert MintToZeroAddress();
963         if (quantity == 0) revert MintZeroQuantity();
964 
965         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
966 
967         unchecked {
968             _addressData[to].balance += uint64(quantity);
969             _addressData[to].numberMinted += uint64(quantity);
970 
971             _ownerships[startTokenId].addr = to;
972             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
973 
974             uint256 updatedIndex = startTokenId;
975             uint256 end = updatedIndex + quantity;
976 
977             if (safe && to.isContract()) {
978                 do {
979                     emit Transfer(address(0), to, updatedIndex);
980                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
981                         revert TransferToNonERC721ReceiverImplementer();
982                     }
983                 } while (updatedIndex != end);
984                 // Reentrancy protection
985                 if (_currentIndex != startTokenId) revert();
986             } else {
987                 do {
988                     emit Transfer(address(0), to, updatedIndex++);
989                 } while (updatedIndex != end);
990             }
991             _currentIndex = updatedIndex;
992         }
993         _afterTokenTransfers(address(0), to, startTokenId, quantity);
994     }
995 
996     function _transfer(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) private {
1001         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1002 
1003         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1004 
1005         bool isApprovedOrOwner = (_msgSender() == from ||
1006             isApprovedForAll(from, _msgSender()) ||
1007             getApproved(tokenId) == _msgSender());
1008 
1009         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1010         if (to == address(0)) revert TransferToZeroAddress();
1011 
1012         _beforeTokenTransfers(from, to, tokenId, 1);
1013 
1014         // Clear approvals from the previous owner
1015         _approve(address(0), tokenId, from);
1016 
1017         unchecked {
1018             _addressData[from].balance -= 1;
1019             _addressData[to].balance += 1;
1020 
1021             TokenOwnership storage currSlot = _ownerships[tokenId];
1022             currSlot.addr = to;
1023             currSlot.startTimestamp = uint64(block.timestamp);
1024 
1025             uint256 nextTokenId = tokenId + 1;
1026             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1027             if (nextSlot.addr == address(0)) {
1028 
1029                 if (nextTokenId != _currentIndex) {
1030                     nextSlot.addr = from;
1031                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1032                 }
1033             }
1034         }
1035 
1036         emit Transfer(from, to, tokenId);
1037         _afterTokenTransfers(from, to, tokenId, 1);
1038     }
1039 
1040     function _burn(uint256 tokenId) internal virtual {
1041         _burn(tokenId, false);
1042     }
1043 
1044     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1045         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1046 
1047         address from = prevOwnership.addr;
1048 
1049         if (approvalCheck) {
1050             bool isApprovedOrOwner = (_msgSender() == from ||
1051                 isApprovedForAll(from, _msgSender()) ||
1052                 getApproved(tokenId) == _msgSender());
1053 
1054             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1055         }
1056 
1057         _beforeTokenTransfers(from, address(0), tokenId, 1);
1058 
1059         _approve(address(0), tokenId, from);
1060 
1061         unchecked {
1062             AddressData storage addressData = _addressData[from];
1063             addressData.balance -= 1;
1064             addressData.numberBurned += 1;
1065 
1066             TokenOwnership storage currSlot = _ownerships[tokenId];
1067             currSlot.addr = from;
1068             currSlot.startTimestamp = uint64(block.timestamp);
1069             currSlot.burned = true;
1070 
1071             uint256 nextTokenId = tokenId + 1;
1072             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1073             if (nextSlot.addr == address(0)) {
1074 
1075                 if (nextTokenId != _currentIndex) {
1076                     nextSlot.addr = from;
1077                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1078                 }
1079             }
1080         }
1081 
1082         emit Transfer(from, address(0), tokenId);
1083         _afterTokenTransfers(from, address(0), tokenId, 1);
1084 
1085         unchecked {
1086             _burnCounter++;
1087         }
1088     }
1089 
1090     function _approve(
1091         address to,
1092         uint256 tokenId,
1093         address owner
1094     ) private {
1095         _tokenApprovals[tokenId] = to;
1096         emit Approval(owner, to, tokenId);
1097     }
1098 
1099     function _checkContractOnERC721Received(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) private returns (bool) {
1105         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1106             return retval == IERC721Receiver(to).onERC721Received.selector;
1107         } catch (bytes memory reason) {
1108             if (reason.length == 0) {
1109                 revert TransferToNonERC721ReceiverImplementer();
1110             } else {
1111                 assembly {
1112                     revert(add(32, reason), mload(reason))
1113                 }
1114             }
1115         }
1116     }
1117 
1118     function _beforeTokenTransfers(
1119         address from,
1120         address to,
1121         uint256 startTokenId,
1122         uint256 quantity
1123     ) internal virtual {}
1124 
1125     function _afterTokenTransfers(
1126         address from,
1127         address to,
1128         uint256 startTokenId,
1129         uint256 quantity
1130     ) internal virtual {}
1131 }
1132 
1133 pragma solidity ^0.8.4;
1134 
1135 contract PirateChest is ERC721A, Ownable {
1136     using Strings for uint256;
1137     string private baseURI;
1138     string public hiddenMetadataUri;
1139     uint256 public price = 0.01 ether;
1140     uint256 public maxPerTx = 10;
1141     uint256 public maxFreePerWallet = 2;
1142     uint256 public totalFree = 4444;
1143     uint256 public maxSupply = 4444;
1144     uint public nextId = 0;
1145     bool public mintEnabled = false;
1146     bool public revealed = true;
1147     mapping(address => uint256) private _mintedFreeAmount;
1148 
1149 constructor() ERC721A("Pirate ETH Chest", "CHEST") {
1150         setHiddenMetadataUri("https://api.piratechest.xyz/");
1151         setBaseURI("https://api.piratechest.xyz/");
1152     }
1153 
1154     function mint(uint256 count) external payable {
1155     require(mintEnabled, "Mint not live yet");
1156       uint256 cost = price;
1157       bool isFree =
1158       ((totalSupply() + count < totalFree + 1) &&
1159       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1160 
1161       if (isFree) {
1162       cost = 0;
1163      }
1164 
1165      else {
1166       require(msg.value >= count * price, "Please send the exact amount.");
1167       require(totalSupply() + count <= maxSupply, "No more Chest");
1168       require(count <= maxPerTx, "Max per TX reached.");
1169      }
1170 
1171       if (isFree) {
1172          _mintedFreeAmount[msg.sender] += count;
1173       }
1174 
1175      _safeMint(msg.sender, count);
1176      nextId += count;
1177     }
1178 
1179     function _baseURI() internal view virtual override returns (string memory) {
1180         return baseURI;
1181     }
1182 
1183     function tokenURI(uint256 tokenId)
1184         public
1185         view
1186         virtual
1187         override
1188         returns (string memory)
1189     {
1190         require(
1191             _exists(tokenId),
1192             "ERC721Metadata: URI query for nonexistent token"
1193         );
1194 
1195         if (revealed == false) {
1196          return string(abi.encodePacked(hiddenMetadataUri));
1197         }
1198     
1199         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1200     }
1201 
1202     function setBaseURI(string memory uri) public onlyOwner {
1203         baseURI = uri;
1204     }
1205 
1206     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1207      hiddenMetadataUri = _hiddenMetadataUri;
1208     }
1209 
1210     function setFreeAmount(uint256 amount) external onlyOwner {
1211         totalFree = amount;
1212     }
1213 
1214     function setPrice(uint256 _newPrice) external onlyOwner {
1215         price = _newPrice;
1216     }
1217 
1218     function setRevealed() external onlyOwner {
1219      revealed = !revealed;
1220     }
1221 
1222     function flipSale() external onlyOwner {
1223         mintEnabled = !mintEnabled;
1224     }
1225 
1226     function getNextId() public view returns(uint){
1227      return nextId;
1228     }
1229 
1230     function _startTokenId() internal pure override returns (uint256) {
1231         return 1;
1232     }
1233 
1234     function withdraw() external onlyOwner {
1235         (bool success, ) = payable(msg.sender).call{
1236             value: address(this).balance
1237         }("");
1238         require(success, "Transfer failed.");
1239     }
1240     function setmaxSupply(uint _maxSupply) external onlyOwner {
1241         maxSupply = _maxSupply;
1242     }
1243 
1244     function setmaxFreePerWallet(uint256 _maxFreePerWallet) external onlyOwner {
1245         maxFreePerWallet = _maxFreePerWallet;
1246     }
1247 
1248     function setmaxPerTx(uint256 _maxPerTx) external onlyOwner {
1249         maxPerTx = _maxPerTx;
1250     }
1251 
1252     function MintFreeWhiteList(address to, uint256 quantity)public onlyOwner{
1253     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1254     _safeMint(to, quantity);
1255   }
1256 }