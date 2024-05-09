1 // SPDX-License-Identifier: UNLICENSED;
2 
3 pragma solidity ^0.8.0;
4 
5 library Strings {
6     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
7 
8     function toString(uint256 value) internal pure returns (string memory) {
9 
10         if (value == 0) {
11             return "0";
12         }
13         uint256 temp = value;
14         uint256 digits;
15         while (temp != 0) {
16             digits++;
17             temp /= 10;
18         }
19         bytes memory buffer = new bytes(digits);
20         while (value != 0) {
21             digits -= 1;
22             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
23             value /= 10;
24         }
25         return string(buffer);
26     }
27 
28     function toHexString(uint256 value) internal pure returns (string memory) {
29         if (value == 0) {
30             return "0x00";
31         }
32         uint256 temp = value;
33         uint256 length = 0;
34         while (temp != 0) {
35             length++;
36             temp >>= 8;
37         }
38         return toHexString(value, length);
39     }
40 
41     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
42         bytes memory buffer = new bytes(2 * length + 2);
43         buffer[0] = "0";
44         buffer[1] = "x";
45         for (uint256 i = 2 * length + 1; i > 1; --i) {
46             buffer[i] = _HEX_SYMBOLS[value & 0xf];
47             value >>= 4;
48         }
49         require(value == 0, "Strings: hex length insufficient");
50         return string(buffer);
51     }
52 }
53 
54 
55 
56 abstract contract Context {
57     function _msgSender() internal view virtual returns (address) {
58         return msg.sender;
59     }
60 
61     function _msgData() internal view virtual returns (bytes calldata) {
62         return msg.data;
63     }
64 }
65 
66 
67 
68 abstract contract Ownable is Context {
69     address private _owner;
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor() {
74         _setOwner(_msgSender());
75     }
76 
77     function owner() public view virtual returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         _setOwner(address(0));
88     }
89 
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _setOwner(newOwner);
93     }
94 
95     function _setOwner(address newOwner) private {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 
103 
104 library Address {
105     function isContract(address account) internal view returns (bool) {
106         uint256 size;
107         assembly {
108             size := extcodesize(account)
109         }
110         return size > 0;
111     }
112 
113     function sendValue(address payable recipient, uint256 amount) internal {
114         require(address(this).balance >= amount, "Address: insufficient balance");
115 
116         (bool success, ) = recipient.call{value: amount}("");
117         require(success, "Address: unable to send value, recipient may have reverted");
118     }
119 
120     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
121         return functionCall(target, data, "Address: low-level call failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
126      * `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCall(
131         address target,
132         bytes memory data,
133         string memory errorMessage
134     ) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, 0, errorMessage);
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
140      * but also transferring `value` wei to `target`.
141      *
142      * Requirements:
143      *
144      * - the calling contract must have an ETH balance of at least `value`.
145      * - the called Solidity function must be `payable`.
146      *
147      * _Available since v3.1._
148      */
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value
153     ) internal returns (bytes memory) {
154         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
159      * with `errorMessage` as a fallback revert reason when `target` reverts.
160      *
161      * _Available since v3.1._
162      */
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
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but performing a static call.
179      *
180      * _Available since v3.3._
181      */
182     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
183         return functionStaticCall(target, data, "Address: low-level static call failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
188      * but performing a static call.
189      *
190      * _Available since v3.3._
191      */
192     function functionStaticCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal view returns (bytes memory) {
197         require(isContract(target), "Address: static call to non-contract");
198 
199         (bool success, bytes memory returndata) = target.staticcall(data);
200         return verifyCallResult(success, returndata, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but performing a delegate call.
206      *
207      * _Available since v3.4._
208      */
209     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
210         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
215      * but performing a delegate call.
216      *
217      * _Available since v3.4._
218      */
219     function functionDelegateCall(
220         address target,
221         bytes memory data,
222         string memory errorMessage
223     ) internal returns (bytes memory) {
224         require(isContract(target), "Address: delegate call to non-contract");
225 
226         (bool success, bytes memory returndata) = target.delegatecall(data);
227         return verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     /**
231      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
232      * revert reason using the provided one.
233      *
234      * _Available since v4.3._
235      */
236     function verifyCallResult(
237         bool success,
238         bytes memory returndata,
239         string memory errorMessage
240     ) internal pure returns (bytes memory) {
241         if (success) {
242             return returndata;
243         } else {
244             // Look for revert reason and bubble it up if present
245             if (returndata.length > 0) {
246                 // The easiest way to bubble the revert reason is using memory via assembly
247 
248                 assembly {
249                     let returndata_size := mload(returndata)
250                     revert(add(32, returndata), returndata_size)
251                 }
252             } else {
253                 revert(errorMessage);
254             }
255         }
256     }
257 }
258 
259 
260 
261 interface IERC721Receiver {
262     function onERC721Received(
263         address operator,
264         address from,
265         uint256 tokenId,
266         bytes calldata data
267     ) external returns (bytes4);
268 }
269 
270 
271 
272 interface IERC165 {
273     function supportsInterface(bytes4 interfaceId) external view returns (bool);
274 }
275 
276 
277 
278 abstract contract ERC165 is IERC165 {
279     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
280         return interfaceId == type(IERC165).interfaceId;
281     }
282 }
283 
284 
285 
286 interface IERC721 is IERC165 {
287     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
288     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
289     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
290 
291     function balanceOf(address owner) external view returns (uint256 balance);
292 
293     function ownerOf(uint256 tokenId) external view returns (address owner);
294 
295     function safeTransferFrom(
296         address from,
297         address to,
298         uint256 tokenId
299     ) external;
300 
301     function transferFrom(
302         address from,
303         address to,
304         uint256 tokenId
305     ) external;
306 
307     function approve(address to, uint256 tokenId) external;
308 
309     function getApproved(uint256 tokenId) external view returns (address operator);
310 
311     function setApprovalForAll(address operator, bool _approved) external;
312 
313     function isApprovedForAll(address owner, address operator) external view returns (bool);
314 
315     function safeTransferFrom(
316         address from,
317         address to,
318         uint256 tokenId,
319         bytes calldata data
320     ) external;
321 }
322 
323 
324 
325 interface IERC721Enumerable is IERC721 {
326     function totalSupply() external view returns (uint256);
327 
328     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
329 
330     function tokenByIndex(uint256 index) external view returns (uint256);
331 }
332 
333 
334 
335 interface IERC721Metadata is IERC721 {
336     function name() external view returns (string memory);
337 
338     function symbol() external view returns (string memory);
339 
340     function tokenURI(uint256 tokenId) external view returns (string memory);
341 }
342 
343 
344 
345 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
346     using Address for address;
347     using Strings for uint256;
348 
349     // Token name
350     string private _name;
351 
352     // Token symbol
353     string private _symbol;
354 
355     // Mapping from token ID to owner address
356     mapping(uint256 => address) private _owners;
357 
358     // Mapping owner address to token count
359     mapping(address => uint256) private _balances;
360 
361     // Mapping from token ID to approved address
362     mapping(uint256 => address) private _tokenApprovals;
363 
364     // Mapping from owner to operator approvals
365     mapping(address => mapping(address => bool)) private _operatorApprovals;
366 
367     constructor(string memory name_, string memory symbol_) {
368         _name = name_;
369         _symbol = symbol_;
370     }
371 
372     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
373         return
374             interfaceId == type(IERC721).interfaceId ||
375             interfaceId == type(IERC721Metadata).interfaceId ||
376             super.supportsInterface(interfaceId);
377     }
378 
379     function balanceOf(address owner) public view virtual override returns (uint256) {
380         require(owner != address(0), "ERC721: balance query for the zero address");
381         return _balances[owner];
382     }
383 
384     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
385         address owner = _owners[tokenId];
386         require(owner != address(0), "ERC721: owner query for nonexistent token");
387         return owner;
388     }
389 
390     function name() public view virtual override returns (string memory) {
391         return _name;
392     }
393 
394     function symbol() public view virtual override returns (string memory) {
395         return _symbol;
396     }
397 
398     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
399         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
400 
401         string memory baseURI = _baseURI();
402         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
403     }
404 
405     function _baseURI() internal view virtual returns (string memory) {
406         return "";
407     }
408 
409     function approve(address to, uint256 tokenId) public virtual override {
410         address owner = ERC721.ownerOf(tokenId);
411         require(to != owner, "ERC721: approval to current owner");
412 
413         require(
414             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
415             "ERC721: approve caller is not owner nor approved for all"
416         );
417 
418         _approve(to, tokenId);
419     }
420 
421     function getApproved(uint256 tokenId) public view virtual override returns (address) {
422         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
423 
424         return _tokenApprovals[tokenId];
425     }
426 
427     function setApprovalForAll(address operator, bool approved) public virtual override {
428         require(operator != _msgSender(), "ERC721: approve to caller");
429 
430         _operatorApprovals[_msgSender()][operator] = approved;
431         emit ApprovalForAll(_msgSender(), operator, approved);
432     }
433 
434     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
435         return _operatorApprovals[owner][operator];
436     }
437 
438     function transferFrom(
439         address from,
440         address to,
441         uint256 tokenId
442     ) public virtual override {
443         //solhint-disable-next-line max-line-length
444         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
445 
446         _transfer(from, to, tokenId);
447     }
448 
449     function safeTransferFrom(
450         address from,
451         address to,
452         uint256 tokenId
453     ) public virtual override {
454         safeTransferFrom(from, to, tokenId, "");
455     }
456 
457     function safeTransferFrom(
458         address from,
459         address to,
460         uint256 tokenId,
461         bytes memory _data
462     ) public virtual override {
463         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
464         _safeTransfer(from, to, tokenId, _data);
465     }
466 
467     function _safeTransfer(
468         address from,
469         address to,
470         uint256 tokenId,
471         bytes memory _data
472     ) internal virtual {
473         _transfer(from, to, tokenId);
474         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
475     }
476 
477     function _exists(uint256 tokenId) internal view virtual returns (bool) {
478         return _owners[tokenId] != address(0);
479     }
480 
481     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
482         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
483         address owner = ERC721.ownerOf(tokenId);
484         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
485     }
486 
487     function _safeMint(address to, uint256 tokenId) internal virtual {
488         _safeMint(to, tokenId, "");
489     }
490 
491     function _safeMint(
492         address to,
493         uint256 tokenId,
494         bytes memory _data
495     ) internal virtual {
496         _mint(to, tokenId + 1);
497         require(
498             _checkOnERC721Received(address(0), to, tokenId, _data),
499             "ERC721: transfer to non ERC721Receiver implementer"
500         );
501     }
502 
503     function _mint(address to, uint256 tokenId) internal virtual {
504         require(to != address(0), "ERC721: mint to the zero address");
505         require(!_exists(tokenId), "ERC721: token already minted");
506 
507         _beforeTokenTransfer(address(0), to, tokenId);
508 
509         _balances[to] += 1;
510         _owners[tokenId] = to;
511 
512         emit Transfer(address(0), to, tokenId);
513     }
514 
515     function _burn(uint256 tokenId) internal virtual {
516         address owner = ERC721.ownerOf(tokenId);
517 
518         _beforeTokenTransfer(owner, address(0), tokenId);
519 
520         // Clear approvals
521         _approve(address(0), tokenId);
522 
523         _balances[owner] -= 1;
524         delete _owners[tokenId];
525 
526         emit Transfer(owner, address(0), tokenId);
527     }
528 
529     function _transfer(
530         address from,
531         address to,
532         uint256 tokenId
533     ) internal virtual {
534         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
535         require(to != address(0), "ERC721: transfer to the zero address");
536 
537         _beforeTokenTransfer(from, to, tokenId);
538 
539         // Clear approvals from the previous owner
540         _approve(address(0), tokenId);
541 
542         _balances[from] -= 1;
543         _balances[to] += 1;
544         _owners[tokenId] = to;
545 
546         emit Transfer(from, to, tokenId);
547     }
548 
549     function _approve(address to, uint256 tokenId) internal virtual {
550         _tokenApprovals[tokenId] = to;
551         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
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
582 }
583 
584 
585 
586 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
587     // Mapping from owner to list of owned token IDs
588     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
589 
590     // Mapping from token ID to index of the owner tokens list
591     mapping(uint256 => uint256) private _ownedTokensIndex;
592 
593     // Array with all token ids, used for enumeration
594     uint256[] private _allTokens;
595 
596     // Mapping from token id to position in the allTokens array
597     mapping(uint256 => uint256) private _allTokensIndex;
598 
599     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
600         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
601     }
602 
603     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
604         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
605         return _ownedTokens[owner][index];
606     }
607 
608     function totalSupply() public view virtual override returns (uint256) {
609         return _allTokens.length;
610     }
611 
612 
613     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
614         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
615         return _allTokens[index];
616     }
617 
618     function _beforeTokenTransfer(
619         address from,
620         address to,
621         uint256 tokenId
622     ) internal virtual override {
623         super._beforeTokenTransfer(from, to, tokenId);
624 
625         if (from == address(0)) {
626             _addTokenToAllTokensEnumeration(tokenId);
627         } else if (from != to) {
628             _removeTokenFromOwnerEnumeration(from, tokenId);
629         }
630         if (to == address(0)) {
631             _removeTokenFromAllTokensEnumeration(tokenId);
632         } else if (to != from) {
633             _addTokenToOwnerEnumeration(to, tokenId);
634         }
635     }
636 
637     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
638         uint256 length = ERC721.balanceOf(to);
639         _ownedTokens[to][length] = tokenId;
640         _ownedTokensIndex[tokenId] = length;
641     }
642 
643     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
644         _allTokensIndex[tokenId] = _allTokens.length;
645         _allTokens.push(tokenId);
646     }
647 
648     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
649         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
650         // then delete the last slot (swap and pop).
651 
652         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
653         uint256 tokenIndex = _ownedTokensIndex[tokenId];
654 
655         // When the token to delete is the last token, the swap operation is unnecessary
656         if (tokenIndex != lastTokenIndex) {
657             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
658 
659             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
660             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
661         }
662 
663         // This also deletes the contents at the last position of the array
664         delete _ownedTokensIndex[tokenId];
665         delete _ownedTokens[from][lastTokenIndex];
666     }
667 
668     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
669         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
670         // then delete the last slot (swap and pop).
671 
672         uint256 lastTokenIndex = _allTokens.length - 1;
673         uint256 tokenIndex = _allTokensIndex[tokenId];
674 
675         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
676         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
677         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
678         uint256 lastTokenId = _allTokens[lastTokenIndex];
679 
680         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
681         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
682 
683         // This also deletes the contents at the last position of the array
684         delete _allTokensIndex[tokenId];
685         _allTokens.pop();
686     }
687 }
688 
689 
690 
691 
692 
693 contract Puxxies is ERC721Enumerable, Ownable {
694 
695     using Strings for uint256;
696 
697     string _baseTokenURI;
698     uint256 public limit = 999;
699     uint256 public _reserved = 99;
700     uint256 private _price = 0.01 ether;
701     bool public _paused = true;
702     uint256 public maxPerTx = 5;
703 
704     uint per1 = 35; uint per2 = 35; uint per3 = 20; uint per4 = 5; uint per5 = 3; uint per6 = 2;
705     address public wallet1 = 0xe548BC7E002c8dFcD3f9Dc85834ad6378da973d4;
706     address public wallet2 = 0x511206e0e69E37CBd338f17B436B5900e7967032;
707     address public wallet3 = 0x8CCd7fE0e34ECcb3fE0c55e5Ae6ed9ffCB48575e;
708     address public wallet4 = 0xb761B096602aABE7E6Dc51425A386b2619165624;
709     address public wallet5 = 0xdEFBd0EBc0E5caA1ab313ABd7cd9111705878a2E;
710     address public wallet6 = 0x9a7Cc48d3BFa0CF7eE7913dCEaAeCffad59601cB;
711 
712     uint maxWithdrawWallets = 6;
713 
714     address public fundWallet;
715     
716     mapping(address => bool) public WL; 
717     
718     constructor(string memory baseURI) ERC721("Puxxies", "Puxxies") {
719         setBaseURI(baseURI);
720      
721     }
722 
723     function Mint(uint256 num) public payable {
724         uint256 supply = totalSupply();
725         require( !_paused,                              "Sale paused" );
726         require( num <= maxPerTx,                       "You exceeds mint limit per transaction." );
727         require( supply + num <= limit - _reserved,     "Exceeds maximum punks supply" );
728         require( msg.value >= _price * num,             "Ether sent is not correct" );
729 
730         for(uint256 i; i < num; i++){
731             _safeMint( msg.sender, supply + i );
732         }
733     }
734 
735     function giveAway(address[] memory _to, uint256[] memory _amount) external onlyOwner() {
736         require( _to.length == _amount.length, "Entered data is invalid");
737         for(uint i;  i<_amount.length; i++){
738             minto(_to[i], _amount[i]);
739         }
740     }
741     
742     function minto (address _to, uint256 _amount) private {
743         uint256 supply = totalSupply();
744         require( _to != address(0),    "Invalid address found");
745         require( _amount <= _reserved, "Exceeds reserved punk supply" );
746 
747         for(uint i; i<_amount; i++){
748             _safeMint( _to, supply + i );
749         }
750         _reserved -= _amount;
751     }
752     
753     function WHITELIST_MINT(uint256 num) public payable {
754         uint256 supply = totalSupply();
755         require( !_paused,                                       "Sale paused" );
756         require( WL[msg.sender] == true,                         "Only WHITELIST can mint" );
757         require( supply + num <= limit - _reserved,              "Exceeds maximum PUNK supply" );
758         require( msg.value >= _price * num,                      "Ether sent is not correct" );
759         
760         for(uint256 i; i < num; i++){
761             _safeMint( msg.sender, supply + i );
762         }
763     }
764     
765     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
766         uint256 tokenCount = balanceOf(_owner);
767         uint256[] memory tokensId = new uint256[](tokenCount);
768 
769         for(uint256 i; i < tokenCount; i++){
770             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
771         }
772         return tokensId;
773     }
774     
775     // Just in case Eth does some crazy stuff
776     function setPrice(uint256 _newPrice) public onlyOwner() {
777         _price = _newPrice;
778     }
779  
780     function setWL(address[] memory _address) public onlyOwner() {
781         for(uint256 i; i<_address.length; i++){
782             require(_address[i] != address(0), "Invalid address found");
783             address tempAdd = _address[i];
784             WL[tempAdd] = true;
785         }
786     }
787 
788     function setFundWallet(address _fundWallet) public onlyOwner() {
789         fundWallet = _fundWallet;
790     }
791 
792     function setLimit(uint256 __limit) public onlyOwner() {
793         limit = __limit;
794     }
795 
796     function setMaxPerTx(uint256 __maxPerTx) public onlyOwner() {
797         maxPerTx = __maxPerTx;
798     }
799 
800     function _baseURI() internal view virtual override returns (string memory) {
801         return _baseTokenURI;
802     }
803 
804     function setBaseURI(string memory baseURI) public onlyOwner {
805         _baseTokenURI = baseURI;
806     }
807 
808     function getPrice() public view returns (uint256){
809         return _price;
810     }
811 
812     function pause() public onlyOwner {
813         _paused = !_paused;
814     }
815 
816     function withdraw() public payable onlyOwner {
817         uint256 _puxxy1 = (address(this).balance * 350) / 1000;  // 35%  
818         uint256 _puxxy2 = (address(this).balance * 350) / 1000;  // 35%
819         uint256 _puxxy3 = (address(this).balance * 200) / 1000;  // 20%
820         uint256 _puxxy4 = (address(this).balance * 50 ) / 1000;  // 5%
821         uint256 _puxxy5 = (address(this).balance * 30 ) / 1000;  // 3%
822         uint256 _puxxy6 = (address(this).balance * 20 ) / 1000;  // 2%
823 
824         payable(wallet1).transfer(_puxxy1);
825         payable(wallet2).transfer(_puxxy2);
826         payable(wallet3).transfer(_puxxy3);
827         payable(wallet4).transfer(_puxxy4);
828         payable(wallet5).transfer(_puxxy5);
829         payable(wallet6).transfer(_puxxy6);
830 
831     }
832 }