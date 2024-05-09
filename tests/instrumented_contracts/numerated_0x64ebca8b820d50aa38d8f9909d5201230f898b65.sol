1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5 Iron Bank - the most secure bank in the nft space. 
6 RM: IBGC (free mint) - Neuro Goblins (for IBGC holders) - $IBGC 
7 
8 ┏━━┳━━━┳━━━┳━┓╋┏┓┏━━┓┏━━━┳━┓╋┏┳┓┏━┓
9 ┗┫┣┫┏━┓┃┏━┓┃┃┗┓┃┃┃┏┓┃┃┏━┓┃┃┗┓┃┃┃┃┏┛
10 ╋┃┃┃┗━┛┃┃╋┃┃┏┓┗┛┃┃┗┛┗┫┃╋┃┃┏┓┗┛┃┗┛┛
11 ╋┃┃┃┏┓┏┫┃╋┃┃┃┗┓┃┃┃┏━┓┃┗━┛┃┃┗┓┃┃┏┓┃
12 ┏┫┣┫┃┃┗┫┗━┛┃┃╋┃┃┃┃┗━┛┃┏━┓┃┃╋┃┃┃┃┃┗┓
13 ┗━━┻┛┗━┻━━━┻┛╋┗━┛┗━━━┻┛╋┗┻┛╋┗━┻┛┗━┛
14 */
15 
16 library Counters {
17     struct Counter {
18 
19         uint256 _value; // default: 0
20     }
21 
22     function current(Counter storage counter) internal view returns (uint256) {
23         return counter._value;
24     }
25 
26     function increment(Counter storage counter) internal {
27         unchecked {
28             counter._value += 1;
29         }
30     }
31 
32     function decrement(Counter storage counter) internal {
33         uint256 value = counter._value;
34         require(value > 0, "Counter:decrement overflow");
35         unchecked {
36             counter._value = value - 1;
37         }
38     }
39 
40     function reset(Counter storage counter) internal {
41         counter._value = 0;
42     }
43 }
44 
45 pragma solidity ^0.8.0;
46 
47 library Strings {
48     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
52      */
53     function toString(uint256 value) internal pure returns (string memory) {
54 
55         if (value == 0) {
56             return "0";
57         }
58         uint256 temp = value;
59         uint256 digits;
60         while (temp != 0) {
61             digits++;
62             temp /= 10;
63         }
64         bytes memory buffer = new bytes(digits);
65         while (value != 0) {
66             digits -= 1;
67             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
68             value /= 10;
69         }
70         return string(buffer);
71     }
72 
73     function toHexString(uint256 value) internal pure returns (string memory) {
74         if (value == 0) {
75             return "0x00";
76         }
77         uint256 temp = value;
78         uint256 length = 0;
79         while (temp != 0) {
80             length++;
81             temp >>= 8;
82         }
83         return toHexString(value, length);
84     }
85 
86     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
87         bytes memory buffer = new bytes(2 * length + 2);
88         buffer[0] = "0";
89         buffer[1] = "x";
90         for (uint256 i = 2 * length + 1; i > 1; --i) {
91             buffer[i] = _HEX_SYMBOLS[value & 0xf];
92             value >>= 4;
93         }
94         require(value == 0, "Strings: hex length insufficient");
95         return string(buffer);
96     }
97 }
98 
99 pragma solidity ^0.8.0;
100 
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 pragma solidity ^0.8.0;
112 
113 abstract contract Ownable is Context {
114     address private _owner;
115 
116     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
117 
118     constructor() {
119         _transferOwnership(_msgSender());
120     }
121 
122     function owner() public view virtual returns (address) {
123         return _owner;
124     }
125 
126     modifier onlyOwner() {
127         require(owner() == _msgSender(), "Ownable: caller is not the owner");
128         _;
129     }
130 
131     function renounceOwnership() public virtual onlyOwner {
132         _transferOwnership(address(0));
133     }
134 
135     function transferOwnership(address newOwner) public virtual onlyOwner {
136         require(newOwner != address(0), "Ownable: new owner is the zero address");
137         _transferOwnership(newOwner);
138     }
139 
140     function _transferOwnership(address newOwner) internal virtual {
141         address oldOwner = _owner;
142         _owner = newOwner;
143         emit OwnershipTransferred(oldOwner, newOwner);
144     }
145 }
146 
147 pragma solidity ^0.8.1;
148 
149 library Address {
150 
151     function isContract(address account) internal view returns (bool) {
152 
153         return account.code.length > 0;
154     }
155 
156     function sendValue(address payable recipient, uint256 amount) internal {
157         require(address(this).balance >= amount, "Address: insufficient balance");
158 
159         (bool success, ) = recipient.call{value: amount}("");
160         require(success, "Address: unable to send value, recipient may have reverted");
161     }
162 
163     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
164         return functionCall(target, data, "Address: low-level call failed");
165     }
166 
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     function functionCallWithValue(
176         address target,
177         bytes memory data,
178         uint256 value
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
181     }
182 
183     function functionCallWithValue(
184         address target,
185         bytes memory data,
186         uint256 value,
187         string memory errorMessage
188     ) internal returns (bytes memory) {
189         require(address(this).balance >= value, "Address: insufficient balance for call");
190         require(isContract(target), "Address: call to non-contract");
191 
192         (bool success, bytes memory returndata) = target.call{value: value}(data);
193         return verifyCallResult(success, returndata, errorMessage);
194     }
195 
196     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
197         return functionStaticCall(target, data, "Address: low-level static call failed");
198     }
199 
200     function functionStaticCall(
201         address target,
202         bytes memory data,
203         string memory errorMessage
204     ) internal view returns (bytes memory) {
205         require(isContract(target), "Address: static call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.staticcall(data);
208         return verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
212         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
213     }
214 
215     function functionDelegateCall(
216         address target,
217         bytes memory data,
218         string memory errorMessage
219     ) internal returns (bytes memory) {
220         require(isContract(target), "Address: delegate call to non-contract");
221 
222         (bool success, bytes memory returndata) = target.delegatecall(data);
223         return verifyCallResult(success, returndata, errorMessage);
224     }
225 
226     function verifyCallResult(
227         bool success,
228         bytes memory returndata,
229         string memory errorMessage
230     ) internal pure returns (bytes memory) {
231         if (success) {
232             return returndata;
233         } else {
234             // Look for revert reason and bubble it up if present
235             if (returndata.length > 0) {
236                 // The easiest way to bubble the revert reason is using memory via assembly
237 
238                 assembly {
239                     let returndata_size := mload(returndata)
240                     revert(add(32, returndata), returndata_size)
241                 }
242             } else {
243                 revert(errorMessage);
244             }
245         }
246     }
247 }
248 
249 pragma solidity ^0.8.0;
250 
251 interface IERC721Receiver {
252 
253     function onERC721Received(
254         address operator,
255         address from,
256         uint256 tokenId,
257         bytes calldata data
258     ) external returns (bytes4);
259 }
260 
261 pragma solidity ^0.8.0;
262 
263 interface IERC165 {
264 
265     function supportsInterface(bytes4 interfaceId) external view returns (bool);
266 }
267 
268 pragma solidity ^0.8.0;
269 
270 abstract contract ERC165 is IERC165 {
271 
272     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
273         return interfaceId == type(IERC165).interfaceId;
274     }
275 }
276 
277 pragma solidity ^0.8.0;
278 
279 interface IERC721 is IERC165 {
280 
281     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
282     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
283     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
284     function balanceOf(address owner) external view returns (uint256 balance);
285     function ownerOf(uint256 tokenId) external view returns (address owner);
286 
287     function safeTransferFrom(
288         address from,
289         address to,
290         uint256 tokenId
291     ) external;
292 
293     function transferFrom(
294         address from,
295         address to,
296         uint256 tokenId
297     ) external;
298 
299     function approve(address to, uint256 tokenId) external;
300 
301     function getApproved(uint256 tokenId) external view returns (address operator);
302 
303     function setApprovalForAll(address operator, bool _approved) external;
304 
305     function isApprovedForAll(address owner, address operator) external view returns (bool);
306 
307     function safeTransferFrom(
308         address from,
309         address to,
310         uint256 tokenId,
311         bytes calldata data
312     ) external;
313 }
314 
315 pragma solidity ^0.8.0;
316 
317 interface IERC721Enumerable is IERC721 {
318 
319     function totalSupply() external view returns (uint256);
320     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
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
778         unchecked {
779             return _currentIndex - _burnCounter - _startTokenId();
780         }
781     }
782 
783     function _totalMinted() internal view returns (uint256) {
784         unchecked {
785             return _currentIndex - _startTokenId();
786         }
787     }
788 
789     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
790         return
791             interfaceId == type(IERC721).interfaceId ||
792             interfaceId == type(IERC721Metadata).interfaceId ||
793             super.supportsInterface(interfaceId);
794     }
795 
796     function balanceOf(address owner) public view override returns (uint256) {
797         if (owner == address(0)) revert BalanceQueryForZeroAddress();
798         return uint256(_addressData[owner].balance);
799     }
800 
801     function _numberMinted(address owner) internal view returns (uint256) {
802         return uint256(_addressData[owner].numberMinted);
803     }
804 
805     function _numberBurned(address owner) internal view returns (uint256) {
806         return uint256(_addressData[owner].numberBurned);
807     }
808 
809     function _getAux(address owner) internal view returns (uint64) {
810         return _addressData[owner].aux;
811     }
812 
813     function _setAux(address owner, uint64 aux) internal {
814         _addressData[owner].aux = aux;
815     }
816 
817     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
818         uint256 curr = tokenId;
819 
820         unchecked {
821             if (_startTokenId() <= curr && curr < _currentIndex) {
822                 TokenOwnership memory ownership = _ownerships[curr];
823                 if (!ownership.burned) {
824                     if (ownership.addr != address(0)) {
825                         return ownership;
826                     }
827 
828                     while (true) {
829                         curr--;
830                         ownership = _ownerships[curr];
831                         if (ownership.addr != address(0)) {
832                             return ownership;
833                         }
834                     }
835                 }
836             }
837         }
838         revert OwnerQueryForNonexistentToken();
839     }
840 
841     function ownerOf(uint256 tokenId) public view override returns (address) {
842         return _ownershipOf(tokenId).addr;
843     }
844 
845     function name() public view virtual override returns (string memory) {
846         return _name;
847     }
848 
849     function symbol() public view virtual override returns (string memory) {
850         return _symbol;
851     }
852 
853     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
854         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
855 
856         string memory baseURI = _baseURI();
857         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
858     }
859 
860     function _baseURI() internal view virtual returns (string memory) {
861         return '';
862     }
863 
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
875     function getApproved(uint256 tokenId) public view override returns (address) {
876         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
877 
878         return _tokenApprovals[tokenId];
879     }
880 
881     function setApprovalForAll(address operator, bool approved) public virtual override {
882         if (operator == _msgSender()) revert ApproveToCaller();
883 
884         _operatorApprovals[_msgSender()][operator] = approved;
885         emit ApprovalForAll(_msgSender(), operator, approved);
886     }
887 
888     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
889         return _operatorApprovals[owner][operator];
890     }
891 
892     function transferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public virtual override {
897         _transfer(from, to, tokenId);
898     }
899 
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public virtual override {
905         safeTransferFrom(from, to, tokenId, '');
906     }
907 
908     function safeTransferFrom(
909         address from,
910         address to,
911         uint256 tokenId,
912         bytes memory _data
913     ) public virtual override {
914         _transfer(from, to, tokenId);
915         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
916             revert TransferToNonERC721ReceiverImplementer();
917         }
918     }
919 
920     function _exists(uint256 tokenId) internal view returns (bool) {
921         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
922     }
923 
924     function _safeMint(address to, uint256 quantity) internal {
925         _safeMint(to, quantity, '');
926     }
927 
928     function _safeMint(
929         address to,
930         uint256 quantity,
931         bytes memory _data
932     ) internal {
933         _mint(to, quantity, _data, true);
934     }
935 
936     function _mint(
937         address to,
938         uint256 quantity,
939         bytes memory _data,
940         bool safe
941     ) internal {
942         uint256 startTokenId = _currentIndex;
943         if (to == address(0)) revert MintToZeroAddress();
944         if (quantity == 0) revert MintZeroQuantity();
945 
946         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
947 
948         unchecked {
949             _addressData[to].balance += uint64(quantity);
950             _addressData[to].numberMinted += uint64(quantity);
951 
952             _ownerships[startTokenId].addr = to;
953             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
954 
955             uint256 updatedIndex = startTokenId;
956             uint256 end = updatedIndex + quantity;
957 
958             if (safe && to.isContract()) {
959                 do {
960                     emit Transfer(address(0), to, updatedIndex);
961                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
962                         revert TransferToNonERC721ReceiverImplementer();
963                     }
964                 } while (updatedIndex != end);
965                 // Reentrancy protection
966                 if (_currentIndex != startTokenId) revert();
967             } else {
968                 do {
969                     emit Transfer(address(0), to, updatedIndex++);
970                 } while (updatedIndex != end);
971             }
972             _currentIndex = updatedIndex;
973         }
974         _afterTokenTransfers(address(0), to, startTokenId, quantity);
975     }
976 
977     function _transfer(
978         address from,
979         address to,
980         uint256 tokenId
981     ) private {
982         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
983 
984         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
985 
986         bool isApprovedOrOwner = (_msgSender() == from ||
987             isApprovedForAll(from, _msgSender()) ||
988             getApproved(tokenId) == _msgSender());
989 
990         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
991         if (to == address(0)) revert TransferToZeroAddress();
992 
993         _beforeTokenTransfers(from, to, tokenId, 1);
994 
995         // Clear approvals from the previous owner
996         _approve(address(0), tokenId, from);
997 
998         unchecked {
999             _addressData[from].balance -= 1;
1000             _addressData[to].balance += 1;
1001 
1002             TokenOwnership storage currSlot = _ownerships[tokenId];
1003             currSlot.addr = to;
1004             currSlot.startTimestamp = uint64(block.timestamp);
1005 
1006             uint256 nextTokenId = tokenId + 1;
1007             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1008             if (nextSlot.addr == address(0)) {
1009 
1010                 if (nextTokenId != _currentIndex) {
1011                     nextSlot.addr = from;
1012                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1013                 }
1014             }
1015         }
1016 
1017         emit Transfer(from, to, tokenId);
1018         _afterTokenTransfers(from, to, tokenId, 1);
1019     }
1020 
1021     function _burn(uint256 tokenId) internal virtual {
1022         _burn(tokenId, false);
1023     }
1024 
1025     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1026         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1027 
1028         address from = prevOwnership.addr;
1029 
1030         if (approvalCheck) {
1031             bool isApprovedOrOwner = (_msgSender() == from ||
1032                 isApprovedForAll(from, _msgSender()) ||
1033                 getApproved(tokenId) == _msgSender());
1034 
1035             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1036         }
1037 
1038         _beforeTokenTransfers(from, address(0), tokenId, 1);
1039 
1040         _approve(address(0), tokenId, from);
1041 
1042         unchecked {
1043             AddressData storage addressData = _addressData[from];
1044             addressData.balance -= 1;
1045             addressData.numberBurned += 1;
1046 
1047             TokenOwnership storage currSlot = _ownerships[tokenId];
1048             currSlot.addr = from;
1049             currSlot.startTimestamp = uint64(block.timestamp);
1050             currSlot.burned = true;
1051 
1052             uint256 nextTokenId = tokenId + 1;
1053             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1054             if (nextSlot.addr == address(0)) {
1055 
1056                 if (nextTokenId != _currentIndex) {
1057                     nextSlot.addr = from;
1058                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1059                 }
1060             }
1061         }
1062 
1063         emit Transfer(from, address(0), tokenId);
1064         _afterTokenTransfers(from, address(0), tokenId, 1);
1065 
1066         unchecked {
1067             _burnCounter++;
1068         }
1069     }
1070 
1071     function _approve(
1072         address to,
1073         uint256 tokenId,
1074         address owner
1075     ) private {
1076         _tokenApprovals[tokenId] = to;
1077         emit Approval(owner, to, tokenId);
1078     }
1079 
1080     function _checkContractOnERC721Received(
1081         address from,
1082         address to,
1083         uint256 tokenId,
1084         bytes memory _data
1085     ) private returns (bool) {
1086         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1087             return retval == IERC721Receiver(to).onERC721Received.selector;
1088         } catch (bytes memory reason) {
1089             if (reason.length == 0) {
1090                 revert TransferToNonERC721ReceiverImplementer();
1091             } else {
1092                 assembly {
1093                     revert(add(32, reason), mload(reason))
1094                 }
1095             }
1096         }
1097     }
1098 
1099     function _beforeTokenTransfers(
1100         address from,
1101         address to,
1102         uint256 startTokenId,
1103         uint256 quantity
1104     ) internal virtual {}
1105 
1106     function _afterTokenTransfers(
1107         address from,
1108         address to,
1109         uint256 startTokenId,
1110         uint256 quantity
1111     ) internal virtual {}
1112 }
1113 
1114 pragma solidity ^0.8.4;
1115 
1116 contract IronBank is ERC721A, Ownable {
1117     using Strings for uint256;
1118     string private baseURI;
1119     string public hiddenMetadataUri;
1120     uint256 public price = 0.006 ether;
1121     uint256 public maxPerTx = 10;
1122     uint256 public maxFreePerWallet = 2;
1123     uint256 public totalFree = 6000;
1124     uint256 public maxSupply = 10000;
1125     uint public nextId = 0;
1126     bool public mintEnabled = false;
1127     bool public revealed = true;
1128     mapping(address => uint256) private _mintedFreeAmount;
1129 
1130 constructor() ERC721A("IronBank.Gold", "IBGC") {
1131         setHiddenMetadataUri("https://api.ironbank.gold/");
1132         setBaseURI("https://api.ironbank.gold/");
1133     }
1134 
1135     function mint(uint256 count) external payable {
1136     require(mintEnabled, "Mint not live yet");
1137       uint256 cost = price;
1138       bool isFree =
1139       ((totalSupply() + count < totalFree + 1) &&
1140       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1141 
1142       if (isFree) {
1143       cost = 0;
1144      }
1145 
1146      else {
1147       require(msg.value >= count * price, "Please send the exact amount.");
1148       require(totalSupply() + count <= maxSupply, "No more tokens");
1149       require(count <= maxPerTx, "Max per TX reached.");
1150      }
1151 
1152       if (isFree) {
1153          _mintedFreeAmount[msg.sender] += count;
1154       }
1155 
1156      _safeMint(msg.sender, count);
1157      nextId += count;
1158     }
1159 
1160     function _baseURI() internal view virtual override returns (string memory) {
1161         return baseURI;
1162     }
1163 
1164     function tokenURI(uint256 tokenId)
1165         public
1166         view
1167         virtual
1168         override
1169         returns (string memory)
1170     {
1171         require(
1172             _exists(tokenId),
1173             "ERC721Metadata: URI query for nonexistent token"
1174         );
1175 
1176         if (revealed == false) {
1177          return string(abi.encodePacked(hiddenMetadataUri));
1178         }
1179     
1180         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1181     }
1182 
1183     function setBaseURI(string memory uri) public onlyOwner {
1184         baseURI = uri;
1185     }
1186 
1187     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1188      hiddenMetadataUri = _hiddenMetadataUri;
1189     }
1190 
1191     function setFreeAmount(uint256 amount) external onlyOwner {
1192         totalFree = amount;
1193     }
1194 
1195     function setPrice(uint256 _newPrice) external onlyOwner {
1196         price = _newPrice;
1197     }
1198 
1199     function setRevealed() external onlyOwner {
1200      revealed = !revealed;
1201     }
1202 
1203     function flipSale() external onlyOwner {
1204         mintEnabled = !mintEnabled;
1205     }
1206 
1207     function getNextId() public view returns(uint){
1208      return nextId;
1209     }
1210 
1211     function _startTokenId() internal pure override returns (uint256) {
1212         return 1;
1213     }
1214 
1215     function withdraw() external onlyOwner {
1216         (bool success, ) = payable(msg.sender).call{
1217             value: address(this).balance
1218         }("");
1219         require(success, "Transfer failed.");
1220     }
1221     function setmaxSupply(uint _maxSupply) external onlyOwner {
1222         maxSupply = _maxSupply;
1223     }
1224 
1225     function setmaxFreePerWallet(uint256 _maxFreePerWallet) external onlyOwner {
1226         maxFreePerWallet = _maxFreePerWallet;
1227     }
1228 
1229     function setmaxPerTx(uint256 _maxPerTx) external onlyOwner {
1230         maxPerTx = _maxPerTx;
1231     }
1232 
1233     function MintWhiteList(address to, uint256 quantity)public onlyOwner{
1234     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1235     _safeMint(to, quantity);
1236   }
1237 }