1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 (¯´•._.• т𝐫ｉｐ𝕡𝔦ภ 'ғά𝒾яƳ •._.•´¯)
6 
7 */
8 
9 
10 pragma solidity ^0.8.0;
11 
12 library Counters {
13     struct Counter {
14 
15         uint256 _value; // default: 0
16     }
17 
18     function current(Counter storage counter) internal view returns (uint256) {
19         return counter._value;
20     }
21 
22     function increment(Counter storage counter) internal {
23         unchecked {
24             counter._value += 1;
25         }
26     }
27 
28     function decrement(Counter storage counter) internal {
29         uint256 value = counter._value;
30         require(value > 0, "Counter:decrement overflow");
31         unchecked {
32             counter._value = value - 1;
33         }
34     }
35 
36     function reset(Counter storage counter) internal {
37         counter._value = 0;
38     }
39 }
40 
41 pragma solidity ^0.8.0;
42 
43 library Strings {
44     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
45 
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
48      */
49     function toString(uint256 value) internal pure returns (string memory) {
50         // Inspired by OraclizeAPI's implementation - MIT licence
51         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
52 
53         if (value == 0) {
54             return "0";
55         }
56         uint256 temp = value;
57         uint256 digits;
58         while (temp != 0) {
59             digits++;
60             temp /= 10;
61         }
62         bytes memory buffer = new bytes(digits);
63         while (value != 0) {
64             digits -= 1;
65             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
66             value /= 10;
67         }
68         return string(buffer);
69     }
70 
71     function toHexString(uint256 value) internal pure returns (string memory) {
72         if (value == 0) {
73             return "0x00";
74         }
75         uint256 temp = value;
76         uint256 length = 0;
77         while (temp != 0) {
78             length++;
79             temp >>= 8;
80         }
81         return toHexString(value, length);
82     }
83 
84     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
85         bytes memory buffer = new bytes(2 * length + 2);
86         buffer[0] = "0";
87         buffer[1] = "x";
88         for (uint256 i = 2 * length + 1; i > 1; --i) {
89             buffer[i] = _HEX_SYMBOLS[value & 0xf];
90             value >>= 4;
91         }
92         require(value == 0, "Strings: hex length insufficient");
93         return string(buffer);
94     }
95 }
96 
97 pragma solidity ^0.8.0;
98 
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes calldata) {
105         return msg.data;
106     }
107 }
108 
109 pragma solidity ^0.8.0;
110 
111 abstract contract Ownable is Context {
112     address private _owner;
113 
114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115 
116     constructor() {
117         _transferOwnership(_msgSender());
118     }
119 
120     function owner() public view virtual returns (address) {
121         return _owner;
122     }
123 
124     modifier onlyOwner() {
125         require(owner() == _msgSender(), "Ownable: caller is not the owner");
126         _;
127     }
128 
129     function renounceOwnership() public virtual onlyOwner {
130         _transferOwnership(address(0));
131     }
132 
133     function transferOwnership(address newOwner) public virtual onlyOwner {
134         require(newOwner != address(0), "Ownable: new owner is the zero address");
135         _transferOwnership(newOwner);
136     }
137 
138     function _transferOwnership(address newOwner) internal virtual {
139         address oldOwner = _owner;
140         _owner = newOwner;
141         emit OwnershipTransferred(oldOwner, newOwner);
142     }
143 }
144 
145 pragma solidity ^0.8.1;
146 
147 library Address {
148 
149     function isContract(address account) internal view returns (bool) {
150 
151         return account.code.length > 0;
152     }
153 
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         (bool success, ) = recipient.call{value: amount}("");
158         require(success, "Address: unable to send value, recipient may have reverted");
159     }
160 
161     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
162         return functionCall(target, data, "Address: low-level call failed");
163     }
164 
165     function functionCall(
166         address target,
167         bytes memory data,
168         string memory errorMessage
169     ) internal returns (bytes memory) {
170         return functionCallWithValue(target, data, 0, errorMessage);
171     }
172 
173     function functionCallWithValue(
174         address target,
175         bytes memory data,
176         uint256 value
177     ) internal returns (bytes memory) {
178         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
179     }
180 
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(address(this).balance >= value, "Address: insufficient balance for call");
188         require(isContract(target), "Address: call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.call{value: value}(data);
191         return verifyCallResult(success, returndata, errorMessage);
192     }
193 
194     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
195         return functionStaticCall(target, data, "Address: low-level static call failed");
196     }
197 
198     function functionStaticCall(
199         address target,
200         bytes memory data,
201         string memory errorMessage
202     ) internal view returns (bytes memory) {
203         require(isContract(target), "Address: static call to non-contract");
204 
205         (bool success, bytes memory returndata) = target.staticcall(data);
206         return verifyCallResult(success, returndata, errorMessage);
207     }
208 
209     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
210         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
211     }
212 
213     function functionDelegateCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         require(isContract(target), "Address: delegate call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.delegatecall(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     function verifyCallResult(
225         bool success,
226         bytes memory returndata,
227         string memory errorMessage
228     ) internal pure returns (bytes memory) {
229         if (success) {
230             return returndata;
231         } else {
232             // Look for revert reason and bubble it up if present
233             if (returndata.length > 0) {
234                 // The easiest way to bubble the revert reason is using memory via assembly
235 
236                 assembly {
237                     let returndata_size := mload(returndata)
238                     revert(add(32, returndata), returndata_size)
239                 }
240             } else {
241                 revert(errorMessage);
242             }
243         }
244     }
245 }
246 
247 pragma solidity ^0.8.0;
248 
249 interface IERC721Receiver {
250 
251     function onERC721Received(
252         address operator,
253         address from,
254         uint256 tokenId,
255         bytes calldata data
256     ) external returns (bytes4);
257 }
258 
259 pragma solidity ^0.8.0;
260 
261 interface IERC165 {
262 
263     function supportsInterface(bytes4 interfaceId) external view returns (bool);
264 }
265 
266 pragma solidity ^0.8.0;
267 
268 abstract contract ERC165 is IERC165 {
269 
270     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
271         return interfaceId == type(IERC165).interfaceId;
272     }
273 }
274 
275 pragma solidity ^0.8.0;
276 
277 interface IERC721 is IERC165 {
278 
279     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
280 
281     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
282 
283     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
284 
285     function balanceOf(address owner) external view returns (uint256 balance);
286 
287     function ownerOf(uint256 tokenId) external view returns (address owner);
288 
289     function safeTransferFrom(
290         address from,
291         address to,
292         uint256 tokenId
293     ) external;
294 
295     function transferFrom(
296         address from,
297         address to,
298         uint256 tokenId
299     ) external;
300 
301     function approve(address to, uint256 tokenId) external;
302 
303     function getApproved(uint256 tokenId) external view returns (address operator);
304 
305     function setApprovalForAll(address operator, bool _approved) external;
306 
307     function isApprovedForAll(address owner, address operator) external view returns (bool);
308 
309     function safeTransferFrom(
310         address from,
311         address to,
312         uint256 tokenId,
313         bytes calldata data
314     ) external;
315 }
316 
317 pragma solidity ^0.8.0;
318 
319 interface IERC721Enumerable is IERC721 {
320 
321     function totalSupply() external view returns (uint256);
322 
323     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
324 
325     function tokenByIndex(uint256 index) external view returns (uint256);
326 }
327 
328 pragma solidity ^0.8.0;
329 
330 interface IERC721Metadata is IERC721 {
331 
332     function name() external view returns (string memory);
333 
334     function symbol() external view returns (string memory);
335 
336     function tokenURI(uint256 tokenId) external view returns (string memory);
337 }
338 
339 pragma solidity ^0.8.0;
340 
341 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
342     using Address for address;
343     using Strings for uint256;
344 
345     // Token name
346     string private _name;
347 
348     // Token symbol
349     string private _symbol;
350 
351     // Mapping from token ID to owner address
352     mapping(uint256 => address) private _owners;
353 
354     // Mapping owner address to token count
355     mapping(address => uint256) private _balances;
356 
357     // Mapping from token ID to approved address
358     mapping(uint256 => address) private _tokenApprovals;
359 
360     // Mapping from owner to operator approvals
361     mapping(address => mapping(address => bool)) private _operatorApprovals;
362 
363     constructor(string memory name_, string memory symbol_) {
364         _name = name_;
365         _symbol = symbol_;
366     }
367 
368     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
369         return
370             interfaceId == type(IERC721).interfaceId ||
371             interfaceId == type(IERC721Metadata).interfaceId ||
372             super.supportsInterface(interfaceId);
373     }
374 
375     function balanceOf(address owner) public view virtual override returns (uint256) {
376         require(owner != address(0), "ERC721: balance query for the zero address");
377         return _balances[owner];
378     }
379 
380     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
381         address owner = _owners[tokenId];
382         require(owner != address(0), "ERC721: owner query for nonexistent token");
383         return owner;
384     }
385 
386     function name() public view virtual override returns (string memory) {
387         return _name;
388     }
389 
390     function symbol() public view virtual override returns (string memory) {
391         return _symbol;
392     }
393 
394     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
395         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
396 
397         string memory baseURI = _baseURI();
398         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
399     }
400 
401     function _baseURI() internal view virtual returns (string memory) {
402         return "";
403     }
404 
405     function approve(address to, uint256 tokenId) public virtual override {
406         address owner = ERC721.ownerOf(tokenId);
407         require(to != owner, "ERC721: approval to current owner");
408 
409         require(
410             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
411             "ERC721: approve caller is not owner nor approved for all"
412         );
413 
414         _approve(to, tokenId);
415     }
416 
417     function getApproved(uint256 tokenId) public view virtual override returns (address) {
418         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
419 
420         return _tokenApprovals[tokenId];
421     }
422 
423     function setApprovalForAll(address operator, bool approved) public virtual override {
424         _setApprovalForAll(_msgSender(), operator, approved);
425     }
426 
427     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
428         return _operatorApprovals[owner][operator];
429     }
430 
431     function transferFrom(
432         address from,
433         address to,
434         uint256 tokenId
435     ) public virtual override {
436         //solhint-disable-next-line max-line-length
437         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
438 
439         _transfer(from, to, tokenId);
440     }
441 
442     function safeTransferFrom(
443         address from,
444         address to,
445         uint256 tokenId
446     ) public virtual override {
447         safeTransferFrom(from, to, tokenId, "");
448     }
449 
450     function safeTransferFrom(
451         address from,
452         address to,
453         uint256 tokenId,
454         bytes memory _data
455     ) public virtual override {
456         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
457         _safeTransfer(from, to, tokenId, _data);
458     }
459 
460     function _safeTransfer(
461         address from,
462         address to,
463         uint256 tokenId,
464         bytes memory _data
465     ) internal virtual {
466         _transfer(from, to, tokenId);
467         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
468     }
469 
470     function _exists(uint256 tokenId) internal view virtual returns (bool) {
471         return _owners[tokenId] != address(0);
472     }
473 
474     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
475         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
476         address owner = ERC721.ownerOf(tokenId);
477         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
478     }
479 
480     function _safeMint(address to, uint256 tokenId) internal virtual {
481         _safeMint(to, tokenId, "");
482     }
483 
484     function _safeMint(
485         address to,
486         uint256 tokenId,
487         bytes memory _data
488     ) internal virtual {
489         _mint(to, tokenId);
490         require(
491             _checkOnERC721Received(address(0), to, tokenId, _data),
492             "ERC721: transfer to non ERC721Receiver implementer"
493         );
494     }
495 
496     function _mint(address to, uint256 tokenId) internal virtual {
497         require(to != address(0), "ERC721: mint to the zero address");
498         require(!_exists(tokenId), "ERC721: token already minted");
499 
500         _beforeTokenTransfer(address(0), to, tokenId);
501 
502         _balances[to] += 1;
503         _owners[tokenId] = to;
504 
505         emit Transfer(address(0), to, tokenId);
506 
507         _afterTokenTransfer(address(0), to, tokenId);
508     }
509 
510     function _burn(uint256 tokenId) internal virtual {
511         address owner = ERC721.ownerOf(tokenId);
512 
513         _beforeTokenTransfer(owner, address(0), tokenId);
514 
515         // Clear approvals
516         _approve(address(0), tokenId);
517 
518         _balances[owner] -= 1;
519         delete _owners[tokenId];
520 
521         emit Transfer(owner, address(0), tokenId);
522 
523         _afterTokenTransfer(owner, address(0), tokenId);
524     }
525 
526     function _transfer(
527         address from,
528         address to,
529         uint256 tokenId
530     ) internal virtual {
531         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
532         require(to != address(0), "ERC721: transfer to the zero address");
533 
534         _beforeTokenTransfer(from, to, tokenId);
535 
536         _approve(address(0), tokenId);
537 
538         _balances[from] -= 1;
539         _balances[to] += 1;
540         _owners[tokenId] = to;
541 
542         emit Transfer(from, to, tokenId);
543 
544         _afterTokenTransfer(from, to, tokenId);
545     }
546 
547     function _approve(address to, uint256 tokenId) internal virtual {
548         _tokenApprovals[tokenId] = to;
549         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
550     }
551 
552     function _setApprovalForAll(
553         address owner,
554         address operator,
555         bool approved
556     ) internal virtual {
557         require(owner != operator, "ERC721: approve to caller");
558         _operatorApprovals[owner][operator] = approved;
559         emit ApprovalForAll(owner, operator, approved);
560     }
561 
562     function _checkOnERC721Received(
563         address from,
564         address to,
565         uint256 tokenId,
566         bytes memory _data
567     ) private returns (bool) {
568         if (to.isContract()) {
569             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
570                 return retval == IERC721Receiver.onERC721Received.selector;
571             } catch (bytes memory reason) {
572                 if (reason.length == 0) {
573                     revert("ERC721: transfer to non ERC721Receiver implementer");
574                 } else {
575                     assembly {
576                         revert(add(32, reason), mload(reason))
577                     }
578                 }
579             }
580         } else {
581             return true;
582         }
583     }
584 
585     function _beforeTokenTransfer(
586         address from,
587         address to,
588         uint256 tokenId
589     ) internal virtual {}
590 
591     function _afterTokenTransfer(
592         address from,
593         address to,
594         uint256 tokenId
595     ) internal virtual {}
596 }
597 
598 pragma solidity ^0.8.0;
599 
600 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
601     // Mapping from owner to list of owned token IDs
602     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
603 
604     // Mapping from token ID to index of the owner tokens list
605     mapping(uint256 => uint256) private _ownedTokensIndex;
606 
607     // Array with all token ids, used for enumeration
608     uint256[] private _allTokens;
609 
610     // Mapping from token id to position in the allTokens array
611     mapping(uint256 => uint256) private _allTokensIndex;
612 
613     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
614         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
615     }
616 
617     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
618         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
619         return _ownedTokens[owner][index];
620     }
621 
622     function totalSupply() public view virtual override returns (uint256) {
623         return _allTokens.length;
624     }
625 
626     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
627         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
628         return _allTokens[index];
629     }
630 
631     function _beforeTokenTransfer(
632         address from,
633         address to,
634         uint256 tokenId
635     ) internal virtual override {
636         super._beforeTokenTransfer(from, to, tokenId);
637 
638         if (from == address(0)) {
639             _addTokenToAllTokensEnumeration(tokenId);
640         } else if (from != to) {
641             _removeTokenFromOwnerEnumeration(from, tokenId);
642         }
643         if (to == address(0)) {
644             _removeTokenFromAllTokensEnumeration(tokenId);
645         } else if (to != from) {
646             _addTokenToOwnerEnumeration(to, tokenId);
647         }
648     }
649 
650     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
651         uint256 length = ERC721.balanceOf(to);
652         _ownedTokens[to][length] = tokenId;
653         _ownedTokensIndex[tokenId] = length;
654     }
655 
656     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
657         _allTokensIndex[tokenId] = _allTokens.length;
658         _allTokens.push(tokenId);
659     }
660 
661     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
662         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
663         // then delete the last slot (swap and pop).
664 
665         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
666         uint256 tokenIndex = _ownedTokensIndex[tokenId];
667 
668         // When the token to delete is the last token, the swap operation is unnecessary
669         if (tokenIndex != lastTokenIndex) {
670             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
671 
672             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
673             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
674         }
675 
676         // This also deletes the contents at the last position of the array
677         delete _ownedTokensIndex[tokenId];
678         delete _ownedTokens[from][lastTokenIndex];
679     }
680 
681     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
682         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
683         // then delete the last slot (swap and pop).
684 
685         uint256 lastTokenIndex = _allTokens.length - 1;
686         uint256 tokenIndex = _allTokensIndex[tokenId];
687 
688         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
689         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
690         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
691         uint256 lastTokenId = _allTokens[lastTokenIndex];
692 
693         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
694         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
695 
696         // This also deletes the contents at the last position of the array
697         delete _allTokensIndex[tokenId];
698         _allTokens.pop();
699     }
700 }
701 
702 pragma solidity ^0.8.4;
703 
704 error ApprovalCallerNotOwnerNorApproved();
705 error ApprovalQueryForNonexistentToken();
706 error ApproveToCaller();
707 error ApprovalToCurrentOwner();
708 error BalanceQueryForZeroAddress();
709 error MintToZeroAddress();
710 error MintZeroQuantity();
711 error OwnerQueryForNonexistentToken();
712 error TransferCallerNotOwnerNorApproved();
713 error TransferFromIncorrectOwner();
714 error TransferToNonERC721ReceiverImplementer();
715 error TransferToZeroAddress();
716 error URIQueryForNonexistentToken();
717 
718 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
719     using Address for address;
720     using Strings for uint256;
721 
722     // Compiler will pack this into a single 256bit word.
723     struct TokenOwnership {
724         // The address of the owner.
725         address addr;
726         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
727         uint64 startTimestamp;
728         // Whether the token has been burned.
729         bool burned;
730     }
731 
732     // Compiler will pack this into a single 256bit word.
733     struct AddressData {
734         // Realistically, 2**64-1 is more than enough.
735         uint64 balance;
736         // Keeps track of mint count with minimal overhead for tokenomics.
737         uint64 numberMinted;
738         // Keeps track of burn count with minimal overhead for tokenomics.
739         uint64 numberBurned;
740         // For miscellaneous variable(s) pertaining to the address
741         // (e.g. number of whitelist mint slots used).
742         // If there are multiple variables, please pack them into a uint64.
743         uint64 aux;
744     }
745 
746     // The tokenId of the next token to be minted.
747     uint256 internal _currentIndex;
748 
749     // The number of tokens burned.
750     uint256 internal _burnCounter;
751 
752     // Token name
753     string private _name;
754 
755     // Token symbol
756     string private _symbol;
757 
758     // Mapping from token ID to ownership details
759     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
760     mapping(uint256 => TokenOwnership) internal _ownerships;
761 
762     // Mapping owner address to address data
763     mapping(address => AddressData) private _addressData;
764 
765     // Mapping from token ID to approved address
766     mapping(uint256 => address) private _tokenApprovals;
767 
768     // Mapping from owner to operator approvals
769     mapping(address => mapping(address => bool)) private _operatorApprovals;
770 
771     constructor(string memory name_, string memory symbol_) {
772         _name = name_;
773         _symbol = symbol_;
774         _currentIndex = _startTokenId();
775     }
776 
777     function _startTokenId() internal view virtual returns (uint256) {
778         return 0;
779     }
780 
781     function totalSupply() public view returns (uint256) {
782         // Counter underflow is impossible as _burnCounter cannot be incremented
783         // more than _currentIndex - _startTokenId() times
784         unchecked {
785             return _currentIndex - _burnCounter - _startTokenId();
786         }
787     }
788 
789     function _totalMinted() internal view returns (uint256) {
790         // Counter underflow is impossible as _currentIndex does not decrement,
791         // and it is initialized to _startTokenId()
792         unchecked {
793             return _currentIndex - _startTokenId();
794         }
795     }
796 
797     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
798         return
799             interfaceId == type(IERC721).interfaceId ||
800             interfaceId == type(IERC721Metadata).interfaceId ||
801             super.supportsInterface(interfaceId);
802     }
803 
804     function balanceOf(address owner) public view override returns (uint256) {
805         if (owner == address(0)) revert BalanceQueryForZeroAddress();
806         return uint256(_addressData[owner].balance);
807     }
808 
809     function _numberMinted(address owner) internal view returns (uint256) {
810         return uint256(_addressData[owner].numberMinted);
811     }
812 
813     function _numberBurned(address owner) internal view returns (uint256) {
814         return uint256(_addressData[owner].numberBurned);
815     }
816 
817     function _getAux(address owner) internal view returns (uint64) {
818         return _addressData[owner].aux;
819     }
820 
821     function _setAux(address owner, uint64 aux) internal {
822         _addressData[owner].aux = aux;
823     }
824 
825     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
826         uint256 curr = tokenId;
827 
828         unchecked {
829             if (_startTokenId() <= curr && curr < _currentIndex) {
830                 TokenOwnership memory ownership = _ownerships[curr];
831                 if (!ownership.burned) {
832                     if (ownership.addr != address(0)) {
833                         return ownership;
834                     }
835 
836                     while (true) {
837                         curr--;
838                         ownership = _ownerships[curr];
839                         if (ownership.addr != address(0)) {
840                             return ownership;
841                         }
842                     }
843                 }
844             }
845         }
846         revert OwnerQueryForNonexistentToken();
847     }
848 
849     function ownerOf(uint256 tokenId) public view override returns (address) {
850         return _ownershipOf(tokenId).addr;
851     }
852 
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     function symbol() public view virtual override returns (string memory) {
858         return _symbol;
859     }
860 
861     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
862         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
863 
864         string memory baseURI = _baseURI();
865         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
866     }
867 
868     function _baseURI() internal view virtual returns (string memory) {
869         return '';
870     }
871 
872     function approve(address to, uint256 tokenId) public override {
873         address owner = ERC721A.ownerOf(tokenId);
874         if (to == owner) revert ApprovalToCurrentOwner();
875 
876         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
877             revert ApprovalCallerNotOwnerNorApproved();
878         }
879 
880         _approve(to, tokenId, owner);
881     }
882 
883     function getApproved(uint256 tokenId) public view override returns (address) {
884         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
885 
886         return _tokenApprovals[tokenId];
887     }
888 
889     function setApprovalForAll(address operator, bool approved) public virtual override {
890         if (operator == _msgSender()) revert ApproveToCaller();
891 
892         _operatorApprovals[_msgSender()][operator] = approved;
893         emit ApprovalForAll(_msgSender(), operator, approved);
894     }
895 
896     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
897         return _operatorApprovals[owner][operator];
898     }
899 
900     function transferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public virtual override {
905         _transfer(from, to, tokenId);
906     }
907 
908     function safeTransferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public virtual override {
913         safeTransferFrom(from, to, tokenId, '');
914     }
915 
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId,
920         bytes memory _data
921     ) public virtual override {
922         _transfer(from, to, tokenId);
923         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
924             revert TransferToNonERC721ReceiverImplementer();
925         }
926     }
927 
928     function _exists(uint256 tokenId) internal view returns (bool) {
929         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
930     }
931 
932     function _safeMint(address to, uint256 quantity) internal {
933         _safeMint(to, quantity, '');
934     }
935 
936     function _safeMint(
937         address to,
938         uint256 quantity,
939         bytes memory _data
940     ) internal {
941         _mint(to, quantity, _data, true);
942     }
943 
944     function _mint(
945         address to,
946         uint256 quantity,
947         bytes memory _data,
948         bool safe
949     ) internal {
950         uint256 startTokenId = _currentIndex;
951         if (to == address(0)) revert MintToZeroAddress();
952         if (quantity == 0) revert MintZeroQuantity();
953 
954         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
955 
956         unchecked {
957             _addressData[to].balance += uint64(quantity);
958             _addressData[to].numberMinted += uint64(quantity);
959 
960             _ownerships[startTokenId].addr = to;
961             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
962 
963             uint256 updatedIndex = startTokenId;
964             uint256 end = updatedIndex + quantity;
965 
966             if (safe && to.isContract()) {
967                 do {
968                     emit Transfer(address(0), to, updatedIndex);
969                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
970                         revert TransferToNonERC721ReceiverImplementer();
971                     }
972                 } while (updatedIndex != end);
973                 // Reentrancy protection
974                 if (_currentIndex != startTokenId) revert();
975             } else {
976                 do {
977                     emit Transfer(address(0), to, updatedIndex++);
978                 } while (updatedIndex != end);
979             }
980             _currentIndex = updatedIndex;
981         }
982         _afterTokenTransfers(address(0), to, startTokenId, quantity);
983     }
984 
985     function _transfer(
986         address from,
987         address to,
988         uint256 tokenId
989     ) private {
990         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
991 
992         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
993 
994         bool isApprovedOrOwner = (_msgSender() == from ||
995             isApprovedForAll(from, _msgSender()) ||
996             getApproved(tokenId) == _msgSender());
997 
998         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
999         if (to == address(0)) revert TransferToZeroAddress();
1000 
1001         _beforeTokenTransfers(from, to, tokenId, 1);
1002 
1003         // Clear approvals from the previous owner
1004         _approve(address(0), tokenId, from);
1005 
1006         unchecked {
1007             _addressData[from].balance -= 1;
1008             _addressData[to].balance += 1;
1009 
1010             TokenOwnership storage currSlot = _ownerships[tokenId];
1011             currSlot.addr = to;
1012             currSlot.startTimestamp = uint64(block.timestamp);
1013 
1014             uint256 nextTokenId = tokenId + 1;
1015             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1016             if (nextSlot.addr == address(0)) {
1017 
1018                 if (nextTokenId != _currentIndex) {
1019                     nextSlot.addr = from;
1020                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1021                 }
1022             }
1023         }
1024 
1025         emit Transfer(from, to, tokenId);
1026         _afterTokenTransfers(from, to, tokenId, 1);
1027     }
1028 
1029     function _burn(uint256 tokenId) internal virtual {
1030         _burn(tokenId, false);
1031     }
1032 
1033     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1034         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1035 
1036         address from = prevOwnership.addr;
1037 
1038         if (approvalCheck) {
1039             bool isApprovedOrOwner = (_msgSender() == from ||
1040                 isApprovedForAll(from, _msgSender()) ||
1041                 getApproved(tokenId) == _msgSender());
1042 
1043             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1044         }
1045 
1046         _beforeTokenTransfers(from, address(0), tokenId, 1);
1047 
1048         _approve(address(0), tokenId, from);
1049 
1050         unchecked {
1051             AddressData storage addressData = _addressData[from];
1052             addressData.balance -= 1;
1053             addressData.numberBurned += 1;
1054 
1055             TokenOwnership storage currSlot = _ownerships[tokenId];
1056             currSlot.addr = from;
1057             currSlot.startTimestamp = uint64(block.timestamp);
1058             currSlot.burned = true;
1059 
1060             uint256 nextTokenId = tokenId + 1;
1061             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1062             if (nextSlot.addr == address(0)) {
1063 
1064                 if (nextTokenId != _currentIndex) {
1065                     nextSlot.addr = from;
1066                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1067                 }
1068             }
1069         }
1070 
1071         emit Transfer(from, address(0), tokenId);
1072         _afterTokenTransfers(from, address(0), tokenId, 1);
1073 
1074         unchecked {
1075             _burnCounter++;
1076         }
1077     }
1078 
1079     function _approve(
1080         address to,
1081         uint256 tokenId,
1082         address owner
1083     ) private {
1084         _tokenApprovals[tokenId] = to;
1085         emit Approval(owner, to, tokenId);
1086     }
1087 
1088     function _checkContractOnERC721Received(
1089         address from,
1090         address to,
1091         uint256 tokenId,
1092         bytes memory _data
1093     ) private returns (bool) {
1094         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1095             return retval == IERC721Receiver(to).onERC721Received.selector;
1096         } catch (bytes memory reason) {
1097             if (reason.length == 0) {
1098                 revert TransferToNonERC721ReceiverImplementer();
1099             } else {
1100                 assembly {
1101                     revert(add(32, reason), mload(reason))
1102                 }
1103             }
1104         }
1105     }
1106 
1107     function _beforeTokenTransfers(
1108         address from,
1109         address to,
1110         uint256 startTokenId,
1111         uint256 quantity
1112     ) internal virtual {}
1113 
1114     function _afterTokenTransfers(
1115         address from,
1116         address to,
1117         uint256 startTokenId,
1118         uint256 quantity
1119     ) internal virtual {}
1120 }
1121 
1122 pragma solidity ^0.8.4;
1123 
1124 contract TrippinFairy is ERC721A, Ownable {
1125     using Strings for uint256;
1126     string private baseURI;
1127     string public hiddenMetadataUri;
1128     uint256 public price = 0.01 ether;
1129     uint256 public maxPerTx = 10;
1130     uint256 public maxFreePerWallet = 2;
1131     uint256 public totalFree = 4444;
1132     uint256 public maxSupply = 4444;
1133     uint public nextId = 0;
1134     bool public mintEnabled = false;
1135     bool public revealed = true;
1136     mapping(address => uint256) private _mintedFreeAmount;
1137 constructor() ERC721A("Trippin Fairy", "FAIRY") {
1138         setHiddenMetadataUri("https://api.ptrippinfairy.xyz/");
1139         setBaseURI("https://api.trippinfairy.xyz /");
1140     }
1141 
1142     function mint(uint256 count) external payable {
1143     require(mintEnabled, "Mint not live yet");
1144       uint256 cost = price;
1145       bool isFree =
1146       ((totalSupply() + count < totalFree + 1) &&
1147       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1148 
1149       if (isFree) {
1150       cost = 0;
1151      }
1152 
1153      else {
1154       require(msg.value >= count * price, "Please send the exact amount.");
1155       require(totalSupply() + count <= maxSupply, "No more Fairy");
1156       require(count <= maxPerTx, "Max per TX reached.");
1157      }
1158 
1159       if (isFree) {
1160          _mintedFreeAmount[msg.sender] += count;
1161       }
1162 
1163      _safeMint(msg.sender, count);
1164      nextId += count;
1165     }
1166 
1167     function _baseURI() internal view virtual override returns (string memory) {
1168         return baseURI;
1169     }
1170 
1171     function tokenURI(uint256 tokenId)
1172         public
1173         view
1174         virtual
1175         override
1176         returns (string memory)
1177     {
1178         require(
1179             _exists(tokenId),
1180             "ERC721Metadata: URI query for nonexistent token"
1181         );
1182 
1183         if (revealed == false) {
1184          return string(abi.encodePacked(hiddenMetadataUri));
1185         }
1186     
1187         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1188     }
1189 
1190     function setBaseURI(string memory uri) public onlyOwner {
1191         baseURI = uri;
1192     }
1193 
1194     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1195      hiddenMetadataUri = _hiddenMetadataUri;
1196     }
1197 
1198     function setFreeAmount(uint256 amount) external onlyOwner {
1199         totalFree = amount;
1200     }
1201 
1202     function setPrice(uint256 _newPrice) external onlyOwner {
1203         price = _newPrice;
1204     }
1205 
1206     function setRevealed() external onlyOwner {
1207      revealed = !revealed;
1208     }
1209 
1210     function flipSale() external onlyOwner {
1211         mintEnabled = !mintEnabled;
1212     }
1213 
1214     function getNextId() public view returns(uint){
1215      return nextId;
1216     }
1217 
1218     function _startTokenId() internal pure override returns (uint256) {
1219         return 1;
1220     }
1221 
1222     function withdraw() external onlyOwner {
1223         (bool success, ) = payable(msg.sender).call{
1224             value: address(this).balance
1225         }("");
1226         require(success, "Transfer failed.");
1227     }
1228     function setmaxSupply(uint _maxSupply) external onlyOwner {
1229         maxSupply = _maxSupply;
1230     }
1231 
1232     function setmaxFreePerWallet(uint256 _maxFreePerWallet) external onlyOwner {
1233         maxFreePerWallet = _maxFreePerWallet;
1234     }
1235 
1236     function setmaxPerTx(uint256 _maxPerTx) external onlyOwner {
1237         maxPerTx = _maxPerTx;
1238     }
1239 
1240     function MintWL(address to, uint256 quantity)public onlyOwner{
1241     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1242     _safeMint(to, quantity);
1243   }
1244 }