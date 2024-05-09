1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 //  乃ㄖ丂ㄖ乙ㄖҜㄩ 卂卩乇 Ꮆ卂几Ꮆ 匚ㄥㄩ乃
6 
7 
8 library Counters {
9     struct Counter {
10 
11         uint256 _value; // default: 0
12     }
13 
14     function current(Counter storage counter) internal view returns (uint256) {
15         return counter._value;
16     }
17 
18     function increment(Counter storage counter) internal {
19         unchecked {
20             counter._value += 1;
21         }
22     }
23 
24     function decrement(Counter storage counter) internal {
25         uint256 value = counter._value;
26         require(value > 0, "Counter:decrement overflow");
27         unchecked {
28             counter._value = value - 1;
29         }
30     }
31 
32     function reset(Counter storage counter) internal {
33         counter._value = 0;
34     }
35 }
36 
37 pragma solidity ^0.8.0;
38 
39 library Strings {
40     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
44      */
45     function toString(uint256 value) internal pure returns (string memory) {
46         // Inspired by OraclizeAPI's implementation - MIT licence
47         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
48 
49         if (value == 0) {
50             return "0";
51         }
52         uint256 temp = value;
53         uint256 digits;
54         while (temp != 0) {
55             digits++;
56             temp /= 10;
57         }
58         bytes memory buffer = new bytes(digits);
59         while (value != 0) {
60             digits -= 1;
61             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
62             value /= 10;
63         }
64         return string(buffer);
65     }
66 
67     function toHexString(uint256 value) internal pure returns (string memory) {
68         if (value == 0) {
69             return "0x00";
70         }
71         uint256 temp = value;
72         uint256 length = 0;
73         while (temp != 0) {
74             length++;
75             temp >>= 8;
76         }
77         return toHexString(value, length);
78     }
79 
80     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
81         bytes memory buffer = new bytes(2 * length + 2);
82         buffer[0] = "0";
83         buffer[1] = "x";
84         for (uint256 i = 2 * length + 1; i > 1; --i) {
85             buffer[i] = _HEX_SYMBOLS[value & 0xf];
86             value >>= 4;
87         }
88         require(value == 0, "Strings: hex length insufficient");
89         return string(buffer);
90     }
91 }
92 
93 pragma solidity ^0.8.0;
94 
95 abstract contract Context {
96     function _msgSender() internal view virtual returns (address) {
97         return msg.sender;
98     }
99 
100     function _msgData() internal view virtual returns (bytes calldata) {
101         return msg.data;
102     }
103 }
104 
105 pragma solidity ^0.8.0;
106 
107 abstract contract Ownable is Context {
108     address private _owner;
109 
110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112     constructor() {
113         _transferOwnership(_msgSender());
114     }
115 
116     function owner() public view virtual returns (address) {
117         return _owner;
118     }
119 
120     modifier onlyOwner() {
121         require(owner() == _msgSender(), "Ownable: caller is not the owner");
122         _;
123     }
124 
125     function renounceOwnership() public virtual onlyOwner {
126         _transferOwnership(address(0));
127     }
128 
129     function transferOwnership(address newOwner) public virtual onlyOwner {
130         require(newOwner != address(0), "Ownable: new owner is the zero address");
131         _transferOwnership(newOwner);
132     }
133 
134     function _transferOwnership(address newOwner) internal virtual {
135         address oldOwner = _owner;
136         _owner = newOwner;
137         emit OwnershipTransferred(oldOwner, newOwner);
138     }
139 }
140 
141 pragma solidity ^0.8.1;
142 
143 library Address {
144 
145     function isContract(address account) internal view returns (bool) {
146 
147         return account.code.length > 0;
148     }
149 
150     function sendValue(address payable recipient, uint256 amount) internal {
151         require(address(this).balance >= amount, "Address: insufficient balance");
152 
153         (bool success, ) = recipient.call{value: amount}("");
154         require(success, "Address: unable to send value, recipient may have reverted");
155     }
156 
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     function functionCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal returns (bytes memory) {
166         return functionCallWithValue(target, data, 0, errorMessage);
167     }
168 
169     function functionCallWithValue(
170         address target,
171         bytes memory data,
172         uint256 value
173     ) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
175     }
176 
177     function functionCallWithValue(
178         address target,
179         bytes memory data,
180         uint256 value,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         require(address(this).balance >= value, "Address: insufficient balance for call");
184         require(isContract(target), "Address: call to non-contract");
185 
186         (bool success, bytes memory returndata) = target.call{value: value}(data);
187         return verifyCallResult(success, returndata, errorMessage);
188     }
189 
190     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
191         return functionStaticCall(target, data, "Address: low-level static call failed");
192     }
193 
194     function functionStaticCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal view returns (bytes memory) {
199         require(isContract(target), "Address: static call to non-contract");
200 
201         (bool success, bytes memory returndata) = target.staticcall(data);
202         return verifyCallResult(success, returndata, errorMessage);
203     }
204 
205     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
206         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
207     }
208 
209     function functionDelegateCall(
210         address target,
211         bytes memory data,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(isContract(target), "Address: delegate call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.delegatecall(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     function verifyCallResult(
221         bool success,
222         bytes memory returndata,
223         string memory errorMessage
224     ) internal pure returns (bytes memory) {
225         if (success) {
226             return returndata;
227         } else {
228             // Look for revert reason and bubble it up if present
229             if (returndata.length > 0) {
230                 // The easiest way to bubble the revert reason is using memory via assembly
231 
232                 assembly {
233                     let returndata_size := mload(returndata)
234                     revert(add(32, returndata), returndata_size)
235                 }
236             } else {
237                 revert(errorMessage);
238             }
239         }
240     }
241 }
242 
243 pragma solidity ^0.8.0;
244 
245 interface IERC721Receiver {
246 
247     function onERC721Received(
248         address operator,
249         address from,
250         uint256 tokenId,
251         bytes calldata data
252     ) external returns (bytes4);
253 }
254 
255 pragma solidity ^0.8.0;
256 
257 interface IERC165 {
258 
259     function supportsInterface(bytes4 interfaceId) external view returns (bool);
260 }
261 
262 pragma solidity ^0.8.0;
263 
264 abstract contract ERC165 is IERC165 {
265 
266     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
267         return interfaceId == type(IERC165).interfaceId;
268     }
269 }
270 
271 pragma solidity ^0.8.0;
272 
273 interface IERC721 is IERC165 {
274 
275     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
276 
277     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
278 
279     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
280 
281     function balanceOf(address owner) external view returns (uint256 balance);
282 
283     function ownerOf(uint256 tokenId) external view returns (address owner);
284 
285     function safeTransferFrom(
286         address from,
287         address to,
288         uint256 tokenId
289     ) external;
290 
291     function transferFrom(
292         address from,
293         address to,
294         uint256 tokenId
295     ) external;
296 
297     function approve(address to, uint256 tokenId) external;
298 
299     function getApproved(uint256 tokenId) external view returns (address operator);
300 
301     function setApprovalForAll(address operator, bool _approved) external;
302 
303     function isApprovedForAll(address owner, address operator) external view returns (bool);
304 
305     function safeTransferFrom(
306         address from,
307         address to,
308         uint256 tokenId,
309         bytes calldata data
310     ) external;
311 }
312 
313 pragma solidity ^0.8.0;
314 
315 interface IERC721Enumerable is IERC721 {
316 
317     function totalSupply() external view returns (uint256);
318 
319     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
320 
321     function tokenByIndex(uint256 index) external view returns (uint256);
322 }
323 
324 pragma solidity ^0.8.0;
325 
326 interface IERC721Metadata is IERC721 {
327 
328     function name() external view returns (string memory);
329 
330     function symbol() external view returns (string memory);
331 
332     function tokenURI(uint256 tokenId) external view returns (string memory);
333 }
334 
335 pragma solidity ^0.8.0;
336 
337 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
338     using Address for address;
339     using Strings for uint256;
340 
341     // Token name
342     string private _name;
343 
344     // Token symbol
345     string private _symbol;
346 
347     // Mapping from token ID to owner address
348     mapping(uint256 => address) private _owners;
349 
350     // Mapping owner address to token count
351     mapping(address => uint256) private _balances;
352 
353     // Mapping from token ID to approved address
354     mapping(uint256 => address) private _tokenApprovals;
355 
356     // Mapping from owner to operator approvals
357     mapping(address => mapping(address => bool)) private _operatorApprovals;
358 
359     constructor(string memory name_, string memory symbol_) {
360         _name = name_;
361         _symbol = symbol_;
362     }
363 
364     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
365         return
366             interfaceId == type(IERC721).interfaceId ||
367             interfaceId == type(IERC721Metadata).interfaceId ||
368             super.supportsInterface(interfaceId);
369     }
370 
371     function balanceOf(address owner) public view virtual override returns (uint256) {
372         require(owner != address(0), "ERC721: balance query for the zero address");
373         return _balances[owner];
374     }
375 
376     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
377         address owner = _owners[tokenId];
378         require(owner != address(0), "ERC721: owner query for nonexistent token");
379         return owner;
380     }
381 
382     function name() public view virtual override returns (string memory) {
383         return _name;
384     }
385 
386     function symbol() public view virtual override returns (string memory) {
387         return _symbol;
388     }
389 
390     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
391         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
392 
393         string memory baseURI = _baseURI();
394         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
395     }
396 
397     function _baseURI() internal view virtual returns (string memory) {
398         return "";
399     }
400 
401     function approve(address to, uint256 tokenId) public virtual override {
402         address owner = ERC721.ownerOf(tokenId);
403         require(to != owner, "ERC721: approval to current owner");
404 
405         require(
406             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
407             "ERC721: approve caller is not owner nor approved for all"
408         );
409 
410         _approve(to, tokenId);
411     }
412 
413     function getApproved(uint256 tokenId) public view virtual override returns (address) {
414         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
415 
416         return _tokenApprovals[tokenId];
417     }
418 
419     function setApprovalForAll(address operator, bool approved) public virtual override {
420         _setApprovalForAll(_msgSender(), operator, approved);
421     }
422 
423     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
424         return _operatorApprovals[owner][operator];
425     }
426 
427     function transferFrom(
428         address from,
429         address to,
430         uint256 tokenId
431     ) public virtual override {
432         //solhint-disable-next-line max-line-length
433         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
434 
435         _transfer(from, to, tokenId);
436     }
437 
438     function safeTransferFrom(
439         address from,
440         address to,
441         uint256 tokenId
442     ) public virtual override {
443         safeTransferFrom(from, to, tokenId, "");
444     }
445 
446     function safeTransferFrom(
447         address from,
448         address to,
449         uint256 tokenId,
450         bytes memory _data
451     ) public virtual override {
452         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
453         _safeTransfer(from, to, tokenId, _data);
454     }
455 
456     function _safeTransfer(
457         address from,
458         address to,
459         uint256 tokenId,
460         bytes memory _data
461     ) internal virtual {
462         _transfer(from, to, tokenId);
463         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
464     }
465 
466     function _exists(uint256 tokenId) internal view virtual returns (bool) {
467         return _owners[tokenId] != address(0);
468     }
469 
470     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
471         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
472         address owner = ERC721.ownerOf(tokenId);
473         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
474     }
475 
476     function _safeMint(address to, uint256 tokenId) internal virtual {
477         _safeMint(to, tokenId, "");
478     }
479 
480     function _safeMint(
481         address to,
482         uint256 tokenId,
483         bytes memory _data
484     ) internal virtual {
485         _mint(to, tokenId);
486         require(
487             _checkOnERC721Received(address(0), to, tokenId, _data),
488             "ERC721: transfer to non ERC721Receiver implementer"
489         );
490     }
491 
492     function _mint(address to, uint256 tokenId) internal virtual {
493         require(to != address(0), "ERC721: mint to the zero address");
494         require(!_exists(tokenId), "ERC721: token already minted");
495 
496         _beforeTokenTransfer(address(0), to, tokenId);
497 
498         _balances[to] += 1;
499         _owners[tokenId] = to;
500 
501         emit Transfer(address(0), to, tokenId);
502 
503         _afterTokenTransfer(address(0), to, tokenId);
504     }
505 
506     function _burn(uint256 tokenId) internal virtual {
507         address owner = ERC721.ownerOf(tokenId);
508 
509         _beforeTokenTransfer(owner, address(0), tokenId);
510 
511         // Clear approvals
512         _approve(address(0), tokenId);
513 
514         _balances[owner] -= 1;
515         delete _owners[tokenId];
516 
517         emit Transfer(owner, address(0), tokenId);
518 
519         _afterTokenTransfer(owner, address(0), tokenId);
520     }
521 
522     function _transfer(
523         address from,
524         address to,
525         uint256 tokenId
526     ) internal virtual {
527         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
528         require(to != address(0), "ERC721: transfer to the zero address");
529 
530         _beforeTokenTransfer(from, to, tokenId);
531 
532         _approve(address(0), tokenId);
533 
534         _balances[from] -= 1;
535         _balances[to] += 1;
536         _owners[tokenId] = to;
537 
538         emit Transfer(from, to, tokenId);
539 
540         _afterTokenTransfer(from, to, tokenId);
541     }
542 
543     function _approve(address to, uint256 tokenId) internal virtual {
544         _tokenApprovals[tokenId] = to;
545         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
546     }
547 
548     function _setApprovalForAll(
549         address owner,
550         address operator,
551         bool approved
552     ) internal virtual {
553         require(owner != operator, "ERC721: approve to caller");
554         _operatorApprovals[owner][operator] = approved;
555         emit ApprovalForAll(owner, operator, approved);
556     }
557 
558     function _checkOnERC721Received(
559         address from,
560         address to,
561         uint256 tokenId,
562         bytes memory _data
563     ) private returns (bool) {
564         if (to.isContract()) {
565             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
566                 return retval == IERC721Receiver.onERC721Received.selector;
567             } catch (bytes memory reason) {
568                 if (reason.length == 0) {
569                     revert("ERC721: transfer to non ERC721Receiver implementer");
570                 } else {
571                     assembly {
572                         revert(add(32, reason), mload(reason))
573                     }
574                 }
575             }
576         } else {
577             return true;
578         }
579     }
580 
581     function _beforeTokenTransfer(
582         address from,
583         address to,
584         uint256 tokenId
585     ) internal virtual {}
586 
587     function _afterTokenTransfer(
588         address from,
589         address to,
590         uint256 tokenId
591     ) internal virtual {}
592 }
593 
594 pragma solidity ^0.8.0;
595 
596 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
597     // Mapping from owner to list of owned token IDs
598     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
599 
600     // Mapping from token ID to index of the owner tokens list
601     mapping(uint256 => uint256) private _ownedTokensIndex;
602 
603     // Array with all token ids, used for enumeration
604     uint256[] private _allTokens;
605 
606     // Mapping from token id to position in the allTokens array
607     mapping(uint256 => uint256) private _allTokensIndex;
608 
609     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
610         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
611     }
612 
613     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
614         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
615         return _ownedTokens[owner][index];
616     }
617 
618     function totalSupply() public view virtual override returns (uint256) {
619         return _allTokens.length;
620     }
621 
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
683 
684         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
685         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
686         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
687         uint256 lastTokenId = _allTokens[lastTokenIndex];
688 
689         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
690         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
691 
692         // This also deletes the contents at the last position of the array
693         delete _allTokensIndex[tokenId];
694         _allTokens.pop();
695     }
696 }
697 
698 pragma solidity ^0.8.4;
699 
700 error ApprovalCallerNotOwnerNorApproved();
701 error ApprovalQueryForNonexistentToken();
702 error ApproveToCaller();
703 error ApprovalToCurrentOwner();
704 error BalanceQueryForZeroAddress();
705 error MintToZeroAddress();
706 error MintZeroQuantity();
707 error OwnerQueryForNonexistentToken();
708 error TransferCallerNotOwnerNorApproved();
709 error TransferFromIncorrectOwner();
710 error TransferToNonERC721ReceiverImplementer();
711 error TransferToZeroAddress();
712 error URIQueryForNonexistentToken();
713 
714 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
715     using Address for address;
716     using Strings for uint256;
717 
718     // Compiler will pack this into a single 256bit word.
719     struct TokenOwnership {
720         // The address of the owner.
721         address addr;
722         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
723         uint64 startTimestamp;
724         // Whether the token has been burned.
725         bool burned;
726     }
727 
728     // Compiler will pack this into a single 256bit word.
729     struct AddressData {
730         // Realistically, 2**64-1 is more than enough.
731         uint64 balance;
732         // Keeps track of mint count with minimal overhead for tokenomics.
733         uint64 numberMinted;
734         // Keeps track of burn count with minimal overhead for tokenomics.
735         uint64 numberBurned;
736         // For miscellaneous variable(s) pertaining to the address
737         // (e.g. number of whitelist mint slots used).
738         // If there are multiple variables, please pack them into a uint64.
739         uint64 aux;
740     }
741 
742     // The tokenId of the next token to be minted.
743     uint256 internal _currentIndex;
744 
745     // The number of tokens burned.
746     uint256 internal _burnCounter;
747 
748     // Token name
749     string private _name;
750 
751     // Token symbol
752     string private _symbol;
753 
754     // Mapping from token ID to ownership details
755     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
756     mapping(uint256 => TokenOwnership) internal _ownerships;
757 
758     // Mapping owner address to address data
759     mapping(address => AddressData) private _addressData;
760 
761     // Mapping from token ID to approved address
762     mapping(uint256 => address) private _tokenApprovals;
763 
764     // Mapping from owner to operator approvals
765     mapping(address => mapping(address => bool)) private _operatorApprovals;
766 
767     constructor(string memory name_, string memory symbol_) {
768         _name = name_;
769         _symbol = symbol_;
770         _currentIndex = _startTokenId();
771     }
772 
773     function _startTokenId() internal view virtual returns (uint256) {
774         return 0;
775     }
776 
777     function totalSupply() public view returns (uint256) {
778         // Counter underflow is impossible as _burnCounter cannot be incremented
779         // more than _currentIndex - _startTokenId() times
780         unchecked {
781             return _currentIndex - _burnCounter - _startTokenId();
782         }
783     }
784 
785     function _totalMinted() internal view returns (uint256) {
786         // Counter underflow is impossible as _currentIndex does not decrement,
787         // and it is initialized to _startTokenId()
788         unchecked {
789             return _currentIndex - _startTokenId();
790         }
791     }
792 
793     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
794         return
795             interfaceId == type(IERC721).interfaceId ||
796             interfaceId == type(IERC721Metadata).interfaceId ||
797             super.supportsInterface(interfaceId);
798     }
799 
800     function balanceOf(address owner) public view override returns (uint256) {
801         if (owner == address(0)) revert BalanceQueryForZeroAddress();
802         return uint256(_addressData[owner].balance);
803     }
804 
805     function _numberMinted(address owner) internal view returns (uint256) {
806         return uint256(_addressData[owner].numberMinted);
807     }
808 
809     function _numberBurned(address owner) internal view returns (uint256) {
810         return uint256(_addressData[owner].numberBurned);
811     }
812 
813     function _getAux(address owner) internal view returns (uint64) {
814         return _addressData[owner].aux;
815     }
816 
817     function _setAux(address owner, uint64 aux) internal {
818         _addressData[owner].aux = aux;
819     }
820 
821     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
822         uint256 curr = tokenId;
823 
824         unchecked {
825             if (_startTokenId() <= curr && curr < _currentIndex) {
826                 TokenOwnership memory ownership = _ownerships[curr];
827                 if (!ownership.burned) {
828                     if (ownership.addr != address(0)) {
829                         return ownership;
830                     }
831 
832                     while (true) {
833                         curr--;
834                         ownership = _ownerships[curr];
835                         if (ownership.addr != address(0)) {
836                             return ownership;
837                         }
838                     }
839                 }
840             }
841         }
842         revert OwnerQueryForNonexistentToken();
843     }
844 
845     function ownerOf(uint256 tokenId) public view override returns (address) {
846         return _ownershipOf(tokenId).addr;
847     }
848 
849     function name() public view virtual override returns (string memory) {
850         return _name;
851     }
852 
853     function symbol() public view virtual override returns (string memory) {
854         return _symbol;
855     }
856 
857     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
858         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
859 
860         string memory baseURI = _baseURI();
861         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
862     }
863 
864     function _baseURI() internal view virtual returns (string memory) {
865         return '';
866     }
867 
868     function approve(address to, uint256 tokenId) public override {
869         address owner = ERC721A.ownerOf(tokenId);
870         if (to == owner) revert ApprovalToCurrentOwner();
871 
872         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
873             revert ApprovalCallerNotOwnerNorApproved();
874         }
875 
876         _approve(to, tokenId, owner);
877     }
878 
879     function getApproved(uint256 tokenId) public view override returns (address) {
880         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
881 
882         return _tokenApprovals[tokenId];
883     }
884 
885     function setApprovalForAll(address operator, bool approved) public virtual override {
886         if (operator == _msgSender()) revert ApproveToCaller();
887 
888         _operatorApprovals[_msgSender()][operator] = approved;
889         emit ApprovalForAll(_msgSender(), operator, approved);
890     }
891 
892     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
893         return _operatorApprovals[owner][operator];
894     }
895 
896     function transferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public virtual override {
901         _transfer(from, to, tokenId);
902     }
903 
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) public virtual override {
909         safeTransferFrom(from, to, tokenId, '');
910     }
911 
912     function safeTransferFrom(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) public virtual override {
918         _transfer(from, to, tokenId);
919         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
920             revert TransferToNonERC721ReceiverImplementer();
921         }
922     }
923 
924     function _exists(uint256 tokenId) internal view returns (bool) {
925         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
926     }
927 
928     function _safeMint(address to, uint256 quantity) internal {
929         _safeMint(to, quantity, '');
930     }
931 
932     function _safeMint(
933         address to,
934         uint256 quantity,
935         bytes memory _data
936     ) internal {
937         _mint(to, quantity, _data, true);
938     }
939 
940     function _mint(
941         address to,
942         uint256 quantity,
943         bytes memory _data,
944         bool safe
945     ) internal {
946         uint256 startTokenId = _currentIndex;
947         if (to == address(0)) revert MintToZeroAddress();
948         if (quantity == 0) revert MintZeroQuantity();
949 
950         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
951 
952         unchecked {
953             _addressData[to].balance += uint64(quantity);
954             _addressData[to].numberMinted += uint64(quantity);
955 
956             _ownerships[startTokenId].addr = to;
957             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
958 
959             uint256 updatedIndex = startTokenId;
960             uint256 end = updatedIndex + quantity;
961 
962             if (safe && to.isContract()) {
963                 do {
964                     emit Transfer(address(0), to, updatedIndex);
965                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
966                         revert TransferToNonERC721ReceiverImplementer();
967                     }
968                 } while (updatedIndex != end);
969                 // Reentrancy protection
970                 if (_currentIndex != startTokenId) revert();
971             } else {
972                 do {
973                     emit Transfer(address(0), to, updatedIndex++);
974                 } while (updatedIndex != end);
975             }
976             _currentIndex = updatedIndex;
977         }
978         _afterTokenTransfers(address(0), to, startTokenId, quantity);
979     }
980 
981     function _transfer(
982         address from,
983         address to,
984         uint256 tokenId
985     ) private {
986         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
987 
988         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
989 
990         bool isApprovedOrOwner = (_msgSender() == from ||
991             isApprovedForAll(from, _msgSender()) ||
992             getApproved(tokenId) == _msgSender());
993 
994         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
995         if (to == address(0)) revert TransferToZeroAddress();
996 
997         _beforeTokenTransfers(from, to, tokenId, 1);
998 
999         // Clear approvals from the previous owner
1000         _approve(address(0), tokenId, from);
1001 
1002         unchecked {
1003             _addressData[from].balance -= 1;
1004             _addressData[to].balance += 1;
1005 
1006             TokenOwnership storage currSlot = _ownerships[tokenId];
1007             currSlot.addr = to;
1008             currSlot.startTimestamp = uint64(block.timestamp);
1009 
1010             uint256 nextTokenId = tokenId + 1;
1011             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1012             if (nextSlot.addr == address(0)) {
1013 
1014                 if (nextTokenId != _currentIndex) {
1015                     nextSlot.addr = from;
1016                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1017                 }
1018             }
1019         }
1020 
1021         emit Transfer(from, to, tokenId);
1022         _afterTokenTransfers(from, to, tokenId, 1);
1023     }
1024 
1025     function _burn(uint256 tokenId) internal virtual {
1026         _burn(tokenId, false);
1027     }
1028 
1029     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1030         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1031 
1032         address from = prevOwnership.addr;
1033 
1034         if (approvalCheck) {
1035             bool isApprovedOrOwner = (_msgSender() == from ||
1036                 isApprovedForAll(from, _msgSender()) ||
1037                 getApproved(tokenId) == _msgSender());
1038 
1039             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1040         }
1041 
1042         _beforeTokenTransfers(from, address(0), tokenId, 1);
1043 
1044         _approve(address(0), tokenId, from);
1045 
1046         unchecked {
1047             AddressData storage addressData = _addressData[from];
1048             addressData.balance -= 1;
1049             addressData.numberBurned += 1;
1050 
1051             TokenOwnership storage currSlot = _ownerships[tokenId];
1052             currSlot.addr = from;
1053             currSlot.startTimestamp = uint64(block.timestamp);
1054             currSlot.burned = true;
1055 
1056             uint256 nextTokenId = tokenId + 1;
1057             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1058             if (nextSlot.addr == address(0)) {
1059 
1060                 if (nextTokenId != _currentIndex) {
1061                     nextSlot.addr = from;
1062                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1063                 }
1064             }
1065         }
1066 
1067         emit Transfer(from, address(0), tokenId);
1068         _afterTokenTransfers(from, address(0), tokenId, 1);
1069 
1070         unchecked {
1071             _burnCounter++;
1072         }
1073     }
1074 
1075     function _approve(
1076         address to,
1077         uint256 tokenId,
1078         address owner
1079     ) private {
1080         _tokenApprovals[tokenId] = to;
1081         emit Approval(owner, to, tokenId);
1082     }
1083 
1084     function _checkContractOnERC721Received(
1085         address from,
1086         address to,
1087         uint256 tokenId,
1088         bytes memory _data
1089     ) private returns (bool) {
1090         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1091             return retval == IERC721Receiver(to).onERC721Received.selector;
1092         } catch (bytes memory reason) {
1093             if (reason.length == 0) {
1094                 revert TransferToNonERC721ReceiverImplementer();
1095             } else {
1096                 assembly {
1097                     revert(add(32, reason), mload(reason))
1098                 }
1099             }
1100         }
1101     }
1102 
1103     function _beforeTokenTransfers(
1104         address from,
1105         address to,
1106         uint256 startTokenId,
1107         uint256 quantity
1108     ) internal virtual {}
1109 
1110     function _afterTokenTransfers(
1111         address from,
1112         address to,
1113         uint256 startTokenId,
1114         uint256 quantity
1115     ) internal virtual {}
1116 }
1117 
1118 pragma solidity ^0.8.4;
1119 
1120 contract BosozokuApe is ERC721A, Ownable {
1121     using Strings for uint256;
1122     string private baseURI;
1123     string public hiddenMetadataUri;
1124     uint256 public price = 0.08 ether;
1125     uint256 public maxPerTx = 20;
1126     uint256 public maxFreePerWallet = 2;
1127     uint256 public totalFree = 0;
1128     uint256 public maxSupply = 7777;
1129     uint public nextId = 0;
1130     bool public mintEnabled = false;
1131     bool public revealed = true;
1132     mapping(address => uint256) private _mintedFreeAmount;
1133 
1134 constructor() ERC721A("BosozokuApe GangClub", "BAGC") {
1135         setHiddenMetadataUri("https://api.bosozokuapes.com/");
1136         setBaseURI("https://api.bosozokuapes.com/");
1137     }
1138 
1139     function mint(uint256 count) external payable {
1140     require(mintEnabled, "Mint not live yet");
1141       uint256 cost = price;
1142       bool isFree =
1143       ((totalSupply() + count < totalFree + 1) &&
1144       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1145 
1146       if (isFree) {
1147       cost = 0;
1148      }
1149 
1150      else {
1151       require(msg.value >= count * price, "Please send the exact amount.");
1152       require(totalSupply() + count <= maxSupply, "No more APES");
1153       require(count <= maxPerTx, "Max per TX reached.");
1154      }
1155 
1156       if (isFree) {
1157          _mintedFreeAmount[msg.sender] += count;
1158       }
1159 
1160      _safeMint(msg.sender, count);
1161      nextId += count;
1162     }
1163 
1164     function _baseURI() internal view virtual override returns (string memory) {
1165         return baseURI;
1166     }
1167 
1168     function tokenURI(uint256 tokenId)
1169         public
1170         view
1171         virtual
1172         override
1173         returns (string memory)
1174     {
1175         require(
1176             _exists(tokenId),
1177             "ERC721Metadata: URI query for nonexistent token"
1178         );
1179 
1180         if (revealed == false) {
1181          return string(abi.encodePacked(hiddenMetadataUri));
1182         }
1183     
1184         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1185     }
1186 
1187     function setBaseURI(string memory uri) public onlyOwner {
1188         baseURI = uri;
1189     }
1190 
1191     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1192      hiddenMetadataUri = _hiddenMetadataUri;
1193     }
1194 
1195     function setFreeAmount(uint256 amount) external onlyOwner {
1196         totalFree = amount;
1197     }
1198 
1199     function setPrice(uint256 _newPrice) external onlyOwner {
1200         price = _newPrice;
1201     }
1202 
1203     function setRevealed() external onlyOwner {
1204      revealed = !revealed;
1205     }
1206 
1207     function flipSale() external onlyOwner {
1208         mintEnabled = !mintEnabled;
1209     }
1210 
1211     function getNextId() public view returns(uint){
1212      return nextId;
1213     }
1214 
1215     function _startTokenId() internal pure override returns (uint256) {
1216         return 1;
1217     }
1218 
1219     function withdraw() external onlyOwner {
1220         (bool success, ) = payable(msg.sender).call{
1221             value: address(this).balance
1222         }("");
1223         require(success, "Transfer failed.");
1224     }
1225     function setmaxSupply(uint _maxSupply) external onlyOwner {
1226         maxSupply = _maxSupply;
1227     }
1228 
1229     function setmaxFreePerWallet(uint256 _maxFreePerWallet) external onlyOwner {
1230         maxFreePerWallet = _maxFreePerWallet;
1231     }
1232 
1233     function setmaxPerTx(uint256 _maxPerTx) external onlyOwner {
1234         maxPerTx = _maxPerTx;
1235     }
1236 
1237     function MintFreeWhiteList(address to, uint256 quantity)public onlyOwner{
1238     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1239     _safeMint(to, quantity);
1240   }
1241 }