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
43 
44         if (value == 0) {
45             return "0";
46         }
47         uint256 temp = value;
48         uint256 digits;
49         while (temp != 0) {
50             digits++;
51             temp /= 10;
52         }
53         bytes memory buffer = new bytes(digits);
54         while (value != 0) {
55             digits -= 1;
56             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
57             value /= 10;
58         }
59         return string(buffer);
60     }
61 
62     function toHexString(uint256 value) internal pure returns (string memory) {
63         if (value == 0) {
64             return "0x00";
65         }
66         uint256 temp = value;
67         uint256 length = 0;
68         while (temp != 0) {
69             length++;
70             temp >>= 8;
71         }
72         return toHexString(value, length);
73     }
74 
75     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
76         bytes memory buffer = new bytes(2 * length + 2);
77         buffer[0] = "0";
78         buffer[1] = "x";
79         for (uint256 i = 2 * length + 1; i > 1; --i) {
80             buffer[i] = _HEX_SYMBOLS[value & 0xf];
81             value >>= 4;
82         }
83         require(value == 0, "Strings: hex length insufficient");
84         return string(buffer);
85     }
86 }
87 
88 pragma solidity ^0.8.0;
89 
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 pragma solidity ^0.8.0;
101 
102 abstract contract Ownable is Context {
103     address private _owner;
104 
105     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
106 
107     constructor() {
108         _transferOwnership(_msgSender());
109     }
110 
111     function owner() public view virtual returns (address) {
112         return _owner;
113     }
114 
115     modifier onlyOwner() {
116         require(owner() == _msgSender(), "Ownable: caller is not the owner");
117         _;
118     }
119 
120     function renounceOwnership() public virtual onlyOwner {
121         _transferOwnership(address(0));
122     }
123 
124     function transferOwnership(address newOwner) public virtual onlyOwner {
125         require(newOwner != address(0), "Ownable: new owner is the zero address");
126         _transferOwnership(newOwner);
127     }
128 
129     function _transferOwnership(address newOwner) internal virtual {
130         address oldOwner = _owner;
131         _owner = newOwner;
132         emit OwnershipTransferred(oldOwner, newOwner);
133     }
134 }
135 
136 pragma solidity ^0.8.1;
137 
138 library Address {
139 
140     function isContract(address account) internal view returns (bool) {
141 
142         return account.code.length > 0;
143     }
144 
145     function sendValue(address payable recipient, uint256 amount) internal {
146         require(address(this).balance >= amount, "Address: insufficient balance");
147 
148         (bool success, ) = recipient.call{value: amount}("");
149         require(success, "Address: unable to send value, recipient may have reverted");
150     }
151 
152     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionCall(target, data, "Address: low-level call failed");
154     }
155 
156     function functionCall(
157         address target,
158         bytes memory data,
159         string memory errorMessage
160     ) internal returns (bytes memory) {
161         return functionCallWithValue(target, data, 0, errorMessage);
162     }
163 
164     function functionCallWithValue(
165         address target,
166         bytes memory data,
167         uint256 value
168     ) internal returns (bytes memory) {
169         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
170     }
171 
172     function functionCallWithValue(
173         address target,
174         bytes memory data,
175         uint256 value,
176         string memory errorMessage
177     ) internal returns (bytes memory) {
178         require(address(this).balance >= value, "Address: insufficient balance for call");
179         require(isContract(target), "Address: call to non-contract");
180 
181         (bool success, bytes memory returndata) = target.call{value: value}(data);
182         return verifyCallResult(success, returndata, errorMessage);
183     }
184 
185     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
186         return functionStaticCall(target, data, "Address: low-level static call failed");
187     }
188 
189     function functionStaticCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal view returns (bytes memory) {
194         require(isContract(target), "Address: static call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.staticcall(data);
197         return verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
201         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
202     }
203 
204     function functionDelegateCall(
205         address target,
206         bytes memory data,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(isContract(target), "Address: delegate call to non-contract");
210 
211         (bool success, bytes memory returndata) = target.delegatecall(data);
212         return verifyCallResult(success, returndata, errorMessage);
213     }
214 
215     function verifyCallResult(
216         bool success,
217         bytes memory returndata,
218         string memory errorMessage
219     ) internal pure returns (bytes memory) {
220         if (success) {
221             return returndata;
222         } else {
223             // Look for revert reason and bubble it up if present
224             if (returndata.length > 0) {
225                 // The easiest way to bubble the revert reason is using memory via assembly
226 
227                 assembly {
228                     let returndata_size := mload(returndata)
229                     revert(add(32, returndata), returndata_size)
230                 }
231             } else {
232                 revert(errorMessage);
233             }
234         }
235     }
236 }
237 
238 pragma solidity ^0.8.0;
239 
240 interface IERC721Receiver {
241 
242     function onERC721Received(
243         address operator,
244         address from,
245         uint256 tokenId,
246         bytes calldata data
247     ) external returns (bytes4);
248 }
249 
250 pragma solidity ^0.8.0;
251 
252 interface IERC165 {
253 
254     function supportsInterface(bytes4 interfaceId) external view returns (bool);
255 }
256 
257 pragma solidity ^0.8.0;
258 
259 abstract contract ERC165 is IERC165 {
260 
261     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
262         return interfaceId == type(IERC165).interfaceId;
263     }
264 }
265 
266 pragma solidity ^0.8.0;
267 
268 interface IERC721 is IERC165 {
269 
270     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
271     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
272     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
273     function balanceOf(address owner) external view returns (uint256 balance);
274     function ownerOf(uint256 tokenId) external view returns (address owner);
275 
276     function safeTransferFrom(
277         address from,
278         address to,
279         uint256 tokenId
280     ) external;
281 
282     function transferFrom(
283         address from,
284         address to,
285         uint256 tokenId
286     ) external;
287 
288     function approve(address to, uint256 tokenId) external;
289 
290     function getApproved(uint256 tokenId) external view returns (address operator);
291 
292     function setApprovalForAll(address operator, bool _approved) external;
293 
294     function isApprovedForAll(address owner, address operator) external view returns (bool);
295 
296     function safeTransferFrom(
297         address from,
298         address to,
299         uint256 tokenId,
300         bytes calldata data
301     ) external;
302 }
303 
304 pragma solidity ^0.8.0;
305 
306 interface IERC721Enumerable is IERC721 {
307 
308     function totalSupply() external view returns (uint256);
309     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
310     function tokenByIndex(uint256 index) external view returns (uint256);
311 }
312 
313 pragma solidity ^0.8.0;
314 
315 interface IERC721Metadata is IERC721 {
316 
317     function name() external view returns (string memory);
318 
319     function symbol() external view returns (string memory);
320 
321     function tokenURI(uint256 tokenId) external view returns (string memory);
322 }
323 
324 pragma solidity ^0.8.0;
325 
326 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
327     using Address for address;
328     using Strings for uint256;
329 
330     string private _name;
331 
332     string private _symbol;
333 
334     mapping(uint256 => address) private _owners;
335 
336     mapping(address => uint256) private _balances;
337 
338     mapping(uint256 => address) private _tokenApprovals;
339 
340     mapping(address => mapping(address => bool)) private _operatorApprovals;
341 
342     constructor(string memory name_, string memory symbol_) {
343         _name = name_;
344         _symbol = symbol_;
345     }
346 
347     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
348         return
349             interfaceId == type(IERC721).interfaceId ||
350             interfaceId == type(IERC721Metadata).interfaceId ||
351             super.supportsInterface(interfaceId);
352     }
353 
354     function balanceOf(address owner) public view virtual override returns (uint256) {
355         require(owner != address(0), "ERC721: balance query for the zero address");
356         return _balances[owner];
357     }
358 
359     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
360         address owner = _owners[tokenId];
361         require(owner != address(0), "ERC721: owner query for nonexistent token");
362         return owner;
363     }
364 
365     function name() public view virtual override returns (string memory) {
366         return _name;
367     }
368 
369     function symbol() public view virtual override returns (string memory) {
370         return _symbol;
371     }
372 
373     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
374         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
375 
376         string memory baseURI = _baseURI();
377         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
378     }
379 
380     function _baseURI() internal view virtual returns (string memory) {
381         return "";
382     }
383 
384     function approve(address to, uint256 tokenId) public virtual override {
385         address owner = ERC721.ownerOf(tokenId);
386         require(to != owner, "ERC721: approval to current owner");
387 
388         require(
389             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
390             "ERC721: approve caller is not owner nor approved for all"
391         );
392 
393         _approve(to, tokenId);
394     }
395 
396     function getApproved(uint256 tokenId) public view virtual override returns (address) {
397         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
398 
399         return _tokenApprovals[tokenId];
400     }
401 
402     function setApprovalForAll(address operator, bool approved) public virtual override {
403         _setApprovalForAll(_msgSender(), operator, approved);
404     }
405 
406     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
407         return _operatorApprovals[owner][operator];
408     }
409 
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) public virtual override {
415         //solhint-disable-next-line max-line-length
416         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
417 
418         _transfer(from, to, tokenId);
419     }
420 
421     function safeTransferFrom(
422         address from,
423         address to,
424         uint256 tokenId
425     ) public virtual override {
426         safeTransferFrom(from, to, tokenId, "");
427     }
428 
429     function safeTransferFrom(
430         address from,
431         address to,
432         uint256 tokenId,
433         bytes memory _data
434     ) public virtual override {
435         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
436         _safeTransfer(from, to, tokenId, _data);
437     }
438 
439     function _safeTransfer(
440         address from,
441         address to,
442         uint256 tokenId,
443         bytes memory _data
444     ) internal virtual {
445         _transfer(from, to, tokenId);
446         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
447     }
448 
449     function _exists(uint256 tokenId) internal view virtual returns (bool) {
450         return _owners[tokenId] != address(0);
451     }
452 
453     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
454         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
455         address owner = ERC721.ownerOf(tokenId);
456         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
457     }
458 
459     function _safeMint(address to, uint256 tokenId) internal virtual {
460         _safeMint(to, tokenId, "");
461     }
462 
463     function _safeMint(
464         address to,
465         uint256 tokenId,
466         bytes memory _data
467     ) internal virtual {
468         _mint(to, tokenId);
469         require(
470             _checkOnERC721Received(address(0), to, tokenId, _data),
471             "ERC721: transfer to non ERC721Receiver implementer"
472         );
473     }
474 
475     function _mint(address to, uint256 tokenId) internal virtual {
476         require(to != address(0), "ERC721: mint to the zero address");
477         require(!_exists(tokenId), "ERC721: token already minted");
478 
479         _beforeTokenTransfer(address(0), to, tokenId);
480 
481         _balances[to] += 1;
482         _owners[tokenId] = to;
483 
484         emit Transfer(address(0), to, tokenId);
485 
486         _afterTokenTransfer(address(0), to, tokenId);
487     }
488 
489     function _burn(uint256 tokenId) internal virtual {
490         address owner = ERC721.ownerOf(tokenId);
491 
492         _beforeTokenTransfer(owner, address(0), tokenId);
493 
494         // Clear approvals
495         _approve(address(0), tokenId);
496 
497         _balances[owner] -= 1;
498         delete _owners[tokenId];
499 
500         emit Transfer(owner, address(0), tokenId);
501 
502         _afterTokenTransfer(owner, address(0), tokenId);
503     }
504 
505     function _transfer(
506         address from,
507         address to,
508         uint256 tokenId
509     ) internal virtual {
510         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
511         require(to != address(0), "ERC721: transfer to the zero address");
512 
513         _beforeTokenTransfer(from, to, tokenId);
514 
515         _approve(address(0), tokenId);
516 
517         _balances[from] -= 1;
518         _balances[to] += 1;
519         _owners[tokenId] = to;
520 
521         emit Transfer(from, to, tokenId);
522 
523         _afterTokenTransfer(from, to, tokenId);
524     }
525 
526     function _approve(address to, uint256 tokenId) internal virtual {
527         _tokenApprovals[tokenId] = to;
528         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
529     }
530 
531     function _setApprovalForAll(
532         address owner,
533         address operator,
534         bool approved
535     ) internal virtual {
536         require(owner != operator, "ERC721: approve to caller");
537         _operatorApprovals[owner][operator] = approved;
538         emit ApprovalForAll(owner, operator, approved);
539     }
540 
541     function _checkOnERC721Received(
542         address from,
543         address to,
544         uint256 tokenId,
545         bytes memory _data
546     ) private returns (bool) {
547         if (to.isContract()) {
548             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
549                 return retval == IERC721Receiver.onERC721Received.selector;
550             } catch (bytes memory reason) {
551                 if (reason.length == 0) {
552                     revert("ERC721: transfer to non ERC721Receiver implementer");
553                 } else {
554                     assembly {
555                         revert(add(32, reason), mload(reason))
556                     }
557                 }
558             }
559         } else {
560             return true;
561         }
562     }
563 
564     function _beforeTokenTransfer(
565         address from,
566         address to,
567         uint256 tokenId
568     ) internal virtual {}
569 
570     function _afterTokenTransfer(
571         address from,
572         address to,
573         uint256 tokenId
574     ) internal virtual {}
575 }
576 
577 pragma solidity ^0.8.0;
578 
579 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
580     // Mapping from owner to list of owned token IDs
581     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
582 
583     // Mapping from token ID to index of the owner tokens list
584     mapping(uint256 => uint256) private _ownedTokensIndex;
585 
586     // Array with all token ids, used for enumeration
587     uint256[] private _allTokens;
588 
589     // Mapping from token id to position in the allTokens array
590     mapping(uint256 => uint256) private _allTokensIndex;
591 
592     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
593         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
594     }
595 
596     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
597         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
598         return _ownedTokens[owner][index];
599     }
600 
601     function totalSupply() public view virtual override returns (uint256) {
602         return _allTokens.length;
603     }
604 
605     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
606         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
607         return _allTokens[index];
608     }
609 
610     function _beforeTokenTransfer(
611         address from,
612         address to,
613         uint256 tokenId
614     ) internal virtual override {
615         super._beforeTokenTransfer(from, to, tokenId);
616 
617         if (from == address(0)) {
618             _addTokenToAllTokensEnumeration(tokenId);
619         } else if (from != to) {
620             _removeTokenFromOwnerEnumeration(from, tokenId);
621         }
622         if (to == address(0)) {
623             _removeTokenFromAllTokensEnumeration(tokenId);
624         } else if (to != from) {
625             _addTokenToOwnerEnumeration(to, tokenId);
626         }
627     }
628 
629     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
630         uint256 length = ERC721.balanceOf(to);
631         _ownedTokens[to][length] = tokenId;
632         _ownedTokensIndex[tokenId] = length;
633     }
634 
635     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
636         _allTokensIndex[tokenId] = _allTokens.length;
637         _allTokens.push(tokenId);
638     }
639 
640     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
641         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
642         // then delete the last slot (swap and pop).
643 
644         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
645         uint256 tokenIndex = _ownedTokensIndex[tokenId];
646 
647         // When the token to delete is the last token, the swap operation is unnecessary
648         if (tokenIndex != lastTokenIndex) {
649             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
650 
651             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
652             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
653         }
654 
655         // This also deletes the contents at the last position of the array
656         delete _ownedTokensIndex[tokenId];
657         delete _ownedTokens[from][lastTokenIndex];
658     }
659 
660     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
661         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
662         // then delete the last slot (swap and pop).
663 
664         uint256 lastTokenIndex = _allTokens.length - 1;
665         uint256 tokenIndex = _allTokensIndex[tokenId];
666 
667         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
668         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
669         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
670         uint256 lastTokenId = _allTokens[lastTokenIndex];
671 
672         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
673         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
674 
675         // This also deletes the contents at the last position of the array
676         delete _allTokensIndex[tokenId];
677         _allTokens.pop();
678     }
679 }
680 
681 pragma solidity ^0.8.4;
682 
683 error ApprovalCallerNotOwnerNorApproved();
684 error ApprovalQueryForNonexistentToken();
685 error ApproveToCaller();
686 error ApprovalToCurrentOwner();
687 error BalanceQueryForZeroAddress();
688 error MintToZeroAddress();
689 error MintZeroQuantity();
690 error OwnerQueryForNonexistentToken();
691 error TransferCallerNotOwnerNorApproved();
692 error TransferFromIncorrectOwner();
693 error TransferToNonERC721ReceiverImplementer();
694 error TransferToZeroAddress();
695 error URIQueryForNonexistentToken();
696 
697 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
698     using Address for address;
699     using Strings for uint256;
700 
701     // Compiler will pack this into a single 256bit word.
702     struct TokenOwnership {
703         // The address of the owner.
704         address addr;
705         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
706         uint64 startTimestamp;
707         // Whether the token has been burned.
708         bool burned;
709     }
710 
711     // Compiler will pack this into a single 256bit word.
712     struct AddressData {
713         // Realistically, 2**64-1 is more than enough.
714         uint64 balance;
715         // Keeps track of mint count with minimal overhead for tokenomics.
716         uint64 numberMinted;
717         // Keeps track of burn count with minimal overhead for tokenomics.
718         uint64 numberBurned;
719         // For miscellaneous variable(s) pertaining to the address
720         // (e.g. number of whitelist mint slots used).
721         // If there are multiple variables, please pack them into a uint64.
722         uint64 aux;
723     }
724 
725     // The tokenId of the next token to be minted.
726     uint256 internal _currentIndex;
727 
728     // The number of tokens burned.
729     uint256 internal _burnCounter;
730 
731     // Token name
732     string private _name;
733 
734     // Token symbol
735     string private _symbol;
736 
737     // Mapping from token ID to ownership details
738     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
739     mapping(uint256 => TokenOwnership) internal _ownerships;
740 
741     // Mapping owner address to address data
742     mapping(address => AddressData) private _addressData;
743 
744     // Mapping from token ID to approved address
745     mapping(uint256 => address) private _tokenApprovals;
746 
747     // Mapping from owner to operator approvals
748     mapping(address => mapping(address => bool)) private _operatorApprovals;
749 
750     constructor(string memory name_, string memory symbol_) {
751         _name = name_;
752         _symbol = symbol_;
753         _currentIndex = _startTokenId();
754     }
755 
756     function _startTokenId() internal view virtual returns (uint256) {
757         return 0;
758     }
759 
760     function totalSupply() public view returns (uint256) {
761         unchecked {
762             return _currentIndex - _burnCounter - _startTokenId();
763         }
764     }
765 
766     function _totalMinted() internal view returns (uint256) {
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
828     function name() public view virtual override returns (string memory) {
829         return _name;
830     }
831 
832     function symbol() public view virtual override returns (string memory) {
833         return _symbol;
834     }
835 
836     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
837         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
838 
839         string memory baseURI = _baseURI();
840         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
841     }
842 
843     function _baseURI() internal view virtual returns (string memory) {
844         return '';
845     }
846 
847     function approve(address to, uint256 tokenId) public override {
848         address owner = ERC721A.ownerOf(tokenId);
849         if (to == owner) revert ApprovalToCurrentOwner();
850 
851         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
852             revert ApprovalCallerNotOwnerNorApproved();
853         }
854 
855         _approve(to, tokenId, owner);
856     }
857 
858     function getApproved(uint256 tokenId) public view override returns (address) {
859         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
860 
861         return _tokenApprovals[tokenId];
862     }
863 
864     function setApprovalForAll(address operator, bool approved) public virtual override {
865         if (operator == _msgSender()) revert ApproveToCaller();
866 
867         _operatorApprovals[_msgSender()][operator] = approved;
868         emit ApprovalForAll(_msgSender(), operator, approved);
869     }
870 
871     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
872         return _operatorApprovals[owner][operator];
873     }
874 
875     function transferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) public virtual override {
880         _transfer(from, to, tokenId);
881     }
882 
883     function safeTransferFrom(
884         address from,
885         address to,
886         uint256 tokenId
887     ) public virtual override {
888         safeTransferFrom(from, to, tokenId, '');
889     }
890 
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId,
895         bytes memory _data
896     ) public virtual override {
897         _transfer(from, to, tokenId);
898         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
899             revert TransferToNonERC721ReceiverImplementer();
900         }
901     }
902 
903     function _exists(uint256 tokenId) internal view returns (bool) {
904         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
905     }
906 
907     function _safeMint(address to, uint256 quantity) internal {
908         _safeMint(to, quantity, '');
909     }
910 
911     function _safeMint(
912         address to,
913         uint256 quantity,
914         bytes memory _data
915     ) internal {
916         _mint(to, quantity, _data, true);
917     }
918 
919     function _mint(
920         address to,
921         uint256 quantity,
922         bytes memory _data,
923         bool safe
924     ) internal {
925         uint256 startTokenId = _currentIndex;
926         if (to == address(0)) revert MintToZeroAddress();
927         if (quantity == 0) revert MintZeroQuantity();
928 
929         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
930 
931         unchecked {
932             _addressData[to].balance += uint64(quantity);
933             _addressData[to].numberMinted += uint64(quantity);
934 
935             _ownerships[startTokenId].addr = to;
936             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
937 
938             uint256 updatedIndex = startTokenId;
939             uint256 end = updatedIndex + quantity;
940 
941             if (safe && to.isContract()) {
942                 do {
943                     emit Transfer(address(0), to, updatedIndex);
944                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
945                         revert TransferToNonERC721ReceiverImplementer();
946                     }
947                 } while (updatedIndex != end);
948                 // Reentrancy protection
949                 if (_currentIndex != startTokenId) revert();
950             } else {
951                 do {
952                     emit Transfer(address(0), to, updatedIndex++);
953                 } while (updatedIndex != end);
954             }
955             _currentIndex = updatedIndex;
956         }
957         _afterTokenTransfers(address(0), to, startTokenId, quantity);
958     }
959 
960     function _transfer(
961         address from,
962         address to,
963         uint256 tokenId
964     ) private {
965         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
966 
967         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
968 
969         bool isApprovedOrOwner = (_msgSender() == from ||
970             isApprovedForAll(from, _msgSender()) ||
971             getApproved(tokenId) == _msgSender());
972 
973         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
974         if (to == address(0)) revert TransferToZeroAddress();
975 
976         _beforeTokenTransfers(from, to, tokenId, 1);
977 
978         // Clear approvals from the previous owner
979         _approve(address(0), tokenId, from);
980 
981         unchecked {
982             _addressData[from].balance -= 1;
983             _addressData[to].balance += 1;
984 
985             TokenOwnership storage currSlot = _ownerships[tokenId];
986             currSlot.addr = to;
987             currSlot.startTimestamp = uint64(block.timestamp);
988 
989             uint256 nextTokenId = tokenId + 1;
990             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
991             if (nextSlot.addr == address(0)) {
992 
993                 if (nextTokenId != _currentIndex) {
994                     nextSlot.addr = from;
995                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
996                 }
997             }
998         }
999 
1000         emit Transfer(from, to, tokenId);
1001         _afterTokenTransfers(from, to, tokenId, 1);
1002     }
1003 
1004     function _burn(uint256 tokenId) internal virtual {
1005         _burn(tokenId, false);
1006     }
1007 
1008     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1009         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1010 
1011         address from = prevOwnership.addr;
1012 
1013         if (approvalCheck) {
1014             bool isApprovedOrOwner = (_msgSender() == from ||
1015                 isApprovedForAll(from, _msgSender()) ||
1016                 getApproved(tokenId) == _msgSender());
1017 
1018             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1019         }
1020 
1021         _beforeTokenTransfers(from, address(0), tokenId, 1);
1022 
1023         _approve(address(0), tokenId, from);
1024 
1025         unchecked {
1026             AddressData storage addressData = _addressData[from];
1027             addressData.balance -= 1;
1028             addressData.numberBurned += 1;
1029 
1030             TokenOwnership storage currSlot = _ownerships[tokenId];
1031             currSlot.addr = from;
1032             currSlot.startTimestamp = uint64(block.timestamp);
1033             currSlot.burned = true;
1034 
1035             uint256 nextTokenId = tokenId + 1;
1036             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1037             if (nextSlot.addr == address(0)) {
1038 
1039                 if (nextTokenId != _currentIndex) {
1040                     nextSlot.addr = from;
1041                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1042                 }
1043             }
1044         }
1045 
1046         emit Transfer(from, address(0), tokenId);
1047         _afterTokenTransfers(from, address(0), tokenId, 1);
1048 
1049         unchecked {
1050             _burnCounter++;
1051         }
1052     }
1053 
1054     function _approve(
1055         address to,
1056         uint256 tokenId,
1057         address owner
1058     ) private {
1059         _tokenApprovals[tokenId] = to;
1060         emit Approval(owner, to, tokenId);
1061     }
1062 
1063     function _checkContractOnERC721Received(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) private returns (bool) {
1069         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1070             return retval == IERC721Receiver(to).onERC721Received.selector;
1071         } catch (bytes memory reason) {
1072             if (reason.length == 0) {
1073                 revert TransferToNonERC721ReceiverImplementer();
1074             } else {
1075                 assembly {
1076                     revert(add(32, reason), mload(reason))
1077                 }
1078             }
1079         }
1080     }
1081 
1082     function _beforeTokenTransfers(
1083         address from,
1084         address to,
1085         uint256 startTokenId,
1086         uint256 quantity
1087     ) internal virtual {}
1088 
1089     function _afterTokenTransfers(
1090         address from,
1091         address to,
1092         uint256 startTokenId,
1093         uint256 quantity
1094     ) internal virtual {}
1095 }
1096 
1097 pragma solidity ^0.8.4;
1098 
1099 contract BroNicorns is ERC721A, Ownable {
1100     using Strings for uint256;
1101     string private baseURI;
1102     string public hiddenMetadataUri;
1103     uint256 public price = 0.00555 ether;
1104     uint256 public maxPerTx = 5;
1105     uint256 public maxFreePerWallet = 2;
1106     uint256 public totalFree = 5555;
1107     uint256 public maxSupply = 5555;
1108     uint public nextId = 0;
1109     bool public mintEnabled = false;
1110     bool public revealed = true;
1111     mapping(address => uint256) private _mintedFreeAmount;
1112 
1113 constructor() ERC721A("BroNicorns", "BRO") {
1114         setHiddenMetadataUri("https://api.bronicorns.fun/");
1115         setBaseURI("https://api.bronicorns.fun/");
1116     }
1117 
1118     function mint(uint256 count) external payable {
1119     require(mintEnabled, "BRO, Mint not live yet!");
1120       uint256 cost = price;
1121       bool isFree =
1122       ((totalSupply() + count < totalFree + 1) &&
1123       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1124 
1125       if (isFree) {
1126       cost = 0;
1127      }
1128 
1129      else {
1130       require(msg.value >= count * price, "Please send the exact amount.");
1131       require(totalSupply() + count <= maxSupply, "No more BRO");
1132       require(count <= maxPerTx, "Max per TX reached.");
1133      }
1134 
1135       if (isFree) {
1136          _mintedFreeAmount[msg.sender] += count;
1137       }
1138 
1139      _safeMint(msg.sender, count);
1140      nextId += count;
1141     }
1142 
1143     function _baseURI() internal view virtual override returns (string memory) {
1144         return baseURI;
1145     }
1146 
1147     function tokenURI(uint256 tokenId)
1148         public
1149         view
1150         virtual
1151         override
1152         returns (string memory)
1153     {
1154         require(
1155             _exists(tokenId),
1156             "ERC721Metadata: URI query for nonexistent token"
1157         );
1158 
1159         if (revealed == false) {
1160          return string(abi.encodePacked(hiddenMetadataUri));
1161         }
1162     
1163         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1164     }
1165 
1166     function setBaseURI(string memory uri) public onlyOwner {
1167         baseURI = uri;
1168     }
1169 
1170     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1171      hiddenMetadataUri = _hiddenMetadataUri;
1172     }
1173 
1174     function setFreeAmount(uint256 amount) external onlyOwner {
1175         totalFree = amount;
1176     }
1177 
1178     function setPrice(uint256 _newPrice) external onlyOwner {
1179         price = _newPrice;
1180     }
1181 
1182     function setRevealed() external onlyOwner {
1183      revealed = !revealed;
1184     }
1185 
1186     function flipSale() external onlyOwner {
1187         mintEnabled = !mintEnabled;
1188     }
1189 
1190     function getNextId() public view returns(uint){
1191      return nextId;
1192     }
1193 
1194     function _startTokenId() internal pure override returns (uint256) {
1195         return 1;
1196     }
1197 
1198     function withdraw() external onlyOwner {
1199         (bool success, ) = payable(msg.sender).call{
1200             value: address(this).balance
1201         }("");
1202         require(success, "Transfer failed.");
1203     }
1204     function setmaxSupply(uint _maxSupply) external onlyOwner {
1205         maxSupply = _maxSupply;
1206     }
1207 
1208     function setmaxFreePerWallet(uint256 _maxFreePerWallet) external onlyOwner {
1209         maxFreePerWallet = _maxFreePerWallet;
1210     }
1211 
1212     function setmaxPerTx(uint256 _maxPerTx) external onlyOwner {
1213         maxPerTx = _maxPerTx;
1214     }
1215 
1216     function MintVIP(address to, uint256 quantity)public onlyOwner{
1217     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1218     _safeMint(to, quantity);
1219   }
1220 }